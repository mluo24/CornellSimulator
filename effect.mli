(* type of effect *)

type t = {
  description : string;
  effects : (string * int) list;
}

val from_json : Yojson.Basic.t -> t
