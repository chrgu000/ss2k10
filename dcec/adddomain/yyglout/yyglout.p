/* GUI CONVERTED from yyglout.p (converter v1.78) Thu Sep 20 16:17:10 2012 */
/* yyglout.p - GL REPORT                                                      */
/*V8:ConvertMode=FullGUIReport                                                */
/*-Revision end---------------------------------------------------------------*/


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "120920.1"}
define variable effdate like gltr_eff_dt.
define variable effdate2 like gltr_eff_dt.
define variable usr like gltr_user.
define variable usr2 like gltr_user.
define variable tpe like gltr_tr_type.
define variable tpe2 like gltr_tr_type.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
effdate  colon 20
   effdate2 colon 40 label {t001.i}
   usr      colon 20
   usr2     colon 40 label {t001.i}
   tpe      colon 20
   tpe2     colon 40 label {t001.i}

 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF DEFINED(GPLABEL_I)=0 &THEN
   &IF (DEFINED(SELECTION_CRITERIA) = 0)
   &THEN " Selection Criteria "
   &ELSE {&SELECTION_CRITERIA}
   &ENDIF 
&ELSE 
   getTermLabel("SELECTION_CRITERIA", 25).
&ENDIF.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/*K1D1*/ {wbrp01.i}


/*GUI*/ {mfguirpa.i false  "printer" 80 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

   if effdate = low_date then effdate = ?.
   if effdate2 = hi_date then effdate2 = ?.
   if tpe2 = hi_char then tpe2 = "".
   if usr2 = hi_char then usr2 = "".

/*K1D1*/ if c-application-mode <> 'web' then
   
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


/*K1D1*/ {wbrp06.i &command = update
                   &fields = " effdate effdate2 tpe tpe2 usr usr2"
                   &frm = "a"}

/*K1D1*/ if (c-application-mode <> 'web') or
/*K1D1*/ (c-application-mode = 'web' and
/*K1D1*/ (c-web-request begins 'data')) then do:

   if effdate = ? then effdate = low_date.
   if effdate2 = ? then effdate2 = hi_date.
   if tpe2 = "" then tpe2 = hi_char.
   if usr2 = "" then usr2 = hi_char.

/*K1D1*/ end.

   /* SELECT PRINTER */
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 80}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:



   {mfphead2.i}

   for each  gltr_hist no-lock where gltr_domain = global_domain and
             gltr_eff_dt >= effdate and gltr_eff_dt <= effdate2 and
             gltr_tr_type >= tpe and gltr_tr_type <= tpe2 and
             gltr_user >= usr and gltr_user <= usr2
   use-index gltr_eff_dt with frame b width 80 no-attr-space:
                /* SET EXTERNAL LABELS */
                setFrameLabels(frame b:handle).
                
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
         /*G348*/

      display gltr_eff_dt gltr_ref gltr_user gltr_tr_type WITH STREAM-IO /*GUI*/ .

   end.
   
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

end.

/*K1D1*/ {wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" effdate effdate2 usr usr2 tpe tpe2 "} /*Drive the Report*/
