open Graphics
open Images
open State
open World
open Position
open Item
open ImageHandler
open Unix
open IntroState

(** infinite loop *)
let rec loop () = loop ()

(** [main] opens the graph, sets it up, and draws everything on. If closed
    with x button, catch fatal I/O error and exit *)
let main () =
  try
    Graphics.open_graph "";
    Graphics.clear_graph ();
    set_window_title "Cornell Simulator";
    resize_window (Position.x_dim + 200)
      (Position.y_dim + Item.inventory_height);
    IntroState.in_game ();
    loop ()
  with Graphic_failure x -> (
    match x with
    | "fatal I/O error" -> print_endline "Goodbye."
    | _ ->
        print_endline
          (x ^ "Run export DISPLAY=:0 and make sure X server is running.") )

(** Runs the game. *)
let () = main ()
