(* interaction between key input, user, item, map *)
open Graphics
open Position
open Item
open Character
open Yojson.Basic
open ImageHandler
open World
open Mission

type t = {
  world : World.t;
  character : Character.t;
  mutable items : Item.ilist;
  (* mutable gauges: Gauges.t *)
  mutable gauges : Gauges.t;
  mutable missions : Mission.t;
}

let init_game () =
  {
    world = World.map_from_json_file "realmap.json";
    character = Character.init_character ();
    items =
      Item.init_item_list
        (Yojson.Basic.from_file "item.json")
        (Yojson.Basic.from_file "item_rep.json")
        (Yojson.Basic.from_file "item_init.json");
    gauges = Gauges.init_gauges (Yojson.Basic.from_file "gauges.json");
    missions = Mission.init_mission ();
  }

let draw t =
  Graphics.clear_graph ();

  Mission.draw_missions_window t.missions;
  Gauges.draw t.gauges;
  World.draw_tiles t.world;
  Item.draw_all t.items;
  Character.draw t.character;
  Item.draw_bag t.items

(* let draw_with_assets t assets = Graphics.clear_graph (); World.draw_tiles
   t.world; Item.draw_all t.items; Character.draw t.character *)

exception End

let end_game () = failwith "unimplemented"

let in_game () =
  let game_state = init_game () in
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
        match c with
        | 't' ->
            game_state.items <-
              Item.get_item game_state.items game_state.character;
            draw game_state
        | _ ->
            if
              not
                (Rect.will_enter_rect game_state.character.pos
                   Item.inventory_area c 16)
            then Character.move game_state.character s.Graphics.key
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
