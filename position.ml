open Yojson.Basic.Util

let x_dim = 800

(** for 32x32 *)
let y_dim = 576

(** for 16x16 *)

(* let y_dim = 560 *)

type t = {
  mutable x : int;
  mutable y : int;
}

type direction =
  | Still
  | Up
  | Left
  | Right
  | Down

let from_json json =
  { x = json |> member "x" |> to_int; y = json |> member "y" |> to_int }

let ex2 n = n * n

let distance p1 p2 =
  let x2 = p1.x - p2.x |> ex2 in
  let y2 = p1.y - p2.y |> ex2 in
  x2 + y2 |> float_of_int |> sqrt |> int_of_float
