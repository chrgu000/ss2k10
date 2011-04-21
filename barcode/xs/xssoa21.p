/* Generate By Barcode Generator , Copyright by Softspeed - Build By Sam Song  */ 
/* INV ALLOCATION INQ BY LOC */
/* Generate date / time  2007-1-9 10:55:55 */
define variable sectionid as integer init 0 .
define variable WMESSAGE  as char format "x(80)" init "".
define variable wtm_num   as char format "x(20)" init "0".
define variable wtm_fm    as char format "x(16)".
define variable wsection as char format "x(16)".
define variable i as integer .

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout" no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xssoa21wtimeout" no-lock no-error. /*  Timeout - Program Level */
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
                display "[�P��ƮƬd��]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 no-box.

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
                display "[�P��ƮƬd��]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1100 no-box.

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
     /* START  LINE :1205  �������  */
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
        find first sod_det where sod_nbr = V1100 and sod_site = V1002 no-lock no-error.
If AVAILABLE (sod_det) and string ( sod_line ) <> V1205 then
        V1205 = string (sod_line ).
        V1205 = ENTRY(1,V1205,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1205 = ENTRY(1,V1205,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        find last sod_det where sod_nbr = V1100 and sod_site = V1002  no-lock no-error.
If AVAILABLE (sod_det) and string ( sod_line ) = V1205 then
        leave V1205L.
        /* LOGICAL SKIP END */
                display "[�P��ƮƬd��]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1205 no-box.

                /* LABEL 1 - START */ 
                L12051 = "�q�涵��?" .
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
                display "��J�Ϋ�E�h�X "      format "x(40)" skip
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
                  IF recid(SOD_DET) = ? THEN find first SOD_DET where 
                              sod_nbr = V1100 and sod_site = V1002 AND  
                              string ( SOD_LINE ) >=  INPUT V1205
                               no-lock no-error.
                  ELSE find next SOD_DET where 
                              sod_nbr = V1100 and sod_site = V1002  
                               no-lock no-error.
                  IF AVAILABLE SOD_DET then display skip 
            string ( SOD_LINE ) @ V1205 "�����:" + String( SOD_DUE_DATE) @ L12052 trim(SOD_PART) @ WMESSAGE NO-LABEL with fram F1205.
                  else   display skip "" @ WMESSAGE with fram F1205.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(SOD_DET) = ? THEN find first SOD_DET where 
                              sod_nbr = V1100 and sod_site = V1002 AND  
            string ( SOD_LINE ) <=  INPUT V1205
                               no-lock no-error.
                  ELSE find prev SOD_DET where 
                              sod_nbr = V1100 and sod_site = V1002 
                               no-lock no-error.
                  IF AVAILABLE SOD_DET then display skip 
            string ( SOD_LINE ) @ V1205 "�����:" + String( SOD_DUE_DATE) @ L12052 trim(SOD_PART) @ WMESSAGE NO-LABEL with fram F1205.
                  else   display skip "" @ WMESSAGE with fram F1205.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1205 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1205.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1205.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first SOD_DET where SOD_NBR = V1100 AND string ( sod_line ) = V1205 and SOD_SITE = V1002  no-lock no-error.
        IF NOT AVAILABLE SOD_DET then do:
                display skip "�L�ĩγQ��!" @ WMESSAGE NO-LABEL with fram F1205.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1205.
        pause 0.
        leave V1205L.
     END.
     PV1205 = V1205.
     /* END    LINE :1205  �������  */


   /* Additional Labels Format */
     /* START  LINE :1300  �ƫ~[ITEM]  */
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
        find first sod_det where sod_nbr = V1100 and sod_line = integer ( V1205 ) no-lock no-error.
If AVAILABLE (sod_det) THEN
        V1300 = sod_part.
        V1300 = ENTRY(1,V1300,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1300 = ENTRY(1,V1300,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[�P��ƮƬd��]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1300 no-box.

                /* LABEL 1 - START */ 
                L13001 = "�ƫ~ �� �ƫ~+�帹?" .
                display L13001          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find first sod_det where sod_nbr = V1100 and sod_line = integer ( V1205 ) no-lock no-error.
If AVAILABLE (sod_det) THEN
                L13002 = trim(sod_part) .
                else L13002 = "" . 
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
                display "��J�Ϋ�E�h�X "      format "x(40)" skip
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
        IF V1300 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1300.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first LAD_DET where LAD_PART = ENTRY(1, V1300, "@") AND LAD_NBR = V1100 AND LAD_LINE = V1205  no-lock no-error.
        IF NOT AVAILABLE LAD_DET then do:
                display skip "���~,����!" @ WMESSAGE NO-LABEL with fram F1300.
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
     /* END    LINE :1300  �ƫ~[ITEM]  */


   /* Additional Labels Format */
     /* START  LINE :1510  ���Ӹ��[Detail]  */
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
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1510 = ENTRY(1,V1510,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[�P��ƮƬd��]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1510 no-box.

                /* LABEL 1 - START */ 
                L15101 = "*�ƮƫH��*" .
                display L15101          format "x(40)" skip with fram F1510 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L15102 = "�q��/��:" + trim ( V1100 ) + "/" + trim (V1205) .
                display L15102          format "x(40)" skip with fram F1510 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first sod_det where sod_nbr = V1100 and sod_line = integer ( V1205 ) no-lock no-error.
If AVAILABLE (sod_det) THEN
                L15103 = "�w��/��:" + string ( sod_qty_all ) + "/" + string ( sod_qty_pick ) .
                else L15103 = "" . 
                display L15103          format "x(40)" skip with fram F1510 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L15104 = "�ƫ~:" + trim (V1300) .
                display L15104          format "x(40)" skip with fram F1510 no-box.
                /* LABEL 4 - END */ 
                display "��J�Ϋ�E�h�X "      format "x(40)" skip
        skip with fram F1510 no-box.
        Update V1510
        WITH  fram F1510 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1510.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(LAD_DET) = ? THEN find first LAD_DET where 
                              LAD_DATASET = "SOD_DET" AND LAD_PART = V1300 AND LAD_SITE = V1002 AND LAD_LINE = V1205
AND LAD_REF  = V1100 AND  
                              LAD_LOT >=  INPUT V1510
                               no-lock no-error.
                  ELSE find next LAD_DET where 
                              LAD_DATASET = "SOD_DET" AND LAD_PART = V1300 AND LAD_SITE = V1002 AND LAD_LINE = V1205
AND LAD_REF  = V1100  
                               no-lock no-error.
                  IF AVAILABLE LAD_DET then display skip 
            LAD_LOT @ V1510 "��/�߶q:" + trim(string(LAD_QTY_ALL))  + "/" + trim(string(LAD_QTY_PICK)) + "/" + trim (LAD_LOC) @ WMESSAGE NO-LABEL with fram F1510.
                  else   display skip "" @ WMESSAGE with fram F1510.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(LAD_DET) = ? THEN find first LAD_DET where 
                              LAD_DATASET = "SOD_DET" AND LAD_PART = V1300 AND LAD_SITE = V1002 AND LAD_LINE = V1205
AND LAD_REF  = V1100 AND  
            LAD_LOT <=  INPUT V1510
                               no-lock no-error.
                  ELSE find prev LAD_DET where 
                              LAD_DATASET = "SOD_DET" AND LAD_PART = V1300 AND LAD_SITE = V1002 AND LAD_LINE = V1205
AND LAD_REF  = V1100 
                               no-lock no-error.
                  IF AVAILABLE LAD_DET then display skip 
            LAD_LOT @ V1510 "��/�߶q:" + trim(string(LAD_QTY_ALL))  + "/" + trim(string(LAD_QTY_PICK)) + "/" + trim (LAD_LOC) @ WMESSAGE NO-LABEL with fram F1510.
                  else   display skip "" @ WMESSAGE with fram F1510.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1510 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1510.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1510.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1510.
        pause 0.
        leave V1510L.
     END.
     IF INDEX(V1510,"@" ) <> 0 then V1510 = ENTRY(2,V1510,"@").
     PV1510 = V1510.
     /* END    LINE :1510  ���Ӹ��[Detail]  */


   /* Additional Labels Format */
end.