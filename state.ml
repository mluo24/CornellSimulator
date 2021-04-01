(* interaction between key input, user, item, map *)
open Graphics

type t

(* { character: Character; world: time: } *)

let draw_point =
  Graphics.open_graph "";
  (* set_window_title "Cornell Simulator"; *)
  resize_window 600 600;
  Graphics.set_color black;
  Graphics.fill_circle 300 300 20
