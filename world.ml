<<<<<<< HEAD
type t
=======
open Yojson.Basic.Util
(* animation loading tilesets *)
>>>>>>> d9d2319a202303073a2aa15dadaf13becad6bce8

type tile = 
  | Blank
  | Grass 
  | Sidewalk
  | Building

<<<<<<< HEAD
let x_dim = failwith "Unimplemented"
=======
type t = {
  cols : int;
  rows : int;
  tile_size : int;
  tiles: tile array
}
>>>>>>> d9d2319a202303073a2aa15dadaf13becad6bce8

let y_dim = failwith "Unimplemented"

let tile_sizw = failwith "Unimplemented"

<<<<<<< HEAD
let rows = failwith "Unimplemented"
=======
(* let tile_size = 16
>>>>>>> d9d2319a202303073a2aa15dadaf13becad6bce8

let cols = failwith "Unimplemented"

let tile_size = failwith "Unimplemented"

<<<<<<< HEAD
let layers = failwith "Unimplemented"

let arr_from_txt = failwith "Unimplemented"

let int_to_tile = failwith "Unimplemented"

let map_from_arr = failwith "Unimplemented"
=======
let layers = 2 *)

let int_to_tile i = 
  match i with
  | 1 -> Grass
  | 2 -> Sidewalk
  | 3 -> Building
  | _ -> Blank

let map_from_json json = {
  cols = json |> member "cols" |> to_int;
  rows = json |> member "rows" |> to_int;
  tile_size = json |> member "tile_size" |> to_int;
  tiles = json |> member "tile_size" |> to_list 
          |> List.map to_int |> List.map int_to_tile |> Array.of_list
}
(* let ic = open_in filename in let try_read () = try Some (input_line
   ic) with End_of_file -> None in let rec loop acc = match try_read ()
   with | Some s -> loop (s :: acc) | None -> close_in ic; List.rev acc
   in loop [] *)

let map_from_arr arr = failwith "Unimplemented"
>>>>>>> d9d2319a202303073a2aa15dadaf13becad6bce8
