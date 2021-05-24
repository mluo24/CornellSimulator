(** The abstract type for a game world. *)
type t

type coords = {
  x : int;
  y : int;
}

(** [load_world dir] loads in all of the json files within the direction of
    [dir] and loads each one in as an area map.

    Requires: all of the files in the directory [dir] must be valid as an
    AreaMap type if loaded in. *)
val load_world : string -> t

(** [get_map world name] returns the map of the name [name] in [world]. *)
val get_map : t -> string -> AreaMap.t

(** [get_map world] returns the maps in [world]. *)
val list_maps : t -> (string, AreaMap.t) Hashtbl.t

(** [get_map world] returns the starting map in [world]. *)
val get_start_map : t -> AreaMap.t

(** [get_assets map] returns the assets [world] has. *)
val get_assets : t -> Images.t array array
