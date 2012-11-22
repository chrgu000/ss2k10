/* GUI CONVERTED from yyictrrp03.i (converter v1.78) Mon Nov  5 11:41:50 2012 */
/* ictrrp03.i - INCLUDE FILE FOR TRANSACTION ACCOUNTING REPORT                */
/* Copyright 1986-2011 QAD Inc., Santa Barbara, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* Revision: 1.1.1.1    BY: Laxmikant Bondre       DATE: 05/05/09 ECO: *Q2TR* */
/* $Revision: 1.1.1.2 $   BY: Deepak Keni       DATE: 02/23/11 ECO: *Q4NB* */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Report                                                       */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

l_fo_trnbr = yes.
for each trgl_det
   {&ICTRRP03-P-TAG17}
   where  trgl_domain   = global_domain
   and    trgl_trnbr    = tr_trnbr
   and    trgl_gl_ref  >= glref
   and    trgl_gl_ref  <= glref1
   and   (trgl_dr_acct >= acct
      and trgl_dr_acct <= acct1
      and trgl_dr_sub  >= sub
      and trgl_dr_sub  <= sub1
      and trgl_dr_cc   >= cc
      and trgl_dr_cc   <= cc1
      and trgl_dr_proj >= proj
      and trgl_dr_proj <= proj1
      or  trgl_cr_acct >= acct
      and trgl_cr_acct <= acct1
      and trgl_cr_sub  >= sub
      and trgl_cr_sub  <= sub1
      and trgl_cr_cc   >= cc
      and trgl_cr_cc   <= cc1
      and trgl_cr_proj >= proj
      and trgl_cr_proj <= proj1)
   and    trgl_gl_amt  <> 0
no-lock,
   first si_mstr
   where si_domain     = global_domain
   and   si_site       = tr_site
   and   si_entity    >= entity
   and   si_entity    <= entity1
no-lock:
   if gl_yn
   then do:
      {&ICTRRP03-P-TAG35}

      /* PROCEDURE TO CREATE TEMP-TABLE WITH GL DATA */
      run p_tt_glt_create.

      {&ICTRRP03-P-TAG36}
   end. /* IF gl_yn */

   if tr_yn
   then do:
      assign
         desc1 = ""
         desc2 = "".

      {&ICTRRP03-P-TAG20}

      for first pt_mstr
         where pt_domain = global_domain
         and   pt_part   = tr_part
      no-lock:
         desc1 = pt_desc1.
         {&ICTRRP03-P-TAG21}
      end. /* FOR FIRST pt_mstr */

      if page-size - line-counter < 4
      then
         page.

      if tr_qty_loc <> 0
      then
         desc2 = trim(string(tr_qty_loc,"->>,>>>,>>>,>>>,>>>,>>9.9<<<<")) +
                 " @ "                                        +
                 if    round(tr_qty_loc      *
                             (tr_bdn_std     +
                              tr_lbr_std     +
                              tr_mtl_std     +
                              tr_ovh_std     +
                              tr_sub_std),2) = trgl_gl_amt
                    or round(tr_qty_loc      *
                             (tr_bdn_std     +
                              tr_lbr_std     +
                              tr_mtl_std     +
                              tr_ovh_std     +
                              tr_sub_std),2) = -1 * trgl_gl_amt
                 then
                    trim(string(if (trgl_gl_amt  /
                                    tr_qty_loc)  *
                                   (tr_bdn_std   +
                                    tr_lbr_std   +
                                    tr_mtl_std   +
                                    tr_ovh_std   +
                                    tr_sub_std) >= 0
                                then
                                   (tr_bdn_std +
                                    tr_lbr_std +
                                    tr_mtl_std +
                                    tr_ovh_std +
                                    tr_sub_std)
                                else
                                   (tr_bdn_std  +
                                    tr_lbr_std  +
                                    tr_mtl_std  +
                                    tr_ovh_std  +
                                    tr_sub_std) * -1,
                                "->>,>>>,>>>,>>>,>>>,>>9.99<<<"))
                 else
                    trim(string(trgl_gl_amt / tr_qty_loc,"->>,>>>,>>>,>>>,>>>,>>9.99<<<")).

      if tr_type begins "CN-"
      then do for trhist:
         for first trhist
            fields(tr_bdn_std tr_lbr_std tr_mtl_std tr_ovh_std tr_sub_std)
            where trhist.tr_domain = global_domain
            and   trhist.tr_trnbr  = integer(tr_hist.tr_rmks)
         no-lock:
            desc2 = trim(string(tr_hist.tr_qty_loc,"->>,>>>,>>>,>>>,>>>,>>9.99<<<")) +
                    " @ "                                                +
                         if   (round(tr_hist.tr_qty_loc     *
                                     (trhist.tr_bdn_std     +
                                      trhist.tr_lbr_std     +
                                      trhist.tr_mtl_std     +
                                      trhist.tr_ovh_std     +
                                      trhist.tr_sub_std),2) = trgl_gl_amt
                            or round(tr_hist.tr_qty_loc     *
                                     (trhist.tr_bdn_std     +
                                      trhist.tr_lbr_std     +
                                      trhist.tr_mtl_std     +
                                      trhist.tr_ovh_std     +
                                      trhist.tr_sub_std),2) = -1 * trgl_gl_amt)
                         then
                            trim(string(if (trgl_gl_amt         /
                                            tr_hist.tr_qty_loc) *
                                           (trhist.tr_bdn_std   +
                                            trhist.tr_lbr_std   +
                                            trhist.tr_mtl_std   +
                                            trhist.tr_ovh_std   +
                                            trhist.tr_sub_std) >= 0
                                        then
                                           (trhist.tr_bdn_std +
                                            trhist.tr_lbr_std +
                                            trhist.tr_mtl_std +
                                            trhist.tr_ovh_std +
                                            trhist.tr_sub_std)
                                        else
                                           (trhist.tr_bdn_std  +
                                            trhist.tr_lbr_std  +
                                            trhist.tr_mtl_std  +
                                            trhist.tr_ovh_std  +
                                            trhist.tr_sub_std) * -1,
                                        "->>,>>>,>>>,>>>,>>>,>>9.99<<<"))
                            else
                               trim(string(trgl_gl_amt / tr_hist.tr_qty_loc,
                                           "->>,>>>,>>>,>>>,>>>,>>9.99<<<")).
         end.  /* FOR FIRST trhist */
      end.  /* IF tr_type BEGINS "CN-" */

      if l_fo_trnbr
      then do:
         {&ICTRRP03-P-TAG28}
         down 1 with frame b.
         {&ICTRRP03-P-TAG22}
         display
            tr_effdate
            tr_trnbr
            trgl_type
            tr_nbr
         with frame b STREAM-IO /*GUI*/ .
         {&ICTRRP03-P-TAG23}
      end. /* IF l_fo_trnbr */

      {&ICTRRP03-P-TAG24}
      display
         si_entity
         trgl_gl_ref
         desc2
         trgl_dr_acct
         trgl_dr_sub
         trgl_dr_cc
         {&ICTRRP03-P-TAG26}
         trgl_gl_amt format "->>,>>>,>>>,>>>,>>>,>>9.99<<<"
      with frame b STREAM-IO /*GUI*/ .
      down with frame b.

      {&ICTRRP03-P-TAG27}
      if l_fo_trnbr
      then do:
         l_fo_trnbr = no.
         display
            tr_part @ tr_nbr
            desc1   @ desc2
         with frame b STREAM-IO /*GUI*/ .
      end. /* IF l_fo_trnbr */

      display
         trgl_cr_acct    @ trgl_dr_acct
         trgl_cr_sub     @ trgl_dr_sub
         trgl_cr_cc      @ trgl_dr_cc
         (- trgl_gl_amt) @ trgl_gl_amt format "->>,>>>,>>>,>>>,>>>,>>9.99<<<"
      with frame b STREAM-IO /*GUI*/ .
      down with frame b.
      {&ICTRRP03-P-TAG25}

      
/*GUI*/ {mfguirex.i  "false"} /*Replace mfrpexit*/

   end. /* IF tr_yn */
end. /* FOR EACH trgl_det */
