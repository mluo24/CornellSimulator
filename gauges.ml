open Yojson.Basic.Util
open GameDataStructure
open Graphics

type t = GameDataStructure.GameIntDict.t

type effect

let get_level l_type gauges = failwith "Unimplemented"

let consume_item item = failwith "Unimplemented"

let format_string
    (key : GameDataStructure.GameIntDict.key)
    (value : GameDataStructure.GameIntDict.value)
    init =
  let str_g =
    match value with
    | v, max ->
        GameDataStructure.GameIntDict.GameValue.to_string v
        ^ "/"
        ^ GameDataStructure.GameIntDict.GameValue.to_string max
  in
  let str = GameDataStructure.GameIntDict.Key.to_string key ^ ":" ^ str_g in
  str :: init

let make_string_lst t =
  let lst = GameDataStructure.GameIntDict.fold format_string [] t in
  "gauges" :: lst

let draw gauges =
  Graphics.set_color black;
  let rec draw_lst (pos : Position.t) line_height lst =
    match lst with
    | [] -> ()
    | h :: t ->
        Graphics.moveto pos.x pos.y;
        Graphics.draw_string h;
        pos.y <- pos.y - line_height;
        draw_lst pos line_height t
  in
  draw_lst { x = 600; y = 500 } 20 (make_string_lst gauges)

let add_to_init acc json =
  let name = json |> member "name" |> to_string in
  let max = json |> member "max" |> to_int in
  let init = json |> member "init" |> to_int in
  GameIntDict.insert name init max acc

let init_gauges json =
  json |> member "gauges" |> to_list
  |> List.fold_left add_to_init GameIntDict.empty

let decrease_gauges name by_val =
  GameIntDict.change_gauges name GameIntDict.GameValue.subtract by_val

let increase_gauges name by_val =
  GameIntDict.change_gauges name GameIntDict.GameValue.add by_val
