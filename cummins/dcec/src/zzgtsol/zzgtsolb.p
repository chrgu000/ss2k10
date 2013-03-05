/* GUI CONVERTED from soivpst.p (converter v1.69) Tue Aug 27 09:57:06 1996 */
/* soivpst.p - POST INVOICES TO AR AND GL REPORT                            */


/*origin*/    define input parameter v_inv_nbr  as character.
/*origin*/    define input parameter v_effdate  as date.
/*origin*/    define input parameter out_rpt    as character.
/*origin*/    define output parameter v_flag    as logical.



   /* origin      {mfdtitle.i "d+ "} */
/*origin */   {mfdeclre.i}

/*F017*/  {soivpst.i "new shared"} /* variable definition moved include file */
/*F017*/  {fsdeclr.i new}
/*F458    define new shared variable tax_date like tax_effdate. */
/*G2CR*/  define new shared variable prog_name as character
						  initial "soivpst.p" no-undo.

          /* DEFINE VARIABLES USED IN GPGLEF1.P (GL CALENDAR VALIDATION) */
/*J0DV*/  {gpglefv.i}

/*J0DV*   /*H039*/  {gpglefdf.i} */


          post = yes.



	/*GUI preprocessor Frame A define */
	&SCOPED-DEFINE PP_FRAME_NAME A

	FORM /*GUI*/

	 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
	 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
	 SKIP(.1)  /*GUI*/
	inv                  colon 15
	             inv1                 label {t001.i} colon 49 skip
	/*G047*/     cust                 colon 15
	/*G047*/     cust1                label {t001.i} colon 49 skip
	/*G047*/     bill                 colon 15
	/*G047*/     bill1                label {t001.i} colon 49 skip(1)
	             eff_date             colon 33 label "总帐生效日期" skip
	             gl_sum               colon 33 label "总帐合并/明细(C/D)" skip
	             print_lotserials     colon 33
	/*H0F0*   with frame a side-labels.       */
	/*H0F0*/   SKIP(.4)  /*GUI*/
	with frame a width 80 side-labels NO-BOX THREE-D /*GUI*/.

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



          do transaction:


             insbase = no.
/*G585*/     fsunit = false.


     find first svc_ctrl where svc_ctrl.svc_domain = global_domain no-lock no-error.
             /* SVC_WARR_SVCODE IS THE WARRANTY SERVICE TYPE FOR RMA'S, */
             /* NOT A DEFAULT WARRANTY TYPE.                            */

/*J04C*/     /* WITH THE 8.5 RELEASE, LOADING THE STANDARD BOM CONTENTS */
             /* INTO THE INSTALLED BASE IS NO LONGER AN OPTION.  THIS   */
             /* DECISION WAS MADE TO PREVENT SERIALIZED ITEMS FROM      */
             /* GETTING INTO THE ISB WITHOUT SERIAL NUMBERS, AND ENSURE */
             /* THERE ARE NO ADVERSE IMPACTS TO THE COMPLIANCE SERIAL   */
             /* NUMBERING REQUIREMENTS.                                 */
             if available svc_ctrl then
                assign
/*J04C*            serialsp = svc_serial        */
/*J04C* /*G435*/   nsusebom = svc_isb_nsbom     */
/*J04C*/           serialsp = "S"       /* ALL SERIALS SHOULD LOAD */
/*J04C*/           nsusebom = no
/*G435*/           usebom   = svc_isb_bom
/*H0F0*/           needitem = svc_pt_mstr
/*J04C* /*H0F0*/   warranty = svc_warr_svcode   */
                   insbase  = svc_ship_isb.

/*G585* *BEGIN DELETED CODE****************
 * find first sac_ctrl no-lock no-error.
 * if available sac_ctrl then do:
 *     prefix = sac_sa_pre.
 *     if svc_ship_isb then insbase = yes.
 * end.
 *G585* *END DELETED CODE******************/

/*GJ95*      find first fac_ctrl no-lock. */
/*GJ95*/     find first fac_ctrl where fac_ctrl.fac_domain = global_domain no-lock no-error.
/*G435*/     if available fac_ctrl then
/*G435*/        fsunit = fac_unit_qty.
/*G435*/     else
/*G435*/        fsunit = false.

          end.

/*          origin
				/*GUI*/ {mfguirpa.i true  "printer" 132 }
				/*GUI repeat : */
				/*GUI*/ procedure p-enable-ui:
*/

             assign
                expcount = 999
                pageno   = 0.
/*****
				             if eff_date = ? then eff_date = today.
				             if inv1 = hi_char then inv1 = "".
				/*G047*/     if cust1 = hi_char then cust1 = "".
				/*G047*/     if bill1 = hi_char then bill1 = "".


				run p-action-fields (input "display").
				run p-action-fields (input "enable").
				end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

				/*GUI*/ procedure p-report-quote:
******/

/*origin*begin**********/
        cust1 = "".
        bill1 = "".
        inv = v_inv_nbr.
        inv1 = inv.
        eff_date = v_effdate.
        gl_sum = no.
        print_lotserials = no.
/*origin*end**********/


/*J0DV*/     /* VALIDATE OPEN GL PERIOD FOR PRIMARY ENTITY - GIVE
/*J0DV*/      * A WARNING IF THE PRIMARY ENTITY IS CLOSED. WE DON T
/*J0DV*/      * WANT A HARD ERROR BECAUSE WHAT REALLY MATTERS IS
/*J0DV*/      * THE ENTITY SO_SITE OF EACH SO_SITE (WHICH IS VALIDATED
/*J0DV*/      * IN SOIVPST1.P. BUT WE AT LEAST WANT A WARNING MESSAGE
/*J0DV*/      * IN CASE, FOR EXAMPLE, THEY ACCIDENTALLY ENTERED
/*J0DV*/      * THE WRONG EFFECTIVE DATE */

             /* VALIDATE OPEN GL PERIOD FOR SPECIFIED ENTITY */
/*J0DV*/     {gprun.i ""gpglef1.p""
                   "( input  ""SO"",
                      input  glentity,
                      input  eff_date,
                      output gpglef_result,
                      output gpglef_msg_nbr
                    )" }

/*J0DV*/     if gpglef_result > 0 then do:
/*J0DV*/        /* IF PERIOD CLOSED THEN WARNING ONLY */
/*J0DV*/        if gpglef_result = 2 then do:
/*J0DV*/           {mfmsg.i 3005 2}
/*J0DV*/        end.
/*J0DV*/        /* OTHERWISE REGULAR ERROR MESSAGE */
/*J0DV*/        else do:
/*J0DV*/           {mfmsg.i gpglef_msg_nbr 4}
/*J0DV*/           /*GUI NEXT-PROMPT removed */
/*J0DV*/           /*GUI UNDO removed  RETURN ERROR.*/
/*origin*/         v_flag = yes.  undo, return.
/*J0DV*/        end.
/*J0DV*/     end.

/*H039* {mfglef.i eff_date}                          */
/*J0DV* /*H039*/ {gpglef.i ""SO"" glentity eff_date} */


             bcdparm = "".

             {mfquoter.i inv      }
             {mfquoter.i inv1     }
/*G047*/     {mfquoter.i cust     }
/*G047*/     {mfquoter.i cust1    }
/*G047*/     {mfquoter.i bill     }
/*G047*/     {mfquoter.i bill1    }
             {mfquoter.i eff_date }
             {mfquoter.i gl_sum   }
             {mfquoter.i print_lotserials}

             if  eff_date = ? then eff_date = today.
             if  inv1 = "" then inv1 = hi_char.
/*G047*/     if  cust1 = "" then cust1 = hi_char.
/*G047*/     if  bill1 = "" then bill1 = hi_char.

/* origin
             /* SELECT PRINTER */

/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}*/

/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:


find first svc_ctrl where svc_ctrl.svc_domain = global_domain  no-lock no-error.
find first fac_ctrl where fac_ctrl.fac_domain = global_domain no-lock no-error.




/*F017*/     /* If we are runing under dos then the second print file for  */
/*F017*/     /* installed base has to be to a disc file or it will get a   */
/*F017*/     /* printer error.                                             */
/*G435*      if opsys = "msdos" or dev <> "printer"  then   */
/*G585*/     if insbase then do:
/*G435*/        {gpfildel.i &filename=""ISBPST.prn""}
                output stream prt2  to "ISBPST.prn".
/*G585*/     end.

/*G435*      else                              */
/*G435*         output stream prt2 to PRINTER. */


             do transaction on error undo, retry:
                /* Create Journal Reference */
                {gprun.i ""sonsogl.p""}
             end.


/*GUI mainloop removed */

             do on error undo, leave:

/*FO66       {mfphead.i} */

/*F017*/        /* Main program moved to soivpst1.p */
                {gprun.i ""soivpst1.p""}

/*H367*/        do transaction:
/*H367*/           find ba_mstr where ba_mstr.ba_domain = global_domain and  ba_batch = batch and ba_module = "SO"
/*H367*/              exclusive-lock no-error.
/*H367*/           if available ba_mstr then do:
/*H367*/              ba_total  = ba_total + batch_tot.
/*H367*/              ba_ctrl   = ba_total.
/*H367*/              ba_userid = global_userid.
/*H367*/              ba_date   = today.
/*H367*/              batch_tot = 0.
/*H367*/              ba_status = " ". /*balanced*/
/*H367*/           end.
/*H367*/        end.

/*F017*/        /* Reset second print file */
/*G585*/        if insbase then do:
                   put stream prt2 " ".
                   output stream prt2 close.
/*G585*/        end.

                /* REPORT TRAILER */
       /*
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

		 2004-09-02 14:08 *lb01*
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

*/
             end. /* mainloop */

          end.
/* origin
/*GUI*/ end procedure. /*p-report*/
*/

/**
/*GUI*/ {mfguirpb.i &flds=" inv inv1  cust cust1 bill bill1 eff_date gl_sum print_lotserials "} /*Drive the Report*/

*/