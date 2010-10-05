(* Vejledende løsninger til gruppeopgaverne i IP uge 2. *)

(* 2g1 *)

fun countprefix (a::b::cs) = if (a=b)
                             then let val (_, m, ys) = countprefix (b::cs)
                                  in (a, m+1, ys) end
                             else (a, 1, b::cs)
  | countprefix [c]        = (c, 1, [])
  | countprefix _          = raise Empty;


val test2g1_1 = countprefix [#"a", #"a", #"b", #"a"] = (#"a", 2, [#"b", #"a"]);
val test2g1_2 = (countprefix []; false) handle Empty => true | _ => false;
val test2g1_3 = countprefix [#"a", #"a", #"a"] = (#"a", 3, []);

(* 2g2 *)

fun countallprefixes [] = []
  | countallprefixes l  = let val (x, m, ys) = countprefix l
                          in (x,m) :: countallprefixes ys end;

val test2g2_1 = countallprefixes [#"a", #"a", #"b", #"a"]
                = [(#"a", 2), (#"b", 1), (#"a", 1)];
val test2g2_2 = countallprefixes [] = [];
val test2g2_3 = countallprefixes [#"a", #"a", #"a"] = [(#"a", 3)];

(* 2g3 *)

fun rlcwrite []            = ""
  | rlcwrite ((c,1) :: xs) = str c ^ rlcwrite xs
  | rlcwrite ((c,m) :: xs) = str c ^ rlcwrite ((c,m-1) :: xs);

val test2g3_1 = rlcwrite ([(#"a", 2), (#"b", 1), (#"a", 1)]) = "aaba";
val test2g3_2 = rlcwrite [] = "";

(* 2g4 *)
local fun writepairs []         = ""
        | writepairs ((c,m)::l) = str c ^ Int.toString m ^ writepairs l
in fun rlcompress s = writepairs (countallprefixes (explode s)) end;

val test2g4_1 = rlcompress "aabaaaaaabbbuuaaaa" = "a2b1a6b3u2a4";
val test2g4_1 = rlcompress "" = "";

(* 2g5 *)

(* Det potentielt flercifrede antal tegngentagelser skrives blot
       direkte; se afprøvningerne. *)
local fun writepairs []         = ""
        | writepairs ((c,1)::l) = str c ^ writepairs l
        | writepairs ((c,m)::l) = str c ^ Int.toString m ^ writepairs l
in fun rlcompress2 s = writepairs (countallprefixes (explode s)) end;

val test2g5_1 = rlcompress2 "aabaaaaaabbbuuaaaa" = "a2ba6b3u2a4";
val test2g5_1 = rlcompress2 "aaaaaaaaaaaaaaaaaaaaaaaabcd" = "a24bcd";
val test2g5_1 = rlcompress2 "" = "";
