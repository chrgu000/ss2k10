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
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xsinv98wtimeout" no-lock no-error. /*  Timeout - Program Level */
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
                display "[交易查询byLOT]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 no-box.

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
     /* START  LINE :1100  批号[tr_serial]  */
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
        V1100 = "  ".
        V1100 = ENTRY(1,V1100,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1100 = ENTRY(1,V1100,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[交易查询byLOT]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1100 no-box.

                /* LABEL 1 - START */ 
                L11001 = "批号 或 料号+批号 ?" .
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
        IF V1100 = "*" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1100.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find last tr_hist use-index tr_serial 
            where tr_serial = (if index(v1100,"@") <> 0 then entry(2,v1100,"@") else v1100) 
            and (if  index(v1100,"@") <> 0  then tr_part = entry(1,v1100,"@") else true)
        no-lock no-error .
        if not avail tr_hist then do:
            display "无效批号" @ WMESSAGE NO-LABEL with fram F1100.
            undo,retry .
        end.
        IF INDEX(V1100,"@" ) = 0 then V1100 = "@" + V1100.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        leave V1100L.
     END.
     PV1100 = V1100.
     /* END    LINE :1100  批号[tr_serial]  */


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
        V1100 = ENTRY(2,V1100,"@").
        Find last tr_hist use-index tr_serial where tr_serial =  v1100 and (if entry(1,pv1100,"@") <> "" then  tr_part = entry(1,pv1100,"@") else true) no-lock no-error .
        If avail tr_hist then  V1400 = string ( tr_trnbr ).
        V1400 = v1400.
        V1400 = ENTRY(1,V1400,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1400 = ENTRY(1,V1400,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[交易查询byLOT]"   + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1400 no-box.

                /* LABEL 1 - START */ 
                find last tr_hist use-index tr_serial where tr_serial =  v1100  and (if entry(1,pv1100,"@") <> "" then  tr_part = entry(1,pv1100,"@") else true) no-lock no-error .
                if available ( tr_hist ) then
                L14001 = trim(tr_type) + "/" + string(tr_trnbr) .
                else L14001 = "" . 
                display L14001          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find last tr_hist use-index tr_serial where tr_serial =  v1100  and (if entry(1,pv1100,"@") <> "" then  tr_part = entry(1,pv1100,"@") else true) no-lock no-error .
                if available ( tr_hist ) then
                L14002 = trim(tr_nbr) + "/" + trim(tr_lot) .
                else L14002 = "" . 
                display L14002          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find last tr_hist use-index tr_serial where tr_serial =  v1100  and (if entry(1,pv1100,"@") <> "" then  tr_part = entry(1,pv1100,"@") else true) no-lock no-error .
                if available ( tr_hist ) then
                L14003 = trim(tr_part) + "/" + trim( string( tr_qty_chg )) .
                else L14003 = "" . 
                display L14003          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                find last tr_hist use-index tr_serial where tr_serial =  v1100  and (if entry(1,pv1100,"@") <> "" then  tr_part = entry(1,pv1100,"@") else true) no-lock no-error .
                if available ( tr_hist ) then
                L14004 = "LOC:" + trim(tr_loc) .
                else L14004 = "" . 
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
                  find first tr_hist where 
                              tr_serial = v1100 and (if entry(1,pv1100,"@") <> "" then  tr_part = entry(1,pv1100,"@") else true) AND  
                              tr_trnbr >  INTEGER ( INPUT V1400)
                               use-index tr_serial
                   no-lock no-error.
               else
                  find next tr_hist where 
                              tr_serial = v1100 and (if entry(1,pv1100,"@") <> "" then  tr_part = entry(1,pv1100,"@") else true)
                               use-index tr_serial
                   no-lock no-error.
                  IF not AVAILABLE tr_hist then do: 
                      if v_recno <> ? then 
                          find tr_hist where recid(tr_hist) = v_recno no-lock no-error .
                      else 
                          find last tr_hist where 
                              tr_serial = v1100 and (if entry(1,pv1100,"@") <> "" then  tr_part = entry(1,pv1100,"@") else true)
                               use-index tr_serial
                          no-lock no-error.
                  end. 
                  v_recno = recid(tr_hist) .
                  IF AVAILABLE tr_hist then display skip 
                         string( tr_trnbr )  @ V1400 string( tr_trnbr )  @ V1400 string( tr_trnbr )  @ V1400 trim(tr_type) + "/" + string(tr_trnbr) @ L14001  trim(tr_nbr) + "/" + trim(tr_lot) @ L14002 trim(tr_part) + "/" + trim( string( tr_qty_loc ))  @ L14003  "LOC:" + trim(tr_loc) @ L14004  string (tr_trnbr) @ WMESSAGE NO-LABEL with fram F1400.
                  else   display skip "" @ WMESSAGE with fram F1400.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
               if v_recno = ? then
                  find last tr_hist where 
                              tr_serial = v1100 and (if entry(1,pv1100,"@") <> "" then  tr_part = entry(1,pv1100,"@") else true) AND  
                              tr_trnbr <  INTEGER ( INPUT V1400)
                               use-index tr_serial
                  no-lock no-error.
               else 
                  find prev tr_hist where 
                              tr_serial = v1100 and (if entry(1,pv1100,"@") <> "" then  tr_part = entry(1,pv1100,"@") else true)
                               use-index tr_serial
                  no-lock no-error.
                  IF not AVAILABLE tr_hist then do: 
                      if v_recno <> ? then 
                          find tr_hist where recid(tr_hist) = v_recno no-lock no-error .
                      else 
                          find first tr_hist where 
                              tr_serial = v1100 and (if entry(1,pv1100,"@") <> "" then  tr_part = entry(1,pv1100,"@") else true)
                               use-index tr_serial
                          no-lock no-error.
                  end. 
                  v_recno = recid(tr_hist) .
                  IF AVAILABLE tr_hist then display skip 
                         string( tr_trnbr )  @ V1400 string( tr_trnbr )  @ V1400 string( tr_trnbr )  @ V1400 trim(tr_type) + "/" + string(tr_trnbr) @ L14001  trim(tr_nbr) + "/" + trim(tr_lot) @ L14002 trim(tr_part) + "/" + trim( string( tr_qty_loc ))  @ L14003  "LOC:" + trim(tr_loc) @ L14004  string (tr_trnbr) @ WMESSAGE NO-LABEL with fram F1400.
                  else   display skip "" @ WMESSAGE with fram F1400.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1400 = "*" THEN  LEAVE MAINLOOP.
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
end.
