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

  let meaningful_line_count filename =
    let meaningful_line line =
      let trimmed = String.trim line in
      not (String.length trimmed = 0 || String.get trimmed 0 = '#')
    in
    let ic = open_in filename in
    let rec count_lines_aux count =
      try
        let line = input_line ic in
        if meaningful_line line then count_lines_aux (count + 1)
        else count_lines_aux count
      with End_of_file -> count
    in
    Fun.protect ~finally:(fun () -> close_in ic) (fun () -> count_lines_aux 0)
  

    type shape = 
  | Sphere of float
  | Box of float * float * float

let pi = 3.141592653589793

let volume = function 
  | Sphere r -> 4.0 /. 3.0 *. pi *. r ** 3.0
  | Box (l, w, h) -> l *. w *. h

let surface_area = function
  | Sphere r -> 4.0 *. pi *. r ** 2.0
  | Box (l, w, h) -> 2.0 *. (l *. w +. w *. h +. h *. l)

let epsilon = 0.0001

let float_expect actual expected =
  abs_float (actual -. expected) < epsilon


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

let rec insert value tree = 
  match tree with
  | Empty -> Node (value, Empty, Empty)
  | Node (v, left, right) ->
    if value = v then tree  
    else if value < v then Node (v, insert value left, right)
    else Node (v, left, insert value right)