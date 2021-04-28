open Images
open Graphics

let make_transparent img = 
  let arr = Graphics.dump_image img in
  let newimg = Array.map 
  (fun x -> Array.map (fun y -> if y = 0 then Graphics.transp else y) x) arr in
  Graphics.make_image newimg

let get_tileset_part x y w h filename =
  let img = Images.sub (Png.load_as_rgb24 filename []) x y w h in
  let g = Graphic_image.of_image img |> make_transparent in
  g

let load_tileset filename tile_size imgwidth imgheight = 
  let images = Array.make ((imgwidth / tile_size) * (imgheight / tile_size)) 
               (Graphics.create_image tile_size tile_size) in
  Array.mapi (fun i img -> 
              (* let x = i mod cols * tsize in
              let y = y_dim - tsize - (i / cols * tsize) in *)
              get_tileset_part (i * tile_size) (i * tile_size) 
              tile_size tile_size filename) 
  images
