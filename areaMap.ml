open Yojson.Basic.Util
open Graphics
open ImageHandler
open Images
open Position

type tile =
  | Blank
  (* terrain.png *)
  | Grass
  | TreeBot
  | TreeTop
  | Flower
  | Bush
  (* street.png *)
  | Sidewalk_Curved_BotLeft
  | Sidewalk_Curved_BotRight
  | Sidewalk_Curved_TopLeft
  | Sidewalk_Curved_TopRight
  | Sidewalk_Horiz
  | Sidewalk_Vert
  (* building.png *)
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

type tiletype =
  | StandardTile of tile
  | ItemTile of string * tile
  | SolidTile of tile
  | DoorTile of string * (int * int) * tile

(* redraw tile function *)

(* stringname, visual name *)

type t = {
  name : string;
  cols : int;
  rows : int;
  tile_size : int;
  layer1 : tile array;
  layer2 : tile array;
}

let layers = 2

let int_to_tile i =
  match i with
  | 1 -> Grass
  | 2 -> TreeBot
  | 3 -> TreeTop
  | 4 -> Flower
  | 5 -> Bush
  (* street.png *)
  | 6 -> Sidewalk_Curved_BotLeft
  | 7 -> Sidewalk_Curved_BotRight
  | 8 -> Sidewalk_Curved_TopLeft
  | 9 -> Sidewalk_Curved_TopRight
  | 10 -> Sidewalk_Horiz
  | 11 -> Sidewalk_Vert
  (* building.png *)
  | 12 -> Building1_Left
  | 13 -> Building1_Mid
  | 14 -> Building1_Right
  | 15 -> Building2_Left
  | 16 -> Building2_Mid
  | 17 -> Building2_Right
  | 18 -> Roof
  | 19 -> Roof_BotLeft
  | 20 -> Roof_BotRight
  | 21 -> Roof_TopLeft
  | 22 -> Roof_TopRight
  | 23 -> Roof_TopEdge
  | 24 -> Roof_LeftEdge
  | 25 -> Roof_BotEdge
  | 26 -> Roof_RightEdge
  | 27 -> DoorTop
  | 28 -> DoorBot
  | _ -> Blank

let tile_type_of_tile tile = failwith "unimplemented"

let map_from_json_file filename =
  let json = Yojson.Basic.from_file filename in
  let tile_size = json |> member "tile_size" |> to_int in
  {
    name = json |> member "name" |> to_string;
    cols = json |> member "cols" |> to_int;
    rows = json |> member "rows" |> to_int;
    tile_size;
    layer1 =
      json |> member "layer1" |> to_list |> List.map to_int
      |> List.map int_to_tile |> Array.of_list;
    layer2 =
      json |> member "layer2" |> to_list |> List.map to_int
      |> List.map int_to_tile |> Array.of_list;
  }

let get_tile_arrs map = [| map.layer1; map.layer2 |]

let get_layer map layer = if layer = 1 then map.layer1 else map.layer2

(* let get_tile row col map = try map.tiles.((row * map.cols) + col) with
   Invalid_argument x -> Blank *)

let get_tile row col layer map =
  if layer = 1 then
    try map.layer1.((row * map.cols) + col) with Invalid_argument x -> Blank
  else
    try map.layer2.((row * map.cols) + col) with Invalid_argument x -> Blank

let get_rows map = map.rows

let get_cols map = map.cols

let get_tile_size map = map.tile_size

(* let get_assets map = map.assets *)

let terrain_image_width =
  fst (Images.size (ImageHandler.get_entire_image "assets/nature.png"))

let street_image_width =
  fst (Images.size (ImageHandler.get_entire_image "assets/Street32.png"))

let building_image_width =
  fst (Images.size (ImageHandler.get_entire_image "assets/Buildings32.png"))

let get_image_from_tile assets tile tsize =
  let terrain_tileset = assets.(0) in
  let street_tileset = assets.(1) in
  let building_tileset = assets.(2) in
  let get_terrain_tile x y =
    ImageHandler.get_tile_image_x_y terrain_tileset
      (terrain_image_width / tsize)
      x y
  in
  let get_street_tile x y =
    ImageHandler.get_tile_image_x_y street_tileset
      (street_image_width / tsize)
      x y
  in
  let get_building_tile x y =
    ImageHandler.get_tile_image_x_y building_tileset
      (building_image_width / tsize)
      x y
  in
  match tile with
  | Blank ->
      Graphics.make_image (Array.make_matrix tsize tsize Graphics.transp)
  | Grass -> get_terrain_tile 0 2
  | TreeBot -> get_terrain_tile 0 1
  | TreeTop -> get_terrain_tile 0 0
  | Flower -> get_terrain_tile 3 1
  | Bush -> get_terrain_tile 1 1
  (* street.png *)
  | Sidewalk_Curved_BotLeft -> get_street_tile 17 4
  | Sidewalk_Curved_BotRight -> get_street_tile 21 4
  | Sidewalk_Curved_TopLeft -> get_street_tile 17 0
  | Sidewalk_Curved_TopRight -> get_street_tile 21 0
  | Sidewalk_Horiz -> get_street_tile 18 0
  | Sidewalk_Vert -> get_street_tile 17 1
  (* building.png *)
  | Building1_Left -> get_building_tile 0 0
  | Building1_Mid -> get_building_tile 1 0
  | Building1_Right -> get_building_tile 2 0
  | Building2_Left -> get_building_tile 0 3
  | Building2_Mid -> get_building_tile 1 3
  | Building2_Right -> get_building_tile 2 3
  | Roof -> get_building_tile 5 1
  | Roof_BotLeft -> get_building_tile 4 2
  | Roof_BotRight -> get_building_tile 6 2
  | Roof_TopLeft -> get_building_tile 4 0
  | Roof_TopRight -> get_building_tile 6 0
  | Roof_TopEdge -> get_building_tile 5 0
  | Roof_LeftEdge -> get_building_tile 4 1
  | Roof_BotEdge -> get_building_tile 5 2
  | Roof_RightEdge -> get_building_tile 6 1
  | DoorTop -> get_building_tile 10 7
  | DoorBot -> get_building_tile 10 8

let draw_tile x y tile map assets =
  let tsize = get_tile_size map in
  Graphics.draw_image (get_image_from_tile assets tile tsize) x y

let draw_tile_iter map assets i tile_t =
  let tsize = get_tile_size map in
  let cols = get_cols map in
  let x = i mod cols * tsize in
  let y = y_dim - tsize - (i / cols * tsize) in
  draw_tile x y tile_t map assets

(* let draw_tiles map assets layer = Array.iteri (draw_tile_iter map assets)
   (get_layer map layer) *)

let draw_layer map layer assets =
  Array.iteri (draw_tile_iter map assets) (get_layer map layer)

let is_solid_tile map x y = failwith "unimplemented"

let is_door_tile map x y = failwith "unimplemented"

let tile_effect tile = failwith "unimplemented"
