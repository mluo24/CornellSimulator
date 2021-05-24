(* possibly have this to be all the stuff you need for each of the areas in
   the map. *)
(* SPECIFY HOW THE X AND Y COORDINATE SYSTEM WORKS *)

(** The abstract type representing the game map. *)
type t

(** [tile] is the type of a tile *)
type tile =
  | Blank
  (* terrain.png *)
  | Grass
  | TreeBot
  | TreeTop
  | Flower
  | Bush
  (* street.png *)
  | Sidewalk_Curved_BotLeft
  | Sidewalk_Curved_BotRight
  | Sidewalk_Curved_TopLeft
  | Sidewalk_Curved_TopRight
  | Sidewalk_Horiz
  | Sidewalk_Vert
  (* building.png *)
  | Building1_Left
  | Building1_Mid
  | Building1_Right
  | Building2_Left
  | Building2_Mid
  | Building2_Right
  | Roof
  | Roof_BotLeft
  | Roof_BotRight
  | Roof_TopLeft
  | Roof_TopRight
  | Roof_TopEdge
  | Roof_LeftEdge
  | Roof_BotEdge
  | Roof_RightEdge
  | DoorTop
  | DoorBot
  | Food of string
  | Water of string
  | RedBook of string
  | YellowBook of string
  | GreenBook of string
  | BlueBook
  | PurpleBook of string

type tiletype =
  | StandardTile of tile
  | ItemTile of string * tile
  | SolidTile of tile
  | DoorTile of string * Position.t * tile

(** [map_from_json_file filename] takes the name of a file [filename] and
    loads and returns the data into the a World type. It also adds the field
    [assets] to the World type, which is a matrix of images.

    Requires: file must be a json with the following fields:

    [tile_size] -> size in pixels of a square tile

    [cols] -> how many columns of tiles in the map

    [rows] -> how many rows of tiles in the map

    [tiles] -> a 1D array of the tile configuration, in integers *)
val map_from_json_file : string -> t

(** [int_to_tile i] matches an integer to a specified tile. Arbitrarily, the
    numbers correspond to the tile who has that definition position, starting
    from 0, i.e. 1 -> Grass *)
val int_to_tile : int -> tile

(** [get_tile_arr world map] returns the array of tiles of [map] *)

(* val get_tile_arrs : t -> tile array array *)

(** [get_layer] returns the array of tiles of [map] *)
val get_layer : t -> int -> tiletype array

(** [get_layer_as_tiles] returns the array of tiles of [map] *)
val get_layer_as_tiles : t -> int -> tile array

(** [get_tile row col map] returns the tile at row [row] and column [col] from
    the tile array in [map]. *)
val get_tile : int -> int -> int -> t -> tiletype

val get_tile_as_tile : int -> int -> int -> t -> tile

(** [get_rows map] returns the number of rows [map] has. *)
val get_rows : t -> int

(** [get_cols map] returns the number of columns [map] has. *)
val get_cols : t -> int

(** [get_tile_size map] returns the size of the tiles [map] has. *)
val get_tile_size : t -> int

val get_exits : t -> (string, Position.t) Hashtbl.t

val get_spawn : t -> Position.t

val replace_tiletype : t -> int -> int -> int -> string -> Position.t -> unit

val remove_item_tile : t -> int -> int -> unit

(** [get_image_from_tile assets tile tsize] returns the Graphics image
    representation of an image from [assets] given a specific [tile] and the
    tile's tile size [tsize]. *)
val get_image_from_tile :
  Images.t array array -> tile -> int -> Graphics.image

(** [draw_tile x y tile map assets] draws [tile] at position ([x], [y]) on the
    graphics screen. *)
val draw_tile : int -> int -> tile -> t -> Images.t array array -> unit

(** [draw_tile map assets] draws the tiles of [map] on the graphics screen. *)

(* val draw_tiles : t -> Images.t array array -> unit *)

(** [draw_layer map layer assets] draws the tiles belonging to layer [layer]
    corresponding to the correct layer in [map] on the graphics screen. *)
val draw_layer : t -> int -> Images.t array array -> unit

(** *)
val is_solid_tile : t -> int -> int -> bool

val is_door_tile : t -> int -> int -> bool

val is_item_tile : tiletype -> bool
