(* Introduktion til programmering                       *)
(* DIKU, efteråret 2010                                 *)
(* Vejledende løsning af den individuelle opgave, uge 1 *)

(* Opgave 1i1
 *)

(* Først et brute force -angreb *)
fun brydcaesar (k, c) =
    let
        (* Caesaerkodefunktion til brug ved brute force -angreb *)
        fun caesar (0, _) = 0
          | caesar (k, n) =
            (k + n) mod 10 + 10 * caesar (k div 10, n)

        (* Brute force -angreb.
         * Bemærk at funktionen går i uendelig løkke hvis ingen nøgle
         * eksisterer.
         *)
        fun shakespearmonkey n =
            if caesar (k, n) = c then
                n
            else
                shakespearmonkey (n + 1)
    in
        shakespearmonkey 1
    end

(* Og så et lidt snedigere angreb.
 * Bemærk at der altid returneres en nøgle, også selvom der ikke eksisterer
 * nogen.
 *)
fun brydcaesar (k, c) =
    let
        val n = c mod 10 - k mod 10
    in
        if n < 0 then
            n + 10
        else
            n
    end

(* Og til sidst et rigtigt snedigt angreb.
 *)
fun brydcaesar (k, c) = (c - k) mod 10

(* -- Bevis
 * For et "par" af cifre k' og c' gælder
 *   c' = (k' + n) mod 10
 *
 * Nu gættes n til at være
 *   n = (c' - k') mod 10
 *
 * og gættet verificeres
 *   c' = (k' + (c' - k') mod 10) mod 10
 *   c' = (k' + c' - k') mod 10
 *   c' = c' mod 10
 *   c' = c'           (da 0 <= c' <= 9)
 *
 * Som par af cifre vælges de højreste. Altså
 *   c' = c mod 10   og   k' = k mod 10
 *
 * hvor c og k er chifferteksten og klarteksten henholdsvis. Nøglen er altså
 *   n = (c mod 10 - k mod 10) mod 10
 *   n = (c - k) mod 10
 *)

(* Afprøvning *)
val test_brydcaesar_00 = brydcaesar (55161234, 88494567) = 3



(* Opgave 1i2
 *)

(* Nøglen er 5 *)
val opg2 = brydcaesar (72926349, 27471894)



(* Opgave 1i3
 *)

(* Da funktionen kun skal fungerer for par af klartekster og tilhørende
   chiffertekster er dens opførsel udefineret for par som falder udenfor den
   kategori. Et sådant par er (72926349, 27461894). Funktionen brydcaesar leder
   forgæves efter en kode til dommedag og de snedige versioner tager chancen og
   gætter på en nøgle, selvom der ingen findes.
 *)
