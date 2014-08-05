/* Generate By Barcode Generator , Copyright by Softspeed - Build By Sam Song  */ 
/* STD LABLE PRINT (RM) */
/* Generate date / time  2011-3-18 11:31:15 */
define variable sectionid as integer init 0 .
define variable WMESSAGE as char format "x(80)" init "".
define variable wtm_num as char format "x(20)" init "0".
define variable wsection as char format "x(200)".
define variable looa as char format "x(200)" init "Y".
define variable i as integer .
define variable t_v1300 as char .
define variable t_v1302 as char .
define variable t_v1310 as char .
define variable t_v1314 as char .
define variable t_v1326 as char .
define variable t_v1400 as char .
DEFINE VARIABLE trnbr AS INTEGER.
DEFINE NEW GLOBAL SHARED VARIABLE mfguser AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE ts_mfguser AS CHARACTER.
define  variable t_v100  as char EXTENT 15 .
define  variable tki  as integer .
define  variable tkj  as integer .
define  variable tkstr  as char .

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout"
 and can-find ( first dom_mstr where  dom_type = "SYSTEM " and dom_domain = code_domain and dom_active = yes ) 
 no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xslap03wtimeout"
 and can-find ( first dom_mstr where  dom_type = "SYSTEM " and dom_domain = code_domain and dom_active = yes ) 
 no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

mainloop:
REPEAT:
     /* CYCLE COUNTER -SECTION ID -- START*/
      sectionid = sectionid + 1 .
     /* SECTION ID -- END  */

     /* START  LINE :1001  域[DOMAIN]  */
     V1001L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1001           as char format "x(150)".
        define variable PV1001          as char format "x(150)".
        define variable L10011          as char format "x(40)".
        define variable L10012          as char format "x(40)".
        define variable L10013          as char format "x(40)".
        define variable L10014          as char format "x(40)".
        define variable L10015          as char format "x(40)".
        define variable L10016          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        {xsdfdomain.i}
        V1001 = wDefDomain.
        V1001 = ENTRY(1,V1001,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1001 = ENTRY(1,V1001,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF dPASS = "Y" then
        leave V1001L.
        /* LOGICAL SKIP END */

                /* LABEL 1 - START */ 
                L10011 = "域设定有误" .
                display L10011          format "x(40)" skip with fram F1001 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L10012 = "1.没有设定默认域" .
                display L10012          format "x(40)" skip with fram F1001 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L10013 = "2.域权限设定有误" .
                display L10013          format "x(40)" skip with fram F1001 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L10014 = "  请查核" .
                display L10014          format "x(40)" skip with fram F1001 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1001 width 150 no-box.
        Update V1001
        WITH  fram F1001 NO-LABEL
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
        IF V1001 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1001.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1001.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not trim(V1001) = "E" THEN DO:
                display skip "Error , Retry " @ WMESSAGE NO-LABEL with fram F1001.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1001.
        pause 0.
        leave V1001L.
     END.
     PV1001 = V1001.
     /* END    LINE :1001  域[DOMAIN]  */


     /* START  LINE :1002  地点[SITE]  */
     V1002L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1002           as char format "x(150)".
        define variable PV1002          as char format "x(150)".
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
                display "[标准标签列印]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 width 150 no-box.

                /* LABEL 1 - START */ 
                L10021 = "地点设定有误" .
                display L10021          format "x(40)" skip with fram F1002 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L10022 = "1.没有设定默认地点" .
                display L10022          format "x(40)" skip with fram F1002 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L10023 = "2.权限设定有误" .
                display L10023          format "x(40)" skip with fram F1002 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L10024 = "  请查核" .
                display L10024          format "x(40)" skip with fram F1002 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1002 width 150 no-box.
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
     /* END    LINE :1002  地点[SITE]  */


     /* START  LINE :1300  图号[ITEM]  */
     V1300L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1300           as char format "x(150)".
        define variable PV1300          as char format "x(150)".
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
                display "[标准标签列印]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1300 width 150 no-box.

                /* LABEL 1 - START */ 
                L13001 = "图号 或 图号+批号?" .
                display L13001          format "x(40)" skip with fram F1300 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L13002 = "" . 
                display L13002          format "x(40)" skip with fram F1300 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L13003 = "" . 
                display L13003          format "x(40)" skip with fram F1300 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13004 = "" . 
                display L13004          format "x(40)" skip with fram F1300 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1300 width 150 no-box.
        recid(PT_MSTR) = ?.
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
        display skip "^" @ WMESSAGE NO-LABEL with fram F1300.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(PT_MSTR) = ? THEN find first PT_MSTR where 
                              PT_DOMAIN = V1001 AND  
                              PT_PART >=  INPUT V1300
                               no-lock no-error.
                  else do: 
                       if PT_PART =  INPUT V1300
                       then find next PT_MSTR
                       WHERE PT_DOMAIN = V1001
                        no-lock no-error.
                        else find first PT_MSTR where 
                              PT_DOMAIN = V1001 AND  
                              PT_PART >=  INPUT V1300
                               no-lock no-error.
                  end.
                  IF AVAILABLE PT_MSTR then display skip 
            PT_PART @ V1300 PT_DESC1 @ WMESSAGE NO-LABEL with fram F1300.
                  else   display skip "" @ WMESSAGE with fram F1300.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(PT_MSTR) = ? THEN find last PT_MSTR where 
                              PT_DOMAIN = V1001 AND  
                              PT_PART <=  INPUT V1300
                               no-lock no-error.
                  else do: 
                       if PT_PART =  INPUT V1300
                       then find prev PT_MSTR
                       where PT_DOMAIN = V1001
                        no-lock no-error.
                        else find first PT_MSTR where 
                              PT_DOMAIN = V1001 AND  
                              PT_PART >=  INPUT V1300
                               no-lock no-error.
                  end.
                  IF AVAILABLE PT_MSTR then display skip 
            PT_PART @ V1300 PT_DESC1 @ WMESSAGE NO-LABEL with fram F1300.
                  else   display skip "" @ WMESSAGE with fram F1300.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1300 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1300.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first PT_MSTR where PT_DOMAIN = V1001 AND PT_PART = ENTRY(1, V1300, "@")  no-lock no-error.
        IF NOT AVAILABLE PT_MSTR then do:
                display skip "Error,Retry" @ WMESSAGE NO-LABEL with fram F1300.
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
     /* END    LINE :1300  图号[ITEM]  */


     /* START  LINE :1500  批号[LOT]  */
     V1500L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1500           as char format "x(150)".
        define variable PV1500          as char format "x(150)".
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
        find first pt_mstr where pt_domain = V1001 and pt_part = V1300 and pt_lot_ser = "" no-lock no-error.
If available pt_mstr then
        leave V1500L.
        /* LOGICAL SKIP END */
                display "[标准标签列印]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1500 width 150 no-box.

                /* LABEL 1 - START */ 
                L15001 = "批号?" .
                display L15001          format "x(40)" skip with fram F1500 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L15002 = "图号:" + trim( V1300 ) .
                display L15002          format "x(40)" skip with fram F1500 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L15003 = "" . 
                display L15003          format "x(40)" skip with fram F1500 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L15004 = "" . 
                display L15004          format "x(40)" skip with fram F1500 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1500 width 150 no-box.
        recid(LD_DET) = ?.
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
                              LD_DOMAIN = V1001 AND LD_PART = V1300 AND LD_SITE = V1002 AND  
                              LD_LOT >=  INPUT V1500
                               no-lock no-error.
                  else do: 
                       if LD_LOT =  INPUT V1500
                       then find next LD_DET
                       WHERE LD_DOMAIN = V1001 AND LD_PART = V1300 AND LD_SITE = V1002
                        no-lock no-error.
                        else find first LD_DET where 
                              LD_DOMAIN = V1001 AND LD_PART = V1300 AND LD_SITE = V1002 AND  
                              LD_LOT >=  INPUT V1500
                               no-lock no-error.
                  end.
                  IF AVAILABLE LD_DET then display skip 
            LD_LOT @ V1500 LD_LOT + "/" + trim(string(LD_QTY_OH)) @ WMESSAGE NO-LABEL with fram F1500.
                  else   display skip "" @ WMESSAGE with fram F1500.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(LD_DET) = ? THEN find last LD_DET where 
                              LD_DOMAIN = V1001 AND LD_PART = V1300 AND LD_SITE = V1002 AND  
                              LD_LOT <=  INPUT V1500
                               no-lock no-error.
                  else do: 
                       if LD_LOT =  INPUT V1500
                       then find prev LD_DET
                       where LD_DOMAIN = V1001 AND LD_PART = V1300 AND LD_SITE = V1002
                        no-lock no-error.
                        else find first LD_DET where 
                              LD_DOMAIN = V1001 AND LD_PART = V1300 AND LD_SITE = V1002 AND  
                              LD_LOT >=  INPUT V1500
                               no-lock no-error.
                  end.
                  IF AVAILABLE LD_DET then display skip 
            LD_LOT @ V1500 LD_LOT + "/" + trim(string(LD_QTY_OH)) @ WMESSAGE NO-LABEL with fram F1500.
                  else   display skip "" @ WMESSAGE with fram F1500.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1500 = "e" THEN  LEAVE MAINLOOP.
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


     /* START  LINE :1510  单据号码[REC]  */
     V1510L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1510           as char format "x(150)".
        define variable PV1510          as char format "x(150)".
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
                display "[标准标签列印]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1510 width 150 no-box.

                /* LABEL 1 - START */ 
                L15101 = "单据号码?" .
                display L15101          format "x(40)" skip with fram F1510 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L15102 = "" . 
                display L15102          format "x(40)" skip with fram F1510 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L15103 = "" . 
                display L15103          format "x(40)" skip with fram F1510 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L15104 = "" . 
                display L15104          format "x(40)" skip with fram F1510 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1510 width 150 no-box.
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
     /* END    LINE :1510  单据号码[REC]  */


     /* START  LINE :1520  受检章  */
     V1520L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1520           as char format "x(150)".
        define variable PV1520          as char format "x(150)".
        define variable L15201          as char format "x(40)".
        define variable L15202          as char format "x(40)".
        define variable L15203          as char format "x(40)".
        define variable L15204          as char format "x(40)".
        define variable L15205          as char format "x(40)".
        define variable L15206          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1520 = "Y".
        V1520 = ENTRY(1,V1520,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V1520 = PV1520 .
        V1520 = ENTRY(1,V1520,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[标准标签列印]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1520 width 150 no-box.

                /* LABEL 1 - START */ 
                L15201 = "受检章-Y" .
                display L15201          format "x(40)" skip with fram F1520 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L15202 = "检验OK - N" .
                display L15202          format "x(40)" skip with fram F1520 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L15203 = "" . 
                display L15203          format "x(40)" skip with fram F1520 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L15204 = "" . 
                display L15204          format "x(40)" skip with fram F1520 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1520 width 150 no-box.
        Update V1520
        WITH  fram F1520 NO-LABEL
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
        IF V1520 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1520.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1520.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1520.
        pause 0.
        leave V1520L.
     END.
     PV1520 = V1520.
     /* END    LINE :1520  受检章  */


   /* Internal Cycle Input :9010    */
   V9010LMAINLOOP:
   REPEAT:
     /* START  LINE :9010  条码上的数量[QTY ON LABEL]  */
     V9010L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9010           as char format "x(150)".
        define variable PV9010          as char format "x(150)".
        define variable L90101          as char format "x(40)".
        define variable L90102          as char format "x(40)".
        define variable L90103          as char format "x(40)".
        define variable L90104          as char format "x(40)".
        define variable L90105          as char format "x(40)".
        define variable L90106          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V9010 = "0".
        V9010 = ENTRY(1,V9010,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9010 = ENTRY(1,V9010,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[标准标签列印]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9010 width 150 no-box.

                /* LABEL 1 - START */ 
                L90101 = "条码上数量" .
                display L90101          format "x(40)" skip with fram F9010 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L90102 = "图号:" + trim( V1300 ) .
                display L90102          format "x(40)" skip with fram F9010 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L90103 = "批号:" + Trim(V1500) .
                display L90103          format "x(40)" skip with fram F9010 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L90104 = "" . 
                display L90104          format "x(40)" skip with fram F9010 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9010 width 150 no-box.
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
        IF V9010 = "e" THEN  LEAVE V9010LMAINLOOP.
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
     /* END    LINE :9010  条码上的数量[QTY ON LABEL]  */


     /* START  LINE :9020  条码个数[NO OF LABEL]  */
     V9020L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9020           as char format "x(150)".
        define variable PV9020          as char format "x(150)".
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
                display "[标准标签列印]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9020 width 150 no-box.

                /* LABEL 1 - START */ 
                L90201 = "条码张数?" .
                display L90201          format "x(40)" skip with fram F9020 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L90202 = "图号:" + trim( V1300 ) .
                display L90202          format "x(40)" skip with fram F9020 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L90203 = "批号:" + Trim(V1500) .
                display L90203          format "x(40)" skip with fram F9020 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L90204 = "" . 
                display L90204          format "x(40)" skip with fram F9020 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9020 width 150 no-box.
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
        IF V9020 = "e" THEN  LEAVE V9010LMAINLOOP.
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
     /* START  LINE :9030  打印机[PRINTER]  */
     V9030L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9030           as char format "x(150)".
        define variable PV9030          as char format "x(150)".
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

        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V9030L .
        /* --CYCLE TIME SKIP -- END  */

                display "[标准标签列印]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9030 width 150 no-box.

                /* LABEL 1 - START */ 
                L90301 = "打印机?" .
                display L90301          format "x(40)" skip with fram F9030 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L90302 = "" . 
                display L90302          format "x(40)" skip with fram F9030 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L90303 = "" . 
                display L90303          format "x(40)" skip with fram F9030 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L90304 = "" . 
                display L90304          format "x(40)" skip with fram F9030 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9030 width 150 no-box.
        recid(PRD_DET) = ?.
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
        display skip "^" @ WMESSAGE NO-LABEL with fram F9030.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(PRD_DET) = ? THEN find first PRD_DET where 
                              PRD_DEV >=  INPUT V9030
                               no-lock no-error.
                  else do: 
                       if PRD_DEV =  INPUT V9030
                       then find next PRD_DET
                        no-lock no-error.
                        else find first PRD_DET where 
                              PRD_DEV >=  INPUT V9030
                               no-lock no-error.
                  end.
                  IF AVAILABLE PRD_DET then display skip 
            PRD_DEV @ V9030 PRD_DESC @ WMESSAGE NO-LABEL with fram F9030.
                  else   display skip "" @ WMESSAGE with fram F9030.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(PRD_DET) = ? THEN find last PRD_DET where 
                              PRD_DEV <=  INPUT V9030
                               no-lock no-error.
                  else do: 
                       if PRD_DEV =  INPUT V9030
                       then find prev PRD_DET
                        no-lock no-error.
                        else find first PRD_DET where 
                              PRD_DEV >=  INPUT V9030
                               no-lock no-error.
                  end.
                  IF AVAILABLE PRD_DET then display skip 
            PRD_DEV @ V9030 PRD_DESC @ WMESSAGE NO-LABEL with fram F9030.
                  else   display skip "" @ WMESSAGE with fram F9030.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V9030 = "e" THEN  LEAVE V9010LMAINLOOP.
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


     Define variable ts9030 AS CHARACTER FORMAT "x(100)".
     Define variable av9030 AS CHARACTER FORMAT "x(100)".
     PROCEDURE lap039030l.
        /* Define Labels Path  Start */
        Define variable LabelsPath as character format "x(100)" init "/app/bc/labels/".
        Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath"no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath = trim ( code_cmmt ).
        If substring(LabelsPath, length(LabelsPath), 1) <> "/" Then 
        LabelsPath = LabelsPath + "/".
        /* Define Labels Path  END */
     INPUT FROM VALUE(LabelsPath + "lap03").
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
     output to value( trim(wsection) + ".l") .
     Do While True:
              IMPORT UNFORMATTED ts9030.
        av9030 = V1300.
       IF INDEX(ts9030,"$P") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$P") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$P") + length("$P"), LENGTH(ts9030) - ( index(ts9030 ,"$P" ) + length("$P") - 1 ) ).
       END.
        av9030 = V1510.
       IF INDEX(ts9030,"$O") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$O") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$O") + length("$O"), LENGTH(ts9030) - ( index(ts9030 ,"$O" ) + length("$O") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9030 = trim(pt_desc1).
       IF INDEX(ts9030,"$F") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$F") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$F") + length("$F"), LENGTH(ts9030) - ( index(ts9030 ,"$F" ) + length("$F") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9030 = pt_um.
       IF INDEX(ts9030,"$U") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$U") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$U") + length("$U"), LENGTH(ts9030) - ( index(ts9030 ,"$U" ) + length("$U") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9030 = trim(pt_desc2).
       IF INDEX(ts9030,"$E") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$E") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$E") + length("$E"), LENGTH(ts9030) - ( index(ts9030 ,"$E" ) + length("$E") - 1 ) ).
       END.
        av9030 = string(today).
       IF INDEX(ts9030,"$D") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$D") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$D") + length("$D"), LENGTH(ts9030) - ( index(ts9030 ,"$D" ) + length("$D") - 1 ) ).
       END.
        av9030 = V9010.
       IF INDEX(ts9030,"$Q") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$Q") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$Q") + length("$Q"), LENGTH(ts9030) - ( index(ts9030 ,"$Q" ) + length("$Q") - 1 ) ).
       END.
        av9030 = " ".
       IF INDEX(ts9030,"$G") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$G") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$G") + length("$G"), LENGTH(ts9030) - ( index(ts9030 ,"$G" ) + length("$G") - 1 ) ).
       END.
        av9030 = trim(V1300) + "@" + trim(V1500).
       IF INDEX(ts9030,"&B") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "&B") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"&B") + length("&B"), LENGTH(ts9030) - ( index(ts9030 ,"&B" ) + length("&B") - 1 ) ).
       END.
        av9030 = V1500.
       IF INDEX(ts9030,"$L") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "$L") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"$L") + length("$L"), LENGTH(ts9030) - ( index(ts9030 ,"$L" ) + length("$L") - 1 ) ).
       END.
        av9030 = if trim ( V1520 ) = "Y" then "受检章" else "检验OK".
       IF INDEX(ts9030,"&R") <> 0  THEN DO:
       TS9030 = substring(TS9030, 1, Index(TS9030 , "&R") - 1) + av9030 
       + SUBSTRING( ts9030 , index(ts9030 ,"&R") + length("&R"), LENGTH(ts9030) - ( index(ts9030 ,"&R" ) + length("&R") - 1 ) ).
       END.
       put unformatted ts9030 skip.
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.
     unix silent value ("chmod 777  " + trim(wsection) + ".l").
     END PROCEDURE.
     run lap039030l.
     do i = 1 to integer(wtm_num):
       find first PRD_DET where PRD_DEV = V9030 no-lock no-error.
       IF AVAILABLE PRD_DET then do:
         unix silent value (trim(prd_path) + " " + trim(wsection) + ".l").
         unix silent value ( "clear").
       end.
     End.
   /* Internal Cycle END :9030    */
   END.
   pause 0 before-hide.
end.
