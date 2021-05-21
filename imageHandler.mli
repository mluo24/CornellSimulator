(* change this so this has a type t so that this can truly be some sort of module? *)
(** MAYBE MAKE THIS ALL THE TILESETS? *)

(** [load_tileset filename tile_size] takes an image with the file name 
    [filename] and tile size [tile_size] and loads the individual tile images
    into an Image array. *)
val load_tileset : string -> int -> Images.t array

(** [get_entire_image filename] takes a [filename] and converts it
    to an image. 

    Requires: [filename] is a valid PNG image.
*)
val get_entire_image : string -> Images.t

(** [make_transparent img] takes an image and turns the black pixels to 
    a transparently defined color in the [Graphics] module. *)
val make_transparent : Graphics.image -> Graphics.image

(** [get_tileset_part x y w h image] takes a sub image of [image] starting at position
    ([x], [y]) of size [w] * [h]. *)
val get_tileset_part : int -> int -> int -> int -> Images.t -> Graphics.image

(** [get_tile_image_x_y tileset width x y] gets the  *)
val get_tile_image_x_y : Images.t array -> int -> int -> int -> Graphics.image
