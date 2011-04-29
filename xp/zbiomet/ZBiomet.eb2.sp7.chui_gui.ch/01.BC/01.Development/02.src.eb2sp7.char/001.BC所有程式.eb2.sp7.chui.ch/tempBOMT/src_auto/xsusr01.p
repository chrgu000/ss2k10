/* USER Label */
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
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xsusr01wtimeout" no-lock no-error. /*  Timeout - Program Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

mainloop:
REPEAT:
batchrun = no . /*cimload,有些会改成yes,这里改回来*/
     /* CYCLE COUNTER -SECTION ID -- START*/
      sectionid = sectionid + 1 .
     /* SECTION ID -- END  */

     /* START  LINE :1300  用户名  */
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
        define var v1002 as char .
V1002 = "" .
V1300 = "" .
        V1300 = v1300.
        V1300 = ENTRY(1,V1300,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V1300 = PV1300 .
        V1300 = ENTRY(1,V1300,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[用户标签列印]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1300 no-box.

                /* LABEL 1 - START */ 
                L13001 = "用户名?" .
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
        IF V1300 = "*" THEN  LEAVE MAINLOOP.
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
     /* END    LINE :1300  用户名  */


   /* Additional Labels Format */
     /* START  LINE :1510  用户名ID&条码  */
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
        V1510 = v1300.
        V1510 = ENTRY(1,V1510,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1510 = ENTRY(1,V1510,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[用户标签列印]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1510 no-box.

                /* LABEL 1 - START */ 
                L15101 = "ID?" .
                display L15101          format "x(40)" skip with fram F1510 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L15102 = "" . 
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


                /* LABEL 5 - START */ 
                  L15105 = "" . 
                display L15105          format "x(40)" skip with fram F1510 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L15106 = "" . 
                display L15106          format "x(40)" skip with fram F1510 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
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
        IF V1510 = "*" THEN  LEAVE MAINLOOP.
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
     /* END    LINE :1510  用户名ID&条码  */


   /* Additional Labels Format */
     /* START  LINE :9010  无用loop  */
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
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V9010L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V9010L .
        /* --CYCLE TIME SKIP -- END  */

                display "[用户标签列印]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9010 no-box.

                /* LABEL 1 - START */ 
                  L90101 = "" . 
                display L90101          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L90102 = "" . 
                display L90102          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L90103 = "" . 
                display L90103          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L90104 = "" . 
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
        IF V9010 = "*" THEN  LEAVE MAINLOOP.
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
     /* END    LINE :9010  无用loop  */


   /* Additional Labels Format */
     /* START  LINE :9020  条码个数[NO OF LABEL]  */
     V9020L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9020           as char format "x(50)".
        define variable PV9020          as char format "x(50)".
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
                display "[用户标签列印]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9020 no-box.

                /* LABEL 1 - START */ 
                L90201 = "条码张数?" .
                display L90201          format "x(40)" skip with fram F9020 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L90202 = "" . 
                display L90202          format "x(40)" skip with fram F9020 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L90203 = "" . 
                display L90203          format "x(40)" skip with fram F9020 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L90204 = "" . 
                display L90204          format "x(40)" skip with fram F9020 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L90205 = "" . 
                display L90205          format "x(40)" skip with fram F9020 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L90206 = "" . 
                display L90206          format "x(40)" skip with fram F9020 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
        skip with fram F9020 no-box.
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
        IF V9020 = "*" THEN  LEAVE MAINLOOP.
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
   /* Additional Labels Format */
     /* START  LINE :9025  标签格式[Label Format]  */
     V9025L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9025           as char format "x(50)".
        define variable PV9025          as char format "x(50)".
        define variable L90251          as char format "x(40)".
        define variable L90252          as char format "x(40)".
        define variable L90253          as char format "x(40)".
        define variable L90254          as char format "x(40)".
        define variable L90255          as char format "x(40)".
        define variable L90256          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V9025 = " ".
        V9025 = ENTRY(1,V9025,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9025 = ENTRY(1,V9025,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V9025L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V9025L .
        /* --CYCLE TIME SKIP -- END  */

                display "[用户标签列印]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9025 no-box.

                /* LABEL 1 - START */ 
                L90251 = "条码格式" .
                display L90251          format "x(40)" skip with fram F9025 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L90252 = "" . 
                display L90252          format "x(40)" skip with fram F9025 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L90253 = "" . 
                display L90253          format "x(40)" skip with fram F9025 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L90254 = "" . 
                display L90254          format "x(40)" skip with fram F9025 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L90255 = "" . 
                display L90255          format "x(40)" skip with fram F9025 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L90256 = "" . 
                display L90256          format "x(40)" skip with fram F9025 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
        skip with fram F9025 no-box.
        Update V9025
        WITH  fram F9025 NO-LABEL
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
        IF V9025 = "*" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9025.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9025.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9025.
        pause 0.
        leave V9025L.
     END.
     PV9025 = V9025.
     /* END    LINE :9025  标签格式[Label Format]  */


   /* Additional Labels Format */
   wtm_fm = V9025.
     /* START  LINE :9030  打印机[PRINTER]  */
     V9030L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9030           as char format "x(50)".
        define variable PV9030          as char format "x(50)".
        define variable L90301          as char format "x(40)".
        define variable L90302          as char format "x(40)".
        define variable L90303          as char format "x(40)".
        define variable L90304          as char format "x(40)".
        define variable L90305          as char format "x(40)".
        define variable L90306          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first upd_det where upd_nbr = "LAP03" and upd_select = 99 no-lock no-error.
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
                display "[用户标签列印]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9030 no-box.

                /* LABEL 1 - START */ 
                L90301 = "打印机?" .
                display L90301          format "x(40)" skip with fram F9030 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L90302 = "" . 
                display L90302          format "x(40)" skip with fram F9030 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L90303 = "" . 
                display L90303          format "x(40)" skip with fram F9030 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L90304 = "" . 
                display L90304          format "x(40)" skip with fram F9030 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L90305 = "" . 
                display L90305          format "x(40)" skip with fram F9030 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L90306 = "" . 
                display L90306          format "x(40)" skip with fram F9030 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
        skip with fram F9030 no-box.
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
        v_recno = ? .
        display skip "^" @ WMESSAGE NO-LABEL with fram F9030.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
               if v_recno = ? then
                  find first PRD_DET where 
                              PRD_DEV >  INPUT V9030
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
                         PRD_DEV @ V9030 PRD_DESC @ WMESSAGE NO-LABEL with fram F9030.
                  else   display skip "" @ WMESSAGE with fram F9030.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
               if v_recno = ? then
                  find last PRD_DET where 
                              PRD_DEV <  INPUT V9030
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
                         PRD_DEV @ V9030 PRD_DESC @ WMESSAGE NO-LABEL with fram F9030.
                  else   display skip "" @ WMESSAGE with fram F9030.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V9030 = "*" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9030.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9030.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first PRD_DET where PRD_DEV = V9030  no-lock no-error.
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


   /* Additional Labels Format */
     define var vv_part2 as char . /*xp001*/ 
     define var vv_lot2  as char . /*xp001*/ 
     define var vv_qtyp2  as char . /*xp001*/ 
     define var vv_filename2  as char . /*xp001*/   
     define var vv_oneword2  as char . /*xp001*/   
     define var vv_label2  as char . /*xp001*/   
     Define variable ts9030 AS CHARACTER FORMAT "x(100)".
     Define variable av9030 AS CHARACTER FORMAT "x(100)".
     PROCEDURE usr019030l.
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
        vv_label1 = (LabelsPath + "usr01" + trim ( wtm_fm ) ). /*xp001*/
     INPUT FROM VALUE(LabelsPath + "usr01" + trim ( wtm_fm ) ).
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY),'99') + string(DAY(TODAY),'99'))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
     vv_filename1 = trim(wsection) + '.l' . /*xp001*/ 
     output to value( trim(wsection) + ".l") .
     Do While True:
              IMPORT UNFORMATTED ts9030.
        av9030 = v1300.
       if "$u" = '$p' then vv_part1 =  av9030. 
       if "$u" = '$l' then vv_lot1 =  av9030.
       if "$u" = '$q' then vv_qtyp1 =  av9030.
       IF INDEX(ts9030,"$u") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$u") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$u") + length("$u"), LENGTH(ts9030) - ( index(ts9030 ,"$u" ) + length("$u") - 1 ) ).
       END.
        av9030 = v1510.
       if "$p" = '$p' then vv_part1 =  av9030. 
       if "$p" = '$l' then vv_lot1 =  av9030.
       if "$p" = '$q' then vv_qtyp1 =  av9030.
       IF INDEX(ts9030,"$p") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$p") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$p") + length("$p"), LENGTH(ts9030) - ( index(ts9030 ,"$p" ) + length("$p") - 1 ) ).
       END.
       put unformatted ts9030 skip.
       vv_oneword1 = vv_oneword1 + ts9030.  /*xp001*/
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.
     unix silent value ("chmod 777  " + trim(wsection) + ".l").
     END PROCEDURE.
     run usr019030l  (output vv_part2 , output vv_lot2 ,output vv_qtyp2 ,output vv_label2 ,output vv_filename2 ,output vv_oneword2 ) .  /*xp001*/
     PROCEDURE  xsprinthist:  /*xp001*/ 
     {xsprinthist.i}  /*xp001*/ 
     END PROCEDURE.  /*xp001*/ 
     run xsprinthist. /*xp001*/ 
     do i = 1 to integer(wtm_num):
       find first PRD_DET where PRD_DEV = V9030 no-lock no-error.
       IF AVAILABLE PRD_DET then do:
         unix silent value (trim(prd_path) + " " + trim(wsection) + ".l").
       end.
     End.
     unix silent value ( 'rm -f '  + trim(wsection) + '.l').
end.
