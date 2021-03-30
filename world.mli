(** The abstract type of values representing the game map. *)
type t

(** The type of a tile 
    TODO: use records to store data within the tiles, finish the types of tiles that we may need
*)
type tile = 
    | Grass 
    | Building

(** [x_dim] is the width of the graphics window *)
val x_dim : int

(** [y_dim] is the height of the graphics window *)
val y_dim : int

(** [tile_size] is the width and height each tile in pixels *)
val tile_size : int

val row : int

val col : int

(** *)
val arr_from_txt : string -> int array

(** *)
val int_to_tile : int -> tile

(** *)
val map_from_arr : int array -> t