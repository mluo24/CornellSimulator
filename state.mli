(* interaction between key input, user, item, map *)

(** The abstract type of values representing the game state. t currently keep
    track of

    - [world]: all maps within the game
    - [current_area] : the current map
    - [character]: the state of the user
    - [items] : the state of items on the map
    - [gauges] : the character's status *)
type t = {
  world : World.t;
  mutable current_area : AreaMap.t;
  character : Character.t;
  mutable items : Item.t;
  mutable gauges : Gauges.t;
}

(** [level] holds relevant values representing the different levels for each
    character. [level] currently keeps track of:

    - [json] : the json representation of the level's missions
    - [level] : an integer representation of the level's year (1 = freshman, 2
      = sophomore, etc.)
    - [points] : the player's accumulated points
    - [name] : the character's name for identification *)
type level = {
  json : string;
  level : int;
  points : int;
  name : string;
}

(** type [key_module] categorizes/organizes the different modules that the key
    input could refer to. *)
type key_module =
  | Item
  | Character
  | NoModule
  | Gauges

(** [eval_key key] matches the [key] input to a [key_module] type *)
val eval_key : char -> key_module

(** [init_game name png level level_png points] initializes the starting state
    of all game components*)
val init_game : string -> string -> int -> string -> int -> t

(** [draw t] draws current state [t] of the game *)
val draw : t -> unit

(** [draw_t () ] draws the transition state between each level*)
val draw_t : unit -> unit

(**[y_offset row] calculate the tile offset of the dimensions using tile units
   [32 pixels]*)
val y_offset : int -> int

(** [change_room state world tiletype] changes the map that the character is
    currently on*)
val change_room : t -> World.t -> AreaMap.tiletype -> unit

(** [level_to_next level_num acc_points name] matches the current level with
    the next one for the transition*)
val level_to_next : int -> int -> string -> level

(** [character_action game_state s] implements the sequence of actions taken
    after character type key input *)
val character_action : t -> Graphics.status -> unit

(**[item_action game_state c] implements the sequence of actions taken after
   an item type key input *)
val item_action : t -> char -> unit

(** [in_game] updates state of the game based on user input *)
val in_game : string -> string -> int -> string -> int -> unit

(** [transition_in_game] implements the transition screen between levels and
    the mouse input for proceeding to the next level*)
