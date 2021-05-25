open ImageHandler
open State

let introduction_line1 = "Welcome to the Cornell Student Simulator!"

let introduction_line2 =
  "First, choose your student by clicking on one of the three characters \
   below:"

let undecided_name = "Confused Freshman"

let undecided_des_1 = "Undecided Major"

let undecided_des_2 = "(Challenge Mode)"

let engineer_name = "Engineering Student"

let engineer_des = "Computer Science Major"

let premed_name = "Science Student"

let premed_des = "Pre-Med"

let draw_texts text x y =
  Graphics.moveto x y;
  Graphics.draw_string text

let draw () =
  let img =
    ImageHandler.get_entire_image "assets/character/starterpagedemo.png"
  in
  let graphics_img = ImageHandler.get_tileset_part 0 0 1000 560 img in
  Graphics.draw_image graphics_img 0 0;
  draw_texts introduction_line1 360 510;
  draw_texts introduction_line2 260 470;
  draw_texts undecided_name 235 330;
  draw_texts undecided_des_1 235 305;
  draw_texts undecided_des_2 235 290;
  draw_texts engineer_name 445 330;
  draw_texts engineer_des 430 305;
  draw_texts premed_name 655 330

type button = {
  x_min : int;
  x_max : int;
  y_min : int;
  y_max : int;
}

type choose_student = {
  button : button;
  png_file : string;
  name : string; (*missions : Missions.t list*)
}

let engineer =
  {
    (* button = { x_min = 0; x_max = 1000; y_min = 0; y_max = 650 }; *)
    (* button = { x_min = 630; x_max = 750; y_min = 380; y_max = 444 }; *)
    button = { x_min = 425; x_max = 564; y_min = 280; y_max = 444 };
    png_file = "assets/character/engineer.png";
    name = "engineer";
  }

let premed =
  {
    (* button = { x_min = 425; x_max = 564; y_min = 380; y_max = 444 }; *)
    button = { x_min = 630; x_max = 750; y_min = 280; y_max = 444 };
    png_file = "assets/character/premed.png";
    name = "premed";
  }

let undecided =
  {
    button = { x_min = 213; x_max = 356; y_min = 280; y_max = 444 };
    png_file = "assets/character/freshman.png";
    name = "undecided";
  }

let match_student student x y =
  x > student.button.x_min && x < student.button.x_max
  && y > student.button.y_min && y < student.button.y_max

exception End

let end_game () = failwith "unimplemented"

let in_game () =
  try
    while true do
      draw ();
      let s = Graphics.wait_next_event [ Graphics.Button_down ] in
      if s.Graphics.button then Graphics.moveto 500 200;
      let x = fst (Graphics.mouse_pos ()) in
      let y = snd (Graphics.mouse_pos ()) in
      match (x, y) with
      | x, y when match_student engineer x y ->
          State.in_game engineer.name engineer.png_file 1
            "missions/freshman_engineer.json" 0
      | x, y when match_student premed x y ->
          State.in_game premed.name premed.png_file 1
            "missions/freshman_premed.json" 0
      | x, y when match_student undecided x y ->
          State.in_game undecided.name undecided.png_file 1
            "missions/freshman_undecided.json" 0
      | _, _ -> ()
    done
  with End -> end_game ()
