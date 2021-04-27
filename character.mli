open Graphics

(** The abstract type of values representing character. *)
type t

(** [get_position t] is the position on graphical interface of character [t]*)
val get_position : t -> Position.t

(** [move t ch] moves character [t] to the new position in the direction
    specified by character [ch] based on the character current speed Require:
    ch must be 'w', 'a', 's', 'd' which represent up, left, down, right
    respectively*)
val move : t -> char -> unit

(** for drawing player *)
(* val get_user_rep : t -> color array array *)

val get_user_name : t -> string

(** [get_size t ] is the size of character [t] in graphical interface unit*)
val get_size : t -> int

(* val get_level: t -> how getting an item effect user *)
(* val aquire_item : Item.t -> t *)

val draw : t -> unit

(** [init_character] initialize fake character TODO: re implement to
    initialize the character from file*)
val init_character : unit -> t
