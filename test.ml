open OUnit2
open World

(********************************************************************
   Helper functions testing set-like lists. (from A2)
 ********************************************************************)

(** [cmp_set_like_lists lst1 lst2] compares two lists to see whether
    they are equivalent set-like lists. That means checking two things.
    First, they must both be {i set-like}, meaning that they do not
    contain any duplicates. Second, they must contain the same elements,
    though not necessarily in the same order. *)
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
    
(* These tests demonstrate how to use [cmp_set_like_lists] and [pp_list]
    to get helpful output from OUnit. *)
let cmp_demo =
  [
    ( "order is irrelevant" >:: fun _ ->
      assert_equal ~cmp:cmp_set_like_lists ~printer:(pp_list pp_string)
        [ "foo"; "bar" ] [ "bar"; "foo" ] );
    (* Uncomment this test to see what happens when a test case fails.
        "duplicates not allowed" >:: (fun _ -> assert_equal
        ~cmp:cmp_set_like_lists ~printer:(pp_list pp_string) ["foo";
        "foo"] ["foo"]); *)
  ]
    
(* HELPER FUNCTIONS/VALUES FOR MAKING TESTS *)

(* let adventure_test_room_ids name (adv : Adventure.t) expected_output = 
  name >:: fun _ -> 
    assert_equal ~cmp:cmp_set_like_lists expected_output (room_ids adv) 
    ~printer:(pp_list pp_string) *)

let string_of_tile tile =
  match tile with
  | Blank -> "0"
  | Grass -> "G"
  | Sidewalk -> "S"
  | Building -> "B"

let string_of_array pp_elt arr =
  let lst = Array.to_list arr in
  pp_list pp_elt lst

let blank = map_from_json_file "blankmap.json"
let map = map_from_json_file "testmap.json"

let world_test_get_tile_arr name map expected_output =
  name >:: fun _ ->
    assert_equal expected_output (get_tile_arr map) ~printer:(string_of_array string_of_tile)

(********************************************************************
    End helper functions.
  ********************************************************************)

let world_tests = [
  world_test_get_tile_arr "empty file gives empty array" blank (Array.make 0 Blank);
  world_test_get_tile_arr "testmap.json" map (Array.map int_to_tile [|1;1;1;1;1;1;1;1;1;1;
                                                                      1;1;1;3;1;3;3;3;1;1;
                                                                      1;3;3;3;3;3;3;3;3;1;
                                                                      2;2;2;2;2;2;2;2;2;2;
                                                                      1;1;1;1;1;1;2;1;1;1;
                                                                      1;1;1;1;1;1;2;1;1;1;
                                                                      1;1;1;1;1;1;2;1;1;1|])
]
    
let suite =
  "test suite for m1"
  >::: List.flatten [ world_tests ]

let _ = run_test_tt_main suite