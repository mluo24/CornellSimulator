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

let draw () =
  let img =
    ImageHandler.get_entire_image "assets/character/starterpagedemo.png"
  in
  let graphics_img = ImageHandler.get_tileset_part 0 0 1000 560 img in
  Graphics.draw_image graphics_img 0 0;
  Graphics.moveto 360 510;
  Graphics.draw_string introduction_line1;
  Graphics.moveto 260 470;
  Graphics.draw_string introduction_line2;
  Graphics.moveto 235 330;
  Graphics.draw_string undecided_name;
  Graphics.moveto 235 305;
  Graphics.draw_string undecided_des_1;
  Graphics.moveto 235 290;
  Graphics.draw_string undecided_des_2;
  Graphics.moveto 445 330;
  Graphics.draw_string engineer_name;
  Graphics.moveto 430 305;
  Graphics.draw_string engineer_des;
  Graphics.moveto 655 330;
  Graphics.draw_string premed_name;
  Graphics.moveto 670 305;
  Graphics.draw_string premed_des

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
    button = { x_min = 425; x_max = 564; y_min = 380; y_max = 444 };
    png_file = "assets/character/engineer.png";
    name = "engineer";
  }

let premed =
  {
    (* button = { x_min = 425; x_max = 564; y_min = 380; y_max = 444 }; *)
    button = { x_min = 630; x_max = 750; y_min = 380; y_max = 444 };
    png_file = "assets/character/premed.png";
    name = "premed";
  }

let undecided =
  {
    button = { x_min = 213; x_max = 356; y_min = 380; y_max = 444 };
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
      if s.Graphics.button then
        let x = fst (Graphics.mouse_pos ()) in
        let y = snd (Graphics.mouse_pos ()) in
        match (x, y) with
        | x, y when match_student engineer x y ->
            State.in_game engineer.name engineer.png_file
        | x, y when match_student premed x y ->
            State.in_game premed.name premed.png_file
        | x, y when match_student undecided x y ->
            State.in_game undecided.name undecided.png_file
        | _, _ -> ()
    done
  with End -> end_game ()
