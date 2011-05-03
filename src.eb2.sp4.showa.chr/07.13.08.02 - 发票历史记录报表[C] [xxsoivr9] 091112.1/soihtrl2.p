/* soihtrl2.p - CLOSED INVOICE TRAILER                                       */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.26.1.1 $                                                              */
/*V8:ConvertMode=Report                                                      */
/* REVISION: 7.4            CREATED: 09/23/94   BY: bcm *H536*               */
/*           7.4                     12/01/94   BY: bcm *H601*               */
/*           8.5                     07/13/95   BY: taf *J053*               */
/*           7.4                     07/06/95   BY: jym *H0F7*               */
/*           7.4                     08/01/95   BY: jym *G0T3*               */
/* REVISION  8.5      LAST MODIFIED: 10/03/97   BY: *H1FT* MANISH K.         */
/* REVISION  8.5      LAST MODIFIED: 11/18/97   BY: *H1F8* Nirav Parikh      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 05/06/98   BY: *L00L* Ed v.d.Gevel      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* REVISION: 8.6E     LAST MODIFIED: 07/15/98   BY: *L024* Steve Goeke       */
/* REVISION: 8.6E     LAST MODIFIED: 12/04/98   BY: *J360* Poonam Bahl       */
/* REVISION: 8.6E     LAST MODIFIED: 01/22/99   BY: *J38T* Poonam Bahl       */
/* REVISION: 8.6E     LAST MODIFIED: 05/07/99   BY: *J3DQ* Niranjan R.       */
/* REVISION: 8.6E     LAST MODIFIED: 01/04/00   BY: *J3N6* Santosh Rao       */
/* REVISION: 9.1      LAST MODIFIED: 09/05/00   BY: *N0RF* Mark Brown        */
/* REVISION: 9.1      LAST MODIFIED: 09/06/00   BY: *N0D0* Santosh Rao       */
/* Revision: 1.25       BY: Amit Chaturvedi     DATE: 01/20/03  ECO: *N20Y*  */
/* Revision: 1.26       BY: Vandna Rohira       DATE: 04/28/03  ECO: *N1YL*  */
/* $Revision: 1.26.1.1 $         BY: Vivek Gogte         DATE: 07/14/03  ECO: *N2GZ*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*! N1YL HAS CHANGED THE WAY TAXABLE/NON-TAXABLE AMOUNT IS CALCULATED.
    THE ORDER DISCOUNT IS APPLIED FOR EACH LINE TOTAL AND THEN IT IS
    SUMMED UP TO CALCULATE THE TAXABLE/NON-TAXABLE AMOUNT BASED ON THE
    TAXABLE STATUS OF EACH LINE. PREVIOUSLY, TAXABLE/NON-TAXABLE AMOUNT
    WAS OBTAINED FROM THE GTM TABLES. THIS CAUSED PROBLEMS WHEN
    MULTIPLE TAXABLE BASES ARE USED TO CALCULATE TAX.

    TAXABLE/NON-TAXABLE AMOUNT WILL NOW BE DISPLAYED IN THE TRAILER
    FRAME BASED ON THE VALUE OF THE FLAG "DISPLAY TAXABLE/NON-TAXABLE
    AMOUNT ON TRAILER" IN THE GLOBAL TAX MANAGEMENT CTRL FILE
 */

{mfdeclre.i}
{gprunpdf.i "sopl" "p"}

/* SHARED VARIABLES */
define shared variable ih_recno           as recid.
define shared variable taxable_amt        as decimal
   format "->>>>,>>>,>>9.99"
   label "Taxable".
define shared variable nontaxable_amt   like taxable_amt
   label "Non-Taxable".
define shared variable line_total         as decimal
   format "-zzzz,zzz,zz9.99"
   label "Line Total".
define shared variable disc_amt         like line_total
   label "Discount"
   format "(zzzz,zzz,zz9.99)".
define shared variable tax_amt          like line_total
   label "Total Tax".
define shared variable ord_amt          like line_total
   label "Total".
define shared variable invcrdt            as character format "x(15)".
define shared variable user_desc        like trl_desc extent 3.
define shared variable tax_date         like ih_tax_date.
define shared variable col-80           like mfc_logical.
define shared variable rndmthd          like rnd_rnd_mthd.
define shared variable l_tax_in         like tax_amt no-undo.
define shared variable l_nontaxable_lbl as character format "x(12)" no-undo.
define shared variable l_taxable_lbl    as character format "x(12)" no-undo.

/* GENERAL VARIABLES  */
define variable ext_price               like idh_price            no-undo.
define variable ext_actual              like idh_price            no-undo.
define variable tax_lines               like tx2d_line initial 0  no-undo.
define variable page_break                as integer   initial 10 no-undo.
define variable tax_ref                 like tx2d_ref             no-undo.
define variable tax_nbr                 like tx2d_nbr             no-undo.
define variable tax_tr_type             like tx2d_tr_type
   initial "16"                                                   no-undo.
define variable tmp_amt                   as decimal              no-undo.
define variable auth_price              like sod_price
   format "->>>>,>>>,>>9.99"                                      no-undo.
define variable auth_found              like mfc_logical          no-undo.
define variable l_ext_actual            like idh_price            no-undo.

/* l_ext_actual IS THE EXTENDED AMOUNT EXCLUDING DISCOUNT. IT WILL */
/* BE USED FOR THE CALCULATION OF taxable_amt AND nontaxable_amt   */
define shared temp-table t_absr_det     no-undo
   field t_absr_reference like absr_reference
   field t_absr_qty       as decimal format "->>>>,>>>,>>9.99"
   field t_absr_ext       as decimal format "->>>>,>>>,>>9.99".

{socurvar.i}
{etdcrvar.i}
{etvar.i}
{etrpvar.i}

do for ih_hist:     /*scope this trans */

   for first ih_hist
      fields(ih_curr      ih_disc_pct ih_due_date ih_inv_nbr ih_nbr
             ih_ship_date ih_tax_date ih_trl1_amt ih_trl1_cd ih_trl2_amt
             ih_trl2_cd   ih_trl3_amt ih_trl3_cd)
      where recid(ih_hist) = ih_recno
      no-lock:
   end. /* FOR FIRST ih_hist */.

   assign
      tax_ref = ih_inv_nbr
      tax_nbr = "*".

   taxloop:
   do on endkey undo, leave:

      /*** GET TOTALS FOR LINES ***/

      assign
         line_total     = 0
         taxable_amt    = 0
         nontaxable_amt = 0.

      if ih_tax_date <> ?
      then
         tax_date = ih_tax_date.
      else
      if ih_ship_date <> ?
      then
         tax_date = ih_ship_date.
      else
         tax_date = ih_due_date.

      /* CALCULATE EXTENDED AMOUNTS */
      /* OBTAINING LINE TOTALS FOR THE SALES ORDER */
      /* ADDED FIELD idh_tax_in                    */
      for each idh_hist
         fields(idh_inv_nbr idh_line    idh_nbr   idh_part
                idh_price   idh_qty_inv idh_sched idh_site
                idh_taxable idh__qadc06 idh_tax_in)
         where idh_inv_nbr = ih_inv_nbr
           and idh_nbr     = ih_nbr
      no-lock:

         assign
            ext_actual   = idh_price * idh_qty_inv
            l_ext_actual = (idh_price * idh_qty_inv
                            * (1 - ih_disc_pct / 100)).


         /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output ext_actual,
              input        rndmthd,
              output       mc-error-number)" }

         if mc-error-number <> 0
         then do:

            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end. /* IF mc-error-number <> 0 */

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output l_ext_actual,
              input        rndmthd,
              output       mc-error-number)" }

         if mc-error-number <> 0
         then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end. /* IF mc-error-number <> 0 */

         /* CHECK AUTHORIZATION RECORDS FOR DIFFERENT EXTENDED PRICE */
         if idh_sched
         then do:

            auth_found = no.

            {gprun.i ""soauthbl.p""
               "(input idh_inv_nbr,
                 input idh__qadc06,
                 input idh_nbr,
                 input idh_line,
                 input idh_part,
                 input idh_price,
                 input idh_site,
                 input ext_actual,
                 output auth_price,
                 output auth_found)"}

            ext_actual = auth_price.

         end. /*IF idh_sched */

         /* CALL THE PROCEDURE TO GET LINE TOTAL ONLY WHEN TAX IS */
         /* INCLUDED                                              */
         if idh_tax_in
         then do:
            {gprunp.i "sopl" "p" "getExtendedAmount"
               "(input        rndmthd,
                 input        idh_line,
                 input        ih_inv_nbr,
                 input        ih_nbr,
                 input        tax_tr_type,
                 input-output ext_actual)"}
         end. /* IF idh_tax_in */

         line_total = line_total + ext_actual.

         if idh_taxable
         then
            taxable_amt = taxable_amt + l_ext_actual.
         else
            nontaxable_amt = nontaxable_amt + l_ext_actual.
      end. /* FOR EACH idh_hist */

      disc_amt = (- line_total * (ih_disc_pct / 100)).

      /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output disc_amt,
           input        rndmthd,
           output       mc-error-number)" }

      if mc-error-number <> 0
      then do:

         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end. /* IF mc-error-number <> 0 */

      /* ADD TRAILER AMOUNTS */
      {txtrltrl.i ih_trl1_cd ih_trl1_amt user_desc[1]}
      {txtrltrl.i ih_trl2_cd ih_trl2_amt user_desc[2]}
      {txtrltrl.i ih_trl3_cd ih_trl3_amt user_desc[3]}

      {gprun.i ""txabsrb.p"" "(input ih_inv_nbr,
           input ih_nbr,
           input tax_tr_type,
           input-output line_total,
           input-output taxable_amt)"}

      /* DISCOUNT AMOUNT IS ADJUSTED TO AVOID ROUNDING ERROR */
      /* IN CALCULATION OF ORDER AMOUNT                      */
      if l_tax_in <> 0
      then do:
         {gprunp.i "sopl" "p" "adjustDiscountAmount"
            "(input        taxable_amt - l_tax_in,
              input        nontaxable_amt,
              input        ih_trl1_amt,
              input        ih_trl2_amt,
              input        ih_trl3_amt,
              input        line_total,
              input-output disc_amt)"}
      end. /* IF l_tax_in <> 0 */

      /* CALL TO txtotal.p IS MADE IN THE MAIN PROGRAM */

      /* ADJUSTING LINE TOTAL AND TAXABLE AMOUNT BY INCLUDED TAX */
      assign
         taxable_amt = taxable_amt - l_tax_in
         ord_amt     = line_total  + disc_amt + ih_trl1_amt
                     + ih_trl2_amt + ih_trl3_amt.

      /* DISPLAY TRAILER ONLY IF INVOICES ARE NOT CONSOLIDATED */
      /* DISPLAY TRAILER AFTER LINE DETAILS OF ALL CONSOLIDATED  */
      /* SALES ORDERS ARE DISPLAYED. THIS IS DONE IN soivto10.i  */

   end. /* TAXLOOP */

   {etdcrc.i ih_curr ih_hist.ih}

end. /* DO For ih_hist */
