(* player character *)
open Graphics

type t

(** current position*)
val get_position : t -> Position.t

val move : t -> char -> unit

(** for drawing player *)
(* val get_user_rep : t -> color array array *)

val get_user_name : t -> string

val get_size : t -> int

(* val get_level: t -> how getting an item effect user *)
(* val aquire_item : Item.t -> t *)

val draw : t -> unit

val init_character : unit -> t
