open Yojson.Basic.Util
open Graphics
open ImageHandler
open Images
open AreaMap

type t = {
  maps : (string, AreaMap.t) Hashtbl.t;
  start_map : AreaMap.t;
  assets : Images.t array array;
}

let load_files dir =
  let files_in_dir = Sys.readdir dir |> Array.to_list in
  let map_files =
    List.filter (fun file -> Filename.extension file = ".json") files_in_dir
  in
  map_files

(** [load_tilesets tile_size] loads in all the tileset assets being used in
    the game. *)
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
  let book_tileset =
    ImageHandler.load_tileset "assets/items/books.png" tile_size
  in
  let pizza = ImageHandler.load_tileset "assets/items/pizza.png" tile_size in
  let liq = ImageHandler.load_tileset "assets/items/liq.png" tile_size in
  [|
    terrain_tileset; street_tileset; building_tileset; room_tileset;
    interior_tileset; book_tileset; pizza; liq;
  |]

(** [add_exits maps] adds the appropriate links as a DoorTile in each map to
    its specified maps in their initialization. *)
let add_exits maps =
  Hashtbl.iter
    (fun map_name map ->
      let exits = get_exits map in
      Hashtbl.iter
        (fun exit_name (pos : Position.t) ->
          let col = pos.x in
          let row = pos.y in
          replace_tiletype map col row 1 exit_name
            (get_spawn (Hashtbl.find maps exit_name)))
        exits)
    maps

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

let get_map world name = Hashtbl.find world.maps name

let list_maps world = world.maps

let get_start_map world = world.start_map

let get_assets world = world.assets
