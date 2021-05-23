open Graphics
open Images
open State
open World
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
    set_window_title "Cornell Simulator";
    resize_window (World.x_dim + 200) World.y_dim;
    IntroState.in_game ();
    (* let imgs = ImageHandler.load_tileset "assets/Buildings.png" 16 in
       Array.iteri (fun i img -> Graphics.draw_image img (i * 16) 0) imgs; *)
    loop ()
  with Graphic_failure x -> (
    match x with
    | "fatal I/O error" -> print_endline "Goodbye."
    | _ ->
        print_endline
          (x ^ "Run export DISPLAY=:0 and make sure X server is running."))

(** Runs the game. *)
let () = main ()
