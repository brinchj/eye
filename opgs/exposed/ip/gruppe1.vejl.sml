(* Introduktion til programmering             *)
(* DIKU, efteråret 2009                       *)
(* Vejledende løsning af gruppeopgaven, uge 1 *)

(* Opgave 1g1
 *)

fun caesar (0, _) = 0
  | caesar (k, n) =
    (k mod 10 + n) mod 10 + 10 * caesar (k div 10, n)

(* eller med 'let' *)
fun caesar (0, _) = 0
  | caesar (k, n) =
    let
        val hint = k div 10
        val dette = k mod 10
    in
        (dette + n) mod 10 + 10 * caesar (hint, n)
    end

(* eller ved at bemærke at (k mod 10 + n) mod 10 = (k + n) mod 10 *)
fun caesar (0, _) = 0
  | caesar (k, n) =
    (k + n) mod 10 + 10 * caesar (k div 10, n)



(* Opgave 1g2
 *)

fun caesar (0, _) = 0
  | caesar (k, n) =
    if n <= 0 then
        raise Fail "Julle tåler ikke negative nøgler."
    else
        (k + n) mod 10 + 10 * caesar (k div 10, n)



(* Opgave 1g3
 *)

fun caesar (k, n) =
    (* k skal være netop 8 cifre langt *)
    if k < 10000000 orelse k > 99999999 then
        raise Fail "Klartekstens længde passer ikke med stentavlens format (8 cifre)."
    else
        let
            fun caesar' (0, _) = 0
              | caesar' (k, n) =
                if n <= 0 then
                    raise Fail "Julle tåler ikke negative nøgler."
                else
                    (k + n) mod 10 + 10 * caesar' (k div 10, n)
        in
            caesar' (k, n)
        end

(* Eller med brug af 'local' og alternativt tjek af antal cifre *)
local
    fun cifre 0 = 0
      | cifre n = 1 + cifre (n div 10)
    fun caesar' (0, _) = 0
      | caesar' (k, n) =
        (k + n) mod 10 + 10 * caesar' (k div 10, n)
in
fun caesar (k, n) =
    if n <= 0 then
        raise Fail "Nøglen skal være skarpt større end nul."
    else
        if cifre k <> 8 then
            raise Fail "Klarteksten skal være netop 8 cifre lang."
        else
            caesar' (k, n)
end

(* Afprøvning *)
val test_caesar_00 = caesar (74763459, 2) = 96985671
