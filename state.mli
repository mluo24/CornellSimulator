(* interaction between key input, user, item, map *)

type state

(* { character: Character; world: time: } *)

val key_input : (char -> unit) -> 'a -> 'b -> unit

(** stand in character for now is dot, and it's init position is 400 200 *)
val dot : unit

val dot_init : unit

val dot_end : unit

(** match keyboard input to a move *)
val move_key : state -> char -> unit
