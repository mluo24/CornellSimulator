(** A module for handling the logic of the movable character in game. *)

open Graphics
open Drawable
open World
open AreaMap
open Position
open Images

(** The type of values representing character. Record fields include:

    - [name] : name of the character,
    - [layer1_tile_mem] : mutable AreaMap.tile that the character is over in
      the first layer,
    - [layer2_tile_mem] : mutable AreaMap.tile that the character is over in
      the second layer,
    - [rep] : mutable character image,
    - [pos] : mutable Position.t of the character
    - [speed] : number of pixels the character moves per keyboard input *)
type t = {
  name : string;
  mutable layer1_tile_mem : tile;
  mutable layer2_tile_mem : tile;
  mutable rep : Graphics.image;
  png : string;
  mutable pos : Position.t;
  speed : int;
}

(** The type representing the different positions of the character
    corresponding to movements in different directions*)
type person = Position.direction

(** [draw t] is draws the character [t]*)
include Drawable with type t := t

(** [image_width png] returns the integer width of the png image*)
val image_width : string -> int

(** [get_person_pose x y png] find the pose image representation of the
    character*)
val get_person_pose : int -> int -> string -> Graphics.image

(** [get_size t] is the size of character [t] in graphical interface unit*)
val get_size : t -> int

(** [get_person_image person] matches [person] to an image representing the
    character in the pose of the direction of the character's movement*)
val get_person_image : string -> Position.direction -> Graphics.image

(** [y_offset row] makes calculation adjustments to the tilesize and different
    coordinate systems*)
val y_offset : int -> int

(** [get_tile_from_coords x y layer map] finds the tile at the coordinates of
    the current map*)
val get_tile_from_coords : int -> int -> int -> AreaMap.t -> AreaMap.tile

(** [init_character] initializes the character [t]*)
val init_character : string -> string -> AreaMap.t -> t

(** [draw_move] implements the drawing as well as the [t] field values
    updates, generalizing for movements in any direction*)
val draw_move :
  t ->
  Position.t ->
  AreaMap.t ->
  Images.t array array ->
  Position.direction ->
  unit

(** [move_up t map assets] implements the animation of the character's up
    movement.*)
val move_up : t -> AreaMap.t -> Images.t array array -> unit

(** [move_right t map assets] implements the animation of the character's
    right movement.*)
val move_right : t -> AreaMap.t -> Images.t array array -> unit

(** [move_down t map assets] implements the animation of the character's right
    movement.*)
val move_down : t -> AreaMap.t -> Images.t array array -> unit

(** [move_left t map assets] implements the animation of the character's right
    movement.*)
val move_left : t -> AreaMap.t -> Images.t array array -> unit

(** [refresh_character t map assets] reloads the current tile layers the
    character is standing on from the updated [map] and redraws the current
    tile layers and character. *)
val refresh_character : t -> AreaMap.t -> Images.t array array -> unit

(** [move t ch] matches character [t] to the animation in the direction
    specified by character [ch] based on the character current speed.

    Requires: [ch] must be ['w'], ['a'], ['s'], ['d'] which represent up,
    left, down, right respectively. If not the keys specified, the character
    does not move. *)
val move : t -> char -> AreaMap.t -> Images.t array array -> unit
