module type Drawable = sig
  type t

  val draw : t -> unit
end
