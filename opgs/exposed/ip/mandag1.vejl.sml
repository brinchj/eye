(* Introduktion til programmering                   *)
(* DIKU, efteråret 2010                             *)
(* Vejledende løsninger af mandagens opgaver, uge 1 *)

(* Opgave 1m1
 * Både 'andalso' og 'orelse' evaluerer først sit venstre argument og derefter
 * sit højre. Begge opperatorer kortslutter, således at i f.eks. udtrykket true
 * orelse f (42) evalueres 'f (42)' aldrig. Se omskrivningsregler for udtryk i
 * appendix A i 'The definition of Standard ML'.  Operatoren 'andalso' binder
 * stærkere end 'orelse' (appendix B).
 *
 * - Udtrykket 'true orelse true andalso false' kortslutter med det
 *   samme. Resultatet er 'true'.
 * - I '(true orelse true) andalso false' evalueres først 'true orelse true' som
 *   kortslutter og bliver 'true'. Derefter evalueres 'true andalso false' (uden
 *   kortslutning) til 'false'.
 * - Udtrykket 'true orelse (true andalso false)' kortslutter med det samme og
 *   giver 'true'.
 *)



(* Opgave 1m2
 *)
(* Er 2016 et skudår? *)
val aar = 2016
val skudaar = if aar mod 100 = 0
              then aar mod 400 = 0
              else aar mod 4 = 0
(* Svaret er 'Ja, 2016 er et skudår'. *)

(* Hvad med 2000? Ja. *)
val aar = 2000
val skudaar = if aar mod 100 = 0
              then aar mod 400 = 0
              else aar mod 4 = 0

(* 1900? Nej. *)
val aar = 1900
val skudaar
    = if aar mod 100 = 0
      then aar mod 400 = 0
      else aar mod 4 = 0

(* Hvor mange dage er der er februar i år 2000? Der er 29. *)
val (aar, maaned) = (2000, 2)
val skudaar
    = if aar mod 100 = 0
      then aar mod 400 = 0
      else aar mod 4 = 0
val maanedslgd
    = if maaned = 2
      then if skudaar then 29 else 28
      else if maaned = 4 orelse maaned = 6
               orelse maaned = 9 orelse maaned = 11
           then 30 else 31


(* Opgave 1m3
 *)
fun skudaarmaaned (aar) =
    let
        val maaned = 2
        val skudaar
            = if aar mod 100 = 0
              then aar mod 400 = 0
              else aar mod 4 = 0
        val maanedslgd
            = if maaned = 2
              then if skudaar then 29 else 28
              else if maaned = 4 orelse maaned = 6
                       orelse maaned = 9 orelse maaned = 11
                   then 30 else 31
    in
        (skudaar, maanedslgd)
    end

(* Afprøvning *)
val test_skudaarmaaned_00 = skudaarmaaned 1700 = (false, 28)
val test_skudaarmaaned_01 = skudaarmaaned 1600 = (true, 29)



(* Opgave 1m4
 * Note: Funktionerne er ikke robuste.
 *)

(* Løsning med tupler *)
nonfix isBeforeT
fun isBeforeT ((h1, m1, f1), (h2, m2, f2)) =
    let
        (* Timen nummeret 12 kan opfattes som 0
         * Se http://en.wikipedia.org/wiki/12-hour_clock
         *)
        val h1r = if h1 = 12 then 0 else h1;
        val h2r = if h2 = 12 then 0 else h2;
    in
        f1 = "AM" andalso f2 = "PM" orelse
        f1 = f2 andalso (h1r < h2r orelse h1r = h2r andalso m1 < m2)
    end

infix isBeforeT

(* Afprøvning *)
val test_isBeforeT_00 = (11, 59, "AM") isBeforeT ( 1, 15, "PM")
val test_isBeforeT_01 = (12,  0, "AM") isBeforeT (11, 59, "AM")
val test_isBeforeT_02 = ( 1,  0, "PM") isBeforeT ( 4,  2, "PM")
val test_isBeforeT_03 = ( 6, 15, "PM") isBeforeT (11,  5, "PM")

(* Løsning med records *)
nonfix isBeforeR
fun isBeforeR ( {hours = h1, minutes = m1, f = f1}
               ,{hours = h2, minutes = m2, f = f2})
    = (h1,m1,f1) isBeforeT (h2,m2,f2)

infix isBeforeR

(* Afprøvning *)
val test_isBeforeR_00 = {hours = 11, minutes = 59, f = "AM"}
                          isBeforeR {hours =  1, minutes = 15, f = "PM"}
val test_isBeforeR_01 = {hours = 12, minutes =  0, f = "PM"}
                          isBeforeR {hours = 11, minutes = 59, f = "PM"}
val test_isBeforeR_02 = {hours =  4, minutes = 58, f = "AM"}
                          isBeforeR {hours = 11, minutes = 59, f = "PM"}
val test_isBeforeR_03 = {hours =  1, minutes =  0, f = "PM"}
                          isBeforeR {hours =  4, minutes =  2, f = "PM"}



(* Opgave 1m6
 *)
(* Delopgave IP-2, 3.1
 *)
fun harfem 0 = false
  | harfem n = n mod 10 = 5 orelse harfem (n div 10)



(* Delopgave IP-2, 3.3
 *)
fun raekketilsoejle (m, n, i) =
    let
      val r = i div m
      val s = i mod m
    in
      s * m + r
    end

(* Det er en trickopgave, det eneste som har betydning er at løbenummeret
 * starter på 1. Det kan korrigeres før og efter konverteringen.
 *)
fun raekketilsoejle2 (m, n, i) = raekketilsoejle (m, n, i - 1) + 1



(* Delopgave IP-2, 3.9
 *)
fun foranstil (w, n) =
    let
      fun nuller 0 = ""
        | nuller n = "0" ^ nuller (n - 1)
      val n' = Int.toString n
      val w' = size n'
    in
      if w >= w' then
        nuller (w - w') ^ n'
      else
        String.substring (n', w' - w, w)
    end
fun tidspunkt (t, m, s) =
    foranstil (2, t) ^ ":" ^ foranstil (2, m) ^ ":" ^ foranstil (2, s)

(* Afprøvning *)
val test_tidspunkt_00 = tidspunkt (8, 12, 5) = "08:12:05"



(* Delopgave IP-2, 4.3
 *
 * Det kan man godt.
 * Uanset valget for (-1)! har vi af ligningen at 0! = 0 * (-1)! = 0. Nu følger
 * det ved induktion at n! = 0 for alle n >= 0. Vi ser at lignen er opfyldt for
 * alle n >= 0.
 *
 * Men hvis man implicit forstår at n! betegner den sædvanlige fakultetsfunktion
 * kan det altså ikke lade sig gøre at udvidde ligninen til at gælde for alle
 * ikke-negative tal.
 *)



(* Delopgave IP-2, 4.6
 * Funktionen går i uendelig løkke for både ulige og negative tal.
 * Af funktionens navn og erklæringen i det hele taget gætter vi på at
 * programmøren har prøvet at skrive en (langsom) funktion som dividerer sit
 * argument med to (og runder ned).
 * Funktionen kan rettes ved at ændre 2-tallet til et 1-tal i else-delen af
 * if-sætningen. Hvorfor?
 *)
fun halve 0 = 0
  | halve n = if n mod 2 = 0 then 1 + halve (n - 2)
              else halve (n - 1)

(* Afprøvning *)
val test_halve_00 = halve 0 = 0 div 2
val test_halve_01 = halve 12 = 12 div 2
val test_halve_02 = halve 31 = 31 div 2
val test_halve_03 = halve 1 = 1 div 2
