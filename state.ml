(* interaction between key input, user, item, map *)
open Graphics
open Position
open Item
open Character

type t = {
  world : World.t;
  character : Character.t;
  items : Item.ilist;
}

let init_game () =
  {
    world = World.map_from_json_file "testmap.json";
    character = Character.init_character ();
    items =
      Item.init_item_list
        (Yojson.Basic.from_file "item.json")
        (Yojson.Basic.from_file "item_rep.json");
  }

let draw t =
  Graphics.clear_graph ();
  World.draw_tiles t.world;
  Item.draw_all t.items;
  Character.draw t.character

exception End

let end_game () = failwith "unimplemented"

let in_game () =
  let game_state = init_game () in
  draw game_state;
  try
    while true do
      let s = Graphics.wait_next_event [ Graphics.Key_pressed ] in
      if s.Graphics.keypressed then begin
        Character.move game_state.character s.Graphics.key;
        draw game_state
      end
    done
  with End -> end_game ()

(* type t_pos = { mutable x : int; mutable y : int; } *)

(* { character: Character; world: time: } *)

(* exception End *)

(* let key_input key init the_end = init; try while true do try let s =
   Graphics.wait_next_event [ Graphics.Key_pressed ] in if
   s.Graphics.keypressed then key s.Graphics.key else print_string "Wrong key.
   You can only use char keys!" with End -> the_end done with End -> the_end

   let dot s = Graphics.set_color black; Graphics.fill_circle s.x s.y 20

   let dot_init s = dot s

   let redraw_dot s = Graphics.clear_graph (); dot s

   let dot_end = Graphics.close_graph (); print_string "End of dot."

   let move_key s c = redraw_dot s; match c with | 'w' -> if s.y < 400 then
   s.y <- s.y + 1 | 'd' -> if s.x > 0 then s.x <- s.x + 1 | 's' -> if s.y > 0
   then s.y <- s.y - 1 | 'a' -> if s.x < 800 then s.x <- s.x - 1 | 'e' ->
   dot_end | _ -> () *)
