
 val instruments = [
   ("Pressure",      10, true ),
   ("Meter",         90, false),
   ("Water-Level",   70, true ),
   ("Frequency",     50, true ),
   ("Alarm1",         0, true )
 ]
 ;

 (* Manipulate data *)

 (* cons *)
 fun add ins name value =
   (name, value, true)::ins
 ;

 (* match, cons, if *)
 fun has             [] name = false
   | has ((a,_,_)::ins) name =
     if a = name
     then true
     else has ins name
 ;

 (* match, cons, if, let *)
 fun rem ((elem as (a,_,_))::ins) name =
     if a = name
     then ins
     else
       let
         val k = rem ins name
       in
         elem :: k
       end
   | rem _ _ = []
 ;

 (* match, if *)
 fun update  [] _ _ = []
   | update ins name value =
     case not (has ins name) of
       true => ins
     | false => add (rem ins name) name value
 ;

 (* Check for failures *)

 (* match, cons, if *)
 fun first_failed [] = NONE
   | first_failed ((elem as (_,_,c))::ins) =
     if not c
     then SOME elem
     else first_failed ins
 ;

 (* match, cons, if *)
 fun too_high [] = []
   | too_high ((elem as (_,b,_))::ins) =
     if b > 90
     then elem::(too_high ins)
     else too_high ins
 ;

 (* Two instrument boards *)

 (* match, cons, if, local *)
 local
   fun contains (elem1::ins) elem0 =
       elem0 = elem1 orelse contains ins elem0
     | contains _ _ = false
 in
 fun diff [] ins1 = []
   | diff (elem0::ins0) ins1 =
     if not (contains ins1 elem0)
     then elem0 :: (diff ins0 ins1)
     else diff ins0 ins1
 end
 ;

 (* toString, concat *)
 fun elem_toString (a,b,c) =
   "(" ^ a ^ "," ^
    Int.toString b ^ "," ^
   Bool.toString c ^ ")"
 ;

 (* match, cons, concat *)
 fun ins_toString [] = ""
   | ins_toString (elem::ins) =
     elem_toString elem ^ "," ^ (ins_toString ins)
 ;

 (* concat *)
 fun diff_all ins0 ins1 =
   "[" ^ ins_toString (diff ins0 ins1) ^
   "] => " ^
   "[" ^ ins_toString (diff ins1 ins0) ^
   "]"
 ;

 (* Print status report *)

 (* local, match, cons, concat, if, case, option, print, let *)
 local
   fun out ((a,b,c)::ins) =
     let
       val oper = if c then "Yes" else "No"
       val s = a ^ ", " ^ Int.toString b ^
               ", " ^ oper
     in
       (s ^ "\n") ^ (out ins)
     end
   | out _ = ""
 in
 fun print_status ins =
   let
     val failed =
         case first_failed ins of
           NONE => ""
         | SOME elem => elem_toString elem
     val high = ins_toString (too_high ins)
     val s =
           "====\n" ^
           "Name: Value: Operating:\n" ^
           out ins ^ "\n" ^
           "High:" ^ high ^ "\n\n" ^
           "Failed:" ^ failed ^ "\n" ^
           "====\n"
     in print s end
 end
 ;

 (* CLI for manipulating data *)

 (* local, print, TextIO, case, if, let, valOf ; *)
 local
   fun strip_newline s =
     String.substring (s, 0, String.size s - 1)

   fun raw_input msg =
     let
       val _ = print msg
       val s = TextIO.inputLine TextIO.stdIn
     in
       strip_newline s
     end

   fun add_new ins name =
     let
       val value = raw_input "INSERT value="
     in
       case value of
         "" => ( print "No value.\n" ; ins )
       |  s => add ins name (
               valOf (Int.fromString s))
     end

   fun change ins name =
     let
       val value = raw_input "CHANGE value="
     in
       case value of
         ""    => ( print "No value.\n" ;
                    ins )
       | "REM" => ( print "REMOVE\n" ;
                    rem ins name )
       |  s    => update ins name (
                  valOf (Int.fromString s))
     end
 in
 fun updater ins =
   let
     val _ = print_status ins
     val name = raw_input "> name="
   in
     if name = "quit"
     then ins
     else
       if String.size name = 0
       then (print "No name." ; updater ins)
       else
         let
           val ins_new =
               if not (has ins name)
               then add_new ins name
               else change  ins name
         in
           (print (diff_all ins ins_new ^ "\n") ;
            updater ins_new)
         end
     end
 end
