(* handle the representation of food water slip day etc *)

open Graphics
open Yojson.Basic.Util

(** The abstract type of values representing the items group *)
open Position

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

type t = {
  id : item_id;
  pos : Position.t;
  itype : item_type;
  rep : item_prop;
}

type ilist = { items : t list }

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

(* from json for now, contain id, position, item_type *)
let init_item_list item_file item_rep_file =
  {
    items =
      item_file |> member "items" |> to_list
      |> List.map (to_item item_rep_file);
  }

let draw (item : t) : unit =
  Graphics.set_color item.rep.color;
  Graphics.fill_circle item.pos.x item.pos.y item.rep.size

let draw_all (item_lst : ilist) = List.iter draw item_lst.items

let acquired item = failwith "unimplemented"

(* item name *)
let name item = failwith "unimplemented"

let description item = failwith "unimplemented"

(* effect *)
let item_effect item = failwith "unimplemented"

let item_position item = failwith "unimplemented"
