/* xxapblrp.p - AP BALANCE REPORT                                         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.   */
/*F0PN*/ /*V8:ConvertMode=FullGUIReport                                   */
/* REVISION: 8.6E     LAST MODIFIED: 10/14/2000   BY: *JY003* **Frankie Xu*  */
/*By: Neil Gao 09/02/07 ECO: *SS 20090207* */

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
	   vend           colon 15
	   vend1          label {t001.i} colon 49 skip
	   vdtype         colon 15
	   vdtype1        label {t001.i} colon 49 skip
	 SKIP(.4)  /*GUI*/
with frame a side-labels width 80.

setFrameLabels(frame a:handle).

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


repeat : 

	   if vend1    = hi_char  then vend1    = "".
	   if vdtype1  = hi_char  then vdtype1  = "".

	   update vend vend1 vdtype vdtype1 with frame a.
	   
	   bcdparm = "".
	   {mfquoter.i vend}
	   {mfquoter.i vend1}
	   {mfquoter.i vdtype  }
	   {mfquoter.i vdtype1  }

	   if  vend1 = ""   then vend1    = hi_char.
	   if  vdtype1 = "" then vdtype1  = hi_char.

	   /* SELECT PRINTER */
	   
					{mfselbpr.i "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:


	   {mfphead.i}

           form
             vd_addr ad_name ad_line1 ad_attn vd_buyer 
             ad_phone vd_type  vd_balance vd_prepay
           with frame b  down stream-io width 255.
           
           setFrameLabels(frame b:handle).
           
           do with frame b down:
               amt_balance = 0.
               amt_prepay  = 0.
               for each vd_mstr where vd_addr >= vend and vd_addr <= vend1 and
/*SS 20090207 - B*/
										vd_domain = global_domain and
/*SS 20090207 - E*/
                      vd_type >= vdtype and vd_type <= vdtype1  and vd_prepay > 0 no-lock,
                  first ad_mstr where ad_addr = vd_addr 
/*SS 20090207 - B*/
									and ad_domain = global_domain
/*SS 20090207 - E*/                  
                  no-lock with frame b down:
                 
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

 {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .



	end.

/*GUI*/ end.
