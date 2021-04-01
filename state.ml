(* interaction between key input, user, item, map *)
open Graphics

type t

(* { character: Character; world: time: } *)

let draw_point x y r =
  Graphics.set_color black;
  Graphics.fill_circle x y r
