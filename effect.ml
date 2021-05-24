open Yojson.Basic.Util

type t = {
  description : string;
  gauges : (string * int) list;
  mission : (string * int) list;
}

let to_effect json =
  (json |> member "name" |> to_string, json |> member "value" |> to_int)

let from_json json =
  {
    description = json |> member "description" |> to_string;
    gauges = json |> member "gauges" |> to_list |> List.map to_effect;
    mission = json |> member "mission" |> to_list |> List.map to_effect;
  }

let execute_effect t = ()
