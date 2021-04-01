(* interaction between key input, user, item, map *)

type t

(* { character: Character; world: time: } *)

(** stand in character for now is dot and it's init pos is center *)
val draw_point : int -> int -> int -> unit

(** match keyboard input to a move *)
