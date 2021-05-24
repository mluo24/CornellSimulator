open Graphics
open Yojson.Basic.Util
open GameDataStructure
open GraphicHelper

(** The abstract type of values representing the items group *)
open Position

(* 288 224 *)

(** The type of item identifiers -unique. *)

(* string representation of item type *)

exception SizeExceed of string

exception TypeNotFound

exception NotEnoughSpace

type t = {
  mutable inventory : GameDataStructure.InventoryDict.t;
  item_type : GameDataStructure.ItemTypeDict.t;
  mutable selected : int;
}

let inventory_size = 10

let padding = 6

let text_pd = 2

let text_size = 12

let inventory_bg = Graphics.black

let item_size = 32

let item_bg = Graphics.rgb 255 255 255

let not_select = Graphics.rgb 100 100 100

let item_text = Graphics.rgb 255 255 255

let empty_bg = Graphics.rgb 50 50 50

let start_x tol_width i_size inv_size padding =
  let width = inv_size * (i_size + (2 * padding)) in
  let tol_gap = tol_width - width in
  if tol_gap < 0 then raise NotEnoughSpace else tol_gap / 2

let start_pos_x = start_x World.x_dim item_size inventory_size padding

let start_pos_y = World.y_dim

let start_pos () = { x = start_pos_x; y = start_pos_y }

let selected_col = Graphics.red

type is_legal =
  | Legal
  | Illegal

let to_item_prop json : GameDataStructure.ItemTypeDict.game_value =
  {
    name = json |> member "name" |> to_string;
    description = json |> member "description" |> to_string;
    image =
      json |> member "image" |> to_string |> ImageHandler.get_graphic_image;
    effect = json |> member "effect" |> Effect.from_json;
    dmax = json |> member "dmax" |> to_int;
  }

let to_inventory json : GameDataStructure.InventoryDict.game_value =
  {
    value = json |> member "init" |> to_int;
    max = json |> member "max" |> to_int;
    item_type = json |> member "name" |> to_string;
  }

let get_type_info state name : ItemTypeDict.game_value =
  match ItemTypeDict.get_value_of name state.item_type with
  | Some { name; description; image; effect; dmax } ->
      { name; description; image; effect; dmax }
  | None -> raise TypeNotFound

let get_item_image state name =
  let info = get_type_info state name in
  info.image

let inventory_height = item_size + (2 * padding) + (text_size + (2 * text_pd))

type item = InventoryDict.game_value

let init_item type_file inventory_file =
  let add_to_type dict json =
    GameDataStructure.ItemTypeDict.insert
      (json |> member "name" |> to_string)
      (to_item_prop json) dict
  in
  let add_to_inventory dict json =
    GameDataStructure.InventoryDict.insert
      (json |> member "name" |> to_string)
      (to_inventory json) dict
  in
  let type_dict =
    type_file |> member "type" |> to_list
    |> List.fold_left add_to_type GameDataStructure.ItemTypeDict.empty
  in
  let inv_dict =
    inventory_file |> member "init item" |> to_list
    |> List.fold_left add_to_inventory GameDataStructure.InventoryDict.empty
  in
  let size = InventoryDict.get_size inv_dict in
  if size > inventory_size then
    raise (SizeExceed "too many starting item in json file")
  else { item_type = type_dict; inventory = inv_dict; selected = 0 }

(* let init_bag json = json |> member "init item" |> to_list |> List.fold_left
   insert_bag GameIntDict.empty *)

(* from json for now, contain id, position, item_type *)

let draw_background pos w h color =
  let bg = Rect.make_rect_wh pos w h in
  Graphics.set_color color;
  Rect.draw bg

let draw_item t (pos : Position.t) w h (item : InventoryDict.game_value) =
  draw_background pos w h item_bg;
  let img = get_item_image t item.item_type in
  Graphics.draw_image img pos.x pos.y;
  Graphics.moveto pos.x (start_pos_y + item_size + (2 * padding) + text_pd);
  Graphics.set_text_size text_size;
  Graphics.set_color item_text;
  Graphics.draw_string
    (string_of_int item.value ^ "/" ^ string_of_int item.max)

let find_pos_x n size padding =
  let pos = start_pos () in
  pos.x + (n * (size + (2 * padding)))

let draw_empty pos =
  Graphics.set_color empty_bg;
  let bg = Rect.make_rect_wh pos item_size item_size in
  Rect.draw bg

let draw_box t pos (item : InventoryDict.game_value option) col =
  Graphics.set_color col;
  let bg =
    Rect.make_rect_wh pos
      (item_size + (2 * padding))
      (item_size + (2 * padding))
  in
  Rect.draw bg;
  let new_pos = { x = pos.x + padding; y = pos.y + padding } in
  match item with
  | Some it ->
      draw_item t { x = new_pos.x; y = new_pos.y } item_size item_size it
  | None -> draw_empty new_pos

let draw_box_itter t pos n item =
  let key, value = item in
  let col = if n = t.selected then selected_col else not_select in
  draw_box t pos (Some value) col;
  pos.x <- find_pos_x (n + 1) item_size padding

let item_select_redraw t ol n =
  let lst = InventoryDict.get_bindings t.inventory in
  let x_pos_ol = find_pos_x ol item_size padding in
  let x_pos_new = find_pos_x n item_size padding in
  let ol_item = List.nth_opt lst ol in
  match ol_item with
  | None -> draw_box t { x = x_pos_ol; y = start_pos_y } None not_select
  | Some (k, v) -> (
      draw_box t { x = x_pos_ol; y = start_pos_y } (Some v) not_select;
      let n_item = List.nth_opt lst n in
      match n_item with
      | None ->
          draw_box t { x = x_pos_new; y = start_pos_y } None selected_col
      | Some (k, v) ->
          draw_box t { x = x_pos_new; y = start_pos_y } (Some v) selected_col)

let move_select_left t =
  let ol = t.selected in
  let n = t.selected - 1 in
  match n >= 0 with
  | true ->
      t.selected <- n;
      item_select_redraw t ol n
  | false -> ()

let move_select_right t =
  let ol = t.selected in
  let n = t.selected + 1 in
  let size = InventoryDict.get_size t.inventory in
  match n < size with
  | true ->
      t.selected <- n;
      item_select_redraw t ol n
  | false -> ()

let draw (item : t) : unit =
  let rec draw_empty cur max =
    match cur < max with
    | true ->
        let x_pos = find_pos_x cur item_size padding in
        draw_box item
          { x = x_pos; y = start_pos_y }
          None
          (if cur = item.selected then selected_col else not_select);
        draw_empty (cur + 1) max
    | false -> ()
  in
  let sp = start_pos () in
  draw_background
    { x = 0; y = start_pos_y }
    World.x_dim inventory_height inventory_bg;
  let size = InventoryDict.get_size item.inventory in
  let lst = InventoryDict.get_bindings item.inventory in
  List.iteri (draw_box_itter item sp) lst;
  draw_empty size inventory_size

let use_item t =
  let remove t (ov : InventoryDict.game_value option) :
      InventoryDict.game_value option =
    match ov with
    | None -> raise Not_found
    | Some { value = v; max; item_type } ->
        let new_val = v - 1 in
        if new_val <= 0 then (
          if t.selected > 0 then t.selected <- t.selected - 1;
          None)
        else Some { value = new_val; max; item_type }
  in

  let lst = InventoryDict.get_bindings t.inventory in
  let v = List.nth_opt lst t.selected in
  match v with
  | None -> ()
  | Some (key, { value; max; item_type }) ->
      let nInv = InventoryDict.update key (remove t) t.inventory in
      t.inventory <- nInv;
      draw t

let draw_inventory item = failwith "unimplement"

let draw_all (item_state : t) = failwith "unimplement"

let item_command t c =
  match c with
  | 'j' -> move_select_left t
  | 'l' -> move_select_right t
  | 'k' -> use_item t
  | _ -> ()

let acquire item_state str_type =
  let update state name (olv : InventoryDict.game_value option) :
      InventoryDict.game_value option =
    match olv with
    | Some { value; max; item_type } ->
        let nv = value + 1 in
        if nv <= max then Some { value = nv; max; item_type }
        else Some { value; max; item_type }
    | None ->
        let size = InventoryDict.get_size state.inventory in
        if size < inventory_size then
          let info = get_type_info state name in
          Some { value = 1; max = info.dmax; item_type = info.name }
        else None
  in
  try
    let update_dict =
      InventoryDict.update str_type
        (update item_state str_type)
        item_state.inventory
    in
    item_state.inventory <- update_dict;
    draw item_state;

    Legal
  with TypeNotFound -> Illegal

(* item name *)

let name item = failwith "unimplemented"

let description item = failwith "unimplemented"

(* effect *)

let item_effect item = failwith "unimplemented"

let item_position item = failwith "unimplemented"
