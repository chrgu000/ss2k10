/* GUI CONVERTED from vtarrp1a.i (converter v1.71) Tue Aug  4 16:31:38 1998 */
/* vtarrp1a.i - VAT/GST REPORT BY VAT CLASS                               */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.   */
/*F0PN*/ /*V8:ConvertMode=Report                                          */
/* REVISION: 6.0        LAST MODIFIED: 12/03/90   BY: MLB *D238*          */
/* REVISION: 6.0        LAST MODIFIED: 05/23/91   BY: MLV *D655*          */
/* REVISION: 7.0        LAST MODIFIED: 10/28/91   BY: MLV *F028*          */
/* REVISION: 7.0        LAST MODIFIED: 01/09/92   BY: MLV *D983*          */
/* REVISION: 7.0        LAST MODIFIED: 04/06/92   BY: tmd *F357*          */
/*                                     03/07/94   BY: bcm *FM75*          */
/* REVISION: 7.3        LAST MODIFIED: 04/10/96   BY: jzw *G1P6*          */
/* REVISION: 7.3        LAST MODIFIED: 08/26/96   BY: *G2D0* Sanjay Patil */
/* REVISION: 7.4        LAST MODIFIED: 01/02/98   BY: *H1HY* Mandar K.    */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane      */
/* REVISION: 8.6E     LAST MODIFIED: 07/11/98   BY: *L02S* Jim Josey      */
/* Old ECO marker removed, but no ECO exists           *D170*             */
/**************************************************************************/


/* ********** Begin Translatable Strings Definitions ********* */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

&SCOPED-DEFINE vtarrp1a_i_1 "定税日期:  "
/* MaxLen: Comment: */

&SCOPED-DEFINE vtarrp1a_i_2 "基本货币增值税:"
/* MaxLen: Comment: */

&SCOPED-DEFINE vtarrp1a_i_3 "增值税合计:"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         define variable term-disc as decimal.
/*L02S*/ define variable mc-error-number like msg_nbr no-undo.

         find first gl_ctrl no-lock.
         if gl_vat then find first vtc_ctrl no-lock.

         find vt_mstr where recid(vt_mstr) = vt_recno.
         FORM /*GUI*/  with STREAM-IO /*GUI*/  frame b width 132 down.

         assign
            base_amt     = 0
            base_vat     = 0
            base_tot_amt = 0.

         for each ar_mstr where (ar_nbr >= nbr)
         and (ar_nbr <= nbr1)
         and (ar_batch >= batch)
         and (ar_batch <= batch1)
         and (ar_cust >= cust)
         and (ar_cust <= cust1)
         and (ar_date >= ardate)
         and (ar_date <= ardate1)
         and (ar_effdate >= effdate)
         and (ar_effdate <= effdate1)
         and (ar_tax_date >= taxdate)
         and (ar_tax_date <= taxdate1)
         and ((ar_curr = base_rpt)
         or (base_rpt = ""))
         no-lock by ar_nbr
         with frame b width 132 down:

            if ar_type <> "P" and ar_type <> "A" and ar_type <> "D" then do:

               term-disc = 0.
               if gl_vat and vtc_disc then do:
                  find ct_mstr where ct_code = ar_cr_terms no-lock no-error.
                  if available ct_mstr then term-disc = ct_disc_pct.
               end.
               for each ard_det where ard_nbr = ar_nbr
                                  and ard_tax_at = vt_class
               no-lock:

                  /*DON'T DO IF NOT RIGHT VAT DATES*/
                  find last vtmstr where vtmstr.vt_class = ard_tax_at and
                    vtmstr.vt_start <=
                    ar_tax_date
                    and vtmstr.vt_end >= ar_tax_date
                  no-lock no-error.
                  if available vtmstr
                  and vtmstr.vt_class = vt_mstr.vt_class
                  and vtmstr.vt_start = vt_mstr.vt_start then do:

                     base_amt = - ard_amt.
                     disp_curr = " ".
                     if base_rpt = ""
                     and ar_curr <> base_curr then do:
/*L02S*                 base_amt = base_amt / ar_ex_rate. */
/*L02S*/                /* CONVERT FROM FOREIGN TO BASE CURRENCY */
/*L02S*/                {gprunp.i "mcpl" "p" "mc-curr-conv"
                         "(input ar_curr,
                           input base_curr,
                           input ar_ex_rate,
                           input ar_ex_rate2,
                           input base_amt,
                           input false, /* DO NOT ROUND */
                           output base_amt,
                           output mc-error-number)"}
/*L02S*/                if mc-error-number <> 0 then do:
/*L02S*/                   {mfmsg.i mc-error-number 2}
/*L02S*/                end.
                        disp_curr = "C".
                     end.

                     accumulate base_amt (total).

                     display
                        ar_mstr.ar_nbr format "x(8)"
                        ar_mstr.ar_type
                        ar_mstr.ar_date
                        ar_mstr.ar_effdate
                        ar_mstr.ar_batch
                        ar_mstr.ar_cust
                        ard_det.ard_acct
                  /*      ard_det.ard_cc */
                        base_amt 
                    /*     " " @ base_tot_amt */
                        " " @ base_vat
                        disp_curr no-label
                     with frame b STREAM-IO /*GUI*/ .
                     down 1 with frame b.
                     if ar_mstr.ar_tax_date <> ar_mstr.ar_effdate
                     then put space(10) {&vtarrp1a_i_1}
                        ar_mstr.ar_tax_date skip.
                  end.
               end. /*for each tax_at*/

               base_tot_amt = accum total (base_amt).

               for each ard_det where ard_nbr = ar_nbr and ard_tax = vt_class
               no-lock:
                  /*DON'T DO IF NOT RIGHT VAT DATES*/
                  find last vtmstr where vtmstr.vt_class = ard_tax and
                    vtmstr.vt_start <=
                    ar_tax_date
                  and vtmstr.vt_end >= ar_tax_date no-lock no-error.
                  if available vtmstr
                    and vtmstr.vt_class = vt_mstr.vt_class
                    and vtmstr.vt_start = vt_mstr.vt_start then
                     accumulate ard_amt (total).
                  end.
                  base_vat = - (accum total (ard_amt)).
                  disp_curr = " ".
                  if base_rpt = ""
                  and ar_curr <> base_curr then do:
/*L02S*              base_vat = base_vat / ar_ex_rate. */
/*L02S*/             /* CONVERT FROM FOREIGN TO BASE CURRENCY */
/*L02S*/             {gprunp.i "mcpl" "p" "mc-curr-conv"
                      "(input ar_curr,
                        input base_curr,
                        input ar_ex_rate,
                        input ar_ex_rate2,
                        input base_vat,
                        input false, /* DO NOT ROUND */
                        output base_vat,
                        output mc-error-number)"}
/*L02S*/             if mc-error-number <> 0 then do:
/*L02S*/                {mfmsg.i mc-error-number 2}
/*L02S*/             end.
                     disp_curr = "C".
                  end.
                  if base_vat <> 0
                  or base_tot_amt <> 0
                  then do:

                     display
                        " " @ ar_mstr.ar_nbr format "x(8)"
                        " " @ ar_mstr.ar_type
                        " " @ ar_mstr.ar_date
                        " " @ ar_mstr.ar_effdate
                        " " @ ar_mstr.ar_batch
                        " " @ ar_mstr.ar_cust
                        "应纳税金额： " @  ard_det.ard_acct
                   /*     " " @ ard_det.ard_cc */
                         base_tot_amt @ base_amt
                        base_vat
                        disp_curr no-label
                     with frame b STREAM-IO /*GUI*/ .
                     down 1 with frame b.

                     /*ADD TO WORKFILE FOR VAT SUMMARY*/
                     find first vtw_wkfl where vtw_class = vt_mstr.vt_class and
                       vtw_start = vt_mstr.vt_start no-error.
                     if available vtw_wkfl then
                        vtw_amt = vtw_amt + base_vat.
                     else do:
                        create vtw_wkfl.
                        assign
                           vtw_class = vt_mstr.vt_class
                           vtw_start = vt_mstr.vt_start
                           vtw_amt   = base_vat.
                     end.

                     accumulate base_tot_amt(total).
                     accumulate base_vat(total).
                  end. /*base_vat <> 0*/
               end.
               else if ar_type = "P" or ar_type = "D"  then
                  for each ard_det where ard_nbr = ar_nbr
                  with frame b width 132 down:
                     if index("IMF",ard_type) <> 0 and
                     gl_vat and vtc_pmt_disc then do:
                        find armstr where armstr.ar_nbr = ard_ref
                        no-lock no-error.
                        if available armstr then
                        for each arddet where arddet.ard_nbr = armstr.ar_nbr
                                          and arddet.ard_tax_at <> "":

                           find last vtmstr where vtmstr.vt_class =
                             arddet.ard_tax_at and vtmstr.vt_start
                             <= armstr.ar_tax_date
                             and vtmstr.vt_end >= armstr.ar_tax_date
                           no-lock no-error.
                           if available vtmstr
                             and vtmstr.vt_class = vt_mstr.vt_class
                           and vtmstr.vt_start = vt_mstr.vt_start then do:

                              disc_pct = (
                                          1 - (ard_det.ard_amt /
                                         (ard_det.ard_amt + ard_det.ard_disc)
                                          )
                                          ).
                              base_amt = disc_pct *
                                         (ard_det.ard_amt + ard_det.ard_disc)
                                         * arddet.ard_amt / armstr.ar_amt.

                              disp_curr = " ".
                              if base_rpt = "" and
                              armstr.ar_curr <> base_curr then do:
/*L02S*                          base_amt = base_amt / armstr.ar_ex_rate. */
/*L02S*/                         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
/*L02S*/                         {gprunp.i "mcpl" "p" "mc-curr-conv"
                                  "(input armstr.ar_curr,
                                    input base_curr,
                                    input armstr.ar_ex_rate,
                                    input armstr.ar_ex_rate2,
                                    input base_amt,
                                    input false, /* DO NOT ROUND */
                                    output base_amt,
                                    output mc-error-number)"}
/*L02S*/                         if mc-error-number <> 0 then do:
/*L02S*/                            {mfmsg.i mc-error-number 2}
/*L02S*/                         end.
                                 disp_curr = "C".
                              end.
                              base_tot_amt = base_amt.

                              base_vat = base_amt * vt_tax_pct /
                                         100.

                              /*ADD TO WORKFILE FOR VAT SUMMARY*/
                              find first vtw_wkfl where vtw_class = vt_class
                                                    and vtw_start = vt_start
                              no-error.
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
                                 substr(ar_mstr.ar_nbr, 9) @
                                  ar_mstr.ar_nbr format "x(8)"
                                 ar_mstr.ar_type
                                 ar_mstr.ar_date
                                 ar_mstr.ar_effdate
                                 ar_mstr.ar_batch
                                 ar_mstr.ar_cust
                                 arddet.ard_acct @ ard_det.ard_acct
                            /*     arddet.ard_cc @ ard_det.ard_cc */
                                 base_amt
                             /*    base_tot_amt */
                                 base_vat
                                 disp_curr no-label
                              with frame b STREAM-IO /*GUI*/ .
                              down 1 with frame b.
                              displ base_tot_amt @ base_amt with frame b stream-io.
                              if ar_mstr.ar_tax_date <> ar_mstr.ar_effdate
                              then put space(10) {&vtarrp1a_i_1}
                                 ar_mstr.ar_tax_date skip.
                              accumulate base_tot_amt(total).
                              accumulate base_vat(total).
                           end.
                        end.
                     end. /*type = IMF*/
                     else if (ard_det.ard_type = "U"
                     or ard_det.ard_type = "N")
                     then do:
                     find last vtmstr where vtmstr.vt_class =
                       ard_det.ard_tax_at and vtmstr.vt_start
                       <= ar_mstr.ar_tax_date
                       and vtmstr.vt_end >= ar_mstr.ar_tax_date
                     no-lock no-error.
                     if available vtmstr
                       and vtmstr.vt_class = vt_mstr.vt_class
                     and vtmstr.vt_start = vt_mstr.vt_start then do:

                     base_amt = - ( ard_det.ard_amt /
                                (1 + (vt_tax_pct / 100)) ).

                     disp_curr = " ".
                     if base_rpt = ""
                     and ar_mstr.ar_curr <> base_curr then do:
/*L02S*                 base_amt = base_amt / ar_mstr.ar_ex_rate. */
/*L02S*/                /* CONVERT FROM FOREIGN TO BASE CURRENCY */
/*L02S*/                {gprunp.i "mcpl" "p" "mc-curr-conv"
                         "(input ar_mstr.ar_curr,
                           input base_curr,
                           input ar_mstr.ar_ex_rate,
                           input ar_mstr.ar_ex_rate2,
                           input base_amt,
                           input false, /* DO NOT ROUND */
                           output base_amt,
                           output mc-error-number)"}
/*L02S*/                if mc-error-number <> 0 then do:
/*L02S*/                   {mfmsg.i mc-error-number 2}
/*L02S*/                end.
                        disp_curr = "C".
                     end.
                     base_tot_amt = base_amt.
                     base_vat = base_amt * (vt_tax_pct / 100).

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

                     display
                        substr(ar_mstr.ar_nbr, 9) @
                          ar_mstr.ar_nbr format "x(8)"
                        ar_mstr.ar_type
                        ar_mstr.ar_date
                        ar_mstr.ar_effdate
                        ar_mstr.ar_batch
                        ar_mstr.ar_cust
                        ard_det.ard_acct
                     /*   ard_det.ard_cc */
                        base_amt
                        base_vat
                        disp_curr no-label
                     with frame b STREAM-IO /*GUI*/ .
                     down 1 with frame b.
                     if ar_mstr.ar_tax_date <> ar_mstr.ar_effdate
                     then put space(10) {&vtarrp1a_i_1}
                        ar_mstr.ar_tax_date skip.
                     accumulate base_tot_amt(total).
                     accumulate base_vat(total).
                  end.
                  else next.  /*ar_mstr*/
               end.
            end. /*if ar_type = "P"*/
            else if ar_mstr.ar_type = "A" then do:
               find armstr
                 where armstr.ar_nbr = ar_mstr.ar_cust +
                 fill(" ", 8 - length(ar_mstr.ar_cust))
                 + ar_mstr.ar_check
               no-lock no-error.      /*need header for effdate*/
               if available armstr  then
                  find first arddet where arddet.ard_nbr = armstr.ar_nbr
                                      and arddet.ard_type = "U"
                  no-lock no-error.
               if available arddet then do:

                  find last vtmstr where vtmstr.vt_class =
                    arddet.ard_tax_at and vtmstr.vt_start
                    <= armstr.ar_tax_date
                    and vtmstr.vt_end >= armstr.ar_tax_date
                  no-lock no-error.
                  if available vtmstr and vtmstr.vt_class = vt_mstr.vt_class
                                      and vtmstr.vt_start = vt_mstr.vt_start
                  then do:

                     base_amt =  ( ar_mstr.ar_amt / (1 + (vt_tax_pct / 100)) ).

                     disp_curr = " ".
                     if base_rpt = ""
                     and ar_mstr.ar_curr <> base_curr then do:
/*L02S*                 base_amt = base_amt / ar_mstr.ar_ex_rate. */
/*L02S*/                /* CONVERT FROM FOREIGN TO BASE CURRENCY */
/*L02S*/                {gprunp.i "mcpl" "p" "mc-curr-conv"
                         "(input ar_mstr.ar_curr,
                           input base_curr,
                           input ar_mstr.ar_ex_rate,
                           input ar_mstr.ar_ex_rate2,
                           input base_amt,
                           input false, /* DO NOT ROUND */
                           output base_amt,
                           output mc-error-number)"}
/*L02S*/                if mc-error-number <> 0 then do:
/*L02S*/                   {mfmsg.i mc-error-number 2}
/*L02S*/                end.
                        disp_curr = "C".
                     end.
                     base_tot_amt = base_amt.
                     base_vat = base_amt * (vt_tax_pct / 100).

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

                     display
                        ar_mstr.ar_nbr format "x(8)"
                        ar_mstr.ar_type
                        ar_mstr.ar_date
                        ar_mstr.ar_effdate
                        ar_mstr.ar_batch
                        ar_mstr.ar_cust
                        ar_mstr.ar_acct @ ard_det.ard_acct
                    /*    ar_mstr.ar_cc   @ ard_det.ard_cc */
                        base_amt
                     /*   base_tot_amt */
                        base_vat
                        disp_curr no-label
                     with frame b STREAM-IO /*GUI*/ .
                     down 1 with frame b.
                     displ base_tot_amt @ base_amt with frame b stream-io .
                     if ar_mstr.ar_tax_date <> ar_mstr.ar_effdate
                     then put space(10) {&vtarrp1a_i_1}
                        ar_mstr.ar_tax_date skip.

                     accumulate base_tot_amt(total).
                     accumulate base_vat(total).
                  end.
               end.
            end. /*ar_type = "A"*/

            
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

         end. /*for each ar_mstr*/
         underline base_amt base_vat with frame b.
         display
            (if base_rpt = "" then {&vtarrp1a_i_2}
             else base_rpt + {&vtarrp1a_i_3})
             format "x(15)" @ ard_det.ard_acct
            accum total base_tot_amt format "->>>,>>>,>>9.99"
              @ base_amt
            accum total base_vat format "->>>,>>>,>>9.99"
              @ base_vat
         with frame b STREAM-IO /*GUI*/ .
         down 1 with frame b.

         tot_base_amt = tot_base_amt + accum total base_tot_amt.
         tot_vat_amt  = tot_vat_amt + accum total base_vat.
