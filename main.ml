open Graphics
open Unix
open Images

let main () =
  Graphics.open_graph "";
  set_window_title "Hello";
  Graphics.draw_string "WELCOME "

let () = main ()
