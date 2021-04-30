open Dictionary
open TreeDictionary

module type Operationable = sig
  type t

  exception IllegalSubtraction

  include Dictionary.Comparable with type t := t

  val add : t -> t -> t

  val subtract : t -> t -> t

  val minimum : t
end

module type Key = sig
  type t

  include Dictionary.KeySig with type t := t

  val to_string : t -> string
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
end

(* module MakeValue: functor (GV: GameValue) -> struct module GameV = GV type
   t = (GameValue.t * GameValue.t) let format = failwith "unimplemented"

   end *)

module MakeGameDict =
functor
  (GV : GameValue)
  (K : Key)
  (DM : DictionaryMaker)
  ->
  struct
    module GameValue = GV
    module Key = K

    type game_value = GameValue.t

    module Value = struct
      module GameValue = GameValue

      type t = game_value * game_value

      let to_string t =
        match t with
        | v, max -> GameValue.to_string v ^ "/" ^ GameValue.to_string max

      let format fmt t =
        Format.fprintf fmt "\"%s\""
          (Stdlib.String.lowercase_ascii (to_string t))
    end

    exception InvalidEffect

    type value = Value.t

    type key = Key.t

    module D = DM (Key) (Value)

    type t = D.t

    let empty = D.empty

    let insert k init max dict = D.insert k (init, max) dict

    let fold fuc acc dict = D.fold fuc acc dict

    let change_gauges name func value dict =
      let cur_val = D.find name dict in
      match cur_val with
      | None -> raise InvalidEffect
      | Some (v, max) ->
          let new_val = func v value in
          let final_val =
            match GameValue.compare new_val max with
            | GT -> (max, max)
            | _ -> (new_val, max)
          in
          D.insert name final_val dict
  end
