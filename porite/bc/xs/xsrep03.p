/* Generate By Barcode Generator , Copyright by Softspeed - Build By Sam Song  */ 
/* Allocation To Shop Floor */
/* Generate date / time  2011-3-18 11:31:16 */
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
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xsrep03wtimeout"
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
                display "[备料转车间]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 width 150 no-box.

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


     /* START  LINE :1100  领料单[ORDER]  */
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

        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1100L .
        /* --CYCLE TIME SKIP -- END  */

                display "[备料转车间]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1100 width 150 no-box.

                /* LABEL 1 - START */ 
                L11001 = "领料单?" .
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
        recid(LAD_DET) = ?.
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
                  IF recid(LAD_DET) = ? THEN find first LAD_DET where 
                              lad_domain = V1001 and lad_dataset ="rps_det"  and substring(lad_nbr,1,8) = V1002 AND  
                              trim( substring(lad_nbr,9,10) ) >=  INPUT V1100
                               no-lock no-error.
                  else do: 
                       if trim( substring(lad_nbr,9,10) ) =  INPUT V1100
                       then find next LAD_DET
                       WHERE lad_domain = V1001 and lad_dataset ="rps_det"  and substring(lad_nbr,1,8) = V1002
                        no-lock no-error.
                        else find first LAD_DET where 
                              lad_domain = V1001 and lad_dataset ="rps_det"  and substring(lad_nbr,1,8) = V1002 AND  
                              trim( substring(lad_nbr,9,10) ) >=  INPUT V1100
                               no-lock no-error.
                  end.
                  IF AVAILABLE LAD_DET then display skip 
            trim( substring(lad_nbr,9,10) ) @ V1100 trim ( substring(lad_nbr,9,10)) + "*" + lad_line @ WMESSAGE NO-LABEL with fram F1100.
                  else   display skip "" @ WMESSAGE with fram F1100.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(LAD_DET) = ? THEN find last LAD_DET where 
                              lad_domain = V1001 and lad_dataset ="rps_det"  and substring(lad_nbr,1,8) = V1002 AND  
                              trim( substring(lad_nbr,9,10) ) <=  INPUT V1100
                               no-lock no-error.
                  else do: 
                       if trim( substring(lad_nbr,9,10) ) =  INPUT V1100
                       then find prev LAD_DET
                       where lad_domain = V1001 and lad_dataset ="rps_det"  and substring(lad_nbr,1,8) = V1002
                        no-lock no-error.
                        else find first LAD_DET where 
                              lad_domain = V1001 and lad_dataset ="rps_det"  and substring(lad_nbr,1,8) = V1002 AND  
                              trim( substring(lad_nbr,9,10) ) >=  INPUT V1100
                               no-lock no-error.
                  end.
                  IF AVAILABLE LAD_DET then display skip 
            trim( substring(lad_nbr,9,10) ) @ V1100 trim ( substring(lad_nbr,9,10)) + "*" + lad_line @ WMESSAGE NO-LABEL with fram F1100.
                  else   display skip "" @ WMESSAGE with fram F1100.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1100 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1100.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first LAD_DET where lad_domain = V1001 and lad_dataset ="rps_det"  and substring(lad_nbr,1,8) = V1002 and trim ( substring(lad_nbr,9,10)) = V1100  no-lock no-error.
        IF NOT AVAILABLE LAD_DET then do:
                display skip "领料单已结或有误" @ WMESSAGE NO-LABEL with fram F1100.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        leave V1100L.
     END.
     PV1100 = V1100.
     /* END    LINE :1100  领料单[ORDER]  */


     /* START  LINE :1105  生产线[Production Line]  */
     V1105L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1105           as char format "x(150)".
        define variable PV1105          as char format "x(150)".
        define variable L11051          as char format "x(40)".
        define variable L11052          as char format "x(40)".
        define variable L11053          as char format "x(40)".
        define variable L11054          as char format "x(40)".
        define variable L11055          as char format "x(40)".
        define variable L11056          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        find first lad_det where lad_domain = V1001 and lad_dataset ="rps_det"  and substring(lad_nbr,1,8) = V1002 and trim ( substring(lad_nbr,9,10)) = V1100 no-lock no-error.
If AVAILABLE ( lad_det ) then
        V1105 = lad_line.
        V1105 = ENTRY(1,V1105,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1105 = ENTRY(1,V1105,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1105L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1105L .
        /* --CYCLE TIME SKIP -- END  */

                display "[备料转车间]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1105 width 150 no-box.

                /* LABEL 1 - START */ 
                L11051 = "生产线?" .
                display L11051          format "x(40)" skip with fram F1105 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11052 = "" . 
                display L11052          format "x(40)" skip with fram F1105 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11053 = "" . 
                display L11053          format "x(40)" skip with fram F1105 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11054 = "" . 
                display L11054          format "x(40)" skip with fram F1105 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1105 width 150 no-box.
        Update V1105
        WITH  fram F1105 NO-LABEL
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
        IF V1105 = "e" THEN  LEAVE MAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1105.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1105.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1105.
        pause 0.
        leave V1105L.
     END.
     PV1105 = V1105.
     /* END    LINE :1105  生产线[Production Line]  */


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
                display "[备料转车间]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1290 width 150 no-box.

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
find first lad_det where  lad_domain = V1001 and lad_dataset ="rps_det"  and substring(lad_nbr,1,8) = V1002 and lad_part=ENTRY(1, V1290, "@") no-lock no-error no-wait.
If not avail lad_det then do:
display skip "已结或不在该领料单,请查" @ WMESSAGE NO-LABEL with fram F1290.
                pause 0 before-hide.
                Undo, retry.

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
                display "[备料转车间]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1300 width 150 no-box.

                /* LABEL 1 - START */ 
                L13001 = "件号?" .
                display L13001          format "x(40)" skip with fram F1300 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L13002 = "领料单:"  + trim ( V1100 ) .
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
        recid(LAD_DET) = ?.
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
                  IF recid(LAD_DET) = ? THEN find first LAD_DET where 
                              lad_domain = V1001 AND lad_dataset ="rps_det"  and substring(lad_nbr,1,8) = V1002 and trim ( substring(lad_nbr,9,10)) = V1100 AND  
                              LAD_PART >=  INPUT V1300
                               no-lock no-error.
                  else do: 
                       if LAD_PART =  INPUT V1300
                       then find next LAD_DET
                       WHERE lad_domain = V1001 AND lad_dataset ="rps_det"  and substring(lad_nbr,1,8) = V1002 and trim ( substring(lad_nbr,9,10)) = V1100
                        no-lock no-error.
                        else find first LAD_DET where 
                              lad_domain = V1001 AND lad_dataset ="rps_det"  and substring(lad_nbr,1,8) = V1002 and trim ( substring(lad_nbr,9,10)) = V1100 AND  
                              LAD_PART >=  INPUT V1300
                               no-lock no-error.
                  end.
                  IF AVAILABLE LAD_DET then display skip 
            LAD_PART @ V1300 "未结数量:" + trim( string ( lad_qty_all + lad_qty_pick ) ) @ WMESSAGE NO-LABEL with fram F1300.
                  else   display skip "" @ WMESSAGE with fram F1300.
            END.
            IF LASTKEY = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"
            THEN DO:
                  IF recid(LAD_DET) = ? THEN find last LAD_DET where 
                              lad_domain = V1001 AND lad_dataset ="rps_det"  and substring(lad_nbr,1,8) = V1002 and trim ( substring(lad_nbr,9,10)) = V1100 AND  
                              LAD_PART <=  INPUT V1300
                               no-lock no-error.
                  else do: 
                       if LAD_PART =  INPUT V1300
                       then find prev LAD_DET
                       where lad_domain = V1001 AND lad_dataset ="rps_det"  and substring(lad_nbr,1,8) = V1002 and trim ( substring(lad_nbr,9,10)) = V1100
                        no-lock no-error.
                        else find first LAD_DET where 
                              lad_domain = V1001 AND lad_dataset ="rps_det"  and substring(lad_nbr,1,8) = V1002 and trim ( substring(lad_nbr,9,10)) = V1100 AND  
                              LAD_PART >=  INPUT V1300
                               no-lock no-error.
                  end.
                  IF AVAILABLE LAD_DET then display skip 
            LAD_PART @ V1300 "未结数量:" + trim( string ( lad_qty_all + lad_qty_pick ) ) @ WMESSAGE NO-LABEL with fram F1300.
                  else   display skip "" @ WMESSAGE with fram F1300.
            END.
            APPLY LASTKEY.
        END.
        /* ROLL BAR END */


        /* PRESS e EXIST CYCLE */
        IF V1300 = "e" THEN  LEAVE V1290LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1300.

         /*  ---- Valid Check ---- START */

        find first lad_det where  lad_domain = V1001 and lad_dataset ="rps_det"  and substring(lad_nbr,1,8) = V1002 and lad_part=V1300 no-lock no-error no-wait.
If not avail lad_det then do:
display skip "件号不在该领料单,请查" @ WMESSAGE NO-LABEL with fram F1300.
                pause 0 before-hide.
                Undo, retry.

End.
        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1300.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first PT_MSTR where PT_DOMAIN = V1001 AND PT_PART = ENTRY(1, V1300, "@")  no-lock no-error.
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
        find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
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

                display "[备料转车间]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1410 width 150 no-box.

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
        IF V1410 = "e" THEN  LEAVE V1290LMAINLOOP.
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


     /* START  LINE :1420  从库位[From LOC]  */
     V1420L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1420           as char format "x(150)".
        define variable PV1420          as char format "x(150)".
        define variable L14201          as char format "x(40)".
        define variable L14202          as char format "x(40)".
        define variable L14203          as char format "x(40)".
        define variable L14204          as char format "x(40)".
        define variable L14205          as char format "x(40)".
        define variable L14206          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1420 = t_v100[3].
        V1420 = ENTRY(1,V1420,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
         If sectionid > 1 Then 
        V1420 = PV1420 .
        V1420 = ENTRY(1,V1420,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1420L .
        /* --CYCLE TIME SKIP -- END  */

                display "[备料转车间]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1420 width 150 no-box.

                /* LABEL 1 - START */ 
                L14201 = "从库位?" .
                display L14201          format "x(40)" skip with fram F1420 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L14202 = "件号" + trim( V1300 ) .
                display L14202          format "x(40)" skip with fram F1420 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L14203 = "" . 
                display L14203          format "x(40)" skip with fram F1420 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L14204 = "" . 
                display L14204          format "x(40)" skip with fram F1420 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1420 width 150 no-box.
        Update V1420
        WITH  fram F1420 NO-LABEL
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
        IF V1420 = "e" THEN  LEAVE V1290LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1420.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1420.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first LOC_MSTR where LOC_DOMAIN = V1001 AND LOC_LOC = V1420 AND LOC_SITE = V1002  no-lock no-error.
        IF NOT AVAILABLE LOC_MSTR then do:
                display skip "Error , Retry." @ WMESSAGE NO-LABEL with fram F1420.
                pause 0 before-hide.
                undo, retry.
        end.
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1420.
        pause 0.
        leave V1420L.
     END.
     PV1420 = V1420.
     /* END    LINE :1420  从库位[From LOC]  */


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
                display "[备料转车间]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1500 width 150 no-box.

                /* LABEL 1 - START */ 
                L15001 = "批号?" .
                display L15001          format "x(40)" skip with fram F1500 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find first ld_det where ld_domain = V1001 and ld_part = V1300  and ld_site = V1002  and ld_ref  = ""     and
ld_loc = V1420 and
ld_qty_oh <> 0 use-index ld_part_lot no-lock no-error.
If AVAILABLE ( ld_det ) then
                L15002 = "最小" + trim(ld_lot) .
                else L15002 = "" . 
                display L15002          format "x(40)" skip with fram F1500 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find first ld_det where ld_domain = V1001 and ld_part = V1300  and
ld_site = V1002  and  
ld_ref  = ""     and
ld_loc = V1420 and
ld_qty_oh <> 0 use-index ld_part_lot no-lock no-error.
If AVAILABLE ( ld_det ) then
                L15003 = "库存" + trim(V1420) + "/" +  trim(string(ld_qty_oh)) .
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
                              LD_DOMAIN = V1001 AND LD_PART = V1300 AND LD_QTY_OH <> 0  AND
LD_SITE = V1002 AND LD_REF = "" AND  
LD_LOC = "P-ALL" AND  
                              LD_LOT >=  INPUT V1500
                               no-lock no-error.
                  else do: 
                       if LD_LOT =  INPUT V1500
                       then find next LD_DET
                       WHERE LD_DOMAIN = V1001 AND LD_PART = V1300 AND LD_QTY_OH <> 0  AND
LD_SITE = V1002 AND LD_REF = "" AND  
LD_LOC = "P-ALL"
                        no-lock no-error.
                        else find first LD_DET where 
                              LD_DOMAIN = V1001 AND LD_PART = V1300 AND LD_QTY_OH <> 0  AND
LD_SITE = V1002 AND LD_REF = "" AND  
LD_LOC = "P-ALL" AND  
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
                              LD_DOMAIN = V1001 AND LD_PART = V1300 AND LD_QTY_OH <> 0  AND
LD_SITE = V1002 AND LD_REF = "" AND  
LD_LOC = "P-ALL" AND  
                              LD_LOT <=  INPUT V1500
                               no-lock no-error.
                  else do: 
                       if LD_LOT =  INPUT V1500
                       then find prev LD_DET
                       where LD_DOMAIN = V1001 AND LD_PART = V1300 AND LD_QTY_OH <> 0  AND
LD_SITE = V1002 AND LD_REF = "" AND  
LD_LOC = "P-ALL"
                        no-lock no-error.
                        else find first LD_DET where 
                              LD_DOMAIN = V1001 AND LD_PART = V1300 AND LD_QTY_OH <> 0  AND
LD_SITE = V1002 AND LD_REF = "" AND  
LD_LOC = "P-ALL" AND  
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


     /* START  LINE :1502  需转移数量  */
     V1502L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1502           as char format "x(150)".
        define variable PV1502          as char format "x(150)".
        define variable L15021          as char format "x(40)".
        define variable L15022          as char format "x(40)".
        define variable L15023          as char format "x(40)".
        define variable L15024          as char format "x(40)".
        define variable L15025          as char format "x(40)".
        define variable L15026          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /*find first lad_det where  lad_domain = V1001 and lad_dataset ="rps_det"  and substring(lad_nbr,1,8) = V1002 and lad_part=V1300 no-lock no-error no-wait.
If avail lad_det then
*/
def var aaqty like tr_qty_loc.
Aaqty=0.
for each lad_det where  lad_domain = V1001 and lad_dataset ="rps_det"  and substring(lad_nbr,1,8) = V1002 and lad_part=V1300 no-lock :
 aaqty=aaqty + lad_qty_all + lad_qty_chg.
End.
If aaqty<>0 then
        V1502 = string(aaqty).
        V1502 = ENTRY(1,V1502,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1502 = ENTRY(1,V1502,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V1502L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V1502L .
        /* --CYCLE TIME SKIP -- END  */

                display "[备料转车间]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1502 width 150 no-box.

                /* LABEL 1 - START */ 
                L15021 = "需转移数量?" .
                display L15021          format "x(40)" skip with fram F1502 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L15022 = "" . 
                display L15022          format "x(40)" skip with fram F1502 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L15023 = "" . 
                display L15023          format "x(40)" skip with fram F1502 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L15024 = "" . 
                display L15024          format "x(40)" skip with fram F1502 width 150 no-box.
                /* LABEL 4 - END */ 
                display "输入或按E退出"       format "x(40)" skip
        skip with fram F1502 width 150 no-box.
        /* DISPLAY ONLY */
        define variable X1502           as char format "x(40)".
        X1502 = V1502.
        V1502 = "".
        /* DISPLAY ONLY */
        Update V1502
        WITH  fram F1502 NO-LABEL
        EDITING:
          readkey pause wtimeout.
          if lastkey = -1 Then quit.
        if LASTKEY = 404 Then Do: /* DISABLE F4 */
           pause 0 before-hide.
           undo, retry.
        end.
           apply lastkey.
        end.
        V1502 = X1502.
        /* DISPLAY ONLY */
        LEAVE V1502L.
        /* DISPLAY ONLY */

        /* PRESS e EXIST CYCLE */
        IF V1502 = "e" THEN  LEAVE V1290LMAINLOOP.
        display  skip WMESSAGE NO-LABEL with fram F1502.

         /*  ---- Valid Check ---- START */

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
     /* END    LINE :1502  需转移数量  */


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
                display "[备料转车间]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1600 width 150 no-box.

                /* LABEL 1 - START */ 
                L16001 = "转移数量?需转" + V1502 .
                display L16001          format "x(40)" skip with fram F1600 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L16002 = "件:" + trim( V1300 ) .
                display L16002          format "x(40)" skip with fram F1600 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L16003 = "批:" + V1500 .
                display L16003          format "x(40)" skip with fram F1600 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L16004 = "从:" + trim( V1420 ) + "到" + trim( V1105 ) .
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
        find first LD_DET where ( ld_part  = V1300 AND ld_lot = V1500 AND ld_domain = V1001 AND ld_site = V1002 AND ld_ref = "") AND ( ( decimal(V1600) < 0  AND ( ld_loc = V1105 AND  ld_domain = V1001 AND LD_SITE = V1002 and ld_ref = "" and ld_QTY_oh >= - DECIMAL ( V1600 ) ) ) OR ( decimal(V1600) > 0 AND  ld_loc = V1420 AND  ld_domain = V1001 AND LD_SITE = V1002 and ld_ref = "" and  ld_QTY_oh >= DECIMAL ( V1600 ) ) )  no-lock no-error.
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
                display "[备料转车间]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1700 width 150 no-box.

                /* LABEL 1 - START */ 
                L17001 = "件号" + trim(V1300) .
                display L17001          format "x(40)" skip with fram F1700 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L17002 = "批号" + trim ( V1500 ) .
                display L17002          format "x(40)" skip with fram F1700 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L17003 = "转移数量:" + trim (V1100) + "/" + trim(V1600) .
                display L17003          format "x(40)" skip with fram F1700 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L17004 = "从:" + trim( V1420 ) + "到" + trim( V1105 ) .
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

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1700.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
        find first ld_det where ld_domain = V1001 and ld_part  = V1300 AND
ld_site = V1002 AND 
ld_ref  = ""    and ld_lot = V1500   AND
( ( decimal(V1600) > 0 AND ld_loc   = V1420 ) OR ( decimal(V1600) < 0 AND ld_loc   = V1105 ))  NO-ERROR NO-WAIT.
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

                display "[备料转车间]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9000 width 150 no-box.

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
     {xsrep03u.i}
     /*  Update MFG/PRO END  */ 
        display  "" NO-LABEL with fram F9000X width 150 no-box .
        pause 0.
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
                display "[备料转车间]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9010 width 150 no-box.

                /* LABEL 1 - START */ 
                find last tr_hist where tr_domain = V1001 and 
tr_date = today     and 
tr_trnbr > integer ( V9000 ) and 
substring(tr_nbr,1,10)  = V1100     and  tr_type = "RCT-TR"  and
tr_site = V1002     and  tr_part = V1300     and tr_serial = V1500   and 
tr_time  + 15 >= TIME 
use-index tr_date_trn no-lock no-error.
If AVAILABLE ( tr_hist ) then
                L90101 = "交易已提交" .
                else L90101 = "" . 
                display L90101          format "x(40)" skip with fram F9010 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                find last tr_hist where tr_domain = V1001 and 
tr_date = today     and 
tr_trnbr > integer ( V9000 ) and 
substring(tr_nbr,1,10)  = V1100     and  tr_type = "RCT-TR"  and  
tr_site = V1002     and  
tr_part = V1300     and tr_serial = V1500   and 
tr_time  + 15 >= TIME 
use-index tr_date_trn no-lock no-error.
If AVAILABLE ( tr_hist ) then
                L90102 = "交易号 :" + trim(string(tr_trnbr)) .
                else L90102 = "" . 
                display L90102          format "x(40)" skip with fram F9010 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                find last tr_hist where tr_domain = V1001 and 
tr_date = today     and 
tr_trnbr > integer ( V9000 ) and 
substring(tr_nbr,1,10)  = V1100     and  tr_type = "RCT-TR"  and  
tr_site = V1002     and  
tr_part = V1300     and tr_serial = V1500   and 
tr_time  + 15 >= TIME 
use-index tr_date_trn no-lock no-error.
If NOT AVAILABLE ( tr_hist ) then
                L90103 = "交易提交失败" .
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

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V9110L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V9110L .
        /* --CYCLE TIME SKIP -- END  */

                display "[备料转车间]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9110 width 150 no-box.

                /* LABEL 1 - START */ 
                find first pt_mstr where pt_domain = V1001 and pt_part = V1300  no-lock no-error.
If AVAILABLE ( pt_mstr ) then
                L91101 = pt_um + " 标签上数量?" .
                else L91101 = "" . 
                display L91101          format "x(40)" skip with fram F9110 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L91102 = "图号:" + trim( V1300 ) .
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
        /* DISPLAY ONLY */
        define variable X9110           as char format "x(40)".
        X9110 = V9110.
        V9110 = "".
        /* DISPLAY ONLY */
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
        V9110 = X9110.
        /* DISPLAY ONLY */
        LEAVE V9110L.
        /* DISPLAY ONLY */

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

        /* --FIRST TIME SKIP -- START  */
         if sectionid = 1 then leave V9120L.
        /* --FIRST TIME SKIP -- END  */


        /* --CYCLE TIME SKIP -- START  */
         if sectionid > 1 then leave V9120L .
        /* --CYCLE TIME SKIP -- END  */

                display "[备料转车间]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9120 width 150 no-box.

                /* LABEL 1 - START */ 
                L91201 = "标签个数?" .
                display L91201          format "x(40)" skip with fram F9120 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L91202 = "图号:" + trim( V1300 ) .
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
        /* DISPLAY ONLY */
        define variable X9120           as char format "x(40)".
        X9120 = V9120.
        V9120 = "".
        /* DISPLAY ONLY */
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
        V9120 = X9120.
        /* DISPLAY ONLY */
        LEAVE V9120L.
        /* DISPLAY ONLY */

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
        find first upd_det where upd_nbr = "REP03" and upd_select = 99 no-lock no-error.
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

                display "[备料转车间]"       + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F9130 width 150 no-box.

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
        /* DISPLAY ONLY */
        define variable X9130           as char format "x(40)".
        X9130 = V9130.
        V9130 = "".
        /* DISPLAY ONLY */
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

        V9130 = X9130.
        /* DISPLAY ONLY */
        LEAVE V9130L.
        /* DISPLAY ONLY */

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
     PROCEDURE rep039130l.
        /* Define Labels Path  Start */
        Define variable LabelsPath as character format "x(100)" init "/app/bc/labels/".
        Find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="LabelsPath"no-lock no-error.
        If AVAILABLE(code_mstr) Then LabelsPath = trim ( code_cmmt ).
        If substring(LabelsPath, length(LabelsPath), 1) <> "/" Then 
        LabelsPath = LabelsPath + "/".
        /* Define Labels Path  END */
     INPUT FROM VALUE(LabelsPath + "rep03").
     wsection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) .
     output to value( trim(wsection) + ".l") .
     Do While True:
              IMPORT UNFORMATTED ts9130.
       put unformatted ts9130 skip.
     End.
     INPUT CLOSE.
     OUTPUT CLOSE.
     unix silent value ("chmod 777  " + trim(wsection) + ".l").
     END PROCEDURE.
     run rep039130l.
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
