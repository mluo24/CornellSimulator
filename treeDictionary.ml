open Dictionary

module Make =
functor
  (K : KeySig)
  (V : ValueSig)
  ->
  struct
    module Key = K
    module Value = V

    type key = K.t

    type value = V.t

    type color =
      | Red
      | Blk

    type max_val = V.t

    (* AF:[Leaf] represents the empty dictionary. [Node (c, k0, v0, l, r)] represennts
    the dictionary containing the binding of key [k0] value [v0] alongs with all the other bindings represented by [l] [r] subtrees.
     * RI:The BST invariant holds, and the local and global Red-Black tree 
        invariants hold *)
    type t =
      | Leaf
      | Node of (color * key * value * t * t * max_val)

    let debug = false

    (* let rec print_tree_str d = match d with | Leaf -> "leaf" | Node (color,
       key, value, left, right) -> let col = match color with Blk -> "B" | Red
       -> "R" in "Node" ^ col ^ Key.stringnigy key ^ Value.stringnigy value ^
       print_tree_str left ^ print_tree_str right *)

    let rec check_local t prevCol =
      match t with
      | Leaf -> ()
      | Node (color, key, value, left, right, max_val) ->
          if prevCol = Red && color = Red then
            raise (Failure "Red node can not have red child")
          else check_local left color;
          check_local right color
      [@@coverage off]

    let rec count_black t =
      match t with
      | Leaf -> 0
      | Node (color, _, _, left, right, _) -> (
          let left_count = count_black left in
          let right_count = count_black right in
          if left_count <> right_count then
            raise (Failure "not the same number of black on each path")
          else match color with Blk -> 1 + right_count | Red -> right_count)
      [@@coverage off]

    let rec check_bst t (min_val : key option) (max_val : key option) =
      let check_m_val m_val key expected =
        match m_val with
        | None -> ()
        | Some m_val ->
            if Key.compare key m_val <> expected then
              raise (Failure "node in subtree violates BST invariant")
      in
      match t with
      | Leaf -> ()
      | Node (_, key, value, left, right, _) ->
          check_m_val min_val key GT;
          check_m_val max_val key LT;
          check_bst left min_val (Some key);
          check_bst right (Some key) max_val
      [@@coverage off]

    let rep_ok d =
      if debug then
        match d with
        | Leaf -> d
        | Node (color, key, value, left, right, max_val) -> (
            try
              check_bst d None None;
              let _ = count_black d in
              check_local left color;
              check_local right color;
              d
            with Failure ex -> Failure "violate rep_ok" |> raise)
      else d
      [@@coverage off]

    let empty = rep_ok Leaf

    let is_empty d =
      match d with Leaf -> true | Node (_, _, _, _, _, _) -> false

    let size d =
      let rec count d =
        match d with
        | Leaf -> 0
        | Node (_, _, _, left, right, _) -> 1 + count left + count right
      in
      count d

    (** [balance (c, l, v, r)] implements the four possible rotations that
        could be necessary to balance a node and restore the RI clause about
        Red nodes. Efficiency: O(1) *)
    let balance = function
      | ( Blk,
          z1,
          z2,
          Node (Red, y1, y2, Node (Red, x1, x2, a, b, x3), c, y3),
          d,
          z3 )
      | ( Blk,
          z1,
          z2,
          Node (Red, x1, x2, a, Node (Red, y1, y2, b, c, y3), x3),
          d,
          z3 )
      | ( Blk,
          x1,
          x2,
          a,
          Node (Red, z1, z2, Node (Red, y1, y2, b, c, y3), d, z3),
          x3 )
      | ( Blk,
          x1,
          x2,
          a,
          Node (Red, y1, y2, b, Node (Red, z1, z2, c, d, z3), y3),
          x3 ) ->
          Node
            ( Red,
              y1,
              y2,
              Node (Blk, x1, x2, a, b, x3),
              Node (Blk, z1, z2, c, d, z3),
              y3 )
      | t -> Node t

    let insert k v d max =
      let new_node = Node (Red, k, v, Leaf, Leaf, max) in
      let rec insert_node k v d =
        match d with
        | Leaf -> new_node
        | Node (color, key, value, left, right, m) -> (
            match Key.compare k key with
            | EQ -> Node (color, key, v, left, right, m)
            | LT ->
                let new_left = insert_node k v left in
                balance (color, key, value, new_left, right, m)
            | GT ->
                let new_right = insert_node k v right in
                balance (color, key, value, left, new_right, m))
      in
      match insert_node k v d with
      | Leaf -> failwith "impossible"
      | Node (_, key, value, left, right, m) ->
          rep_ok (Node (Blk, key, value, left, right, m))

    let remove k d = failwith "optional"

    let rec find k d =
      match d with
      | Leaf -> None
      | Node (_, key, value, left, right, _) -> (
          match Key.compare k key with
          | LT -> find k left
          | EQ -> Some value
          | GT -> find k right)

    let op_val k op_fun v d = failwith "unimplemented"

    let rec member k d =
      match d with
      | Leaf -> false
      | Node (_, key, _, left, right, _) -> (
          match Key.compare k key with
          | LT -> member k left
          | EQ -> true
          | GT -> member k right)

    let rec fold f acc d =
      match d with
      | Leaf -> acc
      | Node (_, key, value, left, right, _) ->
          let left_acc = fold f acc left in
          let mid_acc = f key value left_acc in
          fold f mid_acc right

    let to_list d =
      let fold_fun k v acc = (k, v) :: acc in
      List.rev (fold fold_fun [] d)

    let format fmt d = failwith "unimplemented"

    (* ListDictionary.format_assoc_list Key.format Value.format fmt (to_list
       d) [@@coverage off] *)
  end
