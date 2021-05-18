open GameGaugesDict
open Graphics
open Yojson.Basic.Util
open Drawable
open GameDataStructure

type t = GameIntDict.t

include Drawable with type t := t

type effect

val get_level : GameIntDict.key -> t -> GameIntDict.game_value

val init_gauges : Yojson.Basic.t -> t

val decrease_gauges : GameIntDict.key -> GameIntDict.game_value -> t -> t

val increase_gauges : GameIntDict.key -> GameIntDict.num_val -> t -> t

val consume_item : t -> Item.t -> t
