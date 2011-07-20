/* Generate By Barcode Generator , Copyright by Softspeed - Build By Sam Song  */ 
/* Finished In */
/* Generate date / time  2010-3-9 11:25:10 */
define variable sectionid as integer init 0 .
define variable WMESSAGE as char format "x(80)" init "".
define variable wtm_num as char format "x(20)" init "0".
define variable wsection as char format "x(16)".
define variable i as integer .

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout" no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xsinv71wtimeout" no-lock no-error. /*  Timeout - Program Level */
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
define variable def_loc like ld_loc.
	define variable contain_qty as decimal.
	define workfile xxindet  field 	xxinpart  like   xxin_part
   			                     field     xxinloc   like   xxin_loc
			                     field     xxinlot   like    xxin_lot
			                     field     xxinpallet like  xxin_pallet.
define variable wxxin_pallet like xxin_pallet.
        def variable xsckbypartloclot as logical.
        def variable xsckbypartloc as logical.
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
                display "[图号完工入库]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 no-box.

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
                display "[图号完工入库]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1300 no-box.

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
        IF substring ( V1300 ,1,1) = "P" then V1300 = substring ( V1300 , 2 ,17).
        Find first pt_mstr where pt_part = V1300 no-lock  no-error.
        If NOT AVAILABLE pt_mstr then do:
           find first pt_mstr where pt_draw =  V1300 and pt_draw <> "" no-lock  no-error.
           If AVAILABLE pt_mstr then V1300 = pt_part.
	End.
        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
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
        {xsgetdefloc.i}
        V1400 = def_loc.
        V1400 = ENTRY(1,V1400,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1400 = ENTRY(1,V1400,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[图号完工入库]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1400 no-box.

                /* LABEL 1 - START */ 
                L14001 = "货架OR临时库位?" .
                display L14001          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                {xsgetdefloc.i}
IF 1 = 1 THEN
                L14002 = "可放货架:" + def_loc + "/" + string( contain_qty ) .
                else L14002 = "" . 
                display L14002          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L14003 = "图号:" + trim( V1300 ) .
                display L14003          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                find first xxin_det where xxin_part  = V1300 and xxin_loc   = "ASSY" and xxin_fb    = no no-lock no-error.
If AVAILABLE ( xxin_det ) then
                L14004 = "警告:批号" + trim ( xxin_lot )  + "没上架" .
                else L14004 = "" . 
                display L14004          format "x(40)" skip with fram F1400 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1400 no-box.
        recid(CODE_MSTR) = ?.
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
        display skip "^" @ WMESSAGE NO-LABEL with fram F1400.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(CODE_MSTR) = ? THEN find first CODE_MSTR where 
                              CODE_fldname = "partloc" + V1300 AND  
                              Code_value >=  INPUT V1400
                               no-lock no-error.
                  else do: 
                       if Code_value =  INPUT V1400
                       then find next CODE_MSTR
                       WHERE CODE_fldname = "partloc" + V1300
                        no-lock no-error.
                        else find first CODE_MSTR where 
                              CODE_fldname = "partloc" + V1300 AND  
                              Code_value >=  INPUT V1400
                               no-lock no-error.
                  end.
                  IF AVAILABLE CODE_MSTR then display skip 
            Code_value @ V1400 Code_value + "/" + code_cmmt @ WMESSAGE NO-LABEL with fram F1400.
                  else   display skip "" @ WMESSAGE with fram F1400.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(CODE_MSTR) = ? THEN find last CODE_MSTR where 
                              CODE_fldname = "partloc" + V1300 AND  
                              Code_value <=  INPUT V1400
                               no-lock no-error.
                  else do: 
                       if Code_value =  INPUT V1400
                       then find prev CODE_MSTR
                       where CODE_fldname = "partloc" + V1300
                        no-lock no-error.
                        else find first CODE_MSTR where 
                              CODE_fldname = "partloc" + V1300 AND  
                              Code_value >=  INPUT V1400
                               no-lock no-error.
                  end.
                  IF AVAILABLE CODE_MSTR then display skip 
            Code_value @ V1400 Code_value + "/" + code_cmmt @ WMESSAGE NO-LABEL with fram F1400.
                  else   display skip "" @ WMESSAGE with fram F1400.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1400 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1400.

         /*  ---- Valid Check ---- START */

        find first CODE_MSTR where CODE_Fldname = "partLoc" + trim ( V1300 ) and code_value = trim ( V1400 )  no-lock no-error.
        IF ( NOT AVAILABLE CODE_MSTR )  and V1400 <> "ASSY"  then do:
                display skip "该货架无效." @ WMESSAGE NO-LABEL with fram F1400.
                pause 0 before-hide.
                undo, retry.
        end.
        {xsckbypartloc.i}
	if xsckbypartloc = no then do:
                display skip "该货架已满." @ WMESSAGE NO-LABEL with fram F1400.
                pause 0 before-hide.
                Undo, retry.

	End.
        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1400.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1400.
        pause 0.
        leave V1400L.
     END.
     PV1400 = V1400.
     /* END    LINE :1400  库位[LOC]  */


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

                display "[图号完工入库]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1410 no-box.

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
                display "[图号完工入库]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1500 no-box.

                /* LABEL 1 - START */ 
                L15001 = "入库批号?" .
                display L15001          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L15002 = "图号:" + trim( V1300 ) .
                display L15002          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L15003 = "货架:" + trim( V1400 ) .
                display L15003          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L15004 = "" . 
                display L15004          format "x(40)" skip with fram F1500 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
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
        IF V1500 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1500.

         /*  ---- Valid Check ---- START */

if substring ( V1500 ,1,1 ) = "S" then V1500 = substring (V1500,2,18).
                find first XXIN_DET where XXIN_PART = V1300 AND
XXIN_LOT = V1500  no-lock no-error.
        IF  AVAILABLE XXIN_DET  OR length ( trim(V1500) ) = 0 then do:
                display skip V1500 + "已经入库/不能为空" @ WMESSAGE NO-LABEL with fram F1500.
                pause 0 before-hide.
                undo, retry.
        end.
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


     /* START  LINE :1502  晚班批号[LOT]  */
     V1502L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1502           as char format "x(50)".
        define variable PV1502          as char format "x(50)".
        define variable L15021          as char format "x(40)".
        define variable L15022          as char format "x(40)".
        define variable L15023          as char format "x(40)".
        define variable L15024          as char format "x(40)".
        define variable L15025          as char format "x(40)".
        define variable L15026          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1502 = " ".
        V1502 = ENTRY(1,V1502,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1502 = ENTRY(1,V1502,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF V1410 <> "L" then
        leave V1502L.
        /* LOGICAL SKIP END */
                display "[图号完工入库]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1502 no-box.

                /* LABEL 1 - START */ 
                L15021 = "晚班批号?" .
                display L15021          format "x(40)" skip with fram F1502 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L15022 = "图号:" + trim( V1300 ) .
                display L15022          format "x(40)" skip with fram F1502 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L15023 = "入库批号:" + trim (V1500) .
                display L15023          format "x(40)" skip with fram F1502 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L15024 = "" . 
                display L15024          format "x(40)" skip with fram F1502 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1502 no-box.
        recid(XXIN_DET) = ?.
        Update V1502
        WITH  fram F1502 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1502.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(XXIN_DET) = ? THEN find first XXIN_DET where 
                              XXIN_PART = V1300 AND  
                              XXIN_LOT >=  INPUT V1502
                               no-lock no-error.
                  else do: 
                       if XXIN_LOT =  INPUT V1502
                       then find next XXIN_DET
                       WHERE XXIN_PART = V1300
                        no-lock no-error.
                        else find first XXIN_DET where 
                              XXIN_PART = V1300 AND  
                              XXIN_LOT >=  INPUT V1502
                               no-lock no-error.
                  end.
                  IF AVAILABLE XXIN_DET then display skip 
            XXIN_LOT @ V1502 XXIN_LOT + "/车台号:" + XXIN_PALLET @ WMESSAGE NO-LABEL with fram F1502.
                  else   display skip "" @ WMESSAGE with fram F1502.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(XXIN_DET) = ? THEN find last XXIN_DET where 
                              XXIN_PART = V1300 AND  
                              XXIN_LOT <=  INPUT V1502
                               no-lock no-error.
                  else do: 
                       if XXIN_LOT =  INPUT V1502
                       then find prev XXIN_DET
                       where XXIN_PART = V1300
                        no-lock no-error.
                        else find first XXIN_DET where 
                              XXIN_PART = V1300 AND  
                              XXIN_LOT >=  INPUT V1502
                               no-lock no-error.
                  end.
                  IF AVAILABLE XXIN_DET then display skip 
            XXIN_LOT @ V1502 XXIN_LOT + "/车台号:" + XXIN_PALLET @ WMESSAGE NO-LABEL with fram F1502.
                  else   display skip "" @ WMESSAGE with fram F1502.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1502 = "e" THEN  LEAVE V1300LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1502.

         /*  ---- Valid Check ---- START */

                find first XXIN_DET where XXIN_PART = V1300 AND
XXIN_LOT = V1502  no-lock no-error.
        IF ( NOT AVAILABLE XXIN_DET ) AND V1502 <> "" then do:
                display skip "晚班批号不存在" @ WMESSAGE NO-LABEL with fram F1502.
                pause 0 before-hide.
                undo, retry.
        end.
        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1502.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1502.
        pause 0.
        leave V1502L.
     END.
     PV1502 = V1502.
     /* END    LINE :1502  晚班批号[LOT]  */


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
                display "[图号完工入库]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1700 no-box.

                /* LABEL 1 - START */ 
                L17001 = "图号:" + trim(V1300) .
                display L17001          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L17002 = "批号:" + trim ( V1500 ) .
                display L17002          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L17003 = "库位:" + trim ( V1400 ) .
                display L17003          format "x(40)" skip with fram F1700 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L17004 = "晚班批号:" + trim ( V1502 ) .
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

        {xsckbypartloclot.i}
        IF xsckbypartloclot = no then do:
                display skip "该批号已入库/货架已满" @ WMESSAGE NO-LABEL with fram F1700.
                pause 0 before-hide.
                Undo, retry.
        End.
        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1700.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1700.
        pause 0.
        leave V1700L.
     END.
     PV1700 = V1700.
     /* END    LINE :1700  确认[CONFIRM]  */


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
        {xsinv71u.i}
IF 1 <> 1 then
        leave V9010L.
        /* LOGICAL SKIP END */
                display "[图号完工入库]"      + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9010 no-box.

                /* LABEL 1 - START */ 
                find last xxin_det where 
xxin_part = V1300     and xxin_lot = V1500      and
xxin_loc = V1400 
use-index partlot no-lock no-error.
If AVAILABLE ( xxin_det ) then
                L90101 = "交易已提交" .
                else L90101 = "" . 
                display L90101          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find last xxin_det where 
xxin_part = V1300     and xxin_lot = V1500      and
xxin_loc = V1400 
use-index partlot no-lock no-error.
If AVAILABLE ( xxin_det ) then
                L90102 = "台车:" + trim(xxin_pallet) .
                else L90102 = "" . 
                display L90102          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find last xxin_det where 
xxin_part = V1300     and xxin_lot = V1500      and
xxin_loc = V1400 
use-index partlot no-lock no-error.
If NOT AVAILABLE ( xxin_det ) then
                L90103 = "交易提交失败" .
                else L90103 = "" . 
                display L90103          format "x(40)" skip with fram F9010 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L90104 = "" . 
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
end.
