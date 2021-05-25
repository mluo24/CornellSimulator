
(** Abstract type representing type that can be drawn using Graphic module *)
module type Drawable = sig
  type t
(** [draw t] draws graphic representation of [t] on the map *)
  val draw : t -> unit
end



