type t = {
  x : int;
  y : int;
}

val from_json : Yojson.Basic.t -> t

(* check valid *)
