/* Generate By Barcode Generator , Copyright by Softspeed - Build By Sam Song  */
/* PO RECEIPT [PRODUCTION DATE] */
/* Generate date / time  12/13/07 15:40:25 */
define variable sectionid as integer init 0 .
define variable WMESSAGE as char format "x(80)" init "".
define variable wtm_num as char format "x(20)" init "0".
define variable wsection as char format "x(16)".
define variable i as integer .
define shared  var batchrun    AS LOGICAL.

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout" no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xspor03wtimeout" no-lock no-error. /*  Timeout - Program Level */
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
                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 no-box.

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
                L10024 = "  请查核" .
                display L10024          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
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


     /* START  LINE :1005  图号[Raw Material]  */
     V1005L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1005           as char format "x(50)".
        define variable PV1005          as char format "x(50)".
        define variable L10051          as char format "x(40)".
        define variable L10052          as char format "x(40)".
        define variable L10053          as char format "x(40)".
        define variable L10054          as char format "x(40)".
        define variable L10055          as char format "x(40)".
        define variable L10056          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then
        V1005 = PV1005 .
        V1005 = ENTRY(1,V1005,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1005 no-box.

                /* LABEL 1 - START */
                L10051 = "图号 或 图号+批号?" .
                display L10051          format "x(40)" skip with fram F1005 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L10052 = "输入或空" .
                display L10052          format "x(40)" skip with fram F1005 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L10053 = "" .
                display L10053          format "x(40)" skip with fram F1005 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L10054 = "" .
                display L10054          format "x(40)" skip with fram F1005 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1005 no-box.
        recid(PT_MSTR) = ?.
        Update V1005
        WITH  fram F1005 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1005.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(PT_MSTR) = ? THEN find first PT_MSTR where
                              PT_PART >=  INPUT V1005
                               no-lock no-error.
                  else do:
                       if PT_PART =  INPUT V1005
                       then find next PT_MSTR
                        no-lock no-error.
                        else find first PT_MSTR where
                              PT_PART >=  INPUT V1005
                               no-lock no-error.
                  end.
                  IF AVAILABLE PT_MSTR then display skip
            PT_PART @ V1005 trim( PT_Desc1 ) + "/" + trim (pt_draw) @ WMESSAGE NO-LABEL with fram F1005.
                  else   display skip "" @ WMESSAGE with fram F1005.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(PT_MSTR) = ? THEN find last PT_MSTR where
                              PT_PART <=  INPUT V1005
                               no-lock no-error.
                  else do:
                       if PT_PART =  INPUT V1005
                       then find prev PT_MSTR
                        no-lock no-error.
                        else find first PT_MSTR where
                              PT_PART >=  INPUT V1005
                               no-lock no-error.
                  end.
                  IF AVAILABLE PT_MSTR then display skip
            PT_PART @ V1005 trim( PT_Desc1 ) + "/" + trim (pt_draw) @ WMESSAGE NO-LABEL with fram F1005.
                  else   display skip "" @ WMESSAGE with fram F1005.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1005 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1005.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1005.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1005.
        pause 0.
        leave V1005L.
     END.
     PV1005 = V1005.
     /* END    LINE :1005  图号[Raw Material]  */


     /* START  LINE :1100  采购单[PO]  */
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
                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1100 no-box.

                /* LABEL 1 - START */
                L11001 = "采购单?" .
                display L11001          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L11002 = "图号:" + trim ( V1005 ) .
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
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1100 no-box.
        recid(POD_DET) = ?.
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
                  IF recid(POD_DET) = ? THEN find first POD_DET where
                              pod_site = V1002 and index( "XC",pod_status ) = 0  and pod_type = "" and ( pod_part = V1005 or V1005 = "") AND pod_qty_ord > pod_qty_rcvd AND
                              POD_NBR >=  INPUT V1100
                               use-index POD_PARTDUE
                               no-lock no-error.
                  else do:
                       if POD_NBR =  INPUT V1100
                       then find next POD_DET
                       WHERE pod_site = V1002 and index( "XC",pod_status ) = 0  and pod_type = "" and ( pod_part = V1005 or V1005 = "") AND pod_qty_ord > pod_qty_rcvd
                               use-index POD_PARTDUE
                        no-lock no-error.
                        else find first POD_DET where
                              pod_site = V1002 and index( "XC",pod_status ) = 0  and pod_type = "" and ( pod_part = V1005 or V1005 = "") AND pod_qty_ord > pod_qty_rcvd AND
                              POD_NBR >=  INPUT V1100
                               use-index POD_PARTDUE
                               no-lock no-error.
                  end.
                  IF AVAILABLE POD_DET then display skip
            POD_NBR @ V1100 trim(POD_NBR) + "*" + String( POD_LINE) + "*"  + string (pod_due_Date) + "*" + string ( if ( pod_qty_ord - pod_qty_rcvd ) > 0 then ( pod_qty_ord - pod_qty_rcvd ) else 0 ) @ WMESSAGE NO-LABEL with fram F1100.
                  else   display skip "" @ WMESSAGE with fram F1100.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(POD_DET) = ? THEN find last POD_DET where
                              pod_site = V1002 and index( "XC",pod_status ) = 0  and pod_type = "" and ( pod_part = V1005 or V1005 = "") AND pod_qty_ord > pod_qty_rcvd AND
                              POD_NBR <=  INPUT V1100
                               use-index POD_PARTDUE
                               no-lock no-error.
                  else do:
                       if POD_NBR =  INPUT V1100
                       then find prev POD_DET
                       where pod_site = V1002 and index( "XC",pod_status ) = 0  and pod_type = "" and ( pod_part = V1005 or V1005 = "") AND pod_qty_ord > pod_qty_rcvd
                               use-index POD_PARTDUE
                        no-lock no-error.
                        else find first POD_DET where
                              pod_site = V1002 and index( "XC",pod_status ) = 0  and pod_type = "" and ( pod_part = V1005 or V1005 = "") AND pod_qty_ord > pod_qty_rcvd AND
                              POD_NBR >=  INPUT V1100
                               use-index POD_PARTDUE
                               no-lock no-error.
                  end.
                  IF AVAILABLE POD_DET then display skip
            POD_NBR @ V1100 trim(POD_NBR) + "*" + String( POD_LINE) + "*"  + string (pod_due_Date) + "*" + string ( if ( pod_qty_ord - pod_qty_rcvd ) > 0 then ( pod_qty_ord - pod_qty_rcvd ) else 0 ) @ WMESSAGE NO-LABEL with fram F1100.
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
        find first PO_MSTR where PO_NBR = V1100 AND INDEX("XC",PO_STAT) = 0 AND PO_TYPE <> "B" AND (PO_SITE ="" OR PO_SITE = V1002 )  NO-ERROR NO-WAIT.
        IF NOT AVAILABLE PO_MSTR then do:
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
     /* END    LINE :1100  采购单[PO]  */


     /* START  LINE :1101  采购币别  */
     V1101L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1101           as char format "x(50)".
        define variable PV1101          as char format "x(50)".
        define variable L11011          as char format "x(40)".
        define variable L11012          as char format "x(40)".
        define variable L11013          as char format "x(40)".
        define variable L11014          as char format "x(40)".
        define variable L11015          as char format "x(40)".
        define variable L11016          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first po_mstr where po_nbr = V1100  no-lock no-error.
If AVAILABLE (po_mstr) then
        V1101 = trim( po_curr ).
        V1101 = ENTRY(1,V1101,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1101 = ENTRY(1,V1101,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1101L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1101L .
        /* --CYCLE TIME SKIP -- END  */

                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1101 no-box.

                /* LABEL 1 - START */
                  L11011 = "" .
                display L11011          format "x(40)" skip with fram F1101 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L11012 = "" .
                display L11012          format "x(40)" skip with fram F1101 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L11013 = "" .
                display L11013          format "x(40)" skip with fram F1101 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L11014 = "" .
                display L11014          format "x(40)" skip with fram F1101 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1101 no-box.
        /* DISPLAY ONLY */
        define variable X1101           as char format "x(40)".
        X1101 = V1101.
        V1101 = "".
        /* DISPLAY ONLY */
        Update V1101
        WITH  fram F1101 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V1101 = X1101.
        /* DISPLAY ONLY */
        LEAVE V1101L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1101 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1101.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1101.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1101.
        pause 0.
        leave V1101L.
     END.
     PV1101 = V1101.
     /* END    LINE :1101  采购币别  */


     /* START  LINE :1102  本位币别  */
     V1102L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1102           as char format "x(50)".
        define variable PV1102          as char format "x(50)".
        define variable L11021          as char format "x(40)".
        define variable L11022          as char format "x(40)".
        define variable L11023          as char format "x(40)".
        define variable L11024          as char format "x(40)".
        define variable L11025          as char format "x(40)".
        define variable L11026          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first gl_ctrl no-lock no-error.
If AVAILABLE (gl_ctrl) then
        V1102 = trim( gl_base_curr ).
        V1102 = ENTRY(1,V1102,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1102 = ENTRY(1,V1102,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1102L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1102L .
        /* --CYCLE TIME SKIP -- END  */

                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1102 no-box.

                /* LABEL 1 - START */
                  L11021 = "" .
                display L11021          format "x(40)" skip with fram F1102 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L11022 = "" .
                display L11022          format "x(40)" skip with fram F1102 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L11023 = "" .
                display L11023          format "x(40)" skip with fram F1102 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L11024 = "" .
                display L11024          format "x(40)" skip with fram F1102 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1102 no-box.
        /* DISPLAY ONLY */
        define variable X1102           as char format "x(40)".
        X1102 = V1102.
        V1102 = "".
        /* DISPLAY ONLY */
        Update V1102
        WITH  fram F1102 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V1102 = X1102.
        /* DISPLAY ONLY */
        LEAVE V1102L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1102 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1102.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1102.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1102.
        pause 0.
        leave V1102L.
     END.
     PV1102 = V1102.
     /* END    LINE :1102  本位币别  */


     /* START  LINE :1103  固定汇率 = Y 不跳出  */
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
        find first po_mstr where po_nbr = V1100  no-lock no-error.
If AVAILABLE (po_mstr) then
        V1103 = if po_fix_rate = yes then "Y" else "N".
        V1103 = ENTRY(1,V1103,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1103 = ENTRY(1,V1103,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1103L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1103L .
        /* --CYCLE TIME SKIP -- END  */

                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1103 no-box.

                /* LABEL 1 - START */
                  L11031 = "" .
                display L11031          format "x(40)" skip with fram F1103 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L11032 = "" .
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
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1103 no-box.
        /* DISPLAY ONLY */
        define variable X1103           as char format "x(40)".
        X1103 = V1103.
        V1103 = "".
        /* DISPLAY ONLY */
        Update V1103
        WITH  fram F1103 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V1103 = X1103.
        /* DISPLAY ONLY */
        LEAVE V1103L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1103 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1103.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1103.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1103.
        pause 0.
        leave V1103L.
     END.
     PV1103 = V1103.
     /* END    LINE :1103  固定汇率 = Y 不跳出  */


     /* START  LINE :1104  供应商  */
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
        find first po_mstr where po_nbr = V1100  no-lock no-error.
If AVAILABLE (po_mstr) then
        V1104 = po_vend.
        V1104 = ENTRY(1,V1104,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1104 = ENTRY(1,V1104,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1104L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1104L .
        /* --CYCLE TIME SKIP -- END  */

                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1104 no-box.

                /* LABEL 1 - START */
                L11041 = "Vendor" .
                display L11041          format "x(40)" skip with fram F1104 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L11042 = "" .
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
                display "输入或按E退出"       format "x(40)" skip
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
     /* END    LINE :1104  供应商  */


     /* START  LINE :1108  合同号码  */
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
        V1108 = " ".
        V1108 = ENTRY(1,V1108,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then
        V1108 = PV1108 .
        V1108 = ENTRY(1,V1108,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF  substring (V1104,1,1) = "C" THEN
        leave V1108L.
        /* LOGICAL SKIP END */
                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1108 no-box.

                /* LABEL 1 - START */
                L11081 = "合同号码?" .
                display L11081          format "x(40)" skip with fram F1108 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L11082 = "" .
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
                display "输入或按E退出"       format "x(40)" skip
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
        IF V1108 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1108.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1108.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not (trim(V1108) <> "" and length ( trim (V1108) ) <= 12 ) THEN DO:
                display skip "不能大于12位" @ WMESSAGE NO-LABEL with fram F1108.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1108.
        pause 0.
        leave V1108L.
     END.
     PV1108 = V1108.
     /* END    LINE :1108  合同号码  */


     /* START  LINE :1200  装箱单[Packing No]  */
     V1200L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1200           as char format "x(50)".
        define variable PV1200          as char format "x(50)".
        define variable L12001          as char format "x(40)".
        define variable L12002          as char format "x(40)".
        define variable L12003          as char format "x(40)".
        define variable L12004          as char format "x(40)".
        define variable L12005          as char format "x(40)".
        define variable L12006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then
        V1200 = PV1200 .
        V1200 = ENTRY(1,V1200,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1200 no-box.

                /* LABEL 1 - START */
                L12001 = "装箱单" .
                display L12001          format "x(40)" skip with fram F1200 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L12002 = "" .
                display L12002          format "x(40)" skip with fram F1200 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L12003 = "" .
                display L12003          format "x(40)" skip with fram F1200 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L12004 = "" .
                display L12004          format "x(40)" skip with fram F1200 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1200 no-box.
        Update V1200
        WITH  fram F1200 NO-LABEL
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
        IF V1200 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1200.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1200.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not (trim(V1200) <> "" and length ( trim (V1200) ) <= 20 ) THEN DO:
                display skip "不能大于20位" @ WMESSAGE NO-LABEL with fram F1200.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1200.
        pause 0.
        leave V1200L.
     END.
     PV1200 = V1200.
     /* END    LINE :1200  装箱单[Packing No]  */


     /* START  LINE :1203  生效日期  */
     V1203L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1203           as char format "x(50)".
        define variable PV1203          as char format "x(50)".
        define variable L12031          as char format "x(40)".
        define variable L12032          as char format "x(40)".
        define variable L12033          as char format "x(40)".
        define variable L12034          as char format "x(40)".
        define variable L12035          as char format "x(40)".
        define variable L12036          as char format "x(40)".
        define variable D1203           as date .
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1203 = string ( today ).
        D1203 = Date ( V1203).
        V1203 = ENTRY(1,V1203,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then
        V1203 = PV1203 .
         If sectionid > 1 Then
        D1203 = Date ( V1203).
        V1203 = ENTRY(1,V1203,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1203 no-box.

                /* LABEL 1 - START */
                L12031 = "收货日期?" .
                display L12031          format "x(40)" skip with fram F1203 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L12032 = string ( today ) .
                display L12032          format "x(40)" skip with fram F1203 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L12033 = "" .
                display L12033          format "x(40)" skip with fram F1203 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L12034 = "" .
                display L12034          format "x(40)" skip with fram F1203 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1203 no-box.
        Update D1203
        WITH  fram F1203 NO-LABEL
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
        IF V1203 = "e" THEN  LEAVE MAINLOOP.
        V1203 = string ( D1203).
        display  skip WMESSAGE NO-LABEL with fram F1203.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1203.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1203.
        pause 0.
        leave V1203L.
     END.
     PV1203 = V1203.
     /* END    LINE :1203  生效日期  */


     /* START  LINE :1204  发货日期  */
     V1204L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1204           as char format "x(50)".
        define variable PV1204          as char format "x(50)".
        define variable L12041          as char format "x(40)".
        define variable L12042          as char format "x(40)".
        define variable L12043          as char format "x(40)".
        define variable L12044          as char format "x(40)".
        define variable L12045          as char format "x(40)".
        define variable L12046          as char format "x(40)".
        define variable D1204           as date .
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1204 = string ( today ).
        D1204 = Date ( V1204).
        V1204 = ENTRY(1,V1204,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then
        V1204 = PV1204 .
         If sectionid > 1 Then
        D1204 = Date ( V1204).
        V1204 = ENTRY(1,V1204,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1204 no-box.

                /* LABEL 1 - START */
                L12041 = "发货日期?" .
                display L12041          format "x(40)" skip with fram F1204 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L12042 = string ( today ) .
                display L12042          format "x(40)" skip with fram F1204 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L12043 = "" .
                display L12043          format "x(40)" skip with fram F1204 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L12044 = "" .
                display L12044          format "x(40)" skip with fram F1204 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1204 no-box.
        Update D1204
        WITH  fram F1204 NO-LABEL
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
        IF V1204 = "e" THEN  LEAVE MAINLOOP.
        V1204 = string ( D1204).
        display  skip WMESSAGE NO-LABEL with fram F1204.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1204.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1204.
        pause 0.
        leave V1204L.
     END.
     PV1204 = V1204.
     /* END    LINE :1204  发货日期  */


   /* Internal Cycle Input :1205    */
   V1205LMAINLOOP:
   REPEAT:
     /* START  LINE :1205  采购项次 SKIP ONLY ONE  */
     V1205L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1205           as char format "x(50)".
        define variable PV1205          as char format "x(50)".
        define variable L12051          as char format "x(40)".
        define variable L12052          as char format "x(40)".
        define variable L12053          as char format "x(40)".
        define variable L12054          as char format "x(40)".
        define variable L12055          as char format "x(40)".
        define variable L12056          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first pod_det where pod_nbr = V1100  and pod_site = V1002 and index("XC",pod_status) = 0 and pod_type = "" no-lock no-error.
If AVAILABLE (pod_det) and string ( pod_line ) <> V1205 then
        V1205 = string ( pod_line ).
        V1205 = ENTRY(1,V1205,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1205 = ENTRY(1,V1205,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        find last pod_det where pod_nbr = V1100  and pod_site = V1002  and index("XC",pod_status) = 0 and pod_type = ""  no-lock no-error.
If AVAILABLE (pod_det) and string ( pod_line ) = V1205 then
        leave V1205L.
        /* LOGICAL SKIP END */
                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1205 no-box.

                /* LABEL 1 - START */
                L12051 = "采购项次" .
                display L12051          format "x(40)" skip with fram F1205 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L12052 = "" .
                display L12052          format "x(40)" skip with fram F1205 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L12053 = "" .
                display L12053          format "x(40)" skip with fram F1205 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L12054 = "" .
                display L12054          format "x(40)" skip with fram F1205 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1205 no-box.
        recid(POD_DET) = ?.
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
                  IF recid(POD_DET) = ? THEN find first POD_DET where
                              pod_nbr = V1100 and pod_site = V1002 and index( "XC",pod_status ) = 0  and pod_type = "" AND
                              string ( POD_LINE ) >=  INPUT V1205
                               no-lock no-error.
                  else do:
                       if string ( POD_LINE ) =  INPUT V1205
                       then find next POD_DET
                       WHERE pod_nbr = V1100 and pod_site = V1002 and index( "XC",pod_status ) = 0  and pod_type = ""
                        no-lock no-error.
                        else find first POD_DET where
                              pod_nbr = V1100 and pod_site = V1002 and index( "XC",pod_status ) = 0  and pod_type = "" AND
                              string ( POD_LINE ) >=  INPUT V1205
                               no-lock no-error.
                  end.
                  IF AVAILABLE POD_DET then display skip
            string ( POD_LINE ) @ V1205 trim(POD_PART) + "*" + String( POD_DUE_DATE) + "*" + string ( if ( pod_qty_ord - pod_qty_rcvd ) > 0 then ( pod_qty_ord - pod_qty_rcvd ) else 0 ) @ WMESSAGE NO-LABEL with fram F1205.
                  else   display skip "" @ WMESSAGE with fram F1205.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(POD_DET) = ? THEN find last POD_DET where
                              pod_nbr = V1100 and pod_site = V1002 and index( "XC",pod_status ) = 0  and pod_type = "" AND
                              string ( POD_LINE ) <=  INPUT V1205
                               no-lock no-error.
                  else do:
                       if string ( POD_LINE ) =  INPUT V1205
                       then find prev POD_DET
                       where pod_nbr = V1100 and pod_site = V1002 and index( "XC",pod_status ) = 0  and pod_type = ""
                        no-lock no-error.
                        else find first POD_DET where
                              pod_nbr = V1100 and pod_site = V1002 and index( "XC",pod_status ) = 0  and pod_type = "" AND
                              string ( POD_LINE ) >=  INPUT V1205
                               no-lock no-error.
                  end.
                  IF AVAILABLE POD_DET then display skip
            string ( POD_LINE ) @ V1205 trim(POD_PART) + "*" + String( POD_DUE_DATE) + "*" + string ( if ( pod_qty_ord - pod_qty_rcvd ) > 0 then ( pod_qty_ord - pod_qty_rcvd ) else 0 ) @ WMESSAGE NO-LABEL with fram F1205.
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
        find first POD_DET where POD_NBR = V1100 AND POD_SITE = V1002 AND string( POD_LINE ) = Trim(V1205) and index ( "XC",pod_status ) = 0  and pod_type = ""  NO-ERROR NO-WAIT.
        IF NOT AVAILABLE POD_DET then do:
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
     /* END    LINE :1205  采购项次 SKIP ONLY ONE  */


     /* START  LINE :1300  图号[Raw Material]  */
     V1300L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1300           as char format "x(50)".
        define variable PV1300          as char format "x(50)".
        define variable L13001          as char format "x(40)".
        define variable L13002          as char format "x(40)".
        define variable L13003          as char format "x(40)".
        define variable L13004          as char format "x(40)".
        define variable L13005          as char format "x(40)".
        define variable L13006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first pod_det where pod_nbr = V1100  and string ( pod_line ) = V1205 and pod_type = ""  no-lock no-error.
If AVAILABLE (pod_det) then
        V1300 = pod_part.
        V1300 = ENTRY(1,V1300,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1300 = ENTRY(1,V1300,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1300 no-box.

                /* LABEL 1 - START */
                find first pod_det where pod_nbr = V1100  and string ( pod_line ) = V1205 no-lock no-error.
If AVAILABLE (pod_det) then
                L13001 = "图号:" + pod_part .
                else L13001 = "" .
                display L13001          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                find first pt_mstr where pt_part = V1300 no-lock no-error.
If AVAILABLE (pt_mstr) then
                L13002 = "名称:" + trim ( pt_desc1 ) .
                else L13002 = "" .
                display L13002          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                find first pt_mstr where pt_part = V1300 no-lock no-error.
If AVAILABLE (pt_mstr) then
                L13003 = "图纸:" + trim ( pt_draw ) .
                else L13003 = "" .
                display L13003          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                find first pod_det where pod_nbr = V1100  and string ( pod_line ) = V1205 no-lock no-error.
If AVAILABLE (pod_det) then
                L13004 = "项次/未结数量:" + trim ( V1205 ) + "/" + string ( if ( pod_qty_ord - pod_qty_rcvd ) > 0 then ( pod_qty_ord - pod_qty_rcvd ) else 0 ) .
                else L13004 = "" .
                display L13004          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1300 no-box.
        /* DISPLAY ONLY */
        define variable X1300           as char format "x(40)".
        X1300 = V1300.
        V1300 = "".
        /* DISPLAY ONLY */
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
        V1300 = X1300.
        /* DISPLAY ONLY */
        LEAVE V1300L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1300 = "e" THEN  LEAVE V1205LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1300.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
        leave V1300L.
     END.
     IF INDEX(V1300,"@" ) = 0 then V1300 = V1300 + "@".
     PV1300 = V1300.
     V1300 = ENTRY(1,V1300,"@").
     /* END    LINE :1300  图号[Raw Material]  */


     /* START  LINE :1305  INSP_LOC　检图号默认库位-按产品线  */
     V1305L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1305           as char format "x(50)".
        define variable PV1305          as char format "x(50)".
        define variable L13051          as char format "x(40)".
        define variable L13052          as char format "x(40)".
        define variable L13053          as char format "x(40)".
        define variable L13054          as char format "x(40)".
        define variable L13055          as char format "x(40)".
        define variable L13056          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first poc_ctrl no-lock no-error.
If AVAILABLE (poc_ctrl) then
        V1305 = poc_insp_loc.
        V1305 = ENTRY(1,V1305,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1305 = ENTRY(1,V1305,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1305L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1305L .
        /* --CYCLE TIME SKIP -- END  */

                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1305 no-box.

                /* LABEL 1 - START */
                  L13051 = "" .
                display L13051          format "x(40)" skip with fram F1305 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L13052 = "" .
                display L13052          format "x(40)" skip with fram F1305 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L13053 = "" .
                display L13053          format "x(40)" skip with fram F1305 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L13054 = "" .
                display L13054          format "x(40)" skip with fram F1305 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1305 no-box.
        /* DISPLAY ONLY */
        define variable X1305           as char format "x(40)".
        X1305 = V1305.
        V1305 = "".
        /* DISPLAY ONLY */
        Update V1305
        WITH  fram F1305 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V1305 = X1305.
        /* DISPLAY ONLY */
        LEAVE V1305L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1305 = "e" THEN  LEAVE V1205LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1305.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1305.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1305.
        pause 0.
        leave V1305L.
     END.
     PV1305 = V1305.
     /* END    LINE :1305  INSP_LOC　检图号默认库位-按产品线  */


     /* START  LINE :1306  PT_LOC 免检图号默认库位-按产品线  */
     V1306L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1306           as char format "x(50)".
        define variable PV1306          as char format "x(50)".
        define variable L13061          as char format "x(40)".
        define variable L13062          as char format "x(40)".
        define variable L13063          as char format "x(40)".
        define variable L13064          as char format "x(40)".
        define variable L13065          as char format "x(40)".
        define variable L13066          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first CODE_MSTR where CODE_FLDNAME = "BARCODE" and CODE_VALUE = "PASSCHECKLOC" no-lock no-error.
        V1306 = if avail code_mstr then code_cmmt else " ".
        V1306 = ENTRY(1,V1306,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1306 = ENTRY(1,V1306,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1306L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1306L .
        /* --CYCLE TIME SKIP -- END  */

                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1306 no-box.

                /* LABEL 1 - START */
                  L13061 = "" .
                display L13061          format "x(40)" skip with fram F1306 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L13062 = "" .
                display L13062          format "x(40)" skip with fram F1306 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L13063 = "" .
                display L13063          format "x(40)" skip with fram F1306 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L13064 = "" .
                display L13064          format "x(40)" skip with fram F1306 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1306 no-box.
        /* DISPLAY ONLY */
        define variable X1306           as char format "x(40)".
        X1306 = V1306.
        V1306 = "".
        /* DISPLAY ONLY */
        Update V1306
        WITH  fram F1306 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V1306 = X1306.
        /* DISPLAY ONLY */
        LEAVE V1306L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1306 = "e" THEN  LEAVE V1205LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1306.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1306.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1306.
        pause 0.
        leave V1306L.
     END.
     PV1306 = V1306.
     /* END    LINE :1306  PT_LOC 免检图号默认库位-按产品线  */


     /* START  LINE :1307  产品线  */
     V1307L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1307           as char format "x(50)".
        define variable PV1307          as char format "x(50)".
        define variable L13071          as char format "x(40)".
        define variable L13072          as char format "x(40)".
        define variable L13073          as char format "x(40)".
        define variable L13074          as char format "x(40)".
        define variable L13075          as char format "x(40)".
        define variable L13076          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr ) then
        V1307 = pt_prod_line.
        V1307 = ENTRY(1,V1307,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1307 = ENTRY(1,V1307,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1307L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1307L .
        /* --CYCLE TIME SKIP -- END  */

                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1307 no-box.

                /* LABEL 1 - START */
                L13071 = "产品线" .
                display L13071          format "x(40)" skip with fram F1307 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L13072 = "" .
                display L13072          format "x(40)" skip with fram F1307 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L13073 = "" .
                display L13073          format "x(40)" skip with fram F1307 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L13074 = "" .
                display L13074          format "x(40)" skip with fram F1307 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1307 no-box.
        /* DISPLAY ONLY */
        define variable X1307           as char format "x(40)".
        X1307 = V1307.
        V1307 = "".
        /* DISPLAY ONLY */
        Update V1307
        WITH  fram F1307 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V1307 = X1307.
        /* DISPLAY ONLY */
        LEAVE V1307L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1307 = "e" THEN  LEAVE V1205LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1307.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1307.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1307.
        pause 0.
        leave V1307L.
     END.
     PV1307 = V1307.
     /* END    LINE :1307  产品线  */


     /* START  LINE :1309  生产日期(Create LOT)  */
     V1309L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1309           as char format "x(50)".
        define variable PV1309          as char format "x(50)".
        define variable L13091          as char format "x(40)".
        define variable L13092          as char format "x(40)".
        define variable L13093          as char format "x(40)".
        define variable L13094          as char format "x(40)".
        define variable L13095          as char format "x(40)".
        define variable L13096          as char format "x(40)".
        define variable D1309           as date .
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1309 = string ( today ).
        D1309 = Date ( V1309).
        V1309 = ENTRY(1,V1309,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then
        V1309 = PV1309 .
         If sectionid > 1 Then
        D1309 = Date ( V1309).
        V1309 = ENTRY(1,V1309,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1309 no-box.

                /* LABEL 1 - START */
                L13091 = "生产日期?" .
                display L13091          format "x(40)" skip with fram F1309 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L13092 = string ( today ) .
                display L13092          format "x(40)" skip with fram F1309 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L13093 = "" .
                display L13093          format "x(40)" skip with fram F1309 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L13094 = "" .
                display L13094          format "x(40)" skip with fram F1309 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1309 no-box.
        Update D1309
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
        IF V1309 = "e" THEN  LEAVE V1205LMAINLOOP.
        V1309 = string ( D1309).
        display  skip WMESSAGE NO-LABEL with fram F1309.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1309.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1309.
        pause 0.
        leave V1309L.
     END.
     PV1309 = V1309.
     /* END    LINE :1309  生产日期(Create LOT)  */


     /* START  LINE :1400  库位[LOC] - INSP  */
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
        find first pt_mstr where pt_part = V1300  no-lock no-error.
        V1400 = If AVAILABLE (PT_MSTR) and pt_insp_rqd = no then V1306 else V1305.
        V1400 = ENTRY(1,V1400,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then
        V1400 = PV1400 .
        V1400 = ENTRY(1,V1400,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1400 no-box.

                /* LABEL 1 - START */
                L14001 = "库位?" .
                display L14001          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L14002 = "产品线:" + trim ( V1307 ) .
                display L14002          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                find first pl_mstr where pl_prod_line = V1307 no-lock no-error.
If AVAILABLE (pl_mstr) THEN
                L14003 = trim ( pl_desc ) .
                else L14003 = "" .
                display L14003          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                find first CODE_MSTR where CODE_FLDNAME = "BARCODE" and CODE_VALUE = "PT_PROD_LINE_USEPTLOC" and trim ( CODE_CMMT ) = trim ( V1307 ) no-lock no-error.
If AVAILABLE (CODE_MSTR) then
                L14004 = "**免检图号" .
                else L14004 = "" .
                display L14004          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1400 no-box.
        recid(LOC_MSTR) = ?.
        Update V1400
        WITH  fram F1400 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1400.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(LOC_MSTR) = ? THEN find first LOC_MSTR where
                              LOC_SITE = V1002 AND
                              LOC_LOC >=  INPUT V1400
                               no-lock no-error.
                  else do:
                       if LOC_LOC =  INPUT V1400
                       then find next LOC_MSTR
                       WHERE LOC_SITE = V1002
                        no-lock no-error.
                        else find first LOC_MSTR where
                              LOC_SITE = V1002 AND
                              LOC_LOC >=  INPUT V1400
                               no-lock no-error.
                  end.
                  IF AVAILABLE LOC_MSTR then display skip
            LOC_LOC @ V1400 LOC_DESC @ WMESSAGE NO-LABEL with fram F1400.
                  else   display skip "" @ WMESSAGE with fram F1400.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(LOC_MSTR) = ? THEN find last LOC_MSTR where
                              LOC_SITE = V1002 AND
                              LOC_LOC <=  INPUT V1400
                               no-lock no-error.
                  else do:
                       if LOC_LOC =  INPUT V1400
                       then find prev LOC_MSTR
                       where LOC_SITE = V1002
                        no-lock no-error.
                        else find first LOC_MSTR where
                              LOC_SITE = V1002 AND
                              LOC_LOC >=  INPUT V1400
                               no-lock no-error.
                  end.
                  IF AVAILABLE LOC_MSTR then display skip
            LOC_LOC @ V1400 LOC_DESC @ WMESSAGE NO-LABEL with fram F1400.
                  else   display skip "" @ WMESSAGE with fram F1400.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1400 = "e" THEN  LEAVE V1205LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1400.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1400.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first LOC_MSTR where LOC_LOC = V1400 AND LOC_SITE = V1002  no-lock no-error.
        IF NOT AVAILABLE LOC_MSTR then do:
                display skip "错误,重试." @ WMESSAGE NO-LABEL with fram F1400.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1400.
        pause 0.
        leave V1400L.
     END.
     PV1400 = V1400.
     /* END    LINE :1400  库位[LOC] - INSP  */


     /* START  LINE :1410  L Control  */
     V1410L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1410           as char format "x(50)".
        define variable PV1410          as char format "x(50)".
        define variable L14101          as char format "x(40)".
        define variable L14102          as char format "x(40)".
        define variable L14103          as char format "x(40)".
        define variable L14104          as char format "x(40)".
        define variable L14105          as char format "x(40)".
        define variable L14106          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first pt_mstr where pt_part = V1300  no-lock no-error.
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

                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1410 no-box.

                /* LABEL 1 - START */
                  L14101 = "" .
                display L14101          format "x(40)" skip with fram F1410 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L14102 = "" .
                display L14102          format "x(40)" skip with fram F1410 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L14103 = "" .
                display L14103          format "x(40)" skip with fram F1410 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L14104 = "" .
                display L14104          format "x(40)" skip with fram F1410 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1410 no-box.
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
        IF V1410 = "e" THEN  LEAVE V1205LMAINLOOP.
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
        define variable V1500           as char format "x(50)".
        define variable PV1500          as char format "x(50)".
        define variable L15001          as char format "x(40)".
        define variable L15002          as char format "x(40)".
        define variable L15003          as char format "x(40)".
        define variable L15004          as char format "x(40)".
        define variable L15005          as char format "x(40)".
        define variable L15006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        IF V1410 = "L"  then do:
{xsglot3.i}
end.
IF substring(V1104,1,1) <> "C"  then do:
{xsglot4.i}
end.
IF V1500<>""  then
        V1500 = V1500.
        V1500 = ENTRY(1,V1500,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1500 = ENTRY(1,V1500,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1500 no-box.

                /* LABEL 1 - START */
                L15001 = "批号?" .
                display L15001          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L15002 = "" .
                display L15002          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L15003 = "" .
                display L15003          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L15004 = "" .
                display L15004          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1500 no-box.
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
        IF not V1500 <> "" THEN DO:
                display skip "Error , Retry " @ WMESSAGE NO-LABEL with fram F1500.
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


     /* START  LINE :1501  L Checking & Location Checking & Location Checking  */
     V1501L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1501           as char format "x(50)".
        define variable PV1501          as char format "x(50)".
        define variable L15011          as char format "x(40)".
        define variable L15012          as char format "x(40)".
        define variable L15013          as char format "x(40)".
        define variable L15014          as char format "x(40)".
        define variable L15015          as char format "x(40)".
        define variable L15016          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1501 = "E".
        V1501 = ENTRY(1,V1501,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1501 = ENTRY(1,V1501,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF V1410 = "L" and V1400 <> "" AND V1306 <> "" THEN
        leave V1501L.
        /* LOGICAL SKIP END */
                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1501 no-box.

                /* LABEL 1 - START */
                L15011 = "ERR:LOT/LOC控制" .
                display L15011          format "x(40)" skip with fram F1501 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L15012 = "请在1.4.1进行定义" .
                display L15012          format "x(40)" skip with fram F1501 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L15013 = "" .
                display L15013          format "x(40)" skip with fram F1501 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L15014 = "" .
                display L15014          format "x(40)" skip with fram F1501 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1501 no-box.
        Update V1501
        WITH  fram F1501 NO-LABEL
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
        IF V1501 = "e" THEN  LEAVE V1205LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1501.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1501.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not trim(V1501) = "E" THEN DO:
                display skip "Error , Retry " @ WMESSAGE NO-LABEL with fram F1501.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1501.
        pause 0.
        leave V1501L.
     END.
     PV1501 = V1501.
     /* END    LINE :1501  L Checking & Location Checking & Location Checking  */


     /* START  LINE :1550  单位换算比例[UM FACTOR]  */
     V1550L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1550           as char format "x(50)".
        define variable PV1550          as char format "x(50)".
        define variable L15501          as char format "x(40)".
        define variable L15502          as char format "x(40)".
        define variable L15503          as char format "x(40)".
        define variable L15504          as char format "x(40)".
        define variable L15505          as char format "x(40)".
        define variable L15506          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first pod_det where pod_nbr = V1100 and  string ( pod_line ) = V1205 and pod_type = ""  no-lock no-error.
If AVAILABLE (pod_det) then
        V1550 = string ( pod_um_conv ).
        V1550 = ENTRY(1,V1550,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1550 = ENTRY(1,V1550,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        find first pod_det where pod_nbr = V1100 and string( pod_line)  = V1205   and pod_type = ""  no-lock no-error.
If AVAILABLE (pod_det) and pod_um_conv = 1 then
        leave V1550L.
        /* LOGICAL SKIP END */
                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1550 no-box.

                /* LABEL 1 - START */
                L15501 = "图号:" + trim( V1300 ) .
                display L15501          format "x(40)" skip with fram F1550 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                find first pod_det where pod_nbr = V1100 and string( pod_line)  = V1205 and pod_type = ""  no-lock no-error.
If AVAILABLE (pod_det) then
                L15502 = "采购单位:" + pod_um .
                else L15502 = "" .
                display L15502          format "x(40)" skip with fram F1550 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                find first pod_det where pod_nbr = V1100 and string( pod_line)  = V1205  and pod_type = ""  no-lock no-error.
If AVAILABLE (pod_det) then
                L15503 = "转换比例:" + string (pod_um_conv) .
                else L15503 = "" .
                display L15503          format "x(40)" skip with fram F1550 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                find first pt_mstr where pt_part = V1300 no-lock no-error.
If AVAILABLE (pt_mstr) then
                L15504 = "库存单位:" + pt_um .
                else L15504 = "" .
                display L15504          format "x(40)" skip with fram F1550 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1550 no-box.
        /* DISPLAY ONLY */
        define variable X1550           as char format "x(40)".
        X1550 = V1550.
        V1550 = "".
        /* DISPLAY ONLY */
        Update V1550
        WITH  fram F1550 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V1550 = X1550.
        /* DISPLAY ONLY */
        LEAVE V1550L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1550 = "e" THEN  LEAVE V1205LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1550.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1550.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1550.
        pause 0.
        leave V1550L.
     END.
     PV1550 = V1550.
     /* END    LINE :1550  单位换算比例[UM FACTOR]  */


     /* START  LINE :1558  容差後最多收货数 (支控制数量容差,金额容差=最大)  */
     V1558L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1558           as char format "x(50)".
        define variable PV1558          as char format "x(50)".
        define variable L15581          as char format "x(40)".
        define variable L15582          as char format "x(40)".
        define variable L15583          as char format "x(40)".
        define variable L15584          as char format "x(40)".
        define variable L15585          as char format "x(40)".
        define variable L15586          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first poc_ctrl  no-lock no-error.
If AVAILABLE (poc_ctrl) then
        V1558 = string ( ( poc_tol_pct / 100  + 1 ) *  pod_qty_ord  - pod_qty_rcvd  ).
        V1558 = ENTRY(1,V1558,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1558 = ENTRY(1,V1558,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1558L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1558L .
        /* --CYCLE TIME SKIP -- END  */

                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1558 no-box.

                /* LABEL 1 - START */
                find first poc_ctrl  no-lock no-error.
If AVAILABLE (poc_ctrl) then
                L15581 = string ( ( poc_tol_pct / 100 + 1 ) * ( pod_qty_ord - pod_qty_rcvd ) ) .
                else L15581 = "" .
                display L15581          format "x(40)" skip with fram F1558 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L15582 = "" .
                display L15582          format "x(40)" skip with fram F1558 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L15583 = "" .
                display L15583          format "x(40)" skip with fram F1558 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L15584 = "" .
                display L15584          format "x(40)" skip with fram F1558 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1558 no-box.
        Update V1558
        WITH  fram F1558 NO-LABEL
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
        IF V1558 = "e" THEN  LEAVE V1205LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1558.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1558.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1558.
        pause 0.
        leave V1558L.
     END.
     PV1558 = V1558.
     /* END    LINE :1558  容差後最多收货数 (支控制数量容差,金额容差=最大)  */


     /* START  LINE :1600  数量[QTY](采购单UM)  */
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
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1600 = " ".
        V1600 = ENTRY(1,V1600,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1600 no-box.

                /* LABEL 1 - START */
                L16001 = "收货数量?" .
                display L16001          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L16002 = "图号:" + trim( V1300 ) .
                display L16002          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L16003 = "批号:" + Trim(V1500) .
                display L16003          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                find first pod_det where pod_nbr = V1100 and string( pod_line)  = V1205  no-lock no-error.
If AVAILABLE (pod_det) then
                L16004 = "单位:" + trim( pod_um ) + "/" + trim ( V1400 ) .
                else L16004 = "" .
                display L16004          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
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
        IF not ( decimal ( V1600 ) <= decimal ( V1558 ) AND decimal ( V1600 ) <> 0 ) THEN DO:
                display skip "超过容差!!" @ WMESSAGE NO-LABEL with fram F1600.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1600.
        pause 0.
        leave V1600L.
     END.
     PV1600 = V1600.
     /* END    LINE :1600  数量[QTY](采购单UM)  */


     /* START  LINE :1610  库存单位数量  */
     V1610L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1610           as char format "x(50)".
        define variable PV1610          as char format "x(50)".
        define variable L16101          as char format "x(40)".
        define variable L16102          as char format "x(40)".
        define variable L16103          as char format "x(40)".
        define variable L16104          as char format "x(40)".
        define variable L16105          as char format "x(40)".
        define variable L16106          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first pod_det where pod_nbr = V1100 and  string ( pod_line ) = V1205 no-lock no-error.
If AVAILABLE (pod_det) then
        V1610 = string ( pod_um_conv * decimal( V1600 ) ).
        V1610 = ENTRY(1,V1610,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1610 = ENTRY(1,V1610,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        find first pod_det where pod_nbr = V1100 and string( pod_line)  = V1205  no-lock no-error.
If AVAILABLE (pod_det) and pod_um_conv = 1 then
        leave V1610L.
        /* LOGICAL SKIP END */
                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1610 no-box.

                /* LABEL 1 - START */
                find first pod_det where pod_nbr = V1100 and string( pod_line)  = V1205  no-lock no-error.
If AVAILABLE (pod_det) then
                L16101 = "收货数量:" + string (V1600 ) + " " + pod_um .
                else L16101 = "" .
                display L16101          format "x(40)" skip with fram F1610 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L16102 = "转换因子# 1:" + V1550 .
                display L16102          format "x(40)" skip with fram F1610 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                find first pt_mstr where pt_part = V1300 no-lock no-error.
If AVAILABLE (pt_mstr) THEN
                L16103 = "库存数量:" + string ( decimal ( V1550 ) * decimal ( V1600 ) ) + " " + trim ( pt_um ) .
                else L16103 = "" .
                display L16103          format "x(40)" skip with fram F1610 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L16104 = "" .
                display L16104          format "x(40)" skip with fram F1610 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1610 no-box.
        /* DISPLAY ONLY */
        define variable X1610           as char format "x(40)".
        X1610 = V1610.
        V1610 = "".
        /* DISPLAY ONLY */
        Update V1610
        WITH  fram F1610 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V1610 = X1610.
        /* DISPLAY ONLY */
        LEAVE V1610L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1610 = "e" THEN  LEAVE V1205LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1610.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1610.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1610.
        pause 0.
        leave V1610L.
     END.
     PV1610 = V1610.
     /* END    LINE :1610  库存单位数量  */


     /* START  LINE :1700  确认[CONFIRM]  */
     V1700L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1700           as char format "x(50)".
        define variable PV1700          as char format "x(50)".
        define variable L17001          as char format "x(40)".
        define variable L17002          as char format "x(40)".
        define variable L17003          as char format "x(40)".
        define variable L17004          as char format "x(40)".
        define variable L17005          as char format "x(40)".
        define variable L17006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1700 = "Y".
        V1700 = ENTRY(1,V1700,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1700 = ENTRY(1,V1700,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1700 no-box.

                /* LABEL 1 - START */
                L17001 = "图号:" + trim(V1300) .
                display L17001          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L17002 = "批号:" + trim ( V1500 ) .
                display L17002          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L17003 = "库位:" + trim ( V1400 ) + "/" + trim( V1600 ) .
                display L17003          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                find first pod_det where pod_nbr = V1100 and  string ( pod_line ) = V1205 no-lock no-error.
If AVAILABLE (pod_det) then
                L17004 = "未结数量:" + string ( pod_qty_ord - pod_qty_rcvd ) .
                else L17004 = "" .
                display L17004          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 4 - END */
                display "确认过帐[Y],E退出"   format "x(40)" skip
        skip with fram F1700 no-box.
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
        IF V1700 = "e" THEN  LEAVE V1205LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1700.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1700.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first po_mstr where PO_NBR = V1100 AND  INDEX("XC",PO_STAT) = 0 AND PO_TYPE <> "B"  NO-ERROR NO-WAIT.
        IF NOT AVAILABLE po_mstr then do:
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
        define variable V9000           as char format "x(50)".
        define variable PV9000          as char format "x(50)".
        define variable L90001          as char format "x(40)".
        define variable L90002          as char format "x(40)".
        define variable L90003          as char format "x(40)".
        define variable L90004          as char format "x(40)".
        define variable L90005          as char format "x(40)".
        define variable L90006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find last tr_hist where tr_trnbr >= 0 no-lock no-error.
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

                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9000 no-box.

                /* LABEL 1 - START */
                  L90001 = "" .
                display L90001          format "x(40)" skip with fram F9000 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L90002 = "" .
                display L90002          format "x(40)" skip with fram F9000 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L90003 = "" .
                display L90003          format "x(40)" skip with fram F9000 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L90004 = "" .
                display L90004          format "x(40)" skip with fram F9000 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9000 no-box.
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
        IF V9000 = "e" THEN  LEAVE V1205LMAINLOOP.
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


        display "...PROCESSING...  " NO-LABEL with fram F9000X no-box.
        pause 0.
     /*  Update MFG/PRO START  */
     {xspor03u.i}
     /*  Update MFG/PRO END  */
        display  "" NO-LABEL with fram F9000X no-box .
        pause 0.
     /* START  LINE :9005  取2位小数点/ Blank Expire Date  */
     V9005L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9005           as char format "x(50)".
        define variable PV9005          as char format "x(50)".
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
        {xspo3s.i}
IF 1 = 1 THEN
        leave V9005L.
        /* LOGICAL SKIP END */
                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9005 no-box.

                /* LABEL 1 - START */
                  L90051 = "" .
                display L90051          format "x(40)" skip with fram F9005 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L90052 = "" .
                display L90052          format "x(40)" skip with fram F9005 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L90053 = "" .
                display L90053          format "x(40)" skip with fram F9005 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L90054 = "" .
                display L90054          format "x(40)" skip with fram F9005 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9005 no-box.
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
        IF V9005 = "e" THEN  LEAVE V1205LMAINLOOP.
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
     /* END    LINE :9005  取2位小数点/ Blank Expire Date  */


     /* START  LINE :9010  OK  */
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
        V9010 = "Y".
        V9010 = ENTRY(1,V9010,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9010 = ENTRY(1,V9010,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9010 no-box.

                /* LABEL 1 - START */
                find last tr_hist where
tr_date = today     and
tr_trnbr > integer ( V9000 ) and
tr_nbr  = V1100     and  tr_type = "RCT-PO"  and
tr_site = V1002     and tr_part = V1300     and tr_serial = V1500   and
tr_time  + 15 >= TIME
use-index tr_date_trn no-lock no-error.
If AVAILABLE ( tr_hist ) then
                L90101 = "交易已提交" .
                else L90101 = "" .
                display L90101          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                find last tr_hist where
tr_date = today     and
tr_trnbr > integer ( V9000 ) and
tr_nbr  = V1100     and  tr_type = "RCT-PO"  and tr_site = V1002     and  tr_part = V1300     and tr_serial = V1500   and
tr_time  + 15 >= TIME
use-index tr_date_trn no-lock no-error.
If AVAILABLE ( tr_hist ) then
                L90102 = trim(string(tr_trnbr)) + "/" + trim(tr_lot) .
                else L90102 = "" .
                display L90102          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                find last tr_hist where
tr_date = today     and
tr_trnbr > integer ( V9000 ) and
tr_nbr  = V1100     and  tr_type = "RCT-PO"  and tr_site = V1002     and  tr_part = V1300     and tr_serial = V1500   and
tr_time  + 15 >= TIME
use-index tr_date_trn no-lock no-error.
If NOT AVAILABLE ( tr_hist ) then
                L90103 = "交易提交失败" .
                else L90103 = "" .
                display L90103          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                L90104 = "按Y打印条码,E退出" .
                display L90104          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
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
        IF V9010 = "e" THEN  LEAVE V1205LMAINLOOP.
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
     /* END    LINE :9010  OK  */


   /* Without Condition Exit Cycle Start */
   LEAVE V1205LMAINLOOP.
   /* Without Condition Exit Cycle END */
   /* Internal Cycle END :9010    */
   END.
   pause 0 before-hide.
     /* START  LINE :9015  OUTPUT TO PRINTER QTY  */
     V9015L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9015           as char format "x(50)".
        define variable PV9015          as char format "x(50)".
        define variable L90151          as char format "x(40)".
        define variable L90152          as char format "x(40)".
        define variable L90153          as char format "x(40)".
        define variable L90154          as char format "x(40)".
        define variable L90155          as char format "x(40)".
        define variable L90156          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9015 = ENTRY(1,V9015,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF 1 = 1 THEN
        leave V9015L.
        /* LOGICAL SKIP END */
                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9015 no-box.

                /* LABEL 1 - START */
                  L90151 = "" .
                display L90151          format "x(40)" skip with fram F9015 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L90152 = "" .
                display L90152          format "x(40)" skip with fram F9015 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L90153 = "" .
                display L90153          format "x(40)" skip with fram F9015 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L90154 = "" .
                display L90154          format "x(40)" skip with fram F9015 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9015 no-box.
        Update V9015
        WITH  fram F9015 NO-LABEL
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
        IF V9015 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9015.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9015.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9015.
        pause 0.
        leave V9015L.
     END.
     PV9015 = V9015.
     /* END    LINE :9015  OUTPUT TO PRINTER QTY  */


   /* Internal Cycle Input :9110    */
   V9110LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle9110    */
   IF NOT (V9010 = "Y" AND V1700 = "Y" ) THEN LEAVE V9110LMAINLOOP.
     /* START  LINE :9110  条码上数量[QTY ON LABEL] AUTO  */
     V9110L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9110           as char format "x(50)".
        define variable PV9110          as char format "x(50)".
        define variable L91101          as char format "x(40)".
        define variable L91102          as char format "x(40)".
        define variable L91103          as char format "x(40)".
        define variable L91104          as char format "x(40)".
        define variable L91105          as char format "x(40)".
        define variable L91106          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first pt_mstr where pt_part = V1300 no-lock no-error.
If AVAILABLE ( pt_mstr ) then
        V9110 = string ( pt_ord_qty).
        V9110 = ENTRY(1,V9110,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9110 = ENTRY(1,V9110,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9110 no-box.

                /* LABEL 1 - START */
                L91101 = "发料倍数?" .
                display L91101          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L91102 = "MFG图号:" + trim ( V1300 ) .
                display L91102          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L91103 = "批号:" + trim ( V1500 ) .
                display L91103          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L91104 = "" .
                display L91104          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9110 no-box.
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
        define variable V9120           as char format "x(50)".
        define variable PV9120          as char format "x(50)".
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
        V9015 = V9110.
if V9120 = ? THEN
        leave V9120L.
        /* LOGICAL SKIP END */
                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9120 no-box.

                /* LABEL 1 - START */
                L91201 = "标签个数?" .
                display L91201          format "x(40)" skip with fram F9120 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L91202 = "图号:" + trim( V1300 ) .
                display L91202          format "x(40)" skip with fram F9120 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L91203 = "批号:" + Trim(V1500) .
                display L91203          format "x(40)" skip with fram F9120 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L91204 = "" .
                display L91204          format "x(40)" skip with fram F9120 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9120 no-box.
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
        define variable V9130           as char format "x(50)".
        define variable PV9130          as char format "x(50)".
        define variable L91301          as char format "x(40)".
        define variable L91302          as char format "x(40)".
        define variable L91303          as char format "x(40)".
        define variable L91304          as char format "x(40)".
        define variable L91305          as char format "x(40)".
        define variable L91306          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first upd_det where upd_nbr = "por03" and upd_select = 99 no-lock no-error.
If AVAILABLE ( upd_det ) then
        V9130 = UPD_DEV.
        V9130 = ENTRY(1,V9130,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9130 = ENTRY(1,V9130,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF V9120 = ?  THEN
        leave V9130L.
        /* LOGICAL SKIP END */
                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9130 no-box.

                /* LABEL 1 - START */
                L91301 = "打印机?" .
                display L91301          format "x(40)" skip with fram F9130 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L91302 = "条码上数量:" + trim ( V9110 ) .
                display L91302          format "x(40)" skip with fram F9130 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L91303 = "条码个数:" + trim ( V9120) .
                display L91303          format "x(40)" skip with fram F9130 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L91304 = "" .
                display L91304          format "x(40)" skip with fram F9130 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9130 no-box.
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
     PROCEDURE por039130l.
        /* Define Labels Path  Start */
        Define variable LabelsPath as character format "x(100)" init "/app/bc/labels/".
        Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath"no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath = trim ( code_cmmt ).
        If substring(LabelsPath, length(LabelsPath), 1) <> "/" Then
        LabelsPath = LabelsPath + "/".
        /* Define Labels Path  END */
     INPUT FROM VALUE(LabelsPath + "por03").
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
     output to value( trim(wsection) + ".l") .
     Do While True:
              IMPORT UNFORMATTED ts9130.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = pt_um.
       IF INDEX(ts9130,"$U") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$U") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"$U") + length("$U"), LENGTH(ts9130) - ( index(ts9130 ,"$U" ) + length("$U") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = trim(pt_desc1).
       IF INDEX(ts9130,"$F") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$F") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"$F") + length("$F"), LENGTH(ts9130) - ( index(ts9130 ,"$F" ) + length("$F") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = trim(pt_desc2).
       IF INDEX(ts9130,"$E") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$E") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"$E") + length("$E"), LENGTH(ts9130) - ( index(ts9130 ,"$E" ) + length("$E") - 1 ) ).
       END.
        av9130 = if length( trim ( V1500 ) ) >= 8 then substring ( trim ( V1500 ),7,2) else "00".
       IF INDEX(ts9130,"&M") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&M") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"&M") + length("&M"), LENGTH(ts9130) - ( index(ts9130 ,"&M" ) + length("&M") - 1 ) ).
       END.
        av9130 = V1100.
       IF INDEX(ts9130,"$O") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$O") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"$O") + length("$O"), LENGTH(ts9130) - ( index(ts9130 ,"$O" ) + length("$O") - 1 ) ).
       END.
        av9130 = V1300.
       IF INDEX(ts9130,"$P") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$P") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"$P") + length("$P"), LENGTH(ts9130) - ( index(ts9130 ,"$P" ) + length("$P") - 1 ) ).
       END.
        av9130 = string(today).
       IF INDEX(ts9130,"$D") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$D") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"$D") + length("$D"), LENGTH(ts9130) - ( index(ts9130 ,"$D" ) + length("$D") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = if pt_avg_int <> 0 and pt_avg_int <> 90 then "保质期:" + trim ( string ( pt_avg_int ) ) + "月" else "".
       IF INDEX(ts9130,"&D") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&D") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"&D") + length("&D"), LENGTH(ts9130) - ( index(ts9130 ,"&D" ) + length("&D") - 1 ) ).
       END.
        av9130 = trim(V1300) + "@" + trim(V1500).
       IF INDEX(ts9130,"&B") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&B") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"&B") + length("&B"), LENGTH(ts9130) - ( index(ts9130 ,"&B" ) + length("&B") - 1 ) ).
       END.
        av9130 = V9015.
       IF INDEX(ts9130,"$Q") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$Q") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"$Q") + length("$Q"), LENGTH(ts9130) - ( index(ts9130 ,"$Q" ) + length("$Q") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = if pt_drwg_loc <> "" then "ENV DIR:" + trim (pt_drwg_loc) else "".
       IF INDEX(ts9130,"&E") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&E") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"&E") + length("&E"), LENGTH(ts9130) - ( index(ts9130 ,"&E" ) + length("&E") - 1 ) ).
       END.
        av9130 = V1500.
       IF INDEX(ts9130,"$L") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$L") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"$L") + length("$L"), LENGTH(ts9130) - ( index(ts9130 ,"$L" ) + length("$L") - 1 ) ).
       END.
        av9130 = V1200.
       IF INDEX(ts9130,"$G") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$G") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"$G") + length("$G"), LENGTH(ts9130) - ( index(ts9130 ,"$G" ) + length("$G") - 1 ) ).
       END.
        av9130 = if substring( V1104 ,1,1) = "C" then "受检章" else "检验OK".
       IF INDEX(ts9130,"&R") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&R") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"&R") + length("&R"), LENGTH(ts9130) - ( index(ts9130 ,"&R" ) + length("&R") - 1 ) ).
       END.
       put unformatted ts9130 skip.
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.
     unix silent value ("chmod 777  " + trim(wsection) + ".l").
     END PROCEDURE.
     run por039130l.
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
   IF NOT (V9010 = "Y" AND ( ( decimal ( V9110 ) * decimal ( V9120 )  <> decimal ( V1600 ) ) OR Substring(V1104,1,1) = "C" ) ) THEN LEAVE V9140LMAINLOOP.
     /* START  LINE :9140  条码上余数[QTY ON LABEL] 余数  */
     V9140L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9140           as char format "x(50)".
        define variable PV9140          as char format "x(50)".
        define variable L91401          as char format "x(40)".
        define variable L91402          as char format "x(40)".
        define variable L91403          as char format "x(40)".
        define variable L91404          as char format "x(40)".
        define variable L91405          as char format "x(40)".
        define variable L91406          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V9140 = ( string  ( decimal ( V1600 ) - decimal ( V9110 ) * decimal ( V9120 ) ) ).
        V9140 = ENTRY(1,V9140,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9140 = ENTRY(1,V9140,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9140 no-box.

                /* LABEL 1 - START */
                L91401 = "国外/国内-余数?" .
                display L91401          format "x(40)" skip with fram F9140 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L91402 = "MFG图号:" + trim ( V1300 ) .
                display L91402          format "x(40)" skip with fram F9140 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L91403 = "批号" + trim ( V1500 ) .
                display L91403          format "x(40)" skip with fram F9140 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L91404 = "" .
                display L91404          format "x(40)" skip with fram F9140 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9140 no-box.
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
        define variable V9150           as char format "x(50)".
        define variable PV9150          as char format "x(50)".
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
        V9015 = V9140.
IF 1 = 1 THEN
        leave V9150L.
        /* LOGICAL SKIP END */
                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9150 no-box.

                /* LABEL 1 - START */
                L91501 = "标签个数?" .
                display L91501          format "x(40)" skip with fram F9150 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L91502 = "图号:" + trim( V1300 ) .
                display L91502          format "x(40)" skip with fram F9150 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L91503 = "批号:" + Trim(V1500) .
                display L91503          format "x(40)" skip with fram F9150 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L91504 = "" .
                display L91504          format "x(40)" skip with fram F9150 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9150 no-box.
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
        define variable V9160           as char format "x(50)".
        define variable PV9160          as char format "x(50)".
        define variable L91601          as char format "x(40)".
        define variable L91602          as char format "x(40)".
        define variable L91603          as char format "x(40)".
        define variable L91604          as char format "x(40)".
        define variable L91605          as char format "x(40)".
        define variable L91606          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first upd_det where upd_nbr = "POR03" and upd_select = 99 no-lock no-error.
If AVAILABLE ( upd_det ) then
        V9160 = UPD_DEV.
        V9160 = ENTRY(1,V9160,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9160 = ENTRY(1,V9160,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF 1 <> 1 THEN
        leave V9160L.
        /* LOGICAL SKIP END */
                display "[采购收货(严控)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9160 no-box.

                /* LABEL 1 - START */
                L91601 = "打印机?" .
                display L91601          format "x(40)" skip with fram F9160 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L91602 = "条码上余数:" + trim ( V9140 ) .
                display L91602          format "x(40)" skip with fram F9160 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L91603 = "条码个数:" + trim ( V9150) .
                display L91603          format "x(40)" skip with fram F9160 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L91604 = "" .
                display L91604          format "x(40)" skip with fram F9160 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9160 no-box.
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
     PROCEDURE por039160l.
        /* Define Labels Path  Start */
        Define variable LabelsPath as character format "x(100)" init "/app/bc/labels/".
        Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath"no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath = trim ( code_cmmt ).
        If substring(LabelsPath, length(LabelsPath), 1) <> "/" Then
        LabelsPath = LabelsPath + "/".
        /* Define Labels Path  END */
     INPUT FROM VALUE(LabelsPath + "por03").
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
     output to value( trim(wsection) + ".l") .
     Do While True:
              IMPORT UNFORMATTED ts9160.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9160 = pt_um.
       IF INDEX(ts9160,"$U") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$U") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"$U") + length("$U"), LENGTH(ts9160) - ( index(ts9160 ,"$U" ) + length("$U") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9160 = trim(pt_desc1).
       IF INDEX(ts9160,"$F") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$F") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"$F") + length("$F"), LENGTH(ts9160) - ( index(ts9160 ,"$F" ) + length("$F") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9160 = trim(pt_desc2).
       IF INDEX(ts9160,"$E") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$E") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"$E") + length("$E"), LENGTH(ts9160) - ( index(ts9160 ,"$E" ) + length("$E") - 1 ) ).
       END.
        av9160 = if length( trim ( V1500 ) ) >= 8 then substring ( trim ( V1500 ),7,2) else "00".
       IF INDEX(ts9160,"&M") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "&M") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"&M") + length("&M"), LENGTH(ts9160) - ( index(ts9160 ,"&M" ) + length("&M") - 1 ) ).
       END.
        av9160 = V1100.
       IF INDEX(ts9160,"$O") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$O") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"$O") + length("$O"), LENGTH(ts9160) - ( index(ts9160 ,"$O" ) + length("$O") - 1 ) ).
       END.
        av9160 = V1300.
       IF INDEX(ts9160,"$P") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$P") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"$P") + length("$P"), LENGTH(ts9160) - ( index(ts9160 ,"$P" ) + length("$P") - 1 ) ).
       END.
        av9160 = string(today).
       IF INDEX(ts9160,"$D") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$D") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"$D") + length("$D"), LENGTH(ts9160) - ( index(ts9160 ,"$D" ) + length("$D") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9160 = if pt_avg_int <> 0 and pt_avg_int <> 90 then "保质期:" + trim ( string ( pt_avg_int ) ) + "月" else "".
       IF INDEX(ts9160,"&D") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "&D") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"&D") + length("&D"), LENGTH(ts9160) - ( index(ts9160 ,"&D" ) + length("&D") - 1 ) ).
       END.
        av9160 = trim(V1300) + "@" + trim(V1500).
       IF INDEX(ts9160,"&B") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "&B") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"&B") + length("&B"), LENGTH(ts9160) - ( index(ts9160 ,"&B" ) + length("&B") - 1 ) ).
       END.
        av9160 = V9015.
       IF INDEX(ts9160,"$Q") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$Q") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"$Q") + length("$Q"), LENGTH(ts9160) - ( index(ts9160 ,"$Q" ) + length("$Q") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9160 = if pt_drwg_loc <> "" then "ENV DIR:" + trim (pt_drwg_loc) else "".
       IF INDEX(ts9160,"&E") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "&E") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"&E") + length("&E"), LENGTH(ts9160) - ( index(ts9160 ,"&E" ) + length("&E") - 1 ) ).
       END.
        av9160 = V1500.
       IF INDEX(ts9160,"$L") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$L") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"$L") + length("$L"), LENGTH(ts9160) - ( index(ts9160 ,"$L" ) + length("$L") - 1 ) ).
       END.
        av9160 = V1200.
       IF INDEX(ts9160,"$G") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$G") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"$G") + length("$G"), LENGTH(ts9160) - ( index(ts9160 ,"$G" ) + length("$G") - 1 ) ).
       END.
        av9160 = if substring( V1104 ,1,1) = "C" then "受检章" else "检验OK".
       IF INDEX(ts9160,"&R") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "&R") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"&R") + length("&R"), LENGTH(ts9160) - ( index(ts9160 ,"&R" ) + length("&R") - 1 ) ).
       END.
       put unformatted ts9160 skip.
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.
     unix silent value ("chmod 777  " + trim(wsection) + ".l").
     END PROCEDURE.
     
     
/*1z*       图号：V1005                                         */
/*1z*       采购单：V1100                                       */
/*1z*       合同号码：V1108                                     */
/*1z*       装箱单:V1200                                        */
/*1z*       收货日期：D1203                                     */
/*1z*       发货日期:D1204                                      */
/*1z*       项次：V1205                                         */
/*1z*                                                           */
/*1z*       生产日期：D1309                                     */
/*1z*       库位：V1400                                         */
/*1z*       批号：V1500                                         */
/*1z*       收货数量：V1600                                     */
/*1z*                                                           */
/*1z*       确认：V1700                                         */
/*1z*       打印条码:V9010                                      */
/*1z*       发料倍数:V9110                                      */
/*1z*       国外/国内-余数:V9140                                */
/*1z*       标签个数?:V9120                                     */
/*1z*       打印机:V9160                                        */

/*1z*/     procedure lap03090801:
/*1z*/       output to value("./" + trim(wsection) + "por03.l").
/*1z*/            find first pt_mstr no-lock where pt_part = V1005 no-error.
/*1z*/            if available pt_mstr then do:
/*1z*/               put unformat trim(V1005) + "@" + trim(V1500) skip.
/*1z*/               put unformat pt_part skip.  /*图号*/
/*1z*/               put unformat pt_um skip. /*单位*/
/*1z*/               if pt_desc1 <> "" then
/*1z*/                  put unformat pt_desc1 skip. /*名称*/
/*1z*/               else
/*1z*/                  put skip(1).
/*1z*/               if pt_desc2 <> "" then
/*1z*/                  put unformat pt_desc2 skip.
/*1z*/               else
/*1z*/                  put skip(1).
/*1z*/               if trim(V1100) = "" then              /*采购单号*/ 
/*1z*/                  put skip(1).                        
/*1z*/               else                                   
/*1z*/                  put unformat trim(V1100) skip.      
/*1z*/               put unformat today skip.
/*1z*/               put unformat V1600 skip.
/*1z*/               put unformat V1400 skip.
/*1z*/               put unformat V1500 skip.
/*1z*/            end.
/*1z*/          output close.
/*1z*/     end procedure.
/*1z*/
/*1z*/     procedure lap031111:
/*1z*/       find first prd_det where prd_dev = V9160 no-lock no-error.
/*1z*/       if availabl prd_det and prd_type = "BARCODE" and prd_path = "DIR"
/*1z*/          and prd_init_pro <> "" then do:
/*1z*/          if substring(prd_init_pro,length(prd_init_pro)) = "/" then do:
/*1z*/             unix silent value("sudo -u root mv " + "./" + trim(wsection)
/*1z*/                               + "por03.l " + prd_init_pro).
/*1z*/          end.
/*1z*/          else do:
/*1z*/             unix silent value("sudo -u root mv " + "./" + trim(wsection)
/*1z*/                              + "por03.l " +  prd_init_pro + "/").
/*1z*/          end.
/*1z*/       end.
/*1z*/     end procedure.

           run por039160l.
/*1z*/           run lap03090801.
/*1z*/           run lap031111.


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
end.
