/* Generate By Barcode Generator , Copyright by Softspeed - Build By Sam Song  */ 
/* BARCODE SYSTEM */
/* Generate date / time  2014/7/21 10:36:02 */
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
define input PARAMETER sysptr as int .
DEFINE VARIABLE trnbr AS INTEGER.
DEFINE NEW GLOBAL SHARED VARIABLE mfguser AS CHARACTER.
DEFINE NEW GLOBAL SHARED VARIABLE ts_mfguser AS CHARACTER.
define  variable t_v100  as char EXTENT 15 .
define  variable tki  as integer .
define  variable tkj  as integer .
define  variable tkstr  as char .
define shared variable xsnvarfsto  as char no-undo .
define shared variable xsnvarsecs  as char no-undo .
xsnvarfsto = "Now Begin". 
xsnvarsecs = "Wait For End". 

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout"
 and can-find ( first dom_mstr where  dom_type = "SYSTEM " and dom_domain = code_domain and dom_active = yes ) 
 no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xsmf001wtimeout"
 and can-find ( first dom_mstr where  dom_type = "SYSTEM " and dom_domain = code_domain and dom_active = yes ) 
 no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

define shared var xsnewmsg as char no-undo.
xsnewmsg = "now running".
PROCEDURE CheckSecuritied:
          define var usrwdate as date.
          define var curdate as date .
          define var nowdate as date .
          define var curtime as int .
          define var currec like tr_trnbr .
          curdate = today.
          curtime = time.
          nowdate = today.
          usrwdate = 02/16/12.
          find first usrw_wkfl where usrw_key1 = "BARCODE" and usrw_key2 = "LICENSEKEY"  and usrw_domain = "PDC"
              no-lock no-error.
          if avail usrw_wkfl then do:
            usrwdate = usrw_datefld[1].
            if usrw_datefld[1] = ?  then       usrwdate  = 02/16/12.
            if usrw_charfld[3] <> encode("SS" + string(year(usrw_datefld[1])) + string(month(usrw_datefld[1])) + string(day(usrw_datefld[1]))) then usrwdate = 02/16/12.
          end.
          release usrw_wkfl.
          for last tr_hist no-lock where tr_domain = "PDC" use-index tr_trnbr:
            currec = tr_trnbr.
          end.
          for last tr_hist no-lock where tr_domain = "PDC" and tr_trnbr < (currec - 20000)  use-index tr_trnbr:
            nowdate = tr_date.
          end.
          if  (nowdate - usrwdate) < 30  then usrwdate = nowdate - 30 .
          if  program-name(2) = "xsinv45.p" then usrwdate = usrwdate + 60 .
          if  usrwdate < nowdate then do:
            do on end-key undo,retry:
              do while ((today - curdate) * 3600 * 24 + time - curtime) < ((nowdate - usrwdate) / 30) :
                pause 0 no-message.
              end.
            end.
          end.
end.
define shared variable execname as char format "x(40)".
define shared variable global_userid as char format "x(40)".
define        variable OkToRun       as logical init no .
/* Check Security Start */
PROCEDURE CheckSecurity:
     DEFINE INPUT PARAMETER  ProgramName   AS character.
     DEFINE INPUT PARAMETER  global_userid AS character.
     DEFINE OUTPUT PARAMETER OkToRun     AS logical.
     DEFINE OUTPUT PARAMETER Execname    AS character.
     Def variable  MessageOnly as character format "x(20)" init "".
     OkToRun = no.
     Execname = ProgramName.
     FIND First QAD_WKFL where QAD_KEY1 = "BARCODEMENU" and QAD_KEY2 = ProgramName no-error.
     If AVAILABLE(QAD_WKFL) Then Do:
        IF index ( QAD_CHARFLD[1] , global_userid ) <> 0 then  OkToRun =  yes.
        IF index ( QAD_CHARFLD[1] , "*") <> 0            then  OkToRun =  yes.
        FIND First QAD_WKFL where QAD_KEY1 = "BARCODEMENU"and QAD_KEY2 = ProgramName no-lock no-error .
     end.
     Else Do:
        OkToRun =  yes.
        create QAD_WKFL.
          assign QAD_KEY1 = "BARCODEMENU"
               QAD_KEY2 = ProgramName
               QAD_CHARFLD[1] = "*".
     end.
     If OkToRun = no Then Do:
        display " *** WARNING *** " skip with fram WarningBox width 150 no-box . 
         display " YOU CAN NOT" skip with fram WarningBox width 150 no-box .
         display " ACCESS THIS" skip with fram WarningBox width 150 no-box . 
         display "  FUNCTION!" skip with fram WarningBox width 150 no-box .
         display " CONTACT IT " skip with fram WarningBox width 150 no-box .
         display " DEPARTMENT " skip with fram WarningBox width 150 no-box .
        Update MessageOnly  WITH  fram WarningBox NO-LABEL.
     end.
END PROCEDURE.
/* Check Security End */
/* LOAD SYSTEM MENU START */
PROCEDURE loadmenu:

  DEFINE VARIABLE ProgramMenu AS CHARACTER FORMAT "x(200)".
  DEFINE VARIABLE ProgramID AS CHARACTER FORMAT "x(76)".
  DEFINE VARIABLE ProgramFunction AS CHARACTER FORMAT "x(76)".
  DEFINE VARIABLE ProgramSecurity AS CHARACTER FORMAT "x(200)".
  DEFINE VARIABLE text-string AS CHARACTER FORMAT "x(255)".
  INPUT FROM VALUE(SEARCH("barcodemenu")).
  Do While True:
         IMPORT  UNFORMAT text-string.
         ProgramMenu       = "" .
         ProgramID       = "" .
         ProgramFunction = "" .
         ProgramSecurity = "" .
         ProgramMenu       = ENTRY(1,text-string,"#") .
         ProgramID         = ENTRY(2,text-string,"#") .
         ProgramFunction   = ENTRY(3,text-string,"#") .
         ProgramSecurity   = ENTRY(4,text-string,"#") .
         RUN UPDATE_QAD_WKFL (INPUT ProgramMenu ,INPUT ProgramID , INPUT ProgramFunction, INPUT ProgramSecurity ).
         Display "UPDATE...... "  skip with fram UpdateBox width 150 no-box  .
         Display trim ( ProgramID )      no-label  skip with fram UpdateBox width 150 no-box .
         Display trim ( ProgramFunction ) no-label skip with fram UpdateBox width 150 no-box .
         Pause.
  END.
  INPUT CLOSE.
END PROCEDURE.

/* Call Report Warehouse START */
PROCEDURE RUNMFGPROPROGRAM.
   DEFINE INPUT PARAMETER  wMfgproProgram    AS character.
   run xsmfgpro.p(input wMfgproProgram ,input "").
END PROCEDURE.
/* Call Report Warehouse END */
PROCEDURE UPDATE_QAD_WKFL:
     DEFINE INPUT PARAMETER  wProgramMenu     AS character.
     DEFINE INPUT PARAMETER  wProgramID       AS character.
     DEFINE INPUT PARAMETER  wProgramFunction AS character.
     DEFINE INPUT PARAMETER  wProgramSecurity AS character.
     FIND First QAD_WKFL where QAD_KEY1 = "BARCODEMENU" and QAD_KEY2 = trim(wProgramID) no-error.
     IF   AVAILABLE(QAD_WKFL) Then Do:
         QAD_CHARFLD[1] = trim ( wProgramSecurity ).
         QAD_CHARFLD[2] = trim ( wProgramFunction ).
         QAD_CHARFLD[3] = trim ( wProgramMenu ).
     END.
     ELSE DO:
         CREATE QAD_WKFL.
         ASSIGN QAD_KEY1 = "BARCODEMENU"
                QAD_KEY2 = Trim(wProgramID)
                QAD_CHARFLD [1] = Trim ( wProgramSecurity )
                QAD_CHARFLD [2] = Trim ( wProgramFunction )
                QAD_CHARFLD [3] = Trim ( wProgramMenu ).
     END.
END PROCEDURE.
/* LOAD SYSTEM MENU END  */
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


                /* LABEL 5 - START */ 
                  L10015 = "" . 
                display L10015          format "x(40)" skip with fram F1001 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L10016 = "" . 
                display L10016          format "x(40)" skip with fram F1001 width 150 no-box.
                /* LABEL 6 - END */ 
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
        /* **LOAD MENU START** */
        IF V1001 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1001 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1001 ).
        /* **CHANGE Default Site START ** */
        IF V1001 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1001 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
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
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 width 150 no-box.

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


                /* LABEL 5 - START */ 
                  L10025 = "" . 
                display L10025          format "x(40)" skip with fram F1002 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L10026 = "" . 
                display L10026          format "x(40)" skip with fram F1002 width 150 no-box.
                /* LABEL 6 - END */ 
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
        /* **LOAD MENU START** */
        IF V1002 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1002 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1002 ).
        /* **CHANGE Default Site START ** */
        IF V1002 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1002 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
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


     /* START  LINE :1100  1主菜单  */
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
        V1100 = " ".
        V1100 = ENTRY(1,V1100,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1100 = " ".
        V1100 = ENTRY(1,V1100,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1100 width 150 no-box.

                /* LABEL 1 - START */ 
                L11001 = "收发货菜单. . .1" .
                display L11001          format "x(40)" skip with fram F1100 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11002 = "特殊销售发运. .2" .
                display L11002          format "x(40)" skip with fram F1100 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11003 = "转仓菜单. . . .3" .
                display L11003          format "x(40)" skip with fram F1100 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11004 = "盘点菜单. . . .4" .
                display L11004          format "x(40)" skip with fram F1100 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                L11005 = "标签菜单. . . .5" .
                display L11005          format "x(40)" skip with fram F1100 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                L11006 = "库存菜单. . . .6" .
                display L11006          format "x(40)" skip with fram F1100 width 150 no-box.
                /* LABEL 6 - END */ 
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
        /* **LOAD MENU START** */
        IF V1100 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1100 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1100 ).
        /* **CHANGE Default Site START ** */
        IF V1100 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1100 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1100.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1100.
        pause 0.
        leave V1100L.
     END.
     PV1100 = V1100.
     /* END    LINE :1100  1主菜单  */


   /* Internal Cycle Input :1110    */
   V1110LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1110    */
   IF NOT (V1100 = "1" ) THEN LEAVE V1110LMAINLOOP.
     /* START  LINE :1110  1.1 收发货菜单  */
     V1110L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1110           as char format "x(150)".
        define variable PV1110          as char format "x(150)".
        define variable L11101          as char format "x(40)".
        define variable L11102          as char format "x(40)".
        define variable L11103          as char format "x(40)".
        define variable L11104          as char format "x(40)".
        define variable L11105          as char format "x(40)".
        define variable L11106          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1110 = " ".
        V1110 = ENTRY(1,V1110,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1110 = " ".
        V1110 = ENTRY(1,V1110,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1110 width 150 no-box.

                /* LABEL 1 - START */ 
                L11101 = "销售发货二维码.12" .
                display L11101          format "x(40)" skip with fram F1110 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11102 = "销售发货有日期.13" .
                display L11102          format "x(40)" skip with fram F1110 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11103 = "销售发货. . . .14" .
                display L11103          format "x(40)" skip with fram F1110 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11104 = "搅拌工单发料. .15" .
                display L11104          format "x(40)" skip with fram F1110 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                L11105 = "搅拌粉入库. . .16" .
                display L11105          format "x(40)" skip with fram F1110 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                L11106 = "搅拌粉出库. . .17" .
                display L11106          format "x(40)" skip with fram F1110 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1110
        WITH  fram F1110 NO-LABEL
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
        IF V1110 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1110 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1110 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1110 ).
        /* **CHANGE Default Site START ** */
        IF V1110 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1110 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1110.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1110.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1110.
        pause 0.
        leave V1110L.
     END.
     PV1110 = V1110.
     /* END    LINE :1110  1.1 收发货菜单  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1110LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1110    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1112    */
   V1112LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1112    */
   IF NOT (V1110 = "12" OR V1100 = "12" ) THEN LEAVE V1112LMAINLOOP.
     /* START  LINE :1112  1.1.2 SO发货二维码  */
     V1112L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1112           as char format "x(150)".
        define variable PV1112          as char format "x(150)".
        define variable L11121          as char format "x(40)".
        define variable L11122          as char format "x(40)".
        define variable L11123          as char format "x(40)".
        define variable L11124          as char format "x(40)".
        define variable L11125          as char format "x(40)".
        define variable L11126          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1112 = " ".
        V1112 = ENTRY(1,V1112,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1112 = " ".
        V1112 = ENTRY(1,V1112,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1110 = "".
RUN CheckSecurity (INPUT "xssoi12.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes then RUN    xssoi12.p  (input 100).
        leave V1112L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1112 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11121 = "" . 
                display L11121          format "x(40)" skip with fram F1112 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11122 = "" . 
                display L11122          format "x(40)" skip with fram F1112 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11123 = "" . 
                display L11123          format "x(40)" skip with fram F1112 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11124 = "" . 
                display L11124          format "x(40)" skip with fram F1112 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11125 = "" . 
                display L11125          format "x(40)" skip with fram F1112 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11126 = "" . 
                display L11126          format "x(40)" skip with fram F1112 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1112
        WITH  fram F1112 NO-LABEL
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
        IF V1112 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1112 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1112 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1112 ).
        /* **CHANGE Default Site START ** */
        IF V1112 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1112 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1112.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1112.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1112.
        pause 0.
        leave V1112L.
     END.
     PV1112 = V1112.
     /* END    LINE :1112  1.1.2 SO发货二维码  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1112LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1112    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1113    */
   V1113LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1113    */
   IF NOT (V1110 = "13" OR V1100 = "13" ) THEN LEAVE V1113LMAINLOOP.
     /* START  LINE :1113  1.1.3 SO收货[日期]  */
     V1113L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1113           as char format "x(150)".
        define variable PV1113          as char format "x(150)".
        define variable L11131          as char format "x(40)".
        define variable L11132          as char format "x(40)".
        define variable L11133          as char format "x(40)".
        define variable L11134          as char format "x(40)".
        define variable L11135          as char format "x(40)".
        define variable L11136          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1113 = " ".
        V1113 = ENTRY(1,V1113,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1113 = " ".
        V1113 = ENTRY(1,V1113,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1110 = "".
RUN CheckSecurity (INPUT "xssoi20.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes then RUN    xssoi20.p  (input 100).
        leave V1113L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1113 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11131 = "" . 
                display L11131          format "x(40)" skip with fram F1113 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11132 = "" . 
                display L11132          format "x(40)" skip with fram F1113 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11133 = "" . 
                display L11133          format "x(40)" skip with fram F1113 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11134 = "" . 
                display L11134          format "x(40)" skip with fram F1113 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11135 = "" . 
                display L11135          format "x(40)" skip with fram F1113 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11136 = "" . 
                display L11136          format "x(40)" skip with fram F1113 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1113
        WITH  fram F1113 NO-LABEL
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
        IF V1113 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1113 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1113 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1113 ).
        /* **CHANGE Default Site START ** */
        IF V1113 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1113 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1113.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1113.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1113.
        pause 0.
        leave V1113L.
     END.
     PV1113 = V1113.
     /* END    LINE :1113  1.1.3 SO收货[日期]  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1113LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1113    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1114    */
   V1114LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1114    */
   IF NOT (V1110 = "14" OR V1100 = "14" ) THEN LEAVE V1114LMAINLOOP.
     /* START  LINE :1114  1.1.4 SO发货[严控]  */
     V1114L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1114           as char format "x(150)".
        define variable PV1114          as char format "x(150)".
        define variable L11141          as char format "x(40)".
        define variable L11142          as char format "x(40)".
        define variable L11143          as char format "x(40)".
        define variable L11144          as char format "x(40)".
        define variable L11145          as char format "x(40)".
        define variable L11146          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1114 = " ".
        V1114 = ENTRY(1,V1114,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1114 = " ".
        V1114 = ENTRY(1,V1114,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1110 = "".
RUN CheckSecurity (INPUT "xssoi10.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes then RUN    xssoi10.p  (input 100).
        leave V1114L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1114 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11141 = "" . 
                display L11141          format "x(40)" skip with fram F1114 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11142 = "" . 
                display L11142          format "x(40)" skip with fram F1114 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11143 = "" . 
                display L11143          format "x(40)" skip with fram F1114 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11144 = "" . 
                display L11144          format "x(40)" skip with fram F1114 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11145 = "" . 
                display L11145          format "x(40)" skip with fram F1114 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11146 = "" . 
                display L11146          format "x(40)" skip with fram F1114 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1114
        WITH  fram F1114 NO-LABEL
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
        IF V1114 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1114 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1114 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1114 ).
        /* **CHANGE Default Site START ** */
        IF V1114 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1114 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1114.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1114.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1114.
        pause 0.
        leave V1114L.
     END.
     PV1114 = V1114.
     /* END    LINE :1114  1.1.4 SO发货[严控]  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1114LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1114    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1115    */
   V1115LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1115    */
   IF NOT (V1110 = "15" OR V1100 = "15" ) THEN LEAVE V1115LMAINLOOP.
     /* START  LINE :1115  1.1.5 搅拌工单发料  */
     V1115L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1115           as char format "x(150)".
        define variable PV1115          as char format "x(150)".
        define variable L11151          as char format "x(40)".
        define variable L11152          as char format "x(40)".
        define variable L11153          as char format "x(40)".
        define variable L11154          as char format "x(40)".
        define variable L11155          as char format "x(40)".
        define variable L11156          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1115 = " ".
        V1115 = ENTRY(1,V1115,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1115 = " ".
        V1115 = ENTRY(1,V1115,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1110 = "".
RUN CheckSecurity (INPUT "xswoi10.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes then RUN    xswoi10.p  (input 100).
        leave V1115L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1115 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11151 = "" . 
                display L11151          format "x(40)" skip with fram F1115 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11152 = "" . 
                display L11152          format "x(40)" skip with fram F1115 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11153 = "" . 
                display L11153          format "x(40)" skip with fram F1115 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11154 = "" . 
                display L11154          format "x(40)" skip with fram F1115 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11155 = "" . 
                display L11155          format "x(40)" skip with fram F1115 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11156 = "" . 
                display L11156          format "x(40)" skip with fram F1115 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1115
        WITH  fram F1115 NO-LABEL
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
        IF V1115 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1115 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1115 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1115 ).
        /* **CHANGE Default Site START ** */
        IF V1115 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1115 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1115.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1115.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1115.
        pause 0.
        leave V1115L.
     END.
     PV1115 = V1115.
     /* END    LINE :1115  1.1.5 搅拌工单发料  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1115LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1115    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1116    */
   V1116LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1116    */
   IF NOT (V1110 = "16" OR V1100 = "16" ) THEN LEAVE V1116LMAINLOOP.
     /* START  LINE :1116  1.1.6 搅拌粉入库  */
     V1116L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1116           as char format "x(150)".
        define variable PV1116          as char format "x(150)".
        define variable L11161          as char format "x(40)".
        define variable L11162          as char format "x(40)".
        define variable L11163          as char format "x(40)".
        define variable L11164          as char format "x(40)".
        define variable L11165          as char format "x(40)".
        define variable L11166          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1116 = " ".
        V1116 = ENTRY(1,V1116,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1116 = " ".
        V1116 = ENTRY(1,V1116,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1110 = "".
RUN CheckSecurity (INPUT "xswor01.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes then RUN    xswor01.p  (input 100).
        leave V1116L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1116 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11161 = "" . 
                display L11161          format "x(40)" skip with fram F1116 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11162 = "" . 
                display L11162          format "x(40)" skip with fram F1116 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11163 = "" . 
                display L11163          format "x(40)" skip with fram F1116 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11164 = "" . 
                display L11164          format "x(40)" skip with fram F1116 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11165 = "" . 
                display L11165          format "x(40)" skip with fram F1116 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11166 = "" . 
                display L11166          format "x(40)" skip with fram F1116 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1116
        WITH  fram F1116 NO-LABEL
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
        IF V1116 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1116 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1116 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1116 ).
        /* **CHANGE Default Site START ** */
        IF V1116 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1116 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1116.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1116.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1116.
        pause 0.
        leave V1116L.
     END.
     PV1116 = V1116.
     /* END    LINE :1116  1.1.6 搅拌粉入库  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1116LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1116    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1117    */
   V1117LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1117    */
   IF NOT (V1110 = "17" OR V1100 = "17" ) THEN LEAVE V1117LMAINLOOP.
     /* START  LINE :1117  1.1.7 搅拌粉出库  */
     V1117L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1117           as char format "x(150)".
        define variable PV1117          as char format "x(150)".
        define variable L11171          as char format "x(40)".
        define variable L11172          as char format "x(40)".
        define variable L11173          as char format "x(40)".
        define variable L11174          as char format "x(40)".
        define variable L11175          as char format "x(40)".
        define variable L11176          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1117 = " ".
        V1117 = ENTRY(1,V1117,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1117 = " ".
        V1117 = ENTRY(1,V1117,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1110 = "".
RUN CheckSecurity (INPUT "xsinv26.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes then RUN    xsinv26.p  (input 100).
        leave V1117L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1117 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11171 = "" . 
                display L11171          format "x(40)" skip with fram F1117 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11172 = "" . 
                display L11172          format "x(40)" skip with fram F1117 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11173 = "" . 
                display L11173          format "x(40)" skip with fram F1117 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11174 = "" . 
                display L11174          format "x(40)" skip with fram F1117 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11175 = "" . 
                display L11175          format "x(40)" skip with fram F1117 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11176 = "" . 
                display L11176          format "x(40)" skip with fram F1117 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1117
        WITH  fram F1117 NO-LABEL
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
        IF V1117 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1117 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1117 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1117 ).
        /* **CHANGE Default Site START ** */
        IF V1117 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1117 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1117.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1117.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1117.
        pause 0.
        leave V1117L.
     END.
     PV1117 = V1117.
     /* END    LINE :1117  1.1.7 搅拌粉出库  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1117LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1117    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1118    */
   V1118LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1118    */
   IF NOT (V1110 = "18" OR V1100 = "18" ) THEN LEAVE V1118LMAINLOOP.
     /* START  LINE :1118  1.1.8 组立工单发料  */
     V1118L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1118           as char format "x(150)".
        define variable PV1118          as char format "x(150)".
        define variable L11181          as char format "x(40)".
        define variable L11182          as char format "x(40)".
        define variable L11183          as char format "x(40)".
        define variable L11184          as char format "x(40)".
        define variable L11185          as char format "x(40)".
        define variable L11186          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1118 = " ".
        V1118 = ENTRY(1,V1118,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1118 = " ".
        V1118 = ENTRY(1,V1118,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1110 = "".
RUN CheckSecurity (INPUT "xswoi20.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes then RUN    xswoi20.p  (input 100).
        leave V1118L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1118 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11181 = "" . 
                display L11181          format "x(40)" skip with fram F1118 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11182 = "" . 
                display L11182          format "x(40)" skip with fram F1118 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11183 = "" . 
                display L11183          format "x(40)" skip with fram F1118 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11184 = "" . 
                display L11184          format "x(40)" skip with fram F1118 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11185 = "" . 
                display L11185          format "x(40)" skip with fram F1118 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11186 = "" . 
                display L11186          format "x(40)" skip with fram F1118 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1118
        WITH  fram F1118 NO-LABEL
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
        IF V1118 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1118 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1118 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1118 ).
        /* **CHANGE Default Site START ** */
        IF V1118 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1118 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1118.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1118.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1118.
        pause 0.
        leave V1118L.
     END.
     PV1118 = V1118.
     /* END    LINE :1118  1.1.8 组立工单发料  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1118LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1118    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1120    */
   V1120LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1120    */
   IF NOT (V1100 = "2" ) THEN LEAVE V1120LMAINLOOP.
     /* START  LINE :1120  1.2 特殊销售发运  */
     V1120L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1120           as char format "x(150)".
        define variable PV1120          as char format "x(150)".
        define variable L11201          as char format "x(40)".
        define variable L11202          as char format "x(40)".
        define variable L11203          as char format "x(40)".
        define variable L11204          as char format "x(40)".
        define variable L11205          as char format "x(40)".
        define variable L11206          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1120 = " ".
        V1120 = ENTRY(1,V1120,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1120 = " ".
        V1120 = ENTRY(1,V1120,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1120 width 150 no-box.

                /* LABEL 1 - START */ 
                L11201 = "特殊条码发运. .21" .
                display L11201          format "x(40)" skip with fram F1120 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11202 = "" . 
                display L11202          format "x(40)" skip with fram F1120 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11203 = "" . 
                display L11203          format "x(40)" skip with fram F1120 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11204 = "" . 
                display L11204          format "x(40)" skip with fram F1120 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11205 = "" . 
                display L11205          format "x(40)" skip with fram F1120 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11206 = "" . 
                display L11206          format "x(40)" skip with fram F1120 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1120
        WITH  fram F1120 NO-LABEL
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
        IF V1120 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1120 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1120 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1120 ).
        /* **CHANGE Default Site START ** */
        IF V1120 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1120 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1120.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1120.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1120.
        pause 0.
        leave V1120L.
     END.
     PV1120 = V1120.
     /* END    LINE :1120  1.2 特殊销售发运  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1120LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1120    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1121    */
   V1121LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1121    */
   IF NOT (V1120 = "21" OR V1100 = "21" ) THEN LEAVE V1121LMAINLOOP.
     /* START  LINE :1121  1.2.1 特殊条码发运  */
     V1121L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1121           as char format "x(150)".
        define variable PV1121          as char format "x(150)".
        define variable L11211          as char format "x(40)".
        define variable L11212          as char format "x(40)".
        define variable L11213          as char format "x(40)".
        define variable L11214          as char format "x(40)".
        define variable L11215          as char format "x(40)".
        define variable L11216          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1121 = " ".
        V1121 = ENTRY(1,V1121,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1121 = " ".
        V1121 = ENTRY(1,V1121,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1120 = "".
RUN CheckSecurity (INPUT "xssoi21.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes then RUN    xssoi21.p  (input 100).
        leave V1121L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1121 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11211 = "" . 
                display L11211          format "x(40)" skip with fram F1121 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11212 = "" . 
                display L11212          format "x(40)" skip with fram F1121 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11213 = "" . 
                display L11213          format "x(40)" skip with fram F1121 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11214 = "" . 
                display L11214          format "x(40)" skip with fram F1121 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11215 = "" . 
                display L11215          format "x(40)" skip with fram F1121 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11216 = "" . 
                display L11216          format "x(40)" skip with fram F1121 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1121
        WITH  fram F1121 NO-LABEL
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
        IF V1121 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1121 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1121 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1121 ).
        /* **CHANGE Default Site START ** */
        IF V1121 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1121 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1121.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1121.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1121.
        pause 0.
        leave V1121L.
     END.
     PV1121 = V1121.
     /* END    LINE :1121  1.2.1 特殊条码发运  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1121LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1121    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1130    */
   V1130LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1130    */
   IF NOT (V1100 = "3" ) THEN LEAVE V1130LMAINLOOP.
     /* START  LINE :1130  1.3 转仓菜单  */
     V1130L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1130           as char format "x(150)".
        define variable PV1130          as char format "x(150)".
        define variable L11301          as char format "x(40)".
        define variable L11302          as char format "x(40)".
        define variable L11303          as char format "x(40)".
        define variable L11304          as char format "x(40)".
        define variable L11305          as char format "x(40)".
        define variable L11306          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1130 = " ".
        V1130 = ENTRY(1,V1130,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1130 = " ".
        V1130 = ENTRY(1,V1130,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1130 width 150 no-box.

                /* LABEL 1 - START */ 
                L11301 = "一级库转二级库.31" .
                display L11301          format "x(40)" skip with fram F1130 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11302 = "二级库转一级库.32" .
                display L11302          format "x(40)" skip with fram F1130 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11303 = "002转101 . . . 33" .
                display L11303          format "x(40)" skip with fram F1130 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11304 = "001转202 . . . 34" .
                display L11304          format "x(40)" skip with fram F1130 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                L11305 = "001转205 . . . 35" .
                display L11305          format "x(40)" skip with fram F1130 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11306 = "" . 
                display L11306          format "x(40)" skip with fram F1130 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1130
        WITH  fram F1130 NO-LABEL
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
        IF V1130 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1130 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1130 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1130 ).
        /* **CHANGE Default Site START ** */
        IF V1130 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1130 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1130.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1130.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1130.
        pause 0.
        leave V1130L.
     END.
     PV1130 = V1130.
     /* END    LINE :1130  1.3 转仓菜单  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1130LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1130    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1131    */
   V1131LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1131    */
   IF NOT (V1130 = "31" OR V1100 = "31" ) THEN LEAVE V1131LMAINLOOP.
     /* START  LINE :1131  1.3.1 一级库转二级库  */
     V1131L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1131           as char format "x(150)".
        define variable PV1131          as char format "x(150)".
        define variable L11311          as char format "x(40)".
        define variable L11312          as char format "x(40)".
        define variable L11313          as char format "x(40)".
        define variable L11314          as char format "x(40)".
        define variable L11315          as char format "x(40)".
        define variable L11316          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1131 = " ".
        V1131 = ENTRY(1,V1131,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1131 = " ".
        V1131 = ENTRY(1,V1131,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1130 = "".
RUN CheckSecurity (INPUT "xsinv31.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes then RUN    xsinv31.p  (input 100).
        leave V1131L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1131 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11311 = "" . 
                display L11311          format "x(40)" skip with fram F1131 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11312 = "" . 
                display L11312          format "x(40)" skip with fram F1131 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11313 = "" . 
                display L11313          format "x(40)" skip with fram F1131 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11314 = "" . 
                display L11314          format "x(40)" skip with fram F1131 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11315 = "" . 
                display L11315          format "x(40)" skip with fram F1131 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11316 = "" . 
                display L11316          format "x(40)" skip with fram F1131 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1131
        WITH  fram F1131 NO-LABEL
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
        IF V1131 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1131 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1131 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1131 ).
        /* **CHANGE Default Site START ** */
        IF V1131 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1131 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1131.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1131.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1131.
        pause 0.
        leave V1131L.
     END.
     PV1131 = V1131.
     /* END    LINE :1131  1.3.1 一级库转二级库  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1131LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1131    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1132    */
   V1132LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1132    */
   IF NOT (V1130 = "32" OR V1100 = "32" ) THEN LEAVE V1132LMAINLOOP.
     /* START  LINE :1132  1.3.2 二级库转一级库  */
     V1132L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1132           as char format "x(150)".
        define variable PV1132          as char format "x(150)".
        define variable L11321          as char format "x(40)".
        define variable L11322          as char format "x(40)".
        define variable L11323          as char format "x(40)".
        define variable L11324          as char format "x(40)".
        define variable L11325          as char format "x(40)".
        define variable L11326          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1132 = " ".
        V1132 = ENTRY(1,V1132,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1132 = " ".
        V1132 = ENTRY(1,V1132,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1130 = "".
RUN CheckSecurity (INPUT "xsinv32.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes then RUN    xsinv32.p  (input 100).
        leave V1132L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1132 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11321 = "" . 
                display L11321          format "x(40)" skip with fram F1132 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11322 = "" . 
                display L11322          format "x(40)" skip with fram F1132 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11323 = "" . 
                display L11323          format "x(40)" skip with fram F1132 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11324 = "" . 
                display L11324          format "x(40)" skip with fram F1132 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11325 = "" . 
                display L11325          format "x(40)" skip with fram F1132 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11326 = "" . 
                display L11326          format "x(40)" skip with fram F1132 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1132
        WITH  fram F1132 NO-LABEL
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
        IF V1132 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1132 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1132 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1132 ).
        /* **CHANGE Default Site START ** */
        IF V1132 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1132 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1132.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1132.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1132.
        pause 0.
        leave V1132L.
     END.
     PV1132 = V1132.
     /* END    LINE :1132  1.3.2 二级库转一级库  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1132LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1132    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1133    */
   V1133LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1133    */
   IF NOT (V1130 = "33" OR V1100 = "33" ) THEN LEAVE V1133LMAINLOOP.
     /* START  LINE :1133  1.3.3 002转101  */
     V1133L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1133           as char format "x(150)".
        define variable PV1133          as char format "x(150)".
        define variable L11331          as char format "x(40)".
        define variable L11332          as char format "x(40)".
        define variable L11333          as char format "x(40)".
        define variable L11334          as char format "x(40)".
        define variable L11335          as char format "x(40)".
        define variable L11336          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1133 = " ".
        V1133 = ENTRY(1,V1133,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1133 = " ".
        V1133 = ENTRY(1,V1133,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1130 = "".
RUN CheckSecurity (INPUT "xsinv33.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes then RUN    xsinv33.p  (input 100).
        leave V1133L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1133 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11331 = "" . 
                display L11331          format "x(40)" skip with fram F1133 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11332 = "" . 
                display L11332          format "x(40)" skip with fram F1133 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11333 = "" . 
                display L11333          format "x(40)" skip with fram F1133 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11334 = "" . 
                display L11334          format "x(40)" skip with fram F1133 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11335 = "" . 
                display L11335          format "x(40)" skip with fram F1133 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11336 = "" . 
                display L11336          format "x(40)" skip with fram F1133 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1133
        WITH  fram F1133 NO-LABEL
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
        IF V1133 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1133 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1133 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1133 ).
        /* **CHANGE Default Site START ** */
        IF V1133 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1133 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1133.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1133.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1133.
        pause 0.
        leave V1133L.
     END.
     PV1133 = V1133.
     /* END    LINE :1133  1.3.3 002转101  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1133LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1133    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1134    */
   V1134LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1134    */
   IF NOT (V1130 = "34" OR V1100 = "34" ) THEN LEAVE V1134LMAINLOOP.
     /* START  LINE :1134  1.3.4 001转202  */
     V1134L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1134           as char format "x(150)".
        define variable PV1134          as char format "x(150)".
        define variable L11341          as char format "x(40)".
        define variable L11342          as char format "x(40)".
        define variable L11343          as char format "x(40)".
        define variable L11344          as char format "x(40)".
        define variable L11345          as char format "x(40)".
        define variable L11346          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1134 = " ".
        V1134 = ENTRY(1,V1134,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1134 = " ".
        V1134 = ENTRY(1,V1134,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1130 = "".
RUN CheckSecurity (INPUT "xsinv34.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes then RUN    xsinv34.p  (input 100).
        leave V1134L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1134 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11341 = "" . 
                display L11341          format "x(40)" skip with fram F1134 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11342 = "" . 
                display L11342          format "x(40)" skip with fram F1134 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11343 = "" . 
                display L11343          format "x(40)" skip with fram F1134 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11344 = "" . 
                display L11344          format "x(40)" skip with fram F1134 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11345 = "" . 
                display L11345          format "x(40)" skip with fram F1134 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11346 = "" . 
                display L11346          format "x(40)" skip with fram F1134 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1134
        WITH  fram F1134 NO-LABEL
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
        IF V1134 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1134 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1134 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1134 ).
        /* **CHANGE Default Site START ** */
        IF V1134 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1134 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1134.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1134.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1134.
        pause 0.
        leave V1134L.
     END.
     PV1134 = V1134.
     /* END    LINE :1134  1.3.4 001转202  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1134LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1134    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1135    */
   V1135LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1135    */
   IF NOT (V1130 = "35" OR V1100 = "35" ) THEN LEAVE V1135LMAINLOOP.
     /* START  LINE :1135  1.3.5 001转205  */
     V1135L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1135           as char format "x(150)".
        define variable PV1135          as char format "x(150)".
        define variable L11351          as char format "x(40)".
        define variable L11352          as char format "x(40)".
        define variable L11353          as char format "x(40)".
        define variable L11354          as char format "x(40)".
        define variable L11355          as char format "x(40)".
        define variable L11356          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1135 = " ".
        V1135 = ENTRY(1,V1135,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1135 = " ".
        V1135 = ENTRY(1,V1135,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1130 = "".
RUN CheckSecurity (INPUT "xsinv35.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes then RUN    xsinv35.p  (input 100).
        leave V1135L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1135 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11351 = "" . 
                display L11351          format "x(40)" skip with fram F1135 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11352 = "" . 
                display L11352          format "x(40)" skip with fram F1135 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11353 = "" . 
                display L11353          format "x(40)" skip with fram F1135 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11354 = "" . 
                display L11354          format "x(40)" skip with fram F1135 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11355 = "" . 
                display L11355          format "x(40)" skip with fram F1135 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11356 = "" . 
                display L11356          format "x(40)" skip with fram F1135 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1135
        WITH  fram F1135 NO-LABEL
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
        IF V1135 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1135 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1135 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1135 ).
        /* **CHANGE Default Site START ** */
        IF V1135 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1135 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1135.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1135.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1135.
        pause 0.
        leave V1135L.
     END.
     PV1135 = V1135.
     /* END    LINE :1135  1.3.5 001转205  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1135LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1135    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1139    */
   V1139LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1139    */
   IF NOT (V1130 = "39" OR V1100 = "39" ) THEN LEAVE V1139LMAINLOOP.
     /* START  LINE :1139  1.3.9 直接生产领料  */
     V1139L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1139           as char format "x(150)".
        define variable PV1139          as char format "x(150)".
        define variable L11391          as char format "x(40)".
        define variable L11392          as char format "x(40)".
        define variable L11393          as char format "x(40)".
        define variable L11394          as char format "x(40)".
        define variable L11395          as char format "x(40)".
        define variable L11396          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1139 = " ".
        V1139 = ENTRY(1,V1139,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1139 = " ".
        V1139 = ENTRY(1,V1139,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1130 = "".
RUN CheckSecurity (INPUT "xsrep01.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes then RUN    xsrep01.p (input 100).
        leave V1139L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1139 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11391 = "" . 
                display L11391          format "x(40)" skip with fram F1139 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11392 = "" . 
                display L11392          format "x(40)" skip with fram F1139 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11393 = "" . 
                display L11393          format "x(40)" skip with fram F1139 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11394 = "" . 
                display L11394          format "x(40)" skip with fram F1139 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11395 = "" . 
                display L11395          format "x(40)" skip with fram F1139 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11396 = "" . 
                display L11396          format "x(40)" skip with fram F1139 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1139
        WITH  fram F1139 NO-LABEL
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
        IF V1139 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1139 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1139 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1139 ).
        /* **CHANGE Default Site START ** */
        IF V1139 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1139 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1139.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1139.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1139.
        pause 0.
        leave V1139L.
     END.
     PV1139 = V1139.
     /* END    LINE :1139  1.3.9 直接生产领料  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1139LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1139    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1140    */
   V1140LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1140    */
   IF NOT (V1100 = "4" ) THEN LEAVE V1140LMAINLOOP.
     /* START  LINE :1140  1.4 盘点菜单  */
     V1140L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1140           as char format "x(150)".
        define variable PV1140          as char format "x(150)".
        define variable L11401          as char format "x(40)".
        define variable L11402          as char format "x(40)".
        define variable L11403          as char format "x(40)".
        define variable L11404          as char format "x(40)".
        define variable L11405          as char format "x(40)".
        define variable L11406          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1140 = " ".
        V1140 = ENTRY(1,V1140,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1140 = " ".
        V1140 = ENTRY(1,V1140,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1140 width 150 no-box.

                /* LABEL 1 - START */ 
                L11401 = "Porite盘点. . . .45" .
                display L11401          format "x(40)" skip with fram F1140 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11402 = "" . 
                display L11402          format "x(40)" skip with fram F1140 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11403 = "" . 
                display L11403          format "x(40)" skip with fram F1140 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11404 = "" . 
                display L11404          format "x(40)" skip with fram F1140 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11405 = "" . 
                display L11405          format "x(40)" skip with fram F1140 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11406 = "" . 
                display L11406          format "x(40)" skip with fram F1140 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1140
        WITH  fram F1140 NO-LABEL
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
        IF V1140 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1140 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1140 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1140 ).
        /* **CHANGE Default Site START ** */
        IF V1140 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1140 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1140.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1140.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1140.
        pause 0.
        leave V1140L.
     END.
     PV1140 = V1140.
     /* END    LINE :1140  1.4 盘点菜单  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1140LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1140    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1141    */
   V1141LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1141    */
   IF NOT (V1140 = "41" OR V1100 = "41" ) THEN LEAVE V1141LMAINLOOP.
     /* START  LINE :1141  1.4.1 周期盘点  */
     V1141L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1141           as char format "x(150)".
        define variable PV1141          as char format "x(150)".
        define variable L11411          as char format "x(40)".
        define variable L11412          as char format "x(40)".
        define variable L11413          as char format "x(40)".
        define variable L11414          as char format "x(40)".
        define variable L11415          as char format "x(40)".
        define variable L11416          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1141 = " ".
        V1141 = ENTRY(1,V1141,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1141 = " ".
        V1141 = ENTRY(1,V1141,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1140 = "".
RUN CheckSecurity (INPUT "xsinv41.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xsinv41.p (input 100).
        leave V1141L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1141 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11411 = "" . 
                display L11411          format "x(40)" skip with fram F1141 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11412 = "" . 
                display L11412          format "x(40)" skip with fram F1141 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11413 = "" . 
                display L11413          format "x(40)" skip with fram F1141 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11414 = "" . 
                display L11414          format "x(40)" skip with fram F1141 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11415 = "" . 
                display L11415          format "x(40)" skip with fram F1141 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11416 = "" . 
                display L11416          format "x(40)" skip with fram F1141 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1141
        WITH  fram F1141 NO-LABEL
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
        IF V1141 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1141 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1141 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1141 ).
        /* **CHANGE Default Site START ** */
        IF V1141 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1141 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1141.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1141.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1141.
        pause 0.
        leave V1141L.
     END.
     PV1141 = V1141.
     /* END    LINE :1141  1.4.1 周期盘点  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1141LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1141    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1142    */
   V1142LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1142    */
   IF NOT (V1140 = "42" OR V1100 = "42" ) THEN LEAVE V1142LMAINLOOP.
     /* START  LINE :1142  1.4.2 初盘(按实物)  */
     V1142L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1142           as char format "x(150)".
        define variable PV1142          as char format "x(150)".
        define variable L11421          as char format "x(40)".
        define variable L11422          as char format "x(40)".
        define variable L11423          as char format "x(40)".
        define variable L11424          as char format "x(40)".
        define variable L11425          as char format "x(40)".
        define variable L11426          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1142 = " ".
        V1142 = ENTRY(1,V1142,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1142 = " ".
        V1142 = ENTRY(1,V1142,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1140 = "".
RUN CheckSecurity (INPUT "xsinv42.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xsinv42.p (input 100).
        leave V1142L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1142 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11421 = "" . 
                display L11421          format "x(40)" skip with fram F1142 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11422 = "" . 
                display L11422          format "x(40)" skip with fram F1142 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11423 = "" . 
                display L11423          format "x(40)" skip with fram F1142 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11424 = "" . 
                display L11424          format "x(40)" skip with fram F1142 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11425 = "" . 
                display L11425          format "x(40)" skip with fram F1142 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11426 = "" . 
                display L11426          format "x(40)" skip with fram F1142 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1142
        WITH  fram F1142 NO-LABEL
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
        IF V1142 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1142 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1142 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1142 ).
        /* **CHANGE Default Site START ** */
        IF V1142 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1142 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1142.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1142.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1142.
        pause 0.
        leave V1142L.
     END.
     PV1142 = V1142.
     /* END    LINE :1142  1.4.2 初盘(按实物)  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1142LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1142    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1143    */
   V1143LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1143    */
   IF NOT (V1140 = "43" OR V1100 = "43" ) THEN LEAVE V1143LMAINLOOP.
     /* START  LINE :1143  1.4.3 初盘(无物有数)  */
     V1143L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1143           as char format "x(150)".
        define variable PV1143          as char format "x(150)".
        define variable L11431          as char format "x(40)".
        define variable L11432          as char format "x(40)".
        define variable L11433          as char format "x(40)".
        define variable L11434          as char format "x(40)".
        define variable L11435          as char format "x(40)".
        define variable L11436          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1143 = " ".
        V1143 = ENTRY(1,V1143,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1143 = " ".
        V1143 = ENTRY(1,V1143,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1140 = "".
RUN CheckSecurity (INPUT "xsinv43.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xsinv43.p (input 100).
        leave V1143L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1143 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11431 = "" . 
                display L11431          format "x(40)" skip with fram F1143 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11432 = "" . 
                display L11432          format "x(40)" skip with fram F1143 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11433 = "" . 
                display L11433          format "x(40)" skip with fram F1143 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11434 = "" . 
                display L11434          format "x(40)" skip with fram F1143 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11435 = "" . 
                display L11435          format "x(40)" skip with fram F1143 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11436 = "" . 
                display L11436          format "x(40)" skip with fram F1143 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1143
        WITH  fram F1143 NO-LABEL
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
        IF V1143 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1143 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1143 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1143 ).
        /* **CHANGE Default Site START ** */
        IF V1143 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1143 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1143.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1143.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1143.
        pause 0.
        leave V1143L.
     END.
     PV1143 = V1143.
     /* END    LINE :1143  1.4.3 初盘(无物有数)  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1143LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1143    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1144    */
   V1144LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1144    */
   IF NOT (V1140 = "44" OR V1100 = "44" ) THEN LEAVE V1144LMAINLOOP.
     /* START  LINE :1144  1.4.4 复盘(BY NBR)  */
     V1144L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1144           as char format "x(150)".
        define variable PV1144          as char format "x(150)".
        define variable L11441          as char format "x(40)".
        define variable L11442          as char format "x(40)".
        define variable L11443          as char format "x(40)".
        define variable L11444          as char format "x(40)".
        define variable L11445          as char format "x(40)".
        define variable L11446          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1144 = " ".
        V1144 = ENTRY(1,V1144,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1144 = " ".
        V1144 = ENTRY(1,V1144,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1140 = "".
RUN CheckSecurity (INPUT "xsinv44.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xsinv44.p (input 100).
        leave V1144L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1144 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11441 = "" . 
                display L11441          format "x(40)" skip with fram F1144 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11442 = "" . 
                display L11442          format "x(40)" skip with fram F1144 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11443 = "" . 
                display L11443          format "x(40)" skip with fram F1144 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11444 = "" . 
                display L11444          format "x(40)" skip with fram F1144 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11445 = "" . 
                display L11445          format "x(40)" skip with fram F1144 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11446 = "" . 
                display L11446          format "x(40)" skip with fram F1144 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1144
        WITH  fram F1144 NO-LABEL
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
        IF V1144 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1144 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1144 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1144 ).
        /* **CHANGE Default Site START ** */
        IF V1144 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1144 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1144.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1144.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1144.
        pause 0.
        leave V1144L.
     END.
     PV1144 = V1144.
     /* END    LINE :1144  1.4.4 复盘(BY NBR)  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1144LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1144    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1145    */
   V1145LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1145    */
   IF NOT (V1140 = "45" OR V1100 = "45" ) THEN LEAVE V1145LMAINLOOP.
     /* START  LINE :1145  1.4.5 Porite盘点  */
     V1145L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1145           as char format "x(150)".
        define variable PV1145          as char format "x(150)".
        define variable L11451          as char format "x(40)".
        define variable L11452          as char format "x(40)".
        define variable L11453          as char format "x(40)".
        define variable L11454          as char format "x(40)".
        define variable L11455          as char format "x(40)".
        define variable L11456          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1145 = " ".
        V1145 = ENTRY(1,V1145,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1145 = " ".
        V1145 = ENTRY(1,V1145,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1140 = "".
RUN CheckSecurity (INPUT "xsinv45.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xsinv45.p (input 100).
        leave V1145L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1145 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11451 = "" . 
                display L11451          format "x(40)" skip with fram F1145 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11452 = "" . 
                display L11452          format "x(40)" skip with fram F1145 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11453 = "" . 
                display L11453          format "x(40)" skip with fram F1145 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11454 = "" . 
                display L11454          format "x(40)" skip with fram F1145 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11455 = "" . 
                display L11455          format "x(40)" skip with fram F1145 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11456 = "" . 
                display L11456          format "x(40)" skip with fram F1145 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1145
        WITH  fram F1145 NO-LABEL
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
        IF V1145 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1145 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1145 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1145 ).
        /* **CHANGE Default Site START ** */
        IF V1145 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1145 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1145.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1145.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1145.
        pause 0.
        leave V1145L.
     END.
     PV1145 = V1145.
     /* END    LINE :1145  1.4.5 Porite盘点  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1145LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1145    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1150    */
   V1150LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1150    */
   IF NOT (V1100 = "5" ) THEN LEAVE V1150LMAINLOOP.
     /* START  LINE :1150  1.5 标签菜单  */
     V1150L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1150           as char format "x(150)".
        define variable PV1150          as char format "x(150)".
        define variable L11501          as char format "x(40)".
        define variable L11502          as char format "x(40)".
        define variable L11503          as char format "x(40)".
        define variable L11504          as char format "x(40)".
        define variable L11505          as char format "x(40)".
        define variable L11506          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1150 = " ".
        V1150 = ENTRY(1,V1150,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1150 = " ".
        V1150 = ENTRY(1,V1150,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1150 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11501 = "" . 
                display L11501          format "x(40)" skip with fram F1150 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11502 = "" . 
                display L11502          format "x(40)" skip with fram F1150 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11503 = "" . 
                display L11503          format "x(40)" skip with fram F1150 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11504 = "" . 
                display L11504          format "x(40)" skip with fram F1150 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11505 = "" . 
                display L11505          format "x(40)" skip with fram F1150 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11506 = "" . 
                display L11506          format "x(40)" skip with fram F1150 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1150
        WITH  fram F1150 NO-LABEL
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
        IF V1150 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1150 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1150 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1150 ).
        /* **CHANGE Default Site START ** */
        IF V1150 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1150 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1150.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1150.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1150.
        pause 0.
        leave V1150L.
     END.
     PV1150 = V1150.
     /* END    LINE :1150  1.5 标签菜单  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1150LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1150    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1151    */
   V1151LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1151    */
   IF NOT (V1150 = "51" OR V1100 = "51" ) THEN LEAVE V1151LMAINLOOP.
     /* START  LINE :1151  1.5.1 标准标签打印  */
     V1151L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1151           as char format "x(150)".
        define variable PV1151          as char format "x(150)".
        define variable L11511          as char format "x(40)".
        define variable L11512          as char format "x(40)".
        define variable L11513          as char format "x(40)".
        define variable L11514          as char format "x(40)".
        define variable L11515          as char format "x(40)".
        define variable L11516          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1151 = " ".
        V1151 = ENTRY(1,V1151,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1151 = " ".
        V1151 = ENTRY(1,V1151,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1150 = "".
RUN CheckSecurity (INPUT "xslap03.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xslap03.p (input 100).
        leave V1151L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1151 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11511 = "" . 
                display L11511          format "x(40)" skip with fram F1151 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11512 = "" . 
                display L11512          format "x(40)" skip with fram F1151 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11513 = "" . 
                display L11513          format "x(40)" skip with fram F1151 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11514 = "" . 
                display L11514          format "x(40)" skip with fram F1151 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11515 = "" . 
                display L11515          format "x(40)" skip with fram F1151 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11516 = "" . 
                display L11516          format "x(40)" skip with fram F1151 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1151
        WITH  fram F1151 NO-LABEL
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
        IF V1151 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1151 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1151 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1151 ).
        /* **CHANGE Default Site START ** */
        IF V1151 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1151 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1151.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1151.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1151.
        pause 0.
        leave V1151L.
     END.
     PV1151 = V1151.
     /* END    LINE :1151  1.5.1 标准标签打印  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1151LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1151    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1152    */
   V1152LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1152    */
   IF NOT (V1150 = "52" OR V1100 = "52" ) THEN LEAVE V1152LMAINLOOP.
     /* START  LINE :1152  1.5.2 库存标签打印  */
     V1152L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1152           as char format "x(150)".
        define variable PV1152          as char format "x(150)".
        define variable L11521          as char format "x(40)".
        define variable L11522          as char format "x(40)".
        define variable L11523          as char format "x(40)".
        define variable L11524          as char format "x(40)".
        define variable L11525          as char format "x(40)".
        define variable L11526          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1152 = " ".
        V1152 = ENTRY(1,V1152,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1152 = " ".
        V1152 = ENTRY(1,V1152,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1150 = "".
RUN CheckSecurity (INPUT "xslap04.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xslap04.p (input 100).
        leave V1152L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1152 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11521 = "" . 
                display L11521          format "x(40)" skip with fram F1152 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11522 = "" . 
                display L11522          format "x(40)" skip with fram F1152 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11523 = "" . 
                display L11523          format "x(40)" skip with fram F1152 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11524 = "" . 
                display L11524          format "x(40)" skip with fram F1152 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11525 = "" . 
                display L11525          format "x(40)" skip with fram F1152 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11526 = "" . 
                display L11526          format "x(40)" skip with fram F1152 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1152
        WITH  fram F1152 NO-LABEL
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
        IF V1152 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1152 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1152 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1152 ).
        /* **CHANGE Default Site START ** */
        IF V1152 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1152 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1152.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1152.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1152.
        pause 0.
        leave V1152L.
     END.
     PV1152 = V1152.
     /* END    LINE :1152  1.5.2 库存标签打印  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1152LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1152    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1153    */
   V1153LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1153    */
   IF NOT (V1150 = "53" OR V1100 = "53" ) THEN LEAVE V1153LMAINLOOP.
     /* START  LINE :1153  1.5.3 取消打印列队  */
     V1153L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1153           as char format "x(150)".
        define variable PV1153          as char format "x(150)".
        define variable L11531          as char format "x(40)".
        define variable L11532          as char format "x(40)".
        define variable L11533          as char format "x(40)".
        define variable L11534          as char format "x(40)".
        define variable L11535          as char format "x(40)".
        define variable L11536          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1153 = " ".
        V1153 = ENTRY(1,V1153,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1153 = " ".
        V1153 = ENTRY(1,V1153,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1150 = "".
RUN CheckSecurity (INPUT "xslap05.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xslap05.p (input 100).
        leave V1153L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1153 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11531 = "" . 
                display L11531          format "x(40)" skip with fram F1153 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11532 = "" . 
                display L11532          format "x(40)" skip with fram F1153 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11533 = "" . 
                display L11533          format "x(40)" skip with fram F1153 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11534 = "" . 
                display L11534          format "x(40)" skip with fram F1153 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11535 = "" . 
                display L11535          format "x(40)" skip with fram F1153 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11536 = "" . 
                display L11536          format "x(40)" skip with fram F1153 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1153
        WITH  fram F1153 NO-LABEL
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
        IF V1153 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1153 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1153 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1153 ).
        /* **CHANGE Default Site START ** */
        IF V1153 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1153 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1153.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1153.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1153.
        pause 0.
        leave V1153L.
     END.
     PV1153 = V1153.
     /* END    LINE :1153  1.5.3 取消打印列队  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1153LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1153    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1154    */
   V1154LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1154    */
   IF NOT (V1150 = "54" OR V1100 = "54" ) THEN LEAVE V1154LMAINLOOP.
     /* START  LINE :1154  1.5.4 自制标签补打  */
     V1154L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1154           as char format "x(150)".
        define variable PV1154          as char format "x(150)".
        define variable L11541          as char format "x(40)".
        define variable L11542          as char format "x(40)".
        define variable L11543          as char format "x(40)".
        define variable L11544          as char format "x(40)".
        define variable L11545          as char format "x(40)".
        define variable L11546          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1154 = " ".
        V1154 = ENTRY(1,V1154,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1154 = " ".
        V1154 = ENTRY(1,V1154,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1150 = "".
RUN CheckSecurity (INPUT "xslap08.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xslap08.p (input 100).
        leave V1154L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1154 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11541 = "" . 
                display L11541          format "x(40)" skip with fram F1154 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11542 = "" . 
                display L11542          format "x(40)" skip with fram F1154 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11543 = "" . 
                display L11543          format "x(40)" skip with fram F1154 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11544 = "" . 
                display L11544          format "x(40)" skip with fram F1154 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11545 = "" . 
                display L11545          format "x(40)" skip with fram F1154 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11546 = "" . 
                display L11546          format "x(40)" skip with fram F1154 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1154
        WITH  fram F1154 NO-LABEL
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
        IF V1154 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1154 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1154 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1154 ).
        /* **CHANGE Default Site START ** */
        IF V1154 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1154 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1154.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1154.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1154.
        pause 0.
        leave V1154L.
     END.
     PV1154 = V1154.
     /* END    LINE :1154  1.5.4 自制标签补打  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1154LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1154    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1155    */
   V1155LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1155    */
   IF NOT (V1150 = "55" OR V1100 = "55" ) THEN LEAVE V1155LMAINLOOP.
     /* START  LINE :1155  1.5.5 自制标签入库  */
     V1155L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1155           as char format "x(150)".
        define variable PV1155          as char format "x(150)".
        define variable L11551          as char format "x(40)".
        define variable L11552          as char format "x(40)".
        define variable L11553          as char format "x(40)".
        define variable L11554          as char format "x(40)".
        define variable L11555          as char format "x(40)".
        define variable L11556          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1155 = " ".
        V1155 = ENTRY(1,V1155,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1155 = " ".
        V1155 = ENTRY(1,V1155,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1150 = "".
RUN CheckSecurity (INPUT "xswor03.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xswor03.p (input 100).
        leave V1155L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1155 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11551 = "" . 
                display L11551          format "x(40)" skip with fram F1155 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11552 = "" . 
                display L11552          format "x(40)" skip with fram F1155 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11553 = "" . 
                display L11553          format "x(40)" skip with fram F1155 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11554 = "" . 
                display L11554          format "x(40)" skip with fram F1155 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11555 = "" . 
                display L11555          format "x(40)" skip with fram F1155 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11556 = "" . 
                display L11556          format "x(40)" skip with fram F1155 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1155
        WITH  fram F1155 NO-LABEL
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
        IF V1155 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1155 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1155 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1155 ).
        /* **CHANGE Default Site START ** */
        IF V1155 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1155 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1155.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1155.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1155.
        pause 0.
        leave V1155L.
     END.
     PV1155 = V1155.
     /* END    LINE :1155  1.5.5 自制标签入库  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1155LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1155    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1156    */
   V1156LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1156    */
   IF NOT (V1150 = "56" OR V1100 = "56" ) THEN LEAVE V1156LMAINLOOP.
     /* START  LINE :1156  1.5.6 自制标签打印  */
     V1156L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1156           as char format "x(150)".
        define variable PV1156          as char format "x(150)".
        define variable L11561          as char format "x(40)".
        define variable L11562          as char format "x(40)".
        define variable L11563          as char format "x(40)".
        define variable L11564          as char format "x(40)".
        define variable L11565          as char format "x(40)".
        define variable L11566          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1156 = " ".
        V1156 = ENTRY(1,V1156,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1156 = " ".
        V1156 = ENTRY(1,V1156,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1150 = "".
RUN CheckSecurity (INPUT "xslap07.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xslap07.p (input 100).
        leave V1156L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1156 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11561 = "" . 
                display L11561          format "x(40)" skip with fram F1156 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11562 = "" . 
                display L11562          format "x(40)" skip with fram F1156 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11563 = "" . 
                display L11563          format "x(40)" skip with fram F1156 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11564 = "" . 
                display L11564          format "x(40)" skip with fram F1156 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11565 = "" . 
                display L11565          format "x(40)" skip with fram F1156 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11566 = "" . 
                display L11566          format "x(40)" skip with fram F1156 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1156
        WITH  fram F1156 NO-LABEL
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
        IF V1156 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1156 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1156 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1156 ).
        /* **CHANGE Default Site START ** */
        IF V1156 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1156 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1156.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1156.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1156.
        pause 0.
        leave V1156L.
     END.
     PV1156 = V1156.
     /* END    LINE :1156  1.5.6 自制标签打印  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1156LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1156    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1160    */
   V1160LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1160    */
   IF NOT (V1100 = "6" ) THEN LEAVE V1160LMAINLOOP.
     /* START  LINE :1160  1.6 库存菜单  */
     V1160L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1160           as char format "x(150)".
        define variable PV1160          as char format "x(150)".
        define variable L11601          as char format "x(40)".
        define variable L11602          as char format "x(40)".
        define variable L11603          as char format "x(40)".
        define variable L11604          as char format "x(40)".
        define variable L11605          as char format "x(40)".
        define variable L11606          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1160 = " ".
        V1160 = ENTRY(1,V1160,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1160 = " ".
        V1160 = ENTRY(1,V1160,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1160 width 150 no-box.

                /* LABEL 1 - START */ 
                L11601 = "计划外出库. . .61" .
                display L11601          format "x(40)" skip with fram F1160 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11602 = "计划外入库. . .62" .
                display L11602          format "x(40)" skip with fram F1160 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11603 = "库存转移. . . .63" .
                display L11603          format "x(40)" skip with fram F1160 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11604 = "库位库存查询. .64" .
                display L11604          format "x(40)" skip with fram F1160 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                L11605 = "批号库存查询. .65" .
                display L11605          format "x(40)" skip with fram F1160 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                L11606 = "交易查询. . . .66" .
                display L11606          format "x(40)" skip with fram F1160 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1160
        WITH  fram F1160 NO-LABEL
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
        IF V1160 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1160 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1160 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1160 ).
        /* **CHANGE Default Site START ** */
        IF V1160 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1160 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1160.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1160.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1160.
        pause 0.
        leave V1160L.
     END.
     PV1160 = V1160.
     /* END    LINE :1160  1.6 库存菜单  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1160LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1160    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1161    */
   V1161LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1161    */
   IF NOT (V1160 = "61" OR V1100 = "61" ) THEN LEAVE V1161LMAINLOOP.
     /* START  LINE :1161  1.6.1 计划外出库  */
     V1161L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1161           as char format "x(150)".
        define variable PV1161          as char format "x(150)".
        define variable L11611          as char format "x(40)".
        define variable L11612          as char format "x(40)".
        define variable L11613          as char format "x(40)".
        define variable L11614          as char format "x(40)".
        define variable L11615          as char format "x(40)".
        define variable L11616          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1161 = " ".
        V1161 = ENTRY(1,V1161,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1161 = " ".
        V1161 = ENTRY(1,V1161,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1160 = "".
RUN CheckSecurity (INPUT "xsinv21.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xsinv21.p (input 100).
        leave V1161L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1161 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11611 = "" . 
                display L11611          format "x(40)" skip with fram F1161 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11612 = "" . 
                display L11612          format "x(40)" skip with fram F1161 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11613 = "" . 
                display L11613          format "x(40)" skip with fram F1161 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11614 = "" . 
                display L11614          format "x(40)" skip with fram F1161 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11615 = "" . 
                display L11615          format "x(40)" skip with fram F1161 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11616 = "" . 
                display L11616          format "x(40)" skip with fram F1161 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1161
        WITH  fram F1161 NO-LABEL
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
        IF V1161 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1161 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1161 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1161 ).
        /* **CHANGE Default Site START ** */
        IF V1161 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1161 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1161.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1161.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1161.
        pause 0.
        leave V1161L.
     END.
     PV1161 = V1161.
     /* END    LINE :1161  1.6.1 计划外出库  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1161LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1161    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1162    */
   V1162LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1162    */
   IF NOT (V1160 = "62" OR V1100 = "62" ) THEN LEAVE V1162LMAINLOOP.
     /* START  LINE :1162  1.6.2 计划外入库  */
     V1162L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1162           as char format "x(150)".
        define variable PV1162          as char format "x(150)".
        define variable L11621          as char format "x(40)".
        define variable L11622          as char format "x(40)".
        define variable L11623          as char format "x(40)".
        define variable L11624          as char format "x(40)".
        define variable L11625          as char format "x(40)".
        define variable L11626          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1162 = " ".
        V1162 = ENTRY(1,V1162,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1162 = " ".
        V1162 = ENTRY(1,V1162,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1160 = "".
RUN CheckSecurity (INPUT "xsinv22.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xsinv22.p (input 100).
        leave V1162L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1162 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11621 = "" . 
                display L11621          format "x(40)" skip with fram F1162 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11622 = "" . 
                display L11622          format "x(40)" skip with fram F1162 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11623 = "" . 
                display L11623          format "x(40)" skip with fram F1162 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11624 = "" . 
                display L11624          format "x(40)" skip with fram F1162 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11625 = "" . 
                display L11625          format "x(40)" skip with fram F1162 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11626 = "" . 
                display L11626          format "x(40)" skip with fram F1162 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1162
        WITH  fram F1162 NO-LABEL
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
        IF V1162 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1162 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1162 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1162 ).
        /* **CHANGE Default Site START ** */
        IF V1162 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1162 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1162.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1162.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1162.
        pause 0.
        leave V1162L.
     END.
     PV1162 = V1162.
     /* END    LINE :1162  1.6.2 计划外入库  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1162LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1162    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1163    */
   V1163LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1163    */
   IF NOT (V1160 = "63" OR V1100 = "63" ) THEN LEAVE V1163LMAINLOOP.
     /* START  LINE :1163  1.6.3 库存转移  */
     V1163L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1163           as char format "x(150)".
        define variable PV1163          as char format "x(150)".
        define variable L11631          as char format "x(40)".
        define variable L11632          as char format "x(40)".
        define variable L11633          as char format "x(40)".
        define variable L11634          as char format "x(40)".
        define variable L11635          as char format "x(40)".
        define variable L11636          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1163 = " ".
        V1163 = ENTRY(1,V1163,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1163 = " ".
        V1163 = ENTRY(1,V1163,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1160 = "".
RUN CheckSecurity (INPUT "xsinv23.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xsinv23.p (input 100).
        leave V1163L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1163 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11631 = "" . 
                display L11631          format "x(40)" skip with fram F1163 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11632 = "" . 
                display L11632          format "x(40)" skip with fram F1163 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11633 = "" . 
                display L11633          format "x(40)" skip with fram F1163 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11634 = "" . 
                display L11634          format "x(40)" skip with fram F1163 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11635 = "" . 
                display L11635          format "x(40)" skip with fram F1163 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11636 = "" . 
                display L11636          format "x(40)" skip with fram F1163 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1163
        WITH  fram F1163 NO-LABEL
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
        IF V1163 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1163 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1163 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1163 ).
        /* **CHANGE Default Site START ** */
        IF V1163 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1163 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1163.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1163.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1163.
        pause 0.
        leave V1163L.
     END.
     PV1163 = V1163.
     /* END    LINE :1163  1.6.3 库存转移  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1163LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1163    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1164    */
   V1164LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1164    */
   IF NOT (V1160 = "64" OR V1100 = "64" ) THEN LEAVE V1164LMAINLOOP.
     /* START  LINE :1164  1.6.4 库位库存查询  */
     V1164L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1164           as char format "x(150)".
        define variable PV1164          as char format "x(150)".
        define variable L11641          as char format "x(40)".
        define variable L11642          as char format "x(40)".
        define variable L11643          as char format "x(40)".
        define variable L11644          as char format "x(40)".
        define variable L11645          as char format "x(40)".
        define variable L11646          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1164 = " ".
        V1164 = ENTRY(1,V1164,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1164 = " ".
        V1164 = ENTRY(1,V1164,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1160 = "".
RUN CheckSecurity (INPUT "xsinv03.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xsinv03.p (input 100).
        leave V1164L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1164 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11641 = "" . 
                display L11641          format "x(40)" skip with fram F1164 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11642 = "" . 
                display L11642          format "x(40)" skip with fram F1164 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11643 = "" . 
                display L11643          format "x(40)" skip with fram F1164 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11644 = "" . 
                display L11644          format "x(40)" skip with fram F1164 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11645 = "" . 
                display L11645          format "x(40)" skip with fram F1164 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11646 = "" . 
                display L11646          format "x(40)" skip with fram F1164 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1164
        WITH  fram F1164 NO-LABEL
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
        IF V1164 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1164 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1164 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1164 ).
        /* **CHANGE Default Site START ** */
        IF V1164 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1164 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1164.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1164.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1164.
        pause 0.
        leave V1164L.
     END.
     PV1164 = V1164.
     /* END    LINE :1164  1.6.4 库位库存查询  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1164LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1164    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1165    */
   V1165LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1165    */
   IF NOT (V1160 = "65" OR V1100 = "65" ) THEN LEAVE V1165LMAINLOOP.
     /* START  LINE :1165  1.6.5 批号库存查询  */
     V1165L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1165           as char format "x(150)".
        define variable PV1165          as char format "x(150)".
        define variable L11651          as char format "x(40)".
        define variable L11652          as char format "x(40)".
        define variable L11653          as char format "x(40)".
        define variable L11654          as char format "x(40)".
        define variable L11655          as char format "x(40)".
        define variable L11656          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1165 = " ".
        V1165 = ENTRY(1,V1165,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1165 = " ".
        V1165 = ENTRY(1,V1165,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1160 = "".
RUN CheckSecurity (INPUT "xsinv02.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xsinv02.p (input 100).
        leave V1165L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1165 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11651 = "" . 
                display L11651          format "x(40)" skip with fram F1165 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11652 = "" . 
                display L11652          format "x(40)" skip with fram F1165 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11653 = "" . 
                display L11653          format "x(40)" skip with fram F1165 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11654 = "" . 
                display L11654          format "x(40)" skip with fram F1165 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11655 = "" . 
                display L11655          format "x(40)" skip with fram F1165 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11656 = "" . 
                display L11656          format "x(40)" skip with fram F1165 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1165
        WITH  fram F1165 NO-LABEL
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
        IF V1165 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1165 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1165 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1165 ).
        /* **CHANGE Default Site START ** */
        IF V1165 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1165 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1165.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1165.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1165.
        pause 0.
        leave V1165L.
     END.
     PV1165 = V1165.
     /* END    LINE :1165  1.6.5 批号库存查询  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1165LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1165    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1166    */
   V1166LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1166    */
   IF NOT (V1160 = "66" OR V1100 = "66" ) THEN LEAVE V1166LMAINLOOP.
     /* START  LINE :1166  1.6.6 交易查询  */
     V1166L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1166           as char format "x(150)".
        define variable PV1166          as char format "x(150)".
        define variable L11661          as char format "x(40)".
        define variable L11662          as char format "x(40)".
        define variable L11663          as char format "x(40)".
        define variable L11664          as char format "x(40)".
        define variable L11665          as char format "x(40)".
        define variable L11666          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1166 = " ".
        V1166 = ENTRY(1,V1166,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1166 = " ".
        V1166 = ENTRY(1,V1166,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1160 = "".
RUN CheckSecurity (INPUT "xsinv99.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xsinv99.p (input 100).
        leave V1166L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1166 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11661 = "" . 
                display L11661          format "x(40)" skip with fram F1166 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11662 = "" . 
                display L11662          format "x(40)" skip with fram F1166 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11663 = "" . 
                display L11663          format "x(40)" skip with fram F1166 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11664 = "" . 
                display L11664          format "x(40)" skip with fram F1166 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11665 = "" . 
                display L11665          format "x(40)" skip with fram F1166 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11666 = "" . 
                display L11666          format "x(40)" skip with fram F1166 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1166
        WITH  fram F1166 NO-LABEL
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
        IF V1166 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1166 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1166 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1166 ).
        /* **CHANGE Default Site START ** */
        IF V1166 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1166 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1166.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1166.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1166.
        pause 0.
        leave V1166L.
     END.
     PV1166 = V1166.
     /* END    LINE :1166  1.6.6 交易查询  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1166LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1166    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1180    */
   V1180LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1180    */
   IF NOT (V1100 = "8" ) THEN LEAVE V1180LMAINLOOP.
     /* START  LINE :1180  1.8 加强菜单  */
     V1180L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1180           as char format "x(150)".
        define variable PV1180          as char format "x(150)".
        define variable L11801          as char format "x(40)".
        define variable L11802          as char format "x(40)".
        define variable L11803          as char format "x(40)".
        define variable L11804          as char format "x(40)".
        define variable L11805          as char format "x(40)".
        define variable L11806          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1180 = " ".
        V1180 = ENTRY(1,V1180,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1180 = " ".
        V1180 = ENTRY(1,V1180,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1180 width 150 no-box.

                /* LABEL 1 - START */ 
                L11801 = "计划外出正常料.81" .
                display L11801          format "x(40)" skip with fram F1180 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11802 = "计划外出过期料.82" .
                display L11802          format "x(40)" skip with fram F1180 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11803 = "库存标签分箱...83" .
                display L11803          format "x(40)" skip with fram F1180 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11804 = "" . 
                display L11804          format "x(40)" skip with fram F1180 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11805 = "" . 
                display L11805          format "x(40)" skip with fram F1180 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11806 = "" . 
                display L11806          format "x(40)" skip with fram F1180 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1180
        WITH  fram F1180 NO-LABEL
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
        IF V1180 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1180 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1180 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1180 ).
        /* **CHANGE Default Site START ** */
        IF V1180 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1180 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1180.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1180.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1180.
        pause 0.
        leave V1180L.
     END.
     PV1180 = V1180.
     /* END    LINE :1180  1.8 加强菜单  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1180LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1180    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1181    */
   V1181LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1181    */
   IF NOT (V1180 = "81" OR V1100 = "81" ) THEN LEAVE V1181LMAINLOOP.
     /* START  LINE :1181  1.8.1 计划外出正常料  */
     V1181L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1181           as char format "x(150)".
        define variable PV1181          as char format "x(150)".
        define variable L11811          as char format "x(40)".
        define variable L11812          as char format "x(40)".
        define variable L11813          as char format "x(40)".
        define variable L11814          as char format "x(40)".
        define variable L11815          as char format "x(40)".
        define variable L11816          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1181 = " ".
        V1181 = ENTRY(1,V1181,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1181 = " ".
        V1181 = ENTRY(1,V1181,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1180 = "".
RUN CheckSecurity (INPUT "xsinv24.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xsinv24.p (input 100).
        leave V1181L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1181 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11811 = "" . 
                display L11811          format "x(40)" skip with fram F1181 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11812 = "" . 
                display L11812          format "x(40)" skip with fram F1181 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11813 = "" . 
                display L11813          format "x(40)" skip with fram F1181 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11814 = "" . 
                display L11814          format "x(40)" skip with fram F1181 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11815 = "" . 
                display L11815          format "x(40)" skip with fram F1181 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11816 = "" . 
                display L11816          format "x(40)" skip with fram F1181 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1181
        WITH  fram F1181 NO-LABEL
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
        IF V1181 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1181 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1181 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1181 ).
        /* **CHANGE Default Site START ** */
        IF V1181 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1181 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1181.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1181.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1181.
        pause 0.
        leave V1181L.
     END.
     PV1181 = V1181.
     /* END    LINE :1181  1.8.1 计划外出正常料  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1181LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1181    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1182    */
   V1182LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1182    */
   IF NOT (V1180 = "82" OR V1100 = "82" ) THEN LEAVE V1182LMAINLOOP.
     /* START  LINE :1182  1.8.2 计划外出过期料  */
     V1182L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1182           as char format "x(150)".
        define variable PV1182          as char format "x(150)".
        define variable L11821          as char format "x(40)".
        define variable L11822          as char format "x(40)".
        define variable L11823          as char format "x(40)".
        define variable L11824          as char format "x(40)".
        define variable L11825          as char format "x(40)".
        define variable L11826          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1182 = " ".
        V1182 = ENTRY(1,V1182,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1182 = " ".
        V1182 = ENTRY(1,V1182,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1180 = "".
RUN CheckSecurity (INPUT "xsinv25.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xsinv25.p (input 100).
        leave V1182L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1182 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11821 = "" . 
                display L11821          format "x(40)" skip with fram F1182 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11822 = "" . 
                display L11822          format "x(40)" skip with fram F1182 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11823 = "" . 
                display L11823          format "x(40)" skip with fram F1182 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11824 = "" . 
                display L11824          format "x(40)" skip with fram F1182 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11825 = "" . 
                display L11825          format "x(40)" skip with fram F1182 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11826 = "" . 
                display L11826          format "x(40)" skip with fram F1182 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1182
        WITH  fram F1182 NO-LABEL
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
        IF V1182 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1182 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1182 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1182 ).
        /* **CHANGE Default Site START ** */
        IF V1182 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1182 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1182.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1182.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1182.
        pause 0.
        leave V1182L.
     END.
     PV1182 = V1182.
     /* END    LINE :1182  1.8.2 计划外出过期料  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1182LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1182    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1183    */
   V1183LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1183    */
   IF NOT (V1180 = "83" OR V1100 = "83" ) THEN LEAVE V1183LMAINLOOP.
     /* START  LINE :1183  1.8.3 库存标签分箱  */
     V1183L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1183           as char format "x(150)".
        define variable PV1183          as char format "x(150)".
        define variable L11831          as char format "x(40)".
        define variable L11832          as char format "x(40)".
        define variable L11833          as char format "x(40)".
        define variable L11834          as char format "x(40)".
        define variable L11835          as char format "x(40)".
        define variable L11836          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        V1183 = " ".
        V1183 = ENTRY(1,V1183,"@").
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1183 = " ".
        V1183 = ENTRY(1,V1183,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1180 = "".
RUN CheckSecurity (INPUT "xslap09.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xslap09.p (input 100).
        leave V1183L.
        /* LOGICAL SKIP END */
                display "#条码# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1183 width 150 no-box.

                /* LABEL 1 - START */ 
                  L11831 = "" . 
                display L11831          format "x(40)" skip with fram F1183 width 150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11832 = "" . 
                display L11832          format "x(40)" skip with fram F1183 width 150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11833 = "" . 
                display L11833          format "x(40)" skip with fram F1183 width 150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11834 = "" . 
                display L11834          format "x(40)" skip with fram F1183 width 150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11835 = "" . 
                display L11835          format "x(40)" skip with fram F1183 width 150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11836 = "" . 
                display L11836          format "x(40)" skip with fram F1183 width 150 no-box.
                /* LABEL 6 - END */ 
        Update V1183
        WITH  fram F1183 NO-LABEL
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
        IF V1183 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1183 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1183 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1183 ).
        /* **CHANGE Default Site START ** */
        IF V1183 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        /* **CHANGE Default DOMAIN START ** */
        IF V1183 = "D" THEN  RUN xsmdf02.p.
        /* **CHANGE DEFAULT DOMAIN END ** */
        display  skip WMESSAGE NO-LABEL with fram F1183.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1183.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1183.
        pause 0.
        leave V1183L.
     END.
     PV1183 = V1183.
     /* END    LINE :1183  1.8.3 库存标签分箱  */


   /* Without Condition Exit Cycle Start */ 
   LEAVE V1183LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1183    */
   END.
   pause 0 before-hide.
end.
