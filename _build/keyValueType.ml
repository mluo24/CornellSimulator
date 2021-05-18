(** [StringKey] provides the necessary definitions to use strings as keys in
    dictionaries. *)

open Dictionary
open GameGaugesDict

module String : KeyType with type t = string = struct
  type t = string

  let compare s1 s2 = Stdlib.compare s1 s2

  let to_string t = Fun.id t

  let format fmt s = Format.fprintf fmt "\"%s\"" s [@@coverage off]
end

module CaselessString : KeyType with type t = string = struct
  type t = string

  let to_string t = Fun.id t

  let compare s1 s2 =
    Stdlib.compare
      (Stdlib.String.lowercase_ascii s1)
      (Stdlib.String.lowercase_ascii s2)

  let format fmt s =
    Format.fprintf fmt "\"%s\"" (Stdlib.String.lowercase_ascii s)
    [@@coverage off]
end

module IntPos : GameNum with type t = int = struct
  exception IllegalSubtraction

  type t = int

  let to_string t = string_of_int t

  let compare x y = Stdlib.compare x y

  let format fmt x = Format.fprintf fmt "%d" x

  let add i1 i2 = i1 + i2

  let minimum = 0

  let defualt = 20

  let subtract i1 i2 =
    let num = i1 - i2 in
    if num < minimum then raise IllegalSubtraction else num
end
