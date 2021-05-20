(** The abstract type of values representing the position on the graphical
    interface. x = 0, y= is bottom left conner *)

(* represent a rectable that can be drawn on the map *)

open Drawable

type t = {
  mutable left : int;
  mutable top : int;
  mutable right : int;
  mutable bottom : int;
}

include Drawable with type t := t

val from_json : Yojson.Basic.t -> t

val in_rect : Position.t -> t -> bool

val make_rect : int -> int -> int -> int -> t

val will_enter_rect : Position.t -> t -> char -> int -> bool
