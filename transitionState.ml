open ImageHandler
open IntroState
open EndState

(* type level = | Sophomore = {} | Junior | Senior

   let level_student_mission level name = match (level, name) with |
   Sophomore, "undecided" -> "" | Junior, "undecided" -> "" | Senior,
   "undecided" -> "" | _ -> "" *)

type level = {
  json : string;
  level : int;
  points : int;
  name : string;
}

let level_to_next level_num acc_points name =
  let next_level_num = level_num + 1 in
  match (level_num, name) with
  | 2, "undecided" ->
      {
        json = "missions/sophomore_undecided.json";
        level = level_num;
        points = acc_points;
        name;
      }
  | 3, "undecided" ->
      {
        json = "missions/junior_undecided.json";
        level = level_num;
        points = acc_points;
        name;
      }
  | 4, "undecided" ->
      {
        json = "missions/senior_undecided.json";
        level = level_num;
        points = acc_points;
        name;
      }
  | _, _ ->
      {
        json = "missions/sophomore_undecided.json";
        level = 0;
        points = acc_points;
        name;
      }

let draw () =
  let img = ImageHandler.get_entire_image "assets/transition_state.png" in
  let graphics_img = ImageHandler.get_tileset_part 0 0 800 576 img in
  Graphics.draw_image graphics_img 50 50

let next_level_button = { x_min = 335; x_max = 487; y_min = 281; y_max = 306 }

exception End

let end_game () = failwith "unimplemented"

let in_game level_num name points =
  try
    while true do
      draw ();
      let s = Graphics.wait_next_event [ Graphics.Button_down ] in
      if s.Graphics.button then Graphics.moveto 500 200;
      let x = fst (Graphics.mouse_pos ()) in
      let y = snd (Graphics.mouse_pos ()) in
      match (x, y) with
      | x, y
        when x > next_level_button.x_min
             && x < next_level_button.x_max
             && y > next_level_button.y_min
             && y < next_level_button.y_max ->
          let next_level = level_to_next level_num points name in
          if next_level.level > 0 then
            State.in_game engineer.name engineer.png_file next_level.level
              points
          else EndState.in_game points
      | _, _ -> ()
    done
  with End -> end_game ()
