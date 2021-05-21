open Position
open Graphics
open ImageHandler

type t = {
  name : string;
  mutable tile_mem : World.tile;
  mutable rep : Graphics.image;
  pos : Position.t;
  speed : int;
}

type person = Position.direction

let draw t = Graphics.draw_image t.rep t.pos.x t.pos.y

let get_user_name t = t.name

let get_size t = 16

let player_sprites = ImageHandler.load_tileset "assets/spr_player.png" 16

let player_image_size_width =
  fst (Images.size (ImageHandler.get_entire_image "assets/spr_player.png"))
  / 16

let world = World.map_from_json_file "realmap.json"

let get_person_image person =
  match person with
  | Still ->
      ImageHandler.get_tile_image_x_y player_sprites player_image_size_width 1
        1
  | Up ->
      ImageHandler.get_tile_image_x_y player_sprites player_image_size_width 2
        4
  | Left ->
      ImageHandler.get_tile_image_x_y player_sprites player_image_size_width 2
        2
  | Right ->
      ImageHandler.get_tile_image_x_y player_sprites player_image_size_width 2
        3
  | Down ->
      ImageHandler.get_tile_image_x_y player_sprites player_image_size_width 2
        1

(* | Still -> ImageHandler.get_tileset_part 16 16 15 17 player_sprites | Up ->
   ImageHandler.get_tileset_part 50 64 15 16 player_sprites | Left ->
   ImageHandler.get_tileset_part 50 32 15 17 player_sprites | Right ->
   ImageHandler.get_tileset_part 50 48 15 17 player_sprites | Down ->
   ImageHandler.get_tileset_part 48 16 15 17 player_sprites *)

let init_character () =
  {
    name = "bear";
    rep = get_person_image Still;
    pos = { x = 160; y = 256 };
    speed = 16;
    tile_mem = World.get_tile 9 10 world;
  }

let move_up t =
  if t.pos.y < World.y_dim - 16 then begin
    World.draw_tile t.pos.x t.pos.y t.tile_mem world;
    t.pos.y <- t.pos.y + t.speed;
    t.tile_mem <-
      World.get_tile ((World.y_dim - t.pos.y - 16) / 16) (t.pos.x / 16) world;
    t.rep <- get_person_image Up;
    draw t
  end

let move_right t =
  if t.pos.x < World.x_dim - 16 then begin
    World.draw_tile t.pos.x t.pos.y t.tile_mem world;
    t.pos.x <- t.pos.x + t.speed;
    t.tile_mem <-
      World.get_tile ((World.y_dim - t.pos.y - 16) / 16) (t.pos.x / 16) world;
    t.rep <- get_person_image Right;
    draw t
  end

let move_down t =
  if t.pos.y > 0 then begin
    World.draw_tile t.pos.x t.pos.y t.tile_mem world;
    t.pos.y <- t.pos.y - t.speed;
    t.tile_mem <-
      World.get_tile ((World.y_dim - t.pos.y - 16) / 16) (t.pos.x / 16) world;
    t.rep <- get_person_image Down;
    draw t
  end

let move_left t =
  if t.pos.x > 0 then begin
    World.draw_tile t.pos.x t.pos.y t.tile_mem world;
    t.pos.x <- t.pos.x - t.speed;
    t.tile_mem <-
      World.get_tile ((World.y_dim - t.pos.y - 16) / 16) (t.pos.x / 16) world;
    t.rep <- get_person_image Left;
    draw t
  end

let move (t : t) c =
  match c with
  | 'w' -> move_up t
  | 'd' -> move_right t
  | 's' -> move_down t
  | 'a' -> move_left t
  | _ -> ()
