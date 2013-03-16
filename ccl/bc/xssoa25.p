/* Generate By Barcode Generator , Copyright by Softspeed - Build By Sam Song  */ 
/* SO Allocation by LOT */
/* Generate date / time  10/10/07 10:09:10 */
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
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xssoa25wtimeout" no-lock no-error. /*  Timeout - Program Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

mainloop:
REPEAT:
     /* CYCLE COUNTER -SECTION ID -- START*/
      sectionid = sectionid + 1 .
     /* SECTION ID -- END  */

     /* START  LINE :1002  �a�I[SITE]  */
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
FUNCTION GETSONBR RETURNS CHARACTER (INPUT ldlot AS CHARACTER , INPUT V1300 AS CHARACTER).
  
     
     DEF VARIABLE WOSOJOB LIKE wo_so_job.
     WOSOJOB = "".
     FOR EACH tr_hist WHERE tr_type = "RCT-WO" AND tr_serial = ldlot AND tr_part = V1300 AND tr_qty_loc <> 0 NO-LOCK :
         FIND FIRST wo_mstr WHERE wo_lot = tr_lot NO-LOCK NO-ERROR.
         IF AVAILABLE wo_mstr THEN WOSOJOB = wo_so_job .
     END.
     
     RETURN WOSOJOB.

END FUNCTION.
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
                display "[�P��Ʈ�LOT]���w�q��" + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 no-box.

                /* LABEL 1 - START */ 
                L10021 = "�a�I�]�w���~" .
                display L10021          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L10022 = "1.�S���]�w�q�{�a�I" .
                display L10022          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L10023 = "2.�v���]�w���~" .
                display L10023          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L10024 = "  �Ьd��" .
                display L10024          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 4 - END */ 
                display "��J�Ϋ�E�h�X "      format "x(40)" skip
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
     /* END    LINE :1002  �a�I[SITE]  */


   /* Additional Labels Format */
     /* START  LINE :1100  �P��q��[SalesOrder]  */
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
                display "[�P��Ʈ�LOT]���w�q��" + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1100 no-box.

                /* LABEL 1 - START */ 
                L11001 = "�P��q��?" .
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
                display "��J�Ϋ�E�h�X "      format "x(40)" skip
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
                  IF recid(SO_MSTR) = ? THEN find first SO_MSTR where 
                              ( SO_SITE = "" OR SO_SITE = V1002 ) AND  
                              SO_NBR >=  INPUT V1100
                               no-lock no-error.
                  ELSE find next SO_MSTR where 
                              ( SO_SITE = "" OR SO_SITE = V1002 )  
                               no-lock no-error.
                  IF AVAILABLE SO_MSTR then display skip 
            SO_NBR @ V1100 trim( SO_PO ) + "*" + string ( so_due_date ) @ WMESSAGE NO-LABEL with fram F1100.
                  else   display skip "" @ WMESSAGE with fram F1100.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(SO_MSTR) = ? THEN find first SO_MSTR where 
                              ( SO_SITE = "" OR SO_SITE = V1002 ) AND  
            SO_NBR <=  INPUT V1100
                               no-lock no-error.
                  ELSE find prev SO_MSTR where 
                              ( SO_SITE = "" OR SO_SITE = V1002 ) 
                               no-lock no-error.
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
        find first SO_MSTR where SO_NBR = V1100 AND ( SO_SITE = V1002 OR SO_SITE = "" )  NO-ERROR NO-WAIT.
        IF NOT AVAILABLE SO_MSTR then do:
                display skip "�L�ĩγQ��!" @ WMESSAGE NO-LABEL with fram F1100.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        leave V1100L.
     END.
     PV1100 = V1100.
     /* END    LINE :1100  �P��q��[SalesOrder]  */


   /* Additional Labels Format */
     /* START  LINE :1105  �Ȥ�N�X[Customer Code]  */
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
        find first so_mstr where so_nbr  = V1100 no-lock no-error.
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

                display "[�P��Ʈ�LOT]���w�q��" + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1105 no-box.

                /* LABEL 1 - START */ 
                  L11051 = "" . 
                display L11051          format "x(40)" skip with fram F1105 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11052 = "" . 
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
                display "��J�Ϋ�E�h�X "      format "x(40)" skip
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
     /* END    LINE :1105  �Ȥ�N�X[Customer Code]  */


   /* Additional Labels Format */
     /* START  LINE :1203  �w�p�o�f���[SHIPPMENT DATE]  */
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
                display "[�P��Ʈ�LOT]���w�q��" + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1203 no-box.

                /* LABEL 1 - START */ 
                L12031 = "�w�p�o�f���?" .
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
                display "��J�Ϋ�E�h�X "      format "x(40)" skip
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
     /* END    LINE :1203  �w�p�o�f���[SHIPPMENT DATE]  */


   /* Additional Labels Format */
     /* START  LINE :1300  ���~[Finished Goods]  */
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
        V1300 = " ".
        V1300 = ENTRY(1,V1300,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1300 = ENTRY(1,V1300,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[�P��Ʈ�LOT]���w�q��" + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1300 no-box.

                /* LABEL 1 - START */ 
                L13001 = "�f�~[���y]?" .
                display L13001          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find first so_mstr where so_nbr = V1100 no-lock no-error.
If AVAILABLE ( so_mstr ) then
                L13002 = "PO #:" + trim ( so_po ) .
                else L13002 = "" . 
                display L13002          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first so_mstr where so_nbr = V1100 no-lock no-error.
If AVAILABLE ( so_mstr ) then
                L13003 = "�Ȥ�:" + trim ( so_cust ) .
                else L13003 = "" . 
                display L13003          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                find first ad_mstr where ad_addr = V1105 no-lock no-error.
If AVAILABLE ( ad_mstr ) then
                L13004 = trim ( ad_name ) .
                else L13004 = "" . 
                display L13004          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 4 - END */ 
                display "��J�Ϋ�E�h�X "      format "x(40)" skip
        skip with fram F1300 no-box.
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
        find first SOD_DET where SOD_NBR = V1100 AND SOD_PART = ENTRY(1, V1300, "@")  no-lock no-error.
        IF NOT AVAILABLE SOD_DET then do:
                display skip "�Ӧ��~���ǰt,�Ьd��!" @ WMESSAGE NO-LABEL with fram F1300.
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
     /* END    LINE :1300  ���~[Finished Goods]  */


   /* Additional Labels Format */
   /* Internal Cycle Input :1305    */
   V1305LMAINLOOP:
   REPEAT:
     /* START  LINE :1305  �������  */
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
        find first sod_det where sod_nbr = V1100 and sod_site = V1002 and sod_part = V1300 no-lock no-error.
If AVAILABLE (sod_det) and string ( sod_line ) <> V1305 then
        V1305 = string (sod_line ).
        V1305 = ENTRY(1,V1305,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1305 = ENTRY(1,V1305,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        find last sod_det where sod_nbr = V1100 and sod_site = V1002 AND sod_part = V1300 no-lock no-error.
If AVAILABLE (sod_det) and string ( sod_line ) = V1305 then
        leave V1305L.
        /* LOGICAL SKIP END */
                display "[�P��Ʈ�LOT]���w�q��" + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1305 no-box.

                /* LABEL 1 - START */ 
                L13051 = "�q�涵��" .
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
                display "��J�Ϋ�E�h�X "      format "x(40)" skip
        skip with fram F1305 no-box.
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
                              sod_nbr = V1100 and sod_site = V1002 AND  
                              string ( SOD_LINE ) >=  INPUT V1305
                               no-lock no-error.
                  ELSE find next SOD_DET where 
                              sod_nbr = V1100 and sod_site = V1002  
                               no-lock no-error.
                  IF AVAILABLE SOD_DET then display skip 
            string ( SOD_LINE ) @ V1305 trim( string ( SOD_QTY_ORD - SOD_QTY_SHIP ) ) + "*" + String( SOD_DUE_DATE) @ WMESSAGE NO-LABEL with fram F1305.
                  else   display skip "" @ WMESSAGE with fram F1305.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(SOD_DET) = ? THEN find first SOD_DET where 
                              sod_nbr = V1100 and sod_site = V1002 AND  
            string ( SOD_LINE ) <=  INPUT V1305
                               no-lock no-error.
                  ELSE find prev SOD_DET where 
                              sod_nbr = V1100 and sod_site = V1002 
                               no-lock no-error.
                  IF AVAILABLE SOD_DET then display skip 
            string ( SOD_LINE ) @ V1305 trim( string ( SOD_QTY_ORD - SOD_QTY_SHIP ) ) + "*" + String( SOD_DUE_DATE) @ WMESSAGE NO-LABEL with fram F1305.
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
        find first SOD_DET where SOD_NBR = V1100 AND string ( sod_line ) = V1305 and SOD_SITE = V1002  NO-ERROR NO-WAIT.
        IF NOT AVAILABLE SOD_DET then do:
                display skip "�L�ĩγQ��!" @ WMESSAGE NO-LABEL with fram F1305.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1305.
        pause 0.
        leave V1305L.
     END.
     PV1305 = V1305.
     /* END    LINE :1305  �������  */


   /* Additional Labels Format */
     /* START  LINE :1309  Already Print Packing List  */
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
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1309 = "E".
        V1309 = ENTRY(1,V1309,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1309 = ENTRY(1,V1309,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        find first lad_det where lad_dataset = "sod_det" and lad_nbr = V1100 and lad_line = V1305 and lad_qty_pick <> 0 no-lock no-error.
If NOT AVAILABLE (lad_det) THEN
        leave V1309L.
        /* LOGICAL SKIP END */
                display "[�P��Ʈ�LOT]���w�q��" + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1309 no-box.

                /* LABEL 1 - START */ 
                L13091 = "ERR:�w��DN,����Ʈ�" .
                display L13091          format "x(40)" skip with fram F1309 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L13092 = "�й�w�XDN��,���X�f" .
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
                display "��J�Ϋ�E�h�X "      format "x(40)" skip
        skip with fram F1309 no-box.
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

                display "[�P��Ʈ�LOT]���w�q��" + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1410 no-box.

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
                display "��J�Ϋ�E�h�X "      format "x(40)" skip
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


   /* Additional Labels Format */
     /* START  LINE :1500  �帹[LOT]  */
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
                display "[�P��Ʈ�LOT]���w�q��" + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1500 no-box.

                /* LABEL 1 - START */ 
                L15001 = "�ƮƧ帹?" .
                display L15001          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                		Define variable MinLot like ld_lot.
		Define variable MinQty like ld_qty_oh.
		MinLot = "".
                MinQty = 0.
                find first ld_det where ld_part = V1300 and ld_site = V1002 and ld_qty_oh <> 0 and ld_ref = "" use-index ld_part_lot no-lock no-error.
If AVAILABLE ( ld_det ) then MinLot = ld_lot.


If AVAILABLE ( ld_det ) then
                L15002 = "�̤p:" + trim(ld_lot) .
                else L15002 = "" . 
                display L15002          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                for each  ld_det where ld_part = V1300 and ld_site = V1002 and ld_qty_oh <> 0 and ld_lot = MinLot and ld_ref = "" no-lock :
		     MinQty =  MinQty + ld_qty_oh.
                End.


Find first sod_det where string ( sod_line ) =   V1305  and sod_nbr = V1100 no-lock no-error.
If MinLot <> ""  then
                L15003 = "�w�s/SO:" + trim(string(MinQty)) + "/" +  (If AVAILABLE ( sod_det ) then string ( sod_qty_ord - sod_qty_ship ) else "0"  ) .
                else L15003 = "" . 
                display L15003          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L15004 = "�ƫ~:" + trim( V1300 ) .
                display L15004          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 4 - END */ 
                display "��J�Ϋ�E�h�X "      format "x(40)" skip
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
                              LD_PART = V1300 AND LD_QTY_OH <> 0 AND LD_SITE = V1002 AND ( LD_REF = "" OR LD_REF = V1100) and substring(ld_loc,1,3)<> 'crc' AND  
                              LD_LOT >=  INPUT V1500
                               use-index ld_part_lot
                               no-lock no-error.
                  ELSE find next LD_DET where 
                              LD_PART = V1300 AND LD_QTY_OH <> 0 AND LD_SITE = V1002 AND ( LD_REF = "" OR LD_REF = V1100) and substring(ld_loc,1,3)<> 'crc'  
                               use-index ld_part_lot
                               no-lock no-error.
                  IF AVAILABLE LD_DET then display skip 
            LD_LOT @ V1500 (IF LD_REF = "" THEN "�i" ELSE "�w" ) + "��SO/Q:" + GETSONBR(LD_LOT,V1300) + "/" + trim(string(LD_QTY_OH)) + "/" + trim ( LD_LOC ) @ WMESSAGE NO-LABEL with fram F1500.
                  else   display skip "" @ WMESSAGE with fram F1500.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(LD_DET) = ? THEN find first LD_DET where 
                              LD_PART = V1300 AND LD_QTY_OH <> 0 AND LD_SITE = V1002 AND ( LD_REF = "" OR LD_REF = V1100) and substring(ld_loc,1,3)<> 'crc' AND  
            LD_LOT <=  INPUT V1500
                               use-index ld_part_lot
                               no-lock no-error.
                  ELSE find prev LD_DET where 
                              LD_PART = V1300 AND LD_QTY_OH <> 0 AND LD_SITE = V1002 AND ( LD_REF = "" OR LD_REF = V1100) and substring(ld_loc,1,3)<> 'crc' 
                               use-index ld_part_lot
                               no-lock no-error.
                  IF AVAILABLE LD_DET then display skip 
            LD_LOT @ V1500 (IF LD_REF = "" THEN "�i" ELSE "�w" ) + "��SO/Q:" + GETSONBR(LD_LOT,V1300) + "/" + trim(string(LD_QTY_OH)) + "/" + trim ( LD_LOC ) @ WMESSAGE NO-LABEL with fram F1500.
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
        if (substring(V1100,1,1)="R" and V1100 <> substring(GETSONBR(V1500,V1300),1,8)) or (substring(V1100,1,7) <> substring(GETSONBR(V1500,V1300),1,7)) then do:
display skip "�帹�����q�椣�����J�q��" @ WMESSAGE NO-LABEL with fram F1500.
                pause 0 before-hide.
                Undo, retry.
End.
        IF not ( IF INDEX(V1500,"@" ) <> 0 then ENTRY(2,V1500,"@") else V1500 ) <> "" THEN DO:
                display skip "L����,���ର��" @ WMESSAGE NO-LABEL with fram F1500.
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
     /* END    LINE :1500  �帹[LOT]  */


   /* Additional Labels Format */
     /* START  LINE :1505  �w��[LOC]  */
     V1505L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1505           as char format "x(50)".
        define variable PV1505          as char format "x(50)".
        define variable L15051          as char format "x(40)".
        define variable L15052          as char format "x(40)".
        define variable L15053          as char format "x(40)".
        define variable L15054          as char format "x(40)".
        define variable L15055          as char format "x(40)".
        define variable L15056          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr ) then
        V1505 = pt_loc.
        V1505 = ENTRY(1,V1505,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1505 = ENTRY(1,V1505,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[�P��Ʈ�LOT]���w�q��" + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1505 no-box.

                /* LABEL 1 - START */ 
                L15051 = "�w��?" + pt_loc .
                display L15051          format "x(40)" skip with fram F1505 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L15052 = "" . 
                display L15052          format "x(40)" skip with fram F1505 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L15053 = "�q��/��:" + trim ( V1100 ) + "/" + trim ( V1305 ) .
                display L15053          format "x(40)" skip with fram F1505 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L15054 = "" . 
                display L15054          format "x(40)" skip with fram F1505 no-box.
                /* LABEL 4 - END */ 
                display "��J�Ϋ�E�h�X "      format "x(40)" skip
        skip with fram F1505 no-box.
        Update V1505
        WITH  fram F1505 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1505.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(LD_DET) = ? THEN find first LD_DET where 
                              LD_PART = V1300 AND LD_LOT =  V1500 AND LD_QTY_OH <> 0  AND LD_SITE = V1002 AND ( LD_REF = "" OR LD_REF = V1100) AND  
                              LD_LOC >=  INPUT V1505
                               no-lock no-error.
                  ELSE find next LD_DET where 
                              LD_PART = V1300 AND LD_LOT =  V1500 AND LD_QTY_OH <> 0  AND LD_SITE = V1002 AND ( LD_REF = "" OR LD_REF = V1100)  
                               no-lock no-error.
                  IF AVAILABLE LD_DET then display skip 
            LD_LOC @ V1505 (IF LD_REF = "" THEN "�i" ELSE "�w" ) + "��L/Q:" + LD_LOT + "/" + trim(string(LD_QTY_OH)) @ WMESSAGE NO-LABEL with fram F1505.
                  else   display skip "" @ WMESSAGE with fram F1505.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(LD_DET) = ? THEN find first LD_DET where 
                              LD_PART = V1300 AND LD_LOT =  V1500 AND LD_QTY_OH <> 0  AND LD_SITE = V1002 AND ( LD_REF = "" OR LD_REF = V1100) AND  
            LD_LOC <=  INPUT V1505
                               no-lock no-error.
                  ELSE find prev LD_DET where 
                              LD_PART = V1300 AND LD_LOT =  V1500 AND LD_QTY_OH <> 0  AND LD_SITE = V1002 AND ( LD_REF = "" OR LD_REF = V1100) 
                               no-lock no-error.
                  IF AVAILABLE LD_DET then display skip 
            LD_LOC @ V1505 (IF LD_REF = "" THEN "�i" ELSE "�w" ) + "��L/Q:" + LD_LOT + "/" + trim(string(LD_QTY_OH)) @ WMESSAGE NO-LABEL with fram F1505.
                  else   display skip "" @ WMESSAGE with fram F1505.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1505 = "e" THEN  LEAVE V1305LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1505.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1505.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        /* find first LOC_MSTR where LOC_LOC = V1505 AND LOC_SITE = V1002  no-lock no-error. 20080815-10:39*/
        find first LOC_MSTR where LOC_LOC = V1505 AND LOC_SITE = V1002 AND LOC_STATUS <> "WAIT1" no-lock no-error.
	IF NOT AVAILABLE LOC_MSTR then do:
                display skip "Error , Retry." @ WMESSAGE NO-LABEL with fram F1505.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1505.
        pause 0.
        leave V1505L.
     END.
     PV1505 = V1505.
     /* END    LINE :1505  �w��[LOC]  */


   /* Additional Labels Format */
     /* START  LINE :1600  �ƶq[QTY]  */
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
                display "[�P��Ʈ�LOT]���w�q��" + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1600 no-box.

                /* LABEL 1 - START */ 
                L16001 = "�l�[�ƮƼƶq?" .
                display L16001          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find first sod_det where sod_nbr = V1100 and string ( sod_line ) = V1305 no-lock no-error.
If AVAILABLE ( sod_det ) then
                L16002 = "�q��/�w�X:" + string ( sod_qty_ord ) + "/" + string (sod_qty_ship) .
                else L16002 = "" . 
                display L16002          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first sod_det where sod_nbr = V1100 and string ( sod_line ) = V1305 no-lock no-error.
If AVAILABLE ( sod_det ) then
                L16003 = "�w��/�߶q:" + string (sod_qty_all) + "/" + string ( sod_qty_pick ) .
                else L16003 = "" . 
                display L16003          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                find last ld_det where ld_part = V1300 and ld_loc = V1505 and ld_site = V1002 and ld_qty_oh <> 0 and ld_lot = V1500 and ( ld_ref = "" OR ld_ref = V1100 ) use-index ld_part_lot no-lock no-error.
If AVAILABLE ( ld_det ) then
                L16004 = "�帹/" + ( if ld_ref = "" then "�i" else "�w" ) + "��:" + V1500 + "/" +  string (ld_Qty_oh) .
                else L16004 = "" . 
                display L16004          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 4 - END */ 
                display "��J�Ϋ�E�h�X "      format "x(40)" skip
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
        find first LD_DET where ld_part  = V1300 AND ld_loc = V1505 and 
ld_site = V1002 and ld_lot = V1500 and  ( DECIMAL ( V1600 ) < 0 and ld_ref = V1100 and (ld_qty_oh + DECIMAL ( V1600 ) >= 0)
  OR
  DECIMAL ( V1600 ) > 0 and ld_ref = "" and ld_qty_oh >= DECIMAL ( V1600 )
  )  no-lock no-error.
        IF NOT AVAILABLE LD_DET then do:
                display skip "�i/�w�Ƽ� <: " + string( V1600 ) @ WMESSAGE NO-LABEL with fram F1600.
                pause 0 before-hide.
                undo, retry.
        end.
        IF not V1600 <> "0" THEN DO:
                display skip "�i/�w�Ƽ� <: " + string( V1600 ) @ WMESSAGE NO-LABEL with fram F1600.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1600.
        pause 0.
        leave V1600L.
     END.
     PV1600 = V1600.
     /* END    LINE :1600  �ƶq[QTY]  */


   /* Additional Labels Format */
     /* START  LINE :1700  �T�{[CONFIRM]  */
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
                display "[�P��Ʈ�LOT]���w�q��" + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1700 no-box.

                /* LABEL 1 - START */ 
                L17001 = "�ƫ~:" + trim(V1300) .
                display L17001          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L17002 = "�帹:" + trim ( V1500 ) .
                display L17002          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L17003 = "�w��:" + trim ( V1505 ) + "/" + trim( V1600 ) .
                display L17003          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                find first sod_det where sod_nbr = V1100 and sod_line = integer ( V1305 )  no-lock no-error.
If AVAILABLE ( sod_det ) then
                L17004 = "�q�楼�M�ƶq:" + ( if sod_qty_ord <= sod_qty_ship then "0" else ( string ( sod_qty_ord - sod_qty_ship ) ) ) .
                else L17004 = "" . 
                display L17004          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 4 - END */ 
                display "�T�{�L�b[Y],E�h�X"   format "x(40)" skip
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
        IF V1700 = "e" THEN  LEAVE V1305LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1700.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1700.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first so_mstr where so_nbr = V1100  NO-ERROR NO-WAIT.
        IF NOT AVAILABLE so_mstr then do:
                display skip "�L�ĩγQ��!" @ WMESSAGE NO-LABEL with fram F1700.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1700.
        pause 0.
        leave V1700L.
     END.
     PV1700 = V1700.
     /* END    LINE :1700  �T�{[CONFIRM]  */


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

                display "[�P��Ʈ�LOT]���w�q��" + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9000 no-box.

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
                display "��J�Ϋ�E�h�X "      format "x(40)" skip
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


   /* Additional Labels Format */
        display "...PROCESSING...  " NO-LABEL with fram F9000X no-box.
        pause 0.
     /*  Update MFG/PRO START  */ 
     {xssoa25u.i}
     /*  Update MFG/PRO END  */ 
        display  "" NO-LABEL with fram F9000X no-box .
        pause 0.
     /* START  LINE :9005  LOAD ALLOCATION DATA  */
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
        {xsso23s.i}
IF 1 = 1 THEN
        leave V9005L.
        /* LOGICAL SKIP END */
                display "[�P��Ʈ�LOT]���w�q��" + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9005 no-box.

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
                display "��J�Ϋ�E�h�X "      format "x(40)" skip
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
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9010 = ENTRY(1,V9010,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        find first lad_det where 
lad_dataset = "sod_det" and lad_nbr = V1100   and string ( lad_line ) = V1305     and lad_site = V1002 and lad_loc  = V1505 and lad_part = V1300 and lad_lot  = V1500 and lad_ref  = V1100 no-error.
If AVAILABLE ( lad_det ) then lad_user1 = V1203.
IF 1 = 2 THEN
        leave V9010L.
        /* LOGICAL SKIP END */
                display "[�P��Ʈ�LOT]���w�q��" + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9010 no-box.

                /* LABEL 1 - START */ 
                find last tr_hist where 
tr_date = today     and 
tr_trnbr > integer ( V9000 ) and 
tr_nbr  = V1100     and  tr_type = "RCT-TR"  and 
tr_site = V1002     and tr_part = V1300     and tr_serial = V1500   and 
tr_time  + 15 >= TIME 
use-index tr_date_trn no-lock no-error.
If AVAILABLE ( tr_hist ) then
                L90101 = "����w����" .
                else L90101 = "" . 
                display L90101          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find last tr_hist where 
tr_date = today     and 
tr_trnbr > integer ( V9000 ) and 
tr_nbr  = V1100     and  tr_type = "RCT-TR"  and  tr_site = V1002     and tr_part = V1300     and tr_serial = V1500   and 
tr_time  + 15 >= TIME 
use-index tr_date_trn no-lock no-error.
If AVAILABLE ( tr_hist ) then
                L90102 = "����� :" + trim(string(tr_trnbr)) .
                else L90102 = "" . 
                display L90102          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find last tr_hist where 
tr_date = today     and 
tr_trnbr > integer ( V9000 ) and 
tr_nbr  = V1100     and  tr_type = "RCT-TR"  and  tr_site = V1002     and tr_part = V1300     and tr_serial = V1500   and 
tr_time  + 15 >= TIME 
use-index tr_date_trn no-lock no-error.
If NOT AVAILABLE ( tr_hist ) then
                L90103 = "������楢��" .
                else L90103 = "" . 
                display L90103          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L90104 = "" . 
                display L90104          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 4 - END */ 
                display "��J�Ϋ�E�h�X "      format "x(40)" skip
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


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1305LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :9010    */
   END.
   pause 0 before-hide.
end.