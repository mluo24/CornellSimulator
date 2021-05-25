open GameGaugesDict
open Graphics
open Yojson.Basic.Util
open Drawable
open GameDataStructure
open Effect
open Item

exception Negative_Gauge of int

(** [t] is the state of all game's guages. [t] gives information on the current gauges value  *)
type t = {
  mutable general : GameIntDict.t;
  mutable mission : GameIntDict.t;
  class_map: ClassMapping.t
}
(** [gauge_type] is the type of gauge: General and Mission for mission specific gauges *)
type gauge_type =
  | General
  | Mission

include Drawable with type t := t

(** [get_score g_type key state] is a ratio of current gauge value and max
    value of gauge of type [g_type] with name [key] in [state] *)
(* val get_score : t -> float *)


(** [init_gauges json_file] is the initial state of gauges levels coresponding
    the information provided in [json_file]

    Requires: [json_file] is a valid json file representing initial gauge set
    up. [json_file] must contains field "gauges" and "missions" associated
    with list of gauges configuration. The set up must not match conditions
    for wining ie. all starting level of gauges in "gauges" must be greater
    than 0 and at least one of gauge level in "missions" must be less than max
    gauge level *)
val init_gauges : Yojson.Basic.t -> t


(** [update_gauge g_type lst state] update the gauge type [g_type] in [state.gauges] by incrementing or decrementing gauge name specified in [lst] by a value  *)
val update_gauge: gauge_type-> (GameDataStructure.GameIntDict.key * int) list-> t ->  unit

val use_item : Item.t -> t -> unit 






