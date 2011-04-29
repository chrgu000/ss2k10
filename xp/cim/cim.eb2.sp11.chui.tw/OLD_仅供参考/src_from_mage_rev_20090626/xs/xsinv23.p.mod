/* Generate By Barcode Generator , Copyright by Softspeed - Build By Sam Song  */ 
/* INV TRANSFER */
/* Generate date / time  2006-10-24 10:21:05 */
/*ssivan 07032701 */  /*党蜊湖荂最唗*/

define variable sectionid as integer init 0 .
define variable WMESSAGE  as char format "x(80)" init "".
define variable wtm_num   as char format "x(20)" init "0".
define variable wtm_fm    as char format "x(16)".
define variable wsection as char format "x(16)".
define variable i as integer .

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout" no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xsinv23wtimeout" no-lock no-error. /*  Timeout - Program Level */
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
                display "[庫存轉移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 no-box.

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
     /* START  LINE :1100  單號[ORDER]  */
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

        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1100L .
        /* --CYCLE TIME SKIP -- END  */

                display "[庫存轉移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1100 no-box.

                /* LABEL 1 - START */ 
                L11001 = "單據號碼?" .
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
        IF V1100 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1100.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not length( trim ( V1100 ) ) <= 18 THEN DO:
                display skip "長度不能超過18位" @ WMESSAGE NO-LABEL with fram F1100.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        leave V1100L.
     END.
     PV1100 = V1100.
     /* END    LINE :1100  單號[ORDER]  */


   /* Additional Labels Format */
   /* Internal Cycle Input :1300    */
   V1300LMAINLOOP:
   REPEAT:
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
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1300 = ENTRY(1,V1300,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[庫存轉移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1300 no-box.

                /* LABEL 1 - START */ 
                L13001 = "料品 或 料品+批號?" .
                display L13001          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L13002 = "" . 
                display L13002          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L13003 = "" . 
                display L13003          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13004 = "" . 
                display L13004          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1300 no-box.
        Update V1300
        WITH  fram F1300 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1300.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(PT_MSTR) = ? THEN find first PT_MSTR where 
                              PT_PART >=  INPUT V1300
                               no-lock no-error.
                  ELSE find next PT_MSTR where 
                               no-lock no-error.
                  IF AVAILABLE PT_MSTR then display skip 
            PT_PART @ V1300 trim( PT_Desc1 ) @ WMESSAGE NO-LABEL with fram F1300.
                  else   display skip "" @ WMESSAGE with fram F1300.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(PT_MSTR) = ? THEN find first PT_MSTR where 
            PT_PART <=  INPUT V1300
                               no-lock no-error.
                  ELSE find prev PT_MSTR where 
                               no-lock no-error.
                  IF AVAILABLE PT_MSTR then display skip 
            PT_PART @ V1300 trim( PT_Desc1 ) @ WMESSAGE NO-LABEL with fram F1300.
                  else   display skip "" @ WMESSAGE with fram F1300.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        /* **SKIP TO MAIN LOOP START** */
        IF V1300 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        display  skip WMESSAGE NO-LABEL with fram F1300.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first PT_MSTR where PT_PART = ENTRY(1, V1300, "@")  no-lock no-error.
        IF NOT AVAILABLE PT_MSTR then do:
                display skip "料品有誤!" @ WMESSAGE NO-LABEL with fram F1300.
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
     /* END    LINE :1300  料品[Raw Material]  */


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

                display "[庫存轉移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1410 no-box.

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
        IF V1410 = "e" THEN  LEAVE V1300LMAINLOOP.
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
     /* START  LINE :1500  批號[LOT]  */
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
                display "[庫存轉移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1500 no-box.

                /* LABEL 1 - START */ 
                L15001 = "批號?" .
                display L15001          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find first ld_det where ld_part = V1300  and ld_site = V1002  and ld_ref  = ""     and ld_qty_oh <> 0 use-index ld_part_lot no-lock no-error.
If AVAILABLE ( ld_det ) then
                L15002 = "最小:" + trim(ld_lot) .
                else L15002 = "" . 
                display L15002          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first ld_det where ld_part = V1300 and
ld_site = V1002 and  
ld_ref  = ""     and ld_qty_oh <> 0 use-index ld_part_lot no-lock no-error.
If AVAILABLE ( ld_det ) then
                L15003 = "庫存:" + trim(ld_loc) + "/" +  trim(string(ld_qty_oh)) .
                else L15003 = "" . 
                display L15003          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L15004 = "料品:" + trim( V1300 ) .
                display L15004          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1500 no-box.
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
                              LD_PART = V1300 AND LD_QTY_OH <> 0  AND
LD_SITE = V1002 AND LD_REF = "" AND  
                              LD_LOT >=  INPUT V1500
                               no-lock no-error.
                  ELSE find next LD_DET where 
                              LD_PART = V1300 AND LD_QTY_OH <> 0  AND
LD_SITE = V1002 AND LD_REF = ""  
                               no-lock no-error.
                  IF AVAILABLE LD_DET then display skip 
            LD_LOT @ V1500 LD_LOC + "/" + trim(string(LD_QTY_OH)) @ WMESSAGE NO-LABEL with fram F1500.
                  else   display skip "" @ WMESSAGE with fram F1500.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(LD_DET) = ? THEN find first LD_DET where 
                              LD_PART = V1300 AND LD_QTY_OH <> 0  AND
LD_SITE = V1002 AND LD_REF = "" AND  
            LD_LOT <=  INPUT V1500
                               no-lock no-error.
                  ELSE find prev LD_DET where 
                              LD_PART = V1300 AND LD_QTY_OH <> 0  AND
LD_SITE = V1002 AND LD_REF = "" 
                               no-lock no-error.
                  IF AVAILABLE LD_DET then display skip 
            LD_LOT @ V1500 LD_LOC + "/" + trim(string(LD_QTY_OH)) @ WMESSAGE NO-LABEL with fram F1500.
                  else   display skip "" @ WMESSAGE with fram F1500.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1500 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1500.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1500.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not ( IF INDEX(V1500,"@" ) <> 0 then ENTRY(2,V1500,"@") else V1500 ) <> "" THEN DO:
                display skip "L控制,不能為空" @ WMESSAGE NO-LABEL with fram F1500.
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
     /* END    LINE :1500  批號[LOT]  */


   /* Additional Labels Format */
     /* START  LINE :1510  從庫位[From LOC]  */
     V1510L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1510           as char format "x(50)".
        define variable PV1510          as char format "x(50)".
        define variable L15101          as char format "x(40)".
        define variable L15102          as char format "x(40)".
        define variable L15103          as char format "x(40)".
        define variable L15104          as char format "x(40)".
        define variable L15105          as char format "x(40)".
        define variable L15106          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first poc_ctrl  no-lock no-error.
If AVAILABLE ( poc_ctrl ) then
        V1510 = poc_insp_loc.
        V1510 = ENTRY(1,V1510,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V1510 = PV1510 .
        V1510 = ENTRY(1,V1510,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[庫存轉移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1510 no-box.

                /* LABEL 1 - START */ 
                L15101 = "從庫位?" .
                display L15101          format "x(40)" skip with fram F1510 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find first poc_ctrl  no-lock no-error.
If AVAILABLE ( poc_ctrl ) then
                L15102 = poc_insp_loc .
                else L15102 = "" . 
                display L15102          format "x(40)" skip with fram F1510 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L15103 = "" . 
                display L15103          format "x(40)" skip with fram F1510 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L15104 = "" . 
                display L15104          format "x(40)" skip with fram F1510 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1510 no-box.
        Update V1510
        WITH  fram F1510 NO-LABEL
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
        IF V1510 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1510.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1510.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first LOC_MSTR where LOC_LOC = V1510 AND LOC_SITE = V1002  no-lock no-error.
        IF NOT AVAILABLE LOC_MSTR then do:
                display skip "Error , Retry." @ WMESSAGE NO-LABEL with fram F1510.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1510.
        pause 0.
        leave V1510L.
     END.
     IF INDEX(V1510,"@" ) <> 0 then V1510 = ENTRY(2,V1510,"@").
     PV1510 = V1510.
     /* END    LINE :1510  從庫位[From LOC]  */


   /* Additional Labels Format */
     /* START  LINE :1520  到庫位[To   LOC]  */
     V1520L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1520           as char format "x(50)".
        define variable PV1520          as char format "x(50)".
        define variable L15201          as char format "x(40)".
        define variable L15202          as char format "x(40)".
        define variable L15203          as char format "x(40)".
        define variable L15204          as char format "x(40)".
        define variable L15205          as char format "x(40)".
        define variable L15206          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first pt_mstr where pt_part = V1300 no-lock no-error.
If AVAILABLE ( pt_mstr ) then
        V1520 = pt_loc.
        V1520 = ENTRY(1,V1520,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1520 = ENTRY(1,V1520,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[庫存轉移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1520 no-box.

                /* LABEL 1 - START */ 
                L15201 = "到庫位?" .
                display L15201          format "x(40)" skip with fram F1520 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L15202 = "" . 
                display L15202          format "x(40)" skip with fram F1520 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L15203 = "" . 
                display L15203          format "x(40)" skip with fram F1520 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L15204 = "" . 
                display L15204          format "x(40)" skip with fram F1520 no-box.
                /* LABEL 4 - END */ 
                display "輸入或按E退出 "      format "x(40)" skip
        skip with fram F1520 no-box.
        Update V1520
        WITH  fram F1520 NO-LABEL
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
        IF V1520 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1520.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1520.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first LOC_MSTR where LOC_LOC = V1520 AND V1520 <> V1510 AND LOC_SITE = V1002  no-lock no-error.
        IF NOT AVAILABLE LOC_MSTR then do:
                display skip "Error , Retry." @ WMESSAGE NO-LABEL with fram F1520.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1520.
        pause 0.
        leave V1520L.
     END.
     PV1520 = V1520.
     /* END    LINE :1520  到庫位[To   LOC]  */


   /* Additional Labels Format */
     /* START  LINE :1600  數量[QTY]  */
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
                display "[庫存轉移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1600 no-box.

                /* LABEL 1 - START */ 
                L16001 = "轉移數量?" .
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
                L16004 = "從:" + trim( V1510 ) + "到:" + trim( V1520 ) .
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
        IF V1600 = "e" THEN  LEAVE V1300LMAINLOOP.
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
        find first LD_DET where ( ld_part  = V1300 AND ld_lot = V1500 AND ld_site = V1002 AND ld_ref = "") AND ( ( decimal(V1600) < 0  AND ( ld_loc = V1520 AND  LD_SITE = V1002 and ld_ref = "" and ld_QTY_oh >= - DECIMAL ( V1600 ) ) ) OR ( decimal(V1600) > 0 AND  ld_loc = V1510 AND  LD_SITE = V1002 and ld_ref = "" and  ld_QTY_oh >= DECIMAL ( V1600 ) ) )  no-lock no-error.
        IF NOT AVAILABLE LD_DET then do:
                display skip "在庫數 <:" + string( V1600 ) @ WMESSAGE NO-LABEL with fram F1600.
                pause 0 before-hide.
                undo, retry.
        end.
        IF not V1600 <> "0" THEN DO:
                display skip "在庫數 <:" + string( V1600 ) @ WMESSAGE NO-LABEL with fram F1600.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1600.
        pause 0.
        leave V1600L.
     END.
     PV1600 = V1600.
     /* END    LINE :1600  數量[QTY]  */


   /* Additional Labels Format */
     /* START  LINE :1700  確認[CONFIRM]  */
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
                display "[庫存轉移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1700 no-box.

                /* LABEL 1 - START */ 
                L17001 = "料品:" + trim(V1300) .
                display L17001          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L17002 = "批號:" + trim ( V1500 ) .
                display L17002          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L17003 = "數量:" + trim(V1600) .
                display L17003          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L17004 = "從:" + trim( V1510 ) + "到:" + trim( V1520 ) .
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
        IF V1700 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1700.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1700.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first ld_det where ld_part  = V1300 AND
ld_site = V1002 AND 
ld_ref  = ""    and ld_lot = V1500   AND
( ( decimal(V1600) > 0 AND ld_loc   = V1510 ) OR ( decimal(V1600) < 0 AND ld_loc   = V1520 ))  NO-ERROR NO-WAIT.
        IF NOT AVAILABLE ld_det then do:
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
     /* END    LINE :1700  確認[CONFIRM]  */


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

                display "[庫存轉移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9000 no-box.

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
        IF V9000 = "e" THEN  LEAVE V1300LMAINLOOP.
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
     {xsinv23u.i}
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
        V9010 = "Y".
        V9010 = ENTRY(1,V9010,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9010 = ENTRY(1,V9010,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[庫存轉移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9010 no-box.

                /* LABEL 1 - START */ 
                find last tr_hist where 
tr_date = today     and 
tr_trnbr > integer ( V9000 ) and 
tr_nbr  = V1100     and  tr_type = "RCT-TR"  and
tr_site = V1002     and  tr_part = V1300     and tr_serial = V1500   and 
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
tr_nbr  = V1100     and  tr_type = "RCT-TR"  and  
tr_site = V1002     and  
tr_part = V1300     and tr_serial = V1500   and 
tr_time  + 15 >= TIME 
use-index tr_date_trn no-lock no-error.
If AVAILABLE ( tr_hist ) then
                L90102 = "交易號 :" + trim(string(tr_trnbr)) .
                else L90102 = "" . 
                display L90102          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find last tr_hist where 
tr_date = today     and 
tr_trnbr > integer ( V9000 ) and 
tr_nbr  = V1100     and  tr_type = "RCT-TR"  and  
tr_site = V1002     and  
tr_part = V1300     and tr_serial = V1500   and 
tr_time  + 15 >= TIME 
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
        IF V9010 = "e" THEN  LEAVE V1300LMAINLOOP.
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
   LEAVE V1300LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :9010    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :9110    */
   V9110LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle9110    */
   IF NOT (V9010 = "Y" AND V1700 = "Y" ) THEN LEAVE V9110LMAINLOOP.
     /* START  LINE :9110  條碼上數量[QTY ON LABEL]  */
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
        V9110 = V1600.
        V9110 = ENTRY(1,V9110,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9110 = ENTRY(1,V9110,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[庫存轉移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9110 no-box.

                /* LABEL 1 - START */ 
                find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr ) then
                L91101 = pt_um + " 標簽上數量?" .
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
                  L91104 = "" . 
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
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9110.
        pause 0.
        leave V9110L.
     END.
     PV9110 = V9110.
     /* END    LINE :9110  條碼上數量[QTY ON LABEL]  */


   /* Additional Labels Format */
     /* START  LINE :9120  條碼個數[No Of Label]  */
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
                display "[庫存轉移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9120 no-box.

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
     /* END    LINE :9120  條碼個數[No Of Label]  */


   wtm_num = V9120.
   /* Additional Labels Format */
     /* START  LINE :9130  打印機[Printer]  */
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
        find first upd_det where upd_nbr = "INV23" and upd_select = 99 no-lock no-error.
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

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V9130L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V9130L .
        /* --CYCLE TIME SKIP -- END  */

                display "[庫存轉移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9130 no-box.

                /* LABEL 1 - START */ 
                L91301 = "打印機?" .
                display L91301          format "x(40)" skip with fram F9130 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L91302 = "" . 
                display L91302          format "x(40)" skip with fram F9130 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L91303 = "" . 
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
     /* END    LINE :9130  打印機[Printer]  */


   /* Additional Labels Format */
     Define variable ts9130 AS CHARACTER FORMAT "x(100)".
     Define variable av9130 AS CHARACTER FORMAT "x(100)".
     PROCEDURE inv239130l.
        /* Define Labels Path  Start */
        Define variable LabelsPath as character format "x(100)" init "/mfgpro/rf/labels/".
        Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath"no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath = trim ( code_cmmt ).
        If substring(LabelsPath, length(LabelsPath), 1) <> "/" Then 
        LabelsPath = LabelsPath + "/".
        /* Define Labels Path  END */
     INPUT FROM VALUE(LabelsPath + "inv23" + trim ( wtm_fm ) ).
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
     output to value( trim(wsection) + ".l") .
     Do While True:
              IMPORT UNFORMATTED ts9130.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
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
        av9130 = trim(V1300) + "@" + trim(V1500).
       IF INDEX(ts9130,"&B") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&B") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"&B") + length("&B"), LENGTH(ts9130) - ( index(ts9130 ,"&B" ) + length("&B") - 1 ) ).
       END.
        av9130 = V1500.
       IF INDEX(ts9130,"$L") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$L") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$L") + length("$L"), LENGTH(ts9130) - ( index(ts9130 ,"$L" ) + length("$L") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = pt_um.
       IF INDEX(ts9130,"$U") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$U") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$U") + length("$U"), LENGTH(ts9130) - ( index(ts9130 ,"$U" ) + length("$U") - 1 ) ).
       END.
        av9130 = string(today).
       IF INDEX(ts9130,"$D") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$D") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$D") + length("$D"), LENGTH(ts9130) - ( index(ts9130 ,"$D" ) + length("$D") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = trim(pt_desc1).
       IF INDEX(ts9130,"$F") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$F") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$F") + length("$F"), LENGTH(ts9130) - ( index(ts9130 ,"$F" ) + length("$F") - 1 ) ).
       END.
       if length ( trim(V1500) ) = 13 THEN 
        find first tr_hist where tr_serial = trim(V1500)  and tr_type = "RCT-PO" and tr_part = trim(V1300) use-index tr_serial no-lock no-error.
        If available tr_hist then
        av9130 = tr_nbr.
       IF INDEX(ts9130,"$O") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$O") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$O") + length("$O"), LENGTH(ts9130) - ( index(ts9130 ,"$O" ) + length("$O") - 1 ) ).
       END.
        av9130 = V1300.
       IF INDEX(ts9130,"$P") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$P") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$P") + length("$P"), LENGTH(ts9130) - ( index(ts9130 ,"$P" ) + length("$P") - 1 ) ).
       END.
        av9130 = if length( trim ( V1500 ) ) >= 8 then substring ( trim ( V1500 ),7,2) else "00".
       IF INDEX(ts9130,"&M") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&M") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"&M") + length("&M"), LENGTH(ts9130) - ( index(ts9130 ,"&M" ) + length("&M") - 1 ) ).
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
       put unformatted ts9130 skip.
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.
     unix silent value ("chmod 777  " + trim(wsection) + ".l").
     END PROCEDURE.
     run inv239130l.
/*ssivan 07032701 B*/
     /* do i = 1 to integer(wtm_num): */
     repeat while (integer(wtm_num) / 100 >= 1):
	
       find first PRD_DET where PRD_DEV = V9130 no-lock no-error.
       IF AVAILABLE PRD_DET then do:
         unix silent value (trim(prd_path) + " " + "-n 100" + " " + trim(wsection) + ".l").
       end.
       wtm_num = string(integer(wtm_num) - 100).
     End. 
     if integer(wtm_num) > 0 then do:
       find first PRD_DET where PRD_DEV = V9130 no-lock no-error.
       IF AVAILABLE PRD_DET then do:
	unix silent value (trim(prd_path) + " " + "-n " + string(wtm_num) + " " + trim(wsection) + ".l").
	end.
	end.
   /* Internal Cycle END :9130    */
 /*ssivan 07032701 E*/
   END.
   pause 0 before-hide.
end.
