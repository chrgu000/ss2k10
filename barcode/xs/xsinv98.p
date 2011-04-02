/* Generate By Barcode Generator , Copyright by Softspeed - Build By Sam Song  */ 
/* FIFO AUDIT INQUIRY */
/* Generate date / time  2006-10-24 10:21:05 */
define variable sectionid as integer init 0 .
define variable WMESSAGE  as char format "x(80)" init "".
define variable wtm_num   as char format "x(20)" init "0".
define variable wtm_fm    as char format "x(16)".
define variable wsection as char format "x(16)".
define variable i as integer .

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout" no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xsinv98wtimeout" no-lock no-error. /*  Timeout - Program Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

mainloop:
REPEAT:
     /* CYCLE COUNTER -SECTION ID -- START*/
      sectionid = sectionid + 1 .
     /* SECTION ID -- END  */

     /* START  LINE :1002  翴[SITE]  */
     V1002L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1002           as char format "x(50)".
        define variable PV1002          as char format "x(50)".
        define variable L10021          as char format "x(40)".
        define variable L10022          as char format "x(40)".
        define variable L10023          as char format "x(40)".
        define variable L10024          as char format "x(40)".
        define variable L10025          as char format "x(40)".
        define variable L10026          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        {xsdfsite.i}
        V1002 = wDefSite.
        V1002 = ENTRY(1,V1002,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1002 = ENTRY(1,V1002,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF aPASS = "Y" then
        leave V1002L.
        /* LOGICAL SKIP END */
                display "[FIFOу腹糵琩高]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 no-box.

                /* LABEL 1 - START */ 
                L10021 = "翴砞﹚Τ粇" .
                display L10021          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L10022 = "1.⊿Τ砞﹚纐粄翴" .
                display L10022          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L10023 = "2.舦砞﹚Τ粇" .
                display L10023          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L10024 = "  叫琩" .
                display L10024          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 4 - END */ 
                display "块┪E癶 "      format "x(40)" skip
        skip with fram F1002 no-box.
        Update V1002
        WITH  fram F1002 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.

        /* PRESS e EXIST CYCLE */
        IF V1002 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1002.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1002.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not trim(V1002) = "E" THEN DO:
                display skip "Error , Retry " @ WMESSAGE NO-LABEL with fram F1002.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1002.
        pause 0.
        leave V1002L.
     END.
     PV1002 = V1002.
     /* END    LINE :1002  翴[SITE]  */


   /* Additional Labels Format */
     /* START  LINE :1400  最后记录[Transaction Detail]  */
     V1400L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1400           as char format "x(50)".
        define variable PV1400          as char format "x(50)".
        define variable L14001          as char format "x(40)".
        define variable L14002          as char format "x(40)".
        define variable L14003          as char format "x(40)".
        define variable L14004          as char format "x(40)".
        define variable L14005          as char format "x(40)".
        define variable L14006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1400 = "E".
        V1400 = ENTRY(1,V1400,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1400 = ENTRY(1,V1400,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[FIFOу腹糵琩高]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1400 no-box.

                /* LABEL 1 - START */ 
                find last tr_hist where tr__chr01 <> "" and 
tr_userid = userid(sdbname('qaddb')) and
tr_type = "ISS-WO" and tr_effdate > today - 30 no-lock no-error.
If AVAILABLE ( tr_hist ) then
                L14001 = string (tr_nbr) + "/L" + string(tr_effdate) .
                else L14001 = "" . 
                display L14001          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find last tr_hist where tr__chr01 <> "" and 
tr_userid = userid(sdbname('qaddb')) and
tr_type = "ISS-WO" and tr_effdate > today - 30 no-lock no-error.
If AVAILABLE ( tr_hist ) then
                L14002 = "龟祇:" + trim(tr_serial) .
                else L14002 = "" . 
                display L14002          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find last tr_hist where tr__chr01 <> "" and 
tr_userid = userid(sdbname('qaddb')) and
tr_type = "ISS-WO" and tr_effdate > today - 30 no-lock no-error.
If AVAILABLE ( tr_hist ) then
                L14003 = "莱祇:" + trim ( substring ( tr__chr01,1,18 ) ) .
                else L14003 = "" . 
                display L14003          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                find last tr_hist where tr__chr01 <> "" and 
tr_userid = userid(sdbname('qaddb')) and
tr_type = "ISS-WO" and tr_effdate > today - 30 no-lock no-error.
If AVAILABLE ( tr_hist ) then
                L14004 = "珇:" + trim(tr_part) + "/" + string( - tr_qty_loc ) .
                else L14004 = "" . 
                display L14004          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 4 - END */ 
                display "块┪E癶 "      format "x(40)" skip
        skip with fram F1400 no-box.
        Update V1400
        WITH  fram F1400 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.

        /* PRESS e EXIST CYCLE */
        IF V1400 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1400.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1400.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1400.
        pause 0.
        leave V1400L.
     END.
     PV1400 = V1400.
     /* END    LINE :1400  最后记录[Transaction Detail]  */


   /* Additional Labels Format */
   /* Internal Cycle Input :1600    */
   V1600LMAINLOOP:
   REPEAT:
     /* START  LINE :1600  下一个Tr No[Next Transaction NBR]  */
     V1600L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1600           as char format "x(50)".
        define variable PV1600          as char format "x(50)".
        define variable L16001          as char format "x(40)".
        define variable L16002          as char format "x(40)".
        define variable L16003          as char format "x(40)".
        define variable L16004          as char format "x(40)".
        define variable L16005          as char format "x(40)".
        define variable L16006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find prev tr_hist where tr__chr01 <> "" and 
tr_userid = userid(sdbname('qaddb')) and
tr_type = "ISS-WO" and tr_effdate > today - 30 no-lock no-error.
If AVAILABLE ( tr_hist ) then
        V1600 = string(tr_trnbr).
        V1600 = ENTRY(1,V1600,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1600 = ENTRY(1,V1600,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1600L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1600L .
        /* --CYCLE TIME SKIP -- END  */

                display "[FIFOу腹糵琩高]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1600 no-box.

                /* LABEL 1 - START */ 
                  L16001 = "" . 
                display L16001          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L16002 = "" . 
                display L16002          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L16003 = "" . 
                display L16003          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L16004 = "" . 
                display L16004          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 4 - END */ 
                display "块┪E癶 "      format "x(40)" skip
        skip with fram F1600 no-box.
        Update V1600
        WITH  fram F1600 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.

        /* PRESS e EXIST CYCLE */
        IF V1600 = "e" THEN  LEAVE V1600LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1600.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1600.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        If V1600 = "" OR V1600 = "-" OR V1600 = "." OR V1600 = ".-" OR V1600 = "-." then do:
                display skip "CAN NOT EMPTY  " @ WMESSAGE NO-LABEL with fram F1600.
                pause 0 before-hide.
                undo, retry.
        end.
        DO i = 1 to length(V1600).
                If index("0987654321.-", substring(V1600,i,1)) = 0 then do:
                display skip "Format  Error  " @ WMESSAGE NO-LABEL with fram F1600.
                pause 0 before-hide.
                undo, retry.
                end.
        end.
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1600.
        pause 0.
        leave V1600L.
     END.
     PV1600 = V1600.
     /* END    LINE :1600  下一个Tr No[Next Transaction NBR]  */


   /* Additional Labels Format */
     /* START  LINE :1800  下一笔资料[Next]  */
     V1800L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1800           as char format "x(50)".
        define variable PV1800          as char format "x(50)".
        define variable L18001          as char format "x(40)".
        define variable L18002          as char format "x(40)".
        define variable L18003          as char format "x(40)".
        define variable L18004          as char format "x(40)".
        define variable L18005          as char format "x(40)".
        define variable L18006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1800 = ENTRY(1,V1800,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[FIFOу腹糵琩高]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1800 no-box.

                /* LABEL 1 - START */ 
                find first tr_hist where tr_trnbr = integer(V1600) no-lock no-error.
If AVAILABLE ( tr_hist ) then
                L18001 = string (tr_nbr) + "/N" + string(tr_effdate) .
                else L18001 = "" . 
                display L18001          format "x(40)" skip with fram F1800 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find first tr_hist where tr_trnbr = integer(V1600) no-lock no-error.
If AVAILABLE ( tr_hist ) then
                L18002 = "龟祇:" + trim(tr_serial) .
                else L18002 = "" . 
                display L18002          format "x(40)" skip with fram F1800 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first tr_hist where tr_trnbr = integer(V1600) no-lock no-error.
If AVAILABLE ( tr_hist ) then
                L18003 = "莱祇:" + trim ( substring ( tr__chr01,1,18 ) ) .
                else L18003 = "" . 
                display L18003          format "x(40)" skip with fram F1800 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                find first tr_hist where tr_trnbr = integer(V1600) no-lock no-error.
If AVAILABLE ( tr_hist ) then
                L18004 = "珇:" + trim(tr_part) + "/" + string( - tr_qty_loc ) .
                else L18004 = "" . 
                display L18004          format "x(40)" skip with fram F1800 no-box.
                /* LABEL 4 - END */ 
                display "块┪E癶 "      format "x(40)" skip
        skip with fram F1800 no-box.
        Update V1800
        WITH  fram F1800 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.

        /* PRESS e EXIST CYCLE */
        IF V1800 = "e" THEN  LEAVE V1600LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1800.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1800.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1800.
        pause 0.
        leave V1800L.
     END.
     PV1800 = V1800.
     /* END    LINE :1800  下一笔资料[Next]  */


   /* Additional Labels Format */
   /* Internal Cycle END :1800    */
   END.
   pause 0 before-hide.
end.
