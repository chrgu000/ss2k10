/* SO Allocation */
/* Generate date / time  2009-4-1 15:20:45 */
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
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xssoa20wtimeout" no-lock no-error. /*  Timeout - Program Level */
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
        /*V1002 = "10000" .
        IF 1 = 1 THEN LEAVE V1002L .*/
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
                display "[销售成品备料]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 no-box.

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
     /* START  LINE :1005  计划单号xpk_nbr  */
     V1005L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1005           as char format "x(50)".
        define variable PV1005          as char format "x(50)".
        define variable L10051          as char format "x(40)".
        define variable L10052          as char format "x(40)".
        define variable L10053          as char format "x(40)".
        define variable L10054          as char format "x(40)".
        define variable L10055          as char format "x(40)".
        define variable L10056          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first xpk_mstr where xpk_crt_date = today and xpk_stat = "" no-lock no-error .
        if not avail xpk_mstr then find first xpk_mstr where xpk_crt_date = today and xpk_stat = "A" no-lock no-error .
        if avail xpk_mstr then v1005 = xpk_nbr .
        V1005 = v1005.
        V1005 = ENTRY(1,V1005,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V1005 = PV1005 .
        V1005 = ENTRY(1,V1005,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1005L .
        /* --CYCLE TIME SKIP -- END  */

                display "[销售成品备料]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1005 no-box.

                /* LABEL 1 - START */ 
                L10051 = "出货计划单号？" .
                display L10051          format "x(40)" skip with fram F1005 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L10052 = "" . 
                display L10052          format "x(40)" skip with fram F1005 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L10053 = "" . 
                display L10053          format "x(40)" skip with fram F1005 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L10054 = "" . 
                display L10054          format "x(40)" skip with fram F1005 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L10055 = "" . 
                display L10055          format "x(40)" skip with fram F1005 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L10056 = "" . 
                display L10056          format "x(40)" skip with fram F1005 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
        skip with fram F1005 no-box.
        Update V1005
        WITH  fram F1005 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        v_recno = ? .
        display skip "^" @ WMESSAGE NO-LABEL with fram F1005.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
               if v_recno = ? then
                  find first xpk_mstr where 
                              xpk_site = v1002 and xpk_stat <> "c" AND  
                              xpk_nbr >  INPUT V1005
                               use-index xpk_nbr2
                   no-lock no-error.
               else
                  find next xpk_mstr where 
                              xpk_site = v1002 and xpk_stat <> "c"
                               use-index xpk_nbr2
                   no-lock no-error.
                  IF not AVAILABLE xpk_mstr then do: 
                      if v_recno <> ? then 
                          find xpk_mstr where recid(xpk_mstr) = v_recno no-lock no-error .
                      else 
                          find last xpk_mstr where 
                              xpk_site = v1002 and xpk_stat <> "c"
                               use-index xpk_nbr2
                          no-lock no-error.
                  end. 
                  v_recno = recid(xpk_mstr) .
                  IF AVAILABLE xpk_mstr then display skip 
                         xpk_nbr @ V1005 "交运地" + xpk_shipto @ WMESSAGE NO-LABEL with fram F1005.
                  else   display skip "" @ WMESSAGE with fram F1005.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
               if v_recno = ? then
                  find last xpk_mstr where 
                              xpk_site = v1002 and xpk_stat <> "c" AND  
                              xpk_nbr <  INPUT V1005
                               use-index xpk_nbr2
                  no-lock no-error.
               else 
                  find prev xpk_mstr where 
                              xpk_site = v1002 and xpk_stat <> "c"
                               use-index xpk_nbr2
                  no-lock no-error.
                  IF not AVAILABLE xpk_mstr then do: 
                      if v_recno <> ? then 
                          find xpk_mstr where recid(xpk_mstr) = v_recno no-lock no-error .
                      else 
                          find first xpk_mstr where 
                              xpk_site = v1002 and xpk_stat <> "c"
                               use-index xpk_nbr2
                          no-lock no-error.
                  end. 
                  v_recno = recid(xpk_mstr) .
                  IF AVAILABLE xpk_mstr then display skip 
                         xpk_nbr @ V1005 "交运地" + xpk_shipto @ WMESSAGE NO-LABEL with fram F1005.
                  else   display skip "" @ WMESSAGE with fram F1005.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1005 = "*" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1005.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1005.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first xpk_mstr where xpk_nbr = v1005 no-lock no-error .
        if not avail xpk_mstr then do:
            display  "无效计划单号" @ WMESSAGE NO-LABEL with fram F1005.
            undo,retry .
        end.
        else do:
            find first xpk_mstr where xpk_nbr = v1005 and xpk_stat = "C" no-lock no-error .
            if avail xpk_mstr then do:
                find first xpk_mstr where xpk_nbr = v1005 and xpk_stat <> "C" no-lock no-error .
                if not avail xpk_mstr then do:
                    display  "计划单已结" @ WMESSAGE NO-LABEL with fram F1005.
                    undo,retry .
                end.
            end.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1005.
        pause 0.
        leave V1005L.
     END.
     PV1005 = V1005.
     /* END    LINE :1005  计划单号xpk_nbr  */


   /* Additional Labels Format */
     /* START  LINE :1006  箱号ID  */
     V1006L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1006           as char format "x(50)".
        define variable PV1006          as char format "x(50)".
        define variable L10061          as char format "x(40)".
        define variable L10062          as char format "x(40)".
        define variable L10063          as char format "x(40)".
        define variable L10064          as char format "x(40)".
        define variable L10065          as char format "x(40)".
        define variable L10066          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        v1006  = "" .
        L10064 = "" .
        for each xpkd_det where xpkd_nbr = v1005 
            no-lock break by xpkd_nbr by xpkd_box :
            if last(xpkd_nbr) then do:
                assign v1006 = string(xpkd_box) L10064 = "最后箱号:" + string(xpkd_box) .
            end.
        end.
        V1006 = v1006.
        V1006 = ENTRY(1,V1006,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1006 = ENTRY(1,V1006,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售成品备料]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1006 no-box.

                /* LABEL 1 - START */ 
                L10061 = "箱号 ? " .
                display L10061          format "x(40)" skip with fram F1006 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L10062 = "计划单:" + v1005 .
                display L10062          format "x(40)" skip with fram F1006 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first xpk_mstr where xpk_nbr = v1005 no-lock no-error .
                L10063 = if avail xpk_mstr then xpk_shipto else "" .
                if 1 =1 then
                L10063 = "交运地" + L10063 .
                else L10063 = "" . 
                display L10063          format "x(40)" skip with fram F1006 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L10064 = L10064 .
                display L10064          format "x(40)" skip with fram F1006 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L10065 = "" . 
                display L10065          format "x(40)" skip with fram F1006 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L10066 = "" . 
                display L10066          format "x(40)" skip with fram F1006 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
        skip with fram F1006 no-box.
        Update V1006
        WITH  fram F1006 NO-LABEL
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
        IF V1006 = "*" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1006.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1006.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        If V1006 = "" OR V1006 = "-" OR V1006 = "." OR V1006 = ".-" OR V1006 = "-." then do:
                display skip "CAN NOT EMPTY  " @ WMESSAGE NO-LABEL with fram F1006.
                pause 0 before-hide.
                undo, retry.
        end.
        DO i = 1 to length(V1006).
                If index("0987654321.-", substring(V1006,i,1)) = 0 then do:
                display skip "Format  Error  " @ WMESSAGE NO-LABEL with fram F1006.
                pause 0 before-hide.
                undo, retry.
                end.
        end.
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1006.
        pause 0.
        leave V1006L.
     END.
     PV1006 = V1006.
     /* END    LINE :1006  箱号ID  */


   /* Additional Labels Format */
   /* Internal Cycle Input :1100    */
   V1100LMAINLOOP:
   REPEAT:
     /* START  LINE :1100  销售订单[SalesOrder]  */
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
        V1100 = v1100.
        V1100 = ENTRY(1,V1100,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V1100 = PV1100 .
        V1100 = ENTRY(1,V1100,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售成品备料]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1100 no-box.

                /* LABEL 1 - START */ 
                L11001 = "计划单项?" .
                display L11001          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11002 = "计划单:" + v1005 .
                display L11002          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11003 = "箱号:" + v1006 .
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
        IF V1100 = "*" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1100.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        If V1100 = "" OR V1100 = "-" OR V1100 = "." OR V1100 = ".-" OR V1100 = "-." then do:
                display skip "CAN NOT EMPTY  " @ WMESSAGE NO-LABEL with fram F1100.
                pause 0 before-hide.
                undo, retry.
        end.
        DO i = 1 to length(V1100).
                If index("0987654321.-", substring(V1100,i,1)) = 0 then do:
                display skip "Format  Error  " @ WMESSAGE NO-LABEL with fram F1100.
                pause 0 before-hide.
                undo, retry.
                end.
        end.
        /* CHECK FOR NUMBER VARIABLE  END */
        define var v_nbr like so_nbr .
        Define var v_line like sod_line .
        Define var v_qty_need like sod_qty_ord. 
        V_nbr = "" .
        V_line = 0 .
        V_qty_need = 0 .

        Find first xpk_mstr where xpk_nbr = v1005 and xpk__int01 = inte(v1100)  no-lock no-error.
        If not avail xpk_mstr then do:
            display  "计划单无此订单/项" @ WMESSAGE NO-LABEL with fram F1100.
            undo,retry.
        End.
        else do:
            V_nbr  = xpk_sonbr  .
            V_line = xpk_soline .
        end.

        Find first xpk_mstr where xpk_nbr = v1005 and xpk_sonbr = v_nbr and xpk_soline = v_line and xpk_stat <> "C" no-lock no-error.
        If not avail xpk_mstr then do:
            display  "订单/项的计划已结" @ WMESSAGE NO-LABEL with fram F1100.
            undo,retry.
        End.
        Else do:
            v_qty_need = xpk_qty_all .
        End.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        leave V1100L.
     END.
     PV1100 = V1100.
     /* END    LINE :1100  销售订单[SalesOrder]  */


   /* Additional Labels Format */
   /* Internal Cycle Input :1300    */
   V1300LMAINLOOP:
   REPEAT:
     /* START  LINE :1300  料号[Finished Goods]  */
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
        V1300 = ENTRY(1,V1300,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售成品备料]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1300 no-box.

                /* LABEL 1 - START */ 
                L13001 = "料号+批号 ?" .
                display L13001          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L13002 = "计划单:" + v1005 .
                display L13002          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L13003 = "箱号:" + v1006 .
                display L13003          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L13004 = "订单/项:" + v_nbr + "/" + string(v_line) .
                display L13004          format "x(40)" skip with fram F1300 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                L13005 = "订单需求:" + string(v_qty_need) .
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
        IF V1300 = "*" THEN  LEAVE V1300LMAINLOOP.
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
        Find first sod_det where sod_nbr = v_nbr and sod_line = v_line and sod_part = entry(1, v1300, "@")  no-lock no-error.
        If not available sod_det then do:
                display skip "订单项与料品不匹配!" @ wmessage no-label with fram f1300.
                undo, retry.
        End.
        Else do:
            find first pt_mstr where pt_part = sod_part  no-lock no-error.
            If available ( pt_mstr ) then do:
                if pt_lot_ser = "L" then do:
                    if index(v1300,"@" ) = 0 then do:
                        display skip "条码批号不存在" @ wmessage no-label with fram f1300.
                        undo, retry.
                    End.
                    Else do:
                        find first ld_det where ld_site = v1002 and ld_part = entry(1, v1300, "@") and ld_lot = entry(2, v1300, "@") and ld_stat = "normal" and ld_qty_oh <> 0 no-lock no-error .
                        If not avail ld_det then do:
                            display skip "条码批号不存在." @ wmessage no-label with fram f1300.
                            undo, retry.
                        End.
                    End.
                End.
            End.
        End.
        Find first xpk_mstr where xpk_nbr = v1005 and xpk_sonbr = v_nbr and xpk_soline = v_line and xpk_part = entry(1, v1300, "@") no-lock no-error .
        If not avail xpk_mstr then do:
            display skip "出货计划明细不存在!" @ wmessage no-label with fram f1300.
            undo, retry.
        End.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
        leave V1300L.
     END.
     IF INDEX(V1300,"@" ) = 0 then V1300 = V1300 + "@".
     PV1300 = V1300.
     V1300 = ENTRY(1,V1300,"@").
     /* END    LINE :1300  料号[Finished Goods]  */


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

                display "[销售成品备料]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1410 no-box.

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

                display "[销售成品备料]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1500 no-box.

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
     /* START  LINE :1510  库位  */
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
        L15105 = "" .
        v1510  = "" .
        Find first xpk_mstr 
            where xpk_nbr = v1005 
            and xpk_sonbr = v_nbr 
            and xpk_soline = v_line 
            and xpk_part = v1300
            and xpk_lot  = v1500
        no-lock no-error .
        If avail xpk_mstr then v1510 = xpk_loc .
        Else do:
            L15105 = "*批号无计划*" .
            find first ld_det 
                where ld_site = v1002 
                and   ld_part = v1300
                and   ld_lot  = v1500
                and   ld_ref  = ""
                and   ld_stat = "normal"
                and   ld_qty_oh <> 0
            no-lock no-error .
            if avail ld_det then v1510 = ld_loc .
        end.
        V1510 = v1510.
        V1510 = ENTRY(1,V1510,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1510 = ENTRY(1,V1510,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售成品备料]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1510 no-box.

                /* LABEL 1 - START */ 
                L15101 = "库位?" .
                display L15101          format "x(40)" skip with fram F1510 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L15102 = "料号:" + v1300 .
                display L15102          format "x(40)" skip with fram F1510 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L15103 = "批号:" + v1500 .
                display L15103          format "x(40)" skip with fram F1510 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L15104 = "箱号:" + v1006 .
                display L15104          format "x(40)" skip with fram F1510 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                L15105 = L15105 .
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
        IF V1510 = "*" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1510.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1510.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first ld_Det 
            where ld_site = v1002 
            and ld_loc = (IF INDEX(V1510,"@" ) <> 0 then ENTRY(2,V1510,"@") else v1510 )
            and ld_part = v1300 
            and ld_lot = v1500 
        no-lock no-error.
        if avail ld_det then do:
            if ld_stat <> "normal" then do:
                display  "无效库位状态" + ld_stat @ WMESSAGE NO-LABEL with fram F1510.
                undo,retry.
            End.
        End.
        Else do:
            display  "无效库存记录" @ WMESSAGE NO-LABEL with fram F1510.
            undo,retry.
        End.

        Find first xpk_mstr 
            where xpk_nbr = v1005 
            and xpk_sonbr = v_nbr 
            and xpk_soline = v_line 
            and xpk_part = v1300
            and xpk_lot  = v1500
            and xpk_loc  = v1510
        no-lock no-error .
        If avail xpk_mstr and xpk_stat = "C" then do:
                display  "已结的备料计划,不可再修改" @ WMESSAGE NO-LABEL with fram F1510.
                undo,retry.
        End.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1510.
        pause 0.
        leave V1510L.
     END.
     IF INDEX(V1510,"@" ) <> 0 then V1510 = ENTRY(2,V1510,"@").
     PV1510 = V1510.
     /* END    LINE :1510  库位  */


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
        v1600  = "" .
        L16002 = "" .
        L16003 = "" .
        L16004 = "" .
        L16005 = "本箱数量: 0" .
        find first ld_Det where ld_site = v1002 and ld_part = v1300  and ld_loc = v1510 and ld_lot = v1500 no-lock no-error.
        If avail ld_det then do:
            L16002 = "可用库存:" + string(ld_qty_oh - ld_qty_all) .
        End.
        Else do:
            L16002 = "**可用库存:0" .
        End.        
        
        Find first xpk_mstr 
            where xpk_nbr = v1005 
            and xpk_sonbr = v_nbr 
            and xpk_soline = v_line 
            and xpk_part = v1300
            and xpk_lot  = v1500
            and xpk_loc  = v1510
        no-lock no-error .
        If avail xpk_mstr then do:
            L16003 = "本批需求:" + string(xpk_qty_shp) .
            v1600 = string(xpk_qty_shp) .
            Define var v_qty_tmp like ld_qty_oh .   v_qty_tmp = 0 .   
            For each xpkd_det where xpkd_nbr = v1005 and xpkd_sonbr = v_nbr and xpkd_soline = v_line and xpkd_site = v1002 and xpkd_lot = v1500 and xpkd_loc = v1510  no-lock:
                v_qty_tmp = v_qty_tmp + xpkd_qty_pk .
            End.
            L16004 = "本批已装箱:" + string(v_qty_tmp) .
        End.
        Else do:
            L16003 = "**本批需求:0" .
            L16004 = "**本批已装箱:0" .
        End.
        Find first xpkd_det 
            where xpkd_nbr = v1005
            and xpkd_sonbr = v_nbr 
            and xpkd_soline  = v_line
            and xpkd_part   = v1300
            and xpkd_lot    = v1500
            and xpkd_loc    = v1510
            and xpkd_box    = integer(v1006)
        no-lock no-error .
        If avail xpkd_Det then assign L16005 = "本箱数量:" + string(xpkd_qty_pk) .
        V1600 = v1600.
        V1600 = ENTRY(1,V1600,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1600 = ENTRY(1,V1600,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[销售成品备料]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1600 no-box.

                /* LABEL 1 - START */ 
                L16001 = "备料数量?" .
                display L16001          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L16002 = l16002 .
                display L16002          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L16003 = l16003 .
                display L16003          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L16004 = l16004 .
                display L16004          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                L16005 = L16005 .
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
        find first ld_det 
            where ld_site = v1002
            and ld_part  = v1300 
            and ld_loc = v1510 
            and ld_lot = v1500 
            and  ( decimal( v1600 ) <= 0 or (decimal ( v1600 ) > 0 and (ld_qty_oh - ld_qty_all) >= decimal ( v1600 )))  
        no-lock no-error.
        If not available ld_det then do:
            display skip "可备数 <: " + string( v1600 ) @ wmessage no-label with fram f1600.
            undo, retry.
        End.

        Define var v_qty_lad like ld_qty_oh .
        V_qty_lad = 0 .
        Find first sod_det where sod_nbr = v_nbr and sod_line = v_line no-lock no-error .
        If avail sod_det then do:
            for each lad_det where lad_dataset = "sod_det" and lad_nbr = sod_nbr and lad_line = string(sod_line)  no-lock:
                v_qty_lad = v_qty_lad + (lad_qty_all + lad_qty_pick ) .
            End.
            If decimal ( v1600 ) > 0 and decimal(v1600) > (sod_qty_ord * sod_um_conv  - sod_qty_ship - v_qty_lad ) then do:
                display skip "备料数超过订单可备料数" @ wmessage no-label with fram f1600.
                undo, retry.
            End.
        End.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1600.
        pause 0.
        leave V1600L.
     END.
     PV1600 = V1600.
     /* END    LINE :1600  数量[QTY]  */


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
                display "[销售成品备料]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1700 no-box.

                /* LABEL 1 - START */ 
                L17001 = "料品:" + trim(V1300) .
                display L17001          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L17002 = "批号/库位:" + trim ( V1500 ) + "/" +  trim ( V1510 ) .
                display L17002          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L17003 = "数量/箱号:" + trim(v1600) + "/" + trim(v1006) .
                display L17003          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L17004 = "订单/项:" + v_nbr + "/" + string(v_line) .
                display L17004          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                L17005 = "计划单:" + v1005 .
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
        find first so_mstr where so_nbr = v_nbr  no-error no-wait.
        if not available so_mstr then do:
                display skip "SO被锁!" @ wmessage no-label with fram f1700.
                pause 0 before-hide.
                undo, retry.
        end.
        find first lad_det 
            where lad_det.lad_dataset = 'sod_det' 
            and lad_nbr = v_nbr 
            and lad_line = string(v_line) 
            and lad_part = v1300
            and lad_site = v1002
            and lad_loc  = v1510
            and lad_lot  = v1500
            and lad_ref  = "" 
        no-lock no-error .
        if avail lad_det then do:
            find first lad_det 
                where lad_det.lad_dataset = 'sod_det' 
                and lad_nbr = v_nbr 
                and lad_line = string(v_line) 
                and lad_part = v1300
                and lad_site = v1002
                and lad_loc  = v1510
                and lad_lot  = v1500
                and lad_ref  = "" 
            no-wait no-error .
            if not avail lad_det then do:
                display skip "备料明细被锁!" @ wmessage no-label with fram f1700.
                undo, retry.
            end.
        end .
        find first xpk_mstr 
          where xpk_nbr = v1005 
            and xpk_sonbr = v_nbr 
            and xpk_soline = v_line 
            and xpk_site = v1002 
            and xpk_lot = v1500 
            and xpk_loc = v1510 
        no-lock no-error.
            if avail xpk_mstr then do:
            find first xpk_mstr 
              where xpk_nbr = v1005 
                and xpk_sonbr = v_nbr 
                and xpk_soline = v_line 
                and xpk_site = v1002 
                and xpk_lot = v1500 
                and xpk_loc = v1510 
            no-wait no-error.
            if not avail xpk_mstr then do:
                display skip "计划单被锁!" @ wmessage no-label with fram f1700.
                undo, retry.
            end.
        end.

        find first xpkd_det 
          where xpkd_nbr = v1005 
            and xpkd_sonbr = v_nbr 
            and xpkd_soline = v_line 
            and xpkd_site = v1002 
            and xpkd_lot = v1500 
            and xpkd_loc = v1510 
            and xpkd_box = integer(v1006)
        no-lock no-error.
        if avail xpkd_det then do:
            find first xpkd_det 
              where xpkd_nbr = v1005 
                and xpkd_sonbr = v_nbr 
                and xpkd_soline = v_line 
                and xpkd_site = v1002 
                and xpkd_lot = v1500 
                and xpkd_loc = v1510 
                and xpkd_box = integer(v1006)
            no-wait no-error.
            If not avail xpkd_det then do:
                display skip "装箱明细被锁!" @ wmessage no-label with fram f1700.
                undo, retry.
            End.
        End.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1700.
        pause 0.
        leave V1700L.
     END.
     PV1700 = V1700.
     /* END    LINE :1700  确认[CONFIRM]  */


   /* Additional Labels Format */
     /* START  LINE :9005  执行备料  */
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
        {xsso20s.i}
IF 1 = 1 THEN
        leave V9005L.
        /* LOGICAL SKIP END */
                display "[销售成品备料]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9005 no-box.

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
                display "确认或按*退出 "      format "x(40)" skip
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
     /* END    LINE :9005  执行备料  */


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1300LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :9005    */
   END.
   pause 0 before-hide.
     /* START  LINE :9006  Nothing,JustforLoop  */
     V9006L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9006           as char format "x(50)".
        define variable PV9006          as char format "x(50)".
        define variable L90061          as char format "x(40)".
        define variable L90062          as char format "x(40)".
        define variable L90063          as char format "x(40)".
        define variable L90064          as char format "x(40)".
        define variable L90065          as char format "x(40)".
        define variable L90066          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9006 = ENTRY(1,V9006,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V9006L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V9006L .
        /* --CYCLE TIME SKIP -- END  */

                display "[销售成品备料]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9006 no-box.

                /* LABEL 1 - START */ 
                  L90061 = "" . 
                display L90061          format "x(40)" skip with fram F9006 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L90062 = "" . 
                display L90062          format "x(40)" skip with fram F9006 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L90063 = "" . 
                display L90063          format "x(40)" skip with fram F9006 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L90064 = "" . 
                display L90064          format "x(40)" skip with fram F9006 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L90065 = "" . 
                display L90065          format "x(40)" skip with fram F9006 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L90066 = "" . 
                display L90066          format "x(40)" skip with fram F9006 no-box.
                /* LABEL 6 - END */ 
                display "确认或按*退出 "      format "x(40)" skip
        skip with fram F9006 no-box.
        Update V9006
        WITH  fram F9006 NO-LABEL
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
        IF V9006 = "*" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9006.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9006.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9006.
        pause 0.
        leave V9006L.
     END.
     PV9006 = V9006.
     /* END    LINE :9006  Nothing,JustforLoop  */


   /* Additional Labels Format */
   /* Internal Cycle END :9006    */
   END.
   pause 0 before-hide.
end.
