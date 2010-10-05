(* Vejledende løsninger til mandagsopgaverne i IP uge 2. *)

(* 2m1 *)

val x = [1,8,3];

(* 2m2 *)

val x = [4,8,~2,1];

(* 2m3 *)

(*
 [8,3,1] : int list
 [] : 'a list
 ["Ekhlewagastir", "Holtijar"] : string list
 [ 2,"Erasmus",5,5] - typefejl.
  Lister kan kun indeholder elementer af samme type.
*)

(* 2m4 *)

(* Subscript er den sædvanlige undtagelse når man forsøger at tilgå et
ikke-eksisterende element i en sekvens. *)

fun nte2 (_::_::x::_) = x
  | nte2 _            = raise Subscript;

val test2m4_0 = nte2 [5,4,9,5,2] = 9;
val test2m4_1 = nte2 [5,4,3] = 3;
val test2m4_2 = (nte2 [5,4]; false) handle Subscript => true | _ => false;
val test2m4_3 = (nte2 []; false)    handle Subscript => true | _ => false;

(* 2m5 *)

(* Kan også løses som ovenstående, men det ville være grimt. *)
local
    (* Hjælpefunktion der giver element nummer N i en liste *)
    fun nteNth ([], _)    = raise Subscript
      | nteNth (x::_,0)   = x
      | nteNth (_::xs, i) = nteNth (xs, i-1)
in
fun nte19 l = nteNth (l, 19)
end;

val test2m5_0 = nte19 [5,4,9,5,2,1,2,4,5,6,1,2,5,6,1,2,4,5,8,1,2,3,5,6] = 1;
val test2m5_1 = nte19 [5,4,9,5,2,1,2,4,5,6,1,2,5,6,1,2,4,5,8,1] = 1;
val test2m5_2 = (nte19 [5,4]; false) handle Subscript => true | _ => false;
val test2m5_3 = (nte19 []; false)    handle Subscript => true | _ => false;

(* 2m6 *)

fun foranAlle (_, []) = []
  | foranAlle (x, y::ys) = (x::y) :: foranAlle (x, ys);

val test2m6_0 = foranAlle (#"s", [[#"t", #"e", #"n"], [], [#"a", #"v"]]) =
                [[#"s", #"t", #"e", #"n"], [#"s"], [#"s", #"a", #"v"]];
val test2m6_1 = foranAlle (#"s", []) = [];

(* 2m7 *)

fun rmodd []      = []
  | rmodd (x::xs) = if x mod 2 = 0
                    then x :: rmodd xs
                    else rmodd xs;

val test2m7_0 = rmodd [] = [];
val test2m7_1 = rmodd [2,4,6,8] = [2,4,6,8];
val test2m7_2 = rmodd [1,2,3,4,5,6,7,8,9] = [2,4,6,8];
val test2m7_3 = rmodd [1,3,5,7,9] = [];
