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
   /**** start user ****
   if j = 0 then do:
      VUSER:
      REPEAT:
         hide all.
         define variable luser         as char format "x(40)".
         define variable puser        as char format "x(40)".
         define variable lpwd         as char format "x(40)".
         define variable ppwd        as char format "x(40)".
        
	 display dmdesc format "x(40)" skip with fram user1 no-box.

	 luser = "用户 ?" .
         display luser         format "x(40)" skip with fram user1 no-box.
/*
         lpwd = "密码 ?" .
         display lpwd         format "x(40)" skip with fram user1 no-box.
*/
       	 display "输入或按E退出"       format "x(40)" skip
                skip with fram user1 no-box.

	 Update puser skip
/*	        ppwd blank  */
         WITH  fram user1 NO-LABEL.

	 /* PRESS e EXIST CYCLE */
         IF trim(puser) = "e" THEN LEAVE MAINLOOP.
	
         display  skip WMESSAGE NO-LABEL with fram user1.

	 find first xusr_mstr where xusr_domain = global_domain AND xusr_usr = puser no-lock no-error.
         IF NOT AVAILABLE xusr_mstr then do:
            display skip "错误:用户不存在." @ WMESSAGE NO-LABEL with fram user1.
	    next-prompt puser with fram user1.
            pause 0 before-hide.
            undo, retry.
         end.
	 else do:
/*	    
	    if ppwd <> xusr_pwd then do:
               display skip "错误:密码错误." @ WMESSAGE NO-LABEL with fram user1.
   	       next-prompt ppwd with fram user1.
               pause 0 before-hide.
               undo, retry.
	    end.
*/
	    prog = xusr_prog.
	 end.
	 suser = puser.
         display  "" @ WMESSAGE NO-LABEL with fram user1.
         pause 0.
         leave VUSER.
      end.
   end.
   j = j + 1.
   *** end user *****/
     
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
                L11003 = "看板采购刷读...3" .
                display L11003          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 4 - START */ 
                L11004 = "看板刷读转移...4" .
                display L11004          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 2 - END */ 


                /* LABEL 5 - START */ 
                L11005 = "FG有条码转仓/出货..5" .
                display L11005          format "x(40)" skip with fram F1100 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 6 - START */ 
                L11006= "FG无条码转仓/出货..6" .
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
/*debug	
        if V1100 = "11" and lookup("xsictr01.p", prog) = 0 then do:
	   display "错误:你没权限使用该程式"  @ WMESSAGE NO-LABEL with fram F1100.
           pause 0 before-hide.
           undo, retry.		        
	end.

	if V1100 = "12" and lookup("xsictr02.p", prog) = 0 then do:
	   display "错误:你没权限使用该程式"  @ WMESSAGE NO-LABEL with fram F1100.
           pause 0 before-hide.
           undo, retry.		        
	end.
	
        if V1100 = "21" and lookup("xsship01.p", prog) = 0 then do:
	   display "错误:你没权限使用该程式"  @  WMESSAGE NO-LABEL with fram F1100.
           pause 0 before-hide.
           undo, retry.		        
	end.

	if V1100 = "22" and lookup("xsship02.p", prog) = 0 then do:
	    display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1100.
            pause 0 before-hide.
            undo, retry.		        
	end.
	
	if V1100 = "31" and lookup("xxkbporc.p", prog) = 0 then do:
	   display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1100.
           pause 0 before-hide.
           undo, retry.		        
	end.

	if V1100 = "32" and lookup("xxkbport.p", prog) = 0 then do:
	   display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1100.
           pause 0 before-hide.
           undo, retry.		        
	end.

        if V1100 = "41" and lookup("mhjit035.p", prog) = 0 then do:
	   display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1100.
           pause 0 before-hide.
           undo, retry.		        
	end.

        if V1100 = "42" and lookup("mhjit036.p", prog) = 0 then do:
	   display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1100.
           pause 0 before-hide.
           undo, retry.		        
	end.

	if V1100 = "43" and lookup("mhjit038.p", prog) = 0 then do:
	   display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1100.
           pause 0 before-hide.
           undo, retry.		        
	end.

	if V1100 = "44" and lookup("mhjit047.p", prog) = 0 then do:
	   display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1100.
           pause 0 before-hide.
           undo, retry.		        
	end.

	if V1100 = "45" and lookup("mhjit000.p", prog) = 0 then do:
	   display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1100.
           pause 0 before-hide.
           undo, retry.		        
	end.

	if V1100 = "51" and lookup("mhjit050_a.p", prog) = 0 then do:
	   display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1100.
           pause 0 before-hide.
           undo, retry.		        
	end.

	if V1100 = "52" and lookup("mhjit050_b.p", prog) = 0 then do:
	   display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1100.
           pause 0 before-hide.
           undo, retry.		        
	end.

        if V1100 = "53" and lookup("xsship01.p", prog) = 0 then do:
	   display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1100.
           pause 0 before-hide.
           undo, retry.		        
	end.

	if V1100 = "54" and lookup("xskbshpnbr_a.p", prog) = 0 then do:
	   display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1100.
           pause 0 before-hide.
           undo, retry.		        
	end.
debug*/

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
/*debug
	   if V1110 = "11" and lookup("xsictr01.p", prog) = 0 then do:
	      display "错误:你没权限使用该程式"  @ WMESSAGE NO-LABEL with fram F1110.
              pause 0 before-hide.
              undo, retry.		        
	   end.

	   if V1110 = "12" and lookup("xsictr02.p", prog) = 0 then do:
	      display "错误:你没权限使用该程式"  @ WMESSAGE NO-LABEL with fram F1110.
              pause 0 before-hide.
              undo, retry.		        
	   end.
debug*/
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
                L11302 = "其它:货物发其它......22" .
                display L11302          format "x(40)" skip with fram F1130 no-box.
                /* LABEL 2 - END */ 

                L11303 = "......下有SO控制......" .
                display L11303          format "x(40)" skip with fram F1130 no-box.

                L11304 = "福特:货物发福特-SO ..23" .
                display L11304          format "x(40)" skip with fram F1130 no-box.

                L11305 = "其它:货物发其它-SO...24" .
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

	   /* **SKIP TO MAIN LOOP END** */
/*debug
	   if V1130 = "21" and lookup("xsship01.p", prog) = 0 then do:
	      display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1130.
              pause 0 before-hide.
              undo, retry.		        
	   end.

	   if V1130 = "22" and lookup("xsship02.p", prog) = 0 then do:
	      display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1130.
              pause 0 before-hide.
              undo, retry.		        
	   end.
debug*/
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

     /* Internal Cycle Input :1131    */
     V1133LMAINLOOP:
     REPEAT:
           /*Logical Enter Cycle1131    */
           IF NOT (V1130 = "23" OR V1100 = "23" ) THEN LEAVE V1133LMAINLOOP.
           /* START  LINE :1131  1.3.1 福特货物发货  */
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

	      V1133 = " ".
              V1133 = ENTRY(1,V1133,"@").
              V1130 = "".

              RUN CheckSecurity (INPUT "xsship01_so.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
              IF OkToRun = yes then RUN xsship01_so.p.

              leave V1133L.

	      /* LOGICAL SKIP END */
                display dmdesc format "x(40)" skip with fram F1133 no-box.

                  L11331 = "" . 
                display L11331          format "x(40)" skip with fram F1133 no-box.

		  L11332 = "" . 
                display L11332          format "x(40)" skip with fram F1133 no-box.
                /* LABEL 2 - END */ 

                /* LABEL 3 - START */ 
                  L11333 = "" . 
                display L11333          format "x(40)" skip with fram F1133 no-box.

                /* LABEL 4 - START */ 
                  L11334 = "" . 
                display L11334          format "x(40)" skip with fram F1133 no-box.

                  L11335 = "" . 
                display L11335          format "x(40)" skip with fram F1133 no-box.

		/* LABEL 3 - START */ 
                  L11336 = "" . 
                display L11336          format "x(40)" skip with fram F1133 no-box.

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
              IF V1133 = "e" THEN  LEAVE V1133L.
              /* **SKIP TO MAIN LOOP END** */
              /* **LOAD MENU START** */
              IF V1133 = "$LOADMENU" THEN  RUN LOADMENU.
              /* **LOAD MENU END ** */
              /* **CHANGE Default Site END ** */
/*tommy       IF V1131 = "S" THEN  RUN xsmdf01.p. */
              /* **CHANGE DEFAULT SITE END ** */
              display skip WMESSAGE NO-LABEL with fram F1133.

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
           /* END    LINE :1131  1.3.1 工单发正常料  */


           /* Without Condition Exit Cycle Start */ 
           LEAVE V1133LMAINLOOP.
           /* Without Condition Exit Cycle END */ 
           /* Internal Cycle END :1131    */
        END.
        pause 0 before-hide.

        /* Internal Cycle Input :1132    */
        V1134LMAINLOOP:
        REPEAT:
           /*Logical Enter Cycle1132    */
           IF NOT (V1130 = "24" OR V1100 = "24" ) THEN LEAVE V1134LMAINLOOP.
           /* START  LINE :1132  1.3.2 内部货物发货  */
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

              /* --CYCLE TIME DEFAULT  VALUE -- START  */
              V1134 = " ".
              V1134 = ENTRY(1,V1134,"@").
              /* --CYCLE TIME DEFAULT  VALUE -- END  */

              /* LOGICAL SKIP START */
              V1130 = "".
	      
              RUN CheckSecurity (INPUT "xsship02_so.p" , INPUT global_userid , OUTPUT okToRun , OUTPUT Execname ).
              IF OkToRun = yes THEN RUN xsship02_so.p.
              leave V1134L.

	      /* LOGICAL SKIP END */
                display dmdesc format "x(40)" skip with fram F1134 no-box.

                /* LABEL 1 - START */ 
                  L11341 = "" . 
                display L11341          format "x(40)" skip with fram F1134 no-box.
                /* LABEL 1 - END */ 


                /* LABEL 2 - START */ 
                  L11342 = "" . 
                display L11342          format "x(40)" skip with fram F1134 no-box.
                /* LABEL 2 - END */ 

                /* LABEL 3 - START */ 
                  L11323 = "" . 
                display L11343          format "x(40)" skip with fram F1134 no-box.
                /* LABEL 4 - START */ 
                  L11324 = "" . 
                display L11344          format "x(40)" skip with fram F1134 no-box.
                /* LABEL 5 - START */ 
                  L11345 = "" . 	      
		display L11345          format "x(40)" skip with fram F1134 no-box.

                /* LABEL 6 - START */ 
                  L11346 = "" . 
                display L11346          format "x(40)" skip with fram F1134 no-box.


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
              IF V1134 = "e" THEN  LEAVE V1134L.
              /* **SKIP TO MAIN LOOP END** */
              /* **LOAD MENU START** */
              IF V1134 = "$LOADMENU" THEN  RUN LOADMENU.
              /* **LOAD MENU END ** */
              /* **CHANGE Default Site END ** */
/*tommy       IF V1132 = "S" THEN  RUN xsmdf01.p.
*/
              /* **CHANGE DEFAULT SITE END ** */
              display skip WMESSAGE NO-LABEL with fram F1134.

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

	   /* Without Condition Exit Cycle Start */ 
           LEAVE V1134LMAINLOOP.
           /* Without Condition Exit Cycle END */ 
           /* Internal Cycle END :1132    */
        END.
        pause 0 before-hide.
	   
	
     /* Internal Cycle Input :1130    */
     V1140LMAINLOOP:
     REPEAT:
        /*Logical Enter Cycle1130    */
        IF NOT (V1100 = "3" ) THEN LEAVE V1140LMAINLOOP.
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
           /* --CYCLE TIME DEFAULT  VALUE -- END  */

           /* LOGICAL SKIP START */
           /* LOGICAL SKIP END */
                display dmdesc format "x(40)" skip with fram F1430 no-box.

                /* LABEL 1 - START */ 
                L11401 = "PO看板刷读收货....31" .
                display L11401          format "x(40)" skip with fram F1430 no-box.
                /* LABEL 1 - END */ 

                /* LABEL 2 - START */ 
                L11402 = "PO看板刷读退货....32" .
                display L11402          format "x(40)" skip with fram F1430 no-box.
                /* LABEL 2 - END */ 

                L11403 = " " .
                display L11403          format "x(40)" skip with fram F1430 no-box.

                L11404 = " " .
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
/*debug
	   if V1430 = "31" and lookup("xxkbporc.p", prog) = 0 then do:
	      display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1430.
              pause 0 before-hide.
              undo, retry.		        
	   end.

	   if V1430 = "32" and lookup("xxkbport.p", prog) = 0 then do:
	      display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1430.
              pause 0 before-hide.
              undo, retry.		        
	   end.
debug*/
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
           IF NOT (V1430 = "31" or V1100 = "31") THEN LEAVE V1141LMAINLOOP.

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
           IF NOT (V1430 = "32" or V1100 = "32") THEN LEAVE V1151LMAINLOOP.

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
        IF NOT (V1100 = "4" ) THEN LEAVE V1150LMAINLOOP.
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
                L11501 = "看板刷读库存转移..41" .
                display L11501          format "x(40)" skip with fram F1530 no-box.
                /* LABEL 1 - END */ 

                /* LABEL 2 - START */ 
                L11502 = "看板刷读看板转移..42" .
                display L11502          format "x(40)" skip with fram F1530 no-box.
                /* LABEL 2 - END */ 

                L11503 = "领料看板刷读领料..43" .
                display L11503          format "x(40)" skip with fram F1530 no-box.

                L11504 = "看板刷读生产退料..44" .
                display L11504          format "x(40)" skip with fram F1530 no-box.


		L11505 = "有领料无采购看板..45 " .
                display L11505          format "x(40)" skip with fram F1530 no-box.

		L11506 = "有采购无领料看板..46" .
                display L11506          format "x(40)" skip with fram F1530 no-box.

		L11507 = "看板刷读数量清零..47" .
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
/*debug
	   if V1530 = "41" and lookup("mhjit035.p", prog) = 0 then do:
	      display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1530.
              pause 0 before-hide.
              undo, retry.		        
	   end.

	   if V1530 = "42" and lookup("mhjit036.p", prog) = 0 then do:
	      display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1530.
              pause 0 before-hide.
              undo, retry.		        
	   end.

	   if V1530 = "43" and lookup("mhjit038.p", prog) = 0 then do:
	      display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1530.
              pause 0 before-hide.
              undo, retry.		        
	   end.

	   if V1530 = "44" and lookup("mhjit047.p", prog) = 0 then do:
	      display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1530.
              pause 0 before-hide.
              undo, retry.		        
	   end.

	   if V1530 = "45" and lookup("mhjit000.p", prog) = 0 then do:
	      display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1530.
              pause 0 before-hide.
              undo, retry.		        
	   end.
debug*/
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
           IF NOT (V1530 = "41" OR V1100 = "41" ) THEN LEAVE V1181LMAINLOOP.

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
           IF NOT (V1530 = "42" OR V1100 = "42") THEN LEAVE V1191LMAINLOOP.

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
              V1530 = "".

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
           IF NOT (V1530 = "43" OR V1100 = "43" ) THEN LEAVE V1101LMAINLOOP.

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
           IF NOT (V1530 = "44" OR V1100 = "44" ) THEN LEAVE V1102LMAINLOOP.

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
     V1105LMAINLOOP:
     REPEAT:
           /*Logical Enter Cycle1131    */
           IF NOT (V1530 = "45" OR V1100 = "45" ) THEN LEAVE V1105LMAINLOOP.

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

              V1502 = " ".
              V1502 = ENTRY(1,V1502,"@").
              /* --CYCLE TIME DEFAULT  VALUE -- END  */

              /* LOGICAL SKIP START */
              V1530 = "".

              RUN mhjit0382.p.
              leave V1502L.

	      /* LOGICAL SKIP END */
                display dmdesc format "x(40)" skip with fram F1502 no-box.

		/* LABEL 1 - START */ 
                  L15021 = "" . 
                display L15021          format "x(40)" skip with fram F1502 no-box.
                /* LABEL 1 - END */ 

                /* LABEL 2 - START */ 
                  L15022 = "" . 
                display L15022          format "x(40)" skip with fram F1502 no-box.
                /* LABEL 2 - END */ 

                /* LABEL 3 - START */ 
                  L15023 = "" . 
                display L15023          format "x(40)" skip with fram F1502 no-box.

                /* LABEL 4 - START */ 
                  L15024 = "" . 
                display L15024          format "x(40)" skip with fram F1502 no-box.

                /* LABEL 3 - START */ 
                  L15025 = "" . 
                display L15025          format "x(40)" skip with fram F1502 no-box.
                
		/* LABEL 3 - START */ 
                  L15026 = "" . 
                display L15026          format "x(40)" skip with fram F1502 no-box.

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

              /* PRESS e EXIST CYCLE */
              /* **SKIP TO MAIN LOOP START** */
              IF V1502 = "e" THEN  LEAVE V1502L.
              /* **SKIP TO MAIN LOOP END** */
              /* **LOAD MENU START** */
              IF V1502 = "$LOADMENU" THEN  RUN LOADMENU.
              /* **LOAD MENU END ** */
              display skip WMESSAGE NO-LABEL with fram F1502.

              /*  ---- Valid Check ---- START */

              display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1502.
              pause 0.

              display  "" @ WMESSAGE NO-LABEL with fram F1502.
              pause 0.
              leave V1502L.
           END.
           PV1502 = V1502.


           /* Without Condition Exit Cycle Start */ 
           LEAVE V1105LMAINLOOP.
           /* Without Condition Exit Cycle END */ 
           /* Internal Cycle END :1131    */
        END.
        pause 0 before-hide.



     /* Internal Cycle Input :1131    */
     V1106LMAINLOOP:
     REPEAT:
           /*Logical Enter Cycle1131    */
           IF NOT (V1530 = "46" OR V1100 = "46" ) THEN LEAVE V1106LMAINLOOP.

           V1503L:
           REPEAT:
              /* --DEFINE VARIABLE -- START */
              hide all.
              define variable V1602           as char format "x(50)".
              define variable PV1602          as char format "x(50)".
              define variable L16021          as char format "x(40)".
              define variable L16022          as char format "x(40)".
              define variable L16023          as char format "x(40)".
              define variable L16024          as char format "x(40)".
              define variable L16025          as char format "x(40)".
              define variable L16026          as char format "x(40)".

              V1602 = " ".
              V1602 = ENTRY(1,V1602,"@").
              /* --CYCLE TIME DEFAULT  VALUE -- END  */

              /* LOGICAL SKIP START */
              V1530 = "".

              RUN mhjit0383.p.
              leave V1503L.

	      /* LOGICAL SKIP END */
                display dmdesc format "x(40)" skip with fram F1602 no-box.

		/* LABEL 1 - START */ 
                  L16021 = "" . 
                display L16021          format "x(40)" skip with fram F1602 no-box.
                /* LABEL 1 - END */ 

                /* LABEL 2 - START */ 
                  L16022 = "" . 
                display L16022          format "x(40)" skip with fram F1602 no-box.
                /* LABEL 2 - END */ 

                /* LABEL 3 - START */ 
                  L16023 = "" . 
                display L16023          format "x(40)" skip with fram F1602 no-box.

                /* LABEL 4 - START */ 
                  L16024 = "" . 
                display L16024          format "x(40)" skip with fram F1602 no-box.

                /* LABEL 3 - START */ 
                  L16025 = "" . 
                display L16025          format "x(40)" skip with fram F1602 no-box.
                
		/* LABEL 3 - START */ 
                  L16026 = "" . 
                display L16026          format "x(40)" skip with fram F1602 no-box.

              Update V1602
              WITH  fram F1602 NO-LABEL
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
              IF V1602 = "e" THEN  LEAVE V1503L.
              /* **SKIP TO MAIN LOOP END** */

              /* **LOAD MENU START** */
              IF V1602 = "$LOADMENU" THEN  RUN LOADMENU.
              /* **LOAD MENU END ** */
              display skip WMESSAGE NO-LABEL with fram F1602.

              /*  ---- Valid Check ---- START */

              display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1602.
              pause 0.

              display  "" @ WMESSAGE NO-LABEL with fram F1602.
              pause 0.
              leave V1503L.
           END.
           PV1602 = V1602.

           /* Without Condition Exit Cycle Start */ 
           LEAVE V1106LMAINLOOP.
           /* Without Condition Exit Cycle END */ 
           /* Internal Cycle END :1131    */
        END.
        pause 0 before-hide.
     
     /* Internal Cycle Input :1131    */
     V1104LMAINLOOP:
     REPEAT:
           /*Logical Enter Cycle1131    */
           IF NOT (V1530 = "47" OR V1100 = "47" ) THEN LEAVE V1104LMAINLOOP.

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

              V1104 = " ".
              V1104 = ENTRY(1,V1104,"@").
              /* --CYCLE TIME DEFAULT  VALUE -- END  */

              /* LOGICAL SKIP START */
              V1530 = "".

	      RUN mhjit000.p.
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

     /* Internal Cycle Input :1130    */
     V1160LMAINLOOP:
     REPEAT:
        /*Logical Enter Cycle1130    */
        IF NOT (V1100 = "5" ) THEN LEAVE V1160LMAINLOOP.
        /* START  LINE :1130  3.看板菜单  */
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

	   display dmdesc format "x(40)" skip with fram F1630 no-box.
           
	   L11601 = "生产转仓入库-铭仕...51" .
           display L11601          format "x(40)" skip with fram F1630 no-box.

           L11602 = "生产转仓入库-非铭仕.52" .
           display L11602          format "x(40)" skip with fram F1630 no-box.

           L11603 = "货物发往--铭仕......53" .
           display L11603          format "x(40)" skip with fram F1630 no-box.

           L11604 = "货物发往--非铭仕....54" .
           display L11604          format "x(40)" skip with fram F1630 no-box.

           L11605 = ".....下有SO控制.......".
           display L11605          format "x(40)" skip with fram F1630 no-box.

	   L11606 = "货物发往--铭仕-SO...56".
           display L11606          format "x(40)" skip with fram F1630 no-box.

	   L11607 = "货物发往-非铭仕-SO..57 ".
           display L11607          format "x(40)" skip with fram F1630 no-box.

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

           IF V1630 = "e" THEN  LEAVE V1160L.
/*debug
	   if V1630 = "51" and lookup("mhjit050_a.p", prog) = 0 then do:
	      display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1630.
              pause 0 before-hide.
              undo, retry.		        
	   end.

	   if V1630 = "52" and lookup("mhjit050_b.p", prog) = 0 then do:
	      display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1630.
              pause 0 before-hide.
              undo, retry.		        
	   end.

           if V1630 = "53" and lookup("xsship01.p", prog) = 0 then do:
	      display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1630.
              pause 0 before-hide.
              undo, retry.		        
	   end.

	   if V1630 = "54" and lookup("xskbshpnbr_a.p", prog) = 0 then do:
	      display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1630.
              pause 0 before-hide.
              undo, retry.		        
	   end.
debug*/
	   /* **CHANGE DEFAULT SITE END ** */
           display skip WMESSAGE NO-LABEL with fram F1630.

           display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1630.
           pause 0.

           display  "" @ WMESSAGE NO-LABEL with fram F1630.
           pause 0.
           leave V1160L.
        END.
        PV1630  = V1630.

        LEAVE V1160LMAINLOOP.
     END.
     pause 0 before-hide.

     /* Internal Cycle Input :1131    */
     V1170LMAINLOOP:
     REPEAT:
           /*Logical Enter Cycle1131    */
           IF NOT (V1630 = "51" OR V1100 = "51" ) THEN LEAVE V1170LMAINLOOP.

           V1170L:
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

              V1105 = " ".
              V1105 = ENTRY(1,V1105,"@").
              /* --CYCLE TIME DEFAULT  VALUE -- END  */

              /* LOGICAL SKIP START */
              V1630 = "".

	      RUN mhjit050_a.p.

              leave V1170L.

              display dmdesc format "x(40)" skip with fram F1105 no-box.

              L11051 = "" . 
              display L11051          format "x(40)" skip with fram F1105 no-box.

              L11052 = "" . 
              display L11052          format "x(40)" skip with fram F1105 no-box.

              L11053 = "" . 
              display L11053          format "x(40)" skip with fram F1105 no-box.

              L11054 = "" . 
              display L11054          format "x(40)" skip with fram F1105 no-box.

              L11055 = "" . 
              display L11055          format "x(40)" skip with fram F1105 no-box.

              L11056 = "" . 
              display L11056          format "x(40)" skip with fram F1105 no-box.

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

              IF V1105 = "e" THEN  LEAVE V1170L.

              display skip WMESSAGE NO-LABEL with fram F1105.

              /*  ---- Valid Check ---- START */

              display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1105.
              pause 0.

              display  "" @ WMESSAGE NO-LABEL with fram F1105.
              pause 0.
              leave V1170L.
           END.
           PV1105 = V1105.


           /* Without Condition Exit Cycle Start */ 
           LEAVE V1170LMAINLOOP.
        END.
        pause 0 before-hide.

     /* Internal Cycle Input :1131    */
     V1180LMAINLOOP:
     REPEAT:
           /*Logical Enter Cycle1131    */
           IF NOT (V1630 = "52" OR V1100 = "52" ) THEN LEAVE V1180LMAINLOOP.

           V1180L:
           REPEAT:
              /* --DEFINE VARIABLE -- START */
              hide all.
              define variable V1106           as char format "x(50)".
              define variable PV1106          as char format "x(50)".
              define variable L11061          as char format "x(40)".
              define variable L11062          as char format "x(40)".
              define variable L11063          as char format "x(40)".
              define variable L11064          as char format "x(40)".
              define variable L11065          as char format "x(40)".
              define variable L11066          as char format "x(40)".

              V1106 = " ".
              V1106 = ENTRY(1,V1106,"@").

              V1630 = "".

	      RUN mhjit050_b.p.

              leave V1180L.

              display dmdesc format "x(40)" skip with fram F1106 no-box.

              L11061 = "" . 
              display L11061          format "x(40)" skip with fram F1106 no-box.

              L11062 = "" . 
              display L11062          format "x(40)" skip with fram F1106 no-box.

              L11063 = "" . 
              display L11063          format "x(40)" skip with fram F1106 no-box.

              L11064 = "" . 
              display L11064          format "x(40)" skip with fram F1106 no-box.

              L11065 = "" . 
              display L11065          format "x(40)" skip with fram F1106 no-box.

              L11066 = "" . 
              display L11066          format "x(40)" skip with fram F1106 no-box.

              Update V1106
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

              IF V1106 = "e" THEN  LEAVE V1180L.

              display skip WMESSAGE NO-LABEL with fram F1106.

              /*  ---- Valid Check ---- START */

              display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1106.
              pause 0.

              display  "" @ WMESSAGE NO-LABEL with fram F1106.
              pause 0.
              leave V1180L.
           END.
           PV1106 = V1106.


           /* Without Condition Exit Cycle Start */ 
           LEAVE V1180LMAINLOOP.
        END.
        pause 0 before-hide.

     /* Internal Cycle Input :1131    */
     V1190LMAINLOOP:
     REPEAT:
           /*Logical Enter Cycle1131    */
           IF NOT (V1630 = "53" OR V1100 = "53" ) THEN LEAVE V1190LMAINLOOP.

           V1190L:
           REPEAT:
              /* --DEFINE VARIABLE -- START */
              hide all.
              define variable V1107           as char format "x(50)".
              define variable PV1107          as char format "x(50)".
              define variable L11071          as char format "x(40)".
              define variable L11072          as char format "x(40)".
              define variable L11073          as char format "x(40)".
              define variable L11074          as char format "x(40)".
              define variable L11075          as char format "x(40)".
              define variable L11076          as char format "x(40)".

              V1107 = " ".
              V1107 = ENTRY(1,V1107,"@").

              V1630 = "".

	      RUN xsship53.p.

              leave V1190L.

              display dmdesc format "x(40)" skip with fram F1107 no-box.

              L11071 = "" . 
              display L11071          format "x(40)" skip with fram F1107 no-box.

              L11072 = "" . 
              display L11072          format "x(40)" skip with fram F1107 no-box.

              L11073 = "" . 
              display L11073          format "x(40)" skip with fram F1107 no-box.

              L11074 = "" . 
              display L11074          format "x(40)" skip with fram F1107 no-box.

              L11075 = "" . 
              display L11075          format "x(40)" skip with fram F1107 no-box.

              L11076 = "" . 
              display L11076          format "x(40)" skip with fram F1107 no-box.

              Update V1107
              WITH  fram F1107 NO-LABEL
              EDITING:
                 readkey pause wtimeout.
                 if lastkey = -1 Then quit.
                 if LASTKEY = 404 Then Do: /* DISABLE F4 */
                    pause 0 before-hide.
                    undo, retry.
                 end.
                 apply lastkey.
              end.

              IF V1107 = "e" THEN  LEAVE V1190L.

              display skip WMESSAGE NO-LABEL with fram F1107.

              /*  ---- Valid Check ---- START */

              display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1107.
              pause 0.

              display  "" @ WMESSAGE NO-LABEL with fram F1107.
              pause 0.
              leave V1190L.
           END.
           PV1107 = V1107.

           /* Without Condition Exit Cycle Start */ 
           LEAVE V1190LMAINLOOP.
        END.
        pause 0 before-hide.

     /* Internal Cycle Input :1131    */
     V1120LMAINLOOP:
     REPEAT:
           /*Logical Enter Cycle1131    */
           IF NOT (V1630 = "54" OR V1100 = "54" ) THEN LEAVE V1120LMAINLOOP.

           V1120L:
           REPEAT:
              /* --DEFINE VARIABLE -- START */
              hide all.
              define variable V1108           as char format "x(50)".
              define variable PV1108          as char format "x(50)".
              define variable L11081          as char format "x(40)".
              define variable L11082          as char format "x(40)".
              define variable L11083          as char format "x(40)".
              define variable L11084          as char format "x(40)".
              define variable L11085          as char format "x(40)".
              define variable L11086          as char format "x(40)".

              V1108 = " ".
              V1108 = ENTRY(1,V1108,"@").

              V1630 = "".

	      RUN xskbshpnbr_a.p.

              leave V1120L.

              display dmdesc format "x(40)" skip with fram F1108 no-box.

              L11081 = "" . 
              display L11081          format "x(40)" skip with fram F1108 no-box.

              L11082 = "" . 
              display L11082          format "x(40)" skip with fram F1108 no-box.

              L11083 = "" . 
              display L11083          format "x(40)" skip with fram F1108 no-box.

              L11084 = "" . 
              display L11084          format "x(40)" skip with fram F1108 no-box.

              L11085 = "" . 
              display L11085          format "x(40)" skip with fram F1108 no-box.

              L11086 = "" . 
              display L11086          format "x(40)" skip with fram F1108 no-box.

              Update V1108
              WITH  fram F1108 NO-LABEL
              EDITING:
                 readkey pause wtimeout.
                 if lastkey = -1 Then quit.
                 if LASTKEY = 404 Then Do: /* DISABLE F4 */
                    pause 0 before-hide.
                    undo, retry.
                 end.
                 apply lastkey.
              end.

              IF V1108 = "e" THEN  LEAVE V1120L.

              display skip WMESSAGE NO-LABEL with fram F1108.

              /*  ---- Valid Check ---- START */

              display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1108.
              pause 0.

              display  "" @ WMESSAGE NO-LABEL with fram F1108.
              pause 0.
              leave V1120L.
           END.
           PV1108 = V1108.

           /* Without Condition Exit Cycle Start */ 
           LEAVE V1120LMAINLOOP.
        END.
        pause 0 before-hide.

     /* Internal Cycle Input :1131    */
     V1124LMAINLOOP:
     REPEAT:
           /*Logical Enter Cycle1131    */
           IF NOT (V1630 = "56" OR V1100 = "56" ) THEN LEAVE V1124LMAINLOOP.

           V1124L:
           REPEAT:
              /* --DEFINE VARIABLE -- START */
              hide all.
              define variable V1208           as char format "x(50)".
              define variable PV1208          as char format "x(50)".
              define variable L12081          as char format "x(40)".
              define variable L12082          as char format "x(40)".
              define variable L12083          as char format "x(40)".
              define variable L12084          as char format "x(40)".
              define variable L12085          as char format "x(40)".
              define variable L12086          as char format "x(40)".

              V1208 = " ".
              V1208 = ENTRY(1,V1208,"@").

              V1630 = "".

	      RUN xsship01_so56.p.

              leave V1124L.

              display dmdesc format "x(40)" skip with fram F1208 no-box.

              L12081 = "" . 
              display L12081          format "x(40)" skip with fram F1208 no-box.

              L12082 = "" . 
              display L12082          format "x(40)" skip with fram F1208 no-box.

              L12083 = "" . 
              display L12083          format "x(40)" skip with fram F1208 no-box.

              L12084 = "" . 
              display L12084          format "x(40)" skip with fram F1208 no-box.

              L12085 = "" . 
              display L12085          format "x(40)" skip with fram F1208 no-box.

              L12086 = "" . 
              display L12086          format "x(40)" skip with fram F1208 no-box.

              Update V1208
              WITH  fram F1208 NO-LABEL
              EDITING:
                 readkey pause wtimeout.
                 if lastkey = -1 Then quit.
                 if LASTKEY = 404 Then Do: /* DISABLE F4 */
                    pause 0 before-hide.
                    undo, retry.
                 end.
                 apply lastkey.
              end.

              IF V1208 = "e" THEN  LEAVE V1124L.

              display skip WMESSAGE NO-LABEL with fram F1208.

              /*  ---- Valid Check ---- START */

              display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1208.
              pause 0.

              display  "" @ WMESSAGE NO-LABEL with fram F1208.
              pause 0.
              leave V1124L.
           END.
           PV1208 = V1208.

           /* Without Condition Exit Cycle Start */ 
           LEAVE V1124LMAINLOOP.
        END.
        pause 0 before-hide.

     /* Internal Cycle Input :1131    */
     V1125LMAINLOOP:
     REPEAT:
           /*Logical Enter Cycle1131    */
           IF NOT (V1630 = "57" OR V1100 = "57" ) THEN LEAVE V1125LMAINLOOP.

           V1125L:
           REPEAT:
              /* --DEFINE VARIABLE -- START */
              hide all.
              define variable V1308           as char format "x(50)".
              define variable PV1308          as char format "x(50)".
              define variable L13081          as char format "x(40)".
              define variable L13082          as char format "x(40)".
              define variable L13083          as char format "x(40)".
              define variable L13084          as char format "x(40)".
              define variable L13085          as char format "x(40)".
              define variable L13086          as char format "x(40)".

              V1308 = " ".
              V1308 = ENTRY(1,V1308,"@").

              V1630 = "".

              RUN xskbshpnbr_a_so.p.

              leave V1125L.

              display dmdesc format "x(40)" skip with fram F1308 no-box.

              L13081 = "" . 
              display L13081          format "x(40)" skip with fram F1308 no-box.

              L13082 = "" . 
              display L13082          format "x(40)" skip with fram F1308 no-box.

              L13083 = "" . 
              display L13083          format "x(40)" skip with fram F1308 no-box.

              L13084 = "" . 
              display L13084          format "x(40)" skip with fram F1308 no-box.

              L13085 = "" . 
              display L13085          format "x(40)" skip with fram F1308 no-box.

              L13086 = "" . 
              display L13086          format "x(40)" skip with fram F1308 no-box.

              Update V1308
              WITH  fram F1308 NO-LABEL
              EDITING:
                 readkey pause wtimeout.
                 if lastkey = -1 Then quit.
                 if LASTKEY = 404 Then Do: /* DISABLE F4 */
                    pause 0 before-hide.
                    undo, retry.
                 end.
                 apply lastkey.
              end.

              IF V1308 = "e" THEN  LEAVE V1125L.

              display skip WMESSAGE NO-LABEL with fram F1308.

              /*  ---- Valid Check ---- START */

              display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1308.
              pause 0.

              display  "" @ WMESSAGE NO-LABEL with fram F1308.
              pause 0.
              leave V1125L.
           END.
           PV1308 = V1308.

           /* Without Condition Exit Cycle Start */ 
           LEAVE V1125LMAINLOOP.
        END.
        pause 0 before-hide.

     /* Internal Cycle Input :1130    */
     V1121LMAINLOOP:
     REPEAT:
        /*Logical Enter Cycle1130    */
        IF NOT (V1100 = "6" ) THEN LEAVE V1121LMAINLOOP.
        /* START  LINE :1130  3.看板菜单  */
        V1121L:
        REPEAT:

           /* --DEFINE VARIABLE -- START */
           hide all.
           define variable V1109           as char format "x(50)".
           define variable PV1109          as char format "x(50)".
           define variable L11091          as char format "x(40)".
           define variable L11092          as char format "x(40)".
           define variable L11093          as char format "x(40)".
           define variable L11094          as char format "x(40)".
           define variable L11095          as char format "x(40)".
           define variable L11096          as char format "x(40)".
           define variable L11097          as char format "x(40)".

           /* --CYCLE TIME DEFAULT  VALUE -- START  */
           V1109 = " ".
           V1109 = ENTRY(1,V1109,"@").

	   display dmdesc format "x(40)" skip with fram F1109 no-box.
           
	   L11091 = "无条码JIT转仓入库.....61" .
           display L11091          format "x(40)" skip with fram F1109 no-box.

           L11092 = "无条码JIT货运单生成...62" .
           display L11092          format "x(40)" skip with fram F1109 no-box.

           L11093 = "....下有 SO 控制......" .
           display L11093          format "x(40)" skip with fram F1109 no-box.

           L11094 = "无条码JIT货运单生成SO.63" .
           display L11094          format "x(40)" skip with fram F1109 no-box.

           L11095 = "  ".
           display L11095          format "x(40)" skip with fram F1109 no-box.

	   L11096 = "  ".
           display L11096          format "x(40)" skip with fram F1109 no-box.

	   L11097 = " ".
           display L11097          format "x(40)" skip with fram F1109 no-box.

           Update V1109
           WITH  fram F1109 NO-LABEL
           EDITING:
              readkey pause wtimeout.
              if lastkey = -1 Then quit.
              if LASTKEY = 404 Then Do: /* DISABLE F4 */
                 pause 0 before-hide.
                 undo, retry.
              end.
              apply lastkey.
           end.

           IF V1109 = "e" THEN LEAVE V1121L.
/*debug
	   if V1109 = "61" and lookup("mhjit050.p", prog) = 0 then do:
	      display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1109.
              pause 0 before-hide.
              undo, retry.		        
	   end.

	   if V1109 = "62" and lookup("xskbshpnbr.p", prog) = 0 then do:
	      display "错误:你没权限使用该程式"   @ WMESSAGE NO-LABEL with fram F1109.
              pause 0 before-hide.
              undo, retry.		        
	   end.
debug*/
	   /* **CHANGE DEFAULT SITE END ** */
           display skip WMESSAGE NO-LABEL with fram F1109.

           display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1109.
           pause 0.

           display  "" @ WMESSAGE NO-LABEL with fram F1109.
           pause 0.
           leave V1121L.
        END.
        PV1109  = V1109.

        LEAVE V1121LMAINLOOP.
     END.
     pause 0 before-hide.

     V1122LMAINLOOP:
     REPEAT:
           /*Logical Enter Cycle1131    */
           IF NOT (V1109 = "61" OR V1100 = "61" ) THEN LEAVE V1122LMAINLOOP.

           V1170L:
           REPEAT:
              /* --DEFINE VARIABLE -- START */
              hide all.
              define variable V1201           as char format "x(50)".
              define variable PV1201         as char format "x(50)".
              define variable L1201          as char format "x(40)".
              define variable L1202          as char format "x(40)".
              define variable L1203          as char format "x(40)".
              define variable L1204          as char format "x(40)".
              define variable L1205          as char format "x(40)".
              define variable L1206          as char format "x(40)".
              define variable L1207          as char format "x(40)".

              V1201 = " ".
              V1201 = ENTRY(1,V1201,"@").
              /* --CYCLE TIME DEFAULT  VALUE -- END  */

              /* LOGICAL SKIP START */
              V1109 = "".

	      RUN mhjit050.p.

              leave V1170L.

              display dmdesc format "x(40)" skip with fram F1201 no-box.

              l1201 = "" . 
              display l1201          format "x(40)" skip with fram F1201 no-box.

              l1202 = "" . 
              display l1202          format "x(40)" skip with fram F1201 no-box.

              l1203 = "" . 
              display l1203          format "x(40)" skip with fram F1201 no-box.

              l1204 = "" . 
              display l1204          format "x(40)" skip with fram F1201 no-box.

              l1205 = "" . 
              display l1205          format "x(40)" skip with fram F1201 no-box.

              l1206 = "" . 
              display l1206          format "x(40)" skip with fram F1201 no-box.

              l1207 = "" . 
              display l1207          format "x(40)" skip with fram F1201 no-box.

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

              IF V1201 = "e" THEN  LEAVE V1170L.

              display skip WMESSAGE NO-LABEL with fram F1201.

              /*  ---- Valid Check ---- START */

              display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1201.
              pause 0.

              display  "" @ WMESSAGE NO-LABEL with fram F1201.
              pause 0.
              leave V1170L.
           END.
           PV1201 = V1201.


           /* Without Condition Exit Cycle Start */ 
           LEAVE V1122LMAINLOOP.
        END.
        pause 0 before-hide.

     V1123LMAINLOOP:
     REPEAT:
           /*Logical Enter Cycle1131    */
           IF NOT (V1109 = "62" OR V1100 = "62" ) THEN LEAVE V1123LMAINLOOP.

           V1180L:
           REPEAT:
              /* --DEFINE VARIABLE -- START */
              hide all.
              define variable V1301           as char format "x(50)".
              define variable PV1301         as char format "x(50)".
              define variable L1301          as char format "x(40)".
              define variable L1302          as char format "x(40)".
              define variable L1303          as char format "x(40)".
              define variable L1304          as char format "x(40)".
              define variable L1305          as char format "x(40)".
              define variable L1306          as char format "x(40)".
              define variable L1307          as char format "x(40)".

              V1301 = " ".
              V1301 = ENTRY(1,V1301,"@").
              /* --CYCLE TIME DEFAULT  VALUE -- END  */

              /* LOGICAL SKIP START */
              V1109 = "".

	      RUN xskbshpnbr.p.

              leave V1180L.

              display dmdesc format "x(40)" skip with fram F1301 no-box.

              l1301 = "" . 
              display l1301          format "x(40)" skip with fram F1301 no-box.

              l1302 = "" . 
              display l1302          format "x(40)" skip with fram F1301 no-box.

              l1303 = "" . 
              display l1303          format "x(40)" skip with fram F1301 no-box.

              l1304 = "" . 
              display l1304          format "x(40)" skip with fram F1301 no-box.

              l1305 = "" . 
              display l1305          format "x(40)" skip with fram F1301 no-box.

              l1306 = "" . 
              display l1306          format "x(40)" skip with fram F1301 no-box.

              l1307 = "" . 
              display l1307          format "x(40)" skip with fram F1301 no-box.

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

              IF V1301 = "e" THEN  LEAVE V1180L.

              display skip WMESSAGE NO-LABEL with fram F1301.

              /*  ---- Valid Check ---- START */

              display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1301.
              pause 0.

              display  "" @ WMESSAGE NO-LABEL with fram F1301.
              pause 0.
              leave V1180L.
           END.
           PV1301 = V1301.


           /* Without Condition Exit Cycle Start */ 
           LEAVE V1123LMAINLOOP.
        END.
        pause 0 before-hide.

     V1126LMAINLOOP:
     REPEAT:
           /*Logical Enter Cycle1131    */
           IF NOT (V1109 = "63" OR V1100 = "63" ) THEN LEAVE V1126LMAINLOOP.

           V1126L:
           REPEAT:
              /* --DEFINE VARIABLE -- START */
              hide all.
              define variable V1601           as char format "x(50)".
              define variable PV1601         as char format "x(50)".
              define variable L1601          as char format "x(40)".
              define variable L1602          as char format "x(40)".
              define variable L1603          as char format "x(40)".
              define variable L1604          as char format "x(40)".
              define variable L1605          as char format "x(40)".
              define variable L1606          as char format "x(40)".
              define variable L1607          as char format "x(40)".

              V1601 = " ".
              V1601 = ENTRY(1,V1601,"@").
              /* --CYCLE TIME DEFAULT  VALUE -- END  */

              /* LOGICAL SKIP START */
              V1109 = "".

	      RUN xskbshpnbr_so.p.

              leave V1126L.

              display dmdesc format "x(40)" skip with fram F1601 no-box.

              l1601 = "" . 
              display l1601          format "x(40)" skip with fram F1601 no-box.

              l1602 = "" . 
              display l1602          format "x(40)" skip with fram F1601 no-box.

              l1603 = "" . 
              display l1603          format "x(40)" skip with fram F1601 no-box.

              l1604 = "" . 
              display l1604          format "x(40)" skip with fram F1601 no-box.

              l1605 = "" . 
              display l1605          format "x(40)" skip with fram F1601 no-box.

              l1606 = "" . 
              display l1606          format "x(40)" skip with fram F1601 no-box.

              l1607 = "" . 
              display l1607          format "x(40)" skip with fram F1601 no-box.

              Update V1601
              WITH  fram F1601 NO-LABEL
              EDITING:
                 readkey pause wtimeout.
                 if lastkey = -1 Then quit.
                 if LASTKEY = 404 Then Do: /* DISABLE F4 */
                    pause 0 before-hide.
                    undo, retry.
                 end.
                 apply lastkey.
              end.

              IF V1601 = "e" THEN  LEAVE V1126L.

              display skip WMESSAGE NO-LABEL with fram F1601.

              /*  ---- Valid Check ---- START */

              display "...PROCESSING...  " @ WMESSAGE NO-LABEL with fram F1601.
              pause 0.

              display  "" @ WMESSAGE NO-LABEL with fram F1601.
              pause 0.
              leave V1126L.
           END.
           PV1601 = V1601.


           /* Without Condition Exit Cycle Start */ 
           LEAVE V1126LMAINLOOP.
        END.
        pause 0 before-hide.

/**End 看板*/
     end.

