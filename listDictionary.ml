open Dictionary

(** [format_assoc_list fmt_key fmt_val fmt lst] formats an association list
    [lst] as a dictionary. The [fmt_key] and [fmt_val] arguments are
    formatters for the key and value types, respectively. The [fmt] argument
    is where to put the formatted output. *)
let format_assoc_list format_key format_val fmt lst =
  (* You are free to improve the output of this function in any way you like. *)
  Format.fprintf fmt "[";
  List.iter
    (fun (k, v) -> Format.fprintf fmt "%a -> %a; " format_key k format_val v)
    lst;
  Format.fprintf fmt "]"
  [@@coverage off]

module Make : DictionaryMaker =
functor
  (K : KeySig)
  (V : ValueSig)
  ->
  struct
    module Key = K
    module Value = V

    type key = K.t

    type value = V.t

    (** AF: The association list [(k0,v0); ...(kn,vn)] represents a dictionary
        {k0:v0, ...kn:vn} with key ki and value vi. [] represent empty
        dictionary RI: The key must be in ascending order. The list contains
        no duplicated key. *)
    type t = (key * value) list

    let rep_ok (d : t) : t =
      let rec check_order prev_key prev_val left acc =
        match left with
        | [] -> (prev_key, prev_val) :: acc |> List.rev
        | (k', v') :: t ->
            if Key.compare prev_key k' = LT then
              check_order k' v' t ((prev_key, prev_val) :: acc)
            else raise (Failure "key is not in order")
      in
      match d with [] -> [] | (k1, v1) :: t -> check_order k1 v1 t []
      [@@coverage off]

    let empty = []

    let is_empty d = match d with [] -> true | (k', v') :: t -> false

    let size d =
      let rec count num lst =
        match lst with [] -> num | h :: t -> count (num + 1) t
      in
      count 0 d

    let insert (k : key) (v : value) (d : t) : t =
      let rec check_insert (k : key) (v : value) (d : t) (acc : t) : t =
        match d with
        | [] -> (k, v) :: acc |> List.rev
        | (k', v') :: t ->
            if Key.compare k' k = EQ then List.rev_append ((k, v) :: acc) t
            else if Key.compare k' k = GT then
              List.rev_append ((k, v) :: acc) ((k', v') :: t)
            else check_insert k v t ((k', v') :: acc)
      in
      check_insert k v d []

    let remove (k : key) (d : t) =
      let rec check_remove (k : key) (d : t) (acc : t) =
        match d with
        | [] -> List.rev acc
        | (key, value) :: t ->
            if Key.compare key k = EQ then List.rev_append acc t
            else if Key.compare key k = GT then
              List.rev_append acc ((key, value) :: t)
            else check_remove k t ((key, value) :: acc)
      in
      check_remove k d []

    let find (k : key) (d : t) : value option =
      let rec check_find (k : key) (d : t) : value option =
        match d with
        | [] -> None
        | (k', v') :: t ->
            if Key.compare k k' = EQ then Some v' else check_find k t
      in
      check_find k d

    let member k d =
      let rec find k d =
        match d with
        | [] -> false
        | (k', v') :: t ->
            if Key.compare k' k = EQ then true
            else if Key.compare k' k = GT then false
            else find k t
      in
      find k d

    let to_list d = d

    let rec fold f init d =
      match d with [] -> init | (k', v') :: t -> fold f (f k' v' init) t

    let format fmt d =
      (* Hint: use [format_assoc_list] as a helper. *)
      format_assoc_list Key.format Value.format fmt d
      [@@coverage off]
  end
