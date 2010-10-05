(* Tirsdagsøvelser for uge 3, IP 2010 *)
(* Vejledende løsninger *)

(* Datatyper gentages fra mandagsøvelserne til at repræsentere personer. *)
datatype aarstal = Aar of int
                 | UkendtAar
                 | IrrelevantAar

datatype navn = Navn of string
              | UkendtNavn

datatype kon = Mand
             | Kvinde
             | UkendtKon
          (* | Queer (* http://en.wikipedia.org/wiki/Genderqueer *) *)

datatype person = Person of navn * kon * aarstal * aarstal

(* 3t1
 * Strategien i aeldst er løbende at frasortere alle ikke-gyldige personer,
 * altså personer uden defineret førdselsår eller med dødsår. Er en gyldig
 * person tilbage må dette være den ældste, findes ingen må der ikke eksistere
 * en gyldig ældste person. *)
local
  (* Afprøvning af hjælpefunktion aeldst2 *)
  val erik = Person (Navn "Erik", Mand, Aar 1990, IrrelevantAar)
  val mads = Person (Navn "Mads", Mand, Aar 1989, Aar 2007)
  val elin = Person (Navn "Elin", Kvinde, Aar 1985, IrrelevantAar)
  val arne = Person (Navn "Arne", Mand, Aar 1987, Aar 2007)
in
  fun aeldst ((p1 as Person (_, _, Aar a1, IrrelevantAar))::
              (p2 as Person (_, _, Aar a2, IrrelevantAar))::ps)
      = if a1 < a2
          then aeldst (p1::ps)
          else aeldst (p2::ps)
    | aeldst ((p as Person (_, _, Aar _,IrrelevantAar))::_::ps) = aeldst (p::ps)
    | aeldst ((p as Person (_, _, Aar _,IrrelevantAar))::[]) = SOME p
    | aeldst ([]) = NONE
    | aeldst (p::ps) = aeldst (ps)

  val aeldst_test_1 = aeldst [erik, mads, elin, arne] = SOME elin
  val aeldst_test_2 = aeldst [mads, arne] = NONE
  val aeldst_test_3 = aeldst [erik, erik, erik, erik] = SOME erik

  (* Særligt grænsetilfælde:
   * Levende mennesker hvis alder er ukendt fraregnes automatisk. Dette
   * er problematisk da en sådan person vil være ældst iblandt en liste
   * af døde mennesker, men i tilfælde af to sådanne mennesker vil NONE
   * være det eneste rimelige svar da en sammenligning ikke er mulig.
   *
   * En løsning som tager forbehold for dette er imidlertid udeladt. *)
end

(* 3t2 *)
(* Følgende anetræ garanterer ikke imod konstruktionen af et træ med to fædre,
 * selvom det er biologisk utænkeligt at et sådan træ kunne forekomme, modulo en
 * vis film med Arnold og Danny.
 *
 * Bemærk rækkefølgen for konstruktørens parametre: Man kan selv vælge, og der
 * forekommer en vis symmetri i at lade 'person' stå i midten. Der er imidlertid
 * også fordele ved at lade 'person' stå forrest hvis man selv skal konstruere
 * store træer, ligesom i gruppeopgaven. *)
datatype aneTrae = AneTrae of person * aneTrae * aneTrae
                 | TomtTrae

(* 3t3 *)
(* Funktionen aeldstTrae : aneTrae -> bool, tager et aneTrae og rekursivt
 * finder den ældste nulevende person i træet.*)
fun aeldstTrae TomtTrae = NONE
  | aeldstTrae (AneTrae (p, venstre, hojre)) =
    let
      val aeldst_venstre = aeldstTrae venstre
      val aeldst_hojre = aeldstTrae hojre
    in
      case (aeldst_venstre, aeldst_hojre) of
            (SOME pa, SOME pb) => aeldst [p, pa, pb]
          | (SOME pa, _)       => aeldst [p, pa]
          | (_, SOME pb)       => aeldst [p, pb]
          | _                  => aeldst [p]
    end

(* Alternativ løsning til 3t3: Lav personer i træet om
 * til en liste og kald funktionen aeldst på listen. *)
fun aeldstTrae trae =
  let
    fun traeTilListe (AneTrae (person, venstre, hojre))
        = person :: traeTilListe venstre @ traeTilListe hojre
      | traeTilListe (TomtTrae) = []
  in
    aeldst (traeTilListe trae)
  end;

local
  (* Afprøvning af aeldstTrae *)
  val erik = Person (Navn "Erik", Mand, Aar 1990, IrrelevantAar)
  val mads = Person (Navn "Mads", Mand, Aar 1971, Aar 2007)
  val elin = Person (Navn "Elin", Kvinde, Aar 1970, IrrelevantAar)
  val arne = Person (Navn "Arne", Mand, Aar 1950, Aar 2007)

  (* Nogle testtræer *)
  (* Ingen nulevende *)
  val testtrae1 = AneTrae (mads,
                    AneTrae (arne, TomtTrae, TomtTrae),
                    TomtTrae)

  val testtrae2 = AneTrae (erik,
                    AneTrae (elin, TomtTrae, TomtTrae),
                    testtrae1)

  (* Elin fjernes *)
  val testtrae3 = AneTrae (erik,
                    TomtTrae,
                    testtrae1)

in
  val aeldstTrae_test_1 = aeldstTrae testtrae1 = NONE
  val aeldstTrae_test_2 = aeldstTrae testtrae2 = SOME elin
  val aeldstTrae_test_3 = aeldstTrae testtrae3 = SOME erik
end
