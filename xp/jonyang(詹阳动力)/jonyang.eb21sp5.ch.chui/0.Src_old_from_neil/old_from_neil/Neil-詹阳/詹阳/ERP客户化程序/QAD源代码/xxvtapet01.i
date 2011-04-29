/* GUI CONVERTED from vtapet01.i (converter v1.71) Thu Oct  8 11:27:40 1998 */
/* vtapet01.i - AP VAT BY TRANSACTION REPORT                              */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.   */
/*V8:ConvertMode=FullGUIReport                                            */
/* *L00S*   COPIED FROM vtaprp01.i  ***rup***                             */
/* REVISION: 6.0      LAST MODIFIED: 12/04/90   BY: MLB *D238*            */
/* REVISION: 7.0      LAST MODIFIED: 08/23/91   BY: MLV *F002*            */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: tmd *F357*            */
/* Revision: 7.3      LAST MODIFIED: 11/19/92   BY: jcd *G349*            */
/* REVISION: 7.3      LAST MODIFIED: 03/01/93   BY: bcm *G763*            */
/*                                   04/15/93   BY: bcm *G958*            */
/*                                   11/02/94   BY: ame *FT22*            */
/*                                   04/10/96   BY: jzw *G1LD*            */
/* Revision: 8.6        Last edit: 10/13/97     BY: gyk *K0WM*            */
/* REVISION: 8.6E     CREATED      : 04/97/98   BY: EMS *L00S*            */
/* REVISION: 8.6E     LAST MODIFIED: 06/24/98   BY: *L01G* Robin McCarthy */
/* REVISION: 8.6E     LAST MODIFIED: 07/11/98   BY: *L02S* Jim Josey      */
/* Old ECO marker removed, but no ECO exists        *F0PN*                */
/* Old ECO marker removed, but no ECO exists        *L017*                */
/* REVISION: 8.6E     LAST MODIFIED: 08/20/98   BY: *L06L* Jean Miller    */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt      */
/* REVISION: 8.6E     LAST MODIFIED: 10/07/98   BY: *L0B9* Brenda Milton  */

/**************************************************************************/

/* ********** Begin Translatable Strings Definitions ********* */


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

&SCOPED-DEFINE vtapet01_i_1 "打印已确认的凭证"
/* MaxLen: Comment: */

&SCOPED-DEFINE vtapet01_i_2 "   生效日期: "
/* MaxLen: Comment: */

&SCOPED-DEFINE vtapet01_i_3 "打印未确认的"
/* MaxLen: Comment: */

&SCOPED-DEFINE vtapet01_i_4 "  合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE vtapet01_i_5 " 比率: "
/* MaxLen: Comment: */

&SCOPED-DEFINE vtapet01_i_6 " G/L Acct/CC: "
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         define new shared variable show_unconf like mfc_logical
/*L06L*     label "Print Unconfirmed". */
/*L06L*/    label {&vtapet01_i_3}.
         define new shared variable show_conf like mfc_logical
/*L06L*     label "Print Confirmed" */
/*L06L*/    label {&vtapet01_i_1}
            initial yes.

         /* ***** GET EURO VARIABLES ***** */
         {etrpvar.i &new = "new"}
         {etvar.i   &new = "new"}

         /* ***** GET EURO INFORMATION ***** */
         {eteuro.i}

         define new shared variable et_tot_base_amt like tot_base_amt no-undo.
         define new shared variable et_tot_vat_amt  like tot_vat_amt  no-undo.

         define            variable et_conv_amt     like tot_base_amt no-undo.
         define            variable et_conv_vat     like tot_vat_amt  no-undo.

/*L02S*/ {gprunpdf.i "mcpl" "p"}
/*L02S*/ {gprunpdf.i "mcui" "p"}

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
						vat            colon 15
            vat1           label {t001.i} colon 49 skip
            batch          colon 15
            batch1         label {t001.i} colon 49 skip
            ref            colon 15
            ref1           label {t001.i} colon 49 skip
            vend           colon 15
            vend1          label {t001.i} colon 49 skip
            apdate         colon 15
            apdate1        label {t001.i} colon 49
            effdate        colon 15
            effdate1       label {t001.i} colon 49
            taxdate        colon 15
            taxdate1       label {t001.i} colon 49 skip (1)
            show_conf      colon 25
            show_unconf    colon 25
            base_rpt       colon 25
/*L02S*/    et_report_curr colon 25
            skip (1)
/*L02S*     et_report_txt  no-label to 25          */
/*L02S*     et_report_curr no-label                */
/*L02S*     et_rate_txt    no-label to 25          */
/*L02S*     et_report_rate no-label       skip (1) */
          SKIP(.4)  /*GUI*/
with frame a side-labels attr-space
         width 80.

setFrameLabels(frame a:handle).

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



         FORM /*GUI*/  header
/*L02S*     et_report_txt to 63 et_disp_curr */
/*L02S*/    mc-curr-label at 1
/*L02S*/    et_report_curr
/*L02S*/    skip
/*L02S*/    mc-exch-label at 1
/*L02S*/    mc-exch-line1
/*L02S*/    skip
/*L02S*/    mc-exch-line2 at 23
/*L02S*/    skip
         with STREAM-IO /*GUI*/  frame phead1 no-labels page-top width 80.

         find first gl_ctrl no-lock.

         {wbrp01.i}
         

            if vat1     = hi_char  then vat1     = "".
            if batch1   = hi_char  then batch1   = "".
            if ref1     = hi_char  then ref1     = "".
            if vend1    = hi_char  then vend1    = "".
            if apdate   = low_date then apdate   = ?.
            if apdate1  = hi_date  then apdate1  = ?.
            if effdate  = low_date then effdate  = ?.
            if effdate1 = hi_date  then effdate1 = ?.
            if taxdate  = low_date then taxdate  = ?.
            if taxdate1 = hi_date  then taxdate1 = ?.

/*L01G*     display                              */
/*L01G*        et_report_txt when (et_tk_active) */
/*L01G*        et_rate_txt when (et_tk_active)   */
/*L01G*     with frame a.                        */



            update      vat
                        vat1
                        batch
                        batch1
                        ref
                        ref1
                        vend
                        vend1
                        apdate
                        apdate1
                        effdate
                        effdate1
                        taxdate
                        taxdate1
                        show_conf
                        show_unconf
                        base_rpt
                        et_report_curr 
                        with frame a.

            if (c-application-mode <> "WEB":U) or
               (c-application-mode = "WEB":U and
               (c-web-request begins "DATA":U)) then do:

               bcdparm = "".
               {mfquoter.i vat    }
               {mfquoter.i vat1   }
               {mfquoter.i batch  }
               {mfquoter.i batch1 }
               {mfquoter.i ref    }
               {mfquoter.i ref1   }
               {mfquoter.i vend   }
               {mfquoter.i vend1  }
               {mfquoter.i apdate }
               {mfquoter.i apdate1}
               {mfquoter.i effdate}
               {mfquoter.i effdate1}
               {mfquoter.i taxdate}
               {mfquoter.i taxdate1}
               {mfquoter.i show_conf  }
               {mfquoter.i show_unconf}
               {mfquoter.i base_rpt}
/*L01G*        if et_tk_active then do: */
               {mfquoter.i et_report_curr}
/*L02S*        {mfquoter.i et_report_rate} */
/*L01G*        end. */

               if vat1     = "" then vat1     = hi_char.
               if batch1   = "" then batch1   = hi_char.
               if ref1     = "" then ref1     = hi_char.
               if vend1    = "" then vend1    = hi_char.
               if apdate   = ?  then apdate   = low_date.
               if apdate1  = ?  then apdate1  = hi_date.
               if effdate  = ?  then effdate  = low_date.
               if effdate1 = ?  then effdate1 = hi_date.
               if taxdate  = ?  then taxdate  = low_date.
               if taxdate1 = ?  then taxdate1 = hi_date.

               /* ***** CURRENCY VALIDATION ***** */
/*L02S*        {etcurval.i &curr     = "et_report_curr" */
/*L02S*                 &errlevel = 4                */
/*L02S*                 &prompt   = "next-prompt et_report_curr with frame a" */
/*L02S*                 &action   = "undo, retry"}   */

               /* ***** GET EXCHANGE RATE ***** */
               assign et_eff_date    = today.

               /* ***** DEFINE FIXED EXCHANGE RATE ***** */
/*L02S*        {gprun.i ""etrate.p"" "(input base_rpt)"} */

/*L02S*/       if base_rpt = "" then
/*L02S*/          mc_rpt_curr = base_curr.
/*L02S*/       else
/*L02S*/          mc_rpt_curr = base_rpt.

/*L02S*/       if et_report_curr <> "" then do:
/*L02S*/          {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
                   "(input et_report_curr,
                     output mc-error-number)"}
/*L02S*/          if mc-error-number = 0
/*L02S*/          and et_report_curr <> mc_rpt_curr then do:
/*L08W*              CURRENCIES AND RATES REVERSED BELOW...             */
/*L02S*/             {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                      "(input et_report_curr,
                        input mc_rpt_curr,
                        input "" "",
                        input et_eff_date,
                        output et_rate2,
                        output et_rate1,
                        output mc-seq,
                        output mc-error-number)"}
/*L02S*/          end.  /* if mc-error-number = 0 */

/*L02S*/          if mc-error-number <> 0 then do:
/*L02S*/             {mfmsg.i mc-error-number 3}
/*L02S*/             if c-application-mode = "WEB":U then return.
/*L02S*/             else /*GUI NEXT-PROMPT removed */
/*L02S*/             /*GUI UNDO removed */ RETURN ERROR.
/*L02S*/          end.  /* if mc-error-number <> 0 */
/*L02S*/          else do:
/*L08W*              CURRENCIES AND RATES REVERSED BELOW...             */
/*L02S*/             {gprunp.i "mcui" "p" "mc-ex-rate-output"
                      "(input et_report_curr,
                        input mc_rpt_curr,
                        input et_rate2,
                        input et_rate1,
                        input mc-seq,
                        output mc-exch-line1,
                        output mc-exch-line2)"}
/*L02S*/             {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                      "(input mc-seq)"}
/*L02S*/          end.
/*L02S*/       end.  /* if et_report_curr <> "" */
/*L02S*/       if et_report_curr = ""
/*L02S*/        or et_report_curr = mc_rpt_curr then assign
/*L02S*/          mc-exch-line1 = ""
/*L02S*/          mc-exch-line2 = ""
/*L02S*/          et_report_curr = mc_rpt_curr.

            end. /* C-APPLICATION-MODE <> WEB */

            /* SELECT PRINTER */
            					{mfselbpr.i "printer" 132}
            
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:
					find first gl_ctrl no-lock.



            {mfphead2.i}
/*L01G*     if et_tk_active then */
/*L01G*/    view frame phead1.

            assign
/*L0B9*        tot_base_amt    = 0 */
/*L0B9*        tot_vat_amt     = 0 */
               et_tot_base_amt = 0
               et_tot_vat_amt  = 0
               tot_base_amt    = 0
               tot_vat_amt     = 0.

            for each vt_mstr where vt_class >= vat
            and vt_class <= vat1 no-lock:

               
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/


               put skip(1)
                   vat_label
/*L06L*            vt_class format "x(1)"  "  Start Eff: "          */
/*L06L*            vt_start " Rate: " vt_tax_pct " G/L Acct/cc: "   */
/*L06L*/           vt_class format "x(1)"  {&vtapet01_i_2}
/*L06L*/           vt_start {&vtapet01_i_5} vt_tax_pct {&vtapet01_i_6}
                   vt_ap_acct vt_ap_cc skip(1).

               vt_recno = recid(vt_mstr).


               if gl_can then do:
                  {gprun.i ""xxctaprp1a.p""}
               end.
               else do:
                  {gprun.i ""xxvtaprp1a.p""}
               end.

            end.

            put skip "----------------" to 76 "----------------" to 99
/*L02S*         et_disp_curr +  " Total:" */
/*L06L* /*L02S*/et_report_curr +  " Total:" */
/*L06L*/        et_report_curr +  {&vtapet01_i_4}
                to 70 format "x(15)"

                et_tot_base_amt to 76 format "->>>>,>>>,>>9.99"
                et_tot_vat_amt  to 99 format "->>>>,>>>,>>9.99" skip.

/*L02S*     assign et_tr_curr = " ". */
/*L02S*     {etrpconv.i tot_base_amt et_conv_amt} */
/*L02S*/    if et_report_curr <> mc_rpt_curr then do:
/*L02S*/       {gprunp.i "mcpl" "p" "mc-curr-conv"
                 "(input mc_rpt_curr,
                   input et_report_curr,
                   input et_rate1,
                   input et_rate2,
                   input tot_base_amt,
                   input true, /* ROUND */
                   output et_conv_amt,
                   output mc-error-number)"}
/*L02S*/       if mc-error-number <> 0 then do:
/*L02S*/          {mfmsg.i mc-error-number 2}
/*L02S*/       end.

/*L02S*        {etrpconv.i tot_vat_amt  et_conv_vat} */
/*L02S*/       {gprunp.i "mcpl" "p" "mc-curr-conv"
                 "(input mc_rpt_curr,
                   input et_report_curr,
                   input et_rate1,
                   input et_rate2,
                   input tot_vat_amt,
                   input true, /* ROUND */
                   output et_conv_vat,
                   output mc-error-number)"}
/*L02S*/       if mc-error-number <> 0 then do:
/*L02S*/          {mfmsg.i mc-error-number 2}
/*L02S*/       end.
/*L02S*/    end.  /* if et_report_curr <> mc_rpt_curr */
/*L02S*/    else assign
/*L02S*/       et_conv_vat = tot_vat_amt
/*L02S*/       et_conv_amt = tot_base_amt.

/*L01G*     if et_show_diff and */
/*L01G*/    if et_ctrl.et_show_diff and
            et_report_curr <> "" and
            (et_conv_amt <> et_tot_base_amt) or
            (et_conv_vat <> et_tot_vat_amt)
            then do: /* CONVERTED TOTALS DON'T MATCH */
/*L0B9*        put et_diff_txt    to  79 format "x(25)" */
/*L0B9*/       put (et_diff_txt + ":") format "x(26)" to 78
                   (et_conv_amt - et_tot_base_amt)
                   to  96 format "->>>>,>>>,>>9.99"
                   (et_conv_vat - et_tot_vat_amt)
                   to 122 format "->>>>,>>>,>>9.99" skip.
            end. /* CONVERTED TOTALS DON'T MATCH */

            /*DISPLAY SUMMARY BY VAT*/
            for each vtw_wkfl exclusive-lock by vtw_class by vtw_start:
               
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

               find vt_mstr where vt_class = vtw_class and vt_start = vtw_start
               no-lock.
               accumulate vtw_amt(total).
               display vtw_class vtw_start
                  vt_tax_pct space (4)
                  vt_ap_acct
                  vt_ap_cc no-label
                  vtw_amt with frame c STREAM-IO /*GUI*/ .
               down 1 with frame c.
               delete vtw_wkfl.
            end.
            underline vtw_amt with frame c.
            display

/*L02S*        et_disp_curr + " Total:" */
/*L06L* /*L02S*/    et_report_curr +  " Total:" */
/*L06L*/       et_report_curr +  {&vtapet01_i_4}
               format "x(15)" @ vt_ap_acct
               accum total vtw_amt format "->>>>,>>>,>>9.99" @ vtw_amt
            with frame c STREAM-IO /*GUI*/ .

            hide frame phead1.
            /* REPORT TRAILER */
            
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


         end. /* REPEAT */

         {wbrp04.i &frame-spec = a}
