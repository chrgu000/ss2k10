/* Generate By Barcode Generator , Copyright by Softspeed - Build By Sam Song  */ 
/* SO-WO LABLE */
/* Generate date / time  11/20/07 12:49:26 */
define variable sectionid as integer init 0 .
define variable WMESSAGE  as char format "x(80)" init "".
define variable wtm_num   as char format "x(20)" init "0".
define variable wtm_fm    as char format "x(16)".
define variable wsection as char format "x(16)".
define variable i as integer .
define variable errstr as char .

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout" no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xslap87wtimeout" no-lock no-error. /*  Timeout - Program Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

mainloop:
REPEAT:
     /* CYCLE COUNTER -SECTION ID -- START*/
      sectionid = sectionid + 1 .
     /* SECTION ID -- END  */

     /* START  LINE :1002  地點[SITE]  */
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
                display "[Auto Label]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 no-box.

                /* LABEL 1 - START */ 
                L10021 = "地點設定有誤" .
                display L10021          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L10022 = "1.沒有設定默認地點" .
                display L10022          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L10023 = "2.權限設定有誤" .
                display L10023          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L10024 = "  請查核" .
                display L10024          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
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
     /* END    LINE :1002  地點[SITE]  */


   /* Additional Labels Format */
   /* Internal Cycle Input :1100    */
   V1100LMAINLOOP:
   REPEAT:
     /* START  LINE :1100  工單號碼[WO]  */
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
                display "[Auto Label]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1100 no-box.

                /* LABEL 1 - START */ 
                L11001 = "工單號碼?" .
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
                display "輸入或按E退出 "      format "x(40)" skip
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
                              INDEX("AR",WO_STATUS) <> 0 AND WO_SITE = V1002 AND  
                              WO_NBR >=  INPUT V1100
                               no-lock no-error.
                  ELSE find next WO_MSTR where 
                              INDEX("AR",WO_STATUS) <> 0 AND WO_SITE = V1002  
                               no-lock no-error.
                  IF AVAILABLE WO_MSTR then display skip 
            WO_NBR @ V1100 trim(WO_PART) + "*" + trim ( wo_so_job) @ WMESSAGE NO-LABEL with fram F1100.
                  else   display skip "" @ WMESSAGE with fram F1100.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(WO_MSTR) = ? THEN find first WO_MSTR where 
                              INDEX("AR",WO_STATUS) <> 0 AND WO_SITE = V1002 AND  
            WO_NBR <=  INPUT V1100
                               no-lock no-error.
                  ELSE find prev WO_MSTR where 
                              INDEX("AR",WO_STATUS) <> 0 AND WO_SITE = V1002 
                               no-lock no-error.
                  IF AVAILABLE WO_MSTR then display skip 
            WO_NBR @ V1100 trim(WO_PART) + "*" + trim ( wo_so_job) @ WMESSAGE NO-LABEL with fram F1100.
                  else   display skip "" @ WMESSAGE with fram F1100.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        /* **SKIP TO MAIN LOOP START** */
        IF V1100 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        display  skip WMESSAGE NO-LABEL with fram F1100.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        if length(trim(V1100))=0 then do:
display skip "工單不能為空" @ WMESSAGE NO-LABEL with fram F1100.
                pause 0 before-hide.
                Undo, retry.

End.
        find first WO_MSTR where WO_NBR = V1100 AND INDEX("AR",WO_STATUS) <> 0 AND WO_SITE = V1002  NO-ERROR NO-WAIT.
        IF NOT AVAILABLE WO_MSTR then do:
                display skip "無效或被鎖!" @ WMESSAGE NO-LABEL with fram F1100.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        leave V1100L.
     END.
     PV1100 = V1100.
     /* END    LINE :1100  工單號碼[WO]  */


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
        find last wo_mstr where wo_nbr  = V1100  and wo_site = V1002 no-lock no-error.
If AVAILABLE ( wo_mstr )  and  wo_lot = V1103 then
        leave V1103L.
        /* LOGICAL SKIP END */
                display "[Auto Label]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1103 no-box.

                /* LABEL 1 - START */ 
                L11031 = "工單ID#" .
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
                L11033 = "工單:" + V1100 .
                display L11033          format "x(40)" skip with fram F1103 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11034 = "" . 
                display L11034          format "x(40)" skip with fram F1103 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
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
                              wo_nbr = V1100 AND INDEX("AR",WO_STATUS) <> 0 and wo_site = V1002 AND  
                              wo_lot >=  INPUT V1103
                               no-lock no-error.
                  ELSE find next wo_mstr where 
                              wo_nbr = V1100 AND INDEX("AR",WO_STATUS) <> 0 and wo_site = V1002  
                               no-lock no-error.
                  IF AVAILABLE wo_mstr then display skip 
            wo_lot @ V1103 "成品: " +  trim (wo_part) @ WMESSAGE NO-LABEL with fram F1103.
                  else   display skip "" @ WMESSAGE with fram F1103.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(wo_mstr) = ? THEN find first wo_mstr where 
                              wo_nbr = V1100 AND INDEX("AR",WO_STATUS) <> 0 and wo_site = V1002 AND  
            wo_lot <=  INPUT V1103
                               no-lock no-error.
                  ELSE find prev wo_mstr where 
                              wo_nbr = V1100 AND INDEX("AR",WO_STATUS) <> 0 and wo_site = V1002 
                               no-lock no-error.
                  IF AVAILABLE wo_mstr then display skip 
            wo_lot @ V1103 "成品: " +  trim (wo_part) @ WMESSAGE NO-LABEL with fram F1103.
                  else   display skip "" @ WMESSAGE with fram F1103.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1103 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1103.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1103.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first wo_mstr where wo_lot = V1103 AND INDEX("AR",WO_STATUS) <> 0 and wo_site = V1002  NO-ERROR NO-WAIT.
        IF NOT AVAILABLE wo_mstr then do:
                display skip "無效或被鎖!" @ WMESSAGE NO-LABEL with fram F1103.
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
     /* START  LINE :1104  料品  */
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
        find first wo_mstr where wo_site=V1002 and wo_nbr=V1100 and wo_lot=V1103 no-lock no-error.
If avail wo_mstr then
        V1104 = wo_part.
        V1104 = ENTRY(1,V1104,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1104 = ENTRY(1,V1104,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[Auto Label]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1104 no-box.

                /* LABEL 1 - START */ 
                L11041 = "料品?" .
                display L11041          format "x(40)" skip with fram F1104 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11042 = "工單:" + V1100 + "/" + V1103 .
                display L11042          format "x(40)" skip with fram F1104 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11043 = "" . 
                display L11043          format "x(40)" skip with fram F1104 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11044 = "" . 
                display L11044          format "x(40)" skip with fram F1104 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1104 no-box.
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

        /* PRESS e EXIST CYCLE */
        IF V1104 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1104.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1104.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first pt_mstr where pt_part=V1104 no-lock no-error.
If not avail pt_mstr then do :
display skip "料號不存在" @ WMESSAGE NO-LABEL with fram F1104.
                pause 0 before-hide.
                Undo, retry.

End.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1104.
        pause 0.
        leave V1104L.
     END.
     PV1104 = V1104.
     /* END    LINE :1104  料品  */


   /* Additional Labels Format */
     /* START  LINE :1105  銷售訂單[SalesOrder]  */
     V1105L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1105           as char format "x(50)".
        define variable PV1105          as char format "x(50)".
        define variable L11051          as char format "x(40)".
        define variable L11052          as char format "x(40)".
        define variable L11053          as char format "x(40)".
        define variable L11054          as char format "x(40)".
        define variable L11055          as char format "x(40)".
        define variable L11056          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first wo_mstr where wo_nbr=V1100 and wo_site=V1002 and wo_lot=V1103 no-lock no-error.
If avail wo_mstr then
V1105 = if substring( wo_so_job,1,2 ) = "RA" then substring(wo_so_job,1,8) else substring(wo_so_job,1,7).
If V1105<>"" then
        V1105 = V1105.
        V1105 = ENTRY(1,V1105,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1105 = ENTRY(1,V1105,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[Auto Label]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1105 no-box.

                /* LABEL 1 - START */ 
                L11051 = "銷售訂單?" .
                display L11051          format "x(40)" skip with fram F1105 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11052 = "工單:" + V1100 + "/" + V1103 .
                display L11052          format "x(40)" skip with fram F1105 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11053 = "*SA-正式(7位)*" .
                display L11053          format "x(40)" skip with fram F1105 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11054 = "*RA-返工(8位)*" .
                display L11054          format "x(40)" skip with fram F1105 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1105 no-box.
        Update V1105
        WITH  fram F1105 NO-LABEL
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
        IF V1105 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1105.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1105.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first so_mstr where so_nbr=V1105 and so_site=V1002 no-lock no-error.
If not AVAILABLE ( so_mstr )  then do:
 display skip "訂單不存在" @ WMESSAGE NO-LABEL with fram F1105.
                pause 0 before-hide.
                Undo, retry.

End.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1105.
        pause 0.
        leave V1105L.
     END.
     PV1105 = V1105.
     /* END    LINE :1105  銷售訂單[SalesOrder]  */


   /* Additional Labels Format */
     /* START  LINE :1106  PO[CustPO]  */
     V1106L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1106           as char format "x(50)".
        define variable PV1106          as char format "x(50)".
        define variable L11061          as char format "x(40)".
        define variable L11062          as char format "x(40)".
        define variable L11063          as char format "x(40)".
        define variable L11064          as char format "x(40)".
        define variable L11065          as char format "x(40)".
        define variable L11066          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        def var ii as integer.
Find first so_mstr where so_nbr=V1105 no-lock no-error.
If avail so_mstr and so_po<>"" then do:
	V1106=so_po.
	do ii=1 to length(so_po):
	    if substring(so_po,ii,1)="/" then  V1106=substring(so_po,1,ii - 1).

	End.
End.
Else V1106="".
If V1106<>"" then
        V1106 = V1106.
        V1106 = ENTRY(1,V1106,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1106 = ENTRY(1,V1106,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        if 1=1 then
        leave V1106L.
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1106L.
        /* --FIRST TIME SKIP -- END  */

                display "[Auto Label]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1106 no-box.

                /* LABEL 1 - START */ 
                L11061 = "Cust PO?" .
                display L11061          format "x(40)" skip with fram F1106 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11062 = "工單:" + V1100 + "/" + V1103 .
                display L11062          format "x(40)" skip with fram F1106 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11063 = "訂單號:" + V1105 .
                display L11063          format "x(40)" skip with fram F1106 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11064 = "" . 
                display L11064          format "x(40)" skip with fram F1106 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1106 no-box.
        Update V1106
        WITH  fram F1106 NO-LABEL
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
        IF V1106 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1106.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1106.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        if length(trim(V1106))=0 then do:
display skip "PO不能為空" @ WMESSAGE NO-LABEL with fram F1106.
                pause 0 before-hide.
                Undo, retry.

End.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1106.
        pause 0.
        leave V1106L.
     END.
     PV1106 = V1106.
     /* END    LINE :1106  PO[CustPO]  */


   /* Additional Labels Format */
     /* START  LINE :1107  隆等砐棒  */
     V1107L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1107           as char format "x(50)".
        define variable PV1107          as char format "x(50)".
        define variable L11071          as char format "x(40)".
        define variable L11072          as char format "x(40)".
        define variable L11073          as char format "x(40)".
        define variable L11074          as char format "x(40)".
        define variable L11075          as char format "x(40)".
        define variable L11076          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1107 = " ".
        V1107 = ENTRY(1,V1107,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1107 = ENTRY(1,V1107,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1107L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1107L .
        /* --CYCLE TIME SKIP -- END  */

                display "[Auto Label]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1107 no-box.

                /* LABEL 1 - START */ 
                L11071 = "訂單項次?" .
                display L11071          format "x(40)" skip with fram F1107 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11072 = "工單:" + V1100 + "/" + V1103 .
                display L11072          format "x(40)" skip with fram F1107 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11073 = "訂單號:" + V1105 .
                display L11073          format "x(40)" skip with fram F1107 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11074 = "" . 
                display L11074          format "x(40)" skip with fram F1107 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1107 no-box.
        /* DISPLAY ONLY */
        define variable X1107           as char format "x(40)".
        X1107 = V1107.
        V1107 = "".
        /* DISPLAY ONLY */
        Update V1107
        WITH  fram F1107 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V1107 = X1107.
        /* DISPLAY ONLY */
        LEAVE V1107L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1107 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1107.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1107.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1107.
        pause 0.
        leave V1107L.
     END.
     PV1107 = V1107.
     /* END    LINE :1107  隆等砐棒  */


   /* Additional Labels Format */
     /* START  LINE :1108  PKLIST[PACKING List]  */
     V1108L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1108           as char format "x(50)".
        define variable PV1108          as char format "x(50)".
        define variable L11081          as char format "x(40)".
        define variable L11082          as char format "x(40)".
        define variable L11083          as char format "x(40)".
        define variable L11084          as char format "x(40)".
        define variable L11085          as char format "x(40)".
        define variable L11086          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        def var kkb2 as integer.
Find first wo_mstr where wo_nbr=V1100 and wo_site=V1002 and wo_lot=V1103 no-lock no-error.
If avail wo_mstr and wo_rmks<>"" then do:
  V1108=wo_rmks.
  Do kkb2=1 to length(wo_rmks):
    if substring(wo_rmks,kkb2,1)="/" then assign V1108=substring(wo_rmks,1,kkb2 - 1).
  End.
End.
Else V1108="".
If V1108<>"" then
        V1108 = V1108.
        V1108 = ENTRY(1,V1108,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1108 = ENTRY(1,V1108,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        if 1=1 then
        leave V1108L.
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1108L.
        /* --FIRST TIME SKIP -- END  */

                display "[Auto Label]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1108 no-box.

                /* LABEL 1 - START */ 
                L11081 = "PACKING LIST?" .
                display L11081          format "x(40)" skip with fram F1108 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11082 = "工單:" + V1100 + "/" + V1103 .
                display L11082          format "x(40)" skip with fram F1108 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11083 = "" . 
                display L11083          format "x(40)" skip with fram F1108 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11084 = "" . 
                display L11084          format "x(40)" skip with fram F1108 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1108 no-box.
        Update V1108
        WITH  fram F1108 NO-LABEL
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
        IF V1108 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1108.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1108.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1108.
        pause 0.
        leave V1108L.
     END.
     PV1108 = V1108.
     /* END    LINE :1108  PKLIST[PACKING List]  */


   /* Additional Labels Format */
     /* START  LINE :1109  客戶[CUST]  */
     V1109L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1109           as char format "x(50)".
        define variable PV1109          as char format "x(50)".
        define variable L11091          as char format "x(40)".
        define variable L11092          as char format "x(40)".
        define variable L11093          as char format "x(40)".
        define variable L11094          as char format "x(40)".
        define variable L11095          as char format "x(40)".
        define variable L11096          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first so_mstr where so_nbr=V1105 no-lock no-error.
If  AVAILABLE ( so_mstr )  then
        V1109 = so_cust.
        V1109 = ENTRY(1,V1109,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1109 = ENTRY(1,V1109,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        if 1=1 then
        leave V1109L.
        /* LOGICAL SKIP END */
                display "[Auto Label]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1109 no-box.

                /* LABEL 1 - START */ 
                L11091 = "客戶?" .
                display L11091          format "x(40)" skip with fram F1109 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11092 = "" . 
                display L11092          format "x(40)" skip with fram F1109 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11093 = "" . 
                display L11093          format "x(40)" skip with fram F1109 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11094 = "" . 
                display L11094          format "x(40)" skip with fram F1109 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1109 no-box.
        Update V1109
        WITH  fram F1109 NO-LABEL
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
        IF V1109 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1109.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1109.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1109.
        pause 0.
        leave V1109L.
     END.
     PV1109 = V1109.
     /* END    LINE :1109  客戶[CUST]  */


   /* Additional Labels Format */
     /* START  LINE :1110  Part Ver[Pver]  */
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
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first pt_mstr where pt_part=V1104 no-lock no-error.
If  AVAILABLE ( pt_mstr )  then
        V1110 = pt_rev.
        V1110 = ENTRY(1,V1110,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1110 = ENTRY(1,V1110,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[Auto Label]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1110 no-box.

                /* LABEL 1 - START */ 
                L11101 = "料號版本?" .
                display L11101          format "x(40)" skip with fram F1110 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11102 = "工單:" + V1100 + "/" + V1103 .
                display L11102          format "x(40)" skip with fram F1110 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11103 = "訂單號:" + V1105 .
                display L11103          format "x(40)" skip with fram F1110 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11104 = "料號:" + V1104 .
                display L11104          format "x(40)" skip with fram F1110 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1110 no-box.
        Update V1110
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
        IF V1110 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1110.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1110.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        if length(trim(V1110))=0 then do:
display skip "料號版本不能為空" @ WMESSAGE NO-LABEL with fram F1110.
                pause 0 before-hide.
                Undo, retry.

End.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1110.
        pause 0.
        leave V1110L.
     END.
     PV1110 = V1110.
     /* END    LINE :1110  Part Ver[Pver]  */


   /* Additional Labels Format */
     /* START  LINE :1111  客戶料號[CUST PART]  */
     V1111L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1111           as char format "x(50)".
        define variable PV1111          as char format "x(50)".
        define variable L11111          as char format "x(40)".
        define variable L11112          as char format "x(40)".
        define variable L11113          as char format "x(40)".
        define variable L11114          as char format "x(40)".
        define variable L11115          as char format "x(40)".
        define variable L11116          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        Find first sod_det where sod_nbr=V1105 and sod_part=V1104 AND sod_site=V1002 no-lock no-error.
If  AVAILABLE ( sod_det )  and sod_custpart<>"" then do:
        V1111=sod_custpart. 
	do ii=1 to length(sod_custpart):
	    if substring(sod_custpart,ii,1)="/" then V1111=substring(sod_custpart,1,ii - 1).
	End.
End.
Else do:
	find first cp_mstr where cp_cust=V1109 and cp_part=V1104 no-lock no-error.
	If  AVAILABLE ( cp_mstr )  then do:
	        V1111=cp_cust_part.
		do ii=1 to length(cp_cust_part):
		    if substring(cp_cust_part,ii,1)="/" then V1111=substring(cp_cust_part,1,ii - 1).
		End.

	End.
End.
If V1111<>"" then
        V1111 = V1111.
        V1111 = ENTRY(1,V1111,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1111 = ENTRY(1,V1111,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[Auto Label]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1111 no-box.

                /* LABEL 1 - START */ 
                L11111 = "客戶料號?" .
                display L11111          format "x(40)" skip with fram F1111 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11112 = "工單:" + V1100 + "/" + V1103 .
                display L11112          format "x(40)" skip with fram F1111 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11113 = "訂單號:" + V1105 .
                display L11113          format "x(40)" skip with fram F1111 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11114 = "料號:" + V1104 .
                display L11114          format "x(40)" skip with fram F1111 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1111 no-box.
        Update V1111
        WITH  fram F1111 NO-LABEL
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
        IF V1111 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1111.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1111.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not V1111<>"" THEN DO:
                display skip "客戶料號不能為空" @ WMESSAGE NO-LABEL with fram F1111.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1111.
        pause 0.
        leave V1111L.
     END.
     PV1111 = V1111.
     /* END    LINE :1111  客戶料號[CUST PART]  */


   /* Additional Labels Format */
     /* START  LINE :1112  PO砐棒  */
     V1112L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1112           as char format "x(50)".
        define variable PV1112          as char format "x(50)".
        define variable L11121          as char format "x(40)".
        define variable L11122          as char format "x(40)".
        define variable L11123          as char format "x(40)".
        define variable L11124          as char format "x(40)".
        define variable L11125          as char format "x(40)".
        define variable L11126          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first so_mstr where so_nbr=V1105 no-lock no-error.
If avail so_mstr and so_rmks<>"" then
do:
do ii=1 to length(so_rmks):
    if substring(so_rmks,ii,1)="/" then V1112=substring(so_rmks,ii + 1).
End.
End.
If length(V1112)>4 then assign V1112=substring(V1112,5).
If V1112<>"" then
        V1112 = V1112.
        V1112 = ENTRY(1,V1112,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1112 = ENTRY(1,V1112,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[Auto Label]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1112 no-box.

                /* LABEL 1 - START */ 
                L11121 = "客PO項次?" .
                display L11121          format "x(40)" skip with fram F1112 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11122 = "訂單號：" + V1105 .
                display L11122          format "x(40)" skip with fram F1112 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11123 = "客戶料號:" + V1111 .
                display L11123          format "x(40)" skip with fram F1112 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11124 = "" . 
                display L11124          format "x(40)" skip with fram F1112 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1112 no-box.
        Update V1112
        WITH  fram F1112 NO-LABEL
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
        IF V1112 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1112.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1112.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1112.
        pause 0.
        leave V1112L.
     END.
     PV1112 = V1112.
     /* END    LINE :1112  PO砐棒  */


   /* Additional Labels Format */
     /* START  LINE :1113  批號[Part Lot]  */
     V1113L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1113           as char format "x(50)".
        define variable PV1113          as char format "x(50)".
        define variable L11131          as char format "x(40)".
        define variable L11132          as char format "x(40)".
        define variable L11133          as char format "x(40)".
        define variable L11134          as char format "x(40)".
        define variable L11135          as char format "x(40)".
        define variable L11136          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1113 = " ".
        V1113 = ENTRY(1,V1113,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1113 = ENTRY(1,V1113,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1113L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1113L .
        /* --CYCLE TIME SKIP -- END  */

                display "[Auto Label]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1113 no-box.

                /* LABEL 1 - START */ 
                L11131 = "批號?" .
                display L11131          format "x(40)" skip with fram F1113 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11132 = "訂單號：" + V1105 .
                display L11132          format "x(40)" skip with fram F1113 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11133 = "客戶料號:" + V1111 .
                display L11133          format "x(40)" skip with fram F1113 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11134 = "" . 
                display L11134          format "x(40)" skip with fram F1113 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1113 no-box.
        /* DISPLAY ONLY */
        define variable X1113           as char format "x(40)".
        X1113 = V1113.
        V1113 = "".
        /* DISPLAY ONLY */
        Update V1113
        WITH  fram F1113 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V1113 = X1113.
        /* DISPLAY ONLY */
        LEAVE V1113L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1113 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1113.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1113.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1113.
        pause 0.
        leave V1113L.
     END.
     PV1113 = V1113.
     /* END    LINE :1113  批號[Part Lot]  */


   /* Additional Labels Format */
     /* START  LINE :1114  版本[Ver]  */
     V1114L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1114           as char format "x(50)".
        define variable PV1114          as char format "x(50)".
        define variable L11141          as char format "x(40)".
        define variable L11142          as char format "x(40)".
        define variable L11143          as char format "x(40)".
        define variable L11144          as char format "x(40)".
        define variable L11145          as char format "x(40)".
        define variable L11146          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first sod_det where sod_nbr=V1105 and sod_part=V1104 AND sod_site=V1002 no-lock no-error.
If  AVAILABLE ( sod_det )  and sod_custpart<>"" then do:
do ii=1 to length(sod_custpart):
    if substring(sod_custpart,ii,1)="/" then V1114=substring(sod_custpart,ii + 1).
End.
End.
Else do:
find first cp_mstr where cp_cust=V1109 and cp_part=V1104 no-lock no-error.
If  AVAILABLE ( cp_mstr )  then do:
do ii=1 to length(cp_cust_part):
    if substring(cp_cust_part,ii,1)="/" then V1114=substring(cp_cust_part,1,ii + 1).
End.

End.
End.
If V1114<>"" then
        V1114 = V1114.
        V1114 = ENTRY(1,V1114,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1114 = ENTRY(1,V1114,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[Auto Label]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1114 no-box.

                /* LABEL 1 - START */ 
                L11141 = "客戶料號版本?" .
                display L11141          format "x(40)" skip with fram F1114 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11142 = "工單:" + V1100 + "/" + V1103 .
                display L11142          format "x(40)" skip with fram F1114 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11143 = "訂單號:" + V1105 .
                display L11143          format "x(40)" skip with fram F1114 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11144 = "客戶料號:" + V1111 .
                display L11144          format "x(40)" skip with fram F1114 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1114 no-box.
        Update V1114
        WITH  fram F1114 NO-LABEL
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
        IF V1114 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1114.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1114.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        /* If length(trim(V1114))=0 then do :
display skip "不能為空" @ WMESSAGE NO-LABEL with fram F1114.
                pause 0 before-hide.
                Undo, retry.

End. */
        IF not V1114<>"" THEN DO:
                display skip "客戶料號版本不能為空" @ WMESSAGE NO-LABEL with fram F1114.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1114.
        pause 0.
        leave V1114L.
     END.
     PV1114 = V1114.
     /* END    LINE :1114  版本[Ver]  */


   /* Additional Labels Format */
     /* START  LINE :1115  生產日期[Prod Date]  */
     V1115L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1115           as char format "x(50)".
        define variable PV1115          as char format "x(50)".
        define variable L11151          as char format "x(40)".
        define variable L11152          as char format "x(40)".
        define variable L11153          as char format "x(40)".
        define variable L11154          as char format "x(40)".
        define variable L11155          as char format "x(40)".
        define variable L11156          as char format "x(40)".
        define variable D1115           as date .
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1115 = string(today).
        D1115 = Date ( V1115).
        V1115 = ENTRY(1,V1115,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1115 = ENTRY(1,V1115,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[Auto Label]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1115 no-box.

                /* LABEL 1 - START */ 
                L11151 = "生產日期?" .
                display L11151          format "x(40)" skip with fram F1115 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11152 = "工單:" + V1100 + "/" + V1103 .
                display L11152          format "x(40)" skip with fram F1115 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11153 = "訂單號:" + V1105 .
                display L11153          format "x(40)" skip with fram F1115 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11154 = "料號:" + V1104 .
                display L11154          format "x(40)" skip with fram F1115 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1115 no-box.
        Update D1115
        WITH  fram F1115 NO-LABEL
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
        IF V1115 = "e" THEN  LEAVE V1100LMAINLOOP.
        V1115 = string ( D1115).
        display  skip WMESSAGE NO-LABEL with fram F1115.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1115.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1115.
        pause 0.
        leave V1115L.
     END.
     PV1115 = V1115.
     /* END    LINE :1115  生產日期[Prod Date]  */


   /* Additional Labels Format */
     /* START  LINE :1116  生產線[prod line]  */
     V1116L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1116           as char format "x(50)".
        define variable PV1116          as char format "x(50)".
        define variable L11161          as char format "x(40)".
        define variable L11162          as char format "x(40)".
        define variable L11163          as char format "x(40)".
        define variable L11164          as char format "x(40)".
        define variable L11165          as char format "x(40)".
        define variable L11166          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1116 = " ".
        V1116 = ENTRY(1,V1116,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1116 = ENTRY(1,V1116,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[Auto Label]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1116 no-box.

                /* LABEL 1 - START */ 
                L11161 = "生產線?" .
                display L11161          format "x(40)" skip with fram F1116 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11162 = "工單:" + V1100 + "/" + V1103 .
                display L11162          format "x(40)" skip with fram F1116 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11163 = "訂單號:" + V1105 .
                display L11163          format "x(40)" skip with fram F1116 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11164 = "料號:" + V1104 .
                display L11164          format "x(40)" skip with fram F1116 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1116 no-box.
        Update V1116
        WITH  fram F1116 NO-LABEL
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
        IF V1116 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1116.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1116.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        If length(trim(V1116))>2 then do :
display skip "長度不能超過2位" @ WMESSAGE NO-LABEL with fram F1116.
                pause 0 before-hide.
                Undo, retry.

End.
        IF not V1116<>"" THEN DO:
                display skip "生產線不能為空" @ WMESSAGE NO-LABEL with fram F1116.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1116.
        pause 0.
        leave V1116L.
     END.
     PV1116 = V1116.
     /* END    LINE :1116  生產線[prod line]  */


   /* Additional Labels Format */
     /* START  LINE :1117  1kpoine  */
     V1117L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1117           as char format "x(50)".
        define variable PV1117          as char format "x(50)".
        define variable L11171          as char format "x(40)".
        define variable L11172          as char format "x(40)".
        define variable L11173          as char format "x(40)".
        define variable L11174          as char format "x(40)".
        define variable L11175          as char format "x(40)".
        define variable L11176          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        if length(trim(V1112))<>0 then V1117="1K" + V1112.
else V1117="".
If V1117<>"" then
        V1117 = V1117.
        V1117 = ENTRY(1,V1117,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1117 = ENTRY(1,V1117,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        if 1=1 then
        leave V1117L.
        /* LOGICAL SKIP END */
                display "[Auto Label]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1117 no-box.

                /* LABEL 1 - START */ 
                L11171 = "PO LINE?" .
                display L11171          format "x(40)" skip with fram F1117 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11172 = "" . 
                display L11172          format "x(40)" skip with fram F1117 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11173 = "" . 
                display L11173          format "x(40)" skip with fram F1117 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11174 = "" . 
                display L11174          format "x(40)" skip with fram F1117 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1117 no-box.
        Update V1117
        WITH  fram F1117 NO-LABEL
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
        IF V1117 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1117.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1117.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1117.
        pause 0.
        leave V1117L.
     END.
     PV1117 = V1117.
     /* END    LINE :1117  1kpoine  */


   /* Additional Labels Format */
     /* START  LINE :1118  班次[shift]  */
     V1118L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1118           as char format "x(50)".
        define variable PV1118          as char format "x(50)".
        define variable L11181          as char format "x(40)".
        define variable L11182          as char format "x(40)".
        define variable L11183          as char format "x(40)".
        define variable L11184          as char format "x(40)".
        define variable L11185          as char format "x(40)".
        define variable L11186          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1118 = "D".
        V1118 = ENTRY(1,V1118,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1118 = ENTRY(1,V1118,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[Auto Label]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1118 no-box.

                /* LABEL 1 - START */ 
                L11181 = "班次?" .
                display L11181          format "x(40)" skip with fram F1118 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11182 = "工單:" + V1100 + "/" + V1103 .
                display L11182          format "x(40)" skip with fram F1118 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11183 = "訂單號:" + V1105 .
                display L11183          format "x(40)" skip with fram F1118 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11184 = "D-日班,W-夜班" .
                display L11184          format "x(40)" skip with fram F1118 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1118 no-box.
        Update V1118
        WITH  fram F1118 NO-LABEL
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
        IF V1118 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1118.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1118.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not (V1118="d" or V1118="w") THEN DO:
                display skip "班次隻能是D或W" @ WMESSAGE NO-LABEL with fram F1118.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1118.
        pause 0.
        leave V1118L.
     END.
     PV1118 = V1118.
     /* END    LINE :1118  班次[shift]  */


   /* Additional Labels Format */
     /* START  LINE :1120  標簽類型[label type]  */
     V1120L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1120           as char format "x(50)".
        define variable PV1120          as char format "x(50)".
        define variable L11201          as char format "x(40)".
        define variable L11202          as char format "x(40)".
        define variable L11203          as char format "x(40)".
        define variable L11204          as char format "x(40)".
        define variable L11205          as char format "x(40)".
        define variable L11206          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1120 = "n".
        V1120 = ENTRY(1,V1120,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1120 = ENTRY(1,V1120,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[Auto Label]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1120 no-box.

                /* LABEL 1 - START */ 
                L11201 = "標簽類型?" .
                display L11201          format "x(40)" skip with fram F1120 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11202 = "工單:" + V1100 + "/" + V1103 .
                display L11202          format "x(40)" skip with fram F1120 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11203 = "訂單號:" + V1105 .
                display L11203          format "x(40)" skip with fram F1120 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11204 = "n-內箱標簽，w-外箱標簽" .
                display L11204          format "x(40)" skip with fram F1120 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1120 no-box.
        Update V1120
        WITH  fram F1120 NO-LABEL
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
        IF V1120 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1120.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1120.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         Define variable LabelsPath1 as character format "x(100)" init "/app/mfgpro/bc/labels/".
        Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath" no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath1 = trim ( code_cmmt ).
        If substring(LabelsPath1, length(LabelsPath1), 1) <> "/" Then 
        LabelsPath1 = LabelsPath1 + "/".

	 If search(LabelsPath1 + "lap87" + trim ( V1120 ) ) = ? Then do:
	                 display skip "文件不存在，請重新輸入." @ WMESSAGE NO-LABEL with fram F1120.
                         pause 0 before-hide.
                         Undo, retry.
	 End.
Wtm_fm = V1120.
        IF not (V1120="n" or V1120="w") THEN DO:
                display skip "Input Error" @ WMESSAGE NO-LABEL with fram F1120.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1120.
        pause 0.
        leave V1120L.
     END.
     PV1120 = V1120.
     /* END    LINE :1120  標簽類型[label type]  */


   /* Additional Labels Format */
     /* START  LINE :1122  Serial#[Serial#]  */
     V1122L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1122           as char format "x(50)".
        define variable PV1122          as char format "x(50)".
        define variable L11221          as char format "x(40)".
        define variable L11222          as char format "x(40)".
        define variable L11223          as char format "x(40)".
        define variable L11224          as char format "x(40)".
        define variable L11225          as char format "x(40)".
        define variable L11226          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1122=if length(string(year(Date(V1115)))) > 3 then substring(string(year(Date(V1115))),3) else string(year(Date(V1115))) .
V1122=V1122 + 
entry(month(date(V1115)),"A,B,C,D,E,F,G,H,J,K,L,M") + 
if day(date(V1115))<10 then "0" + string(day(date(V1115))) else string(day(date(V1115)))
.
If trim(V1118)="d" then
V1122=V1122 + "A".
If trim(V1118)="w" then
V1122=V1122 + "B".

If V1122<>"" then
        V1122 = V1122.
        V1122 = ENTRY(1,V1122,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1122 = ENTRY(1,V1122,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        if V1120="w" then
        leave V1122L.
        /* LOGICAL SKIP END */
                display "[Auto Label]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1122 no-box.

                /* LABEL 1 - START */ 
                L11221 = "Serial#?" .
                display L11221          format "x(40)" skip with fram F1122 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11222 = "工單:" + V1100 + "/" + V1103 .
                display L11222          format "x(40)" skip with fram F1122 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11223 = "訂單號:" + V1105 .
                display L11223          format "x(40)" skip with fram F1122 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11224 = "料號:" + V1104 .
                display L11224          format "x(40)" skip with fram F1122 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1122 no-box.
        Update V1122
        WITH  fram F1122 NO-LABEL
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
        IF V1122 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1122.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1122.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        if length(trim(V1122))=0 and V1120<>"w"  then do:
display skip "Serial不能為空" @ WMESSAGE NO-LABEL with fram F1122.
                pause 0 before-hide.
                Undo, retry.

End.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1122.
        pause 0.
        leave V1122L.
     END.
     PV1122 = V1122.
     /* END    LINE :1122  Serial#[Serial#]  */


   /* Additional Labels Format */
     /* START  LINE :1124  發貨日期[Ship Date]  */
     V1124L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1124           as char format "x(50)".
        define variable PV1124          as char format "x(50)".
        define variable L11241          as char format "x(40)".
        define variable L11242          as char format "x(40)".
        define variable L11243          as char format "x(40)".
        define variable L11244          as char format "x(40)".
        define variable L11245          as char format "x(40)".
        define variable L11246          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first wo_mstr where wo_nbr=V1100 and wo_site=V1002 and wo_lot=V1103 no-lock no-error.
If avail wo_mstr and wo_rmks <> "" then
        V1124 = wo_rmks.
        V1124 = ENTRY(1,V1124,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V1124 = PV1124 .
        V1124 = ENTRY(1,V1124,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        if V1120="n" then
        leave V1124L.
        /* LOGICAL SKIP END */
                display "[Auto Label]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1124 no-box.

                /* LABEL 1 - START */ 
                L11241 = "發貨日期?" .
                display L11241          format "x(40)" skip with fram F1124 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11242 = "工單:" + V1100 + "/" + V1103 .
                display L11242          format "x(40)" skip with fram F1124 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11243 = "訂單號:" + V1105 .
                display L11243          format "x(40)" skip with fram F1124 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11244 = "料號:" + V1104 .
                display L11244          format "x(40)" skip with fram F1124 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1124 no-box.
        Update V1124
        WITH  fram F1124 NO-LABEL
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
        IF V1124 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1124.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1124.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        if length(trim(V1124))=0 and V1120<>"n"  then do:
display skip "Ship Date不能為空" @ WMESSAGE NO-LABEL with fram F1124.
                pause 0 before-hide.
                Undo, retry.

End.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1124.
        pause 0.
        leave V1124L.
     END.
     PV1124 = V1124.
     /* END    LINE :1124  發貨日期[Ship Date]  */


   /* Additional Labels Format */
     /* START  LINE :1335  parverdate[Partverdate]  */
     V1335L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1335           as char format "x(50)".
        define variable PV1335          as char format "x(50)".
        define variable L13351          as char format "x(40)".
        define variable L13352          as char format "x(40)".
        define variable L13353          as char format "x(40)".
        define variable L13354          as char format "x(40)".
        define variable L13355          as char format "x(40)".
        define variable L13356          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        {xsweekc87.i}
V1335 = fill( "0" , 4 - length (  trim (V1110) ) ) + trim (V1110) + trim ( WeekResult ) + ( if substring ( trim (V1105) ,1,1) = "R" then "R" else "*" ) + trim(V1116) + trim(V1118).
If V1335<>"" then
        V1335 = V1335.
        V1335 = ENTRY(1,V1335,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1335 = ENTRY(1,V1335,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1335L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1335L .
        /* --CYCLE TIME SKIP -- END  */

                display "[Auto Label]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1335 no-box.

                /* LABEL 1 - START */ 
                L13351 = "parvardate?" .
                display L13351          format "x(40)" skip with fram F1335 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L13352 = "" . 
                display L13352          format "x(40)" skip with fram F1335 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L13353 = "" . 
                display L13353          format "x(40)" skip with fram F1335 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13354 = "" . 
                display L13354          format "x(40)" skip with fram F1335 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1335 no-box.
        /* DISPLAY ONLY */
        define variable X1335           as char format "x(40)".
        X1335 = V1335.
        V1335 = "".
        /* DISPLAY ONLY */
        Update V1335
        WITH  fram F1335 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V1335 = X1335.
        /* DISPLAY ONLY */
        LEAVE V1335L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1335 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1335.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1335.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1335.
        pause 0.
        leave V1335L.
     END.
     PV1335 = V1335.
     /* END    LINE :1335  parverdate[Partverdate]  */


   /* Additional Labels Format */
     /* START  LINE :9010  條碼上的數量[QTY ON LABEL]  */
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
        V9010 = "0".
        V9010 = ENTRY(1,V9010,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9010 = ENTRY(1,V9010,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[Auto Label]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9010 no-box.

                /* LABEL 1 - START */ 
                L90101 = "條碼上數量?" .
                display L90101          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L90102 = "工單:" + V1100 + "/" + V1103 .
                display L90102          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L90103 = "" . 
                display L90103          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L90104 = "料號:" + V1104 .
                display L90104          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
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
        IF V9010 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9010.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9010.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        If V9010 = "" OR V9010 = "-" OR V9010 = "." OR V9010 = ".-" OR V9010 = "-." then do:
                display skip "CAN NOT EMPTY  " @ WMESSAGE NO-LABEL with fram F9010.
                pause 0 before-hide.
                undo, retry.
        end.
        DO i = 1 to length(V9010).
                If index("0987654321.-", substring(V9010,i,1)) = 0 then do:
                display skip "Format  Error  " @ WMESSAGE NO-LABEL with fram F9010.
                pause 0 before-hide.
                undo, retry.
                end.
        end.
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9010.
        pause 0.
        leave V9010L.
     END.
     PV9010 = V9010.
     /* END    LINE :9010  條碼上的數量[QTY ON LABEL]  */


   /* Additional Labels Format */
     /* START  LINE :9020  條碼個數[NO OF LABEL]  */
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
                display "[Auto Label]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9020 no-box.

                /* LABEL 1 - START */ 
                L90201 = "條碼張數?" .
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
                display "輸入或按E退出 "      format "x(40)" skip
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
        IF V9020 = "e" THEN  LEAVE V1100LMAINLOOP.
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
     /* END    LINE :9020  條碼個數[NO OF LABEL]  */


   wtm_num = V9020.
   /* Additional Labels Format */
     /* START  LINE :9025  標簽額外格式[Label Format]  */
     V9025L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9025           as char format "x(50)".
        define variable PV9025          as char format "x(50)".
        define variable L90251          as char format "x(40)".
        define variable L90252          as char format "x(40)".
        define variable L90253          as char format "x(40)".
        define variable L90254          as char format "x(40)".
        define variable L90255          as char format "x(40)".
        define variable L90256          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V9025 = V1120.
        V9025 = ENTRY(1,V9025,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9025 = ENTRY(1,V9025,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V9025L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V9025L .
        /* --CYCLE TIME SKIP -- END  */

                display "[Auto Label]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9025 no-box.

                /* LABEL 1 - START */ 
                L90251 = " " .
                display L90251          format "x(40)" skip with fram F9025 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L90252 = "" . 
                display L90252          format "x(40)" skip with fram F9025 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L90253 = "" . 
                display L90253          format "x(40)" skip with fram F9025 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L90254 = "" . 
                display L90254          format "x(40)" skip with fram F9025 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F9025 no-box.
        /* DISPLAY ONLY */
        define variable X9025           as char format "x(40)".
        X9025 = V9025.
        V9025 = "".
        /* DISPLAY ONLY */
        Update V9025
        WITH  fram F9025 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V9025 = X9025.
        /* DISPLAY ONLY */
        LEAVE V9025L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V9025 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9025.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9025.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        /*                Define variable LabelsPath1 as character format "x(100)" init "/mfgpro/rf/labels/".
        Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath" no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath1 = trim ( code_cmmt ).
        If substring(LabelsPath1, length(LabelsPath1), 1) <> "/" Then 
        LabelsPath1 = LabelsPath1 + "/".

	 If search(LabelsPath1 + "lap87" + trim ( V9025 ) ) = ? Then do:
	                 display skip "文件不存在，請重新輸入." @ WMESSAGE NO-LABEL with fram F9025.
                         pause 0 before-hide.
                         Undo, retry.
	 End.
*/
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9025.
        pause 0.
        leave V9025L.
     END.
     PV9025 = V9025.
     /* END    LINE :9025  標簽額外格式[Label Format]  */


   /* Additional Labels Format */
   wtm_fm = V9025.
     /* START  LINE :9030  打印機[PRINTER]  */
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
        Find first upd_det where upd_nbr = "LAP87" and upd_select = 99 no-lock no-error.
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
                display "[Auto Label]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9030 no-box.

                /* LABEL 1 - START */ 
                L90301 = "打印機?" .
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
                display "輸入或按E退出 "      format "x(40)" skip
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
                              PRD_DEV >=  INPUT V9030
                               no-lock no-error.
                  ELSE find next PRD_DET where 
                               no-lock no-error.
                  IF AVAILABLE PRD_DET then display skip 
            PRD_DEV @ V9030 PRD_DESC @ WMESSAGE NO-LABEL with fram F9030.
                  else   display skip "" @ WMESSAGE with fram F9030.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(PRD_DET) = ? THEN find first PRD_DET where 
            PRD_DEV <=  INPUT V9030
                               no-lock no-error.
                  ELSE find prev PRD_DET where 
                               no-lock no-error.
                  IF AVAILABLE PRD_DET then display skip 
            PRD_DEV @ V9030 PRD_DESC @ WMESSAGE NO-LABEL with fram F9030.
                  else   display skip "" @ WMESSAGE with fram F9030.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V9030 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9030.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9030.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first PRD_DET where PRD_DEV = V9030  no-lock no-error.
        IF NOT AVAILABLE PRD_DET then do:
                display skip "Printer Error " @ WMESSAGE NO-LABEL with fram F9030.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9030.
        pause 0.
        leave V9030L.
     END.
     PV9030 = V9030.
     /* END    LINE :9030  打印機[PRINTER]  */


   /* Additional Labels Format */
     Define variable ts9030 AS CHARACTER FORMAT "x(100)".
     Define variable av9030 AS CHARACTER FORMAT "x(100)".
     PROCEDURE lap879030l.
        /* Define Labels Path  Start */
        Define variable LabelsPath as character format "x(100)" init "/mfgpro/rf/labels/".
        Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath"no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath = trim ( code_cmmt ).
        If substring(LabelsPath, length(LabelsPath), 1) <> "/" Then 
        LabelsPath = LabelsPath + "/".
        /* Define Labels Path  END */
     INPUT FROM VALUE(LabelsPath + "lap87" + trim ( wtm_fm ) ).
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
     output to value( trim(wsection) + ".l") .
     Do While True:
              IMPORT UNFORMATTED ts9030.
       find first pt_mstr where pt_part = V1104  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9030 = string ( pt_net_wt ) + trim ( pt_net_wt_um ).
       IF INDEX(ts9030,"&N") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "&N") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"&N") + length("&N"), LENGTH(ts9030) - ( index(ts9030 ,"&N" ) + length("&N") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1104  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9030 = string ( pt_ship_wt ) + trim ( pt_ship_wt_um ).
       IF INDEX(ts9030,"&G") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "&G") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"&G") + length("&G"), LENGTH(ts9030) - ( index(ts9030 ,"&G" ) + length("&G") - 1 ) ).
       END.
        av9030 = trim (V1104).
       IF INDEX(ts9030,"&B") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "&B") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"&B") + length("&B"), LENGTH(ts9030) - ( index(ts9030 ,"&B" ) + length("&B") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1104  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9030 = trim(pt_desc1).
       IF INDEX(ts9030,"$E") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$E") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$E") + length("$E"), LENGTH(ts9030) - ( index(ts9030 ,"$E" ) + length("$E") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1104  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9030 = trim(pt_um).
       IF INDEX(ts9030,"$U") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$U") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$U") + length("$U"), LENGTH(ts9030) - ( index(ts9030 ,"$U" ) + length("$U") - 1 ) ).
       END.
        av9030 = trim(V1111).
       IF INDEX(ts9030,"$X") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$X") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$X") + length("$X"), LENGTH(ts9030) - ( index(ts9030 ,"$X" ) + length("$X") - 1 ) ).
       END.
        av9030 = trim(V1115).
       IF INDEX(ts9030,"$C") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$C") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$C") + length("$C"), LENGTH(ts9030) - ( index(ts9030 ,"$C" ) + length("$C") - 1 ) ).
       END.
        av9030 = trim(V1122).
       IF INDEX(ts9030,"$S") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$S") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$S") + length("$S"), LENGTH(ts9030) - ( index(ts9030 ,"$S" ) + length("$S") - 1 ) ).
       END.
        av9030 = trim(V1124).
       IF INDEX(ts9030,"$D") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$D") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$D") + length("$D"), LENGTH(ts9030) - ( index(ts9030 ,"$D" ) + length("$D") - 1 ) ).
       END.
        av9030 = V1104.
       IF INDEX(ts9030,"$K") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$K") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$K") + length("$K"), LENGTH(ts9030) - ( index(ts9030 ,"$K" ) + length("$K") - 1 ) ).
       END.
        av9030 = V1104 + "@" + V1335.
       IF INDEX(ts9030,"$T") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$T") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$T") + length("$T"), LENGTH(ts9030) - ( index(ts9030 ,"$T" ) + length("$T") - 1 ) ).
       END.
        av9030 = V1106.
       IF INDEX(ts9030,"$O") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$O") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$O") + length("$O"), LENGTH(ts9030) - ( index(ts9030 ,"$O" ) + length("$O") - 1 ) ).
       END.
        av9030 = V1108.
       IF INDEX(ts9030,"$P") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$P") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$P") + length("$P"), LENGTH(ts9030) - ( index(ts9030 ,"$P" ) + length("$P") - 1 ) ).
       END.
        av9030 = V1112.
       IF INDEX(ts9030,"$L") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$L") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$L") + length("$L"), LENGTH(ts9030) - ( index(ts9030 ,"$L" ) + length("$L") - 1 ) ).
       END.
        av9030 = V1114.
       IF INDEX(ts9030,"$V") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$V") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$V") + length("$V"), LENGTH(ts9030) - ( index(ts9030 ,"$V" ) + length("$V") - 1 ) ).
       END.
        av9030 = V1117.
       IF INDEX(ts9030,"$A") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$A") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$A") + length("$A"), LENGTH(ts9030) - ( index(ts9030 ,"$A" ) + length("$A") - 1 ) ).
       END.
        av9030 = V9010.
       IF INDEX(ts9030,"$Q") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$Q") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$Q") + length("$Q"), LENGTH(ts9030) - ( index(ts9030 ,"$Q" ) + length("$Q") - 1 ) ).
       END.
       put unformatted ts9030 skip.
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.
     unix silent value ("chmod 777  " + trim(wsection) + ".l").
     END PROCEDURE.
     run lap879030l.
     do i = 1 to integer(wtm_num):
       find first PRD_DET where PRD_DEV = V9030 no-lock no-error.
       IF AVAILABLE PRD_DET then do:
         unix silent value (trim(prd_path) + " " + trim(wsection) + ".l").
         unix silent value ( "clear").
       end.
     End.
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1100LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :9030    */
   END.
   pause 0 before-hide.
end.
