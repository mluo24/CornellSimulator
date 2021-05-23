(** A module that matches [GameVal] is a customizeable value suitable for use as the type of value of [GameDict] *)
module type GameVal = sig
  type t
end
(** A module that matches [KeyType] is suitable for use as the type of key of [GameDict]. Keys must be comparable *)
module type KeyType = sig
  type t

  include Map.OrderedType with type t := t
end

(** A [GameDict] maps keys to game values. [GameDict] *)
module type GameDict = sig
  exception InvalidEffect


  module GameVal : GameVal

  module KeyType : KeyType


  type game_value = GameVal.t

  type key = KeyType.t

  module GameMap : Map.S

  (** [t] is the type of [GameDict]*)
  type t = game_value GameMap.t

  (** [empty] is the empty [GameDict] *)
  val empty : t

(** [insert key value dict] is [dict] with [k] bound to [value]. If [key] was already
      bound, its previous value is replaced with [v]. *)
  val insert : key -> game_value -> t -> t


  (** [update key func dict] is [dict] with [key] bound to the new value from [func old_value]. If [key] is not bound...
      . *)
  val update : key -> (game_value option -> game_value option) -> t -> t

(** [get_size dict] is the number of bindings in [dict]  *)
  val get_size : t -> int

  (** [get_bindings dict] is the list containing the bindings in [dict] *)
  val get_bindings : t -> (key * game_value) list

  (** [get_key_of value] is the first key that bound to [value]  *)
  val get_key_of : game_value -> t -> key

  val get_value_of : key -> t ->  game_value option
end

(** A [MakeGameDict] is a functor that makes a [GameDict] out of
    modules representing keys and values. *)

module MakeGameDict : functor (GVal : GameVal) (K : KeyType) ->
  GameDict with module GameVal = GVal and module KeyType = K
