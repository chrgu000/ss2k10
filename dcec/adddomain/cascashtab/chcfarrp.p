/* GUI CONVERTED from chcfarrp.p (converter v1.71) Sun Oct 21 21:39:25 2007 */
/* chcfacrp.p - CHINESE CF ACCOUNT CODE REPORT - CAS                 */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert glacrp.p (converter v1.00) Fri Oct 10 13:57:11 1997      */
/* web tag in glacrp.p (converter v1.00) Mon Oct 06 14:17:31 1997       */
/*F0PN*/ /*K0SM*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=FullGUIReport                                          */
/* REVISION: 9.2CH    LAST MODIFIED:03/05/04   XinChao Ma  *XXCH911*     */

/* ********** Begin Translatable Strings Definitions ********* */

/* ********** End Translatable Strings Definitions ********* */

      /* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

      {mfdtitle.i "A "}
      define variable cas_cf_code like xcf1_ac_code. 
      define variable cas_cf_code1 like xcf1_ac_code. 

      /* SELECT FORM */
      
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
      
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
cas_cf_code   colon 25   cas_cf_code1  colon 50 label {t001.i} skip(1) 
       SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " Selection Criteria "
  &ELSE {&SELECTION_CRITERIA}
  &ENDIF .
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

      {wbrp01.i}


/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

     if cas_cf_code1 = hi_char then cas_cf_code1 = "".

     if c-application-mode <> 'web':u then
           
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


     {wbrp06.i &command = update &fields = "  cas_cf_code cas_cf_code1 " &frm = "a"}

     if (c-application-mode <> 'web':u) or
        (c-application-mode = 'web':u and
        (c-web-request begins 'data':u)) then do:

         /* CREATE BATCH INPUT STRING */
         bcdparm = "".
         {mfquoter.i cas_cf_code   }
         {mfquoter.i cas_cf_code1  }

         if cas_cf_code1 = "" then cas_cf_code1 = hi_char.

     end.

         /* SELECT PRINTER */
         
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:




         {mfphead.i}  
      
         for each xcf1_mstr where xcf1_ac_code >= cas_cf_code 
                             and xcf1_ac_code <= cas_cf_code1
                             and xcf1_domain = global_domain
                    no-lock with frame d:

             FORM /*GUI*/     xcf1_mfg_ac_code 
                     xcf1_mfgc_ac_code
                     xcf1_mfgc_sub  label "Sub-Acct"
                     xcf1_mfgc_cc  label "Cost Center"
                     xcf1_mfgc_pro label "Project code"
                     xcf1_ac_code 
                     xcf1_cf_acc
                     xcf1_active
                     with STREAM-IO /*GUI*/  frame d width 132. 

             /* SET EXTERNAL LABELS */
             setFrameLabels(frame d:handle).

             display xcf1_mfg_ac_code 
                     xcf1_mfgc_ac_code
                     xcf1_mfgc_sub
                     xcf1_mfgc_cc
                     xcf1_mfgc_pro
                     xcf1_ac_code 
                     xcf1_cf_acc
                     xcf1_active
                     with frame d STREAM-IO /*GUI*/ . 

            
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

         end. /* for each */

         /* REPORT TRAILER  */
         
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


      end.

{wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" cas_cf_code cas_cf_code1 "} /*Drive the Report*/
