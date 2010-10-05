(* -*- encoding: utf-8 -*- *)
(* Introduktion til programmering                   *)
(* DIKU, efteråret 2010                             *)
(* Vejledende løsninger af mandagens opgaver, uge 4 *)

(* Opgave 4m1
 *)
fun add0 (a, b, c) = a + b + c
val add1 = fn (a, b, c) => a + b + c
fun add2 a b c = a + b + c
val add3 = fn a => fn b => fn c => a + b + c

(* Funktionerne deler sig i to lejre: add0 og add1 tager sine tre parametre som
 * en tre-tupel, hvorimod add2 og add3 tager dem som tre sekventialiserede
 * argumenteter. Typerne er:
 *   add0 : int * int * int -> int
 *   add1 : int * int * int -> int
 *   add2 : int -> int -> int -> int
 *   add3 : int -> int -> int -> int
 *
 * Derudover er der en lille forskel på add0 og add1 henholdsvis add2 og add3:
 * Når "fun"-notationen bruges kan man skrive rekursive funktioner. Det kan man
 * ikke med "val"-notationen.
 *
 * Følgende kald binder a til 2, b til 5 og c 6 i hver af de fire
 * funktionskroppe.
 *)
val add0kald = add0 (2, 5, 6)
val add1kald = add1 (2, 5, 6)
val add2kald = add2 2 5 6
val add3kald = add3 2 5 6

(* Ved at se på typen for add3 ser vi at typen for add3a, add3b og add3c bliver
 * int -> int -> int, int -> int og int henholdsvis. Husk på at -> er
 * højreassociativ.
 *)
val add3a = add3 2     : int -> int -> int
val add3b = add3 2 5   : int -> int
val add3c = add3 2 5 6 : int

(* Fakultetsfunktionen og map (for let reference) erklæres, og de tre kald
 * udføres.
 *)
fun fact 0 = 1
  | fact n = n * fact (n - 1)

fun map _ nil = nil
  | map f (x :: xs) = f x :: map f xs

val kald1 = (fn n => n * n) 7
val kald2 = map (fn n => n + n) [2, 5, 6]
val kald3 = map fact [2, 5, 6]

(* Beregning af de tre udtryk håndkøres.
 * I det nedenstående betyder "(eval)" beregn, "(app)" anvend anonym funktion,
 * "(app-m1)" anvend map's første mønster, "(app-m2)" anvend map's andet
 * mønster og "(nota)" omskrivning i henhold til særlig notation.
 *
 *  (fn n => n * n) 7                                              --> (app)
 *  7 * 7                                                          --> (eval)
 *  49
 *
 *  map (fn n => n + n) [2, 5, 6]                                  --> (app-m2)
 *  (fn n => n + n) 2 :: map (fn n => n + n) [5, 6]                --> (app)
 *  2 + 2 :: map (fn n => n + n) [5, 6]                            --> (eval)
 *  4 :: map (fn n => n + n) [5, 6]                                --> (app-m2)
 *  4 :: (fn n => n + n) 5 :: map (fn n => n + n) [6]              --> (app)
 *  4 :: 5 + 5 :: map (fn n => n + n) [6]                          --> (eval)
 *  4 :: 10 :: map (fn n => n + n) [6]                             --> (app-m2)
 *  4 :: 10 :: (fn n => n + n) 6 :: map (fn n => n + n) []         --> (app)
 *  4 :: 10 :: 6 + 6 :: map (fn n => n + n) []                     --> (eval)
 *  4 :: 10 :: 12 :: map (fn n => n + n) []                        --> (app-m1)
 *  4 :: 10 :: 14 :: []                                            --> (nota)
 *  [4, 10, 14]
 *
 *  map fact [2, 5, 6]                                             --> (app-m2)
 *  fact 2 :: map fact [5, 7]                                      --> ...
 *  2 :: map fact [5, 6]                                           --> (app-m2)
 *  2 :: fact 5 :: map fact [6]                                    --> ...
 *  2 :: 120 :: map fact [6]                                       --> (app-m2)
 *  2 :: 120 :: fact 6 :: map fact []                              --> ...
 *  2 :: 120 :: 720 :: map fact []                                 --> (app-m1)
 *  2 :: 120 :: 720 :: []                                          --> (nota)
 *  [2, 120, 720]
 *)



(* Opgave 4m2
 *)
fun twice f x = f (f x)

(* Udtryk        Type
 * x             'a
 * f x           'a
 * f             'a -> 'a
 * f (f x)       'a
 * twice f x     'a
 * twice f       'a -> 'a
 * twice         ('a -> 'a) -> 'a -> 'a
 *)

(* Funktionen f kan ikke have type 'a -> 'b da den jo kaldes på resultatet af
 * at kalde den på x. Resultatet må da have samme type som argumentet.
 *)

(* For en alternativ tilgang er herunder angivet hvorledes problemet,
 * med at afg�re hvilken type twice har, ogs� kan angribes lidt anderledes.
 *   fun twice f x = f (f x)
 * 1) twice har to argumenter og et resultat, derfor ser skelettet s�ledes ud:
 *      [1st arg] -> [2nd arg] -> [resultat]
 * 2) x har typen 'a
 * 3) Som beskrevet i afsnittet ovenfor m� f have typen 'a -> 'a
 * 4) Vi ender derfor med typen: ('a -> 'a) -> 'a -> 'a
 *
 * 5) twice f: Ved at give twice f�rste parameter dannes en ny funktion
 *      af typen: 'a -> 'a
 * 6) Anvendes denne funktion p� en v�rdi af typen 'a, er resultatet selv
      en v�rdi af typen 'a.
 *)

(* Funktionen twice anvendes som foreskrevet.
 *)
val twicekald1 = twice (fn n => n) 3
val twicekald2 = twice (fn n => n + n) 3
val twicekald3 = twice twice (fn n => n + n) 3

(* Udtrykkene beregnes ved håndkøring. Samme notation som ovenfor, med den
 * tilføjelse at "(app-t)" betyder anvend twice. Husk på at funktionsanvendelse
 * er venstreassociativ. Øvelse: sæt de underforståede parenteser.
 *
 *  twice (fn n => n) 3                                            --> (app-t)
 *  (fn n => n) ((fn n => n) 3)                                    --> (app)
 *  (fn n => n) 3                                                  --> (app)
 *  3
 *
 *  twice (fn n => n + n) 3                                        --> (app-t)
 *  (fn n => n + n) ((fn n => n + n) 3)                            --> (app)
 *  (fn n => n + n) (3 + 3)                                        --> (eval)
 *  (fn n => n + n) 6                                              --> (app)
 *  6 + 6                                                          --> (eval)
 *  12
 *
 * Hold nu tungen lige i munden!
 *  twice twice (fn n => n + n) 3                                  --> (app-t)
 *  twice (twice (fn n => n + n)) 3                                --> (app-t)
 *  twice (fn n => n + n) (twice (fn n => n + n) 3)                --> (app-t)
 *  twice (fn n => n + n) ((fn n => n + n) ((fn n => n + n) 3))    --> (app)
 *  twice (fn n => n + n) ((fn n => n + n) (3 + 3))                --> (eval)
 *  twice (fn n => n + n) ((fn n => n + n) 6)                      --> (app)
 *  twice (fn n => n + n) (6 + 6)                                  --> (eval)
 *  twice (fn n => n + n) 12                                       --> (app-t)
 *  (fn n => n + n) ((fn n => n + n) 12)                           --> (app)
 *  (fn n => n + n) (12 + 12)                                      --> (eval)
 *  (fn n => n + n) 24                                             --> (app)
 *  24 + 24                                                        --> (eval)
 *  48
 *)


(* Opgave 4m3
 *)
infixr 3 $
fun f $ x = f x

(* Udtryk        Type
 * x             'a
 * f x           'b
 * f             'a -> 'b
 * (f, x)        ('a -> 'b, 'a)
 * f $ x         'b
 * op $          ('a -> 'b) * 'a -> 'b
 *)

val applykald1 = (fn n => n) $ 7
val applykald2 = (fn n => n * n) $ 7
val applykald3 = (fn n => n + n) $ fact $ 3
val applykald4 = fact $ (fn n => n + n) $ 3
(* val applykald5 = let fun foo n = foo n in foo $ 0 end *)

(* Endnu en håndkøring. Samme notation som ovenfor, men den tilføjelse at
 * "(app-$)" betyder andvend $ og "(app-f)" betyder anvend foo. Husk på at $ er
 * højreassociativ. Prøv at lave håndkøringen selv ved siden af på et stykke
 * papir.
 *
 *  (fn n => n) $ 7                                                --> (app-$)
 *  (fn n => n) 7                                                  --> (app)
 *  7
 *
 *  (fn n => n * n) $ 7                                            --> (app-$)
 *  (fn n => n * n) 7                                              --> (app)
 *  7 * 7                                                          --> (eval)
 *  49
 *
 *  (fn n => n + n) $ fact $ 3                                     --> (app-$)
 *  (fn n => n + n) $ fact 3                                       --> ...
 *  (fn n => n + n) $ 6                                            --> (app-$)
 *  (fn n => n + n) 6                                              --> (app)
 *  6 + 6                                                          --> (eval)
 *  12
 *
 *  fact $ (fn n => n + n) $ 3                                     --> (app-$)
 *  fact $ (fn n => n + n) 3                                       --> (app)
 *  fact $ 3 + 3                                                   --> (eval)
 *  fact $ 6                                                       --> (app-$)
 *  fact 6                                                         --> ...
 *  720
 *
 *  let fun foo n = foo n in foo $ 0 end                           --> (app-$)
 *  let fun foo n = foo n in foo 0 end                             --> (app-f)
 *  let fun foo n = foo n in foo 0 end                             --> (app-f)
 *  let fun foo n = foo n in foo 0 end                             --> (app-f)
 *  ... (uendelig løkke) ...
 *)



(* Opgave 4m4
 *)
(* Dårligt *)
fun affin (a, b) = fn x => a * x + b

(* Godt *)
fun affin (a, b) x = a * x + b

val affin2komma5 = affin (2, 5)
(* MosML svarer blot at værdien er en funktion af type int -> int. Men vi ved at
 * det er funktionen fn x => 2 * x + 5, altså den funktion som sender x over i
 * to gange x plus fem.
 *)



(* Opgave 4m5
 *)
(* Dårligt *)
fun affinlist (p :: ps) = affin p :: affinlist ps

(* Bedre *)
fun affinlist ps = map affin ps

(* Bedst *)
val affinlist = map affin
