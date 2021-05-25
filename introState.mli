(** [draw] draws intro page*)
val draw : unit -> unit

(** [button] is a type representation of the area of the graphics window that
    is an interactive button*)
type button = {
  x_min : int;
  x_max : int;
  y_min : int;
  y_max : int;
}

(** [draw_texts text x y] draws the string at the specified coordinates.*)
val draw_texts : string -> int -> int -> unit

(** type [choose_student] represents the student choices*)
type choose_student = {
  button : button;
  png_file : string;
  name : string;
}

(** [in_game] represents the in_game interactive state of the intro page*)

val in_game : unit -> unit
