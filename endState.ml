open ImageHandler
open IntroState

let points_message points =
  "You have graduated! Your GPA is : " ^ string_of_int points

let draw points =
  let img = ImageHandler.get_entire_image "assets/end_state.png" in
  let graphics_img = ImageHandler.get_tileset_part 0 0 800 576 img in
  Graphics.draw_image graphics_img 50 50;
  IntroState.draw_texts (points_message points) 520 290

let end_button = { x_min = 339; x_max = 476; y_min = 292; y_max = 334 }

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
      | x, y
        when x > end_button.x_min && x < end_button.x_max
             && y > end_button.y_min && y < end_button.y_max ->
          Graphics.close_graph ()
      | _, _ -> ()
    done
  with End -> end_game ()
