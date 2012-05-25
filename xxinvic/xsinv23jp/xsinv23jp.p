/* xsinv23jp.p 日供件打印条码,并修改收货库位                                  */
/*----rev history-------------------------------------------------------------*/
/* ss - 110321.1  by: roger xiao                                              */
/* 由当前版本的xsinv23.p改为日供件独立转仓程式xsinv23jp.p ,其他逻辑完全相同,  */
/*-revision end---------------------------------------------------------------*/
/* Barcode 67                                                                 */

define variable sectionid as integer init 0 .
define variable WMESSAGE as char format "x(80)" init "".
define variable wtm_num as char format "x(20)" init "0".
define variable wsection as char format "x(16)".
define variable i as integer .
/*SS - 080912.1 B*/
DEFINE VARIABLE vv_loc_oh AS DECIMAL.
/*SS - 080912.1 E*/

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout" no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xsinv23wtimeout" no-lock no-error. /*  Timeout - Program Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

mainloop:
REPEAT:
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
                display "[日供件-库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 no-box.

                /* LABEL 1 - START */
                L10021 = "地点设定有误" .
                display L10021          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L10022 = "1.没有设定默认地点" .
                display L10022          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L10023 = "2.权限设定有误" .
                display L10023          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                L10024 = "  请查核" .
                display L10024          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
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
     /* END    LINE :1002  地点[SITE]  */


     /* START  LINE :1100  单号[ORDER]  */
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

                display "[日供件-库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1100 no-box.

                /* LABEL 1 - START */
                L11001 = "日供发票号?" .
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
                display "输入或按E退出"       format "x(40)" skip
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
        IF V1100 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1100.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not length( trim ( V1100 ) ) <= 18 THEN DO:
                display skip "长度不能超过18位" @ WMESSAGE NO-LABEL with fram F1100.
                pause 0 before-hide.
                undo, retry.
        end.

        find first xxinv_mstr
            where xxinv_nbr = V1100
        no-lock no-error.
        if not avail xxinv_mstr then do:
                display skip "无效日供发票号" @ WMESSAGE NO-LABEL with fram F1100.
                pause 0 before-hide.
                undo, retry.
        end.  /* SS - 110321.1 */

         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        leave V1100L.
     END.
     PV1100 = V1100.
     /* END    LINE :1100  单号[ORDER]  */


   /* Internal Cycle Input :1300    */
   V1300LMAINLOOP:
   REPEAT:
     /* START  LINE :1300  图号[Raw Material]  */
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
                display "[日供件-库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1300 no-box.

                /* LABEL 1 - START */
                L13001 = "图号 或 图号+批号?" .
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
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1300 no-box.
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
                              PT_PART >=  INPUT V1300
                               no-lock no-error.
                  else do:
                       if PT_PART =  INPUT V1300
                       then find next PT_MSTR
                        no-lock no-error.
                        else find first PT_MSTR where
                              PT_PART >=  INPUT V1300
                               no-lock no-error.
                  end.
                  IF AVAILABLE PT_MSTR then display skip
            PT_PART @ V1300 trim( PT_Desc1 ) @ WMESSAGE NO-LABEL with fram F1300.
                  else   display skip "" @ WMESSAGE with fram F1300.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(PT_MSTR) = ? THEN find last PT_MSTR where
                              PT_PART <=  INPUT V1300
                               no-lock no-error.
                  else do:
                       if PT_PART =  INPUT V1300
                       then find prev PT_MSTR
                        no-lock no-error.
                        else find first PT_MSTR where
                              PT_PART >=  INPUT V1300
                               no-lock no-error.
                  end.
                  IF AVAILABLE PT_MSTR then display skip
            PT_PART @ V1300 trim( PT_Desc1 ) @ WMESSAGE NO-LABEL with fram F1300.
                  else   display skip "" @ WMESSAGE with fram F1300.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        /* **SKIP TO MAIN LOOP START** */
        IF V1300 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        display  skip WMESSAGE NO-LABEL with fram F1300.

         /*  ---- Valid Check ---- START */
/*  Sam Song 20100319 Start */
        IF substring ( V1300 ,1,1) = "P" then V1300 = substring ( V1300 , 2 ,17).
        Find first pt_mstr where pt_part = V1300 no-lock  no-error.
        If NOT AVAILABLE pt_mstr then do:
           find first pt_mstr where pt_draw =  V1300 and pt_draw <> "" no-lock  no-error.
           If AVAILABLE pt_mstr then V1300 = pt_part.
	End.
        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.

/*  Sam Song 20100319 End */

        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first PT_MSTR where PT_PART = ENTRY(1, V1300, "@")  no-lock no-error.
        IF NOT AVAILABLE PT_MSTR then do:
                display skip "图号有误!" @ WMESSAGE NO-LABEL with fram F1300.
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
     /* END    LINE :1300  图号[Raw Material]  */


     /* START  LINE :1305  备注  */
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
        V1305 = " ".
        V1305 = ENTRY(1,V1305,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then
        V1305 = PV1305 .
        V1305 = ENTRY(1,V1305,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[日供件-库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1305 no-box.

                /* LABEL 1 - START */
                L13051 = "备注?" .
                display L13051          format "x(40)" skip with fram F1305 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L13052 = "10 个位" .
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
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1305 no-box.
        Update V1305
        WITH  fram F1305 NO-LABEL
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
        IF V1305 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1305.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1305.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not length( trim ( V1305 ) ) <= 10 THEN DO:
                display skip "长度不能超过10位" @ WMESSAGE NO-LABEL with fram F1305.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1305.
        pause 0.
        leave V1305L.
     END.
     PV1305 = V1305.
     /* END    LINE :1305  备注  */


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

                display "[日供件-库存转移]" + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1410 no-box.

                /* LABEL 1 - START */
                  L14101 = "" .
                display L14101 format "x(40)" skip with fram F1410 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L14102 = "" .
                display L14102 format "x(40)" skip with fram F1410 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L14103 = "" .
                display L14103 format "x(40)" skip with fram F1410 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L14104 = "" .
                display L14104 format "x(40)" skip with fram F1410 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
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
        IF V1410 = "e" THEN  LEAVE V1300LMAINLOOP.
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
                display "[日供件-库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1500 no-box.

                /* LABEL 1 - START */
                L15001 = "批号+拖号?" .
                display L15001          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                find first ld_det where ld_part = V1300  and ld_site = V1002  and ld_ref  = ""     and ld_qty_oh <> 0   and ( substring( ld_loc ,1,1 ) = "X" or substring (ld_loc ,1,1 ) = "Y" ) use-index ld_part_lot no-lock no-error.
If AVAILABLE ( ld_det ) then
                L15002 = "最小:" + trim(ld_lot) .
                else L15002 = "" .
                display L15002          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                find first ld_det where ld_part = V1300 and
ld_site = V1002 and
ld_ref  = ""     and ld_qty_oh <> 0 and ( substring( ld_loc ,1,1 ) = "X" or substring (ld_loc ,1,1 ) = "Y" ) use-index ld_part_lot no-lock no-error.
If AVAILABLE ( ld_det ) then
               /*SS - 080912.1 B*/
                DO:

                L15003 = "库存:" + trim(ld_loc) + "/" +  trim(string(ld_qty_oh)) .

               END.
               /*SS - 080912.1 E*/

                else  DO:
                    L15003 = "" .
                END.
                display L15003          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                L15004 = "图号:" + trim( V1300 ) .
                display L15004          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1500 no-box.
        recid(LD_DET) = ?.
        Update V1500
        WITH  fram F1500 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.


        IF INPUT V1500 = "e" THEN  LEAVE V1300LMAINLOOP.

        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1500.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(LD_DET) = ? THEN find first LD_DET where
                              LD_PART = V1300 AND LD_QTY_OH <> 0  AND index ( "N", substring (ld_loc ,1,1 ) ) = 0  AND
LD_SITE = V1002 AND LD_REF = "" AND
                              LD_LOT >=  INPUT V1500
                               no-lock no-error.
                  else do:
                       if LD_LOT =  INPUT V1500
                       then find next LD_DET
                       WHERE LD_PART = V1300 AND LD_QTY_OH <> 0  AND index ( "N", substring (ld_loc ,1,1 ) ) = 0  AND
LD_SITE = V1002 AND LD_REF = ""
                        no-lock no-error.
                        else find first LD_DET where
                              LD_PART = V1300 AND LD_QTY_OH <> 0  AND index ( "N", substring (ld_loc ,1,1 ) ) = 0  AND
LD_SITE = V1002 AND LD_REF = "" AND
                              LD_LOT >=  INPUT V1500
                               no-lock no-error.
                  end.
                  IF AVAILABLE LD_DET then display skip
            LD_LOT @ V1500 LD_LOC + "/" + trim(string(LD_QTY_OH)) @ WMESSAGE NO-LABEL with fram F1500.
                  else   display skip "" @ WMESSAGE with fram F1500.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(LD_DET) = ? THEN find last LD_DET where
                              LD_PART = V1300 AND LD_QTY_OH <> 0  AND index ( "N", substring (ld_loc ,1,1 ) ) = 0  AND
LD_SITE = V1002 AND LD_REF = "" AND
                              LD_LOT <=  INPUT V1500
                               no-lock no-error.
                  else do:
                       if LD_LOT =  INPUT V1500
                       then find prev LD_DET
                       where LD_PART = V1300 AND LD_QTY_OH <> 0  AND index ( "N", substring (ld_loc ,1,1 ) ) = 0  AND
LD_SITE = V1002 AND LD_REF = ""
                        no-lock no-error.
                        else find first LD_DET where
                              LD_PART = V1300 AND LD_QTY_OH <> 0  AND index ( "N", substring (ld_loc ,1,1 ) ) = 0  AND
LD_SITE = V1002 AND LD_REF = "" AND
                              LD_LOT >=  INPUT V1500
                               no-lock no-error.
                  end.
                  IF AVAILABLE LD_DET then
                  DO:

                      display skip
            LD_LOT @ V1500 LD_LOC + "/" + trim(string(LD_QTY_OH)) @ WMESSAGE NO-LABEL with fram F1500.


                 END.
                  else   display skip "" @ WMESSAGE with fram F1500.
            END.

            APPLY LASTKEY.


        END.
        /* ROLL BAR END */

        find first ld_det
            use-index ld_part_loc
            where ld_part = v1300
            and ld_site = v1002
            and index ( "n", substring (ld_loc ,1,1 ) ) = 0
            and ld_lot =  input v1500
            and ld_ref = ""
            and ld_qty_oh <> 0
        no-lock no-error. /* SS - 110321.1 */
        if avail ld_det then  /* SS - 110321.1 */

        vv_loc_oh = ld_qty_oh.


        define variable v_case_nbr      as char format "x(10)".
        define variable v_recid         as recid .
        define variable v_qty_rct       like xxship_rcvd_qty .
        define variable v_loc_to        as char format "x(8)" .
        define variable v_loc_from      as char format "x(8)" .


        v_case_nbr = "" .
        v_recid    = ? .
        v_qty_rct  = 0 .
        v_loc_to   = "" .
  /*      v_loc_from =  if v1300 begins "P" then "PT" else "TEMP" .                               */

  /*  v_case_nbr = trim(substring(v1500,11)).                                                     */
  /*                                                                                              */
  /*  if v_case_nbr = "" then do:                                                                 */
  /*          display skip "托号有误,请重新输入" @ wmessage no-label with fram f1500.             */
  /*          pause 0 before-hide.                                                                */
  /*          undo, retry.                                                                        */
  /*  end.                                                                                        */
  /*  else do:                                                                                    */
  /*      do i = 1 to length(v_case_nbr).                                                         */
  /*          if index("0987654321", substring(v_case_nbr,i,1)) = 0 then do:                      */
  /*              display skip "托号有误,请重新输入." @ wmessage no-label with fram f1500.        */
  /*              pause 0 before-hide.                                                            */
  /*              undo, retry.                                                                    */
  /*          end.                                                                                */
  /*      end.                                                                                    */
  /*  end.                                                                                        */

        find first xxship_det
            use-index xxship_case
            where xxship_nbr    = v1100
            and   xxship_case  = integer(v_case_nbr)
            and   xxship_part2  = v1300
            and   xxship_status = "RCT-PO"
        no-lock no-error.
        if not avail xxship_det then do:
                display skip "该图号/批号/发票,无待转仓的项次" @ wmessage no-label with fram f1500.
                pause 0 before-hide.
                undo, retry.
        end.
        else do:
            v_recid     = recid(xxship_det) .
            v_loc_to    = xxship_rcvd_loc   .
            v_qty_rct   = xxship_rcvd_qty   .
            v_loc_from  = xxship_rcvd_loc   .
        end.

        /* PRESS e EXIST CYCLE */
        IF INPUT V1500 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1500.

         /*  ---- Valid Check ---- START */
         /* Sam Song 20100319 Start */
	 if substring ( V1500 ,1,1 ) = "S" then V1500 = substring (V1500,2,18).
        /*  Sam Song 20100319 End */

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


     /* START  LINE :1510  从库位[From LOC]  */
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
        V1510 = v_loc_from .     /* SS - 110321.1 */
        V1510 = ENTRY(1,V1510,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then
        V1510 = PV1510 .
        V1510 = ENTRY(1,V1510,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[日供件-库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1510 no-box.

                /* LABEL 1 - START */
                L15101 = "从库位?" .
                display L15101          format "x(40)" skip with fram F1510 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L15102 = v_loc_from .
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
                display "输入或按E退出"       format "x(40)" skip
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
        IF V1510 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1510.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1510.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first LOC_MSTR where LOC_LOC = V1510 AND LOC_SITE = V1002  no-lock no-error.
        IF NOT AVAILABLE LOC_MSTR then do:
                display skip "Error , Retry." @ WMESSAGE NO-LABEL with fram F1510.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1510.
        pause 0.
        leave V1510L.
     END.
     IF INDEX(V1510,"@" ) <> 0 then V1510 = ENTRY(2,V1510,"@").
     PV1510 = V1510.
     /* END    LINE :1510  从库位[From LOC]  */


     /* START  LINE :1520  到库位[To   LOC]  */
     V1520L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1520           as char format "x(50)".
        define variable PV1520          as char format "x(50)".
        define variable L15201          as char format "x(40)".
        define variable L15202          as char format "x(40)".
        define variable L15203          as char format "x(40)".
        define variable L15204          as char format "x(40)".
        define variable L15205          as char format "x(40)".
        define variable L15206          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1520 = "" .     /* SS - 110321.1 */
        V1520 = ENTRY(1,V1520,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1520 = ENTRY(1,V1520,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[日供件-库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1520 no-box.

                /* LABEL 1 - START */
                L15201 = "到库位?" .
                display L15201          format "x(40)" skip with fram F1520 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L15202 = "" .
                display L15202          format "x(40)" skip with fram F1520 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L15203 = "自动收货库位:" + v_loc_to .
                display L15203          format "x(40)" skip with fram F1520 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L15204 = "" .
                display L15204          format "x(40)" skip with fram F1520 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1520 no-box.
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
        IF V1520 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1520.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1520.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first LOC_MSTR where LOC_LOC = V1520 AND V1520 <> V1510 AND LOC_SITE = V1002  no-lock no-error.
        IF NOT AVAILABLE LOC_MSTR then do:
                display skip "Error , Retry." @ WMESSAGE NO-LABEL with fram F1520.
                pause 0 before-hide.
                undo, retry.
        end.


        if v1520 <> v_loc_to then do:
                display skip "仅限转仓到自动收货库位" @ WMESSAGE NO-LABEL with fram F1520.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1520.
        pause 0.
        leave V1520L.
     END.
     PV1520 = V1520.
     /* END    LINE :1520  到库位[To   LOC]  */


     /* START  LINE :1525  提示该架位已有库存  */
     V1525L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1525           as char format "x(50)".
        define variable PV1525          as char format "x(50)".
        define variable L15251          as char format "x(40)".
        define variable L15252          as char format "x(40)".
        define variable L15253          as char format "x(40)".
        define variable L15254          as char format "x(40)".
        define variable L15255          as char format "x(40)".
        define variable L15256          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1525 = "Y".
        V1525 = ENTRY(1,V1525,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1525 = ENTRY(1,V1525,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        find first ld_det where ld_site = V1002 and ld_loc = V1520 and ld_qty_oh <> 0
and substring ( ld_loc ,1,1) = "X"  no-lock no-error.
If NOT AVAILABLE ld_det THEN
        leave V1525L.
        /* LOGICAL SKIP END */
                display "[日供件-库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1525 no-box.

                /* LABEL 1 - START */
                L15251 = "警告:架位有以下货物" .
                display L15251          format "x(40)" skip with fram F1525 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L15252 = "图号:" + trim ( ld_part ) .
                display L15252          format "x(40)" skip with fram F1525 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L15253 = "数量:" + string ( ld_qty_oh ) .
                display L15253          format "x(40)" skip with fram F1525 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                L15254 = "Y继续,E退出" .
                display L15254          format "x(40)" skip with fram F1525 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1525 no-box.
        Update V1525
        WITH  fram F1525 NO-LABEL
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
        IF V1525 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1525.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1525.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1525.
        pause 0.
        leave V1525L.
     END.
     PV1525 = V1525.
     /* END    LINE :1525  提示该架位已有库存  */


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
        V1600 = string(v_qty_rct).    /* SS - 110321.1 */
        V1600 = ENTRY(1,V1600,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[日供件-库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1600 no-box.

                /* LABEL 1 - START */
                L16001 = "转移数量?" .
                display L16001          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L16002 = "图号:" + trim( V1300 ) .
                display L16002          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L16003 = "批号:" + Trim(V1500) .
                display L16003          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                L16004 = "从:" + trim( V1510 ) + "到:" + trim( V1520 ) .
                display L16004          format "x(40)" skip with fram F1600 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
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
        IF V1600 = "e" THEN  LEAVE V1300LMAINLOOP.
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
        /****
        find first LD_DET where ( ld_part  = V1300 AND ld_lot = V1500 AND ld_site = V1002 AND ld_ref = "") AND ( ( decimal(V1600) < 0  AND ( ld_loc = V1520 AND  LD_SITE = V1002 and ld_ref = "" and ld_QTY_oh >= - DECIMAL ( V1600 ) ) ) OR ( decimal(V1600) > 0 AND  ld_loc = V1510 AND  LD_SITE = V1002 and ld_ref = "" and  ld_QTY_oh >= DECIMAL ( V1600 ) ) )  no-lock no-error.
        IF NOT AVAILABLE LD_DET then do:
                display skip "在库数 <:" + string( V1600 ) @ WMESSAGE NO-LABEL with fram F1600.
                pause 0 before-hide.
                undo, retry.
        end.
				*/
				
        if V1600 <> string(v_qty_rct) then do:
                display skip "请按条码数量转仓:" + string(v_qty_rct) @ WMESSAGE NO-LABEL with fram F1600.
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
        V1700 = "Y".
        V1700 = ENTRY(1,V1700,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1700 = ENTRY(1,V1700,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[日供件-库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1700 no-box.

                /* LABEL 1 - START */
                L17001 = "图号:" + trim(V1300) .
                display L17001          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L17002 = "批号:" + trim ( V1500 ) .
                display L17002          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L17003 = "数量:" + trim(V1600) .
                display L17003          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                L17004 = "从:" + trim( V1510 ) + "到:" + trim( V1520 ) .
                display L17004          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 4 - END */
                display "确认过帐[Y],E退出"   format "x(40)" skip
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
        IF V1700 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1700.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1700.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first ld_det where ld_part  = V1300 AND
ld_site = V1002 AND
ld_ref  = ""    and ld_lot = V1500   AND
( ( decimal(V1600) > 0 AND ld_loc   = V1510 ) OR ( decimal(V1600) < 0 AND ld_loc   = V1520 ))  NO-ERROR NO-WAIT.
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

                display "[日供件-库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9000 no-box.

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
                display "输入或按E退出"       format "x(40)" skip
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
        IF V9000 = "e" THEN  LEAVE V1300LMAINLOOP.
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


        display "...PROCESSING...  " NO-LABEL with fram F9000X no-box.
        pause 0.
     /*  Update MFG/PRO START  */
     {xsinv23u.i}
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
        V9010 = "E".
        V9010 = ENTRY(1,V9010,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9010 = ENTRY(1,V9010,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[日供件-库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9010 no-box.

                /* LABEL 1 - START */
                find last tr_hist where
tr_date = today     and
tr_trnbr > integer ( V9000 ) and
tr_nbr  = V1100     and  tr_type = "RCT-TR"  and
tr_site = V1002     and  tr_part = V1300     and tr_serial = V1500   and
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
tr_trnbr > integer ( V9000 ) and
tr_nbr  = V1100     and  tr_type = "RCT-TR"  and
tr_site = V1002     and
tr_part = V1300     and tr_serial = V1500   and
tr_time  + 15 >= TIME
use-index tr_date_trn no-lock no-error.
If AVAILABLE ( tr_hist ) then
do:     /* SS - 110321.1 */
    L90102 = "交易号 :" + trim(string(tr_trnbr)) .
    find first xxship_det
        where recid(xxship_det)  = v_recid
    no-error.
    if avail xxship_det then do:
        xxship_status = "RCT-TR".
    end.
end.
                else L90102 = "" .
                display L90102          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                find last tr_hist where
tr_date = today     and
tr_trnbr > integer ( V9000 ) and
tr_nbr  = V1100     and  tr_type = "RCT-TR"  and
tr_site = V1002     and
tr_part = V1300     and tr_serial = V1500   and
tr_time  + 15 >= TIME
use-index tr_date_trn no-lock no-error.
If NOT AVAILABLE ( tr_hist ) then
                L90103 = "交易提交失败" .
                else L90103 = "" .
                display L90103          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                L90104 = "按Y打印条码,E退出" .
                display L90104          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
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
        IF V9010 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9010.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9010.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not trim(V9010) = "Y" THEN DO:
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


   /* Without Condition Exit Cycle Start */
   LEAVE V1300LMAINLOOP.
   /* Without Condition Exit Cycle END */
   /* Internal Cycle END :9010    */
   END.
   pause 0 before-hide.
     /* START  LINE :9015  OUTPUT TO PRINTER QTY  */
     V9015L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9015           as char format "x(50)".
        define variable PV9015          as char format "x(50)".
        define variable L90151          as char format "x(40)".
        define variable L90152          as char format "x(40)".
        define variable L90153          as char format "x(40)".
        define variable L90154          as char format "x(40)".
        define variable L90155          as char format "x(40)".
        define variable L90156          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9015 = ENTRY(1,V9015,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF 1 = 1 THEN
        leave V9015L.
        /* LOGICAL SKIP END */
                display "[日供件-库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9015 no-box.

                /* LABEL 1 - START */
                  L90151 = "" .
                display L90151          format "x(40)" skip with fram F9015 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                  L90152 = "" .
                display L90152          format "x(40)" skip with fram F9015 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                  L90153 = "" .
                display L90153          format "x(40)" skip with fram F9015 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L90154 = "" .
                display L90154          format "x(40)" skip with fram F9015 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9015 no-box.
        Update V9015
        WITH  fram F9015 NO-LABEL
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
        IF V9015 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9015.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9015.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9015.
        pause 0.
        leave V9015L.
     END.
     PV9015 = V9015.
     /* END    LINE :9015  OUTPUT TO PRINTER QTY  */


   /* Internal Cycle Input :9110    */
   V9110LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle9110    */
   IF NOT (V9010 = "Y" AND V1700 = "Y" ) OR v1100 = "e" OR v1300 = "e" OR v1305 = "e" OR v1500 = "e" OR v1520 = "e" OR v1600 = "e" THEN LEAVE V9110LMAINLOOP.
     /* START  LINE :9110  条码上数量[QTY ON LABEL] AUTO  */
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
        find first pt_mstr where pt_part = V1300 no-lock no-error.
If AVAILABLE ( pt_mstr ) then
        V9110 = string ( pt_ord_qty).
        V9110 = ENTRY(1,V9110,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9110 = ENTRY(1,V9110,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[日供件-库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9110 no-box.

                /* LABEL 1 - START */
                L91101 = "发料倍数?" .
                display L91101          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L91102 = "MFG图号:" + trim ( V1300 ) .
                display L91102          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L91103 = "批号:" + trim ( V1500 ) .
                display L91103          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L91104 = "" .
                display L91104          format "x(40)" skip with fram F9110 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
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
        IF V9110 = "e" THEN  LEAVE V9110LMAINLOOP.
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
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9110.
        pause 0.
        leave V9110L.
     END.
     PV9110 = V9110.
     /* END    LINE :9110  条码上数量[QTY ON LABEL] AUTO  */


     /* START  LINE :9120  条码个数[No Of Label] AUTO  */
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
        V9120 = string ( integer ( decimal(V1600)  / decimal ( V9110 ) - 0.5 ) ).



        V9120 = ENTRY(1,V9120,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9120 = ENTRY(1,V9120,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V9015 = V9110.
if V9120 = ? THEN
        leave V9120L.
        /* LOGICAL SKIP END */
                display "[日供件-库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9120 no-box.

                /* LABEL 1 - START */
                L91201 = "标签个数?" .
                display L91201          format "x(40)" skip with fram F9120 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L91202 = "图号:" + trim( V1300 ) .
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
                display "输入或按E退出"       format "x(40)" skip
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
        IF V9120 = "e" THEN  LEAVE V9110LMAINLOOP.
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
     /* END    LINE :9120  条码个数[No Of Label] AUTO  */


   wtm_num = V9120.
     /* START  LINE :9130  打印机[Printer] AUTO  */
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
        find first upd_det where upd_nbr = "inv23" and upd_select = 99 no-lock no-error.
If AVAILABLE ( upd_det ) then
        V9130 = UPD_DEV.
        V9130 = ENTRY(1,V9130,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9130 = ENTRY(1,V9130,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF V9120 = ?  THEN
        leave V9130L.
        /* LOGICAL SKIP END */
                display "[日供件-库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9130 no-box.

                /* LABEL 1 - START */
                L91301 = "打印机?" .
                display L91301          format "x(40)" skip with fram F9130 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L91302 = "条码上数量:" + trim ( V9110 ) .
                display L91302          format "x(40)" skip with fram F9130 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L91303 = "条码个数:" + trim ( V9120) .
                display L91303          format "x(40)" skip with fram F9130 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L91304 = "" .
                display L91304          format "x(40)" skip with fram F9130 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9130 no-box.
        recid(PRD_DET) = ?.
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
        display skip "^" @ WMESSAGE NO-LABEL with fram F9130.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(PRD_DET) = ? THEN find first PRD_DET where
                              PRD_DEV >=  INPUT V9130
                               no-lock no-error.
                  else do:
                       if PRD_DEV =  INPUT V9130
                       then find next PRD_DET
                        no-lock no-error.
                        else find first PRD_DET where
                              PRD_DEV >=  INPUT V9130
                               no-lock no-error.
                  end.
                  IF AVAILABLE PRD_DET then display skip
            PRD_DEV @ V9130 PRD_DESC @ WMESSAGE NO-LABEL with fram F9130.
                  else   display skip "" @ WMESSAGE with fram F9130.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(PRD_DET) = ? THEN find last PRD_DET where
                              PRD_DEV <=  INPUT V9130
                               no-lock no-error.
                  else do:
                       if PRD_DEV =  INPUT V9130
                       then find prev PRD_DET
                        no-lock no-error.
                        else find first PRD_DET where
                              PRD_DEV >=  INPUT V9130
                               no-lock no-error.
                  end.
                  IF AVAILABLE PRD_DET then display skip
            PRD_DEV @ V9130 PRD_DESC @ WMESSAGE NO-LABEL with fram F9130.
                  else   display skip "" @ WMESSAGE with fram F9130.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V9130 = "e" THEN  LEAVE V9110LMAINLOOP.
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
     /* END    LINE :9130  打印机[Printer] AUTO  */


     Define variable ts9130 AS CHARACTER FORMAT "x(100)".
     Define variable av9130 AS CHARACTER FORMAT "x(100)".
     PROCEDURE inv239130l.
        /* Define Labels Path  Start */
        Define variable LabelsPath as character format "x(100)" init "/app/bc/labels/".
        Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath"no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath = trim ( code_cmmt ).
        If substring(LabelsPath, length(LabelsPath), 1) <> "/" Then
        LabelsPath = LabelsPath + "/".
        /* Define Labels Path  END */
     INPUT FROM VALUE(LabelsPath + "inv23").
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
     output to value( trim(wsection) + ".l") .
     Do While True:
              IMPORT UNFORMATTED ts9130.
        av9130 = V9015.
       IF INDEX(ts9130,"$Q") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$Q") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"$Q") + length("$Q"), LENGTH(ts9130) - ( index(ts9130 ,"$Q" ) + length("$Q") - 1 ) ).
       END.
        av9130 = trim(V1300) + "@" + trim(V1500).
       IF INDEX(ts9130,"&B") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&B") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"&B") + length("&B"), LENGTH(ts9130) - ( index(ts9130 ,"&B" ) + length("&B") - 1 ) ).
       END.

          /*库位*/
          if index(ts9130, "$C") <> 0 then do:
             av9130 = trim(V1520).
             ts9130 = substring(ts9130, 1, index(ts9130 , "$C") - 1) + av9130
                    + substring( ts9130 , index(ts9130 ,"$C")
                    + length("$C"), length(ts9130) - ( index(ts9130 , "$C") + length("$C") - 1 ) ).
          end.    /* SS - 110321.1 */

       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = trim(pt_desc2).
       IF INDEX(ts9130,"$E") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$E") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"$E") + length("$E"), LENGTH(ts9130) - ( index(ts9130 ,"$E" ) + length("$E") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = trim(pt_desc1).
       IF INDEX(ts9130,"$F") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$F") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"$F") + length("$F"), LENGTH(ts9130) - ( index(ts9130 ,"$F" ) + length("$F") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = if pt_avg_int <> 0 and pt_avg_int <> 90 then "保质期:" + trim ( string ( pt_avg_int ) ) + "月" else "".
       IF INDEX(ts9130,"&D") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&D") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"&D") + length("&D"), LENGTH(ts9130) - ( index(ts9130 ,"&D" ) + length("&D") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = pt_um.
       IF INDEX(ts9130,"$U") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$U") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"$U") + length("$U"), LENGTH(ts9130) - ( index(ts9130 ,"$U" ) + length("$U") - 1 ) ).
       END.
        av9130 = V1100.
       IF INDEX(ts9130,"$O") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$O") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"$O") + length("$O"), LENGTH(ts9130) - ( index(ts9130 ,"$O" ) + length("$O") - 1 ) ).
       END.
        av9130 = " ".
       IF INDEX(ts9130,"&R") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&R") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"&R") + length("&R"), LENGTH(ts9130) - ( index(ts9130 ,"&R" ) + length("&R") - 1 ) ).
       END.
        av9130 = string(today).
       IF INDEX(ts9130,"$D") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$D") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"$D") + length("$D"), LENGTH(ts9130) - ( index(ts9130 ,"$D" ) + length("$D") - 1 ) ).
       END.
        av9130 = V1300.
       IF INDEX(ts9130,"$P") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$P") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"$P") + length("$P"), LENGTH(ts9130) - ( index(ts9130 ,"$P" ) + length("$P") - 1 ) ).
       END.
        av9130 = V1500.
       IF INDEX(ts9130,"$L") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$L") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"$L") + length("$L"), LENGTH(ts9130) - ( index(ts9130 ,"$L" ) + length("$L") - 1 ) ).
       END.
        av9130 = " ".
       IF INDEX(ts9130,"$G") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$G") - 1) + av9130
       + SUBSTRING( ts9130 , index(ts9130 ,"$G") + length("$G"), LENGTH(ts9130) - ( index(ts9130 ,"$G" ) + length("$G") - 1 ) ).
       END.
       put unformatted ts9130 skip.
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.
     unix silent value ("chmod 777  " + trim(wsection) + ".l").
     END PROCEDURE.

     run inv239130l.
     do i = 1 to integer(wtm_num):
       find first PRD_DET where PRD_DEV = V9130 no-lock no-error.
       IF AVAILABLE PRD_DET then do:
         unix silent value (trim(prd_path) + " " + trim(wsection) + ".l").
         unix silent value ( "clear").
       end.
     End.
   /* Without Condition Exit Cycle Start */
   LEAVE V9110LMAINLOOP.
   /* Without Condition Exit Cycle END */
   /* Internal Cycle END :9130    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :9140    */
   V9140LMAINLOOP:
   REPEAT:



   IF NOT (V9010 = "Y" AND V1700 = "Y"   ) OR V9110 = "E" OR V9120 = "E" OR V9130 = "E"
       OR v1100 = "e" OR v1300 = "e" OR v1305 = "e" OR v1500 = "e" OR v1520 = "e" OR v1600 = "e"  THEN LEAVE V9140LMAINLOOP.

  /*****************************************************
   /*Logical Enter Cycle9140    */
   /*
   IF NOT (V9010 = "Y" AND ( decimal ( V9110 ) * decimal ( V9120 )  <> decimal ( V1600 ) ) ) THEN LEAVE V9140LMAINLOOP.
   */
     /* START  LINE :9140  条码上余数[QTY ON LABEL] 余数  */
     V9140L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9140           as char format "x(50)".
        define variable PV9140          as char format "x(50)".
        define variable L91401          as char format "x(40)".
        define variable L91402          as char format "x(40)".
        define variable L91403          as char format "x(40)".
        define variable L91404          as char format "x(40)".
        define variable L91405          as char format "x(40)".
        define variable L91406          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V9140 = string  ( decimal ( V1600 ) - decimal ( V9110 ) * decimal ( V9120 ) ).
        V9140 = ENTRY(1,V9140,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9140 = ENTRY(1,V9140,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[日供件-库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9140 no-box.

                /* LABEL 1 - START */
                L91401 = "余数?" .
                display L91401          format "x(40)" skip with fram F9140 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L91402 = "MFG图号:" + trim ( V1300 ) .
                display L91402          format "x(40)" skip with fram F9140 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L91403 = "批号" + trim ( V1500 ) .
                display L91403          format "x(40)" skip with fram F9140 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L91404 = "" .
                display L91404          format "x(40)" skip with fram F9140 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9140 no-box.
        Update V9140
        WITH  fram F9140 NO-LABEL
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
        IF V9140 = "e" THEN  LEAVE V9140LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9140.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9140.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        If V9140 = "" OR V9140 = "-" OR V9140 = "." OR V9140 = ".-" OR V9140 = "-." then do:
                display skip "CAN NOT EMPTY  " @ WMESSAGE NO-LABEL with fram F9140.
                pause 0 before-hide.
                undo, retry.
        end.
        DO i = 1 to length(V9140).
                If index("0987654321.-", substring(V9140,i,1)) = 0 then do:
                display skip "Format  Error  " @ WMESSAGE NO-LABEL with fram F9140.
                pause 0 before-hide.
                undo, retry.
                end.
        end.
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9140.
        pause 0.
        leave V9140L.
     END.
     PV9140 = V9140.
     /* END    LINE :9140  条码上余数[QTY ON LABEL] 余数  */


     /* START  LINE :9150  条码个数[No Of Label] 余数  */
     V9150L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9150           as char format "x(50)".
        define variable PV9150          as char format "x(50)".
        define variable L91501          as char format "x(40)".
        define variable L91502          as char format "x(40)".
        define variable L91503          as char format "x(40)".
        define variable L91504          as char format "x(40)".
        define variable L91505          as char format "x(40)".
        define variable L91506          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V9150 = "1".
        V9150 = ENTRY(1,V9150,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9150 = ENTRY(1,V9150,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V9015 = V9140.
IF 1 = 1 THEN
        leave V9150L.
        /* LOGICAL SKIP END */
                display "[日供件-库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9150 no-box.

                /* LABEL 1 - START */
                L91501 = "标签个数?" .
                display L91501          format "x(40)" skip with fram F9150 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L91502 = "图号:" + trim( V1300 ) .
                display L91502          format "x(40)" skip with fram F9150 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L91503 = "批号:" + Trim(V1500) .
                display L91503          format "x(40)" skip with fram F9150 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L91504 = "" .
                display L91504          format "x(40)" skip with fram F9150 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9150 no-box.
        Update V9150
        WITH  fram F9150 NO-LABEL
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
        IF V9150 = "e" THEN  LEAVE V9140LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9150.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9150.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        If V9150 = "" OR V9150 = "-" OR V9150 = "." OR V9150 = ".-" OR V9150 = "-." then do:
                display skip "CAN NOT EMPTY  " @ WMESSAGE NO-LABEL with fram F9150.
                pause 0 before-hide.
                undo, retry.
        end.
        DO i = 1 to length(V9150).
                If index("0987654321.-", substring(V9150,i,1)) = 0 then do:
                display skip "Format  Error  " @ WMESSAGE NO-LABEL with fram F9150.
                pause 0 before-hide.
                undo, retry.
                end.
        end.
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9150.
        pause 0.
        leave V9150L.
     END.
     PV9150 = V9150.
     /* END    LINE :9150  条码个数[No Of Label] 余数  */

   wtm_num = V9150.

     /* START  LINE :9160  打印机[Printer] 余数  */
     V9160L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9160           as char format "x(50)".
        define variable PV9160          as char format "x(50)".
        define variable L91601          as char format "x(40)".
        define variable L91602          as char format "x(40)".
        define variable L91603          as char format "x(40)".
        define variable L91604          as char format "x(40)".
        define variable L91605          as char format "x(40)".
        define variable L91606          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first upd_det where upd_nbr = "INV23" and upd_select = 99 no-lock no-error.
If AVAILABLE ( upd_det ) then
        V9160 = UPD_DEV.
        V9160 = ENTRY(1,V9160,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9160 = ENTRY(1,V9160,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF 1 <> 1 THEN
        leave V9160L.
        /* LOGICAL SKIP END */
                display "[日供件-库存转移]" + "*" + TRIM ( V1002 ) format "x(40)" skip with fram F9160 no-box.

                /* LABEL 1 - START */
                L91601 = "打印机?" .
                display L91601 format "x(40)" skip with fram F9160 no-box.
                /* LABEL 1 - END */


                /* LABEL 2 - START */
                L91602 = "条码上余数:" + trim ( V9140 ) .
                display L91602          format "x(40)" skip with fram F9160 no-box.
                /* LABEL 2 - END */


                /* LABEL 3 - START */
                L91603 = "条码个数:" + trim ( V9150) .
                display L91603          format "x(40)" skip with fram F9160 no-box.
                /* LABEL 3 - END */


                /* LABEL 4 - START */
                  L91604 = "" .
                display L91604          format "x(40)" skip with fram F9160 no-box.
                /* LABEL 4 - END */
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9160 no-box.
        recid(PRD_DET) = ?.
        Update V9160
        WITH  fram F9160 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F9160.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(PRD_DET) = ? THEN find first PRD_DET where
                              PRD_DEV >=  INPUT V9160
                               no-lock no-error.
                  else do:
                       if PRD_DEV =  INPUT V9160
                       then find next PRD_DET
                        no-lock no-error.
                        else find first PRD_DET where
                              PRD_DEV >=  INPUT V9160
                               no-lock no-error.
                  end.
                  IF AVAILABLE PRD_DET then display skip
            PRD_DEV @ V9160 PRD_DESC @ WMESSAGE NO-LABEL with fram F9160.
                  else   display skip "" @ WMESSAGE with fram F9160.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(PRD_DET) = ? THEN find last PRD_DET where
                              PRD_DEV <=  INPUT V9160
                               no-lock no-error.
                  else do:
                       if PRD_DEV =  INPUT V9160
                       then find prev PRD_DET
                        no-lock no-error.
                        else find first PRD_DET where
                              PRD_DEV >=  INPUT V9160
                               no-lock no-error.
                  end.
                  IF AVAILABLE PRD_DET then display skip
            PRD_DEV @ V9160 PRD_DESC @ WMESSAGE NO-LABEL with fram F9160.
                  else display skip "" @ WMESSAGE with fram F9160.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V9160 = "e" THEN  LEAVE V9140LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9160.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9160.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first PRD_DET where PRD_DEV = V9160  no-lock no-error.
        IF NOT AVAILABLE PRD_DET then do:
                display skip "打印机有误 " @ WMESSAGE NO-LABEL with fram F9160.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9160.
        pause 0.
        leave V9160L.
     END.
     PV9160 = V9160.
     /* END    LINE :9160  打印机[Printer] 余数  */

************************************************************************/
     Define variable ts9160 AS CHARACTER FORMAT "x(100)".
     Define variable av9160 AS CHARACTER FORMAT "x(100)".

     /*SS - 080912.1 B*/
     DEFINE VARIABLE vv_print_qty AS CHARACTER.
     DEFINE VARIABLE vvv_print_qty AS CHAR.

     vv_print_qty = V9015.
     /*SS - 080912.1 E*/


     PROCEDURE inv239160l.
        /* Define Labels Path  Start */
        Define variable LabelsPath as character format "x(100)" init "/app/bc/labels/".
        Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath"no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath = trim ( code_cmmt ).
        If substring(LabelsPath, length(LabelsPath), 1) <> "/" Then
        LabelsPath = LabelsPath + "/".
        /* Define Labels Path  END */
     INPUT FROM VALUE(LabelsPath + "inv23").
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
     output to value( trim(wsection) + ".l") .
     Do While True:
              IMPORT UNFORMATTED ts9160.
        /*SS - 080912.1 B*/
        /*
        av9160 = V9015.
        */
        av9160 = vv_print_qty.
        /*SS - 080912.1 E*/

          /*库位*/
          if index(ts9130, "$C") <> 0 then do:
             av9130 = trim(V1520).
             ts9130 = substring(ts9130, 1, index(ts9130 , "$C") - 1) + av9130
                    + substring( ts9130 , index(ts9130 ,"$C")
                    + length("$C"), length(ts9130) - ( index(ts9130 , "$C") + length("$C") - 1 ) ).
          end.    /* SS - 110321.1 */

       IF INDEX(ts9160,"$Q") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$Q") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"$Q") + length("$Q"), LENGTH(ts9160) - ( index(ts9160 ,"$Q" ) + length("$Q") - 1 ) ).
       END.
        av9160 = trim(V1300) + "@" + trim(V1500).
       IF INDEX(ts9160,"&B") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "&B") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"&B") + length("&B"), LENGTH(ts9160) - ( index(ts9160 ,"&B" ) + length("&B") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9160 = trim(pt_desc2).
       IF INDEX(ts9160,"$E") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$E") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"$E") + length("$E"), LENGTH(ts9160) - ( index(ts9160 ,"$E" ) + length("$E") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9160 = trim(pt_desc1).
       IF INDEX(ts9160,"$F") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$F") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"$F") + length("$F"), LENGTH(ts9160) - ( index(ts9160 ,"$F" ) + length("$F") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9160 = if pt_avg_int <> 0 and pt_avg_int <> 90 then "保质期:" + trim ( string ( pt_avg_int ) ) + "月" else "".
       IF INDEX(ts9160,"&D") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "&D") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"&D") + length("&D"), LENGTH(ts9160) - ( index(ts9160 ,"&D" ) + length("&D") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9160 = pt_um.
       IF INDEX(ts9160,"$U") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$U") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"$U") + length("$U"), LENGTH(ts9160) - ( index(ts9160 ,"$U" ) + length("$U") - 1 ) ).
       END.
        av9160 = V1100.
       IF INDEX(ts9160,"$O") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$O") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"$O") + length("$O"), LENGTH(ts9160) - ( index(ts9160 ,"$O" ) + length("$O") - 1 ) ).
       END.
        av9160 = " ".
       IF INDEX(ts9160,"&R") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "&R") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"&R") + length("&R"), LENGTH(ts9160) - ( index(ts9160 ,"&R" ) + length("&R") - 1 ) ).
       END.
        av9160 = string(today).
       IF INDEX(ts9160,"$D") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$D") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"$D") + length("$D"), LENGTH(ts9160) - ( index(ts9160 ,"$D" ) + length("$D") - 1 ) ).
       END.
        av9160 = V1300.
       IF INDEX(ts9160,"$P") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$P") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"$P") + length("$P"), LENGTH(ts9160) - ( index(ts9160 ,"$P" ) + length("$P") - 1 ) ).
       END.
        av9160 = V1500.
       IF INDEX(ts9160,"$L") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$L") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"$L") + length("$L"), LENGTH(ts9160) - ( index(ts9160 ,"$L" ) + length("$L") - 1 ) ).
       END.
        av9160 = " ".
       IF INDEX(ts9160,"$G") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$G") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"$G") + length("$G"), LENGTH(ts9160) - ( index(ts9160 ,"$G" ) + length("$G") - 1 ) ).
       END.
       put unformatted ts9160 skip.
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.
     unix silent value ("chmod 777  " + trim(wsection) + ".l").
     END PROCEDURE.

     PROCEDURE inv2391602.
        /* Define Labels Path  Start */
        Define variable LabelsPath as character format "x(100)" init "/app/bc/labels/".
        Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath"no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath = trim ( code_cmmt ).
        If substring(LabelsPath, length(LabelsPath), 1) <> "/" Then
        LabelsPath = LabelsPath + "/".
        /* Define Labels Path  END */
     INPUT FROM VALUE(LabelsPath + "inv23").
     wsection = "inv231" + TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
     output to value( trim(wsection) + ".l") .
     Do While True:
              IMPORT UNFORMATTED ts9160.
        /*SS - 080912.1 B*/
        /*
        av9160 = V9015.
        */
        av9160 = vvv_print_qty.
        /*SS - 080912.1 E*/

          /*库位*/
          if index(ts9130, "$C") <> 0 then do:
             av9130 = trim(V1520).
             ts9130 = substring(ts9130, 1, index(ts9130 , "$C") - 1) + av9130
                    + substring( ts9130 , index(ts9130 ,"$C")
                    + length("$C"), length(ts9130) - ( index(ts9130 , "$C") + length("$C") - 1 ) ).
          end.    /* SS - 110321.1 */

       IF INDEX(ts9160,"$Q") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$Q") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"$Q") + length("$Q"), LENGTH(ts9160) - ( index(ts9160 ,"$Q" ) + length("$Q") - 1 ) ).
       END.
        av9160 = trim(V1300) + "@" + trim(V1500).
       IF INDEX(ts9160,"&B") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "&B") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"&B") + length("&B"), LENGTH(ts9160) - ( index(ts9160 ,"&B" ) + length("&B") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9160 = trim(pt_desc2).
       IF INDEX(ts9160,"$E") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$E") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"$E") + length("$E"), LENGTH(ts9160) - ( index(ts9160 ,"$E" ) + length("$E") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9160 = trim(pt_desc1).
       IF INDEX(ts9160,"$F") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$F") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"$F") + length("$F"), LENGTH(ts9160) - ( index(ts9160 ,"$F" ) + length("$F") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9160 = if pt_avg_int <> 0 and pt_avg_int <> 90 then "保质期:" + trim ( string ( pt_avg_int ) ) + "月" else "".
       IF INDEX(ts9160,"&D") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "&D") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"&D") + length("&D"), LENGTH(ts9160) - ( index(ts9160 ,"&D" ) + length("&D") - 1 ) ).
       END.
       find first pt_mstr where pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9160 = pt_um.
       IF INDEX(ts9160,"$U") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$U") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"$U") + length("$U"), LENGTH(ts9160) - ( index(ts9160 ,"$U" ) + length("$U") - 1 ) ).
       END.
        av9160 = V1100.
       IF INDEX(ts9160,"$O") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$O") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"$O") + length("$O"), LENGTH(ts9160) - ( index(ts9160 ,"$O" ) + length("$O") - 1 ) ).
       END.
        av9160 = " ".
       IF INDEX(ts9160,"&R") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "&R") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"&R") + length("&R"), LENGTH(ts9160) - ( index(ts9160 ,"&R" ) + length("&R") - 1 ) ).
       END.
        av9160 = string(today).
       IF INDEX(ts9160,"$D") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$D") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"$D") + length("$D"), LENGTH(ts9160) - ( index(ts9160 ,"$D" ) + length("$D") - 1 ) ).
       END.
        av9160 = V1300.
       IF INDEX(ts9160,"$P") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$P") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"$P") + length("$P"), LENGTH(ts9160) - ( index(ts9160 ,"$P" ) + length("$P") - 1 ) ).
       END.
        av9160 = V1500.
       IF INDEX(ts9160,"$L") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$L") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"$L") + length("$L"), LENGTH(ts9160) - ( index(ts9160 ,"$L" ) + length("$L") - 1 ) ).
       END.
        av9160 = " ".
       IF INDEX(ts9160,"$G") <> 0  THEN DO:
       TS9160 = substring(TS9160, 1, Index(TS9160 , "$G") - 1) + av9160
       + SUBSTRING( ts9160 , index(ts9160 ,"$G") + length("$G"), LENGTH(ts9160) - ( index(ts9160 ,"$G" ) + length("$G") - 1 ) ).
       END.
       put unformatted ts9160 skip.
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.
     unix silent value ("chmod 777  " + trim(wsection) + ".l").
     END PROCEDURE.


     /*SS - 080912.1 b*/
     FIND FIRST pt_mstr WHERE pt_part = v1300  NO-LOCK NO-ERROR.


      /*add 080912.1
      IF  (decimal(V9015) / pt_ord_mult ) - TRUNCATE(decimal(V9015) / pt_ord_mult,0) > 0  THEN DO:
          wtm_num = TRUNCATE(decimal(V9015) / pt_ord_mult,0) + 1.
      END.
      ELSE DO:
          wtm_num = TRUNCATE(decimal(V9015) / pt_ord_mult,0).
      END.
      */
     IF AVAIL pt_mstr  THEN DO:


       IF decimal(V9110) <> 0  THEN DO:

       IF decimal(V1600) <> 0 AND (decimal(V1600) / decimal(V9110) ) - TRUNCATE(decimal(V1600) / decimal(V9110),0) > 0 AND decimal(V9110) <> 0  THEN DO:
            vv_print_qty = string(decimal(V1600) MOD decimal(V9110)) .
           run inv239160l.

           find first PRD_DET where PRD_DEV = V9130 no-lock no-error.
           IF AVAILABLE PRD_DET then do:
             unix silent value (trim(prd_path) + " " + trim(wsection) + ".l").
             unix silent value ( "clear").
           end.

       END.
       END.

       IF decimal(V1600) <> 0 AND (vv_loc_oh - decimal(V1600)) <> 0 THEN DO:
        vvv_print_qty =  string(vv_loc_oh - decimal(V1600)) .
        run inv2391602.

        find first PRD_DET where PRD_DEV = V9130 no-lock no-error.
        IF AVAILABLE PRD_DET then do:
          unix silent value (trim(prd_path) + " " + trim(wsection) + ".l").
          unix silent value ( "clear").
        end.
       END.

     END.
     /*
     run inv239160l.
     do i = 1 to integer(wtm_num):
       find first PRD_DET where PRD_DEV = V9160 no-lock no-error.
       IF AVAILABLE PRD_DET then do:
         unix silent value (trim(prd_path) + " " + trim(wsection) + ".l").
         unix silent value ( "clear").
       end.
     End.
     */

   /*SS - 080912.1 e*/

   /* Without Condition Exit Cycle Start */
   LEAVE V9140LMAINLOOP.
   /* Without Condition Exit Cycle END */
   /* Internal Cycle END :9160    */
   END.
   pause 0 before-hide.
end.

