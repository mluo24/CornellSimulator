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
let key c = failwith "unimplemented"

let move_character m c = failwith "unimplement"

let collect_item item c = failwith "unimplement"
