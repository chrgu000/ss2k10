      /* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

          {mfdtitle.i "A "}
      define variable vend like ap_vend.
      define variable vend1 like ap_vend.
      define variable date like ap_effdate.
      define variable date1 like ap_effdate.
      define variable hold like vo_type.


      /* SELECT FORM */
      
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
      
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
/*  RECT-FRAME       AT ROW 1.4 COLUMN 1.25*/
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
      vend label "供应商"   colon 25   vend1  colon 50 label {t001.i}
      date label "生效日期"   colon 25   date1  colon 50 label {t001.i}
      hold label "三包类型"   colon 25   skip (1)
/*FQ80*   with frame a side-labels attr-space. */
/*FQ80*/   SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = " 选择条件 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



      /* REPORT BLOCK */
      /*fpos1 = 999999.*/
    
/*K0SM*/ {wbrp01.i}


/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

     if vend1 = hi_char then vend1 = "".
     if date = low_date then date = ?.
     if date1 = hi_date then date1 = ?.

/*F058*/
/*K0SM*/ if c-application-mode <> 'web':u then
           
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


/*K0SM*/ {wbrp06.i &command = update &fields = "  vend vend1 date date1 hold " &frm = "a"}

/*K0SM*/ if (c-application-mode <> 'web':u) or
/*K0SM*/ (c-application-mode = 'web':u and
/*K0SM*/ (c-web-request begins 'data':u)) then do:


         /* CREATE BATCH INPUT STRING */
         bcdparm = "".
         {mfquoter.i vend   }
         {mfquoter.i vend1  }
         {mfquoter.i date   }
         {mfquoter.i date1  }
         {mfquoter.i hold   }

         if vend1 = "" then vend1 = hi_char.
         if date = ? then date = low_date.
         if date1 = ? then date1 = hi_date.


/*K0SM*/ end.
         /* SELECT PRINTER */
             
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on 