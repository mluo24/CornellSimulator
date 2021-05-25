open ImageHandler

let points_message points = "You have graduated! Your GPA is : " ^ "3.2"

(*string_of_int points*)

let draw points =
  let img = ImageHandler.get_entire_image "assets/end_state.png" in
  let graphics_img = ImageHandler.get_tileset_part 0 0 800 576 img in
  Graphics.draw_image graphics_img 50 50

exception End

let end_game () = failwith "unimplemented"

let in_game points =
  try
    while true do
      draw points;
      let s = Graphics.wait_next_event [ Graphics.Button_down ] in
      if s.Graphics.button then Graphics.moveto 500 200;
      let x = fst (Graphics.mouse_pos ()) in
      let y = snd (Graphics.mouse_pos ()) in
      match (x, y) with
      | x, y when x > 339 && x < 476 && y > 292 && y < 334 ->
          Graphics.close_graph ()
      | _, _ -> ()
    done
  with End -> end_game ()
