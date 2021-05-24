open Yojson.Basic.Util
open Graphics
open ImageHandler
open Images
open AreaMap

type coords = {
  x : int;
  y : int;
}

(* areamaps, current areamap *)

type t = {
  maps : (string, AreaMap.t) Hashtbl.t;
  start_map : AreaMap.t;
  assets : Images.t array array;
}

let x_dim = 800

let y_dim = 560

(** for 32x32 *)

(* let y_dim = 576 *)

(* let layers = 2 *)

let load_files dir =
  let files_in_dir = Sys.readdir dir |> Array.to_list in
  let map_files =
    List.filter (fun file -> Filename.extension file = ".json") files_in_dir
  in
  map_files

let load_tilesets tile_size =
  let terrain_tileset =
    ImageHandler.load_tileset "assets/nature.png" tile_size
  in
  let street_tileset =
    ImageHandler.load_tileset "assets/Street32.png" tile_size
  in
  let building_tileset =
    ImageHandler.load_tileset "assets/Buildings32.png" tile_size
  in
  let room_tileset =
    ImageHandler.load_tileset "assets/Room_Builder_free_32x32.png" tile_size
  in
  let interior_tileset =
    ImageHandler.load_tileset "assets/Interiors_free_32x32.png" tile_size
  in
  [|
    terrain_tileset; street_tileset; building_tileset; room_tileset;
    interior_tileset;
  |]

let load_world dir =
  let area_maps = Hashtbl.create (List.length (load_files dir)) in
  List.iter
    (fun file ->
      let name = String.sub file 0 (String.index file '.') in
      let area_map = map_from_json_file (dir ^ "/" ^ file) in
      Hashtbl.add area_maps name area_map)
    (load_files dir);
  let json = Yojson.Basic.from_file "world_init.json" in
  let tile_size = json |> member "tile_size" |> to_int in
  let start_map_key = json |> member "start" |> to_string in
  let assets = load_tilesets tile_size in
  {
    maps = area_maps;
    start_map = Hashtbl.find area_maps start_map_key;
    assets;
  }

(**** HERE WE GO ****)

let get_map world name = Hashtbl.find world.maps name

(* let switch_map world name = failwith "unimplemented" *)

(* let generate_items world = failwith "unimplemented" *)

let list_maps world = world.maps

let get_start_map world = world.start_map

let get_assets world = world.assets
