open Graphics

type t = {
  mutable text : string;
  mutable missions : string list;
}

(* end of mission -> transition to another mission json file (pass in prev
   score)*)

(* make a seperate endofstate file *)

let missions_level_1 =
  [ "- Catch 3 Camels"; "- Avoid the Bears"; "- Pass prelims" ]

let init_mission () =
  { text = "Here Are Your Missions:"; missions = missions_level_1 }

let rec draw_missions_list missions y =
  match missions with
  | [] -> ()
  | h :: tail ->
      let y = y - 25 in
      Graphics.moveto 810 y;
      Graphics.draw_string h;
      draw_missions_list tail y

let draw_missions_window t =
  Graphics.set_color Graphics.black;
  Graphics.fill_rect 800 0 200 560;
  Graphics.moveto 810 500;
  Graphics.set_color Graphics.white;
  Graphics.set_text_size 200;
  Graphics.draw_string t.text;
  draw_missions_list t.missions 500
