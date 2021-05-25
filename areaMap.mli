(** Module meant for parsing number arrays into interactable tilemaps. *)

(** The abstract type representing the game map. *)
type t

(** [tile] is the type of a tile *)
type tile =
  | Blank
  | Grass
  | TreeBot
  | TreeTop
  | Flower
  | Bush
  | Sidewalk_Curved_BotLeft
  | Sidewalk_Curved_BotRight
  | Sidewalk_Curved_TopLeft
  | Sidewalk_Curved_TopRight
  | Sidewalk_Horiz
  | Sidewalk_Vert
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

(** [tiletype] is the type of a tile depending on its property.

    - [StandardTile] is a walkable tile
    - [ItemTile] is a tile with an Item in it
    - [SolidTile] is a tile that the player cannot walk through
    - [DoorTile] is a tile that leads to a different map. *)
type tiletype =
  | StandardTile of tile
  | ItemTile of string * tile
  | SolidTile of tile
  | DoorTile of string * Position.t * tile

(** [map_from_json_file filename] takes the name of a file [filename] and
    loads and returns the data into the a World type. It also adds the field
    [assets] to the World type, which is a matrix of images.

    Requires: file must be a json with the following fields:

    - [tile_size] -> size in pixels of a square tile
    - [cols] -> how many columns of tiles in the map
    - [rows] -> how many rows of tiles in the map
    - [layer1] -> a 1D array of the tile configuration of the first layer, in
      integers
    - [layer2] -> a 1D array of the tile configuration of the second layer, in
      integers
    - [exits] -> a list of different maps that this map leads to as well as
      the column and row that it would be located in in the map
    - [spawn] -> the Position that the player should spawn in when loaded into
      the map *)
val map_from_json_file : string -> t

(** [int_to_tile i] matches an integer to a specified tile. Arbitrarily, the
    numbers correspond to the tile who has that definition position, starting
    from 0, i.e. 1 -> Grass. *)
val int_to_tile : int -> tile

(** [tile_type_of_tile tile] returns the tiletype from a specified [tile]. *)
val tile_type_of_tile : tile -> tiletype

(** [get_layer map layer] returns the array of tiletypes of [map] in [layer]. *)
val get_layer : t -> int -> tiletype array

(** [get_layer_as_tiles map layer] returns the [layer] of [map] as an array of
    tiles. *)
val get_layer_as_tiles : t -> int -> tile array

(** [get_tile row col layer map] returns the tiletype at row [row] and column
    [col] from the tiletype array of [layer] in [map]. *)
val get_tile : int -> int -> int -> t -> tiletype

(** [get_tile_as_tile row col layer map] returns the tiletype converted to a
    tile at the [row] and [col] of the specified layer in [map]. *)
val get_tile_as_tile : int -> int -> int -> t -> tile

(** [get_rows map] returns the number of rows [map] has. *)
val get_rows : t -> int

(** [get_cols map] returns the number of columns [map] has. *)
val get_cols : t -> int

(** [get_tile_size map] returns the size of the tiles [map] has. *)
val get_tile_size : t -> int

(** [get_exits map] returns the exits [map] has. *)
val get_exits : t -> (string, Position.t) Hashtbl.t

(** [get_spawn map] returns the spawn position [map] has. *)
val get_spawn : t -> Position.t

(** [replace_tiletype map x y layer exit_name spawn_pos] replaces the tiletype
    at the location of ([x], [y]) relative to the top left corner with a
    DoorTile on the specified [layer]. *)
val replace_tiletype : t -> int -> int -> int -> string -> Position.t -> unit

(** [remove_item_tile map x y] replaces the ItemTile at the location of ([x],
    [y]) relative to the top left corner with a blank tile in the second
    layer. *)
val remove_item_tile : t -> int -> int -> unit

(** [get_image_from_tile assets tile tsize] returns the Graphics image
    representation of an image from [assets] given a specific [tile] and the
    tile's tile size [tsize]. *)
val get_image_from_tile :
  Images.t array array -> tile -> int -> Graphics.image

(** [draw_tile x y tile map assets] draws [tile] at position ([x], [y]) on the
    graphics screen. *)
val draw_tile : int -> int -> tile -> t -> Images.t array array -> unit

(** [draw_layer map layer assets] draws the tiles belonging to layer [layer]
    corresponding to the correct layer in [map] on the graphics screen. *)
val draw_layer : t -> int -> Images.t array array -> unit

(** [is_solid_tile map x y] returns [true] if the type of the tiletype in
    [map] at ([x], [y]) starting from the bottom-left corner as (0, 0) as
    referenced truly in the graphics panel is a [SolidTile], otherwise return
    [false]. *)
val is_solid_tile : t -> int -> int -> bool

(** [is_door_tile map x y] returns [true] if the type of the tiletype in [map]
    at ([x], [y]) starting from the bottom-left corner as (0, 0) as referenced
    truly in the graphics panel is a [DoorTile], otherwise return [false]. *)
val is_door_tile : t -> int -> int -> bool

(** [is_door_tile tiletype] returns [true] if the type of the [tiletype] is an
    [ItemTile], otherwise return [false]. *)
val is_item_tile : tiletype -> bool
