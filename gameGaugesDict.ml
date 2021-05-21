module type KeyType = sig
  type t

  include Map.OrderedType with type t := t
end

module type GameVal = sig
  type t
end

(* value of the dictionary key sig *)

module type GameDict = sig
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

(* module MakeValue: functor (GV: GameValue) -> struct module GameV = GV type
   t = (GameValue.t * GameValue.t) let format = failwith "unimplemented" end *)

module MakeGameDict =
functor
  (GVal : GameVal)
  (K : KeyType)
  ->
  struct
    module KeyType = K
    module GameVal = GVal

    exception InvalidEffect

    module GameMap = Map.Make (KeyType)

    type key = KeyType.t

    type game_value = GameVal.t

    type t = game_value GameMap.t

    let empty = GameMap.empty

    let insert k value dict = GameMap.add k value dict

    (* let add (new_val : num_val) (ol_val : game_value option) : game_value
       option = match ol_val with | Some { value; max; color } -> let add_val
       = GameNum.add value new_val in if add_val > max then Some { value; max;
       color } else Some { value = add_val; max; color } | None -> None *)

    let update name func dict = GameMap.update name func dict

    let get_size dict = GameMap.cardinal dict

    let get_bindings dict = GameMap.bindings dict

    let get_key_of value dict =
      let filter_func k v = if v <> value then None else Some v in
      let new_map = GameMap.filter_map filter_func dict in
      let key, _ = GameMap.min_binding new_map in
      key

    (* let insert_add key value dict = try change_gauges key (add value) dict
       with InvalidEffect -> failwith "uniplemented" *)
  end
