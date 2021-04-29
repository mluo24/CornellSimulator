val load_tileset : string -> int -> Graphics.image array

val get_entire_image : string -> Images.t

val make_transparent : Graphics.image -> Graphics.image

val get_tileset_part : int -> int -> int -> int -> Images.t -> Graphics.image