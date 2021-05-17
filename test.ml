open OUnit2
open World
open Character
open Position

(********************************************************************
   OUR APPROACH TO TESTING
 ********************************************************************)
(** 
  *Our approach to testing ...

  The way we tested...

  Testing was rather difficult because of the fact that a lot of the functions
  heavily relied on the graphics window being open, and most of the operations
  done there. Therefore, the tests would likely fail due to needing to open the 
  graphics screen.

  Partially as a result of that, some tests we omitted because they directly 
  relate to the graphics panel, which we do not believe we can really confirm 
  through running unit tests. Since we can easily confirm this visually, there is 
  no need to write test cases for this. As well, some functions return a specific type
  that is defined in the module, which in this case is obscured from the client.
  Therefore, we "test" those through the other methods to make sure it has
  been defined properly. 

  This demonstrates the correctness of the system... 
  The game is supposed to be graphically based and visual. Because the game works
  correctly from a visual and player standpoint, and the basic tests that in this
  file all pass, this system is very likely to be correct.

*)


(********************************************************************
   Helper functions testing set-like lists. (from A2)
 ********************************************************************)

(** [cmp_set_like_lists lst1 lst2] compares two lists to see whether they are
    equivalent set-like lists. That means checking two things. First, they
    must both be {i set-like}, meaning that they do not contain any
    duplicates. Second, they must contain the same elements, though not
    necessarily in the same order. *)
let cmp_set_like_lists lst1 lst2 =
  let uniq1 = List.sort_uniq compare lst1 in
  let uniq2 = List.sort_uniq compare lst2 in
  List.length lst1 = List.length uniq1
  && List.length lst2 = List.length uniq2
  && uniq1 = uniq2

(** [pp_string s] pretty-prints string [s]. *)
let pp_string s = "\"" ^ s ^ "\""

(** [pp_list pp_elt lst] pretty-prints list [lst], using [pp_elt] to
    pretty-print each element of [lst]. *)
let pp_list pp_elt lst =
  let pp_elts lst =
    let rec loop n acc = function
      | [] -> acc
      | [ h ] -> acc ^ pp_elt h
      | h1 :: (h2 :: t as t') ->
          if n = 100 then acc ^ "..." (* stop printing long list *)
          else loop (n + 1) (acc ^ pp_elt h1 ^ "; ") t'
    in
    loop 0 "" lst
  in
  "[" ^ pp_elts lst ^ "]"

(* These tests demonstrate how to use [cmp_set_like_lists] and [pp_list] to
   get helpful output from OUnit. *)
(* let cmp_demo =
  [
    ( "order is irrelevant" >:: fun _ ->
      assert_equal ~cmp:cmp_set_like_lists ~printer:(pp_list pp_string)
        [ "foo"; "bar" ] [ "bar"; "foo" ] );
     Uncomment this test to see what happens when a test case fails.
       "duplicates not allowed" >:: (fun _ -> assert_equal
       ~cmp:cmp_set_like_lists ~printer:(pp_list pp_string) ["foo"; "foo"]
       ["foo"]);
  ] *)

(* HELPER FUNCTIONS/VALUES FOR MAKING TESTS *)

(* let string_of_tile tile =
  match tile with
  | Blank -> "0"
  | Grass -> "G"
  | Sidewalk -> "S"
  | Building -> "B" *)

let string_of_array pp_elt arr =
  let lst = Array.to_list arr in
  pp_list pp_elt lst

let blank = map_from_json_file "blankmap.json"

let map1 = map_from_json_file "testmap.json"

let map2 = map_from_json_file "realmap.json"

let world_test_get_tile_arr name map expected_output =
  name >:: fun _ ->
  assert_equal expected_output (get_tile_arr map)
    (* ~printer:(string_of_array string_of_tile) *)



(******************************************************************** 
  End helper functions.
  ********************************************************************)

let world_tests =
  [
    
    world_test_get_tile_arr "empty file gives empty array" blank
      (Array.make 0 Blank);
    world_test_get_tile_arr "testmap.json" map1
      (Array.map int_to_tile
         [|
          1;1;1;1;1;1;1;1;1;1;
          1;1;1;3;1;3;3;3;1;1;
          1;3;3;3;3;3;3;3;3;1;
          2;2;2;2;2;2;2;2;2;2;
          1;1;1;1;1;1;2;1;1;1;
          1;1;1;1;1;1;2;1;1;1;
          1;1;1;1;1;1;2;1;1;1
         |]);
  ]

(* 
let move_test name c expected_output =
  Graphics.open_graph "";
  let bear = Character.init_character () in
  Character.move bear c;
  let new_pos = Character.get_position bear in
  name >:: fun _ -> assert_equal expected_output new_pos

let character_tests =
  [
    move_test "move bear up with key w" 'w' { x = 30; y = 70 };
    move_test "move bear left with key a" 'a' { x = 20; y = 60 };
    move_test "move bear right one with key d" 'd' { x = 40; y = 60 };
    move_test "move bear down one with key s" 's' { x = 30; y = 50 };
  ] *)

let suite =
  "test suite for m1" >::: List.flatten 
    [ 
      world_tests; 
      (* character_tests  *)
    ]

let _ = run_test_tt_main suite
