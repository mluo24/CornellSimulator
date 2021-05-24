open GameGaugesDict
open Graphics
open Yojson.Basic.Util
open Drawable
open GameDataStructure
open Effect

(** [t] is the state of all game's guages. [t] gives information on the current gauges value  *)
type t = {
  general : GameIntDict.t;
  mission : GameIntDict.t;
}
(** [gauge_type] is the type of gauge: General and Mission for mission specific gauges *)
type gauge_type =
  | General
  | Mission

include Drawable with type t := t

(** [get_score g_type key state] is a ratio of current gauge value and max
    value of gauge of type [g_type] with name [key] in [state] *)
val get_score : gauge_type -> GameIntDict.key -> t -> float

(** [init_gauges json_file] is the initial state of gauges levels coresponding
    the information provided in [json_file]

    Requires: [json_file] is a valid json file representing initial gauge set
    up. [json_file] must contains field "gauges" and "missions" associated
    with list of gauges configuration. The set up must not match conditions
    for wining ie. all starting level of gauges in "gauges" must be greater
    than 0 and at least one of gauge level in "missions" must be less than max
    gauge level *)
val init_gauges : Yojson.Basic.t -> t

val decrease_gauges : GameIntDict.key -> GameIntDict.game_value -> t -> t

val increase_gauges : GameIntDict.key -> int -> t -> t

val consume_item : t -> Item.t -> t
