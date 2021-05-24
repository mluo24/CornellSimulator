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
  current_area : AreaMap.t;
  character : Character.t;
  mutable items : Item.t;
  (* mutable gauges: Gauges.t *)
  mutable gauges : Gauges.t;
  mutable missions : Mission.t;
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

let init_game name png =
  let world = World.load_world "worldmaps" in
  {
    world;
    current_area = World.get_start_map world;
    character = Character.init_character name png;
    items =
      Item.init_item
        (Yojson.Basic.from_file "item_type.json")
        (Yojson.Basic.from_file "item_init.json");
    gauges = Gauges.init_gauges (Yojson.Basic.from_file "gauges.json");
    missions = Mission.init_mission ();
  }

let draw t =
  Graphics.clear_graph ();

  Mission.draw_missions_window t.missions;
  Item.draw t.items;

  (* CHANGE THIS TO DRAW THE SPECIFIC LAYERS *)
  AreaMap.draw_tiles t.current_area (get_assets t.world);
  (* Item.draw t.items; *)
  Character.draw t.character;
  (* Item.draw t.items; *)
  Gauges.draw t.gauges

(* let draw_with_assets t assets = Graphics.clear_graph (); World.draw_tiles
   t.world; Item.draw_all t.items; Character.draw t.character *)

exception End

let end_game () = failwith "unimplemented"

let in_game name png =
  let game_state = init_game name png in
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
        | Character -> Character.move game_state.character s.Graphics.key
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
