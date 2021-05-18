(** *)
val load_tileset : string -> int -> Images.t array

val get_entire_image : string -> Images.t

(** *)
val make_transparent : Graphics.image -> Graphics.image

(** *)
val get_tileset_part : int -> int -> int -> int -> Images.t -> Graphics.image

(** *)
val get_tile_image_x_y : Images.t array -> int -> int -> int -> Graphics.image
