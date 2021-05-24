(* handle the representation of food water slip day etc *)
(* open Position *)
open Graphics
open Yojson.Basic.Util
open Drawable

(** [t] is type of item containing information on available item type, their
    effects, and the current inventory storing user item *)
type t = {
  mutable inventory : GameDataStructure.InventoryDict.t;
  item_type : GameDataStructure.ItemTypeDict.t;
  mutable selected : int;
}

exception SizeExceed of string

exception TypeNotFound

exception NotEnoughSpace

val inventory_height : int

val item_command : t -> char -> unit

include Drawable with type t := t

(** The type [is_legal] represents a respond to user request to collect the
    item on the map. *)
type is_legal =
  | Legal
  | Illegal

(** [init_item_list item_file item_rep_file] is lists of items in [item_file]
    which belong to different item type in [item_rep_file]. The type determine
    the graphical representation and effects of the item.

    Requires: [item_file] is a valid JSON item representation [item_rep_file]
    is a valide JSON item type representation types present in [item_file]
    must match the key in [item_rep_file] *)
val init_item : Yojson.Basic.t -> Yojson.Basic.t -> t

(** [draw t] draws item [t] on the graphical interface*)
val draw : t -> unit

(** [acquire item_state type_name] modify [item_state] and return [Legal] if
    the item with [type_name] can be collected into the inventory.
    [acquire item_state type_name] is Illegal if the inventory is full or
    exception has occured during the process *)
val acquire : t -> string -> is_legal

val get_item_image : t -> string -> Graphics.image

val use_item : t -> string option

val get_item_info :
  t -> string -> GameDataStructure.ItemTypeDict.game_value option

val get_effect : t -> GameDataStructure.ItemTypeDict.key -> Effect.t option

(* (** [get_item item_lst character] remove item from the list of item on the
   map and add item the aquired item list if [character] is located within
   range of the item. *) val get_item : ilist -> Character.t -> ilist *)

(** [item_position t] is the position on the map of item [t] *)

(* val item_position : t -> -> Position.t *)
