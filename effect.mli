(* type of effect *)

(** [t] is a type used to maintain the information of effects. [t.description]
    is a short describtion of what the effect does. [t.gauges] and [t.mission]
    contain the list of (n,v) use to update gauge with name = n by value = v
    for each type of gauge.*)
type t = {
  description : string;
  gauges : (string * int) list;
  mission : (string * int) list;
}

(** [form_json file_name] is the representation of effect in json [file_name] *)
val from_json : Yojson.Basic.t -> t
