
(* sum elements *)
fun sum [] = 0
  | sum (n::ns) = n + (sum ns) ;

(* calculate average *)
fun avg lst =
    (real (sum lst)) / (real (length lst)) ;

(* squared error *)
fun se a [] = 0.0
  | se a (x::xs) = Math.pow (((real x)-a), 2.0) + (se a xs) ;

(* mean squared error *)
fun mse lst =
    let val a = avg lst in
      let val b = se a lst in
        b / (real (length lst))
      end
    end ;


(* check if list is sorted *)
fun is_sorted  [] = true
  | is_sorted [a] = true
  | is_sorted (a::b::xs) =
    a <= b andalso (is_sorted (b::xs)) ;


(* find minimum of list *)
fun min [] = 0
  | min (x::xs) =
    let fun min' []      m = m
          | min' (x::xs) m =
            if x < m then (min' xs x) else (min' xs m)
    in
      min' xs x
    end ;


(* reverse list *)
fun rev [] = []
  | rev (x::xs) = (rev xs) @ [x] ;


(* add numbers from two lists *)
fun add_lsts [] [] = []
  | add_lsts (b::bs) (c::cs) = (b+c) :: (add_lsts bs cs) ;


(* accumulate list *)
fun acc [] = []
  | acc lst =
    let fun acc' []      n = [n]
          | acc' (x::xs) n =
            n :: (acc' xs (n+x))
    in
      acc' lst 0
    end ;

(* insert element into sorted list *)
fun ins n [] = [n]
  | ins n (xs as h::t) =
    if n < h then n :: xs else h :: (ins n t) ;

(* insertion sort *)
fun ins_sort [] = []
  | ins_sort (x::xs) = ins x (ins_sort xs) ;


