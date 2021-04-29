open Position
open Graphics
open ImageHandler

type t = {
  name : string;
  mutable tile_mem : World.tile;
  mutable pos_mem : Position.t;
  mutable rep : Graphics.image;
  pos : Position.t;
  speed : int;
}

type person =
  | Still
  | Up
  | Left
  | Right
  | Down

let draw t = Graphics.draw_image t.rep t.pos.x t.pos.y

let get_position c = c.pos

let get_size c = 50

let player_sprites = get_entire_image "assets/spr_player.png"

let world = World.map_from_json_file "realmap.json"

let get_person_image person =
  match person with
  | Still -> ImageHandler.get_tileset_part 16 16 15 17 player_sprites
  | Up -> ImageHandler.get_tileset_part 50 64 15 16 player_sprites
  | Left -> ImageHandler.get_tileset_part 50 32 15 17 player_sprites
  | Right -> ImageHandler.get_tileset_part 50 48 15 17 player_sprites
  | Down -> ImageHandler.get_tileset_part 48 16 15 17 player_sprites

let init_character () =
  {
    name = "bear";
    rep = get_person_image Still;
    pos = { x = 160; y = 160 };
    speed = 16;
    tile_mem = World.get_tile 10 10 world;
    pos_mem = { x = 160; y = 160 };
  }

let draw t = Graphics.draw_image t.rep t.pos.x t.pos.y

let move_up t =
  if t.pos.y < World.y_dim then begin
    World.draw_tile t.pos.x t.pos.y t.tile_mem world;
    t.pos_mem <- t.pos;
    t.tile_mem <-
      World.get_tile
        ((World.y_dim - t.pos.y + t.speed) / 16)
        (t.pos.x / 16) world;
    t.pos.y <- t.pos.y + t.speed;
    t.rep <- get_person_image Up;
    draw t
  end

let move_right t =
  if t.pos.x < World.x_dim then begin
    World.draw_tile t.pos.x t.pos.y t.tile_mem world;
    t.pos_mem <- t.pos;
    t.tile_mem <-
      World.get_tile
        ((World.y_dim - t.pos.y) / 16)
        ((t.pos.x + t.speed) / 16)
        world;
    t.pos.x <- t.pos.x + t.speed;
    t.rep <- get_person_image Right;
    draw t
  end

let move_down t =
  if t.pos.y > 0 then begin
    World.draw_tile t.pos.x t.pos.y t.tile_mem world;
    t.pos_mem <- t.pos;
    t.tile_mem <-
      World.get_tile
        ((World.y_dim - t.pos.y - t.speed) / 16)
        (t.pos.x / 15) world;
    t.pos.y <- t.pos.y - t.speed;
    t.rep <- get_person_image Down;
    draw t
  end

let move_left t =
  if t.pos.x > 0 then begin
    World.draw_tile t.pos.x t.pos.y t.tile_mem world;
    t.pos_mem <- t.pos;
    t.tile_mem <-
      World.get_tile
        ((World.y_dim - t.pos.y) / 16)
        ((t.pos.x - t.speed) / 16)
        world;
    t.pos.x <- t.pos.x - t.speed;
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

(* for drawing player *)
(* let get_user_rep = failwith "unimplemented" *)

let get_user_name t = t.name

(* val get_level: t -> how getting an item effect user *)
(* let aquire_item = failwith "unimplemented" *)
