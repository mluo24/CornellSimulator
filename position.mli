type t = {
  mutable x : int;
  mutable y : int;
}

val from_json : Yojson.Basic.t -> t

(* check valid *)
