(** The abstract type representing the game map. *)
type t

(** The type of a tile TODO: use records to store data within the tiles,
    finish the types of tiles that we may need *)
type tile =
  | Blank
  (** terrain.png *)
  | Grass
  | TreeBot
  | TreeTop
  | Flower
  | Bush
  (** street.png *)
  | Sidewalk_Curved_BotLeft
  | Sidewalk_Curved_BotRight
  | Sidewalk_Curved_TopLeft
  | Sidewalk_Curved_TopRight
  | Sidewalk_Horiz
  | Sidewalk_Vert
  (** building.png *)
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

(** [x_dim] is the width of the graphics window *)
val x_dim : int

(** [y_dim] is the height of the graphics window *)
val y_dim : int

(* (** [tile_size] is the width and height each tile in pixels *) val
   tile_size : int

   (** [rows] is the number of tiles in each row of the map *) val rows : int

   (** [cols] is the number of tiles in each column of the map *) val cols :
   int

   val layers : int *)

(** *)
val map_from_json_file : string -> t

(** *)
val int_to_tile : int -> tile

(** *)
val get_tile_arr : t -> tile array

(** *)
val get_tile : int -> int -> t -> tile

(** *)
val get_rows : t -> int

(** *)
val get_cols : t -> int

(** *)
val get_tile_size : t -> int

(** *)
val get_assets : t -> Images.t array array

(** *)
val get_image_from_tile : Images.t array array -> tile -> int -> Graphics.image

(** *)
(* val get_color_from_tile : tile -> Graphics.color *)

(** *)
val draw_tile : int -> int -> tile -> t -> unit

(** *)
val draw_tiles : t -> unit
