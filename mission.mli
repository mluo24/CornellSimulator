open GameDataStructure

type t = {
  mutable text : string;
  mutable missions : string list;
  mutable class_key_map : ClassMapping.t;
}

val init_mission : unit -> t

val draw_missions_window : t -> unit
