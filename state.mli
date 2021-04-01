(* interaction between key input, user, item, map *)

type state

(* { character: Character; world: time: } *)

(** stand in character for now is dot and it's init pos is center *)
val dot_init : unit

val dot_end : unit

(** match keyboard input to a move *)
