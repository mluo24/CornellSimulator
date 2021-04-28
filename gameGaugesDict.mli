open Dictionary

module type Operationable = sig
  type t

  exception IllegalSubtraction

  include Dictionary.Comparable with type t := t

  val add : t -> t -> t

  val subtract : t -> t -> t

  val minimum : t
end

(* type for number value *)
module type GameValue = sig
  type t

  include Dictionary.Comparable with type t := t

  include Operationable with type t := t
end

(* value of the dictionary key sig *)
module type GValue = sig
  module GameValue : GameValue

  type t

  include Dictionary.ValueSig with type t := t
end

(* module MakeValue : functor (GV : GameValue) -> GValue with module GameValue
   = GV *)

module type GameGuagesDict = sig
  exception InvalidEffect

  module Key : Dictionary.KeySig

  module GameValue : GameValue

  module Value : GValue

  type game_value = GameValue.t

  type value = game_value * game_value

  type key = Key.t

  type t

  val empty : t

  val insert : key -> game_value -> game_value -> t -> t

  val change_gauges :
    key -> (game_value -> game_value -> game_value) -> game_value -> t -> t
end

module MakeGameDict : functor
  (GV : GameValue)
  (K : Dictionary.KeySig)
  (DM : DictionaryMaker)
  -> GameGuagesDict with module GameValue = GV and module Key = K
