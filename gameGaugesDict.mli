module type Operationable = sig
  type t

  exception IllegalSubtraction

  val add : t -> t -> t

  val subtract : t -> t -> t

  val minimum : t

  val defualt : t
end

module type GameNum = sig
  type t

  include Operationable with type t := t

  val to_string : t -> string
end

module type KeyType = sig
  type t

  include Map.OrderedType with type t := t
end

(* module MakeValue : functor (GV : GameValue) -> GValue with module GameValue
   = GV *)

module type GameGuagesDict = sig
  exception InvalidEffect

  module GameNum : GameNum

  module KeyType : KeyType

  type game_value = GameNum.t * GameNum.t

  type key = KeyType.t

  type num_val = GameNum.t

  module GameMap : Map.S

  type t = game_value GameMap.t

  val empty : t

  val insert : key -> game_value -> t -> t

  val change_gauges :
    key -> (game_value option -> game_value option) -> t -> t

  val insert_add : key -> num_val -> t -> t
end

module MakeGameDict : functor (GN : GameNum) (K : KeyType) ->
  GameGuagesDict with module GameNum = GN and module KeyType = K
