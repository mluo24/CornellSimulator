(* interaction between key input, user, item, map *)
open Graphics
open Position
open Item
open Character
open Yojson.Basic
open ImageHandler
open World
open AreaMap
open Rect
open EndState

type t = {
  world : World.t;
  mutable current_area : AreaMap.t;
  character : Character.t;
  mutable items : Item.t;
  mutable gauges : Gauges.t;
}

type key_module =
  | Item
  | Character
  | NoModule
  | Gauges

type level = {
  json : string;
  level : int;
  points : int;
  name : string;
}

let eval_key key =
  match key with
  | 'a' -> Character
  | 's' -> Character
  | 'd' -> Character
  | 'w' -> Character
  | 'j' -> Item
  | 'l' -> Item
  | 'k' -> Item
  | 'u' -> Gauges
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
    gauges = Gauges.init_gauges (Yojson.Basic.from_file level_png) level;
  }

let draw t =
  Graphics.clear_graph ();
  Item.draw t.items;
  AreaMap.draw_layer t.current_area 1 (get_assets t.world);
  Character.draw t.character;
  AreaMap.draw_layer t.current_area 2 (get_assets t.world);
  Gauges.draw t.gauges

let draw_t () =
  let img = ImageHandler.get_entire_image "assets/transition_state.png" in
  let graphics_img = ImageHandler.get_tileset_part 0 0 800 576 img in
  Graphics.draw_image graphics_img 50 50

exception End

let y_offset row =
  let height = Position.y_dim / 32 in
  height - row - 1

let change_room state world tiletype =
  match tiletype with
  | DoorTile (exitname, pos, tile) ->
      state.current_area <- get_map world exitname;
      draw state
  | _ -> failwith "not possible"

let level_to_next level_num acc_points name =
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

let character_action game_state s =
  Gauges.update_gauge General [ ("health", -5) ] game_state.gauges
    game_state.items;
  Character.move game_state.character s.Graphics.key game_state.current_area
    (get_assets game_state.world);
  let x = game_state.character.pos.x in
  let y = game_state.character.pos.y in
  if is_door_tile game_state.current_area x y then (
    let col = x / 32 in
    let row = y_offset (y / 32) in
    change_room game_state game_state.world
      (get_tile row col 1 game_state.current_area);
    refresh_character game_state.character game_state.current_area
      (get_assets game_state.world) )

let item_action game_state c =
  let x = game_state.character.pos.x in
  let y = game_state.character.pos.y in
  let col = x / 32 in
  let row = y_offset (y / 32) in
  Item.item_command game_state.items c game_state.current_area row col
    (get_tile row col 2 game_state.current_area);
  refresh_character game_state.character game_state.current_area
    (get_assets game_state.world)

let rec in_game name png level level_json points =
  let game_state = init_game name png level level_json points in
  draw game_state;
  try
    while true do
      try
        let s = Graphics.wait_next_event [ Graphics.Key_pressed ] in
        if s.Graphics.keypressed then
          let c = s.Graphics.key in
          match eval_key c with
          | Character -> character_action game_state s
          | Item -> item_action game_state c
          | Gauges -> Gauges.use_item game_state.items game_state.gauges
          | NoModule -> ()
      with _ -> transition_in_game level name points
    done
  with End -> ()

and transition_in_game level_num name points =
  try
    while true do
      draw_t ();
      let s = Graphics.wait_next_event [ Graphics.Button_down ] in
      if s.Graphics.button then
        let x = fst (Graphics.mouse_pos ()) in
        let y = snd (Graphics.mouse_pos ()) in
        match (x, y) with
        | x, y when x > 0 && x < 500 && y > 0 && y < 700 ->
            let next_level = level_to_next level_num points name in
            if next_level.level > 0 then
              in_game "undecided" "assets/character/freshman.png"
                next_level.level next_level.json points
            else EndState.in_game points
        | _, _ -> ()
    done
  with End -> ()
