open Graphics
open Images
open State
open World
open Item
open Unix

(** infinite loop *)
let rec loop () = loop ()

(** [main] opens the graph, sets it up, and draws everything on. If closed
    with x button, catch fatal I/O error and exit *)
let main () =
  try
    Graphics.open_graph "";
    set_window_title "Cornell Simulator";
    resize_window World.x_dim World.y_dim;
    State.in_game ();
    (* let img = Images.sub (Png.load "ezra.png" []) 0 0 50 50 in let g =
       Graphic_image.of_image img in Graphics.draw_image g 0 0; *)
    loop ()
  with Graphic_failure x -> (
    match x with
    | "fatal I/O error" -> print_endline "Goodbye."
    | _ ->
        print_endline
          (x ^ "Run export DISPLAY=:0 and make sure X server is running."))

(** Runs the game. *)
let () = main ()
