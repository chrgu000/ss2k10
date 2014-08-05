/* Generate By Barcode Generator , Copyright by Softspeed - Build By Sam Song  */ 
/* UNPLANNED ISSUE */
/* Generate date / time  2011-3-18 11:31:14 */
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
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xsinv21wtimeout"
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
                display "[计划外出库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 width 150 no-box.

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


   /* Internal Cycle Input :1100    */
   V1100LMAINLOOP:
   REPEAT:
     /* START  LINE :1100  原因代码[ORDER]  */
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
         If sectionid > 1 Then 
        V1100 = PV1100 .
        V1100 = ENTRY(1,V1100,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[计划外出库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1100 width 150 no-box.

                /* LABEL 1 - START */ 
                L11001 = "原因代码?" .
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
        recid(CODE_MSTR) = ?.
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
        display skip "^" @ WMESSAGE NO-LABEL with fram F1100.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(CODE_MSTR) = ? THEN find first CODE_MSTR where 
                              CODE_DOMAIN = V1001 AND CODE_FLDNAME = "barcode_ISS_UNP" AND  
                              CODE_VALUE >=  INPUT V1100
                               no-lock no-error.
                  else do: 
                       if CODE_VALUE =  INPUT V1100
                       then find next CODE_MSTR
                       WHERE CODE_DOMAIN = V1001 AND CODE_FLDNAME = "barcode_ISS_UNP"
                        no-lock no-error.
                        else find first CODE_MSTR where 
                              CODE_DOMAIN = V1001 AND CODE_FLDNAME = "barcode_ISS_UNP" AND  
                              CODE_VALUE >=  INPUT V1100
                               no-lock no-error.
                  end.
                  IF AVAILABLE CODE_MSTR then display skip 
            CODE_VALUE @ V1100 ENTRY(4,code_cmmt,",") @ WMESSAGE NO-LABEL with fram F1100.
                  else   display skip "" @ WMESSAGE with fram F1100.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(CODE_MSTR) = ? THEN find last CODE_MSTR where 
                              CODE_DOMAIN = V1001 AND CODE_FLDNAME = "barcode_ISS_UNP" AND  
                              CODE_VALUE <=  INPUT V1100
                               no-lock no-error.
                  else do: 
                       if CODE_VALUE =  INPUT V1100
                       then find prev CODE_MSTR
                       where CODE_DOMAIN = V1001 AND CODE_FLDNAME = "barcode_ISS_UNP"
                        no-lock no-error.
                        else find first CODE_MSTR where 
                              CODE_DOMAIN = V1001 AND CODE_FLDNAME = "barcode_ISS_UNP" AND  
                              CODE_VALUE >=  INPUT V1100
                               no-lock no-error.
                  end.
                  IF AVAILABLE CODE_MSTR then display skip 
            CODE_VALUE @ V1100 ENTRY(4,code_cmmt,",") @ WMESSAGE NO-LABEL with fram F1100.
                  else   display skip "" @ WMESSAGE with fram F1100.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        /* **SKIP TO MAIN LOOP START** */
        IF V1100 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        display  skip WMESSAGE NO-LABEL with fram F1100.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first CODE_MSTR where CODE_DOMAIN = V1001 and CODE_FLDNAME = "barcode_ISS_UNP" AND index ( V1100,CODE_VALUE ) <> 0  no-lock no-error.
        IF NOT AVAILABLE CODE_MSTR then do:
                display skip "原因代码有误" @ WMESSAGE NO-LABEL with fram F1100.
                pause 0 before-hide.
                undo, retry.
        end.
        IF not length( trim ( V1100 ) ) <= 18 THEN DO:
                display skip "原因代码有误" @ WMESSAGE NO-LABEL with fram F1100.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        leave V1100L.
     END.
     PV1100 = V1100.
     /* END    LINE :1100  原因代码[ORDER]  */


     /* START  LINE :1200  备注  */
     V1200L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1200           as char format "x(150)".
        define variable PV1200          as char format "x(150)".
        define variable L12001          as char format "x(40)".
        define variable L12002          as char format "x(40)".
        define variable L12003          as char format "x(40)".
        define variable L12004          as char format "x(40)".
        define variable L12005          as char format "x(40)".
        define variable L12006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1200 = ENTRY(1,V1200,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1200L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1200L .
        /* --CYCLE TIME SKIP -- END  */

                display "[计划外出库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1200 width 150 no-box.

                /* LABEL 1 - START */ 
                L12001 = "备注?" .
                display L12001          format "x(40)" skip with fram F1200 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L12002 = "" . 
                display L12002          format "x(40)" skip with fram F1200 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L12003 = "" . 
                display L12003          format "x(40)" skip with fram F1200 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L12004 = "" . 
                display L12004          format "x(40)" skip with fram F1200 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1200 width 150 no-box.
        /* DISPLAY ONLY */
        define variable X1200           as char format "x(40)".
        X1200 = V1200.
        V1200 = "".
        /* DISPLAY ONLY */
        Update V1200
        WITH  fram F1200 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V1200 = X1200.
        /* DISPLAY ONLY */
        LEAVE V1200L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1200 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1200.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1200.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1200.
        pause 0.
        leave V1200L.
     END.
     PV1200 = V1200.
     /* END    LINE :1200  备注  */


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
                display "[计划外出库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1290 width 150 no-box.

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
        IF V1290 = "e" THEN  LEAVE V1100LMAINLOOP.
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

If 1=1 and t_v100[1]<>'' then
        leave V1300L.
        /* LOGICAL SKIP END */
                display "[计划外出库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1300 width 150 no-box.

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
            PT_PART @ V1300 trim( PT_Desc1 ) @ WMESSAGE NO-LABEL with fram F1300.
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
            PT_PART @ V1300 trim( PT_Desc1 ) @ WMESSAGE NO-LABEL with fram F1300.
                  else   display skip "" @ WMESSAGE with fram F1300.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1300 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1300.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first PT_MSTR where PT_PART = ENTRY(1, V1300, "@") and PT_DOMAIN = V1001  no-lock no-error.
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


     /* START  LINE :1400  库位[LOC]  */
     V1400L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1400           as char format "x(150)".
        define variable PV1400          as char format "x(150)".
        define variable L14001          as char format "x(40)".
        define variable L14002          as char format "x(40)".
        define variable L14003          as char format "x(40)".
        define variable L14004          as char format "x(40)".
        define variable L14005          as char format "x(40)".
        define variable L14006          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1400 = t_v100[3].
        V1400 = ENTRY(1,V1400,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1400 = ENTRY(1,V1400,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[计划外出库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1400 width 150 no-box.

                /* LABEL 1 - START */ 
                L14001 = "库位?" .
                display L14001          format "x(40)" skip with fram F1400 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L14002 = "件号" + trim( V1300 ) .
                display L14002          format "x(40)" skip with fram F1400 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L14003 = "" . 
                display L14003          format "x(40)" skip with fram F1400 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L14004 = "" . 
                display L14004          format "x(40)" skip with fram F1400 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1400 width 150 no-box.
        recid(LOC_MSTR) = ?.
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
                  IF recid(LOC_MSTR) = ? THEN find first LOC_MSTR where 
                              LOC_DOMAIN = V1001 AND LOC_SITE = V1002 AND  
                              LOC_LOC >=  INPUT V1400
                               no-lock no-error.
                  else do: 
                       if LOC_LOC =  INPUT V1400
                       then find next LOC_MSTR
                       WHERE LOC_DOMAIN = V1001 AND LOC_SITE = V1002
                        no-lock no-error.
                        else find first LOC_MSTR where 
                              LOC_DOMAIN = V1001 AND LOC_SITE = V1002 AND  
                              LOC_LOC >=  INPUT V1400
                               no-lock no-error.
                  end.
                  IF AVAILABLE LOC_MSTR then display skip 
            LOC_LOC @ V1400 LOC_DESC @ WMESSAGE NO-LABEL with fram F1400.
                  else   display skip "" @ WMESSAGE with fram F1400.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(LOC_MSTR) = ? THEN find last LOC_MSTR where 
                              LOC_DOMAIN = V1001 AND LOC_SITE = V1002 AND  
                              LOC_LOC <=  INPUT V1400
                               no-lock no-error.
                  else do: 
                       if LOC_LOC =  INPUT V1400
                       then find prev LOC_MSTR
                       where LOC_DOMAIN = V1001 AND LOC_SITE = V1002
                        no-lock no-error.
                        else find first LOC_MSTR where 
                              LOC_DOMAIN = V1001 AND LOC_SITE = V1002 AND  
                              LOC_LOC >=  INPUT V1400
                               no-lock no-error.
                  end.
                  IF AVAILABLE LOC_MSTR then display skip 
            LOC_LOC @ V1400 LOC_DESC @ WMESSAGE NO-LABEL with fram F1400.
                  else   display skip "" @ WMESSAGE with fram F1400.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1400 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1400.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1400.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first LOC_MSTR where LOC_DOMAIN = V1001 and LOC_LOC = V1400 AND LOC_SITE = V1002  no-lock no-error.
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


     /* START  LINE :1410  L Control  */
     V1410L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1410           as char format "x(150)".
        define variable PV1410          as char format "x(150)".
        define variable L14101          as char format "x(40)".
        define variable L14102          as char format "x(40)".
        define variable L14103          as char format "x(40)".
        define variable L14104          as char format "x(40)".
        define variable L14105          as char format "x(40)".
        define variable L14106          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first pt_mstr where  pt_domain = V1001 and pt_part = V1300  no-lock no-error.
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

                display "[计划外出库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1410 width 150 no-box.

                /* LABEL 1 - START */ 
                  L14101 = "" . 
                display L14101          format "x(40)" skip with fram F1410 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L14102 = "" . 
                display L14102          format "x(40)" skip with fram F1410 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L14103 = "" . 
                display L14103          format "x(40)" skip with fram F1410 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L14104 = "" . 
                display L14104          format "x(40)" skip with fram F1410 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1410 width 150 no-box.
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
        IF V1410 = "e" THEN  LEAVE V1100LMAINLOOP.
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
                display "[计划外出库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1500 width 150 no-box.

                /* LABEL 1 - START */ 
                L15001 = "批号?" .
                display L15001          format "x(40)" skip with fram F1500 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find first ld_det where ld_domain = V1001 and ld_part = V1300 and ld_loc = V1400 and ld_qty_oh <> 0 and ld_site = V1002 and ld_ref = "" use-index ld_part_lot no-lock no-error.
If AVAILABLE ( ld_det ) then
                L15002 = "最小:" + trim(ld_lot) .
                else L15002 = "" . 
                display L15002          format "x(40)" skip with fram F1500 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first ld_det where  ld_domain = V1001 and ld_part = V1300 and ld_loc = V1400 and ld_qty_oh <> 0  and ld_site = V1002 and ld_ref = "" use-index ld_part_lot no-lock no-error.
If AVAILABLE ( ld_det ) then
                L15003 = "库存:" + trim(ld_loc) + "/" + trim(string(ld_qty_oh)) .
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
                              LD_DOMAIN = V1001 AND LD_PART = V1300 AND LD_LOC = V1400  AND LD_QTY_OH <> 0  AND LD_SITE = V1002 AND LD_REF = "" AND  
                              LD_LOT >=  INPUT V1500
                               no-lock no-error.
                  else do: 
                       if LD_LOT =  INPUT V1500
                       then find next LD_DET
                       WHERE LD_DOMAIN = V1001 AND LD_PART = V1300 AND LD_LOC = V1400  AND LD_QTY_OH <> 0  AND LD_SITE = V1002 AND LD_REF = ""
                        no-lock no-error.
                        else find first LD_DET where 
                              LD_DOMAIN = V1001 AND LD_PART = V1300 AND LD_LOC = V1400  AND LD_QTY_OH <> 0  AND LD_SITE = V1002 AND LD_REF = "" AND  
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
                              LD_DOMAIN = V1001 AND LD_PART = V1300 AND LD_LOC = V1400  AND LD_QTY_OH <> 0  AND LD_SITE = V1002 AND LD_REF = "" AND  
                              LD_LOT <=  INPUT V1500
                               no-lock no-error.
                  else do: 
                       if LD_LOT =  INPUT V1500
                       then find prev LD_DET
                       where LD_DOMAIN = V1001 AND LD_PART = V1300 AND LD_LOC = V1400  AND LD_QTY_OH <> 0  AND LD_SITE = V1002 AND LD_REF = ""
                        no-lock no-error.
                        else find first LD_DET where 
                              LD_DOMAIN = V1001 AND LD_PART = V1300 AND LD_LOC = V1400  AND LD_QTY_OH <> 0  AND LD_SITE = V1002 AND LD_REF = "" AND  
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
        IF V1500 = "e" THEN  LEAVE V1100LMAINLOOP.
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
        find first ld_det where ld_domain = V1001 and ld_part = V1300 and ld_site = V1002 and ld_loc = V1400 and ld_qty_oh <> 0  and ld_ref = "" use-index ld_part_lot no-lock no-error.
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

                display "[计划外出库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1550 width 150 no-box.

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
                L15504 = "件号:" + trim( V1300 ) .
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
        IF V1550 = "e" THEN  LEAVE V1100LMAINLOOP.
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
                display "[计划外出库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1600 width 150 no-box.

                /* LABEL 1 - START */ 
                L16001 = "出库数量?" .
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
                find first ld_det where ld_domain = V1001 and ld_part = V1300 and ld_loc = V1400 and ld_lot = V1500 and ld_qty_oh <> 0  AND LD_SITE = V1002 AND LD_REF = "" use-index ld_part_lot no-lock no-error.
If AVAILABLE ( ld_det ) then
                L16004 = "库存:" + trim(V1400) + "/" + string ( ld_qty_oh ) .
                else L16004 = "" . 
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
        IF V1600 = "e" THEN  LEAVE V1100LMAINLOOP.
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
        find first LD_DET where ( decimal(V1600) < 0 and ld_part = "BARCODEXZYIU" ) OR ( LD_domain = V1001 and  ld_part  = V1300 AND ld_loc = V1400 AND LD_SITE = V1002 and ld_ref = "" AND  ld_lot = V1500 and  ld_QTY_oh >= DECIMAL ( V1600 ) )  no-lock no-error.
        IF NOT AVAILABLE LD_DET then do:
                display skip "在库数 <: " + string( V1600 ) @ WMESSAGE NO-LABEL with fram F1600.
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


     /* START  LINE :1630  科目  */
     V1630L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1630           as char format "x(150)".
        define variable PV1630          as char format "x(150)".
        define variable L16301          as char format "x(40)".
        define variable L16302          as char format "x(40)".
        define variable L16303          as char format "x(40)".
        define variable L16304          as char format "x(40)".
        define variable L16305          as char format "x(40)".
        define variable L16306          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first code_mstr where code_domain = V1001 and code_fldname = "barcode_ISS_UNP" and index(V1100,code_value)<> 0 no-lock no-error.
If AVAILABLE ( code_mstr ) then
        V1630 = ENTRY(1,code_cmmt,",").
        V1630 = ENTRY(1,V1630,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1630 = ENTRY(1,V1630,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        if 1=1 then
        leave V1630L.
        /* LOGICAL SKIP END */
                display "[计划外出库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1630 width 150 no-box.

                /* LABEL 1 - START */ 
                L16301 = "科目?" .
                display L16301          format "x(40)" skip with fram F1630 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L16302 = "原因代码:" + trim(V1100) .
                display L16302          format "x(40)" skip with fram F1630 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L16303 = "件号" + trim( V1300 ) .
                display L16303          format "x(40)" skip with fram F1630 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L16304 = "批号" + Trim(V1500) .
                display L16304          format "x(40)" skip with fram F1630 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1630 width 150 no-box.
        Update V1630
        WITH  fram F1630 NO-LABEL
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
        IF V1630 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1630.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1630.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1630.
        pause 0.
        leave V1630L.
     END.
     PV1630 = V1630.
     /* END    LINE :1630  科目  */


     /* START  LINE :1640  分帐户  */
     V1640L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1640           as char format "x(150)".
        define variable PV1640          as char format "x(150)".
        define variable L16401          as char format "x(40)".
        define variable L16402          as char format "x(40)".
        define variable L16403          as char format "x(40)".
        define variable L16404          as char format "x(40)".
        define variable L16405          as char format "x(40)".
        define variable L16406          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first code_mstr where code_domain = V1001 and code_fldname = "barcode_ISS_UNP" and index(V1100,code_value)<> 0 no-lock no-error.
If AVAILABLE ( code_mstr ) then
        V1640 = ENTRY(2,code_cmmt,",").
        V1640 = ENTRY(1,V1640,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1640 = ENTRY(1,V1640,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        if 1=1 then
        leave V1640L.
        /* LOGICAL SKIP END */
                display "[计划外出库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1640 width 150 no-box.

                /* LABEL 1 - START */ 
                L16401 = "分帐户?" .
                display L16401          format "x(40)" skip with fram F1640 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L16402 = "原因代码:" + trim(V1100) .
                display L16402          format "x(40)" skip with fram F1640 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L16403 = "件号" + trim( V1300 ) .
                display L16403          format "x(40)" skip with fram F1640 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L16404 = "批号" + Trim(V1500) .
                display L16404          format "x(40)" skip with fram F1640 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1640 width 150 no-box.
        Update V1640
        WITH  fram F1640 NO-LABEL
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
        IF V1640 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1640.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1640.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1640.
        pause 0.
        leave V1640L.
     END.
     PV1640 = V1640.
     /* END    LINE :1640  分帐户  */


     /* START  LINE :1650  成本中心  */
     V1650L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1650           as char format "x(150)".
        define variable PV1650          as char format "x(150)".
        define variable L16501          as char format "x(40)".
        define variable L16502          as char format "x(40)".
        define variable L16503          as char format "x(40)".
        define variable L16504          as char format "x(40)".
        define variable L16505          as char format "x(40)".
        define variable L16506          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first code_mstr where code_domain = V1001 and code_fldname = "barcode_ISS_UNP" and index(V1100,code_value)<> 0 no-lock no-error.
If AVAILABLE ( code_mstr ) then
        V1650 = ENTRY(3,code_cmmt,",").
        V1650 = ENTRY(1,V1650,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1650 = ENTRY(1,V1650,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[计划外出库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1650 width 150 no-box.

                /* LABEL 1 - START */ 
                L16501 = "成本中心?" .
                display L16501          format "x(40)" skip with fram F1650 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L16502 = "原因代码:" + trim(V1100) .
                display L16502          format "x(40)" skip with fram F1650 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L16503 = "件号" + trim( V1300 ) .
                display L16503          format "x(40)" skip with fram F1650 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L16504 = "批号" + Trim(V1500) .
                display L16504          format "x(40)" skip with fram F1650 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1650 width 150 no-box.
        Update V1650
        WITH  fram F1650 NO-LABEL
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
        IF V1650 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1650.

         /*  ---- Valid Check ---- START */

        find first cc_mstr where cc_domain=V1001 and cc_ctr=V1650 no-lock no-error.
If not avail cc_mstr then do:
                display skip "成本中心不存在,请查" @ WMESSAGE NO-LABEL with fram F1650.
                pause 0 before-hide.
                Undo, retry.
End.
        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1650.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1650.
        pause 0.
        leave V1650L.
     END.
     PV1650 = V1650.
     /* END    LINE :1650  成本中心  */


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
        V1700 = "E".
        V1700 = ENTRY(1,V1700,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1700 = ENTRY(1,V1700,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[计划外出库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1700 width 150 no-box.

                /* LABEL 1 - START */ 
                L17001 = "原因代码:" + trim(V1100) .
                display L17001          format "x(40)" skip with fram F1700 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L17002 = "件号" + trim(V1300) .
                display L17002          format "x(40)" skip with fram F1700 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L17003 = "批号" + trim ( V1500 ) .
                display L17003          format "x(40)" skip with fram F1700 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L17004 = "库位:" + trim ( V1400 ) + "/" + trim( V1600 ) .
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
        IF V1700 = "e" THEN  LEAVE V1100LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1700.

         /*  ---- Valid Check ---- START */

        find first ac_mstr where ac_domain=V1001 and ac_code=V1630 no-lock no-error.
If not avail ac_mstr then do:
                display skip "科目不存在,请查" @ WMESSAGE NO-LABEL with fram F1700.
                pause 0 before-hide.
                Undo, retry.
End.
find first sb_mstr where sb_domain=V1001 and sb_sub=V1640 no-lock no-error.
If not avail sb_mstr then do:
                display skip "分帐户不存在,请查" @ WMESSAGE NO-LABEL with fram F1700.
                pause 0 before-hide.
                Undo, retry.
End.
find first cc_mstr where cc_domain=V1001 and cc_ctr=V1650 no-lock no-error.
If not avail cc_mstr then do:
                display skip "成本中心不存在,请查" @ WMESSAGE NO-LABEL with fram F1700.
                pause 0 before-hide.
                Undo, retry.
End.
        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1700.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first ld_det where ld_domain = V1001 and ld_part  = V1300 AND ld_loc = V1400 and ld_lot = V1500 AND LD_SITE = V1002 AND LD_REF = ""  NO-ERROR NO-WAIT.
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

                display "[计划外出库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9000 width 150 no-box.

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
        IF V9000 = "e" THEN  LEAVE V1100LMAINLOOP.
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
     {xsinv21u.i}
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
        /* SS - 20070318.1 - B */     
           		   ASSIGN trnbr = INTEGER(mfguser) NO-ERROR.
		    IF ERROR-STATUS:ERROR THEN DO:
		       ASSIGN trnbr = 0.
		    END.
If trnbr<>0 then
        V9004 = string(trnbr).
        V9004 = ENTRY(1,V9004,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9004 = ENTRY(1,V9004,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        if V9004 <> "" then do:
find first tr_hist where  tr_domain=V1001 and tr_trnbr = integer(V9004) and tr_qty_loc < 0 use-index tr_trnbr no-error.
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

                display "[计划外出库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9004 width 150 no-box.

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
        IF V9004 = "e" THEN  LEAVE V1100LMAINLOOP.
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
        V9010 = "E".
        V9010 = ENTRY(1,V9010,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V9010 = ENTRY(1,V9010,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[计划外出库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9010 width 150 no-box.

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
                                /* AND tr_user2 = V1300 */
 		                 AND tr_program = "xsinv21.p"
				 and tr_nbr  = V1100 
				 and  tr_type = "ISS-UNP"
				 and tr_site = V1002  
				 and  tr_part = V1300 
				 and tr_serial=V1500
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
        IF V9010 = "e" THEN  LEAVE V1100LMAINLOOP.
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
   LEAVE V1100LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :9010    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :9110    */
   V9110LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle9110    */
   IF NOT (V9010 = "Y" AND V1700 = "Y" ) THEN LEAVE V9110LMAINLOOP.
     /* START  LINE :9110  条码上数量[QTY ON LABEL]  */
     V9110L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9110           as char format "x(150)".
        define variable PV9110          as char format "x(150)".
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
                display "[计划外出库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9110 width 150 no-box.

                /* LABEL 1 - START */ 
                find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr ) then
                L91101 = pt_um + " 标签上数量?" .
                else L91101 = "" . 
                display L91101          format "x(40)" skip with fram F9110 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L91102 = "件号:" + trim( V1300 ) .
                display L91102          format "x(40)" skip with fram F9110 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L91103 = "批号:" + Trim(V1500) .
                display L91103          format "x(40)" skip with fram F9110 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L91104 = "" . 
                display L91104          format "x(40)" skip with fram F9110 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9110 width 150 no-box.
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
     /* END    LINE :9110  条码上数量[QTY ON LABEL]  */


     /* START  LINE :9120  条码个数[No Of Label]  */
     V9120L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9120           as char format "x(150)".
        define variable PV9120          as char format "x(150)".
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
                display "[计划外出库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9120 width 150 no-box.

                /* LABEL 1 - START */ 
                L91201 = "标签个数?" .
                display L91201          format "x(40)" skip with fram F9120 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L91202 = "件号:" + trim( V1300 ) .
                display L91202          format "x(40)" skip with fram F9120 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L91203 = "批号:" + Trim(V1500) .
                display L91203          format "x(40)" skip with fram F9120 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L91204 = "" . 
                display L91204          format "x(40)" skip with fram F9120 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9120 width 150 no-box.
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
     /* END    LINE :9120  条码个数[No Of Label]  */


   wtm_num = V9120.
     /* START  LINE :9130  打印机[Printer]  */
     V9130L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9130           as char format "x(150)".
        define variable PV9130          as char format "x(150)".
        define variable L91301          as char format "x(40)".
        define variable L91302          as char format "x(40)".
        define variable L91303          as char format "x(40)".
        define variable L91304          as char format "x(40)".
        define variable L91305          as char format "x(40)".
        define variable L91306          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first upd_det where upd_nbr = "INV21" and upd_select = 99 no-lock no-error.
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

                display "[计划外出库]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9130 width 150 no-box.

                /* LABEL 1 - START */ 
                L91301 = "打印机?" .
                display L91301          format "x(40)" skip with fram F9130 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L91302 = "" . 
                display L91302          format "x(40)" skip with fram F9130 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L91303 = "" . 
                display L91303          format "x(40)" skip with fram F9130 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L91304 = "" . 
                display L91304          format "x(40)" skip with fram F9130 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9130 width 150 no-box.
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
     /* END    LINE :9130  打印机[Printer]  */


     Define variable ts9130 AS CHARACTER FORMAT "x(100)".
     Define variable av9130 AS CHARACTER FORMAT "x(100)".
     PROCEDURE inv219130l.
        /* Define Labels Path  Start */
        Define variable LabelsPath as character format "x(100)" init "/app/bc/labels/".
        Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath"no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath = trim ( code_cmmt ).
        If substring(LabelsPath, length(LabelsPath), 1) <> "/" Then 
        LabelsPath = LabelsPath + "/".
        /* Define Labels Path  END */
     INPUT FROM VALUE(LabelsPath + "inv21").
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
     output to value( trim(wsection) + ".l") .
     Do While True:
              IMPORT UNFORMATTED ts9130.
       find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = pt_um.
       IF INDEX(ts9130,"$U") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$U") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$U") + length("$U"), LENGTH(ts9130) - ( index(ts9130 ,"$U" ) + length("$U") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = trim(pt_desc2).
       IF INDEX(ts9130,"$E") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$E") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$E") + length("$E"), LENGTH(ts9130) - ( index(ts9130 ,"$E" ) + length("$E") - 1 ) ).
       END.
        av9130 = trim(V1300) + "@" + trim(V1500).
       IF INDEX(ts9130,"&B") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&B") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"&B") + length("&B"), LENGTH(ts9130) - ( index(ts9130 ,"&B" ) + length("&B") - 1 ) ).
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
       find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = if pt_avg_int <> 0 and pt_avg_int <> 90 then "保质期:" + trim ( string ( pt_avg_int ) ) + "月" else "".
       IF INDEX(ts9130,"&D") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&D") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"&D") + length("&D"), LENGTH(ts9130) - ( index(ts9130 ,"&D" ) + length("&D") - 1 ) ).
       END.
        av9130 = V9110.
       IF INDEX(ts9130,"$Q") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$Q") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$Q") + length("$Q"), LENGTH(ts9130) - ( index(ts9130 ,"$Q" ) + length("$Q") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = if pt_drwg_loc <> "" then "ENV DIR:" + trim (pt_drwg_loc) else "".
       IF INDEX(ts9130,"&E") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&E") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"&E") + length("&E"), LENGTH(ts9130) - ( index(ts9130 ,"&E" ) + length("&E") - 1 ) ).
       END.
        av9130 = V1100.
       IF INDEX(ts9130,"$O") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$O") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$O") + length("$O"), LENGTH(ts9130) - ( index(ts9130 ,"$O" ) + length("$O") - 1 ) ).
       END.
        av9130 = if length( trim ( V1500 ) ) >= 8 then substring ( trim ( V1500 ),7,2) else "00".
       IF INDEX(ts9130,"&M") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "&M") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"&M") + length("&M"), LENGTH(ts9130) - ( index(ts9130 ,"&M" ) + length("&M") - 1 ) ).
       END.
       find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr )  then
        av9130 = trim(pt_desc1).
       IF INDEX(ts9130,"$F") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$F") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$F") + length("$F"), LENGTH(ts9130) - ( index(ts9130 ,"$F" ) + length("$F") - 1 ) ).
       END.
        av9130 = string(today).
       IF INDEX(ts9130,"$D") <> 0  THEN DO:
       TS9130 = substring(TS9130, 1, Index(TS9130 , "$D") - 1) + av9130 
       + SUBSTRING( ts9130 , index(ts9130 ,"$D") + length("$D"), LENGTH(ts9130) - ( index(ts9130 ,"$D" ) + length("$D") - 1 ) ).
       END.
       put unformatted ts9130 skip.
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.
     unix silent value ("chmod 777  " + trim(wsection) + ".l").
     END PROCEDURE.
     run inv219130l.
     do i = 1 to integer(wtm_num):
       find first PRD_DET where PRD_DEV = V9130 no-lock no-error.
       IF AVAILABLE PRD_DET then do:
         unix silent value (trim(prd_path) + " " + trim(wsection) + ".l").
         unix silent value ( "clear").
       end.
     End.
   /* Internal Cycle END :9130    */
   END.
   pause 0 before-hide.
end.
