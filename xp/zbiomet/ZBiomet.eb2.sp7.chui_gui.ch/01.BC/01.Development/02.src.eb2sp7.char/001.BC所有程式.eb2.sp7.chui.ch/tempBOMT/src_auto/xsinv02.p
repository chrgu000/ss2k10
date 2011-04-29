/* INV INQUIRY BY LOT */
/* Generate date / time  2009-3-1 15:49:08 */
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
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xsinv02wtimeout" no-lock no-error. /*  Timeout - Program Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

mainloop:
REPEAT:
batchrun = no . /*cimload,有些会改成yes,这里改回来*/
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
                display "[批号库存查询]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 no-box.

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
     /* END    LINE :1002  地点[SITE]  */


   /* Additional Labels Format */
     /* START  LINE :1300  料品[ITEM]  */
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
         If sectionid > 1 Then 
        V1300 = PV1300 .
        V1300 = ENTRY(1,V1300,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[批号库存查询]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1300 no-box.

                /* LABEL 1 - START */ 
                L13001 = "料品 或 料品+批号?" .
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
                  find first PT_MSTR where 
                              PT_PART >  INPUT V1300
                   no-lock no-error.
               else
                  find next PT_MSTR where 
                   no-lock no-error.
                  IF not AVAILABLE PT_MSTR then do: 
                      if v_recno <> ? then 
                          find PT_MSTR where recid(PT_MSTR) = v_recno no-lock no-error .
                      else 
                          find last PT_MSTR where 
                          no-lock no-error.
                  end. 
                  v_recno = recid(PT_MSTR) .
                  IF AVAILABLE PT_MSTR then display skip 
                         PT_PART @ V1300 PT_DESC1 @ WMESSAGE NO-LABEL with fram F1300.
                  else   display skip "" @ WMESSAGE with fram F1300.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
               if v_recno = ? then
                  find last PT_MSTR where 
                              PT_PART <  INPUT V1300
                  no-lock no-error.
               else 
                  find prev PT_MSTR where 
                  no-lock no-error.
                  IF not AVAILABLE PT_MSTR then do: 
                      if v_recno <> ? then 
                          find PT_MSTR where recid(PT_MSTR) = v_recno no-lock no-error .
                      else 
                          find first PT_MSTR where 
                          no-lock no-error.
                  end. 
                  v_recno = recid(PT_MSTR) .
                  IF AVAILABLE PT_MSTR then display skip 
                         PT_PART @ V1300 PT_DESC1 @ WMESSAGE NO-LABEL with fram F1300.
                  else   display skip "" @ WMESSAGE with fram F1300.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1300 = "*" THEN  LEAVE MAINLOOP.
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
        End.
        find first PT_MSTR where PT_PART = ENTRY(1, V1300, "@")  no-lock no-error.
        IF NOT AVAILABLE PT_MSTR then do:
                display skip "错误,重试!" @ WMESSAGE NO-LABEL with fram F1300.
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
     /* END    LINE :1300  料品[ITEM]  */


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
        if INDEX(PV1300,"@") <> 0 then
        V1500 = ENTRY(2, PV1300, "@").
        V1500 = ENTRY(1,V1500,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1500 = ENTRY(1,V1500,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[批号库存查询]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1500 no-box.

                /* LABEL 1 - START */ 
                L15001 = "批号?" .
                display L15001          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L15002 = "料品:" + trim( V1300 ) .
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
                              LD_PART = V1300 AND LD_QTY_OH <> 0 AND LD_SITE = V1002 AND  
                              LD_LOT >  INPUT V1500
                   no-lock no-error.
               else
                  find next LD_DET where 
                              LD_PART = V1300 AND LD_QTY_OH <> 0 AND LD_SITE = V1002
                   no-lock no-error.
                  IF not AVAILABLE LD_DET then do: 
                      if v_recno <> ? then 
                          find LD_DET where recid(LD_DET) = v_recno no-lock no-error .
                      else 
                          find last LD_DET where 
                              LD_PART = V1300 AND LD_QTY_OH <> 0 AND LD_SITE = V1002
                          no-lock no-error.
                  end. 
                  v_recno = recid(LD_DET) .
                  IF AVAILABLE LD_DET then display skip 
                         LD_LOT @ V1500 LD_LOT + "/" + trim(string(LD_QTY_OH)) + ( if ld_ref = "" then "" else "/" + trim ( ld_ref ) ) @ WMESSAGE NO-LABEL with fram F1500.
                  else   display skip "" @ WMESSAGE with fram F1500.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
               if v_recno = ? then
                  find last LD_DET where 
                              LD_PART = V1300 AND LD_QTY_OH <> 0 AND LD_SITE = V1002 AND  
                              LD_LOT <  INPUT V1500
                  no-lock no-error.
               else 
                  find prev LD_DET where 
                              LD_PART = V1300 AND LD_QTY_OH <> 0 AND LD_SITE = V1002
                  no-lock no-error.
                  IF not AVAILABLE LD_DET then do: 
                      if v_recno <> ? then 
                          find LD_DET where recid(LD_DET) = v_recno no-lock no-error .
                      else 
                          find first LD_DET where 
                              LD_PART = V1300 AND LD_QTY_OH <> 0 AND LD_SITE = V1002
                          no-lock no-error.
                  end. 
                  v_recno = recid(LD_DET) .
                  IF AVAILABLE LD_DET then display skip 
                         LD_LOT @ V1500 LD_LOT + "/" + trim(string(LD_QTY_OH)) + ( if ld_ref = "" then "" else "/" + trim ( ld_ref ) ) @ WMESSAGE NO-LABEL with fram F1500.
                  else   display skip "" @ WMESSAGE with fram F1500.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1500 = "*" THEN  LEAVE MAINLOOP.
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


   /* Additional Labels Format */
     /* START  LINE :1510  明细资料[Detail]  */
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
                display "[批号库存查询]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1510 no-box.

                /* LABEL 1 - START */ 
                L15101 = " ** 库存明细 ** " .
                display L15101          format "x(40)" skip with fram F1510 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L15102 = "料品:" + trim(V1300) .
                display L15102          format "x(40)" skip with fram F1510 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L15103 = "批号:" + trim(V1500) .
                display L15103          format "x(40)" skip with fram F1510 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                find first ld_det where ld_part = V1300 and ld_lot = V1500 and ld_qty_oh <> 0 and ld_site = V1002 no-lock no-error.
If AVAILABLE ( ld_det ) then
                L15104 = "数量:" + trim(LD_LOC) + "/" + trim(string(LD_QTY_OH))  + ( if ld_ref = "" then "" else "/" + trim ( ld_ref ) ) .
                else L15104 = "" . 
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
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        v_recno = ? .
        display skip "^" @ WMESSAGE NO-LABEL with fram F1510.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
               if v_recno = ? then
                  find first LD_DET where 
                              LD_PART = V1300 AND LD_QTY_OH <> 0 AND LD_LOT = V1500 AND LD_SITE = V1002 AND  
                              LD_REF >  INPUT V1510
                   no-lock no-error.
               else
                  find next LD_DET where 
                              LD_PART = V1300 AND LD_QTY_OH <> 0 AND LD_LOT = V1500 AND LD_SITE = V1002
                   no-lock no-error.
                  IF not AVAILABLE LD_DET then do: 
                      if v_recno <> ? then 
                          find LD_DET where recid(LD_DET) = v_recno no-lock no-error .
                      else 
                          find last LD_DET where 
                              LD_PART = V1300 AND LD_QTY_OH <> 0 AND LD_LOT = V1500 AND LD_SITE = V1002
                          no-lock no-error.
                  end. 
                  v_recno = recid(LD_DET) .
                  IF AVAILABLE LD_DET then display skip 
                         LD_REF @ V1510 LD_LOC + "/" + trim(string(LD_QTY_OH))  + ( if ld_ref = "" then "" else "/" + trim ( ld_ref ) ) @ WMESSAGE NO-LABEL with fram F1510.
                  else   display skip "" @ WMESSAGE with fram F1510.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
               if v_recno = ? then
                  find last LD_DET where 
                              LD_PART = V1300 AND LD_QTY_OH <> 0 AND LD_LOT = V1500 AND LD_SITE = V1002 AND  
                              LD_REF <  INPUT V1510
                  no-lock no-error.
               else 
                  find prev LD_DET where 
                              LD_PART = V1300 AND LD_QTY_OH <> 0 AND LD_LOT = V1500 AND LD_SITE = V1002
                  no-lock no-error.
                  IF not AVAILABLE LD_DET then do: 
                      if v_recno <> ? then 
                          find LD_DET where recid(LD_DET) = v_recno no-lock no-error .
                      else 
                          find first LD_DET where 
                              LD_PART = V1300 AND LD_QTY_OH <> 0 AND LD_LOT = V1500 AND LD_SITE = V1002
                          no-lock no-error.
                  end. 
                  v_recno = recid(LD_DET) .
                  IF AVAILABLE LD_DET then display skip 
                         LD_REF @ V1510 LD_LOC + "/" + trim(string(LD_QTY_OH))  + ( if ld_ref = "" then "" else "/" + trim ( ld_ref ) ) @ WMESSAGE NO-LABEL with fram F1510.
                  else   display skip "" @ WMESSAGE with fram F1510.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


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
     /* END    LINE :1510  明细资料[Detail]  */


   /* Additional Labels Format */
end.
