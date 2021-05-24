open Position
open Graphics
open ImageHandler
open World

type t = {
  name : string;
  mutable tile_mem : Graphics.image;
  mutable rep : Graphics.image;
  png : string;
  pos : Position.t;
  speed : int;
}

type person = Position.direction

let draw t = Graphics.draw_image t.rep t.pos.x t.pos.y

let get_user_name t = t.name

let get_size t = 32

let player_image_size_width =
  fst (Images.size (ImageHandler.get_entire_image "assets/spr_player.png"))
  / 16

let world =
  let json = Yojson.Basic.from_file "world_init.json" in
  AreaMap.map_from_json_file
    ( "worldmaps/"
    ^ (json |> Yojson.Basic.Util.member "start" |> Yojson.Basic.Util.to_string)
    ^ ".json" )

let get_person_pose x y w h png =
  ImageHandler.get_tileset_part x y w h (ImageHandler.get_entire_image png)

let get_person_image png person =
  match person with
  | Still -> get_person_pose 36 36 32 32 png
  | Up -> get_person_pose 96 128 32 32 png
  | Left -> get_person_pose 96 64 32 32 png
  | Right -> get_person_pose 96 96 32 32 png
  | Down -> get_person_pose 96 32 32 32 png

let init_character name png =
  {
    name;
    rep = get_person_image png Still;
    pos = { x = 160; y = 256 };
    speed = 32;
    png;
    tile_mem =
      Graphics.get_image 100 100 32 32
      (* TO DOOOOO: this needs to be fixed after tiles are adjusted 32 by 32*);
  }

let move_up t =
  if t.pos.y < Position.y_dim - 16 then begin
    Graphics.draw_image t.tile_mem t.pos.x t.pos.y;
    (* World.draw_tile t.pos.x t.pos.y t.tile_mem world; *)
    t.pos.y <- t.pos.y + t.speed;
    t.tile_mem <- Graphics.get_image t.pos.x t.pos.y 32 32;
    (* t.tile_mem <- World.get_tile ((World.y_dim - t.pos.y - 16) / 16)
       (t.pos.x / 16) world; *)
    t.rep <- get_person_image t.png Up;
    draw t
  end

let move_right t =
  if t.pos.x < Position.x_dim - 16 then begin
    Graphics.draw_image t.tile_mem t.pos.x t.pos.y;
    (* World.draw_tile t.pos.x t.pos.y t.tile_mem world; *)
    t.pos.x <- t.pos.x + t.speed;
    t.tile_mem <- Graphics.get_image t.pos.x t.pos.y 32 32;
    (* t.tile_mem <- World.get_tile ((World.y_dim - t.pos.y - 16) / 16)
       (t.pos.x / 16) world; *)
    t.rep <- get_person_image t.png Right;
    draw t
  end

let move_down t =
  if t.pos.y > 0 then begin
    Graphics.draw_image t.tile_mem t.pos.x t.pos.y;
    (* World.draw_tile t.pos.x t.pos.y t.tile_mem world; *)
    t.pos.y <- t.pos.y - t.speed;
    t.tile_mem <- Graphics.get_image t.pos.x t.pos.y 32 32;
    (* t.tile_mem <- World.get_tile ((World.y_dim - t.pos.y - 16) / 16)
       (t.pos.x / 16) world; *)
    t.rep <- get_person_image t.png Down;
    draw t
  end

let move_left t =
  if t.pos.x > 0 then begin
    Graphics.draw_image t.tile_mem t.pos.x t.pos.y;
    (* World.draw_tile t.pos.x t.pos.y t.tile_mem world; *)
    t.pos.x <- t.pos.x - t.speed;
    t.tile_mem <- Graphics.get_image t.pos.x t.pos.y 32 32;
    (* t.tile_mem <- World.get_tile ((World.y_dim - t.pos.y - 16) / 16)
       (t.pos.x / 16) world; *)
    t.rep <- get_person_image t.png Left;
    draw t
  end

let move (t : t) c =
  match c with
  | 'w' -> move_up t
  | 'd' -> move_right t
  | 's' -> move_down t
  | 'a' -> move_left t
  | _ -> ()
