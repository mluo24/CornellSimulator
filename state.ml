(* interaction between key input, user, item, map *)
open Graphics

type state = {
  mutable x : int;
  mutable y : int;
}

(* { character: Character; world: time: } *)

(* for now, the character is a black dot *)

let dot x y = 
  Graphics.set_color black;
  Graphics.fill_circle x y 20;

let dot_init x y  =
  Graphics.open_graph "";
  set_window_title "Cornell Simulator";
  resize_window 600 600;
  dot x y;

let dot_end =
  Graphics.close_graph ();
  print_string "Good BYE"

let move_key s c = 
  match c with 
  | '