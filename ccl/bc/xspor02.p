/* Generate By Barcode Generator , Copyright by Softspeed - Build By Sam Song  */ 
/* PO RECEIPT [SUBCONTRACT] */
/* Generate date / time  2006-11-27 15:47:08 */
define variable sectionid as integer init 0 .
define variable WMESSAGE  as char format "x(80)" init "".
define variable wtm_num   as char format "x(20)" init "0".
define variable wtm_fm    as char format "x(16)".
define variable wsection as char format "x(16)".
define variable i as integer .

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout" no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xspor02wtimeout" no-lock no-error. /*  Timeout - Program Level */
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
                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 no-box.

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
     /* START  LINE :1100  粒劃等[PO]  */
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
                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1100 no-box.

                /* LABEL 1 - START */ 
                L11001 = "採購單?" .
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
                  IF recid(PO_MSTR) = ? THEN find first PO_MSTR where 
                              INDEX("XC",PO_STAT) = 0 AND PO_TYPE <> "B" AND (PO_SITE = "" OR PO_SITE = V1002) AND  
                              PO_NBR >=  INPUT V1100
                               no-lock no-error.
                  ELSE find next PO_MSTR where 
                              INDEX("XC",PO_STAT) = 0 AND PO_TYPE <> "B" AND (PO_SITE = "" OR PO_SITE = V1002)  
                               no-lock no-error.
                  IF AVAILABLE PO_MSTR then display skip 
            PO_NBR @ V1100 trim( PO_NBR ) + "/" + trim( PO_VEND ) @ WMESSAGE NO-LABEL with fram F1100.
                  else   display skip "" @ WMESSAGE with fram F1100.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(PO_MSTR) = ? THEN find first PO_MSTR where 
                              INDEX("XC",PO_STAT) = 0 AND PO_TYPE <> "B" AND (PO_SITE = "" OR PO_SITE = V1002) AND  
            PO_NBR <=  INPUT V1100
                               no-lock no-error.
                  ELSE find prev PO_MSTR where 
                              INDEX("XC",PO_STAT) = 0 AND PO_TYPE <> "B" AND (PO_SITE = "" OR PO_SITE = V1002) 
                               no-lock no-error.
                  IF AVAILABLE PO_MSTR then display skip 
            PO_NBR @ V1100 trim( PO_NBR ) + "/" + trim( PO_VEND ) @ WMESSAGE NO-LABEL with fram F1100.
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
        find first PO_MSTR where PO_NBR = V1100 AND INDEX("XC",PO_STAT) = 0 AND PO_TYPE <> "B" AND (PO_SITE = "" OR PO_SITE = V1002)  NO-ERROR NO-WAIT.
        IF NOT AVAILABLE PO_MSTR then do:
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
     /* END    LINE :1100  粒劃等[PO]  */


   /* Additional Labels Format */
     /* START  LINE :1101  粒劃啟  */
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

                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1101 no-box.

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
                display "輸入或按E退出 "      format "x(40)" skip
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
     /* END    LINE :1101  粒劃啟  */


   /* Additional Labels Format */
     /* START  LINE :1102  掛弇啟  */
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

                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1102 no-box.

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
                display "輸入或按E退出 "      format "x(40)" skip
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
     /* END    LINE :1102  掛弇啟  */


   /* Additional Labels Format */
     /* START  LINE :1103  嘐隅颯薹 = Y 祥泐堤  */
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

                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1103 no-box.

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
                display "輸入或按E退出 "      format "x(40)" skip
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
     /* END    LINE :1103  嘐隅颯薹 = Y 祥泐堤  */


   /* Additional Labels Format */
     /* START  LINE :1200  蚾眊等[Packing No]  */
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
                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1200 no-box.

                /* LABEL 1 - START */ 
                L12001 = "裝箱單" .
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
                display "輸入或按E退出 "      format "x(40)" skip
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
        IF not trim(V1200) <> "" and length ( trim (V1200) ) <= 12 THEN DO:
                display skip "不能為空!" @ WMESSAGE NO-LABEL with fram F1200.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1200.
        pause 0.
        leave V1200L.
     END.
     PV1200 = V1200.
     /* END    LINE :1200  蚾眊等[Packing No]  */


   /* Additional Labels Format */
     /* START  LINE :1203  汜虴�梪�  */
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
                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1203 no-box.

                /* LABEL 1 - START */ 
                L12031 = "收貨日期?" .
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
                display "輸入或按E退出 "      format "x(40)" skip
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
     /* END    LINE :1203  汜虴�梪�  */


   /* Additional Labels Format */
   /* Internal Cycle Input :1205    */
   V1205LMAINLOOP:
   REPEAT:
     /* START  LINE :1205  粒劃砐棒 SKIP ONLY ONE  */
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
        find first pod_det where pod_nbr = V1100  and pod_site = V1002 and index("XC",pod_status) = 0 and pod_type = "S" no-lock no-error.
If AVAILABLE (pod_det) and string ( pod_line ) <> V1205 then
        V1205 = string ( pod_line ).
        V1205 = ENTRY(1,V1205,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1205 = ENTRY(1,V1205,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        find last pod_det where pod_nbr = V1100  and pod_site = V1002  and index("XC",pod_status) = 0 and pod_type = "S"  no-lock no-error.
If AVAILABLE (pod_det) and string ( pod_line ) = V1205 then
        leave V1205L.
        /* LOGICAL SKIP END */
                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1205 no-box.

                /* LABEL 1 - START */ 
                L12051 = "採購項次" .
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
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1205 no-box.
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
                              pod_nbr = V1100 and 
pod_site = V1002 and index( "XC",pod_status ) = 0  and pod_type = "S" AND  
                              string ( POD_LINE ) >=  INPUT V1205
                               no-lock no-error.
                  ELSE find next POD_DET where 
                              pod_nbr = V1100 and 
pod_site = V1002 and index( "XC",pod_status ) = 0  and pod_type = "S"  
                               no-lock no-error.
                  IF AVAILABLE POD_DET then display skip 
            string ( POD_LINE ) @ V1205 trim(POD_PART) + "*" + String( POD_DUE_DATE) + "*" + string ( if ( pod_qty_ord - pod_qty_rcvd ) > 0 then ( pod_qty_ord - pod_qty_rcvd ) else 0 ) @ WMESSAGE NO-LABEL with fram F1205.
                  else   display skip "" @ WMESSAGE with fram F1205.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(POD_DET) = ? THEN find first POD_DET where 
                              pod_nbr = V1100 and 
pod_site = V1002 and index( "XC",pod_status ) = 0  and pod_type = "S" AND  
            string ( POD_LINE ) <=  INPUT V1205
                               no-lock no-error.
                  ELSE find prev POD_DET where 
                              pod_nbr = V1100 and 
pod_site = V1002 and index( "XC",pod_status ) = 0  and pod_type = "S" 
                               no-lock no-error.
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
        find first POD_DET where POD_NBR = V1100 AND 
pod_site = V1002 AND string( POD_LINE ) = Trim(V1205) and index ( "XC",pod_status ) = 0  and pod_type = "S"  NO-ERROR NO-WAIT.
        IF NOT AVAILABLE POD_DET then do:
                display skip "該項次有誤!" @ WMESSAGE NO-LABEL with fram F1205.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1205.
        pause 0.
        leave V1205L.
     END.
     PV1205 = V1205.
     /* END    LINE :1205  粒劃砐棒 SKIP ONLY ONE  */


   /* Additional Labels Format */
     /* START  LINE :1300  蹋こ[Raw Material]  */
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
        find first pod_det where pod_nbr = V1100  and string ( pod_line ) = V1205 and pod_type = "S"  no-lock no-error.
If AVAILABLE (pod_det) then
        V1300 = pod_part.
        V1300 = ENTRY(1,V1300,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1300 = ENTRY(1,V1300,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1300 no-box.

                /* LABEL 1 - START */ 
                find first pod_det where pod_nbr = V1100  and string ( pod_line ) = V1205 no-lock no-error.
If AVAILABLE (pod_det) then
                L13001 = "料品:" + pod_part .
                else L13001 = "" . 
                display L13001          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find first pt_mstr where pt_part = V1300 no-lock no-error.
If AVAILABLE (pt_mstr) then
                L13002 = "描述:" + trim ( pt_desc1 ) .
                else L13002 = "" . 
                display L13002          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first pt_mstr where pt_part = V1300 no-lock no-error.
If AVAILABLE (pt_mstr) then
                L13003 = "保質期:" + trim ( string ( pt_shelflife ) ) + "天" .
                else L13003 = "" . 
                display L13003          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                find first pod_det where pod_nbr = V1100  and string ( pod_line ) = V1205 no-lock no-error.
If AVAILABLE (pod_det) then
                L13004 = "項次/未結數量:" + trim ( V1205 ) + "/" + string ( if ( pod_qty_ord - pod_qty_rcvd ) > 0 then ( pod_qty_ord - pod_qty_rcvd ) else 0 ) .
                else L13004 = "" . 
                display L13004          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
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
     /* END    LINE :1300  蹋こ[Raw Material]  */


   /* Additional Labels Format */
     /* START  LINE :1301  Supplier  */
     V1301L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1301           as char format "x(50)".
        define variable PV1301          as char format "x(50)".
        define variable L13011          as char format "x(40)".
        define variable L13012          as char format "x(40)".
        define variable L13013          as char format "x(40)".
        define variable L13014          as char format "x(40)".
        define variable L13015          as char format "x(40)".
        define variable L13016          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first po_mstr where po_nbr = V1100  no-lock no-error.
If AVAILABLE (po_mstr) then
        V1301 = trim( po_vend ).
        V1301 = ENTRY(1,V1301,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1301 = ENTRY(1,V1301,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1301L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1301L .
        /* --CYCLE TIME SKIP -- END  */

                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1301 no-box.

                /* LABEL 1 - START */ 
                  L13011 = "" . 
                display L13011          format "x(40)" skip with fram F1301 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L13012 = "" . 
                display L13012          format "x(40)" skip with fram F1301 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L13013 = "" . 
                display L13013          format "x(40)" skip with fram F1301 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13014 = "" . 
                display L13014          format "x(40)" skip with fram F1301 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1301 no-box.
        /* DISPLAY ONLY */
        define variable X1301           as char format "x(40)".
        X1301 = V1301.
        V1301 = "".
        /* DISPLAY ONLY */
        Update V1301
        WITH  fram F1301 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V1301 = X1301.
        /* DISPLAY ONLY */
        LEAVE V1301L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1301 = "e" THEN  LEAVE V1205LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1301.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1301.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1301.
        pause 0.
        leave V1301L.
     END.
     PV1301 = V1301.
     /* END    LINE :1301  Supplier  */


   /* Additional Labels Format */
     /* START  LINE :1302  馱等ID WO ID  */
     V1302L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1302           as char format "x(50)".
        define variable PV1302          as char format "x(50)".
        define variable L13021          as char format "x(40)".
        define variable L13022          as char format "x(40)".
        define variable L13023          as char format "x(40)".
        define variable L13024          as char format "x(40)".
        define variable L13025          as char format "x(40)".
        define variable L13026          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first pod_det where pod_nbr = V1100  and string ( pod_line ) = V1205 and pod_type = "S"  no-lock no-error.
If AVAILABLE (pod_det) then
        V1302 = pod_wo_lot.
        V1302 = ENTRY(1,V1302,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1302 = ENTRY(1,V1302,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1302L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1302L .
        /* --CYCLE TIME SKIP -- END  */

                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1302 no-box.

                /* LABEL 1 - START */ 
                L13021 = "工單ID" .
                display L13021          format "x(40)" skip with fram F1302 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L13022 = "" . 
                display L13022          format "x(40)" skip with fram F1302 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L13023 = "" . 
                display L13023          format "x(40)" skip with fram F1302 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13024 = "" . 
                display L13024          format "x(40)" skip with fram F1302 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1302 no-box.
        /* DISPLAY ONLY */
        define variable X1302           as char format "x(40)".
        X1302 = V1302.
        V1302 = "".
        /* DISPLAY ONLY */
        Update V1302
        WITH  fram F1302 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V1302 = X1302.
        /* DISPLAY ONLY */
        LEAVE V1302L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1302 = "e" THEN  LEAVE V1205LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1302.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1302.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1302.
        pause 0.
        leave V1302L.
     END.
     PV1302 = V1302.
     /* END    LINE :1302  馱等ID WO ID  */


   /* Additional Labels Format */
     /* START  LINE :1303  OP FOR WO  */
     V1303L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1303           as char format "x(50)".
        define variable PV1303          as char format "x(50)".
        define variable L13031          as char format "x(40)".
        define variable L13032          as char format "x(40)".
        define variable L13033          as char format "x(40)".
        define variable L13034          as char format "x(40)".
        define variable L13035          as char format "x(40)".
        define variable L13036          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first pod_det where pod_nbr = V1100  and string ( pod_line ) = V1205 and pod_type = "S"  no-lock no-error.
If AVAILABLE (pod_det) then
        V1303 = string ( pod_op ).
        V1303 = ENTRY(1,V1303,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1303 = ENTRY(1,V1303,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1303L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1303L .
        /* --CYCLE TIME SKIP -- END  */

                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1303 no-box.

                /* LABEL 1 - START */ 
                L13031 = "WO OP" .
                display L13031          format "x(40)" skip with fram F1303 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L13032 = "" . 
                display L13032          format "x(40)" skip with fram F1303 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L13033 = "" . 
                display L13033          format "x(40)" skip with fram F1303 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13034 = "" . 
                display L13034          format "x(40)" skip with fram F1303 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1303 no-box.
        /* DISPLAY ONLY */
        define variable X1303           as char format "x(40)".
        X1303 = V1303.
        V1303 = "".
        /* DISPLAY ONLY */
        Update V1303
        WITH  fram F1303 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V1303 = X1303.
        /* DISPLAY ONLY */
        LEAVE V1303L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1303 = "e" THEN  LEAVE V1205LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1303.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1303.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        If V1303 = "" OR V1303 = "-" OR V1303 = "." OR V1303 = ".-" OR V1303 = "-." then do:
                display skip "CAN NOT EMPTY  " @ WMESSAGE NO-LABEL with fram F1303.
                pause 0 before-hide.
                undo, retry.
        end.
        DO i = 1 to length(V1303).
                If index("0987654321.-", substring(V1303,i,1)) = 0 then do:
                display skip "Format  Error  " @ WMESSAGE NO-LABEL with fram F1303.
                pause 0 before-hide.
                undo, retry.
                end.
        end.
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1303.
        pause 0.
        leave V1303L.
     END.
     PV1303 = V1303.
     /* END    LINE :1303  OP FOR WO  */


   /* Additional Labels Format */
     /* START  LINE :1304  ERR:SupplierItem  */
     V1304L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1304           as char format "x(50)".
        define variable PV1304          as char format "x(50)".
        define variable L13041          as char format "x(40)".
        define variable L13042          as char format "x(40)".
        define variable L13043          as char format "x(40)".
        define variable L13044          as char format "x(40)".
        define variable L13045          as char format "x(40)".
        define variable L13046          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1304 = "E".
        V1304 = ENTRY(1,V1304,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1304 = ENTRY(1,V1304,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        find first vp_mstr where vp_vend = V1301 and   vp_part = V1300 and   vp_tp_use_pct = yes  and substring (  trim (userid(sdbname('qaddb')))  ,1,2 ) <> "HK" no-lock no-error.
If NOT AVAILABLE (vp_mstr) THEN
        leave V1304L.
        /* LOGICAL SKIP END */
                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1304 no-box.

                /* LABEL 1 - START */ 
                L13041 = "警告!HK收貨" .
                display L13041          format "x(40)" skip with fram F1304 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L13042 = "供應商:" + trim ( V1301 ) .
                display L13042          format "x(40)" skip with fram F1304 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L13043 = "料號:" + trim ( V1300 ) .
                display L13043          format "x(40)" skip with fram F1304 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L13044 = "按E退出,Y繼續" .
                display L13044          format "x(40)" skip with fram F1304 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1304 no-box.
        Update V1304
        WITH  fram F1304 NO-LABEL
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
        IF V1304 = "e" THEN  LEAVE V1205LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1304.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1304.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1304.
        pause 0.
        leave V1304L.
     END.
     PV1304 = V1304.
     /* END    LINE :1304  ERR:SupplierItem  */


   /* Additional Labels Format */
     /* START  LINE :1305  INSP_LOC剒潰蹋こ蘇�狤瑢�-偌莉こ盄  */
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

                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1305 no-box.

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
                display "輸入或按E退出 "      format "x(40)" skip
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
     /* END    LINE :1305  INSP_LOC剒潰蹋こ蘇�狤瑢�-偌莉こ盄  */


   /* Additional Labels Format */
     /* START  LINE :1306  PT_LOC 轎潰蹋こ蘇�狤瑢�-偌莉こ盄  */
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
        find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr ) then
        V1306 = pt_loc.
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

                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1306 no-box.

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
                display "輸入或按E退出 "      format "x(40)" skip
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
     /* END    LINE :1306  PT_LOC 轎潰蹋こ蘇�狤瑢�-偌莉こ盄  */


   /* Additional Labels Format */
     /* START  LINE :1307  莉こ盄  */
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

                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1307 no-box.

                /* LABEL 1 - START */ 
                L13071 = "產品線" .
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
                display "輸入或按E退出 "      format "x(40)" skip
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
     /* END    LINE :1307  莉こ盄  */


   /* Additional Labels Format */
     /* START  LINE :1309  汜莉�梪�(Create LOT) - CANCEL  */
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

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1309L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1309L .
        /* --CYCLE TIME SKIP -- END  */

                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1309 no-box.

                /* LABEL 1 - START */ 
                L13091 = "生產日期?" .
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
                display "輸入或按E退出 "      format "x(40)" skip
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
     /* END    LINE :1309  汜莉�梪�(Create LOT) - CANCEL  */


   /* Additional Labels Format */
     /* START  LINE :1400  踱弇[LOC] - INSP  */
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
        find first CODE_MSTR where CODE_FLDNAME = "BARCODE" and CODE_VALUE = "PT_PROD_LINE_USEPTLOC" and trim ( CODE_CMMT ) = trim ( V1307 ) no-lock no-error.
If AVAILABLE (CODE_MSTR) then V1305 = "".
        V1400 = If AVAILABLE (CODE_MSTR) then V1306 else V1305.
        V1400 = ENTRY(1,V1400,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1400 = ENTRY(1,V1400,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1400 no-box.

                /* LABEL 1 - START */ 
                L14001 = "庫位?" .
                display L14001          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L14002 = "產品線:" + trim ( V1307 ) .
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
                L14004 = "**免檢料品" .
                else L14004 = "" . 
                display L14004          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1400 no-box.
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
                  ELSE find next LOC_MSTR where 
                              LOC_SITE = V1002  
                               no-lock no-error.
                  IF AVAILABLE LOC_MSTR then display skip 
            LOC_LOC @ V1400 LOC_DESC @ WMESSAGE NO-LABEL with fram F1400.
                  else   display skip "" @ WMESSAGE with fram F1400.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(LOC_MSTR) = ? THEN find first LOC_MSTR where 
                              LOC_SITE = V1002 AND  
            LOC_LOC <=  INPUT V1400
                               no-lock no-error.
                  ELSE find prev LOC_MSTR where 
                              LOC_SITE = V1002 
                               no-lock no-error.
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
                display skip "錯誤,重試." @ WMESSAGE NO-LABEL with fram F1400.
                pause 0 before-hide.
                undo, retry.
        end.
        IF not ( V1305 = "" OR V1305 <> "" AND ( V1400 = "CIQ001" OR V1400 = "HM0001" ) ) THEN DO:
                display skip "錯誤,重試." @ WMESSAGE NO-LABEL with fram F1400.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1400.
        pause 0.
        leave V1400L.
     END.
     PV1400 = V1400.
     /* END    LINE :1400  踱弇[LOC] - INSP  */


   /* Additional Labels Format */
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

                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1410 no-box.

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
                display "輸入或按E退出 "      format "x(40)" skip
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


   /* Additional Labels Format */
     /* START  LINE :1500  蠶瘍[LOT]  */
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
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1500 = ENTRY(1,V1500,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF V1410 = "L" then do:
{xsglot2.i}
end.
IF 1 = 1 then
        leave V1500L.
        /* LOGICAL SKIP END */
                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1500 no-box.

                /* LABEL 1 - START */ 
                L15001 = "批號?" .
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
                display "輸入或按E退出 "      format "x(40)" skip
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
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1500.
        pause 0.
        leave V1500L.
     END.
     IF INDEX(V1500,"@" ) <> 0 then V1500 = ENTRY(2,V1500,"@").
     PV1500 = V1500.
     /* END    LINE :1500  蠶瘍[LOT]  */


   /* Additional Labels Format */
     /* START  LINE :1501  L Checking & WO Status Checking & Location  */
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
        find first wo_mstr where wo_lot = V1302 and wo_status = "R" and wo_site = V1002 no-lock no-error.
If AVAILABLE (wo_mstr) and V1410 = "L" AND V1306 <> "" THEN
        leave V1501L.
        /* LOGICAL SKIP END */
                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1501 no-box.

                /* LABEL 1 - START */ 
                L15011 = "ERR:LOT/LOC控制" .
                display L15011          format "x(40)" skip with fram F1501 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L15012 = "請在1.4.1進行定義" .
                display L15012          format "x(40)" skip with fram F1501 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L15013 = "ERR:委外工單有誤" .
                display L15013          format "x(40)" skip with fram F1501 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L15014 = "工單ID:" + trim (V1302) + "查核!" .
                display L15014          format "x(40)" skip with fram F1501 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
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
     /* END    LINE :1501  L Checking & WO Status Checking & Location  */


   /* Additional Labels Format */
     /* START  LINE :1550  等弇遙呾掀瞰[UM FACTOR]  */
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
        find first pod_det where pod_nbr = V1100 and  string ( pod_line ) = V1205 and pod_type = "S"  no-lock no-error.
If AVAILABLE (pod_det) then
        V1550 = string ( pod_um_conv ).
        V1550 = ENTRY(1,V1550,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1550 = ENTRY(1,V1550,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        find first pod_det where pod_nbr = V1100 and string( pod_line)  = V1205   and pod_type = "S"  no-lock no-error.
If AVAILABLE (pod_det) and pod_um_conv = 1 then
        leave V1550L.
        /* LOGICAL SKIP END */
                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1550 no-box.

                /* LABEL 1 - START */ 
                L15501 = "料品:" + trim( V1300 ) .
                display L15501          format "x(40)" skip with fram F1550 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find first pod_det where pod_nbr = V1100 and string( pod_line)  = V1205 and pod_type = "S"  no-lock no-error.
If AVAILABLE (pod_det) then
                L15502 = "採購單位:" + pod_um .
                else L15502 = "" . 
                display L15502          format "x(40)" skip with fram F1550 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first pod_det where pod_nbr = V1100 and string( pod_line)  = V1205  and pod_type = "S"  no-lock no-error.
If AVAILABLE (pod_det) then
                L15503 = "轉換比例:" + string (pod_um_conv) .
                else L15503 = "" . 
                display L15503          format "x(40)" skip with fram F1550 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                find first pt_mstr where pt_part = V1300 no-lock no-error.
If AVAILABLE (pt_mstr) then
                L15504 = "庫存單位:" + pt_um .
                else L15504 = "" . 
                display L15504          format "x(40)" skip with fram F1550 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
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
     /* END    LINE :1550  等弇遙呾掀瞰[UM FACTOR]  */


   /* Additional Labels Format */
     /* START  LINE :1558  �搚蹎鯚貕鉌梬巏� (硐諷秶杅講�搚�,踢塗�搚�=郔湮)  */
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
        V1558 = string ( ( poc_tol_pct / 100  + 1 ) * ( pod_qty_ord - pod_qty_rcvd ) ).
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

                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1558 no-box.

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
                display "輸入或按E退出 "      format "x(40)" skip
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
     /* END    LINE :1558  �搚蹎鯚貕鉌梬巏� (硐諷秶杅講�搚�,踢塗�搚�=郔湮)  */


   /* Additional Labels Format */
     /* START  LINE :1600  杅講[QTY](粒劃等UM)  */
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
                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1600 no-box.

                /* LABEL 1 - START */ 
                L16001 = "收貨數量?" .
                display L16001          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L16002 = "料品:" + trim( V1300 ) .
                display L16002          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L16003 = "批號:" + Trim(V1500) .
                display L16003          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                find first pod_det where pod_nbr = V1100 and string( pod_line)  = V1205  no-lock no-error.
If AVAILABLE (pod_det) then
                L16004 = "單位:" + trim( pod_um ) + "/" + trim ( V1400 ) .
                else L16004 = "" . 
                display L16004          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
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
                display skip "超過容差!!" @ WMESSAGE NO-LABEL with fram F1600.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1600.
        pause 0.
        leave V1600L.
     END.
     PV1600 = V1600.
     /* END    LINE :1600  杅講[QTY](粒劃等UM)  */


   /* Additional Labels Format */
     /* START  LINE :1610  INV QTY  */
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
                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1610 no-box.

                /* LABEL 1 - START */ 
                find first pod_det where pod_nbr = V1100 and string( pod_line)  = V1205  no-lock no-error.
If AVAILABLE (pod_det) then
                L16101 = "收貨數量:" + string (V1600 ) + " " + pod_um .
                else L16101 = "" . 
                display L16101          format "x(40)" skip with fram F1610 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L16102 = "轉換因子# 1:" + V1550 .
                display L16102          format "x(40)" skip with fram F1610 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first pt_mstr where pt_part = V1300 no-lock no-error.
If AVAILABLE (pt_mstr) THEN
                L16103 = "庫存數量:" + string ( decimal ( V1550 ) * decimal ( V1600 ) ) + " " + trim ( pt_um ) .
                else L16103 = "" . 
                display L16103          format "x(40)" skip with fram F1610 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L16104 = "" . 
                display L16104          format "x(40)" skip with fram F1610 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
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
     /* END    LINE :1610  INV QTY  */


   /* Additional Labels Format */
     /* START  LINE :1700  �溜枮CONFIRM]  */
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
        V1700 = "E".
        V1700 = ENTRY(1,V1700,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1700 = ENTRY(1,V1700,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1700 no-box.

                /* LABEL 1 - START */ 
                L17001 = "料品:" + trim(V1300) .
                display L17001          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L17002 = "批號:" + trim ( V1500 ) .
                display L17002          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L17003 = "庫位:" + trim ( V1400 ) + "/" + trim( V1600 ) .
                display L17003          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                find first pod_det where pod_nbr = V1100 and  string ( pod_line ) = V1205 no-lock no-error.
If AVAILABLE (pod_det) then
                L17004 = "未結數量:" + string ( pod_qty_ord - pod_qty_rcvd ) .
                else L17004 = "" . 
                display L17004          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 4 - END */ 
                display "確認過帳[Y],E退出"   format "x(40)" skip
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
        find first po_mstr where PO_NBR = V1100 AND INDEX("XC",PO_STAT) = 0 AND PO_TYPE <> "B"  NO-ERROR NO-WAIT.
        IF NOT AVAILABLE po_mstr then do:
                display skip "無效或被鎖!" @ WMESSAGE NO-LABEL with fram F1700.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1700.
        pause 0.
        leave V1700L.
     END.
     PV1700 = V1700.
     /* END    LINE :1700  �溜枮CONFIRM]  */


   /* Additional Labels Format */
     /* START  LINE :1702  L Checking & WO Status Checking & Location  */
     V1702L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1702           as char format "x(50)".
        define variable PV1702          as char format "x(50)".
        define variable L17021          as char format "x(40)".
        define variable L17022          as char format "x(40)".
        define variable L17023          as char format "x(40)".
        define variable L17024          as char format "x(40)".
        define variable L17025          as char format "x(40)".
        define variable L17026          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1702 = "E".
        V1702 = ENTRY(1,V1702,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1702 = ENTRY(1,V1702,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        find first wo_mstr where wo_lot = V1302 and wo_status = "R" and wo_site = V1002 NO-ERROR NO-WAIT.
If AVAILABLE (wo_mstr) and V1410 = "L" AND V1306 <> "" THEN
        leave V1702L.
        /* LOGICAL SKIP END */
                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1702 no-box.

                /* LABEL 1 - START */ 
                L17021 = "ERR:LOT/LOC控制" .
                display L17021          format "x(40)" skip with fram F1702 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L17022 = "請在1.4.1進行定義" .
                display L17022          format "x(40)" skip with fram F1702 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L17023 = "ERR:委外工單有誤" .
                display L17023          format "x(40)" skip with fram F1702 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L17024 = "工單ID:" + trim (V1302) + "查核!" .
                display L17024          format "x(40)" skip with fram F1702 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1702 no-box.
        Update V1702
        WITH  fram F1702 NO-LABEL
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
        IF V1702 = "e" THEN  LEAVE V1205LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1702.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1702.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not trim(V1702) = "E" THEN DO:
                display skip "Error , Retry " @ WMESSAGE NO-LABEL with fram F1702.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1702.
        pause 0.
        leave V1702L.
     END.
     PV1702 = V1702.
     /* END    LINE :1702  L Checking & WO Status Checking & Location  */


   /* Additional Labels Format */
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

                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9000 no-box.

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
                display "輸入或按E退出 "      format "x(40)" skip
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


   /* Additional Labels Format */
        display "...PROCESSING...  " NO-LABEL with fram F9000X no-box.
        pause 0.
     /*  Update MFG/PRO START  */ 
     {xspor02u.i}
     /*  Update MFG/PRO END  */ 
        display  "" NO-LABEL with fram F9000X no-box .
        pause 0.
     /* START  LINE :9005  ��2弇苤杅萸/ Blank Expire Date  */
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
        {xspo2s.i}
IF 1 = 1 THEN
        leave V9005L.
        /* LOGICAL SKIP END */
                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9005 no-box.

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
                display "輸入或按E退出 "      format "x(40)" skip
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
     /* END    LINE :9005  ��2弇苤杅萸/ Blank Expire Date  */


   /* Additional Labels Format */
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
                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9010 no-box.

                /* LABEL 1 - START */ 
                find last tr_hist where 
tr_date = today     and 
tr_trnbr > integer ( V9000 ) and 
tr_nbr  = V1100     and  tr_type = "RCT-PO"  and  
tr_site = V1002     and tr_part = V1300     and tr_serial = V1500  
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
tr_nbr  = V1100     and  tr_type = "RCT-PO"  and  tr_site = V1002     and tr_part = V1300     and tr_serial = V1500  
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
tr_nbr  = V1100     and  tr_type = "RCT-PO"  and  tr_site = V1002     and tr_part = V1300     and tr_serial = V1500   
use-index tr_date_trn no-lock no-error.
If NOT AVAILABLE ( tr_hist ) then
                L90103 = "交易提交失敗" .
                else L90103 = "" . 
                display L90103          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L90104 = "按Y打印條碼,E退出" .
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


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1205LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :9010    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :9110    */
   V9110LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle9110    */
   IF NOT (V9010 = "Y" AND V1700 = "Y" ) THEN LEAVE V9110LMAINLOOP.
     /* START  LINE :9110  沭鎢奻杅講[QTY ON LABEL] AUTO  */
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
        find first pod_det where pod_nbr = V1100 and  string ( pod_line ) = V1205 no-lock no-error.
If AVAILABLE (pod_det) then
        V9110 = string ( decimal ( V1610 ) ).
        V9110 = ENTRY(1,V9110,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9110 = ENTRY(1,V9110,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9110 no-box.

                /* LABEL 1 - START */ 
                find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr ) then
                L91101 = pt_um + " 標簽數量?" .
                else L91101 = "" . 
                display L91101          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L91102 = "料品:" + trim( V1300 ) .
                display L91102          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L91103 = "批號:" + Trim(V1500) .
                display L91103          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                find first pod_det where pod_nbr = V1100 and  string ( pod_line ) = V1205 no-lock no-error.
If AVAILABLE (pod_det) then
                L91104 = string ( decimal ( V1610 ) ) .
                else L91104 = "" . 
                display L91104          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
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
        IF not V9110 <> "0" THEN DO:
                display skip "Error , Retry " @ WMESSAGE NO-LABEL with fram F9110.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9110.
        pause 0.
        leave V9110L.
     END.
     PV9110 = V9110.
     /* END    LINE :9110  沭鎢奻杅講[QTY ON LABEL] AUTO  */


   /* Additional Labels Format */
     /* START  LINE :9120  沭鎢跺杅[No Of Label] AUTO  */
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
        V9120 = "1".
        V9120 = ENTRY(1,V9120,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9120 = ENTRY(1,V9120,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9120 no-box.

                /* LABEL 1 - START */ 
                L91201 = "標簽個數?" .
                display L91201          format "x(40)" skip with fram F9120 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L91202 = "料品:" + trim( V1300 ) .
                display L91202          format "x(40)" skip with fram F9120 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L91203 = "批號:" + Trim(V1500) .
                display L91203          format "x(40)" skip with fram F9120 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L91204 = "" . 
                display L91204          format "x(40)" skip with fram F9120 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
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
     /* END    LINE :9120  沭鎢跺杅[No Of Label] AUTO  */


   wtm_num = V9120.
   /* Additional Labels Format */
     /* START  LINE :9130  湖荂儂[Printer]  */
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
        find first upd_det where upd_nbr = "por02" and upd_select = 99 no-lock no-error.
If AVAILABLE ( upd_det ) then
        V9130 = UPD_DEV.
        V9130 = ENTRY(1,V9130,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9130 = ENTRY(1,V9130,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF 1 <> 1 THEN
        leave V9130L.
        /* LOGICAL SKIP END */
                display "[採購收貨(委外)]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9130 no-box.

                /* LABEL 1 - START */ 
                L91301 = "打印機?" .
                display L91301          format "x(40)" skip with fram F9130 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L91302 = "條碼上數量:" + trim ( V9110 ) .
                display L91302          format "x(40)" skip with fram F9130 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L91303 = "條碼個數:" + trim ( V9120) .
                display L91303          format "x(40)" skip with fram F9130 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L91304 = "" . 
                display L91304          format "x(40)" skip with fram F9130 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F9130 no-box.
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
                  ELSE find next PRD_DET where 
                               no-lock no-error.
                  IF AVAILABLE PRD_DET then display skip 
            PRD_DEV @ V9130 PRD_DESC @ WMESSAGE NO-LABEL with fram F9130.
                  else   display skip "" @ WMESSAGE with fram F9130.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(PRD_DET) = ? THEN find first PRD_DET where 
            PRD_DEV <=  INPUT V9130
                               no-lock no-error.
                  ELSE find prev PRD_DET where 
                               no-lock no-error.
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
                display skip "打印機有誤 " @ WMESSAGE NO-LABEL with fram F9130.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9130.
        pause 0.
        leave V9130L.
     END.
     PV9130 = V9130.
     /* END    LINE :9130  湖荂儂[Printer]  */


   /* Additional Labels Format */
     Define variable ts9130 AS CHARACTER FORMAT "x(100)".
     Define variable av9130 AS CHARACTER FORMAT "x(100)".
     PROCEDURE por029130l.
        /* Define Labels Path  Start */
        Define variable LabelsPath as character format "x(100)" init "/mfgpro/rf/labels/".
        Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath"no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath = trim ( code_cmmt ).
        If substring(LabelsPath, length(LabelsPath), 1) <> "/" Then 
        LabelsPath = LabelsPath + "/".
        /* Define Labels Path  END */
     INPUT FROM VALUE(LabelsPath + "por02" + trim ( wtm_fm ) ).
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
     output to value( trim(wsection) + ".l") .
     Do While True:
              IMPORT UNFORMATTED ts9130.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = trim(pt_desc1).
       IF INDEX(ts9130,"$F") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$F") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$F") + length("$F"), LENGTH(ts9130) - ( index(ts9130 ,"$F" ) + length("$F") - 1 ) ).
       END.
        av9130 = if length( trim ( V1500 ) ) >= 8 then substring ( trim ( V1500 ),7,2) else "00".
       IF INDEX(ts9130,"&M") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&M") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"&M") + length("&M"), LENGTH(ts9130) - ( index(ts9130 ,"&M" ) + length("&M") - 1 ) ).
       END.
        av9130 = string(today).
       IF INDEX(ts9130,"$D") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$D") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$D") + length("$D"), LENGTH(ts9130) - ( index(ts9130 ,"$D" ) + length("$D") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = pt_um.
       IF INDEX(ts9130,"$U") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$U") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$U") + length("$U"), LENGTH(ts9130) - ( index(ts9130 ,"$U" ) + length("$U") - 1 ) ).
       END.
        av9130 = V1500.
       IF INDEX(ts9130,"$L") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$L") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$L") + length("$L"), LENGTH(ts9130) - ( index(ts9130 ,"$L" ) + length("$L") - 1 ) ).
       END.
        av9130 = V1300.
       IF INDEX(ts9130,"$P") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$P") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$P") + length("$P"), LENGTH(ts9130) - ( index(ts9130 ,"$P" ) + length("$P") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = trim(pt_desc2).
       IF INDEX(ts9130,"$E") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$E") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$E") + length("$E"), LENGTH(ts9130) - ( index(ts9130 ,"$E" ) + length("$E") - 1 ) ).
       END.
        av9130 = V1100.
       IF INDEX(ts9130,"$O") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$O") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$O") + length("$O"), LENGTH(ts9130) - ( index(ts9130 ,"$O" ) + length("$O") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = if pt_drwg_loc <> "" then "ENV DIR:" + trim (pt_drwg_loc) else "".
       IF INDEX(ts9130,"&E") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&E") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"&E") + length("&E"), LENGTH(ts9130) - ( index(ts9130 ,"&E" ) + length("&E") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = if pt_avg_int <> 0 and pt_avg_int <> 90 then "保質期:" + trim ( string ( pt_avg_int ) ) + "月" else "".
       IF INDEX(ts9130,"&D") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&D") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"&D") + length("&D"), LENGTH(ts9130) - ( index(ts9130 ,"&D" ) + length("&D") - 1 ) ).
       END.
        av9130 = trim(V1300) + "@" + trim(V1500).
       IF INDEX(ts9130,"&B") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&B") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"&B") + length("&B"), LENGTH(ts9130) - ( index(ts9130 ,"&B" ) + length("&B") - 1 ) ).
       END.
        av9130 = V9110.
       IF INDEX(ts9130,"$Q") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$Q") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$Q") + length("$Q"), LENGTH(ts9130) - ( index(ts9130 ,"$Q" ) + length("$Q") - 1 ) ).
       END.
       put unformatted ts9130 skip.
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.
     unix silent value ("chmod 777  " + trim(wsection) + ".l").
     END PROCEDURE.
     run por029130l.
     do i = 1 to integer(wtm_num):
       find first PRD_DET where PRD_DEV = V9130 no-lock no-error.
       IF AVAILABLE PRD_DET then do:
         unix silent value (trim(prd_path) + " " + trim(wsection) + ".l").
       end.
     End.
   /* Internal Cycle END :9130    */
   END.
   pause 0 before-hide.
end.
