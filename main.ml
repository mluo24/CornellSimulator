open Graphics
open State
open World
open Item

(*open World*)
open Unix

(** infinite loop *)
let rec loop () = loop ()

let ex_s : State.t_pos = { x = 400; y = 200 }

(** Opens the graph. If closed with x button, catch fatal I/O error and exit *)

(** [main] opens the graph, sets it up, and draws everything on. If closed
    with x button, catch fatal I/O error and exit *)
let main () =
  try
    Graphics.open_graph "";
    set_window_title "Cornell Simulator";
    resize_window World.x_dim World.y_dim;
    let m = World.map_from_json_file "testmap.json" in
    World.draw_tiles m;
    let items =
      Item.init_item_list
        (Yojson.Basic.from_file "item.json")
        (Yojson.Basic.from_file "item_rep.json")
    in
    Item.draw_all items;
    State.key_input (State.move_key ex_s) (State.dot_init ex_s) State.dot_end;
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
