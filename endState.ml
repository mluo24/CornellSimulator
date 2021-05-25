open ImageHandler

(** TODO implement points caluclation here*)
let points_message points =
  "You have graduated! Your GPA is : " ^ string_of_int points

let draw points =
  let img = ImageHandler.get_entire_image "assets/end_state.png" in
  let graphics_img = ImageHandler.get_tileset_part 0 0 800 576 img in
  Graphics.draw_image graphics_img 50 50;
  Graphics.moveto 380 400;
  Graphics.draw_string (points_message points)

exception End

let in_game points =
  try
    while true do
      draw points;
      let s = Graphics.wait_next_event [ Graphics.Button_down ] in
      if s.Graphics.button then
        let x = fst (Graphics.mouse_pos ()) in
        let y = snd (Graphics.mouse_pos ()) in
        match (x, y) with
        | x, y when x > 0 && x < 1000 && y > 0 && y < 1000 ->
            Graphics.close_graph ()
        | _, _ -> ()
    done
  with End -> ()
