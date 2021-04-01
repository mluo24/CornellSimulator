open Graphics
open State

(*open World*)
open Unix

(** infinite loop *)
let rec loop () = loop ()

(** Opens the graph. If closed with x button, catch fatal I/O error and exit *)
let main () =
  try
    Graphics.open_graph "";
    set_window_title "Cornell Simulator";
    resize_window 600 600;
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

(** runs the program *)
let () = main ()
