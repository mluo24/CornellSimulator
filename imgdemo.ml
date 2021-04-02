open Images
open Graphics

let rec loop () = loop ()


let load_tileset filename = failwith "Unimplemented"


let main () =
  try
    Graphics.open_graph "";
    let img = Images.sub (Png.load_as_rgb24 "assets/Terrain.png" []) 0 16 16 16 in
    let g = Graphic_image.of_image img in
    Graphics.draw_image g 0 0;
    loop ()
  with Graphic_failure x -> (
    match x with
    | "fatal I/O error" -> print_endline "Goodbye."
    | _ ->
        print_endline
          (x ^ "Run export DISPLAY=:0 and make sure X server is running."))

(** Runs the game. *)
let () = main ()
