(* handle the representation of food water slip day etc *)
(* open Position *)
open Graphics
open Yojson.Basic.Util
open Drawable

(** The abstract type of values representing an item *)
type t

include Drawable with type t := t
(** The abstract type of values representing groups of items *)
type ilist


type effect

(** [init_item_list item_file item_rep_file] is lists of items in [item_file] which belong to different item type in [item_rep_file]. The type determine the graphical representation and effects of the item. 
Requires: 
    [item_file] is a valid JSON item representation
    [item_rep_file] is a valide JSON item type representation 
    types present in [item_file] must match the key in [item_rep_file]
    *)
val init_item_list : Yojson.Basic.t -> Yojson.Basic.t-> ilist 

(** [draw t] draws item [t] on the graphical interface*)
val draw : t -> unit

(** [draw_all t_lst] draws all items in [t_lst] on the graphical interface*)
val draw_all : ilist -> unit

(** The type of item identifiers -unique. *)
type item_id = string

(* string representation of item type *)
type item_type = string




(* Whether the item has been collected *)
val acquired : t -> bool

(** [get_item item_lst character] remove item from the list of item on the map and add item the aquired item list if [character] is located within range of the item.
    *)
val get_item : ilist -> Character.t ->
  ilist

(** [name t] is the string representation of item [t]  *)
val name: t -> string
(** [description t] is the description of item [t]  *)
val description: t -> string

(* effect *)
val item_effect: t -> effect

(** [item_position t] is the position on the map of item [t]  *)
val item_position: t -> Position.t

