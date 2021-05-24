(* interaction between key input, user, item, map *)

(** The abstract type of values representing the game state. t currently keep
    track of

    - world: the state of the map
    - character:the state of the user
    - items : the state of items on the map *)
type t = {
  world : World.t;
  current_area : AreaMap.t;
  character : Character.t;
  mutable items : Item.t;
  (* mutable gauges: Gauges.t *)
  mutable gauges : Gauges.t; (*mutable missions : Mission.t;*)
}

(* { character: Character; world: time: } *)

(** [init_game ] is the initial state of the game when playing *)
val init_game : string -> string -> int -> string -> int -> t

(** [draw t] draws current state [t] of the game *)
val draw : t -> unit

(** [in_game] updates state of the game based on user input *)
val in_game : string -> string -> int -> string -> int -> unit
