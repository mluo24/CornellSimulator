open Graphics
open State
open World

(*open World*)
open Unix

(** infinite loop *)
let rec loop () = loop ()

(** [main] opens the graph, sets it up, and draws everything on. 
    If closed with x button, catch fatal I/O error and exit *)
let main () =
  try
    Graphics.open_graph "";
    set_window_title "Cornell Simulator";
    resize_window World.x_dim World.y_dim;
    let m = World.map_from_json_file "testmap.json" in
    World.draw_tiles m;
    (**)
    State.draw_point;

    loop ()
  with Graphic_failure x -> (
    match x with
    | "fatal I/O error" -> print_endline "Goodbye."
    | _ ->
        print_endline
          (x ^ "Run export DISPLAY=:0 and make sure X server is running."))

(* let main () = open_graph ""; set_window_title "Hello"; draw_string "WELCOME
   "; print_endline "Press enter to exit:"; let s = read_line () in if s = s
   then close_graph () *)

(** Runs the game. *)
let () = main ()
