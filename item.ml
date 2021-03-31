(* handle the representation of food water slip day etc *)

open Graphics
open Yojson.Basic.Util
(** The abstract type of values representing the items group *)
type t

type effect

(* from json for now, contain id, position, item_type *)
let init_item json_file = failwith "unimplemented"

(* representation of item for graphic library to draw *)
let image_rep item = failwith "unimplemented"

(** The type of item identifiers -unique. *)
type item_id = string

(* string representation of item type *)
type item_type = string

let acquired item = failwith "unimplemented"

(* item name  *)
let name item = failwith "unimplemented"

let description item = failwith "unimplemented"

(* effect *)
let item_effect item = failwith "unimplemented"

let item_position item = failwith "unimplemented"

