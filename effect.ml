open Yojson.Basic.Util

type t = {
  description : string;
  effects : (string * int) list;
}

let to_effect json =
  (json |> member "gauge" |> to_string, json |> member "value" |> to_int)

let from_json json =
  {
    description = json |> member "description" |> to_string;
    effects = json |> member "effects" |> to_list |> List.map to_effect;
  }
