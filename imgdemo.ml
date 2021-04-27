open Images
open Graphics

let rec loop () = loop ()

let load_tileset filename = failwith "Unimplemented"

let make_transparent img =
  let arr = Graphics.dump_image img in
  let newimg =
    Array.map
      (fun x -> Array.map (fun y -> if y = 0 then Graphics.transp else y) x)
      arr
  in
  Graphics.make_image newimg

let get_tileset_part x y w h filename =
  let img = Images.sub (Png.load_as_rgb24 filename []) x y w h in
  let g = Graphic_image.of_image img |> make_transparent in
  g

(* let main () = try Graphics.open_graph ""; let img = Images.sub
   (Png.load_as_rgb24 "assets/Terrain.png" []) 16 0 16 32 in let g =
   Graphic_image.of_image img |> make_transparent in Graphics.draw_image g 0
   0; loop () with Graphic_failure x -> ( match x with | "fatal I/O error" ->
   print_endline "Goodbye." | _ -> print_endline (x ^ "Run export DISPLAY=:0
   and make sure X server is running."))

   let () = main () *)
