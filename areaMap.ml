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
  | Food of string
  | Water of string
  | RedBook of string
  | YellowBook of string
  | GreenBook of string
  | BlueBook
  | PurpleBook of string

type tiletype =
  | StandardTile of tile
  | ItemTile of string * tile
  | SolidTile of tile
  | DoorTile of string * Position.t * tile

(* stringname, visual name *)

type t = {
  name : string;
  cols : int;
  rows : int;
  tile_size : int;
  layer1 : tiletype array;
  layer2 : tiletype array;
  exits : (string, Position.t) Hashtbl.t;
  spawn : Position.t;
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
  | 29 -> Food "Healthy Food"
  | 30 -> Water "water"
  | 31 -> RedBook "red_book"
  | 32 -> YellowBook "yellow_book"
  | 33 -> GreenBook "green_book"
  | 34 -> BlueBook
  | 35 -> PurpleBook "hw"
  | _ -> Blank

let tile_type_of_tile tile =
  match tile with
  | Grass | TreeTop | Flower | Sidewalk_Curved_BotLeft
  | Sidewalk_Curved_BotRight | Sidewalk_Curved_TopLeft
  | Sidewalk_Curved_TopRight | Sidewalk_Horiz | Roof_TopLeft | Roof_TopRight
  | Roof_TopEdge | Blank ->
      StandardTile tile
  | Bush | TreeBot | Building1_Left | Building1_Mid | Building1_Right
  | Building2_Left | Building2_Mid | Building2_Right | Roof | Roof_BotLeft
  | Roof_BotRight | Roof_LeftEdge | Roof_BotEdge | Roof_RightEdge ->
      SolidTile tile
  | DoorTop | DoorBot -> DoorTile ("classroom", { x = 0; y = 0 }, tile)
  | Food x | Water x | RedBook x | YellowBook x | GreenBook x | PurpleBook x
    ->
      ItemTile (x, tile)
  | _ -> StandardTile tile

(* unimplemented *)

let tile_of_tile_type tiletype =
  match tiletype with
  | StandardTile tile -> tile
  | ItemTile (_, tile) -> tile
  | SolidTile tile -> tile
  | DoorTile (_, _, tile) -> tile

let process_spawn spawn =
  match List.map (fun x -> to_int (snd x)) spawn with
  | [ x; y ] -> { x; y }
  | _ -> { x = -1; y = -1 }

let process_exits exits tbl =
  let loop curr_exit =
    match curr_exit with
    | [] -> ()
    | h :: t ->
        let dbl = List.hd h in
        Hashtbl.add tbl (fst dbl) (dbl |> snd |> to_assoc |> process_spawn)
  in
  loop exits

let map_from_json_file filename =
  let json = Yojson.Basic.from_file filename in
  let exits = json |> member "exits" |> to_list |> List.map to_assoc in
  let exits_tbl = Hashtbl.create (List.length exits) in
  process_exits exits exits_tbl;
  let spawn = json |> member "spawn" |> to_assoc in
  {
    name = json |> member "name" |> to_string;
    cols = json |> member "cols" |> to_int;
    rows = json |> member "rows" |> to_int;
    tile_size = json |> member "tile_size" |> to_int;
    layer1 =
      json |> member "layer1" |> to_list |> List.map to_int
      |> List.map int_to_tile
      |> List.map tile_type_of_tile
      |> Array.of_list;
    layer2 =
      json |> member "layer2" |> to_list |> List.map to_int
      |> List.map int_to_tile
      |> List.map tile_type_of_tile
      |> Array.of_list;
    exits = exits_tbl;
    spawn = process_spawn spawn;
  }

let replace_tiletype map x y layer exit_name spawn_pos =
  if layer = 1 then
    let tile = tile_of_tile_type map.layer1.((x * map.cols) + y) in
    map.layer1.((x * map.cols) + y) <- DoorTile (exit_name, spawn_pos, tile)
  else
    let tile = tile_of_tile_type map.layer2.((x * map.cols) + y) in
    map.layer2.((x * map.cols) + y) <- DoorTile (exit_name, spawn_pos, tile)

let remove_item_tile map x y =
  map.layer2.((x * map.cols) + y) <- StandardTile Blank

let get_tile_arrs map = [| map.layer1; map.layer2 |]

let get_layer map layer = if layer = 1 then map.layer1 else map.layer2

let get_layer_as_tiles map layer =
  Array.map tile_of_tile_type (get_layer map layer)

(* let get_tile row col map = try map.tiles.((row * map.cols) + col) with
   Invalid_argument x -> Blank *)

let get_tile row col layer map =
  if layer = 1 then
    try map.layer1.((row * map.cols) + col)
    with Invalid_argument x -> StandardTile Blank
  else
    try map.layer2.((row * map.cols) + col)
    with Invalid_argument x -> StandardTile Blank

let get_tile_as_tile row col layer map =
  tile_of_tile_type (get_tile row col layer map)

let get_rows map = map.rows

let get_cols map = map.cols

let get_tile_size map = map.tile_size

let get_exits map = map.exits

let get_spawn map = map.spawn

(* let get_assets map = map.assets *)

let terrain_image_width =
  fst (Images.size (ImageHandler.get_entire_image "assets/nature.png"))

let street_image_width =
  fst (Images.size (ImageHandler.get_entire_image "assets/Street32.png"))

let building_image_width =
  fst (Images.size (ImageHandler.get_entire_image "assets/Buildings32.png"))

let room_image_width =
  fst
    (Images.size
       (ImageHandler.get_entire_image "assets/Room_Builder_free_32x32.png"))

let interior_image_width =
  fst
    (Images.size
       (ImageHandler.get_entire_image "assets/Interiors_free_32x32.png"))

let book_image_width =
  fst (Images.size (ImageHandler.get_entire_image "assets/items/books.png"))

let pizza_width =
  fst (Images.size (ImageHandler.get_entire_image "assets/items/pizza.png"))

let liq_width =
  fst (Images.size (ImageHandler.get_entire_image "assets/items/liq.png"))

let get_terrain_tile x y tsize assets =
  let terrain_tileset = assets.(0) in
  ImageHandler.get_tile_image_x_y terrain_tileset
    (terrain_image_width / tsize)
    x y

let get_street_tile x y tsize assets =
  let street_tileset = assets.(1) in
  ImageHandler.get_tile_image_x_y street_tileset
    (street_image_width / tsize)
    x y

let get_building_tile x y tsize assets =
  let building_tileset = assets.(2) in
  ImageHandler.get_tile_image_x_y building_tileset
    (building_image_width / tsize)
    x y

let get_room_tile x y tsize assets =
  let room_tileset = assets.(3) in
  ImageHandler.get_tile_image_x_y room_tileset
    (building_image_width / tsize)
    x y

let get_book_tile x y tsize assets =
  let book_tileset = assets.(5) in
  ImageHandler.get_tile_image_x_y book_tileset (book_image_width / tsize) x y

let get_pizza_tile x y tsize assets =
  let pizza = assets.(5) in
  ImageHandler.get_tile_image_x_y pizza (pizza_width / tsize) x y

let get_liq_tile x y tsize assets =
  let liq = assets.(5) in
  ImageHandler.get_tile_image_x_y liq (liq_width / tsize) x y

let get_image_from_tile assets tile tsize =
  match tile with
  | Blank ->
      Graphics.make_image (Array.make_matrix tsize tsize Graphics.transp)
  | Grass -> get_terrain_tile 0 2 tsize assets
  | TreeBot -> get_terrain_tile 0 1 tsize assets
  | TreeTop -> get_terrain_tile 0 0 tsize assets
  | Flower -> get_terrain_tile 3 1 tsize assets
  | Bush -> get_terrain_tile 1 1 tsize assets
  (* street.png *)
  | Sidewalk_Curved_BotLeft -> get_street_tile 17 4 tsize assets
  | Sidewalk_Curved_BotRight -> get_street_tile 21 4 tsize assets
  | Sidewalk_Curved_TopLeft -> get_street_tile 17 0 tsize assets
  | Sidewalk_Curved_TopRight -> get_street_tile 21 0 tsize assets
  | Sidewalk_Horiz -> get_street_tile 18 0 tsize assets
  | Sidewalk_Vert -> get_street_tile 17 1 tsize assets
  (* building.png *)
  | Building1_Left -> get_building_tile 0 0 tsize assets
  | Building1_Mid -> get_building_tile 1 0 tsize assets
  | Building1_Right -> get_building_tile 2 0 tsize assets
  | Building2_Left -> get_building_tile 0 3 tsize assets
  | Building2_Mid -> get_building_tile 1 3 tsize assets
  | Building2_Right -> get_building_tile 2 3 tsize assets
  | Roof -> get_building_tile 5 1 tsize assets
  | Roof_BotLeft -> get_building_tile 4 2 tsize assets
  | Roof_BotRight -> get_building_tile 6 2 tsize assets
  | Roof_TopLeft -> get_building_tile 4 0 tsize assets
  | Roof_TopRight -> get_building_tile 6 0 tsize assets
  | Roof_TopEdge -> get_building_tile 5 0 tsize assets
  | Roof_LeftEdge -> get_building_tile 4 1 tsize assets
  | Roof_BotEdge -> get_building_tile 5 2 tsize assets
  | Roof_RightEdge -> get_building_tile 6 1 tsize assets
  | DoorTop -> get_building_tile 10 7 tsize assets
  | DoorBot -> get_building_tile 10 8 tsize assets
  | BlueBook -> get_book_tile 3 0 tsize assets
  | Food _ -> get_pizza_tile 0 0 tsize assets
  | Water _ -> get_liq_tile 0 0 tsize assets
  | RedBook _ -> get_book_tile 0 0 tsize assets
  | YellowBook _ -> get_book_tile 1 0 tsize assets
  | GreenBook _ -> get_book_tile 2 0 tsize assets
  | PurpleBook _ -> get_book_tile 4 0 tsize assets

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
  Array.iteri (draw_tile_iter map assets) (get_layer_as_tiles map layer)

let y_offset row =
  let height = Position.y_dim / 32 in
  height - row - 1

let is_solid_tile map x y =
  let col = x / 32 in
  let row = y_offset (y / 32) in
  let tile1 = get_tile row col 1 map in
  let tile2 = get_tile row col 2 map in
  match tile1 with
  | SolidTile _ -> true
  | _ -> ( match tile2 with SolidTile _ -> true | _ -> false )

let is_door_tile map x y =
  let col = x / 32 in
  let row = y_offset (y / 32) in
  let tile1 = get_tile row col 1 map in
  let tile2 = get_tile row col 2 map in
  match tile1 with
  | DoorTile _ -> true
  | _ -> ( match tile2 with DoorTile _ -> true | _ -> false )

let is_item_tile tiletype =
  match tiletype with ItemTile _ -> true | _ -> false

let tile_effect tile = failwith "unimplemented"
