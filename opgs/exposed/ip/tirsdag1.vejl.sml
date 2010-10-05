(* Introduktion til programmering                    *)
(* DIKU, efteråret 2010                              *)
(* Vejledende løsninger af tirsdagens opgaver, uge 1 *)

(* Opgave 1t1
 *)

(* Delopgave IP-2: 3.7
 * Udtrykket
 *   if not a then b else true
 * bliver til
 *   if a then true else b
 * bliver til
 *   a orelse b
 *
 * Udtrykket
 *   if n mod 2 <> 0 then false else if n mod 3 <> 0 then false else true
 * bliver til
 *   if n mod 2 <> 0 then false else if n mod 3 = 0 then true else false
 * bliver til
 *   if n mod 2 <> 0 then false else n mod 3 = 0
 * bliver til
 *   if n mod 2 = 0 then n mod 3 = 0 else false
 * bliver til
 *   n mod 2 = 0 andalso n mod 3 = 0
 * bliver til (2 og 3 er primiske)
 *   n mod 6 = 0
 *)



(* Delopgave IP-2: 3.8
 *
 * Det er klart at a i begge tilfælde bliver evalueret først. Der er tre
 * tilfælde:
 *  1 Evalueringen slutter aldrig (uendelig løkke).
 *  2 Der evalueres til 'true'.
 *  3 Der evalueres til 'false'.
 * Det eneste interessante tilfælde er 2 idet udtrykkene i tilfælde 1 og 3
 * trivielt evaluerer ens. Antag derfor 2.
 * For begge udtryk ses det at b dernæst evalueres. Argumentationen fortsættes
 * som ovenfor.
 *)



(* Delopgave IP-2: 4.4
 * Note: 0 er ikke et naturligt tal, og vi kan derfor vælge en returværdi
 * frit. Valget falder på 1, da det får rekursionen til at lykkes.
 *)
fun multciffer 0 = 1
  | multciffer n = n mod 10 * multciffer (n div 10)

(* Afprøvning *)
val test_multciffer_00 = multciffer 7 = 7
val test_multciffer_01 = multciffer 735 = 105
