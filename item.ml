open Graphics
open Yojson.Basic.Util
open GameDataStructure
open GraphicHelper

(** The abstract type of values representing the items group *)
open Position

(* 288 224 *)

(** The type of item identifiers -unique. *)

(* string representation of item type *)

exception SizeExceed of string

exception TypeNotFound

type t = {
  mutable inventory : GameDataStructure.InventoryDict.t;
  item_type : GameDataStructure.ItemTypeDict.t;
}

let inventory_size = 10

type is_legal =
  | Legal
  | Illegal

let to_item_prop json : GameDataStructure.ItemTypeDict.game_value =
  {
    name = json |> member "name" |> to_string;
    description = json |> member "description" |> to_string;
    image =
      json |> member "image" |> to_string |> ImageHandler.get_graphic_image;
    effect = json |> member "effect" |> Effect.from_json;
    dmax = json |> member "dmax" |> to_int;
  }

let to_inventory json : GameDataStructure.InventoryDict.game_value =
  {
    value = json |> member "init" |> to_int;
    max = json |> member "max" |> to_int;
    item_type = json |> member "name" |> to_string;
  }

let inventory_height = 100

type item = InventoryDict.game_value

let init_item type_file inventory_file =
  let add_to_type dict json =
    GameDataStructure.ItemTypeDict.insert
      (json |> member "name" |> to_string)
      (to_item_prop json) dict
  in
  let add_to_inventory dict json =
    GameDataStructure.InventoryDict.insert
      (json |> member "name" |> to_string)
      (to_inventory json) dict
  in
  let type_dict =
    type_file |> member "type" |> to_list
    |> List.fold_left add_to_type GameDataStructure.ItemTypeDict.empty
  in
  let inv_dict =
    inventory_file |> member "init item" |> to_list
    |> List.fold_left add_to_inventory GameDataStructure.InventoryDict.empty
  in
  let size = InventoryDict.get_size inv_dict in
  if size > inventory_size then
    raise (SizeExceed "too many starting item in json file")
  else { item_type = type_dict; inventory = inv_dict }

(* let init_bag json = json |> member "init item" |> to_list |> List.fold_left
   insert_bag GameIntDict.empty *)

(* from json for now, contain id, position, item_type *)

(* let init_item_list item_file item_rep_file bag_file = { items = item_file
   |> member "items" |> to_list |> List.map (to_item item_rep_file); aquired =
   init_bag bag_file; inventory = Rect.make_rect 88 288 512 0; } *)

let draw (item : t) : unit = failwith "unimplemented"

let draw_inventory item = failwith "unimplement"

let draw_all (item_state : t) = failwith "unimplement"

let get_type_info state name : ItemTypeDict.game_value =
  match ItemTypeDict.get_value_of name state.item_type with
  | Some { name; description; image; effect; dmax } ->
      { name; description; image; effect; dmax }
  | None -> raise TypeNotFound

let get_item_image state name =
  let info = get_type_info state name in
  info.image

let acquire item_state str_type =
  let update state name (olv : InventoryDict.game_value option) :
      InventoryDict.game_value option =
    match olv with
    | Some { value; max; item_type } ->
        let nv = value + 1 in
        if nv <= max then Some { value = nv; max; item_type }
        else Some { value; max; item_type }
    | None ->
        let size = InventoryDict.get_size state.inventory in
        if size < inventory_size then
          let info = get_type_info state name in
          Some { value = 1; max = info.dmax; item_type = info.name }
        else None
  in
  try
    let update_dict =
      InventoryDict.update str_type
        (update item_state str_type)
        item_state.inventory
    in
    item_state.inventory <- update_dict;
    Legal
  with TypeNotFound -> Illegal

(* item name *)

let name item = failwith "unimplemented"

let description item = failwith "unimplemented"

(* effect *)

let item_effect item = failwith "unimplemented"

let item_position item = failwith "unimplemented"
