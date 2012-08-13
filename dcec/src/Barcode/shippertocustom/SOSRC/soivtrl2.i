/* GUI CONVERTED from soivtrl2.i (converter v1.75) Tue Mar  6 02:59:51 2001 */
/* soivtrl2.i - PENDING INVOICE TRAILER                                      */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*V8:ConvertMode=ReportAndMaintenance                                        */
/*V8:RunMode=Character,Windows                                               */
/* REVISION: 7.4      CREATED:       10/02/95   BY: jym *G0XY*               */
/* REVISION: 7.4     MODIFIED:       11/29/95   BY: rxm *H0GY*               */
/* REVISION: 8.5     MODIFIED:       07/13/95   BY: taf *J053*               */
/* REVISION: 8.5     MODIFIED:       01/08/96   BY: jzw *H0K0*               */
/* REVISION: 8.5     LAST MODIFIED:  09/10/96   BY: *H0MP* Aruna P.Patil     */
/* REVISION: 8.6     LAST MODIFIED:  11/25/96   BY: *K01X* jzw               */
/* REVISION: 8.6     LAST MODIFIED:  10/09/97   BY: *K0JV* Surendra Kumar    */
/* REVISION: 8.6     LAST MODIFIED:  01/15/98   BY: *J2B2* Manish K.         */
/* REVISION: 8.6E    LAST MODIFIED:  02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E    LAST MODIFIED:  05/05/98   BY: *L00V* Ed v.d.Gevel      */
/* REVISION: 8.6E    LAST MODIFIED:  05/09/98   BY: *L00Y* Jeff Wootton      */
/* REVISION: 8.6E    LAST MODIFIED:  06/23/98   BY: *L01G* R. McCarthy       */
/* REVISION: 8.6E    LAST MODIFIED:  07/02/98   BY: *L024* Sami Kureishy     */
/* REVISION: 8.6E    LAST MODIFIED:  08/10/98   BY: *J2VV* Rajesh Talele     */
/* REVISION: 8.6E    LAST MODIFIED:  08/19/98   BY: *J2WV* Surekha Joshi     */
/* REVISION: 9.0     LAST MODIFIED:  09/29/98   BY: *J2CZ* Reetu Kapoor      */
/* REVISION: 9.0     LAST MODIFIED:  11/17/98   BY: *H1LN* Poonam Bahl       */
/* REVISION: 9.0     LAST MODIFIED:  01/22/99   BY: *J38T* Poonam Bahl       */
/* REVISION: 9.0     LAST MODIFIED:  03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.0     LAST MODIFIED:  05/07/99   BY: *J3DQ* Niranjan R.       */
/* REVISION: 9.0     LAST MODIFIED:  02/24/00   BY: *M0K0* Ranjit Jain       */
/* REVISION: 9.0     LAST MODIFIED:  06/22/00   BY: *J3PZ* Reetu Kapoor      */
/* REVISION: 9.0     LAST MODIFIED:  03/05/01   BY: *M12V* Rajaneesh S.      */

         /*!

         PARAMETERS:

         I/O    NAME        LIKE         DESCRIPTION
         ------ ----------- ------------ ---------------------------------------
         input  ref         tx2d_ref     so_nbr until inv print; then so_inv_nbr
         input  nbr         tx2d_nbr     blank until inv print; then so_nbr
         input  col-80      mfc_logical  true to print report with 80 columns
                                         otherwise report uses 132 columns
         input  tax_tr_type tx2d_tr_type 13 for Pending SO; 16 for posting

          */

/*J2CZ*/ /* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO */
/*J2CZ*/ /* WHEREVER MISSING FOR PERFORMANCE AND SMALLER R-CODE */

         {mfdeclre.i}

         /* ********** Begin Translatable Strings Definitions ********* */

         &SCOPED-DEFINE soivtrl2_i_1 "合计 "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivtrl2_i_2 "应纳税"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivtrl2_i_3 "税款合计"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivtrl2_i_4 "折扣"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivtrl2_i_5 "非应纳税"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivtrl2_i_6 "项目合计"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE soivtrl2_i_7 "** 冲 销 **"
         /* MaxLen: Comment: */

         /* ********** End Translatable Strings Definitions ********* */
         define input parameter ref          like tx2d_ref     no-undo.
         define input parameter nbr          like tx2d_nbr     no-undo.
         define input parameter col-80       like mfc_logical  no-undo.
         define input parameter tax_tr_type  like tx2d_tr_type no-undo.

         define new shared variable undo_txdetrp like mfc_logical.

/*M0K0*/ /* l_txchg IS SET TO TRUE IN TXEDIT.P WHEN TAXES ARE BEING EDITED  */
/*M0K0*/ /* AND NOT JUST VIEWED IN DR/CR MEMO MAINTENANCE                   */
/*M0K0*/ define new shared variable l_txchg      like mfc_logical initial no.
         define shared variable rndmthd          like rnd_rnd_mthd.
         define shared variable so_recno         as recid.
         define shared variable maint            as logical.
         define shared variable consolidate      like mfc_logical.
         define shared variable taxable_amt      as decimal
                                                 format "->>>>,>>>,>>9.99"
                                                 label {&soivtrl2_i_2}.
         define shared variable nontaxable_amt   like taxable_amt
                                                 label {&soivtrl2_i_5}.
         define shared variable line_total       as decimal
                                                 format "-zzzz,zzz,zz9.99"
                                                 label {&soivtrl2_i_6}.
         define shared variable disc_amt         like line_total
                                                 label {&soivtrl2_i_4}
                                                 format "(zzzz,zzz,zz9.99)".
         define shared variable tax_amt          like line_total
                                                 label {&soivtrl2_i_3}.
         define shared variable ord_amt          like line_total
                                                 label {&soivtrl2_i_1}.
         define shared variable invcrdt          as character format "x(15)".
         define shared variable user_desc        like trl_desc extent 3.
         define shared variable tax_date         like so_tax_date.
         define shared variable new_order        like mfc_logical.
         define shared variable tax_edit         like mfc_logical.
         define shared variable tax_edit_lbl     like mfc_char
                                                 format "x(28)".
         define shared variable undo_trl2        like mfc_logical.
         define shared variable tot_line_comm    as decimal extent 4 format
                                                 "->>>>,>>>,>>9.99<<<<".

         define shared frame sotot.
         define shared frame d.

         define variable ext_price   like sod_price no-undo.
         define variable ext_actual  like sod_price no-undo.
         define variable tax_lines   like tx2d_line initial 0       no-undo.
         define variable page_break  as integer initial 0           no-undo.
         define variable recalc      like mfc_logical initial true  no-undo.
         define variable tax-edited  like mfc_logical initial false no-undo.
         define variable ext_margin  as decimal
                                      format "->>>>,>>>,>>9.99" no-undo.
         define variable disc_pct    like so_disc_pct no-undo.
         define variable tmp_amt     as decimal no-undo.
         define variable retval      as integer no-undo.
/*H1LN*/ define variable l_retrobill like mfc_logical no-undo.
/*J38T*/ define variable l_tax_in    like tax_amt     no-undo.

/*H1LN*/ if execname = "rcrbrp01.p" then
/*H1LN*/    l_retrobill = yes.

         {txcalvar.i}

/*L01G*/ {etdcrvar.i}  /* TOOLKIT DUAL CURRENCY PRICING VARIABLES */
/*L01G*/ {etvar.i}     /* TOOLKIT GENERAL VARIABLES */
/*L01G*/ {etrpvar.i}   /* TOOLKIT REPORTING CURRENCY VARIABLES */

/*J2CZ** BEGIN DELETE **
 *       find first gl_ctrl no-lock.
 *       find first soc_ctrl no-lock.
 *J2CZ** END DELETE **/

/*J2CZ*/ for first soc_ctrl fields (soc_margin) no-lock: end.


         do for so_mstr:     /*scope this trans */

            if maint then
                find so_mstr where recid(so_mstr) = so_recno
                   exclusive-lock no-error.
            else
/*J2CZ**        find so_mstr where recid(so_mstr) = so_recno   */
/*J2CZ**           no-lock no-error.                           */

/*J2CZ*/        for first so_mstr
/*J2CZ*/           fields (so_ar_acct so_ar_cc so_cr_card so_cr_init so_curr
/*J2CZ*/                   so_cust so_disc_pct so_due_date so_ex_rate
/*J2CZ*/                   so_ex_rate2 so_fob so_invoiced so_inv_nbr so_nbr
/*J2CZ*/                   so_ord_date so_prepaid so_print_pl so_print_so
/*J2CZ*/                   so_rev  so_ship so_ship_date so_stat so_tax_date
/*J2CZ*/                   so_tax_env so_to_inv so_trl1_amt so_trl1_cd
/*J2CZ*/                   so_trl2_amt so_trl2_cd so_trl3_amt so_trl3_cd
/*J2CZ*/                   so__qadl01)
/*J2CZ*/           where recid(so_mstr) = so_recno no-lock:
/*J2CZ*/        end.



            /**** FORMS ****/
            FORM /*GUI*/ 
               

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
&ENDIF /*GUI*/
so_cr_init     colon 15 LABEL "信贷批准人"
               so_inv_nbr     colon 40 LABEL "发票号码"
               so_ar_acct     colon 63 LABEL "应收款账户" so_ar_cc no-label
               so_cr_card     colon 15 LABEL "信用卡"
               so_to_inv      colon 40 LABEL "准备开票"
               so_print_so    colon 63 LABEL "打印客户订单"
               so_stat        colon 15 LABEL "执行壮态"
               so_invoiced    colon 40 LABEL "开票"
               so_print_pl    colon 63 LABEL "打印装箱单"
               so_rev         colon 15 LABEL "版本"
               so_prepaid     colon 40 LABEL "预付金"
               so_fob         colon 15 LABEL "FOB易主处"
            

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 SKIP(.4)  /*GUI*/
&ENDIF /*GUI*/
with frame d side-labels width 80
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/

&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 NO-BOX THREE-D /*GUI*/
&ENDIF /*GUI*/
.


&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN
 DEFINE VARIABLE F-d-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame d = F-d-title.
 RECT-FRAME-LABEL:HIDDEN in frame d = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame d =
  FRAME d:HEIGHT-PIXELS - RECT-FRAME:Y in frame d - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME d = FRAME d:WIDTH-CHARS - .5.  /*GUI*/
&ENDIF /*GUI*/


            {socurvar.i}
            {txcurvar.i}
/*L00V*/    {ettotfrm.i}
/*L00V*     {sototfrm.i} */

       taxloop:
       do on endkey undo, leave.

         /* PRINT THE DETAIL REPORT ONLY FOR REPORTS      */
         /* WHERE THE INVOICES HAVE NOT BEEN CONSOLIDATED */
         if not maint and not consolidate then do:
            undo_txdetrp = true.
            {gprun.i  ""txdetrp.p"" "(input tax_tr_type,
                                      input ref,
                                      input nbr,
                                      input col-80,
                                      input page_break)" }
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/

            if undo_txdetrp = true then undo, leave.
         end. /* if not maint */
                  /*** GET TOTALS FOR LINES ***/
/*J2CZ*/ assign
           line_total = 0
           taxable_amt = 0
           nontaxable_amt = 0
           tot_line_comm[1] = 0
           tot_line_comm[2] = 0
           tot_line_comm[3] = 0
           tot_line_comm[4] = 0.

               if so_tax_date <> ? then
                  tax_date = so_tax_date.
               else if so_ship_date <> ? then
                  tax_date = so_ship_date.
               else
                  tax_date = so_due_date.

               for each sod_det where sod_nbr = so_nbr no-lock:
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


                  ext_actual = (sod_price * sod_qty_inv).

/*L024*           {gprun.i ""gpcurrnd.p"" "(input-output ext_actual, */
/*L024*                                     input rndmthd)"}         */
/*L024*/          {gprunp.i "mcpl" "p" "mc-curr-rnd"
                   "(input-output ext_actual,
                     input rndmthd,
                     output mc-error-number)"}
/*L024*/          if mc-error-number <> 0 then do:
/*L024*/             {mfmsg.i mc-error-number 2}
/*L024*/          end.

                  line_total = line_total + ext_actual.

/*J2VV*/    /* FOR CALL INVOICES, SFB_TAXABLE (IN 86E) OF SFB_DET DETERMINES */
/*J2VV*/    /* TAXABILITY AND THERE COULD BE MULTIPLE SFB_DET FOR A SOD_DET. */

/*J2VV*/          if sod_fsm_type = "FSM-RO" and sod_taxable then do:
/*J2VV*/             for each sfb_det no-lock where sfb_nbr = sod_nbr and
/*J2VV*/                                            sfb_so_line = sod_line:
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/

/*J2VV*/                ext_actual = sfb_price * sfb_qty_req.
/*J2VV*/                /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
/*J2VV*/                {gprunp.i "mcpl" "p" "mc-curr-rnd"
                         "(input-output ext_actual,
                           input rndmthd,
                           output mc-error-number)"}
/*J2VV*/                if mc-error-number <> 0 then do:
/*J2VV*/                   {mfmsg.i mc-error-number 2}
/*J2VV*/                end.
/*J2VV*/                if sfb_taxable then
/*J2VV*/                   assign taxable_amt      = taxable_amt + ext_actual.
/*J2VV*/                else
/*J2VV*/                   nontaxable_amt = nontaxable_amt + ext_actual.
/*J2VV*/             end.
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/
 /* FOR EACH SFB_DET */
/*J2VV*/          end. /* IF SOD_FSM_TYPE = FSM-RO ... */
/*J2VV*/          else
                  if sod_taxable then
                     taxable_amt = taxable_amt + ext_actual.
                  else
                     nontaxable_amt = nontaxable_amt + ext_actual.
                  ext_margin = ext_actual -
                               ROUND(sod_std_cost * (sod_qty_inv),2).
                  if soc_margin = yes then do: /* Commissions based on margin */
/*J2CZ*/             assign
                       tot_line_comm[1] = tot_line_comm[1] +
                             ext_margin * sod_comm_pct[1] / 100
                       tot_line_comm[2] = tot_line_comm[2] +
                             ext_margin * sod_comm_pct[2] / 100
                       tot_line_comm[3] = tot_line_comm[3] +
                             ext_margin * sod_comm_pct[3] / 100
                       tot_line_comm[4] = tot_line_comm[4] +
                             ext_margin * sod_comm_pct[4] / 100.
                  end.
                  else do:                     /* Commissions based on sales  */
/*J2CZ*/             assign
                       tot_line_comm[1] = tot_line_comm[1] +
                             ext_actual * sod_comm_pct[1] / 100
                       tot_line_comm[2] = tot_line_comm[2] +
                             ext_actual * sod_comm_pct[2] / 100
                       tot_line_comm[3] = tot_line_comm[3] +
                             ext_actual * sod_comm_pct[3] / 100
                       tot_line_comm[4] = tot_line_comm[4] +
                             ext_actual * sod_comm_pct[4] / 100.
                  end.
               end.
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/

/*H1LN**       if maint and not so__qadl01 then do:             */

/*H1LN*/       /* SKIPPING SALES VOLUME DISCOUNT CALCULATION    */
/*H1LN*/       /* FOR RETROBILLED ITEMS                         */
/*H1LN*/       if maint and not so__qadl01 and not l_retrobill then do:

/*J2CZ**          find cm_mstr where cm_addr = so_cust no-lock. */
/*J2CZ*/          for first cm_mstr fields (cm_addr cm_disc_pct)
/*J2CZ*/             where cm_addr = so_cust no-lock:
/*J2CZ*/          end.

                  if so_cust <> so_ship and
                     can-find (cm_mstr where cm_mstr.cm_addr = so_ship) then
/*J2CZ**             find cm_mstr where cm_mstr.cm_addr = so_ship no-lock. */
/*J2CZ*/             for first cm_mstr fields (cm_addr cm_disc_pct)
/*J2CZ*/                where cm_mstr.cm_addr = so_ship no-lock:
/*J2CZ*/             end.

/*L00Y*/          /* ADDED SECOND EXCHANGE RATE BELOW */
                  {gprun.i ""sosd.p"" "(input so_ord_date,
                                        input so_ex_rate,
                                        input so_ex_rate2,
                                        input so_cust,
                                        input so_curr,
                                        input line_total,
                                        output disc_pct)"}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/

                  if disc_pct > cm_disc_pct and disc_pct <> 0 then
                     so_disc_pct = disc_pct.
                  else so_disc_pct = cm_disc_pct.
               end.

               disc_amt = (- line_total * (so_disc_pct / 100)).

/*L024*        {gprun.i ""gpcurrnd.p"" "(input-output disc_amt, */
/*L024*                                  input rndmthd)"}       */
/*L024*/       {gprunp.i "mcpl" "p" "mc-curr-rnd"
                "(input-output disc_amt,
                  input rndmthd,
                  output mc-error-number)"}
/*L024*/       if mc-error-number <> 0 then do:
/*L024*/          {mfmsg.i mc-error-number 2}
/*L024*/       end.

               tmp_amt = taxable_amt * so_disc_pct / 100.

/*L024*        {gprun.i ""gpcurrnd.p"" "(input-output tmp_amt, */
/*L024*                                  input rndmthd)"}      */
/*L024*/       {gprunp.i "mcpl" "p" "mc-curr-rnd"
                "(input-output tmp_amt,
                  input rndmthd,
                  output mc-error-number)"}
/*L024*/       if mc-error-number <> 0 then do:
/*L024*/          {mfmsg.i mc-error-number 2}
/*L024*/       end.

/*J2CZ*/       assign
                taxable_amt = taxable_amt - tmp_amt
                tmp_amt = nontaxable_amt * so_disc_pct / 100.

/*L024*        {gprun.i ""gpcurrnd.p"" "(input-output tmp_amt, */
/*L024*                                  input rndmthd)"}      */
/*L024*/       {gprunp.i "mcpl" "p" "mc-curr-rnd"
                "(input-output tmp_amt,
                  input rndmthd,
                  output mc-error-number)"}
/*L024*/       if mc-error-number <> 0 then do:
/*L024*/          {mfmsg.i mc-error-number 2}
/*L024*/       end.

               nontaxable_amt = nontaxable_amt - tmp_amt.

                /* ADD TRAILER AMOUNTS */
                {txtrltrl.i so_trl1_cd so_trl1_amt user_desc[1]}
                {txtrltrl.i so_trl2_cd so_trl2_amt user_desc[2]}
                {txtrltrl.i so_trl3_cd so_trl3_amt user_desc[3]}

               /* UNTIL AN INVOICE IS PRINTED REF IS so_nbr AND */
               /* NBR IS BLANK.  ONCE AN INVOICE IS PRINTED REF */
               /* IS so_inv_nbr AND NBR IS so_nbr               */
               /* CALCULATE TAX AMOUNTS ONLY IF MAINT                */
               if maint then do:

                  /* SEE IF ANY TAX DETAIL EXISTS */
/*J2CZ** BEGIN DELETE **
 *                find first tx2d_det where
 *                         tx2d_ref = so_nbr          and
 *                         tx2d_nbr = nbr             and
 *                         tx2d_tr_type = tax_tr_type no-lock no-error.
 *J2CZ** END DELETE **/

/*J2CZ*/         for first tx2d_det
/*J2CZ*/            fields (tx2d_edited tx2d_nbr tx2d_ref tx2d_tr_type)
/*J2CZ*/            where  tx2d_ref = so_nbr          and
/*J2CZ*/                   tx2d_nbr = nbr             and
/*J2CZ*/                   tx2d_tr_type = tax_tr_type no-lock:
/*J2CZ*/         end.


                  if available tx2d_det then do:
                      /* CHECK PREVIOUS DETAIL FOR EDITED VALUES */
/*J2CZ** BEGIN DELETE **
 *                    find first tx2d_det where tx2d_ref = so_nbr          and
 *                                              tx2d_nbr = nbr             and
 *                                              tx2d_tr_type = tax_tr_type and
 *                                              tx2d_edited
 *                    no-lock no-error.
 *J2CZ** END DELETE **/

/*J2CZ*/         for first tx2d_det
/*J2CZ*/            fields (tx2d_edited tx2d_nbr tx2d_ref tx2d_tr_type)
/*J2CZ*/            where tx2d_ref = so_nbr          and
/*J2CZ*/                  tx2d_nbr = nbr             and
/*J2CZ*/                  tx2d_tr_type = tax_tr_type and
/*J2CZ*/                  tx2d_edited no-lock:
/*J2CZ*/         end.

                      if available(tx2d_det) then do:
                          {mfmsg01.i 917 2 recalc}
                      end.
                  end.
                  else do:
                      tax-edited = no.

                      {gprun.i ""txedtchk.p""
                                  "(input  '11'               /* SOURCE TR  */,
                                    input  so_nbr             /* SOURCE REF */,
                                    input  nbr                /* SOURCE NBR */,
                                    input  0                  /* ALL LINES  */,
                                    output tax-edited)" }
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/
     /* RETURN VAL */

                      if tax-edited then do:
                          {mfmsg01.i 935 2 tax-edited}
                      end.
                  end.

                  if recalc then do:

              /* ADDED TWO PARAMETERS TO TXCALC.P, INPUT PARAMETER VQ-POST */
              /* AND OUTPUT PARAMETER RESULT-STATUS. THE POST FLAG IS SET  */
              /* TO 'NO' BECAUSE WE ARE NOT CREATING QUANTUM REGISTER      */
              /* RECORDS FROM THIS CALL TO TXCALC.P                        */

                     {gprun.i ""txcalc.p""  "(input  tax_tr_type,
                                              input  ref,
                                              input  nbr,
                                              input  tax_lines /* ALL LINES */,
                                              input  no,
                                              output result-status)" }
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


/*M12V*/             /* CREATES TAX RECORDS WITH TRANSACTION TYPE "11" */
/*M12V*/             /* FOR THE QUANTITY BACKORDER DURING THE PENDING  */
/*M12V*/             /* INVOICE MAINTENANCE                            */

/*M12V*/             {gprun.i ""txcalc.p""  "(input  "11",
                                              input  ref,
                                              input  nbr,
                                              input  tax_lines,
                                              input  no,
                                              output result-status)" }
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/

                  end.
                end.

/*J3DQ*/         /* PROCEDURE CALCULATES TOTAL TAXABLE AND NONTAXABLE AMOUNT */
/*J3DQ*/         run p-tottax (input  tax_tr_type,
                               input  ref,
                               input  nbr,
                               input  tax_lines,
                               input-output taxable_amt,
                               input-output nontaxable_amt).

                 {gprun.i ""txabsrb.p"" "(input so_nbr,
                                          input ' ',
                                          input '13',
                                          input-output line_total,
                                          input-output taxable_amt)"}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


                /* COPY EDITED RECORDS IF SPECIFIED BY USER */
                if tax-edited then do:
                    {gprun.i ""txedtcpy.p""
                                "(input  '11'               /* SOURCE TR  */,
                                  input  so_nbr             /* SOURCE REF */,
                                  input  nbr                /* SOURCE NBR */,
                                  input  '13'               /* TARGET TR  */,
                                  input  so_nbr             /* TARGET REF */,
                                  input  nbr                /* TARGET NBR */,
                                  input  0)"    }
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/
           /* ALL LINES  */
                end.

               /* TOTAL TAX TOTALS */
               {gprun.i ""txtotal.p"" "(input  tax_tr_type,
                                        input  ref,
                                        input  nbr,
                                        input  tax_lines,        /* ALL LINES */
                                        output tax_amt)"}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


/*J38T*/       /* OBTAINING TOTAL INCLUDED TAX FOR THE TRANSACTION */
/*J38T*/       {gprun.i ""txtotal1.p"" "(input  tax_tr_type,
                                         input  ref,
                                         input  nbr,
                                         input  tax_lines,      /* ALL LINES */
                                         output l_tax_in)"}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


/*J38T*/       /* ADJUSTING LINE TOTALS AND TOTAL TAX BY INCLUDED TAX */
/*J38T*/       assign
/*J38T*/         line_total       = line_total - l_tax_in
/*J3PZ** /*J38T*/  taxable_amt    = taxable_amt - l_tax_in */
/*J38T*/         tax_amt          = tax_amt + l_tax_in.


               ord_amt =  line_total + disc_amt + so_trl1_amt
                          + so_trl2_amt + so_trl3_amt + tax_amt.

               if ord_amt < 0 then invcrdt = {&soivtrl2_i_7}.
               else invcrdt = "".

               if maint then do on endkey undo taxloop, leave:
                  display nontaxable_amt so_curr line_total taxable_amt
                          so_disc_pct disc_amt tax_date user_desc[1] so_trl1_cd
                          so_trl1_amt user_desc[2] so_trl2_cd so_trl2_amt
                          user_desc[3] so_trl3_cd so_trl3_amt tax_amt ord_amt
/*J2WV**                  tax_edit with frame sotot. */
/*J2WV*/                  tax_edit invcrdt with frame sotot
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/
.

                  trlloop:
                  do on error undo trlloop, retry
                     on endkey undo taxloop, leave:
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


                     /* STORING THE DEFAULT VOLUME DISCOUNT PERCENTAGE */
                     assign disc_pct = so_disc_pct .
                     set
                        so_disc_pct so_trl1_cd so_trl1_amt so_trl2_cd
                        so_trl2_amt so_trl3_cd so_trl3_amt tax_edit
                        with frame sotot.

                     /* TO CHECK WHETHER DISCOUNT PERCENTAGE MANUALLY ENTERED?*/
                     if so_disc_pct <> disc_pct then
                        so__qadl01 = yes.

                     {txedttrl.i &code  = "so_trl1_cd"
                                 &amt   = "so_trl1_amt"
                                 &desc  = "user_desc[1]"
                                 &frame = "sotot"
                                 &loop  = "trlloop"}

                     /* VALIDATE TRAILER 1 AMOUNT */
                     if (so_trl1_amt <> 0) then do:
                        {gprun.i ""gpcurval.p"" "(input so_trl1_amt,
                                        input rndmthd,
                                        output retval)"}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/

                        if retval <> 0 then do:
                           next-prompt so_trl1_amt with frame sotot.
                            undo trlloop, retry.
                        end.
                     end.

                     {txedttrl.i &code  = "so_trl2_cd"
                                 &amt   = "so_trl2_amt"
                                 &desc  = "user_desc[2]"
                                 &frame = "sotot"
                                 &loop  = "trlloop"}

                     /* VALIDATE TRAILER 2 AMOUNT */
                     if (so_trl2_amt <> 0) then do:
                        {gprun.i ""gpcurval.p"" "(input so_trl2_amt,
                                               input rndmthd,
                                               output retval)"}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/

                        if retval <> 0 then do:
                           next-prompt so_trl2_amt with frame sotot.
                           undo trlloop, retry.
                        end.
                     end.

                     {txedttrl.i &code  = "so_trl3_cd"
                                 &amt   = "so_trl3_amt"
                                 &desc  = "user_desc[3]"
                                 &frame = "sotot"
                                 &loop  = "trlloop"}

                     /* VALIDATE TRAILER 3 AMOUNT */
                     if (so_trl3_amt <> 0) then do:
                        {gprun.i ""gpcurval.p"" "(input so_trl3_amt,
                                               input rndmthd,
                                               output retval)"}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/

                        if retval <> 0 then do:
                           next-prompt so_trl3_amt with frame sotot.
                           undo trlloop, retry.
                        end.
                     end.

                  end.
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/
 /* TRLLOOP */

                  /*** GET TOTALS FOR LINES ***/
                  line_total = 0.
                  taxable_amt = 0.
                  nontaxable_amt = 0.
                  for each sod_det where sod_nbr = so_nbr:
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


                     ext_actual = (sod_price * sod_qty_inv).

/*L024*              {gprun.i ""gpcurrnd.p"" "(input-output ext_actual,*/
/*L024*                                        input rndmthd)"}        */
/*L024*/             {gprunp.i "mcpl" "p" "mc-curr-rnd"
                      "(input-output ext_actual,
                        input rndmthd,
                        output mc-error-number)"}
/*L024*/             if mc-error-number <> 0 then do:
/*L024*/                {mfmsg.i mc-error-number 2}
/*L024*/             end.

                     line_total = line_total + ext_actual.

/*J2VV*/    /* FOR CALL INVOICES, SFB_TAXABLE (IN 86E) OF SFB_DET DETERMINES */
/*J2VV*/    /* TAXABILITY AND THERE COULD BE MULTIPLE SFB_DET FOR A SOD_DET. */

/*J2VV*/          if sod_fsm_type = "FSM-RO" and sod_taxable then do:
/*J2VV*/             for each sfb_det no-lock where sfb_nbr = sod_nbr and
/*J2VV*/                                            sfb_so_line = sod_line:
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/

/*J2VV*/                ext_actual = sfb_price * sfb_qty_req.
/*J2VV*/                /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
/*J2VV*/                {gprunp.i "mcpl" "p" "mc-curr-rnd"
                         "(input-output ext_actual,
                           input rndmthd,
                           output mc-error-number)"}
/*J2VV*/                if mc-error-number <> 0 then do:
/*J2VV*/                   {mfmsg.i mc-error-number 2}
/*J2VV*/                end.
/*J2VV*/                if sfb_taxable then
/*J2VV*/                   assign taxable_amt      = taxable_amt + ext_actual.
/*J2VV*/                else
/*J2VV*/                   nontaxable_amt = nontaxable_amt + ext_actual.
/*J2VV*/             end.
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/
 /* FOR EACH SFB_DET */
/*J2VV*/          end. /* IF SOD_FSM_TYPE = FSM-RO ... */
/*J2VV*/          else
                     if sod_taxable then
                        taxable_amt = taxable_amt + ext_actual.
                     else
                        nontaxable_amt = nontaxable_amt + ext_actual.
                  end.
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


                  disc_amt = (- line_total * (so_disc_pct / 100)).

/*L024*           {gprun.i ""gpcurrnd.p"" "(input-output disc_amt,*/
/*L024*                                     input rndmthd)"}      */
/*L024*/          {gprunp.i "mcpl" "p" "mc-curr-rnd"
                   "(input-output disc_amt,
                     input rndmthd,
                     output mc-error-number)"}
/*L024*/          if mc-error-number <> 0 then do:
/*L024*/             {mfmsg.i mc-error-number 2}
/*L024*/          end.

                  tmp_amt = taxable_amt * so_disc_pct / 100.
/*L024*           {gprun.i ""gpcurrnd.p"" "(input-output tmp_amt,*/
/*L024*                                     input rndmthd)"}     */
/*L024*/          {gprunp.i "mcpl" "p" "mc-curr-rnd"
                   "(input-output tmp_amt,
                     input rndmthd,
                     output mc-error-number)"}
/*L024*/          if mc-error-number <> 0 then do:
/*L024*/             {mfmsg.i mc-error-number 2}
/*L024*/          end.

                  taxable_amt = taxable_amt - tmp_amt.

                  tmp_amt = nontaxable_amt * so_disc_pct / 100.
/*L024*           {gprun.i ""gpcurrnd.p"" "(input-output tmp_amt,*/
/*L024*                                     input rndmthd)"}     */
/*L024*/          {gprunp.i "mcpl" "p" "mc-curr-rnd"
                   "(input-output tmp_amt,
                     input rndmthd,
                     output mc-error-number)"}
/*L024*/          if mc-error-number <> 0 then do:
/*L024*/             {mfmsg.i mc-error-number 2}
/*L024*/          end.

                  nontaxable_amt = nontaxable_amt - tmp_amt.

                /* ADD TRAILER AMOUNTS */
                {txtrltrl.i so_trl1_cd so_trl1_amt user_desc[1]}
                {txtrltrl.i so_trl2_cd so_trl2_amt user_desc[2]}
                {txtrltrl.i so_trl3_cd so_trl3_amt user_desc[3]}

                  /****** CALCULATE TAXES ************/

                  /* UNTIL AN INVOICE IS PRINTED REF IS so_nbr AND */
                  /* NBR IS BLANK.  ONCE AN INVOICE IS PRINTED     */
                  /* REF BECOMES so_inv_nbr AND NBR IS so_nbr      */

                  if recalc and not tax-edited then do:
                     {gprun.i ""txcalc.p""  "(input  tax_tr_type,
                                              input  ref,
                                              input  nbr,
                                              input  tax_lines, /* ALL LINES */
                                              input  no,
                                              output result-status)"}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


/*M12V*/             /* CREATES TAX RECORDS WITH TRANSACTION TYPE "11" */
/*M12V*/             /* FOR THE QUANTITY BACKORDER DURING THE PENDING  */
/*M12V*/             /* INVOICE MAINTENANCE                            */

/*M12V*/             {gprun.i ""txcalc.p""  "(input  "11",
                                              input  ref,
                                              input  nbr,
                                              input  tax_lines,
                                              input  no,
                                              output result-status)"}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/

                  end.

/*J3DQ*/         /* PROCEDURE CALCULATES TOTAL TAXABLE AND NONTAXABLE AMOUNT */
/*J3DQ*/         run p-tottax (input  tax_tr_type,
                               input  ref,
                               input  nbr,
                               input  tax_lines,
                               input-output taxable_amt,
                               input-output nontaxable_amt).

                 {gprun.i ""txabsrb.p"" "(input so_nbr,
                                          input ' ',
                                          input '13',
                                          input-output line_total,
                                          input-output taxable_amt)"}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


                  /* DO TAX DETAIL DISPLAY / EDIT HERE */
                  if tax_edit then do:
                     hide frame sotot no-pause.
                     hide frame d no-pause.
                     {gprun.i ""txedit.p""  "(input  tax_tr_type,
                                              input  ref,
                                              input  nbr,
                                              input  tax_lines, /* ALL LINES  */
                                              input  so_tax_env,
                                              output tax_amt)"}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/

                     view frame sotot.
                     view frame d.
                  end.

                  /* CALCULATE TOTALS */
                  {gprun.i ""txtotal.p"" "(input  tax_tr_type,
                                           input  ref,
                                           input  nbr,
                                           input  tax_lines,    /* ALL LINES */
                                           output tax_amt)"}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


/*J38T*/       /* OBTAINING TOTAL INCLUDED TAX FOR THE TRANSACTION */
/*J38T*/       {gprun.i ""txtotal1.p"" "(input  tax_tr_type,
                                         input  ref,
                                         input  nbr,
                                         input  tax_lines,      /* ALL LINES */
                                         output l_tax_in)"}
&IF ("{&PP_GUI_CONVERT_MODE}" <> "REPORT") OR
(("{&PP_GUI_CONVERT_MODE}" = "REPORT") AND
("{&PP_FRAME_NAME}" = "A")) &THEN

/*GUI*/ if global-beam-me-up then undo, leave.
&ENDIF /*GUI*/


/*J38T*/       /* ADJUSTING LINE TOTALS AND TOTAL TAX BY INCLUDED TAX */
/*J38T*/       assign
/*J38T*/         line_total       = line_total - l_tax_in
/*J3PZ** /*J38T*/ taxable_amt     = taxable_amt - l_tax_in */
/*J38T*/         tax_amt          = tax_amt + l_tax_in.


                  ord_amt =  line_total + disc_amt + so_trl1_amt
                             + so_trl2_amt + so_trl3_amt + tax_amt.

                  if ord_amt < 0 then invcrdt = {&soivtrl2_i_7}.
                  else invcrdt = "".
               end.    /* end if maint block */

/*L024*/       {etdcrc.i so_curr so_mstr.so}
               /* DISPLAY TRAILER ONLY IF INVOICES ARE NOT CONSOLIDATED */
               if not consolidate then do:
/*L024*         /*L00V*/ {etdcrc.i so_curr so_mstr.so} */
/*L00V*/        if not et_dc_print then
                  display nontaxable_amt so_curr line_total taxable_amt
                          so_disc_pct disc_amt tax_date user_desc[1] so_trl1_cd
                          so_trl1_amt user_desc[2] so_trl2_cd so_trl2_amt
                          user_desc[3] so_trl3_cd so_trl3_amt tax_amt ord_amt
/*J2WV**          with frame sotot. */
/*J2WV*/                  invcrdt with frame sotot
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/
.
/*L00V*/        else display  nontaxable_amt so_curr line_total taxable_amt
                             so_disc_pct disc_amt tax_date user_desc[1]
                             so_trl1_cd so_trl1_amt user_desc[2] so_trl2_cd
                             so_trl2_amt user_desc[3] so_trl3_cd so_trl3_amt
                             tax_amt ord_amt et_line_total et_disc_amt
                             et_trl1_amt et_trl2_amt et_trl3_amt et_tax_amt
/*J2WV**                     et_ord_amt*/
/*J2WV*/                     et_ord_amt invcrdt
                 with frame sototeuro
&IF ("{&PP_GUI_CONVERT_MODE}" = "REPORT") &THEN
 STREAM-IO /*GUI*/ 
&ENDIF /*GUI*/
.
/*L00V*/       end.
               undo_trl2 = false. /* Changed per discussion skk/pcd */
            end. /* TAXLOOP */
         end. /*end do for transaction scope */

/*J3DQ*/ /* PROCEDURE CALCULATES TOTAL TAXABLE AND NONTAXABLE AMOUNT */
/*J3DQ*/ {txtotal.i}
