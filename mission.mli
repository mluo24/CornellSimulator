type t = {
  mutable text : string;
  mutable missions : string list;
}

val init_mission : unit -> t

val draw_missions_window : t -> unit
