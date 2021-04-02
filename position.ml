open Yojson.Basic.Util

type t = {
  mutable x : int;
  mutable y : int;
}

let from_json json =
  { x = json |> member "x" |> to_int; y = json |> member "y" |> to_int }
