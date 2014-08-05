/* Generate By Barcode Generator , Copyright by Softspeed - Build By Sam Song  */ 
/* VI LABLE PRINT */
/* Generate date / time  2011-3-18 11:31:15 */
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
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xslap07wtimeout"
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
                display "[自制品标签打印]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 width 150 no-box.

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
                display "[自制品标签打印]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1100 width 150 no-box.

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
                              wo_domain = V1001 AND ( WO_site = V1002 AND substring (WO_SO_JOB,1,2) <> "SA" and substring ( WO_SO_JOB ,1,2) <> "RA" ) AND  
                              WO_NBR >=  INPUT V1100
                               no-lock no-error.
                  else do: 
                       if WO_NBR =  INPUT V1100
                       then find next WO_MSTR
                       WHERE wo_domain = V1001 AND ( WO_site = V1002 AND substring (WO_SO_JOB,1,2) <> "SA" and substring ( WO_SO_JOB ,1,2) <> "RA" )
                        no-lock no-error.
                        else find first WO_MSTR where 
                              wo_domain = V1001 AND ( WO_site = V1002 AND substring (WO_SO_JOB,1,2) <> "SA" and substring ( WO_SO_JOB ,1,2) <> "RA" ) AND  
                              WO_NBR >=  INPUT V1100
                               no-lock no-error.
                  end.
                  IF AVAILABLE WO_MSTR then display skip 
            WO_NBR @ V1100 trim(WO_PART) + "/" + trim ( WO_SO_JOB ) @ WMESSAGE NO-LABEL with fram F1100.
                  else   display skip "" @ WMESSAGE with fram F1100.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(WO_MSTR) = ? THEN find last WO_MSTR where 
                              wo_domain = V1001 AND ( WO_site = V1002 AND substring (WO_SO_JOB,1,2) <> "SA" and substring ( WO_SO_JOB ,1,2) <> "RA" ) AND  
                              WO_NBR <=  INPUT V1100
                               no-lock no-error.
                  else do: 
                       if WO_NBR =  INPUT V1100
                       then find prev WO_MSTR
                       where wo_domain = V1001 AND ( WO_site = V1002 AND substring (WO_SO_JOB,1,2) <> "SA" and substring ( WO_SO_JOB ,1,2) <> "RA" )
                        no-lock no-error.
                        else find first WO_MSTR where 
                              wo_domain = V1001 AND ( WO_site = V1002 AND substring (WO_SO_JOB,1,2) <> "SA" and substring ( WO_SO_JOB ,1,2) <> "RA" ) AND  
                              WO_NBR >=  INPUT V1100
                               no-lock no-error.
                  end.
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
        find first WO_MSTR where WO_DOMAIN = V1001 AND WO_NBR = V1100 AND WO_SITE = V1002  no-lock no-error.
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
        find last wo_mstr where wo_domain = V1001 and wo_nbr  = V1100 and wo_site = V1002 no-lock no-error.
If AVAILABLE ( wo_mstr )  and  wo_lot = V1103 then
        leave V1103L.
        /* LOGICAL SKIP END */
                display "[自制品标签打印]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1103 width 150 no-box.

                /* LABEL 1 - START */ 
                L11031 = "工单ID#" .
                display L11031          format "x(40)" skip with fram F1103 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find first wo_mstr where wo_domain = V1001 and  wo_nbr  = V1100 and wo_site = V1002 no-lock no-error.
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
                              wo_domain = V1001 and wo_nbr = V1100 and wo_site = V1002 AND  
                              wo_lot >=  INPUT V1103
                               no-lock no-error.
                  else do: 
                       if wo_lot =  INPUT V1103
                       then find next wo_mstr
                       WHERE wo_domain = V1001 and wo_nbr = V1100 and wo_site = V1002
                        no-lock no-error.
                        else find first wo_mstr where 
                              wo_domain = V1001 and wo_nbr = V1100 and wo_site = V1002 AND  
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
                              wo_domain = V1001 and wo_nbr = V1100 and wo_site = V1002 AND  
                              wo_lot <=  INPUT V1103
                               no-lock no-error.
                  else do: 
                       if wo_lot =  INPUT V1103
                       then find prev wo_mstr
                       where wo_domain = V1001 and wo_nbr = V1100 and wo_site = V1002
                        no-lock no-error.
                        else find first wo_mstr where 
                              wo_domain = V1001 and wo_nbr = V1100 and wo_site = V1002 AND  
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
        IF V1103 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1103.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1103.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first wo_mstr where wo_domain = V1001 and wo_lot = V1103 AND wo_site = V1002  no-lock no-error.
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
                display "[自制品标签打印]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1104 width 150 no-box.

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
                display "[自制品标签打印]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1110 width 150 no-box.

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
                display "[自制品标签打印]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1310 width 150 no-box.

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
        IF V1310 = "e" THEN  LEAVE MAINLOOP.
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
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V1320 = PV1320 .
        V1320 = ENTRY(1,V1320,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[自制品标签打印]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1320 width 150 no-box.

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
        recid(CODE_MSTR) = ?.
        Update V1320
        WITH  fram F1320 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1320.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(CODE_MSTR) = ? THEN find first CODE_MSTR where 
                              CODE_DOMAIN = V1001 AND CODE_FLDNAME = "BARCODEVILINE" AND  
                              CODE_VALUE >=  INPUT V1320
                               no-lock no-error.
                  else do: 
                       if CODE_VALUE =  INPUT V1320
                       then find next CODE_MSTR
                       WHERE CODE_DOMAIN = V1001 AND CODE_FLDNAME = "BARCODEVILINE"
                        no-lock no-error.
                        else find first CODE_MSTR where 
                              CODE_DOMAIN = V1001 AND CODE_FLDNAME = "BARCODEVILINE" AND  
                              CODE_VALUE >=  INPUT V1320
                               no-lock no-error.
                  end.
                  IF AVAILABLE CODE_MSTR then display skip 
            CODE_VALUE @ V1320 trim ( CODE_VALUE ) + "/" + Trim(CODE_CMMT) @ WMESSAGE NO-LABEL with fram F1320.
                  else   display skip "" @ WMESSAGE with fram F1320.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(CODE_MSTR) = ? THEN find last CODE_MSTR where 
                              CODE_DOMAIN = V1001 AND CODE_FLDNAME = "BARCODEVILINE" AND  
                              CODE_VALUE <=  INPUT V1320
                               no-lock no-error.
                  else do: 
                       if CODE_VALUE =  INPUT V1320
                       then find prev CODE_MSTR
                       where CODE_DOMAIN = V1001 AND CODE_FLDNAME = "BARCODEVILINE"
                        no-lock no-error.
                        else find first CODE_MSTR where 
                              CODE_DOMAIN = V1001 AND CODE_FLDNAME = "BARCODEVILINE" AND  
                              CODE_VALUE >=  INPUT V1320
                               no-lock no-error.
                  end.
                  IF AVAILABLE CODE_MSTR then display skip 
            CODE_VALUE @ V1320 trim ( CODE_VALUE ) + "/" + Trim(CODE_CMMT) @ WMESSAGE NO-LABEL with fram F1320.
                  else   display skip "" @ WMESSAGE with fram F1320.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1320 = "e" THEN  LEAVE MAINLOOP.
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
                display "[自制品标签打印]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1330 width 150 no-box.

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
        IF V1330 = "e" THEN  LEAVE MAINLOOP.
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

                display "[自制品标签打印]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1335 width 150 no-box.

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
        IF V1335 = "e" THEN  LEAVE MAINLOOP.
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


   /* Internal Cycle Input :9010    */
   V9010LMAINLOOP:
   REPEAT:
     /* START  LINE :9010  条码上的数量[QTY ON LABEL]  */
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
        V9010 = "0".
        V9010 = ENTRY(1,V9010,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9010 = ENTRY(1,V9010,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[自制品标签打印]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9010 width 150 no-box.

                /* LABEL 1 - START */ 
                L90101 = "条码上数量" .
                display L90101          format "x(40)" skip with fram F9010 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L90102 = "图号:" + trim( V1104 ) .
                display L90102          format "x(40)" skip with fram F9010 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first pt_mstr where  pt_domain = V1001 and pt_part  = V1104 no-lock no-error.
If AVAILABLE ( pt_mstr ) then
                L90103 = "名称:" + trim (pt_desc1) .
                else L90103 = "" . 
                display L90103          format "x(40)" skip with fram F9010 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L90104 = "批号:" + trim ( V1335 ) .
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
        IF V9010 = "e" THEN  LEAVE V9010LMAINLOOP.
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


     /* START  LINE :9020  条码个数[NO OF LABEL]  */
     V9020L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9020           as char format "x(150)".
        define variable PV9020          as char format "x(150)".
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
                display "[自制品标签打印]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9020 width 150 no-box.

                /* LABEL 1 - START */ 
                L90201 = "条码张数?" .
                display L90201          format "x(40)" skip with fram F9020 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L90202 = "图号:" + trim( V1104 ) .
                display L90202          format "x(40)" skip with fram F9020 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L90203 = "批号:" + trim (V1335) .
                display L90203          format "x(40)" skip with fram F9020 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L90204 = "" . 
                display L90204          format "x(40)" skip with fram F9020 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9020 width 150 no-box.
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
        IF V9020 = "e" THEN  LEAVE V9010LMAINLOOP.
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
     /* START  LINE :9030  打印机[PRINTER]  */
     V9030L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9030           as char format "x(150)".
        define variable PV9030          as char format "x(150)".
        define variable L90301          as char format "x(40)".
        define variable L90302          as char format "x(40)".
        define variable L90303          as char format "x(40)".
        define variable L90304          as char format "x(40)".
        define variable L90305          as char format "x(40)".
        define variable L90306          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first upd_det where upd_nbr = "LAP07" and upd_select = 99 no-lock no-error.
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

        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V9030L .
        /* --CYCLE TIME SKIP -- END  */

                display "[自制品标签打印]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9030 width 150 no-box.

                /* LABEL 1 - START */ 
                L90301 = "打印机?" .
                display L90301          format "x(40)" skip with fram F9030 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L90302 = "" . 
                display L90302          format "x(40)" skip with fram F9030 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L90303 = "" . 
                display L90303          format "x(40)" skip with fram F9030 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L90304 = "" . 
                display L90304          format "x(40)" skip with fram F9030 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9030 width 150 no-box.
        recid(PRD_DET) = ?.
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
                  else do: 
                       if PRD_DEV =  INPUT V9030
                       then find next PRD_DET
                       WHERE PRD_TYPE = "BARCODE"
                        no-lock no-error.
                        else find first PRD_DET where 
                              PRD_TYPE = "BARCODE" AND  
                              PRD_DEV >=  INPUT V9030
                               no-lock no-error.
                  end.
                  IF AVAILABLE PRD_DET then display skip 
            PRD_DEV @ V9030 PRD_DESC @ WMESSAGE NO-LABEL with fram F9030.
                  else   display skip "" @ WMESSAGE with fram F9030.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(PRD_DET) = ? THEN find last PRD_DET where 
                              PRD_TYPE = "BARCODE" AND  
                              PRD_DEV <=  INPUT V9030
                               no-lock no-error.
                  else do: 
                       if PRD_DEV =  INPUT V9030
                       then find prev PRD_DET
                       where PRD_TYPE = "BARCODE"
                        no-lock no-error.
                        else find first PRD_DET where 
                              PRD_TYPE = "BARCODE" AND  
                              PRD_DEV >=  INPUT V9030
                               no-lock no-error.
                  end.
                  IF AVAILABLE PRD_DET then display skip 
            PRD_DEV @ V9030 PRD_DESC @ WMESSAGE NO-LABEL with fram F9030.
                  else   display skip "" @ WMESSAGE with fram F9030.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V9030 = "e" THEN  LEAVE V9010LMAINLOOP.
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
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9030.
        pause 0.
        leave V9030L.
     END.
     PV9030 = V9030.
     /* END    LINE :9030  打印机[PRINTER]  */


     Define variable ts9030 AS CHARACTER FORMAT "x(100)".
     Define variable av9030 AS CHARACTER FORMAT "x(100)".
     PROCEDURE lap079030l.
        /* Define Labels Path  Start */
        Define variable LabelsPath as character format "x(100)" init "/app/bc/labels/".
        Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath"no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath = trim ( code_cmmt ).
        If substring(LabelsPath, length(LabelsPath), 1) <> "/" Then 
        LabelsPath = LabelsPath + "/".
        /* Define Labels Path  END */
     INPUT FROM VALUE(LabelsPath + "lap07").
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
     output to value( trim(wsection) + ".l") .
     Do While True:
              IMPORT UNFORMATTED ts9030.
       find first pt_mstr where pt_domain = V1001 and pt_part = V1104  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9030 = if pt_avg_int <> 0 and pt_avg_int <> 90 then "保质期:" + trim ( string ( pt_avg_int ) ) + "月" else "".
       IF INDEX(ts9030,"&D") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "&D") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"&D") + length("&D"), LENGTH(ts9030) - ( index(ts9030 ,"&D" ) + length("&D") - 1 ) ).
       END.
        av9030 = string(today).
       IF INDEX(ts9030,"$D") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$D") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$D") + length("$D"), LENGTH(ts9030) - ( index(ts9030 ,"$D" ) + length("$D") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and pt_part = V1104  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9030 = trim(pt_desc1).
       IF INDEX(ts9030,"$F") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$F") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$F") + length("$F"), LENGTH(ts9030) - ( index(ts9030 ,"$F" ) + length("$F") - 1 ) ).
       END.
        av9030 = V1104.
       IF INDEX(ts9030,"$P") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$P") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$P") + length("$P"), LENGTH(ts9030) - ( index(ts9030 ,"$P" ) + length("$P") - 1 ) ).
       END.
        av9030 = V9010.
       IF INDEX(ts9030,"$Q") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$Q") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$Q") + length("$Q"), LENGTH(ts9030) - ( index(ts9030 ,"$Q" ) + length("$Q") - 1 ) ).
       END.
        av9030 = trim(V1104) + "@" + trim(V1335).
       IF INDEX(ts9030,"&B") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "&B") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"&B") + length("&B"), LENGTH(ts9030) - ( index(ts9030 ,"&B" ) + length("&B") - 1 ) ).
       END.
        av9030 = V1335.
       IF INDEX(ts9030,"$L") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$L") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$L") + length("$L"), LENGTH(ts9030) - ( index(ts9030 ,"$L" ) + length("$L") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and pt_part = V1104  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9030 = pt_um.
       IF INDEX(ts9030,"$U") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$U") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$U") + length("$U"), LENGTH(ts9030) - ( index(ts9030 ,"$U" ) + length("$U") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and pt_part = V1104  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9030 = if pt_drwg_loc <> "" then "ENV DIR:" + trim (pt_drwg_loc) else "".
       IF INDEX(ts9030,"&E") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "&E") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"&E") + length("&E"), LENGTH(ts9030) - ( index(ts9030 ,"&E" ) + length("&E") - 1 ) ).
       END.
        av9030 = V1100.
       IF INDEX(ts9030,"$O") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$O") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$O") + length("$O"), LENGTH(ts9030) - ( index(ts9030 ,"$O" ) + length("$O") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and pt_part = V1104  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9030 = trim(pt_desc2).
       IF INDEX(ts9030,"$E") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$E") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$E") + length("$E"), LENGTH(ts9030) - ( index(ts9030 ,"$E" ) + length("$E") - 1 ) ).
       END.
        av9030 = ( IF MONTH ( date ( V1110 ) ) < 10 THEN "0" + STRING( MONTH ( date ( V1110 ) ) ) ELSE STRING( MONTH ( date ( V1110 ) ) ) ).
       IF INDEX(ts9030,"&M") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "&M") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"&M") + length("&M"), LENGTH(ts9030) - ( index(ts9030 ,"&M" ) + length("&M") - 1 ) ).
       END.
       put unformatted ts9030 skip.
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.
     unix silent value ("chmod 777  " + trim(wsection) + ".l").
     END PROCEDURE.
     run lap079030l.
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
