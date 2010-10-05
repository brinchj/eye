(* Vejledende løsninger til de individuelle opgaver i IP uge 2. *)

(* 2i1 *)

fun repchar (c, 0) = []
  | repchar (c, m) = c :: repchar (c, m-1);

val test2i1_1 = repchar (#"a", 0) = explode "";
val test2i1_2 = repchar (#"b", 1) = explode "b";
val test2i1_3 = repchar (#"c", 3) = explode "ccc";

(* 2i2 *)

(* Hvis listen har et ulige antal elementer smides det sidste element væk. *)
fun combine (x1::x2::xs) = (x1,x2) :: combine xs
  | combine _            = [];

val test2i2_1 = combine [1,2,3,4,5,6] = [(1,2),(3,4),(5,6)];
val test2i2_2 = combine [] = [];

(* 2i3 *)

local fun repchars []           = ""
        | repchars ((c, cm)::l) = implode (repchar (c, ord cm - ord #"0"))
                                  ^ repchars l
in fun rldecompress l = repchars (combine (explode l)) end;

val test2i3_1 = rldecompress "a2b1a6b3u2a4" = "aabaaaaaabbbuuaaaa";
val test2i3_2 = rldecompress "" = "";
val test2i3_3 = rldecompress (rlcompress "Dette er en spændende tekst!")
                = "Dette er en spændende tekst!";

(* 2i4 *)

local
    fun repchars []           = ""
      | repchars ((c, cm)::l) = implode (repchar (c, cm)) ^ repchars l
    fun takenumber []         = (0, [])
      | takenumber (c::cs)    = if Char.isDigit c
                                then let val (ds, r) = takenumber cs
                                         val cm = ord c-ord #"0"
                                     in if ds = 0
                                        then (cm, r)
                                        else ( end
                                else (0, c::cs)
    fun findreps []       = []
      | findreps (c1::cs) = let val (x, r) = takenumber cs
                            in (c1, x)::findreps r end
in fun rldecompress2 s = repchars (findreps (explode s)) end;

(* 2i5 *)

local
    fun countprefix (a::b::cs) = if (a=b)
                                 then let val (_, m, ys) = countprefix (b::cs)
                                      in (a, m+1, ys) end
                                 else (a, 1, b::cs)
      | countprefix [c]        = (c, 1, [])
      | countprefix _          = raise Empty;
    fun countallprefixes [] = []
      | countallprefixes l  = let val (x, m, ys) = countprefix l
                              in (x,m) :: countallprefixes ys end;
    fun repchars []             = ""
      | repchars ((c, cm)::l) = implode (repchar (c, ord cm - ord #"0")) ^ repchars l
    fun compress [] = ""
      | compress ((c, n)::l) = if n < 10
                               then str c ^ str (chr (ord #"0" + n)) ^ compress l
                               else compress ((c, 9)::(c, n-9)::l)
in
fun rlcompress3 cs = compress (countallprefixes (explode cs))
fun rldecompress3 cs = repchars (combine (explode cs))
end
