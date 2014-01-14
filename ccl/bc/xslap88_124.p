/* Generate By Barcode Generator , Copyright by Softspeed - Build By Sam Song  */ 
/* SO-WO LABLE */
/* Generate date / time  10/19/07 11:08:21 */
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
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xslap88wtimeout" no-lock no-error. /*  Timeout - Program Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

mainloop:
REPEAT:
     /* CYCLE COUNTER -SECTION ID -- START*/
      sectionid = sectionid + 1 .
     /* SECTION ID -- END  */

     /* START  LINE :1002  地点[SITE]  */
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
                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 no-box.

                /* LABEL 1 - START */ 
                L10021 = "地点设定有误" .
                display L10021          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L10022 = "1.没有设定默认地点" .
                display L10022          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L10023 = "2.权限设定有误" .
                display L10023          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L10024 = "请查核" .
                display L10024          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
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
     /* END    LINE :1002  地点[SITE]  */


   /* Additional Labels Format */
   /* Internal Cycle Input :1100    */
   V1100LMAINLOOP:
   REPEAT:
     /* START  LINE :1100  工单号码[WO]  */
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
                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1100 no-box.

                /* LABEL 1 - START */ 
                L11001 = "工单号码?" .
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
                display "输入或按E退出 "      format "x(40)" skip
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
        find first WO_MSTR where WO_NBR = V1100 AND INDEX("AR",WO_STATUS) <> 0 AND WO_SITE = V1002  NO-ERROR NO-WAIT.
        IF NOT AVAILABLE WO_MSTR then do:
                display skip "无效或被锁!" @ WMESSAGE NO-LABEL with fram F1100.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        leave V1100L.
     END.
     PV1100 = V1100.
     /* END    LINE :1100  工单号码[WO]  */


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
                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1103 no-box.

                /* LABEL 1 - START */ 
                L11031 = "工单ID#" .
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
                L11033 = "工单:" + V1100 .
                display L11033          format "x(40)" skip with fram F1103 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11034 = "" . 
                display L11034          format "x(40)" skip with fram F1103 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
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
                display skip "无效或被锁!" @ WMESSAGE NO-LABEL with fram F1103.
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
     /* START  LINE :1104  销售订单[SalesOrder]  */
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
        find first wo_mstr where wo_nbr=V1100 and wo_site=V1002 and wo_lot=V1103 no-lock no-error.
If avail wo_mstr then
V1104 = if substring( wo_so_job,1,2 ) = "RA" then substring(wo_so_job,1,8) else substring(wo_so_job,1,7).
If V1104<>"" then
        V1104 = V1104.
        V1104 = ENTRY(1,V1104,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1104 = ENTRY(1,V1104,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1104 no-box.

                /* LABEL 1 - START */ 
                L11041 = "销售订单?" .
                display L11041          format "x(40)" skip with fram F1104 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11042 = "工单:" + V1100 + "/" + V1103 .
                display L11042          format "x(40)" skip with fram F1104 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11043 = "*SA-正式(7位)*" .
                display L11043          format "x(40)" skip with fram F1104 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11044 = "*RA-返工(8位)*" .
                display L11044          format "x(40)" skip with fram F1104 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
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
        find first so_mstr where so_nbr=V1104 and so_site=V1002 no-lock no-error.
If not AVAILABLE ( so_mstr )  then do:
 display skip "订单不存在" @ WMESSAGE NO-LABEL with fram F1104.
                pause 0 before-hide.
                Undo, retry.

End.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1104.
        pause 0.
        leave V1104L.
     END.
     PV1104 = V1104.
     /* END    LINE :1104  销售订单[SalesOrder]  */


   /* Additional Labels Format */
     /* START  LINE :1105  PKLIST[PACKING List]  */
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
        def var kkb as integer.
Find first wo_mstr where wo_nbr=V1100 and wo_site=V1002 and wo_lot=V1103 no-lock no-error.
If avail wo_mstr then do:
  do kkb=1 to length(wo_rmks):
  if substring(wo_rmks,kkb,1)="/" then assign V1105=substring(wo_rmks,1,kkb - 1).
End.
End.
Else V1105="".
        V1105 = V1105.
        V1105 = ENTRY(1,V1105,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1105 = ENTRY(1,V1105,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1105 no-box.

                /* LABEL 1 - START */ 
                L11051 = "PACKING LIST:"  + V1105.
                display L11051          format "x(40)" skip with fram F1105 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11052 = "工单:" + V1100 + "/" + V1103 .
                display L11052          format "x(40)" skip with fram F1105 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11053 = "" . 
                display L11053          format "x(40)" skip with fram F1105 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11054 = "" . 
                display L11054          format "x(40)" skip with fram F1105 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
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
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1105.
        pause 0.
        leave V1105L.
     END.
     PV1105 = V1105.
     /* END    LINE :1105  PKLIST[PACKING List]  */


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
        def var allstr as char.
Allstr="1".
find first so_mstr where so_nbr=V1104 no-lock no-error.
If avail so_mstr and so_rmks<>"" then do:
  do kkb=1 to length(so_rmks):
  if substring(so_rmks,kkb,1)="/" then do:
assign V1106=substring(so_rmks,1,kkb - 1).
Allstr="2".
End.
End.
if allstr="1" then V1106=so_rmks.
End.
Else V1106="".
        V1106 = V1106.
        V1106 = ENTRY(1,V1106,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1106 = ENTRY(1,V1106,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1106 no-box.

                /* LABEL 1 - START */ 
                L11061 = "Cust PO?" .
                display L11061          format "x(40)" skip with fram F1106 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11062 = "工单:" + V1100 + "/" + V1103 .
                display L11062          format "x(40)" skip with fram F1106 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11063 = "订单号:" + V1104 .
                display L11063          format "x(40)" skip with fram F1106 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11064 = "PK List:" + V1105 .
                display L11064          format "x(40)" skip with fram F1106 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
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
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1106.
        pause 0.
        leave V1106L.
     END.
     PV1106 = V1106.
     /* END    LINE :1106  PO[CustPO]  */


   /* Additional Labels Format */
     /* START  LINE :1108  Coundry of origin  */
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
        V1108 = "CHN".
        V1108 = ENTRY(1,V1108,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V1108 = PV1108 .
        V1108 = ENTRY(1,V1108,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1108 no-box.

                /* LABEL 1 - START */ 
                L11081 = "Coundry of origin?" .
                display L11081          format "x(40)" skip with fram F1108 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11082 = "订单号:" + V1104 .
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
                display "输入或按E退出 "      format "x(40)" skip
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
     /* END    LINE :1108  Coundry of origin  */


   /* Additional Labels Format */
     /* START  LINE :1109  suppliers warehouse  */
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
        V1109 = " ".
        V1109 = ENTRY(1,V1109,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V1109 = PV1109 .
        V1109 = ENTRY(1,V1109,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1109 no-box.

                /* LABEL 1 - START */ 
                L11091 = "suppliers warehouse?" .
                display L11091          format "x(40)" skip with fram F1109 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11092 = "订单号:" + V1104 .
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
                display "输入或按E退出 "      format "x(40)" skip
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
     /* END    LINE :1109  suppliers warehouse  */


   /* Additional Labels Format */
     /* START  LINE :1110  suppliers name  */
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
        V1110 = "Chiaphua Components Limited".
        V1110 = ENTRY(1,V1110,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V1110 = PV1110 .
        V1110 = ENTRY(1,V1110,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1110 no-box.

                /* LABEL 1 - START */ 
                L11101 = "suppliers name?" .
                display L11101          format "x(40)" skip with fram F1110 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11102 = "订单号:" + V1104 .
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
                display "输入或按E退出 "      format "x(40)" skip
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
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1110.
        pause 0.
        leave V1110L.
     END.
     PV1110 = V1110.
     /* END    LINE :1110  suppliers name  */


   /* Additional Labels Format */
     /* START  LINE :1112  订单项次  */
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
        V1112 = " ".
        V1112 = ENTRY(1,V1112,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1112 = ENTRY(1,V1112,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1112L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1112L .
        /* --CYCLE TIME SKIP -- END  */

                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1112 no-box.

                /* LABEL 1 - START */ 
                L11121 = "订单项次?" .
                display L11121          format "x(40)" skip with fram F1112 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11122 = "工单:" + V1100 + "/" + V1103 .
                display L11122          format "x(40)" skip with fram F1112 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11123 = "订单号:" + V1104 .
                display L11123          format "x(40)" skip with fram F1112 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11124 = "客PO号:" + V1106 .
                display L11124          format "x(40)" skip with fram F1112 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
        skip with fram F1112 no-box.
        /* DISPLAY ONLY */
        define variable X1112           as char format "x(40)".
        X1112 = V1112.
        V1112 = "".
        /* DISPLAY ONLY */
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
        V1112 = X1112.
        /* DISPLAY ONLY */
        LEAVE V1112L.
        /* DISPLAY ONLY */

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
     /* END    LINE :1112  订单项次  */


   /* Additional Labels Format */
     /* START  LINE :1114  料品  */
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
        find first wo_mstr where wo_site=V1002 and wo_nbr=V1100 and wo_lot=V1103 no-lock no-error.
If avail wo_mstr then
        V1114 = wo_part.
        V1114 = ENTRY(1,V1114,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1114 = ENTRY(1,V1114,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1114 no-box.

                /* LABEL 1 - START */ 
                L11141 = "料品?" .
                display L11141          format "x(40)" skip with fram F1114 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11142 = "工单:" + V1100 + "/" + V1103 .
                display L11142          format "x(40)" skip with fram F1114 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11143 = "订单号:" + V1104 .
                display L11143          format "x(40)" skip with fram F1114 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11144 = "客PO号:" + V1106 .
                display L11144          format "x(40)" skip with fram F1114 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
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
        find first pt_mstr where pt_part=V1114 no-lock no-error.
If not avail pt_mstr then do :
display skip "料品不存在" @ WMESSAGE NO-LABEL with fram F1114.
                pause 0 before-hide.
                Undo, retry.

End.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1114.
        pause 0.
        leave V1114L.
     END.
     PV1114 = V1114.
     /* END    LINE :1114  料品  */


   /* Additional Labels Format */
     /* START  LINE :1116  客户[CUST]  */
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
        find first so_mstr where so_nbr=V1104 no-lock no-error.
If  AVAILABLE ( so_mstr )  then
        V1116 = so_cust.
        V1116 = ENTRY(1,V1116,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1116 = ENTRY(1,V1116,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        if 1=1 then
        leave V1116L.
        /* LOGICAL SKIP END */
                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1116 no-box.

                /* LABEL 1 - START */ 
                L11161 = "谛誧?" .
                display L11161          format "x(40)" skip with fram F1116 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11162 = "" . 
                display L11162          format "x(40)" skip with fram F1116 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11163 = "" . 
                display L11163          format "x(40)" skip with fram F1116 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11164 = "" . 
                display L11164          format "x(40)" skip with fram F1116 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
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
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1116.
        pause 0.
        leave V1116L.
     END.
     PV1116 = V1116.
     /* END    LINE :1116  客户[CUST]  */


   /* Additional Labels Format */
     /* START  LINE :1118  客户料号[CUST PART]  */
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
        find first sod_det where sod_nbr=V1104 and sod_part=V1114 AND sod_site=V1002 no-lock no-error.
If  AVAILABLE ( sod_det ) and sod_custpart<>"" then  assign V1118=SOD_custpart.
Else do:
find first cp_mstr where cp_cust=V1116 and cp_part=V1114 no-lock no-error.
If  AVAILABLE ( cp_mstr )  then assign V1118=cp_cust_part.
Else V1118="".
End.
        V1118 = V1118.
        V1118 = ENTRY(1,V1118,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1118 = ENTRY(1,V1118,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1118 no-box.

                /* LABEL 1 - START */ 
                L11181 = "客户料号?" .
                display L11181          format "x(40)" skip with fram F1118 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11182 = "工单:" + V1100 + "/" + V1103 .
                display L11182          format "x(40)" skip with fram F1118 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11183 = "订单号:" + V1104 .
                display L11183          format "x(40)" skip with fram F1118 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11184 = "客PO号:" + V1106 .
                display L11184          format "x(40)" skip with fram F1118 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
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
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1118.
        pause 0.
        leave V1118L.
     END.
     PV1118 = V1118.
     /* END    LINE :1118  客户料号[CUST PART]  */


   /* Additional Labels Format */
     /* START  LINE :1120  批号[Part Lot]  */
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
        V1120 = " ".
        V1120 = ENTRY(1,V1120,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1120 = ENTRY(1,V1120,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1120L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1120L .
        /* --CYCLE TIME SKIP -- END  */

                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1120 no-box.

                /* LABEL 1 - START */ 
                L11201 = "批号?" .
                display L11201          format "x(40)" skip with fram F1120 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11202 = "订单号:" + V1104 .
                display L11202          format "x(40)" skip with fram F1120 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11203 = "客户料号:" + V1118 .
                display L11203          format "x(40)" skip with fram F1120 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11204 = "客PO号:" + V1106 .
                display L11204          format "x(40)" skip with fram F1120 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
        skip with fram F1120 no-box.
        /* DISPLAY ONLY */
        define variable X1120           as char format "x(40)".
        X1120 = V1120.
        V1120 = "".
        /* DISPLAY ONLY */
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
        V1120 = X1120.
        /* DISPLAY ONLY */
        LEAVE V1120L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1120 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1120.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1120.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1120.
        pause 0.
        leave V1120L.
     END.
     PV1120 = V1120.
     /* END    LINE :1120  批号[Part Lot]  */


   /* Additional Labels Format */
     /* START  LINE :1121  版本[Ver]  */
     V1121L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1121           as char format "x(50)".
        define variable PV1121          as char format "x(50)".
        define variable L11211          as char format "x(40)".
        define variable L11212          as char format "x(40)".
        define variable L11213          as char format "x(40)".
        define variable L11214          as char format "x(40)".
        define variable L11215          as char format "x(40)".
        define variable L11216          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1121 = " ".
        V1121 = ENTRY(1,V1121,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1121 = ENTRY(1,V1121,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1121 no-box.

                /* LABEL 1 - START */ 
                L11211 = "版本? " + V1100 .
                display L11211          format "x(40)" skip with fram F1121 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11212 = "订单号:" + V1104 .
                display L11212          format "x(40)" skip with fram F1121 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11213 = "客户料号:" + V1118 .
                display L11213          format "x(40)" skip with fram F1121 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11214 = "客PO号:" + V1106 .
                display L11214          format "x(40)" skip with fram F1121 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
        skip with fram F1121 no-box.
        Update V1121
        WITH  fram F1121 NO-LABEL
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
        IF V1121 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1121.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1121.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        /* If length(trim(V1114))=0 then do :
display skip "版本不能为空" @ WMESSAGE NO-LABEL with fram F1114.
                pause 0 before-hide.
                Undo, retry.

End. */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1121.
        pause 0.
        leave V1121L.
     END.
     PV1121 = V1121.
     /* END    LINE :1121  版本[Ver]  */


   /* Additional Labels Format */
     /* START  LINE :1122  PO项次  */
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
        /*def var wormks as char.
Def var kka as integer.
Wormks="". 
V1122="".
Find first wo_mstr where wo_nbr=V1100 and wo_lot=V1103 no-lock no-error.
If avail wo_mstr then 
assign wormks=wo_rmks.
Else wormks="".
Do kka =1 to length(wormks):
  if substring(wo_rmks,kka,1)="/" then V1122=substring(wo_rmks,kka + 1).
End.*/
find first so_mstr where so_nbr=V1104 no-lock no-error.
If avail so_mstr and so_rmks<>"" then do:
  do kkb=1 to length(so_rmks):
  if substring(so_rmks,kkb,1)="/" then assign V1122=substring(so_rmks,kkb + 1).
End.
End.
Else V1122="".
        V1122 = V1122.
        V1122 = ENTRY(1,V1122,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1122 = ENTRY(1,V1122,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1122 no-box.

                /* LABEL 1 - START */ 
                L11221 = "PO项次?" .
                display L11221          format "x(40)" skip with fram F1122 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11222 = "订单号:" + V1104 .
                display L11222          format "x(40)" skip with fram F1122 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11223 = "" . 
                display L11223          format "x(40)" skip with fram F1122 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11224 = "" . 
                display L11224          format "x(40)" skip with fram F1122 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
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
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1122.
        pause 0.
        leave V1122L.
     END.
     PV1122 = V1122.
     /* END    LINE :1122  PO项次  */


   /* Additional Labels Format */
     /* START  LINE :1123  ship_wt  */
     V1123L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1123           as char format "x(50)".
        define variable PV1123          as char format "x(50)".
        define variable L11231          as char format "x(40)".
        define variable L11232          as char format "x(40)".
        define variable L11233          as char format "x(40)".
        define variable L11234          as char format "x(40)".
        define variable L11235          as char format "x(40)".
        define variable L11236          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first pt_mstr where pt_part=V1114 no-lock no-error.
If avail pt_mstr then
        V1123 = string(pt_ship_wt).
        V1123 = ENTRY(1,V1123,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1123 = ENTRY(1,V1123,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1123 no-box.

                /* LABEL 1 - START */ 
                L11231 = "Ship Weight?" .
                display L11231          format "x(40)" skip with fram F1123 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11232 = "订单号:" + V1104 .
                display L11232          format "x(40)" skip with fram F1123 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11233 = "客户料号:" + V1118 .
                display L11233          format "x(40)" skip with fram F1123 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11234 = "客PO号:" + V1106 .
                display L11234          format "x(40)" skip with fram F1123 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
        skip with fram F1123 no-box.
        Update V1123
        WITH  fram F1123 NO-LABEL
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
        IF V1123 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1123.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1123.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1123.
        pause 0.
        leave V1123L.
     END.
     PV1123 = V1123.
     /* END    LINE :1123  ship_wt  */


   /* Additional Labels Format */
     /* START  LINE :1124  生产日期[MF Date]  */
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
        define variable D1124           as date .
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1124 = string(today).
        D1124 = Date ( V1124).
        V1124 = ENTRY(1,V1124,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V1124 = PV1124 .
         If sectionid > 1 Then 
        D1124 = Date ( V1124).
        V1124 = ENTRY(1,V1124,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1124 no-box.

                /* LABEL 1 - START */ 
                L11241 = "生产日期?" .
                display L11241          format "x(40)" skip with fram F1124 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11242 = "工单:" + V1100 .
                display L11242          format "x(40)" skip with fram F1124 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11243 = "订单号:" + V1104 .
                display L11243          format "x(40)" skip with fram F1124 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11244 = "客PO号:" + V1106 .
                display L11244          format "x(40)" skip with fram F1124 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
        skip with fram F1124 no-box.
        Update D1124
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
        V1124 = string ( D1124).
        display  skip WMESSAGE NO-LABEL with fram F1124.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1124.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1124.
        pause 0.
        leave V1124L.
     END.
     PV1124 = V1124.
     /* END    LINE :1124  生产日期[MF Date]  */


   /* Additional Labels Format */
     /* START  LINE :1126  生产线[prod line]  */
     V1126L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1126           as char format "x(50)".
        define variable PV1126          as char format "x(50)".
        define variable L11261          as char format "x(40)".
        define variable L11262          as char format "x(40)".
        define variable L11263          as char format "x(40)".
        define variable L11264          as char format "x(40)".
        define variable L11265          as char format "x(40)".
        define variable L11266          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1126 = " ".
        V1126 = ENTRY(1,V1126,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1126 = ENTRY(1,V1126,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1126 no-box.

                /* LABEL 1 - START */ 
                L11261 = "生产线?" .
                display L11261          format "x(40)" skip with fram F1126 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11262 = "工单:" + V1100 + "/" + V1103 .
                display L11262          format "x(40)" skip with fram F1126 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11263 = "订单号:" + V1104 .
                display L11263          format "x(40)" skip with fram F1126 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11264 = "料品:" + V1114 .
                display L11264          format "x(40)" skip with fram F1126 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
        skip with fram F1126 no-box.
        Update V1126
        WITH  fram F1126 NO-LABEL
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
        IF V1126 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1126.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1126.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        If length(trim(V1126))>2 then do :
display skip "长度不能超过2位" @ WMESSAGE NO-LABEL with fram F1126.
                pause 0 before-hide.
                Undo, retry.

End.
        IF not V1116<>"" THEN DO:
                display skip "生产线不能为空" @ WMESSAGE NO-LABEL with fram F1126.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1126.
        pause 0.
        leave V1126L.
     END.
     PV1126 = V1126.
     /* END    LINE :1126  生产线[prod line]  */


   /* Additional Labels Format */
     /* START  LINE :1128  班次[shift]  */
     V1128L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1128           as char format "x(50)".
        define variable PV1128          as char format "x(50)".
        define variable L11281          as char format "x(40)".
        define variable L11282          as char format "x(40)".
        define variable L11283          as char format "x(40)".
        define variable L11284          as char format "x(40)".
        define variable L11285          as char format "x(40)".
        define variable L11286          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1128 = "D".
        V1128 = ENTRY(1,V1128,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1128 = ENTRY(1,V1128,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1128 no-box.

                /* LABEL 1 - START */ 
                L11281 = "班次?" .
                display L11281          format "x(40)" skip with fram F1128 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11282 = "工单:" + V1100 + "/" + V1103 .
                display L11282          format "x(40)" skip with fram F1128 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11283 = "订单号:" + V1104 .
                display L11283          format "x(40)" skip with fram F1128 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11284 = "D-日班,W-夜班" .
                display L11284          format "x(40)" skip with fram F1128 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
        skip with fram F1128 no-box.
        Update V1128
        WITH  fram F1128 NO-LABEL
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
        IF V1128 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1128.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1128.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not (V1128="d" or V1128="w") THEN DO:
                display skip "班次只能是D或W" @ WMESSAGE NO-LABEL with fram F1128.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1128.
        pause 0.
        leave V1128L.
     END.
     PV1128 = V1128.
     /* END    LINE :1128  班次[shift]  */


   /* Additional Labels Format */
     /* START  LINE :1129  OK to print label  */
     V1129L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1129           as char format "x(50)".
        define variable PV1129          as char format "x(50)".
        define variable L11291          as char format "x(40)".
        define variable L11292          as char format "x(40)".
        define variable L11293          as char format "x(40)".
        define variable L11294          as char format "x(40)".
        define variable L11295          as char format "x(40)".
        define variable L11296          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1129 = "Y".
        V1129 = ENTRY(1,V1129,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1129 = ENTRY(1,V1129,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF 1 = 2 THEN
        leave V1129L.
        /* LOGICAL SKIP END */
                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1129 no-box.

                /* LABEL 1 - START */ 
                L11291 = "是否打印标签?" .
                display L11291          format "x(40)" skip with fram F1129 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11292 = "" . 
                display L11292          format "x(40)" skip with fram F1129 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11293 = "" . 
                display L11293          format "x(40)" skip with fram F1129 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11294 = "" . 
                display L11294          format "x(40)" skip with fram F1129 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
        skip with fram F1129 no-box.
        Update V1129
        WITH  fram F1129 NO-LABEL
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
        IF V1129 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1129.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1129.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not trim(V1129) = "Y" THEN DO:
                display skip "Error , Retry " @ WMESSAGE NO-LABEL with fram F1129.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1129.
        pause 0.
        leave V1129L.
     END.
     PV1129 = V1129.
     /* END    LINE :1129  OK to print label  */


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1100LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1129    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1130    */
   V1130LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1130    */
   IF NOT (V1129="Y" ) THEN LEAVE V1130LMAINLOOP.
     /* START  LINE :1130  标签类型[label type]  */
     V1130L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1130           as char format "x(50)".
        define variable PV1130          as char format "x(50)".
        define variable L11301          as char format "x(40)".
        define variable L11302          as char format "x(40)".
        define variable L11303          as char format "x(40)".
        define variable L11304          as char format "x(40)".
        define variable L11305          as char format "x(40)".
        define variable L11306          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1130 = "n".
        V1130 = ENTRY(1,V1130,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1130 = ENTRY(1,V1130,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1130 no-box.

                /* LABEL 1 - START */ 
                L11301 = "标签类型?" .
                display L11301          format "x(40)" skip with fram F1130 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11302 = "工单:" + V1100 + "/" + V1103 .
                display L11302          format "x(40)" skip with fram F1130 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11303 = "订单号:" + V1104 .
                display L11303          format "x(40)" skip with fram F1130 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11304 = "n-内箱标签w-外箱标签" .
                display L11304          format "x(40)" skip with fram F1130 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
        skip with fram F1130 no-box.
        Update V1130
        WITH  fram F1130 NO-LABEL
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
        IF V1130 = "e" THEN  V1129= "n".
        IF V1130 = "e" THEN  LEAVE V1130LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1130.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1130.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         Define variable LabelsPath as character format "x(100)" init "/app/mfgpro/bc/labels/".
        Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath" no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath = trim ( code_cmmt ).
        If substring(LabelsPath, length(LabelsPath), 1) <> "/" Then 
        LabelsPath = LabelsPath + "/".

	 If search(LabelsPath + "lap88" + trim ( V1130 ) ) = ? Then do:
	                 display skip "文件不存在,请重新输入." @ WMESSAGE NO-LABEL with fram F1130.
                         pause 0 before-hide.
                         Undo, retry.
	 End.
Wtm_fm = V1130.
        IF not (V1130="n" or V1130="w") THEN DO:
                display skip "Input Error" @ WMESSAGE NO-LABEL with fram F1130.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1130.
        pause 0.
        leave V1130L.
     END.
     PV1130 = V1130.
     /* END    LINE :1130  标签类型[label type]  */


   /* Additional Labels Format */
     /* START  LINE :1133  SHIPTO  */
     V1133L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1133           as char format "x(50)".
        define variable PV1133          as char format "x(50)".
        define variable L11331          as char format "x(40)".
        define variable L11332          as char format "x(40)".
        define variable L11333          as char format "x(40)".
        define variable L11334          as char format "x(40)".
        define variable L11335          as char format "x(40)".
        define variable L11336          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first so_mstr where so_nbr=V1104 no-lock no-error.
If avail so_mstr then
        V1133 = so_ship.
        V1133 = ENTRY(1,V1133,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1133 = ENTRY(1,V1133,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        if 1=1 then
        leave V1133L.
        /* LOGICAL SKIP END */
                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1133 no-box.

                /* LABEL 1 - START */ 
                L11331 = "SHIP TO?" .
                display L11331          format "x(40)" skip with fram F1133 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11332 = "" . 
                display L11332          format "x(40)" skip with fram F1133 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11333 = "" . 
                display L11333          format "x(40)" skip with fram F1133 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11334 = "" . 
                display L11334          format "x(40)" skip with fram F1133 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
        skip with fram F1133 no-box.
        Update V1133
        WITH  fram F1133 NO-LABEL
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
        IF V1133 = "e" THEN  LEAVE V1130LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1133.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1133.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1133.
        pause 0.
        leave V1133L.
     END.
     PV1133 = V1133.
     /* END    LINE :1133  SHIPTO  */


   /* Additional Labels Format */
     /* START  LINE :1134  Serial#[Serial#]  */
     V1134L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1134           as char format "x(50)".
        define variable PV1134          as char format "x(50)".
        define variable L11341          as char format "x(40)".
        define variable L11342          as char format "x(40)".
        define variable L11343          as char format "x(40)".
        define variable L11344          as char format "x(40)".
        define variable L11345          as char format "x(40)".
        define variable L11346          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1134=if length(string(year(Date(V1124)))) > 3 then substring(string(year(Date(V1124))),3) else string(year(Date(V1124))) .
V1134=V1134 + 
entry(month(date(V1124)),"A,B,C,D,E,F,G,H,J,K,L,M") + 
if day(date(V1124))<10 then "0" + string(day(date(V1124))) else string(day(date(V1124)))
.
If trim(V1128)="d" then
V1134=V1134 + "A".
If trim(V1128)="w" then
V1134=V1134 + "B".

If V1134<>"" then
        V1134 = V1134.
        V1134 = ENTRY(1,V1134,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1134 = ENTRY(1,V1134,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        if V1130="w" then
        leave V1134L.
        /* LOGICAL SKIP END */
                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1134 no-box.

                /* LABEL 1 - START */ 
                L11341 = "Serial#?" .
                display L11341          format "x(40)" skip with fram F1134 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11342 = "工单:" + V1100 + "/" + V1103 .
                display L11342          format "x(40)" skip with fram F1134 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11343 = "订单号:" + V1105 .
                display L11343          format "x(40)" skip with fram F1134 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11344 = "料号:" + V1104 .
                display L11344          format "x(40)" skip with fram F1134 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
        skip with fram F1134 no-box.
        Update V1134
        WITH  fram F1134 NO-LABEL
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
        IF V1134 = "e" THEN  LEAVE V1130LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1134.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1134.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        if length(trim(V1134))=0 and V1130<>"w"  then do:
display skip "Serial不能为空" @ WMESSAGE NO-LABEL with fram F1134.
                pause 0 before-hide.
                Undo, retry.

End.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1134.
        pause 0.
        leave V1134L.
     END.
     PV1134 = V1134.
     /* END    LINE :1134  Serial#[Serial#]  */


   /* Additional Labels Format */
     /* START  LINE :1135  suppliers warehouseA  */
     V1135L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1135           as char format "x(50)".
        define variable PV1135          as char format "x(50)".
        define variable L11351          as char format "x(40)".
        define variable L11352          as char format "x(40)".
        define variable L11353          as char format "x(40)".
        define variable L11354          as char format "x(40)".
        define variable L11355          as char format "x(40)".
        define variable L11356          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        if length(V1109) >20 then do:
  if length(V1109)>40 then assign V1135=substring(V1109,21,20).
Else assign V1135=substring(V1109,21).
end.
Else V1135="".
        V1135 = V1135.
        V1135 = ENTRY(1,V1135,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1135 = ENTRY(1,V1135,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        if 1= 1 then
        leave V1135L.
        /* LOGICAL SKIP END */
                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1135 no-box.

                /* LABEL 1 - START */ 
                L11351 = "suppliers warehouse?" .
                display L11351          format "x(40)" skip with fram F1135 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11352 = "订单号:" + V1104 .
                display L11352          format "x(40)" skip with fram F1135 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11353 = "" . 
                display L11353          format "x(40)" skip with fram F1135 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11354 = "" . 
                display L11354          format "x(40)" skip with fram F1135 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
        skip with fram F1135 no-box.
        Update V1135
        WITH  fram F1135 NO-LABEL
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
        IF V1135 = "e" THEN  LEAVE V1130LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1135.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1135.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1135.
        pause 0.
        leave V1135L.
     END.
     PV1135 = V1135.
     /* END    LINE :1135  suppliers warehouseA  */


   /* Additional Labels Format */
     /* START  LINE :1136  suppliers warehouseG  */
     V1136L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1136           as char format "x(50)".
        define variable PV1136          as char format "x(50)".
        define variable L11361          as char format "x(40)".
        define variable L11362          as char format "x(40)".
        define variable L11363          as char format "x(40)".
        define variable L11364          as char format "x(40)".
        define variable L11365          as char format "x(40)".
        define variable L11366          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        if length(V1109) >40 then do:
  if length(V1109)>60 then assign V1136=substring(V1109,41,20).
Else assign V1136=substring(V1109,41).
end.
Else V1136="".
        V1136 = V1136.
        V1136 = ENTRY(1,V1136,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1136 = ENTRY(1,V1136,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        if 1=1 then
        leave V1136L.
        /* LOGICAL SKIP END */
                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1136 no-box.

                /* LABEL 1 - START */ 
                L11361 = "suppliers warehouse?" .
                display L11361          format "x(40)" skip with fram F1136 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11362 = "订单号:" + V1104 .
                display L11362          format "x(40)" skip with fram F1136 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11363 = "" . 
                display L11363          format "x(40)" skip with fram F1136 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11364 = "" . 
                display L11364          format "x(40)" skip with fram F1136 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
        skip with fram F1136 no-box.
        Update V1136
        WITH  fram F1136 NO-LABEL
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
        IF V1136 = "e" THEN  LEAVE V1130LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1136.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1136.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1136.
        pause 0.
        leave V1136L.
     END.
     PV1136 = V1136.
     /* END    LINE :1136  suppliers warehouseG  */


   /* Additional Labels Format */
     /* START  LINE :1137  suppliers warehouseB  */
     V1137L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1137           as char format "x(50)".
        define variable PV1137          as char format "x(50)".
        define variable L11371          as char format "x(40)".
        define variable L11372          as char format "x(40)".
        define variable L11373          as char format "x(40)".
        define variable L11374          as char format "x(40)".
        define variable L11375          as char format "x(40)".
        define variable L11376          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        if length(V1109) >20 then V1137=substring(V1109,1,20).
Else V1137=V1109.
        V1137 = V1137.
        V1137 = ENTRY(1,V1137,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1137 = ENTRY(1,V1137,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        if 1= 1 then
        leave V1137L.
        /* LOGICAL SKIP END */
                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1137 no-box.

                /* LABEL 1 - START */ 
                L11371 = "suppliers warehouse?" .
                display L11371          format "x(40)" skip with fram F1137 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11372 = "订单号:" + V1104 .
                display L11372          format "x(40)" skip with fram F1137 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11373 = "" . 
                display L11373          format "x(40)" skip with fram F1137 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11374 = "" . 
                display L11374          format "x(40)" skip with fram F1137 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
        skip with fram F1137 no-box.
        Update V1137
        WITH  fram F1137 NO-LABEL
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
        IF V1137 = "e" THEN  LEAVE V1130LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1137.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1137.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1137.
        pause 0.
        leave V1137L.
     END.
     PV1137 = V1137.
     /* END    LINE :1137  suppliers warehouseB  */


   /* Additional Labels Format */
     /* START  LINE :1338  parverdate[Partverdate]  */
     V1338L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1338           as char format "x(50)".
        define variable PV1338          as char format "x(50)".
        define variable L13381          as char format "x(40)".
        define variable L13382          as char format "x(40)".
        define variable L13383          as char format "x(40)".
        define variable L13384          as char format "x(40)".
        define variable L13385          as char format "x(40)".
        define variable L13386          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        {xsweekc88.i}
V1338 = fill( "0" , 4 - length (  trim (V1121) ) ) + trim (V1121) + trim ( WeekResult ) + ( if substring ( trim (V1104) ,1,1) = "R" then "R" else "*" ) + trim(V1126) + trim(V1128).
If V1338<>"" then
        V1338 = V1338.
        V1338 = ENTRY(1,V1338,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1338 = ENTRY(1,V1338,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1338L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1338L .
        /* --CYCLE TIME SKIP -- END  */

                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1338 no-box.

                /* LABEL 1 - START */ 
                L13381 = "parvardate?" .
                display L13381          format "x(40)" skip with fram F1338 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L13382 = "" . 
                display L13382          format "x(40)" skip with fram F1338 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L13383 = "" . 
                display L13383          format "x(40)" skip with fram F1338 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13384 = "" . 
                display L13384          format "x(40)" skip with fram F1338 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
        skip with fram F1338 no-box.
        /* DISPLAY ONLY */
        define variable X1338           as char format "x(40)".
        X1338 = V1338.
        V1338 = "".
        /* DISPLAY ONLY */
        Update V1338
        WITH  fram F1338 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V1338 = X1338.
        /* DISPLAY ONLY */
        LEAVE V1338L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1338 = "e" THEN  LEAVE V1130LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1338.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1338.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1338.
        pause 0.
        leave V1338L.
     END.
     PV1338 = V1338.
     /* END    LINE :1338  parverdate[Partverdate]  */


   /* Additional Labels Format */
     /* START  LINE :9010  条码上的数量[QTY ON LABEL]  */
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
                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9010 no-box.

                /* LABEL 1 - START */ 
                L90101 = "条码上的数量?" .
                display L90101          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L90102 = "订单号:" + trim(V1104) .
                display L90102          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L90103 = "客PO号:" + V1106 .
                display L90103          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L90104 = "客户料号:" + V1118 .
                display L90104          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出 "      format "x(40)" skip
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
        IF V9010 = "e" THEN  LEAVE V1130LMAINLOOP.
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
     /* END    LINE :9010  条码上的数量[QTY ON LABEL]  */


   /* Additional Labels Format */
     /* START  LINE :9020  条码个数[NO OF LABEL]  */
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
                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9020 no-box.

                /* LABEL 1 - START */ 
                L90201 = "条码个数?" .
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
                display "输入或按E退出 "      format "x(40)" skip
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
        IF V9020 = "e" THEN  LEAVE V1130LMAINLOOP.
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
     /* END    LINE :9020  条码个数[NO OF LABEL]  */


   wtm_num = V9020.
   /* Additional Labels Format */
     /* START  LINE :9025  标签额外客式[Label Format]  */
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
        V9025 = V1130.
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

                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9025 no-box.

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
                display "输入或按E退出 "      format "x(40)" skip
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
        IF V9025 = "e" THEN  LEAVE V1130LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9025.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9025.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        /*                Define variable LabelsPath1 as character format "x(100)" init "/app/mfgpro/bc/labels/".
        Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath" no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath1 = trim ( code_cmmt ).
        If substring(LabelsPath1, length(LabelsPath1), 1) <> "/" Then 
        LabelsPath1 = LabelsPath1 + "/".

	 If search(LabelsPath1 + "lap88" + trim ( V9025 ) ) = ? Then do:
	                 display skip "文件不存在,请重新输入." @ WMESSAGE NO-LABEL with fram F9025.
                         pause 0 before-hide.
                         Undo, retry.
	 End.*/
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9025.
        pause 0.
        leave V9025L.
     END.
     PV9025 = V9025.
     /* END    LINE :9025  标签额外客式[Label Format]  */


   /* Additional Labels Format */
   wtm_fm = V9025.
     /* START  LINE :9030  打印机[PRINTER]  */
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
        Find first upd_det where upd_nbr = "LAP88" and upd_select = 99 no-lock no-error.
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
                display "[NEW成品标签打印]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9030 no-box.

                /* LABEL 1 - START */ 
                L90301 = "打印机?" .
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
                display "输入或按E退出 "      format "x(40)" skip
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
        IF V9030 = "e" THEN  LEAVE V1130LMAINLOOP.
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
     /* END    LINE :9030  打印机[PRINTER]  */


   /* Additional Labels Format */
     Define variable ts9030 AS CHARACTER FORMAT "x(100)".
     Define variable av9030 AS CHARACTER FORMAT "x(100)".
     PROCEDURE lap889030l.
        /* Define Labels Path  Start */
        Define variable LabelsPath as character format "x(100)" init "/mfgpro/rf/labels/".
        Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath"no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath = trim ( code_cmmt ).
        If substring(LabelsPath, length(LabelsPath), 1) <> "/" Then 
        LabelsPath = LabelsPath + "/".
        /* Define Labels Path  END */
     INPUT FROM VALUE(LabelsPath + "lap88" + trim ( wtm_fm ) ).
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
     output to value( trim(wsection) + ".l") .
     Do While True:
              IMPORT UNFORMATTED ts9030.
        av9030 = V1105.
       IF INDEX(ts9030,"$K") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$K") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$K") + length("$K"), LENGTH(ts9030) - ( index(ts9030 ,"$K" ) + length("$K") - 1 ) ).
       END.
       find first ad_mstr where ad_addr=V1133 no-lock no-error.
        av9030 = trim(ad_line2).
       IF INDEX(ts9030,"$R") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$R") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$R") + length("$R"), LENGTH(ts9030) - ( index(ts9030 ,"$R" ) + length("$R") - 1 ) ).
       END.
       find first ad_mstr where ad_addr=V1133 no-lock no-error.
        av9030 = trim(ad_line3).
       IF INDEX(ts9030,"$H") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$H") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$H") + length("$H"), LENGTH(ts9030) - ( index(ts9030 ,"$H" ) + length("$H") - 1 ) ).
       END.
        av9030 = trim(V1134).
       IF INDEX(ts9030,"$S") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$S") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$S") + length("$S"), LENGTH(ts9030) - ( index(ts9030 ,"$S" ) + length("$S") - 1 ) ).
       END.
        av9030 = trim (V1135).
       IF INDEX(ts9030,"$A") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$A") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$A") + length("$A"), LENGTH(ts9030) - ( index(ts9030 ,"$A" ) + length("$A") - 1 ) ).
       END.
        av9030 = trim (V1136).
       IF INDEX(ts9030,"$G") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$G") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$G") + length("$G"), LENGTH(ts9030) - ( index(ts9030 ,"$G" ) + length("$G") - 1 ) ).
       END.
        av9030 = V9010.
       IF INDEX(ts9030,"$Q") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$Q") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$Q") + length("$Q"), LENGTH(ts9030) - ( index(ts9030 ,"$Q" ) + length("$Q") - 1 ) ).
       END.
        av9030 = V1121.
       IF INDEX(ts9030,"$V") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$V") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$V") + length("$V"), LENGTH(ts9030) - ( index(ts9030 ,"$V" ) + length("$V") - 1 ) ).
       END.
        av9030 = V1122.
       IF INDEX(ts9030,"$L") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$L") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$L") + length("$L"), LENGTH(ts9030) - ( index(ts9030 ,"$L" ) + length("$L") - 1 ) ).
       END.
       find first ad_mstr where ad_addr=V1133 no-lock no-error.
        av9030 = trim(ad_line1).
       IF INDEX(ts9030,"$M") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$M") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$M") + length("$M"), LENGTH(ts9030) - ( index(ts9030 ,"$M" ) + length("$M") - 1 ) ).
       END.
        av9030 = V1106.
       IF INDEX(ts9030,"$O") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$O") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$O") + length("$O"), LENGTH(ts9030) - ( index(ts9030 ,"$O" ) + length("$O") - 1 ) ).
       END.
        av9030 = V1108.
       IF INDEX(ts9030,"$C") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$C") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$C") + length("$C"), LENGTH(ts9030) - ( index(ts9030 ,"$C" ) + length("$C") - 1 ) ).
       END.
        av9030 = trim(V1124).
       IF INDEX(ts9030,"$D") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$D") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$D") + length("$D"), LENGTH(ts9030) - ( index(ts9030 ,"$D" ) + length("$D") - 1 ) ).
       END.
        av9030 = trim(V1118).
       IF INDEX(ts9030,"$X") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$X") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$X") + length("$X"), LENGTH(ts9030) - ( index(ts9030 ,"$X" ) + length("$X") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1114  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9030 = trim(pt_um).
       IF INDEX(ts9030,"$U") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$U") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$U") + length("$U"), LENGTH(ts9030) - ( index(ts9030 ,"$U" ) + length("$U") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1114  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9030 = trim(pt_desc2).
       IF INDEX(ts9030,"$F") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$F") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$F") + length("$F"), LENGTH(ts9030) - ( index(ts9030 ,"$F" ) + length("$F") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1114  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9030 = trim(pt_desc1).
       IF INDEX(ts9030,"$E") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$E") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$E") + length("$E"), LENGTH(ts9030) - ( index(ts9030 ,"$E" ) + length("$E") - 1 ) ).
       END.
        av9030 = trim (V1137).
       IF INDEX(ts9030,"$B") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$B") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$B") + length("$B"), LENGTH(ts9030) - ( index(ts9030 ,"$B" ) + length("$B") - 1 ) ).
       END.
        av9030 = V1114 + "@" + V1338.
       IF INDEX(ts9030,"$T") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$T") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$T") + length("$T"), LENGTH(ts9030) - ( index(ts9030 ,"$T" ) + length("$T") - 1 ) ).
       END.
        av9030 = V1123.
       IF INDEX(ts9030,"$N") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$N") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$N") + length("$N"), LENGTH(ts9030) - ( index(ts9030 ,"$N" ) + length("$N") - 1 ) ).
       END.
        av9030 = V1114.
       IF INDEX(ts9030,"$P") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$P") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$P") + length("$P"), LENGTH(ts9030) - ( index(ts9030 ,"$P" ) + length("$P") - 1 ) ).
       END.
       put unformatted ts9030 skip.
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.
     unix silent value ("chmod 777  " + trim(wsection) + ".l").
     END PROCEDURE.
     run lap889030l.
     do i = 1 to integer(wtm_num):
       find first PRD_DET where PRD_DEV = V9030 no-lock no-error.
       IF AVAILABLE PRD_DET then do:
         unix silent value (trim(prd_path) + " " + trim(wsection) + ".l").
         unix silent value ( "clear").
       end.
     End.
   /* Internal Cycle END :9030    */
   END.
   pause 0 before-hide.
end.
