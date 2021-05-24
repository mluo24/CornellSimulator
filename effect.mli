(* type of effect *)

type t = {
  description : string;
  gauges : (string * int) list;
  mission : (string * int) list;
}

val from_json : Yojson.Basic.t -> t
