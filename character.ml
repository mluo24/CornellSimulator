open Position
open Graphics
<<<<<<< HEAD
open Imgdemo
open World
=======
open ImageHandler
>>>>>>> dc05468668f64479c6da4f1444248db71e66f032

type t = {
  name : string;
  (*mutable mem : Word.tile;*)
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

let player_sprites = get_entire_image "assets/spr_player.png"

let get_person_image person =
  match person with
<<<<<<< HEAD
  (* 16 16 15 17*)
  | Still -> Imgdemo.get_tileset_part 16 16 15 17 "assets/spr_player.png"
  | Up -> Imgdemo.get_tileset_part 50 64 15 16 "assets/spr_player.png"
  | Left -> Imgdemo.get_tileset_part 50 32 15 17 "assets/spr_player.png"
  | Right -> Imgdemo.get_tileset_part 50 48 15 17 "assets/spr_player.png"
  | Down -> Imgdemo.get_tileset_part 48 16 15 17 "assets/spr_player.png"
=======
  | Still -> ImageHandler.get_tileset_part 16 16 15 17 player_sprites
  | Up -> ImageHandler.get_tileset_part 50 64 15 16 player_sprites
  | Left -> ImageHandler.get_tileset_part 50 32 15 17 player_sprites
  | Right -> ImageHandler.get_tileset_part 50 48 15 17 player_sprites
  | Down -> ImageHandler.get_tileset_part 48 16 15 17 player_sprites
>>>>>>> dc05468668f64479c6da4f1444248db71e66f032

let init_character () =
  {
    name = "bear";
    rep = get_person_image Still;
    pos = { x = 30; y = 30 };
    speed = 15;
  }

let draw t = Graphics.draw_image t.rep t.pos.x t.pos.y

let move_up t =
  let old_pos = t.pos in
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
