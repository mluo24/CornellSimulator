open Images
open Graphics

let make_transparent img =
  let arr = Graphics.dump_image img in
  let newimg =
    Array.map
      (fun x -> Array.map (fun y -> if y = 0 then Graphics.transp else y) x)
      arr
  in
  Graphics.make_image newimg

let get_entire_image filename = Png.load_as_rgb24 filename []

let get_tileset_part x y w h image =
  let img = Images.sub image x y w h in
  let g = Graphic_image.of_image img |> make_transparent in
  g

let get_tileset_part_image = Images.sub

let load_tileset filename tile_size =
  let all_tiles = get_entire_image filename in
  let imgwidth = fst (Images.size all_tiles) in
  let imgheight = snd (Images.size all_tiles) in
  let cols = imgwidth / tile_size in
  let rows = imgheight / tile_size in
  let images = Array.make (cols * rows) 0 in
  Array.mapi
    (fun i img ->
      let x = i mod cols * tile_size in
      let y = i / cols * tile_size in
      get_tileset_part_image all_tiles x y tile_size tile_size)
    images

let get_tile_image_x_y tileset width x y =
  let img = tileset.((width * y) + x) in
  Graphic_image.of_image img |> make_transparent

let get_graphic_image file_name =
  get_entire_image file_name |> Graphic_image.of_image |> make_transparent
