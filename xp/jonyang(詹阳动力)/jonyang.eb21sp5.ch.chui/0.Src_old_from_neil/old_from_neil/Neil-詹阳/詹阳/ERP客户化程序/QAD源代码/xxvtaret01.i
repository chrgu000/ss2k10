/* GUI CONVERTED from vtaret01.i (converter v1.71) Thu Oct  1 14:20:59 1998 */
/* vtaret01.i - VAT AND GST REPORT BY VAT CLASS                           */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.   */
/*V8:ConvertMode=FullGUIReport                                            */
/*          COPIED FROM vtarrp01.i  ***rup***                             */
/* REVISION: 6.0      LAST MODIFIED: 12/03/90   BY: MLB *D238*            */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: tmd *F357*            */
/* REVISION: 7.0      LAST MODIFIED: 11/02/94   BY: ame *FT22*            */
/* REVISION: 7.3      LAST MODIFIED: 04/10/96   BY: jzw *G1P6*            */
/* REVISION: 8.6      LAST MODIFIED: 10/13/97   BY: bvm *K0VM*            */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: EMS *L00S*            */
/* REVISION: 8.6E     LAST MODIFIED: 06/24/98   BY: *L01G* Robin McCarthy */
/* REVISION: 8.6E     LAST MODIFIED: 07/11/98   BY: *L02S* Jim Josey      */
/* Old ECO marker removed, but no ECO exists        *F0PN*                */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt      */
/**************************************************************************/

/* ********** Begin Translatable Strings Definitions ********* */


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

&SCOPED-DEFINE vtaret01_i_1 " G/L Acct/CC: "
/* MaxLen: Comment: */

&SCOPED-DEFINE vtaret01_i_2 " 比率: "
/* MaxLen: Comment: */

&SCOPED-DEFINE vtaret01_i_3 "  合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE vtaret01_i_4 "     报表合计:"
/* MaxLen: Comment: */

&SCOPED-DEFINE vtaret01_i_5 "   生效日期: "
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         /* ***** DEFINE EURO TOOLKIT VARIABLES ***** */
         {etrpvar.i &new = "new"}
         {etvar.i   &new = "new"}
         /* GET EURO INFORMATION */
         {eteuro.i}

/*L02S*  define         variable et_select_curr  like exd_curr   no-undo. */

         define new shared variable et_tot_base_amt like tot_base_amt no-undo.
         define new shared variable et_tot_vat_amt  like tot_vat_amt  no-undo.
         define            variable et_conv_amt     like tot_base_amt no-undo.
         define            variable et_conv_vat     like tot_vat_amt  no-undo.

/*L02S*/ {gprunpdf.i "mcpl" "p"}
/*L02S*/ {gprunpdf.i "mcui" "p"}

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
						vat            colon 16
            vat1           label {t001.i} colon 49 skip
            nbr            colon 16
            nbr1           label {t001.i} colon 49 skip
            batch          colon 16
            batch1         label {t001.i} colon 49 skip
            cust           colon 16
            cust1          label {t001.i} colon 49 skip
            ardate         colon 16
            ardate1        label {t001.i} colon 49 skip
            effdate        colon 16
            effdate1       label {t001.i} colon 49 skip
            taxdate  colon 16
            taxdate1 label {t001.i} colon 49 skip
            base_rpt       colon 16 skip (1)
/*L02S*/    et_report_curr colon 49
/*L02S*     et_report_txt  to 20 no-label          */
/*L02S*     et_report_curr at 22 no-label skip     */
/*L02S*     et_rate_txt    to 20 no-label          */
/*L02S*     et_report_rate at 22 no-label skip (1) */
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80.

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



         FORM /*GUI*/  header
/*L02S* *L00S*    et_report_txt to 63 et_disp_curr */
/*L02S*/     mc-curr-label at 1
/*L02S*/     et_report_curr
/*L02S*/     skip
/*L02S*/     mc-exch-label at 1
/*L02S*/     mc-exch-line1
/*L02S*/     skip
/*L02S*/     mc-exch-line2 at 23
/*L02S*/     skip
         with STREAM-IO /*GUI*/  frame phead1 no-labels page-top width 80.

         find first gl_ctrl no-lock.

         {wbrp01.i}

            if vat1     = hi_char  then vat1     = "".
            if batch1   = hi_char  then batch1   = "".
            if nbr1     = hi_char  then nbr1     = "".
            if cust1    = hi_char  then cust1    = "".
            if ardate   = low_date then ardate   = ?.
            if ardate1  = hi_date  then ardate1  = ?.
            if effdate  = low_date then effdate  = ?.
            if effdate1 = hi_date  then effdate1 = ?.
            if taxdate  = low_date then taxdate  = ?.
            if taxdate1 = hi_date  then taxdate1 = ?.

/*L01G*     display et_report_txt when (et_tk_active)       */
/*L01G*             et_rate_txt   when (et_tk_active) with frame a. */


           update
              vat
              vat1
              nbr
              nbr1
              batch
              batch1
              cust
              cust1
              ardate
              ardate1
              effdate
              effdate1
              taxdate
              taxdate1
              base_rpt
              et_report_curr
/*L02S*       et_report_rate */
              with frame a.

            if (c-application-mode <> "WEB":U) or
               (c-application-mode = "WEB":U and
               (c-web-request begins "DATA":U)) then do:

               bcdparm = "".
               {mfquoter.i vat     }
               {mfquoter.i vat1    }
               {mfquoter.i nbr     }
               {mfquoter.i nbr1    }
               {mfquoter.i batch   }
               {mfquoter.i batch1  }
               {mfquoter.i cust    }
               {mfquoter.i cust1   }
               {mfquoter.i ardate  }
               {mfquoter.i ardate1 }
               {mfquoter.i effdate  }
               {mfquoter.i effdate1 }
               {mfquoter.i taxdate  }
               {mfquoter.i taxdate1 }
               {mfquoter.i base_rpt}
/*L01G*              if et_tk_active then do: */
               {mfquoter.i et_report_curr}
/*L02S*              {mfquoter.i et_report_rate} */
/*L01G*              end. /* if et_tk_active then do: */ */

               if vat1     = "" then vat1     = hi_char.
               if batch1   = "" then batch1   = hi_char.
               if nbr1     = "" then nbr1     = hi_char.
               if cust1    = "" then cust1    = hi_char.
               if ardate   = ?  then ardate   = low_date.
               if ardate1  = ?  then ardate1  = hi_date.
               if effdate  = ?  then effdate  = low_date.
               if effdate1 = ?  then effdate1 = hi_date.
               if taxdate  = ?  then taxdate  = low_date.
               if taxdate1 = ?  then taxdate1 = hi_date.

/*L02S*/       if base_rpt = "" then
/*L02S*/          mc_rpt_curr = base_curr.
/*L02S*/       else
/*L02S*/          mc_rpt_curr = base_rpt.

               /* ***** VALIDATION OF CURRENCY ***** */
/*L02S*        {etcurval.i &curr     = "et_report_curr" */
/*L02S*                 &errlevel = 4                */
/*L02S*                 &prompt   = "next-prompt et_report_curr with frame a" */
/*L02S*                 &action   = "undo, retry"}   */

               /* ***** GET EXCHANGE RATE  ***** */
               assign et_eff_date    = today.

/*L02S*        {gprun.i ""etrate.p"" "(input base_rpt)"} */

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

/*L01G*     if et_tk_active and et_report_curr <> "" */
/*L02S* *L01G*    if et_report_curr <> "" */
/*L01G*     then view frame phead1. */
/*L02S*/    view frame phead1.

            assign
               tot_base_amt    = 0
               tot_vat_amt     = 0
               et_tot_base_amt = 0
               et_tot_vat_amt  = 0.

            for each vt_mstr where vt_class >= vat
                               and vt_class <= vat1 no-lock:

               put skip(1)
                  vat_label
/*L06L*           vt_class format "x(2)"  "  Start Eff: "         */
/*L06L*           vt_start " Rate: " vt_tax_pct " G/L Acct/cc: "  */
/*L06L*/          vt_class format "x(2)"  {&vtaret01_i_5}
/*L06L*/          vt_start {&vtaret01_i_2} vt_tax_pct {&vtaret01_i_1}
                  vt_ar_acct vt_ar_cc skip(1).

               vt_recno = recid(vt_mstr).

               if gl_can then do:
                  {gprun.i ""xxctarrp1a.p""}
               end.
               else do:
                  {gprun.i ""xxvtarrp1a.p""}
               end.
            end.

            put
               skip "-----------------" to 76 "-----------------" to 99


/*L02S*        et_disp_curr + " Report Total:"  to 74 format "x(18)" */
/*L06L* /*L02S*/ et_report_curr + " Report Total:"  to 74 format "x(18)" */
/*L02S*/       et_report_curr + {&vtaret01_i_4} to 74 format "x(18)"

               et_tot_base_amt to  76 format "->>>,>>>,>>9.99"
               et_tot_vat_amt  to 99 format "->>>,>>>,>>9.99" skip.

/*L01G*     if et_show_diff then do: */
/*L01G*/    if et_ctrl.et_show_diff then do:
/*L02S*        {etrpconv.i tot_base_amt et_conv_amt} */
/*L02S*/       if et_report_curr <> mc_rpt_curr then do:
/*L02S*/          /* CONVERT TO REPORTING CURRENCY */
/*L02S*/          {gprunp.i "mcpl" "p" "mc-curr-conv"
                   "(input mc_rpt_curr,
                     input et_report_curr,
                     input et_rate1,
                     input et_rate2,
                     input tot_base_amt,
                     input true, /* ROUND */
                     output et_conv_amt,
                     output mc-error-number)"}
/*L02S*/          if mc-error-number <> 0 then do:
/*L02S*/             {mfmsg.i mc-error-number 2}
/*L02S*/          end.

/*L02S*        {etrpconv.i tot_vat_amt  et_conv_vat} */
/*L02S*/          /* CONVERT TO REPORTING CURRENCY */
/*L02S*/          {gprunp.i "mcpl" "p" "mc-curr-conv"
                   "(input mc_rpt_curr,
                     input et_report_curr,
                     input et_rate1,
                     input et_rate2,
                     input tot_vat_amt,
                     input true, /* ROUND */
                     output et_conv_vat,
                     output mc-error-number)"}
/*L02S*/          if mc-error-number <> 0 then do:
/*L02S*/             {mfmsg.i mc-error-number 2}
/*L02S*/          end.
/*L02S*/       end.  /* if et_report_curr <> mc_rpt_curr */
/*L02S*/       else assign
/*L02S*/          et_conv_vat = tot_vat_amt
/*L02S*/          et_conv_amt = tot_base_amt.

               if (et_conv_amt <> et_tot_base_amt) or
                  (et_conv_vat <> et_tot_vat_amt )
               then do with frame b: /* CONVERTED TOTALS DON'T MATCH */
                  put
                     et_diff_txt             to  74 format "x(25)"
                     ( et_tot_base_amt - et_conv_amt )
                                             to  96 format "->>>,>>>,>>9.99"
                     ( et_tot_vat_amt  - et_conv_vat )
                                             to 123 format "->>>,>>>,>>9.99".
               end. /* CONVERTED TOTALS DON'T MATCH */
            end. /* if et_show_diff then do: */

            /*DISPLAY SUMMARY BY VAT*/
            for each vtw_wkfl exclusive-lock
            by vtw_class
            by vtw_start:
               find vt_mstr where vt_class = vtw_class
                              and vt_start = vtw_start
               no-lock.
               accumulate vtw_amt(total).
               display
                  vtw_class
                  vtw_start
                  vt_tax_pct
                  space (4)
                  vt_ar_acct
                  vt_ar_cc no-label
                  vtw_amt
               with frame c STREAM-IO /*GUI*/ .
               down 1 with frame c.
               delete vtw_wkfl.
            end.
            underline vtw_amt with frame c.
            down 1 with frame c.
            display

/*L02S*        et_disp_curr + " Total:" */
/*L06L* /*L02S*/ et_report_curr + " Total:" */
/*L06L*/       et_report_curr + {&vtaret01_i_3}
                 format "x(10)" @ vt_ar_acct
               accum total vtw_amt
                 format "->>>>,>>>,>>9.99" @ vtw_amt
            with frame c STREAM-IO /*GUI*/ .
            down 1 with frame c.

            hide frame phead1.

            /* REPORT TRAILER */
            
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


         end. /* REPEAT */

         {wbrp04.i &frame-spec = a}
