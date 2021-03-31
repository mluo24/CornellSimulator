(* animation loading tilesets *)

type tile =
  | Grass
  | Building

type t = tile array array

let x_dim = 800

let y_dim = 640

let tile_size = 16

let row = x_dim / tile_size

let col = y_dim / tile_size

let layers = 2

let arr_from_txt filename = failwith "Unimplemented"

(* let ic = open_in filename in let try_read () = try Some (input_line
   ic) with End_of_file -> None in let rec loop acc = match try_read ()
   with | Some s -> loop (s :: acc) | None -> close_in ic; List.rev acc
   in loop [] *)

let map_from_arr arr = failwith "Unimplemented"

let int_to_tile i = failwith "Unimplemented"
