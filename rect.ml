(* ;; 288 224 *)
type t = {
  mutable left : int;
  mutable top : int;
  mutable right : int;
  mutable bottom : int;
}

let char_size = 16

let from_json json = failwith "unimplemented"

(* true if the position is vertically at the same level at the rectable *)
let in_vertical (pos : Position.t) rect =
  pos.y < rect.top && pos.y > rect.bottom + -char_size

(* true if the position is horizontally at the same level at the rectable *)
let in_horizontal (pos : Position.t) rect =
  pos.x > rect.left - char_size && pos.x < rect.right

let in_rect (pos : Position.t) rect =
  in_vertical pos rect && in_horizontal pos rect

(* return true if the object of the position will enter rectagle if moving in
   the direction *)
let will_enter_rect pos rect dir offset =
  match dir with
  | 'a' ->
      if in_vertical pos rect && pos.x > rect.left then
        pos.x < rect.right + offset
      else false
  | 'd' ->
      if in_vertical pos rect && pos.x < rect.right then
        pos.x > rect.left - (char_size + offset)
      else false
  | 'w' ->
      if in_horizontal pos rect && pos.y < rect.top then
        pos.y > rect.bottom - offset
      else false
  | 's' ->
      if in_horizontal pos rect && pos.y > rect.bottom then
        pos.y < rect.top + offset
      else false
  | _ -> false

let make_rect top left right bottom = { left; right; top; bottom }

let draw rect =
  Graphics.fill_rect rect.left rect.bottom (rect.right - rect.left)
    (rect.top - rect.bottom)
