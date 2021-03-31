<<<<<<< HEAD
(** a type t for representing the state of the game *)
=======
(* interaction between key input, user, item, map *)
open Position

type t

(* { character: Character; world: time: } *)

type move = {
  forward : Position.t;
  back : Position.t;
  right : Position.t;
  left : Position.t;
}

(** match keyboard input to a move *)
val key : char -> move

val move_character : move -> t -> t

val collect_item : Item.t -> t -> t
>>>>>>> aab8e55dee5ec2717615c0b7ce770fd42c8fead0
