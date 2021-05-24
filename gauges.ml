open Yojson.Basic.Util
open GameDataStructure
open Graphics
open World
module GameDict = GameDataStructure.GameIntDict

type t = GameDict.t

type effect

let get_level l_type gauges = failwith "Unimplemented"

let text_height_space = 16

let bg_color = Graphics.black

let text_color = Graphics.rgb 8 200 200

let barbg_color = Graphics.rgb 80 80 80

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
  Graphics.draw_string des;
  pos.y <- pos.y + text_height_space

let draw_gauge_display (pos : Position.t) bw bh pd gauge =
  let g_size = GameDict.get_size gauge in
  let height = ((bh + text_height_space) * g_size) + (2 * pd) in
  let width = bw + (2 * pd) in
  draw_background width height pos;
  (* move offset *)
  pos.x <- pos.x + pd;
  pos.y <- pos.y + pd;
  let gauge_lst = GameDict.get_bindings gauge in
  List.iter (draw_text_and_bar pos bw bh) gauge_lst

let draw gauges = draw_gauge_display { x = 0; y = 0 } 200 16 6 gauges

let add_to_init acc json =
  let name = json |> member "name" |> to_string in
  let max = json |> member "max" |> to_int in
  let init = json |> member "init" |> to_int in
  let color = json |> member "color" |> GraphicHelper.to_color in
  GameIntDict.insert name { value = init; max; color } acc

let init_gauges json =
  json |> member "gauges" |> to_list
  |> List.fold_left add_to_init GameIntDict.empty

let decrease_gauges name by_val map = failwith "unimplemented"

(* GameIntDict.change_gauges name GameIntDict.GameValue.subtract by_val map *)

let increase_gauges name by_val map = failwith "unimplemented"
