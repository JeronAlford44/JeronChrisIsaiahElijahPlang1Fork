exception Negative_Amount

let change amount =
  if amount < 0 then
    raise Negative_Amount
  else
    let denominations = [25; 10; 5; 1] in
    let rec aux remaining denominations =
      match denominations with
      | [] -> []
      | d :: ds -> (remaining / d) :: aux (remaining mod d) ds
    in
    aux amount denominations


let first_then_apply array predicate consumer =
  match List.find_opt predicate array with
  None -> None
| Some x -> consumer x

let powers_generator base =
  let rec generate_from power () = 
    Seq.Cons (power, generate_from  (power * base))
  in
  generate_from  1

(* Write your line count function here *)

type shape = 
  | Sphere of float
  | Box of float * float * float
  

let volume = function 
  | Sphere r -> 4.0 /. 3.0 *. 3.14159265359 *. r ** 3.0
  | Box (l, w, h) -> l *. w *. h


type 'a binary_search_tree = 
  | Empty
  | Node of 'a * 'a binary_search_tree * 'a binary_search_tree

  let rec size tree = 
    match tree with
    | Empty -> 0
    | Node (_, left, right) -> 1 + size left + size right

  let rec contains value tree = 
    match tree with
    | Empty -> false
    | Node (v, left, right) -> 
      if value = v then true
      else if value < v then contains value left
      else contains value right

  let rec inorder tree = 
    match tree with
    | Empty -> []
    | Node (v, left, right) -> inorder left @ [v] @ inorder right