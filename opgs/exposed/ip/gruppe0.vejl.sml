(* Introduktion til programmering               *)
(* DIKU, efteråret 2010                         *)
(* Vejledende løsninger af gruppeopgaven, uge 0 *)

(* Opgave 0g1
 * / dividerer brudne tal (kommatal), dvs. typen er real og div er
 * defineret på typen af heltal (int). div afrunder mod negativt
 * uendeligt og resten efter divisionen kan findes med "mod"- (modulus)
 * funktionen.
 *)



(* Opgave 0g2
 *)
fun binomk (n, k) = fact n div (fact k * fact (n - k))

(* Alternativ løsning
 * Her udnyttes det at brøken i definitionen kan forkortes med fact (n - k)
 * mult n m beregner n * n+1 * ... * m-1 * m.
 * For eksempel mult 3 6 = 3*4*5*6
 *)
fun mult n k =
    if n = k then
      k
    else
      n * mult (n + 1) k
fun binomk_faster (n, k) = mult (n - k + 1) n div fact k



(* Opgave 0g3
 *)
fun binomk2 (n, 0) = 1
  | binomk2 (n, k) =
    if n = k then
      1
    else
      binomk2 (n - 1, k - 1) + binomk2 (n - 1, k)



(* Afprøvning *)
val test_binomk_00 = binomk (5,2) = 10
val test_binomk_01 = binomk (5,4) = 5
val test_binomk_02 = binomk (1,1) = 1
val test_binomk_03 = binomk (2,0) = 1
val test_binomk2_00 = binomk2 (5,2) = 10
val test_binomk2_01 = binomk2 (5,4) = 5
val test_binomk2_02 = binomk2 (1,1) = 1
val test_binomk2_03 = binomk2 (2,0) = 1
