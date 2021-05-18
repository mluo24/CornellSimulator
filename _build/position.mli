(** The abstract type of values representing the position on the graphical
    interface. x = 0, y= is bottom left conner *)
type t = {
  mutable x : int;
  mutable y : int;
}

val from_json : Yojson.Basic.t -> t

(** [distance pt1 pt2] is distance between pt1 and pt2 *)
val distance : t -> t -> int

(* check valid *)
