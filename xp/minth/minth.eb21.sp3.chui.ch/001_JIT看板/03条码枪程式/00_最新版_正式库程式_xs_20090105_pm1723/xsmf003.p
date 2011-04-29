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
define variable j as integer.
define shared variable prog as char format "x(60)" no-undo.
define shared variable suser as char no-undo.

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
/*mage add 08/10/29*/    global_userid = trim ( userid(sdbname('qaddb')) ).

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

                display dmdesc format "x(40)" skip with fram F1100 no-box.

                /* LABEL 1 - START */ 
                L11001 = "看板采购刷读....1" .
                display L11001          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                L11002 = "看板刷读转移....2" .
                display L11002          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 3 - START */ 
                L11003 = "看板货运单生成..3 " .
                display L11003          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 3 - END */ 

		/* LABEL 4 - START */ 
                L11004 = " " .
                display L11004          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 4 - END */ 

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
/*	
	if V1100 = "11" and lookup("xxkbporc.p", prog) = 0 then do:
	   display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1100.
           pause 0 before-hide.
           undo, retry.		        
	end.

	if V1100 = "12" and lookup("xxkbport.p", prog) = 0 then do:
	   display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1100.
           pause 0 before-hide.
           undo, retry.		        
	end.

	if V1100 = "13" and lookup("xskbshpnbr.p", prog) = 0 then do:
	   display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1100.
           pause 0 before-hide.
           undo, retry.		        
	end.

        if V1100 = "21" and lookup("mhjit035.p", prog) = 0 then do:
	   display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1100.
           pause 0 before-hide.
           undo, retry.		        
	end.

        if V1100 = "22" and lookup("mhjit036.p", prog) = 0 then do:
	   display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1100.
           pause 0 before-hide.
           undo, retry.		        
	end.

	if V1100 = "23" and lookup("mhjit038.p", prog) = 0 then do:
	   display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1100.
           pause 0 before-hide.
           undo, retry.		        
	end.

	if V1100 = "24" and lookup("mhjit047.p", prog) = 0 then do:
	   display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1100.
           pause 0 before-hide.
           undo, retry.		        
	end.

	if V1100 = "25" and lookup("mhjit050.p", prog) = 0 then do:
	   display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1100.
           pause 0 before-hide.
           undo, retry.		        
	end.
		
	if V1100 = "26" and lookup("mhjit000.p", prog) = 0 then do:
	   display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1100.
           pause 0 before-hide.
           undo, retry.		        
	end.
*/		
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

     /* Internal Cycle Input :1130    */
     V1140LMAINLOOP:
     REPEAT:
        /*Logical Enter Cycle1130    */
        IF NOT (V1100 = "1" ) THEN LEAVE V1140LMAINLOOP.
        
	/* START  LINE :1130  3.看板菜单  */
        V1140L:
        REPEAT:

           /* --DEFINE VARIABLE -- START */
           hide all.
           define variable V1430           as char format "x(50)".
           define variable PV1430          as char format "x(50)".
           define variable L11401          as char format "x(40)".
           define variable L11402          as char format "x(40)".

           define variable L11403          as char format "x(40)".
           define variable L11404          as char format "x(40)".
           define variable L11405          as char format "x(40)".
           define variable L11406          as char format "x(40)".

           /* --CYCLE TIME DEFAULT  VALUE -- START  */
           V1430 = " ".
           V1430 = ENTRY(1,V1430,"@").

		display dmdesc format "x(40)" skip with fram F1430 no-box.

                /* LABEL 1 - START */ 
                L11401 = "PO看板刷读收货....11" .
                display L11401          format "x(40)" skip with fram F1430 no-box.
                /* LABEL 1 - END */ 

                /* LABEL 2 - START */ 
                L11402 = "PO看板刷读退货....12" .
                display L11402          format "x(40)" skip with fram F1430 no-box.
                /* LABEL 2 - END */ 

		L11403 = " " .
                display L11403          format "x(40)" skip with fram F1430 no-box.

		L11404 = "  " .
                display L11404          format "x(40)" skip with fram F1430 no-box.

                L11405 = " " .
                display L11405          format "x(40)" skip with fram F1430 no-box.
                L11406 = " " .
                display L11406          format "x(40)" skip with fram F1430 no-box.

           Update V1430
           WITH  fram F1430 NO-LABEL
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
           IF V1430 = "e" THEN  LEAVE V1140L.
           /* **SKIP TO MAIN LOOP END** */
/*
	   if V1430 = "11" and lookup("xxkbporc.p", prog) = 0 then do:
	      display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1430.
              pause 0 before-hide.
              undo, retry.		        
	   end.

	   if V1430 = "12" and lookup("xxkbport.p", prog) = 0 then do:
	      display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1430.
              pause 0 before-hide.
              undo, retry.		        
	   end.

	   if V1430 = "13" and lookup("xskbshpnbr.p", prog) = 0 then do:
	      display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1430.
              pause 0 before-hide.
              undo, retry.		        
	   end.
*/
           /* **LOAD MENU START** */
           IF V1430 = "$LOADMENU" THEN  RUN LOADMENU.
           /* **LOAD MENU END ** */

	   /* **CHANGE DEFAULT SITE END ** */
           display skip WMESSAGE NO-LABEL with fram F1430.

           /*  ---- Valid Check ---- START */

           display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1430.
           pause 0.

           display  "" @ WMESSAGE NO-LABEL with fram F1430.
           pause 0.
           leave V1140L.
        END.
        PV1430  = V1430.


        /* Without Condition Exit Cycle Start */ 
        LEAVE V1140LMAINLOOP.
        /* Without Condition Exit Cycle END */ 
        /* Internal Cycle END :1130    */
     END.
     pause 0 before-hide.

     /* Internal Cycle Input :1131    */
     V1141LMAINLOOP:
     REPEAT:
           /*Logical Enter Cycle1131    */
           IF NOT (V1430 = "11" or V1100 = "11") THEN LEAVE V1141LMAINLOOP.

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
              /* --CYCLE TIME DEFAULT  VALUE -- END  */

              /* LOGICAL SKIP START */
              V1430 = "".
              
	      /* run program PO收货 */

              RUN xxkbporc.p.
              pause 0 before-hide.
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
              display skip WMESSAGE NO-LABEL with fram F1141.

              /*  ---- Valid Check ---- START */

              display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1141.
              pause 0.

              display  "" @ WMESSAGE NO-LABEL with fram F1141.
              pause 0.
              leave V1141L.
           END.
           PV1141 = V1141.


           /* Without Condition Exit Cycle Start */ 
           LEAVE V1141LMAINLOOP.
           /* Without Condition Exit Cycle END */ 
           /* Internal Cycle END :1131    */
     END.
     pause 0 before-hide.

     /* Internal Cycle Input :1131    */
     V1151LMAINLOOP:
     REPEAT:
           /*Logical Enter Cycle1131    */
           IF NOT (V1430 = "12" or V1100 = "12") THEN LEAVE V1151LMAINLOOP.

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

              V1151 = " ".
              V1151 = ENTRY(1,V1151,"@").
              /* --CYCLE TIME DEFAULT  VALUE -- END  */

              /* LOGICAL SKIP START */
              V1430 = "".
              
	      /* run program PO退货 */
              RUN xxkbport.p.
              leave V1151L.

	      /* LOGICAL SKIP END */
                display dmdesc format "x(40)" skip with fram F1151 no-box.

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

                /* LABEL 4 - START */ 
                  L11514 = "" . 
                display L11514          format "x(40)" skip with fram F1151 no-box.


                /* LABEL 3 - START */ 
                  L11515 = "" . 
                display L11515          format "x(40)" skip with fram F1151 no-box.
                /* LABEL 3 - START */ 
                  L11516 = "" . 
                display L11516          format "x(40)" skip with fram F1151 no-box.

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
              IF V1151 = "e" THEN  LEAVE V1151L.
              /* **SKIP TO MAIN LOOP END** */
              /* **LOAD MENU START** */
              IF V1151 = "$LOADMENU" THEN  RUN LOADMENU.
              /* **LOAD MENU END ** */
              display skip WMESSAGE NO-LABEL with fram F1151.

              /*  ---- Valid Check ---- START */

              display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1151.
              pause 0.

              display  "" @ WMESSAGE NO-LABEL with fram F1151.
              pause 0.
              leave V1151L.
           END.
           PV1151 = V1151.


           /* Without Condition Exit Cycle Start */ 
           LEAVE V1151LMAINLOOP.
           /* Without Condition Exit Cycle END */ 
           /* Internal Cycle END :1131    */
        END.
        pause 0 before-hide.

     /* Internal Cycle Input :1130    */
     V1150LMAINLOOP:
     REPEAT:
        /*Logical Enter Cycle1130    */
        IF NOT (V1100 = "2" ) THEN LEAVE V1150LMAINLOOP.
     
	/* START  LINE :1130  3.看板菜单  */
        V1150L:
        REPEAT:

           /* --DEFINE VARIABLE -- START */
           hide all.
           define variable V1530           as char format "x(50)".
           define variable PV1530          as char format "x(50)".
           define variable L11501          as char format "x(40)".
           define variable L11502          as char format "x(40)".

           define variable L11503          as char format "x(40)".
           define variable L11504          as char format "x(40)".
           define variable L11505          as char format "x(40)".
           define variable L11506          as char format "x(40)".
           define variable L11507          as char format "x(40)".

           /* --CYCLE TIME DEFAULT  VALUE -- START  */
           V1530 = " ".
           V1530 = ENTRY(1,V1530,"@").

                /* LABEL 1 - START */ 
                L11501 = "看板刷读库存转移..21" .
                display L11501          format "x(40)" skip with fram F1530 no-box.
                /* LABEL 1 - END */ 

                /* LABEL 2 - START */ 
                L11502 = "看板刷读看板转移..22" .
                display L11502          format "x(40)" skip with fram F1530 no-box.
                /* LABEL 2 - END */ 

                L11503 = "领料看板刷读领料..23" .
                display L11503          format "x(40)" skip with fram F1530 no-box.

                L11504 = "看板刷读生产退料..24" .
                display L11504          format "x(40)" skip with fram F1530 no-box.

		L11505 = "看板生产转仓入库..25" .
                display L11505          format "x(40)" skip with fram F1530 no-box.
/*debug
		L11506 = "看板刷读数量清零..26 " .
                display L11506          format "x(40)" skip with fram F1530 no-box.
*/

		L11506 = "有领料无采购看板..26" .
                display L11506          format "x(40)" skip with fram F1530 no-box.

		L11507 = "有采购无领料看板..27" .
                display L11507          format "x(40)" skip with fram F1530 no-box.


           Update V1530
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
           /* **SKIP TO MAIN LOOP START** */
           IF V1530 = "e" THEN  LEAVE V1150L.
           /* **SKIP TO MAIN LOOP END** */
/*
	   if V1530 = "21" and lookup("mhjit035.p", prog) = 0 then do:
	      display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1530.
              pause 0 before-hide.
              undo, retry.		        
	   end.

	   if V1530 = "22" and lookup("mhjit036.p", prog) = 0 then do:
	      display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1530.
              pause 0 before-hide.
              undo, retry.		        
	   end.

	   if V1530 = "23" and lookup("mhjit038.p", prog) = 0 then do:
	      display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1530.
              pause 0 before-hide.
              undo, retry.		        
	   end.

	   if V1530 = "24" and lookup("mhjit047.p", prog) = 0 then do:
	      display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1530.
              pause 0 before-hide.
              undo, retry.		        
	   end.

	   if V1530 = "25" and lookup("mhjit050.p", prog) = 0 then do:
	      display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1530.
              pause 0 before-hide.
              undo, retry.		        
	   end.

	   if V1530 = "26" and lookup("mhjit000.p", prog) = 0 then do:
	      display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1530.
              pause 0 before-hide.
              undo, retry.		        
	   end.
*/
           /* **LOAD MENU START** */
           IF V1530 = "$LOADMENU" THEN  RUN LOADMENU.
           /* **LOAD MENU END ** */

	   /* **CHANGE DEFAULT SITE END ** */
           display skip WMESSAGE NO-LABEL with fram F1530.

           /*  ---- Valid Check ---- START */

           display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1530.
           pause 0.

           display  "" @ WMESSAGE NO-LABEL with fram F1530.
           pause 0.
           leave V1150L.
        END.
        PV1530  = V1530.

        /* Without Condition Exit Cycle Start */ 
        LEAVE V1150LMAINLOOP.
        /* Without Condition Exit Cycle END */ 
        /* Internal Cycle END :1130    */
     END.
     pause 0 before-hide.

     /* Internal Cycle Input :1131    */
     V1181LMAINLOOP:
     REPEAT:

	   /*Logical Enter Cycle1131    */
           IF NOT (V1530 = "21" OR V1100 = "21" ) THEN LEAVE V1181LMAINLOOP.

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

              V1181 = " ".
              V1181 = ENTRY(1,V1181,"@").
              /* --CYCLE TIME DEFAULT  VALUE -- END  */

              /* LOGICAL SKIP START */
              V1530 = "".
              
	      /* run program 看板刷读库存转移-41 */
              RUN mhjit035.p.
	      leave V1181L.

	      /* LOGICAL SKIP END */
                display dmdesc format "x(40)" skip with fram F1181 no-box.

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

                /* LABEL 4 - START */ 
                  L11814 = "" . 
                display L11814          format "x(40)" skip with fram F1181 no-box.

                /* LABEL 3 - START */ 
                  L11815 = "" . 
                display L11815          format "x(40)" skip with fram F1181 no-box.
                /* LABEL 3 - START */ 
                  L11816 = "" . 
                display L11816          format "x(40)" skip with fram F1181 no-box.

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
              IF V1181 = "e" THEN  LEAVE V1181L.
              /* **SKIP TO MAIN LOOP END** */
              /* **LOAD MENU START** */
              IF V1181 = "$LOADMENU" THEN  RUN LOADMENU.
              /* **LOAD MENU END ** */
              display skip WMESSAGE NO-LABEL with fram F1181.

              /*  ---- Valid Check ---- START */

              display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1181.
              pause 0.

              display  "" @ WMESSAGE NO-LABEL with fram F1181.
              pause 0.
              leave V1181L.
           END.
           PV1181 = V1181.

           /* Without Condition Exit Cycle Start */ 
           LEAVE V1181LMAINLOOP.
           /* Without Condition Exit Cycle END */ 
        END.
        pause 0 before-hide.

     /* Internal Cycle Input :1131    */
     V1191LMAINLOOP:
     REPEAT:
	   /*Logical Enter Cycle1131    */
	   IF NOT (V1530 = "22" and V1100 = "2") THEN LEAVE V1191LMAINLOOP.

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

              V1191 = " ".
              V1191 = ENTRY(1,V1191,"@").
              /* --CYCLE TIME DEFAULT  VALUE -- END  */

              /* LOGICAL SKIP START */
              V1430 = "".
              RUN mhjit036.p.
	      leave V1191L.

	      /* LOGICAL SKIP END */
                display dmdesc format "x(40)" skip with fram F1191 no-box.

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

                /* LABEL 4 - START */ 
                  L11914 = "" . 
                display L11914          format "x(40)" skip with fram F1191 no-box.

                /* LABEL 3 - START */ 
                  L11915 = "" . 
                display L11915          format "x(40)" skip with fram F1191 no-box.
                /* LABEL 3 - START */ 
                  L11916 = "" . 
                display L11916          format "x(40)" skip with fram F1191 no-box.

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
              IF V1191 = "e" THEN  LEAVE V1191L.
              /* **SKIP TO MAIN LOOP END** */
              /* **LOAD MENU START** */
              IF V1191 = "$LOADMENU" THEN  RUN LOADMENU.
              /* **LOAD MENU END ** */
              display skip WMESSAGE NO-LABEL with fram F1191.

              /*  ---- Valid Check ---- START */

              display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1191.
              pause 0.

              display  "" @ WMESSAGE NO-LABEL with fram F1191.
              pause 0.
              leave V1191L.
           END.
           PV1191 = V1191.

           /* Without Condition Exit Cycle Start */ 
           LEAVE V1191LMAINLOOP.
           /* Without Condition Exit Cycle END */ 
           /* Internal Cycle END :1131    */
        END.
        pause 0 before-hide.

     /* Internal Cycle Input :1131    */
     V1101LMAINLOOP:
     REPEAT:
           /*Logical Enter Cycle1131    */
           IF NOT (V1530 = "23" OR V1100 = "23" ) THEN LEAVE V1101LMAINLOOP.

           V1101L:
           REPEAT:
              /* --DEFINE VARIABLE -- START */
              hide all.
              define variable V1101           as char format "x(50)".
              define variable PV1101          as char format "x(50)".
              define variable L11011          as char format "x(40)".
              define variable L11012          as char format "x(40)".
              define variable L11013          as char format "x(40)".
              define variable L11014          as char format "x(40)".
              define variable L11015          as char format "x(40)".
              define variable L11016          as char format "x(40)".

              V1101 = " ".
              V1101 = ENTRY(1,V1101,"@").
              /* --CYCLE TIME DEFAULT  VALUE -- END  */

              /* LOGICAL SKIP START */
              V1530 = "".

              RUN mhjit038.p.
              leave V1101L.

	      /* LOGICAL SKIP END */
                display dmdesc format "x(40)" skip with fram F1101 no-box.

		/* LABEL 1 - START */ 
                  L11011 = "" . 
                display L11011          format "x(40)" skip with fram F1101 no-box.
                /* LABEL 1 - END */ 

                /* LABEL 2 - START */ 
                  L11012 = "" . 
                display L11012          format "x(40)" skip with fram F1101 no-box.
                /* LABEL 2 - END */ 

                /* LABEL 3 - START */ 
                  L11013 = "" . 
                display L11013          format "x(40)" skip with fram F1101 no-box.

                /* LABEL 4 - START */ 
                  L11014 = "" . 
                display L11014          format "x(40)" skip with fram F1101 no-box.

                /* LABEL 3 - START */ 
                  L11015 = "" . 
                display L11015          format "x(40)" skip with fram F1101 no-box.
                /* LABEL 3 - START */ 
                  L11016 = "" . 
                display L11016          format "x(40)" skip with fram F1101 no-box.

              Update V1101
              WITH  fram F1101 NO-LABEL
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
              IF V1101 = "e" THEN  LEAVE V1101L.
              /* **SKIP TO MAIN LOOP END** */
              /* **LOAD MENU START** */
              IF V1101 = "$LOADMENU" THEN  RUN LOADMENU.
              /* **LOAD MENU END ** */
              display skip WMESSAGE NO-LABEL with fram F1101.

              /*  ---- Valid Check ---- START */

              display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1101.
              pause 0.

              display  "" @ WMESSAGE NO-LABEL with fram F1101.
              pause 0.
              leave V1101L.
           END.
           PV1101 = V1101.


           /* Without Condition Exit Cycle Start */ 
           LEAVE V1101LMAINLOOP.
           /* Without Condition Exit Cycle END */ 
           /* Internal Cycle END :1131    */
        END.
        pause 0 before-hide.


     /* Internal Cycle Input :1131    */
     V1102LMAINLOOP:
     REPEAT:
           /*Logical Enter Cycle1131    */
           IF NOT (V1530 = "24" OR V1100 = "24" ) THEN LEAVE V1102LMAINLOOP.

           V1102L:
           REPEAT:
              /* --DEFINE VARIABLE -- START */
              hide all.
              define variable V1102           as char format "x(50)".
              define variable PV1102          as char format "x(50)".
              define variable L11021          as char format "x(40)".
              define variable L11022          as char format "x(40)".
              define variable L11023          as char format "x(40)".
              define variable L11024          as char format "x(40)".
              define variable L11025          as char format "x(40)".
              define variable L11026          as char format "x(40)".

              V1102 = " ".
              V1102 = ENTRY(1,V1102,"@").
              /* --CYCLE TIME DEFAULT  VALUE -- END  */

              /* LOGICAL SKIP START */
              V1530 = "".

              RUN mhjit047.p.
              leave V1102L.

	      /* LOGICAL SKIP END */
                display dmdesc format "x(40)" skip with fram F1102 no-box.

		/* LABEL 1 - START */ 
                  L11021 = "" . 
                display L11021          format "x(40)" skip with fram F1102 no-box.
                /* LABEL 1 - END */ 

                /* LABEL 2 - START */ 
                  L11022 = "" . 
                display L11022          format "x(40)" skip with fram F1102 no-box.
                /* LABEL 2 - END */ 

                /* LABEL 3 - START */ 
                  L11023 = "" . 
                display L11023          format "x(40)" skip with fram F1102 no-box.

                /* LABEL 4 - START */ 
                  L11024 = "" . 
                display L11024          format "x(40)" skip with fram F1102 no-box.

                /* LABEL 3 - START */ 
                  L11025 = "" . 
                display L11025          format "x(40)" skip with fram F1102 no-box.
                /* LABEL 3 - START */ 
                  L11026 = "" . 
                display L11026          format "x(40)" skip with fram F1102 no-box.

              Update V1102
              WITH  fram F1102 NO-LABEL
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
              IF V1102 = "e" THEN  LEAVE V1102L.
              /* **SKIP TO MAIN LOOP END** */
              /* **LOAD MENU START** */
              IF V1102 = "$LOADMENU" THEN  RUN LOADMENU.
              /* **LOAD MENU END ** */
              display skip WMESSAGE NO-LABEL with fram F1102.

              /*  ---- Valid Check ---- START */

              display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1102.
              pause 0.

              display  "" @ WMESSAGE NO-LABEL with fram F1102.
              pause 0.
              leave V1102L.
           END.
           PV1102 = V1102.


           /* Without Condition Exit Cycle Start */ 
           LEAVE V1102LMAINLOOP.
           /* Without Condition Exit Cycle END */ 
           /* Internal Cycle END :1131    */
        END.
        pause 0 before-hide.

     /* Internal Cycle Input :1131    */
     V1103LMAINLOOP:
     REPEAT:
           /*Logical Enter Cycle1131    */
           IF NOT (V1530 = "25" OR V1100 = "25" ) THEN LEAVE V1103LMAINLOOP.

           V1103L:
           REPEAT:
              /* --DEFINE VARIABLE -- START */
              hide all.
              define variable V1103           as char format "x(50)".
              define variable PV1103          as char format "x(50)".
              define variable L11031          as char format "x(40)".
              define variable L11032          as char format "x(40)".
              define variable L11033          as char format "x(40)".
              define variable L11034          as char format "x(40)".
              define variable L11035          as char format "x(40)".
              define variable L11036          as char format "x(40)".

              V1103 = " ".
              V1103 = ENTRY(1,V1103,"@").
              /* --CYCLE TIME DEFAULT  VALUE -- END  */

              /* LOGICAL SKIP START */
              V1530 = "".

	      RUN mhjit050.p.

	      leave V1103L.

	      /* LOGICAL SKIP END */
                display dmdesc format "x(40)" skip with fram F1103 no-box.

		/* LABEL 1 - START */ 
                  L11031 = "" . 
                display L11031          format "x(40)" skip with fram F1103 no-box.
                /* LABEL 1 - END */ 

                /* LABEL 2 - START */ 
                  L11032 = "" . 
                display L11032          format "x(40)" skip with fram F1103 no-box.
                /* LABEL 2 - END */ 

                /* LABEL 3 - START */ 
                  L11033 = "" . 
                display L11033          format "x(40)" skip with fram F1103 no-box.

                /* LABEL 4 - START */ 
                  L11034 = "" . 
                display L11034          format "x(40)" skip with fram F1103 no-box.

                /* LABEL 3 - START */ 
                  L11035 = "" . 
                display L11035          format "x(40)" skip with fram F1103 no-box.
                /* LABEL 3 - START */ 
                  L11036 = "" . 
                display L11036          format "x(40)" skip with fram F1103 no-box.

              Update V1103
              WITH  fram F1103 NO-LABEL
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
              IF V1103 = "e" THEN  LEAVE V1103L.
              /* **SKIP TO MAIN LOOP END** */
              /* **LOAD MENU START** */
              IF V1103 = "$LOADMENU" THEN  RUN LOADMENU.
              /* **LOAD MENU END ** */
              display skip WMESSAGE NO-LABEL with fram F1103.

              /*  ---- Valid Check ---- START */

              display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1103.
              pause 0.

              display  "" @ WMESSAGE NO-LABEL with fram F1103.
              pause 0.
              leave V1103L.
           END.
           PV1103 = V1103.


           /* Without Condition Exit Cycle Start */ 
           LEAVE V1103LMAINLOOP.
           /* Without Condition Exit Cycle END */ 
           /* Internal Cycle END :1131    */
        END.
        pause 0 before-hide.

     /* Internal Cycle Input :1131    */
     V1104LMAINLOOP:
     REPEAT:
           /*Logical Enter Cycle1131    */
           IF NOT (V1530 = "26" OR V1100 = "26" ) THEN LEAVE V1104LMAINLOOP.

           V1104L:
           REPEAT:
              /* --DEFINE VARIABLE -- START */
              hide all.
              define variable V1104           as char format "x(50)".
              define variable PV1104          as char format "x(50)".
              define variable L11041          as char format "x(40)".
              define variable L11042          as char format "x(40)".
              define variable L11043          as char format "x(40)".
              define variable L11044          as char format "x(40)".
              define variable L11045          as char format "x(40)".
              define variable L11046          as char format "x(40)".

              V1530 = " ".
              V1530 = ENTRY(1,V1530,"@").
              /* --CYCLE TIME DEFAULT  VALUE -- END  */

              /* LOGICAL SKIP START */
              V1530 = "".
/*

	      RUN mhjit000.p.
*/
/*debug*/
              run mhjit0382.p.

	      leave V1104L.

	      /* LOGICAL SKIP END */
                display dmdesc format "x(40)" skip with fram F1104 no-box.

		/* LABEL 1 - START */ 
                  L11041 = "" . 
                display L11041          format "x(40)" skip with fram F1104 no-box.
                /* LABEL 1 - END */ 

                /* LABEL 2 - START */ 
                  L11042 = "" . 
                display L11042          format "x(40)" skip with fram F1104 no-box.
                /* LABEL 2 - END */ 

                /* LABEL 3 - START */ 
                  L11043 = "" . 
                display L11043          format "x(40)" skip with fram F1104 no-box.

                /* LABEL 4 - START */ 
                  L11044 = "" . 
                display L11044          format "x(40)" skip with fram F1104 no-box.

                /* LABEL 3 - START */ 
                  L11045 = "" . 
                display L11045          format "x(40)" skip with fram F1104 no-box.
                /* LABEL 3 - START */ 
                  L11046 = "" . 
                display L11046          format "x(40)" skip with fram F1104 no-box.

              Update V1104
              WITH  fram F1104 NO-LABEL
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
              IF V1104 = "e" THEN  LEAVE V1104L.
              /* **SKIP TO MAIN LOOP END** */
              /* **LOAD MENU START** */
              IF V1104 = "$LOADMENU" THEN  RUN LOADMENU.
              /* **LOAD MENU END ** */
              display skip WMESSAGE NO-LABEL with fram F1104.

              /*  ---- Valid Check ---- START */

              display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1104.
              pause 0.

              display  "" @ WMESSAGE NO-LABEL with fram F1104.
              pause 0.
              leave V1104L.
           END.
           PV1104 = V1104.


           /* Without Condition Exit Cycle Start */ 
           LEAVE V1104LMAINLOOP.
        END.
        pause 0 before-hide.

/*start debug*/
     /* Internal Cycle Input :1131    */
     V1105LMAINLOOP:
     REPEAT:
           /*Logical Enter Cycle1131    */
           IF NOT (V1530 = "27" OR V1100 = "27" ) THEN LEAVE V1105LMAINLOOP.

           V1105L:
           REPEAT:
              /* --DEFINE VARIABLE -- START */
              hide all.
              define variable V1105           as char format "x(50)".
              define variable PV1105          as char format "x(50)".
              define variable L11051          as char format "x(40)".
              define variable L11052          as char format "x(40)".
              define variable L11053          as char format "x(40)".
              define variable L11054          as char format "x(40)".
              define variable L11055          as char format "x(40)".
              define variable L11056          as char format "x(40)".

              V1530 = " ".
              V1530 = ENTRY(1,V1530,"@").
              /* --CYCLE TIME DEFAULT  VALUE -- END  */

              /* LOGICAL SKIP START */
              V1530 = "".
/*

	      RUN mhjit000.p.
*/
/*debug*/
              run mhjit0383.p.

	      leave V1105L.

	      /* LOGICAL SKIP END */
                display dmdesc format "x(40)" skip with fram F1106 no-box.

		/* LABEL 1 - START */ 
                  L11051 = "" . 
                display L11051          format "x(40)" skip with fram F1106 no-box.
                /* LABEL 1 - END */ 

                /* LABEL 2 - START */ 
                  L11052 = "" . 
                display L11052          format "x(40)" skip with fram F1106 no-box.
                /* LABEL 2 - END */ 

                /* LABEL 3 - START */ 
                  L11053 = "" . 
                display L11053          format "x(40)" skip with fram F1106 no-box.

                /* LABEL 4 - START */ 
                  L11054 = "" . 
                display L11054          format "x(40)" skip with fram F1106 no-box.

                /* LABEL 3 - START */ 
                  L11055 = "" . 
                display L11055          format "x(40)" skip with fram F1106 no-box.
                
		/* LABEL 3 - START */ 
                  L11056 = "" . 
                display L11056          format "x(40)" skip with fram F1106 no-box.


              Update V1105
              WITH  fram F1106 NO-LABEL
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
              IF V1105 = "e" THEN  LEAVE V1105L.
              /* **SKIP TO MAIN LOOP END** */
              /* **LOAD MENU START** */
              IF V1105 = "$LOADMENU" THEN  RUN LOADMENU.
              /* **LOAD MENU END ** */
              display skip WMESSAGE NO-LABEL with fram F1106.

              /*  ---- Valid Check ---- START */

              display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1106.
              pause 0.

              display  "" @ WMESSAGE NO-LABEL with fram F1106.
              pause 0.
              leave V1105L.
           END.
           PV1105 = V1105.

           /* Without Condition Exit Cycle Start */ 
           LEAVE V1105LMAINLOOP.
        END.
        pause 0 before-hide.

/*end */
     
     /* Internal Cycle Input :1130    */
     V1160LMAINLOOP:
     REPEAT:
        /*Logical Enter Cycle1130    */
        IF NOT (V1100 = "3" ) THEN LEAVE V1160LMAINLOOP.
     
        V1160L:
        REPEAT:

           /* --DEFINE VARIABLE -- START */
           hide all.
           define variable V1630           as char format "x(50)".
           define variable PV1630          as char format "x(50)".
           define variable L11601          as char format "x(40)".
           define variable L11602          as char format "x(40)".
           define variable L11603          as char format "x(40)".
           define variable L11604          as char format "x(40)".
           define variable L11605          as char format "x(40)".
           define variable L11606          as char format "x(40)".
           define variable L11607          as char format "x(40)".

           /* --CYCLE TIME DEFAULT  VALUE -- START  */
           V1630 = " ".
           V1630 = ENTRY(1,V1630,"@").

		display dmdesc format "x(40)" skip with fram F1105 no-box.

                /* LABEL 1 - START */ 
                L11601 = "看板货运单生成.....31" .
                display L11601          format "x(40)" skip with fram F1105 no-box.
                /* LABEL 1 - END */ 

                /* LABEL 2 - START */ 
                L11602 = "看板刷读数量清零...32" .
                display L11602          format "x(40)" skip with fram F1105 no-box.
                /* LABEL 2 - END */ 

                L11603 = ".....下有SO控制...." .
                display L11603          format "x(40)" skip with fram F1105 no-box.

                L11604 = "看板货运单生成-SO..33" .
                display L11604          format "x(40)" skip with fram F1105 no-box.

		L11605 = "  " .
                display L11605          format "x(40)" skip with fram F1105 no-box.

		L11606 = "  " .
                display L11606          format "x(40)" skip with fram F1105 no-box.

		L11607 = " " .
                display L11607          format "x(40)" skip with fram F1105 no-box.


           Update V1630
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

           IF V1630 = "e" THEN  LEAVE V1160L.
/*
	   if V1630 = "31" and lookup("xskbshpnbr.p", prog) = 0 then do:
	      display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1105.
              pause 0 before-hide.
              undo, retry.		        
	   end.
*/
	   /* **CHANGE DEFAULT SITE END ** */
           display skip WMESSAGE NO-LABEL with fram F1105.

           /*  ---- Valid Check ---- START */

           display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1105.
           pause 0.

           display  "" @ WMESSAGE NO-LABEL with fram F1105.
           pause 0.
           leave V1160L.
        END.
        PV1630  = V1630.

        /* Without Condition Exit Cycle Start */ 
        LEAVE V1160LMAINLOOP.
        /* Without Condition Exit Cycle END */ 
        /* Internal Cycle END :1130    */
     END.
     pause 0 before-hide.

     /* Internal Cycle Input :1131    */
     V1201LMAINLOOP:
     REPEAT:

	   /*Logical Enter Cycle1131    */
           IF NOT (V1630 = "31" OR V1100 = "31" ) THEN LEAVE V1201LMAINLOOP.

           V1201L:
           REPEAT:
              /* --DEFINE VARIABLE -- START */
              hide all.
              define variable V1201           as char format "x(50)".
              define variable PV1201          as char format "x(50)".
              define variable L11201          as char format "x(40)".
              define variable L11202          as char format "x(40)".
              define variable L11203          as char format "x(40)".
              define variable L11204          as char format "x(40)".
              define variable L11205          as char format "x(40)".
              define variable L11206          as char format "x(40)".
              define variable L11207          as char format "x(40)".

              V1201 = " ".
              V1201 = ENTRY(1,V1201,"@").

	      V1630 = "".
              
	      /* run program 看板刷读库存转移-41 */
              RUN xskbshpnbr.p.
	      leave V1201L.

	      /* LOGICAL SKIP END */
                display dmdesc format "x(40)" skip with fram F1201 no-box.

		/* LABEL 1 - START */ 
                  L11201 = "" . 
                display L11201          format "x(40)" skip with fram F1201 no-box.
                /* LABEL 1 - END */ 

                /* LABEL 2 - START */ 
                  L11202 = "" . 
                display L11202          format "x(40)" skip with fram F1201 no-box.
                /* LABEL 2 - END */ 

                /* LABEL 3 - START */ 
                  L11203 = "" . 
                display L11203          format "x(40)" skip with fram F1201 no-box.

                /* LABEL 4 - START */ 
                  L11204 = "" . 
                display L11204          format "x(40)" skip with fram F1201 no-box.

                /* LABEL 3 - START */ 
                  L11205 = "" . 
                display L11205          format "x(40)" skip with fram F1201 no-box.
                /* LABEL 3 - START */ 
                  
		  L11206 = "" . 
                display L11206          format "x(40)" skip with fram F1201 no-box.

		  L11207 = "" . 
                display L11207          format "x(40)" skip with fram F1201 no-box.

              Update V1201
              WITH  fram F1201 NO-LABEL
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
              IF V1201 = "e" THEN  LEAVE V1201L.

	      display skip WMESSAGE NO-LABEL with fram F1201.

              /*  ---- Valid Check ---- START */

              display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1201.
              pause 0.

              display  "" @ WMESSAGE NO-LABEL with fram F1201.
              pause 0.
              leave V1201L.
           END.
           PV1201 = V1201.

           /* Without Condition Exit Cycle Start */ 
           LEAVE V1201LMAINLOOP.
           /* Without Condition Exit Cycle END */ 
        END.
        pause 0 before-hide.


     /* Internal Cycle Input :1131    */
     V1301LMAINLOOP:
     REPEAT:

	   /*Logical Enter Cycle1131    */
           IF NOT (V1630 = "32" OR V1100 = "32" ) THEN LEAVE V1301LMAINLOOP.

           V1301L:
           REPEAT:
              /* --DEFINE VARIABLE -- START */
              hide all.
              define variable V1301           as char format "x(50)".
              define variable PV1301          as char format "x(50)".
              define variable L11301          as char format "x(40)".
              define variable L11302          as char format "x(40)".
              define variable L11303          as char format "x(40)".
              define variable L11304          as char format "x(40)".
              define variable L11305          as char format "x(40)".
              define variable L11306          as char format "x(40)".
              define variable L11307          as char format "x(40)".

              V1301 = " ".
              V1301 = ENTRY(1,V1301,"@").

	      V1630 = "".
              
	      /* run program 看板刷读库存转移-41 */
     	      RUN mhjit000.p.

	      leave V1301L.

	      /* LOGICAL SKIP END */
                display dmdesc format "x(40)" skip with fram F1301 no-box.

		/* LABEL 1 - START */ 
                  L11301 = "" . 
                display L11301          format "x(40)" skip with fram F1301 no-box.
                /* LABEL 1 - END */ 

                /* LABEL 2 - START */ 
                  L11302 = "" . 
                display L11302          format "x(40)" skip with fram F1301 no-box.
                /* LABEL 2 - END */ 

                /* LABEL 3 - START */ 
                  L11303 = "" . 
                display L11303          format "x(40)" skip with fram F1301 no-box.

                /* LABEL 4 - START */ 
                  L11304 = "" . 
                display L11304          format "x(40)" skip with fram F1301 no-box.

                /* LABEL 3 - START */ 
                  L11305 = "" . 
                display L11305          format "x(40)" skip with fram F1301 no-box.
                /* LABEL 3 - START */ 
                  
		  L11306 = "" . 
                display L11306          format "x(40)" skip with fram F1301 no-box.

		  L11307 = "" . 
                display L11307          format "x(40)" skip with fram F1301 no-box.

              Update V1301
              WITH  fram F1301 NO-LABEL
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
              IF V1301 = "e" THEN  LEAVE V1301L.

	      display skip WMESSAGE NO-LABEL with fram F1301.

              /*  ---- Valid Check ---- START */

              display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1301.
              pause 0.

              display  "" @ WMESSAGE NO-LABEL with fram F1301.
              pause 0.
              leave V1301L.
           END.
           PV1301 = V1301.

           /* Without Condition Exit Cycle Start */ 
           LEAVE V1301LMAINLOOP.
           /* Without Condition Exit Cycle END */ 
        END.
        pause 0 before-hide.

     /* Internal Cycle Input :1131    */
     V1401LMAINLOOP:
     REPEAT:

	   /*Logical Enter Cycle1131    */
           IF NOT (V1630 = "33" OR V1100 = "33" ) THEN LEAVE V1401LMAINLOOP.

           V1401L:
           REPEAT:
              /* --DEFINE VARIABLE -- START */
              hide all.
              define variable V1701           as char format "x(50)".
              define variable PV1701          as char format "x(50)".
              define variable L11701          as char format "x(40)".
              define variable L11702          as char format "x(40)".
              define variable L11703          as char format "x(40)".
              define variable L11704          as char format "x(40)".
              define variable L11705          as char format "x(40)".
              define variable L11706          as char format "x(40)".
              define variable L11707          as char format "x(40)".

              V1701 = " ".
              V1701 = ENTRY(1,V1701,"@").

	      V1630 = "".
              
     	      RUN xskbshpnbr_so.p.

	      leave V1401L.

	      /* LOGICAL SKIP END */
                display dmdesc format "x(40)" skip with fram F1701 no-box.

		/* LABEL 1 - START */ 
                  L11701 = "" . 
                display L11701          format "x(40)" skip with fram F1701 no-box.
                /* LABEL 1 - END */ 

                /* LABEL 2 - START */ 
                  L11702 = "" . 
                display L11702          format "x(40)" skip with fram F1701 no-box.
                /* LABEL 2 - END */ 

                /* LABEL 3 - START */ 
                  L11703 = "" . 
                display L11703          format "x(40)" skip with fram F1701 no-box.

                /* LABEL 4 - START */ 
                  L11704 = "" . 
                display L11704          format "x(40)" skip with fram F1701 no-box.

                /* LABEL 3 - START */ 
                  L11705 = "" . 
                display L11705          format "x(40)" skip with fram F1701 no-box.
                /* LABEL 3 - START */ 
                  
		  L11706 = "" . 
                display L11706          format "x(40)" skip with fram F1701 no-box.

		  L11707 = "" . 
                display L11707          format "x(40)" skip with fram F1701 no-box.

              Update V1701
              WITH  fram F1701 NO-LABEL
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
              IF V1701 = "e" THEN  LEAVE V1401L.

	      display skip WMESSAGE NO-LABEL with fram F1701.

              /*  ---- Valid Check ---- START */

              display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1701.
              pause 0.

              display  "" @ WMESSAGE NO-LABEL with fram F1701.
              pause 0.
              leave V1401L.
           END.
           PV1701 = V1701.

           /* Without Condition Exit Cycle Start */ 
           LEAVE V1401LMAINLOOP.
           /* Without Condition Exit Cycle END */ 
        END.
        pause 0 before-hide.
     end.
