(* interaction between key input, user, item, map *)

type t_pos = {
  mutable x : int;
  mutable y : int;
}

(* { character: Character; world: time: } *)


val key_input : (char -> unit) -> 'a -> unit -> unit

(** stand in character for now is dot, and it's init position is 400 200 *)
val dot : t_pos -> unit

val dot_init : t_pos -> unit

val dot_end : unit


(** match keyboard input to a move *)
val move_key : t_pos -> char -> unit
