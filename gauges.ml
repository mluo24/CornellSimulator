open Yojson.Basic.Util
open GameDataStructure
open Graphics
open World
module GameDict = GameDataStructure.GameIntDict
open Position
open Item

exception Invalid_Gauge_Name

exception Negative_Gauge of int

type t = {
  mutable general : GameDict.t;
  mutable mission : GameIntDict.t;
  mutable level : int;
}

type gauge_type =
  | General
  | Mission

(* let get_score l_type gauges = failwith "Unimplemented" *)

let text_height_space = 16

let bg_color = Graphics.black

let text_color = Graphics.rgb 8 200 200

let barbg_color = Graphics.rgb 80 80 80

let label_size = 12

let mission_title = "Class:"

let gauge_title = "Gauges:"

let bar_height = 16

let bar_width = 200

let padding = 6

let heading_size = 18

let bar_height = 16

let init_pos = { x = 0; y = 0 }

let consume_item item = failwith "Unimplemented"

let draw_bar (game_value : GaugesValue.t) (pos : Position.t) length height =
  let ratio = Float.of_int game_value.value /. Float.of_int game_value.max in
  let width = ratio *. Float.of_int length in
  Graphics.set_color barbg_color;
  Graphics.fill_rect pos.x pos.y length height;
  Graphics.set_color game_value.color;
  Graphics.fill_rect pos.x pos.y (Float.to_int width) height

let draw_background width height pos =
  Graphics.set_color bg_color;
  let brect = Rect.make_rect_wh pos width height in
  Rect.draw brect

let draw_text_and_bar (pos : Position.t) bw bh binding =
  let k, v = binding in
  draw_bar v pos bw bh;
  pos.y <- pos.y + bh;
  Graphics.moveto pos.x pos.y;
  Graphics.set_color text_color;
  let des = k ^ " : " ^ string_of_int v.value ^ "/" ^ string_of_int v.max in
  Graphics.set_text_size label_size;
  Graphics.draw_string des;
  pos.y <- pos.y + text_height_space

let draw_gauge_display (pos : Position.t) bw bh pd gauge t_gauge =
  (* move offset *)
  pos.x <- pos.x + pd;
  pos.y <- pos.y + pd;
  let gauge_lst = GameDict.get_bindings gauge in

  List.iter (draw_text_and_bar pos bw bh) gauge_lst;
  Graphics.moveto pos.x (pos.y + padding);
  Graphics.set_text_size heading_size;
  Graphics.draw_string t_gauge

let draw gauges =
  let gauge_size = GameDict.get_size gauges.general in
  let gauge_height =
    ((bar_height + text_height_space) * gauge_size) + (2 * padding)
  in
  let mission_size = GameDict.get_size gauges.mission in
  let mission_height =
    ((bar_height + text_height_space) * mission_size) + (2 * padding)
  in
  let title_height = padding + label_size in
  let total_height =
    mission_height + gauge_height + (2 * title_height) + padding
  in
  let mission_pos = init_pos in
  let gauge_pos =
    {
      x = init_pos.x;
      y = init_pos.y + mission_height + title_height + padding;
    }
  in
  let width = bar_width + (2 * padding) in

  draw_background width total_height mission_pos;
  draw_gauge_display mission_pos bar_width bar_height padding gauges.mission
    mission_title;
  draw_gauge_display gauge_pos bar_width bar_height padding gauges.general
    gauge_title

let add_to_init acc json =
  let name = json |> member "name" |> to_string in
  let max = json |> member "max" |> to_int in
  let init = json |> member "init" |> to_int in
  let color = json |> member "color" |> GraphicHelper.to_color in
  GameIntDict.insert name { value = init; max; color } acc

let init_gauges json level =
  {
    general =
      json |> member "gauges" |> to_list
      |> List.fold_left add_to_init GameIntDict.empty;
    mission =
      json |> member "missions" |> to_list
      |> List.fold_left add_to_init GameIntDict.empty;
    level;
  }

let end_game t = ()

let update_a_gauge state gdict nvpair =
  let name, nvalue = nvpair in
  let update state n (ol : GameIntDict.game_value option) :
      GameIntDict.game_value option =
    match ol with
    | None -> raise Invalid_Gauge_Name
    | Some { value; max; color } ->
        let v = nvalue + value in
        if v < 0 then raise (Negative_Gauge 10)
        else Some { value = v; max; color }
  in
  let n_dict = GameIntDict.update name (update state nvalue) gdict in
  n_dict

let update_gauge gtype lst (gauges : t) item_t =
  let dict =
    match gtype with General -> gauges.general | Mission -> gauges.mission
  in
  init_pos.x <- 0;
  init_pos.y <- 0;
  let new_dict = List.fold_left (update_a_gauge item_t) dict lst in
  match gtype with
  | General ->
      gauges.general <- new_dict;
      draw gauges
  | Mission ->
      gauges.mission <- new_dict;
      draw gauges

let use_item item_t gauge =
  let type_str = Item.use_item item_t in
  match type_str with
  | None -> ()
  | Some v -> (
      let info = Item.get_effect item_t v in
      match info with
      | None -> raise Item.TypeNotFound
      | Some i ->
          update_gauge General i.gauges gauge item_t;
          update_gauge Mission i.mission gauge item_t)
