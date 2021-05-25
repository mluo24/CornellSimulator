

(* Represent a rectable that can be drawn on the map *)

open Drawable
(** The abstract type of values representing the position on the graphical
    interface. x = 0, y= is bottom left conner *)
type t = {
  mutable left : int;
  mutable top : int;
  mutable right : int;
  mutable bottom : int;
}

include Drawable with type t := t


(** [in_rect pos rect] is true if [pos] is contain within [rec] *)
val in_rect : Position.t -> t -> bool

(** [make_rect top left right bottom] is rectagle with sides on the specified [top] [left] [right] [bottom] *)
val make_rect : int -> int -> int -> int -> t

(** [make_rect_wh pos width height] is rectangle with lower left cornner on the specified [pos] *)
val make_rect_wh : Position.t -> int -> int -> t

(**  [will_enter_rect pos rect c offset] is true if the next move to direction [c] will enter a rectangle  with [offset]*)
val will_enter_rect : Position.t -> t -> char -> int -> bool
