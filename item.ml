open Graphics
open Yojson.Basic.Util
open GameDataStructure

(** The abstract type of values representing the items group *)
open Position

(* 288 224 *)

type effect = { effect_dis : string }

(** The type of item identifiers -unique. *)
type item_id = string

(* string representation of item type *)
type item_type = string

type item_prop = {
  name : string;
  description : string;
  color : Graphics.color;
  size : int;
  effect : effect;
}

let inventory_area = Rect.make_rect 88 288 512 0

type t = {
  id : item_id;
  pos : Position.t;
  itype : item_type;
  rep : item_prop;
}

type ilist = {
  items : t list;
  aquired : GameDataStructure.GameIntDict.t;
  inventory : Rect.t;
}

let to_color json : Graphics.color =
  Graphics.rgb
    (json |> member "r" |> to_int)
    (json |> member "g" |> to_int)
    (json |> member "b" |> to_int)

let to_effect json : effect =
  { effect_dis = json |> member "effect_dis" |> to_string }

let to_item_prop json : item_prop =
  {
    name = json |> member "name" |> to_string;
    description = json |> member "description" |> to_string;
    color = json |> member "color" |> to_color;
    size = json |> member "size" |> to_int;
    effect = json |> member "effect" |> to_effect;
  }

let get_item_prop item_prop_json itype =
  item_prop_json |> member itype |> to_item_prop

let to_item item_rep_json json =
  let itype = json |> member "type" |> to_string in
  {
    id = json |> member "id" |> to_string;
    pos = json |> member "position" |> Position.from_json;
    itype;
    rep = get_item_prop item_rep_json itype;
  }

let insert_bag acc json =
  let name = json |> member "name" |> to_string in
  let max = json |> member "max" |> to_int in
  let init = json |> member "init" |> to_int in
  GameIntDict.insert name (init, max) acc

let init_bag json =
  json |> member "init item" |> to_list
  |> List.fold_left insert_bag GameIntDict.empty

(* from json for now, contain id, position, item_type *)

let init_item_list item_file item_rep_file bag_file =
  {
    items =
      item_file |> member "items" |> to_list
      |> List.map (to_item item_rep_file);
    aquired = init_bag bag_file;
    inventory = Rect.make_rect 88 288 512 0;
  }

let draw (item : t) : unit =
  Graphics.set_color item.rep.color;
  Graphics.fill_circle item.pos.x item.pos.y item.rep.size

let draw_inventory item =
  Graphics.set_color black;
  Rect.draw inventory_area

let draw_all (item_lst : ilist) =
  List.iter draw item_lst.items;
  draw_inventory item_lst

let acquired item = failwith "unimplemented"

(* item name *)
let name item = failwith "unimplemented"

let get_item ilist (c : Character.t) : ilist =
  let rec find_item lst acc rem_acc (cpos : Position.t) (csize : int) inven =
    match lst with
    | [] -> { items = acc; aquired = rem_acc; inventory = inven }
    | h :: t ->
        let dist = Position.distance h.pos cpos in
        if dist < h.rep.size + csize then
          find_item t acc
            (GameIntDict.insert_add h.rep.name 1 rem_acc)
            cpos csize inven
        else find_item t (h :: acc) rem_acc cpos csize inven
  in
  find_item ilist.items [] ilist.aquired c.pos (Character.get_size c)
    ilist.inventory

let draw_bag bag =
  Graphics.set_color white;
  let rec draw_lst (pos : Position.t) line_height lst =
    match lst with
    | [] -> ()
    | h :: t ->
        Graphics.moveto pos.x pos.y;
        Graphics.draw_string h;
        pos.y <- pos.y - line_height;
        draw_lst pos line_height t
  in
  draw_lst { x = 810; y = 200 } 20
    (* ("bag" :: GameIntDict.format_string_lst bag.aquired) *)
    [ "bag"; " in the work" ]

let description item = failwith "unimplemented"

(* effect *)
let item_effect item = failwith "unimplemented"

let item_position item = failwith "unimplemented"
