open Yojson.Basic.Util
open GameDataStructure

type t = GameDataStructure.GameIntDict.t

type effect

let get_level l_type gauges = failwith "Unimplemented"

let consume_item item = failwith "Unimplemented"

let draw gauges = failwith "unimplemented"

let add_to_init acc json =
  let name = json |> member "name" |> to_string in
  let max = json |> member "max" |> to_int in
  let init = json |> member "init" |> to_int in
  GameIntDict.insert name init max acc

let init_gauges json =
  json |> member "gauges" |> to_list
  |> List.fold_left add_to_init GameIntDict.empty

let decrease_gauges name by_val =
  GameIntDict.change_gauges name GameIntDict.GameValue.subtract by_val

let increase_gauges name by_val =
  GameIntDict.change_gauges name GameIntDict.GameValue.add by_val
