/* GUI CONVERTED from fstdetrp.i (converter v1.76) Mon Mar 18 16:39:30 2002 */
/* fstdetrp.i - ACCUMULATE TAX DETAIL AMOUNTS FOR A TRANSACTION               */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.3 $                                               */
/*V8:ConvertMode=Report                                                       */
/*  THIS PROGRAM ACCUMULATES THE TAX DETAILS                                  */
/*                                                                            */
/* $Revision: 1.3 $    BY: Niranjan R.          DATE: 03/12/02  ECO: *P020*  */

/* THIS INCLUDE FILE IS A CLONE OF TXDETRPA.I.ANY CHANGES MADE TO  */
/* THIS FILE MAY APPLY TO TXDETRPA.I.ONLY DIFFERENCE IS, THIS FILE */
/* CONVERTS MULTIPLE CURRENCY ON A DOCUMENT TO A CONTRACT CURRENCY.*/
/* ALSO, THIS FILE IS USE FOR CONTRACT AND CONTRACT QUOTE,         */
/* TRANSACTION TYPE "34" AND "33" RESPECTIVELY.                    */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

define variable l_prefix        like sa_prefix    no-undo.
define variable saRndmthd       like rnd_rnd_mthd no-undo.
define variable mc-error-number as   integer      no-undo.

define variable l_taxtotal like tx2d_tottax no-undo.
define variable l_taxbase  like tx2d_tottax no-undo.
define variable l_nontax   like tx2d_tottax no-undo.
define variable l_taxadj   like tx2d_tottax no-undo.

for first sac_ctrl fields (sac_domain sac_sa_pre sac_qo_pre)
no-lock where sac_domain = global_domain:
end.

if tr_type = "34" then
   l_prefix = sac_sa_pre.
else
   if tr_type = "33" then
   l_prefix = sac_qo_pre.

for first sa_mstr fields(sa_domain sa_nbr sa_prefix sa_curr sa_ex_rate sa_ex_rate2)
   where sa_domain = global_domain and sa_nbr    = ref
   and   sa_prefix = l_prefix
no-lock:
end.

/* GET ROUNDING METHOD FROM CURRENCY MASTER */
{gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
   "(input  sa_curr,
     output saRndmthd,
     output mc-error-number
     )"}

/* TAX DETAILS ACCUMULATION */
for each tx2d_det where tx2d_domain = global_domain and tx2d_ref = ref and
      (tx2d_nbr = nbr or nbr = "*") and
      tx2d_tr_type = tr_type
   no-lock:

   for first tx2_mstr fields(tx2_domain tx2_by_line tx2_desc tx2_pt_taxc
             tx2_tax_code tx2_tax_pct tx2_tax_type tx2_tax_usage)
      where tx2_domain = global_domain and tx2_tax_code = tx2d_tax_code no-lock:
   end.
   if tx2_tax_code = "00000000" then next.

   /* GET CORRESPONDING MASTER INFO, OTHERWISE PRINT PROGRESS */
   /* HARD ERROR-NO MSTR */

   if available tx2_mstr then do:
      for first code_mstr
         fields(code_domain code_desc code_fldname code_value)
         where code_domain = global_domain and code_fldname = "txt_tax_type" and
         code_value   = tx2_tax_type
      no-lock :
      end.

      /* IF TAXED BY LINE: USE TAX DETAIL INFO */
      if tx2_by_line then
      for first taxdetail where
         taxtype  = tx2_tax_type  and
         taxclass = tx2d_taxc     and
         taxusage = tx2d_tax_usage
      no-lock :
      end.
      else
      /* IF TAXED BY TOTAL: USE TAX RATE INFO */
      for first taxdetail where
         taxtype  = tx2_tax_type and
         taxclass = tx2_pt_taxc  and
         taxusage = tx2_tax_usage
      no-lock :
      end.

      if not available taxdetail then do:

         create
            taxdetail.

         taxtype = tx2_tax_type.
         if available code_mstr then
            typedesc = code_desc.
         if tx2_by_line then
         assign
            taxclass  = tx2d_taxc
            taxusage  = tx2d_tax_usage.
         else
         assign
            taxclass  = tx2_pt_taxc
            taxusage  = tx2_tax_usage.

         assign
            taxdesc   = tx2_desc
            taxedit   = tx2d_edited.

         if sa_curr = tx2d_curr then
         assign
            taxtotal  = tx2d_cur_tax_amt
            taxbase   = tx2d_tottax
            nontax    = tx2d_cur_nontax_amt
            taxadj    = tx2d_cur_abs_ret_amt
            taxpercnt = if not taxedit then tx2_tax_pct else
               ((taxtotal / taxbase) * 100).
         else do:
            run amountInContractCurrency
               (buffer sa_mstr,
               buffer tx2d_det,
               input  tx2d_cur_tax_amt,
               input  saRndmthd,
               output taxtotal).

            run amountInContractCurrency
               (buffer sa_mstr,
               buffer tx2d_det,
               input  tx2d_tottax,
               input  saRndmthd,
               output taxbase).

            run amountInContractCurrency
               (buffer sa_mstr,
               buffer tx2d_det,
               input  tx2d_cur_nontax_amt,
               input  saRndmthd,
               output nontax).

            run amountInContractCurrency
               (buffer sa_mstr,
               buffer tx2d_det,
               input  tx2d_cur_abs_ret_amt,
               input  saRndmthd,
               output taxadj).

            taxpercnt = if not taxedit then
            tx2_tax_pct else
               ((taxtotal / taxbase) * 100).
         end. /* else do: */
      end.

      else do:

         taxedit   = taxedit or tx2d_edited.

         if sa_curr = tx2d_curr then
         assign
            taxtotal  = taxtotal + tx2d_cur_tax_amt
            taxbase   = taxbase  + tx2d_tottax
            nontax    = nontax   + tx2d_cur_nontax_amt
            taxadj    = taxadj   + tx2d_cur_abs_ret_amt
            taxpercnt = if not taxedit then tx2_tax_pct else
               ((taxtotal / taxbase) * 100).
         else do:

            run amountInContractCurrency
               (buffer sa_mstr,
               buffer tx2d_det,
               input  tx2d_cur_tax_amt,
               input  saRndmthd,
               output l_taxtotal).

            run amountInContractCurrency
               (buffer sa_mstr,
               buffer tx2d_det,
               input  tx2d_tottax,
               input  saRndmthd,
               output l_taxbase).

            run amountInContractCurrency
               (buffer sa_mstr,
               buffer tx2d_det,
               input  tx2d_cur_nontax_amt,
               input  saRndmthd,
               output l_nontax).

            run amountInContractCurrency
               (buffer sa_mstr,
               buffer tx2d_det,
               input  tx2d_cur_abs_ret_amt,
               input  saRndmthd,
               output l_taxadj).

            assign
               taxtotal  = taxtotal + l_taxtotal
               taxbase   = taxbase  + l_taxbase
               nontax    = nontax   + l_nontax
               taxadj    = taxadj   + l_taxadj
               taxpercnt = if not taxedit then tx2_tax_pct else
                  ((taxtotal / taxbase) * 100).
         end. /* eles do: */
      end. /* else do:*/
   end.
end. /* for each tx2d_det */

PROCEDURE amountInContractCurrency:

   define parameter buffer sa_mstr for sa_mstr.
   define parameter buffer tx2d_det for tx2d_det.
   define input  parameter pInAmount       like tx2d_tottax  no-undo.
   define input  parameter pRndmthd        like rnd_rnd_mthd no-undo.
   define output parameter pOutAmount      like tx2d_tottax  no-undo.

   if tx2d_by_line then
   for first sad_det
      fields(sad_domain sad_nbr sad_prefix sad_line sad_ex_rate sad_ex_rate2)
      where sad_domain = global_domain
      and   sad_nbr    = sa_nbr
      and   sad_prefix = sa_prefix
      and   sad_line   = tx2d_line
   no-lock:
   end.
   else
   for first sad_det
      fields(sad_domain sad_nbr sad_prefix sad_line sad_ex_rate sad_ex_rate2
      sad_eu_nbr sad_curr)
      where sad_domain = global_domain
      and   sad_nbr    = sa_nbr
      and   sad_prefix = sa_prefix
      and   sad_eu_nbr = tx2d_nbr
      and   sad_curr   = tx2d_curr
   no-lock:
   end.

   /* CONVERT THE AMOUNT FIRST IN BASE CURRENCY THEN IN CONTRACT */
   /* CURRENCY */
   pOutAmount = (((pInAmount * sad_ex_rate2) /
   sad_ex_rate) * sa_ex_rate) / sa_ex_rate2.

   /* Rounding the amount */
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output pOutAmount,
        input        pRndmthd,
        output       mc-error-number)"}

END PROCEDURE.
