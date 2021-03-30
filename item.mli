(* handle the representation of food water slip day etc *)
open Item
open Graphics
(** The abstract type of values representing the items group *)
type t

type effect

(* from json for now, contain id, position, item_type *)
val init_item : Yojson.Basic.t -> t

(* representation of item for graphic library to draw *)
val image_rep: t -> color array array

(** The type of item identifiers -unique. *)
type item_id = string

(* string representation of item type *)
type item_type = string




(* Whether the item has been collected *)
val acquired : t -> bool

(* item name  *)
val name: t -> string

val description: t -> string

(* effect *)
val item_effect: t -> effect

val item_position: t -> Position.t

