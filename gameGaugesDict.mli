module type GameVal = sig
  type t
end

module type KeyType = sig
  type t

  include Map.OrderedType with type t := t
end

module type GameGuagesDict = sig
  exception InvalidEffect

  module GameVal : GameVal

  module KeyType : KeyType

  type game_value = GameVal.t

  type key = KeyType.t

  module GameMap : Map.S

  type t = game_value GameMap.t

  val empty : t

  val insert : key -> game_value -> t -> t

  val update : key -> (game_value option -> game_value option) -> t -> t

  val get_size : t -> int

  val get_bindings : t -> (key * game_value) list

  val get_key_of : game_value -> t -> key
end

module MakeGameDict : functor (GVal : GameVal) (K : KeyType) ->
  GameGuagesDict with module GameVal = GVal and module KeyType = K
