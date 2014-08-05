/* Generate By Barcode Generator , Copyright by Softspeed - Build By Sam Song  */ 
/* PO RECEIPT [PRODUCTION DATE] */
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
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xspor03wtimeout"
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
                display "[采购收货]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 width 150 no-box.

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


   /* Internal Cycle Input :1287    */
   V1287LMAINLOOP:
   REPEAT:
     /* START  LINE :1287  扫描传票[SCANCHUANPIAO]  */
     V1287L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1287           as char format "x(150)".
        define variable PV1287          as char format "x(150)".
        define variable L12871          as char format "x(40)".
        define variable L12872          as char format "x(40)".
        define variable L12873          as char format "x(40)".
        define variable L12874          as char format "x(40)".
        define variable L12875          as char format "x(40)".
        define variable L12876          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        if looa="N" then
V1287=PV1287.
else
        V1287 = " ".
        V1287 = ENTRY(1,V1287,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1287 = ENTRY(1,V1287,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "[采购收货]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1287 width 150 no-box.

                /* LABEL 1 - START */ 
                L12871 = "扫描传票" .
                display L12871          format "x(40)" skip with fram F1287 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L12872 = "" . 
                display L12872          format "x(40)" skip with fram F1287 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L12873 = "" . 
                display L12873          format "x(40)" skip with fram F1287 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L12874 = "" . 
                display L12874          format "x(40)" skip with fram F1287 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1287 width 150 no-box.
        Update V1287
        WITH  fram F1287 NO-LABEL
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
        IF V1287 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        display  skip WMESSAGE NO-LABEL with fram F1287.

         /*  ---- Valid Check ---- START */

        If length(trim(V1287))<>0 then do:       
 DO tki=1 TO 15:
   t_v100[tki]=''.
End.

Tkstr=V1287.

DO tki=1 TO 15:
  do  tkj=1 to length(tkstr) :
     if substring(tkstr,tkj,1)="@" then do:
       t_v100[tki]=substring(tkstr,1,tkj - 1).
        Tkstr=substring(tkstr,tkj + 1).

       Leave .
     End.
   End.
End.
If length(trim(t_v100[11]))=0 then do:
display skip "传票格式不正确" @ WMESSAGE NO-LABEL with fram F1287.
                pause 0 before-hide.
                Undo, retry.
End.
End.
        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1287.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1287.
        pause 0.
        leave V1287L.
     END.
     PV1287 = V1287.
     /* END    LINE :1287  扫描传票[SCANCHUANPIAO]  */


     /* START  LINE :1288  扫描提示[SCANCHUANPIAO]  */
     V1288L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1288           as char format "x(150)".
        define variable PV1288          as char format "x(150)".
        define variable L12881          as char format "x(40)".
        define variable L12882          as char format "x(40)".
        define variable L12883          as char format "x(40)".
        define variable L12884          as char format "x(40)".
        define variable L12885          as char format "x(40)".
        define variable L12886          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1288 = "Y".
        V1288 = ENTRY(1,V1288,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1288 = ENTRY(1,V1288,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        find first tr_hist where tr_batch<>"" and tr_batch=V1287
and tr_domain=V1001   use-index tr_batch no-lock no-error no-wait.
If not avail tr_hist then
        leave V1288L.
        /* LOGICAL SKIP END */
                display "[采购收货]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1288 width 150 no-box.

                /* LABEL 1 - START */ 
                L12881 = "该传票已扫描" .
                display L12881          format "x(40)" skip with fram F1288 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L12882 = "按Y继续,N重新扫描" .
                display L12882          format "x(40)" skip with fram F1288 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L12883 = "" . 
                display L12883          format "x(40)" skip with fram F1288 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L12884 = "" . 
                display L12884          format "x(40)" skip with fram F1288 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1288 width 150 no-box.
        Update V1288
        WITH  fram F1288 NO-LABEL
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
        IF V1288 = "e" THEN  LEAVE V1287LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1288.

         /*  ---- Valid Check ---- START */

        if V1288="N" then LEAVE V1287LMAINLOOP.
        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1288.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not (V1288= "Y" or V1288="N") THEN DO:
                display skip "Error , Retry " @ WMESSAGE NO-LABEL with fram F1288.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1288.
        pause 0.
        leave V1288L.
     END.
     PV1288 = V1288.
     /* END    LINE :1288  扫描提示[SCANCHUANPIAO]  */


     /* START  LINE :1289  显示传票[SCANCHUANPIAO]  */
     V1289L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1289           as char format "x(150)".
        define variable PV1289          as char format "x(150)".
        define variable L12891          as char format "x(40)".
        define variable L12892          as char format "x(40)".
        define variable L12893          as char format "x(40)".
        define variable L12894          as char format "x(40)".
        define variable L12895          as char format "x(40)".
        define variable L12896          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1289 = ENTRY(1,V1289,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        DO tki=1 TO 15:
   t_v100[tki]="".
End.

Tkstr=V1287.

DO tki=1 TO 15:
  do  tkj=1 to length(tkstr) :
     if substring(tkstr,tkj,1)="@" then do:
       t_v100[tki]=substring(tkstr,1,tkj - 1).
        Tkstr=substring(tkstr,tkj + 1).

       Leave .
     End.
   End.
End.
If 1=1 then
        leave V1289L.
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1289L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1289L .
        /* --CYCLE TIME SKIP -- END  */

                display "[采购收货]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1289 width 150 no-box.

                /* LABEL 1 - START */ 
                L12891 = "显示传票" .
                display L12891          format "x(40)" skip with fram F1289 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L12892 = "" . 
                display L12892          format "x(40)" skip with fram F1289 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L12893 = "" . 
                display L12893          format "x(40)" skip with fram F1289 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L12894 = "" . 
                display L12894          format "x(40)" skip with fram F1289 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1289 width 150 no-box.
        Update V1289
        WITH  fram F1289 NO-LABEL
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
        IF V1289 = "e" THEN  LEAVE V1287LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1289.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1289.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1289.
        pause 0.
        leave V1289L.
     END.
     PV1289 = V1289.
     /* END    LINE :1289  显示传票[SCANCHUANPIAO]  */


     /* START  LINE :1290  装箱单(传票)[Packing No]  */
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
        V1290 = t_v100[8].
        V1290 = ENTRY(1,V1290,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1290 = ENTRY(1,V1290,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        if looa="Y" then leave V1290L.
IF t_v100[8]<>"" THEN
        leave V1290L.
        /* LOGICAL SKIP END */
                display "[采购收货]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1290 width 150 no-box.

                /* LABEL 1 - START */ 
                L12901 = "传票号?" .
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
        IF V1290 = "e" THEN  LEAVE V1287LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1290.

         /*  ---- Valid Check ---- START */

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
     /* END    LINE :1290  装箱单(传票)[Packing No]  */


     /* START  LINE :1300  PO加传票号[POCHUANPIAO]  */
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
        V1300 = t_v100[6].
        V1300 = ENTRY(1,V1300,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1300 = ENTRY(1,V1300,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        if looa="Y" then leave V1300L.
IF t_v100[6]<>"" THEN
        leave V1300L.
        /* LOGICAL SKIP END */
                display "[采购收货]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1300 width 150 no-box.

                /* LABEL 1 - START */ 
                L13001 = "采购单?" .
                display L13001          format "x(40)" skip with fram F1300 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L13002 = "传票号" + V1290 .
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
        recid(po_mstr) = ?.
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
                  IF recid(po_mstr) = ? THEN find first po_mstr where 
                              PO_DOMAIN = V1001 AND INDEX("XC",PO_STAT) = 0 AND PO_TYPE <> "B" AND (PO_SITE = "" OR PO_SITE = V1002) /*and po_sched=yes*/ AND  
                              po_nbr >=  INPUT V1300
                               no-lock no-error.
                  else do: 
                       if po_nbr =  INPUT V1300
                       then find next po_mstr
                       WHERE PO_DOMAIN = V1001 AND INDEX("XC",PO_STAT) = 0 AND PO_TYPE <> "B" AND (PO_SITE = "" OR PO_SITE = V1002) /*and po_sched=yes*/
                        no-lock no-error.
                        else find first po_mstr where 
                              PO_DOMAIN = V1001 AND INDEX("XC",PO_STAT) = 0 AND PO_TYPE <> "B" AND (PO_SITE = "" OR PO_SITE = V1002) /*and po_sched=yes*/ AND  
                              po_nbr >=  INPUT V1300
                               no-lock no-error.
                  end.
                  IF AVAILABLE po_mstr then display skip 
            po_nbr @ V1300 trim( PO_NBR ) + "/" + trim( PO_VEND ) @ WMESSAGE NO-LABEL with fram F1300.
                  else   display skip "" @ WMESSAGE with fram F1300.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(po_mstr) = ? THEN find last po_mstr where 
                              PO_DOMAIN = V1001 AND INDEX("XC",PO_STAT) = 0 AND PO_TYPE <> "B" AND (PO_SITE = "" OR PO_SITE = V1002) /*and po_sched=yes*/ AND  
                              po_nbr <=  INPUT V1300
                               no-lock no-error.
                  else do: 
                       if po_nbr =  INPUT V1300
                       then find prev po_mstr
                       where PO_DOMAIN = V1001 AND INDEX("XC",PO_STAT) = 0 AND PO_TYPE <> "B" AND (PO_SITE = "" OR PO_SITE = V1002) /*and po_sched=yes*/
                        no-lock no-error.
                        else find first po_mstr where 
                              PO_DOMAIN = V1001 AND INDEX("XC",PO_STAT) = 0 AND PO_TYPE <> "B" AND (PO_SITE = "" OR PO_SITE = V1002) /*and po_sched=yes*/ AND  
                              po_nbr >=  INPUT V1300
                               no-lock no-error.
                  end.
                  IF AVAILABLE po_mstr then display skip 
            po_nbr @ V1300 trim( PO_NBR ) + "/" + trim( PO_VEND ) @ WMESSAGE NO-LABEL with fram F1300.
                  else   display skip "" @ WMESSAGE with fram F1300.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1300 = "e" THEN  LEAVE V1287LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1300.

         /*  ---- Valid Check ---- START */

        find first po_mstr where PO_DOMAIN = V1001 AND INDEX("XC",PO_STAT) = 0 AND PO_TYPE <> "B" AND (PO_SITE = "" OR PO_SITE = V1002) and /*po_sched=yes and*/ po_nbr=ENTRY(1,V1300,"@") no-lock no-error.
If not avail po_mstr then do:
                display skip "订单不存在,请重新输入" @ WMESSAGE NO-LABEL with fram F1300.
                pause 0 before-hide.
                Undo, retry.
End.
        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
        leave V1300L.
     END.
     IF INDEX(V1300,"@" ) = 0 then V1300 = V1300 + "@".
     PV1300 = V1300.
     V1300 = ENTRY(1,V1300,"@").
     /* END    LINE :1300  PO加传票号[POCHUANPIAO]  */


     /* START  LINE :1310  件号加批号[Raw Material lot]  */
     V1310L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1310           as char format "x(150)".
        define variable PV1310          as char format "x(150)".
        define variable L13101          as char format "x(40)".
        define variable L13102          as char format "x(40)".
        define variable L13103          as char format "x(40)".
        define variable L13104          as char format "x(40)".
        define variable L13105          as char format "x(40)".
        define variable L13106          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1310 = t_v100[1].
        V1310 = ENTRY(1,V1310,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1310 = ENTRY(1,V1310,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        if looa="Y" then leave V1310L.
IF t_v100[1]<>"" THEN
        leave V1310L.
        /* LOGICAL SKIP END */
                display "[采购收货]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1310 width 150 no-box.

                /* LABEL 1 - START */ 
                L13101 = "件号?" .
                display L13101          format "x(40)" skip with fram F1310 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L13102 = "传票号" + V1290 .
                display L13102          format "x(40)" skip with fram F1310 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L13103 = "PO号" + V1300 .
                display L13103          format "x(40)" skip with fram F1310 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13104 = "" . 
                display L13104          format "x(40)" skip with fram F1310 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1310 width 150 no-box.
        recid(pod_det) = ?.
        Update V1310
        WITH  fram F1310 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1310.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(pod_det) = ? THEN find first pod_det where 
                              pod_domain=V1001 and
pod_nbr=V1300 and 
/*pod_sched=yes AND */ INDEX("XC",Pod_STAT) = 0 AND Pod_TYPE <> "B" AND (Pod_SITE = "" OR Pod_SITE = V1002) AND  
                              pod_part >=  INPUT V1310
                               no-lock no-error.
                  else do: 
                       if pod_part =  INPUT V1310
                       then find next pod_det
                       WHERE pod_domain=V1001 and
pod_nbr=V1300 and 
/*pod_sched=yes AND */ INDEX("XC",Pod_STAT) = 0 AND Pod_TYPE <> "B" AND (Pod_SITE = "" OR Pod_SITE = V1002)
                        no-lock no-error.
                        else find first pod_det where 
                              pod_domain=V1001 and
pod_nbr=V1300 and 
/*pod_sched=yes AND */ INDEX("XC",Pod_STAT) = 0 AND Pod_TYPE <> "B" AND (Pod_SITE = "" OR Pod_SITE = V1002) AND  
                              pod_part >=  INPUT V1310
                               no-lock no-error.
                  end.
                  IF AVAILABLE pod_det then display skip 
            pod_part @ V1310 (pod_nbr) + "/" + trim( pod_part) @ WMESSAGE NO-LABEL with fram F1310.
                  else   display skip "" @ WMESSAGE with fram F1310.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(pod_det) = ? THEN find last pod_det where 
                              pod_domain=V1001 and
pod_nbr=V1300 and 
/*pod_sched=yes AND */ INDEX("XC",Pod_STAT) = 0 AND Pod_TYPE <> "B" AND (Pod_SITE = "" OR Pod_SITE = V1002) AND  
                              pod_part <=  INPUT V1310
                               no-lock no-error.
                  else do: 
                       if pod_part =  INPUT V1310
                       then find prev pod_det
                       where pod_domain=V1001 and
pod_nbr=V1300 and 
/*pod_sched=yes AND */ INDEX("XC",Pod_STAT) = 0 AND Pod_TYPE <> "B" AND (Pod_SITE = "" OR Pod_SITE = V1002)
                        no-lock no-error.
                        else find first pod_det where 
                              pod_domain=V1001 and
pod_nbr=V1300 and 
/*pod_sched=yes AND */ INDEX("XC",Pod_STAT) = 0 AND Pod_TYPE <> "B" AND (Pod_SITE = "" OR Pod_SITE = V1002) AND  
                              pod_part >=  INPUT V1310
                               no-lock no-error.
                  end.
                  IF AVAILABLE pod_det then display skip 
            pod_part @ V1310 (pod_nbr) + "/" + trim( pod_part) @ WMESSAGE NO-LABEL with fram F1310.
                  else   display skip "" @ WMESSAGE with fram F1310.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1310 = "e" THEN  LEAVE V1287LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1310.

         /*  ---- Valid Check ---- START */

        find first pt_mstr where pt_part= ENTRY(1,V1310,"@") and pt_domain=V1001 no-lock no-error.
If not avail pt_mstr then do:
display skip "件号不存在,请重新输入" @ WMESSAGE NO-LABEL with fram F1310.
                pause 0 before-hide.
                Undo, retry.

End.
find first pod_det where pod_part= ENTRY(1,V1310,"@") and pod_nbr=V1300 and pod_domain=V1001 and pod_site=V1002  and INDEX("XC",POd_STAT) = 0 AND POd_TYPE <> "B" no-lock no-error.
If not avail pod_det then do:
display skip "件号不在订单中,请重新输入" @ WMESSAGE NO-LABEL with fram F1310.
                pause 0 before-hide.
                Undo, retry.

End.
        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1310.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1310.
        pause 0.
        leave V1310L.
     END.
     IF INDEX(V1310,"@" ) = 0 then V1310 = V1310 + "@".
     PV1310 = V1310.
     V1310 = ENTRY(1,V1310,"@").
     /* END    LINE :1310  件号加批号[Raw Material lot]  */


     /* START  LINE :1312  L Control  */
     V1312L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1312           as char format "x(150)".
        define variable PV1312          as char format "x(150)".
        define variable L13121          as char format "x(40)".
        define variable L13122          as char format "x(40)".
        define variable L13123          as char format "x(40)".
        define variable L13124          as char format "x(40)".
        define variable L13125          as char format "x(40)".
        define variable L13126          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first pt_mstr where pt_domain = V1001 and pt_part = V1310  no-lock no-error.
If AVAILABLE ( pt_mstr ) then
        V1312 = pt_lot_ser.
        V1312 = ENTRY(1,V1312,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1312 = ENTRY(1,V1312,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1312L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1312L .
        /* --CYCLE TIME SKIP -- END  */

                display "[采购收货]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1312 width 150 no-box.

                /* LABEL 1 - START */ 
                  L13121 = "" . 
                display L13121          format "x(40)" skip with fram F1312 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L13122 = "" . 
                display L13122          format "x(40)" skip with fram F1312 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L13123 = "" . 
                display L13123          format "x(40)" skip with fram F1312 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13124 = "" . 
                display L13124          format "x(40)" skip with fram F1312 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1312 width 150 no-box.
        /* DISPLAY ONLY */
        define variable X1312           as char format "x(40)".
        X1312 = V1312.
        V1312 = "".
        /* DISPLAY ONLY */
        Update V1312
        WITH  fram F1312 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V1312 = X1312.
        /* DISPLAY ONLY */
        LEAVE V1312L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1312 = "e" THEN  LEAVE V1287LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1312.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1312.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1312.
        pause 0.
        leave V1312L.
     END.
     PV1312 = V1312.
     /* END    LINE :1312  L Control  */


     /* START  LINE :1314  批号[LOT]  */
     V1314L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1314           as char format "x(150)".
        define variable PV1314          as char format "x(150)".
        define variable L13141          as char format "x(40)".
        define variable L13142          as char format "x(40)".
        define variable L13143          as char format "x(40)".
        define variable L13144          as char format "x(40)".
        define variable L13145          as char format "x(40)".
        define variable L13146          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1314 = t_v100[2].
        V1314 = ENTRY(1,V1314,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1314 = ENTRY(1,V1314,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        if looa="Y" then leave V1314L.
IF t_v100[2]<>"" THEN
        leave V1314L.
        /* LOGICAL SKIP END */
                display "[采购收货]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1314 width 150 no-box.

                /* LABEL 1 - START */ 
                L13141 = "批号?" .
                display L13141          format "x(40)" skip with fram F1314 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L13142 = "传票号" + V1290 .
                display L13142          format "x(40)" skip with fram F1314 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L13143 = "PO号" + V1300 .
                display L13143          format "x(40)" skip with fram F1314 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L13144 = "件号:" + V1310 .
                display L13144          format "x(40)" skip with fram F1314 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1314 width 150 no-box.
        Update V1314
        WITH  fram F1314 NO-LABEL
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
        IF V1314 = "e" THEN  LEAVE V1287LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1314.

         /*  ---- Valid Check ---- START */

        if length(trim(V1314))>18  then do:
display skip "批号长度不能大于18位,请重新输入" @ WMESSAGE NO-LABEL with fram F1314.
                pause 0 before-hide.
                undo, retry.

end.
        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1314.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1314.
        pause 0.
        leave V1314L.
     END.
     PV1314 = V1314.
     /* END    LINE :1314  批号[LOT]  */


     /* START  LINE :1316  采购项次 SKIP ONLY ONE  */
     V1316L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1316           as char format "x(150)".
        define variable PV1316          as char format "x(150)".
        define variable L13161          as char format "x(40)".
        define variable L13162          as char format "x(40)".
        define variable L13163          as char format "x(40)".
        define variable L13164          as char format "x(40)".
        define variable L13165          as char format "x(40)".
        define variable L13166          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first pod_det where pod_domain = V1001 and pod_nbr = V1300  and
pod_part=V1310 and pod_site = V1002 and index("XC",pod_status) = 0 and pod_type = "" /*and pod_sched =yes */ no-lock no-error.
If AVAILABLE (pod_det) and string ( pod_line ) <> V1316 then
        V1316 = string ( pod_line ).
        V1316 = ENTRY(1,V1316,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1316 = ENTRY(1,V1316,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        if looa="Y" then leave V1316L.
Find last pod_det where pod_domain = V1001 and pod_nbr = V1300  and pod_part=V1310 and pod_site = V1002 and index("XC",pod_status) = 0 and pod_type = "" /*and  pod_sched =yes */ no-lock no-error.
If AVAILABLE (pod_det) and string ( pod_line ) = V1316 then
        leave V1316L.
        /* LOGICAL SKIP END */
                display "[采购收货]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1316 width 150 no-box.

                /* LABEL 1 - START */ 
                L13161 = "采购项次?" .
                display L13161          format "x(40)" skip with fram F1316 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L13162 = "传票号" + V1290 .
                display L13162          format "x(40)" skip with fram F1316 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L13163 = "PO号" + V1300 .
                display L13163          format "x(40)" skip with fram F1316 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L13164 = "件号" + V1310 .
                display L13164          format "x(40)" skip with fram F1316 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1316 width 150 no-box.
        recid(pod_det) = ?.
        Update V1316
        WITH  fram F1316 NO-LABEL
        /* ROLL BAR START */
        EDITING:
        readkey pause wtimeout.
        if lastkey = -1 then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
        display skip "^" @ WMESSAGE NO-LABEL with fram F1316.
            IF LASTKEY = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"
            THEN DO:
                  IF recid(pod_det) = ? THEN find first pod_det where 
                              pod_domain = V1001 and pod_nbr = V1300 and 
pod_part=V1310 and
pod_site = V1002 and index( "XC",pod_status ) = 0  and pod_type = "" /*and pod_sched =yes*/ AND  
                              string ( POD_LINE ) >=  INPUT V1316
                               no-lock no-error.
                  else do: 
                       if string ( POD_LINE ) =  INPUT V1316
                       then find next pod_det
                       WHERE pod_domain = V1001 and pod_nbr = V1300 and 
pod_part=V1310 and
pod_site = V1002 and index( "XC",pod_status ) = 0  and pod_type = "" /*and pod_sched =yes*/
                        no-lock no-error.
                        else find first pod_det where 
                              pod_domain = V1001 and pod_nbr = V1300 and 
pod_part=V1310 and
pod_site = V1002 and index( "XC",pod_status ) = 0  and pod_type = "" /*and pod_sched =yes*/ AND  
                              string ( POD_LINE ) >=  INPUT V1316
                               no-lock no-error.
                  end.
                  IF AVAILABLE pod_det then display skip 
            string ( POD_LINE ) @ V1316 trim(POD_PART) + "*" + String( POD_DUE_DATE) + "*" + string ( if ( pod_qty_ord - pod_qty_rcvd ) > 0 then ( pod_qty_ord - pod_qty_rcvd ) else 0 ) @ WMESSAGE NO-LABEL with fram F1316.
                  else   display skip "" @ WMESSAGE with fram F1316.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(pod_det) = ? THEN find last pod_det where 
                              pod_domain = V1001 and pod_nbr = V1300 and 
pod_part=V1310 and
pod_site = V1002 and index( "XC",pod_status ) = 0  and pod_type = "" /*and pod_sched =yes*/ AND  
                              string ( POD_LINE ) <=  INPUT V1316
                               no-lock no-error.
                  else do: 
                       if string ( POD_LINE ) =  INPUT V1316
                       then find prev pod_det
                       where pod_domain = V1001 and pod_nbr = V1300 and 
pod_part=V1310 and
pod_site = V1002 and index( "XC",pod_status ) = 0  and pod_type = "" /*and pod_sched =yes*/
                        no-lock no-error.
                        else find first pod_det where 
                              pod_domain = V1001 and pod_nbr = V1300 and 
pod_part=V1310 and
pod_site = V1002 and index( "XC",pod_status ) = 0  and pod_type = "" /*and pod_sched =yes*/ AND  
                              string ( POD_LINE ) >=  INPUT V1316
                               no-lock no-error.
                  end.
                  IF AVAILABLE pod_det then display skip 
            string ( POD_LINE ) @ V1316 trim(POD_PART) + "*" + String( POD_DUE_DATE) + "*" + string ( if ( pod_qty_ord - pod_qty_rcvd ) > 0 then ( pod_qty_ord - pod_qty_rcvd ) else 0 ) @ WMESSAGE NO-LABEL with fram F1316.
                  else   display skip "" @ WMESSAGE with fram F1316.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1316 = "e" THEN  LEAVE V1287LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1316.

         /*  ---- Valid Check ---- START */

        find first pod_det where POd_DOMAIN = V1001 AND pod_nbr=V1300 and
pod_part=V1310 and 
INDEX("XC",POd_STAT) = 0 AND POd_TYPE <> "B" AND (POd_SITE = "" OR POd_SITE = V1002) /*and pod_sched=yes*/ no-lock no-error.
If not avail pod_det then do:
                display skip "项次不存在,请重新输入" @ WMESSAGE NO-LABEL with fram F1316.
                pause 0 before-hide.
                Undo, retry.
End.
        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1316.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1316.
        pause 0.
        leave V1316L.
     END.
     PV1316 = V1316.
     /* END    LINE :1316  采购项次 SKIP ONLY ONE  */


     /* START  LINE :1318  采购币别  */
     V1318L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1318           as char format "x(150)".
        define variable PV1318          as char format "x(150)".
        define variable L13181          as char format "x(40)".
        define variable L13182          as char format "x(40)".
        define variable L13183          as char format "x(40)".
        define variable L13184          as char format "x(40)".
        define variable L13185          as char format "x(40)".
        define variable L13186          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first po_mstr where po_domain = V1001 and po_nbr = V1300  no-lock no-error.
If AVAILABLE (po_mstr) then
        V1318 = trim( po_curr ).
        V1318 = ENTRY(1,V1318,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1318 = ENTRY(1,V1318,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1318L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1318L .
        /* --CYCLE TIME SKIP -- END  */

                display "[采购收货]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1318 width 150 no-box.

                /* LABEL 1 - START */ 
                  L13181 = "" . 
                display L13181          format "x(40)" skip with fram F1318 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L13182 = "" . 
                display L13182          format "x(40)" skip with fram F1318 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L13183 = "" . 
                display L13183          format "x(40)" skip with fram F1318 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13184 = "" . 
                display L13184          format "x(40)" skip with fram F1318 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1318 width 150 no-box.
        /* DISPLAY ONLY */
        define variable X1318           as char format "x(40)".
        X1318 = V1318.
        V1318 = "".
        /* DISPLAY ONLY */
        Update V1318
        WITH  fram F1318 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V1318 = X1318.
        /* DISPLAY ONLY */
        LEAVE V1318L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1318 = "e" THEN  LEAVE V1287LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1318.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1318.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1318.
        pause 0.
        leave V1318L.
     END.
     PV1318 = V1318.
     /* END    LINE :1318  采购币别  */


     /* START  LINE :1320  本位币别  */
     V1320L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1320           as char format "x(150)".
        define variable PV1320          as char format "x(150)".
        define variable L13201          as char format "x(40)".
        define variable L13202          as char format "x(40)".
        define variable L13203          as char format "x(40)".
        define variable L13204          as char format "x(40)".
        define variable L13205          as char format "x(40)".
        define variable L13206          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first gl_ctrl where gl_domain = V1001 no-lock no-error.
If AVAILABLE (gl_ctrl) then
        V1320 = trim( gl_base_curr ).
        V1320 = ENTRY(1,V1320,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1320 = ENTRY(1,V1320,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1320L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1320L .
        /* --CYCLE TIME SKIP -- END  */

                display "[采购收货]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1320 width 150 no-box.

                /* LABEL 1 - START */ 
                  L13201 = "" . 
                display L13201          format "x(40)" skip with fram F1320 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L13202 = "" . 
                display L13202          format "x(40)" skip with fram F1320 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L13203 = "" . 
                display L13203          format "x(40)" skip with fram F1320 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13204 = "" . 
                display L13204          format "x(40)" skip with fram F1320 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1320 width 150 no-box.
        /* DISPLAY ONLY */
        define variable X1320           as char format "x(40)".
        X1320 = V1320.
        V1320 = "".
        /* DISPLAY ONLY */
        Update V1320
        WITH  fram F1320 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V1320 = X1320.
        /* DISPLAY ONLY */
        LEAVE V1320L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1320 = "e" THEN  LEAVE V1287LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1320.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1320.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1320.
        pause 0.
        leave V1320L.
     END.
     PV1320 = V1320.
     /* END    LINE :1320  本位币别  */


     /* START  LINE :1322  固定汇率 = Y 不跳出  */
     V1322L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1322           as char format "x(150)".
        define variable PV1322          as char format "x(150)".
        define variable L13221          as char format "x(40)".
        define variable L13222          as char format "x(40)".
        define variable L13223          as char format "x(40)".
        define variable L13224          as char format "x(40)".
        define variable L13225          as char format "x(40)".
        define variable L13226          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first po_mstr where po_domain = V1001 and po_nbr = V1300  no-lock no-error.
If AVAILABLE (po_mstr) then
        V1322 = if po_fix_rate = yes then "Y" else "N".
        V1322 = ENTRY(1,V1322,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1322 = ENTRY(1,V1322,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1322L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1322L .
        /* --CYCLE TIME SKIP -- END  */

                display "[采购收货]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1322 width 150 no-box.

                /* LABEL 1 - START */ 
                  L13221 = "" . 
                display L13221          format "x(40)" skip with fram F1322 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L13222 = "" . 
                display L13222          format "x(40)" skip with fram F1322 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L13223 = "" . 
                display L13223          format "x(40)" skip with fram F1322 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13224 = "" . 
                display L13224          format "x(40)" skip with fram F1322 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1322 width 150 no-box.
        /* DISPLAY ONLY */
        define variable X1322           as char format "x(40)".
        X1322 = V1322.
        V1322 = "".
        /* DISPLAY ONLY */
        Update V1322
        WITH  fram F1322 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V1322 = X1322.
        /* DISPLAY ONLY */
        LEAVE V1322L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1322 = "e" THEN  LEAVE V1287LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1322.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1322.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1322.
        pause 0.
        leave V1322L.
     END.
     PV1322 = V1322.
     /* END    LINE :1322  固定汇率 = Y 不跳出  */


     /* START  LINE :1324  供应商  */
     V1324L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1324           as char format "x(150)".
        define variable PV1324          as char format "x(150)".
        define variable L13241          as char format "x(40)".
        define variable L13242          as char format "x(40)".
        define variable L13243          as char format "x(40)".
        define variable L13244          as char format "x(40)".
        define variable L13245          as char format "x(40)".
        define variable L13246          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first po_mstr where po_domain = V1001 and po_nbr = V1300  no-lock no-error.
If AVAILABLE (po_mstr) then
        V1324 = po_vend.
        V1324 = ENTRY(1,V1324,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1324 = ENTRY(1,V1324,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1324L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1324L .
        /* --CYCLE TIME SKIP -- END  */

                display "[采购收货]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1324 width 150 no-box.

                /* LABEL 1 - START */ 
                L13241 = "Vendor" .
                display L13241          format "x(40)" skip with fram F1324 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L13242 = "" . 
                display L13242          format "x(40)" skip with fram F1324 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L13243 = "" . 
                display L13243          format "x(40)" skip with fram F1324 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13244 = "" . 
                display L13244          format "x(40)" skip with fram F1324 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1324 width 150 no-box.
        Update V1324
        WITH  fram F1324 NO-LABEL
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
        IF V1324 = "e" THEN  LEAVE V1287LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1324.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1324.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1324.
        pause 0.
        leave V1324L.
     END.
     PV1324 = V1324.
     /* END    LINE :1324  供应商  */


     /* START  LINE :1326  生效日期  */
     V1326L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1326           as char format "x(150)".
        define variable PV1326          as char format "x(150)".
        define variable L13261          as char format "x(40)".
        define variable L13262          as char format "x(40)".
        define variable L13263          as char format "x(40)".
        define variable L13264          as char format "x(40)".
        define variable L13265          as char format "x(40)".
        define variable L13266          as char format "x(40)".
        define variable D1326           as date .
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1326 = t_v100[11].
        D1326 = Date ( V1326).
        V1326 = ENTRY(1,V1326,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1326 = ENTRY(1,V1326,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        if looa="Y" then leave V1326L.
        leave V1326L.
        /* LOGICAL SKIP END */
                display "[采购收货]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1326 width 150 no-box.

                /* LABEL 1 - START */ 
                L13261 = "收货日期?" .
                display L13261          format "x(40)" skip with fram F1326 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L13262 = "" . 
                display L13262          format "x(40)" skip with fram F1326 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L13263 = "" . 
                display L13263          format "x(40)" skip with fram F1326 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13264 = "" . 
                display L13264          format "x(40)" skip with fram F1326 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1326 width 150 no-box.
        Update D1326
        WITH  fram F1326 NO-LABEL
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
        IF V1326 = "e" THEN  LEAVE V1287LMAINLOOP.
        V1326 = string ( D1326).
        display  skip WMESSAGE NO-LABEL with fram F1326.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1326.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1326.
        pause 0.
        leave V1326L.
     END.
     PV1326 = V1326.
     /* END    LINE :1326  生效日期  */


     /* START  LINE :1328  发货日期  */
     V1328L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1328           as char format "x(150)".
        define variable PV1328          as char format "x(150)".
        define variable L13281          as char format "x(40)".
        define variable L13282          as char format "x(40)".
        define variable L13283          as char format "x(40)".
        define variable L13284          as char format "x(40)".
        define variable L13285          as char format "x(40)".
        define variable L13286          as char format "x(40)".
        define variable D1328           as date .
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1328 = t_v1326.
        D1328 = Date ( V1328).
        V1328 = ENTRY(1,V1328,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V1328 = PV1328 .
         If sectionid > 1 Then 
        D1328 = Date ( V1328).
        V1328 = ENTRY(1,V1328,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1328L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1328L .
        /* --CYCLE TIME SKIP -- END  */

                display "[采购收货]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1328 width 150 no-box.

                /* LABEL 1 - START */ 
                L13281 = "发货日期?" .
                display L13281          format "x(40)" skip with fram F1328 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L13282 = string ( today ) .
                display L13282          format "x(40)" skip with fram F1328 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L13283 = "" . 
                display L13283          format "x(40)" skip with fram F1328 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L13284 = "" . 
                display L13284          format "x(40)" skip with fram F1328 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1328 width 150 no-box.
        /* DISPLAY ONLY */
        define variable X1328           as char format "x(40)".
        X1328 = V1328.
        V1328 = "".
        /* DISPLAY ONLY */
        Update D1328
        WITH  fram F1328 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V1328 = X1328.
        /* DISPLAY ONLY */
        LEAVE V1328L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1328 = "e" THEN  LEAVE V1287LMAINLOOP.
        V1328 = string ( D1328).
        display  skip WMESSAGE NO-LABEL with fram F1328.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1328.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1328.
        pause 0.
        leave V1328L.
     END.
     PV1328 = V1328.
     /* END    LINE :1328  发货日期  */


     /* START  LINE :1400  库位[LOC] - INSP  */
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
        if looa="Y" then leave V1400L.
        leave V1400L.
        /* LOGICAL SKIP END */
                display "[采购收货]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1400 width 150 no-box.

                /* LABEL 1 - START */ 
                L14001 = "库位?" + " " + V1290 .
                display L14001          format "x(40)" skip with fram F1400 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L14002 = "PO:" + trim( V1300 ) + "/" + V1316 + "/" + trim( V1324 ) .
                display L14002          format "x(40)" skip with fram F1400 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L14003 = "件号" + trim( V1310 ) .
                display L14003          format "x(40)" skip with fram F1400 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L14004 = "批号" + Trim(V1314) .
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
        IF V1400 = "e" THEN  LEAVE V1287LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1400.

         /*  ---- Valid Check ---- START */

        find first loc_mstr where loc_DOMAIN = V1001 and loc_SITE =V1002 AND loc_loc=V1400 use-index loc_loc  no-lock no-error no-wait.
If not avail loc_mstr then do:
                display skip "库位不存在,请重新输入" @ WMESSAGE NO-LABEL with fram F1400.
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
     /* END    LINE :1400  库位[LOC] - INSP  */


     /* START  LINE :1550  单位换算比例[UM FACTOR]  */
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
        find first pod_det where pod_domain = V1001 and pod_nbr = V1300 and  string ( pod_line ) = V1316 and pod_type = ""
/*and pod_sched=yes */ no-lock no-error.
If AVAILABLE (pod_det) then
        V1550 = string ( pod_um_conv ).
        V1550 = ENTRY(1,V1550,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1550 = ENTRY(1,V1550,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        find first pod_det where pod_domain = V1001 and  pod_nbr = V1300 and string( pod_line)  = V1316   and pod_type = "" /*and po_sched=yes */ no-lock no-error.
If AVAILABLE (pod_det) and pod_um_conv = 1 then
        leave V1550L.
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1550L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1550L .
        /* --CYCLE TIME SKIP -- END  */

                display "[采购收货]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1550 width 150 no-box.

                /* LABEL 1 - START */ 
                L15501 = "件号" + trim( V1310 ) .
                display L15501          format "x(40)" skip with fram F1550 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find first pod_det where pod_domain = V1001 and pod_nbr = V1300 and string( pod_line)  = V1316 and pod_type = "" and pod_sched=yes  no-lock no-error.
If AVAILABLE (pod_det) then
                L15502 = "采购单位:" + pod_um .
                else L15502 = "" . 
                display L15502          format "x(40)" skip with fram F1550 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first pod_det where pod_domain = V1001 and pod_nbr = V1300 and string( pod_line)  = V1316  and pod_type = ""  and pod_sched=yes no-lock no-error.
If AVAILABLE (pod_det) then
                L15503 = "转换比例:" + string (pod_um_conv) .
                else L15503 = "" . 
                display L15503          format "x(40)" skip with fram F1550 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                find first pt_mstr where pt_domain = V1001 and pt_part = V1310 no-lock no-error.
If AVAILABLE (pt_mstr) then
                L15504 = "库存单位:" + pt_um .
                else L15504 = "" . 
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
        IF V1550 = "e" THEN  LEAVE V1287LMAINLOOP.
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
     /* END    LINE :1550  单位换算比例[UM FACTOR]  */


     /* START  LINE :1558  容差後最多收货数 (支控制数量容差,金额容差=最大)  */
     V1558L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1558           as char format "x(150)".
        define variable PV1558          as char format "x(150)".
        define variable L15581          as char format "x(40)".
        define variable L15582          as char format "x(40)".
        define variable L15583          as char format "x(40)".
        define variable L15584          as char format "x(40)".
        define variable L15585          as char format "x(40)".
        define variable L15586          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first poc_ctrl where poc_domain = V1001  no-lock no-error.
If AVAILABLE (poc_ctrl) then
        V1558 = string ( ( poc_tol_pct / 100  + 1 ) *  pod_qty_ord  - pod_qty_rcvd  ).
        V1558 = ENTRY(1,V1558,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1558 = ENTRY(1,V1558,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1558L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1558L .
        /* --CYCLE TIME SKIP -- END  */

                display "[采购收货]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1558 width 150 no-box.

                /* LABEL 1 - START */ 
                find first poc_ctrl where poc_domain = V1001   no-lock no-error.
If AVAILABLE (poc_ctrl) then
                L15581 = string ( ( poc_tol_pct / 100 + 1 ) * ( pod_qty_ord - pod_qty_rcvd ) ) .
                else L15581 = "" . 
                display L15581          format "x(40)" skip with fram F1558 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L15582 = "" . 
                display L15582          format "x(40)" skip with fram F1558 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L15583 = "" . 
                display L15583          format "x(40)" skip with fram F1558 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L15584 = "" . 
                display L15584          format "x(40)" skip with fram F1558 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1558 width 150 no-box.
        /* DISPLAY ONLY */
        define variable X1558           as char format "x(40)".
        X1558 = V1558.
        V1558 = "".
        /* DISPLAY ONLY */
        Update V1558
        WITH  fram F1558 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V1558 = X1558.
        /* DISPLAY ONLY */
        LEAVE V1558L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1558 = "e" THEN  LEAVE V1287LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1558.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1558.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1558.
        pause 0.
        leave V1558L.
     END.
     PV1558 = V1558.
     /* END    LINE :1558  容差後最多收货数 (支控制数量容差,金额容差=最大)  */


     /* START  LINE :1600  数量[QTY](采购单UM)  */
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
        V1600 = t_v100[5].
        V1600 = ENTRY(1,V1600,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1600 = ENTRY(1,V1600,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        if looa="Y" then leave V1600L.
        leave V1600L.
        /* LOGICAL SKIP END */
                display "[采购收货]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1600 width 150 no-box.

                /* LABEL 1 - START */ 
                L16001 = "收货数量?" + " " + V1290 .
                display L16001          format "x(40)" skip with fram F1600 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L16002 = "PO:" + trim( V1300 ) + "/" + V1316 + "/" + trim( V1324 ) .
                display L16002          format "x(40)" skip with fram F1600 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L16003 = "件号" + trim( V1310 ) .
                display L16003          format "x(40)" skip with fram F1600 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L16004 = "批号" + Trim(V1314) .
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
        IF V1600 = "e" THEN  LEAVE V1287LMAINLOOP.
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
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1600.
        pause 0.
        leave V1600L.
     END.
     PV1600 = V1600.
     /* END    LINE :1600  数量[QTY](采购单UM)  */


     /* START  LINE :1610  库存单位数量  */
     V1610L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1610           as char format "x(150)".
        define variable PV1610          as char format "x(150)".
        define variable L16101          as char format "x(40)".
        define variable L16102          as char format "x(40)".
        define variable L16103          as char format "x(40)".
        define variable L16104          as char format "x(40)".
        define variable L16105          as char format "x(40)".
        define variable L16106          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first pod_det where pod_domain = V1001 and pod_nbr = V1300 and  string ( pod_line ) = V1316 /*and pod_sched=yes*/ no-lock no-error.
If AVAILABLE (pod_det) then
        V1610 = string ( pod_um_conv * decimal( V1600 ) ).
        V1610 = ENTRY(1,V1610,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1610 = ENTRY(1,V1610,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        find first pod_det where pod_domain = V1001 and pod_nbr = V1300 and string( pod_line)  = V1316 /*and pod_sched=yes*/  no-lock no-error.
If AVAILABLE (pod_det) and pod_um_conv = 1 then
        leave V1610L.
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1610L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1610L .
        /* --CYCLE TIME SKIP -- END  */

                display "[采购收货]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1610 width 150 no-box.

                /* LABEL 1 - START */ 
                find first pod_det where pod_domain = V1001 and pod_nbr = V1300 and string( pod_line)  = V1316  /*and pod_sched=yes*/  no-lock no-error.
If AVAILABLE (pod_det) then
                L16101 = "收货数量:" + string (V1600 ) + " " + pod_um .
                else L16101 = "" . 
                display L16101          format "x(40)" skip with fram F1610 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L16102 = "转换因子# 1:" + V1550 .
                display L16102          format "x(40)" skip with fram F1610 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first pt_mstr where pt_domain = V1001 and pt_part = V1310 no-lock no-error.
If AVAILABLE (pt_mstr) THEN
                L16103 = "库存数量:" + string ( decimal ( V1550 ) * decimal ( V1600 ) ) + " " + trim ( pt_um ) .
                else L16103 = "" . 
                display L16103          format "x(40)" skip with fram F1610 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L16104 = "" . 
                display L16104          format "x(40)" skip with fram F1610 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1610 width 150 no-box.
        /* DISPLAY ONLY */
        define variable X1610           as char format "x(40)".
        X1610 = V1610.
        V1610 = "".
        /* DISPLAY ONLY */
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
        V1610 = X1610.
        /* DISPLAY ONLY */
        LEAVE V1610L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1610 = "e" THEN  LEAVE V1287LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1610.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1610.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1610.
        pause 0.
        leave V1610L.
     END.
     PV1610 = V1610.
     /* END    LINE :1610  库存单位数量  */


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
                display "[采购收货]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1700 width 150 no-box.

                /* LABEL 1 - START */ 
                L17001 = "PO:" + trim( V1300 ) + "/" + V1316 + "/" + V1324 .
                display L17001          format "x(40)" skip with fram F1700 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L17002 = "件号" + trim( V1310 ) .
                display L17002          format "x(40)" skip with fram F1700 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L17003 = "库位:" + trim ( V1400 ) + "/" + trim( V1600 ) .
                display L17003          format "x(40)" skip with fram F1700 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                def var tqty like pod_qty_ord.
Def var tstr like sch_rlse_id.
Def var tflag as char. 
Tqty=0.
tflag="".
tstr="".
find first pod_det where pod_domain = V1001 and pod_part=V1310 and pod_nbr = V1300 and  string ( pod_line ) = V1316 /*and pod_sched=yes*/ use-index pod_part no-lock no-error no-wait.
If AVAILABLE (pod_det) then do:
 tstr=pod_curr_rlse_id[1].
 Tqty=pod_cum_qty[1].
L17004="未结数量:" + string ( pod_qty_ord - pod_qty_rcvd ).
If pod_sched=yes then tflag="S" .
Else tflag="N".
End.
Def var ttqty like pod_qty_ord.
If tflag="S" then do:
Ttqty=0.
find last schd_det no-lock
   where schd_domain=V1001 
   and schd_type = 4
   and schd_nbr = V1300
   and string(schd_line) = V1316
   and schd_rlse_id = tstr
  .
If avail schd_det then do:
ttqty=schd_cum_qty.
End.
L17004="未结数量:" + string ( ttqty - tqty ).
End.
If L17004<>"" then
                L17004 = L17004 .
                else L17004 = "" . 
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
        IF V1700 = "e" THEN  LEAVE V1287LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1700.

         /*  ---- Valid Check ---- START */

        find first po_mstr where PO_DOMAIN = V1001 and po_nbr=ENTRY(1,V1300,"@") AND INDEX("XC",PO_STAT) = 0 AND PO_TYPE <> "B" AND (PO_SITE = "" OR PO_SITE = V1002) /*and po_sched=yes*/  use-index po_nbr no-lock no-error  no-wait.
If not avail po_mstr then do:
                display skip "订单不存在,请查" @ WMESSAGE NO-LABEL with fram F1700.
                pause 0 before-hide.
                Undo, retry.
End.
Find first pt_mstr where  pt_domain=V1001 and pt_part= ENTRY(1,V1310,"@") use-index pt_part no-lock no-error  no-wait.
If not avail pt_mstr then do:
display skip "件号不存在,请查" @ WMESSAGE NO-LABEL with fram F1700.
                pause 0 before-hide.
                Undo, retry.

End.
Find first pod_det where pod_domain=V1001 and pod_part= ENTRY(1,V1310,"@")  and pod_nbr=V1300  and string(pod_line)=V1316 and pod_site=V1002  and INDEX("XC",Pod_STAT) = 0 AND Pod_TYPE <> "B" use-index pod_part no-lock no-error  no-wait.
If not avail pod_det then do:
display skip "件号不在订单中,请查" @ WMESSAGE NO-LABEL with fram F1700.
                pause 0 before-hide.
                Undo, retry.

End.
find first loc_mstr where loc_DOMAIN = V1001 and loc_SITE =V1002 AND loc_loc=V1400  use-index loc_loc no-lock no-error  no-wait.
If not avail loc_mstr then do:
                display skip "库位不存在,请查" @ WMESSAGE NO-LABEL with fram F1700.
                pause 0 before-hide.
                Undo, retry.
End.
/*find first pod_det where POd_DOMAIN = V1001 AND pod_part=V1310 and pod_nbr=V1300 and
 
INDEX("XC",POd_STAT) = 0 AND POd_TYPE <> "B" AND (POd_SITE = "" OR POd_SITE = V1002) /*and pod_sched=yes*/ no-lock no-error no-wait.
If not avail pod_det then do:
                display skip "项次不存在,请查" @ WMESSAGE NO-LABEL with fram F1700.
                pause 0 before-hide.
                Undo, retry.
End. */
IF V1700="N" then 
looa="N".
IF V1700="N" then
leave submain.
        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1700.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        IF not (V1700="Y" or V1700="E" or V1700="N") THEN DO:
                display skip "只能按Y,E,N" @ WMESSAGE NO-LABEL with fram F1700.
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

                display "[采购收货]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9000 width 150 no-box.

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
        IF V9000 = "e" THEN  LEAVE V1287LMAINLOOP.
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
      mfguser = V1287. /* ching add */ 
     {xspor03u.i}
     /*  Update MFG/PRO END  */ 
        display  "" NO-LABEL with fram F9000X width 150 no-box .
        pause 0.
     /* START  LINE :9005  取2位小数点/ Blank Expire Date  */
     V9005L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V9005           as char format "x(150)".
        define variable PV9005          as char format "x(150)".
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
        /*{xspo3s.i}*/
IF 1 = 1 THEN
        leave V9005L.
        /* LOGICAL SKIP END */
                display "[采购收货]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9005 width 150 no-box.

                /* LABEL 1 - START */ 
                  L90051 = "" . 
                display L90051          format "x(40)" skip with fram F9005 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L90052 = "" . 
                display L90052          format "x(40)" skip with fram F9005 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L90053 = "" . 
                display L90053          format "x(40)" skip with fram F9005 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L90054 = "" . 
                display L90054          format "x(40)" skip with fram F9005 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F9005 width 150 no-box.
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
        IF V9005 = "e" THEN  LEAVE V1287LMAINLOOP.
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
     /* END    LINE :9005  取2位小数点/ Blank Expire Date  */


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
                display "[采购收货]"        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9010 width 150 no-box.

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
/*	AND tr_batch= V1287		                 
*/
AND tr_program = "xspor03.p"
				 and tr_nbr  = V1300 
				 and  tr_type = "RCT-PO"
				 and tr_site = V1002  
				 and  tr_part = V1310 
				 and tr_serial = V1314
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
			 L90102 = "交易号:" + trim(string(tr_trnbr)) + "/" + trim(tr_lot) .               
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
        IF V9010 = "e" THEN  LEAVE V1287LMAINLOOP.
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
   LEAVE V1287LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :9010    */
   END.
   pause 0 before-hide.
end.
