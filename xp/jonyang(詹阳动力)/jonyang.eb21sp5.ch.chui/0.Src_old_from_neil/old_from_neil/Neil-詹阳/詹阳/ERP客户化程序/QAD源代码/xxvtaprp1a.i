/* GUI CONVERTED from vtaprp1a.i (converter v1.71) Tue Aug  4 16:31:28 1998 */
/* vtaprp1a.i - AP VAT BY VAT CLASS REPORT                               */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.  */
/*F0PN*/ /*V8:ConvertMode=Report                                         */
/* REVISION: 6.0      LAST MODIFIED: 12/04/90   BY: MLB *D238*           */
/* REVISION: 7.0      LAST MODIFIED: 08/23/91   BY: MLV *F002*           */
/* REVISION: 7.0      LAST MODIFIED: 10/28/91   BY: MLV *F028*           */
/* REVISION: 7.0      LAST MODIFIED: 01/09/92   BY: MLV *D983*           */
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: tmd *F357*           */
/* REVISION: 7.3      LAST MODIFIED: 04/15/93   BY: bcm *G958*           */
/*                                   03/07/94   BY: bcm *FM75*           */
/*                                   03/23/95   BY: jzw *F0PS*           */
/*                                   04/10/96   BY: jzw *G1LD*           */
/*                                   09/17/96   BY: rxm *G2FB*           */
/* REVISION: 7.4      LAST MODIFIED: 01/02/98   BY: *H1HY* Mandar K.     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane     */
/* REVISION: 8.6E     LAST MODIFIED: 07/11/98   BY: *L02S* Jim Josey     */
/*************************************************************************/

/* ********** Begin Translatable Strings Definitions ********* */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

&SCOPED-DEFINE vtaprp1a_i_1 "定税日期:  "
/* MaxLen: Comment: */

&SCOPED-DEFINE vtaprp1a_i_2 " 合计 "
/* MaxLen: Comment: */

&SCOPED-DEFINE vtaprp1a_i_3 "基本货币合计"
/* MaxLen: Comment: */

&SCOPED-DEFINE vtaprp1a_i_4 "打印未确认的"
/* MaxLen: Comment: */

&SCOPED-DEFINE vtaprp1a_i_5 "打印已确认的凭证"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         define shared variable show_unconf like mfc_logical
                label {&vtaprp1a_i_4}.
         define shared variable show_conf like mfc_logical
                label {&vtaprp1a_i_5}
                        initial yes.
         define variable term-disc as decimal.
/*L02S*/ define variable mc-error-number like msg_nbr no-undo.

         find first vtc_ctrl no-lock.
         find first gl_ctrl no-lock.
         find vt_mstr where recid(vt_mstr) = vt_recno.

         FORM /*GUI*/  with STREAM-IO /*GUI*/  frame b width 132 down.

         assign
            base_amt     = 0
            base_vat     = 0
            base_tot_amt = 0.

         for each ap_mstr where (ap_batch >= batch)
         and (ap_batch <= batch1)
         and (ap_ref >= ref)
         and (ap_ref <= ref1)
         and (ap_vend >= vend)
         and (ap_vend <= vend1)
         and (ap_date >= apdate)
         and (ap_date <= apdate1)
         and (ap_effdate >= effdate)
         and (ap_effdate <= effdate1)
         and ((ap_curr = base_rpt)
           or (base_rpt = ""))
         no-lock break by ap_batch by ap_ref:

            if ap_type = "VO" then do:
               find vo_mstr where vo_ref = ap_ref no-lock.
               if (vo_confirmed = yes or show_unconf = yes)
                 and (vo_tax_date >= taxdate)
                 and (vo_tax_date <= taxdate1)
               and (vo_confirmed = no  or show_conf = yes) then do:
                  term-disc = 0.
                    if gl_vat and vtc_disc then do:
                     find ct_mstr where ct_code = vo_cr_terms
                     no-lock no-error.
                     if available ct_mstr then term-disc = ct_disc_pct.
                  end.
                  for each vod_det where vod_ref = vo_ref and
                  vod_tax_at = vt_class no-lock:
                  find last vt_mstr where vt_class = vod_tax_at and
                       vt_start <= vo_tax_date and vt_end >= vo_tax_date
                  no-lock no-error.
                  if available vt_mstr and recid(vt_mstr) = vt_recno
                  then do:

                      base_amt = vod_amt.
                      disp_curr = " ".
                      if base_rpt = ""
                      and ap_curr <> base_curr then do:
/*L02S*                  base_amt = base_amt / ap_ex_rate. */

/*L02S*/                 /* VOD_BASE_AMT ADDED IN 8.6E */
/*L02S*/                 base_amt = vod_base_amt.
                         disp_curr = "C".
                      end.

                      accumulate base_amt (total).

                      display
                         ap_mstr.ap_ref
                         ap_mstr.ap_type
                         ap_mstr.ap_date
                         ap_mstr.ap_effdate
                         ap_mstr.ap_batch
                         ap_mstr.ap_vend
                         vod_det.vod_acct
                      /*   vod_det.vod_cc */
                         base_amt
                      /*   " " @ base_tot_amt */
                         " " @ base_vat  
                         disp_curr no-label
                      with frame b STREAM-IO /*GUI*/ .
                      down 1 with frame b.
                      if vo_tax_date <> ap_mstr.ap_effdate
                      then put space(10) {&vtaprp1a_i_1}
                         vo_mstr.vo_tax_date skip.
                   end.
                   else
                      /* RE-FIND THE ORIGINAL VAT MASTER */
                      find vt_mstr where recid(vt_mstr) = vt_recno.
                end.

                base_tot_amt = accum total (base_amt).

                for each vod_det where vod_ref = vo_ref and vod_tax
                = vt_class no-lock:
                   find last vt_mstr where vt_class = vod_tax and
                   vt_start <=
                   vo_tax_date and vt_end >= vo_tax_date
                no-lock no-error.
                if available vt_mstr and recid(vt_mstr) = vt_recno then do:
                   accumulate vod_amt (total).
/*L02S*/           accumulate vod_base_amt (total).
/*L02S*/        end.
                else
                   /* RE-FIND THE ORIGINAL VAT MASTER */
                   find vt_mstr where recid(vt_mstr) = vt_recno.
                end.

                base_vat = accum total (vod_amt).
                disp_curr = " ".
                if base_rpt = ""
                and ap_curr <> base_curr then do:
/*L02S*            base_vat = base_vat / ap_ex_rate. */

/*L02S*/           /* VOD_BASE_AMT ADDED IN 8.6E */
/*L02S*/           base_vat = accum total (vod_base_amt).
                   disp_curr = "C".
                end.
                if base_vat <> 0 or base_tot_amt <> 0 then do:

                   display
                      " " @ ap_mstr.ap_ref
                      " " @ ap_mstr.ap_type
                      " " @ ap_mstr.ap_date
                      " " @ ap_mstr.ap_effdate
                      " " @ ap_mstr.ap_batch
                      " " @ ap_mstr.ap_vend
                      "应纳税金额：" @ vod_det.vod_acct
                   /*   " " @ vod_det.vod_cc */
                     /* " " @  base_amt */
                      base_tot_amt @ base_amt 
                      base_vat
                      disp_curr no-label
                   with frame b STREAM-IO /*GUI*/ .
                   down 1 with frame b.
                   if vo_tax_date <> ap_mstr.ap_effdate
                   then put space(10) {&vtaprp1a_i_1}
                      vo_mstr.vo_tax_date skip.

                   /*ADD TO WORKFILE FOR VAT SUMMARY*/
                   find first vtw_wkfl where vtw_class = vt_class and
                   vtw_start = vt_start no-error.
                   if available vtw_wkfl then
                      vtw_amt = vtw_amt + base_vat.
                   else do:
                      create vtw_wkfl.
                      assign
                         vtw_class = vt_class
                         vtw_start = vt_start
                         vtw_amt   = base_vat.
                    end.

                    accumulate base_tot_amt(total).
                    accumulate base_vat(total).
                 end. /*base_vat <> 0*/
              end.
           end. /*type = VO*/

           else if ap_type = "CK" and
            ((gl_vat and vtc_pmt_disc)
           or gl_can) then do:
              find ck_mstr where ck_ref = ap_ref no-lock.
              if ck_status <> "VOID" then
              for each ckd_det where ckd_ref = ck_ref no-lock:
                 find vo_mstr where vo_ref = ckd_voucher no-lock no-error.
                 if available vo_mstr
                    and (vo_tax_date >= taxdate)
                    and (vo_tax_date <= taxdate1)
                 then
                    find apmstr where apmstr.ap_ref
                    = vo_ref and apmstr.ap_type = "VO" no-lock.
                 if available apmstr then do:
                    for each vod_det where vod_ref = vo_ref
                    and vod_tax_at = vt_class:
                      find last vt_mstr where vt_class =
                        vod_tax_at and vt_start
                        <= vo_mstr.vo_tax_date and vt_end >=
                        vo_mstr.vo_tax_date no-lock no-error.
                      if available vt_mstr and recid(vt_mstr) =
                      vt_recno then do:
                         disc_pct = (
                                     1 - (ckd_amt /
                                    (ckd_amt + ckd_det.ckd_disc)
                                     )
                                     ).

                          base_amt = - ( disc_pct * (ckd_amt + ckd_disc) *
                                     vod_amt / apmstr.ap_amt).

                          disp_curr = " ".
                          if base_rpt = "" and
                          apmstr.ap_curr <> base_curr then do:
/*L02S*                      base_amt = base_amt / apmstr.ap_ex_rate. */
/*L02S*/                     /* CONVERT FROM FOREIGN TO BASE CURRENCY */
/*L02S*/                     {gprunp.i "mcpl" "p" "mc-curr-conv"
                              "(input apmstr.ap_curr,
                                input base_curr,
                                input apmstr.ap_ex_rate,
                                input apmstr.ap_ex_rate2,
                                input base_amt,
                                input false, /* DO NOT ROUND */
                                output base_amt,
                                output mc-error-number)"}.
/*L02S*/                     if mc-error-number <> 0 then do:
/*L02S*/                        {mfmsg.i mc-error-number 2}
/*L02S*/                     end.
                             disp_curr = "C".
                          end.
                          base_tot_amt = base_amt.

                          base_vat = base_amt * vt_tax_pct / 100.

                          /*ADD TO WORKFILE FOR VAT SUMMARY*/
                          find first vtw_wkfl where vtw_class =
                          vt_class and vtw_start = vt_start no-error.
                          if available vtw_wkfl then
                             vtw_amt = vtw_amt + base_vat.
                          else do:
                             create vtw_wkfl.
                             assign
                                vtw_class = vt_class
                                vtw_start = vt_start
                                vtw_amt   = base_vat.
                           end.

                           display
                              ap_mstr.ap_ref
                              ap_mstr.ap_type
                              ap_mstr.ap_date
                              ap_mstr.ap_effdate
                              ap_mstr.ap_batch
                              ap_mstr.ap_vend
                              vod_det.vod_acct
                            /*  vod_det.vod_cc */
                              base_amt
                          /*    base_tot_amt */
                              base_vat
                              disp_curr no-label
                           with frame b STREAM-IO /*GUI*/ .
                           down 1 with frame b.
                           if vo_tax_date <> ap_mstr.ap_effdate
                           then put space(10) {&vtaprp1a_i_1}
                              vo_mstr.vo_tax_date skip.
                           accumulate base_tot_amt(total).
                           accumulate base_vat(total).
                        end.
                        else
                           /* RE-FIND THE ORIGINAL VAT MASTER */
                           find vt_mstr where recid(vt_mstr) = vt_recno.
                     end.
                  end.
               end.
            end. /*if ap_type = "CK"*/
         end. /*for each ap_mstr*/
         underline base_amt base_vat with frame b.
         display
            (if base_rpt = "" then {&vtaprp1a_i_3} + vat_label
             else base_rpt + {&vtaprp1a_i_2} + vat_label)
             format "x(15)" @ vod_det.vod_acct
            accum total base_tot_amt format "->>,>>>,>>9.99"
              @ base_amt
            accum total base_vat format "->>,>>>,>>9.99"
              @ base_vat
         with frame b STREAM-IO /*GUI*/ .

         tot_base_amt = tot_base_amt + accum total base_tot_amt.
         tot_vat_amt  = tot_vat_amt + accum total base_vat.

         find vt_mstr where recid(vt_mstr) = vt_recno.
