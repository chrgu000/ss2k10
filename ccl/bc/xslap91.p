/* Generate By Barcode Generator , Copyright by Softspeed - Build By Sam Song  */ 
/* FWD LABEL */
/* Generate date / time  5/29/2008 1:29:05 PM */
/* jack001 2008/10/19 ¥Î­ì¨Ó89§ï¬°91 */
/* ss-081126.1 by jack */
define variable sectionid as integer init 0 .
define variable WMESSAGE  as char format "x(80)" init "".
define variable wtm_num   as char format "x(20)" init "0".
define variable wtm_fm    as char format "x(16)".
define variable wsection as char format "x(16)".
define variable i as integer .
define variable errstr as char .

define variable v_choice as char  . /* jack001 ¥Î©ó¿ï¾Ü±ø½X¦C¦L¤è¦¡ */
define variable v_print  as char . /* jack001 ¥Î©ó¿ï¾Ü¨ãÅé¦C¦L±ø½X®æ¦¡"ABC"*/

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout" no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xslap91wtimeout" no-lock no-error. /*  Timeout - Program Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

mainloop:
REPEAT:
     /* CYCLE COUNTER -SECTION ID -- START*/
      sectionid = sectionid + 1 .
     /* SECTION ID -- END  */

     /* START  LINE :1002  ¦aÂI[SITE]  */
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
                display "[FWD LABEL]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 no-box.

                /* LABEL 1 - START */ 
                L10021 = "¦aÂI³]©w¦³»~" .
                display L10021          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L10022 = "1.¨S¦³³]©wÀq»{¦aÂI" .
                display L10022          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L10023 = "2.Åv­­³]©w¦³»~" .
                display L10023          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L10024 = "  ½Ð¬d®Ö" .
                display L10024          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 4 - END */ 
                display "¿é¤J©Î«öE°h¥X "      format "x(40)" skip
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
     /* END    LINE :1002  ¦aÂI[SITE]  */


   /* Additional Labels Format */
     /* START  LINE :1100  ¤u³æ¸¹½X[WO]  */
     V1100L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1100           as char format "x(50)".
        define variable PV1100          as char format "x(50)".
        define variable L11001          as char format "x(40)".
        define variable L11002          as char format "x(40)".
        define variable L11003          as char format "x(40)".
        define variable L11004          as char format "x(40)".
        define variable L11005          as char format "x(40)".
        define variable L11006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V1100 = PV1100 .
        V1100 = ENTRY(1,V1100,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[FWD LABEL]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1100 no-box.

                /* LABEL 1 - START */ 
                L11001 = "¤u³æ¸¹½X?" .
                display L11001          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11002 = "" . 
                display L11002          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11003 = "" . 
                display L11003          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11004 = "" . 
                display L11004          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 4 - END */ 
                display "¿é¤J©Î«öE°h¥X "      format "x(40)" skip
        skip with fram F1100 no-box.
        Update V1100
        WITH  fram F1100 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1100.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(WO_MSTR) = ? THEN find first WO_MSTR where 
                              WO_site = V1002 AND  
                              WO_NBR >=  INPUT V1100
                               no-lock no-error.
                  ELSE find next WO_MSTR where 
                              WO_site = V1002  
                               no-lock no-error.
                  IF AVAILABLE WO_MSTR then display skip 
            WO_NBR @ V1100 trim(WO_PART) + "/" + trim ( WO_SO_JOB ) @ WMESSAGE NO-LABEL with fram F1100.
                  else   display skip "" @ WMESSAGE with fram F1100.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(WO_MSTR) = ? THEN find first WO_MSTR where 
                              WO_site = V1002 AND  
            WO_NBR <=  INPUT V1100
                               no-lock no-error.
                  ELSE find prev WO_MSTR where 
                              WO_site = V1002 
                               no-lock no-error.
                  IF AVAILABLE WO_MSTR then display skip 
            WO_NBR @ V1100 trim(WO_PART) + "/" + trim ( WO_SO_JOB ) @ WMESSAGE NO-LABEL with fram F1100.
                  else   display skip "" @ WMESSAGE with fram F1100.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1100 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1100.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first WO_MSTR where WO_NBR = V1100 AND WO_SITE = V1002  no-lock no-error.
        IF NOT AVAILABLE WO_MSTR then do:
                display skip "Error,Retry" @ WMESSAGE NO-LABEL with fram F1100.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        leave V1100L.
     END.
     PV1100 = V1100.
     /* END    LINE :1100  ¤u³æ¸¹½X[WO]  */


   /* Additional Labels Format */
     /* START  LINE :1103  ID[ID]  */
     V1103L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1103           as char format "x(50)".
        define variable PV1103          as char format "x(50)".
        define variable L11031          as char format "x(40)".
        define variable L11032          as char format "x(40)".
        define variable L11033          as char format "x(40)".
        define variable L11034          as char format "x(40)".
        define variable L11035          as char format "x(40)".
        define variable L11036          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first wo_mstr where wo_nbr  = V1100 and wo_site = V1002 no-lock no-error.
If AVAILABLE ( wo_mstr ) then
        V1103 = wo_lot.
        V1103 = ENTRY(1,V1103,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1103 = ENTRY(1,V1103,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        find last wo_mstr where wo_nbr  = V1100 and wo_site = V1002 no-lock no-error.
If AVAILABLE ( wo_mstr )  and  wo_lot = V1103 then
        leave V1103L.
        /* LOGICAL SKIP END */
                display "[FWD LABEL]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1103 no-box.

                /* LABEL 1 - START */ 
                L11031 = "¤u³æID#" .
                display L11031          format "x(40)" skip with fram F1103 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find first wo_mstr where wo_nbr  = V1100 and wo_site = V1002 no-lock no-error.
If AVAILABLE ( wo_mstr ) then
                L11032 = wo_lot .
                else L11032 = "" . 
                display L11032          format "x(40)" skip with fram F1103 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11033 = "" . 
                display L11033          format "x(40)" skip with fram F1103 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11034 = "" . 
                display L11034          format "x(40)" skip with fram F1103 no-box.
                /* LABEL 4 - END */ 
                display "¿é¤J©Î«öE°h¥X "      format "x(40)" skip
        skip with fram F1103 no-box.
        Update V1103
        WITH  fram F1103 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1103.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(wo_mstr) = ? THEN find first wo_mstr where 
                              wo_nbr = V1100 and wo_site = V1002 AND  
                              wo_lot >=  INPUT V1103
                               no-lock no-error.
                  ELSE find next wo_mstr where 
                              wo_nbr = V1100 and wo_site = V1002  
                               no-lock no-error.
                  IF AVAILABLE wo_mstr then display skip 
            wo_lot @ V1103 "¦¨«~: " +  trim (wo_part) @ WMESSAGE NO-LABEL with fram F1103.
                  else   display skip "" @ WMESSAGE with fram F1103.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(wo_mstr) = ? THEN find first wo_mstr where 
                              wo_nbr = V1100 and wo_site = V1002 AND  
            wo_lot <=  INPUT V1103
                               no-lock no-error.
                  ELSE find prev wo_mstr where 
                              wo_nbr = V1100 and wo_site = V1002 
                               no-lock no-error.
                  IF AVAILABLE wo_mstr then display skip 
            wo_lot @ V1103 "¦¨«~: " +  trim (wo_part) @ WMESSAGE NO-LABEL with fram F1103.
                  else   display skip "" @ WMESSAGE with fram F1103.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1103 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1103.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1103.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first wo_mstr where wo_lot = V1103 AND wo_site = V1002  no-lock no-error.
        IF NOT AVAILABLE wo_mstr then do:
                display skip "µL®Ä©Î³QÂê!" @ WMESSAGE NO-LABEL with fram F1103.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1103.
        pause 0.
        leave V1103L.
     END.
     PV1103 = V1103.
     /* END    LINE :1103  ID[ID]  */


   /* Additional Labels Format */
     /* START  LINE :1104  «¬¸¹[ITEM]  */
     V1104L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1104           as char format "x(50)".
        define variable PV1104          as char format "x(50)".
        define variable L11041          as char format "x(40)".
        define variable L11042          as char format "x(40)".
        define variable L11043          as char format "x(40)".
        define variable L11044          as char format "x(40)".
        define variable L11045          as char format "x(40)".
        define variable L11046          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first wo_mstr where wo_lot  = V1103 no-lock no-error.
If AVAILABLE ( wo_mstr ) then
        V1104 = wo_part.
        V1104 = ENTRY(1,V1104,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1104 = ENTRY(1,V1104,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[FWD LABEL]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1104 no-box.

                /* LABEL 1 - START */ 
                L11041 = "®Æ«~" .
                display L11041          format "x(40)" skip with fram F1104 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11042 = wo_part .
                display L11042          format "x(40)" skip with fram F1104 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first pt_mstr where pt_part  = V1104 no-lock no-error.
If AVAILABLE ( pt_mstr ) then
                L11043 = pt_desc1 .
                else L11043 = "" . 
                display L11043          format "x(40)" skip with fram F1104 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                find first pt_mstr where pt_part  = V1104 no-lock no-error.
If AVAILABLE ( pt_mstr ) then
                L11044 = trim(pt_desc2) .
                else L11044 = "" . 
                display L11044          format "x(40)" skip with fram F1104 no-box.
                /* LABEL 4 - END */ 
                display "¿é¤J©Î«öE°h¥X "      format "x(40)" skip
        skip with fram F1104 no-box.
        /* DISPLAY ONLY */
        define variable X1104           as char format "x(40)".
        X1104 = V1104.
        V1104 = "".
        /* DISPLAY ONLY */
        Update V1104
        WITH  fram F1104 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V1104 = X1104.
        /* DISPLAY ONLY */
        LEAVE V1104L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1104 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1104.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1104.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1104.
        pause 0.
        leave V1104L.
     END.
     PV1104 = V1104.
     /* END    LINE :1104  «¬¸¹[ITEM]  */


   /* Additional Labels Format */
     /* START  LINE :1110  ¤é´Á[Date]  */
     V1110L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1110           as char format "x(50)".
        define variable PV1110          as char format "x(50)".
        define variable L11101          as char format "x(40)".
        define variable L11102          as char format "x(40)".
        define variable L11103          as char format "x(40)".
        define variable L11104          as char format "x(40)".
        define variable L11105          as char format "x(40)".
        define variable L11106          as char format "x(40)".
        define variable D1110           as date .
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1110 = string(today).
        D1110 = Date ( V1110).
        V1110 = ENTRY(1,V1110,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V1110 = PV1110 .
         If sectionid > 1 Then 
        D1110 = Date ( V1110).
        V1110 = ENTRY(1,V1110,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[FWD LABEL]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1110 no-box.

                /* LABEL 1 - START */ 
                {xstolap91.i}   /* 91.i¤¤¥[¤J¤F89.i function */
		
IF 1 = 1 then
                L11101 = "¤é´Á?" .
                else L11101 = "" . 
                display L11101          format "x(40)" skip with fram F1110 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11102 = string(today) .
                display L11102          format "x(40)" skip with fram F1110 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11103 = "" . 
                display L11103          format "x(40)" skip with fram F1110 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11104 = "" . 
                display L11104          format "x(40)" skip with fram F1110 no-box.
                /* LABEL 4 - END */ 
                display "¿é¤J©Î«öE°h¥X "      format "x(40)" skip
        skip with fram F1110 no-box.
        Update D1110
        WITH  fram F1110 NO-LABEL
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
        IF V1110 = "e" THEN  LEAVE MAINLOOP.
        V1110 = string ( D1110).
        display  skip WMESSAGE NO-LABEL with fram F1110.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1110.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1110.
        pause 0.
        leave V1110L.
     END.
     PV1110 = V1110.
     /* END    LINE :1110  ¤é´Á[Date]  */

     /* ss-081127.1 -b */
        /* START  LINE :9011  ±ø½X¦C¦L¤è¦¡[NO OF LABEL]  */
     V9011L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9011           as char format "x(50)".
        define variable PV9011          as char format "x(50)".
        define variable L90111          as char format "x(40)".
        define variable L90112          as char format "x(40)".
        define variable L90113          as char format "x(40)".
        define variable L90114          as char format "x(40)".
        define variable L90115          as char format "x(40)".
        define variable L90116          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V9011 = "1".
        V9011 = ENTRY(1,V9011,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9011 = ENTRY(1,V9011,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[FWD LABEL]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9011 no-box.

                /* LABEL 1 - START */ 
                L90111 = "±ø½X¦C¦L¤è¦¡?" .
                display L90111          format "x(40)" skip with fram F9011 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L90112 = "" . 
                display L90112          format "x(40)" skip with fram F9011 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L90113 = "" . 
                display L90113          format "x(40)" skip with fram F9011 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L90114 = "1.ELBA Label  2.F&P Label" . 
                display L90114          format "x(40)" skip with fram F9011 no-box.
                /* LABEL 4 - END */ 
                display "¿é¤J©Î«öE°h¥X "      format "x(40)" skip
        skip with fram F9011 no-box.
        Update V9011
        WITH  fram F9011 NO-LABEL
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
        IF V9011 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9011.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9011.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        If V9011 = "" OR V9011 = "-" OR V9011 = "." OR V9011 = ".-" OR V9011 = "-." then do:
                display skip "CAN NOT EMPTY  " @ WMESSAGE NO-LABEL with fram F9011.
                pause 0 before-hide.
                undo, retry.
        end.
        DO i = 1 to length(V9011).
                If index("0987654321.-", substring(V9011,i,1)) = 0 then do:
                display skip "Format  Error  " @ WMESSAGE NO-LABEL with fram F9011.
                pause 0 before-hide.
                undo, retry.
                end.
        end.
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9011.
        pause 0.
        leave V9011L.
     END.
     PV9011 = V9011.
     v_choice = v9011 .
     /* END    LINE :9011  ±ø½X¦C¦L¤è¦¡[NO OF LABEL]  */
     /* ss-081127.1 -e */


   /* Additional Labels Format */
   /* Internal Cycle Input :1310    */
   V1310LMAINLOOP:
   REPEAT:
     /* START  LINE :1310  START NO.[Start No]  */
     V1310L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1310           as char format "x(50)".
        define variable PV1310          as char format "x(50)".
        define variable L13101          as char format "x(40)".
        define variable L13102          as char format "x(40)".
        define variable L13103          as char format "x(40)".
        define variable L13104          as char format "x(40)".
        define variable L13105          as char format "x(40)".
        define variable L13106          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
	/* ss-081127.1 -b */
	if v_choice = "1" then do :
        V1310 = CALLBYLAP91 ( CALLBYLAP91 (V1104,"","1","") + "@" + CALLBYLAP91 (V1110,"","5","") + "1"  ,"","6","").
	end .
	else do :
	  V1310 = CALLBYLAP91 ( CALLBYLAP91 (V1104,"","1","") + "@" + CALLBYLAP91 (V1110,"","5","") + "2" ,"","6","").
	end .
	/* ss-081127.1 -e */
        V1310 = ENTRY(1,V1310,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1310 = ENTRY(1,V1310,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[FWD LABEL]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1310 no-box.

                /* LABEL 1 - START */ 
                L13101 = "START NO." .
                display L13101          format "x(40)" skip with fram F1310 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L13102 = "" . 
                display L13102          format "x(40)" skip with fram F1310 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L13103 = "" . 
                display L13103          format "x(40)" skip with fram F1310 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13104 = "" . 
                display L13104          format "x(40)" skip with fram F1310 no-box.
                /* LABEL 4 - END */ 
                display "¿é¤J©Î«öE°h¥X "      format "x(40)" skip
        skip with fram F1310 no-box.
        Update V1310
        WITH  fram F1310 NO-LABEL
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
        IF V1310 = "e" THEN  LEAVE V1310LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1310.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1310.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
	/* ss-081127.1 -b */
	if v_choice = "1" then do :
        IF not ( V1310 <= CALLBYLAP91 ( CALLBYLAP91 (V1104,"","1","") + "@" + CALLBYLAP91 (V1110,"","5","") + "1" ,"","6","") ) THEN DO:
                display skip "ERROR,ENTRY!" @ WMESSAGE NO-LABEL with fram F1310.
                pause 0 before-hide.
                undo, retry.
        end.
	end .
	else do :
	IF not ( V1310 <= CALLBYLAP91 ( CALLBYLAP91 (V1104,"","1","") + "@" + CALLBYLAP91 (V1110,"","5","") + "2" ,"","6","") ) THEN DO:
                display skip "ERROR,ENTRY!" @ WMESSAGE NO-LABEL with fram F1310.
                pause 0 before-hide.
                undo, retry.
        end.
	end .
	/* ss-081127.1 -e */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1310.
        pause 0.
        leave V1310L.
     END.
     IF INDEX(V1310,"@" ) = 0 then V1310 = V1310 + "@".
     PV1310 = V1310.
     V1310 = ENTRY(1,V1310,"@").
     /* END    LINE :1310  START NO.[Start No]  */


   /* Additional Labels Format */
     /* START  LINE :9010  [INFORMATION]  */
     V9010L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9010           as char format "x(50)".
        define variable PV9010          as char format "x(50)".
        define variable L90101          as char format "x(40)".
        define variable L90102          as char format "x(40)".
        define variable L90103          as char format "x(40)".
        define variable L90104          as char format "x(40)".
        define variable L90105          as char format "x(40)".
        define variable L90106          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V9010 = " ".
        V9010 = ENTRY(1,V9010,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9010 = ENTRY(1,V9010,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[FWD LABEL]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9010 no-box.

                /* LABEL 1 - START */ 
                L90101 = "MODEL:" + CALLBYLAP91 (V1104,"","1","") .
                display L90101          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find first pt_mstr where pt_part  = V1104 no-lock no-error.
If AVAILABLE ( pt_mstr ) then
                L90102 = CALLBYLAP91 (pt_desc1 + pt_desc2,"","2","") .
                else L90102 = "" . 
                display L90102          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first pt_mstr where pt_part  = V1104 no-lock no-error.
If AVAILABLE ( pt_mstr ) then
                L90103 = CALLBYLAP91 (pt_desc1 + pt_desc2,"","3","") + "     " + substring ( V1310 ,3,1) + substring ( V1310 ,2,1) + substring ( V1310 ,1,1) + CALLBYLAP91 (V1110,"","5","") .
                else L90103 = "" . 
                display L90103          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                find first pt_mstr where pt_part  = V1104 no-lock no-error.
If AVAILABLE ( pt_mstr ) then
                L90104 = CALLBYLAP91 (pt_desc1 + pt_desc2,"","4","") .
                else L90104 = "" . 
                display L90104          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 4 - END */ 
                display "¿é¤J©Î«öE°h¥X "      format "x(40)" skip
        skip with fram F9010 no-box.
        Update V9010
        WITH  fram F9010 NO-LABEL
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
        IF V9010 = "e" THEN  LEAVE V1310LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9010.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9010.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9010.
        pause 0.
        leave V9010L.
     END.
     PV9010 = V9010.
     /* END    LINE :9010  [INFORMATION]  */
     
     /* jack001 begins */
       
             
      /* ¿ï¾Üªº¥´¦L¤è¦¡¶i¦æ±ø½X¿ï¾Ü */
     if v_choice = "1" then do :
        /* START  LINE :9012  ±ø½XºØÃþ¿ï¾Ü[NO OF LABEL]  */
     V9012L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9012           as char format "x(50)".
        define variable PV9012          as char format "x(50)".
        define variable L90121          as char format "x(40)".
        define variable L90122          as char format "x(40)".
        define variable L90123          as char format "x(40)".
        define variable L90124          as char format "x(40)".
        define variable L90125          as char format "x(40)".
        define variable L90126          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V9012 = "a".
        V9012 = ENTRY(1,V9012,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9012 = ENTRY(1,V9012,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[FWD LABEL]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9012 no-box.

                /* LABEL 1 - START */ 
                L90121 = "±ø½X¦C¦L®æ¦¡¿ï¾Ü?" .
                display L90121          format "x(40)" skip with fram F9012 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L90122 = "" . 
                display L90122          format "x(40)" skip with fram F9012 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L90123 = "" . 
                display L90123          format "x(40)" skip with fram F9012 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L90124 = "a. Rating label b. Gift box label c. Pallet label" . 
                display L90124          format "x(40)" skip with fram F9012 no-box.
                /* LABEL 4 - END */ 
                display "¿é¤J©Î«öE°h¥X "      format "x(40)" skip
        skip with fram F9012 no-box.
        Update V9012
        WITH  fram F9012 NO-LABEL
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
        IF V9012 = "e" THEN  LEAVE V1310LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9012.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9012.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        If V9012 = "" OR V9012 = "-" OR V9012 = "." OR V9012 = ".-" OR V9012 = "-." then do:
                display skip "CAN NOT EMPTY  " @ WMESSAGE NO-LABEL with fram F9012.
                pause 0 before-hide.
                undo, retry.
        end.
        DO i = 1 to length(V9012).
                If index("abc", substring(V9012,i,1)) = 0 then do:
                display skip "Format  Error  " @ WMESSAGE NO-LABEL with fram F9012.
                pause 0 before-hide.
                undo, retry.
                end.
        end.
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9012.
        pause 0.
        leave V9012L.
     END.
     PV9012 = V9012.
     v_print = v9012 .
     /* END    LINE :9012  ±ø½X¦C¦L¤è¦¡[NO OF LABEL]  */
     end .
     else do :
     
        /* START  LINE :9013  ±ø½XºØÃþ¿ï¾Ü[NO OF LABEL]  */
     V9013L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9013           as char format "x(50)".
        define variable PV9013          as char format "x(50)".
        define variable L90131          as char format "x(40)".
        define variable L90132          as char format "x(40)".
        define variable L90133          as char format "x(40)".
        define variable L90134          as char format "x(40)".
        define variable L90135          as char format "x(40)".
        define variable L90136          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V9013 = "a".
        V9013 = ENTRY(1,V9013,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9013 = ENTRY(1,V9013,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[FWD LABEL]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9013 no-box.

                /* LABEL 1 - START */ 
                L90131 = "±ø½X¦C¦L®æ¦¡¿ï¾Ü?" .
                display L90131          format "x(40)" skip with fram F9013 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L90132 = "" . 
                display L90132          format "x(40)" skip with fram F9013 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L90133 = "" . 
                display L90133          format "x(40)" skip with fram F9013 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L90134 = "a. Rating label b. Gift box label c. Pallet label ". 
                display L90134          format "x(40)" skip with fram F9013 no-box.
                /* LABEL 4 - END */ 
                display "¿é¤J©Î«öE°h¥X "      format "x(40)" skip
        skip with fram F9013 no-box.
        Update V9013
        WITH  fram F9013 NO-LABEL
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
        IF V9013 = "e" THEN  LEAVE V1310LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9013.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9013.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        If V9013 = "" OR V9013 = "-" OR V9013 = "." OR V9013 = ".-" OR V9013 = "-." then do:
                display skip "CAN NOT EMPTY  " @ WMESSAGE NO-LABEL with fram F9013.
                pause 0 before-hide.
                undo, retry.
        end.
        DO i = 1 to length(V9013).
                If index("abc", substring(V9013,i,1)) = 0 then do:
                display skip "Format  Error  " @ WMESSAGE NO-LABEL with fram F9013.
                pause 0 before-hide.
                undo, retry.
                end.
        end.
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9013.
        pause 0.
        leave V9013L.
     END.
     PV9013 = V9013.
     v_print = v9013 .
     /* END    LINE :9013  ±ø½X¦C¦L¤è¦¡[NO OF LABEL]  */

     end . /* choice = "2" */

     /* jack001 begins  */

     if v_print = "c" then do :

      /* START  LINE :9018  ¿é¤JÅÜ¶q qty  */
     V9018L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9018           as char format "x(50)".
        define variable PV9018          as char format "x(50)".
        define variable L90181          as char format "x(40)".
        define variable L90182          as char format "x(40)".
        define variable L90183          as char format "x(40)".
        define variable L90184          as char format "x(40)".
        define variable L90185          as char format "x(40)".
        define variable L90186          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V9018 = "1".
        V9018 = ENTRY(1,V9018,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9018 = ENTRY(1,V9018,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[FWD LABEL]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9018 no-box.

                /* LABEL 1 - START */ 
                L90181 = "Qty" .
                display L90181          format "x(40)" skip with fram F9018 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L90182 = "" . 
                display L90182          format "x(40)" skip with fram F9018 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L90183 = "" . 
                display L90183          format "x(40)" skip with fram F9018 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L90184 = "". 
                display L90184          format "x(40)" skip with fram F9018 no-box.
                /* LABEL 4 - END */ 
                display "¿é¤J©Î«öE°h¥X "      format "x(40)" skip
        skip with fram F9018 no-box.
        Update V9018
        WITH  fram F9018 NO-LABEL
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
        IF V9018 = "e" THEN  LEAVE V1310LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9018.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9018.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        If V9018 = "" OR V9018 = "-" OR V9018 = "." OR V9018 = ".-" OR V9018 = "-." then do:
                display skip "CAN NOT EMPTY  " @ WMESSAGE NO-LABEL with fram F9018.
                pause 0 before-hide.
                undo, retry.
        end.
        DO i = 1 to length(V9018).
                If index("1234567890", substring(V9018,i,1)) = 0 then do:
                display skip "Format  Error  " @ WMESSAGE NO-LABEL with fram F9018.
                pause 0 before-hide.
                undo, retry.
                end.
        end.
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9018.
        pause 0.
        leave V9018L.
     END.
     PV9018 = V9018.
         /* END    LINE :9018  ÅÜ¶q qty ¿é¤J  */
     end . /* v_print = "c" */

     /* ss-081126.1 -e */

   /* Additional Labels Format */
     /* START  LINE :9020  ±ø½X­Ó¼Æ[NO OF LABEL]  */
     V9020L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9020           as char format "x(50)".
        define variable PV9020          as char format "x(50)".
        define variable L90201          as char format "x(40)".
        define variable L90202          as char format "x(40)".
        define variable L90203          as char format "x(40)".
        define variable L90204          as char format "x(40)".
        define variable L90205          as char format "x(40)".
        define variable L90206          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V9020 = "1".
        V9020 = ENTRY(1,V9020,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9020 = ENTRY(1,V9020,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[FWD LABEL]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9020 no-box.

                /* LABEL 1 - START */ 
                L90201 = "±ø½X±i¼Æ?" .
                display L90201          format "x(40)" skip with fram F9020 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L90202 = "" . 
                display L90202          format "x(40)" skip with fram F9020 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L90203 = "" . 
                display L90203          format "x(40)" skip with fram F9020 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L90204 = "" . 
                display L90204          format "x(40)" skip with fram F9020 no-box.
                /* LABEL 4 - END */ 
                display "¿é¤J©Î«öE°h¥X "      format "x(40)" skip
        skip with fram F9020 no-box.
        Update V9020
        WITH  fram F9020 NO-LABEL
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
        IF V9020 = "e" THEN  LEAVE V1310LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9020.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9020.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        If V9020 = "" OR V9020 = "-" OR V9020 = "." OR V9020 = ".-" OR V9020 = "-." then do:
                display skip "CAN NOT EMPTY  " @ WMESSAGE NO-LABEL with fram F9020.
                pause 0 before-hide.
                undo, retry.
        end.
        DO i = 1 to length(V9020).
                If index("0987654321.-", substring(V9020,i,1)) = 0 then do:
                display skip "Format  Error  " @ WMESSAGE NO-LABEL with fram F9020.
                pause 0 before-hide.
                undo, retry.
                end.
        end.
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9020.
        pause 0.
        leave V9020L.
     END.
     PV9020 = V9020.
     /* END    LINE :9020  ±ø½X­Ó¼Æ[NO OF LABEL]  */


   wtm_num = V9020.
  

   if v_choice = "2" then do :  /* jack001 */
   /* Additional Labels Format */
     /* START  LINE :9030  ¥´¦L¾÷[PRINTER]  */
     V9030L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9030           as char format "x(50)".
        define variable PV9030          as char format "x(50)".
        define variable L90301          as char format "x(40)".
        define variable L90302          as char format "x(40)".
        define variable L90303          as char format "x(40)".
        define variable L90304          as char format "x(40)".
        define variable L90305          as char format "x(40)".
        define variable L90306          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first upd_det where upd_nbr = "LAP91" and upd_select = 99 no-lock no-error.
If AVAILABLE ( upd_det ) then
        V9030 = UPD_DEV.
        V9030 = ENTRY(1,V9030,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V9030 = PV9030 .
        V9030 = ENTRY(1,V9030,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[FWD LABEL]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9030 no-box.

                /* LABEL 1 - START */ 
                L90301 = "¥´¦L¾÷?" .
                display L90301          format "x(40)" skip with fram F9030 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L90302 = "" . 
                display L90302          format "x(40)" skip with fram F9030 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L90303 = "" . 
                display L90303          format "x(40)" skip with fram F9030 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L90304 = "" . 
                display L90304          format "x(40)" skip with fram F9030 no-box.
                /* LABEL 4 - END */ 
                display "¿é¤J©Î«öE°h¥X "      format "x(40)" skip
        skip with fram F9030 no-box.
        Update V9030
        WITH  fram F9030 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F9030.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(PRD_DET) = ? THEN find first PRD_DET where 
                              PRD_TYPE = "BARCODE" AND  
                              PRD_DEV >=  INPUT V9030
                               no-lock no-error.
                  ELSE find next PRD_DET where 
                              PRD_TYPE = "BARCODE"  
                               no-lock no-error.
                  IF AVAILABLE PRD_DET then display skip 
            PRD_DEV @ V9030 PRD_DESC @ WMESSAGE NO-LABEL with fram F9030.
                  else   display skip "" @ WMESSAGE with fram F9030.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(PRD_DET) = ? THEN find first PRD_DET where 
                              PRD_TYPE = "BARCODE" AND  
            PRD_DEV <=  INPUT V9030
                               no-lock no-error.
                  ELSE find prev PRD_DET where 
                              PRD_TYPE = "BARCODE" 
                               no-lock no-error.
                  IF AVAILABLE PRD_DET then display skip 
            PRD_DEV @ V9030 PRD_DESC @ WMESSAGE NO-LABEL with fram F9030.
                  else   display skip "" @ WMESSAGE with fram F9030.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V9030 = "e" THEN  LEAVE V1310LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9030.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9030.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first PRD_DET where PRD_DEV = V9030 and PRD_TYPE = "BARCODE"  no-lock no-error.
        IF NOT AVAILABLE PRD_DET then do:
                display skip "Printer Error " @ WMESSAGE NO-LABEL with fram F9030.
                pause 0 before-hide.
                undo, retry.
        end.
	/* ss-081127.1 -b */
	 if  v_print = "a" or v_print = "b"  then  do :
	 IF not CALLBYLAP91 ( CALLBYLAP91 (V1104,"","1","") + "@" + CALLBYLAP91 (V1110,"","5","") + "2" + "@" + V1310 + "@" +  string ( integer ( V1310) + integer ( V9020 ) - 1 ,"999") ,
                                   V1100,"7",CALLBYLAP91 (V1104,"","1","") + "@" + CALLBYLAP91 (V1110,"","5","") + "2" ) <> "000" THEN DO:
                display skip "Printer Error " @ WMESSAGE NO-LABEL with fram F9030.
                pause 0 before-hide.
                undo, retry.
	end .
	end .
	/* ss-081127.1 - e */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9030.
        pause 0.
        leave V9030L.
     END.
     PV9030 = V9030.
     /* END    LINE :9030  ¥´¦L¾÷[PRINTER]  */
     end . /* choice = "2" */
     else do :
       /* Additional Labels Format */
     /* START  LINE :90301  ¥´¦L¾÷[PRINTER]  */
     V90301L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V90301           as char format "x(50)".
        define variable PV90301          as char format "x(50)".
        define variable L903011          as char format "x(40)".
        define variable L903012          as char format "x(40)".
        define variable L903013          as char format "x(40)".
        define variable L903014          as char format "x(40)".
        define variable L903015          as char format "x(40)".
        define variable L903016          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first upd_det where upd_nbr = "lap91" and upd_select = 99 no-lock no-error.
If AVAILABLE ( upd_det ) then
        V90301 = UPD_DEV.
        V90301 = ENTRY(1,V90301,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V90301 = PV90301 .
        V90301 = ENTRY(1,V90301,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[FWD LABEL]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F90301 no-box.

                /* LABEL 1 - START */ 
                L903011 = "¥´¦L¾÷?" .
                display L903011          format "x(40)" skip with fram F90301 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L903012 = "" . 
                display L903012          format "x(40)" skip with fram F90301 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L903013 = "" . 
                display L903013          format "x(40)" skip with fram F90301 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L903014 = "" . 
                display L903014          format "x(40)" skip with fram F90301 no-box.
                /* LABEL 4 - END */ 
                display "¿é¤J©Î«öE°h¥X "      format "x(40)" skip
        skip with fram F90301 no-box.
        Update V90301
        WITH  fram F90301 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F90301.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(PRD_DET) = ? THEN find first PRD_DET where 
                              PRD_TYPE = "BARCODE" AND  
                              PRD_DEV >=  INPUT V90301
                               no-lock no-error.
                  ELSE find next PRD_DET where 
                              PRD_TYPE = "BARCODE"  
                               no-lock no-error.
                  IF AVAILABLE PRD_DET then display skip 
            PRD_DEV @ V90301 PRD_DESC @ WMESSAGE NO-LABEL with fram F90301.
                  else   display skip "" @ WMESSAGE with fram F90301.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(PRD_DET) = ? THEN find first PRD_DET where 
                              PRD_TYPE = "BARCODE" AND  
            PRD_DEV <=  INPUT V90301
                               no-lock no-error.
                  ELSE find prev PRD_DET where 
                              PRD_TYPE = "BARCODE" 
                               no-lock no-error.
                  IF AVAILABLE PRD_DET then display skip 
            PRD_DEV @ V90301 PRD_DESC @ WMESSAGE NO-LABEL with fram F90301.
                  else   display skip "" @ WMESSAGE with fram F90301.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V90301 = "e" THEN  LEAVE V1310LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F90301.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F90301.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first PRD_DET where PRD_DEV = V90301 and PRD_TYPE = "BARCODE"  no-lock no-error.
        IF NOT AVAILABLE PRD_DET then do:
                display skip "Printer Error " @ WMESSAGE NO-LABEL with fram F90301.
                pause 0 before-hide.
                undo, retry.
        end.
	/* ??ÁË?´aµÄé_Ê¼ºÍ½YÊø£¬·½±ã´æƒ¦ */
	/* ss-081127.1 -b */
	if v_print = "a" or v_print = "b" then do :
	
        IF not CALLBYlap91 ( CALLBYlap91 (V1104,"","1","")   + "@" + CALLBYlap91 (V1110,"","5","") + "1"  + "@" + V1310 + "@" +  string ( integer ( V1310) + integer ( V9020 ) - 1 ,"999") ,
                                   V1100,"7",CALLBYlap91 (V1104,"","1","") + "@" + CALLBYlap91 (V1110,"","5","") + "1" ) <> "000" THEN DO:
                display skip "Printer Error " @ WMESSAGE NO-LABEL with fram F90301.
                pause 0 before-hide.
                undo, retry.
        end. 
	end .
	
	/* ss-081127.1 -e */

         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F90301.
        pause 0.
        leave V90301L.
     END.
     PV90301 = V90301.
     /* END    LINE :90301  ¥´¦L¾÷[PRINTER]  */
     end . /* choice = 1 */  
   
   /* jack001 ¿ï¾Ü±ø½X */
   if v_choice = "2" then do :
   /* Additional Labels Format */
    /* ss-081126.1 - b*/
   /*  Define variable ts9030 AS CHARACTER FORMAT "x(100)".
     Define variable av9030 AS CHARACTER FORMAT "x(100)".
     */
     /* ss-081126.1 -e */
     /* ss-0826.1 - b */
     Define variable ts9030 AS CHARACTER FORMAT "x(500)".
     Define variable av9030 AS CHARACTER FORMAT "x(500)". 
     /* ss-0826.1 -e */
     PROCEDURE lap919030l.
        /* Define Labels Path  Start */
        Define variable LabelsPath as character format "x(100)" init "/app/mfgpro/bc/labels/".
        Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath"no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath = trim ( code_cmmt ).
        If substring(LabelsPath, length(LabelsPath), 1) <> "/" Then 
        LabelsPath = LabelsPath + "/".
	/* ss-081127.1 -b */
	define var v_add2  as logical initial yes .
	/* ss-081127.1 -e */
        /* Define Labels Path  END */
	/* ss-081126.1 -b */
	/* ¿ï¾Ü A  BEGINS */
	/* ss-081128.1 -b */
	/* assign ts9030 = "" av9030 = "" . */
	/* ss-081128.1 -e */
      IF v_print = "a" then do :
     INPUT FROM VALUE(LabelsPath + "lap91" + trim ( wtm_fm ) ).
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
     output to value( trim(wsection) + ".l") .
     Do While True:
              IMPORT UNFORMATTED ts9030.
	      v_add2 = yes .
        av9030 = "MODEL "+ CALLBYLAP91 (V1104,"","1","").
	repeat while v_add2 :
       IF INDEX(ts9030,"$M") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$M") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$M") + length("$M"), LENGTH(ts9030) - ( index(ts9030 ,"$M" ) + length("$M") - 1 ) ).
       END.
       else do :
       v_add2 = no .
       end .
       end .
       v_add2 = yes .

        av9030 = substring (string ( INTEGER(V1310) - 1 + i , "999" ),3,1)  +  substring (string ( INTEGER(V1310) - 1 + i , "999" ),2,1)  + substring (string ( INTEGER(V1310) - 1 + i , "999" ),1,1) + CALLBYLAP91 (V1110,"","5","").
      repeat while v_add2 :
       IF INDEX(ts9030,"$S") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$S") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$S") + length("$S"), LENGTH(ts9030) - ( index(ts9030 ,"$S" ) + length("$S") - 1 ) ).
       END.
       else do :
       v_add2 = no .
       end .
       end .
       v_add2 = yes .

       find first pt_mstr where pt_part  = V1104 no-lock no-error.
If AVAILABLE ( pt_mstr ) then
        av9030 = CALLBYLAP91 (pt_desc1 + pt_desc2,"","2","").
       repeat while v_add2 :
       IF INDEX(ts9030,"$D") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$D") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$D") + length("$D"), LENGTH(ts9030) - ( index(ts9030 ,"$D" ) + length("$D") - 1 ) ).
       END.
       else do :
       v_add2 = no .
       end .
       end  .
       v_add2 = yes .

       find first pt_mstr where pt_part  = V1104 no-lock no-error.
If AVAILABLE ( pt_mstr ) then
        av9030 = CALLBYLAP91 (pt_desc1 + pt_desc2,"","3","").
	repeat while v_add2 :
       IF INDEX(ts9030,"$W") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$W") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$W") + length("$W"), LENGTH(ts9030) - ( index(ts9030 ,"$W" ) + length("$W") - 1 ) ).
       END.
       else do :
       v_add2 = no .
       end .
       end .
       v_add2 = yes .
       find first pt_mstr where pt_part  = V1104 no-lock no-error.
If AVAILABLE ( pt_mstr ) then
        av9030 = CALLBYLAP91 (pt_desc1 + pt_desc2,"","4","").
	repeat while v_add2 :
       IF INDEX(ts9030,"$P") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$P") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$P") + length("$P"), LENGTH(ts9030) - ( index(ts9030 ,"$P" ) + length("$P") - 1 ) ).
       END.
       else do :
       v_add2 = no .
       end .
       end .

       put unformatted ts9030 skip.
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.  
     end .  /* ¿ï¾Ü A  END */
      ELSE IF v_print = "B" then do :
     INPUT FROM VALUE(LabelsPath + "lap94" + trim ( wtm_fm ) ).
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
     output to value( trim(wsection) + ".l") .
     Do While True:
              IMPORT UNFORMATTED ts9030.
       v_add2 = yes .
        av9030 = substring (string ( INTEGER(V1310) - 1 + i , "999" ),3,1)  +  substring (string ( INTEGER(V1310) - 1 + i , "999" ),2,1)  + substring (string ( INTEGER(V1310) - 1 + i , "999" ),1,1) + CALLBYLAP91 (V1110,"","5","").
       repeat while v_add2 :
       IF INDEX(ts9030,"$S") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$S") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$S") + length("$S"), LENGTH(ts9030) - ( index(ts9030 ,"$S" ) + length("$S") - 1 ) ).
       END.
       else do :
       v_add2 = no .
       end .
       end .
      
       put unformatted ts9030 skip.
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.  
     end .  /* ¿ï¾Ü B  END */
     ELSE IF v_print = "C" then do :
     INPUT FROM VALUE(LabelsPath + "lap95" + trim ( wtm_fm ) ).
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
     output to value( trim(wsection) + ".l") .
     Do While True:
              IMPORT UNFORMATTED ts9030.
       /* ss-081201.1 -b */
	/* v_add2 = yes . */
	/* ss-081201.1 -e */
        av9030 = pv9018 .
	/* repeat while v_add2 : */
       IF INDEX(ts9030,"$v") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$v") - 1) + "Pallet Qty:" + av9030 + "PCS" 
       + SUBSTRING( ts9030 , index(ts9030 ,"$v") + length("$v"), LENGTH(ts9030) - ( index(ts9030 ,"$v" ) + length("$v") - 1 ) ).
       END.
      /* else do :
       v_add2 = no .
       end .
       end . */
       
          
       put unformatted ts9030 skip.
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.  
     end .  /* ¿ï¾Ü c  END */
     
   /* ss-081126.1 - e */
     unix silent value ("chmod 777  " + trim(wsection) + ".l").
     END PROCEDURE.
     do i = 1 to integer(wtm_num):
     run lap919030l.
     
       find first PRD_DET where PRD_DEV = V9030 no-lock no-error.
       IF AVAILABLE PRD_DET then do:
         unix silent value (trim(prd_path) + " " + trim(wsection) + ".l").
         unix silent value ( "clear").
       end.
     End.
     end . /* choice = 2 */
     else do :
     Define variable ts90301 AS CHARACTER FORMAT "x(500)".
     Define variable av90301 AS CHARACTER FORMAT "x(500)".
     
     PROCEDURE lap9190301l.
        /* Define Labels Path  Start */
        Define variable LabelsPath as character format "x(100)" init "/app/mfgpro/bc/labels/".
        Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath"no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath = trim ( code_cmmt ).
        If substring(LabelsPath, length(LabelsPath), 1) <> "/" Then 
        LabelsPath = LabelsPath + "/".
	/* ss-081127.1 -b */
     define variable v_add1 as logical initial  yes .
     /* ss-081127.1 -e */
        /* Define Labels Path  END */
	/* ss-081126.1 - b */
	/* ss-081128.1 -b */
	 assign ts90301 = "" av90301 = "" .
	 /* ss-081128.1 -e */
     IF v_print = "a" then do :
     INPUT FROM VALUE(LabelsPath + "lap91" + trim ( wtm_fm ) ).
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
   
     output to value( trim(wsection) + ".l") . 
   
     Do While True:
              IMPORT UNFORMATTED ts90301.
	 /* v_add1 = yes . */
	  
        av90301 = "MODEL "+ CALLBYlap91 (V1104,"","1","").
	/* repeat while v_add1  : */
       IF INDEX(ts90301,"$M") <> 0  THEN DO:
       TS90301 = substring(TS90301, 1, Index(TS90301 , "$M") - 1) + av90301 
       + SUBSTRING( ts90301 , index(ts90301 ,"$M") + length("$M"), LENGTH(ts90301) - ( index(ts90301 ,"$M" ) + length("$M") - 1 ) ).
       END.
       /* else do :
	v_add1 = no .
	end .
	end .
	v_add1 = yes . */

	
        av90301 = substring (string ( INTEGER(V1310) - 1 + i , "999" ),3,1)  +  substring (string ( INTEGER(V1310) - 1 + i , "999" ),2,1)  + substring (string ( INTEGER(V1310) - 1 + i , "999" ),1,1) + CALLBYlap91 (V1110,"","5","").
       
      /* repeat while v_add1 : */
       IF INDEX(ts90301,"$S") <> 0  THEN DO:
       TS90301 = substring(TS90301, 1, Index(TS90301 , "$S") - 1) + av90301 
       + SUBSTRING( ts90301 , index(ts90301 ,"$S") + length("$S"), LENGTH(ts90301) - ( index(ts90301 ,"$S" ) + length("$S") - 1 ) ).
       END.
      /* else do :
       v_add1 = no .
       end .
       end .
       v_add1 = yes . */

       
       find first pt_mstr where pt_part  = V1104 no-lock no-error.
If AVAILABLE ( pt_mstr ) then
        av90301 = CALLBYlap91 (pt_desc1 + pt_desc2,"","2","").
	/* repeat while v_add1 : */
       IF INDEX(ts90301,"$D") <> 0  THEN DO:
       TS90301 = substring(TS90301, 1, Index(TS90301 , "$D") - 1) + av90301 
       + SUBSTRING( ts90301 , index(ts90301 ,"$D") + length("$D"), LENGTH(ts90301) - ( index(ts90301 ,"$D" ) + length("$D") - 1 ) ).
       END.
     /*  else do :
       v_add1 = no .
       end .
       end .
       v_add1 = yes . */

       find first pt_mstr where pt_part  = V1104 no-lock no-error.
If AVAILABLE ( pt_mstr ) then
        av90301 = CALLBYlap91 (pt_desc1 + pt_desc2,"","3","").
     /*  repeat while v_add1 : */
       IF INDEX(ts90301,"$W") <> 0  THEN DO:
       TS90301 = substring(TS90301, 1, Index(TS90301 , "$W") - 1) + av90301 
       + SUBSTRING( ts90301 , index(ts90301 ,"$W") + length("$W"), LENGTH(ts90301) - ( index(ts90301 ,"$W" ) + length("$W") - 1 ) ).
       END.
      /* else do :
       v_add1 = no .
       end .
       end .
       v_add1 = yes . */

       find first pt_mstr where pt_part  = V1104 no-lock no-error.
If AVAILABLE ( pt_mstr ) then
        av90301 = CALLBYlap91 (pt_desc1 + pt_desc2,"","4","").
	/* repeat while v_add1 : */
       IF INDEX(ts90301,"$P") <> 0  THEN DO:
       TS90301 = substring(TS90301, 1, Index(TS90301 , "$P") - 1) + av90301 
       + SUBSTRING( ts90301 , index(ts90301 ,"$P") + length("$P"), LENGTH(ts90301) - ( index(ts90301 ,"$P" ) + length("$P") - 1 ) ).
       END.
     /*  else do :
       v_add1 = no .
       end .
       end . */

       put unformatted ts90301 skip.
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.
     end . /* end "a" */
      IF v_print = "b" then do :
     
      /* ss-081127.1 -b */
     INPUT FROM VALUE(LabelsPath + "lap92" + trim ( wtm_fm ) ).
     /* ss-081127.1 -e */
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
    
     output to value( trim(wsection) + ".l") . 

        Do While True:
              IMPORT UNFORMATTED ts90301.
	     
	 v_add1 = yes .
        av90301 = substring (string ( INTEGER(V1310) - 1 + i , "999" ),3,1)  +  substring (string ( INTEGER(V1310) - 1 + i , "999" ),2,1)  + substring (string ( INTEGER(V1310) - 1 + i , "999" ),1,1) + CALLBYlap91 (V1110,"","5","").
       repeat while v_add1 :
       IF INDEX(ts90301,"$S") <> 0  THEN DO:
       TS90301 = substring(TS90301, 1, Index(TS90301 , "$S") - 1) + av90301 
       + SUBSTRING( ts90301 , index(ts90301 ,"$S") + length("$S"), LENGTH(ts90301) - ( index(ts90301 ,"$S" ) + length("$S") - 1 ) ).
       END.
       else do :
        v_add1 = no .
       end .
       end .

       put unformatted ts90301 skip.
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.
     end . /* end "b" */
      IF v_print = "c" then do :
     
     INPUT FROM VALUE(LabelsPath + "lap93" + trim ( wtm_fm ) ).
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
    
     output to value( trim(wsection) + ".l") . 
   
        Do While True:
              IMPORT UNFORMATTED ts90301.
	/* v_add1 = yes . */
        av90301 = pv9018 .
	/* repeat while v_add1  : */
       IF INDEX(ts90301,"$v") <> 0  THEN DO:
       TS90301 = substring(TS90301, 1, Index(TS90301 , "$v") - 1) + "Pallet Qty:" + av90301 + "PCS"
       + SUBSTRING( ts90301 , index(ts90301 ,"$v") + length("$v"), LENGTH(ts90301) - ( index(ts90301 ,"$v" ) + length("$v") - 1 ) ).
       END.

    /*  else do :
      v_add1 = no .
      end .
      end . */

   

       put unformatted ts90301 skip.
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.
      end . /* end "c" */
     
     /* ss-081126.1 - e */
     
     unix silent value ("chmod 777  " + trim(wsection) + ".l"). 
   
   
    
     END PROCEDURE.
     do i = 1 to integer(wtm_num):
    
     run lap9190301l.
    
       find first PRD_DET where PRD_DEV = V90301 no-lock no-error.
       IF AVAILABLE PRD_DET then do:
       
          unix silent value (trim(prd_path) + " " + trim(wsection) + ".l").
         unix silent value ( "clear"). 
	
       end.
     End.
     end . /* choice = 1 */  
   /* Internal Cycle END :90301    */
   END.
   pause 0 before-hide.
end.
