/* PO RECEIPT [NORMAL] */
/* Generate date / time  2009-3-1 15:49:09 */
{mfdeclre.i}
define var v_recno as recid . /*for roll bar*/
define variable sectionid as integer init 0 .
define variable WMESSAGE  as char format "x(80)" init "".
define variable wtm_num   as char format "x(20)" init "0".
define variable wtm_fm    as char format "x(16)".
define variable wsection as char format "x(16)".
define variable i as integer .

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout" no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xspor01wtimeout" no-lock no-error. /*  Timeout - Program Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

mainloop:
REPEAT:
batchrun = no . /*cimload,有些会改成yes,这里改回来*/
     /* CYCLE COUNTER -SECTION ID -- START*/
      sectionid = sectionid + 1 .
     /* SECTION ID -- END  */

     /* START  LINE :1002  [SITE]  */
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
        {xsdfsite02.i}
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
                display "[采购收货(2)]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 no-box.

                /* LABEL 1 - START */ 
                L10021 = "初始值有误:" .
                display L10021          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L10022 = "1.默认权限/地点有误" .
                display L10022          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L10023 = "2.会计期间有误" .
                display L10023          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L10024 = "  请查核" .
                display L10024          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L10025 = "" . 
                display L10025          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L10026 = "" . 
                display L10026          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
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
        IF V1002 = "*" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1002.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1002.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not trim(V1002) = "*" THEN DO:
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
     /* END    LINE :1002  [SITE]  */


   /* Additional Labels Format */
     /* START  LINE :1050  送检单[Packing No]  */
     V1050L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1050           as char format "x(50)".
        define variable PV1050          as char format "x(50)".
        define variable L10501          as char format "x(40)".
        define variable L10502          as char format "x(40)".
        define variable L10503          as char format "x(40)".
        define variable L10504          as char format "x(40)".
        define variable L10505          as char format "x(40)".
        define variable L10506          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find last xsj_hist use-index xsj_date_lot where xsj_date = today no-lock no-error .
         If avail xsj_hist then
        V1050 = xsj_nbr.
        V1050 = ENTRY(1,V1050,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V1050 = PV1050 .
        V1050 = ENTRY(1,V1050,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[采购收货(2)]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1050 no-box.

                /* LABEL 1 - START */ 
                L10501 = "送检单?" .
                display L10501          format "x(40)" skip with fram F1050 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L10502 = "" . 
                display L10502          format "x(40)" skip with fram F1050 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L10503 = "" . 
                display L10503          format "x(40)" skip with fram F1050 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L10504 = "" . 
                display L10504          format "x(40)" skip with fram F1050 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L10505 = "" . 
                display L10505          format "x(40)" skip with fram F1050 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L10506 = "" . 
                display L10506          format "x(40)" skip with fram F1050 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
        skip with fram F1050 no-box.
        Update V1050
        WITH  fram F1050 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        v_recno = ? .
        display skip "^" @ WMESSAGE NO-LABEL with fram F1050.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
               if v_recno = ? then
                  find first xsj_hist where 
                              xsj_date = today AND  
                              xsj_nbr >  INPUT V1050
                               use-index xsj_date_lot
                   no-lock no-error.
               else
                  find next xsj_hist where 
                              xsj_date = today
                               use-index xsj_date_lot
                   no-lock no-error.
                  IF not AVAILABLE xsj_hist then do: 
                      if v_recno <> ? then 
                          find xsj_hist where recid(xsj_hist) = v_recno no-lock no-error .
                      else 
                          find last xsj_hist where 
                              xsj_date = today
                               use-index xsj_date_lot
                          no-lock no-error.
                  end. 
                  v_recno = recid(xsj_hist) .
                  IF AVAILABLE xsj_hist then display skip 
                         xsj_nbr @ V1050 "PO/Line:" + xsj_ponbr + "/" + string(xsj_line) @ WMESSAGE NO-LABEL with fram F1050.
                  else   display skip "" @ WMESSAGE with fram F1050.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
               if v_recno = ? then
                  find last xsj_hist where 
                              xsj_date = today AND  
                              xsj_nbr <  INPUT V1050
                               use-index xsj_date_lot
                  no-lock no-error.
               else 
                  find prev xsj_hist where 
                              xsj_date = today
                               use-index xsj_date_lot
                  no-lock no-error.
                  IF not AVAILABLE xsj_hist then do: 
                      if v_recno <> ? then 
                          find xsj_hist where recid(xsj_hist) = v_recno no-lock no-error .
                      else 
                          find first xsj_hist where 
                              xsj_date = today
                               use-index xsj_date_lot
                          no-lock no-error.
                  end. 
                  v_recno = recid(xsj_hist) .
                  IF AVAILABLE xsj_hist then display skip 
                         xsj_nbr @ V1050 "PO/Line:" + xsj_ponbr + "/" + string(xsj_line) @ WMESSAGE NO-LABEL with fram F1050.
                  else   display skip "" @ WMESSAGE with fram F1050.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1050 = "*" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1050.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1050.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        
        if index(v1050,"-") = 0 then do:
                display skip "无效送检单号" @ WMESSAGE NO-LABEL with fram F1050.
                pause 0 before-hide.
                undo, retry.
        end.
        find first xsj_hist where xsj_nbr = v1050  NO-ERROR NO-WAIT.
        IF NOT AVAILABLE xsj_hist then do:
                display skip "无效送检单或被锁" @ WMESSAGE NO-LABEL with fram F1050.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1050.
        pause 0.
        leave V1050L.
     END.
     PV1050 = V1050.
     /* END    LINE :1050  送检单[Packing No]  */


   /* Additional Labels Format */
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
        define var ii as integer .
        define var v1100xp as char format "x(20)" .
        ii = 0 .
        repeat:
            ii = ii + 1 .
            /*message ii substring(v1050,1,length(v1050) - ii ) substring(v1050,length(v1050) - ii + 1 ,1 ) view-as alert-box.*/
            if ii = length(v1050) or substring(v1050,length(v1050) - ii + 1 ,1 ) = "-" then leave .
        end.
        v1100xp = substring(v1050,1,length(v1050) - ii ) .
        V1100 = v1100xp.
        V1100 = ENTRY(1,V1100,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1100 = ENTRY(1,V1100,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1100L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1100L .
        /* --CYCLE TIME SKIP -- END  */

                display "[采购收货(2)]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1100 no-box.

                /* LABEL 1 - START */ 
                L11001 = "采购单?" .
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


                /* LABEL 5 - START */ 
                  L11005 = "" . 
                display L11005          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11006 = "" . 
                display L11006          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
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
        v_recno = ? .
        display skip "^" @ WMESSAGE NO-LABEL with fram F1100.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
               if v_recno = ? then
                  find first PO_MSTR where 
                              INDEX("XC",PO_STAT) = 0 AND PO_TYPE <> "B" AND (PO_SITE = "" OR PO_SITE = V1002) AND  
                              PO_NBR >  INPUT V1100
                   no-lock no-error.
               else
                  find next PO_MSTR where 
                              INDEX("XC",PO_STAT) = 0 AND PO_TYPE <> "B" AND (PO_SITE = "" OR PO_SITE = V1002)
                   no-lock no-error.
                  IF not AVAILABLE PO_MSTR then do: 
                      if v_recno <> ? then 
                          find PO_MSTR where recid(PO_MSTR) = v_recno no-lock no-error .
                      else 
                          find last PO_MSTR where 
                              INDEX("XC",PO_STAT) = 0 AND PO_TYPE <> "B" AND (PO_SITE = "" OR PO_SITE = V1002)
                          no-lock no-error.
                  end. 
                  v_recno = recid(PO_MSTR) .
                  IF AVAILABLE PO_MSTR then display skip 
                         PO_NBR @ V1100 trim( PO_NBR ) + "/" + trim( PO_VEND ) @ WMESSAGE NO-LABEL with fram F1100.
                  else   display skip "" @ WMESSAGE with fram F1100.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
               if v_recno = ? then
                  find last PO_MSTR where 
                              INDEX("XC",PO_STAT) = 0 AND PO_TYPE <> "B" AND (PO_SITE = "" OR PO_SITE = V1002) AND  
                              PO_NBR <  INPUT V1100
                  no-lock no-error.
               else 
                  find prev PO_MSTR where 
                              INDEX("XC",PO_STAT) = 0 AND PO_TYPE <> "B" AND (PO_SITE = "" OR PO_SITE = V1002)
                  no-lock no-error.
                  IF not AVAILABLE PO_MSTR then do: 
                      if v_recno <> ? then 
                          find PO_MSTR where recid(PO_MSTR) = v_recno no-lock no-error .
                      else 
                          find first PO_MSTR where 
                              INDEX("XC",PO_STAT) = 0 AND PO_TYPE <> "B" AND (PO_SITE = "" OR PO_SITE = V1002)
                          no-lock no-error.
                  end. 
                  v_recno = recid(PO_MSTR) .
                  IF AVAILABLE PO_MSTR then display skip 
                         PO_NBR @ V1100 trim( PO_NBR ) + "/" + trim( PO_VEND ) @ WMESSAGE NO-LABEL with fram F1100.
                  else   display skip "" @ WMESSAGE with fram F1100.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1100 = "*" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1100.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        if v1100xp <> v1100 then do:
        disp "非送检单指定PO" @ WMESSAGE NO-LABEL with fram F1100.
        undo,retry .
        End.
        find first PO_MSTR where PO_NBR = V1100 AND INDEX("XC",PO_STAT) = 0 AND PO_TYPE <> "B" AND ( PO_SITE = "" OR PO_SITE = V1002 )  NO-ERROR NO-WAIT.
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


   /* Additional Labels Format */
     /* START  LINE :1101  采购币  */
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

                display "[采购收货(2)]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1101 no-box.

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


                /* LABEL 5 - START */ 
                  L11015 = "" . 
                display L11015          format "x(40)" skip with fram F1101 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11016 = "" . 
                display L11016          format "x(40)" skip with fram F1101 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
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
        IF V1101 = "*" THEN  LEAVE MAINLOOP.
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
     /* END    LINE :1101  采购币  */


   /* Additional Labels Format */
     /* START  LINE :1102  本位币  */
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

                display "[采购收货(2)]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1102 no-box.

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


                /* LABEL 5 - START */ 
                  L11025 = "" . 
                display L11025          format "x(40)" skip with fram F1102 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11026 = "" . 
                display L11026          format "x(40)" skip with fram F1102 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
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
        IF V1102 = "*" THEN  LEAVE MAINLOOP.
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
     /* END    LINE :1102  本位币  */


   /* Additional Labels Format */
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
        V1103 = if po_fix_rate = yes then "#" else "N".
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

                display "[采购收货(2)]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1103 no-box.

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


                /* LABEL 5 - START */ 
                  L11035 = "" . 
                display L11035          format "x(40)" skip with fram F1103 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11036 = "" . 
                display L11036          format "x(40)" skip with fram F1103 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
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
        IF V1103 = "*" THEN  LEAVE MAINLOOP.
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


   /* Additional Labels Format */
     /* START  LINE :1203  收货日期(Create LOT)  */
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
                display "[采购收货(2)]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1203 no-box.

                /* LABEL 1 - START */ 
                L12031 = "收货日期?" .
                display L12031          format "x(40)" skip with fram F1203 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L12032 = string ( today ) .
                display L12032          format "x(40)" skip with fram F1203 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L12033 = "PO:" + v1100 .
                display L12033          format "x(40)" skip with fram F1203 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L12034 = "" . 
                display L12034          format "x(40)" skip with fram F1203 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L12035 = "" . 
                display L12035          format "x(40)" skip with fram F1203 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L12036 = "" . 
                display L12036          format "x(40)" skip with fram F1203 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
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
        IF V1203 = "*" THEN  LEAVE MAINLOOP.
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
     /* END    LINE :1203  收货日期(Create LOT)  */


   /* Additional Labels Format */
     /* START  LINE :1204  兑换率检查  */
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
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1204 = "*".
        V1204 = ENTRY(1,V1204,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1204 = ENTRY(1,V1204,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        {xscurr01.i &pocurr="v1101" &basecurr="v1102" &effdate="d1203"}
        {xsglef01.i  &entity ="v_entity" &effdate="d1203" &module=""IC""}
        if v_curr_error = 0 and apass = "Y" then
        leave V1204L.
        /* LOGICAL SKIP END */
                display "[采购收货(2)]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1204 no-box.

                /* LABEL 1 - START */ 
                L12041 = "兑换率有误或未开账:" .
                display L12041          format "x(40)" skip with fram F1204 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L12042 = "收货日期:" + string(d1203) .
                display L12042          format "x(40)" skip with fram F1204 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L12043 = "采购币:" + v1101 .
                display L12043          format "x(40)" skip with fram F1204 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L12044 = "本位币:" + v1102 .
                display L12044          format "x(40)" skip with fram F1204 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L12045 = "" . 
                display L12045          format "x(40)" skip with fram F1204 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L12046 = "" . 
                display L12046          format "x(40)" skip with fram F1204 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
        skip with fram F1204 no-box.
        Update V1204
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
        IF V1204 = "*" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1204.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1204.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not trim(V1204) = "*" THEN DO:
                display skip "Error , Retry " @ WMESSAGE NO-LABEL with fram F1204.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1204.
        pause 0.
        leave V1204L.
     END.
     PV1204 = V1204.
     /* END    LINE :1204  兑换率检查  */


   /* Additional Labels Format */
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
        find last pod_det where pod_nbr = V1100  and pod_site = V1002 and index("XC",pod_status) = 0 and pod_type = ""  no-lock no-error.
If AVAILABLE (pod_det) and string ( pod_line ) = V1205 then
        leave V1205L.
        /* LOGICAL SKIP END */
                display "[采购收货(2)]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1205 no-box.

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


                /* LABEL 5 - START */ 
                  L12055 = "" . 
                display L12055          format "x(40)" skip with fram F1205 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L12056 = "" . 
                display L12056          format "x(40)" skip with fram F1205 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
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
        v_recno = ? .
        display skip "^" @ WMESSAGE NO-LABEL with fram F1205.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
               if v_recno = ? then
                  find first POD_DET where 
                              pod_nbr = V1100 and pod_site = V1002 and index( "XC",pod_status ) = 0  and pod_type = "" AND  
                              string ( POD_LINE ) >  INPUT V1205
                   no-lock no-error.
               else
                  find next POD_DET where 
                              pod_nbr = V1100 and pod_site = V1002 and index( "XC",pod_status ) = 0  and pod_type = ""
                   no-lock no-error.
                  IF not AVAILABLE POD_DET then do: 
                      if v_recno <> ? then 
                          find POD_DET where recid(POD_DET) = v_recno no-lock no-error .
                      else 
                          find last POD_DET where 
                              pod_nbr = V1100 and pod_site = V1002 and index( "XC",pod_status ) = 0  and pod_type = ""
                          no-lock no-error.
                  end. 
                  v_recno = recid(POD_DET) .
                  IF AVAILABLE POD_DET then display skip 
                         string ( POD_LINE ) @ V1205 trim(POD_PART) + "*" + String( POD_DUE_DATE) + "*" + string ( if ( pod_qty_ord - pod_qty_rcvd ) > 0 then ( pod_qty_ord - pod_qty_rcvd ) else 0 ) @ WMESSAGE NO-LABEL with fram F1205.
                  else   display skip "" @ WMESSAGE with fram F1205.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
               if v_recno = ? then
                  find last POD_DET where 
                              pod_nbr = V1100 and pod_site = V1002 and index( "XC",pod_status ) = 0  and pod_type = "" AND  
                              string ( POD_LINE ) <  INPUT V1205
                  no-lock no-error.
               else 
                  find prev POD_DET where 
                              pod_nbr = V1100 and pod_site = V1002 and index( "XC",pod_status ) = 0  and pod_type = ""
                  no-lock no-error.
                  IF not AVAILABLE POD_DET then do: 
                      if v_recno <> ? then 
                          find POD_DET where recid(POD_DET) = v_recno no-lock no-error .
                      else 
                          find first POD_DET where 
                              pod_nbr = V1100 and pod_site = V1002 and index( "XC",pod_status ) = 0  and pod_type = ""
                          no-lock no-error.
                  end. 
                  v_recno = recid(POD_DET) .
                  IF AVAILABLE POD_DET then display skip 
                         string ( POD_LINE ) @ V1205 trim(POD_PART) + "*" + String( POD_DUE_DATE) + "*" + string ( if ( pod_qty_ord - pod_qty_rcvd ) > 0 then ( pod_qty_ord - pod_qty_rcvd ) else 0 ) @ WMESSAGE NO-LABEL with fram F1205.
                  else   display skip "" @ WMESSAGE with fram F1205.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        /* **SKIP TO MAIN LOOP START** */
        IF V1205 = "*" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        display  skip WMESSAGE NO-LABEL with fram F1205.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1205.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first xsj_hist use-index xsj_nbr where xsj_nbr = v1050 and xsj_line = integer(v1205)  no-lock no-error.
        If not AVAILABLE (xsj_hist) then do:
            disp "非送检单指定项次" @ WMESSAGE NO-LABEL with fram F1205.
            undo,retry .
        End.
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


   /* Additional Labels Format */
     /* START  LINE :1300  料品[Raw Material]  */
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
                display "[采购收货(2)]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1300 no-box.

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
                L13003 = "     " + trim( pt_desc2 ) .
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


                /* LABEL 5 - START */ 
                  L13005 = "" . 
                display L13005          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L13006 = "" . 
                display L13006          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
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
        IF V1300 = "*" THEN  LEAVE V1205LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1300.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        /* MAKE SURE THAT ITEM STATUS ALLOWS TRANSTYPE */
find first pt_mstr where pt_part = ENTRY(1, V1300, "@") no-lock no-error .
If available pt_mstr then do:
   if can-find(first isd_det  where isd_status = string(pt_status,"x(8)") + "#" and ( isd_tr_type = "RCT-PO" ))
   then do:
      disp "零件状态限制交易"  @ WMESSAGE NO-LABEL with fram F1300.
      undo, retry.
   End.
End. /* available pt_mstr */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
        leave V1300L.
     END.
     IF INDEX(V1300,"@" ) = 0 then V1300 = V1300 + "@".
     PV1300 = V1300.
     V1300 = ENTRY(1,V1300,"@").
     /* END    LINE :1300  料品[Raw Material]  */


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

                display "[采购收货(2)]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1301 no-box.

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


                /* LABEL 5 - START */ 
                  L13015 = "" . 
                display L13015          format "x(40)" skip with fram F1301 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L13016 = "" . 
                display L13016          format "x(40)" skip with fram F1301 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
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
        IF V1301 = "*" THEN  LEAVE V1205LMAINLOOP.
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
        find first pt_mstr where pt_part = V1300 no-lock no-error.
If AVAILABLE (pt_mstr) then
        V1400 = pt_loc.
        V1400 = ENTRY(1,V1400,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1400 = ENTRY(1,V1400,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[采购收货(2)]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1400 no-box.

                /* LABEL 1 - START */ 
                L14001 = "库位?" .
                display L14001          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L14002 = "" . 
                display L14002          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L14003 = "" . 
                display L14003          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L14004 = "" . 
                display L14004          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L14005 = "" . 
                display L14005          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L14006 = "" . 
                display L14006          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
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
        v_recno = ? .
        display skip "^" @ WMESSAGE NO-LABEL with fram F1400.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
               if v_recno = ? then
                  find first LOC_MSTR where 
                              LOC_SITE = V1002 AND  
                              LOC_LOC >  INPUT V1400
                   no-lock no-error.
               else
                  find next LOC_MSTR where 
                              LOC_SITE = V1002
                   no-lock no-error.
                  IF not AVAILABLE LOC_MSTR then do: 
                      if v_recno <> ? then 
                          find LOC_MSTR where recid(LOC_MSTR) = v_recno no-lock no-error .
                      else 
                          find last LOC_MSTR where 
                              LOC_SITE = V1002
                          no-lock no-error.
                  end. 
                  v_recno = recid(LOC_MSTR) .
                  IF AVAILABLE LOC_MSTR then display skip 
                         LOC_LOC @ V1400 LOC_DESC @ WMESSAGE NO-LABEL with fram F1400.
                  else   display skip "" @ WMESSAGE with fram F1400.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
               if v_recno = ? then
                  find last LOC_MSTR where 
                              LOC_SITE = V1002 AND  
                              LOC_LOC <  INPUT V1400
                  no-lock no-error.
               else 
                  find prev LOC_MSTR where 
                              LOC_SITE = V1002
                  no-lock no-error.
                  IF not AVAILABLE LOC_MSTR then do: 
                      if v_recno <> ? then 
                          find LOC_MSTR where recid(LOC_MSTR) = v_recno no-lock no-error .
                      else 
                          find first LOC_MSTR where 
                              LOC_SITE = V1002
                          no-lock no-error.
                  end. 
                  v_recno = recid(LOC_MSTR) .
                  IF AVAILABLE LOC_MSTR then display skip 
                         LOC_LOC @ V1400 LOC_DESC @ WMESSAGE NO-LABEL with fram F1400.
                  else   display skip "" @ WMESSAGE with fram F1400.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1400 = "*" THEN  LEAVE V1205LMAINLOOP.
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

                display "[采购收货(2)]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1410 no-box.

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


                /* LABEL 5 - START */ 
                  L14105 = "" . 
                display L14105          format "x(40)" skip with fram F1410 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L14106 = "" . 
                display L14106          format "x(40)" skip with fram F1410 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
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
        IF V1410 = "*" THEN  LEAVE V1205LMAINLOOP.
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
        find first xsj_hist use-index xsj_nbr where xsj_nbr = v1050 and xsj_line = integer(v1205) no-lock no-error.
        If AVAILABLE (xsj_hist) then
        V1500 = xsj_lot.
        V1500 = ENTRY(1,V1500,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1500 = ENTRY(1,V1500,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF 1 = 1 then
        leave V1500L.
        /* LOGICAL SKIP END */
                display "[采购收货(2)]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1500 no-box.

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


                /* LABEL 5 - START */ 
                  L15005 = "" . 
                display L15005          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L15006 = "" . 
                display L15006          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
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
        IF V1500 = "*" THEN  LEAVE V1205LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1500.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1500.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first xsj_hist use-index xsj_nbr where xsj_nbr = v1050 and xsj_line = integer(v1205) and xsj_lot = v1500 no-lock no-error.
If not AVAILABLE (xsj_hist) then do:
    disp "非送检单指定批次" @ WMESSAGE NO-LABEL with fram F1500.
    undo,retry .
End.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1500.
        pause 0.
        leave V1500L.
     END.
     IF INDEX(V1500,"@" ) <> 0 then V1500 = ENTRY(2,V1500,"@").
     PV1500 = V1500.
     /* END    LINE :1500  批号[LOT]  */


   /* Additional Labels Format */
     /* START  LINE :1501  L Checking & Location Checking & Location  */
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
        V1501 = "*".
        V1501 = ENTRY(1,V1501,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1501 = ENTRY(1,V1501,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF (V1410 = "L" and V1500 <> "" ) or (v1410 = "" ) THEN
        leave V1501L.
        /* LOGICAL SKIP END */
                display "[采购收货(2)]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1501 no-box.

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


                /* LABEL 5 - START */ 
                  L15015 = "" . 
                display L15015          format "x(40)" skip with fram F1501 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L15016 = "" . 
                display L15016          format "x(40)" skip with fram F1501 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
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
        IF V1501 = "*" THEN  LEAVE V1205LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1501.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1501.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not trim(V1501) = "*" THEN DO:
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
     /* END    LINE :1501  L Checking & Location Checking & Location  */


   /* Additional Labels Format */
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
                display "[采购收货(2)]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1550 no-box.

                /* LABEL 1 - START */ 
                L15501 = "料品:" + trim( V1300 ) .
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


                /* LABEL 5 - START */ 
                  L15505 = "" . 
                display L15505          format "x(40)" skip with fram F1550 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L15506 = "" . 
                display L15506          format "x(40)" skip with fram F1550 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
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
        IF V1550 = "*" THEN  LEAVE V1205LMAINLOOP.
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


   /* Additional Labels Format */
     /* START  LINE :1558  容差后最多收货数 (只控制数量容差,金额容差=最大)  */
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

                display "[采购收货(2)]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1558 no-box.

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


                /* LABEL 5 - START */ 
                  L15585 = "" . 
                display L15585          format "x(40)" skip with fram F1558 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L15586 = "" . 
                display L15586          format "x(40)" skip with fram F1558 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
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
        IF V1558 = "*" THEN  LEAVE V1205LMAINLOOP.
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
     /* END    LINE :1558  容差后最多收货数 (只控制数量容差,金额容差=最大)  */


   /* Additional Labels Format */
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
        find first xsj_hist use-index xsj_nbr where xsj_nbr = v1050 and xsj_line = integer(v1205)  no-lock no-error.
If AVAILABLE (xsj_hist) then
        V1600 = string(xsj_qty).
        V1600 = ENTRY(1,V1600,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1600 = ENTRY(1,V1600,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[采购收货(2)]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1600 no-box.

                /* LABEL 1 - START */ 
                L16001 = "收货数量?" .
                display L16001          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L16002 = "料品:" + trim( V1300 ) .
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


                /* LABEL 5 - START */ 
                  L16005 = "" . 
                display L16005          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L16006 = "" . 
                display L16006          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
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
        IF V1600 = "*" THEN  LEAVE V1205LMAINLOOP.
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
                display "[采购收货(2)]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1610 no-box.

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


                /* LABEL 5 - START */ 
                  L16105 = "" . 
                display L16105          format "x(40)" skip with fram F1610 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L16106 = "" . 
                display L16106          format "x(40)" skip with fram F1610 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
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
        IF V1610 = "*" THEN  LEAVE V1205LMAINLOOP.
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
     /* START  LINE :1630  取消欠交量  */
     V1630L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1630           as char format "x(50)".
        define variable PV1630          as char format "x(50)".
        define variable L16301          as char format "x(40)".
        define variable L16302          as char format "x(40)".
        define variable L16303          as char format "x(40)".
        define variable L16304          as char format "x(40)".
        define variable L16305          as char format "x(40)".
        define variable L16306          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1630 = "N".
        V1630 = ENTRY(1,V1630,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1630 = "N".
        V1630 = ENTRY(1,V1630,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        find first pod_det where pod_nbr = V1100 and  string ( pod_line ) = V1205 no-lock no-error.
        If pod_qty_ord - pod_qty_rcvd  <= decimal ( V1600 ) then
        leave V1630L.
        /* LOGICAL SKIP END */
                display "[采购收货(2)]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1630 no-box.

                /* LABEL 1 - START */ 
                L16301 = "取消欠交量?" .
                display L16301          format "x(40)" skip with fram F1630 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L16302 = "采购单:" + trim ( V1100 ) + "/" + trim ( V1205 ) .
                display L16302          format "x(40)" skip with fram F1630 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first pod_det where pod_nbr = V1100 and  string ( pod_line ) = V1205 no-lock no-error.
If AVAILABLE (pod_det) then
                L16303 = "订单/已收货:" + string ( pod_qty_ord ) + "/" + string ( pod_qty_rcvd ) .
                else L16303 = "" . 
                display L16303          format "x(40)" skip with fram F1630 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                find first pod_det where pod_nbr = V1100 and  string ( pod_line ) = V1205 no-lock no-error.
If AVAILABLE (pod_det) then
                L16304 = "未结/此次:" + string ( pod_qty_ord - pod_qty_rcvd ) + "/" + V1600 .
                else L16304 = "" . 
                display L16304          format "x(40)" skip with fram F1630 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L16305 = "" . 
                display L16305          format "x(40)" skip with fram F1630 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L16306 = "" . 
                display L16306          format "x(40)" skip with fram F1630 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
        skip with fram F1630 no-box.
        Update V1630
        WITH  fram F1630 NO-LABEL
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
        IF V1630 = "*" THEN  LEAVE V1205LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1630.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1630.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not ( trim(V1630) = "#" OR trim(V1630) = "N" ) THEN DO:
                display skip "输入#/*" @ WMESSAGE NO-LABEL with fram F1630.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1630.
        pause 0.
        leave V1630L.
     END.
     PV1630 = V1630.
     /* END    LINE :1630  取消欠交量  */


   /* Additional Labels Format */
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
        V1700 = "#".
        V1700 = ENTRY(1,V1700,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1700 = ENTRY(1,V1700,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[采购收货(2)]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1700 no-box.

                /* LABEL 1 - START */ 
                L17001 = "料品:" + trim(V1300) .
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


                /* LABEL 5 - START */ 
                  L17005 = "" . 
                display L17005          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L17006 = "" . 
                display L17006          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 6 - END */ 
                display "确认过帐[#],*退出"   format "x(40)" skip
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
        IF V1700 = "*" THEN  LEAVE V1205LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1700.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1700.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first po_mstr where PO_NBR = V1100 AND INDEX("XC",PO_STAT) = 0 AND PO_TYPE <> "B"  NO-ERROR NO-WAIT.
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

                display "[采购收货(2)]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9000 no-box.

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


                /* LABEL 5 - START */ 
                  L90005 = "" . 
                display L90005          format "x(40)" skip with fram F9000 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L90006 = "" . 
                display L90006          format "x(40)" skip with fram F9000 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
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
        IF V9000 = "*" THEN  LEAVE V1205LMAINLOOP.
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
     {xspor01u.i}
     /*  Update MFG/PRO END  */ 
        display  "" NO-LABEL with fram F9000X no-box .
        pause 0.
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
        V9010 = "#".
        V9010 = ENTRY(1,V9010,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9010 = ENTRY(1,V9010,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[采购收货(2)]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9010 no-box.

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
tr_nbr  = V1100     and  tr_type = "RCT-PO"  and tr_site = V1002     and tr_part = V1300     and tr_serial = V1500   and 
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
tr_nbr  = V1100     and  tr_type = "RCT-PO"  and tr_site = V1002     and tr_part = V1300     and tr_serial = V1500   and 
tr_time  + 15 >= TIME 
use-index tr_date_trn no-lock no-error.
If NOT AVAILABLE ( tr_hist ) then
                L90103 = "交易提交失败" .
                else L90103 = "" . 
                display L90103          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L90104 = "按#打印条码,*退出" .
                display L90104          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L90105 = "" . 
                display L90105          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L90106 = "" . 
                display L90106          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
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
        IF V9010 = "*" THEN  LEAVE V1205LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9010.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9010.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not trim(V9010) = "#" THEN DO:
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
   IF NOT (V9010 = "#" AND V1700 = "#" ) THEN LEAVE V9110LMAINLOOP.
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
                display "[采购收货(2)]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9110 no-box.

                /* LABEL 1 - START */ 
                find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr ) then
                L91101 = pt_um + " 标签数量?" .
                else L91101 = "" . 
                display L91101          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L91102 = "料品:" + trim( V1300 ) .
                display L91102          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L91103 = "批号:" + Trim(V1500) .
                display L91103          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                find first pod_det where pod_nbr = V1100 and  string ( pod_line ) = V1205 no-lock no-error.
If AVAILABLE (pod_det) then
                L91104 = string ( decimal ( V1610 ) ) .
                else L91104 = "" . 
                display L91104          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L91105 = "" . 
                display L91105          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L91106 = "" . 
                display L91106          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
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
        IF V9110 = "*" THEN  LEAVE V9110LMAINLOOP.
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
        if  v9110 = "0" then do:
                display skip "条码数量不可为零" @ wmessage no-label with fram f9110.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9110.
        pause 0.
        leave V9110L.
     END.
     PV9110 = V9110.
     /* END    LINE :9110  条码上数量[QTY ON LABEL] AUTO  */


   /* Additional Labels Format */
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
        V9120 = "1".
        V9120 = ENTRY(1,V9120,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9120 = ENTRY(1,V9120,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[采购收货(2)]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9120 no-box.

                /* LABEL 1 - START */ 
                L91201 = "标签个数?" .
                display L91201          format "x(40)" skip with fram F9120 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L91202 = "料品:" + trim( V1300 ) .
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


                /* LABEL 5 - START */ 
                  L91205 = "" . 
                display L91205          format "x(40)" skip with fram F9120 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L91206 = "" . 
                display L91206          format "x(40)" skip with fram F9120 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
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
        IF V9120 = "*" THEN  LEAVE V9110LMAINLOOP.
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
   /* Additional Labels Format */
     /* START  LINE :9130  打印机[Printer]  */
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
        find first upd_det where upd_nbr = "por01" and upd_select = 99 no-lock no-error.
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
                display "[采购收货(2)]"     + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9130 no-box.

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


                /* LABEL 5 - START */ 
                  L91305 = "" . 
                display L91305          format "x(40)" skip with fram F9130 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L91306 = "" . 
                display L91306          format "x(40)" skip with fram F9130 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
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
        v_recno = ? .
        display skip "^" @ WMESSAGE NO-LABEL with fram F9130.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
               if v_recno = ? then
                  find first PRD_DET where 
                              PRD_DEV >  INPUT V9130
                   no-lock no-error.
               else
                  find next PRD_DET where 
                   no-lock no-error.
                  IF not AVAILABLE PRD_DET then do: 
                      if v_recno <> ? then 
                          find PRD_DET where recid(PRD_DET) = v_recno no-lock no-error .
                      else 
                          find last PRD_DET where 
                          no-lock no-error.
                  end. 
                  v_recno = recid(PRD_DET) .
                  IF AVAILABLE PRD_DET then display skip 
                         PRD_DEV @ V9130 PRD_DESC @ WMESSAGE NO-LABEL with fram F9130.
                  else   display skip "" @ WMESSAGE with fram F9130.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
               if v_recno = ? then
                  find last PRD_DET where 
                              PRD_DEV <  INPUT V9130
                  no-lock no-error.
               else 
                  find prev PRD_DET where 
                  no-lock no-error.
                  IF not AVAILABLE PRD_DET then do: 
                      if v_recno <> ? then 
                          find PRD_DET where recid(PRD_DET) = v_recno no-lock no-error .
                      else 
                          find first PRD_DET where 
                          no-lock no-error.
                  end. 
                  v_recno = recid(PRD_DET) .
                  IF AVAILABLE PRD_DET then display skip 
                         PRD_DEV @ V9130 PRD_DESC @ WMESSAGE NO-LABEL with fram F9130.
                  else   display skip "" @ WMESSAGE with fram F9130.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V9130 = "*" THEN  LEAVE V9110LMAINLOOP.
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
     /* END    LINE :9130  打印机[Printer]  */


   /* Additional Labels Format */
     define var vv_part2 as char . /*xp001*/ 
     define var vv_lot2  as char . /*xp001*/ 
     define var vv_qtyp2  as char . /*xp001*/ 
     define var vv_filename2  as char . /*xp001*/   
     define var vv_oneword2  as char . /*xp001*/   
     define var vv_label2  as char . /*xp001*/   
     Define variable ts9130 AS CHARACTER FORMAT "x(100)".
     Define variable av9130 AS CHARACTER FORMAT "x(100)".
     PROCEDURE por019130l.
        define output parameter vv_part1 as char . /*xp001*/  
        define output parameter vv_lot1  as char . /*xp001*/  
        define output parameter vv_qtyp1  as char . /*xp001*/  
        define output parameter vv_label1  as char . /*xp001*/  
        define output parameter vv_filename1  as char . /*xp001*/ 
        define output parameter vv_oneword1  as char . /*xp001*/  
        /* Define Labels Path  Start */
        Define variable LabelsPath as character format "x(100)" init "/mfgpro/rf/labels/".
        Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath"no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath = trim ( code_cmmt ).
        If substring(LabelsPath, length(LabelsPath), 1) <> "/" Then 
        LabelsPath = LabelsPath + "/".
        /* Define Labels Path  END */
        vv_label1 = (LabelsPath + "por01" + trim ( wtm_fm ) ). /*xp001*/
     INPUT FROM VALUE(LabelsPath + "por01" + trim ( wtm_fm ) ).
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY),'99') + string(DAY(TODAY),'99'))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
     vv_filename1 = trim(wsection) + '.l' . /*xp001*/ 
     output to value( trim(wsection) + ".l") .
     Do While True:
              IMPORT UNFORMATTED ts9130.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = if pt_drwg_loc <> "" then "ENV DIR:" + trim (pt_drwg_loc) else "".
       if "&E" = '$p' then vv_part1 =  av9130. 
       if "&E" = '$l' then vv_lot1 =  av9130.
       if "&E" = '$q' then vv_qtyp1 =  av9130.
       IF INDEX(ts9130,"&E") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&E") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"&E") + length("&E"), LENGTH(ts9130) - ( index(ts9130 ,"&E" ) + length("&E") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = trim(pt_desc2).
       if "$E" = '$p' then vv_part1 =  av9130. 
       if "$E" = '$l' then vv_lot1 =  av9130.
       if "$E" = '$q' then vv_qtyp1 =  av9130.
       IF INDEX(ts9130,"$E") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$E") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$E") + length("$E"), LENGTH(ts9130) - ( index(ts9130 ,"$E" ) + length("$E") - 1 ) ).
       END.
        av9130 = V1100.
       if "$O" = '$p' then vv_part1 =  av9130. 
       if "$O" = '$l' then vv_lot1 =  av9130.
       if "$O" = '$q' then vv_qtyp1 =  av9130.
       IF INDEX(ts9130,"$O") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$O") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$O") + length("$O"), LENGTH(ts9130) - ( index(ts9130 ,"$O" ) + length("$O") - 1 ) ).
       END.
        av9130 = trim(V1300) + "@" + trim(V1500).
       if "&B" = '$p' then vv_part1 =  av9130. 
       if "&B" = '$l' then vv_lot1 =  av9130.
       if "&B" = '$q' then vv_qtyp1 =  av9130.
       IF INDEX(ts9130,"&B") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&B") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"&B") + length("&B"), LENGTH(ts9130) - ( index(ts9130 ,"&B" ) + length("&B") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = trim(pt_desc1).
       if "$F" = '$p' then vv_part1 =  av9130. 
       if "$F" = '$l' then vv_lot1 =  av9130.
       if "$F" = '$q' then vv_qtyp1 =  av9130.
       IF INDEX(ts9130,"$F") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$F") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$F") + length("$F"), LENGTH(ts9130) - ( index(ts9130 ,"$F" ) + length("$F") - 1 ) ).
       END.
        av9130 = V1300.
       if "$P" = '$p' then vv_part1 =  av9130. 
       if "$P" = '$l' then vv_lot1 =  av9130.
       if "$P" = '$q' then vv_qtyp1 =  av9130.
       IF INDEX(ts9130,"$P") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$P") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$P") + length("$P"), LENGTH(ts9130) - ( index(ts9130 ,"$P" ) + length("$P") - 1 ) ).
       END.
        av9130 = V9110.
       if "$Q" = '$p' then vv_part1 =  av9130. 
       if "$Q" = '$l' then vv_lot1 =  av9130.
       if "$Q" = '$q' then vv_qtyp1 =  av9130.
       IF INDEX(ts9130,"$Q") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$Q") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$Q") + length("$Q"), LENGTH(ts9130) - ( index(ts9130 ,"$Q" ) + length("$Q") - 1 ) ).
       END.
        av9130 = V1500.
       if "$L" = '$p' then vv_part1 =  av9130. 
       if "$L" = '$l' then vv_lot1 =  av9130.
       if "$L" = '$q' then vv_qtyp1 =  av9130.
       IF INDEX(ts9130,"$L") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$L") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$L") + length("$L"), LENGTH(ts9130) - ( index(ts9130 ,"$L" ) + length("$L") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = pt_um.
       if "$U" = '$p' then vv_part1 =  av9130. 
       if "$U" = '$l' then vv_lot1 =  av9130.
       if "$U" = '$q' then vv_qtyp1 =  av9130.
       IF INDEX(ts9130,"$U") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$U") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$U") + length("$U"), LENGTH(ts9130) - ( index(ts9130 ,"$U" ) + length("$U") - 1 ) ).
       END.
        av9130 = string(today).
       if "$D" = '$p' then vv_part1 =  av9130. 
       if "$D" = '$l' then vv_lot1 =  av9130.
       if "$D" = '$q' then vv_qtyp1 =  av9130.
       IF INDEX(ts9130,"$D") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$D") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$D") + length("$D"), LENGTH(ts9130) - ( index(ts9130 ,"$D" ) + length("$D") - 1 ) ).
       END.
        av9130 = if length( trim ( V1500 ) ) >= 8 then substring ( trim ( V1500 ),7,2) else "00".
       if "&M" = '$p' then vv_part1 =  av9130. 
       if "&M" = '$l' then vv_lot1 =  av9130.
       if "&M" = '$q' then vv_qtyp1 =  av9130.
       IF INDEX(ts9130,"&M") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&M") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"&M") + length("&M"), LENGTH(ts9130) - ( index(ts9130 ,"&M" ) + length("&M") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = if pt_avg_int <> 0 and pt_avg_int <> 90 then "玂借戳:" + trim ( string ( pt_avg_int ) ) + "る" else "".
       if "&D" = '$p' then vv_part1 =  av9130. 
       if "&D" = '$l' then vv_lot1 =  av9130.
       if "&D" = '$q' then vv_qtyp1 =  av9130.
       IF INDEX(ts9130,"&D") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&D") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"&D") + length("&D"), LENGTH(ts9130) - ( index(ts9130 ,"&D" ) + length("&D") - 1 ) ).
       END.
        av9130 = V1301.
       if "$S" = '$p' then vv_part1 =  av9130. 
       if "$S" = '$l' then vv_lot1 =  av9130.
       if "$S" = '$q' then vv_qtyp1 =  av9130.
       IF INDEX(ts9130,"$S") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$S") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$S") + length("$S"), LENGTH(ts9130) - ( index(ts9130 ,"$S" ) + length("$S") - 1 ) ).
       END.
       put unformatted ts9130 skip.
       vv_oneword1 = vv_oneword1 + ts9130.  /*xp001*/
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.
     unix silent value ("chmod 777  " + trim(wsection) + ".l").
     END PROCEDURE.
     run por019130l  (output vv_part2 , output vv_lot2 ,output vv_qtyp2 ,output vv_label2 ,output vv_filename2 ,output vv_oneword2 ) .  /*xp001*/
     PROCEDURE  xsprinthist:  /*xp001*/ 
     {xsprinthist.i}  /*xp001*/ 
     END PROCEDURE.  /*xp001*/ 
     run xsprinthist. /*xp001*/ 
     do i = 1 to integer(wtm_num):
       find first PRD_DET where PRD_DEV = V9130 no-lock no-error.
       IF AVAILABLE PRD_DET then do:
         unix silent value (trim(prd_path) + " " + trim(wsection) + ".l").
       end.
     End.
     unix silent value ( 'rm -f '  + trim(wsection) + '.l').
   /* Internal Cycle END :9130    */
   END.
   pause 0 before-hide.
end.
