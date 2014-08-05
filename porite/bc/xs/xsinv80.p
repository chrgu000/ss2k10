/* Generate By Barcode Generator , Copyright by Softspeed - Build By Sam Song  */ 
/* SO LABLE REPRINT */
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
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xsinv80wtimeout"
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
                display "[销售标签补打]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 width 150 no-box.

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


     /* START  LINE :1100  销售订单[SO]  */
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
                display "[销售标签补打]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1100 width 150 no-box.

                /* LABEL 1 - START */ 
                L11001 = "销售订单?" .
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
        recid(SO_MSTR) = ?.
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
                  IF recid(SO_MSTR) = ? THEN find first SO_MSTR where 
                              SO_DOMAIN = V1001 AND ( SO_SITE = "" OR SO_SITE = V1002 ) AND  
                              SO_NBR >=  INPUT V1100
                               no-lock no-error.
                  else do: 
                       if SO_NBR =  INPUT V1100
                       then find next SO_MSTR
                       WHERE SO_DOMAIN = V1001 AND ( SO_SITE = "" OR SO_SITE = V1002 )
                        no-lock no-error.
                        else find first SO_MSTR where 
                              SO_DOMAIN = V1001 AND ( SO_SITE = "" OR SO_SITE = V1002 ) AND  
                              SO_NBR >=  INPUT V1100
                               no-lock no-error.
                  end.
                  IF AVAILABLE SO_MSTR then display skip 
            SO_NBR @ V1100 trim( SO_PO ) + "/" + trim( SO_CUST ) @ WMESSAGE NO-LABEL with fram F1100.
                  else   display skip "" @ WMESSAGE with fram F1100.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(SO_MSTR) = ? THEN find last SO_MSTR where 
                              SO_DOMAIN = V1001 AND ( SO_SITE = "" OR SO_SITE = V1002 ) AND  
                              SO_NBR <=  INPUT V1100
                               no-lock no-error.
                  else do: 
                       if SO_NBR =  INPUT V1100
                       then find prev SO_MSTR
                       where SO_DOMAIN = V1001 AND ( SO_SITE = "" OR SO_SITE = V1002 )
                        no-lock no-error.
                        else find first SO_MSTR where 
                              SO_DOMAIN = V1001 AND ( SO_SITE = "" OR SO_SITE = V1002 ) AND  
                              SO_NBR >=  INPUT V1100
                               no-lock no-error.
                  end.
                  IF AVAILABLE SO_MSTR then display skip 
            SO_NBR @ V1100 trim( SO_PO ) + "/" + trim( SO_CUST ) @ WMESSAGE NO-LABEL with fram F1100.
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
        find first SO_MSTR where SO_DOMAIN = V1001 AND SO_NBR = V1100 AND (SO_SITE = "" OR SO_SITE = V1002 )  no-lock no-error.
        IF NOT AVAILABLE SO_MSTR then do:
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
     /* END    LINE :1100  销售订单[SO]  */


     /* START  LINE :1110  客户代码  */
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
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find last so_mstr where so_domain = V1001 and so_nbr = V1100  no-lock no-error.
If AVAILABLE (so_mstr) then
        V1110 = so_cust.
        V1110 = ENTRY(1,V1110,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1110 = ENTRY(1,V1110,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF 1 = 1 THEN
        leave V1110L.
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1110L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1110L .
        /* --CYCLE TIME SKIP -- END  */

                display "[销售标签补打]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1110 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11101 = "" . 
                display L11101          format "x(40)" skip with fram F1110 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11102 = "" . 
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
        IF V1110 = "e" THEN  LEAVE MAINLOOP.
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
     /* END    LINE :1110  客户代码  */


   /* Internal Cycle Input :1205    */
   V1205LMAINLOOP:
   REPEAT:
     /* START  LINE :1205  订单项次  */
     V1205L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1205           as char format "x(150)".
        define variable PV1205          as char format "x(150)".
        define variable L12051          as char format "x(40)".
        define variable L12052          as char format "x(40)".
        define variable L12053          as char format "x(40)".
        define variable L12054          as char format "x(40)".
        define variable L12055          as char format "x(40)".
        define variable L12056          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first sod_det where sod_domain = V1001 and sod_nbr = V1100 and sod_site = V1002 no-lock no-error.
If AVAILABLE (sod_det) and string ( sod_line ) <> V1205 then
        V1205 = string (sod_line ).
        V1205 = ENTRY(1,V1205,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1205 = ENTRY(1,V1205,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        find last sod_det where sod_domain = V1001 and sod_nbr = V1100 and sod_site = V1002 no-lock no-error.
If AVAILABLE (sod_det) and string ( sod_line ) = V1205 then
        leave V1205L.
        /* LOGICAL SKIP END */
                display "[销售标签补打]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1205 width 150 no-box.

                /* LABEL 1 - START */ 
                L12051 = "订单项次" .
                display L12051          format "x(40)" skip with fram F1205 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L12052 = "" . 
                display L12052          format "x(40)" skip with fram F1205 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L12053 = "" . 
                display L12053          format "x(40)" skip with fram F1205 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L12054 = "" . 
                display L12054          format "x(40)" skip with fram F1205 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1205 width 150 no-box.
        recid(SOD_DET) = ?.
        Update V1205
        WITH  fram F1205 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1205.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(SOD_DET) = ? THEN find first SOD_DET where 
                              sod_domain = V1001 and ( sod_nbr = V1100 and sod_site = V1002 ) AND  
                              string ( SOD_LINE ) >=  INPUT V1205
                               no-lock no-error.
                  else do: 
                       if string ( SOD_LINE ) =  INPUT V1205
                       then find next SOD_DET
                       WHERE sod_domain = V1001 and ( sod_nbr = V1100 and sod_site = V1002 )
                        no-lock no-error.
                        else find first SOD_DET where 
                              sod_domain = V1001 and ( sod_nbr = V1100 and sod_site = V1002 ) AND  
                              string ( SOD_LINE ) >=  INPUT V1205
                               no-lock no-error.
                  end.
                  IF AVAILABLE SOD_DET then display skip 
            string ( SOD_LINE ) @ V1205 trim(SOD_PART) + "*" + String( SOD_DUE_DATE) @ WMESSAGE NO-LABEL with fram F1205.
                  else   display skip "" @ WMESSAGE with fram F1205.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(SOD_DET) = ? THEN find last SOD_DET where 
                              sod_domain = V1001 and ( sod_nbr = V1100 and sod_site = V1002 ) AND  
                              string ( SOD_LINE ) <=  INPUT V1205
                               no-lock no-error.
                  else do: 
                       if string ( SOD_LINE ) =  INPUT V1205
                       then find prev SOD_DET
                       where sod_domain = V1001 and ( sod_nbr = V1100 and sod_site = V1002 )
                        no-lock no-error.
                        else find first SOD_DET where 
                              sod_domain = V1001 and ( sod_nbr = V1100 and sod_site = V1002 ) AND  
                              string ( SOD_LINE ) >=  INPUT V1205
                               no-lock no-error.
                  end.
                  IF AVAILABLE SOD_DET then display skip 
            string ( SOD_LINE ) @ V1205 trim(SOD_PART) + "*" + String( SOD_DUE_DATE) @ WMESSAGE NO-LABEL with fram F1205.
                  else   display skip "" @ WMESSAGE with fram F1205.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        /* **SKIP TO MAIN LOOP START** */
        IF V1205 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        display  skip WMESSAGE NO-LABEL with fram F1205.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1205.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first SOD_DET where SOD_DOMAIN = V1001 AND SOD_NBR = V1100 AND string ( sod_line ) = V1205 and sod_site = V1002  no-lock no-error.
        IF NOT AVAILABLE SOD_DET then do:
                display skip "该项次有误!" @ WMESSAGE NO-LABEL with fram F1205.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1205.
        pause 0.
        leave V1205L.
     END.
     PV1205 = V1205.
     /* END    LINE :1205  订单项次  */


     /* START  LINE :1300  成品[Finished Goods]  */
     V1300L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1300           as char format "x(150)".
        define variable PV1300          as char format "x(150)".
        define variable L13001          as char format "x(40)".
        define variable L13002          as char format "x(40)".
        define variable L13003          as char format "x(40)".
        define variable L13004          as char format "x(40)".
        define variable L13005          as char format "x(40)".
        define variable L13006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first sod_det where sod_domain = V1001 and sod_nbr = V1100  and sod_site = V1002 and string ( sod_line ) = V1205 no-lock no-error.
If AVAILABLE (sod_det) then
        V1300 = sod_part.
        V1300 = ENTRY(1,V1300,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1300 = ENTRY(1,V1300,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售标签补打]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1300 width 150 no-box.

                /* LABEL 1 - START */ 
                find first sod_det where sod_domain = V1001 and sod_nbr = V1100  and sod_site = V1002 and string ( sod_line ) = V1205 no-lock no-error.
If AVAILABLE (sod_det) then
                L13001 = "图号:" + sod_part .
                else L13001 = "" . 
                display L13001          format "x(40)" skip with fram F1300 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find first pt_mstr where pt_domain = V1001 and pt_part = V1300 no-lock no-error.
If AVAILABLE (pt_mstr) then
                L13002 = "名称:" + trim ( pt_desc1 ) .
                else L13002 = "" . 
                display L13002          format "x(40)" skip with fram F1300 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first cp_mstr where cp_domain = V1001 and  cp_cust = V1110 and cp_part = V1300 no-lock no-error.
If AVAILABLE (cp_mstr) then
                L13003 = "客料:" + Trim(cp_cust_part) .
                else L13003 = "" . 
                display L13003          format "x(40)" skip with fram F1300 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                find first cp_mstr where cp_domain = V1001 and cp_cust = V1110 and cp_part = V1300 no-lock no-error.
If AVAILABLE (cp_mstr) then
                L13004 = Trim(cp_cust_partd) .
                else L13004 = "" . 
                display L13004          format "x(40)" skip with fram F1300 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1300 width 150 no-box.
        Update V1300
        WITH  fram F1300 NO-LABEL
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
        IF V1300 = "e" THEN  LEAVE V1205LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1300.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first SOD_DET where SOD_DOMAIN = V1001 AND SOD_LINE = integer( V1205 ) and SOD_NBR = V1100 and sod_site = V1002 and SOD_PART = ENTRY(1, V1300, "@")  no-lock no-error.
        IF NOT AVAILABLE SOD_DET then do:
                display skip "图号不对应" @ WMESSAGE NO-LABEL with fram F1300.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
        leave V1300L.
     END.
     IF INDEX(V1300,"@" ) = 0 then V1300 = V1300 + "@".
     PV1300 = V1300.
     V1300 = ENTRY(1,V1300,"@").
     /* END    LINE :1300  成品[Finished Goods]  */


     /* START  LINE :1500  批号[LOT]  */
     V1500L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1500           as char format "x(150)".
        define variable PV1500          as char format "x(150)".
        define variable L15001          as char format "x(40)".
        define variable L15002          as char format "x(40)".
        define variable L15003          as char format "x(40)".
        define variable L15004          as char format "x(40)".
        define variable L15005          as char format "x(40)".
        define variable L15006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        if INDEX(PV1300,"@") <> 0 then
        V1500 = ENTRY(2, PV1300, "@").
        V1500 = ENTRY(1,V1500,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1500 = ENTRY(1,V1500,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售标签补打]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1500 width 150 no-box.

                /* LABEL 1 - START */ 
                L15001 = "批号?" .
                display L15001          format "x(40)" skip with fram F1500 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L15002 = "" . 
                display L15002          format "x(40)" skip with fram F1500 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L15003 = "" . 
                display L15003          format "x(40)" skip with fram F1500 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L15004 = "" . 
                display L15004          format "x(40)" skip with fram F1500 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1500 width 150 no-box.
        Update V1500
        WITH  fram F1500 NO-LABEL
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
        IF V1500 = "e" THEN  LEAVE V1205LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1500.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1500.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1500.
        pause 0.
        leave V1500L.
     END.
     IF INDEX(V1500,"@" ) <> 0 then V1500 = ENTRY(2,V1500,"@").
     PV1500 = V1500.
     /* END    LINE :1500  批号[LOT]  */


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
                display "[销售标签补打]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1600 width 150 no-box.

                /* LABEL 1 - START */ 
                L16001 = "发货数量?" .
                display L16001          format "x(40)" skip with fram F1600 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find first so_mstr where so_domain = V1001 and so_nbr = V1100  no-lock no-error.
If AVAILABLE (so_mstr) then
                L16002 = "PO #:" + trim( so_po ) .
                else L16002 = "" . 
                display L16002          format "x(40)" skip with fram F1600 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first cp_mstr where cp_domain = V1001 and cp_cust = V1110 and cp_part = V1300 no-lock no-error.
If AVAILABLE (cp_mstr) then
                L16003 = "客料:" + Trim(cp_cust_part) .
                else L16003 = "" . 
                display L16003          format "x(40)" skip with fram F1600 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L16004 = "客户:" +  trim ( V1110 ) .
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
        IF V1600 = "e" THEN  LEAVE V1205LMAINLOOP.
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
     /* END    LINE :1600  数量[QTY]  */


     /* START  LINE :9010  OK  */
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
        V9010 = "A".
        V9010 = ENTRY(1,V9010,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9010 = ENTRY(1,V9010,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售标签补打]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9010 width 150 no-box.

                /* LABEL 1 - START */ 
                  L90101 = "" . 
                display L90101          format "x(40)" skip with fram F9010 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L90102 = "" . 
                display L90102          format "x(40)" skip with fram F9010 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L90103 = "" . 
                display L90103          format "x(40)" skip with fram F9010 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L90104 = "A/M-自/手动打印" .
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
        IF V9010 = "e" THEN  LEAVE V1205LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9010.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9010.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not INDEX("AME",V9010) <> 0 THEN DO:
                display skip "输入A M E" @ WMESSAGE NO-LABEL with fram F9010.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9010.
        pause 0.
        leave V9010L.
     END.
     PV9010 = V9010.
     /* END    LINE :9010  OK  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1205LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :9010    */
   END.
   pause 0 before-hide.
     /* START  LINE :9109  输出到打印机的条码上的数量  */
     V9109L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9109           as char format "x(150)".
        define variable PV9109          as char format "x(150)".
        define variable L91091          as char format "x(40)".
        define variable L91092          as char format "x(40)".
        define variable L91093          as char format "x(40)".
        define variable L91094          as char format "x(40)".
        define variable L91095          as char format "x(40)".
        define variable L91096          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V9109 = "0".
        V9109 = ENTRY(1,V9109,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9109 = ENTRY(1,V9109,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF 1 = 1 THEN
        leave V9109L.
        /* LOGICAL SKIP END */
                display "[销售标签补打]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9109 width 150 no-box.

                /* LABEL 1 - START */ 
                  L91091 = "" . 
                display L91091          format "x(40)" skip with fram F9109 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L91092 = "" . 
                display L91092          format "x(40)" skip with fram F9109 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L91093 = "" . 
                display L91093          format "x(40)" skip with fram F9109 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L91094 = "" . 
                display L91094          format "x(40)" skip with fram F9109 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9109 width 150 no-box.
        Update V9109
        WITH  fram F9109 NO-LABEL
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
        IF V9109 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9109.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9109.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9109.
        pause 0.
        leave V9109L.
     END.
     PV9109 = V9109.
     /* END    LINE :9109  输出到打印机的条码上的数量  */


   /* Internal Cycle Input :9110    */
   V9110LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle9110    */
   IF NOT (V9010 = "A" ) THEN LEAVE V9110LMAINLOOP.
     /* START  LINE :9110  条码上数量[QTY ON LABEL] AUTO  */
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
        V9110 = string ( decimal ( V1600 ) ).
        V9110 = ENTRY(1,V9110,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9110 = ENTRY(1,V9110,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售标签补打]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9110 width 150 no-box.

                /* LABEL 1 - START */ 
                find first sod_det where sod_domain = V1001 and sod_nbr = V1100 and string ( sod_line ) = V1205  no-lock no-error.
If AVAILABLE ( pt_mstr ) then
                L91101 = sod_um + " 标签上数量[自动]?" .
                else L91101 = "" . 
                display L91101          format "x(40)" skip with fram F9110 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L91102 = "MFG图号:" + trim ( V1300 ) .
                display L91102          format "x(40)" skip with fram F9110 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first cp_mstr where cp_domain = V1001 and cp_cust = V1110 and cp_part = V1300 no-lock no-error.
If AVAILABLE (cp_mstr) then
                L91103 = "客料:" + Trim(cp_cust_part) .
                else L91103 = "" . 
                display L91103          format "x(40)" skip with fram F9110 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                find first so_mstr where so_domain = V1001 and so_nbr = V1100  no-lock no-error.
If AVAILABLE (so_mstr) then
                L91104 = "PO #:" + trim( so_po ) .
                else L91104 = "" . 
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
     /* END    LINE :9110  条码上数量[QTY ON LABEL] AUTO  */


     /* START  LINE :9120  条码个数[No Of Label] AUTO  */
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
        V9120 = string ( integer ( decimal(V1600)  / decimal ( V9110 ) - 0.5 ) ).
        V9120 = ENTRY(1,V9120,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9120 = ENTRY(1,V9120,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF 1 = 1 THEN
        leave V9120L.
        /* LOGICAL SKIP END */
                display "[销售标签补打]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9120 width 150 no-box.

                /* LABEL 1 - START */ 
                L91201 = "标签个数?" .
                display L91201          format "x(40)" skip with fram F9120 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L91202 = "图号:" + trim( V1300 ) .
                display L91202          format "x(40)" skip with fram F9120 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L91203 = "批号:" + Trim(V1500) .
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
     /* END    LINE :9120  条码个数[No Of Label] AUTO  */


   wtm_num = V9120.
     /* START  LINE :9130  打印机[Printer] AUTO  */
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
        find first upd_det where upd_nbr = "inv80" and upd_select = 99 no-lock no-error.
If AVAILABLE ( upd_det ) then
        V9130 = UPD_DEV.
        V9130 = ENTRY(1,V9130,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9130 = ENTRY(1,V9130,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V9109 = V9110. 
IF 1 <> 1 THEN
        leave V9130L.
        /* LOGICAL SKIP END */
                display "[销售标签补打]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9130 width 150 no-box.

                /* LABEL 1 - START */ 
                L91301 = "打印机?" .
                display L91301          format "x(40)" skip with fram F9130 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L91302 = "条码上数量:" + trim ( V9110 ) .
                display L91302          format "x(40)" skip with fram F9130 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L91303 = "条码个数:" + trim ( V9120) .
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
                              PRD_DEV >=  INPUT V9130
                               no-lock no-error.
                  else do: 
                       if PRD_DEV =  INPUT V9130
                       then find next PRD_DET
                        no-lock no-error.
                        else find first PRD_DET where 
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
                              PRD_DEV <=  INPUT V9130
                               no-lock no-error.
                  else do: 
                       if PRD_DEV =  INPUT V9130
                       then find prev PRD_DET
                        no-lock no-error.
                        else find first PRD_DET where 
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
        find first PRD_DET where PRD_DEV = V9130  no-lock no-error.
        IF NOT AVAILABLE PRD_DET then do:
                display skip "打印机有误 " @ WMESSAGE NO-LABEL with fram F9130.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9130.
        pause 0.
        leave V9130L.
     END.
     PV9130 = V9130.
     /* END    LINE :9130  打印机[Printer] AUTO  */


     Define variable ts9130 AS CHARACTER FORMAT "x(100)".
     Define variable av9130 AS CHARACTER FORMAT "x(100)".
     PROCEDURE inv809130l.
        /* Define Labels Path  Start */
        Define variable LabelsPath as character format "x(100)" init "/app/bc/labels/".
        Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath"no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath = trim ( code_cmmt ).
        If substring(LabelsPath, length(LabelsPath), 1) <> "/" Then 
        LabelsPath = LabelsPath + "/".
        /* Define Labels Path  END */
     INPUT FROM VALUE(LabelsPath + "inv80").
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
     output to value( trim(wsection) + ".l") .
     Do While True:
              IMPORT UNFORMATTED ts9130.
        av9130 = V9110.
       IF INDEX(ts9130,"$Q") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$Q") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$Q") + length("$Q"), LENGTH(ts9130) - ( index(ts9130 ,"$Q" ) + length("$Q") - 1 ) ).
       END.
       find first cp_mstr where cp_domain = V1001 and cp_cust = V1110 and cp_cust_part <> "" and cp_part = V1300  no-lock no-error.
        av9130 = If AVAILABLE ( cp_mstr )  then  trim ( cp_cust_part ) else "".
       IF INDEX(ts9130,"$X") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$X") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$X") + length("$X"), LENGTH(ts9130) - ( index(ts9130 ,"$X" ) + length("$X") - 1 ) ).
       END.
        av9130 = string(today).
       IF INDEX(ts9130,"$D") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$D") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$D") + length("$D"), LENGTH(ts9130) - ( index(ts9130 ,"$D" ) + length("$D") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = string ( pt_net_wt ) + trim ( pt_net_wt_um ).
       IF INDEX(ts9130,"&N") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&N") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"&N") + length("&N"), LENGTH(ts9130) - ( index(ts9130 ,"&N" ) + length("&N") - 1 ) ).
       END.
       find first ad_mstr where ad_domain = V1001 and ad_addr = V1110  no-lock no-error.
If AVAILABLE ( ad_mstr )  then
        av9130 = trim ( ad_name ).
       IF INDEX(ts9130,"$N") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$N") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$N") + length("$N"), LENGTH(ts9130) - ( index(ts9130 ,"$N" ) + length("$N") - 1 ) ).
       END.
        av9130 = trim(V1300) + "@" + trim (V1500).
       IF INDEX(ts9130,"&B") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&B") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"&B") + length("&B"), LENGTH(ts9130) - ( index(ts9130 ,"&B" ) + length("&B") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = trim(pt_desc2).
       IF INDEX(ts9130,"$E") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$E") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$E") + length("$E"), LENGTH(ts9130) - ( index(ts9130 ,"$E" ) + length("$E") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = trim(pt_desc1).
       IF INDEX(ts9130,"$F") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$F") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$F") + length("$F"), LENGTH(ts9130) - ( index(ts9130 ,"$F" ) + length("$F") - 1 ) ).
       END.
        av9130 = V1300.
       IF INDEX(ts9130,"$P") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$P") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$P") + length("$P"), LENGTH(ts9130) - ( index(ts9130 ,"$P" ) + length("$P") - 1 ) ).
       END.
        av9130 = " ".
       IF INDEX(ts9130,"&D") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&D") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"&D") + length("&D"), LENGTH(ts9130) - ( index(ts9130 ,"&D" ) + length("&D") - 1 ) ).
       END.
       find first so_mstr where so_domain = V1001 and so_nbr = V1100  no-lock no-error.
If AVAILABLE ( so_mstr )  then
        av9130 = so_po.
       IF INDEX(ts9130,"$C") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$C") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$C") + length("$C"), LENGTH(ts9130) - ( index(ts9130 ,"$C" ) + length("$C") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = if trim ( pt_drwg_loc ) = "RoHs" then trim ( pt_drwg_loc ) else "".
       IF INDEX(ts9130,"&R") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&R") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"&R") + length("&R"), LENGTH(ts9130) - ( index(ts9130 ,"&R" ) + length("&R") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = string ( pt_ship_wt ) + trim ( pt_ship_wt_um ).
       IF INDEX(ts9130,"&G") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&G") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"&G") + length("&G"), LENGTH(ts9130) - ( index(ts9130 ,"&G" ) + length("&G") - 1 ) ).
       END.
       put unformatted ts9130 skip.
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.
     unix silent value ("chmod 777  " + trim(wsection) + ".l").
     END PROCEDURE.
     run inv809130l.
     do i = 1 to integer(wtm_num):
       find first PRD_DET where PRD_DEV = V9130 no-lock no-error.
       IF AVAILABLE PRD_DET then do:
         unix silent value (trim(prd_path) + " " + trim(wsection) + ".l").
         unix silent value ( "clear").
       end.
     End.
   /* Without Condition Exit Cycle Start */ 
   LEAVE V9110LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :9130    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :9140    */
   V9140LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle9140    */
   IF NOT (V9010 = "A" AND ( decimal ( V9110 ) * decimal ( V9120 )  <> decimal ( V1600 ) ) ) THEN LEAVE V9140LMAINLOOP.
     /* START  LINE :9140  条码上余数[QTY ON LABEL] 余数  */
     V9140L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9140           as char format "x(150)".
        define variable PV9140          as char format "x(150)".
        define variable L91401          as char format "x(40)".
        define variable L91402          as char format "x(40)".
        define variable L91403          as char format "x(40)".
        define variable L91404          as char format "x(40)".
        define variable L91405          as char format "x(40)".
        define variable L91406          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V9140 = string  ( decimal ( V1600 ) - decimal ( V9110 ) * decimal ( V9120 ) ).
        V9140 = ENTRY(1,V9140,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9140 = ENTRY(1,V9140,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF 1= 1 THEN
        leave V9140L.
        /* LOGICAL SKIP END */
                display "[销售标签补打]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9140 width 150 no-box.

                /* LABEL 1 - START */ 
                find first sod_det where sod_domain = V1001 and sod_nbr = V1100 and string ( sod_line ) = V1205  no-lock no-error.
If AVAILABLE ( sod_det ) then
                L91401 = sod_um + " 标签上数量?" .
                else L91401 = "" . 
                display L91401          format "x(40)" skip with fram F9140 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L91402 = "MFG图号:" + trim ( V1300 ) .
                display L91402          format "x(40)" skip with fram F9140 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first cp_mstr where cp_domain = V1001 and cp_cust = V1110 and cp_part = V1300 no-lock no-error.
If AVAILABLE (cp_mstr) then
                L91403 = "客料:" + Trim(cp_cust_part) .
                else L91403 = "" . 
                display L91403          format "x(40)" skip with fram F9140 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                find first so_mstr where so_domain = V1001 and so_nbr = V1100  no-lock no-error.
If AVAILABLE (so_mstr) then
                L91404 = "PO #:" + trim( so_po ) .
                else L91404 = "" . 
                display L91404          format "x(40)" skip with fram F9140 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9140 width 150 no-box.
        Update V9140
        WITH  fram F9140 NO-LABEL
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
        IF V9140 = "e" THEN  LEAVE V9140LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9140.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9140.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        If V9140 = "" OR V9140 = "-" OR V9140 = "." OR V9140 = ".-" OR V9140 = "-." then do:
                display skip "CAN NOT EMPTY  " @ WMESSAGE NO-LABEL with fram F9140.
                pause 0 before-hide.
                undo, retry.
        end.
        DO i = 1 to length(V9140).
                If index("0987654321.-", substring(V9140,i,1)) = 0 then do:
                display skip "Format  Error  " @ WMESSAGE NO-LABEL with fram F9140.
                pause 0 before-hide.
                undo, retry.
                end.
        end.
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9140.
        pause 0.
        leave V9140L.
     END.
     PV9140 = V9140.
     /* END    LINE :9140  条码上余数[QTY ON LABEL] 余数  */


     /* START  LINE :9150  条码个数[No Of Label] 余数  */
     V9150L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9150           as char format "x(150)".
        define variable PV9150          as char format "x(150)".
        define variable L91501          as char format "x(40)".
        define variable L91502          as char format "x(40)".
        define variable L91503          as char format "x(40)".
        define variable L91504          as char format "x(40)".
        define variable L91505          as char format "x(40)".
        define variable L91506          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V9150 = "1".
        V9150 = ENTRY(1,V9150,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9150 = ENTRY(1,V9150,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF 1 = 1 THEN
        leave V9150L.
        /* LOGICAL SKIP END */
                display "[销售标签补打]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9150 width 150 no-box.

                /* LABEL 1 - START */ 
                L91501 = "标签个数?" .
                display L91501          format "x(40)" skip with fram F9150 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L91502 = "图号:" + trim( V1300 ) .
                display L91502          format "x(40)" skip with fram F9150 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L91503 = "批号:" + Trim(V1500) .
                display L91503          format "x(40)" skip with fram F9150 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L91504 = "" . 
                display L91504          format "x(40)" skip with fram F9150 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9150 width 150 no-box.
        Update V9150
        WITH  fram F9150 NO-LABEL
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
        IF V9150 = "e" THEN  LEAVE V9140LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9150.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9150.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        If V9150 = "" OR V9150 = "-" OR V9150 = "." OR V9150 = ".-" OR V9150 = "-." then do:
                display skip "CAN NOT EMPTY  " @ WMESSAGE NO-LABEL with fram F9150.
                pause 0 before-hide.
                undo, retry.
        end.
        DO i = 1 to length(V9150).
                If index("0987654321.-", substring(V9150,i,1)) = 0 then do:
                display skip "Format  Error  " @ WMESSAGE NO-LABEL with fram F9150.
                pause 0 before-hide.
                undo, retry.
                end.
        end.
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9150.
        pause 0.
        leave V9150L.
     END.
     PV9150 = V9150.
     /* END    LINE :9150  条码个数[No Of Label] 余数  */


   wtm_num = V9150.
     /* START  LINE :9160  打印机[Printer] 余数  */
     V9160L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9160           as char format "x(150)".
        define variable PV9160          as char format "x(150)".
        define variable L91601          as char format "x(40)".
        define variable L91602          as char format "x(40)".
        define variable L91603          as char format "x(40)".
        define variable L91604          as char format "x(40)".
        define variable L91605          as char format "x(40)".
        define variable L91606          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first upd_det where upd_nbr = "INV80" and upd_select = 99 no-lock no-error.
If AVAILABLE ( upd_det ) then
        V9160 = UPD_DEV.
        V9160 = ENTRY(1,V9160,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9160 = ENTRY(1,V9160,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V9109 = V9140. 
IF 1 <> 1 THEN
        leave V9160L.
        /* LOGICAL SKIP END */
                display "[销售标签补打]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9160 width 150 no-box.

                /* LABEL 1 - START */ 
                L91601 = "打印机?" .
                display L91601          format "x(40)" skip with fram F9160 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L91602 = "条码上余数:" + trim ( V9140 ) .
                display L91602          format "x(40)" skip with fram F9160 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L91603 = "条码个数:" + trim ( V9150) .
                display L91603          format "x(40)" skip with fram F9160 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L91604 = "" . 
                display L91604          format "x(40)" skip with fram F9160 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9160 width 150 no-box.
        recid(PRD_DET) = ?.
        Update V9160
        WITH  fram F9160 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F9160.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(PRD_DET) = ? THEN find first PRD_DET where 
                              PRD_DEV >=  INPUT V9160
                               no-lock no-error.
                  else do: 
                       if PRD_DEV =  INPUT V9160
                       then find next PRD_DET
                        no-lock no-error.
                        else find first PRD_DET where 
                              PRD_DEV >=  INPUT V9160
                               no-lock no-error.
                  end.
                  IF AVAILABLE PRD_DET then display skip 
            PRD_DEV @ V9160 PRD_DESC @ WMESSAGE NO-LABEL with fram F9160.
                  else   display skip "" @ WMESSAGE with fram F9160.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(PRD_DET) = ? THEN find last PRD_DET where 
                              PRD_DEV <=  INPUT V9160
                               no-lock no-error.
                  else do: 
                       if PRD_DEV =  INPUT V9160
                       then find prev PRD_DET
                        no-lock no-error.
                        else find first PRD_DET where 
                              PRD_DEV >=  INPUT V9160
                               no-lock no-error.
                  end.
                  IF AVAILABLE PRD_DET then display skip 
            PRD_DEV @ V9160 PRD_DESC @ WMESSAGE NO-LABEL with fram F9160.
                  else   display skip "" @ WMESSAGE with fram F9160.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V9160 = "e" THEN  LEAVE V9140LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9160.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9160.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first PRD_DET where PRD_DEV = V9160  no-lock no-error.
        IF NOT AVAILABLE PRD_DET then do:
                display skip "打印机有误 " @ WMESSAGE NO-LABEL with fram F9160.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9160.
        pause 0.
        leave V9160L.
     END.
     PV9160 = V9160.
     /* END    LINE :9160  打印机[Printer] 余数  */


     Define variable ts9160 AS CHARACTER FORMAT "x(100)".
     Define variable av9160 AS CHARACTER FORMAT "x(100)".
     PROCEDURE inv809160l.
        /* Define Labels Path  Start */
        Define variable LabelsPath as character format "x(100)" init "/app/bc/labels/".
        Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath"no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath = trim ( code_cmmt ).
        If substring(LabelsPath, length(LabelsPath), 1) <> "/" Then 
        LabelsPath = LabelsPath + "/".
        /* Define Labels Path  END */
     INPUT FROM VALUE(LabelsPath + "inv80").
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
     output to value( trim(wsection) + ".l") .
     Do While True:
              IMPORT UNFORMATTED ts9160.
        av9160 = V9110.
       IF INDEX(ts9160,"$Q") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$Q") - 1) + av9160 
       + SUBSTRING( ts9160 , index(ts9160 ,"$Q") + length("$Q"), LENGTH(ts9160) - ( index(ts9160 ,"$Q" ) + length("$Q") - 1 ) ).
       END.
       find first cp_mstr where cp_domain = V1001 and cp_cust = V1110 and cp_cust_part <> "" and cp_part = V1300  no-lock no-error.
        av9160 = If AVAILABLE ( cp_mstr )  then  trim ( cp_cust_part ) else "".
       IF INDEX(ts9160,"$X") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$X") - 1) + av9160 
       + SUBSTRING( ts9160 , index(ts9160 ,"$X") + length("$X"), LENGTH(ts9160) - ( index(ts9160 ,"$X" ) + length("$X") - 1 ) ).
       END.
        av9160 = string(today).
       IF INDEX(ts9160,"$D") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$D") - 1) + av9160 
       + SUBSTRING( ts9160 , index(ts9160 ,"$D") + length("$D"), LENGTH(ts9160) - ( index(ts9160 ,"$D" ) + length("$D") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9160 = string ( pt_net_wt ) + trim ( pt_net_wt_um ).
       IF INDEX(ts9160,"&N") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "&N") - 1) + av9160 
       + SUBSTRING( ts9160 , index(ts9160 ,"&N") + length("&N"), LENGTH(ts9160) - ( index(ts9160 ,"&N" ) + length("&N") - 1 ) ).
       END.
       find first ad_mstr where ad_domain = V1001 and ad_addr = V1110  no-lock no-error.
If AVAILABLE ( ad_mstr )  then
        av9160 = trim ( ad_name ).
       IF INDEX(ts9160,"$N") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$N") - 1) + av9160 
       + SUBSTRING( ts9160 , index(ts9160 ,"$N") + length("$N"), LENGTH(ts9160) - ( index(ts9160 ,"$N" ) + length("$N") - 1 ) ).
       END.
        av9160 = trim(V1300) + "@" + trim (V1500).
       IF INDEX(ts9160,"&B") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "&B") - 1) + av9160 
       + SUBSTRING( ts9160 , index(ts9160 ,"&B") + length("&B"), LENGTH(ts9160) - ( index(ts9160 ,"&B" ) + length("&B") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9160 = trim(pt_desc2).
       IF INDEX(ts9160,"$E") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$E") - 1) + av9160 
       + SUBSTRING( ts9160 , index(ts9160 ,"$E") + length("$E"), LENGTH(ts9160) - ( index(ts9160 ,"$E" ) + length("$E") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9160 = trim(pt_desc1).
       IF INDEX(ts9160,"$F") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$F") - 1) + av9160 
       + SUBSTRING( ts9160 , index(ts9160 ,"$F") + length("$F"), LENGTH(ts9160) - ( index(ts9160 ,"$F" ) + length("$F") - 1 ) ).
       END.
        av9160 = V1300.
       IF INDEX(ts9160,"$P") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$P") - 1) + av9160 
       + SUBSTRING( ts9160 , index(ts9160 ,"$P") + length("$P"), LENGTH(ts9160) - ( index(ts9160 ,"$P" ) + length("$P") - 1 ) ).
       END.
        av9160 = " ".
       IF INDEX(ts9160,"&D") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "&D") - 1) + av9160 
       + SUBSTRING( ts9160 , index(ts9160 ,"&D") + length("&D"), LENGTH(ts9160) - ( index(ts9160 ,"&D" ) + length("&D") - 1 ) ).
       END.
       find first so_mstr where so_domain = V1001 and so_nbr = V1100  no-lock no-error.
If AVAILABLE ( so_mstr )  then
        av9160 = so_po.
       IF INDEX(ts9160,"$C") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$C") - 1) + av9160 
       + SUBSTRING( ts9160 , index(ts9160 ,"$C") + length("$C"), LENGTH(ts9160) - ( index(ts9160 ,"$C" ) + length("$C") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9160 = if trim ( pt_drwg_loc ) = "RoHs" then trim ( pt_drwg_loc ) else "".
       IF INDEX(ts9160,"&R") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "&R") - 1) + av9160 
       + SUBSTRING( ts9160 , index(ts9160 ,"&R") + length("&R"), LENGTH(ts9160) - ( index(ts9160 ,"&R" ) + length("&R") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9160 = string ( pt_ship_wt ) + trim ( pt_ship_wt_um ).
       IF INDEX(ts9160,"&G") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "&G") - 1) + av9160 
       + SUBSTRING( ts9160 , index(ts9160 ,"&G") + length("&G"), LENGTH(ts9160) - ( index(ts9160 ,"&G" ) + length("&G") - 1 ) ).
       END.
       put unformatted ts9160 skip.
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.
     unix silent value ("chmod 777  " + trim(wsection) + ".l").
     END PROCEDURE.
     run inv809160l.
     do i = 1 to integer(wtm_num):
       find first PRD_DET where PRD_DEV = V9160 no-lock no-error.
       IF AVAILABLE PRD_DET then do:
         unix silent value (trim(prd_path) + " " + trim(wsection) + ".l").
         unix silent value ( "clear").
       end.
     End.
   /* Without Condition Exit Cycle Start */ 
   LEAVE V9140LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :9160    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :9170    */
   V9170LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle9170    */
   IF NOT (V9010 = "M" ) THEN LEAVE V9170LMAINLOOP.
     /* START  LINE :9170  条码上数量[QTY ON LABEL] 手工  */
     V9170L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9170           as char format "x(150)".
        define variable PV9170          as char format "x(150)".
        define variable L91701          as char format "x(40)".
        define variable L91702          as char format "x(40)".
        define variable L91703          as char format "x(40)".
        define variable L91704          as char format "x(40)".
        define variable L91705          as char format "x(40)".
        define variable L91706          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V9170 = string ( decimal ( V1600 ) ).
        V9170 = ENTRY(1,V9170,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9170 = ENTRY(1,V9170,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售标签补打]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9170 width 150 no-box.

                /* LABEL 1 - START */ 
                find first sod_det where sod_domain = V1001 and sod_nbr = V1100 and string ( sod_line ) = V1205  no-lock no-error.
If AVAILABLE ( sod_det ) then
                L91701 = sod_um + " 标签上数量[手工]?" .
                else L91701 = "" . 
                display L91701          format "x(40)" skip with fram F9170 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L91702 = "MFG图号:" + trim ( V1300 ) .
                display L91702          format "x(40)" skip with fram F9170 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first cp_mstr where cp_domain = V1001 and  cp_cust = V1110 and cp_part = V1300 no-lock no-error.
If AVAILABLE (cp_mstr) then
                L91703 = "客料:" + Trim(cp_cust_part) .
                else L91703 = "" . 
                display L91703          format "x(40)" skip with fram F9170 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                find first so_mstr where so_domain = V1001 and so_nbr = V1100  no-lock no-error.
If AVAILABLE (so_mstr) then
                L91704 = "PO #:" + trim( so_po ) .
                else L91704 = "" . 
                display L91704          format "x(40)" skip with fram F9170 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9170 width 150 no-box.
        Update V9170
        WITH  fram F9170 NO-LABEL
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
        IF V9170 = "e" THEN  LEAVE V9170LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9170.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9170.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        If V9170 = "" OR V9170 = "-" OR V9170 = "." OR V9170 = ".-" OR V9170 = "-." then do:
                display skip "CAN NOT EMPTY  " @ WMESSAGE NO-LABEL with fram F9170.
                pause 0 before-hide.
                undo, retry.
        end.
        DO i = 1 to length(V9170).
                If index("0987654321.-", substring(V9170,i,1)) = 0 then do:
                display skip "Format  Error  " @ WMESSAGE NO-LABEL with fram F9170.
                pause 0 before-hide.
                undo, retry.
                end.
        end.
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9170.
        pause 0.
        leave V9170L.
     END.
     PV9170 = V9170.
     /* END    LINE :9170  条码上数量[QTY ON LABEL] 手工  */


     /* START  LINE :9180  条码个数[No Of Label] 手工  */
     V9180L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9180           as char format "x(150)".
        define variable PV9180          as char format "x(150)".
        define variable L91801          as char format "x(40)".
        define variable L91802          as char format "x(40)".
        define variable L91803          as char format "x(40)".
        define variable L91804          as char format "x(40)".
        define variable L91805          as char format "x(40)".
        define variable L91806          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V9180 = "1".
        V9180 = ENTRY(1,V9180,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9180 = ENTRY(1,V9180,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售标签补打]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9180 width 150 no-box.

                /* LABEL 1 - START */ 
                L91801 = "标签个数?" .
                display L91801          format "x(40)" skip with fram F9180 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L91802 = "图号:" + trim( V1300 ) .
                display L91802          format "x(40)" skip with fram F9180 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L91803 = "批号:" + Trim(V1500) .
                display L91803          format "x(40)" skip with fram F9180 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L91804 = "" . 
                display L91804          format "x(40)" skip with fram F9180 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9180 width 150 no-box.
        Update V9180
        WITH  fram F9180 NO-LABEL
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
        IF V9180 = "e" THEN  LEAVE V9170LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9180.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9180.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        If V9180 = "" OR V9180 = "-" OR V9180 = "." OR V9180 = ".-" OR V9180 = "-." then do:
                display skip "CAN NOT EMPTY  " @ WMESSAGE NO-LABEL with fram F9180.
                pause 0 before-hide.
                undo, retry.
        end.
        DO i = 1 to length(V9180).
                If index("0987654321.-", substring(V9180,i,1)) = 0 then do:
                display skip "Format  Error  " @ WMESSAGE NO-LABEL with fram F9180.
                pause 0 before-hide.
                undo, retry.
                end.
        end.
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9180.
        pause 0.
        leave V9180L.
     END.
     PV9180 = V9180.
     /* END    LINE :9180  条码个数[No Of Label] 手工  */


   wtm_num = V9180.
     /* START  LINE :9190  打印机[Printer] 手工  */
     V9190L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9190           as char format "x(150)".
        define variable PV9190          as char format "x(150)".
        define variable L91901          as char format "x(40)".
        define variable L91902          as char format "x(40)".
        define variable L91903          as char format "x(40)".
        define variable L91904          as char format "x(40)".
        define variable L91905          as char format "x(40)".
        define variable L91906          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first upd_det where upd_nbr = "INV80" and upd_select = 99 no-lock no-error.
If AVAILABLE ( upd_det ) then
        V9190 = UPD_DEV.
        V9190 = ENTRY(1,V9190,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9190 = ENTRY(1,V9190,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V9109 = V9170. 
IF 1 <> 1 THEN
        leave V9190L.
        /* LOGICAL SKIP END */
                display "[销售标签补打]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9190 width 150 no-box.

                /* LABEL 1 - START */ 
                L91901 = "打印机?" .
                display L91901          format "x(40)" skip with fram F9190 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L91902 = "" . 
                display L91902          format "x(40)" skip with fram F9190 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L91903 = "" . 
                display L91903          format "x(40)" skip with fram F9190 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L91904 = "" . 
                display L91904          format "x(40)" skip with fram F9190 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9190 width 150 no-box.
        recid(PRD_DET) = ?.
        Update V9190
        WITH  fram F9190 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F9190.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(PRD_DET) = ? THEN find first PRD_DET where 
                              PRD_DEV >=  INPUT V9190
                               no-lock no-error.
                  else do: 
                       if PRD_DEV =  INPUT V9190
                       then find next PRD_DET
                        no-lock no-error.
                        else find first PRD_DET where 
                              PRD_DEV >=  INPUT V9190
                               no-lock no-error.
                  end.
                  IF AVAILABLE PRD_DET then display skip 
            PRD_DEV @ V9190 PRD_DESC @ WMESSAGE NO-LABEL with fram F9190.
                  else   display skip "" @ WMESSAGE with fram F9190.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(PRD_DET) = ? THEN find last PRD_DET where 
                              PRD_DEV <=  INPUT V9190
                               no-lock no-error.
                  else do: 
                       if PRD_DEV =  INPUT V9190
                       then find prev PRD_DET
                        no-lock no-error.
                        else find first PRD_DET where 
                              PRD_DEV >=  INPUT V9190
                               no-lock no-error.
                  end.
                  IF AVAILABLE PRD_DET then display skip 
            PRD_DEV @ V9190 PRD_DESC @ WMESSAGE NO-LABEL with fram F9190.
                  else   display skip "" @ WMESSAGE with fram F9190.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V9190 = "e" THEN  LEAVE V9170LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9190.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9190.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first PRD_DET where PRD_DEV = V9190  no-lock no-error.
        IF NOT AVAILABLE PRD_DET then do:
                display skip "打印机有误 " @ WMESSAGE NO-LABEL with fram F9190.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9190.
        pause 0.
        leave V9190L.
     END.
     PV9190 = V9190.
     /* END    LINE :9190  打印机[Printer] 手工  */


     Define variable ts9190 AS CHARACTER FORMAT "x(100)".
     Define variable av9190 AS CHARACTER FORMAT "x(100)".
     PROCEDURE inv809190l.
        /* Define Labels Path  Start */
        Define variable LabelsPath as character format "x(100)" init "/app/bc/labels/".
        Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath"no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath = trim ( code_cmmt ).
        If substring(LabelsPath, length(LabelsPath), 1) <> "/" Then 
        LabelsPath = LabelsPath + "/".
        /* Define Labels Path  END */
     INPUT FROM VALUE(LabelsPath + "inv80").
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
     output to value( trim(wsection) + ".l") .
     Do While True:
              IMPORT UNFORMATTED ts9190.
        av9190 = V9110.
       IF INDEX(ts9190,"$Q") <> 0  THEN DO:
       TS9190 = substring(TS9190, 1, Index(TS9190 , "$Q") - 1) + av9190 
       + SUBSTRING( ts9190 , index(ts9190 ,"$Q") + length("$Q"), LENGTH(ts9190) - ( index(ts9190 ,"$Q" ) + length("$Q") - 1 ) ).
       END.
       find first cp_mstr where cp_domain = V1001 and cp_cust = V1110 and cp_cust_part <> "" and cp_part = V1300  no-lock no-error.
        av9190 = If AVAILABLE ( cp_mstr )  then  trim ( cp_cust_part ) else "".
       IF INDEX(ts9190,"$X") <> 0  THEN DO:
       TS9190 = substring(TS9190, 1, Index(TS9190 , "$X") - 1) + av9190 
       + SUBSTRING( ts9190 , index(ts9190 ,"$X") + length("$X"), LENGTH(ts9190) - ( index(ts9190 ,"$X" ) + length("$X") - 1 ) ).
       END.
        av9190 = string(today).
       IF INDEX(ts9190,"$D") <> 0  THEN DO:
       TS9190 = substring(TS9190, 1, Index(TS9190 , "$D") - 1) + av9190 
       + SUBSTRING( ts9190 , index(ts9190 ,"$D") + length("$D"), LENGTH(ts9190) - ( index(ts9190 ,"$D" ) + length("$D") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9190 = string ( pt_net_wt ) + trim ( pt_net_wt_um ).
       IF INDEX(ts9190,"&N") <> 0  THEN DO:
       TS9190 = substring(TS9190, 1, Index(TS9190 , "&N") - 1) + av9190 
       + SUBSTRING( ts9190 , index(ts9190 ,"&N") + length("&N"), LENGTH(ts9190) - ( index(ts9190 ,"&N" ) + length("&N") - 1 ) ).
       END.
       find first ad_mstr where ad_domain = V1001 and ad_addr = V1110  no-lock no-error.
If AVAILABLE ( ad_mstr )  then
        av9190 = trim ( ad_name ).
       IF INDEX(ts9190,"$N") <> 0  THEN DO:
       TS9190 = substring(TS9190, 1, Index(TS9190 , "$N") - 1) + av9190 
       + SUBSTRING( ts9190 , index(ts9190 ,"$N") + length("$N"), LENGTH(ts9190) - ( index(ts9190 ,"$N" ) + length("$N") - 1 ) ).
       END.
        av9190 = trim(V1300) + "@" + trim (V1500).
       IF INDEX(ts9190,"&B") <> 0  THEN DO:
       TS9190 = substring(TS9190, 1, Index(TS9190 , "&B") - 1) + av9190 
       + SUBSTRING( ts9190 , index(ts9190 ,"&B") + length("&B"), LENGTH(ts9190) - ( index(ts9190 ,"&B" ) + length("&B") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9190 = trim(pt_desc2).
       IF INDEX(ts9190,"$E") <> 0  THEN DO:
       TS9190 = substring(TS9190, 1, Index(TS9190 , "$E") - 1) + av9190 
       + SUBSTRING( ts9190 , index(ts9190 ,"$E") + length("$E"), LENGTH(ts9190) - ( index(ts9190 ,"$E" ) + length("$E") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9190 = trim(pt_desc1).
       IF INDEX(ts9190,"$F") <> 0  THEN DO:
       TS9190 = substring(TS9190, 1, Index(TS9190 , "$F") - 1) + av9190 
       + SUBSTRING( ts9190 , index(ts9190 ,"$F") + length("$F"), LENGTH(ts9190) - ( index(ts9190 ,"$F" ) + length("$F") - 1 ) ).
       END.
        av9190 = V1300.
       IF INDEX(ts9190,"$P") <> 0  THEN DO:
       TS9190 = substring(TS9190, 1, Index(TS9190 , "$P") - 1) + av9190 
       + SUBSTRING( ts9190 , index(ts9190 ,"$P") + length("$P"), LENGTH(ts9190) - ( index(ts9190 ,"$P" ) + length("$P") - 1 ) ).
       END.
        av9190 = " ".
       IF INDEX(ts9190,"&D") <> 0  THEN DO:
       TS9190 = substring(TS9190, 1, Index(TS9190 , "&D") - 1) + av9190 
       + SUBSTRING( ts9190 , index(ts9190 ,"&D") + length("&D"), LENGTH(ts9190) - ( index(ts9190 ,"&D" ) + length("&D") - 1 ) ).
       END.
       find first so_mstr where so_domain = V1001 and so_nbr = V1100  no-lock no-error.
If AVAILABLE ( so_mstr )  then
        av9190 = so_po.
       IF INDEX(ts9190,"$C") <> 0  THEN DO:
       TS9190 = substring(TS9190, 1, Index(TS9190 , "$C") - 1) + av9190 
       + SUBSTRING( ts9190 , index(ts9190 ,"$C") + length("$C"), LENGTH(ts9190) - ( index(ts9190 ,"$C" ) + length("$C") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9190 = if trim ( pt_drwg_loc ) = "RoHs" then trim ( pt_drwg_loc ) else "".
       IF INDEX(ts9190,"&R") <> 0  THEN DO:
       TS9190 = substring(TS9190, 1, Index(TS9190 , "&R") - 1) + av9190 
       + SUBSTRING( ts9190 , index(ts9190 ,"&R") + length("&R"), LENGTH(ts9190) - ( index(ts9190 ,"&R" ) + length("&R") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9190 = string ( pt_ship_wt ) + trim ( pt_ship_wt_um ).
       IF INDEX(ts9190,"&G") <> 0  THEN DO:
       TS9190 = substring(TS9190, 1, Index(TS9190 , "&G") - 1) + av9190 
       + SUBSTRING( ts9190 , index(ts9190 ,"&G") + length("&G"), LENGTH(ts9190) - ( index(ts9190 ,"&G" ) + length("&G") - 1 ) ).
       END.
       put unformatted ts9190 skip.
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.
     unix silent value ("chmod 777  " + trim(wsection) + ".l").
     END PROCEDURE.
     run inv809190l.
     do i = 1 to integer(wtm_num):
       find first PRD_DET where PRD_DEV = V9190 no-lock no-error.
       IF AVAILABLE PRD_DET then do:
         unix silent value (trim(prd_path) + " " + trim(wsection) + ".l").
         unix silent value ( "clear").
       end.
     End.
   /* Internal Cycle END :9190    */
   END.
   pause 0 before-hide.
end.
