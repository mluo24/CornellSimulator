val draw : unit -> unit

type button = {
  x_min : int;
  x_max : int;
  y_min : int;
  y_max : int;
}

val draw_texts : string -> int -> int -> unit

type choose_student = {
  button : button;
  png_file : string;
  name : string;
}

val engineer : choose_student

val premed : choose_student

val undecided : choose_student

val match_student : choose_student -> int -> int -> bool

val in_game : unit -> unit
