(* player character *)
open Graphics

type t

(* current position*)
val get_position: t -> Position.t

val set_position: Position.t -> t

(* for drawing player *)
val get_user_rep: t -> color array array


val get_level: t -> 

(* how getting an item effect user *)
val aquire_item: Item.t -> t

