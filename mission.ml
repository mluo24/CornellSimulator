open Graphics

type t = {
  mutable text : string;
  mutable missions : string list;
}

let missions_level_1 =
  [ "- Catch 3 Camels"; "- Avoid the Bears"; "- Pass prelims" ]

let init_mission () =
  { text = "Here Are Your Missions:"; missions = missions_level_1 }

let draw_missions_window t =
  Graphics.set_color Graphics.black;
  Graphics.fill_rect 800 0 200 560;
  Graphics.moveto 810 500;
  Graphics.set_color Graphics.white;
  Graphics.set_text_size 200;
  Graphics.draw_string t.text
