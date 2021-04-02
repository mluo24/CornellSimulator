(* interaction between key input, user, item, map *)

type t

(* { character: Character; world: time: } *)

(* val key_input : (char -> unit) -> 'a -> unit -> unit *)

val init_game : unit -> t

val draw : t -> unit

val in_game : unit -> unit

(* val dot : t_pos -> unit

   val dot_init : t_pos -> unit

   val dot_end : unit

   (** match keyboard input to a move *) val move_key : t_pos -> char -> unit *)
