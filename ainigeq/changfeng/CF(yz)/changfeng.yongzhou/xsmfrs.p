DEFINE VAR Selection AS character INIT "".
define var wlocation as character init "0".
DEFINE VAR wtoday    AS date    INIT today.
DEF    VAR CallMfgpro AS LOGICAL .

DEFINE VAR ML101     as char  format "x(24)" init " 1." .   /*Menu Line */
DEFINE VAR ML102     as char  format "x(24)" init " 2." .   /*Menu Line */
DEFINE VAR ML103     as char  format "x(24)" init " 3." .   /*Menu Line */
DEFINE VAR ML104     as char  format "x(24)" init " 4." .   /*Menu Line */
DEFINE VAR ML105     as char  format "x(24)" init " 5." .   /*Menu Line */
DEFINE VAR ML106     as char  format "x(24)" init " 6." .   /*Menu Line */
DEFINE VAR ML107     as char  format "x(24)" init " 7." .   /*Menu Line */
DEFINE VAR ML108     as char  format "x(24)" init " 8." .   /*Menu Line */
DEFINE VAR ML109     as char  format "x(24)" init " 9." .   /*Menu Line */
DEFINE VAR ML110     as char  format "x(24)" init "10." .   /*Menu Line */
DEFINE VAR ML111     as char  format "x(24)" init "11." .   /*Menu Line */
DEFINE VAR ML112     as char  format "x(24)" init "12." .   /*Menu Line */
DEFINE VAR ML113     as char  format "x(24)" init "13." .   /*Menu Line */

DEFINE VAR ML114     as char  format "x(24)" init "14." .   /*Menu Line */
DEFINE VAR ML115     as char  format "x(24)" init "15." .   /*Menu Line */
DEFINE VAR ML116     as char  format "x(24)" init "16." .   /*Menu Line */
DEFINE VAR ML117     as char  format "x(24)" init "17." .   /*Menu Line */
DEFINE VAR ML118     as char  format "x(24)" init "18." .   /*Menu Line */
DEFINE VAR ML119     as char  format "x(24)" init "19." .   /*Menu Line */
DEFINE VAR ML120     as char  format "x(24)" init "20." .   /*Menu Line */
DEFINE VAR ML121     as char  format "x(24)" init "21." .   /*Menu Line */
DEFINE VAR ML122     as char  format "x(24)" init "22." .   /*Menu Line */
DEFINE VAR ML123     as char  format "x(24)" init "23." .   /*Menu Line */
DEFINE VAR ML124     as char  format "x(24)" init "24." .   /*Menu Line */
DEFINE VAR ML125     as char  format "x(24)" init "25." .   /*Menu Line */
DEFINE VAR ML126     as char  format "x(24)" init "26." .   /*Menu Line */

DEFINE VAR ML127     as char  format "x(24)" init "27." .   /*Menu Line */
DEFINE VAR ML128     as char  format "x(24)" init "28." .   /*Menu Line */
DEFINE VAR ML129     as char  format "x(24)" init "29." .   /*Menu Line */
DEFINE VAR ML130     as char  format "x(24)" init "30." .   /*Menu Line */
DEFINE VAR ML131     as char  format "x(24)" init "31." .   /*Menu Line */
DEFINE VAR ML132     as char  format "x(24)" init "32." .   /*Menu Line */
DEFINE VAR ML133     as char  format "x(24)" init "33." .   /*Menu Line */
DEFINE VAR ML134     as char  format "x(24)" init "34." .   /*Menu Line */
DEFINE VAR ML135     as char  format "x(24)" init "35." .   /*Menu Line */
DEFINE VAR ML136     as char  format "x(24)" init "36." .   /*Menu Line */
DEFINE VAR ML137     as char  format "x(24)" init "37." .   /*Menu Line */
DEFINE VAR ML138     as char  format "x(24)" init "38." .   /*Menu Line */
DEFINE VAR ML139     as char  format "x(24)" init "39." .   /*Menu Line */

DEFINE VAR outProgramID as char .

form

ML101    ML114 at 25 ML127 at 50 skip
ML102    ML115 at 25 ML128 at 50 skip
ML103    ML116 at 25 ML129 at 50 skip
ML104    ML117 at 25 ML130 at 50 skip
ML105    ML118 at 25 ML131 at 50 skip
ML106    ML119 at 25 ML132 at 50 skip
ML107    ML120 at 25 ML133 at 50 skip
ML108    ML121 at 25 ML134 at 50 skip
ML109    ML122 at 25 ML135 at 50 skip
ML110    ML123 at 25 ML136 at 50 skip
ML111    ML124 at 25 ML137 at 50 skip
ML112    ML125 at 25 ML138 at 50 skip
ML113    ML126 at 25 ML139 at 50 skip

WITH  NO-LABELS CENTERED FRAME menu2 width 78.

PROCEDURE DISPMENU.

     DEFINE INPUT PARAMETER  wlocation     AS character.
     DEFINE INPUT PARAMETER  wselection     AS character.
     
     RUN CLEARDATA.
 
     /* message wlocation view-as alert-box . */

     FOR EACH   QAD_WKFL where QAD_KEY1	      = "BARCODE_RS_MENU" and 
                               QAD_CHARFLD[1] = wlocation no-lock : /* Menu  QAD_CHARFLD[1] = Parent ProgramID*/
     
          if QAD_CHARFLD[2] = "1" then ML101 = " " + QAD_CHARFLD[2] + "." +  QAD_CHARFLD[4] .
          if QAD_CHARFLD[2] = "2" then ML102 = " " + QAD_CHARFLD[2] + "." +  QAD_CHARFLD[4] .
          if QAD_CHARFLD[2] = "3" then ML103 = " " + QAD_CHARFLD[2] + "." +  QAD_CHARFLD[4] .
          if QAD_CHARFLD[2] = "4" then ML104 = " " + QAD_CHARFLD[2] + "." +  QAD_CHARFLD[4] .
          if QAD_CHARFLD[2] = "5" then ML105 = " " + QAD_CHARFLD[2] + "." +  QAD_CHARFLD[4] .
          if QAD_CHARFLD[2] = "6" then ML106 = " " + QAD_CHARFLD[2] + "." +  QAD_CHARFLD[4] .

     END.



clear all.
	display 
	ML101  ML102 ML103 ML104  ML105 ML103 ML106  ML102 ML107 ML108  ML109 ML110 ML111  ML112 ML113 
	ML114  ML115 ML103 ML116  ML117 ML118 ML119  ML120 ML121 ML122  ML111 ML123 ML124  ML125 ML126 
	ML127  ML128 ML129 ML130  ML131 ML132 ML133  ML134 ML135 ML136  ML109 ML137 ML138  ML112 ML139 

	with fram menu2 no-label width 78.


END.

PROCEDURE LOAD_RS_MENU.   /* load report system menu */
  DEFINE VARIABLE ParentProgramMenu     AS CHARACTER FORMAT "x(200)".
  DEFINE VARIABLE ProgramMenu     AS CHARACTER FORMAT "x(200)".
  DEFINE VARIABLE ProgramID       AS CHARACTER FORMAT "x(76)".
  DEFINE VARIABLE ProgramFunction AS CHARACTER FORMAT "x(76)".
  DEFINE VARIABLE ProgramSecurity AS CHARACTER FORMAT "x(200)".
  DEFINE VARIABLE LicenseKey      AS CHARACTER FORMAT "x(200)".


  DEFINE VARIABLE text-string AS CHARACTER FORMAT "x(255)".
  INPUT FROM VALUE(SEARCH("ReportSystemmenu")).
  Do While True:
         IMPORT  UNFORMAT text-string.
	 ParentProgramMenu = "".
         ProgramMenu     = "" .
         ProgramID       = "" .
         ProgramFunction = "" .
         ProgramSecurity = "" .
	 LicenseKey      = "" .
         ParentProgramMenu = ENTRY(1,text-string,"#") .
         ProgramMenu       = ENTRY(2,text-string,"#") .
         ProgramID         = ENTRY(3,text-string,"#") .
         ProgramFunction   = ENTRY(4,text-string,"#") .
         ProgramSecurity   = ENTRY(5,text-string,"#") .
	 LicenseKey	   = ENTRY(6,text-string,"#") .
         if index ( "123456789",substring(ProgramMenu,1,1) ) <> 0 then do:

    	    RUN UPDATE_QAD_WKFL_RS (INPUT ParentProgramMenu ,INPUT ProgramMenu ,INPUT ProgramID , INPUT ProgramFunction, INPUT ProgramSecurity, INPUT LicenseKey ).
	    Display "UPDATE...... "  skip with fram UpdateBox no-box  .
	    Display trim ( ProgramFunction ) format "X(20)"      no-label  skip with fram UpdateBox no-box .
	    Display trim ( LicenseKey  ) format "x(16)" no-label skip with fram UpdateBox no-box . 
	    
	 
	 end.

  END.
  INPUT CLOSE.
  
END.

PROCEDURE CLEARDATA .

ML101 = " 1." .   
ML102 = " 2." .   
ML103 = " 3." .   
ML104 = " 4." .   
ML105 = " 5." .   
ML106 = " 6." .   
ML107 = " 7." .   
ML108 = " 8." .   
ML109 = " 9." .   
ML110 = "10." .   
ML111 = "11." .   
ML112 = "12." .   
ML113 = "13." .   

ML114 = "14." .   
ML115 = "15." .   
ML116 = "16." .   
ML117 = "17." .   
ML118 = "18." .   
ML119 = "19." .   
ML120 = "20." .   
ML121 = "21." .   
ML122 = "22." .   
ML123 = "23." .   
ML124 = "24." .   
ML125 = "25." .   
ML126 = "26." .   

ML127 = "27." .   
ML128 = "28." .   
ML129 = "29." .   
ML130 = "30." .   
ML131 = "31." .   
ML132 = "32." .   
ML133 = "33." .   
ML134 = "34." .   
ML135 = "35." .   
ML136 = "36." .   
ML137 = "37." .   
ML138 = "38." .   
ML139 = "39." .   

END.

PROCEDURE UPDATE_QAD_WKFL_RS:
     DEFINE INPUT PARAMETER  wParentProgramMenu     AS character.
     DEFINE INPUT PARAMETER  wProgramMenu     AS character.
     DEFINE INPUT PARAMETER  wProgramID       AS character.
     DEFINE INPUT PARAMETER  wProgramFunction AS character.
     DEFINE INPUT PARAMETER  wProgramSecurity AS character.
     DEFINE INPUT PARAMETER  wLicenseKey      AS character.

     FIND First QAD_WKFL where QAD_KEY1 = "BARCODE_RS_MENU" and 
                               QAD_KEY2 = trim(wParentProgramMenu) + "."  + trim(wProgramMenu) no-error.
     IF   NOT AVAILABLE(QAD_WKFL) Then Do:
          CREATE QAD_WKFL.
          ASSIGN QAD_KEY1 = "BARCODE_RS_MENU"
                 QAD_KEY2 = trim(wParentProgramMenu) + "."  + trim(wProgramMenu).
     END.
     QAD_CHARFLD[1] = trim ( wParentProgramMenu ).
     QAD_CHARFLD[2] = trim ( wProgramMenu ).
     QAD_CHARFLD[3] = trim ( wProgramID ).
     QAD_CHARFLD[4] = trim ( wProgramFunction ).
     QAD_CHARFLD[5] = trim ( wProgramSecurity ).
     QAD_CHARFLD[6] = trim ( wLicenseKey ).
END PROCEDURE.

FORM
skip "fmenu                           Main Menu                        " wtoday " "
WITH  NO-LABELS CENTERED TITLE " SOFTSPEED BARCODE REPORT SYSTEM" FRAME menu1.

display wtoday with frame menu1.
wlocation = "0".

form

"    Select Option [E-Exit]:" SELECTION     "		Menu:" wlocation 
WITH  NO-LABELS CENTERED FRAME menu3 width 78.


view frame menu1.
view frame menu2.
view frame menu3.



RUN DISPMENU (INPUT "0" , INPUT "" ). 



REPEAT ON ENDKEY UNDO, RETRY:
        SELECTION = "".

        UPDATE SELECTION  WITH FRAME menu3.
	if selection = "E" then leave .

	if selection = "LOADMENU" then do:
	   RUN LOAD_RS_MENU.
	   selection = "E".
	end.

	if selection = "" THEN  do:
	   wlocation = "0".
	   RUN DISPMENU (INPUT "0" , INPUT "" ).
	   display wlocation with  frame menu3.
	   undo,retry.
	end.

	
	     
	CallMfgpro = no.

        FIND First QAD_WKFL where QAD_KEY1 = "BARCODE_RS_MENU" and QAD_CHARFLD[1] = wlocation and QAD_CHARFLD[2] = selection no-error.
        IF  AVAILABLE(QAD_WKFL) THEN DO:
	    IF index ( QAD_CHARFLD[3],".p" ) <> 0  then do:
	       hide frame menu1.
               hide frame menu2.
               hide frame menu3.
	       RUN  xsmfgpro.p(input trim(QAD_CHARFLD[3]) , input trim (QAD_CHARFLD[4]) ).
	       hide all.
               view frame menu1.
               view frame menu2.
               view frame menu3.

	       CallMfgpro = yes.
	    end.

	END.
        
        
        if CallMfgpro = no then do:
           
	   

	   IF wlocation <> "0" then  wlocation = wlocation + "." + SELECTION.
           IF wlocation  = "0" then  wlocation = SELECTION.

           RUN DISPMENU ( INPUT wlocation , INPUT SELECTION ).
        
	END.

        clear all.
	display wlocation with frame menu3.

END.  /* REPEAT  */
quit.
