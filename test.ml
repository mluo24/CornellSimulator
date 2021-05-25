open OUnit2
open World
open AreaMap
open Character
open Position
open State
open Graphics
open GameDataStructure

(********************************************************************
   OUR APPROACH TO TESTING/TEST PLAN
 ********************************************************************)
(* Our approach to testing consisted of unit testing and through viewing
   results on the graphics panel. Because a there is a lot of backend in our
   code that would not really be shown to the user, we mainly tested that. We
   used glass box testing as there were a lot of internal parts in the body of
   the function that were not necessarily exposed in the documentation that we
   should test. For some of the graphics content, it was more randomized.

   Testing was rather difficult because of the fact that a lot of the
   functions heavily relied on the graphics window being open, and most of the
   operations done there. Therefore, the tests would likely fail due to
   needing to open the graphics screen. As well, especially in the
   ImageHandler module, it is heavily reliant on such external library types
   that we trust to work, so we would not have to test those return types
   specifically.

   Partially as a result of that, some tests we omitted because they directly
   relate to the graphics panel, which we do not believe we can really confirm
   through running unit tests. Since we can easily confirm this visually,
   especially in the functions that require using pictures that we can see
   being draw on the graphics panel, there is no need to write test cases for
   this. As well, some functions return a specific type that is defined in the
   module, which in this case is obscured from the client. Therefore, we
   "test" those through the other methods to make sure it has been defined
   properly. One module that we did not test as throughly was State,
   especially because it is meant as a container to hold all of the other
   modules, and if their functions are working, State is more than likely
   working. As well, State directly controls what is being shown and the
   behavior of the game, which would seem quite obvious to the player, so we
   tested it like that.

   Therefore, the combination of having our eyes see what we would like and
   having correct written unit tests demonstrates the correctness of the
   system. The game is supposed to be graphically based and visual. Because
   the game works correctly from a visual and player standpoint, and the basic
   tests that in this file all pass, this system is very likely to be correct. *)

let area_test_int_to_tile name i expected_output =
  name >:: fun _ -> assert_equal expected_output (int_to_tile i)

let area_test_tile_type_of_tile name tile expected_output =
  name >:: fun _ -> assert_equal expected_output (tile_type_of_tile tile)

let area_test_get_layer name map layer expected_output =
  name >:: fun _ -> assert_equal expected_output (get_layer map layer)

let area_test_get_tile name row col layer map expected_output =
  name >:: fun _ -> assert_equal expected_output (get_tile row col layer map)

let area_test_get_rows name map expected_output =
  name >:: fun _ ->
  assert_equal expected_output (get_rows map) ~printer:string_of_int

let area_test_get_cols name map expected_output =
  name >:: fun _ ->
  assert_equal expected_output (get_cols map) ~printer:string_of_int

let area_test_get_tile_size name map expected_output =
  name >:: fun _ ->
  assert_equal expected_output (get_tile_size map) ~printer:string_of_int

let area_test_is_solid_tile name map x y expected_output =
  name >:: fun _ -> assert_equal expected_output (is_solid_tile map x y)

let area_test_is_door_tile name map x y expected_output =
  name >:: fun _ -> assert_equal expected_output (is_door_tile map x y)

let blank = map_from_json_file "testworlds/blankmap.json"

let map1 = map_from_json_file "testworlds/testmap.json"

let map2 = map_from_json_file "testworlds/realmap.json"

let map_size_32 = map_from_json_file "testworlds/32.json"

let area_tests =
  [
    area_test_int_to_tile "0 gives blank" 0 Blank;
    area_test_int_to_tile "1 gives grass" 1 Grass;
    area_test_int_to_tile "27 gives top of door" 27 DoorTop;
    area_test_int_to_tile "28 gives bottom of door" 28 DoorBot;
    area_test_tile_type_of_tile "Grass is standard tile" Grass
      (StandardTile Grass);
    area_test_tile_type_of_tile "Bush is solid tile" Bush (SolidTile Bush);
    area_test_tile_type_of_tile "DoorTop is door tile" DoorTop
      (DoorTile ("classroom", { x = 0; y = 0 }, DoorTop));
    area_test_tile_type_of_tile "Grass is standard tile" Grass
      (StandardTile Grass);
    area_test_tile_type_of_tile "Bush is solid tile" Bush (SolidTile Bush);
    area_test_tile_type_of_tile "DoorTop is door tile" DoorTop
      (DoorTile ("classroom", { x = 0; y = 0 }, DoorTop));
    area_test_tile_type_of_tile "RedBook is item tile" (RedBook "red_book")
      (ItemTile ("red_book", RedBook "red_book"));
    area_test_get_layer "empty file gives empty array" blank 1
      (Array.make 0 (StandardTile Blank));
    area_test_get_layer "testmap.json" map1 1
      (Array.map tile_type_of_tile
         (Array.map int_to_tile
            [|
              1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 1; 3; 1; 3; 3; 3; 1; 1; 1;
              3; 3; 3; 3; 3; 3; 3; 3; 1; 2; 2; 2; 2; 2; 2; 2; 2; 2; 2; 1; 1;
              1; 1; 1; 1; 2; 1; 1; 1; 1; 1; 1; 1; 1; 1; 2; 1; 1; 1; 1; 1; 1;
              1; 1; 1; 2; 1; 1; 1;
            |]));
    area_test_get_tile "empty map will give blank tile" 0 0 1 blank
      (StandardTile Blank);
    area_test_get_tile "map1 (0, 0) gives " 0 0 1 map1 (StandardTile Grass);
    area_test_get_tile "map1 (2, 3) gives " 2 3 1 map1 (StandardTile TreeTop);
    area_test_get_tile "map2 (0, 0) gives " 0 0 1 map2 (StandardTile Grass);
    area_test_get_tile "map2 (19, 6) gives " 19 6 1 map2
      (StandardTile Sidewalk_Curved_TopLeft);
    area_test_get_rows "empty map will give 0 rows" blank 0;
    area_test_get_rows "map1 will give 7 rows" map1 7;
    area_test_get_rows "map2 will give 35 rows" map2 35;
    area_test_get_cols "empty map will give 10 cols" blank 0;
    area_test_get_cols "map1 will give 0 cols" map1 10;
    area_test_get_cols "map2 will give 0 cols" map2 50;
    area_test_get_tile_size "blank has 1x1 tile size" blank 1;
    area_test_get_tile_size "map2 has 16x16 tile size" map2 16;
    area_test_get_tile_size "map_size_32 has 32x32 tile size" map_size_32 32;
    area_test_is_solid_tile "area here is solid tile" map_size_32 160 256 true;
    area_test_is_solid_tile "area here is not solid tile" map_size_32 0 0
      false;
    area_test_is_door_tile "area here is door tile" map_size_32 224 224 true;
    area_test_is_door_tile "area here is not door tile" map_size_32 0 0 false;
  ]

let testworld = load_world "testworlds"

let world_test_get_map name map_name world expected_output =
  name >:: fun _ -> assert_equal expected_output (get_map map_name world)

let world_test_get_start_map name world expected_output =
  name >:: fun _ -> assert_equal expected_output (get_start_map world)

let world_tests =
  [
    world_test_get_map "testworld can give blank" testworld "blankmap" blank;
    world_test_get_start_map "start is 32" testworld map_size_32;
  ]

(* CHARACTER TESTS *)

let () = Graphics.open_graph ""

let create_person position =
  {
    name = "person";
    layer1_tile_mem = Blank;
    layer2_tile_mem = Blank;
    rep = Character.get_person_image "assets/character/engineer.png" Still;
    png = "assets/character/engineer.png";
    pos = { x = position.x; y = position.y };
    speed = 32;
  }

let person_1 () = create_person { x = 500; y = 200 }

let person_2 () =
  create_person { x = Position.x_dim - 32; y = Position.y_dim - 32 }

let person_3 () = create_person { x = 0; y = 0 }

let game_state =
  State.init_game "undecided" "assets/character/engineer.png" 1
    "missions/freshman_undecided.json" 0

let move_test_pos name k expected_output p =
  let person = p () in
  let world = World.load_world "worldmaps" in
  Character.move person k (World.get_start_map world) (get_assets world);
  name >:: fun _ ->
  assert_equal expected_output.x person.pos.x ~printer:string_of_int;
  assert_equal expected_output.y person.pos.y ~printer:string_of_int

let character_tests =
  [
    move_test_pos "move person_1 left with key a" 'a'
      { x = (person_1 ()).pos.x - 32; y = (person_1 ()).pos.y }
      person_1;
    move_test_pos "move person_1 right one with key d" 'd'
      { x = (person_1 ()).pos.x + 32; y = (person_1 ()).pos.y }
      person_1;
    move_test_pos "move person_1 down one with key s" 's'
      { x = (person_1 ()).pos.x; y = (person_1 ()).pos.y - 32 }
      person_1;
    move_test_pos "move person_1 up one with key w" 'w'
      { x = (person_1 ()).pos.x; y = (person_1 ()).pos.y + 32 }
      person_1;
    move_test_pos "person_1 will not move with key z" 'z'
      { x = (person_1 ()).pos.x; y = (person_1 ()).pos.y }
      person_1;
    move_test_pos "person_2 can't move any further right with key d" 'd'
      { x = Position.x_dim - 32; y = Position.y_dim - 32 }
      person_2;
    move_test_pos "person_2 can't move any further up with key w" 'w'
      { x = Position.x_dim - 32; y = Position.y_dim - 32 }
      person_2;
    move_test_pos "person_2 can move down" 's'
      { x = Position.x_dim - 32; y = Position.y_dim - 64 }
      person_2;
    move_test_pos "person_2 can move left" 'a'
      { x = Position.x_dim - 64; y = Position.y_dim - 32 }
      person_2;
    move_test_pos "person_2 can not move with key z" 'z'
      { x = Position.x_dim - 32; y = Position.y_dim - 32 }
      person_2;
    move_test_pos "person_3 can't move any further left with key a" 'a'
      { x = 0; y = 0 } person_3;
    move_test_pos "person_3 can't move any further down with key s" 's'
      { x = 0; y = 0 } person_3;
    move_test_pos "person_3 can move right with key d" 'd' { x = 32; y = 0 }
      person_3;
    move_test_pos "person_3 can move up with key w" 'w' { x = 0; y = 32 }
      person_3;
    move_test_pos "person_3 can not move with key z" 'z' { x = 0; y = 0 }
      person_3;
  ]

let test_equal_item name input expected_output =
  name >:: fun _ -> assert_equal expected_output input

let item_t =
  Item.init_item
    (Yojson.Basic.from_file "testitem/item_type.json")
    (Yojson.Basic.from_file "testitem/item_init.json")

let item_iventory_type_tests =
  [
    test_equal_item "init with correct number of item in type"
      (ItemTypeDict.get_size item_t.item_type)
      4;
    test_equal_item "init with correct number of initail item in inventory"
      (InventoryDict.get_size item_t.inventory)
      2;
    test_equal_item "using up item return string option"
      (Item.use_item item_t) (Some "red_book");
    test_equal_item "move the selecting tool"
      (Item.item_command item_t 'l' blank 0 0
         (tile_type_of_tile (int_to_tile 0));
       item_t.selected)
      1;
  ]

let suite =
  "test suite for Cornell Simulator"
  >::: List.flatten
         [
           area_tests; character_tests; world_tests; item_iventory_type_tests;
         ]

let _ = run_test_tt_main suite
