define variable sectionid as integer init 0 .
define variable WMESSAGE as char format "x(20)" init "".
define variable wtm_num as char format "x(20)" init "0".
define variable wsection as char format "x(16)".
define variable wloc as CHAR format "x(8)" .
define variable wqty as decimal init 0.
define var v_recno as recid . /*for roll bar*/

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout" no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xsinv02wtimeout" no-lock no-error. /*  Timeout - Program Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).


define variable i as integer .
mainloop:
REPEAT:
     sectionid = sectionid + 1 .
     
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
                display "[库存查询-库位]"    + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 no-box.

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
     
     
     
     V1300L:
     REPEAT:

        hide all no-pause.
        define variable V1300           as char format "x(26)".
        define variable PV1300          as char format "x(26)".

        display "[库存查询-库位]"   format "x(20)" skip with fram F1300 no-box.

        display "料品 或 料品+批号? " format "x(20)" skip with fram F1300 no-box.

        find first pt_mstr where pt_part = ENTRY(1, V1300, "@")  no-lock no-error.
        If AVAILABLE ( pt_mstr )  then
             display pt_desc1      format "x(20)" skip with fram F1300 no-box.
        else display  skip with fram F1300 no-box.

        find first pt_mstr where pt_part = ENTRY(1, V1300, "@")  no-lock no-error.
        If AVAILABLE ( pt_mstr ) then
             display pt_desc2      format "x(20)" skip with fram F1300 no-box.
        else display  skip with fram F1300 no-box.

        find first pt_mstr where pt_part = ENTRY(1, V1300, "@")  no-lock no-error.
        If AVAILABLE ( pt_mstr ) then
             display pt_um         format "x(20)" skip with fram F1300 no-box.
        else display  skip with fram F1300 no-box.

        display "确认或按*退出"  format "x(20)" skip
        skip with fram F1300 no-box.
        Update V1300  WITH  fram F1300 NO-LABEL EDITING:
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
        END.     /* ROLL BAR END */

        IF V1300 = "*" THEN  LEAVE MAINLOOP.

        if v1300 begins "*" and v1300 <> "*" then do:
            v1300 = substring(v1300,2) .
        End.
        if index(v1300,"@") <> 0 then do:
            if entry(2,v1300,"@") = "/" then v1300 = entry(1,v1300,"@") + "@" .
        end.
        find first PT_MSTR where PT_PART = ENTRY(1, V1300, "@")  no-lock no-error.
        IF NOT AVAILABLE PT_MSTR then do:
                display skip "Error,Retry" @ WMESSAGE NO-LABEL with fram F1300.
                undo, retry.
        end.

        leave V1300L.
     END.
     PV1300 = ENTRY(1, V1300, "@").
     V1300 =  ENTRY(1, V1300, "@").


     
     
     
     V1500L:
     REPEAT:

        hide all no-pause.
        define variable V1500           as char format "x(20)".
        define variable PV1500          as char format "x(20)".
        define variable L15001          as char format "x(40)".
        define variable L15002          as char format "x(40)".
        define variable L15003          as char format "x(40)".
        define variable L15004          as char format "x(40)".
        define variable L15005          as char format "x(40)".
        define variable L15006          as char format "x(40)".

        V1500  = "".
        L15001 = "料品:" + V1300 .
        L15002 = "------首批次------" .
        L15003 = "库位:" .
        L15004 = "批号"  .
        L15005 = "数量:" .
        L15006 = "" .

        for each ld_det 
            where ld_site = v1002
            and ld_part = v1300 
            and ld_qty_oh <> 0 
            and ld_stat = "normal"
        no-lock 
        break by ld_part by ld_lot by ld_loc :
            if first-of(ld_part) then do:
                L15003 = "库位:" + ld_loc .
                L15004 = "批号:" + ld_lot .
                L15005 = "数量:" + string(ld_qty_oh) .
            end.
        end.



        display L15001          format "x(40)" skip with fram F1500 no-box.
        display L15002          format "x(40)" skip with fram F1500 no-box.
        display L15003          format "x(40)" skip with fram F1500 no-box.
        display L15004          format "x(40)" skip with fram F1500 no-box.
        display L15005          format "x(40)" skip with fram F1500 no-box.
        display L15006          format "x(40)" skip with fram F1500 no-box.
        display "按确认继续,按*退出"  format "x(20)" skip with fram F1500 no-box.
        Update V1500 WITH  fram F1500 NO-LABEL .
        display skip "^" @ WMESSAGE NO-LABEL with fram F1500.




        IF V1500 = "*" THEN  LEAVE MAINLOOP.

        leave V1500L.
     END.
     PV1500 = V1500.

end. /*mainloop*/
