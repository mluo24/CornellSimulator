open Position

type rep = {
  color : Graphics.color;
  size : int;
}

type t = {
  name : string;
  rep : rep;
  pos : Position.t;
  speed : int;
}

let get_position c = c.pos

let get_size c = c.rep.size

let init_character () =
  {
    name = "bear";
    rep = { color = Graphics.black; size = 10 };
    pos = { x = 30; y = 60 };
    speed = 10;
  }

let move (t : t) c =
  match c with
  | 'w' -> if t.pos.y < World.y_dim then t.pos.y <- t.pos.y + t.speed
  | 'd' -> if t.pos.x < World.x_dim then t.pos.x <- t.pos.x + t.speed
  | 's' -> if t.pos.y > 0 then t.pos.y <- t.pos.y - t.speed
  | 'a' -> if t.pos.x > 0 then t.pos.x <- t.pos.x - t.speed
  | _ -> ()

(* for drawing player *)
(* let get_user_rep = failwith "unimplemented" *)

let get_user_name t = t.name

(* val get_level: t -> how getting an item effect user *)
(* let aquire_item = failwith "unimplemented" *)

let draw t =
  Graphics.set_color t.rep.color;
  Graphics.fill_circle t.pos.x t.pos.y t.rep.size
