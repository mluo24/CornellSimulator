open Graphics
open Drawable
open World
open Position
open Images

(** The type of values representing character. Record fields include:

    - [name] : name of the character,
    - [tile_mem] : mutable World.tile that the character is over,
    - [rep] : mutable character image,
    - [pos] : mutable Position.t of the character
    - [speed] : number of pixels the character moves per keyboard input *)
type t = {
  name : string;
  mutable tile_mem : Graphics.image;
  mutable rep : Graphics.image;
  png : string;
  pos : Position.t;
  speed : int;
}

(** The type representing the different positions of the character
    corresponding to movements in different directions*)
type person = Position.direction

(** [draw t] is draws the character [t]*)
include Drawable with type t := t

(** [get_user_name t] is the name of the character [t]*)
val get_user_name : t -> string

(** [get_size t ] is the size of character [t] in graphical interface unit*)
val get_size : t -> int

(** [player_image_size_width] is width of the image, measured in unit tile
    lengths*)
val player_image_size_width : int

(** [world] is the World.t type of the json data used to represent the map
    referenced as the character moves*)
val world : World.t

(** [get_person_image person] matches [person] to an image representing the
    character in the pose of the direction of the character's movement*)
val get_person_image : string -> Position.direction -> Graphics.image

(** [init_character] initializes the character [t]*)
val init_character : string -> string -> t

(** [move_up t] implements the animation of the character's up movement.*)
val move_up : t -> unit

(** [move_right t] implements the animation of the character's right movement.*)
val move_right : t -> unit

(** [move_down t] implements the animation of the character's right movement.*)
val move_down : t -> unit

(** [move_left t] implements the animation of the character's right movement.*)
val move_left : t -> unit

(** [move t ch] matches character [t] to the animation in the direction
    specified by character [ch] based on the character current speed Require:
    ch must be 'w', 'a', 's', 'd' which represent up, left, down, right
    respectively. If not the keys specified, the character does not move. *)
val move : t -> char -> unit
