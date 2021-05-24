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

val from_json : Yojson.Basic.t -> t

(* (** [execute_effect state effect] updatad the game's gauges in [state] to
   match the effects specified in [effect] *) val execute_effect : Item.t -> t
   -> unit *)
