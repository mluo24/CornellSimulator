open Yojson.Basic.Util
open Graphics
(* animation loading tilesets *)

type tile =
  | Blank
  | Grass
  | Sidewalk
  | Building

type t = {
  cols : int;
  rows : int;
  tile_size : int;
  tiles : tile array;
}

(** possibly make this in the type of the map *)
let x_dim = 800

let y_dim = 560

(* let tile_size = 16

   let cols = failwith "Unimplemented"

   let tile_size = failwith "Unimplemented"

   let layers = 2 *)

let int_to_tile i =
  match i with 1 -> Grass | 2 -> Sidewalk | 3 -> Building | _ -> Blank

let map_from_json_file filename =
  let json = Yojson.Basic.from_file filename in 
  {
    cols = json |> member "cols" |> to_int;
    rows = json |> member "rows" |> to_int;
    tile_size = json |> member "tile_size" |> to_int;
    tiles = json |> member "tiles" |> to_list 
            |> List.map to_int |> List.map int_to_tile |> Array.of_list
  }

let get_tile_arr map = map.tiles

let get_tile row col map = map.tiles.(row * map.cols + col)

let get_rows map = map.rows

let get_cols map = map.cols

let get_tile_size map = map.tile_size

let get_color_from_tile tile = 
  match tile with
  | Blank -> Graphics.black
  | Grass -> Graphics.green
  | Sidewalk -> Graphics.yellow
  | Building -> Graphics.rgb 100 100 100

let draw_tile x y tile map = 
  let tsize = get_tile_size map in 
  Graphics.set_color (get_color_from_tile tile);
  Graphics.fill_rect x y (tsize) (tsize)

let draw_tile_iter map i tile_t = 
  let tsize = get_tile_size map in
  let cols = get_cols map in
  let x = (i mod cols) * tsize in
  let y = (y_dim - tsize) - (i / cols) * tsize in
  draw_tile x y tile_t map

let draw_tiles map = Array.iteri (draw_tile_iter map) (get_tile_arr map)

(* let map_from_arr arr = failwith "Unimplemented" *)

(* let ic = open_in filename in let try_read () = try Some (input_line
   ic) with End_of_file -> None in let rec loop acc = match try_read ()
   with | Some s -> loop (s :: acc) | None -> close_in ic; List.rev acc
   in loop [] *)
