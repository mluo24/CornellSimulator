(** Module for displaying the end state of the game (game is done). *)

(** [points_message points] calculates the points to a GPA format, then
    returns a string message to display to the player*)
val points_message : int -> string

(**[draw points] draws the state of the end message screen*)
val draw : int -> unit

(** [exception End] thrown in the event in which the player closes the
    graphics window*)
exception End

(** [in_game points] displays the ending screen and closes screen based on
    user interaction (mouse events)*)
val in_game : int -> unit
