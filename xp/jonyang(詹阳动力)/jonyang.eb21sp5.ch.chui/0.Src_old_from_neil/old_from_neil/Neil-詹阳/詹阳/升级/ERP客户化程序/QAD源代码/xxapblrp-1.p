/* xxapblrp.p - AP BALANCE REPORT                                         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.   */
/*F0PN*/ /*V8:ConvertMode=FullGUIReport                                   */
/* REVISION: 8.6E     LAST MODIFIED: 10/14/2000   BY: *JY003* **Frankie Xu*  */


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*G1LD*/ {mfdtitle.i "b+ "}

	define variable vend         like ap_vend.
	define variable vend1        like ap_vend.
	define variable vdtype       like vd_type label "供应商类型".
	define variable vdtype1      like vdtype.
        define variable duedate      like vo_due_date.
        define variable duedate1     like vo_due_date.
        define variable amt_balance  like vd_balance.
        define variable amt_prepay   like vd_prepay.

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
	   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
	   vend           colon 15
	   vend1          label {t001.i} colon 49 skip
	   vdtype         colon 15
	   vdtype1        label {t001.i} colon 49 skip
	 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

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



	
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

	   if vend1    = hi_char  then vend1    = "".
	   if vdtype1  = hi_char  then vdtype1  = "".

	   
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


	   bcdparm = "".
	   {mfquoter.i vend}
	   {mfquoter.i vend1}
	   {mfquoter.i vdtype  }
	   {mfquoter.i vdtype1  }

	   if  vend1 = ""   then vend1    = hi_char.
	   if  vdtype1 = "" then vdtype1  = hi_char.

	   /* SELECT PRINTER */
	   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:


	   {mfphead.i}

           form
             vd_addr ad_name ad_line1 ad_attn vd_buyer 
             ad_phone vd_type  vd_balance vd_prepay
           with frame b  down stream-io width 255.
           
           do with frame b down:
               amt_balance = 0.
               amt_prepay  = 0.
               for each vd_mstr where vd_addr >= vend and vd_addr <= vend1 and
                      vd_type >= vdtype and vd_type <= vdtype1  and vd_prepay > 0 no-lock,
                  first ad_mstr where ad_addr = vd_addr no-lock with frame b down:
                 
                 display vd_addr ad_name ad_line1 ad_attn vd_buyer ad_phone vd_type  vd_balance vd_prepay.
                 amt_balance = amt_balance + vd_balance.
                 amt_prepay  = amt_prepay  + vd_prepay.
                 down .
               end.
               down 1 with frame b.
               underline vd_balance vd_prepay.
               display amt_balance @ vd_balance
                       amt_prepay  @ vd_prepay.
           end.
            

	   /* REPORT TRAILER */
	   
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


	end.

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" vend vend1 vdtype vdtype1"} /*Drive the Report*/
