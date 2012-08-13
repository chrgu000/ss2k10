/* GUI CONVERTED from sosotrle.p (converter v1.75) Fri Apr 20 00:29:25 2001 */
/* sosotrle.p - DISPLAY INVOICE TRAILER                                   */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.   */
/*V8:ConvertMode=Maintenance                                              */
/*V8:RunMode=Character,Windows                                            */
/* REVISION: 8.5      CREATED:       08/05/96   BY: jpm *J13Q*            */
/* REVISION: 8.6      CREATED:       11/25/96   BY: jzw *K01X*            */
/* REVISION: 8.6      CREATED:       10/09/97   BY: *K0JV* Surendra Kumar */
/* REVISION: 8.6   LAST MODIFIED:    01/15/98   BY: *J2B2* Manish  K.     */
/* REVISION: 8.6E  LAST MODIFIED:    02/23/98   BY: *L007* A. Rahane      */
/* REVISION: 8.6E  LAST MODIFIED:    03/13/98   BY: *J2B5* Samir Bavkar   */
/* REVISION: 8.6E  LAST MODIFIED:    05/05/98   BY: *L00L* Ed vdGevel     */
/* REVISION: 8.6E  LAST MODIFIED:    05/09/98   BY: *L00Y* Jeff Wootton   */
/* REVISION: 8.6E  LAST MODIFIED:    07/16/98   BY: *L024* sami Kureishy  */
/* REVISION: 8.6E  LAST MODIFIED:    01/22/99   BY: *J38T* Poonam Bahl    */
/* REVISION: 8.6E  LAST MODIFIED:    02/10/99   BY: *L0D4* Satish Chavan  */
/* REVISION: 8.6E  LAST MODIFIED:    02/16/99   BY: *J3B4* Madhavi Pradhan*/
/* REVISION: 8.6E  LAST MODIFIED:    05/07/99   BY: *J3DQ* Niranjan R.    */
/* REVISION: 9.0   LAST MODIFIED:    02/24/00   BY: *M0K0* Ranjit Jain    */
/* REVISION: 9.0   LAST MODIFIED:    03/15/2000 BY: *L0SP* Kedar Deherkar */
/* REVISION: 9.0   LAST MODIFIED:    06/22/00   BY: *J3PZ* Reetu Kapoor   */
/* REVISION: 9.0   LAST MODIFIED:    04/06/01   BY: *M14W* Sandeep P.     */

         {mfdeclre.i}

         /* ********** Begin Translatable Strings Definitions ********* */

         &SCOPED-DEFINE sosotrle_p_1 "客户订单"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosotrle_p_2 "税款合计"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosotrle_p_3 "增值税"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosotrle_p_4 "合计 "
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosotrle_p_5 "税"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosotrle_p_6 "应纳税"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosotrle_p_7 "折扣"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosotrle_p_8 "非应纳税"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosotrle_p_9 "** 冲 销 **"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosotrle_p_10 "项目合计"
         /* MaxLen: Comment: */

         &SCOPED-DEFINE sosotrle_p_11 "金额"
         /* MaxLen: Comment: */

         /* ********** End Translatable Strings Definitions ********* */

         /* NEW SHARED VARIABLES, BUFFERS AND FRAMES */
         define new shared variable undo_txdetrp     like mfc_logical.
         define new shared variable tax_recno        as recid.

/*M0K0*/ /* l_txchg IS SET TO TRUE IN TXEDIT.P WHEN TAXES ARE BEING EDITED  */
/*M0K0*/ /* AND NOT JUST VIEWED IN DR/CR MEMO MAINTENANCE                   */
/*M0K0*/ define new shared variable l_txchg       like mfc_logical
/*M0K0*/                                          initial no.

         /* SHARED VARIABLES, BUFFERS AND FRAMES */
         define shared variable rndmthd          like rnd_rnd_mthd.
         define shared variable display_trail    like mfc_logical.
         define shared variable so_recno         as recid.
         define shared variable maint            like mfc_logical.
         define shared variable taxable_amt      as decimal
                            format "->>>>,>>>,>>9.99"
                            label {&sosotrle_p_6}.
         define shared variable line_taxable_amt like taxable_amt.
         define shared variable nontaxable_amt   like taxable_amt
                            label {&sosotrle_p_8}.
         define shared variable line_total       as decimal
                            format "-zzzz,zzz,zz9.99"
                            label {&sosotrle_p_10}.
         define shared variable disc_amt         like line_total
                            label {&sosotrle_p_7}
                            format "(zzzz,zzz,zz9.99)".
         define shared variable tax_amt          like line_total
                            label {&sosotrle_p_2}.
         define shared variable ord_amt          like line_total
                            label {&sosotrle_p_4}.
         define shared variable tax              like line_total
                            label {&sosotrle_p_5}
                            extent 3
                            format "-zzzzzzzzz9.99".
         define shared variable amt              like line_total
                            label {&sosotrle_p_11} extent 3
                            format "-zzzzzzzzz9.99".
         define shared variable vtclass          as character format "x(1)"
                            extent 3 label {&sosotrle_p_3}.
         define shared variable user_desc        like trl_desc extent 3.
         define shared variable line_pst         as decimal
                            format "->>>>,>>>,>>9.99".
         define shared variable trail_pst        as decimal
                            format "->>>>,>>>,>>9.99".
         define shared variable total_pst        like line_total.
         define shared variable pst_on_gst       like mfc_logical.
         define shared variable pst_taxed        like mfc_logical.
         define shared variable gst_taxed        like mfc_logical.
         define shared variable tax_date         like so_tax_date.
         define shared variable new_order        like mfc_logical.
         define shared variable tax_edit         like mfc_logical.
         define shared variable tax_edit_lbl     like mfc_char
                            format "x(28)".
         define shared variable invcrdt          as character format "x(15)".
         define shared variable undo_trl2        like mfc_logical.

         define shared frame sotot.
         define shared frame d.

         /* LOCAL VARIABLES, BUFFERS AND FRAMES */
         define variable i as integer.
         define variable term-disc       like ct_disc_pct.
         define variable actual_price    like sod_price.
         define variable gst_rate        like vt_tax_pct.
         define variable ext_price       like sod_price.
         define variable ext_actual      like sod_price.
         define variable gst             like sod_price.
         define variable tax_tr_type     like tx2d_tr_type initial "11".
         define variable tax_nbr         like tx2d_nbr initial "".
         define variable tax_lines       like tx2d_line initial 0.
         define variable disc_pct        like so_disc_pct.
         define variable page_break      as integer initial 10.
         define variable col-80          as logical initial true.
         define variable recalc          like mfc_logical initial true.
         define variable credit_hold     like mfc_logical no-undo.
         define variable base_amt        like ar_amt.
         define variable tmp_amt         as decimal.
         define variable retval          as integer.
         define variable balance_fmt      as character.
         define variable limit_fmt        as character.
/*J38T*/ define variable l_tax_in         like tax_amt no-undo.

/*L024*/ {gprunpdf.i "mcpl" "p"}

         {fsconst.i} /* FIELD SERVICE CONSTANTS */
         {txcalvar.i}
/*L00L*/ {etdcrvar.i}
/*L00L*/ {etvar.i}
/*L00L*/ {etrpvar.i}

         find first gl_ctrl no-lock.
         find first soc_ctrl no-lock.

         /* SET LIMIT_FMT AND BALANCE_FMT FOR USE IN MFMSG02.I */
         limit_fmt = "->>>>,>>>,>>9.99".

         /* SET LIMIT_FMT ACCORDING TO BASE CURR ROUND METHOD*/
         {gprun.i ""gpcurfmt.p"" "(input-output limit_fmt,
                   input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         balance_fmt = "->>>>,>>>,>>9.99".

         /* SET BALANCE_FMT ACCORDING TO BASE CURR ROUND METHOD*/
         {gprun.i ""gpcurfmt.p"" "(input-output balance_fmt,
                   input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.


        if maint then /* LOCK THE RECORD */
        find so_mstr where recid(so_mstr) = so_recno exclusive-lock.
        else /* PRINTING - DON'T LOCK THE RECORD */
        find so_mstr where recid(so_mstr) = so_recno no-lock.

            tax_nbr = so_quote.

        if so_fsm_type = 'RMA' then
           assign tax_tr_type = '36'.

            /* USE TRANSACTION TYPE 38 FOR CALL INVOICE RECORDING (SSM) */
            /* AND SET THE TAX_NBR TO THE CALL'S QUOTE (IF ANY) */
            if so_fsm_type = fsmro_c then do:
/*L0D4**       find ca_mstr where ca_nbr = so_nbr no-lock no-error. */
/*L0D4*/       for first ca_mstr
/*L0D4*/          fields(ca_category ca_nbr ca_quote_nbr)
/*L0D4*/          where ca_category = '0'
/*L0D4*/          and   ca_nbr      = so_nbr no-lock:
/*L0D4*/       end. /* FOR FIRST CA_MSTR */
               if available ca_mstr then
                  tax_nbr = ca_quote_nbr.
               tax_tr_type = "38".
            end.

        /**** FORMS ****/
        
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
        
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
so_nbr so_cust so_bill so_ship
         SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



        {sosomt01.i}  /* Define shared frame d */

            {socurvar.i}
            {txcurvar.i}
            if {txnew.i} then do:
           {sototfrm.i}
            end.

        tax_nbr = so_quote.

        if not maint and display_trail then do:
        tax_edit_lbl = "".
        undo_txdetrp = true.
        {gprun.i  ""txdetrp.p"" "(input tax_tr_type,
                      input so_nbr,
                      input tax_nbr,
                      input col-80,
                      input page_break)" }
/*GUI*/ if global-beam-me-up then undo, leave.

        if undo_txdetrp = true then undo, leave.
        if page-size - line-counter < page_break then page.
        do while page-size - line-counter > page_break:
            put skip(1).
        end.
        put "-----------------------------------------"
          + "-----------------------------------------" format "x(80)".
        end.

        taxloop:
        do on endkey undo, leave:

        /*** GET TOTALS FOR LINES ***/
        line_total = 0.
        taxable_amt = 0.
        nontaxable_amt = 0.

        if so_tax_date = ? then tax_date = so_due_date.
        else tax_date = so_tax_date.
        if tax_date = ? then tax_date = so_ord_date.

        /* ACCUMULATE LINE AMOUNTS */
        for each sod_det where sod_nbr = so_nbr:
/*GUI*/ if global-beam-me-up then undo, leave.


                    ext_actual = (sod_price * (sod_qty_ord - sod_qty_ship)).
                    /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */

/*L024*             {gprun.i ""gpcurrnd.p"" "(input-output ext_actual, */
/*L024*                       input rndmthd)"} */
/*L024*/            {gprunp.i "mcpl" "p" "mc-curr-rnd"
                           "(input-output ext_actual,
                             input rndmthd,
                             output mc-error-number)"}
/*L024*/            if mc-error-number <> 0 then do:
/*L024*/               {mfmsg.i mc-error-number 2}
/*L024*/            end.

                line_total = line_total + ext_actual.

/*J2B5*/    /* FOR CALL INVOICES, SFB_TAXABLE (IN 86) OF SFB_DET DETERMINES  */
/*J2B5*/    /* TAXABILITY AND THERE COULD BE MULTIPLE SFB_DET FOR A SOD_DET. */

/*J2B5*/    if sod_fsm_type = fsmro_c and sod_taxable then do:
/*J2B5*/       for each sfb_det no-lock where sfb_nbr = sod_nbr and
/*J2B5*/          sfb_so_line = sod_line:
/*GUI*/ if global-beam-me-up then undo, leave.

/*J2B5*/          ext_actual = sfb_price * sfb_qty_req.
/*J2B5*/          /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */

/*L024* /*J2B5*/   {gprun.i ""gpcurrnd.p"" "(input-output ext_actual, */
/*L024*                                      input rndmthd)"}         */
/*L024*/          {gprunp.i "mcpl" "p" "mc-curr-rnd"
                     "(input-output ext_actual,
                       input rndmthd,
                       output mc-error-number)"}
/*L024*/          if mc-error-number <> 0 then do:
/*L024*/             {mfmsg.i mc-error-number 2}
/*L024*/          end.

/*J2B5*/          if sfb_taxable then
/*J2B5*/             assign taxable_amt      = taxable_amt + ext_actual
/*J2B5*/                    line_taxable_amt = taxable_amt.
/*J2B5*/          else
/*J2B5*/             nontaxable_amt = nontaxable_amt + ext_actual.
/*J2B5*/       end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH SFB_DET */
/*J2B5*/    end. /* IF SOD_FSM_TYPE = FSMRO_C ... */
/*J2B5*/    else

            if sod_taxable then do:
                taxable_amt = taxable_amt + ext_actual.
            line_taxable_amt = taxable_amt.
            end.
            else
                nontaxable_amt = nontaxable_amt + ext_actual.
        end.
/*GUI*/ if global-beam-me-up then undo, leave.


         if maint and not so__qadl01 then do:
            find cm_mstr where cm_addr = so_cust no-lock .
            if so_cust <> so_ship and
               can-find (cm_mstr where cm_mstr.cm_addr = so_ship) then
                  find cm_mstr where cm_mstr.cm_addr = so_ship no-lock.
/*L00Y*/    /* ADDED SECOND EXCHANGE RATE BELOW */
            {gprun.i ""sosd.p"" "(input so_ord_date,
                      input so_ex_rate,
                      input so_ex_rate2,
                      input so_cust,
                      input so_curr,
                      input line_total,
                      output disc_pct)"}
/*GUI*/ if global-beam-me-up then undo, leave.

           if disc_pct > cm_disc_pct and disc_pct <> 0 then
              so_disc_pct = disc_pct.
           else so_disc_pct = cm_disc_pct .
        end. /* IF MAINT AND NOT SO__QADL01 */

        /* CALCULATE DISCOUNT AMOUNT */
                disc_amt = (- line_total * (so_disc_pct / 100)).
                /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */

/*L024*         {gprun.i ""gpcurrnd.p"" "(input-output disc_amt, */
/*L024*               input rndmthd)"}                           */
/*L024*/        {gprunp.i "mcpl" "p" "mc-curr-rnd"
                   "(input-output disc_amt,
                     input rndmthd,
                     output mc-error-number)"}
/*L024*/        if mc-error-number <> 0 then do:
/*L024*/           {mfmsg.i mc-error-number 2}
/*L024*/        end.

                tmp_amt = taxable_amt * so_disc_pct / 100.
                /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */

/*L024*         {gprun.i ""gpcurrnd.p"" "(input-output tmp_amt, */
/*L024*               input rndmthd)"}                          */
/*L024*/        {gprunp.i "mcpl" "p" "mc-curr-rnd"
                   "(input-output tmp_amt,
                     input rndmthd,
                     output mc-error-number)"}
/*L024*/        if mc-error-number <> 0 then do:
/*L024*/           {mfmsg.i mc-error-number 2}
/*L024*/        end.

                taxable_amt = taxable_amt - tmp_amt.

                tmp_amt = nontaxable_amt * so_disc_pct / 100.
                /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */

/*L024*         {gprun.i ""gpcurrnd.p"" "(input-output tmp_amt, */
/*L024*               input rndmthd)"} */
/*L024*/        {gprunp.i "mcpl" "p" "mc-curr-rnd"
                   "(input-output tmp_amt,
                     input rndmthd,
                     output mc-error-number)"}
/*L024*/        if mc-error-number <> 0 then do:
/*L024*/           {mfmsg.i mc-error-number 2}
/*L024*/        end.

                nontaxable_amt = nontaxable_amt - tmp_amt.

        /* ADD TRAILER AMOUNTS */
        {txtrltrl.i so_trl1_cd so_trl1_amt user_desc[1]}
        {txtrltrl.i so_trl2_cd so_trl2_amt user_desc[2]}
        {txtrltrl.i so_trl3_cd so_trl3_amt user_desc[3]}

        /* CHECK PREVIOUS DETAIL FOR EDITED VALUES */
        find first tx2d_det where tx2d_ref = so_nbr      and
                      tx2d_nbr = so_quote    and
                      tx2d_tr_type = tax_tr_type and
                                          tx2d_edited
        no-lock no-error.
        if available(tx2d_det) then do:
            {mfmsg01.i 917 2 recalc}
        end.

        if maint and recalc then do:
            /* CALCULATE TAXES */
            /* NOTE nbr FIELD BLANK FOR SALES ORDERS */

              /* ADDED TWO PARAMETERS TO TXCALC.P, INPUT PARAMETER VQ-POST
 *               AND OUTPUT PARAMETER RESULT-STATUS. THE POST FLAG IS SET
 *               TO 'NO' BECAUSE WE ARE NOT CREATING QUANTUM REGISTER
 *               RECORDS FROM THIS CALL TO TXCALC.P */

/*L0SP*/   if not so_sched then
/*L0SP*/   do:
              {gprun.i ""txcalc.p""  "(input  tax_tr_type,
                                       input  so_nbr,
                                       input  tax_nbr,
                                       input  tax_lines /*ALL LINES*/,
                                       input no,
                                       output result-status)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*L0SP*/   end. /* IF NOT SO_SCHED */
        end. /* if maint */

/*J3DQ*/ /* PROCEDURE CALCULATES TOTAL TAXABLE AND  NONTAXABLE AMOUNT */
/*J3DQ*/ run p-tottax (input  tax_tr_type,
                       input  so_nbr,
                       input  tax_nbr,
                       input  tax_lines,
                       input-output taxable_amt,
                       input-output nontaxable_amt).

         {gprun.i ""txabsrb.p"" "(input so_nbr,
                      input so_quote,
                      input tax_tr_type,
                      input-output line_total,
                      input-output taxable_amt)"}
/*GUI*/ if global-beam-me-up then undo, leave.


        /* GET TAX TOTALS */
        {gprun.i ""txtotal.p"" "(input  tax_tr_type,
                     input  so_nbr,
                     input  tax_nbr,
                     input  tax_lines,       /* ALL LINES */
                     output tax_amt)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J38T*/ /* OBTAINING TOTAL INCLUDED TAX FOR THE TRANSACTION */
/*J38T*/ {gprun.i ""txtotal1.p"" "(input  tax_tr_type,
                                  input  so_nbr,
                                  input  tax_nbr,
                                  input  tax_lines,       /* ALL LINES */
                                  output l_tax_in)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J38T*/  /* ADJUSTING LINE TOTALS AND TOTAL TAX BY INCLUDED TAX */
/*J38T*/  assign
/*J38T*/     line_total       = line_total - l_tax_in
/*J3PZ** /*J38T*/ taxable_amt = taxable_amt - l_tax_in */
/*J38T*/     line_taxable_amt = taxable_amt
/*J38T*/     tax_amt          = tax_amt + l_tax_in.

        /* CALCULATE ORDER TOTAL */
            ord_amt =  line_total + disc_amt + so_trl1_amt
                   + so_trl2_amt + so_trl3_amt + tax_amt + total_pst.

        /* CHECK CREDIT AMOUNTS */
        if ord_amt < 0 then invcrdt = {&sosotrle_p_9}.
              else invcrdt = "".

        /* IF IN SO MAINT. THEN RECALCULATE TAXES AFTER EDITING */
        if maint then do:

     /* CHECK CREDIT LIMIT */
     /* If the bill-to customer's outstanding balance is already above   */
     /* His credit limit, then the order will have been put on hold in   */
     /* The header.  We check now because the subtotal of the order may  */
     /* Have put the customer over his credit limit and the user might   */
     /* F4 out of the trailer screen, bypassing the check done after     */
     /* The trailer amounts have been entered.  It hardly seems worth    */
     /* Mentioning that the customer's balance plus this order might be  */
     /* Above his credit limit now, but judicious use of order discounts */
     /* And negative trailer amounts might bring the total back down     */
     /* Below the credit limit.  Better safe than sorry, I always say.   */
     /* Note that we don't bother checking if we're not going to put the */
     /* Order on hold, since this could just produce a lot of messages   */
     /* That the user is probably ignoring anyway.                       */
            if so_stat = ""
            and soc_cr_hold then do:
               find cm_mstr where cm_addr = so_bill no-lock.
               base_amt = ord_amt.
               if so_curr <> base_curr then
                       do:
                          /* CONVERT TO BASE CURRENCY */

/*L024*                   base_amt = base_amt / so_ex_rate. */
/*L024*/                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                             "(input so_curr,
                               input base_curr,
                               input so_ex_rate,
                               input so_ex_rate2,
                               input base_amt,
                               input true,
                               output base_amt,
                               output mc-error-number)"}
/*L024*/                  if mc-error-number <> 0 then do:
/*L024*/                     {mfmsg.i mc-error-number 2}
/*L024*/                  end.

                          /* ROUND PER BASE CURRENCY ROUND METHOD */

/*L024*                   {gprun.i ""gpcurrnd.p"" "(input-output base_amt, */
/*L024*                      input gl_rnd_mthd)"} */

                       end.

         /* NOTE: DO NOT PUT CALL REPAIR ORDERS (FSM-RO) ON HOLD - BECAUSE */
         /*    THESE ORDERS WILL NOT BE SHIPPING ANYTHING, ONLY INVOICING  */
         /*    FOR WORK ALREADY DONE.                                      */

/*J3B4*/ /* NOTE: ALSO DO NOT PUT RMA ORDERS (RMA) ON HOLD - BECAUSE THESE */
/*J3B4*/ /*    ORDERS WILL BE CHECKED FOR CREDIT LIMIT AND PUT ON HOLD IN  */
/*J3B4*/ /*    THE PROGRAM FSRMAMTU.P DEPENDING ON THE SERVICE LEVEL FLAG  */
/*J3B4*/ /*    (SVC_HOLD_CALL)                                             */

               if cm_cr_limit < (cm_balance + base_amt)
                       and so_fsm_type <> "FSM-RO"
/*J3B4*/               and so_fsm_type <> "RMA"
               then do:
              /* Sales Order placed on credit hold */
              credit_hold = true.
              so_stat = "HD".
              display so_stat with frame d.
                          {mfmsg02.i 616 2
                  "cm_balance + base_amt,"balance_fmt" "}
                          {mfmsg02.i 617 1 "cm_cr_limit,"limit_fmt" "}
              {mfmsg03.i 690 1 ""{&sosotrle_p_1}"" """" """" }
               end.
            end.

/*M14W**    {sototdsp.i} /* DISPLAY ALL FIELDS */ */
/*M14W*/    run so_tot_dsp. /* DISPLAY ALL FIELDS */

                    trlloop:
                    do on error undo, retry
                       on endkey undo taxloop, leave:
/*GUI*/ if global-beam-me-up then undo, leave.


                  /* STORING THE DEFAULT VOLUME DISCOUNT PERCENTAGE */
                  assign disc_pct = so_disc_pct .
                       set
                  so_disc_pct so_trl1_cd so_trl1_amt so_trl2_cd
                  so_trl2_amt so_trl3_cd so_trl3_amt tax_edit
                  with frame sotot.

               /* CHECKING WHETHER VOLUME DISCOUNT IS MANUALLY ENTERED ? */
                  if so_disc_pct <> disc_pct  then
                     so__qadl01 = yes .

                       {txedttrl.i &code  = "so_trl1_cd"
                   &amt   = "so_trl1_amt"
                   &desc  = "user_desc[1]"
                   &frame = "sotot"
                   &loop  = "trlloop"}

                       /* VALIDATE TRAILER AMOUNT BASE ON ROUNDING METHOD */
                       if (so_trl1_amt <> 0) then do:
                           {gprun.i ""gpcurval.p"" "(input so_trl1_amt,
                            input rndmthd,
                            output retval)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                          if (retval <> 0) then do:
                             next-prompt so_trl1_amt with frame sotot.
                             undo trlloop, retry.
                          end.
                       end.

                       {txedttrl.i &code  = "so_trl2_cd"
                   &amt   = "so_trl2_amt"
                   &desc  = "user_desc[2]"
                   &frame = "sotot"
                   &loop  = "trlloop"}

                       /* VALIDATE TRAILER AMOUNT BASE ON ROUNDING METHOD */
                       if (so_trl2_amt <> 0) then do:
                          {gprun.i ""gpcurval.p"" "(input so_trl2_amt,
                            input rndmthd,
                            output retval)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                          if (retval <> 0) then do:
                             next-prompt so_trl2_amt with frame sotot.
                             undo trlloop, retry.
                          end.
                       end.

                       {txedttrl.i &code  = "so_trl3_cd"
                   &amt   = "so_trl3_amt"
                   &desc  = "user_desc[3]"
                   &frame = "sotot"
                   &loop  = "trlloop"}

                       /* VALIDATE TRAILER AMOUNT BASE ON ROUNDING METHOD */
                       if (so_trl3_amt <> 0) then do:
                          {gprun.i ""gpcurval.p"" "(input so_trl3_amt,
                            input rndmthd,
                            output retval)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                          if (retval <> 0) then do:
                             next-prompt so_trl3_amt with frame sotot.
                             undo trlloop, retry.
                          end.
                       end.
                    end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* TRLLOOP: DO ON ERROR UNDO, RETRY */

            /*** RECALCULATE TOTALS FOR LINES ***/
            line_total = 0.
            taxable_amt = 0.
            nontaxable_amt = 0.

            /* ACCUMULATE LINE AMOUNTS */
            for each sod_det where sod_nbr = so_nbr:
/*GUI*/ if global-beam-me-up then undo, leave.

                        ext_actual = (sod_price * (sod_qty_ord - sod_qty_ship)).
                        /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */

/*L024*                 {gprun.i ""gpcurrnd.p"" "(input-output ext_actual, */
/*L024*                                  input rndmthd)"} */
/*L024*/                {gprunp.i "mcpl" "p" "mc-curr-rnd"
                           "(input-output ext_actual,
                             input rndmthd,
                             output mc-error-number)"}
/*L024*/                if mc-error-number <> 0 then do:
/*L024*/                   {mfmsg.i mc-error-number 2}
/*L024*/                end.

                line_total = line_total + ext_actual.

/*J2B5*/        /* FOR CALL INVOICES, SFB_TAXABLE (IN 86) OF SFB_DET         */
/*J2B5*/        /* DETERMINES TAXABILITY AND THERE COULD BE MULTIPLE SFB_DET */
/*J2B5*/        /* FOR A SOD_DET.                                            */

/*J2B5*/        if sod_fsm_type = fsmro_c and sod_taxable then do:
/*J2B5*/           for each sfb_det no-lock where sfb_nbr = sod_nbr and
/*J2B5*/              sfb_so_line = sod_line:
/*GUI*/ if global-beam-me-up then undo, leave.

/*J2B5*/              ext_actual = sfb_price * sfb_qty_req.
/*J2B5*/              /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */

/*L024* /*J2B5*/      {gprun.i ""gpcurrnd.p"" "(input-output ext_actual, */
/*L024*                                         input rndmthd)"} */
/*L024*/              {gprunp.i "mcpl" "p" "mc-curr-rnd"
                         "(input-output ext_actual,
                           input rndmthd,
                           output mc-error-number)"}
/*L024*/              if mc-error-number <> 0 then do:
/*L024*/                 {mfmsg.i mc-error-number 2}
/*L024*/              end.

/*J2B5*/              if sfb_taxable then
/*J2B5*/                 assign taxable_amt      = taxable_amt + ext_actual
/*J2B5*/                        line_taxable_amt = taxable_amt.
/*J2B5*/              else
/*J2B5*/                 nontaxable_amt = nontaxable_amt + ext_actual.
/*J2B5*/           end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH SFB_DET */
/*J2B5*/        end. /* IF SOD_FSM_TYPE = FSMRO_C ... */
/*J2B5*/        else

                if sod_taxable then do:
                            taxable_amt = taxable_amt + ext_actual.
                line_taxable_amt = taxable_amt.
            end.
            else
                   nontaxable_amt = nontaxable_amt + ext_actual.
            end.
/*GUI*/ if global-beam-me-up then undo, leave.


            /* CALCULATE DISCOUNT */
                    disc_amt = (- line_total * (so_disc_pct / 100)).
                    /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */

/*L024*             {gprun.i ""gpcurrnd.p"" "(input-output disc_amt, */
/*L024*                   input rndmthd)"} */
/*L024*/            {gprunp.i "mcpl" "p" "mc-curr-rnd"
                       "(input-output disc_amt,
                         input rndmthd,
                         output mc-error-number)"}
/*L024*/            if mc-error-number <> 0 then do:
/*L024*/               {mfmsg.i mc-error-number 2}
/*L024*/            end.

                    tmp_amt = taxable_amt * so_disc_pct / 100.
                    /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */

/*L024*             {gprun.i ""gpcurrnd.p"" "(input-output tmp_amt, */
/*L024*                   input rndmthd)"} */
/*L024*/            {gprunp.i "mcpl" "p" "mc-curr-rnd"
                       "(input-output tmp_amt,
                         input rndmthd,
                         output mc-error-number)"}
/*L024*/            if mc-error-number <> 0 then do:
/*L024*/               {mfmsg.i mc-error-number 2}
/*L024*/            end.

                    taxable_amt = taxable_amt - tmp_amt.

                    tmp_amt = nontaxable_amt * so_disc_pct / 100.
                    /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */

/*L024*             {gprun.i ""gpcurrnd.p"" "(input-output tmp_amt, */
/*L024*                   input rndmthd)"} */
/*L024*/            {gprunp.i "mcpl" "p" "mc-curr-rnd"
                       "(input-output tmp_amt,
                         input rndmthd,
                         output mc-error-number)"}
/*L024*/            if mc-error-number <> 0 then do:
/*L024*/               {mfmsg.i mc-error-number 2}
/*L024*/            end.

                    nontaxable_amt = nontaxable_amt - tmp_amt.

            /* ADD TRAILER AMOUNTS */
            {txtrltrl.i so_trl1_cd so_trl1_amt user_desc[1]}
            {txtrltrl.i so_trl2_cd so_trl2_amt user_desc[2]}
            {txtrltrl.i so_trl3_cd so_trl3_amt user_desc[3]}

            /****** CALCULATE TAXES ************/
            if recalc then do:
              /* ADDED TWO PARAMETERS TO TXCALC.P, INPUT PARAMETER VQ-POST
 *               AND OUTPUT PARAMETER RESULT-STATUS. THE POST FLAG IS SET
 *               TO 'NO' BECAUSE WE ARE NOT CREATING QUANTUM REGISTER
 *               RECORDS FROM THIS CALL TO TXCALC.P */

/*L0SP*/       if not so_sched then
/*L0SP*/       do:
                  {gprun.i ""txcalc.p""  "(input  tax_tr_type,
                                           input  so_nbr,
                                           input  tax_nbr,
                                           input  tax_lines,  /*ALL LINES*/
                                           input  no,
                                           output result-status)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*L0SP*/       end. /* IF NOT SO_SCHED THEN */
            end.

/*J3DQ*/ /* PROCEDURE CALCULATES TOTAL TAXABLE AND  NONTAXABLE AMOUNT */
/*J3DQ*/ run p-tottax (input  tax_tr_type,
                       input  so_nbr,
                       input  tax_nbr,
                       input  tax_lines,
                       input-output taxable_amt,
                       input-output nontaxable_amt).

         {gprun.i ""txabsrb.p"" "(input so_nbr,
                      input so_quote,
                      input tax_tr_type,
                      input-output line_total,
                      input-output taxable_amt)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            /* DO TAX DETAIL DISPLAY / EDIT HERE */
            if tax_edit then do:
            hide frame sotot no-pause.
            hide frame d no-pause.
            {gprun.i ""txedit.p""  "(input  tax_tr_type,
                         input  so_nbr,
                         input  tax_nbr,
                         input  tax_lines, /*ALL LINES*/
                         input  so_tax_env,
                         output tax_amt)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            view frame sotot.
     /*V8+*/
            end.

            /* CALCULATE TOTALS */
            {gprun.i ""txtotal.p"" "(input  tax_tr_type,
                         input  so_nbr,
                         input  tax_nbr,
                         input  tax_lines,   /* ALL LINES */
                         output tax_amt)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J38T*/    /* OBTAINING TOTAL INCLUDED TAX FOR THE TRANSACTION */
/*J38T*/    {gprun.i ""txtotal1.p"" "(input  tax_tr_type,
                                     input  so_nbr,
                                     input  tax_nbr,
                                     input  tax_lines,       /* ALL LINES */
                                     output l_tax_in)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J38T*/    /* ADJUSTING LINE TOTALS AND TOTAL TAX BY INCLUDED TAX */
/*J38T*/    assign
/*J38T*/       line_total       = line_total - l_tax_in
/*J3PZ** /*J38T*/ taxable_amt   = taxable_amt - l_tax_in */
/*J38T*/       line_taxable_amt = taxable_amt
/*J38T*/       tax_amt          = tax_amt + l_tax_in.

                ord_amt =  line_total + disc_amt + so_trl1_amt
                       + so_trl2_amt + so_trl3_amt + tax_amt + total_pst.

            if ord_amt < 0 then invcrdt = {&sosotrle_p_9}.
              else invcrdt = "".
        end. /* IF MAINT */

        if display_trail then do:
/*M14W**   {sototdsp.i} /* DISPLAY ALL FIELDS */ */
/*M14W*/   run so_tot_dsp. /* DISPLAY ALL FIELDS */
        end.

        undo_trl2 = false.

        end. /* taxloop*/

        /* Warn user now if order had been put on credit hold */
        if maint and credit_hold then do:
        so_stat = "HD".
        end.

/*J3DQ*/ /* PROCEDURE CALCULATES TOTAL TAXABLE AND  NONTAXABLE AMOUNT */
/*J3DQ*/ {txtotal.i}

/*M14W*/ /* PROCEDURE so_tot_dsp IS INTRODUCED AS PROGRESS GETS       */
/*M14W*/ /* CONFUSED BETWEEN TWO FRAMES WITH SAME FIELD IN sototdsp.i */
/*M14W*/ /* AND ALLOWED UNAUTORIZED USER TO UPDATE so_disc_pct FIELD. */
/*M14W*/ PROCEDURE so_tot_dsp:
            {sototdsp.i}.
/*M14W*/ END PROCEDURE. /* PROCEDURE so_tot_dsp */
