(* interaction between key input, user, item, map *)
open Graphics
open Position
open Item
open Character
open Yojson.Basic
open ImageHandler
open World
open AreaMap
open Mission
open Rect

type t = {
  world : World.t;
  mutable current_area : AreaMap.t;
  character : Character.t;
  mutable items : Item.t;
  (* mutable gauges: Gauges.t *)
  mutable gauges : Gauges.t; (* mutable missions : Mission.t; *)
}

type key_module =
  | Item
  | Character
  | NoModule

let eval_key key =
  match key with
  | 'a' -> Character
  | 's' -> Character
  | 'd' -> Character
  | 'w' -> Character
  | 'j' -> Item
  | 'l' -> Item
  | 'k' -> Item
  | _ -> NoModule

let init_game name png level level_png points =
  let world = World.load_world "worldmaps" in
  let current_area = World.get_start_map world in
  {
    world;
    current_area;
    character = Character.init_character name png current_area;
    items =
      Item.init_item
        (Yojson.Basic.from_file "item_type.json")
        (Yojson.Basic.from_file "item_init.json");
    gauges =
      Gauges.init_gauges (Yojson.Basic.from_file level_png)
      (* missions = Mission.init_mission (); *);
  }

let draw t =
  Graphics.clear_graph ();

  (* Mission.draw_missions_window t.missions; *)
  Item.draw t.items;

  AreaMap.draw_layer t.current_area 1 (get_assets t.world);
  (* Item.draw t.items; *)
  Character.draw t.character;
  AreaMap.draw_layer t.current_area 2 (get_assets t.world);
  (* Item.draw t.items; *)
  Gauges.draw t.gauges

(* let draw_with_assets t assets = Graphics.clear_graph (); World.draw_tiles
   t.world; Item.draw_all t.items; Character.draw t.character *)

exception End

let end_game () = failwith "unimplemented"

let y_offset row =
  let height = Position.y_dim / 32 in
  height - row - 1

let change_room state world tiletype =
  match tiletype with
  | DoorTile (exitname, pos, tile) ->
      state.current_area <- get_map world exitname;
      draw state
  | _ -> failwith "not possible"

let in_game name png level level_png points =
  let game_state = init_game name png level level_png points in
  (* let tilesize = get_tile_size game_state.world in *)
  (* let terrain_tileset = ImageHandler.load_tileset "assets/Terrain.png"
     tilesize in let street_tileset = ImageHandler.load_tileset
     "assets/Street.png" tilesize in let building_tileset =
     ImageHandler.load_tileset "assets/Building.png" tilesize in let
     character_tileset = ImageHandler.load_tileset "assets/spr_player.png"
     tilesize in let assets = [|terrain_tileset; street_tileset;
     building_tileset; character_tileset|] in *)
  (* draw_with_assets game_state assets; *)
  draw game_state;
  try
    while true do
      let s = Graphics.wait_next_event [ Graphics.Key_pressed ] in
      if s.Graphics.keypressed then
        let c = s.Graphics.key in
        match eval_key c with
        | Character ->
            Character.move game_state.character s.Graphics.key
              game_state.current_area
              (get_assets game_state.world);
            let x = game_state.character.pos.x in
            let y = game_state.character.pos.y in
            if is_door_tile game_state.current_area x y then
              let col = x / 32 in
              let row = y_offset (y / 32) in
              change_room game_state game_state.world
                (get_tile row col 1 game_state.current_area)
        | Item -> Item.item_command game_state.items c
        | NoModule -> ()
      (* draw game_state *)
    done
  with End -> end_game ()

(* type t_pos = { mutable x : int; mutable y : int; } *)

(* { character: Character; world: time: } *)

(* exception End *)

(* let key_input key init the_end = init; try while true do try let s =
   Graphics.wait_next_event [ Graphics.Key_pressed ] in if
   s.Graphics.keypressed then key s.Graphics.key else print_string "Wrong key.
   You can only use char keys!" with End -> the_end done with End -> the_end

   let dot s = Graphics.set_color black; Graphics.fill_circle s.x s.y 20

   let dot_init s = dot s

   let redraw_dot s = Graphics.clear_graph (); dot s

   let dot_end = Graphics.close_graph (); print_string "End of dot."

   let move_key s c = redraw_dot s; match c with | 'w' -> if s.y < 400 then
   s.y <- s.y + 1 | 'd' -> if s.x > 0 then s.x <- s.x + 1 | 's' -> if s.y > 0
   then s.y <- s.y - 1 | 'a' -> if s.x < 800 then s.x <- s.x - 1 | 'e' ->
   dot_end | _ -> () *)
