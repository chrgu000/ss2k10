/* xsmf001.p   BARCODE MAIN MENU                                            */
/* Copyright by Softspeed                                                   */ 
/* BARCODE SYSTEM      Create : 08/17/06   BY: tommy                        */

define shared variable global_domain like dom_domain.
define shared variable global_userid like usr_userid format "x(40)".
define shared variable execname as char format "x(40)".
define shared variable batchrun like mfc_logical.
define variable sectionid as integer init 0 .
define variable wmessage as char format "x(80)" init "".
define variable wtm_num as char format "x(20)" init "0".
define variable wsection as char format "x(16)".
define variable i as integer .
define variable wtimeout as integer init 99999 .
define variable OkToRun as logical init no .
define variable dmdesc like dom_name.
define variable prog as char format "x(60)" no-undo.
define variable j as integer.

find first code_mstr where code_fldname = "BARCODE"
   AND CODE_value ="wtimeout" and code_domain = global_domain 
   no-lock no-error.                                   /* Timeout - All Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).
find first code_mstr where code_fldname = "BARCODE" AND CODE_value ="wtimeout"
   and code_domain = global_domain no-lock no-error.    /*  Timeout - Program Level */
if AVAILABLE(code_mstr) Then wtimeout = 60 * decimal(code_cmmt).

find first dom_mstr where dom_domain = global_domain no-lock no-error.
dmdesc = "#条码#*" + (if available dom_mstr then trim(dom_name) else "")
         + trim(substring(DBNAME,length(DBNAME) - 3,7)).

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
        display " *** WARNING *** " skip with fram WarningBox no-box.
         display " YOU CAN NOT" skip with fram WarningBox no-box.
         display " ACCESS THIS" skip with fram WarningBox no-box.
         display "  FUNCTION!" skip with fram WarningBox no-box.
         display " CONTACT IT " skip with fram WarningBox no-box.
         display " DEPARTMENT " skip with fram WarningBox no-box.
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
         Display "UPDATE...... "  skip with frame UpdateBox no-box.
         Display trim ( ProgramID )      no-label  skip with frame UpdateBox no-box.
         Display trim ( ProgramFunction ) no-label skip with frame UpdateBox no-box.
         Pause.
  END.
  INPUT CLOSE.
END PROCEDURE.
PROCEDURE UPDATE_QAD_WKFL:
     DEFINE INPUT PARAMETER  wProgramMenu     AS character.
     DEFINE INPUT PARAMETER  wProgramID       AS character.
     DEFINE INPUT PARAMETER  wProgramFunction AS character.
     DEFINE INPUT PARAMETER  wProgramSecurity AS character.
     FIND First QAD_WKFL where QAD_KEY1 = "BARCODEMENU" and QAD_KEY2 = trim(wProgramID) no-error.
     IF AVAILABLE(QAD_WKFL) Then Do:
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
                display dmdesc format "x(40)" skip with fram F1002 no-box.

                /* LABEL 1 - START */ 
                L10021 = "地点设定有误".
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
        /* **CHANGE Default Site END ** */
/*tommy IF V1002 = "S" THEN  RUN xsmdf01.p. */
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
     /* END    LINE :1002  地点[SITE]  */


     /* START  LINE :1100  1主菜单  */
     V1100L:
     REPEAT:
        hide all.
        define variable V1100           as char format "x(50)".
        define variable PV1100          as char format "x(50)".
        define variable L11001          as char format "x(40)".
        define variable L11002          as char format "x(40)".
        define variable L11003          as char format "x(40)".
        define variable L11004          as char format "x(40)".
        define variable L11005          as char format "x(40)".
        define variable L11006          as char format "x(40)".

        /* --CYCLE TIME DEFAULT  VALUE -- START  */
        V1100 = " ".
        V1100 = ENTRY(1,V1100,"@").
        /* --CYCLE TIME DEFAULT  VALUE -- END  */

        /* LOGICAL SKIP START */
        /* LOGICAL SKIP END */
                display dmdesc format "x(40)" skip with fram F1100 no-box.

                /* LABEL 1 - START */ 
                L11001 = "转仓菜单. . . .1" .
                display L11001          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11002 = "出货菜单. . . .2" .
                display L11002          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 2 - END */ 

                /* LABEL 3 - START */ 
                L11003 = " " .
                display L11003          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 4 - START */ 
                L11004 = " " .
                display L11004          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 5 - START */ 
                L11005 = " " .
                display L11005          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 6 - START */ 
                L11006= " " .
                display L11006          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 2 - END */ 

        Update V1100
        WITH  frame F1100 NO-LABEL
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
        /* **CHANGE Default Site END ** */
/*tommy IF V1100 = "S" THEN  RUN xsmdf01.p.*/
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
/*mage add 08/10/29*/    global_userid = trim ( userid(sdbname('qaddb')) ).


     /* Internal Cycle Input :1110    */
     V1110LMAINLOOP:
     REPEAT:
        /*Logical Enter Cycle1110    */
        IF NOT (V1100 = "1" ) THEN LEAVE V1110LMAINLOOP.
        /* START  LINE :1110  1.1 转仓菜单  */
        V1110L:
        REPEAT:
           hide all.
           define variable V1110           as char format "x(50)".
           define variable PV1110          as char format "x(50)".
           define variable L11101          as char format "x(40)".
           define variable L11102          as char format "x(40)".
           define variable L11103          as char format "x(40)".
           define variable L11104          as char format "x(40)".
           define variable L11105          as char format "x(40)".
           define variable L11106          as char format "x(40)".
                display dmdesc format "x(40)" skip with fram F1110 no-box.

                /* LABEL 1 - START */ 
                L11101 = "福特WIP转成品入库. .11".
                display L11101          format "x(40)" skip with fram F1110 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11102 = "其它WIP转成品入库. .12" .
                display L11102          format "x(40)" skip with fram F1110 no-box.
                /* LABEL 2 - END */ 

                /* LABEL 3 - START */ 
                L11103 = "" .
                display L11103          format "x(40)" skip with fram F1110 no-box.
                /* LABEL 4 - START */ 
                L11104 = "" .
                display L11104          format "x(40)" skip with fram F1110 no-box.
                /* LABEL 5 - START */ 
                L11105 = "" .
                display L11105          format "x(40)" skip with fram F1110 no-box.
                /* LABEL 6 - START */ 
                L11106 = "" .
                display L11106          format "x(40)" skip with fram F1110 no-box.

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
           IF V1110 = "e" THEN  LEAVE V1110L.

           /* **SKIP TO MAIN LOOP END** */
           /* **LOAD MENU START** */
           IF V1110 = "$LOADMENU" THEN  RUN LOADMENU.
           /* **LOAD MENU END ** */
           /* **CHANGE Default Site END ** */
/*tommy    IF V1110 = "S" THEN  RUN xsmdf01.p.*/
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
        /* END    LINE :1110  1.1 转仓菜单  */

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
        /* START  LINE :1111  1.1.1 福特转仓]  */
        V1111L:
        REPEAT:

           hide all.
           define variable V1111           as char format "x(50)".
           define variable PV1111          as char format "x(50)".
           define variable L11111          as char format "x(40)".
           define variable L11112          as char format "x(40)".

           /* --CYCLE TIME DEFAULT  VALUE -- START  */
           V1111 = " ".
           V1111 = ENTRY(1,V1111,"@").
           /* --CYCLE TIME DEFAULT  VALUE -- END  */

           /* LOGICAL SKIP START */
           V1110 = "".

           RUN CheckSecurity (INPUT "xsictr01.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
           IF OkToRun = yes then RUN xsictr01.p.
           leave V1111L.

	   /* LOGICAL SKIP END */
                display dmdesc format "x(40)" skip with fram F1111 no-box.

                /* LABEL 1 - START */ 
                  L11111 = "" . 
                display L11111          format "x(40)" skip with fram F1111 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11112 = "" . 
                display L11112          format "x(40)" skip with fram F1111 no-box.
                /* LABEL 2 - END */ 

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
           IF V1111 = "e" THEN  LEAVE V1111L.
           /* **SKIP TO MAIN LOOP END** */
           /* **LOAD MENU START** */
           IF V1111 = "$LOADMENU" THEN  RUN LOADMENU.
           /* **LOAD MENU END ** */
           /* **CHANGE Default Site END ** */
/*tommy    IF V1111 = "S" THEN  RUN xsmdf01.p. */
           /* **CHANGE DEFAULT SITE END ** */
           display  skip WMESSAGE NO-LABEL with fram F1111.

           /*  ---- Valid Check ---- START */

           display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1111.
           pause 0.
           /*  ---- Valid Check ---- END */

           display  "" @ WMESSAGE NO-LABEL with fram F1111.
           pause 0.
           leave V1111L.
        END.
        PV1111 = V1111.

        /* Without Condition Exit Cycle Start */ 
        LEAVE V1111LMAINLOOP.
        /* Without Condition Exit Cycle END */ 
        /* Internal Cycle END :1111    */
     END.
     pause 0 before-hide.

     /* Internal Cycle Input :1111    */
     V1112LMAINLOOP:
     REPEAT:
        /*Logical Enter Cycle1111    */
        IF NOT (V1110 = "12" OR V1100 = "12" ) THEN LEAVE V1112LMAINLOOP.
        /* START  LINE :1111  1.1.1 福特转仓]  */
        V1112L:
        REPEAT:

           hide all.

	   define variable V1112           as char format "x(50)".
           define variable PV1112          as char format "x(50)".
           define variable L11121          as char format "x(40)".
           define variable L11122          as char format "x(40)".


           /* --CYCLE TIME DEFAULT  VALUE -- START  */
           V1112 = " ".
           V1112 = ENTRY(1,V1112,"@").
           /* --CYCLE TIME DEFAULT  VALUE -- END  */

           /* LOGICAL SKIP START */
           V1110 = "".

           RUN CheckSecurity (INPUT "xsictr02.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
           IF OkToRun = yes then RUN xsictr02.p.
           leave V1112L.

	   /* LOGICAL SKIP END */
           display dmdesc format "x(40)" skip with fram F1112 no-box.

           /* LABEL 1 - START */ 
           L11121 = "" . 
           display L11121          format "x(40)" skip with fram F1112 no-box.
           /* LABEL 1 - END */ 

           /* LABEL 2 - START */ 
           L11122 = "" . 
           display L11122          format "x(40)" skip with fram F1112 no-box.
           /* LABEL 2 - END */ 

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
           IF V1112 = "e" THEN  LEAVE V1112L.
           /* **SKIP TO MAIN LOOP END** */
           /* **LOAD MENU START** */
           IF V1112 = "$LOADMENU" THEN  RUN LOADMENU.
           /* **LOAD MENU END ** */

	  display  skip WMESSAGE NO-LABEL with fram F1112.

           /*  ---- Valid Check ---- START */

           display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1112.
           pause 0.
           /*  ---- Valid Check ---- END */

           display  "" @ WMESSAGE NO-LABEL with fram F1112.
           pause 0.
           leave V1112L.
        END.
        PV1112 = V1112.

        /* Without Condition Exit Cycle Start */ 
        LEAVE V1112LMAINLOOP.
        /* Without Condition Exit Cycle END */ 
        /* Internal Cycle END :1111    */
     END.
     pause 0 before-hide.

     /* Internal Cycle Input :1130    */
     V1130LMAINLOOP:
     REPEAT:
        /*Logical Enter Cycle1130    */
        IF NOT (V1100 = "2" ) THEN LEAVE V1130LMAINLOOP.
        /* START  LINE :1130  1.出货菜单  */
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

           /* --CYCLE TIME DEFAULT  VALUE -- START  */
           V1130 = " ".
           V1130 = ENTRY(1,V1130,"@").
           /* --CYCLE TIME DEFAULT  VALUE -- END  */

           /* LOGICAL SKIP START */
           /* LOGICAL SKIP END */
                display dmdesc format "x(40)" skip with fram F1130 no-box.

                /* LABEL 1 - START */ 
                L11301 = "福特:货物发福特. . . 21" .
                display L11301          format "x(40)" skip with fram F1130 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11302 = "其它:货物内部发其它..22" .
                display L11302          format "x(40)" skip with fram F1130 no-box.
                /* LABEL 2 - END */ 

                L11303 = "....下有SO控制......." .
                display L11303          format "x(40)" skip with fram F1130 no-box.

                L11304 = "福特:货物发福特-SO...23" .
                display L11304          format "x(40)" skip with fram F1130 no-box.

                L11305 = "其它:货物发其它-SO...24".
                display L11305          format "x(40)" skip with fram F1130 no-box.

                L11306 = " " .
                display L11306          format "x(40)" skip with fram F1130 no-box.

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
           IF V1130 = "e" THEN  LEAVE V1130L.

           /* **LOAD MENU START** */
           IF V1130 = "$LOADMENU" THEN  RUN LOADMENU.
           /* **LOAD MENU END ** */
           /* **CHANGE Default Site END ** */
/*tommy    IF V1130 = "S" THEN  RUN xsmdf01.p. */
           /* **CHANGE DEFAULT SITE END ** */
           display skip WMESSAGE NO-LABEL with fram F1130.

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
           IF NOT (V1130 = "21" OR V1100 = "21" ) THEN LEAVE V1131LMAINLOOP.
           /* START  LINE :1131  1.3.1 福特货物发货  */
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
	      
              RUN CheckSecurity (INPUT "xsship01.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
              IF OkToRun = yes then RUN xsship01.p.
              leave V1131L.

	      /* LOGICAL SKIP END */
                display dmdesc format "x(40)" skip with fram F1131 no-box.

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

                /* LABEL 4 - START */ 
                  L11314 = "" . 
                display L11314          format "x(40)" skip with fram F1131 no-box.

                /* LABEL 3 - START */ 
                  L11315 = "" . 
                display L11315          format "x(40)" skip with fram F1131 no-box.
                /* LABEL 3 - START */ 
                  L11316 = "" . 
                display L11316          format "x(40)" skip with fram F1131 no-box.

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
              IF V1131 = "e" THEN  LEAVE V1131L.
              /* **SKIP TO MAIN LOOP END** */
              /* **LOAD MENU START** */
              IF V1131 = "$LOADMENU" THEN  RUN LOADMENU.
              /* **LOAD MENU END ** */
              /* **CHANGE Default Site END ** */
/*tommy       IF V1131 = "S" THEN  RUN xsmdf01.p. */
              /* **CHANGE DEFAULT SITE END ** */
              display skip WMESSAGE NO-LABEL with fram F1131.

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
           IF NOT (V1130 = "22" OR V1100 = "22" ) THEN LEAVE V1132LMAINLOOP.
           /* START  LINE :1132  1.3.2 内部货物发货  */
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
	      
              RUN CheckSecurity (INPUT "xsship02.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
              IF OkToRun = yes THEN RUN xsship02.p.
              leave V1132L.

	      /* LOGICAL SKIP END */
                display dmdesc format "x(40)" skip with fram F1132 no-box.

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
                /* LABEL 4 - START */ 
                  L11324 = "" . 
                display L11324          format "x(40)" skip with fram F1132 no-box.
                /* LABEL 5 - START */ 
                  L11325 = "" . 
                display L11326          format "x(40)" skip with fram F1132 no-box.
                /* LABEL 6 - START */ 
                  L11326 = "" . 
                display L11326          format "x(40)" skip with fram F1132 no-box.

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
              IF V1132 = "e" THEN  LEAVE V1132L.
              /* **SKIP TO MAIN LOOP END** */
              /* **LOAD MENU START** */
              IF V1132 = "$LOADMENU" THEN  RUN LOADMENU.
              /* **LOAD MENU END ** */
              /* **CHANGE Default Site END ** */
/*tommy       IF V1132 = "S" THEN  RUN xsmdf01.p.*/
              /* **CHANGE DEFAULT SITE END ** */
              display skip WMESSAGE NO-LABEL with fram F1132.

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

           /* Without Condition Exit Cycle Start */ 
           LEAVE V1132LMAINLOOP.
           /* Without Condition Exit Cycle END */ 
           /* Internal Cycle END :1132    */
        END.
        pause 0 before-hide.

/*************** start tx01***********/

     /* Internal Cycle Input :1131    */
     V1141LMAINLOOP:
     REPEAT:
           /*Logical Enter Cycle1131    */
           IF NOT (V1130 = "23" OR V1100 = "23" ) THEN LEAVE V1141LMAINLOOP.

           /* START  LINE :1131  1.3.1 福特货物发货  */
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

              V1141 = " ".
              V1141 = ENTRY(1,V1141,"@").

	      V1130 = "".
	      
              RUN CheckSecurity (INPUT "xsship01_so.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
              IF OkToRun = yes then RUN xsship01_so.p.
              leave V1141L.

	      /* LOGICAL SKIP END */
                display dmdesc format "x(40)" skip with fram F1141 no-box.

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

                /* LABEL 4 - START */ 
                  L11414 = "" . 
                display L11414          format "x(40)" skip with fram F1141 no-box.

                /* LABEL 3 - START */ 
                  L11415 = "" . 
                display L11415          format "x(40)" skip with fram F1141 no-box.
                /* LABEL 3 - START */ 

                  L11416 = "" . 
                display L11416          format "x(40)" skip with fram F1141 no-box.

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
              IF V1141 = "e" THEN  LEAVE V1141L.
              /* **SKIP TO MAIN LOOP END** */
              /* **LOAD MENU START** */
              IF V1141 = "$LOADMENU" THEN  RUN LOADMENU.
              /* **LOAD MENU END ** */
              /* **CHANGE Default Site END ** */
/*tommy       IF V1131 = "S" THEN  RUN xsmdf01.p.
 */
              /* **CHANGE DEFAULT SITE END ** */
              display skip WMESSAGE NO-LABEL with fram F1141.

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
           /* END    LINE :1131  1.3.1 工单发正常料  */


           /* Without Condition Exit Cycle Start */ 
           LEAVE V1141LMAINLOOP.
           /* Without Condition Exit Cycle END */ 
           /* Internal Cycle END :1131    */
        END.
        pause 0 before-hide.

        /* Internal Cycle Input :1132    */
        V1151LMAINLOOP:
        REPEAT:
           /*Logical Enter Cycle1132    */
           IF NOT (V1130 = "24" OR V1100 = "24" ) THEN LEAVE V1151LMAINLOOP.

	   /* START  LINE :1132  1.3.2 内部货物发货  */
           V1151L:
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

              /* --CYCLE TIME DEFAULT  VALUE -- START  */
              V1152 = " ".
              V1152 = ENTRY(1,V1152,"@").
              /* --CYCLE TIME DEFAULT  VALUE -- END  */

              /* LOGICAL SKIP START */
              V1130 = "".
	      
              RUN CheckSecurity (INPUT "xsship02.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
              IF OkToRun = yes THEN RUN xsship02_so.p.
              leave V1151L.

	      /* LOGICAL SKIP END */
                display dmdesc format "x(40)" skip with fram F1152 no-box.

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
                /* LABEL 4 - START */ 
                  L11524 = "" . 
                display L11524          format "x(40)" skip with fram F1152 no-box.
                /* LABEL 5 - START */ 
                  L11525 = "" . 
                display L11526          format "x(40)" skip with fram F1152 no-box.
                /* LABEL 6 - START */ 
                  L11526 = "" . 
                display L11526          format "x(40)" skip with fram F1152 no-box.


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
              IF V1152 = "e" THEN  LEAVE V1151L.
              /* **SKIP TO MAIN LOOP END** */
              /* **LOAD MENU START** */
              IF V1152 = "$LOADMENU" THEN  RUN LOADMENU.
              /* **LOAD MENU END ** */
              /* **CHANGE Default Site END ** */
/*tommy       IF V1132 = "S" THEN  RUN xsmdf01.p.
*/
              /* **CHANGE DEFAULT SITE END ** */
              display skip WMESSAGE NO-LABEL with fram F1152.

              /*  ---- Valid Check ---- START */

              display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1152.
              pause 0.
              /* CHECK FOR NUMBER VARIABLE START  */
              /* CHECK FOR NUMBER VARIABLE  END */
              /*  ---- Valid Check ---- END */

              display  "" @ WMESSAGE NO-LABEL with fram F1152.
              pause 0.
              leave V1151L.
           END.
           PV1152 = V1152.

           /* Without Condition Exit Cycle Start */ 
           LEAVE V1151LMAINLOOP.
           /* Without Condition Exit Cycle END */ 
           /* Internal Cycle END :1132    */
        END.
        pause 0 before-hide.

/**************** end tx01*************/

     end.





