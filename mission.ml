open Graphics

type t = { mutable text : string }

let init_mission () = { text = "Here Are Your Missions:" }

let draw_missions_window t =
  Graphics.set_color Graphics.black;
  Graphics.fill_rect 800 0 200 560;
  Graphics.moveto 810 500;
  Graphics.set_color Graphics.white;
  Graphics.set_text_size 200;
  Graphics.draw_string t.text
