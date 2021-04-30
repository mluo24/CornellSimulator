open Position
open Graphics
open ImageHandler

type t = {
  name : string;
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

let get_position c = c.pos

let get_size c = 50

let size = 16

let player_sprites = ImageHandler.load_tileset "assets/spr_player.png" size

let player_image_size_width = fst (Images.size 
  (ImageHandler.get_entire_image "assets/spr_player.png")) / size

let get_person_image person =
  match person with
  | Still -> ImageHandler.get_tile_image_x_y player_sprites 
  player_image_size_width 1 1
  | Up -> ImageHandler.get_tile_image_x_y player_sprites 
  player_image_size_width 2 4
  | Left -> ImageHandler.get_tile_image_x_y player_sprites 
  player_image_size_width 2 2
  | Right -> ImageHandler.get_tile_image_x_y player_sprites 
  player_image_size_width 2 3
  | Down -> ImageHandler.get_tile_image_x_y player_sprites 
  player_image_size_width 2 1
  (* | Still -> ImageHandler.get_tileset_part 16 16 15 17 player_sprites
  | Up -> ImageHandler.get_tileset_part 50 64 15 16 player_sprites
  | Left -> ImageHandler.get_tileset_part 50 32 15 17 player_sprites
  | Right -> ImageHandler.get_tileset_part 50 48 15 17 player_sprites
  | Down -> ImageHandler.get_tileset_part 48 16 15 17 player_sprites *)

let init_character () =
  {
    name = "bear";
    rep = get_person_image Still;
    pos = { x = 30; y = 60 };
    speed = 10;
  }

let move_up t =
  if t.pos.y < World.y_dim then t.pos.y <- t.pos.y + t.speed;
  t.rep <- get_person_image Up

let move_right t =
  if t.pos.x < World.x_dim then t.pos.x <- t.pos.x + t.speed;
  t.rep <- get_person_image Right

let move_down t =
  if t.pos.y > 0 then t.pos.y <- t.pos.y - t.speed;
  t.rep <- get_person_image Down

let move_left t =
  if t.pos.x > 0 then t.pos.x <- t.pos.x - t.speed;
  t.rep <- get_person_image Left

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

let draw t = Graphics.draw_image t.rep t.pos.x t.pos.y
