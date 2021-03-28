open Graphics
open Unix

let main () =
  Graphics.open_graph "";
  set_window_title "Hello";
  Graphics.draw_string "WELCOME "

let () = main ()
