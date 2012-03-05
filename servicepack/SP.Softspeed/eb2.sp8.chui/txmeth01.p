/* txmeth01.p - qad GENERIC TAX CALCULATION ROUTINE                        */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* $Revision: 1.11.2.10 $                                                   */
/*V8:ConvertMode=Maintenance                                               */
/* Revision: 7.3      CREATED:       11/18/92   By: bcm  *G413*            */
/* Revision: 7.4      MODIFIED:      07/02/93   By: bcm  *H010*            */
/*                                   10/22/93   By: bcm  *H212*            */
/*                                   03/17/94   By: bcm  *H296*            */
/*                                   03/29/94   By: bcm  *H309*            */
/*                                   09/20/94   By: bcm  *H531*            */
/*                                   09/20/94   By: bcm  *H610*            */
/*                                   02/23/95   By: jzw  *H0BM*            */
/* Revision: 8.5      MODIFIED:      07/05/95   By: taf  *J053*            */
/*                                   05/08/96   By: jzw  *H0KY*            */
/* REVISION: 8.6      MODIFIED:      09/03/96   By: jzw  *K008*            */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane       */
/*                                   11/25/96   By: *K01X* jzw             */
/*                                   11/10/97   BY: *K197* Jeff Wootton    */
/* REVISION: 8.6E     LAST MODIFIED: 04/22/98   BY: *J2D9* Sachin Shah     */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan      */
/* REVISION: 8.6E     LAST MODIFIED: 04/27/99   BY: *J3DV* Santosh Rao     */
/* REVISION: 8.6E     LAST MODIFIED: 08/20/99   BY: *J3KY* Sachin Shinde   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* myb             */
/* REVISION: 9.1      LAST MODIFIED: 09/11/00   BY: *M0S3* Veena Lad       */
/* REVISION: 9.1      LAST MODIFIED: 10/11/00   BY: *L12X* Shilpa Athalye  */
/* REVISION: 9.1      LAST MODIFIED: 09/30/00   BY: *N0W4* Mudit Mehta     */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.11.2.8    BY: Manjusha Inglay    DATE: 04/26/02  ECO: *M1X7*  */
/* Revision: 1.11.2.9    BY: Samir Bavkar       DATE: 07/07/02  ECO: *P0B0*  */
/* $Revision: 1.11.2.10 $  BY: Ashish Maheshwari  DATE: 10/16/02  ECO: *N1W5*  */
/* $Revision: 1.11.2.10 $  BY: Bill Jiang  DATE: 07/27/06  ECO: *SS - 20060727.1*  */

/* SS - 20060727.1 - B */
/*
1. 更正了以下BUG:
   1) 应纳税
   2) 不含税
   3) 修改了价格
*/
/* SS - 20060727.1 - E */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*!
    txmeth01.p  qad Generic Tax Calculation routine
                receives the following parameters
        input   tax_code        tx2_tax_code    Tax Code
        input   tax_round       txed_round      Rounding Method
        input   tax_curr        tx2d_curr       Tax Currency
        input   tax_in          sod_tax_in      Tax Included In Price
        input   tr_type         tx2d_tr_type    Tax Transaction Type
        input   ref             tx2d_ref        Document Reference
        input   nbr             tx2d_nbr        Second Reference
        input   line            tx2d_line       Line Number
        input   trlr_code       trl_code        Trailer_code
        input   tax_line        tx2d_line       Tax Line Number
        input   adj_factor      mfc_decimal     Adjustment factor
        input   exrate          so_ex_rate      Transaction exchange rate
        input   exrate2         so_ex_rate2     Transaction exchange rate
        input   tot_amt         tx2d_totamt     Total Amount
        input   adjust_factor   mfc_decimal     Flexible Adjustment Factor
        output  taxes           mfc_decimal     Taxes
        output  tax_base_amt    mfc_decimal     Taxable Base Amount
        output  ntax_amt        mfc_decimal     Non-Taxable Amount

*/
/*!
    NOTE: ANY CHANGES MADE TO THIS PROGRAM SHOULD ALSO BE MADE TO
          ALL TXMETH*.P PROGRAMS
*/
/***************************************************************************/

{mfdeclre.i}
{cxcustom.i "TXMETH01.P"}

   define input        parameter tax_code     like tx2_tax_code         no-undo.
   define input        parameter tax_round    like txed_round           no-undo.
   define input        parameter amt_curr     like tx2d_curr            no-undo.
   define input        parameter tax_in       like sod_tax_in           no-undo.
   define input        parameter tr_type      like tx2d_tr_type         no-undo.
   define input        parameter ref          like tx2d_ref             no-undo.
   define input        parameter nbr          like tx2d_nbr             no-undo.
   define input        parameter line         like tx2d_line            no-undo.
   define input        parameter trlr_code    like tx2d_trl             no-undo.
   define input        parameter tax_line     like tx2d_line            no-undo.
   define input        parameter adj_factor   like mfc_decimal          no-undo.
   define input        parameter exrate       like so_ex_rate           no-undo.
   define input        parameter exrate2      like so_ex_rate           no-undo.
   define input-output parameter tot_amt      like tx2d_totamt          no-undo.
   define output       parameter taxes        like tx2d_totamt          no-undo.
   define output       parameter adj_amt      like tx2d_totamt          no-undo.
   define output       parameter recoverable  like tx2d_totamt          no-undo.
   define output       parameter tax_base_amt like tx2d_totamt          no-undo.
   define output       parameter ntax_amt     like tx2d_totamt          no-undo.

   define variable     start_tot              like tx2d_totamt          no-undo.
   define variable     base_percent           like mfc_dec format "->>9.99<<%"
                                                   label "Base Percent" no-undo.
   define variable     ar_ap                  as   logical initial true no-undo.
   define variable     found_base_tx2d        like mfc_logical          no-undo.
   define variable l_mintax                   like tx2_min              no-undo.
   define variable l_maxtax                   like tx2_max              no-undo.
   define variable l_mc_error_nbr             like msg_nbr              no-undo.

   {gpcrnd.i}

   /* INITIALIZE MULTI-CURRENCY PROCEDURE LIBRARY */
   {gprunpdf.i "mcpl" "p"}

   /* FIND TAX RATE MASTER */

   for first tx2_mstr
      fields (tx2_apr_use tx2_ara_use tx2_base
              tx2_max tx2_min tx2_pct_recv
              tx2_tax_code tx2_tax_pct)
      where tx2_tax_code = tax_code
   no-lock :
   end. /* FOR FIRST tx2_mstr */

   if not available tx2_mstr
   then do:
      /* TAX MASTER DOES NOT EXIST */
      {pxmsg.i &MSGNUM=872 &ERRORLEVEL=4}
   end. /* IF NOT AVAILABLE tx2_mstr */

   /* CURRENCY ISSUES FOR TAXABLE AMOUNT? */
   /* CALCULATE */
   if tx2_tax_pct = 0
   then
      assign
         taxes        = 0
         tax_base_amt = tot_amt
         ntax_amt     = 0.

   else do:
      start_tot = tot_amt.
      /* CHECK TAX INCLUDED */
      if tax_in
      then
         tot_amt = (tot_amt * 100)/(100 + tx2_tax_pct).

      /* CHECK TAX BASE */
      assign
         tax_base_amt = tot_amt
         ntax_amt     = 0.
      if tx2_base > ""
      then do:

         for first code_mstr
            fields (code_cmmt code_fldname code_value)
            where code_fldname = "txb_base"
              and code_value = tx2_base
         no-lock :
         end. /* FOR FIRST code_mstr */

         if available code_mstr
         then do:

            for each txbd_det
               fields (txbd_base txbd_tax_type)
               where txbd_base = tx2_base
            no-lock:

               found_base_tx2d = no.

               base_tx2d:
               for each tx2d_det
                   where tx2d_ref     = ref
                     and tx2d_nbr     = nbr
                     and tx2d_trl     = trlr_code
                     and tx2d_tr_type = tr_type
               exclusive-lock:

                  if  tax_line  <> 0 /* TAX_BY_LINE = YES */
                  and tx2d_line <> tax_line /* NOT SAME LINE */
                  then
                     next base_tx2d.  /* NOT WANTED */

                  if tx2d_tax_type <> txbd_tax_type  /* NOT SAME TAX TYPE */
                  then
                     next base_tx2d.  /* NOT WANTED */

                  found_base_tx2d = yes.

                  /* SS - 20060727.1 - B */
                  /*
                  if not tx2d_tax_in
                     /* FIRST TAX WAS NOT TAX-INCLUDED */
                  or (tx2d_tax_in and not tax_in)
                     /* FIRST TAX WAS TAX-INCLUDED, */
                     /* THIS TAX IS NOT TAX-INCLUDED, */
                     /* SO NEED TO ADD TAX TO THE BASE AMOUNT. */
                  then
                     /* UPDATE tx2d__qadd02[1] AS TO CONTAIN TAX AMOUNT OF    */
                     /* CURRENT tx2d_det RECORD AND STORE IT IN               */
                     /*  tx2d__qadd02[2] TO USE IN SUBSEQUENT LINE OF ORDER   */
                     /* TO CALCULATE TAX AMOUNT WITH SAME taxtype IF REQUIRED */
                     assign
                        tx2d__qadd02[1] = tx2d_cur_tax_amt - tx2d__qadd02[1]
                                          + tx2d__qadd02[2]
                        tax_base_amt    = tax_base_amt + tx2d__qadd02[1]
                        tx2d__qadd02[2] = tx2d__qadd02[1].
                  */
                  IF TX2d_tr_type <> "22" THEN DO:
                     if not tx2d_tax_in
                        /* FIRST TAX WAS NOT TAX-INCLUDED */
                     or (tx2d_tax_in and not tax_in)
                        /* FIRST TAX WAS TAX-INCLUDED, */
                        /* THIS TAX IS NOT TAX-INCLUDED, */
                        /* SO NEED TO ADD TAX TO THE BASE AMOUNT. */
                     then
                        /* UPDATE tx2d__qadd02[1] AS TO CONTAIN TAX AMOUNT OF    */
                        /* CURRENT tx2d_det RECORD AND STORE IT IN               */
                        /*  tx2d__qadd02[2] TO USE IN SUBSEQUENT LINE OF ORDER   */
                        /* TO CALCULATE TAX AMOUNT WITH SAME taxtype IF REQUIRED */
                        assign
                           tx2d__qadd02[1] = tx2d_cur_tax_amt - tx2d__qadd02[1]
                                             + tx2d__qadd02[2]
                           tax_base_amt    = tax_base_amt + tx2d__qadd02[1]
                           tx2d__qadd02[2] = tx2d__qadd02[1].
                  END.
                  /* SS - 20060727.1 - E */

               end. /* BASE_TX2D: */

               if found_base_tx2d = no
               then do:
                  /* TAX DETAIL RECORD FOR TAX BASE TAX TYPE DOES NOT EXIST */
                  {pxmsg.i &MSGNUM=868 &ERRORLEVEL=2}
               end. /* IF found_base_tx2d = no */
            end. /* FOR EACH txbd_det */

            /* MULTIPLY TOTAL BY PERCENTAGE */
            assign
               base_percent = decimal(substring(code_cmmt,1,9))
               ntax_amt     = tax_base_amt * (1 - base_percent / 100)
               tax_base_amt = tax_base_amt * base_percent / 100.

         end. /* IF AVAILABLE code_mstr */
         else do:
            /* TAX BASE DOES NOT EXIST */
            {pxmsg.i &MSGNUM=866 &ERRORLEVEL=2}
         end. /* IF AVAILABLE code_mstr ELSE */
      end. /* IF TX2_BASE > "" */


      /* CHECK MIN/MAX AMOUNTS */

      /* MIN/MAX AMOUNTS ARE CONVERTED TO TRANSACTION CURRENCY, */
      /* IF REQUIRED AND THEN COMPARED WITH tax_base_amt.       */

      assign
         l_mintax = tx2_min
         l_maxtax = tx2_max.

      if amt_curr <> base_curr
      then do:
         run base_to_foreign (input-output l_mintax).
         run base_to_foreign (input-output l_maxtax).
      end. /* IF amt_curr <> base_curr */

      if     (l_mintax      > 0      )
         and (tax_base_amt  > 0      )
         and (tax_base_amt  < l_mintax)
      then
         assign
            ntax_amt     = ntax_amt + tax_base_amt - l_mintax
            tax_base_amt = l_mintax.

      else if (l_mintax        > 0       )
         and ( tax_base_amt    < 0       )
         and ((- tax_base_amt) < l_mintax)
      then
         assign
            ntax_amt     = ntax_amt - (- tax_base_amt - l_mintax)
            tax_base_amt = - (l_mintax).

      else if (l_maxtax     > 0
         and   tax_base_amt > l_maxtax)
      then
         assign
            ntax_amt     = ntax_amt + tax_base_amt - l_maxtax
            tax_base_amt = l_maxtax.

      else if (l_maxtax        > 0       )
         and ( tax_base_amt    < 0       )
         and ((- tax_base_amt) > l_maxtax)
      then
         assign
            ntax_amt     = ntax_amt - (- tax_base_amt - l_maxtax)
            tax_base_amt = - (l_maxtax).

      /* CALCULATE */
      taxes = tax_base_amt * (tx2_tax_pct / 100) * adj_factor.

      /*NOTE: THE adj_factor VALUE IS USED TO ALLOW SPECIAL CASE CALCULATIONS
              SUCH AS VAT DISCOUNT AT PAYMENT OR INVOICE ADJUSTMENTS.  */

      /* APPLY ROUNDING */
      /* DETERMINE ROUNDING METHOD */

      run gpcrnd (input-output taxes,input tax_round).

      /* DERIVE OUTPUT VALUES */
      /* FORCE TAX INCLUDED AMOUNTS TO MATCH TOTAL AMOUNT */
      if tax_in
      then do:
         tot_amt = start_tot.
         if (taxes + tax_base_amt <> tot_amt)
         then
            tax_base_amt = tot_amt - taxes.
      end. /* IF tax_in */

      /* HANDLE AP Reverse & AR Absorbed Amounts */

      /* ADD TRANSACTION TYPES FOR LOGISTICS CHARGES(40-48) */
      {&TXMETH01-P-TAG1}
      ar_ap = lookup(tr_type,
             "20,21,22,23,24,25,26,27,28,29,32,40,41,42,43,44,45,46,47,48") = 0.
      {&TXMETH01-P-TAG2}

      if  ar_ap
      and tx2_ara_use
      then
         adj_amt = - taxes.
      else if not ar_ap
      then do:
         if tx2_apr_use
         then
            adj_amt = - taxes.
         if tx2_pct_recv <> 0
         then do:
            recoverable = (( taxes) * (tx2_pct_recv / 100)).
            run gpcrnd (input-output recoverable,input tax_round).
         end. /*  IF tx2_pct_recv <> 0 */
      end. /* ELSE IF NOT ar_ap */
   end. /* IF tx2_tax_pct = 0 ELSE */

   /* CONVERT FROM BASE TO FOREIGN CURRENCY */
   PROCEDURE base_to_foreign:

      define input-output parameter l_amt like tx2d_totamt no-undo.

      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input base_curr,
           input amt_curr,
           input exrate2,
           input exrate,
           input l_amt,
           input true, /* ROUND */
           output l_amt,
           output l_mc_error_nbr)"}.

      /* ERROR CHECK ROUND METHOD FOR base_curr */
      if l_mc_error_nbr <> 0
      then do:
         {pxmsg.i
            &MSGNUM = l_mc_error_nbr
            &ERRORLEVEL = 2
         }
      end.

   END PROCEDURE. /* PROCEDURE base_to_foreign */
