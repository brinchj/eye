(* Vejledende løsninger til tirsdagsopgaverne i IP uge 2. *)

(* 2t1 *)

fun removeprefix (_, []) = []
  | removeprefix (x, y::ys) = if x = y
                              then removeprefix (x, ys)
                              else y::ys;

val test2t1_1 = removeprefix (2, []) = [];
val test2t1_2 = removeprefix ("a", []) = [];
val test2t1_3 = removeprefix (2, [1,2,3,4]) = [1,2,3,4];
val test2t1_4 = removeprefix (2, [2,2,3,4]) = [3,4];
val test2t1_5 = removeprefix (2, [2,2]) = [];
val test2t1_6 = removeprefix ("b", ["a","b","c","d"]) = ["a","b","c","d"];
val test2t1_7 = removeprefix ("a", ["a","a","c","d"]) = ["c","d"];
val test2t1_8 = removeprefix ("a", ["a", "a"]) = [];

(* 2t2 *)

(* Såfremt inputlisten er tom kastes undtagelsen Empty. *)
fun findcharprefix (a::b::cs) = if (a=b)
                                then let val (m, rest) = findcharprefix (b::cs)
                                     in (m+1, rest) end
                                else (1, b::cs)
  | findcharprefix [c]        = (1, [])
  | findcharprefix _          = raise Empty;

val test2t2_0 = findcharprefix ([#"a", #"a", #"b", #"a"]) = (2, [#"b", #"a"]);
val test2t2_1 = findcharprefix ([#"a", #"b", #"a"])       = (1, [#"b", #"a"]);
val test2t2_2 = (findcharprefix ([]); false) handle Empty => true | _ => false;
