(* type for number value *)

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

(* value of the dictionary key sig *)

module type GameGuagesDict = sig
  exception InvalidEffect

  module GameNum : GameNum

  module KeyType : KeyType

  type game_value = GameNum.t * GameNum.t

  type key = KeyType.t

  module GameMap : Map.S

  type t = game_value GameMap.t

  val empty : t

  type num_val = GameNum.t

  val insert : key -> game_value -> t -> t

  val change_gauges :
    key -> (game_value option -> game_value option) -> t -> t

  val insert_add : key -> num_val -> t -> t
end

(* module MakeValue: functor (GV: GameValue) -> struct module GameV = GV type
   t = (GameValue.t * GameValue.t) let format = failwith "unimplemented"

   end *)

module MakeGameDict =
functor
  (GN : GameNum)
  (K : KeyType)
  ->
  struct
    module GameNum = GN
    module KeyType = K

    exception InvalidEffect

    module GameMap = Map.Make (KeyType)

    type num_val = GameNum.t

    type key = KeyType.t

    type game_value = GameNum.t * GameNum.t

    type t = game_value GameMap.t

    let empty = GameMap.empty

    let insert k value dict = GameMap.add k value dict

    let add (new_val : num_val) (ol_val : game_value option) :
        game_value option =
      match ol_val with
      | Some (num, max) ->
          let add_val = GameNum.add num new_val in
          if add_val > max then Some (num, max) else Some (add_val, max)
      | None -> None

    let change_gauges name func dict = GameMap.update name func dict

    let insert_add key value dict =
      try change_gauges key (add value) dict
      with InvalidEffect -> failwith "uniplemented"
  end
