/* WO ISSUE [NORMAL MATERIAL] */
/* Generate date / time  2009-4-26 15:14:31 */
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
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xswoi12wtimeout" no-lock no-error. /*  Timeout - Program Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

mainloop:
REPEAT:
batchrun = no . /*cimload,��Щ��ĳ�yes,����Ļ���*/
     /* CYCLE COUNTER -SECTION ID -- START*/
      sectionid = sectionid + 1 .
     /* SECTION ID -- END  */

     /* START  LINE :1002  �ص�[SITE]  */
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
                display "[��������ת��]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 no-box.

                /* LABEL 1 - START */ 
                L10021 = "��ʼֵ����:" .
                display L10021          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L10022 = "1.Ĭ��Ȩ��/�ص�����" .
                display L10022          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L10023 = "2.����ڼ�����" .
                display L10023          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L10024 = "  ����" .
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
                display "ȷ�ϻ�*�˳� "      format "x(40)" skip
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
     /* END    LINE :1002  �ص�[SITE]  */


   /* Additional Labels Format */
     /* START  LINE :1110  ID[ID]  */
     V1110L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1110           as char format "x(50)".
        define variable PV1110          as char format "x(50)".
        define variable L11101          as char format "x(40)".
        define variable L11102          as char format "x(40)".
        define variable L11103          as char format "x(40)".
        define variable L11104          as char format "x(40)".
        define variable L11105          as char format "x(40)".
        define variable L11106          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1110 = ENTRY(1,V1110,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[��������ת��]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1110 no-box.

                /* LABEL 1 - START */ 
                L11101 = "����ID#" .
                display L11101          format "x(40)" skip with fram F1110 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11102 = "" . 
                display L11102          format "x(40)" skip with fram F1110 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11103 = "" . 
                display L11103          format "x(40)" skip with fram F1110 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11104 = "" . 
                display L11104          format "x(40)" skip with fram F1110 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11105 = "" . 
                display L11105          format "x(40)" skip with fram F1110 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11106 = "" . 
                display L11106          format "x(40)" skip with fram F1110 no-box.
                /* LABEL 6 - END */ 
                display "ȷ�ϻ�*�˳� "      format "x(40)" skip
        skip with fram F1110 no-box.
        Update V1110
        WITH  fram F1110 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        v_recno = ? .
        display skip "^" @ WMESSAGE NO-LABEL with fram F1110.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
               if v_recno = ? then
                  find first wo_mstr where 
                              INDEX("AR",WO_STATUS) <> 0 and wo_site = V1002 AND  
                              wo_lot >  INPUT V1110
                   no-lock no-error.
               else
                  find next wo_mstr where 
                              INDEX("AR",WO_STATUS) <> 0 and wo_site = V1002
                   no-lock no-error.
                  IF not AVAILABLE wo_mstr then do: 
                      if v_recno <> ? then 
                          find wo_mstr where recid(wo_mstr) = v_recno no-lock no-error .
                      else 
                          find last wo_mstr where 
                              INDEX("AR",WO_STATUS) <> 0 and wo_site = V1002
                          no-lock no-error.
                  end. 
                  v_recno = recid(wo_mstr) .
                  IF AVAILABLE wo_mstr then display skip 
                         wo_lot @ V1110 "��Ʒ: " +  trim (wo_part) @ WMESSAGE NO-LABEL with fram F1110.
                  else   display skip "" @ WMESSAGE with fram F1110.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
               if v_recno = ? then
                  find last wo_mstr where 
                              INDEX("AR",WO_STATUS) <> 0 and wo_site = V1002 AND  
                              wo_lot <  INPUT V1110
                  no-lock no-error.
               else 
                  find prev wo_mstr where 
                              INDEX("AR",WO_STATUS) <> 0 and wo_site = V1002
                  no-lock no-error.
                  IF not AVAILABLE wo_mstr then do: 
                      if v_recno <> ? then 
                          find wo_mstr where recid(wo_mstr) = v_recno no-lock no-error .
                      else 
                          find first wo_mstr where 
                              INDEX("AR",WO_STATUS) <> 0 and wo_site = V1002
                          no-lock no-error.
                  end. 
                  v_recno = recid(wo_mstr) .
                  IF AVAILABLE wo_mstr then display skip 
                         wo_lot @ V1110 "��Ʒ: " +  trim (wo_part) @ WMESSAGE NO-LABEL with fram F1110.
                  else   display skip "" @ WMESSAGE with fram F1110.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1110 = "*" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1110.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1110.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first wo_mstr where wo_lot = V1110 AND INDEX("AR",WO_STATUS) <> 0 AND wo_site = V1002  NO-ERROR NO-WAIT.
        IF NOT AVAILABLE wo_mstr then do:
                display skip "��Ч����!" @ WMESSAGE NO-LABEL with fram F1110.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1110.
        pause 0.
        leave V1110L.
     END.
     PV1110 = V1110.
     /* END    LINE :1110  ID[ID]  */


   /* Additional Labels Format */
     /* START  LINE :1200  ��Ʒ[FG]  */
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
        V1200 = ENTRY(1,V1200,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1200L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1200L .
        /* --CYCLE TIME SKIP -- END  */

                display "[��������ת��]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1200 no-box.

                /* LABEL 1 - START */ 
                find first wo_mstr where wo_lot = V1110  no-lock no-error.
If AVAILABLE ( wo_mstr ) then
                L12001 = "��Ʒ: " + trim(wo_part) .
                else L12001 = "" . 
                display L12001          format "x(40)" skip with fram F1200 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find first wo_mstr where wo_lot = V1110  no-lock no-error.
Find first pt_mstr where pt_part = wo_part no-lock no-error.
If AVAILABLE ( pt_mstr ) then
                L12002 = pt_desc1 .
                else L12002 = "" . 
                display L12002          format "x(40)" skip with fram F1200 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first wo_mstr where wo_lot = V1110  no-lock no-error.
Find first pt_mstr where pt_part = wo_part no-lock no-error.
If AVAILABLE ( pt_mstr ) then
                L12003 = pt_desc2 .
                else L12003 = "" . 
                display L12003          format "x(40)" skip with fram F1200 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L12004 = "" . 
                display L12004          format "x(40)" skip with fram F1200 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L12005 = "" . 
                display L12005          format "x(40)" skip with fram F1200 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L12006 = "" . 
                display L12006          format "x(40)" skip with fram F1200 no-box.
                /* LABEL 6 - END */ 
                display "ȷ�ϻ�*�˳� "      format "x(40)" skip
        skip with fram F1200 no-box.
        /* DISPLAY ONLY */
        define variable X1200           as char format "x(40)".
        X1200 = V1200.
        V1200 = "".
        /* DISPLAY ONLY */
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
        V1200 = X1200.
        /* DISPLAY ONLY */
        LEAVE V1200L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1200 = "*" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1200.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1200.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1200.
        pause 0.
        leave V1200L.
     END.
     PV1200 = V1200.
     /* END    LINE :1200  ��Ʒ[FG]  */


   /* Additional Labels Format */
     /* START  LINE :1203  ��������[EFFDATE]  */
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
        find first code_mstr where code_fldname = "BARCODEFIELDDISABLE" and code_value = "WOI10_V1203" no-error.
If AVAILABLE ( code_mstr ) then
        leave V1203L.
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1203L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1203L .
        /* --CYCLE TIME SKIP -- END  */

                display "[��������ת��]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1203 no-box.

                /* LABEL 1 - START */ 
                L12031 = "��������?" .
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


                /* LABEL 5 - START */ 
                  L12035 = "" . 
                display L12035          format "x(40)" skip with fram F1203 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L12036 = "" . 
                display L12036          format "x(40)" skip with fram F1203 no-box.
                /* LABEL 6 - END */ 
                display "ȷ�ϻ�*�˳� "      format "x(40)" skip
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
     /* END    LINE :1203  ��������[EFFDATE]  */


   /* Additional Labels Format */
   /* Internal Cycle Input :1300    */
   V1300LMAINLOOP:
   REPEAT:
     /* START  LINE :1300  ��Ʒ[Raw Material]  */
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
        V1300 = " ".
        V1300 = ENTRY(1,V1300,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[��������ת��]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1300 no-box.

                /* LABEL 1 - START */ 
                L13001 = "��Ʒ �� ��Ʒ+����?" .
                display L13001          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L13002 = "����ID:" + V1110 .
                display L13002          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first wo_mstr where wo_lot = V1110  no-lock no-error.
If AVAILABLE ( wo_mstr ) then
                L13003 = "���Ʒ:" + wo_part .
                else L13003 = "" . 
                display L13003          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13004 = "" . 
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
                display "ȷ�ϻ�*�˳� "      format "x(40)" skip
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
        v_recno = ? .
        display skip "^" @ WMESSAGE NO-LABEL with fram F1300.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
               if v_recno = ? then
                  find first LAD_DET where 
                              lad_dataset = "wod_det" and lad_nbr = V1110 and lad_site = V1002 and ( lad_qty_all + lad_qty_pick ) <> 0 AND  
                              trim(lad_PART) + "@" + lad_lot + "@" + lad_loc >  INPUT V1300
                   no-lock no-error.
               else
                  find next LAD_DET where 
                              lad_dataset = "wod_det" and lad_nbr = V1110 and lad_site = V1002 and ( lad_qty_all + lad_qty_pick ) <> 0
                   no-lock no-error.
                  IF not AVAILABLE LAD_DET then do: 
                      if v_recno <> ? then 
                          find LAD_DET where recid(LAD_DET) = v_recno no-lock no-error .
                      else 
                          find last LAD_DET where 
                              lad_dataset = "wod_det" and lad_nbr = V1110 and lad_site = V1002 and ( lad_qty_all + lad_qty_pick ) <> 0
                          no-lock no-error.
                  end. 
                  v_recno = recid(LAD_DET) .
                  IF AVAILABLE LAD_DET then display skip 
                         trim(lad_PART) + "@" + lad_lot + "@" + lad_loc @ V1300 "���Ͽ�λ/����:" + lad_loc + "@" + string ( lad_qty_pick) @ WMESSAGE NO-LABEL with fram F1300.
                  else   display skip "" @ WMESSAGE with fram F1300.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
               if v_recno = ? then
                  find last LAD_DET where 
                              lad_dataset = "wod_det" and lad_nbr = V1110 and lad_site = V1002 and ( lad_qty_all + lad_qty_pick ) <> 0 AND  
                              trim(lad_PART) + "@" + lad_lot + "@" + lad_loc <  INPUT V1300
                  no-lock no-error.
               else 
                  find prev LAD_DET where 
                              lad_dataset = "wod_det" and lad_nbr = V1110 and lad_site = V1002 and ( lad_qty_all + lad_qty_pick ) <> 0
                  no-lock no-error.
                  IF not AVAILABLE LAD_DET then do: 
                      if v_recno <> ? then 
                          find LAD_DET where recid(LAD_DET) = v_recno no-lock no-error .
                      else 
                          find first LAD_DET where 
                              lad_dataset = "wod_det" and lad_nbr = V1110 and lad_site = V1002 and ( lad_qty_all + lad_qty_pick ) <> 0
                          no-lock no-error.
                  end. 
                  v_recno = recid(LAD_DET) .
                  IF AVAILABLE LAD_DET then display skip 
                         trim(lad_PART) + "@" + lad_lot + "@" + lad_loc @ V1300 "���Ͽ�λ/����:" + lad_loc + "@" + string ( lad_qty_pick) @ WMESSAGE NO-LABEL with fram F1300.
                  else   display skip "" @ WMESSAGE with fram F1300.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        /* **SKIP TO MAIN LOOP START** */
        IF V1300 = "*" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        display  skip WMESSAGE NO-LABEL with fram F1300.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        if v1300 begins "*" and v1300 <> "*" then do:
            v1300 = substring(v1300,2) .
        End.
        if index(v1300,"@") <> 0 then do:
            if entry(2,v1300,"@") = "/" then v1300 = entry(1,v1300,"@") + "@" .
        end.  
        Find first pt_mstr where pt_part = ENTRY(1, V1300, "@")  no-lock no-error .
        If available pt_mstr then do:
           if can-find(first isd_det  where isd_status = string(pt_status,"x(8)") + "#" and ( isd_tr_type = "ISS-TR" or  isd_tr_type = "RCT-TR" ))
           then do:
              disp "���״̬���ƽ���"   @ WMESSAGE NO-LABEL with fram F1300.
              undo, retry.
           End.
        End. /* available pt_mstr */
else do:
              disp "���������"   @ WMESSAGE NO-LABEL with fram F1300.
              undo, retry.
        End.

        Find first wod_det where wod_lot = v1110 and wod_part = ENTRY(1, V1300, "@")  no-lock no-error .
        If not avail wod_det then do:
                display skip "��������������" @ WMESSAGE NO-LABEL with fram F1300.
                pause 0 before-hide.
                Undo, retry.            
        End.

        Find first lad_det 
            where lad_dataset = "wod_det" 
            and lad_nbr = V1110 
            and lad_site = V1002 
            and lad_part = ENTRY(1, V1300, "@")  
            and lad_lot = ENTRY(2, V1300, "@")
            and ( lad_qty_all + lad_qty_pick <> 0 )  
        no-lock no-error.
        If not avail lad_det  then do:
                display skip "��������ƥ��" @ WMESSAGE NO-LABEL with fram F1300.
                pause 0 before-hide.
                Undo, retry.
        End.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
        leave V1300L.
     END.
     IF INDEX(V1300,"@" ) = 0 then V1300 = V1300 + "@".
     PV1300 = V1300.
     V1300 = ENTRY(1,V1300,"@").
     /* END    LINE :1300  ��Ʒ[Raw Material]  */


   /* Additional Labels Format */
     /* START  LINE :1400  �����߿�λ[LOC]  */
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
        PV1300 = PV1300 + "@@".
        V1400 = ( if ENTRY(3, PV1300, "@") = "" then "" else ENTRY(3, PV1300, "@") ).
        find first lad_det 
            where lad_dataset = "wod_det" 
            and lad_nbr = V1110 
            and lad_site = V1002 
            and lad_part = ENTRY(1, V1300, "@")  
            and (lad_lot = ENTRY(2, PV1300, "@") or ENTRY(2, PV1300, "@") = "" )
            and ( lad_qty_all + lad_qty_pick <> 0 )  
        no-lock no-error.
        If avail lad_det  and v1400 = "" then v1400 = lad_loc .
        V1400 = v1400.
        V1400 = ENTRY(1,V1400,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1400 = ENTRY(1,V1400,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[��������ת��]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1400 no-box.

                /* LABEL 1 - START */ 
                L14001 = "�����߿�λ?" .
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
                display "ȷ�ϻ�*�˳� "      format "x(40)" skip
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
                  find first lad_det where 
                              lad_dataset = "wod_det" 
                            and lad_nbr = V1110 
                            and lad_site = V1002 
                            and lad_part = v1300  
                            and (lad_lot = ENTRY(2, PV1300, "@") or ENTRY(2, PV1300, "@") = "" )
                            and ( lad_qty_all + lad_qty_pick <> 0 ) AND  
                              lad_loc >  INPUT V1400
                   no-lock no-error.
               else
                  find next lad_det where 
                              lad_dataset = "wod_det" 
                            and lad_nbr = V1110 
                            and lad_site = V1002 
                            and lad_part = v1300  
                            and (lad_lot = ENTRY(2, PV1300, "@") or ENTRY(2, PV1300, "@") = "" )
                            and ( lad_qty_all + lad_qty_pick <> 0 )
                   no-lock no-error.
                  IF not AVAILABLE lad_det then do: 
                      if v_recno <> ? then 
                          find lad_det where recid(lad_det) = v_recno no-lock no-error .
                      else 
                          find last lad_det where 
                              lad_dataset = "wod_det" 
                            and lad_nbr = V1110 
                            and lad_site = V1002 
                            and lad_part = v1300  
                            and (lad_lot = ENTRY(2, PV1300, "@") or ENTRY(2, PV1300, "@") = "" )
                            and ( lad_qty_all + lad_qty_pick <> 0 )
                          no-lock no-error.
                  end. 
                  v_recno = recid(lad_det) .
                  IF AVAILABLE lad_det then display skip 
                         lad_loc @ V1400 lad_lot + "@" + string ( lad_qty_pick) @ WMESSAGE NO-LABEL with fram F1400.
                  else   display skip "" @ WMESSAGE with fram F1400.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
               if v_recno = ? then
                  find last lad_det where 
                              lad_dataset = "wod_det" 
                            and lad_nbr = V1110 
                            and lad_site = V1002 
                            and lad_part = v1300  
                            and (lad_lot = ENTRY(2, PV1300, "@") or ENTRY(2, PV1300, "@") = "" )
                            and ( lad_qty_all + lad_qty_pick <> 0 ) AND  
                              lad_loc <  INPUT V1400
                  no-lock no-error.
               else 
                  find prev lad_det where 
                              lad_dataset = "wod_det" 
                            and lad_nbr = V1110 
                            and lad_site = V1002 
                            and lad_part = v1300  
                            and (lad_lot = ENTRY(2, PV1300, "@") or ENTRY(2, PV1300, "@") = "" )
                            and ( lad_qty_all + lad_qty_pick <> 0 )
                  no-lock no-error.
                  IF not AVAILABLE lad_det then do: 
                      if v_recno <> ? then 
                          find lad_det where recid(lad_det) = v_recno no-lock no-error .
                      else 
                          find first lad_det where 
                              lad_dataset = "wod_det" 
                            and lad_nbr = V1110 
                            and lad_site = V1002 
                            and lad_part = v1300  
                            and (lad_lot = ENTRY(2, PV1300, "@") or ENTRY(2, PV1300, "@") = "" )
                            and ( lad_qty_all + lad_qty_pick <> 0 )
                          no-lock no-error.
                  end. 
                  v_recno = recid(lad_det) .
                  IF AVAILABLE lad_det then display skip 
                         lad_loc @ V1400 lad_lot + "@" + string ( lad_qty_pick) @ WMESSAGE NO-LABEL with fram F1400.
                  else   display skip "" @ WMESSAGE with fram F1400.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1400 = "*" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1400.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1400.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        if v1400 begins "*" and v1400 <> "*" then do:
            v1400 = substring(v1400,2) .
        end.  
        find first lad_det where 
                lad_dataset = "wod_det" 
                and lad_nbr = V1110 
                and lad_site = V1002 
                and lad_loc  = v1400 
                and lad_part = v1300  
                and (lad_lot = ENTRY(2, PV1300, "@") or ENTRY(2, PV1300, "@") = "" )
                and ( lad_qty_all + lad_qty_pick <> 0 ) 
         no-lock no-error .
         If not avail lad_det then do:
             display "������ϸ������" @ WMESSAGE NO-LABEL with fram F1400.
             undo,retry .
         End.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1400.
        pause 0.
        leave V1400L.
     END.
     PV1400 = V1400.
     /* END    LINE :1400  �����߿�λ[LOC]  */


   /* Additional Labels Format */
     /* START  LINE :1410  Lot Control  */
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

                display "[��������ת��]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1410 no-box.

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
                display "ȷ�ϻ�*�˳� "      format "x(40)" skip
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
        IF V1410 = "*" THEN  LEAVE V1300LMAINLOOP.
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
     /* END    LINE :1410  Lot Control  */


   /* Additional Labels Format */
     /* START  LINE :1500  ����[LOT]  */
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

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1500L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1500L .
        /* --CYCLE TIME SKIP -- END  */

                display "[��������ת��]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1500 no-box.

                /* LABEL 1 - START */ 
                L15001 = "����?" .
                display L15001          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find first ld_det where ld_part = V1300 and ld_site = V1002 and ld_ref = "" and ld_loc = V1400 and ld_qty_oh <> 0 use-index ld_part_lot no-lock no-error.
If AVAILABLE ( ld_det ) then
                L15002 = "��С:" + trim(ld_lot) .
                else L15002 = "" . 
                display L15002          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first ld_det where ld_part = V1300 and ld_site = V1002 and ld_ref = "" and ld_loc = V1400 and ld_qty_oh <> 0 use-index ld_part_lot no-lock no-error.
If AVAILABLE ( ld_det ) then
                L15003 = "���:" + trim ( V1400 ) + "/" + trim(string(ld_qty_oh)) .
                else L15003 = "" . 
                display L15003          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L15004 = "��Ʒ:" + trim( V1300 ) .
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
                display "ȷ�ϻ�*�˳� "      format "x(40)" skip
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
        v_recno = ? .
        display skip "^" @ WMESSAGE NO-LABEL with fram F1500.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
               if v_recno = ? then
                  find first LD_DET where 
                              LD_PART = V1300 AND LD_LOC = V1400 AND LD_QTY_OH <> 0  AND LD_SITE = V1002 AND LD_REF = "" AND  
                              LD_LOT >  INPUT V1500
                   no-lock no-error.
               else
                  find next LD_DET where 
                              LD_PART = V1300 AND LD_LOC = V1400 AND LD_QTY_OH <> 0  AND LD_SITE = V1002 AND LD_REF = ""
                   no-lock no-error.
                  IF not AVAILABLE LD_DET then do: 
                      if v_recno <> ? then 
                          find LD_DET where recid(LD_DET) = v_recno no-lock no-error .
                      else 
                          find last LD_DET where 
                              LD_PART = V1300 AND LD_LOC = V1400 AND LD_QTY_OH <> 0  AND LD_SITE = V1002 AND LD_REF = ""
                          no-lock no-error.
                  end. 
                  v_recno = recid(LD_DET) .
                  IF AVAILABLE LD_DET then display skip 
                         LD_LOT @ V1500 LD_LOT + "/" + trim(string(LD_QTY_OH)) @ WMESSAGE NO-LABEL with fram F1500.
                  else   display skip "" @ WMESSAGE with fram F1500.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
               if v_recno = ? then
                  find last LD_DET where 
                              LD_PART = V1300 AND LD_LOC = V1400 AND LD_QTY_OH <> 0  AND LD_SITE = V1002 AND LD_REF = "" AND  
                              LD_LOT <  INPUT V1500
                  no-lock no-error.
               else 
                  find prev LD_DET where 
                              LD_PART = V1300 AND LD_LOC = V1400 AND LD_QTY_OH <> 0  AND LD_SITE = V1002 AND LD_REF = ""
                  no-lock no-error.
                  IF not AVAILABLE LD_DET then do: 
                      if v_recno <> ? then 
                          find LD_DET where recid(LD_DET) = v_recno no-lock no-error .
                      else 
                          find first LD_DET where 
                              LD_PART = V1300 AND LD_LOC = V1400 AND LD_QTY_OH <> 0  AND LD_SITE = V1002 AND LD_REF = ""
                          no-lock no-error.
                  end. 
                  v_recno = recid(LD_DET) .
                  IF AVAILABLE LD_DET then display skip 
                         LD_LOT @ V1500 LD_LOT + "/" + trim(string(LD_QTY_OH)) @ WMESSAGE NO-LABEL with fram F1500.
                  else   display skip "" @ WMESSAGE with fram F1500.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1500 = "*" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1500.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1500.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first lad_det where 
                lad_dataset = "wod_det" 
                and lad_nbr = V1110 
                and lad_site = V1002 
                and lad_loc  = v1400 
                and lad_part = v1300  
                and (lad_lot = v1500 )
                and ( lad_qty_all + lad_qty_pick <> 0 ) 
         no-lock no-error .
         if not avail lad_det then do:
             display "������ϸ������" @ WMESSAGE NO-LABEL with fram F1500.
             undo,retry .
         end.
        IF not ( IF INDEX(V1500,"@" ) <> 0 then ENTRY(2,V1500,"@") else V1500 ) <> "" THEN DO:
                display skip "L����,����Ϊ��" @ WMESSAGE NO-LABEL with fram F1500.
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
     /* END    LINE :1500  ����[LOT]  */


   /* Additional Labels Format */
     /* START  LINE :1600  ����[QTY]  */
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
        find first lad_det 
            where lad_dataset = "wod_det" 
            and lad_site = V1002 
            and lad_nbr = V1110 
            and lad_part = V1300 
            and lad_loc = V1400  
            and lad_lot = V1500 
            and lad_qty_pick + lad_qty_all <> 0
        no-lock no-error.
        V1600 = string(if avail lad_det then lad_qty_pick  else 0 ).
        V1600 = v1600.
        V1600 = ENTRY(1,V1600,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1600 = ENTRY(1,V1600,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[��������ת��]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1600 no-box.

                /* LABEL 1 - START */ 
                L16001 = "��������?" .
                display L16001          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L16002 = "��Ʒ:" + trim( V1300 ) .
                display L16002          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L16003 = "����:" + Trim(V1500) .
                display L16003          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L16004 = "������:" + trim(V1400) .
                display L16004          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                L16005 = "�ѱ�����:"  + string ( v1600 ) .
                display L16005          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L16006 = "" . 
                display L16006          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 6 - END */ 
                display "ȷ�ϻ�*�˳� "      format "x(40)" skip
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
        IF V1600 = "*" THEN  LEAVE V1300LMAINLOOP.
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
        if decimal(v1600) = 0 then do:
                display skip "����������Ϊ��" @ WMESSAGE NO-LABEL with fram F1600.
                pause 0 before-hide.
                Undo, retry.
        end.
        Find first LD_DET where ld_part = V1300 AND ld_site = V1002  AND   ld_loc = V1400 and ld_lot = V1500 AND ld_ref = "" and  ld_QTY_oh >= DECIMAL ( V1600 )  no-lock no-error.
        IF NOT AVAILABLE LD_DET then do:
                display skip "�ڿ��� <: " + string( V1600 ) @ WMESSAGE NO-LABEL with fram F1600.
                pause 0 before-hide.
                Undo, retry.
        End.

        Find first lad_det where 
                lad_dataset = "wod_det" 
                and lad_nbr = V1110 
                and lad_site = V1002 
                and lad_loc  = v1400 
                and lad_part = v1300  
                and (lad_lot = v1500 )
                and ( lad_qty_all + lad_qty_pick <> 0 ) 
         no-lock no-error .
         If not avail lad_det then do:
             display "������ϸ������" @ WMESSAGE NO-LABEL with fram F1600.
             undo,retry .
         End.
         Else do:
             if decimal(v1600) > lad_qty_pick  then do:
                 display "����������ϸ����" @ WMESSAGE NO-LABEL with fram F1600.
                 undo,retry .
             End.
         End.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1600.
        pause 0.
        leave V1600L.
     END.
     PV1600 = V1600.
     /* END    LINE :1600  ����[QTY]  */


   /* Additional Labels Format */
     /* START  LINE :1660  �����λ  */
     V1660L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1660           as char format "x(50)".
        define variable PV1660          as char format "x(50)".
        define variable L16601          as char format "x(40)".
        define variable L16602          as char format "x(40)".
        define variable L16603          as char format "x(40)".
        define variable L16604          as char format "x(40)".
        define variable L16605          as char format "x(40)".
        define variable L16606          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        l16606 = "" .
        find last tr_hist where tr_nbr = v1110 and tr_type = "iss-tr" and tr_part = v1300 and tr_site = v1002 and tr_serial = v1500 and tr_loc <> v1400 no-lock no-error .
        if avail tr_hist then do:
            find first ld_det where ld_site = v1002 and ld_part = v1300 and ld_lot = v1500 and ld_loc = tr_loc and ld_stat = "normal"  no-lock no-error .
            if avail ld_det then do:
                v1660 = ld_loc .
                l16606 = "��ǰ���:" + string(ld_qty_oh)  + "/" + v1660.
            end.
        end.
        else do:
            find first ld_det where ld_site = v1002 and ld_part = v1300 and ld_lot = v1500 and ld_qty_oh > 0 and ld_stat = "normal"  no-lock no-error .
            if avail ld_det then do:
                v1660 = ld_loc .
                l16606 = "��ǰ���:" + string(ld_qty_oh)  + "/" + v1660.
            end.
        end.
        V1660 = v1660.
        V1660 = ENTRY(1,V1660,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1660 = ENTRY(1,V1660,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[��������ת��]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1660 no-box.

                /* LABEL 1 - START */ 
                L16601 = "�����λ ? " .
                display L16601          format "x(40)" skip with fram F1660 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L16602 = "��Ʒ:" + trim(V1300) .
                display L16602          format "x(40)" skip with fram F1660 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L16603 = "����:" + trim ( V1500 ) .
                display L16603          format "x(40)" skip with fram F1660 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L16604 = "����:" + trim( V1600 ) .
                display L16604          format "x(40)" skip with fram F1660 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L16605 = "" . 
                display L16605          format "x(40)" skip with fram F1660 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                L16606 = L16606 .
                display L16606          format "x(40)" skip with fram F1660 no-box.
                /* LABEL 6 - END */ 
                display "ȷ�ϻ�*�˳� "      format "x(40)" skip
        skip with fram F1660 no-box.
        Update V1660
        WITH  fram F1660 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        v_recno = ? .
        display skip "^" @ WMESSAGE NO-LABEL with fram F1660.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
               if v_recno = ? then
                  find first loc_mstr where 
                              LOC_SITE = V1002 AND  
                              loc_loc >  INPUT V1660
                   no-lock no-error.
               else
                  find next loc_mstr where 
                              LOC_SITE = V1002
                   no-lock no-error.
                  IF not AVAILABLE loc_mstr then do: 
                      if v_recno <> ? then 
                          find loc_mstr where recid(loc_mstr) = v_recno no-lock no-error .
                      else 
                          find last loc_mstr where 
                              LOC_SITE = V1002
                          no-lock no-error.
                  end. 
                  v_recno = recid(loc_mstr) .
                  IF AVAILABLE loc_mstr then display skip 
                         loc_loc @ V1660 loc_desc @ WMESSAGE NO-LABEL with fram F1660.
                  else   display skip "" @ WMESSAGE with fram F1660.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
               if v_recno = ? then
                  find last loc_mstr where 
                              LOC_SITE = V1002 AND  
                              loc_loc <  INPUT V1660
                  no-lock no-error.
               else 
                  find prev loc_mstr where 
                              LOC_SITE = V1002
                  no-lock no-error.
                  IF not AVAILABLE loc_mstr then do: 
                      if v_recno <> ? then 
                          find loc_mstr where recid(loc_mstr) = v_recno no-lock no-error .
                      else 
                          find first loc_mstr where 
                              LOC_SITE = V1002
                          no-lock no-error.
                  end. 
                  v_recno = recid(loc_mstr) .
                  IF AVAILABLE loc_mstr then display skip 
                         loc_loc @ V1660 loc_desc @ WMESSAGE NO-LABEL with fram F1660.
                  else   display skip "" @ WMESSAGE with fram F1660.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1660 = "*" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1660.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1660.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        if v1660 begins "*" and v1660 <> "*" then do:
            v1660 = substring(v1660,2) .
        End.  
        Find first LOC_MSTR where LOC_LOC = V1660 AND LOC_SITE = V1002  no-lock no-error.
        IF NOT AVAILABLE LOC_MSTR then do:
                display skip "��Ч��λ,����������" @ WMESSAGE NO-LABEL with fram F1660.
                pause 0 before-hide.
                Undo, retry.
        End.

        If v1660 = v1400 then do:
            display skip "ת���λ��������������ͬ" @ WMESSAGE NO-LABEL with fram F1660.
            pause 0 before-hide.
            Undo, retry.
        End.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1660.
        pause 0.
        leave V1660L.
     END.
     PV1660 = V1660.
     /* END    LINE :1660  �����λ  */


   /* Additional Labels Format */
     /* START  LINE :1700  ȷ��[CONFIRM]  */
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
                display "[��������ת��]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1700 no-box.

                /* LABEL 1 - START */ 
                L17001 = "��Ʒ:" + trim(V1300) .
                display L17001          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L17002 = "����:" + trim ( V1500 ) .
                display L17002          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L17003 = "��/��:" + trim ( V1400 ) + "/" + trim(v1660) .
                display L17003          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L17004 = "��������:" + trim( V1600 ) .
                display L17004          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                find first ld_Det where ld_site = v1002 and ld_loc = v1660 and ld_part = v1300 and ld_lot = v1500 and ld_ref = "" no-lock no-error .
                  L17005 = if avail ld_det then "���п��:" + string(ld_qty_oh) else "���п��:0" .
                  L17005 = L17005 + "/" + trim(v1660) .
                  if 1 = 1 then
                L17005 = l17005 .
                else L17005 = "" . 
                display L17005          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L17006 = "" . 
                display L17006          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 6 - END */ 
                display "ȷ�Ϲ���[#],*�˳�"   format "x(40)" skip
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
        IF V1700 = "*" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1700.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1700.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first wo_mstr where wo_lot = V1110 AND INDEX("AR",WO_STATUS) <> 0 and wo_site = V1002  NO-ERROR NO-WAIT.
        IF NOT AVAILABLE wo_mstr then do:
                display skip "��Ч����!" @ WMESSAGE NO-LABEL with fram F1700.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1700.
        pause 0.
        leave V1700L.
     END.
     PV1700 = V1700.
     /* END    LINE :1700  ȷ��[CONFIRM]  */


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

                display "[��������ת��]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9000 no-box.

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
                display "ȷ�ϻ�*�˳� "      format "x(40)" skip
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
        IF V9000 = "*" THEN  LEAVE V1300LMAINLOOP.
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
     {xswoi12u.i}
     /*  Update MFG/PRO END  */ 
        display  "" NO-LABEL with fram F9000X no-box .
        pause 0.
     /* START  LINE :9005  �޸ı�����Allocation  */
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
        {xswoi12s.i}
        if 1 = 1 then
        leave V9005L.
        /* LOGICAL SKIP END */
                display "[��������ת��]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9005 no-box.

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


                /* LABEL 5 - START */ 
                  L90055 = "" . 
                display L90055          format "x(40)" skip with fram F9005 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L90056 = "" . 
                display L90056          format "x(40)" skip with fram F9005 no-box.
                /* LABEL 6 - END */ 
                display "ȷ�ϻ�*�˳� "      format "x(40)" skip
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
        IF V9005 = "*" THEN  LEAVE V1300LMAINLOOP.
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
     /* END    LINE :9005  �޸ı�����Allocation  */


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
        V9010 = "*".
        V9010 = ENTRY(1,V9010,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9010 = ENTRY(1,V9010,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        release wo_mstr.
IF 1 = 2 THEN
        leave V9010L.
        /* LOGICAL SKIP END */
                display "[��������ת��]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9010 no-box.

                /* LABEL 1 - START */ 
                find last tr_hist where 
tr_date = today     and 
tr_trnbr > integer ( V9000 ) and 
tr_type = "RCT-TR"  and 
tr_site = V1002     and tr_nbr  = V1110     and tr_part = V1300     and tr_serial = V1500   and 
tr_time  + 15 >= TIME 
use-index tr_date_trn no-lock no-error.
If AVAILABLE ( tr_hist ) then
                L90101 = "�������ύ" .
                else L90101 = "" . 
                display L90101          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find last tr_hist where 
tr_date = today     and 
tr_trnbr > integer ( V9000 ) and 
tr_type = "RCT-TR"  and  tr_nbr  = V1110     and tr_site = V1002     and tr_part = V1300     and tr_serial = V1500   and 
tr_time  + 15 >= TIME 
use-index tr_date_trn no-lock no-error.
If AVAILABLE ( tr_hist ) then
                L90102 = "���׺� :" + trim(string(tr_trnbr)) .
                else L90102 = "" . 
                display L90102          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find last tr_hist where 
                tr_date = today     and 
                tr_trnbr > integer ( V9000 ) and 
                tr_type = "RCT-TR"  and  tr_nbr  = V1110     and tr_site = V1002     and tr_part = V1300     and tr_serial = V1500   and 
                tr_time  + 15 >= TIME 
                use-index tr_date_trn no-lock no-error.
                If NOT AVAILABLE ( tr_hist ) then  L90103 = "�����ύʧ��" .
                Else do:
                    define var v_qty_tmp like ld_qty_oh .
                    V_qty_tmp = 0 .
                    L90103 = "����ʣ����:" + string(v_qty_tmp) .
                    For each lad_det 
                        where lad_dataset = "wod_det"
                        and lad_nbr  = v1110 
                        and lad_part = v1300
                        and lad_site = v1002
                        and lad_loc  = v1400
                        and lad_lot  = v1500
                        and lad_ref  = "" 
                        and ( lad_qty_all + lad_qty_pick <> 0 )
                    no-lock :
                        v_qty_tmp = v_qty_tmp + lad_qty_pick .
                    End.
                    L90103 = "����ʣ����:" + string(v_qty_tmp) .
                    L90104 = "" . 
                    Find first ld_det where ld_site = v1002 and ld_part = v1300 and ld_lot = v1500 and ld_loc = v1660 and ld_qty_oh > 0 and ld_stat = "normal"  no-lock no-error .
                    If avail ld_det then do:
                        L90104 = "�ֿ�ʣ����:" + string(ld_qty_oh)  + "/" + v1660.
                    end.
                End.  
                If 1 = 1 then
                L90103 = L90103 .
                else L90103 = "" . 
                display L90103          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L90104 = L90104 .
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
                display "ȷ�ϻ�*�˳� "      format "x(40)" skip
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
        IF V9010 = "*" THEN  LEAVE V1300LMAINLOOP.
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
   LEAVE V1300LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :9010    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :9110    */
   V9110LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle9110    */
   IF NOT (V9010 = "#" AND V1700 = "#" ) THEN LEAVE V9110LMAINLOOP.
     /* START  LINE :9110  ����������[QTY ON LABEL]  */
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
                display "[��������ת��]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9110 no-box.

                /* LABEL 1 - START */ 
                find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr ) then
                L91101 = pt_um + " ��ǩ������?" .
                else L91101 = "" . 
                display L91101          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L91102 = "��Ʒ:" + trim( V1300 ) .
                display L91102          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L91103 = "����:" + Trim(V1500) .
                display L91103          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L91104 = "" . 
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
                display "ȷ�ϻ�*�˳� "      format "x(40)" skip
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
                display skip "������������Ϊ��" @ wmessage no-label with fram f9110.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9110.
        pause 0.
        leave V9110L.
     END.
     PV9110 = V9110.
     /* END    LINE :9110  ����������[QTY ON LABEL]  */


   /* Additional Labels Format */
     /* START  LINE :9120  �������[No Of Label]  */
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
                display "[��������ת��]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9120 no-box.

                /* LABEL 1 - START */ 
                L91201 = "��ǩ����?" .
                display L91201          format "x(40)" skip with fram F9120 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L91202 = "��Ʒ:" + trim( V1300 ) .
                display L91202          format "x(40)" skip with fram F9120 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L91203 = "����:" + Trim(V1500) .
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
                display "ȷ�ϻ�*�˳� "      format "x(40)" skip
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
     /* END    LINE :9120  �������[No Of Label]  */


   wtm_num = V9120.
   /* Additional Labels Format */
     /* START  LINE :9130  ��ӡ��[Printer]  */
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
        find first upd_det where upd_nbr = "WOI10" and upd_select = 99 no-lock no-error.
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

                display "[��������ת��]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9130 no-box.

                /* LABEL 1 - START */ 
                L91301 = "��ӡ��?" .
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


                /* LABEL 5 - START */ 
                  L91305 = "" . 
                display L91305          format "x(40)" skip with fram F9130 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L91306 = "" . 
                display L91306          format "x(40)" skip with fram F9130 no-box.
                /* LABEL 6 - END */ 
                display "ȷ�ϻ�*�˳� "      format "x(40)" skip
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
                display skip "��ӡ������ " @ WMESSAGE NO-LABEL with fram F9130.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9130.
        pause 0.
        leave V9130L.
     END.
     PV9130 = V9130.
     /* END    LINE :9130  ��ӡ��[Printer]  */


   /* Additional Labels Format */
     define var vv_part2 as char . /*xp001*/ 
     define var vv_lot2  as char . /*xp001*/ 
     define var vv_qtyp2  as char . /*xp001*/ 
     define var vv_filename2  as char . /*xp001*/   
     define var vv_oneword2  as char . /*xp001*/   
     define var vv_label2  as char . /*xp001*/   
     Define variable ts9130 AS CHARACTER FORMAT "x(100)".
     Define variable av9130 AS CHARACTER FORMAT "x(100)".
     PROCEDURE woi129130l.
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
        vv_label1 = (LabelsPath + "woi12" + trim ( wtm_fm ) ). /*xp001*/
     INPUT FROM VALUE(LabelsPath + "woi12" + trim ( wtm_fm ) ).
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY),'99') + string(DAY(TODAY),'99'))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
     vv_filename1 = trim(wsection) + '.l' . /*xp001*/ 
     output to value( trim(wsection) + ".l") .
     Do While True:
              IMPORT UNFORMATTED ts9130.
        av9130 = V1110.
       if "$O" = '$p' then vv_part1 =  av9130. 
       if "$O" = '$l' then vv_lot1 =  av9130.
       if "$O" = '$q' then vv_qtyp1 =  av9130.
       IF INDEX(ts9130,"$O") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$O") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$O") + length("$O"), LENGTH(ts9130) - ( index(ts9130 ,"$O" ) + length("$O") - 1 ) ).
       END.
        av9130 = string(today).
       if "$D" = '$p' then vv_part1 =  av9130. 
       if "$D" = '$l' then vv_lot1 =  av9130.
       if "$D" = '$q' then vv_qtyp1 =  av9130.
       IF INDEX(ts9130,"$D") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$D") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$D") + length("$D"), LENGTH(ts9130) - ( index(ts9130 ,"$D" ) + length("$D") - 1 ) ).
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
        av9130 = V1500.
       if "$L" = '$p' then vv_part1 =  av9130. 
       if "$L" = '$l' then vv_lot1 =  av9130.
       if "$L" = '$q' then vv_qtyp1 =  av9130.
       IF INDEX(ts9130,"$L") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$L") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$L") + length("$L"), LENGTH(ts9130) - ( index(ts9130 ,"$L" ) + length("$L") - 1 ) ).
       END.
        av9130 = trim(V1300) + "@" + trim(V1500).
       if "&B" = '$p' then vv_part1 =  av9130. 
       if "&B" = '$l' then vv_lot1 =  av9130.
       if "&B" = '$q' then vv_qtyp1 =  av9130.
       IF INDEX(ts9130,"&B") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&B") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"&B") + length("&B"), LENGTH(ts9130) - ( index(ts9130 ,"&B" ) + length("&B") - 1 ) ).
       END.
        av9130 = V9110.
       if "$Q" = '$p' then vv_part1 =  av9130. 
       if "$Q" = '$l' then vv_lot1 =  av9130.
       if "$Q" = '$q' then vv_qtyp1 =  av9130.
       IF INDEX(ts9130,"$Q") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$Q") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$Q") + length("$Q"), LENGTH(ts9130) - ( index(ts9130 ,"$Q" ) + length("$Q") - 1 ) ).
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
        av9130 = V1300.
       if "$P" = '$p' then vv_part1 =  av9130. 
       if "$P" = '$l' then vv_lot1 =  av9130.
       if "$P" = '$q' then vv_qtyp1 =  av9130.
       IF INDEX(ts9130,"$P") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$P") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$P") + length("$P"), LENGTH(ts9130) - ( index(ts9130 ,"$P" ) + length("$P") - 1 ) ).
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
        av9130 = if pt_avg_int <> 0 and pt_avg_int <> 90 then "�O���:" + trim ( string ( pt_avg_int ) ) + "��" else "".
       if "&D" = '$p' then vv_part1 =  av9130. 
       if "&D" = '$l' then vv_lot1 =  av9130.
       if "&D" = '$q' then vv_qtyp1 =  av9130.
       IF INDEX(ts9130,"&D") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&D") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"&D") + length("&D"), LENGTH(ts9130) - ( index(ts9130 ,"&D" ) + length("&D") - 1 ) ).
       END.
       put unformatted ts9130 skip.
       vv_oneword1 = vv_oneword1 + ts9130.  /*xp001*/
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.
     unix silent value ("chmod 777  " + trim(wsection) + ".l").
     END PROCEDURE.
     run woi129130l  (output vv_part2 , output vv_lot2 ,output vv_qtyp2 ,output vv_label2 ,output vv_filename2 ,output vv_oneword2 ) .  /*xp001*/
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
