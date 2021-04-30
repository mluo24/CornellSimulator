open Dictionary

module type Operationable = sig
  type t

  exception IllegalSubtraction

  include Dictionary.Comparable with type t := t

  val add : t -> t -> t

  val subtract : t -> t -> t

  val minimum : t

  val defualt : t
end

(* type for number value *)
module type GameValue = sig
  type t

  include Dictionary.Comparable with type t := t

  include Operationable with type t := t

  val to_string : t -> string
end

(* value of the dictionary key sig *)
module type GValue = sig
  module GameValue : GameValue

  type t

  include Dictionary.ValueSig with type t := t

  val to_string : t -> string
end

module type Key = sig
  type t

  include Dictionary.KeySig with type t := t

  val to_string : t -> string
end

(* module MakeValue : functor (GV : GameValue) -> GValue with module GameValue
   = GV *)

module type GameGuagesDict = sig
  exception InvalidEffect

  module Key : Key

  module GameValue : GameValue

  module Value : GValue

  module D : Dictionary

  type game_value = GameValue.t

  type value = game_value * game_value

  type key = Key.t

  type t

  val empty : t

  val insert : key -> game_value -> game_value -> t -> t

  val fold : (key -> value -> 'acc -> 'acc) -> 'acc -> t -> 'acc

  val change_gauges :
    key -> (game_value -> game_value -> game_value) -> game_value -> t -> t

  val insert_add : key -> game_value -> t -> t

  val format_string_lst : t -> string list
end

module MakeGameDict : functor
  (GV : GameValue)
  (K : Key)
  (DM : DictionaryMaker)
  -> GameGuagesDict with module GameValue = GV and module Key = K
