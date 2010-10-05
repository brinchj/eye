(* Mandagsøvelser for uge 3, IP 2010 *)
(* Vejledende løsninger *)

(* 3m1 *)
(* En datatype erklæres for karakterer. *)
datatype karakter = K'3 | K00 | K02 | K4 | K7 | K10 | K12
(* Følgende datatype er ikke nær så afgrænsende. *)
(* datatype karakter = Karakter of int *)

(* 3m2 *)
(* Eksempelværdier *)
val jytte_haandgerning = K10
val jens_hjemkundskab = K4

(* 3m3 *)
(* Der er færrest karakterer som dumper. *)
fun best K'3 = false
  | best K00 = false
  | best _ = true

(* 3m4 *)
(* En datatype for årstal *)
datatype aarstal = Aar of int
                 | UkendtAar
                 | IrrelevantAar

(* 3m5 *)
(* En datatype til at repræsentere personer (med navn og køn) *)
datatype navn = Navn of string
              | UkendtNavn

datatype kon = Mand
             | Kvinde
             | UkendtKon
          (* | Queer (* http://en.wikipedia.org/wiki/Genderqueer *) *)

(* Alternativ ved brug af records frem for en 4-tuple:
type person = {navn : string,
               kon : kon,
               fodselsaar : int,
               dodsaar : int} *)

(* I stedet benyttes en 4-tuple fordi syntaksen er mere behagelig. *)
datatype person = Person of navn * kon * aarstal * aarstal

(* 3m6 *)
(* Eksempelværdier *)
val jytte = Person (Navn "Jytte", Kvinde, Aar 1932, Aar 2009)
val jens = Person (Navn "Jens", Mand, Aar 1985, IrrelevantAar)
val snej = Person (Navn "Jens omvendt", Mand, Aar 2000, Aar 1900)

(* 3m7 *)
(* En funktion integritet : person -> bool.
 * Kaldet integritet (p) returnerer om det vides at
 * personen p's fødselsår er mindre end personens dødsår. *)
fun integritet (Person (_, _, IrrelevantAar, _)) = false
  | integritet (Person (_, _, Aar f, Aar d)) = f < d
  | integritet _ = true

val integritet_test_1 = integritet jytte
val integritet_test_2 = integritet jens
val integritet_test_3 = not (integritet snej)

(* 3m8, eller HR 7.2 *)
(* En funktion smallest : int list -> int option.
 * Kaldet smallest (xs) returnerer den mindste værdi
 * blandt elementer i en liste, hvis et sådant findes. *)
fun smallest [] = NONE
  | smallest [x] = SOME x
  | smallest (x1::x2::xs) = smallest ((if x1 < x2 then x1 else x2)::xs)

(* Alternativ som benytter biblioteksfunktionen Int.min. *)
;load "Int";
fun smallest [] = NONE
  | smallest [x] = SOME x
  | smallest (x1::x2::xs) = smallest (Int.min (x1, x2)::xs)

val smallest_test_1 = smallest [1,2,3,4,5,6] = SOME 1
val smallest_test_2 = smallest [9,1,1,~5,25] = SOME ~5
val smallest_test_3 = smallest [] = NONE
