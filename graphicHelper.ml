open Yojson.Basic.Util

let to_color json : Graphics.color =
  Graphics.rgb
    (json |> member "r" |> to_int)
    (json |> member "g" |> to_int)
    (json |> member "b" |> to_int)
