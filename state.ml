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
open EndState

type level = {
  json : string;
  level : int;
  points : int;
  name : string;
}

type t = {
  world : World.t;
  current_area : AreaMap.t;
  character : Character.t;
  mutable items : Item.t;
  (* mutable gauges: Gauges.t *)
  mutable gauges : Gauges.t; (* mutable missions : Mission.t; *)
}

type key_module =
  | Item
  | Character
  | NoModule
  | Gauges

let eval_key key =
  match key with
  | 'a' -> Character
  | 's' -> Character
  | 'd' -> Character
  | 'w' -> Character
  | 'j' -> Item
  | 'l' -> Item
  | 'u' -> Gauges
  | _ -> NoModule

let init_game name png level level_png points =
  let world = World.load_world "worldmaps" in
  {
    world;
    current_area = World.get_start_map world;
    character = Character.init_character name png;
    items =
      Item.init_item
        (Yojson.Basic.from_file "item_type.json")
        (Yojson.Basic.from_file "item_init.json");
    gauges =
      Gauges.init_gauges (Yojson.Basic.from_file level_png) level
      (* missions = Mission.init_mission (); *);
  }

let draw t =
  Graphics.clear_graph ();

  (* Mission.draw_missions_window t.missions; *)
  Item.draw t.items;

  (* CHANGE THIS TO DRAW THE SPECIFIC LAYERS *)
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

let rec in_game name png level level_json points =
  let game_state = init_game name png level level_json points in
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
      try
        let s = Graphics.wait_next_event [ Graphics.Key_pressed ] in
        if s.Graphics.keypressed then
          let c = s.Graphics.key in
          match eval_key c with
          | Character ->
              Gauges.update_gauge General [ ("health", -10) ]
                game_state.gauges game_state.items;
              Character.move game_state.character s.Graphics.key
          | Item -> Item.item_command game_state.items c
          | Gauges -> Gauges.use_item game_state.items game_state.gauges
          | NoModule -> ()
        (* draw game_state *)
      with _ -> transition_in_game 1 "undecided" 1
    done
  with End -> end_game ()

(* type t_pos = { mutable x : int; mutable y : int; } *)

(* { character: Character; world: time: } *)

(* exception End *)

(* type level = | Sophomore = {} | Junior | Senior

   let level_student_mission level name = match (level, name) with |
   Sophomore, "undecided" -> "" | Junior, "undecided" -> "" | Senior,
   "undecided" -> "" | _ -> "" *)
and level_to_next level_num acc_points name =
  let next_level_num = level_num + 1 in
  match (next_level_num, name) with
  | 2, "undecided" ->
      {
        json = "missions/sophomore_undecided.json";
        level = next_level_num;
        points = acc_points;
        name;
      }
  | 3, "undecided" ->
      {
        json = "missions/junior_undecided.json";
        level = next_level_num;
        points = acc_points;
        name;
      }
  | 4, "undecided" ->
      {
        json = "missions/senior_undecided.json";
        level = next_level_num;
        points = acc_points;
        name;
      }
  | _, _ ->
      {
        json = "missions/sophomore_undecided.json";
        level = 0;
        points = acc_points;
        name;
      }

and draw_t () =
  let img = ImageHandler.get_entire_image "assets/transition_state.png" in
  let graphics_img = ImageHandler.get_tileset_part 0 0 800 576 img in
  Graphics.draw_image graphics_img 50 50

and transition_in_game level_num name points =
  try
    while true do
      draw_t ();
      let s = Graphics.wait_next_event [ Graphics.Button_down ] in
      if s.Graphics.button then Graphics.moveto 500 200;
      let x = fst (Graphics.mouse_pos ()) in
      let y = snd (Graphics.mouse_pos ()) in
      match (x, y) with
      | x, y when x > 335 && x < 487 && y > 281 && y < 306 ->
          let next_level = level_to_next level_num points name in
          if next_level.level > 0 then
            in_game "undecided" "assets/character/freshman.png"
              next_level.level next_level.json points
          else EndState.in_game points
      | _, _ -> ()
    done
  with End -> end_game ()

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
