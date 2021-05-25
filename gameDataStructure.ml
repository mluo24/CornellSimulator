

open GameGaugesDict

(** [String] provides the necessary definitions to use strings as keys in
    GameGaugesDict *)
module String : KeyType with type t = string = struct
  type t = string

  let compare s1 s2 = Stdlib.compare s1 s2
end

(** [CaselessString] provides the necessary definitions to use strings as keys in
    GameGaugesDict *)
module CaselessString : KeyType with type t = string = struct
  type t = string

  let compare s1 s2 =
    Stdlib.compare
      (Stdlib.String.lowercase_ascii s1)
      (Stdlib.String.lowercase_ascii s2)
end

(** [IntPos] provides the necessary definitions to use int as keys in
    GameGaugesDict *)
module IntPos = struct
  exception IllegalSubtraction

  type t = int

  let to_string t = string_of_int t

  let compare x y = Stdlib.compare x y

  let format fmt x = Format.fprintf fmt "%d" x

  let add i1 i2 = i1 + i2

  let divide i1 i2 = Float.of_int i1 /. Float.of_int i2

  let minimum = 0

  let defualt = 20

  let subtract i1 i2 =
    let num = i1 - i2 in
    if num < minimum then raise IllegalSubtraction else num
end

(** [GaugesValue] provides a type to represent necessary information for gauges value in the map  *)
module type GaugesValue = sig
  type t = {
    value : int;
    max : int;
    color : Graphics.color;
  }

  include GameVal with type t := t
end

module GaugesValue : GaugesValue = struct
  type t = {
    value : int;
    max : int;
    color : Graphics.color;
  }
end

(** [ItemTypeInfo] provides a type to represent necessary information for item type value of the map  *)
module type ItemTypeInfo = sig
  type t = {
    name : string;
    description : string;
    image : Graphics.image;
    effect : Effect.t;
    dmax : int;
  }

  include GameVal with type t := t
end

(** [ItemInventory] provides a type to represent necessary information for item inventory value of the map  *)
module type ItemInventory = sig
  type t = {
    value : int;
    max : int;
    item_type : string;
  }

  include GameVal with type t := t
end

module ItemInventory : ItemInventory = struct
  type t = {
    value : int;
    max : int;
    item_type : string;
  }
end

module ItemTypeInfo : ItemTypeInfo = struct
  type t = {
    name : string;
    description : string;
    image : Graphics.image;
    effect : Effect.t;
    dmax : int;
  }
end

(** [GameIntDict] is a data structure for maintaining gauges information *)
module GameIntDict = MakeGameDict (GaugesValue) (CaselessString)
(** [ItemTypeDict] is a data structure for maintaining item type information *)
module ItemTypeDict = MakeGameDict (ItemTypeInfo) (CaselessString)
(** [InventoryDict] is a data structure for maintaining inventory  information *)
module InventoryDict = MakeGameDict (ItemInventory) (CaselessString)
(** [ClassMapping] is a data structure for maintaining the information on the mapping between gauge id and display name *)
module ClassMapping = MakeGameDict (String) (String)
