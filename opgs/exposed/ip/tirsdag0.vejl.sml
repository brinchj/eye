(* Introduktion til programmering                    *)
(* DIKU, efteråret 2010                              *)
(* Vejledende løsninger af tirsdagens opgaver, uge 0 *)

(* Opgave 0t1
 *)
fun fact 0 = 1
  | fact n = n * fact (n - 1)

(* At evaluere 'fact 25' giver overløb, fordi SML's type int ikke kan
 * repræsentere så store heltal.
 *)



(* Opgave 0t2
 *)
fun power (x, 0) = 1.0
  | power (x, n) = x * power (x, n - 1)

(* Kaldet power (2, 4) kan ikke evalueres, fordi argumenterne ikke passer med
 * funktionens type.
 *)



(* Opgave 0t3
 * Et programmeringssprog behøver ikke have et typesystem. Grunden til at de
 * fleste sprog har det, er at et typesystem sikrer at nogle typer (pun
 * intended) fejl ikke kan opstå (vi husker fra fysik- og matematiktimerne at
 * man aldrig må blande æbler og pærer). SML's typesystem er et såkaldt statisk
 * (i forhold til dynamisk) typesystem. Det betyder at alle tjek som har med
 * typer at gøre udføres før programmet kører. Det har flere fordele. For det
 * første kan man være sikker på at hvis typesystemet siger at variablen a er et
 * heltal, så er a altid et heltal uanset hvornår og med hvilke inddata
 * programmet afvikles. Den anden fordel er at man ikke behøver holde styr på
 * typerne når programmet kører. Det gør at programmet kører hurtigere.
 *)



(* Opgave 0t4
 *)
fun fooint (n,k) = 2 * n - k * k
fun fooreal (n, k) = 2.0 * n - k * k
fun foorealint (n, k) = 2.0 * n - real (k * k)



(* Afprøvning *)
val test_fact0 = fact 0 = 1
val test_fact1 = fact 4 = 24
val test_power0 = power (2.0, 4) = 16.0
val test_power0 = power (2.0, 0) = 1.0
val test_fooint = fooint (5, 2) = 17
val test_fooreal = fooreal (5.0, 2.0) = 17.0
val test_foorealint = foorealint (5.0, 2) = 17.0
