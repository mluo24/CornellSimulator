(* handle the representation of food water slip day etc *)
(* open Position *)
open Graphics
open Yojson.Basic.Util
(** The abstract type of values representing the items group *)
type t

type ilist

type effect

(* from json for now, contain id, position, item_type *)
val init_item_list : Yojson.Basic.t -> Yojson.Basic.t-> ilist 

val draw : t -> unit
val draw_all : ilist -> unit
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

