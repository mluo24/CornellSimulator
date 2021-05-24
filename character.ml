open Position
open Graphics
open ImageHandler
open World
open AreaMap

(* CHANGES SO FAR: added mutable tile layer records, changed type of them to
   tile, added map to most things, changed the way character images are
   accessed*)

type t = {
  name : string;
  mutable layer1_tile_mem : tile;
  mutable layer2_tile_mem : tile;
  mutable rep : Graphics.image;
  png : string;
  pos : Position.t;
  speed : int;
}

type person = Position.direction

let draw t = Graphics.draw_image t.rep t.pos.x t.pos.y

let get_user_name t = t.name

let get_size t = 32

(* let player_image_size_width = fst (Images.size
   (ImageHandler.get_entire_image "assets/spr_player.png")) / 16 *)

(* let world = let json = Yojson.Basic.from_file "world_init.json" in
   AreaMap.map_from_json_file ( "worldmaps/" ^ (json |>
   Yojson.Basic.Util.member "start" |> Yojson.Basic.Util.to_string) ^ ".json"
   ) *)

let image_width png = fst (Images.size (ImageHandler.get_entire_image png))

let get_person_pose x y png =
  let width = image_width png in
  let character_tileset = ImageHandler.load_tileset png 32 in
  ImageHandler.get_tile_image_x_y character_tileset (width / 32) x y

let get_person_image png person =
  match person with
  | Still -> get_person_pose 1 1 png
  | Up -> get_person_pose 3 4 png
  | Left -> get_person_pose 3 2 png
  | Right -> get_person_pose 3 3 png
  | Down -> get_person_pose 3 1 png

(* let x_offset col = let width = Position.x_dim / 32 in width - col *)

let y_offset row =
  let height = Position.y_dim / 32 in
  height - row - 1

let get_tile_from_coords x y layer map =
  let col = x / 32 in
  let row = y_offset (y / 32) in
  get_tile_as_tile row col layer map

let initial_spawn = { x = 352; y = 416 }

let init_character name png map =
  {
    name;
    rep = get_person_image png Still;
    pos = initial_spawn;
    speed = 32;
    png;
    layer1_tile_mem =
      get_tile_from_coords initial_spawn.x initial_spawn.y 1 map;
    layer2_tile_mem =
      get_tile_from_coords initial_spawn.x initial_spawn.y 2 map
      (* TO DOOOOO: this needs to be fixed after tiles are adjusted 32 by 32*);
  }

let move_up t map assets =
  let new_pos = t.pos.y + t.speed in
  if t.pos.y < Position.y_dim - 32 && not (is_solid_tile map t.pos.x new_pos)
  then begin
    draw_tile t.pos.x t.pos.y t.layer1_tile_mem map assets;
    draw_tile t.pos.x t.pos.y t.layer2_tile_mem map assets;
    (* World.draw_tile t.pos.x t.pos.y t.tile_mem world; *)
    (* t.tile_mem <- World.get_tile ((World.y_dim - t.pos.y - 16) / 16)
       (t.pos.x / 16) world; *)
    t.rep <- get_person_image t.png Up;
    t.pos.y <- new_pos;
    draw t;
    t.layer2_tile_mem <- get_tile_from_coords t.pos.x new_pos 2 map;
    draw_tile t.pos.x new_pos t.layer2_tile_mem map assets;
    t.layer1_tile_mem <- get_tile_from_coords t.pos.x t.pos.y 1 map
  end

let move_right t map assets =
  let new_pos = t.pos.x + t.speed in
  if t.pos.x < Position.x_dim - 32 && not (is_solid_tile map new_pos t.pos.y)
  then begin
    draw_tile t.pos.x t.pos.y t.layer1_tile_mem map assets;
    draw_tile t.pos.x t.pos.y t.layer2_tile_mem map assets;
    (* World.draw_tile t.pos.x t.pos.y t.tile_mem world; *)
    (* t.tile_mem <- World.get_tile ((World.y_dim - t.pos.y - 16) / 16)
       (t.pos.x / 16) world; *)
    t.pos.x <- new_pos;
    t.rep <- get_person_image t.png Right;
    draw t;
    t.layer2_tile_mem <- get_tile_from_coords new_pos t.pos.y 2 map;
    draw_tile new_pos t.pos.y t.layer2_tile_mem map assets;
    (* print_endline (string_of_int (new_pos / 32) ^ " " ^ string_of_int
       (t.pos.y / 32)); *)
    t.layer1_tile_mem <- get_tile_from_coords t.pos.x t.pos.y 1 map
  end

let move_down t map assets =
  let new_pos = t.pos.y - t.speed in
  if t.pos.y > 0 && not (is_solid_tile map t.pos.x new_pos) then begin
    draw_tile t.pos.x t.pos.y t.layer1_tile_mem map assets;
    draw_tile t.pos.x t.pos.y t.layer2_tile_mem map assets;
    (* World.draw_tile t.pos.x t.pos.y t.tile_mem world; *)
    (* t.tile_mem <- World.get_tile ((World.y_dim - t.pos.y - 16) / 16)
       (t.pos.x / 16) world; *)
    t.rep <- get_person_image t.png Down;
    t.pos.y <- new_pos;
    draw t;
    t.layer2_tile_mem <- get_tile_from_coords t.pos.x new_pos 2 map;
    draw_tile t.pos.x new_pos t.layer2_tile_mem map assets;
    t.layer1_tile_mem <- get_tile_from_coords t.pos.x t.pos.y 1 map
  end

let move_left t map assets =
  let new_pos = t.pos.x - t.speed in
  if t.pos.x > 0 && not (is_solid_tile map new_pos t.pos.y) then begin
    draw_tile t.pos.x t.pos.y t.layer1_tile_mem map assets;
    draw_tile t.pos.x t.pos.y t.layer2_tile_mem map assets;
    (* World.draw_tile t.pos.x t.pos.y t.tile_mem world; *)
    (* t.tile_mem <- World.get_tile ((World.y_dim - t.pos.y - 16) / 16)
       (t.pos.x / 16) world; *)
    t.rep <- get_person_image t.png Left;
    t.pos.x <- new_pos;
    draw t;
    t.layer2_tile_mem <- get_tile_from_coords t.pos.x t.pos.y 2 map;
    draw_tile t.pos.x t.pos.y t.layer2_tile_mem map assets;
    t.layer1_tile_mem <- get_tile_from_coords t.pos.x t.pos.y 1 map
  end

let move (t : t) c map assets =
  match c with
  | 'w' -> move_up t map assets
  | 'd' -> move_right t map assets
  | 's' -> move_down t map assets
  | 'a' -> move_left t map assets
  | _ -> ()
