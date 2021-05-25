open OUnit2
open World
open AreaMap
open Character
open Position
open State
open Graphics

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
   properly. One module that we definitely did not need to test was State,
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

(* AREA MAP TESTS *)

let area_test_int_to_tile name i expected_output =
  name >:: fun _ -> assert_equal expected_output (int_to_tile i)

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

let area_test_get_assets name map expected_output =
  name >:: fun _ -> assert_equal expected_output (get_assets map)

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
  ]

(* WORLD TESTS *)

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

(* let () = Graphics.open_graph "" *)

(* let create_person position = { name = "person"; rep =
   Character.get_person_image Still; pos = { x = position.x; y = position.y };
   speed = 16; tile_mem = World.get_tile 9 10 world; }

   let person_1 () = create_person { x = 16; y = 16 }

   let person_2 () = create_person { x = World.x_dim - 16; y = World.y_dim -
   16 }

   let person_3 () = create_person { x = 0; y = 0 }

   let move_test_pos name c expected_output p = let person = p () in
   Character.move person c; name >:: fun _ -> assert_equal expected_output
   person.pos *)

let character_tests =
  [ (* tests for regular movements *)
    (* move_test_pos "move person_1 left with key a" 'a' { x = 0; y = 16 }
       person_1; move_test_pos "move person_1 right one with key d" 'd' { x =
       32; y = 16 } person_1; move_test_pos "move person_1 down one with key
       s" 's' { x = 16; y = 0 } person_1; move_test_pos "move person_1 up one
       with key w" 'w' { x = 16; y = 32 } person_1; move_test_pos "person_1
       will not move with key z" 'z' { x = 16; y = 16 } person_1; (* tests for
       edge cases *) move_test_pos "person_2 can't move any further right with
       key d" 'd' { x = World.x_dim - 16; y = World.y_dim - 16 } person_2;
       move_test_pos "person_2 can't move any further up with key w" 'w' { x =
       World.x_dim - 16; y = World.y_dim - 16 } person_2; move_test_pos
       "person_3 can't move any further left with key a" 'a' { x = 0; y = 0 }
       person_3; move_test_pos "person_3 can't move any further down with key
       s" 's' { x = 0; y = 0 } person_3; *) ]

let suite =
  "test suite for Cornell Simulator"
  >::: List.flatten [ area_tests; character_tests; world_tests ]

let _ = run_test_tt_main suite
