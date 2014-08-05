/* Generate By Barcode Generator , Copyright by Softspeed - Build By Sam Song  */ 
/* SO Allocation */
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
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xssoa20wtimeout"
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
                display "[销售出货备料]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 width 150 no-box.

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


     /* START  LINE :1100  销售订单[SalesOrder]  */
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
                display "[销售出货备料]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1100 width 150 no-box.

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
            SO_NBR @ V1100 trim( SO_PO ) + "*" + string ( so_due_date ) @ WMESSAGE NO-LABEL with fram F1100.
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
            SO_NBR @ V1100 trim( SO_PO ) + "*" + string ( so_due_date ) @ WMESSAGE NO-LABEL with fram F1100.
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
        find first SO_MSTR where SO_DOMAIN = V1001 AND SO_NBR = V1100 AND ( SO_SITE = V1002 OR SO_SITE = "" )  NO-ERROR NO-WAIT.
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
     /* END    LINE :1100  销售订单[SalesOrder]  */


     /* START  LINE :1105  客户代码[Customer Code]  */
     V1105L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1105           as char format "x(150)".
        define variable PV1105          as char format "x(150)".
        define variable L11051          as char format "x(40)".
        define variable L11052          as char format "x(40)".
        define variable L11053          as char format "x(40)".
        define variable L11054          as char format "x(40)".
        define variable L11055          as char format "x(40)".
        define variable L11056          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first so_mstr where so_domain = V1001 and so_nbr  = V1100 no-lock no-error.
If AVAILABLE ( so_mstr ) then
        V1105 = so_cust.
        V1105 = ENTRY(1,V1105,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1105 = ENTRY(1,V1105,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1105L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1105L .
        /* --CYCLE TIME SKIP -- END  */

                display "[销售出货备料]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1105 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11051 = "" . 
                display L11051          format "x(40)" skip with fram F1105 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11052 = "" . 
                display L11052          format "x(40)" skip with fram F1105 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11053 = "" . 
                display L11053          format "x(40)" skip with fram F1105 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11054 = "" . 
                display L11054          format "x(40)" skip with fram F1105 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1105 width 150 no-box.
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
        IF V1105 = "e" THEN  LEAVE MAINLOOP.
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
     /* END    LINE :1105  客户代码[Customer Code]  */


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
        V1300 = " ".
        V1300 = ENTRY(1,V1300,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1300 = ENTRY(1,V1300,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售出货备料]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1300 width 150 no-box.

                /* LABEL 1 - START */ 
                L13001 = "货品[扫描]?" .
                display L13001          format "x(40)" skip with fram F1300 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find first so_mstr where so_domain = V1001 and  so_nbr = V1100 no-lock no-error.
If AVAILABLE ( so_mstr ) then
                L13002 = "PO #:" + trim ( so_po ) .
                else L13002 = "" . 
                display L13002          format "x(40)" skip with fram F1300 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first so_mstr where so_domain = V1001 and so_nbr = V1100 no-lock no-error.
If AVAILABLE ( so_mstr ) then
                L13003 = "客户:" + trim ( so_cust ) .
                else L13003 = "" . 
                display L13003          format "x(40)" skip with fram F1300 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                find first ad_mstr where ad_domain = V1001 and ad_addr = V1105 no-lock no-error.
If AVAILABLE ( ad_mstr ) then
                L13004 = trim ( ad_name ) .
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
        IF V1300 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1300.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first SOD_DET where SOD_DOMAIN = V1001 AND SOD_NBR = V1100 AND SOD_PART = ENTRY(1, V1300, "@")  no-lock no-error.
        IF NOT AVAILABLE SOD_DET then do:
                display skip "该成品不匹配,请查核!" @ WMESSAGE NO-LABEL with fram F1300.
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


   /* Internal Cycle Input :1305    */
   V1305LMAINLOOP:
   REPEAT:
     /* START  LINE :1305  订单项次  */
     V1305L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1305           as char format "x(150)".
        define variable PV1305          as char format "x(150)".
        define variable L13051          as char format "x(40)".
        define variable L13052          as char format "x(40)".
        define variable L13053          as char format "x(40)".
        define variable L13054          as char format "x(40)".
        define variable L13055          as char format "x(40)".
        define variable L13056          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first sod_det where sod_domain = V1001 AND sod_nbr = V1100 and sod_site = V1002 and sod_part = V1300 no-lock no-error.
If AVAILABLE (sod_det) and string ( sod_line ) <> V1305 then
        V1305 = string (sod_line ).
        V1305 = ENTRY(1,V1305,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1305 = ENTRY(1,V1305,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        find last sod_det where sod_domain = V1001 AND sod_nbr = V1100 and sod_site = V1002 AND sod_part = V1300 no-lock no-error.
If AVAILABLE (sod_det) and string ( sod_line ) = V1305 then
        leave V1305L.
        /* LOGICAL SKIP END */
                display "[销售出货备料]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1305 width 150 no-box.

                /* LABEL 1 - START */ 
                L13051 = "订单项次" .
                display L13051          format "x(40)" skip with fram F1305 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L13052 = "" . 
                display L13052          format "x(40)" skip with fram F1305 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L13053 = "" . 
                display L13053          format "x(40)" skip with fram F1305 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13054 = "" . 
                display L13054          format "x(40)" skip with fram F1305 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1305 width 150 no-box.
        recid(SOD_DET) = ?.
        Update V1305
        WITH  fram F1305 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1305.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(SOD_DET) = ? THEN find first SOD_DET where 
                              sod_domain = V1001 AND sod_nbr = V1100 and sod_site = V1002 AND  
                              string ( SOD_LINE ) >=  INPUT V1305
                               no-lock no-error.
                  else do: 
                       if string ( SOD_LINE ) =  INPUT V1305
                       then find next SOD_DET
                       WHERE sod_domain = V1001 AND sod_nbr = V1100 and sod_site = V1002
                        no-lock no-error.
                        else find first SOD_DET where 
                              sod_domain = V1001 AND sod_nbr = V1100 and sod_site = V1002 AND  
                              string ( SOD_LINE ) >=  INPUT V1305
                               no-lock no-error.
                  end.
                  IF AVAILABLE SOD_DET then display skip 
            string ( SOD_LINE ) @ V1305 trim(SOD_PART) + "*" + String( SOD_DUE_DATE) @ WMESSAGE NO-LABEL with fram F1305.
                  else   display skip "" @ WMESSAGE with fram F1305.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(SOD_DET) = ? THEN find last SOD_DET where 
                              sod_domain = V1001 AND sod_nbr = V1100 and sod_site = V1002 AND  
                              string ( SOD_LINE ) <=  INPUT V1305
                               no-lock no-error.
                  else do: 
                       if string ( SOD_LINE ) =  INPUT V1305
                       then find prev SOD_DET
                       where sod_domain = V1001 AND sod_nbr = V1100 and sod_site = V1002
                        no-lock no-error.
                        else find first SOD_DET where 
                              sod_domain = V1001 AND sod_nbr = V1100 and sod_site = V1002 AND  
                              string ( SOD_LINE ) >=  INPUT V1305
                               no-lock no-error.
                  end.
                  IF AVAILABLE SOD_DET then display skip 
            string ( SOD_LINE ) @ V1305 trim(SOD_PART) + "*" + String( SOD_DUE_DATE) @ WMESSAGE NO-LABEL with fram F1305.
                  else   display skip "" @ WMESSAGE with fram F1305.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        /* **SKIP TO MAIN LOOP START** */
        IF V1305 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        display  skip WMESSAGE NO-LABEL with fram F1305.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1305.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first SOD_DET where SOD_DOMAIN = V1001 AND SOD_NBR = V1100 AND string ( sod_line ) = V1305 and SOD_SITE = V1002  NO-ERROR NO-WAIT.
        IF NOT AVAILABLE SOD_DET then do:
                display skip "无效或被锁!" @ WMESSAGE NO-LABEL with fram F1305.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1305.
        pause 0.
        leave V1305L.
     END.
     PV1305 = V1305.
     /* END    LINE :1305  订单项次  */


     /* START  LINE :1309  Already Print Packing List  */
     V1309L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1309           as char format "x(150)".
        define variable PV1309          as char format "x(150)".
        define variable L13091          as char format "x(40)".
        define variable L13092          as char format "x(40)".
        define variable L13093          as char format "x(40)".
        define variable L13094          as char format "x(40)".
        define variable L13095          as char format "x(40)".
        define variable L13096          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1309 = "E".
        V1309 = ENTRY(1,V1309,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1309 = ENTRY(1,V1309,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        find first lad_det where lad_domain = V1001 AND lad_dataset = "sod_det" and lad_nbr = V1100 and lad_line = V1305 and lad_qty_pick <> 0 no-lock no-error.
If NOT AVAILABLE (lad_det) THEN
        leave V1309L.
        /* LOGICAL SKIP END */
                display "[销售出货备料]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1309 width 150 no-box.

                /* LABEL 1 - START */ 
                L13091 = "ERR:已打DN,不能备料" .
                display L13091          format "x(40)" skip with fram F1309 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L13092 = "请对已出DN的,先出货" .
                display L13092          format "x(40)" skip with fram F1309 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L13093 = "" . 
                display L13093          format "x(40)" skip with fram F1309 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13094 = "" . 
                display L13094          format "x(40)" skip with fram F1309 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1309 width 150 no-box.
        Update V1309
        WITH  fram F1309 NO-LABEL
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
        IF V1309 = "e" THEN  LEAVE V1305LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1309.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1309.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not Trim (V1309) = "E" THEN DO:
                display skip "Error , Retry " @ WMESSAGE NO-LABEL with fram F1309.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1309.
        pause 0.
        leave V1309L.
     END.
     PV1309 = V1309.
     /* END    LINE :1309  Already Print Packing List  */


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
        find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr ) then
        V1400 = pt_loc.
        V1400 = ENTRY(1,V1400,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1400 = ENTRY(1,V1400,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售出货备料]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1400 width 150 no-box.

                /* LABEL 1 - START */ 
                L14001 = "库位?" + pt_loc .
                display L14001          format "x(40)" skip with fram F1400 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L14002 = "" . 
                display L14002          format "x(40)" skip with fram F1400 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L14003 = "订单/项:" + trim ( V1100 ) + "/" + trim ( V1305 ) .
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
        IF V1400 = "e" THEN  LEAVE V1305LMAINLOOP.
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


     /* START  LINE :1410  L Control  */
     V1410L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1410           as char format "x(150)".
        define variable PV1410          as char format "x(150)".
        define variable L14101          as char format "x(40)".
        define variable L14102          as char format "x(40)".
        define variable L14103          as char format "x(40)".
        define variable L14104          as char format "x(40)".
        define variable L14105          as char format "x(40)".
        define variable L14106          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr ) then
        V1410 = pt_lot_ser.
        V1410 = ENTRY(1,V1410,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1410 = ENTRY(1,V1410,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1410L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1410L .
        /* --CYCLE TIME SKIP -- END  */

                display "[销售出货备料]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1410 width 150 no-box.

                /* LABEL 1 - START */ 
                  L14101 = "" . 
                display L14101          format "x(40)" skip with fram F1410 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L14102 = "" . 
                display L14102          format "x(40)" skip with fram F1410 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L14103 = "" . 
                display L14103          format "x(40)" skip with fram F1410 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L14104 = "" . 
                display L14104          format "x(40)" skip with fram F1410 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1410 width 150 no-box.
        /* DISPLAY ONLY */
        define variable X1410           as char format "x(40)".
        X1410 = V1410.
        V1410 = "".
        /* DISPLAY ONLY */
        Update V1410
        WITH  fram F1410 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V1410 = X1410.
        /* DISPLAY ONLY */
        LEAVE V1410L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1410 = "e" THEN  LEAVE V1305LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1410.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1410.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1410.
        pause 0.
        leave V1410L.
     END.
     PV1410 = V1410.
     /* END    LINE :1410  L Control  */


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
        V1500 = ( if ENTRY(2, PV1300, "@") = "" then "" else ENTRY(2, PV1300, "@") ).
        V1500 = ENTRY(1,V1500,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1500 = ENTRY(1,V1500,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF V1410 <> "L" then
        leave V1500L.
        /* LOGICAL SKIP END */
                display "[销售出货备料]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1500 width 150 no-box.

                /* LABEL 1 - START */ 
                L15001 = "备料批号?" .
                display L15001          format "x(40)" skip with fram F1500 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find first ld_det where ld_domain = V1001 and ld_part = V1300 and ld_loc = V1400 and ld_site = V1002 and ld_qty_oh <> 0 and ld_ref = "" use-index ld_part_lot no-lock no-error.
If AVAILABLE ( ld_det ) then
                L15002 = "最小:" + trim(ld_lot) .
                else L15002 = "" . 
                display L15002          format "x(40)" skip with fram F1500 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first ld_det where ld_domain = V1001 and ld_part = V1300 and ld_loc = V1400 and ld_site = V1002 and ld_qty_oh <> 0 use-index ld_part_lot no-lock no-error.
If AVAILABLE ( ld_det ) then
                L15003 = "库存:" + trim(string(ld_qty_oh)) .
                else L15003 = "" . 
                display L15003          format "x(40)" skip with fram F1500 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L15004 = "图号:" + trim( V1300 ) .
                display L15004          format "x(40)" skip with fram F1500 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1500 width 150 no-box.
        recid(LD_DET) = ?.
        Update V1500
        WITH  fram F1500 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1500.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(LD_DET) = ? THEN find first LD_DET where 
                              LD_DOMAIN = V1001 AND LD_PART = V1300 AND LD_LOC = V1400 AND LD_QTY_OH <> 0 AND LD_SITE = V1002 AND ( LD_REF = "" OR LD_REF = V1100) AND  
                              LD_LOT >=  INPUT V1500
                               no-lock no-error.
                  else do: 
                       if LD_LOT =  INPUT V1500
                       then find next LD_DET
                       WHERE LD_DOMAIN = V1001 AND LD_PART = V1300 AND LD_LOC = V1400 AND LD_QTY_OH <> 0 AND LD_SITE = V1002 AND ( LD_REF = "" OR LD_REF = V1100)
                        no-lock no-error.
                        else find first LD_DET where 
                              LD_DOMAIN = V1001 AND LD_PART = V1300 AND LD_LOC = V1400 AND LD_QTY_OH <> 0 AND LD_SITE = V1002 AND ( LD_REF = "" OR LD_REF = V1100) AND  
                              LD_LOT >=  INPUT V1500
                               no-lock no-error.
                  end.
                  IF AVAILABLE LD_DET then display skip 
            LD_LOT @ V1500 (IF LD_REF = "" THEN "可" ELSE "已" ) + "备L/Q:" + LD_LOT + "/" + trim(string(LD_QTY_OH)) @ WMESSAGE NO-LABEL with fram F1500.
                  else   display skip "" @ WMESSAGE with fram F1500.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(LD_DET) = ? THEN find last LD_DET where 
                              LD_DOMAIN = V1001 AND LD_PART = V1300 AND LD_LOC = V1400 AND LD_QTY_OH <> 0 AND LD_SITE = V1002 AND ( LD_REF = "" OR LD_REF = V1100) AND  
                              LD_LOT <=  INPUT V1500
                               no-lock no-error.
                  else do: 
                       if LD_LOT =  INPUT V1500
                       then find prev LD_DET
                       where LD_DOMAIN = V1001 AND LD_PART = V1300 AND LD_LOC = V1400 AND LD_QTY_OH <> 0 AND LD_SITE = V1002 AND ( LD_REF = "" OR LD_REF = V1100)
                        no-lock no-error.
                        else find first LD_DET where 
                              LD_DOMAIN = V1001 AND LD_PART = V1300 AND LD_LOC = V1400 AND LD_QTY_OH <> 0 AND LD_SITE = V1002 AND ( LD_REF = "" OR LD_REF = V1100) AND  
                              LD_LOT >=  INPUT V1500
                               no-lock no-error.
                  end.
                  IF AVAILABLE LD_DET then display skip 
            LD_LOT @ V1500 (IF LD_REF = "" THEN "可" ELSE "已" ) + "备L/Q:" + LD_LOT + "/" + trim(string(LD_QTY_OH)) @ WMESSAGE NO-LABEL with fram F1500.
                  else   display skip "" @ WMESSAGE with fram F1500.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1500 = "e" THEN  LEAVE V1305LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1500.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1500.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not ( IF INDEX(V1500,"@" ) <> 0 then ENTRY(2,V1500,"@") else V1500 ) <> "" THEN DO:
                display skip "L控制,不能为空" @ WMESSAGE NO-LABEL with fram F1500.
                pause 0 before-hide.
                undo, retry.
        end.
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
                display "[销售出货备料]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1600 width 150 no-box.

                /* LABEL 1 - START */ 
                L16001 = "追加备料数量?" .
                display L16001          format "x(40)" skip with fram F1600 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find first sod_det where sod_domain = V1001 and sod_nbr = V1100 and string ( sod_line ) = V1305 no-lock no-error.
If AVAILABLE ( sod_det ) then
                L16002 = "订单/已出:" + string ( sod_qty_ord ) + "/" + string (sod_qty_ship) .
                else L16002 = "" . 
                display L16002          format "x(40)" skip with fram F1600 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first sod_det where sod_domain = V1001 and sod_nbr = V1100 and string ( sod_line ) = V1305 no-lock no-error.
If AVAILABLE ( sod_det ) then
                L16003 = "已备/捡量:" + string (sod_qty_all) + "/" + string ( sod_qty_pick ) .
                else L16003 = "" . 
                display L16003          format "x(40)" skip with fram F1600 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                find last ld_det where ld_domain = V1001 and ld_part = V1300 and ld_loc = V1400 and ld_site = V1002 and ld_qty_oh <> 0 and ld_lot = V1500 and ( ld_ref = "" OR ld_ref = V1100 ) use-index ld_part_lot no-lock no-error.
If AVAILABLE ( ld_det ) then
                L16004 = "批号/" + ( if ld_ref = "" then "可" else "已" ) + "备:" + V1500 + "/" +  string (ld_Qty_oh) .
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
        IF V1600 = "e" THEN  LEAVE V1305LMAINLOOP.
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
        find first LD_DET where ld_domain = V1001 AND ld_part  = V1300 AND ld_loc = V1400 and 
ld_site = V1002 and ld_lot = V1500 and  ( DECIMAL ( V1600 ) < 0 and ld_ref = V1100 and (ld_qty_oh + DECIMAL ( V1600 ) >= 0)
  OR
  DECIMAL ( V1600 ) > 0 and ld_ref = "" and ld_qty_oh >= DECIMAL ( V1600 )
  )  no-lock no-error.
        IF NOT AVAILABLE LD_DET then do:
                display skip "可/已备数 <: " + string( V1600 ) @ WMESSAGE NO-LABEL with fram F1600.
                pause 0 before-hide.
                undo, retry.
        end.
        IF not V1600 <> "0" THEN DO:
                display skip "可/已备数 <: " + string( V1600 ) @ WMESSAGE NO-LABEL with fram F1600.
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
                display "[销售出货备料]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1700 width 150 no-box.

                /* LABEL 1 - START */ 
                L17001 = "图号:" + trim(V1300) .
                display L17001          format "x(40)" skip with fram F1700 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L17002 = "批号:" + trim ( V1500 ) .
                display L17002          format "x(40)" skip with fram F1700 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L17003 = "库位:" + trim ( V1400 ) + "/" + trim( V1600 ) .
                display L17003          format "x(40)" skip with fram F1700 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                find first sod_det where sod_domain = V1001 and  sod_nbr = V1100 and sod_line = integer ( V1305 )  no-lock no-error.
If AVAILABLE ( sod_det ) then
                L17004 = "订单未决数量:" + ( if sod_qty_ord <= sod_qty_ship then "0" else ( string ( sod_qty_ord - sod_qty_ship ) ) ) .
                else L17004 = "" . 
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
        IF V1700 = "e" THEN  LEAVE V1305LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1700.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1700.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first so_mstr where so_domain = V1001 AND so_nbr = V1100  NO-ERROR NO-WAIT.
        IF NOT AVAILABLE so_mstr then do:
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
        find last tr_hist where tr_domain = V1001 AND tr_trnbr >= 0 no-lock no-error.
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

                display "[销售出货备料]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9000 width 150 no-box.

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
        IF V9000 = "e" THEN  LEAVE V1305LMAINLOOP.
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
     {xssoa20u.i}
     /*  Update MFG/PRO END  */ 
        display  "" NO-LABEL with fram F9000X width 150 no-box .
        pause 0.
     /* START  LINE :9005  LOAD ALLOCATION DATA  */
     V9005L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9005           as char format "x(150)".
        define variable PV9005          as char format "x(150)".
        define variable L90051          as char format "x(40)".
        define variable L90052          as char format "x(40)".
        define variable L90053          as char format "x(40)".
        define variable L90054          as char format "x(40)".
        define variable L90055          as char format "x(40)".
        define variable L90056          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9005 = ENTRY(1,V9005,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        {xsso20s.i}
IF 1 = 1 THEN
        leave V9005L.
        /* LOGICAL SKIP END */
                display "[销售出货备料]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9005 width 150 no-box.

                /* LABEL 1 - START */ 
                  L90051 = "" . 
                display L90051          format "x(40)" skip with fram F9005 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L90052 = "" . 
                display L90052          format "x(40)" skip with fram F9005 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L90053 = "" . 
                display L90053          format "x(40)" skip with fram F9005 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L90054 = "" . 
                display L90054          format "x(40)" skip with fram F9005 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9005 width 150 no-box.
        Update V9005
        WITH  fram F9005 NO-LABEL
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
        IF V9005 = "e" THEN  LEAVE V1305LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9005.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9005.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9005.
        pause 0.
        leave V9005L.
     END.
     PV9005 = V9005.
     /* END    LINE :9005  LOAD ALLOCATION DATA  */


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
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9010 = ENTRY(1,V9010,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售出货备料]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9010 width 150 no-box.

                /* LABEL 1 - START */ 
                find last tr_hist where tr_domain = V1001 and 
tr_date = today     and 
tr_trnbr > integer ( V9000 ) and 
tr_nbr  = V1100     and  tr_type = "RCT-TR"  and 
tr_site = V1002     and tr_part = V1300     and tr_serial = V1500   and 
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
tr_nbr  = V1100     and  tr_type = "RCT-TR"  and  tr_site = V1002     and tr_part = V1300     and tr_serial = V1500   and 
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
tr_nbr  = V1100     and  tr_type = "RCT-TR"  and  tr_site = V1002     and tr_part = V1300     and tr_serial = V1500   and 
tr_time  + 15 >= TIME 
use-index tr_date_trn no-lock no-error.
If NOT AVAILABLE ( tr_hist ) then
                L90103 = "交易提交失败" .
                else L90103 = "" . 
                display L90103          format "x(40)" skip with fram F9010 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L90104 = "" . 
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
        IF V9010 = "e" THEN  LEAVE V1305LMAINLOOP.
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
     /* END    LINE :9010  OK  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1305LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :9010    */
   END.
   pause 0 before-hide.
end.
