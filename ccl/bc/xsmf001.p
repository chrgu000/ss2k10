/* Generate By Barcode Generator , Copyright by Softspeed - Build By Sam Song  */ 
/* BARCODE SYSTEM */
/* Generate date / time  10/26/07 10:22:03 */
define variable sectionid as integer init 0 .
define variable WMESSAGE  as char format "x(80)" init "".
define variable wtm_num   as char format "x(20)" init "0".
define variable wtm_fm    as char format "x(16)".
define variable wsection as char format "x(16)".
define variable i as integer .
define variable errstr as char .

define variable wtimeout as integer init 99999 .
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout" no-lock no-error. /*  Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="xsmf001wtimeout" no-lock no-error. /*  Timeout - Program Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

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
        display " *** WARNING *** " skip with fram WarningBox no-box . 
         display " YOU CAN NOT" skip with fram WarningBox no-box .
         display " ACCESS THIS" skip with fram WarningBox no-box . 
         display "  FUNCTION!" skip with fram WarningBox no-box .
         display " CONTACT IT " skip with fram WarningBox no-box .
         display " DEPARTMENT " skip with fram WarningBox no-box .
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
         Display "UPDATE...... "  skip with fram UpdateBox no-box  .
         Display trim ( ProgramID )      no-label  skip with fram UpdateBox no-box .
         Display trim ( ProgramFunction ) no-label skip with fram UpdateBox no-box .
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

     /* START  LINE :1002  翴[SITE]  */
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
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1002 no-box.

                /* LABEL 1 - START */ 
                L10021 = "翴砞﹚Τ粇" .
                display L10021          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L10022 = "1.⊿Τ砞﹚纐粄翴" .
                display L10022          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L10023 = "2.舦砞﹚Τ粇" .
                display L10023          format "x(40)" skip with fram F1002 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L10024 = "  叫琩" .
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
        /* **CHANGE Default Site END ** */
        IF V1002 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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
     /* END    LINE :1002  翴[SITE]  */


   /* Additional Labels Format */
     /* START  LINE :1100  1主菜单  */
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
        V1100 = " ".
        V1100 = ENTRY(1,V1100,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1100 no-box.

                /* LABEL 1 - START */ 
                L11001 = "蹦潦垫虫. . . .1" .
                display L11001          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11002 = "虫垫虫. . . .3" .
                display L11002          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11003 = "絃翴垫虫. . . .4" .
                display L11003          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11004 = "夹帽垫虫. . . .5" .
                display L11004          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                L11005 = "畐垫虫. . . .6" .
                display L11005          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                L11006 = "綪扳垫虫. . . .7" .
                display L11006          format "x(40)" skip with fram F1100 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1100 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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


   /* Additional Labels Format */
   /* Internal Cycle Input :1110    */
   V1110LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1110    */
   IF NOT (V1100 = "1" ) THEN LEAVE V1110LMAINLOOP.
     /* START  LINE :1110  1.1 收货菜单  */
     V1110L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1110           as char format "x(50)".
        define variable PV1110          as char format "x(50)".
        define variable L11101          as char format "x(40)".
        define variable L11102          as char format "x(40)".
        define variable L11103          as char format "x(40)".
        define variable L11104          as char format "x(40)".
        define variable L11105          as char format "x(40)".
        define variable L11106          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1110 = " ".
        V1110 = ENTRY(1,V1110,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1110 no-box.

                /* LABEL 1 - START */ 
                L11101 = "POΜ砯[]. .11" .
                display L11101          format "x(40)" skip with fram F1110 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11102 = "POΜ砯[〆]. .12" .
                display L11102          format "x(40)" skip with fram F1110 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11103 = "POΜ砯[腨北]. .13" .
                display L11103          format "x(40)" skip with fram F1110 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11104 = "" . 
                display L11104          format "x(40)" skip with fram F1110 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11105 = "" . 
                display L11105          format "x(40)" skip with fram F1110 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11106 = "" . 
                display L11106          format "x(40)" skip with fram F1110 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1110 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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
     /* END    LINE :1110  1.1 收货菜单  */


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1110LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1110    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1111    */
   V1111LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1111    */
   IF NOT (V1110 = "11" OR V1100 = "11" ) THEN LEAVE V1111LMAINLOOP.
     /* START  LINE :1111  1.1.1 PO收货[一般]  */
     V1111L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1111           as char format "x(50)".
        define variable PV1111          as char format "x(50)".
        define variable L11111          as char format "x(40)".
        define variable L11112          as char format "x(40)".
        define variable L11113          as char format "x(40)".
        define variable L11114          as char format "x(40)".
        define variable L11115          as char format "x(40)".
        define variable L11116          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1111 = " ".
        V1111 = ENTRY(1,V1111,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1110 = "".
RUN CheckSecurity (INPUT "xspor01.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes then RUN    xspor01.p.
        leave V1111L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1111 no-box.

                /* LABEL 1 - START */ 
                  L11111 = "" . 
                display L11111          format "x(40)" skip with fram F1111 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11112 = "" . 
                display L11112          format "x(40)" skip with fram F1111 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11113 = "" . 
                display L11113          format "x(40)" skip with fram F1111 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11114 = "" . 
                display L11114          format "x(40)" skip with fram F1111 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11115 = "" . 
                display L11115          format "x(40)" skip with fram F1111 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11116 = "" . 
                display L11116          format "x(40)" skip with fram F1111 no-box.
                /* LABEL 6 - END */ 
        Update V1111
        WITH  fram F1111 NO-LABEL
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
        IF V1111 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1111 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1111 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1111 ).
        /* **CHANGE Default Site END ** */
        IF V1111 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        display  skip WMESSAGE NO-LABEL with fram F1111.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1111.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1111.
        pause 0.
        leave V1111L.
     END.
     PV1111 = V1111.
     /* END    LINE :1111  1.1.1 PO收货[一般]  */


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1111LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1111    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1112    */
   V1112LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1112    */
   IF NOT (V1110 = "12" OR V1100 = "12" ) THEN LEAVE V1112LMAINLOOP.
     /* START  LINE :1112  1.1.2 PO收货[委外]  */
     V1112L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1112           as char format "x(50)".
        define variable PV1112          as char format "x(50)".
        define variable L11121          as char format "x(40)".
        define variable L11122          as char format "x(40)".
        define variable L11123          as char format "x(40)".
        define variable L11124          as char format "x(40)".
        define variable L11125          as char format "x(40)".
        define variable L11126          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1112 = " ".
        V1112 = ENTRY(1,V1112,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1110 = "".
RUN CheckSecurity (INPUT "xspor02.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes then RUN    xspor02.p.
        leave V1112L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1112 no-box.

                /* LABEL 1 - START */ 
                  L11121 = "" . 
                display L11121          format "x(40)" skip with fram F1112 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11122 = "" . 
                display L11122          format "x(40)" skip with fram F1112 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11123 = "" . 
                display L11123          format "x(40)" skip with fram F1112 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11124 = "" . 
                display L11124          format "x(40)" skip with fram F1112 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11125 = "" . 
                display L11125          format "x(40)" skip with fram F1112 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11126 = "" . 
                display L11126          format "x(40)" skip with fram F1112 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1112 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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
     /* END    LINE :1112  1.1.2 PO收货[委外]  */


   /* Additional Labels Format */
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
     /* START  LINE :1113  1.1.3 PO收货[严控]  */
     V1113L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1113           as char format "x(50)".
        define variable PV1113          as char format "x(50)".
        define variable L11131          as char format "x(40)".
        define variable L11132          as char format "x(40)".
        define variable L11133          as char format "x(40)".
        define variable L11134          as char format "x(40)".
        define variable L11135          as char format "x(40)".
        define variable L11136          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1113 = " ".
        V1113 = ENTRY(1,V1113,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1110 = "".
RUN CheckSecurity (INPUT "xspor03.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes then RUN    xspor03.p.
        leave V1113L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1113 no-box.

                /* LABEL 1 - START */ 
                  L11131 = "" . 
                display L11131          format "x(40)" skip with fram F1113 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11132 = "" . 
                display L11132          format "x(40)" skip with fram F1113 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11133 = "" . 
                display L11133          format "x(40)" skip with fram F1113 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11134 = "" . 
                display L11134          format "x(40)" skip with fram F1113 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11135 = "" . 
                display L11135          format "x(40)" skip with fram F1113 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11136 = "" . 
                display L11136          format "x(40)" skip with fram F1113 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1113 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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
     /* END    LINE :1113  1.1.3 PO收货[严控]  */


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1113LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1113    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1130    */
   V1130LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1130    */
   IF NOT (V1100 = "3" ) THEN LEAVE V1130LMAINLOOP.
     /* START  LINE :1130  1.3 工单菜单  */
     V1130L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1130           as char format "x(50)".
        define variable PV1130          as char format "x(50)".
        define variable L11301          as char format "x(40)".
        define variable L11302          as char format "x(40)".
        define variable L11303          as char format "x(40)".
        define variable L11304          as char format "x(40)".
        define variable L11305          as char format "x(40)".
        define variable L11306          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1130 = " ".
        V1130 = ENTRY(1,V1130,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1130 no-box.

                /* LABEL 1 - START */ 
                L11301 = "虫祇タ盽. .31" .
                display L11301          format "x(40)" skip with fram F1130 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11302 = "虫癶. . . .32" .
                display L11302          format "x(40)" skip with fram F1130 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11303 = "Θ珇畐. . . .33" .
                display L11303          format "x(40)" skip with fram F1130 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11304 = "珇畐. . .34" .
                display L11304          format "x(40)" skip with fram F1130 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                L11305 = "虫祇筁戳. .35" .
                display L11305          format "x(40)" skip with fram F1130 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                L11306 = "FIFO糵琩高. .36" .
                display L11306          format "x(40)" skip with fram F1130 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1130 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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
     /* END    LINE :1130  1.3 工单菜单  */


   /* Additional Labels Format */
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
     /* START  LINE :1131  1.3.1 工单发正常料  */
     V1131L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1131           as char format "x(50)".
        define variable PV1131          as char format "x(50)".
        define variable L11311          as char format "x(40)".
        define variable L11312          as char format "x(40)".
        define variable L11313          as char format "x(40)".
        define variable L11314          as char format "x(40)".
        define variable L11315          as char format "x(40)".
        define variable L11316          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1131 = " ".
        V1131 = ENTRY(1,V1131,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1130 = "".
RUN CheckSecurity (INPUT "xswoi10.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes then RUN    xswoi10.p.
        leave V1131L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1131 no-box.

                /* LABEL 1 - START */ 
                  L11311 = "" . 
                display L11311          format "x(40)" skip with fram F1131 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11312 = "" . 
                display L11312          format "x(40)" skip with fram F1131 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11313 = "" . 
                display L11313          format "x(40)" skip with fram F1131 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11314 = "" . 
                display L11314          format "x(40)" skip with fram F1131 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11315 = "" . 
                display L11315          format "x(40)" skip with fram F1131 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11316 = "" . 
                display L11316          format "x(40)" skip with fram F1131 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1131 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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
     /* END    LINE :1131  1.3.1 工单发正常料  */


   /* Additional Labels Format */
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
     /* START  LINE :1132  1.3.2 工单退料  */
     V1132L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1132           as char format "x(50)".
        define variable PV1132          as char format "x(50)".
        define variable L11321          as char format "x(40)".
        define variable L11322          as char format "x(40)".
        define variable L11323          as char format "x(40)".
        define variable L11324          as char format "x(40)".
        define variable L11325          as char format "x(40)".
        define variable L11326          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1132 = " ".
        V1132 = ENTRY(1,V1132,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1130 = "".
RUN CheckSecurity (INPUT "xswoi08.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN RUN     xswoi08.p.
        leave V1132L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1132 no-box.

                /* LABEL 1 - START */ 
                  L11321 = "" . 
                display L11321          format "x(40)" skip with fram F1132 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11322 = "" . 
                display L11322          format "x(40)" skip with fram F1132 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11323 = "" . 
                display L11323          format "x(40)" skip with fram F1132 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11324 = "" . 
                display L11324          format "x(40)" skip with fram F1132 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11325 = "" . 
                display L11325          format "x(40)" skip with fram F1132 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11326 = "" . 
                display L11326          format "x(40)" skip with fram F1132 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1132 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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
     /* END    LINE :1132  1.3.2 工单退料  */


   /* Additional Labels Format */
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
     /* START  LINE :1133  1.3.3 成品入库  */
     V1133L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1133           as char format "x(50)".
        define variable PV1133          as char format "x(50)".
        define variable L11331          as char format "x(40)".
        define variable L11332          as char format "x(40)".
        define variable L11333          as char format "x(40)".
        define variable L11334          as char format "x(40)".
        define variable L11335          as char format "x(40)".
        define variable L11336          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1133 = " ".
        V1133 = ENTRY(1,V1133,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1130 = "".
RUN CheckSecurity (INPUT "xswor01.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN     	RUN  xswor01.p.
        leave V1133L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1133 no-box.

                /* LABEL 1 - START */ 
                  L11331 = "" . 
                display L11331          format "x(40)" skip with fram F1133 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11332 = "" . 
                display L11332          format "x(40)" skip with fram F1133 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11333 = "" . 
                display L11333          format "x(40)" skip with fram F1133 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11334 = "" . 
                display L11334          format "x(40)" skip with fram F1133 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11335 = "" . 
                display L11335          format "x(40)" skip with fram F1133 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11336 = "" . 
                display L11336          format "x(40)" skip with fram F1133 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1133 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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
     /* END    LINE :1133  1.3.3 成品入库  */


   /* Additional Labels Format */
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
     /* START  LINE :1134  1.3.4 自制品入库  */
     V1134L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1134           as char format "x(50)".
        define variable PV1134          as char format "x(50)".
        define variable L11341          as char format "x(40)".
        define variable L11342          as char format "x(40)".
        define variable L11343          as char format "x(40)".
        define variable L11344          as char format "x(40)".
        define variable L11345          as char format "x(40)".
        define variable L11346          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1134 = " ".
        V1134 = ENTRY(1,V1134,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1130 = "".
RUN CheckSecurity (INPUT "xswor02.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xswor02.p.
        leave V1134L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1134 no-box.

                /* LABEL 1 - START */ 
                  L11341 = "" . 
                display L11341          format "x(40)" skip with fram F1134 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11342 = "" . 
                display L11342          format "x(40)" skip with fram F1134 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11343 = "" . 
                display L11343          format "x(40)" skip with fram F1134 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11344 = "" . 
                display L11344          format "x(40)" skip with fram F1134 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11345 = "" . 
                display L11345          format "x(40)" skip with fram F1134 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11346 = "" . 
                display L11346          format "x(40)" skip with fram F1134 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1134 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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
     /* END    LINE :1134  1.3.4 自制品入库  */


   /* Additional Labels Format */
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
     /* START  LINE :1135  1.3.5 工单发过期料  */
     V1135L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1135           as char format "x(50)".
        define variable PV1135          as char format "x(50)".
        define variable L11351          as char format "x(40)".
        define variable L11352          as char format "x(40)".
        define variable L11353          as char format "x(40)".
        define variable L11354          as char format "x(40)".
        define variable L11355          as char format "x(40)".
        define variable L11356          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1135 = " ".
        V1135 = ENTRY(1,V1135,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1130 = "".
RUN CheckSecurity (INPUT "xswoi11.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes then RUN    xswoi11.p.
        leave V1135L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1135 no-box.

                /* LABEL 1 - START */ 
                  L11351 = "" . 
                display L11351          format "x(40)" skip with fram F1135 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11352 = "" . 
                display L11352          format "x(40)" skip with fram F1135 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11353 = "" . 
                display L11353          format "x(40)" skip with fram F1135 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11354 = "" . 
                display L11354          format "x(40)" skip with fram F1135 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11355 = "" . 
                display L11355          format "x(40)" skip with fram F1135 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11356 = "" . 
                display L11356          format "x(40)" skip with fram F1135 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1135 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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
     /* END    LINE :1135  1.3.5 工单发过期料  */


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1135LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1135    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1136    */
   V1136LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1136    */
   IF NOT (V1130 = "36" OR V1100 = "36" ) THEN LEAVE V1136LMAINLOOP.
     /* START  LINE :1136  1.3.6 FIFO审核查询  */
     V1136L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1136           as char format "x(50)".
        define variable PV1136          as char format "x(50)".
        define variable L11361          as char format "x(40)".
        define variable L11362          as char format "x(40)".
        define variable L11363          as char format "x(40)".
        define variable L11364          as char format "x(40)".
        define variable L11365          as char format "x(40)".
        define variable L11366          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1136 = " ".
        V1136 = ENTRY(1,V1136,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1130 = "".
RUN CheckSecurity (INPUT "xsinv98.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xsinv98.p.
        leave V1136L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1136 no-box.

                /* LABEL 1 - START */ 
                  L11361 = "" . 
                display L11361          format "x(40)" skip with fram F1136 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11362 = "" . 
                display L11362          format "x(40)" skip with fram F1136 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11363 = "" . 
                display L11363          format "x(40)" skip with fram F1136 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11364 = "" . 
                display L11364          format "x(40)" skip with fram F1136 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11365 = "" . 
                display L11365          format "x(40)" skip with fram F1136 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11366 = "" . 
                display L11366          format "x(40)" skip with fram F1136 no-box.
                /* LABEL 6 - END */ 
        Update V1136
        WITH  fram F1136 NO-LABEL
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
        IF V1136 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1136 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1136 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1136 ).
        /* **CHANGE Default Site END ** */
        IF V1136 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        display  skip WMESSAGE NO-LABEL with fram F1136.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1136.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1136.
        pause 0.
        leave V1136L.
     END.
     PV1136 = V1136.
     /* END    LINE :1136  1.3.6 FIFO审核查询  */


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1136LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1136    */
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
        define variable V1140           as char format "x(50)".
        define variable PV1140          as char format "x(50)".
        define variable L11401          as char format "x(40)".
        define variable L11402          as char format "x(40)".
        define variable L11403          as char format "x(40)".
        define variable L11404          as char format "x(40)".
        define variable L11405          as char format "x(40)".
        define variable L11406          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1140 = " ".
        V1140 = ENTRY(1,V1140,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1140 no-box.

                /* LABEL 1 - START */ 
                L11401 = "㏄戳絃翴. . . .41" .
                display L11401          format "x(40)" skip with fram F1140 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11402 = "絃(BY ITEM) .42" .
                display L11402          format "x(40)" skip with fram F1140 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11403 = "絃(礚Τ计).43" .
                display L11403          format "x(40)" skip with fram F1140 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11404 = "確絃(BY NBR). .44" .
                display L11404          format "x(40)" skip with fram F1140 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11405 = "" . 
                display L11405          format "x(40)" skip with fram F1140 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11406 = "" . 
                display L11406          format "x(40)" skip with fram F1140 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1140 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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


   /* Additional Labels Format */
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
        define variable V1141           as char format "x(50)".
        define variable PV1141          as char format "x(50)".
        define variable L11411          as char format "x(40)".
        define variable L11412          as char format "x(40)".
        define variable L11413          as char format "x(40)".
        define variable L11414          as char format "x(40)".
        define variable L11415          as char format "x(40)".
        define variable L11416          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1141 = " ".
        V1141 = ENTRY(1,V1141,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1140 = "".
RUN CheckSecurity (INPUT "xsinv41.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xsinv41.p.
        leave V1141L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1141 no-box.

                /* LABEL 1 - START */ 
                  L11411 = "" . 
                display L11411          format "x(40)" skip with fram F1141 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11412 = "" . 
                display L11412          format "x(40)" skip with fram F1141 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11413 = "" . 
                display L11413          format "x(40)" skip with fram F1141 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11414 = "" . 
                display L11414          format "x(40)" skip with fram F1141 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11415 = "" . 
                display L11415          format "x(40)" skip with fram F1141 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11416 = "" . 
                display L11416          format "x(40)" skip with fram F1141 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1141 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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


   /* Additional Labels Format */
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
     /* START  LINE :1142  1.4.2 初盘(BY ITEM)  */
     V1142L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1142           as char format "x(50)".
        define variable PV1142          as char format "x(50)".
        define variable L11421          as char format "x(40)".
        define variable L11422          as char format "x(40)".
        define variable L11423          as char format "x(40)".
        define variable L11424          as char format "x(40)".
        define variable L11425          as char format "x(40)".
        define variable L11426          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1142 = " ".
        V1142 = ENTRY(1,V1142,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1140 = "".
RUN CheckSecurity (INPUT "xsinv42.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xsinv42.p.
        leave V1142L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1142 no-box.

                /* LABEL 1 - START */ 
                  L11421 = "" . 
                display L11421          format "x(40)" skip with fram F1142 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11422 = "" . 
                display L11422          format "x(40)" skip with fram F1142 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11423 = "" . 
                display L11423          format "x(40)" skip with fram F1142 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11424 = "" . 
                display L11424          format "x(40)" skip with fram F1142 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11425 = "" . 
                display L11425          format "x(40)" skip with fram F1142 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11426 = "" . 
                display L11426          format "x(40)" skip with fram F1142 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1142 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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
     /* END    LINE :1142  1.4.2 初盘(BY ITEM)  */


   /* Additional Labels Format */
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
        define variable V1143           as char format "x(50)".
        define variable PV1143          as char format "x(50)".
        define variable L11431          as char format "x(40)".
        define variable L11432          as char format "x(40)".
        define variable L11433          as char format "x(40)".
        define variable L11434          as char format "x(40)".
        define variable L11435          as char format "x(40)".
        define variable L11436          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1143 = " ".
        V1143 = ENTRY(1,V1143,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1140 = "".
RUN CheckSecurity (INPUT "xsinv43.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xsinv43.p.
        leave V1143L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1143 no-box.

                /* LABEL 1 - START */ 
                  L11431 = "" . 
                display L11431          format "x(40)" skip with fram F1143 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11432 = "" . 
                display L11432          format "x(40)" skip with fram F1143 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11433 = "" . 
                display L11433          format "x(40)" skip with fram F1143 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11434 = "" . 
                display L11434          format "x(40)" skip with fram F1143 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11435 = "" . 
                display L11435          format "x(40)" skip with fram F1143 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11436 = "" . 
                display L11436          format "x(40)" skip with fram F1143 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1143 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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


   /* Additional Labels Format */
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
        define variable V1144           as char format "x(50)".
        define variable PV1144          as char format "x(50)".
        define variable L11441          as char format "x(40)".
        define variable L11442          as char format "x(40)".
        define variable L11443          as char format "x(40)".
        define variable L11444          as char format "x(40)".
        define variable L11445          as char format "x(40)".
        define variable L11446          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1144 = " ".
        V1144 = ENTRY(1,V1144,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1140 = "".
RUN CheckSecurity (INPUT "xsinv44.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xsinv44.p.
        leave V1144L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1144 no-box.

                /* LABEL 1 - START */ 
                  L11441 = "" . 
                display L11441          format "x(40)" skip with fram F1144 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11442 = "" . 
                display L11442          format "x(40)" skip with fram F1144 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11443 = "" . 
                display L11443          format "x(40)" skip with fram F1144 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11444 = "" . 
                display L11444          format "x(40)" skip with fram F1144 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11445 = "" . 
                display L11445          format "x(40)" skip with fram F1144 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11446 = "" . 
                display L11446          format "x(40)" skip with fram F1144 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1144 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1144LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1144    */
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
        define variable V1150           as char format "x(50)".
        define variable PV1150          as char format "x(50)".
        define variable L11501          as char format "x(40)".
        define variable L11502          as char format "x(40)".
        define variable L11503          as char format "x(40)".
        define variable L11504          as char format "x(40)".
        define variable L11505          as char format "x(40)".
        define variable L11506          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1150 = " ".
        V1150 = ENTRY(1,V1150,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1150 no-box.

                /* LABEL 1 - START */ 
                L11501 = "夹非夹帽ゴ..51" .
                display L11501          format "x(40)" skip with fram F1150 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11502 = "畐夹帽ゴ..52" .
                display L11502          format "x(40)" skip with fram F1150 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11503 = "ゴ钉..53" .
                display L11503          format "x(40)" skip with fram F1150 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11504 = "夹帽干ゴ..54" .
                display L11504          format "x(40)" skip with fram F1150 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                L11505 = "夹帽畐..55" .
                display L11505          format "x(40)" skip with fram F1150 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                L11506 = "夹帽ゴ..56" .
                display L11506          format "x(40)" skip with fram F1150 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1150 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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


   /* Additional Labels Format */
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
        define variable V1151           as char format "x(50)".
        define variable PV1151          as char format "x(50)".
        define variable L11511          as char format "x(40)".
        define variable L11512          as char format "x(40)".
        define variable L11513          as char format "x(40)".
        define variable L11514          as char format "x(40)".
        define variable L11515          as char format "x(40)".
        define variable L11516          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1151 = " ".
        V1151 = ENTRY(1,V1151,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1150 = "".
RUN CheckSecurity (INPUT "xslap03.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xslap03.p.
        leave V1151L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1151 no-box.

                /* LABEL 1 - START */ 
                  L11511 = "" . 
                display L11511          format "x(40)" skip with fram F1151 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11512 = "" . 
                display L11512          format "x(40)" skip with fram F1151 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11513 = "" . 
                display L11513          format "x(40)" skip with fram F1151 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11514 = "" . 
                display L11514          format "x(40)" skip with fram F1151 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11515 = "" . 
                display L11515          format "x(40)" skip with fram F1151 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11516 = "" . 
                display L11516          format "x(40)" skip with fram F1151 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1151 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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


   /* Additional Labels Format */
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
        define variable V1152           as char format "x(50)".
        define variable PV1152          as char format "x(50)".
        define variable L11521          as char format "x(40)".
        define variable L11522          as char format "x(40)".
        define variable L11523          as char format "x(40)".
        define variable L11524          as char format "x(40)".
        define variable L11525          as char format "x(40)".
        define variable L11526          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1152 = " ".
        V1152 = ENTRY(1,V1152,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1150 = "".
RUN CheckSecurity (INPUT "xslap04.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xslap04.p.
        leave V1152L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1152 no-box.

                /* LABEL 1 - START */ 
                  L11521 = "" . 
                display L11521          format "x(40)" skip with fram F1152 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11522 = "" . 
                display L11522          format "x(40)" skip with fram F1152 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11523 = "" . 
                display L11523          format "x(40)" skip with fram F1152 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11524 = "" . 
                display L11524          format "x(40)" skip with fram F1152 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11525 = "" . 
                display L11525          format "x(40)" skip with fram F1152 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11526 = "" . 
                display L11526          format "x(40)" skip with fram F1152 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1152 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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


   /* Additional Labels Format */
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
        define variable V1153           as char format "x(50)".
        define variable PV1153          as char format "x(50)".
        define variable L11531          as char format "x(40)".
        define variable L11532          as char format "x(40)".
        define variable L11533          as char format "x(40)".
        define variable L11534          as char format "x(40)".
        define variable L11535          as char format "x(40)".
        define variable L11536          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1153 = " ".
        V1153 = ENTRY(1,V1153,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1150 = "".
RUN CheckSecurity (INPUT "xslap05.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xslap05.p.
        leave V1153L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1153 no-box.

                /* LABEL 1 - START */ 
                  L11531 = "" . 
                display L11531          format "x(40)" skip with fram F1153 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11532 = "" . 
                display L11532          format "x(40)" skip with fram F1153 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11533 = "" . 
                display L11533          format "x(40)" skip with fram F1153 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11534 = "" . 
                display L11534          format "x(40)" skip with fram F1153 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11535 = "" . 
                display L11535          format "x(40)" skip with fram F1153 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11536 = "" . 
                display L11536          format "x(40)" skip with fram F1153 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1153 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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


   /* Additional Labels Format */
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
        define variable V1154           as char format "x(50)".
        define variable PV1154          as char format "x(50)".
        define variable L11541          as char format "x(40)".
        define variable L11542          as char format "x(40)".
        define variable L11543          as char format "x(40)".
        define variable L11544          as char format "x(40)".
        define variable L11545          as char format "x(40)".
        define variable L11546          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1154 = " ".
        V1154 = ENTRY(1,V1154,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1150 = "".
RUN CheckSecurity (INPUT "xslap08.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xslap08.p.
        leave V1154L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1154 no-box.

                /* LABEL 1 - START */ 
                  L11541 = "" . 
                display L11541          format "x(40)" skip with fram F1154 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11542 = "" . 
                display L11542          format "x(40)" skip with fram F1154 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11543 = "" . 
                display L11543          format "x(40)" skip with fram F1154 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11544 = "" . 
                display L11544          format "x(40)" skip with fram F1154 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11545 = "" . 
                display L11545          format "x(40)" skip with fram F1154 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11546 = "" . 
                display L11546          format "x(40)" skip with fram F1154 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1154 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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


   /* Additional Labels Format */
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
        define variable V1155           as char format "x(50)".
        define variable PV1155          as char format "x(50)".
        define variable L11551          as char format "x(40)".
        define variable L11552          as char format "x(40)".
        define variable L11553          as char format "x(40)".
        define variable L11554          as char format "x(40)".
        define variable L11555          as char format "x(40)".
        define variable L11556          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1155 = " ".
        V1155 = ENTRY(1,V1155,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1150 = "".
RUN CheckSecurity (INPUT "xswor04.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xswor04.p.
        leave V1155L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1155 no-box.

                /* LABEL 1 - START */ 
                  L11551 = "" . 
                display L11551          format "x(40)" skip with fram F1155 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11552 = "" . 
                display L11552          format "x(40)" skip with fram F1155 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11553 = "" . 
                display L11553          format "x(40)" skip with fram F1155 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11554 = "" . 
                display L11554          format "x(40)" skip with fram F1155 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11555 = "" . 
                display L11555          format "x(40)" skip with fram F1155 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11556 = "" . 
                display L11556          format "x(40)" skip with fram F1155 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1155 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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


   /* Additional Labels Format */
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
        define variable V1156           as char format "x(50)".
        define variable PV1156          as char format "x(50)".
        define variable L11561          as char format "x(40)".
        define variable L11562          as char format "x(40)".
        define variable L11563          as char format "x(40)".
        define variable L11564          as char format "x(40)".
        define variable L11565          as char format "x(40)".
        define variable L11566          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1156 = " ".
        V1156 = ENTRY(1,V1156,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1150 = "".
RUN CheckSecurity (INPUT "xslap07.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xslap07.p.
        leave V1156L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1156 no-box.

                /* LABEL 1 - START */ 
                  L11561 = "" . 
                display L11561          format "x(40)" skip with fram F1156 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11562 = "" . 
                display L11562          format "x(40)" skip with fram F1156 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11563 = "" . 
                display L11563          format "x(40)" skip with fram F1156 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11564 = "" . 
                display L11564          format "x(40)" skip with fram F1156 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11565 = "" . 
                display L11565          format "x(40)" skip with fram F1156 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11566 = "" . 
                display L11566          format "x(40)" skip with fram F1156 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1156 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1156LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1156    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1157    */
   V1157LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1157    */
   IF NOT (V1150 = "57" OR V1100 = "57" ) THEN LEAVE V1157LMAINLOOP.
     /* START  LINE :1157  1.5.7 VI自制标签打印  */
     V1157L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1157           as char format "x(50)".
        define variable PV1157          as char format "x(50)".
        define variable L11571          as char format "x(40)".
        define variable L11572          as char format "x(40)".
        define variable L11573          as char format "x(40)".
        define variable L11574          as char format "x(40)".
        define variable L11575          as char format "x(40)".
        define variable L11576          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1157 = " ".
        V1157 = ENTRY(1,V1157,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1150 = "".
RUN CheckSecurity (INPUT "xswor03.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xswor03.p.
        leave V1157L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1157 no-box.

                /* LABEL 1 - START */ 
                  L11571 = "" . 
                display L11571          format "x(40)" skip with fram F1157 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11572 = "" . 
                display L11572          format "x(40)" skip with fram F1157 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11573 = "" . 
                display L11573          format "x(40)" skip with fram F1157 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11574 = "" . 
                display L11574          format "x(40)" skip with fram F1157 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11575 = "" . 
                display L11575          format "x(40)" skip with fram F1157 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11576 = "" . 
                display L11576          format "x(40)" skip with fram F1157 no-box.
                /* LABEL 6 - END */ 
        Update V1157
        WITH  fram F1157 NO-LABEL
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
        IF V1157 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1157 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1157 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1157 ).
        /* **CHANGE Default Site END ** */
        IF V1157 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        display  skip WMESSAGE NO-LABEL with fram F1157.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1157.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1157.
        pause 0.
        leave V1157L.
     END.
     PV1157 = V1157.
     /* END    LINE :1157  1.5.7 VI自制标签打印  */


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1157LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1157    */
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
        define variable V1160           as char format "x(50)".
        define variable PV1160          as char format "x(50)".
        define variable L11601          as char format "x(40)".
        define variable L11602          as char format "x(40)".
        define variable L11603          as char format "x(40)".
        define variable L11604          as char format "x(40)".
        define variable L11605          as char format "x(40)".
        define variable L11606          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1160 = " ".
        V1160 = ENTRY(1,V1160,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1160 no-box.

                /* LABEL 1 - START */ 
                L11601 = "璸购畐. . .61" .
                display L11601          format "x(40)" skip with fram F1160 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11602 = "璸购畐. . .62" .
                display L11602          format "x(40)" skip with fram F1160 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11603 = "畐锣簿. . . .63" .
                display L11603          format "x(40)" skip with fram F1160 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11604 = "畐畐琩高. .64" .
                display L11604          format "x(40)" skip with fram F1160 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                L11605 = "у腹畐琩高. .65" .
                display L11605          format "x(40)" skip with fram F1160 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                L11606 = "ユ琩高. . . .66" .
                display L11606          format "x(40)" skip with fram F1160 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1160 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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


   /* Additional Labels Format */
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
        define variable V1161           as char format "x(50)".
        define variable PV1161          as char format "x(50)".
        define variable L11611          as char format "x(40)".
        define variable L11612          as char format "x(40)".
        define variable L11613          as char format "x(40)".
        define variable L11614          as char format "x(40)".
        define variable L11615          as char format "x(40)".
        define variable L11616          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1161 = " ".
        V1161 = ENTRY(1,V1161,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1160 = "".
RUN CheckSecurity (INPUT "xsinv21.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xsinv21.p.
        leave V1161L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1161 no-box.

                /* LABEL 1 - START */ 
                  L11611 = "" . 
                display L11611          format "x(40)" skip with fram F1161 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11612 = "" . 
                display L11612          format "x(40)" skip with fram F1161 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11613 = "" . 
                display L11613          format "x(40)" skip with fram F1161 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11614 = "" . 
                display L11614          format "x(40)" skip with fram F1161 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11615 = "" . 
                display L11615          format "x(40)" skip with fram F1161 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11616 = "" . 
                display L11616          format "x(40)" skip with fram F1161 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1161 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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


   /* Additional Labels Format */
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
        define variable V1162           as char format "x(50)".
        define variable PV1162          as char format "x(50)".
        define variable L11621          as char format "x(40)".
        define variable L11622          as char format "x(40)".
        define variable L11623          as char format "x(40)".
        define variable L11624          as char format "x(40)".
        define variable L11625          as char format "x(40)".
        define variable L11626          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1162 = " ".
        V1162 = ENTRY(1,V1162,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1160 = "".
RUN CheckSecurity (INPUT "xsinv22.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xsinv22.p.
        leave V1162L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1162 no-box.

                /* LABEL 1 - START */ 
                  L11621 = "" . 
                display L11621          format "x(40)" skip with fram F1162 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11622 = "" . 
                display L11622          format "x(40)" skip with fram F1162 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11623 = "" . 
                display L11623          format "x(40)" skip with fram F1162 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11624 = "" . 
                display L11624          format "x(40)" skip with fram F1162 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11625 = "" . 
                display L11625          format "x(40)" skip with fram F1162 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11626 = "" . 
                display L11626          format "x(40)" skip with fram F1162 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1162 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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


   /* Additional Labels Format */
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
        define variable V1163           as char format "x(50)".
        define variable PV1163          as char format "x(50)".
        define variable L11631          as char format "x(40)".
        define variable L11632          as char format "x(40)".
        define variable L11633          as char format "x(40)".
        define variable L11634          as char format "x(40)".
        define variable L11635          as char format "x(40)".
        define variable L11636          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1163 = " ".
        V1163 = ENTRY(1,V1163,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1160 = "".
RUN CheckSecurity (INPUT "xsinv23.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xsinv23.p.
        leave V1163L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1163 no-box.

                /* LABEL 1 - START */ 
                  L11631 = "" . 
                display L11631          format "x(40)" skip with fram F1163 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11632 = "" . 
                display L11632          format "x(40)" skip with fram F1163 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11633 = "" . 
                display L11633          format "x(40)" skip with fram F1163 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11634 = "" . 
                display L11634          format "x(40)" skip with fram F1163 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11635 = "" . 
                display L11635          format "x(40)" skip with fram F1163 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11636 = "" . 
                display L11636          format "x(40)" skip with fram F1163 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1163 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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


   /* Additional Labels Format */
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
        define variable V1164           as char format "x(50)".
        define variable PV1164          as char format "x(50)".
        define variable L11641          as char format "x(40)".
        define variable L11642          as char format "x(40)".
        define variable L11643          as char format "x(40)".
        define variable L11644          as char format "x(40)".
        define variable L11645          as char format "x(40)".
        define variable L11646          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1164 = " ".
        V1164 = ENTRY(1,V1164,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1160 = "".
RUN CheckSecurity (INPUT "xsinq01.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xsinq01.p.
        leave V1164L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1164 no-box.

                /* LABEL 1 - START */ 
                  L11641 = "" . 
                display L11641          format "x(40)" skip with fram F1164 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11642 = "" . 
                display L11642          format "x(40)" skip with fram F1164 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11643 = "" . 
                display L11643          format "x(40)" skip with fram F1164 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11644 = "" . 
                display L11644          format "x(40)" skip with fram F1164 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11645 = "" . 
                display L11645          format "x(40)" skip with fram F1164 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11646 = "" . 
                display L11646          format "x(40)" skip with fram F1164 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1164 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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


   /* Additional Labels Format */
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
        define variable V1165           as char format "x(50)".
        define variable PV1165          as char format "x(50)".
        define variable L11651          as char format "x(40)".
        define variable L11652          as char format "x(40)".
        define variable L11653          as char format "x(40)".
        define variable L11654          as char format "x(40)".
        define variable L11655          as char format "x(40)".
        define variable L11656          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1165 = " ".
        V1165 = ENTRY(1,V1165,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1160 = "".
RUN CheckSecurity (INPUT "xsinv02.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xsinv02.p.
        leave V1165L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1165 no-box.

                /* LABEL 1 - START */ 
                  L11651 = "" . 
                display L11651          format "x(40)" skip with fram F1165 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11652 = "" . 
                display L11652          format "x(40)" skip with fram F1165 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11653 = "" . 
                display L11653          format "x(40)" skip with fram F1165 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11654 = "" . 
                display L11654          format "x(40)" skip with fram F1165 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11655 = "" . 
                display L11655          format "x(40)" skip with fram F1165 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11656 = "" . 
                display L11656          format "x(40)" skip with fram F1165 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1165 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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


   /* Additional Labels Format */
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
        define variable V1166           as char format "x(50)".
        define variable PV1166          as char format "x(50)".
        define variable L11661          as char format "x(40)".
        define variable L11662          as char format "x(40)".
        define variable L11663          as char format "x(40)".
        define variable L11664          as char format "x(40)".
        define variable L11665          as char format "x(40)".
        define variable L11666          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1166 = " ".
        V1166 = ENTRY(1,V1166,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1160 = "".
RUN CheckSecurity (INPUT "xsinv99.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xsinv99.p.
        leave V1166L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1166 no-box.

                /* LABEL 1 - START */ 
                  L11661 = "" . 
                display L11661          format "x(40)" skip with fram F1166 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11662 = "" . 
                display L11662          format "x(40)" skip with fram F1166 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11663 = "" . 
                display L11663          format "x(40)" skip with fram F1166 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11664 = "" . 
                display L11664          format "x(40)" skip with fram F1166 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11665 = "" . 
                display L11665          format "x(40)" skip with fram F1166 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11666 = "" . 
                display L11666          format "x(40)" skip with fram F1166 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1166 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1166LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1166    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1170    */
   V1170LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1170    */
   IF NOT (V1100 = "7" ) THEN LEAVE V1170LMAINLOOP.
     /* START  LINE :1170  1.7 销售菜单  */
     V1170L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1170           as char format "x(50)".
        define variable PV1170          as char format "x(50)".
        define variable L11701          as char format "x(40)".
        define variable L11702          as char format "x(40)".
        define variable L11703          as char format "x(40)".
        define variable L11704          as char format "x(40)".
        define variable L11705          as char format "x(40)".
        define variable L11706          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1170 = " ".
        V1170 = ENTRY(1,V1170,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1170 no-box.

                /* LABEL 1 - START */ 
                L11701 = "綪扳称[LOT] .71" .
                display L11701          format "x(40)" skip with fram F1170 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11702 = "綪扳虫夹帽. .72" .
                display L11702          format "x(40)" skip with fram F1170 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11703 = "綪扳Θ珇称. .73" .
                display L11703          format "x(40)" skip with fram F1170 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11704 = "綪扳称琩高. .74" .
                display L11704          format "x(40)" skip with fram F1170 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                L11705 = "綪扳Θ珇浪琩. .75" .
                display L11705          format "x(40)" skip with fram F1170 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                L11706 = "綪扳POST夹帽. .79" .
                display L11706          format "x(40)" skip with fram F1170 no-box.
                /* LABEL 6 - END */ 
        Update V1170
        WITH  fram F1170 NO-LABEL
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
        IF V1170 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1170 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1170 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1170 ).
        /* **CHANGE Default Site END ** */
        IF V1170 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        display  skip WMESSAGE NO-LABEL with fram F1170.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1170.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1170.
        pause 0.
        leave V1170L.
     END.
     PV1170 = V1170.
     /* END    LINE :1170  1.7 销售菜单  */


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1170LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1170    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1171    */
   V1171LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1171    */
   IF NOT (V1170 = "71" OR V1100 = "71" ) THEN LEAVE V1171LMAINLOOP.
     /* START  LINE :1171  1.7.1 销售备料[LOT]  */
     V1171L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1171           as char format "x(50)".
        define variable PV1171          as char format "x(50)".
        define variable L11711          as char format "x(40)".
        define variable L11712          as char format "x(40)".
        define variable L11713          as char format "x(40)".
        define variable L11714          as char format "x(40)".
        define variable L11715          as char format "x(40)".
        define variable L11716          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1171 = " ".
        V1171 = ENTRY(1,V1171,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1170 = "".
RUN CheckSecurity (INPUT "xssoa25.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xssoa25.p.
        leave V1171L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1171 no-box.

                /* LABEL 1 - START */ 
                  L11711 = "" . 
                display L11711          format "x(40)" skip with fram F1171 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11712 = "" . 
                display L11712          format "x(40)" skip with fram F1171 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11713 = "" . 
                display L11713          format "x(40)" skip with fram F1171 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11714 = "" . 
                display L11714          format "x(40)" skip with fram F1171 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11715 = "" . 
                display L11715          format "x(40)" skip with fram F1171 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11716 = "" . 
                display L11716          format "x(40)" skip with fram F1171 no-box.
                /* LABEL 6 - END */ 
        Update V1171
        WITH  fram F1171 NO-LABEL
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
        IF V1171 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1171 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1171 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1171 ).
        /* **CHANGE Default Site END ** */
        IF V1171 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        display  skip WMESSAGE NO-LABEL with fram F1171.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1171.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1171.
        pause 0.
        leave V1171L.
     END.
     PV1171 = V1171.
     /* END    LINE :1171  1.7.1 销售备料[LOT]  */


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1171LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1171    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1172    */
   V1172LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1172    */
   IF NOT (V1170 = "72" OR V1100 = "72" ) THEN LEAVE V1172LMAINLOOP.
     /* START  LINE :1172  1.7.2 销售工单标签  */
     V1172L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1172           as char format "x(50)".
        define variable PV1172          as char format "x(50)".
        define variable L11721          as char format "x(40)".
        define variable L11722          as char format "x(40)".
        define variable L11723          as char format "x(40)".
        define variable L11724          as char format "x(40)".
        define variable L11725          as char format "x(40)".
        define variable L11726          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1172 = " ".
        V1172 = ENTRY(1,V1172,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1170 = "".
RUN CheckSecurity (INPUT "xslap06.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xslap06.p.
        leave V1172L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1172 no-box.

                /* LABEL 1 - START */ 
                  L11721 = "" . 
                display L11721          format "x(40)" skip with fram F1172 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11722 = "" . 
                display L11722          format "x(40)" skip with fram F1172 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11723 = "" . 
                display L11723          format "x(40)" skip with fram F1172 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11724 = "" . 
                display L11724          format "x(40)" skip with fram F1172 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11725 = "" . 
                display L11725          format "x(40)" skip with fram F1172 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11726 = "" . 
                display L11726          format "x(40)" skip with fram F1172 no-box.
                /* LABEL 6 - END */ 
        Update V1172
        WITH  fram F1172 NO-LABEL
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
        IF V1172 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1172 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1172 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1172 ).
        /* **CHANGE Default Site END ** */
        IF V1172 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        display  skip WMESSAGE NO-LABEL with fram F1172.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1172.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1172.
        pause 0.
        leave V1172L.
     END.
     PV1172 = V1172.
     /* END    LINE :1172  1.7.2 销售工单标签  */


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1172LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1172    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1173    */
   V1173LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1173    */
   IF NOT (V1170 = "73" OR V1100 = "73" ) THEN LEAVE V1173LMAINLOOP.
     /* START  LINE :1173  1.7.3 销售订单备料  */
     V1173L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1173           as char format "x(50)".
        define variable PV1173          as char format "x(50)".
        define variable L11731          as char format "x(40)".
        define variable L11732          as char format "x(40)".
        define variable L11733          as char format "x(40)".
        define variable L11734          as char format "x(40)".
        define variable L11735          as char format "x(40)".
        define variable L11736          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1173 = " ".
        V1173 = ENTRY(1,V1173,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1170 = "".
RUN CheckSecurity (INPUT "xssoa26.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xssoa26.p.
        leave V1173L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1173 no-box.

                /* LABEL 1 - START */ 
                  L11731 = "" . 
                display L11731          format "x(40)" skip with fram F1173 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11732 = "" . 
                display L11732          format "x(40)" skip with fram F1173 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11733 = "" . 
                display L11733          format "x(40)" skip with fram F1173 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11734 = "" . 
                display L11734          format "x(40)" skip with fram F1173 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11735 = "" . 
                display L11735          format "x(40)" skip with fram F1173 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11736 = "" . 
                display L11736          format "x(40)" skip with fram F1173 no-box.
                /* LABEL 6 - END */ 
        Update V1173
        WITH  fram F1173 NO-LABEL
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
        IF V1173 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1173 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1173 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1173 ).
        /* **CHANGE Default Site END ** */
        IF V1173 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        display  skip WMESSAGE NO-LABEL with fram F1173.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1173.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1173.
        pause 0.
        leave V1173L.
     END.
     PV1173 = V1173.
     /* END    LINE :1173  1.7.3 销售订单备料  */


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1173LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1173    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1174    */
   V1174LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1174    */
   IF NOT (V1170 = "74" OR V1100 = "74" ) THEN LEAVE V1174LMAINLOOP.
     /* START  LINE :1174  1.7.4 销售备料查询  */
     V1174L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1174           as char format "x(50)".
        define variable PV1174          as char format "x(50)".
        define variable L11741          as char format "x(40)".
        define variable L11742          as char format "x(40)".
        define variable L11743          as char format "x(40)".
        define variable L11744          as char format "x(40)".
        define variable L11745          as char format "x(40)".
        define variable L11746          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1174 = " ".
        V1174 = ENTRY(1,V1174,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1170 = "".
RUN CheckSecurity (INPUT "xssoa21.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xssoa21.p.
        leave V1174L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1174 no-box.

                /* LABEL 1 - START */ 
                  L11741 = "" . 
                display L11741          format "x(40)" skip with fram F1174 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11742 = "" . 
                display L11742          format "x(40)" skip with fram F1174 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11743 = "" . 
                display L11743          format "x(40)" skip with fram F1174 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11744 = "" . 
                display L11744          format "x(40)" skip with fram F1174 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11745 = "" . 
                display L11745          format "x(40)" skip with fram F1174 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11746 = "" . 
                display L11746          format "x(40)" skip with fram F1174 no-box.
                /* LABEL 6 - END */ 
        Update V1174
        WITH  fram F1174 NO-LABEL
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
        IF V1174 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1174 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1174 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1174 ).
        /* **CHANGE Default Site END ** */
        IF V1174 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        display  skip WMESSAGE NO-LABEL with fram F1174.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1174.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1174.
        pause 0.
        leave V1174L.
     END.
     PV1174 = V1174.
     /* END    LINE :1174  1.7.4 销售备料查询  */


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1174LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1174    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1175    */
   V1175LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1175    */
   IF NOT (V1170 = "75" OR V1100 = "75" ) THEN LEAVE V1175LMAINLOOP.
     /* START  LINE :1175  1.7.5 销售出货检查  */
     V1175L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1175           as char format "x(50)".
        define variable PV1175          as char format "x(50)".
        define variable L11751          as char format "x(40)".
        define variable L11752          as char format "x(40)".
        define variable L11753          as char format "x(40)".
        define variable L11754          as char format "x(40)".
        define variable L11755          as char format "x(40)".
        define variable L11756          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1175 = " ".
        V1175 = ENTRY(1,V1175,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1170 = "".
RUN CheckSecurity (INPUT "xssoa22.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xssoa22.p.
        leave V1175L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1175 no-box.

                /* LABEL 1 - START */ 
                  L11751 = "" . 
                display L11751          format "x(40)" skip with fram F1175 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11752 = "" . 
                display L11752          format "x(40)" skip with fram F1175 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11753 = "" . 
                display L11753          format "x(40)" skip with fram F1175 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11754 = "" . 
                display L11754          format "x(40)" skip with fram F1175 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11755 = "" . 
                display L11755          format "x(40)" skip with fram F1175 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11756 = "" . 
                display L11756          format "x(40)" skip with fram F1175 no-box.
                /* LABEL 6 - END */ 
        Update V1175
        WITH  fram F1175 NO-LABEL
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
        IF V1175 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1175 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1175 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1175 ).
        /* **CHANGE Default Site END ** */
        IF V1175 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        display  skip WMESSAGE NO-LABEL with fram F1175.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1175.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1175.
        pause 0.
        leave V1175L.
     END.
     PV1175 = V1175.
     /* END    LINE :1175  1.7.5 销售出货检查  */


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1175LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1175    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1176    */
   V1176LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1176    */
   IF NOT (V1170 = "76" OR V1100 = "76" ) THEN LEAVE V1176LMAINLOOP.
     /* START  LINE :1176  1.7.6 销售备料返修[LOT]  */
     V1176L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1176           as char format "x(50)".
        define variable PV1176          as char format "x(50)".
        define variable L11761          as char format "x(40)".
        define variable L11762          as char format "x(40)".
        define variable L11763          as char format "x(40)".
        define variable L11764          as char format "x(40)".
        define variable L11765          as char format "x(40)".
        define variable L11766          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1176 = " ".
        V1176 = ENTRY(1,V1176,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1170 = "".
RUN CheckSecurity (INPUT "xssoa24.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xssoa24.p.
        leave V1176L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1176 no-box.

                /* LABEL 1 - START */ 
                  L11761 = "" . 
                display L11761          format "x(40)" skip with fram F1176 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11762 = "" . 
                display L11762          format "x(40)" skip with fram F1176 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11763 = "" . 
                display L11763          format "x(40)" skip with fram F1176 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11764 = "" . 
                display L11764          format "x(40)" skip with fram F1176 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11765 = "" . 
                display L11765          format "x(40)" skip with fram F1176 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11766 = "" . 
                display L11766          format "x(40)" skip with fram F1176 no-box.
                /* LABEL 6 - END */ 
        Update V1176
        WITH  fram F1176 NO-LABEL
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
        IF V1176 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1176 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1176 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1176 ).
        /* **CHANGE Default Site END ** */
        IF V1176 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        display  skip WMESSAGE NO-LABEL with fram F1176.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1176.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1176.
        pause 0.
        leave V1176L.
     END.
     PV1176 = V1176.
     /* END    LINE :1176  1.7.6 销售备料返修[LOT]  */


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1176LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1176    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1177    */
   V1177LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1177    */
   IF NOT (V1170 = "77" OR V1100 = "77" ) THEN LEAVE V1177LMAINLOOP.
     /* START  LINE :1177  1.7.7 销售备料[LOT]限定订单  */
     V1177L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1177           as char format "x(50)".
        define variable PV1177          as char format "x(50)".
        define variable L11771          as char format "x(40)".
        define variable L11772          as char format "x(40)".
        define variable L11773          as char format "x(40)".
        define variable L11774          as char format "x(40)".
        define variable L11775          as char format "x(40)".
        define variable L11776          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1177 = " ".
        V1177 = ENTRY(1,V1177,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1170 = "".
RUN CheckSecurity (INPUT "xssoa23.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xssoa23.p.
        leave V1177L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1177 no-box.

                /* LABEL 1 - START */ 
                  L11771 = "" . 
                display L11771          format "x(40)" skip with fram F1177 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11772 = "" . 
                display L11772          format "x(40)" skip with fram F1177 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11773 = "" . 
                display L11773          format "x(40)" skip with fram F1177 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11774 = "" . 
                display L11774          format "x(40)" skip with fram F1177 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11775 = "" . 
                display L11775          format "x(40)" skip with fram F1177 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11776 = "" . 
                display L11776          format "x(40)" skip with fram F1177 no-box.
                /* LABEL 6 - END */ 
        Update V1177
        WITH  fram F1177 NO-LABEL
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
        IF V1177 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1177 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1177 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1177 ).
        /* **CHANGE Default Site END ** */
        IF V1177 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        display  skip WMESSAGE NO-LABEL with fram F1177.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1177.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1177.
        pause 0.
        leave V1177L.
     END.
     PV1177 = V1177.
     /* END    LINE :1177  1.7.7 销售备料[LOT]限定订单  */


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1177LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1177    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1178    */
   V1178LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1178    */
   IF NOT (V1170 = "78" OR V1100 = "78" ) THEN LEAVE V1178LMAINLOOP.
     /* START  LINE :1178  1.7.8 销售订单备料限定订单  */
     V1178L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1178           as char format "x(50)".
        define variable PV1178          as char format "x(50)".
        define variable L11781          as char format "x(40)".
        define variable L11782          as char format "x(40)".
        define variable L11783          as char format "x(40)".
        define variable L11784          as char format "x(40)".
        define variable L11785          as char format "x(40)".
        define variable L11786          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1178 = " ".
        V1178 = ENTRY(1,V1178,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1170 = "".
RUN CheckSecurity (INPUT "xssoa20.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xssoa20.p.
        leave V1178L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1178 no-box.

                /* LABEL 1 - START */ 
                  L11781 = "" . 
                display L11781          format "x(40)" skip with fram F1178 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11782 = "" . 
                display L11782          format "x(40)" skip with fram F1178 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11783 = "" . 
                display L11783          format "x(40)" skip with fram F1178 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11784 = "" . 
                display L11784          format "x(40)" skip with fram F1178 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11785 = "" . 
                display L11785          format "x(40)" skip with fram F1178 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11786 = "" . 
                display L11786          format "x(40)" skip with fram F1178 no-box.
                /* LABEL 6 - END */ 
        Update V1178
        WITH  fram F1178 NO-LABEL
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
        IF V1178 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1178 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1178 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1178 ).
        /* **CHANGE Default Site END ** */
        IF V1178 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        display  skip WMESSAGE NO-LABEL with fram F1178.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1178.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1178.
        pause 0.
        leave V1178L.
     END.
     PV1178 = V1178.
     /* END    LINE :1178  1.7.8 销售订单备料限定订单  */


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1178LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1178    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1179    */
   V1179LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1179    */
   IF NOT (V1170 = "79" OR V1100 = "79" ) THEN LEAVE V1179LMAINLOOP.
     /* START  LINE :1179  1.7.9 销售POST标签  */
     V1179L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1179           as char format "x(50)".
        define variable PV1179          as char format "x(50)".
        define variable L11791          as char format "x(40)".
        define variable L11792          as char format "x(40)".
        define variable L11793          as char format "x(40)".
        define variable L11794          as char format "x(40)".
        define variable L11795          as char format "x(40)".
        define variable L11796          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1179 = " ".
        V1179 = ENTRY(1,V1179,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1170 = "".
RUN CheckSecurity (INPUT "xslap09.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xslap09.p.
        leave V1179L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1179 no-box.

                /* LABEL 1 - START */ 
                  L11791 = "" . 
                display L11791          format "x(40)" skip with fram F1179 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11792 = "" . 
                display L11792          format "x(40)" skip with fram F1179 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11793 = "" . 
                display L11793          format "x(40)" skip with fram F1179 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11794 = "" . 
                display L11794          format "x(40)" skip with fram F1179 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11795 = "" . 
                display L11795          format "x(40)" skip with fram F1179 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11796 = "" . 
                display L11796          format "x(40)" skip with fram F1179 no-box.
                /* LABEL 6 - END */ 
        Update V1179
        WITH  fram F1179 NO-LABEL
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
        IF V1179 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1179 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1179 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1179 ).
        /* **CHANGE Default Site END ** */
        IF V1179 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        display  skip WMESSAGE NO-LABEL with fram F1179.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1179.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1179.
        pause 0.
        leave V1179L.
     END.
     PV1179 = V1179.
     /* END    LINE :1179  1.7.9 销售POST标签  */


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1179LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1179    */
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
        define variable V1180           as char format "x(50)".
        define variable PV1180          as char format "x(50)".
        define variable L11801          as char format "x(40)".
        define variable L11802          as char format "x(40)".
        define variable L11803          as char format "x(40)".
        define variable L11804          as char format "x(40)".
        define variable L11805          as char format "x(40)".
        define variable L11806          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1180 = " ".
        V1180 = ENTRY(1,V1180,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1180 no-box.

                /* LABEL 1 - START */ 
                L11801 = "璸购タ盽.81" .
                display L11801          format "x(40)" skip with fram F1180 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11802 = "璸购筁戳.82" .
                display L11802          format "x(40)" skip with fram F1180 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11803 = "CIQ001=>CRV002.83" .
                display L11803          format "x(40)" skip with fram F1180 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                L11804 = "璸购癶. . .84" .
                display L11804          format "x(40)" skip with fram F1180 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                L11805 = "Θ珇夹帽ゴ. .85" .
                display L11805          format "x(40)" skip with fram F1180 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11806 = "" . 
                display L11806          format "x(40)" skip with fram F1180 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1180 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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


   /* Additional Labels Format */
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
        define variable V1181           as char format "x(50)".
        define variable PV1181          as char format "x(50)".
        define variable L11811          as char format "x(40)".
        define variable L11812          as char format "x(40)".
        define variable L11813          as char format "x(40)".
        define variable L11814          as char format "x(40)".
        define variable L11815          as char format "x(40)".
        define variable L11816          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1181 = " ".
        V1181 = ENTRY(1,V1181,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1180 = "".
RUN CheckSecurity (INPUT "xsinv24.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xsinv24.p.
        leave V1181L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1181 no-box.

                /* LABEL 1 - START */ 
                  L11811 = "" . 
                display L11811          format "x(40)" skip with fram F1181 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11812 = "" . 
                display L11812          format "x(40)" skip with fram F1181 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11813 = "" . 
                display L11813          format "x(40)" skip with fram F1181 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11814 = "" . 
                display L11814          format "x(40)" skip with fram F1181 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11815 = "" . 
                display L11815          format "x(40)" skip with fram F1181 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11816 = "" . 
                display L11816          format "x(40)" skip with fram F1181 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1181 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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


   /* Additional Labels Format */
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
        define variable V1182           as char format "x(50)".
        define variable PV1182          as char format "x(50)".
        define variable L11821          as char format "x(40)".
        define variable L11822          as char format "x(40)".
        define variable L11823          as char format "x(40)".
        define variable L11824          as char format "x(40)".
        define variable L11825          as char format "x(40)".
        define variable L11826          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1182 = " ".
        V1182 = ENTRY(1,V1182,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1180 = "".
RUN CheckSecurity (INPUT "xsinv25.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xsinv25.p.
        leave V1182L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1182 no-box.

                /* LABEL 1 - START */ 
                  L11821 = "" . 
                display L11821          format "x(40)" skip with fram F1182 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11822 = "" . 
                display L11822          format "x(40)" skip with fram F1182 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11823 = "" . 
                display L11823          format "x(40)" skip with fram F1182 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11824 = "" . 
                display L11824          format "x(40)" skip with fram F1182 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11825 = "" . 
                display L11825          format "x(40)" skip with fram F1182 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11826 = "" . 
                display L11826          format "x(40)" skip with fram F1182 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1182 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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


   /* Additional Labels Format */
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
     /* START  LINE :1183  1.8.3 转仓CIQ001=>CRV002  */
     V1183L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1183           as char format "x(50)".
        define variable PV1183          as char format "x(50)".
        define variable L11831          as char format "x(40)".
        define variable L11832          as char format "x(40)".
        define variable L11833          as char format "x(40)".
        define variable L11834          as char format "x(40)".
        define variable L11835          as char format "x(40)".
        define variable L11836          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1183 = " ".
        V1183 = ENTRY(1,V1183,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1180 = "".
RUN CheckSecurity (INPUT "xsinv83.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xsinv83.p.
        leave V1183L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1183 no-box.

                /* LABEL 1 - START */ 
                  L11831 = "" . 
                display L11831          format "x(40)" skip with fram F1183 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11832 = "" . 
                display L11832          format "x(40)" skip with fram F1183 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11833 = "" . 
                display L11833          format "x(40)" skip with fram F1183 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11834 = "" . 
                display L11834          format "x(40)" skip with fram F1183 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11835 = "" . 
                display L11835          format "x(40)" skip with fram F1183 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11836 = "" . 
                display L11836          format "x(40)" skip with fram F1183 no-box.
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
        /* **CHANGE Default Site END ** */
        IF V1183 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
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
     /* END    LINE :1183  1.8.3 转仓CIQ001=>CRV002  */


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1183LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1183    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1184    */
   V1184LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1184    */
   IF NOT (V1180 = "84" OR V1100 = "84" ) THEN LEAVE V1184LMAINLOOP.
     /* START  LINE :1184  1.8.4 计划外退料  */
     V1184L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1184           as char format "x(50)".
        define variable PV1184          as char format "x(50)".
        define variable L11841          as char format "x(40)".
        define variable L11842          as char format "x(40)".
        define variable L11843          as char format "x(40)".
        define variable L11844          as char format "x(40)".
        define variable L11845          as char format "x(40)".
        define variable L11846          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1184 = " ".
        V1184 = ENTRY(1,V1184,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1180 = "".
RUN CheckSecurity (INPUT "xsinv26.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xsinv26.p.
        leave V1184L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1184 no-box.

                /* LABEL 1 - START */ 
                  L11841 = "" . 
                display L11841          format "x(40)" skip with fram F1184 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11842 = "" . 
                display L11842          format "x(40)" skip with fram F1184 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11843 = "" . 
                display L11843          format "x(40)" skip with fram F1184 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11844 = "" . 
                display L11844          format "x(40)" skip with fram F1184 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11845 = "" . 
                display L11845          format "x(40)" skip with fram F1184 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11846 = "" . 
                display L11846          format "x(40)" skip with fram F1184 no-box.
                /* LABEL 6 - END */ 
        Update V1184
        WITH  fram F1184 NO-LABEL
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
        IF V1184 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1184 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1184 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1184 ).
        /* **CHANGE Default Site END ** */
        IF V1184 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        display  skip WMESSAGE NO-LABEL with fram F1184.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1184.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1184.
        pause 0.
        leave V1184L.
     END.
     PV1184 = V1184.
     /* END    LINE :1184  1.8.4 计划外退料  */


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1184LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1184    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1185    */
   V1185LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1185    */
   IF NOT (V1180 = "85" OR V1100 = "85" ) THEN LEAVE V1185LMAINLOOP.
     /* START  LINE :1185  1.8.5 成品标签  */
     V1185L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1185           as char format "x(50)".
        define variable PV1185          as char format "x(50)".
        define variable L11851          as char format "x(40)".
        define variable L11852          as char format "x(40)".
        define variable L11853          as char format "x(40)".
        define variable L11854          as char format "x(40)".
        define variable L11855          as char format "x(40)".
        define variable L11856          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1185 = " ".
        V1185 = ENTRY(1,V1185,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1180 = "".
RUN CheckSecurity (INPUT "xslap85.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xslap85.p.
        leave V1185L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1185 no-box.

                /* LABEL 1 - START */ 
                  L11851 = "" . 
                display L11851          format "x(40)" skip with fram F1185 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11852 = "" . 
                display L11852          format "x(40)" skip with fram F1185 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11853 = "" . 
                display L11853          format "x(40)" skip with fram F1185 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11854 = "" . 
                display L11854          format "x(40)" skip with fram F1185 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11855 = "" . 
                display L11855          format "x(40)" skip with fram F1185 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11856 = "" . 
                display L11856          format "x(40)" skip with fram F1185 no-box.
                /* LABEL 6 - END */ 
        Update V1185
        WITH  fram F1185 NO-LABEL
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
        IF V1185 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1185 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1185 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1185 ).
        /* **CHANGE Default Site END ** */
        IF V1185 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        display  skip WMESSAGE NO-LABEL with fram F1185.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1185.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1185.
        pause 0.
        leave V1185L.
     END.
     PV1185 = V1185.
     /* END    LINE :1185  1.8.5 成品标签  */


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1185LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1185    */
   END.
   /**********************************************************************/
   pause 0 before-hide.
   /* Internal Cycle Input :1189    */
   V1189LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1185    */
   IF NOT (V1180 = "89" OR V1100 = "89" ) THEN LEAVE V1189LMAINLOOP.
     /* START  LINE :1189  1.8.9 FWD LABEL */
     V1189L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1189           as char format "x(50)".
        define variable PV1189          as char format "x(50)".
        define variable L11891          as char format "x(40)".
        define variable L11892          as char format "x(40)".
        define variable L11893          as char format "x(40)".
        define variable L11894          as char format "x(40)".
        define variable L11895          as char format "x(40)".
        define variable L11896          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1189 = " ".
        V1189 = ENTRY(1,V1189,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1180 = "".
RUN CheckSecurity (INPUT "xslap89.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xslap89.p.
        leave V1189L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1189 no-box.

                /* LABEL 1 - START */ 
                  L11891 = "" . 
                display L11891          format "x(40)" skip with fram F1189 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11892 = "" . 
                display L11892          format "x(40)" skip with fram F1189 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11893 = "" . 
                display L11893          format "x(40)" skip with fram F1189 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11894 = "" . 
                display L11894          format "x(40)" skip with fram F1189 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11895 = "" . 
                display L11895          format "x(40)" skip with fram F1189 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11896 = "" . 
                display L11896          format "x(40)" skip with fram F1189 no-box.
                /* LABEL 6 - END */ 
        Update V1189
        WITH  fram F1189 NO-LABEL
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
        IF V1189 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1189 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1189 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1189 ).
        /* **CHANGE Default Site END ** */
        IF V1189 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        display  skip WMESSAGE NO-LABEL with fram F1189.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1189.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1189.
        pause 0.
        leave V1189L.
     END.
     PV1189 = V1189.
     /* END    LINE :1189  1.8.9 FWD LABEL */


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1189LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1189    */
   END.


   /**********************************************************************/
   pause 0 before-hide.
   /* Internal Cycle Input :1186    */
   V1186LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1186    */
   IF NOT (V1180 = "86" OR V1100 = "86" ) THEN LEAVE V1186LMAINLOOP.
     /* START  LINE :1186  1.8.6 AUTO Label  */
     V1186L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1186           as char format "x(50)".
        define variable PV1186          as char format "x(50)".
        define variable L11861          as char format "x(40)".
        define variable L11862          as char format "x(40)".
        define variable L11863          as char format "x(40)".
        define variable L11864          as char format "x(40)".
        define variable L11865          as char format "x(40)".
        define variable L11866          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1186 = " ".
        V1186 = ENTRY(1,V1186,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1180 = "".
RUN CheckSecurity (INPUT "xslap87.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xslap87.p.
        leave V1186L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1186 no-box.

                /* LABEL 1 - START */ 
                  L11861 = "" . 
                display L11861          format "x(40)" skip with fram F1186 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11862 = "" . 
                display L11862          format "x(40)" skip with fram F1186 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11863 = "" . 
                display L11863          format "x(40)" skip with fram F1186 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11864 = "" . 
                display L11864          format "x(40)" skip with fram F1186 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11865 = "" . 
                display L11865          format "x(40)" skip with fram F1186 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11866 = "" . 
                display L11866          format "x(40)" skip with fram F1186 no-box.
                /* LABEL 6 - END */ 
        Update V1186
        WITH  fram F1186 NO-LABEL
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
        IF V1186 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1186 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1186 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1186 ).
        /* **CHANGE Default Site END ** */
        IF V1186 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        display  skip WMESSAGE NO-LABEL with fram F1186.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1186.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1186.
        pause 0.
        leave V1186L.
     END.
     PV1186 = V1186.
     /* END    LINE :1186  1.8.6 AUTO Label  */


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1186LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1186    */
   END.
   pause 0 before-hide.
   /* Internal Cycle Input :1188    */
   V1188LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1188    */
   IF NOT (V1180 = "88" OR V1100 = "88" ) THEN LEAVE V1188LMAINLOOP.
     /* START  LINE :1188  1.8.8 NEW成品标签打印  */
     V1188L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1188           as char format "x(50)".
        define variable PV1188          as char format "x(50)".
        define variable L11881          as char format "x(40)".
        define variable L11882          as char format "x(40)".
        define variable L11883          as char format "x(40)".
        define variable L11884          as char format "x(40)".
        define variable L11885          as char format "x(40)".
        define variable L11886          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1188 = " ".
        V1188 = ENTRY(1,V1188,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1180 = "".
RUN CheckSecurity (INPUT "xslap88.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xslap88.p.
        leave V1188L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1188 no-box.

                /* LABEL 1 - START */ 
                  L11881 = "" . 
                display L11881          format "x(40)" skip with fram F1188 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11882 = "" . 
                display L11882          format "x(40)" skip with fram F1188 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11883 = "" . 
                display L11883          format "x(40)" skip with fram F1188 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11884 = "" . 
                display L11884          format "x(40)" skip with fram F1188 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11885 = "" . 
                display L11885          format "x(40)" skip with fram F1188 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11886 = "" . 
                display L11886          format "x(40)" skip with fram F1188 no-box.
                /* LABEL 6 - END */ 
        Update V1188
        WITH  fram F1188 NO-LABEL
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
        IF V1188 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1188 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1188 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1188 ).
        /* **CHANGE Default Site END ** */
        IF V1188 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        display  skip WMESSAGE NO-LABEL with fram F1188.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1188.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1188.
        pause 0.
        leave V1188L.
     END.
     PV1188 = V1188.
     /* END    LINE :1188  1.8.8 NEW成品标签打印  */


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1188LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1188    */
   END.
   pause 0 before-hide.

   /* jack001 begins */

   /* Internal Cycle Input :1190    */
   V1190LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1190    */
   IF NOT (V1100 = "9" ) THEN LEAVE V1190LMAINLOOP.
     /* START  LINE :1190  1.9 癸89穝  */
     V1190L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1190           as char format "x(50)".
        define variable PV1190          as char format "x(50)".
        define variable L11901          as char format "x(40)".
        define variable L11902          as char format "x(40)".
        define variable L11903          as char format "x(40)".
        define variable L11904          as char format "x(40)".
        define variable L11905          as char format "x(40)".
        define variable L11906          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1190 = " ".
        V1190 = ENTRY(1,V1190,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1190 no-box.

                /* LABEL 1 - START */ 
                L11901 = "ㄓ89穝. .91" .
                display L11901          format "x(40)" skip with fram F1190 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11902 = "" .
                display L11902          format "x(40)" skip with fram F1190 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11903 = "" .
                display L11903          format "x(40)" skip with fram F1190 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11904 = "" . 
                display L11904          format "x(40)" skip with fram F1190 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11905 = "" . 
                display L11905          format "x(40)" skip with fram F1190 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11906 = "" . 
                display L11906          format "x(40)" skip with fram F1190 no-box.
                /* LABEL 6 - END */ 
        Update V1190
        WITH  fram F1190 NO-LABEL
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
        IF V1190 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1190 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1190 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1190 ).
        /* **CHANGE Default Site END ** */
        IF V1190 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        display  skip WMESSAGE NO-LABEL with fram F1190.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1190.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1190.
        pause 0.
        leave V1190L.
     END.
     PV1190 = V1190.
     /* END    LINE :1190  1.9 穝糤э89  */


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1190LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1190    */
   END.
   pause 0 before-hide.

    /* Internal Cycle Input :1191    */
   V1191LMAINLOOP:
   REPEAT:
   /*Logical Enter Cycle1185    */
   IF NOT (V1190 = "91" OR V1100 = "91" ) THEN LEAVE V1191LMAINLOOP.
     /* START  LINE :1191  1.9.1 FWD LABEL */
     V1191L:
     REPEAT:

        /* --DEFINE VARIABLE -- START */
        hide all.
        define variable V1191           as char format "x(50)".
        define variable PV1191          as char format "x(50)".
        define variable L11911          as char format "x(40)".
        define variable L11912          as char format "x(40)".
        define variable L11913          as char format "x(40)".
        define variable L11914          as char format "x(40)".
        define variable L11915          as char format "x(40)".
        define variable L11916          as char format "x(40)".
        /* --DEFINE VARIABLE -- END */


        /* --FIRST TIME DEFAULT  VALUE -- START  */
        /* --FIRST TIME DEFAULT  VALUE -- END  */


        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1191 = " ".
        V1191 = ENTRY(1,V1191,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        V1190 = "".
RUN CheckSecurity (INPUT "xslap91.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
IF OkToRun = yes THEN  RUN    xslap91.p.
        leave V1191L.
        /* LOGICAL SKIP END */
                display "#兵絏# *" + ( if length(DBNAME) < 5 then trim( DBNAME ) else trim(substring(DBNAME,length(DBNAME) - 4,5)) )
                                        + "*" + TRIM ( V1002 )  format "x(40)" skip with fram F1191 no-box.

                /* LABEL 1 - START */ 
                  L11911 = "" . 
                display L11911          format "x(40)" skip with fram F1191 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11912 = "" . 
                display L11912          format "x(40)" skip with fram F1191 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                  L11913 = "" . 
                display L11913          format "x(40)" skip with fram F1191 no-box.
                /* LABEL 3 - END */ 


                /* LABEL 4 - START */ 
                  L11914 = "" . 
                display L11914          format "x(40)" skip with fram F1191 no-box.
                /* LABEL 4 - END */ 


                /* LABEL 5 - START */ 
                  L11915 = "" . 
                display L11915          format "x(40)" skip with fram F1191 no-box.
                /* LABEL 5 - END */ 


                /* LABEL 6 - START */ 
                  L11916 = "" . 
                display L11916          format "x(40)" skip with fram F1191 no-box.
                /* LABEL 6 - END */ 
        Update V1191
        WITH  fram F1191 NO-LABEL
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
        IF V1191 = "e" THEN  LEAVE MAINLOOP.
        /* **SKIP TO MAIN LOOP END** */
        /* **LOAD MENU START** */
        IF V1191 = "$LOADMENU" THEN  RUN LOADMENU.
        /* **LOAD MENU END ** */
        IF INDEX ( V1191 ,".") <> 0 THEN  RUN RUNMFGPROPROGRAM ( INPUT V1191 ).
        /* **CHANGE Default Site END ** */
        IF V1191 = "S" THEN  RUN xsmdf01.p.
        /* **CHANGE DEFAULT SITE END ** */
        display  skip WMESSAGE NO-LABEL with fram F1191.

         /*  ---- Valid Check ---- START */

        display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1191.
        pause 0.
        /* CHECK FOR NUMBER VARIABLE START  */
        /* CHECK FOR NUMBER VARIABLE  END */
         /*  ---- Valid Check ---- END */

        display  "" @ WMESSAGE NO-LABEL with fram F1191.
        pause 0.
        leave V1191L.
     END.
     PV1191 = V1191.
     /* END    LINE :1191  1.9.1 FWD LABEL */


   /* Additional Labels Format */
   /* Without Condition Exit Cycle Start */ 
   LEAVE V1191LMAINLOOP.
   /* Without Condition Exit Cycle END */ 
   /* Internal Cycle END :1191    */
   END.


   /**********************************************************************/
   pause 0 before-hide.
   /* jack001 end */
end.
