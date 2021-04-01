open Graphics
open State

(*open World*)
open Unix

(** infinite loop *)
let rec loop () = loop ()

let s : State.t_pos = { x = 400; y = 200 }

(** Opens the graph. If closed with x button, catch fatal I/O error and exit *)
let main () =
  try
    State.dot_init s;
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
