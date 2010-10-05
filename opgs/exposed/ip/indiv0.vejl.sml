(* Introduktion til programmering                         *)
(* DIKU, efteråret 2010                                   *)
(* Vejledende løsninger af den individuelle opgave, uge 0 *)

(* Opgave 0i1
 *)
fun prob (p, n, k) = power (p, k) * power (1.0 - p, n - k)



(* Opgave 0i2
 *)
fun binompr (n, k, p) =
    real (binomk (n, k)) * prob (p, n, k)



(* Opgave 0i3
 * Resultater er omtrent 19.7% hvilket er verificeret på en lommeregner.
 *)
val karl3af12 = binompr (12, 3, 1.0/6.0)
