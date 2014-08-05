/* Generate By Barcode Generator , Copyright by Softspeed - Build By Sam Song  */ 
/* INV TRANSFER */
/* Generate date / time  2011-3-30 12:46:13 */
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
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xsnewwtimeout"
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
                display "[库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 width 150 no-box.

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


     /* START  LINE :1100  单号[ORDER]  */
     V1100L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1100           as char format "x(150)".
        define variable PV1100          as char format "x(150)".
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
         If sectionid > 1 Then do:
          V1100 = PV1100 .
          V1100 = ENTRY(1,V1100,"@").
          leave V1100L.
        end.
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1100 = "Tr" + string(year(xxthdate)) + string(month(xxthdate)) + string(day(xxthdate)) + "001".
         	 find first code_mstr where code_domain = wDefDomain and code_fldname = "BarCodeTrPar" and code_value = "AutoNum" no-error.
         	 if not avail code_mstr then do:
         	 	 create code_mstr .
         	 	 assign 
         	 	    code_domain  = wDefDomain
         	 	    code_fldname = "BarCodeTrPar" 
         	 	    code_value   = "AutoNum"
         	 	    code_cmmt    = V1100.
         	 end.
         	 if V1100 < code_cmmt then V1100 = code_cmmt.
         	 code_cmmt = substring(V1100,1,10) + string(int(substring(V1100,11,3)) + 1).
         	 release code_mstr.
        IF 1=1 then        leave V1100L.
        /* LOGICAL SKIP END */

        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1100L .
        /* --CYCLE TIME SKIP -- END  */

                display "[库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1100 width 150 no-box.

                /* LABEL 1 - START */ 
                L11001 = "单据号码?" .
                display L11001          format "x(40)" skip with fram F1100 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11002 = "" . 
                display L11002          format "x(40)" skip with fram F1100 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11003 = "" . 
                display L11003          format "x(40)" skip with fram F1100 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11004 = "" . 
                display L11004          format "x(40)" skip with fram F1100 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1100 width 150 no-box.
        /* DISPLAY ONLY */
        define variable X1100           as char format "x(40)".
        X1100 = V1100.
        V1100 = "".
        /* DISPLAY ONLY */
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
        V1100 = X1100.
        /* DISPLAY ONLY */
        LEAVE V1100L.
        /* DISPLAY ONLY */

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
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        leave V1100L.
     END.
     PV1100 = V1100.
     /* END    LINE :1100  单号[ORDER]  */


   /* Internal Cycle Input :1290    */
   V1290LMAINLOOP:
   REPEAT:
     /* START  LINE :1290  扫描标签[Raw Material]  */
     V1290L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1290           as char format "x(150)".
        define variable PV1290          as char format "x(150)".
        define variable L12901          as char format "x(40)".
        define variable L12902          as char format "x(40)".
        define variable L12903          as char format "x(40)".
        define variable L12904          as char format "x(40)".
        define variable L12905          as char format "x(40)".
        define variable L12906          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1290 = " ".
        V1290 = ENTRY(1,V1290,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1290 = ENTRY(1,V1290,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1290 width 150 no-box.

                /* LABEL 1 - START */ 
                L12901 = "件号+批号+库位+数量?" .
                display L12901          format "x(40)" skip with fram F1290 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L12902 = "" . 
                display L12902          format "x(40)" skip with fram F1290 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L12903 = "" . 
                display L12903          format "x(40)" skip with fram F1290 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L12904 = "" . 
                display L12904          format "x(40)" skip with fram F1290 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1290 width 150 no-box.
        Update V1290
        WITH  fram F1290 NO-LABEL
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
        /* **SKIP TO MAIN LOOP START** */
        IF V1290 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        display  skip WMESSAGE NO-LABEL with fram F1290.

         /*  ---- Valid Check ---- START */

        if length(trim(V1290))<>0 then do:
find first pt_mstr where pt_domain=V1001 and pt_part = ENTRY(1, V1290, "@") no-lock no-error .
If not avail pt_mstr then do:
display skip "件号不存在,请查" @ WMESSAGE NO-LABEL with fram F1290.
                pause 0 before-hide.
                Undo, retry.

End.
End.
        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1290.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1290.
        pause 0.
        leave V1290L.
     END.
     PV1290 = V1290.
     /* END    LINE :1290  扫描标签[Raw Material]  */


     /* START  LINE :1300  件号[Raw Material]  */
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
        V1290=V1290 + "@".
        V1300 = ENTRY(1, V1290, "@").
        V1300 = ENTRY(1,V1300,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1300 = ENTRY(1,V1300,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        DO tki=1 TO 4:
   t_v100[tki]=''.
End.

Tkstr=V1290.

DO tki=1 TO 4:
  do  tkj=1 to length(tkstr) :
     if substring(tkstr,tkj,1)="@" then do:
       t_v100[tki]=substring(tkstr,1,tkj - 1).
        Tkstr=substring(tkstr,tkj + 1).
       Leave .
     End.
   End.
End.

If 1=1 and t_v100[1]<>''then
        leave V1300L.
        /* LOGICAL SKIP END */
                display "[库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1300 width 150 no-box.

                /* LABEL 1 - START */ 
                L13001 = "件号?" .
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
                              pt_domain = V1001 AND  
                              PT_PART >=  INPUT V1300
                               no-lock no-error.
                  else do: 
                       if PT_PART =  INPUT V1300
                       then find next PT_MSTR
                       WHERE pt_domain = V1001
                        no-lock no-error.
                        else find first PT_MSTR where 
                              pt_domain = V1001 AND  
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
                              pt_domain = V1001 AND  
                              PT_PART <=  INPUT V1300
                               no-lock no-error.
                  else do: 
                       if PT_PART =  INPUT V1300
                       then find prev PT_MSTR
                       where pt_domain = V1001
                        no-lock no-error.
                        else find first PT_MSTR where 
                              pt_domain = V1001 AND  
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
        IF V1300 = "e" THEN  LEAVE V1290LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1300.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first PT_MSTR where pt_domain = V1001 and PT_PART = ENTRY(1, V1300, "@")  no-lock no-error.
        IF NOT AVAILABLE PT_MSTR then do:
                display skip "件号有误!" @ WMESSAGE NO-LABEL with fram F1300.
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
     /* END    LINE :1300  件号[Raw Material]  */


     /* START  LINE :1490  从库位[From LOC]  */
     V1490L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1490           as char format "x(150)".
        define variable PV1490          as char format "x(150)".
        define variable L14901          as char format "x(40)".
        define variable L14902          as char format "x(40)".
        define variable L14903          as char format "x(40)".
        define variable L14904          as char format "x(40)".
        define variable L14905          as char format "x(40)".
        define variable L14906          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1490 = t_v100[3].
        V1490 = ENTRY(1,V1490,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V1490 = PV1490 .
        V1490 = ENTRY(1,V1490,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1490 width 150 no-box.

                /* LABEL 1 - START */ 
                L14901 = "从库位?" .
                display L14901          format "x(40)" skip with fram F1490 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L14902 = "件号" + trim( V1300 ) .
                display L14902          format "x(40)" skip with fram F1490 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L14903 = "" . 
                display L14903          format "x(40)" skip with fram F1490 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L14904 = "" . 
                display L14904          format "x(40)" skip with fram F1490 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1490 width 150 no-box.
        recid(loc_mstr) = ?.
        Update V1490
        WITH  fram F1490 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1490.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(loc_mstr) = ? THEN find first loc_mstr where 
                              LOC_domain = V1001 and  LOC_SITE = V1002 AND  
                              loc_loc >=  INPUT V1490
                               no-lock no-error.
                  else do: 
                       if loc_loc =  INPUT V1490
                       then find next loc_mstr
                       WHERE LOC_domain = V1001 and  LOC_SITE = V1002
                        no-lock no-error.
                        else find first loc_mstr where 
                              LOC_domain = V1001 and  LOC_SITE = V1002 AND  
                              loc_loc >=  INPUT V1490
                               no-lock no-error.
                  end.
                  IF AVAILABLE loc_mstr then display skip 
            loc_loc @ V1490 loc_loc + "/" + loc_desc @ WMESSAGE NO-LABEL with fram F1490.
                  else   display skip "" @ WMESSAGE with fram F1490.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(loc_mstr) = ? THEN find last loc_mstr where 
                              LOC_domain = V1001 and  LOC_SITE = V1002 AND  
                              loc_loc <=  INPUT V1490
                               no-lock no-error.
                  else do: 
                       if loc_loc =  INPUT V1490
                       then find prev loc_mstr
                       where LOC_domain = V1001 and  LOC_SITE = V1002
                        no-lock no-error.
                        else find first loc_mstr where 
                              LOC_domain = V1001 and  LOC_SITE = V1002 AND  
                              loc_loc >=  INPUT V1490
                               no-lock no-error.
                  end.
                  IF AVAILABLE loc_mstr then display skip 
            loc_loc @ V1490 loc_loc + "/" + loc_desc @ WMESSAGE NO-LABEL with fram F1490.
                  else   display skip "" @ WMESSAGE with fram F1490.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1490 = "e" THEN  LEAVE V1290LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1490.

         /*  ---- Valid Check ---- START */

        find first loc_mstr where LOC_domain = V1001 and  LOC_LOC = V1490 AND LOC_SITE = V1002 no-lock no-error.
if not avail loc_mstr   then do:
display skip "库位不存在,请重新输入" @ WMESSAGE NO-LABEL with fram F1490.
                pause 0 before-hide.
                Undo, retry.

End.
        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1490.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first LOC_MSTR where LOC_domain = V1001 and  LOC_LOC = V1490 AND LOC_SITE = V1002  no-lock no-error.
        IF NOT AVAILABLE LOC_MSTR then do:
                display skip "Error , Retry." @ WMESSAGE NO-LABEL with fram F1490.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1490.
        pause 0.
        leave V1490L.
     END.
     PV1490 = V1490.
     /* END    LINE :1490  从库位[From LOC]  */


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
        V1500 = t_v100[2].
        V1500 = ENTRY(1,V1500,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1500 = ENTRY(1,V1500,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        IF V1410 <> "L" then
        leave V1500L.
        /* LOGICAL SKIP END */
                display "[库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1500 width 150 no-box.

                /* LABEL 1 - START */ 
                L15001 = "批号?" .
                display L15001          format "x(40)" skip with fram F1500 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find first ld_det where ld_domain = V1001 and  ld_part = V1300  and ld_site = V1002  and ld_ref  = ""     and 
ld_loc = V1490  and
ld_qty_oh <> 0 use-index ld_part_lot no-lock no-error.
If AVAILABLE ( ld_det ) then
                L15002 = "最小:" + trim(ld_lot) .
                else L15002 = "" . 
                display L15002          format "x(40)" skip with fram F1500 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first ld_det where ld_domain = V1001 and ld_part = V1300 and
ld_site = V1002 and  
ld_ref  = ""     and 
ld_loc = V1490  and
ld_qty_oh <> 0 use-index ld_part_lot no-lock no-error.
If AVAILABLE ( ld_det ) then
                L15003 = "库存:" + trim(ld_loc) + "/" +  trim(string(ld_qty_oh)) .
                else L15003 = "" . 
                display L15003          format "x(40)" skip with fram F1500 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L15004 = "件号" + trim( V1300 ) .
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
                              LD_DOMAIN = V1001 and LD_PART = V1300 AND LD_QTY_OH <> 0  AND
LD_SITE = V1002 AND LD_REF = "" AND  
                              LD_LOT >=  INPUT V1500
                               no-lock no-error.
                  else do: 
                       if LD_LOT =  INPUT V1500
                       then find next LD_DET
                       WHERE LD_DOMAIN = V1001 and LD_PART = V1300 AND LD_QTY_OH <> 0  AND
LD_SITE = V1002 AND LD_REF = ""
                        no-lock no-error.
                        else find first LD_DET where 
                              LD_DOMAIN = V1001 and LD_PART = V1300 AND LD_QTY_OH <> 0  AND
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
                              LD_DOMAIN = V1001 and LD_PART = V1300 AND LD_QTY_OH <> 0  AND
LD_SITE = V1002 AND LD_REF = "" AND  
                              LD_LOT <=  INPUT V1500
                               no-lock no-error.
                  else do: 
                       if LD_LOT =  INPUT V1500
                       then find prev LD_DET
                       where LD_DOMAIN = V1001 and LD_PART = V1300 AND LD_QTY_OH <> 0  AND
LD_SITE = V1002 AND LD_REF = ""
                        no-lock no-error.
                        else find first LD_DET where 
                              LD_DOMAIN = V1001 and LD_PART = V1300 AND LD_QTY_OH <> 0  AND
LD_SITE = V1002 AND LD_REF = "" AND  
                              LD_LOT >=  INPUT V1500
                               no-lock no-error.
                  end.
                  IF AVAILABLE LD_DET then display skip 
            LD_LOT @ V1500 LD_LOC + "/" + trim(string(LD_QTY_OH)) @ WMESSAGE NO-LABEL with fram F1500.
                  else   display skip "" @ WMESSAGE with fram F1500.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1500 = "e" THEN  LEAVE V1290LMAINLOOP.
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


     /* START  LINE :1513  到地点[TO SITE]  */
     V1513L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1513           as char format "x(150)".
        define variable PV1513          as char format "x(150)".
        define variable L15131          as char format "x(40)".
        define variable L15132          as char format "x(40)".
        define variable L15133          as char format "x(40)".
        define variable L15134          as char format "x(40)".
        define variable L15135          as char format "x(40)".
        define variable L15136          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1513 = V1002.
        V1513 = ENTRY(1,V1513,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V1513 = PV1513 .
        V1513 = ENTRY(1,V1513,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1513 width 150 no-box.

                /* LABEL 1 - START */ 
                L15131 = "到地点?" .
                display L15131          format "x(40)" skip with fram F1513 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L15132 = "从库位:" + trim( V1490 ) .
                display L15132          format "x(40)" skip with fram F1513 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L15133 = "件号" + trim( V1300 ) .
                display L15133          format "x(40)" skip with fram F1513 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L15134 = "批号" + Trim(V1500) .
                display L15134          format "x(40)" skip with fram F1513 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1513 width 150 no-box.
        recid(si_mstr) = ?.
        Update V1513
        WITH  fram F1513 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1513.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(si_mstr) = ? THEN find first si_mstr where 
                              si_DOMAIN = V1001 AND  
                              si_site >=  INPUT V1513
                               no-lock no-error.
                  else do: 
                       if si_site =  INPUT V1513
                       then find next si_mstr
                       WHERE si_DOMAIN = V1001
                        no-lock no-error.
                        else find first si_mstr where 
                              si_DOMAIN = V1001 AND  
                              si_site >=  INPUT V1513
                               no-lock no-error.
                  end.
                  IF AVAILABLE si_mstr then display skip 
            si_site @ V1513 si_site @ WMESSAGE NO-LABEL with fram F1513.
                  else   display skip "" @ WMESSAGE with fram F1513.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(si_mstr) = ? THEN find last si_mstr where 
                              si_DOMAIN = V1001 AND  
                              si_site <=  INPUT V1513
                               no-lock no-error.
                  else do: 
                       if si_site =  INPUT V1513
                       then find prev si_mstr
                       where si_DOMAIN = V1001
                        no-lock no-error.
                        else find first si_mstr where 
                              si_DOMAIN = V1001 AND  
                              si_site >=  INPUT V1513
                               no-lock no-error.
                  end.
                  IF AVAILABLE si_mstr then display skip 
            si_site @ V1513 si_site @ WMESSAGE NO-LABEL with fram F1513.
                  else   display skip "" @ WMESSAGE with fram F1513.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1513 = "e" THEN  LEAVE V1290LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1513.

         /*  ---- Valid Check ---- START */

        find first si_mstr where si_DOMAIN = V1001 AND si_site=V1513 no-error.
If not avail si_mstr then do:
                display skip "地点不存在,请重新输入" @ WMESSAGE NO-LABEL with fram F1513.
                pause 0 before-hide.
                Undo, retry.
End.
        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1513.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1513.
        pause 0.
        leave V1513L.
     END.
     PV1513 = V1513.
     /* END    LINE :1513  到地点[TO SITE]  */


     /* START  LINE :1520  到库位[To   LOC]  */
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
        V1520 = " ".
        V1520 = ENTRY(1,V1520,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1520 = ENTRY(1,V1520,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1520 width 150 no-box.

                /* LABEL 1 - START */ 
                L15201 = "到库位?" .
                display L15201          format "x(40)" skip with fram F1520 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L15202 = "从库位:" + trim( V1490 ) + " 到地点:" + trim( V1513) .
                display L15202          format "x(40)" skip with fram F1520 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L15203 = "件号" + trim( V1300 ) .
                display L15203          format "x(40)" skip with fram F1520 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L15204 = "批号" + Trim(V1500) .
                display L15204          format "x(40)" skip with fram F1520 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1520 width 150 no-box.
        recid(loc_mstr) = ?.
        Update V1520
        WITH  fram F1520 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1520.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(loc_mstr) = ? THEN find first loc_mstr where 
                              LOC_domain = V1001 and  LOC_SITE = V1513 AND  
                              loc_loc >=  INPUT V1520
                               no-lock no-error.
                  else do: 
                       if loc_loc =  INPUT V1520
                       then find next loc_mstr
                       WHERE LOC_domain = V1001 and  LOC_SITE = V1513
                        no-lock no-error.
                        else find first loc_mstr where 
                              LOC_domain = V1001 and  LOC_SITE = V1513 AND  
                              loc_loc >=  INPUT V1520
                               no-lock no-error.
                  end.
                  IF AVAILABLE loc_mstr then display skip 
            loc_loc @ V1520 loc_loc + "/" + loc_desc @ WMESSAGE NO-LABEL with fram F1520.
                  else   display skip "" @ WMESSAGE with fram F1520.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(loc_mstr) = ? THEN find last loc_mstr where 
                              LOC_domain = V1001 and  LOC_SITE = V1513 AND  
                              loc_loc <=  INPUT V1520
                               no-lock no-error.
                  else do: 
                       if loc_loc =  INPUT V1520
                       then find prev loc_mstr
                       where LOC_domain = V1001 and  LOC_SITE = V1513
                        no-lock no-error.
                        else find first loc_mstr where 
                              LOC_domain = V1001 and  LOC_SITE = V1513 AND  
                              loc_loc >=  INPUT V1520
                               no-lock no-error.
                  end.
                  IF AVAILABLE loc_mstr then display skip 
            loc_loc @ V1520 loc_loc + "/" + loc_desc @ WMESSAGE NO-LABEL with fram F1520.
                  else   display skip "" @ WMESSAGE with fram F1520.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1520 = "e" THEN  LEAVE V1290LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1520.

         /*  ---- Valid Check ---- START */

        find first loc_mstr where LOC_domain = V1001 and  LOC_LOC = V1520 AND LOC_SITE = V1513 no-lock no-error.
if not avail loc_mstr   then do:
display skip "库位不存在,请重新输入" @ WMESSAGE NO-LABEL with fram F1520.
                pause 0 before-hide.
                Undo, retry.

End.
If V1490 = V1520 and
   V1002= V1513 then do:
display skip "地点与库位不可相同,请重新输入" @ WMESSAGE NO-LABEL with fram F1520.
                pause 0 before-hide.
                Undo, retry.

End.
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
     /* END    LINE :1520  到库位[To   LOC]  */


     /* START  LINE :1530  EffDate[EFF Date]  */
     V1530L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1530           as char format "x(150)".
        define variable PV1530          as char format "x(150)".
        define variable L15301          as char format "x(40)".
        define variable L15302          as char format "x(40)".
        define variable L15303          as char format "x(40)".
        define variable L15304          as char format "x(40)".
        define variable L15305          as char format "x(40)".
        define variable L15306          as char format "x(40)".
        define variable D1530           as date .
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1530 = string(today).
        D1530 = Date ( V1530).
        V1530 = ENTRY(1,V1530,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V1530 = PV1530 .
         If sectionid > 1 Then 
        D1530 = Date ( V1530).
        V1530 = ENTRY(1,V1530,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1530 width 150 no-box.

                /* LABEL 1 - START */ 
                L15301 = "生效日期?" .
                display L15301          format "x(40)" skip with fram F1530 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L15302 = "" . 
                display L15302          format "x(40)" skip with fram F1530 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L15303 = "" . 
                display L15303          format "x(40)" skip with fram F1530 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L15304 = "" . 
                display L15304          format "x(40)" skip with fram F1530 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1530 width 150 no-box.
        Update D1530
        WITH  fram F1530 NO-LABEL
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
        IF V1530 = "e" THEN  LEAVE V1290LMAINLOOP.
        V1530 = string ( D1530).
        display  skip WMESSAGE NO-LABEL with fram F1530.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1530.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1530.
        pause 0.
        leave V1530L.
     END.
     PV1530 = V1530.
     /* END    LINE :1530  EffDate[EFF Date]  */


     /* START  LINE :1550  MIN LOT and QTY  */
     V1550L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1550           as char format "x(150)".
        define variable PV1550          as char format "x(150)".
        define variable L15501          as char format "x(40)".
        define variable L15502          as char format "x(40)".
        define variable L15503          as char format "x(40)".
        define variable L15504          as char format "x(40)".
        define variable L15505          as char format "x(40)".
        define variable L15506          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first ld_det where ld_domain = V1001 and ld_part = V1300 and ld_site = V1002 and ld_loc = V1490 and ld_qty_oh <> 0  and ld_ref = "" use-index ld_part_lot no-lock no-error.
If AVAILABLE ( ld_det ) then
        V1550 = trim(ld_lot) + fill( " ", 18 - length ( trim ( ld_lot ) ) ) + string( ld_qty_oh ).
        V1550 = ENTRY(1,V1550,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1550 = ENTRY(1,V1550,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1550L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1550L .
        /* --CYCLE TIME SKIP -- END  */

                display "[库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1550 width 150 no-box.

                /* LABEL 1 - START */ 
                L15501 = "1- 18 LOT NO" .
                display L15501          format "x(40)" skip with fram F1550 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L15502 = "" . 
                display L15502          format "x(40)" skip with fram F1550 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L15503 = "" . 
                display L15503          format "x(40)" skip with fram F1550 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L15504 = "件号" + trim( V1300 ) .
                display L15504          format "x(40)" skip with fram F1550 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1550 width 150 no-box.
        /* DISPLAY ONLY */
        define variable X1550           as char format "x(40)".
        X1550 = V1550.
        V1550 = "".
        /* DISPLAY ONLY */
        Update V1550
        WITH  fram F1550 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V1550 = X1550.
        /* DISPLAY ONLY */
        LEAVE V1550L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1550 = "e" THEN  LEAVE V1290LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1550.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1550.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1550.
        pause 0.
        leave V1550L.
     END.
     PV1550 = V1550.
     /* END    LINE :1550  MIN LOT and QTY  */


     /* START  LINE :1600  数量[QTY]  */
     V1600L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1600           as char format "x(150)".
        define variable PV1600          as char format "x(150)".
        define variable L16001          as char format "x(40)".
        define variable L16002          as char format "x(40)".
        define variable L16003          as char format "x(40)".
        define variable L16004          as char format "x(40)".
        define variable L16005          as char format "x(40)".
        define variable L16006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1600 = t_v100[4].
        V1600 = ENTRY(1,V1600,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1600 = ENTRY(1,V1600,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1600 width 150 no-box.

                /* LABEL 1 - START */ 
                L16001 = "转移数量?" .
                display L16001          format "x(40)" skip with fram F1600 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L16002 = "件号" + trim( V1300 ) .
                display L16002          format "x(40)" skip with fram F1600 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L16003 = "批号" + Trim(V1500) .
                display L16003          format "x(40)" skip with fram F1600 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L16004 = "从:" + trim( V1490 ) + "到:" + trim( V1520 ) .
                display L16004          format "x(40)" skip with fram F1600 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1600 width 150 no-box.
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
        IF V1600 = "e" THEN  LEAVE V1290LMAINLOOP.
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
        find first LD_DET where ( ld_domain = V1001 and ld_part  = V1300 AND ld_lot = V1500 AND ld_site = V1002 AND ld_ref = "") AND ( ( decimal(V1600) < 0  AND ( ld_loc = V1520 AND  ld_domain = V1001 and LD_SITE = V1002 and ld_ref = "" and ld_QTY_oh >= - DECIMAL ( V1600 ) ) ) OR ( decimal(V1600) > 0 AND  ld_loc = V1490 AND  ld_domain = V1001 and LD_SITE = V1002 and ld_ref = "" and  ld_QTY_oh >= DECIMAL ( V1600 ) ) )  no-lock no-error.
        IF NOT AVAILABLE LD_DET then do:
                display skip "在库数 <:" + string( V1600 ) @ WMESSAGE NO-LABEL with fram F1600.
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
        define variable V1700           as char format "x(150)".
        define variable PV1700          as char format "x(150)".
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
                display "[库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1700 width 150 no-box.

                /* LABEL 1 - START */ 
                L17001 = "件号" + trim(V1300) .
                display L17001          format "x(40)" skip with fram F1700 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L17002 = "批号" + trim ( V1500 ) .
                display L17002          format "x(40)" skip with fram F1700 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L17003 = "数量:" + trim(V1600) .
                display L17003          format "x(40)" skip with fram F1700 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L17004 = "从:" + trim( V1490 ) + "到:" + trim( V1520 ) .
                display L17004          format "x(40)" skip with fram F1700 width 150 no-box.
                /* LABEL 4 - END */ 
                display "确认过帐[Y],E退出"   format "x(40)" skip
        skip with fram F1700 width 150 no-box.
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
        IF V1700 = "e" THEN  LEAVE V1290LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1700.

         /*  ---- Valid Check ---- START */

        find first ld_det where ld_domain = V1001 and ld_part  = V1300 AND
ld_site = V1002 AND 
loc_loc=V1490 and
ld_ref  = ""    and ld_lot = V1500 no-lock no-error.
If avail ld_det then do:
if ld_qty_oh<decimal(V1600 ) then do:
              display skip "库存不足,请重新输入" @ WMESSAGE NO-LABEL with fram F1700.
                pause 0 before-hide.
                Undo, retry.
End.
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


     /* START  LINE :9000  BEFORE POST LAST TRANSACTION  */
     V9000L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9000           as char format "x(150)".
        define variable PV9000          as char format "x(150)".
        define variable L90001          as char format "x(40)".
        define variable L90002          as char format "x(40)".
        define variable L90003          as char format "x(40)".
        define variable L90004          as char format "x(40)".
        define variable L90005          as char format "x(40)".
        define variable L90006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find last tr_hist where tr_domain = V1001 and tr_trnbr >= 0 no-lock no-error.
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

                display "[库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9000 width 150 no-box.

                /* LABEL 1 - START */ 
                  L90001 = "" . 
                display L90001          format "x(40)" skip with fram F9000 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L90002 = "" . 
                display L90002          format "x(40)" skip with fram F9000 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L90003 = "" . 
                display L90003          format "x(40)" skip with fram F9000 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L90004 = "" . 
                display L90004          format "x(40)" skip with fram F9000 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9000 width 150 no-box.
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
        IF V9000 = "e" THEN  LEAVE V1290LMAINLOOP.
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


        display "...PROCESSING...  " NO-LABEL with fram F9000X width 150 no-box.
        pause 0.
     /*  Update MFG/PRO START  */ 
      mfguser = V1300. /* ching add */ 
     {xsnewu.i}
     /*  Update MFG/PRO END  */ 
        display  "" NO-LABEL with fram F9000X width 150 no-box .
        pause 0.
     /* START  LINE :9004  FIFO Log Checking  */
     V9004L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9004           as char format "x(150)".
        define variable PV9004          as char format "x(150)".
        define variable L90041          as char format "x(40)".
        define variable L90042          as char format "x(40)".
        define variable L90043          as char format "x(40)".
        define variable L90044          as char format "x(40)".
        define variable L90045          as char format "x(40)".
        define variable L90046          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find last tr_hist where tr_domain = V1001 and
tr_date = today     and 
tr_trnbr > integer ( V9000 ) and 
tr_nbr  = V1100     and
tr_site = V1002     and   tr_type = "ISS-TR"    and tr_part = V1300     and tr_serial = V1500   and 
tr_time  + 15 >= TIME 
use-index tr_date_trn no-lock no-error.
If AVAILABLE ( tr_hist ) then
        V9004 = string(trnbr).
        V9004 = ENTRY(1,V9004,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9004 = ENTRY(1,V9004,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        if V9004 <> "" then do:
find first tr_hist where tr_domain=V1001 and tr_trnbr = integer(V9004) and tr_qty_loc < 0 use-index tr_trnbr no-error.
If AVAILABLE ( tr_hist ) and trim( substring(V1550,1,18) ) <> trim ( V1500 ) then
   tr__chr01 = V1550.
end.
Release tr_hist.
If 1 = 1 then
        leave V9004L.
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V9004L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V9004L .
        /* --CYCLE TIME SKIP -- END  */

                display "[库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9004 width 150 no-box.

                /* LABEL 1 - START */ 
                L90041 = "UPDATE TO TR__CHR01" .
                display L90041          format "x(40)" skip with fram F9004 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L90042 = "" . 
                display L90042          format "x(40)" skip with fram F9004 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L90043 = "" . 
                display L90043          format "x(40)" skip with fram F9004 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L90044 = "" . 
                display L90044          format "x(40)" skip with fram F9004 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9004 width 150 no-box.
        Update V9004
        WITH  fram F9004 NO-LABEL
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
        IF V9004 = "e" THEN  LEAVE V1290LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F9004.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F9004.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F9004.
        pause 0.
        leave V9004L.
     END.
     PV9004 = V9004.
     /* END    LINE :9004  FIFO Log Checking  */


     /* START  LINE :9010  OK  */
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
        V9010 = "Y".
        V9010 = ENTRY(1,V9010,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9010 = ENTRY(1,V9010,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9010 width 150 no-box.

                /* LABEL 1 - START */ 
                  L90101 = "" . 
                display L90101          format "x(40)" skip with fram F9010 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L90102 = "" . 
                display L90102          format "x(40)" skip with fram F9010 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                /* SS - 20070318.1 - B */     
           		   ASSIGN trnbr = INTEGER(mfguser) NO-ERROR.
		    IF ERROR-STATUS:ERROR THEN DO:
		       ASSIGN trnbr = 0.
		    END.


                  /* LABEL 2 - START */ 
 find last tr_hist where tr_trnbr = trnbr 
		                 and tr_domain = V1001 
	/*			 AND tr_user2 = V1300*/
 		                 AND tr_program = "xsinv23.p"
				 and  (tr_type = "RCT-TR" or tr_type = "iss-TR")
				 and tr_site = V1513  
				 and tr_nbr  = V1100 
				 and  tr_part = V1300 
				 and tr_serial = V1500
				   USE-INDEX tr_trnbr
			        NO-LOCK 
			        NO-ERROR.
				IF AVAILABLE tr_hist THEN DO:

				               L90101 = "交易已提交".
				    END.
				    ELSE DO:
				       L90101 = "".
				    END.
				    DISP 
				       L90101 FORMAT "x(40)" 
				       SKIP 
				       WITH FRAME F9010 NO-BOX.
				    If AVAILABLE ( tr_hist ) then do:
			 L90102 = "交易号:" + trim(string(tr_trnbr)) .               
				       L90103 = "" .
				    End.
				    ELSE DO:
				       L90102 = "" .
				       L90103 = "交易提交失败 " .
				    END.	    
				 Display 
				    L90102          format "x(40)" skip 
				    L90103          format "x(40)" skip 
				    with fram F9010 no-box.

                              If L90103<>"" then
				/* SS - 20070318.1 - E */
                L90103 = L90103 .
                else L90103 = "" . 
                display L90103          format "x(40)" skip with fram F9010 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L90104 = "按E退出" .
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
        IF V9010 = "e" THEN  LEAVE V1290LMAINLOOP.
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
   LEAVE V1290LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :9010    */
   END.
   pause 0 before-hide.
     /* START  LINE :9015  OUTPUT TO PRINTER QTY  */
     V9015L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9015           as char format "x(150)".
        define variable PV9015          as char format "x(150)".
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

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V9015L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V9015L .
        /* --CYCLE TIME SKIP -- END  */

                display "[库存转移]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9015 width 150 no-box.

                /* LABEL 1 - START */ 
                  L90151 = "" . 
                display L90151          format "x(40)" skip with fram F9015 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L90152 = "" . 
                display L90152          format "x(40)" skip with fram F9015 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L90153 = "" . 
                display L90153          format "x(40)" skip with fram F9015 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L90154 = "" . 
                display L90154          format "x(40)" skip with fram F9015 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9015 width 150 no-box.
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


end.
