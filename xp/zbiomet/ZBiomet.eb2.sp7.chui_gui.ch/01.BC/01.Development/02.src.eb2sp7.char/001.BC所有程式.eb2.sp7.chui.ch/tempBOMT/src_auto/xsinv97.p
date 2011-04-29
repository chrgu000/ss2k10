/* TRANSACTION INQUIRY */
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
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xsinv97wtimeout" no-lock no-error. /*  Timeout - Program Level */
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
                display "[BIN CARD查询]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 no-box.

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
   /* Internal Cycle Input :1300    */
   V1300LMAINLOOP:
   REPEAT:
     /* START  LINE :1300  料号[tr_part]  */
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
        V1300 = "  ".
        V1300 = ENTRY(1,V1300,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V1300 = PV1300 .
        V1300 = ENTRY(1,V1300,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[BIN CARD查询]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1300 no-box.

                /* LABEL 1 - START */ 
                L13001 = "料号或 料号+批号 ?" .
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
                  find first pt_mstr where 
                              pt_part >  INPUT V1300
                               use-index pt_part
                   no-lock no-error.
               else
                  find next pt_mstr where 
                               use-index pt_part
                   no-lock no-error.
                  IF not AVAILABLE pt_mstr then do: 
                      if v_recno <> ? then 
                          find pt_mstr where recid(pt_mstr) = v_recno no-lock no-error .
                      else 
                          find last pt_mstr where 
                               use-index pt_part
                          no-lock no-error.
                  end. 
                  v_recno = recid(pt_mstr) .
                  IF AVAILABLE pt_mstr then display skip 
                         pt_part @ V1300 pt_desc1 @ WMESSAGE NO-LABEL with fram F1300.
                  else   display skip "" @ WMESSAGE with fram F1300.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
               if v_recno = ? then
                  find last pt_mstr where 
                              pt_part <  INPUT V1300
                               use-index pt_part
                  no-lock no-error.
               else 
                  find prev pt_mstr where 
                               use-index pt_part
                  no-lock no-error.
                  IF not AVAILABLE pt_mstr then do: 
                      if v_recno <> ? then 
                          find pt_mstr where recid(pt_mstr) = v_recno no-lock no-error .
                      else 
                          find first pt_mstr where 
                               use-index pt_part
                          no-lock no-error.
                  end. 
                  v_recno = recid(pt_mstr) .
                  IF AVAILABLE pt_mstr then display skip 
                         pt_part @ V1300 pt_desc1 @ WMESSAGE NO-LABEL with fram F1300.
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
        Find first pt_mstr where pt_part = ( if INDEX(V1300,"@" ) = 0 then v1300 else ENTRY(1,V1300,"@")) no-lock no-error .
        If not avail pt_mstr then do:
            display "无效料号" @ WMESSAGE NO-LABEL with fram F1300.
            undo,retry .
        End.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
        leave V1300L.
     END.
     IF INDEX(V1300,"@" ) = 0 then V1300 = V1300 + "@".
     PV1300 = V1300.
     V1300 = ENTRY(1,V1300,"@").
     /* END    LINE :1300  料号[tr_part]  */


   /* Additional Labels Format */
     /* START  LINE :1305  批号[tr_serial]  */
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
        V1305 = if ENTRY(2,PV1300,"@") <> "" then  ENTRY(2,PV1300,"@") else "".
        V1305 = ENTRY(1,V1305,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V1305 = PV1305 .
        V1305 = ENTRY(1,V1305,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[BIN CARD查询]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1305 no-box.

                /* LABEL 1 - START */ 
                L13051 = "批号 ?" .
                display L13051          format "x(40)" skip with fram F1305 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L13052 = "料号:" + v1300 .
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


                /* LABEL 5 - START */ 
                  L13055 = "" . 
                display L13055          format "x(40)" skip with fram F1305 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L13056 = "" . 
                display L13056          format "x(40)" skip with fram F1305 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
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
        v_recno = ? .
        display skip "^" @ WMESSAGE NO-LABEL with fram F1305.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
               if v_recno = ? then
                  find first ld_det where 
                              ld_site = v1002 and ld_part = v1300 AND  
                              ld_lot >  INPUT V1305
                   no-lock no-error.
               else
                  find next ld_det where 
                              ld_site = v1002 and ld_part = v1300
                   no-lock no-error.
                  IF not AVAILABLE ld_det then do: 
                      if v_recno <> ? then 
                          find ld_det where recid(ld_det) = v_recno no-lock no-error .
                      else 
                          find last ld_det where 
                              ld_site = v1002 and ld_part = v1300
                          no-lock no-error.
                  end. 
                  v_recno = recid(ld_det) .
                  IF AVAILABLE ld_det then display skip 
                         ld_lot @ V1305 "库位:" + ld_loc + "/数量:" + string(ld_qty_oh) @ WMESSAGE NO-LABEL with fram F1305.
                  else   display skip "" @ WMESSAGE with fram F1305.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
               if v_recno = ? then
                  find last ld_det where 
                              ld_site = v1002 and ld_part = v1300 AND  
                              ld_lot <  INPUT V1305
                  no-lock no-error.
               else 
                  find prev ld_det where 
                              ld_site = v1002 and ld_part = v1300
                  no-lock no-error.
                  IF not AVAILABLE ld_det then do: 
                      if v_recno <> ? then 
                          find ld_det where recid(ld_det) = v_recno no-lock no-error .
                      else 
                          find first ld_det where 
                              ld_site = v1002 and ld_part = v1300
                          no-lock no-error.
                  end. 
                  v_recno = recid(ld_det) .
                  IF AVAILABLE ld_det then display skip 
                         ld_lot @ V1305 "库位:" + ld_loc + "/数量:" + string(ld_qty_oh) @ WMESSAGE NO-LABEL with fram F1305.
                  else   display skip "" @ WMESSAGE with fram F1305.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1305 = "*" THEN  LEAVE V1300LMAINLOOP.
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
     /* END    LINE :1305  批号[tr_serial]  */


   /* Additional Labels Format */
     /* START  LINE :1350  库位[tr_loc]  */
     V1350L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1350           as char format "x(50)".
        define variable PV1350          as char format "x(50)".
        define variable L13501          as char format "x(40)".
        define variable L13502          as char format "x(40)".
        define variable L13503          as char format "x(40)".
        define variable L13504          as char format "x(40)".
        define variable L13505          as char format "x(40)".
        define variable L13506          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first ld_det where ld_site = v1002 and ld_part = v1300 and ld_lot = v1305 and ld_qty_oh > 0 and ld_stat = "normal" no-lock no-error. 
        V1350 = if avail ld_det then ld_loc else "" .
        V1350 = v1350.
        V1350 = ENTRY(1,V1350,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1350 = ENTRY(1,V1350,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[BIN CARD查询]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1350 no-box.

                /* LABEL 1 - START */ 
                L13501 = "库位 ?" .
                display L13501          format "x(40)" skip with fram F1350 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L13502 = "批号:" + v1305 .
                display L13502          format "x(40)" skip with fram F1350 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L13503 = "料号:" + v1300 .
                display L13503          format "x(40)" skip with fram F1350 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13504 = "" . 
                display L13504          format "x(40)" skip with fram F1350 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L13505 = "" . 
                display L13505          format "x(40)" skip with fram F1350 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L13506 = "" . 
                display L13506          format "x(40)" skip with fram F1350 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
        skip with fram F1350 no-box.
        Update V1350
        WITH  fram F1350 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        v_recno = ? .
        display skip "^" @ WMESSAGE NO-LABEL with fram F1350.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
               if v_recno = ? then
                  find first LD_DET where 
                              LD_SITE = V1002 AND LD_PART = V1300 AND
LD_LOT  = V1305 AND
LD_QTY_OH <> 0 AND  
                              LD_LOC >  INPUT V1350
                   no-lock no-error.
               else
                  find next LD_DET where 
                              LD_SITE = V1002 AND LD_PART = V1300 AND
LD_LOT  = V1305 AND
LD_QTY_OH <> 0
                   no-lock no-error.
                  IF not AVAILABLE LD_DET then do: 
                      if v_recno <> ? then 
                          find LD_DET where recid(LD_DET) = v_recno no-lock no-error .
                      else 
                          find last LD_DET where 
                              LD_SITE = V1002 AND LD_PART = V1300 AND
LD_LOT  = V1305 AND
LD_QTY_OH <> 0
                          no-lock no-error.
                  end. 
                  v_recno = recid(LD_DET) .
                  IF AVAILABLE LD_DET then display skip 
                         LD_LOC @ V1350 LD_LOC @ WMESSAGE NO-LABEL with fram F1350.
                  else   display skip "" @ WMESSAGE with fram F1350.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
               if v_recno = ? then
                  find last LD_DET where 
                              LD_SITE = V1002 AND LD_PART = V1300 AND
LD_LOT  = V1305 AND
LD_QTY_OH <> 0 AND  
                              LD_LOC <  INPUT V1350
                  no-lock no-error.
               else 
                  find prev LD_DET where 
                              LD_SITE = V1002 AND LD_PART = V1300 AND
LD_LOT  = V1305 AND
LD_QTY_OH <> 0
                  no-lock no-error.
                  IF not AVAILABLE LD_DET then do: 
                      if v_recno <> ? then 
                          find LD_DET where recid(LD_DET) = v_recno no-lock no-error .
                      else 
                          find first LD_DET where 
                              LD_SITE = V1002 AND LD_PART = V1300 AND
LD_LOT  = V1305 AND
LD_QTY_OH <> 0
                          no-lock no-error.
                  end. 
                  v_recno = recid(LD_DET) .
                  IF AVAILABLE LD_DET then display skip 
                         LD_LOC @ V1350 LD_LOC @ WMESSAGE NO-LABEL with fram F1350.
                  else   display skip "" @ WMESSAGE with fram F1350.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1350 = "*" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1350.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1350.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not V1350 <> "" THEN DO:
                display skip "Error , Retry " @ WMESSAGE NO-LABEL with fram F1350.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1350.
        pause 0.
        leave V1350L.
     END.
     PV1350 = V1350.
     /* END    LINE :1350  库位[tr_loc]  */


   /* Additional Labels Format */
     /* START  LINE :1400  交易明细[Transaction Detail]  */
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
        V1400 = "  ".
        V1400 = ENTRY(1,V1400,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1400 = ENTRY(1,V1400,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        {xsinv097a.i}  if 1 = 1 then
        leave V1400L.
        /* LOGICAL SKIP END */
                display "[BIN CARD查询]"  + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1400 no-box.

                /* LABEL 1 - START */ 
                L14001 = L14001 .
                display L14001          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L14002 = L14002 .
                display L14002          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L14003 = L14003 .
                display L14003          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L14004 = L14004 .
                display L14004          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                L14005 = L14005 .
                display L14005          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                L14006 = L14006 .
                display L14006          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
        skip with fram F1400 no-box.
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
        IF V1400 = "*" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1400.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1400.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        If V1400 = "" OR V1400 = "-" OR V1400 = "." OR V1400 = ".-" OR V1400 = "-." then do:
                display skip "CAN NOT EMPTY  " @ WMESSAGE NO-LABEL with fram F1400.
                pause 0 before-hide.
                undo, retry.
        end.
        DO i = 1 to length(V1400).
                If index("0987654321.-", substring(V1400,i,1)) = 0 then do:
                display skip "Format  Error  " @ WMESSAGE NO-LABEL with fram F1400.
                pause 0 before-hide.
                undo, retry.
                end.
        end.
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1400.
        pause 0.
        leave V1400L.
     END.
     PV1400 = V1400.
     /* END    LINE :1400  交易明细[Transaction Detail]  */


   /* Additional Labels Format */
   /* Internal Cycle END :1400    */
   END.
   pause 0 before-hide.
end.
