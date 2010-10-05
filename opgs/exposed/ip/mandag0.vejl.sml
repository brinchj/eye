(* Introduktion til programmering                   *)
(* DIKU, efteråret 2010                             *)
(* Vejledende løsninger af mandagens opgaver, uge 0 *)

(* Opgave 0m5-2
 *)
val toplustreint = 2 + 3
val toplustrereal = 2.0 + 3.0
(* Begge udregninger giver fem. Men den første er et heltal og den anden er et
 * brudent tal. I SML er heltallene og de brudne tal disjunkte mændger (altså: 4
 * og 4.0 er forskellige værdier til trods for at de beskriver samme tal).
 *
 * Det er også grunden til at 2.0 + 3 giver en fejl. I SML virker + (og -) på
 * _enten_ to heltal eller to brudne tal.
 *)



(* Opgave 0m5-3
 *)
fun inc3 n = n + 3
(* Kaldene inc3 (7.0) og inc3 ("Ekbatana") fejler fordi funktionen inc3 har
 * typen int -> int. SML insisterer altså på at dens argument skal være et
 * heltal (og garanterer til gengæld at resultatet - hvis der ikke sker en fejl
 * - er et heltal).
 *)



(* Opgave 0m6: IP-2, 2.1-2.12
 *)
(* Delopgave IP2, 2.1
 *
 * Note: Der står ikke i opgaven om funktionen skal virke på brudne eller hele
 *       tal. Det er ikke muligt at skrive en funktion i SML som virker for
 *       begge slags tal, så vi skriver to forskellige funktioner.
 *)
fun itredjeint n = n * n * n
fun itredjereal (n : real) = n * n * n



(* Delopgave IP2, 2.2
 *)
fun sign n =
    if n = 0 then
      0
    else if n < 0 then
      ~1
    else
      1

(* Det er også muligt at definere funktionen uden brug af if-sætninger: *)
fun sign n = (abs (n + 1) - abs (n - 1)) div 2



(* Delopgave IP2, 2.3
 *
 * Note: Vi antager at der menes "... har stemmeret i Danmark". Man har, på det
 *       tidspunkt hvor disse vejledende løsninger er udarbejdet, stemmeret i
 *       Danmark fra man fylder 18år.
 *
 * Ud fra funktionens type, som skal være int -> bool, gætter vi på at en
 * persons alder er angivet som et helt antal år. Et helt antal sekunder ville
 * være en mulighed, men det ville give os et problem: Hvor mange skudår har
 * personen oplevet? For at svare på det spørgsmål skal vi endvidere kende
 * personens fødselsdato.
 *
 * Denne opgave illustrerer godt, at det nogle gange kan være nødvendigt at
 * præcisere en opgave før det er muligt at besvare den.
 *)
fun stemmeret n = n >= 18



(* Delopgave IP2, 2.4
 *)
fun enderpaafem n = n mod 10 = 5



(* Delopgave IP2, 2.5
 * For at få et betalbart kronebeløb regner vi i antal 25-øre. Der går fire
 * 25-øre på en krone. Vi skal endvidere betale moms som er 25% procent så
 * beløbet skal ganges med 1.25 * 4 = 5.
 * Der afrundes til et helt antal 25-øre med round. Resultatet konverteres
 * tilbage til et brudent tal og divideres med 4 for at få beløbet i kroner.
 *)
fun moms x = real (round (x * 5.0)) / 4.0



(* Delopgave IP2, 2.6
 * Det er velkendt for en datalog at hvis x div y giver "x divideret med y,
 * rundet ned", så giver både (x + y - 1) div y og ~(~x div y) "x divideret med
 * y rundet op". Hvorfor?
 *
 * Med denne viden er opgaven nærmest tríviel, at løse.
 *)
fun hold n = ~(~n div 25)



(* Delopgave IP2, 2.7
 *)
fun gratis n = n >= 80000000 andalso n <= 80999999
fun gratis n = n div 1000000 = 80



(* Delopgave IP2, 2.8
 * Funktionens type er ikke angivet. Jævnfør IP-2, afsnit 2.5.1 er real -> real
 * passende her.
 *
 * Der går (212 - 32) / 100 = 1.8 grader fahrenheit på en grad celcius. Nul
 * grader celcius svarer til 32 grader fahrenheit..
 *)
fun ftilc f = (f - 32.0) / 1.8



(* Delopgave IP2, 2.9
 * Note: Det er ikke gjort klart om funktionen skal virke på heltal eller brudne
 *       tal. Vi har her valgt at den skal virke på hele tal.
 *
 * Det er ikke ligegyldigt hvordan if-sætningerne konstrueres. Nogle vil måske
 * finde det oplagt at skrive
 *   fun stoerste (a, b, c) =
 *       if a > b andalso a > c then
 *         a
 *       else if b > c then
 *         b
 *       else
 *         c
 * Men det er en dårlig idé: Ethvert kald resulterer i mindst to sammenligner,
 * og f.eks. kaldet stoerste (2, 1, 3) resulterer i tre. Løsningen nedenfor
 * resulterer altid i netop to sammenligninger.
 *)
fun stoerste (a, b, c) =
    if a > b then
      if a > c then
        a
      else
        c
    else
      if b > c then
        b
      else
        c



(* Delopgave IP2, 2.10
 *)
fun plural "man" = "men"
  | plural "woman" = "women"
  | plural "mouse" = "mice"
  | plural "sheep" = "sheep"
  | plural n = n ^ "s"



(* Delopgave IP2, 2.11
 * Note: Det forstås implicit at funktionen kun skal virke på tegn som er
 *       bogstaver. Dens opførsel er altså ligegyldig ellers.
 *
 * Lille a er tegn nummer 97 og store a er tegn nummer 65. Vi beslutter at a har
 * nummer 1 (nogen ville måske vælge 0).
 *)
fun bogstavnummer c =
    if Char.isUpper c then
      ord c - 64
    else
      orc c - 96



(* Delopgave IP2, 2.12
 * Note: Der findes faktisk en funktion i standardbiblioteket som undersøger om
 *       een tekst ender på en anden (String.isSuffix), men ud fra vinket
 *       formoder vi at det er snyd at bruge den funktion.
 *
 * Husk på at andalso kortslutter, så højresiden ikke bliver evalueret hvis
 * venstresiden ikke er opfyldt.
 *)
fun enderpaasen s =
    size s >= 3 andalso String.substring (s, size s - 3, 3) = "sen"

fun enderpaa (s, t) =
    size s >= size t andalso String.substring (s, size s - size t, size t) = t

(* Afprøvning
 * De funktioner som bruger brudne tal er ikke afprøvet her fordi variationer i
 * hardware og software kan gøre at sammenligning af brudne tal giver
 * overraskende resultater.
 *)
val test_sign_00 = sign 0 = 0
val test_sign_01 = sign 345 = 1
val test_sign_02 = sign ~2 = ~1
val test_stemmeret_00 = not (stemmeret 3)
val test_stemmeret_01 = stemmeret 18
val test_stemmeret_02 = stemmeret 101
val test_enderpaafem_00 = not (enderpaafem 0)
val test_enderpaafem_01 = not (enderpaafem 7)
val test_enderpaafem_02 = not (enderpaafem 70)
val test_enderpaafem_03 = not (enderpaafem ~28)
val test_enderpaafem_04 = enderpaafem 5
val test_enderpaafem_05 = enderpaafem 105
val test_enderpaafem_06 = enderpaafem ~735
val test_gratis_00 = not (gratis 0)
val test_gratis_01 = not (gratis 12345678)
val test_gratis_02 = gratis 80123456
val test_gratis_03 = not (gratis 8012345)
val test_stoerste_00 = stoerste (1, 2, 3) = 3
val test_stoerste_01 = stoerste (3, 3, 3) = 3
val test_stoerste_02 = stoerste (~3, 3, 2) = 3
val test_hold_00 = hold 0 = 0
val test_hold_01 = hold 1 = 1
val test_hold_02 = hold 25 = 1
val test_hold_03 = hold 36 = 2
