/* UNPLANNED RECEIPT */
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
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xsinv22wtimeout" no-lock no-error. /*  Timeout - Program Level */
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
                display "[计划外入库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 no-box.

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
     /* START  LINE :1100  通用代码  */
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

                display "[计划外入库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1100 no-box.

                /* LABEL 1 - START */ 
                L11001 = "通用代码?" .
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
                  find first CODE_MSTR where 
                              CODE_FLDNAME = "RCT-UNPCODE" AND  
                              CODE_VALUE >  INPUT V1100
                   no-lock no-error.
               else
                  find next CODE_MSTR where 
                              CODE_FLDNAME = "RCT-UNPCODE"
                   no-lock no-error.
                  IF not AVAILABLE CODE_MSTR then do: 
                      if v_recno <> ? then 
                          find CODE_MSTR where recid(CODE_MSTR) = v_recno no-lock no-error .
                      else 
                          find last CODE_MSTR where 
                              CODE_FLDNAME = "RCT-UNPCODE"
                          no-lock no-error.
                  end. 
                  v_recno = recid(CODE_MSTR) .
                  IF AVAILABLE CODE_MSTR then display skip 
                         CODE_VALUE @ V1100 TRIM(CODE_CMMT) @ WMESSAGE NO-LABEL with fram F1100.
                  else   display skip "" @ WMESSAGE with fram F1100.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
               if v_recno = ? then
                  find last CODE_MSTR where 
                              CODE_FLDNAME = "RCT-UNPCODE" AND  
                              CODE_VALUE <  INPUT V1100
                  no-lock no-error.
               else 
                  find prev CODE_MSTR where 
                              CODE_FLDNAME = "RCT-UNPCODE"
                  no-lock no-error.
                  IF not AVAILABLE CODE_MSTR then do: 
                      if v_recno <> ? then 
                          find CODE_MSTR where recid(CODE_MSTR) = v_recno no-lock no-error .
                      else 
                          find first CODE_MSTR where 
                              CODE_FLDNAME = "RCT-UNPCODE"
                          no-lock no-error.
                  end. 
                  v_recno = recid(CODE_MSTR) .
                  IF AVAILABLE CODE_MSTR then display skip 
                         CODE_VALUE @ V1100 TRIM(CODE_CMMT) @ WMESSAGE NO-LABEL with fram F1100.
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
        find first CODE_MSTR where CODE_FLDNAME = "RCT-UNPCODE" AND CODE_VALUE = V1100  no-lock no-error.
        IF NOT AVAILABLE CODE_MSTR then do:
                display skip "通用代码有误" @ WMESSAGE NO-LABEL with fram F1100.
                pause 0 before-hide.
                undo, retry.
        end.
        IF not length( trim ( V1100 ) ) <= 8 THEN DO:
                display skip "通用代码有误" @ WMESSAGE NO-LABEL with fram F1100.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        leave V1100L.
     END.
     PV1100 = V1100.
     /* END    LINE :1100  通用代码  */


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
                display "[计划外入库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1300 no-box.

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
                         PT_PART @ V1300 trim( PT_Desc1 ) @ WMESSAGE NO-LABEL with fram F1300.
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
                         PT_PART @ V1300 trim( PT_Desc1 ) @ WMESSAGE NO-LABEL with fram F1300.
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
        End.  
        
/* MAKE SURE THAT ITEM STATUS ALLOWS TRANSTYPE */
find first pt_mstr where pt_part = ENTRY(1, V1300, "@") no-lock no-error .
If available pt_mstr then do:
   if can-find(first isd_det  where isd_status = string(pt_status,"x(8)") + "#" and ( isd_tr_type = "RCT-UNP" ))
   then do:
      disp "零件状态限制交易" @  WMESSAGE NO-LABEL with fram F1300.
      undo, retry.
   End.
End. /* available pt_mstr */
        find first PT_MSTR where PT_PART = ENTRY(1, V1300, "@")  no-lock no-error.
        IF NOT AVAILABLE PT_MSTR then do:
                display skip "料品有误!" @ WMESSAGE NO-LABEL with fram F1300.
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
     /* START  LINE :1400  库位[LOC]  */
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
If AVAILABLE ( pt_mstr ) then
        V1400 = pt_loc.
        V1400 = ENTRY(1,V1400,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1400 = ENTRY(1,V1400,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[计划外入库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1400 no-box.

                /* LABEL 1 - START */ 
                L14001 = "库位?" .
                display L14001          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE (pt_mstr) then
                L14002 = pt_loc .
                else L14002 = "" . 
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
        IF V1400 = "*" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1400.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1400.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first LOC_MSTR where LOC_SITE = V1002 AND LOC_LOC = V1400  no-lock no-error.
        IF NOT AVAILABLE LOC_MSTR then do:
                display skip "Error , Retry." @ WMESSAGE NO-LABEL with fram F1400.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1400.
        pause 0.
        leave V1400L.
     END.
     PV1400 = V1400.
     /* END    LINE :1400  库位[LOC]  */


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

                display "[计划外入库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1410 no-box.

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
        V1500 = ( if ENTRY(2, PV1300, "@") = "" then " " else ENTRY(2, PV1300, "@") ).
        V1500 = ENTRY(1,V1500,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1500 = ENTRY(1,V1500,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF V1410 <> "L" then
        leave V1500L.
        /* LOGICAL SKIP END */
                display "[计划外入库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1500 no-box.

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
                              LD_SITE = V1002 AND LD_PART = V1300 AND LD_LOC = V1400 AND LD_QTY_OH <> 0 AND LD_REF = "" AND  
                              LD_LOT >  INPUT V1500
                   no-lock no-error.
               else
                  find next LD_DET where 
                              LD_SITE = V1002 AND LD_PART = V1300 AND LD_LOC = V1400 AND LD_QTY_OH <> 0 AND LD_REF = ""
                   no-lock no-error.
                  IF not AVAILABLE LD_DET then do: 
                      if v_recno <> ? then 
                          find LD_DET where recid(LD_DET) = v_recno no-lock no-error .
                      else 
                          find last LD_DET where 
                              LD_SITE = V1002 AND LD_PART = V1300 AND LD_LOC = V1400 AND LD_QTY_OH <> 0 AND LD_REF = ""
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
                              LD_SITE = V1002 AND LD_PART = V1300 AND LD_LOC = V1400 AND LD_QTY_OH <> 0 AND LD_REF = "" AND  
                              LD_LOT <  INPUT V1500
                  no-lock no-error.
               else 
                  find prev LD_DET where 
                              LD_SITE = V1002 AND LD_PART = V1300 AND LD_LOC = V1400 AND LD_QTY_OH <> 0 AND LD_REF = ""
                  no-lock no-error.
                  IF not AVAILABLE LD_DET then do: 
                      if v_recno <> ? then 
                          find LD_DET where recid(LD_DET) = v_recno no-lock no-error .
                      else 
                          find first LD_DET where 
                              LD_SITE = V1002 AND LD_PART = V1300 AND LD_LOC = V1400 AND LD_QTY_OH <> 0 AND LD_REF = ""
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
        IF not ( IF INDEX(V1500,"@" ) <> 0 then ENTRY(2,V1500,"@") else V1500 ) <> "" THEN DO:
                display skip "L控制,不能为空" @ WMESSAGE NO-LABEL with fram F1500.
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


   /* Additional Labels Format */
     /* START  LINE :1600  数量[QTY]  */
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
        V1600 = "畐计秖".
        V1600 = ENTRY(1,V1600,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1600 = " ".
        V1600 = ENTRY(1,V1600,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[计划外入库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1600 no-box.

                /* LABEL 1 - START */ 
                L16001 = "入库数量?" .
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
                find first ld_det where ld_site = V1002 and ld_part = V1300 and ld_loc = V1400 and ld_lot = V1500 and ld_site = V1002 and ld_qty_oh <> 0 and ld_ref = "" use-index ld_part_lot no-lock no-error.
If AVAILABLE ( ld_det ) then
                L16004 = "库存:" + trim(V1400) + "/" + string ( ld_qty_oh ) .
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
        find first LD_DET where ( decimal(V1600) > 0 ) OR ( decimal(V1600) < 0 AND (ld_part  = V1300 AND ld_loc = V1400 and ld_site = V1002 AND ld_ref = "" AND  ld_lot = V1500 and
ld_site = V1002 and ld_ref = "" and  ld_QTY_oh + DECIMAL ( V1600 ) >= 0 ) )  no-lock no-error.
        IF NOT AVAILABLE LD_DET then do:
                display skip "该操作导致库存< 0" @ WMESSAGE NO-LABEL with fram F1600.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1600.
        pause 0.
        leave V1600L.
     END.
     PV1600 = V1600.
     /* END    LINE :1600  数量[QTY]  */


   /* Additional Labels Format */
     /* START  LINE :1610  工作中心  */
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
        find first code_mstr where code_fldname = "RCT-UNPCODE" and V1100 = code_value no-lock no-error.
If AVAILABLE ( code_mstr ) then
        V1610 = ENTRY(1,code_cmmt,"@").
        V1610 = ENTRY(1,V1610,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1610 = ENTRY(1,V1610,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[计划外入库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1610 no-box.

                /* LABEL 1 - START */ 
                L16101 = "工作中心?" .
                display L16101          format "x(40)" skip with fram F1610 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L16102 = "" . 
                display L16102          format "x(40)" skip with fram F1610 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L16103 = "" . 
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

        /* PRESS e EXIST CYCLE */
        IF V1610 = "*" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1610.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1610.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not length( trim ( V1610 ) ) <= 10 THEN DO:
                display skip "工作中心不能超过10位" @ WMESSAGE NO-LABEL with fram F1610.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1610.
        pause 0.
        leave V1610L.
     END.
     PV1610 = V1610.
     /* END    LINE :1610  工作中心  */


   /* Additional Labels Format */
     /* START  LINE :1620  科目  */
     V1620L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1620           as char format "x(50)".
        define variable PV1620          as char format "x(50)".
        define variable L16201          as char format "x(40)".
        define variable L16202          as char format "x(40)".
        define variable L16203          as char format "x(40)".
        define variable L16204          as char format "x(40)".
        define variable L16205          as char format "x(40)".
        define variable L16206          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first code_mstr where code_fldname = "RCT-UNPCODE" and V1100 = code_value no-lock no-error.
If AVAILABLE ( code_mstr ) then
        V1620 = ENTRY(2,code_cmmt,"@").
        V1620 = ENTRY(1,V1620,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1620 = ENTRY(1,V1620,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[计划外入库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1620 no-box.

                /* LABEL 1 - START */ 
                L16201 = "科目?" .
                display L16201          format "x(40)" skip with fram F1620 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L16202 = "料品:" + trim( V1300 ) .
                display L16202          format "x(40)" skip with fram F1620 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L16203 = "" . 
                display L16203          format "x(40)" skip with fram F1620 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L16204 = "" . 
                display L16204          format "x(40)" skip with fram F1620 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L16205 = "" . 
                display L16205          format "x(40)" skip with fram F1620 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L16206 = "" . 
                display L16206          format "x(40)" skip with fram F1620 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
        skip with fram F1620 no-box.
        Update V1620
        WITH  fram F1620 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        v_recno = ? .
        display skip "^" @ WMESSAGE NO-LABEL with fram F1620.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
               if v_recno = ? then
                  find first AC_MSTR where 
                              AC_ACTIVE = yes AND  
                              AC_CODE >  INPUT V1620
                   no-lock no-error.
               else
                  find next AC_MSTR where 
                              AC_ACTIVE = yes
                   no-lock no-error.
                  IF not AVAILABLE AC_MSTR then do: 
                      if v_recno <> ? then 
                          find AC_MSTR where recid(AC_MSTR) = v_recno no-lock no-error .
                      else 
                          find last AC_MSTR where 
                              AC_ACTIVE = yes
                          no-lock no-error.
                  end. 
                  v_recno = recid(AC_MSTR) .
                  IF AVAILABLE AC_MSTR then display skip 
                         AC_CODE @ V1620 AC_DESC @ WMESSAGE NO-LABEL with fram F1620.
                  else   display skip "" @ WMESSAGE with fram F1620.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
               if v_recno = ? then
                  find last AC_MSTR where 
                              AC_ACTIVE = yes AND  
                              AC_CODE <  INPUT V1620
                  no-lock no-error.
               else 
                  find prev AC_MSTR where 
                              AC_ACTIVE = yes
                  no-lock no-error.
                  IF not AVAILABLE AC_MSTR then do: 
                      if v_recno <> ? then 
                          find AC_MSTR where recid(AC_MSTR) = v_recno no-lock no-error .
                      else 
                          find first AC_MSTR where 
                              AC_ACTIVE = yes
                          no-lock no-error.
                  end. 
                  v_recno = recid(AC_MSTR) .
                  IF AVAILABLE AC_MSTR then display skip 
                         AC_CODE @ V1620 AC_DESC @ WMESSAGE NO-LABEL with fram F1620.
                  else   display skip "" @ WMESSAGE with fram F1620.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1620 = "*" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1620.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1620.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first AC_MSTR where AC_ACTIVE = YES AND AC_CODE = V1620  no-lock no-error.
        IF NOT AVAILABLE AC_MSTR then do:
                display skip "科目有误!!" @ WMESSAGE NO-LABEL with fram F1620.
                pause 0 before-hide.
                undo, retry.
        end.
        IF not length( trim ( V1620 ) ) <= 8 THEN DO:
                display skip "科目有误!!" @ WMESSAGE NO-LABEL with fram F1620.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1620.
        pause 0.
        leave V1620L.
     END.
     PV1620 = V1620.
     /* END    LINE :1620  科目  */


   /* Additional Labels Format */
     /* START  LINE :1630  子科目  */
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
        find first code_mstr where code_fldname = "RCT-UNPCODE" and V1100 = code_value no-lock no-error.
        Find first pt_mstr where pt_part = trim( V1300 ) no-lock no-error .
        If AVAILABLE ( code_mstr ) then V1630 = ENTRY(3,code_cmmt,"@") .
        If ( v1630 = "" and avail pt_mstr) then v1630 = pt_prod_line  .
        V1630 = v1630.
        V1630 = ENTRY(1,V1630,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1630 = ENTRY(1,V1630,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[计划外入库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1630 no-box.

                /* LABEL 1 - START */ 
                L16301 = "子科目?" .
                display L16301          format "x(40)" skip with fram F1630 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L16302 = "料品:" + trim( V1300 ) .
                display L16302          format "x(40)" skip with fram F1630 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first pt_mstr where pt_part = V1300 no-lock no-error.
If AVAILABLE ( pt_mstr ) then
                L16303 = "产品线:" + pt_prod_line .
                else L16303 = "" . 
                display L16303          format "x(40)" skip with fram F1630 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L16304 = "" . 
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
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        v_recno = ? .
        display skip "^" @ WMESSAGE NO-LABEL with fram F1630.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
               if v_recno = ? then
                  find first SB_MSTR where 
                              SB_ACTIVE = yes AND  
                              SB_SUB >  INPUT V1630
                   no-lock no-error.
               else
                  find next SB_MSTR where 
                              SB_ACTIVE = yes
                   no-lock no-error.
                  IF not AVAILABLE SB_MSTR then do: 
                      if v_recno <> ? then 
                          find SB_MSTR where recid(SB_MSTR) = v_recno no-lock no-error .
                      else 
                          find last SB_MSTR where 
                              SB_ACTIVE = yes
                          no-lock no-error.
                  end. 
                  v_recno = recid(SB_MSTR) .
                  IF AVAILABLE SB_MSTR then display skip 
                         SB_SUB @ V1630 SB_DESC @ WMESSAGE NO-LABEL with fram F1630.
                  else   display skip "" @ WMESSAGE with fram F1630.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
               if v_recno = ? then
                  find last SB_MSTR where 
                              SB_ACTIVE = yes AND  
                              SB_SUB <  INPUT V1630
                  no-lock no-error.
               else 
                  find prev SB_MSTR where 
                              SB_ACTIVE = yes
                  no-lock no-error.
                  IF not AVAILABLE SB_MSTR then do: 
                      if v_recno <> ? then 
                          find SB_MSTR where recid(SB_MSTR) = v_recno no-lock no-error .
                      else 
                          find first SB_MSTR where 
                              SB_ACTIVE = yes
                          no-lock no-error.
                  end. 
                  v_recno = recid(SB_MSTR) .
                  IF AVAILABLE SB_MSTR then display skip 
                         SB_SUB @ V1630 SB_DESC @ WMESSAGE NO-LABEL with fram F1630.
                  else   display skip "" @ WMESSAGE with fram F1630.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1630 = "*" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1630.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1630.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first SB_MSTR where SB_ACTIVE = YES AND SB_SUB = V1630  no-lock no-error.
        IF NOT AVAILABLE SB_MSTR then do:
                display skip "子科目有误!" @ WMESSAGE NO-LABEL with fram F1630.
                pause 0 before-hide.
                undo, retry.
        end.
        IF not length( trim ( V1630 ) ) <= 8 THEN DO:
                display skip "子科目有误!" @ WMESSAGE NO-LABEL with fram F1630.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1630.
        pause 0.
        leave V1630L.
     END.
     PV1630 = V1630.
     /* END    LINE :1630  子科目  */


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
        V1700 = "*".
        V1700 = ENTRY(1,V1700,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1700 = ENTRY(1,V1700,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[计划外入库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1700 no-box.

                /* LABEL 1 - START */ 
                L17001 = "通用代码:" + trim(V1100) .
                display L17001          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L17002 = "料品:" + trim(V1300) .
                display L17002          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L17003 = "批号:" + trim ( V1500 ) .
                display L17003          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L17004 = "库位:" + trim ( V1400 ) + "/" + trim( V1600 ) .
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
        IF V1700 = "*" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1700.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1700.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first ld_det where decimal(V1600) > 0 OR ( decimal(V1600) < 0 AND (ld_part  = V1300 AND ld_site = V1002 AND ld_ref = "" AND ld_loc = V1400 and ld_lot = V1500 and ld_site = V1002 AND ld_ref = "" and  ld_QTY_oh + DECIMAL ( V1600 ) >= 0 ) )  NO-ERROR NO-WAIT.
        IF NOT AVAILABLE ld_det then do:
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

                display "[计划外入库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9000 no-box.

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
     {xsinv22u.i}
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
        V9010 = "*".
        V9010 = ENTRY(1,V9010,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9010 = ENTRY(1,V9010,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[计划外入库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9010 no-box.

                /* LABEL 1 - START */ 
                find last tr_hist where 
tr_date = today     and 
tr_trnbr > integer ( V9000 ) and 
tr_type = "RCT-UNP"  and tr_site = V1002     and  tr_part = V1300     and tr_serial = V1500   and 
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
tr_trnbr > integer ( V9000 ) and   tr_site = V1002     and  tr_type = "RCT-UNP"  and  tr_part = V1300     and tr_serial = V1500   and 
tr_time  + 15 >= TIME 
use-index tr_date_trn no-lock no-error.
If AVAILABLE ( tr_hist ) then
                L90102 = "交易号 :" + trim(string(tr_trnbr)) .
                else L90102 = "" . 
                display L90102          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find last tr_hist where 
tr_date = today     and 
tr_trnbr > integer ( V9000 ) and 
tr_type = "RCT-UNP"  and  tr_site = V1002     and  tr_part = V1300     and tr_serial = V1500   and 
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
     /* START  LINE :9110  条码上数量[QTY ON LABEL]  */
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
                display "[计划外入库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9110 no-box.

                /* LABEL 1 - START */ 
                find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr ) then
                L91101 = pt_um + " 标签上数量?" .
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
     /* END    LINE :9110  条码上数量[QTY ON LABEL]  */


   /* Additional Labels Format */
     /* START  LINE :9120  条码个数[No Of Label]  */
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
                display "[计划外入库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9120 no-box.

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
     /* END    LINE :9120  条码个数[No Of Label]  */


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
        find first upd_det where upd_nbr = "INV22" and upd_select = 99 no-lock no-error.
If AVAILABLE ( upd_det ) then
        V9130 = UPD_DEV.
        V9130 = ENTRY(1,V9130,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
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

                display "[计划外入库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9130 no-box.

                /* LABEL 1 - START */ 
                L91301 = "打印机?" .
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
     PROCEDURE inv229130l.
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
        vv_label1 = (LabelsPath + "inv22" + trim ( wtm_fm ) ). /*xp001*/
     INPUT FROM VALUE(LabelsPath + "inv22" + trim ( wtm_fm ) ).
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY),'99') + string(DAY(TODAY),'99'))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
     vv_filename1 = trim(wsection) + '.l' . /*xp001*/ 
     output to value( trim(wsection) + ".l") .
     Do While True:
              IMPORT UNFORMATTED ts9130.
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
        av9130 = trim(pt_desc2).
       if "$E" = '$p' then vv_part1 =  av9130. 
       if "$E" = '$l' then vv_lot1 =  av9130.
       if "$E" = '$q' then vv_qtyp1 =  av9130.
       IF INDEX(ts9130,"$E") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$E") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$E") + length("$E"), LENGTH(ts9130) - ( index(ts9130 ,"$E" ) + length("$E") - 1 ) ).
       END.
        av9130 = V9110.
       if "$Q" = '$p' then vv_part1 =  av9130. 
       if "$Q" = '$l' then vv_lot1 =  av9130.
       if "$Q" = '$q' then vv_qtyp1 =  av9130.
       IF INDEX(ts9130,"$Q") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$Q") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$Q") + length("$Q"), LENGTH(ts9130) - ( index(ts9130 ,"$Q" ) + length("$Q") - 1 ) ).
       END.
        av9130 = trim(V1300) + "@" + trim(V1500).
       if "&B" = '$p' then vv_part1 =  av9130. 
       if "&B" = '$l' then vv_lot1 =  av9130.
       if "&B" = '$q' then vv_qtyp1 =  av9130.
       IF INDEX(ts9130,"&B") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&B") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"&B") + length("&B"), LENGTH(ts9130) - ( index(ts9130 ,"&B" ) + length("&B") - 1 ) ).
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
        av9130 = V1100.
       if "$O" = '$p' then vv_part1 =  av9130. 
       if "$O" = '$l' then vv_lot1 =  av9130.
       if "$O" = '$q' then vv_qtyp1 =  av9130.
       IF INDEX(ts9130,"$O") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$O") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$O") + length("$O"), LENGTH(ts9130) - ( index(ts9130 ,"$O" ) + length("$O") - 1 ) ).
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
        av9130 = if pt_avg_int <> 0 and pt_avg_int <> 90 then "玂借戳:" + trim ( string ( pt_avg_int ) ) + "る" else "".
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
     run inv229130l  (output vv_part2 , output vv_lot2 ,output vv_qtyp2 ,output vv_label2 ,output vv_filename2 ,output vv_oneword2 ) .  /*xp001*/
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
