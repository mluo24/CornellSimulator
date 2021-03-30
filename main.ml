open Graphics
open World
open Unix

(* infinite loop *)
let rec loop () = loop ()

(* Opens the graph. If closed, catch fatal I/O error and exit*)
let main () =
  try
    Graphics.open_graph " 800x600";
    set_window_title "Cornell Simulator";
    resize_window (World.x_dim) (World.y_dim);
    loop ()
  with
    | Graphic_failure x ->
      print_string "Goodbye.";
      print_newline ()


(* let main () =
  open_graph "";
  set_window_title "Hello";
  draw_string "WELCOME ";
  print_endline "Press enter to exit:";
  let s = read_line () in
  if s = s then close_graph () *)

(* runs the program*)
let () = main ()