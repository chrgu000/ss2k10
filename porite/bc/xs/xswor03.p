/* Generate By Barcode Generator , Copyright by Softspeed - Build By Sam Song  */ 
/* VI LABLE RECEIPT */
/* Generate date / time  2011-3-18 11:31:16 */
define variable sectionid as integer init 0 .
define variable WMESSAGE as char format "x(80)" init "".
define variable wtm_num as char format "x(20)" init "0".
define variable wsection as char format "x(200)".
define variable looa as char format "x(200)" init "Y".
define variable i as integer .
define variable t_v1300 as char .
define variable t_v1302 as char .
define variable t_v1310 as char .
define variable t_v1314 as char .
define variable t_v1326 as char .
define variable t_v1400 as char .
DEFINE VARIABLE trnbr AS INTEGER.
DEFINE NEW GLOBAL SHARED VARIABLE mfguser AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE ts_mfguser AS CHARACTER.
define  variable t_v100  as char EXTENT 15 .
define  variable tki  as integer .
define  variable tkj  as integer .
define  variable tkstr  as char .

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout"
 and can-find ( first dom_mstr where  dom_type = "SYSTEM " and dom_domain = code_domain and dom_active = yes ) 
 no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xswor03wtimeout"
 and can-find ( first dom_mstr where  dom_type = "SYSTEM " and dom_domain = code_domain and dom_active = yes ) 
 no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

mainloop:
REPEAT:
     /* CYCLE COUNTER -SECTION ID -- START*/
      sectionid = sectionid + 1 .
     /* SECTION ID -- END  */

     /* START  LINE :1001  域[DOMAIN]  */
     V1001L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1001           as char format "x(150)".
        define variable PV1001          as char format "x(150)".
        define variable L10011          as char format "x(40)".
        define variable L10012          as char format "x(40)".
        define variable L10013          as char format "x(40)".
        define variable L10014          as char format "x(40)".
        define variable L10015          as char format "x(40)".
        define variable L10016          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        {xsdfdomain.i}
        V1001 = wDefDomain.
        V1001 = ENTRY(1,V1001,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1001 = ENTRY(1,V1001,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF dPASS = "Y" then
        leave V1001L.
        /* LOGICAL SKIP END */

                /* LABEL 1 - START */ 
                L10011 = "域设定有误" .
                display L10011          format "x(40)" skip with fram F1001 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L10012 = "1.没有设定默认域" .
                display L10012          format "x(40)" skip with fram F1001 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L10013 = "2.域权限设定有误" .
                display L10013          format "x(40)" skip with fram F1001 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L10014 = "  请查核" .
                display L10014          format "x(40)" skip with fram F1001 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1001 width 150 no-box.
        Update V1001
        WITH  fram F1001 NO-LABEL
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
        IF V1001 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1001.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1001.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not trim(V1001) = "E" THEN DO:
                display skip "Error , Retry " @ WMESSAGE NO-LABEL with fram F1001.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1001.
        pause 0.
        leave V1001L.
     END.
     PV1001 = V1001.
     /* END    LINE :1001  域[DOMAIN]  */


     /* START  LINE :1002  地点[SITE]  */
     V1002L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1002           as char format "x(150)".
        define variable PV1002          as char format "x(150)".
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
                display "[自制标签入库]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 width 150 no-box.

                /* LABEL 1 - START */ 
                L10021 = "地点设定有误" .
                display L10021          format "x(40)" skip with fram F1002 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L10022 = "1.没有设定默认地点" .
                display L10022          format "x(40)" skip with fram F1002 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L10023 = "2.权限设定有误" .
                display L10023          format "x(40)" skip with fram F1002 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L10024 = "  请查核" .
                display L10024          format "x(40)" skip with fram F1002 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1002 width 150 no-box.
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


   /* Internal Cycle Input :1100    */
   V1100LMAINLOOP:
   REPEAT:
     /* START  LINE :1100  工单号码[WO]  */
     V1100L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1100           as char format "x(150)".
        define variable PV1100          as char format "x(150)".
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
                display "[自制标签入库]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1100 width 150 no-box.

                /* LABEL 1 - START */ 
                L11001 = "工单号码?" .
                display L11001          format "x(40)" skip with fram F1100 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11002 = "" . 
                display L11002          format "x(40)" skip with fram F1100 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11003 = "" . 
                display L11003          format "x(40)" skip with fram F1100 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11004 = "" . 
                display L11004          format "x(40)" skip with fram F1100 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1100 width 150 no-box.
        recid(WO_MSTR) = ?.
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
                              WO_DOMAIN = V1001 AND INDEX("AR",WO_STATUS) <> 0 AND WO_SITE = V1002 AND  
                              WO_NBR >=  INPUT V1100
                               no-lock no-error.
                  else do: 
                       if WO_NBR =  INPUT V1100
                       then find next WO_MSTR
                       WHERE WO_DOMAIN = V1001 AND INDEX("AR",WO_STATUS) <> 0 AND WO_SITE = V1002
                        no-lock no-error.
                        else find first WO_MSTR where 
                              WO_DOMAIN = V1001 AND INDEX("AR",WO_STATUS) <> 0 AND WO_SITE = V1002 AND  
                              WO_NBR >=  INPUT V1100
                               no-lock no-error.
                  end.
                  IF AVAILABLE WO_MSTR then display skip 
            WO_NBR @ V1100 trim(WO_PART) + "*" + trim ( string ( wo_due_date ) ) @ WMESSAGE NO-LABEL with fram F1100.
                  else   display skip "" @ WMESSAGE with fram F1100.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(WO_MSTR) = ? THEN find last WO_MSTR where 
                              WO_DOMAIN = V1001 AND INDEX("AR",WO_STATUS) <> 0 AND WO_SITE = V1002 AND  
                              WO_NBR <=  INPUT V1100
                               no-lock no-error.
                  else do: 
                       if WO_NBR =  INPUT V1100
                       then find prev WO_MSTR
                       where WO_DOMAIN = V1001 AND INDEX("AR",WO_STATUS) <> 0 AND WO_SITE = V1002
                        no-lock no-error.
                        else find first WO_MSTR where 
                              WO_DOMAIN = V1001 AND INDEX("AR",WO_STATUS) <> 0 AND WO_SITE = V1002 AND  
                              WO_NBR >=  INPUT V1100
                               no-lock no-error.
                  end.
                  IF AVAILABLE WO_MSTR then display skip 
            WO_NBR @ V1100 trim(WO_PART) + "*" + trim ( string ( wo_due_date ) ) @ WMESSAGE NO-LABEL with fram F1100.
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
        find first WO_MSTR where WO_DOMAIN = V1001 AND WO_NBR = V1100 AND INDEX("AR",WO_STATUS) <> 0 AND WO_SITE = V1002  NO-ERROR NO-WAIT.
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


     /* START  LINE :1103  ID[ID]  */
     V1103L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1103           as char format "x(150)".
        define variable PV1103          as char format "x(150)".
        define variable L11031          as char format "x(40)".
        define variable L11032          as char format "x(40)".
        define variable L11033          as char format "x(40)".
        define variable L11034          as char format "x(40)".
        define variable L11035          as char format "x(40)".
        define variable L11036          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first wo_mstr where wo_domain = V1001 and  wo_nbr  = V1100 and wo_site = V1002 no-lock no-error.
If AVAILABLE ( wo_mstr ) then
        V1103 = wo_lot.
        V1103 = ENTRY(1,V1103,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1103 = ENTRY(1,V1103,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        find last wo_mstr where wo_domain = V1001 AND wo_nbr  = V1100  and wo_site = V1002 no-lock no-error.
If AVAILABLE ( wo_mstr )  and  wo_lot = V1103 then
        leave V1103L.
        /* LOGICAL SKIP END */
                display "[自制标签入库]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1103 width 150 no-box.

                /* LABEL 1 - START */ 
                L11031 = "工单ID#" .
                display L11031          format "x(40)" skip with fram F1103 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find first wo_mstr where wo_domain = V1001 and wo_nbr  = V1100 and wo_site = V1002 no-lock no-error.
If AVAILABLE ( wo_mstr ) then
                L11032 = wo_lot .
                else L11032 = "" . 
                display L11032          format "x(40)" skip with fram F1103 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11033 = "" . 
                display L11033          format "x(40)" skip with fram F1103 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11034 = "" . 
                display L11034          format "x(40)" skip with fram F1103 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1103 width 150 no-box.
        recid(wo_mstr) = ?.
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
                              wo_domain = V1001 and wo_nbr = V1100 AND INDEX("AR",WO_STATUS) <> 0 and wo_site = V1002 AND  
                              wo_lot >=  INPUT V1103
                               no-lock no-error.
                  else do: 
                       if wo_lot =  INPUT V1103
                       then find next wo_mstr
                       WHERE wo_domain = V1001 and wo_nbr = V1100 AND INDEX("AR",WO_STATUS) <> 0 and wo_site = V1002
                        no-lock no-error.
                        else find first wo_mstr where 
                              wo_domain = V1001 and wo_nbr = V1100 AND INDEX("AR",WO_STATUS) <> 0 and wo_site = V1002 AND  
                              wo_lot >=  INPUT V1103
                               no-lock no-error.
                  end.
                  IF AVAILABLE wo_mstr then display skip 
            wo_lot @ V1103 "成品: " +  trim (wo_part) @ WMESSAGE NO-LABEL with fram F1103.
                  else   display skip "" @ WMESSAGE with fram F1103.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(wo_mstr) = ? THEN find last wo_mstr where 
                              wo_domain = V1001 and wo_nbr = V1100 AND INDEX("AR",WO_STATUS) <> 0 and wo_site = V1002 AND  
                              wo_lot <=  INPUT V1103
                               no-lock no-error.
                  else do: 
                       if wo_lot =  INPUT V1103
                       then find prev wo_mstr
                       where wo_domain = V1001 and wo_nbr = V1100 AND INDEX("AR",WO_STATUS) <> 0 and wo_site = V1002
                        no-lock no-error.
                        else find first wo_mstr where 
                              wo_domain = V1001 and wo_nbr = V1100 AND INDEX("AR",WO_STATUS) <> 0 and wo_site = V1002 AND  
                              wo_lot >=  INPUT V1103
                               no-lock no-error.
                  end.
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
        find first wo_mstr where wo_domain = V1001 AND wo_lot = V1103 AND INDEX("AR",WO_STATUS) <> 0 and wo_site = V1002  NO-ERROR NO-WAIT.
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


     /* START  LINE :1104  型号[ITEM]  */
     V1104L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1104           as char format "x(150)".
        define variable PV1104          as char format "x(150)".
        define variable L11041          as char format "x(40)".
        define variable L11042          as char format "x(40)".
        define variable L11043          as char format "x(40)".
        define variable L11044          as char format "x(40)".
        define variable L11045          as char format "x(40)".
        define variable L11046          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first wo_mstr where wo_domain = V1001 and wo_lot  = V1103 no-lock no-error.
If AVAILABLE ( wo_mstr ) then
        V1104 = wo_part.
        V1104 = ENTRY(1,V1104,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1104 = ENTRY(1,V1104,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[自制标签入库]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1104 width 150 no-box.

                /* LABEL 1 - START */ 
                L11041 = "图号" .
                display L11041          format "x(40)" skip with fram F1104 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11042 = wo_part .
                display L11042          format "x(40)" skip with fram F1104 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11043 = "" . 
                display L11043          format "x(40)" skip with fram F1104 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11044 = "" . 
                display L11044          format "x(40)" skip with fram F1104 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1104 width 150 no-box.
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
        IF V1104 = "e" THEN  LEAVE V1100LMAINLOOP.
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
     /* END    LINE :1104  型号[ITEM]  */


     /* START  LINE :1110  生产日期[Production Date]  */
     V1110L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1110           as char format "x(150)".
        define variable PV1110          as char format "x(150)".
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
                display "[自制标签入库]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1110 width 150 no-box.

                /* LABEL 1 - START */ 
                L11101 = "生产日期" .
                display L11101          format "x(40)" skip with fram F1110 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11102 = string(today) .
                display L11102          format "x(40)" skip with fram F1110 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11103 = "" . 
                display L11103          format "x(40)" skip with fram F1110 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11104 = "" . 
                display L11104          format "x(40)" skip with fram F1110 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1110 width 150 no-box.
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
        IF V1110 = "e" THEN  LEAVE V1100LMAINLOOP.
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
     /* END    LINE :1110  生产日期[Production Date]  */


     /* START  LINE :1310  版本[Version]  */
     V1310L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1310           as char format "x(150)".
        define variable PV1310          as char format "x(150)".
        define variable L13101          as char format "x(40)".
        define variable L13102          as char format "x(40)".
        define variable L13103          as char format "x(40)".
        define variable L13104          as char format "x(40)".
        define variable L13105          as char format "x(40)".
        define variable L13106          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first pt_mstr where pt_domain = V1001 and pt_part  = V1104 no-lock no-error.
If AVAILABLE ( pt_mstr ) then
        V1310 = fill( "0" , 4 - length (  trim ( pt_rev ) ) ) + trim ( pt_rev ).
        V1310 = ENTRY(1,V1310,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1310 = ENTRY(1,V1310,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[自制标签入库]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1310 width 150 no-box.

                /* LABEL 1 - START */ 
                L13101 = "版本" .
                display L13101          format "x(40)" skip with fram F1310 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L13102 = "" . 
                display L13102          format "x(40)" skip with fram F1310 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L13103 = "" . 
                display L13103          format "x(40)" skip with fram F1310 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13104 = "" . 
                display L13104          format "x(40)" skip with fram F1310 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1310 width 150 no-box.
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
        IF V1310 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1310.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1310.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not length( trim ( V1310 ) ) < 5 THEN DO:
                display skip "长度超过4位!" @ WMESSAGE NO-LABEL with fram F1310.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1310.
        pause 0.
        leave V1310L.
     END.
     IF INDEX(V1310,"@" ) = 0 then V1310 = V1310 + "@".
     PV1310 = V1310.
     V1310 = ENTRY(1,V1310,"@").
     /* END    LINE :1310  版本[Version]  */


     /* START  LINE :1320  部门[Department]  */
     V1320L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1320           as char format "x(150)".
        define variable PV1320          as char format "x(150)".
        define variable L13201          as char format "x(40)".
        define variable L13202          as char format "x(40)".
        define variable L13203          as char format "x(40)".
        define variable L13204          as char format "x(40)".
        define variable L13205          as char format "x(40)".
        define variable L13206          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find last code_mstr where code_domain = V1001 and code_fldname ="BARCODEDEFDEPWOR03" and code_value = trim ( userid(sdbname('qaddb')) ) no-lock no-error.
If AVAILABLE ( code_mstr ) then
        V1320 = code_cmmt.
        V1320 = ENTRY(1,V1320,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V1320 = PV1320 .
        V1320 = ENTRY(1,V1320,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[自制标签入库]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1320 width 150 no-box.

                /* LABEL 1 - START */ 
                L13201 = "生产部门" .
                display L13201          format "x(40)" skip with fram F1320 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L13202 = "" . 
                display L13202          format "x(40)" skip with fram F1320 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L13203 = "" . 
                display L13203          format "x(40)" skip with fram F1320 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13204 = "" . 
                display L13204          format "x(40)" skip with fram F1320 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1320 width 150 no-box.
        Update V1320
        WITH  fram F1320 NO-LABEL
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
        IF V1320 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1320.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1320.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first CODE_MSTR where CODE_DOMAIN = V1001 AND CODE_FLDNAME = "BARCODEVILINE" and CODE_VALUE = V1320  no-lock no-error.
        IF NOT AVAILABLE CODE_MSTR then do:
                display skip "长度有误OR未设定" @ WMESSAGE NO-LABEL with fram F1320.
                pause 0 before-hide.
                undo, retry.
        end.
        IF not length( trim ( V1320 ) ) = 2 THEN DO:
                display skip "长度有误OR未设定" @ WMESSAGE NO-LABEL with fram F1320.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1320.
        pause 0.
        leave V1320L.
     END.
     PV1320 = V1320.
     /* END    LINE :1320  部门[Department]  */


     /* START  LINE :1330  班次[Shift]  */
     V1330L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1330           as char format "x(150)".
        define variable PV1330          as char format "x(150)".
        define variable L13301          as char format "x(40)".
        define variable L13302          as char format "x(40)".
        define variable L13303          as char format "x(40)".
        define variable L13304          as char format "x(40)".
        define variable L13305          as char format "x(40)".
        define variable L13306          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1330 = "*".
        V1330 = ENTRY(1,V1330,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V1330 = PV1330 .
        V1330 = ENTRY(1,V1330,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[自制标签入库]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1330 width 150 no-box.

                /* LABEL 1 - START */ 
                L13301 = "自定义字段" .
                display L13301          format "x(40)" skip with fram F1330 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L13302 = "" . 
                display L13302          format "x(40)" skip with fram F1330 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L13303 = "" . 
                display L13303          format "x(40)" skip with fram F1330 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13304 = "" . 
                display L13304          format "x(40)" skip with fram F1330 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1330 width 150 no-box.
        Update V1330
        WITH  fram F1330 NO-LABEL
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
        IF V1330 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1330.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1330.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not ( length( trim ( V1330 ) ) = 1 OR ( V1330 = "EE" ) ) THEN DO:
                display skip "长度支能1位OR EE" @ WMESSAGE NO-LABEL with fram F1330.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1330.
        pause 0.
        leave V1330L.
     END.
     PV1330 = V1330.
     /* END    LINE :1330  班次[Shift]  */


     /* START  LINE :1335  批号[Lot]  */
     V1335L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1335           as char format "x(150)".
        define variable PV1335          as char format "x(150)".
        define variable L13351          as char format "x(40)".
        define variable L13352          as char format "x(40)".
        define variable L13353          as char format "x(40)".
        define variable L13354          as char format "x(40)".
        define variable L13355          as char format "x(40)".
        define variable L13356          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1335 = fill( "0" , 4 - length (  trim (V1310) ) ) + trim (V1310) + SUBSTRING ( STRING(YEAR(date ( V1110 ))) , LENGTH( STRING ( year (date ( V1110 )) ) ) - 1 ,2 )  + ( IF MONTH ( date ( V1110 ) ) < 10 THEN "0" + STRING( MONTH ( date ( V1110 ) ) ) ELSE STRING( MONTH ( date ( V1110 ) ) ) ) +  ( IF DAY ( date ( V1110 ) ) < 10 THEN "0" + STRING( DAY ( date ( V1110 ) ) ) ELSE STRING( DAY ( date ( V1110 ) ) ) )  +  trim(V1320) + substring ( trim(V1330) ,1 ,1 ).
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

                display "[自制标签入库]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1335 width 150 no-box.

                /* LABEL 1 - START */ 
                  L13351 = "" . 
                display L13351          format "x(40)" skip with fram F1335 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L13352 = "" . 
                display L13352          format "x(40)" skip with fram F1335 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L13353 = "" . 
                display L13353          format "x(40)" skip with fram F1335 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13354 = "" . 
                display L13354          format "x(40)" skip with fram F1335 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1335 width 150 no-box.
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

        /* PRESS e EXIST CYCLE */
        IF V1335 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1335.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1335.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not ( IF INDEX(V1335,"@" ) <> 0 then ENTRY(2,V1335,"@") else V1335 ) <> "" THEN DO:
                display skip "L控制,不能为空" @ WMESSAGE NO-LABEL with fram F1335.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1335.
        pause 0.
        leave V1335L.
     END.
     PV1335 = V1335.
     /* END    LINE :1335  批号[Lot]  */


     /* START  LINE :1400  库位[LOC]  */
     V1400L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1400           as char format "x(150)".
        define variable PV1400          as char format "x(150)".
        define variable L14001          as char format "x(40)".
        define variable L14002          as char format "x(40)".
        define variable L14003          as char format "x(40)".
        define variable L14004          as char format "x(40)".
        define variable L14005          as char format "x(40)".
        define variable L14006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1400 = "VI" + trim ( V1320 ).
        V1400 = ENTRY(1,V1400,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1400 = ENTRY(1,V1400,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[自制标签入库]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1400 width 150 no-box.

                /* LABEL 1 - START */ 
                L14001 = "库位?" .
                display L14001          format "x(40)" skip with fram F1400 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L14002 = "库位= VI 加部门" .
                display L14002          format "x(40)" skip with fram F1400 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L14003 = "" . 
                display L14003          format "x(40)" skip with fram F1400 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L14004 = "" . 
                display L14004          format "x(40)" skip with fram F1400 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1400 width 150 no-box.
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
        IF V1400 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1400.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1400.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first LOC_MSTR where LOC_DOMAIN = V1001 AND LOC_LOC = V1400 AND LOC_SITE = V1002  no-lock no-error.
        IF NOT AVAILABLE LOC_MSTR then do:
                display skip "Error , Retry." @ WMESSAGE NO-LABEL with fram F1400.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1400.
        pause 0.
        leave V1400L.
     END.
     PV1400 = V1400.
     /* END    LINE :1400  库位[LOC]  */


     /* START  LINE :1600  数量[QTY]  */
     V1600L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1600           as char format "x(150)".
        define variable PV1600          as char format "x(150)".
        define variable L16001          as char format "x(40)".
        define variable L16002          as char format "x(40)".
        define variable L16003          as char format "x(40)".
        define variable L16004          as char format "x(40)".
        define variable L16005          as char format "x(40)".
        define variable L16006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1600 = " ".
        V1600 = ENTRY(1,V1600,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[自制标签入库]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1600 width 150 no-box.

                /* LABEL 1 - START */ 
                L16001 = "入库数量?" .
                display L16001          format "x(40)" skip with fram F1600 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L16002 = "图号:" + trim( V1104 ) .
                display L16002          format "x(40)" skip with fram F1600 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L16003 = "批号:" + Trim(V1335) .
                display L16003          format "x(40)" skip with fram F1600 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                find first wo_mstr where wo_domain = V1001 and wo_lot = V1103  no-lock no-error.
If AVAILABLE ( wo_mstr ) then
                L16004 = "未结数量:" + ( if wo_qty_ord < wo_qty_comp then "0" else string ( wo_qty_ord - wo_qty_comp ) ) .
                else L16004 = "" . 
                display L16004          format "x(40)" skip with fram F1600 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1600 width 150 no-box.
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
        IF V1600 = "e" THEN  LEAVE V1100LMAINLOOP.
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
        find first LD_DET where ( decimal(V1600) > 0 ) OR ( decimal(V1600) < 0 AND (ld_domain = V1001 and ld_part  = V1104 AND ld_loc = V1400 and ld_site = V1002 and ld_Ref = "" and  ld_lot = V1335 and  ld_QTY_oh + DECIMAL ( V1600 ) >= 0 ) )  no-lock no-error.
        IF NOT AVAILABLE LD_DET then do:
                display skip "该操作导致库存< 0" @ WMESSAGE NO-LABEL with fram F1600.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1600.
        pause 0.
        leave V1600L.
     END.
     PV1600 = V1600.
     /* END    LINE :1600  数量[QTY]  */


     /* START  LINE :1700  确认[CONFIRM]  */
     V1700L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1700           as char format "x(150)".
        define variable PV1700          as char format "x(150)".
        define variable L17001          as char format "x(40)".
        define variable L17002          as char format "x(40)".
        define variable L17003          as char format "x(40)".
        define variable L17004          as char format "x(40)".
        define variable L17005          as char format "x(40)".
        define variable L17006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1700 = "E".
        V1700 = ENTRY(1,V1700,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1700 = ENTRY(1,V1700,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[自制标签入库]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1700 width 150 no-box.

                /* LABEL 1 - START */ 
                L17001 = "图号:" + trim(V1104) .
                display L17001          format "x(40)" skip with fram F1700 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L17002 = "批号:" + trim ( V1335 ) .
                display L17002          format "x(40)" skip with fram F1700 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L17003 = "库位:" + trim ( V1400 ) + "/" + trim( V1600 ) .
                display L17003          format "x(40)" skip with fram F1700 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L17004 = "" . 
                display L17004          format "x(40)" skip with fram F1700 width 150 no-box.
                /* LABEL 4 - END */ 
                display "确认过帐[Y],E退出"   format "x(40)" skip
        skip with fram F1700 width 150 no-box.
        Update V1700
        WITH  fram F1700 NO-LABEL
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
        IF V1700 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1700.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1700.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first wo_mstr where wo_domain = V1001 and wo_lot = V1103 AND INDEX("AR",WO_STATUS) <> 0 and wo_site = V1002  NO-ERROR NO-WAIT.
        IF NOT AVAILABLE wo_mstr then do:
                display skip "无效或被锁!" @ WMESSAGE NO-LABEL with fram F1700.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1700.
        pause 0.
        leave V1700L.
     END.
     PV1700 = V1700.
     /* END    LINE :1700  确认[CONFIRM]  */


     /* START  LINE :9000  BEFORE POST LAST TRANSACTION  */
     V9000L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9000           as char format "x(150)".
        define variable PV9000          as char format "x(150)".
        define variable L90001          as char format "x(40)".
        define variable L90002          as char format "x(40)".
        define variable L90003          as char format "x(40)".
        define variable L90004          as char format "x(40)".
        define variable L90005          as char format "x(40)".
        define variable L90006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find last tr_hist where tr_domain = V1001 and tr_trnbr >= 0 no-lock no-error.
If AVAILABLE ( tr_hist ) then
        V9000 = string(tr_trnbr).
        V9000 = ENTRY(1,V9000,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9000 = ENTRY(1,V9000,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V9000L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V9000L .
        /* --CYCLE TIME SKIP -- END  */

                display "[自制标签入库]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9000 width 150 no-box.

                /* LABEL 1 - START */ 
                  L90001 = "" . 
                display L90001          format "x(40)" skip with fram F9000 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L90002 = "" . 
                display L90002          format "x(40)" skip with fram F9000 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L90003 = "" . 
                display L90003          format "x(40)" skip with fram F9000 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L90004 = "" . 
                display L90004          format "x(40)" skip with fram F9000 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9000 width 150 no-box.
        /* DISPLAY ONLY */
        define variable X9000           as char format "x(40)".
        X9000 = V9000.
        V9000 = "".
        /* DISPLAY ONLY */
        Update V9000
        WITH  fram F9000 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V9000 = X9000.
        /* DISPLAY ONLY */
        LEAVE V9000L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V9000 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9000.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9000.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9000.
        pause 0.
        leave V9000L.
     END.
     PV9000 = V9000.
     /* END    LINE :9000  BEFORE POST LAST TRANSACTION  */


        display "...PROCESSING...  " NO-LABEL with fram F9000X width 150 no-box.
        pause 0.
     /*  Update MFG/PRO START  */ 
      mfguser = V1300. /* ching add */ 
     {xswor03u.i}
     /*  Update MFG/PRO END  */ 
        display  "" NO-LABEL with fram F9000X width 150 no-box .
        pause 0.
     /* START  LINE :9010  Ok  */
     V9010L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9010           as char format "x(150)".
        define variable PV9010          as char format "x(150)".
        define variable L90101          as char format "x(40)".
        define variable L90102          as char format "x(40)".
        define variable L90103          as char format "x(40)".
        define variable L90104          as char format "x(40)".
        define variable L90105          as char format "x(40)".
        define variable L90106          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V9010 = "Y".
        V9010 = ENTRY(1,V9010,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9010 = ENTRY(1,V9010,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[自制标签入库]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9010 width 150 no-box.

                /* LABEL 1 - START */ 
                find last tr_hist where tr_domain = V1001 and 
tr_date = today     and 
tr_trnbr > integer ( V9000 ) and 
tr_nbr  = V1100     and  tr_type = "RCT-WO"  and  tr_lot  = V1103     and 
tr_site = V1002     and tr_part = V1104     and tr_serial = V1335   and 
tr_time  + 15 >= TIME 
use-index tr_date_trn no-lock no-error.
If AVAILABLE ( tr_hist ) then
                L90101 = "交易已提交" .
                else L90101 = "" . 
                display L90101          format "x(40)" skip with fram F9010 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find last tr_hist where tr_domain = V1001 and 
tr_date = today     and 
tr_trnbr > integer ( V9000 ) and 
tr_nbr  = V1100     and  tr_type = "RCT-WO"  and  tr_site = V1002     and tr_lot  = V1103     and tr_part = V1104     and tr_serial = V1335   and 
tr_time  + 15 >= TIME 
use-index tr_date_trn no-lock no-error.
If AVAILABLE ( tr_hist ) then
                L90102 = "交易号 :" + trim(string(tr_trnbr)) .
                else L90102 = "" . 
                display L90102          format "x(40)" skip with fram F9010 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find last tr_hist where tr_domain = V1001 and 
tr_date = today     and 
tr_trnbr > integer ( V9000 ) and 
tr_nbr  = V1100     and  tr_type = "RCT-WO"  and  tr_site = V1002     and tr_lot  = V1103     and tr_part = V1104     and tr_serial = V1335   and 
tr_time  + 15 >= TIME 
use-index tr_date_trn no-lock no-error.
If NOT AVAILABLE ( tr_hist ) then
                L90103 = "交易提交失败" .
                else L90103 = "" . 
                display L90103          format "x(40)" skip with fram F9010 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L90104 = "按Y打印条码,E退出" .
                display L90104          format "x(40)" skip with fram F9010 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9010 width 150 no-box.
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
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not trim(V9010) = "Y" THEN DO:
                display skip "Error , Retry " @ WMESSAGE NO-LABEL with fram F9010.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9010.
        pause 0.
        leave V9010L.
     END.
     PV9010 = V9010.
     /* END    LINE :9010  Ok  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1100LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :9010    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :9110    */
   V9110LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle9110    */
   IF NOT (V9010 = "Y" AND V1700 = "Y" ) THEN LEAVE V9110LMAINLOOP.
     /* START  LINE :9110  条码上的数量[QTY ON LABEL]  */
     V9110L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9110           as char format "x(150)".
        define variable PV9110          as char format "x(150)".
        define variable L91101          as char format "x(40)".
        define variable L91102          as char format "x(40)".
        define variable L91103          as char format "x(40)".
        define variable L91104          as char format "x(40)".
        define variable L91105          as char format "x(40)".
        define variable L91106          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V9110 = V1600.
        V9110 = ENTRY(1,V9110,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9110 = ENTRY(1,V9110,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[自制标签入库]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9110 width 150 no-box.

                /* LABEL 1 - START */ 
                L91101 = "条码上数量" .
                display L91101          format "x(40)" skip with fram F9110 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L91102 = "图号:" + trim( V1104 ) .
                display L91102          format "x(40)" skip with fram F9110 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first pt_mstr where pt_domain = V1001 and pt_part  = V1104 no-lock no-error.
If AVAILABLE ( pt_mstr ) then
                L91103 = "名称:" + trim (pt_desc1) .
                else L91103 = "" . 
                display L91103          format "x(40)" skip with fram F9110 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L91104 = "批号:" + trim ( V1335 ) .
                display L91104          format "x(40)" skip with fram F9110 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9110 width 150 no-box.
        Update V9110
        WITH  fram F9110 NO-LABEL
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
        IF V9110 = "e" THEN  LEAVE V9110LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9110.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9110.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        If V9110 = "" OR V9110 = "-" OR V9110 = "." OR V9110 = ".-" OR V9110 = "-." then do:
                display skip "CAN NOT EMPTY  " @ WMESSAGE NO-LABEL with fram F9110.
                pause 0 before-hide.
                undo, retry.
        end.
        DO i = 1 to length(V9110).
                If index("0987654321.-", substring(V9110,i,1)) = 0 then do:
                display skip "Format  Error  " @ WMESSAGE NO-LABEL with fram F9110.
                pause 0 before-hide.
                undo, retry.
                end.
        end.
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9110.
        pause 0.
        leave V9110L.
     END.
     PV9110 = V9110.
     /* END    LINE :9110  条码上的数量[QTY ON LABEL]  */


     /* START  LINE :9120  条码个数[NO OF LABEL]  */
     V9120L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9120           as char format "x(150)".
        define variable PV9120          as char format "x(150)".
        define variable L91201          as char format "x(40)".
        define variable L91202          as char format "x(40)".
        define variable L91203          as char format "x(40)".
        define variable L91204          as char format "x(40)".
        define variable L91205          as char format "x(40)".
        define variable L91206          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V9120 = "1".
        V9120 = ENTRY(1,V9120,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9120 = ENTRY(1,V9120,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[自制标签入库]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9120 width 150 no-box.

                /* LABEL 1 - START */ 
                L91201 = "条码张数?" .
                display L91201          format "x(40)" skip with fram F9120 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L91202 = "图号:" + trim( V1104 ) .
                display L91202          format "x(40)" skip with fram F9120 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L91203 = "批号:" + trim (V1335) .
                display L91203          format "x(40)" skip with fram F9120 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L91204 = "" . 
                display L91204          format "x(40)" skip with fram F9120 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9120 width 150 no-box.
        Update V9120
        WITH  fram F9120 NO-LABEL
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
        IF V9120 = "e" THEN  LEAVE V9110LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9120.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9120.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        If V9120 = "" OR V9120 = "-" OR V9120 = "." OR V9120 = ".-" OR V9120 = "-." then do:
                display skip "CAN NOT EMPTY  " @ WMESSAGE NO-LABEL with fram F9120.
                pause 0 before-hide.
                undo, retry.
        end.
        DO i = 1 to length(V9120).
                If index("0987654321.-", substring(V9120,i,1)) = 0 then do:
                display skip "Format  Error  " @ WMESSAGE NO-LABEL with fram F9120.
                pause 0 before-hide.
                undo, retry.
                end.
        end.
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9120.
        pause 0.
        leave V9120L.
     END.
     PV9120 = V9120.
     /* END    LINE :9120  条码个数[NO OF LABEL]  */


   wtm_num = V9120.
     /* START  LINE :9130  打印机[PRINTER]  */
     V9130L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9130           as char format "x(150)".
        define variable PV9130          as char format "x(150)".
        define variable L91301          as char format "x(40)".
        define variable L91302          as char format "x(40)".
        define variable L91303          as char format "x(40)".
        define variable L91304          as char format "x(40)".
        define variable L91305          as char format "x(40)".
        define variable L91306          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first upd_det where upd_nbr = "WOR03" and upd_select = 99 no-lock no-error.
If AVAILABLE ( upd_det ) then
        V9130 = UPD_DEV.
        V9130 = ENTRY(1,V9130,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V9130 = PV9130 .
        V9130 = ENTRY(1,V9130,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V9130L .
        /* --CYCLE TIME SKIP -- END  */

                display "[自制标签入库]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9130 width 150 no-box.

                /* LABEL 1 - START */ 
                L91301 = "打印机?" .
                display L91301          format "x(40)" skip with fram F9130 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L91302 = "" . 
                display L91302          format "x(40)" skip with fram F9130 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L91303 = "" . 
                display L91303          format "x(40)" skip with fram F9130 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L91304 = "" . 
                display L91304          format "x(40)" skip with fram F9130 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9130 width 150 no-box.
        recid(PRD_DET) = ?.
        Update V9130
        WITH  fram F9130 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F9130.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(PRD_DET) = ? THEN find first PRD_DET where 
                              PRD_TYPE = "BARCODE" AND  
                              PRD_DEV >=  INPUT V9130
                               no-lock no-error.
                  else do: 
                       if PRD_DEV =  INPUT V9130
                       then find next PRD_DET
                       WHERE PRD_TYPE = "BARCODE"
                        no-lock no-error.
                        else find first PRD_DET where 
                              PRD_TYPE = "BARCODE" AND  
                              PRD_DEV >=  INPUT V9130
                               no-lock no-error.
                  end.
                  IF AVAILABLE PRD_DET then display skip 
            PRD_DEV @ V9130 PRD_DESC @ WMESSAGE NO-LABEL with fram F9130.
                  else   display skip "" @ WMESSAGE with fram F9130.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(PRD_DET) = ? THEN find last PRD_DET where 
                              PRD_TYPE = "BARCODE" AND  
                              PRD_DEV <=  INPUT V9130
                               no-lock no-error.
                  else do: 
                       if PRD_DEV =  INPUT V9130
                       then find prev PRD_DET
                       where PRD_TYPE = "BARCODE"
                        no-lock no-error.
                        else find first PRD_DET where 
                              PRD_TYPE = "BARCODE" AND  
                              PRD_DEV >=  INPUT V9130
                               no-lock no-error.
                  end.
                  IF AVAILABLE PRD_DET then display skip 
            PRD_DEV @ V9130 PRD_DESC @ WMESSAGE NO-LABEL with fram F9130.
                  else   display skip "" @ WMESSAGE with fram F9130.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V9130 = "e" THEN  LEAVE V9110LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9130.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9130.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first PRD_DET where PRD_DEV = V9130 and PRD_TYPE = "BARCODE"  no-lock no-error.
        IF NOT AVAILABLE PRD_DET then do:
                display skip "Printer Error " @ WMESSAGE NO-LABEL with fram F9130.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9130.
        pause 0.
        leave V9130L.
     END.
     PV9130 = V9130.
     /* END    LINE :9130  打印机[PRINTER]  */


     Define variable ts9130 AS CHARACTER FORMAT "x(100)".
     Define variable av9130 AS CHARACTER FORMAT "x(100)".
     PROCEDURE wor039130l.
        /* Define Labels Path  Start */
        Define variable LabelsPath as character format "x(100)" init "/app/bc/labels/".
        Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath"no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath = trim ( code_cmmt ).
        If substring(LabelsPath, length(LabelsPath), 1) <> "/" Then 
        LabelsPath = LabelsPath + "/".
        /* Define Labels Path  END */
     INPUT FROM VALUE(LabelsPath + "wor03").
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
     output to value( trim(wsection) + ".l") .
     Do While True:
              IMPORT UNFORMATTED ts9130.
        av9130 = trim(V1104) + "@" + trim(V1335).
       IF INDEX(ts9130,"&B") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&B") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"&B") + length("&B"), LENGTH(ts9130) - ( index(ts9130 ,"&B" ) + length("&B") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and  pt_part = V1104  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = trim(pt_desc2).
       IF INDEX(ts9130,"$E") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$E") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$E") + length("$E"), LENGTH(ts9130) - ( index(ts9130 ,"$E" ) + length("$E") - 1 ) ).
       END.
        av9130 = V9110.
       IF INDEX(ts9130,"$Q") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$Q") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$Q") + length("$Q"), LENGTH(ts9130) - ( index(ts9130 ,"$Q" ) + length("$Q") - 1 ) ).
       END.
        av9130 = string(today).
       IF INDEX(ts9130,"$D") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$D") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$D") + length("$D"), LENGTH(ts9130) - ( index(ts9130 ,"$D" ) + length("$D") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and  pt_part = V1104  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = trim(pt_desc1).
       IF INDEX(ts9130,"$F") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$F") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$F") + length("$F"), LENGTH(ts9130) - ( index(ts9130 ,"$F" ) + length("$F") - 1 ) ).
       END.
        av9130 = V1100.
       IF INDEX(ts9130,"$O") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$O") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$O") + length("$O"), LENGTH(ts9130) - ( index(ts9130 ,"$O" ) + length("$O") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and  pt_part = V1104  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = pt_um.
       IF INDEX(ts9130,"$U") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$U") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$U") + length("$U"), LENGTH(ts9130) - ( index(ts9130 ,"$U" ) + length("$U") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and  pt_part = V1104  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = if pt_avg_int <> 0 and pt_avg_int <> 90 then "保质期:" + trim ( string ( pt_avg_int ) ) + "月" else "".
       IF INDEX(ts9130,"&D") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&D") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"&D") + length("&D"), LENGTH(ts9130) - ( index(ts9130 ,"&D" ) + length("&D") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and  pt_part = V1104  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = if pt_drwg_loc <> "" then "ENV DIR:" + trim (pt_drwg_loc) else "".
       IF INDEX(ts9130,"&E") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&E") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"&E") + length("&E"), LENGTH(ts9130) - ( index(ts9130 ,"&E" ) + length("&E") - 1 ) ).
       END.
        av9130 = ( IF MONTH ( date ( V1110 ) ) < 10 THEN "0" + STRING( MONTH ( date ( V1110 ) ) ) ELSE STRING( MONTH ( date ( V1110 ) ) ) ).
       IF INDEX(ts9130,"&M") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&M") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"&M") + length("&M"), LENGTH(ts9130) - ( index(ts9130 ,"&M" ) + length("&M") - 1 ) ).
       END.
        av9130 = V1104.
       IF INDEX(ts9130,"$P") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$P") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$P") + length("$P"), LENGTH(ts9130) - ( index(ts9130 ,"$P" ) + length("$P") - 1 ) ).
       END.
        av9130 = V1335.
       IF INDEX(ts9130,"$L") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$L") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$L") + length("$L"), LENGTH(ts9130) - ( index(ts9130 ,"$L" ) + length("$L") - 1 ) ).
       END.
       put unformatted ts9130 skip.
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.
     unix silent value ("chmod 777  " + trim(wsection) + ".l").
     END PROCEDURE.
     run wor039130l.
     do i = 1 to integer(wtm_num):
       find first PRD_DET where PRD_DEV = V9130 no-lock no-error.
       IF AVAILABLE PRD_DET then do:
         unix silent value (trim(prd_path) + " " + trim(wsection) + ".l").
         unix silent value ( "clear").
       end.
     End.
   /* Internal Cycle END :9130    */
   END.
   pause 0 before-hide.
end.
