/* txline.p - qad CALCULATE TAX FOR A LINE ITEM OR TRAILER                    */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.48 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* Revision: 7.3      CREATED:       11/17/92   By: bcm *G413*                */
/* REVISION: 7.4      MODIFIED:      06/30/93   BY: JMS *H010*                */
/*                                   10/15/93   BY: bcm *H212*                */
/*                                   03/29/94   BY: bcm *H303*                */
/*                                   06/14/94   BY: bcm *H383*                */
/*                                   06/24/94   BY: bcm *H407*                */
/*                                   10/07/94   BY: bcm *H556*                */
/*                                   02/23/95   BY: jzw *H0BM*                */
/*                                   03/07/95   BY: jzw *H0BV*                */
/*                                   03/25/95   BY: tvo *H0BJ*                */
/* REVISION: 8.5      MODIFIED:      07/05/95   BY: taf *J053*                */
/* REVISION: 8.5      MODIFIED:      05/02/96   BY: jpm *H0KV*                */
/* REVISION: 8.5      MODIFIED:      06/25/96   BY: *J0WF* Sue Poland         */
/* REVISION: 8.6      MODIFIED:      09/03/96   BY: jzw *K008*                */
/* REVISION: 8.6      MODIFIED:      09/26/96   BY: *K003* Vinay Nayak-Sujir  */
/*                                   11/25/96   BY: jzw *K01X*                */
/*                                   01/23/97   BY: rxm *H0QY*                */
/* REVISION: 8.6      LAST MODIFIED: 06/12/97   BY: *H19F* Irine D'mello      */
/* REVISION: 8.6      LAST MODIFIED: 06/27/97   BY: *J1VK* Irine D'mello      */
/* REVISION: 8.6      LAST MODIFIED: 10/20/97   BY: *K0JV* Shankar Subramanian*/
/* REVISION: 8.6      LAST MODIFIED: 11/10/97   BY: *K197* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* Old ECO marker removed, but no ECO header exists *H138*                    */
/* Old ECO marker removed, but no ECO header exists *H270*                    */
/* REVISION: 8.6E     LAST MODIFIED: 06/22/98   BY: *J2D9* Sachin Shah        */
/* REVISION: 8.6E     LAST MODIFIED: 06/30/98   BY: *L01B* Jim Josey          */
/* REVISION: 8.6E     LAST MODIFIED: 10/11/98   BY: *L0BG* Surendra Kumar     */
/* REVISION: 9.0      LAST MODIFIED: 12/16/98   BY: *M03Q* Robert Jensen      */
/* REVISION: 9.0      LAST MODIFIED: 03/06/99   BY: *L0D6* Jean Miller        */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 08/19/99   BY: *J3KV* Reetu Kapoor       */
/* REVISION: 9.1      LAST MODIFIED: 09/07/99   BY: *N02K* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Robin McCarthy     */
/* REVISION: 9.1      LAST MODIFIED: 10/18/99   BY: *N049* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 02/01/00   BY: *J3P0* Reetu Kapoor       */
/* REVISION: 9.1      LAST MODIFIED: 02/16/00   BY: *N07N* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* myb                */
/* REVISION: 9.1      LAST MODIFIED: 09/21/00   BY: *L138* Jose Alex          */
/* REVISION: 9.1      LAST MODIFIED: 09/22/00   BY: *N0D0* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 10/12/00   BY: *N0RW* Inna Lyubarsky     */
/* REVISION: 9.1      LAST MODIFIED: 10/13/00   BY: *L12X* Shilpa Athalye     */
/* REVISION: 9.1      LAST MODIFIED: 10/06/00   BY: *N0W4* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.39          BY: Abbas Hirkani     DATE: 07/10/01 ECO: *M1DN*   */
/* Revision: 1.40          BY: Ashish M.         DATE: 12/10/01 ECO: *M1R1*   */
/* Revision: 1.41          BY: Niranjan R.       DATE: 03/12/02 ECO: *P020*   */
/* Revision: 1.42          BY: Sandeep Parab     DATE: 03/13/02 ECO: *N1CZ*   */
/* Revision: 1.43          BY: Manjusha Inglay   DATE: 04/26/02 ECO: *M1X7*   */
/* Revision: 1.44          BY: Vandna Rohira     DATE: 05/24/02 ECO: *M1Z0*   */
/* Revision: 1.45          BY: Gnanasekar        DATE: 10/04/02 ECO: *N1VV*   */
/* Revision: 1.46          BY: Ashish Maheshwari DATE: 10/16/02 ECO: *N1W5*   */
/* Revision: 1.47          BY: Laurene Sheridan  DATE: 10/21/02 ECO: *N13P*   */
/* $Revision: 1.48 $       BY: Katie Hilbert     DATE: 12/31/02 ECO: *P0LM*   */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* ************************************************************************** */
/* Note: This code has been modified to run when called inside an MFG/PRO API */
/* method as well as from the MFG/PRO menu, using the global variable         */
/* c-application-mode to conditionally execute API- vs. UI-specific logic.    */
/* Before modifying the code, please review the MFG/PRO API Development Guide */
/* in the QAD Development Standards for specific API coding standards and     */
/* guidelines.                                                                */
/* ************************************************************************** */
/*!
    txline.p    qad Calculate Tax For a Line Item or Trailer
                receives the following parameters
        I/O     Name        Like            Description
        -----   ----------- --------------- ------------------------------
        input   tax_curr    tx2d_curr       Tax Currency
        input   tr_type     tx2d_tr_type    Transaction Type Code
        input   ref         tx2d_ref        Document Reference
        input   p_nbr       tx2d_nbr        Number (Shipper, etc.)
        input   line        tx2d_line       Line Item #
        input   trlr_code   tx2d_trl        Trailer Code
        input   taxable     so_taxable      Taxable Item
        input   tax_in      sod_tax_in      Tax Included in Price
        input   tax_date    tx2d_effdate    Tax Date
        input   tax_gl_date tx2d_effdate    GL Effective Date
        input   tax_env     txe_tax_env     Tax Environment
        input   tax_zone_from txz_tax_zone  Ship-From Tax Zone
        input   tax_zone_to txz_tax_zone    Ship-To Tax Zone
        input   taxc        tx2_pt_taxc     Tax Class
        input   usage       tx2_tax_usage   Tax Usage (Nature Of Operation)
        input   tax_amt     tx2d_totamt     Taxable Amount
        input   exrate      so_ex_rate      Transaction exchange rate
        input   exrate2     so_ex_rate2     Transaction exchange rate
        input   exratetype  so_ex_ratetype  Transaction exchange rate type.
        input   entity      en_entity       Transaction Entity
        input   det_entity  en_entity       Line Site Entity
        input   adj_fact    mfc_decimal     Adjustment Factor
        input   inv_disc    tx2_tax_pct     Credit Discount for Disc. at Invoice
        input   carrier     tx2d_carrier    Carrier used in the shipment

        ******************* QUANTUM RELATED INPUT PARAMETERS ******************
        input   company-code        en_entity    Company Code
        input   divn-code           so_site      Division Code
        input   cmvd-addr           ad_addr      Customer/ Supplier Address
        input   cmvd-taxclass       ad_taxc      Customer/ Supplier Tax Class
        input   orderaccept-taxzone txz_tax_zone Order Acceptance Tax Zone
        input   shipfrom-incity     mfc_logical  Ship-from Tax Zone
        input   shipto-incity       mfc_logical  Ship-to Tax Zone
        input   orderaccept-incity  mfc_logical  Order Acceptance Tax Zone
        input   lineitem-qty        sod_qty      Line Item Quantity
        input   vq-post             mfc_logical  Quantum Register Post flag
        input   vq-exch-rate        exr_rate     Exch Rate: Trans Curr - USD
        input   vq-exch-rate2       exr_rate2    Exch Rate: Trans Curr - USD
        input   vq-rndmthd          ex_rnd_mthd  Rounding Method:Trans Curr- US

        ******************* QUANTUM RELATED OUTPUT PARAMETERS *****************
        output  result-status       integer      Result Status

        Although nothing is passed back by this program, the tax detail
        records will contain all levels of detail necessary to display
        and edit the taxes and calculate totals for the document.
*/
/*
    Tax Methods
    00-49 qad use ONLY
    50-99 User defineable

    01  qad Standard rounds taxable base up to minimum base or down to max
    02  Min/Max Exclusionary - ignore lines not within the min/max range
    11  Regressive included tax calculation - tax based on base plus tax
    12  Argentina ONLY - Retencions based on cumulative AP Payments (2?,29 only)
*/
/***************************************************************************/
/* H0BJ Notes
 * Because the service-contracts and service-quote additional charges are
 * both in the sad_det file, and both have line-number 1, this caused some
 * problems within the GTM standard-routines like TXLINE.P. As a (temporary)
 * solution, the trailer code for additional charges (tx2d_trlr) is set
 * to 'A'.
*/

{mfdeclre.i}
{gplabel.i}
{cxcustom.i "TXLINE.P"}

define variable mc-error-number like msg_nbr no-undo.

define input parameter tax_curr         like tx2d_curr no-undo.
define input parameter tr_type          like tx2d_tr_type no-undo.
define input parameter ref              like tx2d_ref no-undo.
define input parameter p_nbr            like tx2d_nbr no-undo.
define input parameter line             like tx2d_line no-undo.
define input parameter trlr_code        like tx2d_trl no-undo.
define input parameter taxable          like so_taxable no-undo.
define input parameter tax_in           like sod_tax_in no-undo.
define input parameter tax_date         like tx2d_effdate no-undo.
define input parameter tax_gl_date      like tx2d_effdate no-undo.
define input parameter tax_env          like txed_tax_env no-undo.
define input parameter tax_zone_from    like txz_tax_zone no-undo.
define input parameter tax_zone_to      like txz_tax_zone no-undo.
define input parameter taxc             like tx2_pt_taxc no-undo.
define input parameter usage            like tx2_tax_usage no-undo.
define input parameter tax_amt          like tx2d_totamt no-undo.
define input parameter exrate           like so_ex_rate no-undo.
define input parameter exrate2          like so_ex_rate2 no-undo.
define input parameter exratetype       like so_ex_ratetype no-undo.
define input parameter entity           like en_entity no-undo.
define input parameter det_entity       like en_entity no-undo.
define input parameter adj_fact         like mfc_decimal no-undo.
define input parameter inv_disc         like tx2_tax_pct no-undo.
define input parameter carrier          like tx2d_carrier no-undo.

/*********** BEGIN QUANTUM RELATED PARAMETERS *********************
* DEFINE QUANTUM RELATED VARIABLES.
* THESE VALUES WILL HAVE NO EFFECT ON THE TAX CALCULATIONS OR POSTING
* NOT INVOLVING QUANTUM
* ******************************************************************/

define input  parameter company-code        as character no-undo.
define input  parameter divn-code           as character no-undo.
define input  parameter cmvd-addr           as character no-undo.
define input  parameter cmvd-taxclass       as character no-undo.
define input  parameter orderaccept-taxzone as character no-undo.
define input  parameter shipfrom-incity     as logical no-undo.
define input  parameter shipto-incity       as logical no-undo.
define input  parameter orderaccept-incity  as logical no-undo.
define input  parameter lineitem-qty        as decimal no-undo.
define input  parameter vq-post             as logical no-undo.
define input  parameter vq-exch-rate        like exr_rate no-undo.
define input  parameter vq-exch-rate2       like exr_rate2 no-undo.
define input  parameter vq-rndmthd          like cu_rnd_mthd no-undo.
define output parameter result-status       as   integer no-undo.

/*********** END QUANTUM RELATED PARAMETERS ***********************/

define variable rndmthd                 like rnd_rnd_mthd no-undo.
define variable tmp_amt                 as   decimal no-undo.
define variable filename                like mfc_char no-undo.
define variable tax_round               like txed_round no-undo.
define variable taxes                   like tx2d_totamt no-undo.
define variable tot_amt                 like tx2d_totamt no-undo.
define variable adj_amt                 like tx2d_totamt no-undo.
define variable tax_base_amt            like tx2d_totamt no-undo.
define variable ntax_amt                like tx2d_totamt no-undo.
define variable tax_by_line             like tx2_by_line no-undo.
define variable entity_exrate           like exr_rate no-undo.
define variable entity_exrate2          like exr_rate2 no-undo.
define variable adj_factor              like mfc_decimal no-undo.
define variable recoverable             like mfc_decimal no-undo.
define variable use_tax_in              as   logical initial false no-undo.
define variable taxable_this_line       like so_taxable no-undo.
define variable taxable_this_txed       like so_taxable no-undo.
define variable taxc_this_line          like tx2_pt_taxc no-undo.
define variable taxc_this_txed          like tx2_pt_taxc no-undo.
define variable taxable_amt_this_line   like tx2d_totamt no-undo.
define variable taxable_amt_this_txed   like tx2d_totamt no-undo.
define variable rndmthd1                like rnd_rnd_mthd no-undo.
define variable nbr                     like tx2d_nbr no-undo.
define variable entity_or_trlr_code     like tx2d_trl no-undo.

/************* QUANTUM RELATED VARIABLE **************************/
define variable first-taxtype           as   logical.
define variable method_3_found          as   integer initial 0 no-undo.

/* INCLUDE VQ WORKFILE HERE. THIS FILE HAS A FEW VARIABLE(S)      */
/* DEFINED THAT WILL ENSURE CALLING OF THE QUANTUM API ONLY ONCE  */
/* FOR A DOCUMENT. IT HAS A TEMP-TABLE DEFINITION THAT WILL HOLD  */
/* ALL THE LINE ITEM, TAX TYPE INFORMATION AND WILL CALL          */
/* VQTXCALC.P AFTER THE LAST LINE ITEM IN A FOR EACH ... LOOP     */
/* IS PROCESSED.                                                  */

{vqwrkdef.i}

/* ALLOW USERS TO EXECUTE OWN CODE */
{txline.i}

/* GET THE DOCUMENT CURRENCY ROUNDING METHOD - USING TAX_CURR */

for first gl_ctrl
   fields (gl_base_curr gl_rnd_mthd)
   no-lock :
end. /* FOR FIRST gl_ctrl */

if (gl_base_curr <> tax_curr)
then do:

   {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
      "(input tax_curr,
        output rndmthd,
        output mc-error-number)"}

   if mc-error-number <> 0
   then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.
end. /* IF (gl_base_curr <> tax_curr) */
else
   rndmthd = gl_rnd_mthd.

/* TAX_AMT IS THE AMOUNT THAT IS TAXABLE, IT IS NOT A TAX AMOUNT */
/* WE NOW HAVE RNDMTHD.  THE INPUT VARIABLE TAX_AMT IS UNROUNDED */
/* ROUND IT NOW USING DOC CURRENCY RNDMTHD */

{gprunp.i "mcpl" "p" "mc-curr-rnd"
   "(input-output tax_amt,
     input rndmthd,
     output mc-error-number)"}

/* ERROR CHECK FOR VALID ROUND METHOD */
if mc-error-number <> 0
then do:
   {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
end.

/* GET TAX ENV */
/* NOTE: THE TAX ENVIRONMENT USUALLY COMES FROM THE TRANSACTION */
/*       BUT MAY BE SPECIFIED IN THE LINE DETAIL */

for first code_mstr
   fields (code_fldname code_value)
   where code_fldname = "txe_tax_env"
   and   code_value   = tax_env
   no-lock :
end.

if not available code_mstr
then do:
   /* TAX ENVIRONMENT DOES NOT EXIST */
   {pxmsg.i &MSGNUM=869
            &ERRORLEVEL=4}
   if c-application-mode = "API" then
      return.
end.

if taxable
then do:
   assign
      taxable_this_line     = taxable
      taxc_this_line        = taxc
      taxable_amt_this_line = tax_amt.
   /* THIS MAY INCLUDE TAX AT THIS POINT */

   /* FOR ORDER TRAILER CODES, LINE IS SET TO 99999 TXCALTRL.I */
   if line = 99999999
   then do:

      for first trl_mstr
         fields (trl_code trl_taxable trl_taxc)
         where trl_code = trlr_code
         no-lock:
      end.

      if available(trl_mstr)
      then
         assign
            taxable_this_line = trl_taxable
            taxc_this_line    = trl_taxc.
      else
         assign
            taxable_this_line = false
            taxc_this_line    = "".
   end.  /* IF line = 9999 */

   /* INITIALIZE FIRST TAX-TYPE. THE LOGIC FOR THE QUANTUM TAX */
   /* CALCULATION PROCEDURE IN MFG/PRO USES THIS FLAG */
   first-taxtype = yes.

   /* LOOP THROUGH TAX TYPES */
   for each txed_det
      where txed_tax_env = code_value
      no-lock
      break by txed_seq:

      assign
         taxable_this_txed     = taxable_this_line
         taxc_this_txed        = taxc_this_line
         taxable_amt_this_txed = taxable_amt_this_line.

      /* (THIS MAY INCLUDE TAX FOR THE FIRST TXED, */
      /* BUT THIS WILL HAVE BEEN REMOVED FOR SUBSEQUENT TAXES) */
      /* FOR ORDER TRAILER CODES, LINE IS SET TO 99999 TXCALTRL.I */
      if line = 99999999
      then do:
         /* LOOK FOR TRAILER EXCEPTIONS */
         if trlr_code > ""
            and can-find(trld_det where trld_code = trlr_code
                         and trld_tax_type = txed_tax_type)
         then do:

            for first trld_det
               fields (trld_code trld_taxable trld_taxc trld_tax_type)
               where trld_code = trlr_code
               and trld_tax_type = txed_tax_type
               no-lock:
            end.

            assign
               taxable_this_txed = trld_taxable
               taxc_this_txed    = trld_taxc.
         end.
      end.    /* IF LINE = 99999 */

      /* SETTING LAST-TAXTYPE IF THIS IS THE LAST LINE ITEM BEING */
      /* PROCESSED. */
      /* WILL BE USED WHEN QUANTUM IS USED TO CALCULATE TAXES */

      last-taxtype = if last(txed_seq) then yes
                        else no.

      /* GET ROUNDING METHOD */
      /* TRY TAX ENVIRONMENT DETAIL FIRST */
      if txed_round > ""
      then
         tax_round = txed_round.
      else do:
         /* TRY TAX CONTROL FILE NEXT */

         for first txc_ctrl
            fields (txc_inv_disc txc_pmt_disc
                    txc_rcpt_tax_point txc_round)
            no-lock :
         end.

         if (available(txc_ctrl) and txc_round > "")
         then do:
            tax_round = txc_round.
            release txc_ctrl.
         end.
         else
            /* SET TAX_ROUND EQUAL TO RNDMTHD */
            tax_round = rndmthd.
      end.

      /* LOOK UP TAX MASTER TYPE + TAXC + USAGE */

      for last tx2_mstr
         fields (tx2_apr_acct tx2_apr_cc tx2_ap_acct tx2_ap_cc
                 tx2_apr_sub  tx2_ap_sub tx2_ara_sub tx2_ar_sub
                 tx2_ara_acct tx2_ara_cc tx2_ar_acct tx2_ar_cc
                 tx2_by_line  tx2_desc tx2_effdate tx2_exp_date
                 tx2_inv_disc tx2_max tx2_method tx2_pmt_disc
                 tx2_pt_taxc tx2_rcpt_tax_point tx2_tax_code
                 tx2_tax_in tx2_tax_type tx2_tax_usage
                 tx2_pct_recv tx2_update_tax)
         where tx2_tax_type  = txed_tax_type
         and   tx2_pt_taxc   = taxc_this_txed
         and   tx2_tax_usage = usage
         and   tx2_effdate  <= tax_date
         /* CHECK EXPIRATION DATE */
         and  (tx2_exp_date    = ?
               or tx2_exp_date >= tax_date)
         no-lock :
      end.

      /* TYPE + TAXC + "" */
      if not available(tx2_mstr)
      then

         for last tx2_mstr
            fields (tx2_apr_acct tx2_apr_cc tx2_ap_acct tx2_ap_cc
                    tx2_apr_sub  tx2_ap_sub tx2_ara_sub tx2_ar_sub
                    tx2_ara_acct tx2_ara_cc tx2_ar_acct tx2_ar_cc
                    tx2_by_line  tx2_desc tx2_effdate tx2_exp_date
                    tx2_inv_disc tx2_max tx2_method tx2_pmt_disc
                    tx2_pt_taxc tx2_rcpt_tax_point tx2_tax_code
                    tx2_tax_in tx2_tax_type tx2_tax_usage
                    tx2_pct_recv tx2_update_tax)
            where tx2_tax_type  = txed_tax_type
            and   tx2_pt_taxc   = taxc_this_txed
            and   tx2_tax_usage = ""
            and   tx2_effdate  <= tax_date
            /* CHECK EXPIRATION DATE */
            and  (tx2_exp_date    = ?
                  or tx2_exp_date >= tax_date)
            no-lock :
         end.

      /* TYPE + "" + USAGE */
      if not available(tx2_mstr)
      then

         for last tx2_mstr
            fields (tx2_apr_acct tx2_apr_cc tx2_ap_acct tx2_ap_cc
                    tx2_apr_sub  tx2_ap_sub tx2_ara_sub tx2_ar_sub
                    tx2_ara_acct tx2_ara_cc tx2_ar_acct tx2_ar_cc
                    tx2_by_line  tx2_desc tx2_effdate tx2_exp_date
                    tx2_inv_disc tx2_max tx2_method tx2_pmt_disc
                    tx2_pt_taxc  tx2_rcpt_tax_point tx2_tax_code
                    tx2_tax_in   tx2_tax_type tx2_tax_usage
                    tx2_pct_recv tx2_update_tax)
            where tx2_tax_type = txed_tax_type
            and tx2_pt_taxc    = ""
            and tx2_tax_usage  = usage
            and tx2_effdate   <= tax_date
            /* CHECK EXPIRATION DATE */
            and (tx2_exp_date    = ?
                 or tx2_exp_date >= tax_date)
            no-lock :
         end.

      /* TYPE + "" + "" */
      if not available(tx2_mstr)
      then

         for last tx2_mstr
            fields (tx2_apr_acct tx2_apr_cc tx2_ap_acct tx2_ap_cc
                    tx2_apr_sub  tx2_ap_sub tx2_ara_sub tx2_ar_sub
                    tx2_ara_acct tx2_ara_cc tx2_ar_acct tx2_ar_cc
                    tx2_by_line  tx2_desc tx2_effdate tx2_exp_date
                    tx2_inv_disc tx2_max tx2_method tx2_pmt_disc
                    tx2_pt_taxc  tx2_rcpt_tax_point tx2_tax_code
                    tx2_tax_in   tx2_tax_type tx2_tax_usage
                    tx2_pct_recv tx2_update_tax)
            where tx2_tax_type = txed_tax_type
            and tx2_pt_taxc    = ""
            and tx2_tax_usage  = ""
            and tx2_effdate   <= tax_date
            /* CHECK EXPIRATION DATE */
            and (tx2_exp_date     = ?
                 or tx2_exp_date >= tax_date)
            no-lock :
         end.

      /* GIVE WARNING */
      if not available(tx2_mstr)
      then do:
/* xp001
		{pxmsg.i &MSGNUM=871 &ERRORLEVEL=2}
         /* TAX RATE MASTER DOES NOT EXIST */
         {pxmsg.i &MSGNUM=934
                  &ERRORLEVEL=2
                  &MSGARG1="txed_tax_type"
                  &MSGARG2="taxc_this_txed"
                  &MSGARG3="usage"}
         /* Don't hang batch processing for a warning. */

         if not batchrun
         then
            pause. 
xp001 */

         next.
      end.

      use_tax_in = tax_in and tx2_tax_in.

      /* DETERMINE TAXABLE AMOUNT FOR THIS TAX TYPE */
      if use_tax_in
      then
         taxable_amt_this_txed = tax_amt.
      else
         taxable_amt_this_txed = taxable_amt_this_line.

      /* USE A VARIABLE FOR DOCUMENT NUMBER SO WE CAN OVERRIDE IT */
      nbr = p_nbr.

      /* PO MAINTENANCE SHOULD CREATE tx2d_det RECORDS BASED ON    */
      /* Tax-By-Line SETTING REGARDLESS OF Accrue Tax At Receipt   */
      /* FLAG. PO RECEIPTS, PO RETURNS, PO FISCAL RECEIVING, PO    */
      /* SHIPPER RECEIPT AND VOUCHER MAINTENANCE SHOULD CREATE     */
      /* tx2d_det RECORDS BY LINE WHEN Accrue Tax At Receipt FLAG  */
      /* SET TO YES OR Tax-By-Line FLAG SET TO YES OR PERCENT      */
      /* RECOVERABLE NOT EQUAL TO 100% OR TAX IS INCLUDED. WHEN    */
      /* Accrue Tax At Receipt FLAG SET TO NO AND Tax-By-Line FLAG */
      /* SET TO NO AND PERCENT RECOVERABLE SET EQUAL TO 100% AND   */
      /* TAX IS NOT INCLUDED, THE ABOVE FUNCTIONS SHOULD CREATE    */
      /* tx2d_det RECORDS BASED ON Tax-By-Line SETTING.            */

      /** MAKE TAX CALCULATIONS FOR PO, PO RETURNS AND    **/
      /** PO FISCAL RECEIVING INDEPENDENT OF TAX-BY-LINE  **/
      /* TAX METHOD 3 (EXTERNAL TAXES) IS BY LINE ONLY */

      {&TXLINE-P-TAG1}

      if ((tr_type = "21"
           or tr_type = "22"
           /* TYPE "23" IS NOT CALCULATED HERE, ONLY IN APVOMTI.P */
           or tr_type = "24"
           or tr_type = "25")
          and (tx2_rcpt_tax_point
               or tx2_by_line
               or tx2_pct_recv <> 100))
         /* (UNABLE TO SIMULATE A PURE VAT ENVIRONMENT) */
         or use_tax_in
         or not taxable_this_txed
         or tx2_method = "03"
      then
         tax_by_line = true.
      {&TXLINE-P-TAG2}
      else
      if tr_type = "18"
      then
         tax_by_line = false.
      else
         tax_by_line = tx2_by_line.

      if (tr_type = "22"  /* AP VOUCHER */
          or tr_type = "32") /* AP RECURRING VOUCHER */
          and not tax_by_line
      then
         assign
            /* FORCE TAX TO A BLANK DOCUMENT NUMBER */
            nbr = ""
            /* FOR AP VOUCHER, USE TX2D_TRL FOR ENTITY, */
            /* BECAUSE WE NEED SEPARATE TAX FOR EACH ENTITY.*/
            /* AP VOUCHER DOES NOT USE TRAILER CODES. */
            entity_or_trlr_code = det_entity.
      else
         entity_or_trlr_code = trlr_code.

      /* FIND/CREATE TAX DETAIL */
      if tax_by_line
      then
         for first tx2d_det
            where tx2d_ref      = ref
            and   tx2d_nbr      = nbr
            and   tx2d_line     = line
            and   tx2d_trl      = trlr_code
            and   tx2d_tr_type  = tr_type
            and   tx2d_tax_code = tx2_tax_code
            exclusive-lock:
         end.
      else /* BY-TOTAL RECORDS HAVE LINE = 0 */
         if tr_type = "38"
         then
            find tx2d_det where tx2d_ref      = ref
                            and tx2d_nbr      = nbr
                            and tx2d_line     = 0
                            and tx2d_trl      = ""
                            and tx2d_tr_type  = tr_type
                            and tx2d_tax_code = tx2_tax_code
            exclusive-lock no-error.
         else
            for first tx2d_det
               where tx2d_ref      = ref
                 and tx2d_nbr      = nbr
                 and tx2d_line     = 0
                 and tx2d_trl      = entity_or_trlr_code
                 and tx2d_tr_type  = tr_type
                 and tx2d_tax_code = tx2_tax_code
            exclusive-lock:
            end.

      /* CREATE TAX DETAIL */
      if not available(tx2d_det)
      then do:
         create tx2d_det.
         assign
            tx2d_ref = ref
            tx2d_nbr = nbr.

         /* IF BY-LINE USE LINE ITEM # ; ELSE USE 0 */
         if tax_by_line
         then
            assign
               tx2d_line = line
               tx2d_trl  = trlr_code.
         else
            assign
               tx2d_line = 0
               tx2d_trl  = (if tr_type = "38"
                            then
                               ""
                            else
                               entity_or_trlr_code).

         /* FOR CALL INVOICE, WHEN CALCULATING QUANTUM TAX USE TAX ZONES */
         /* WHICH ARE SET BASED UPON THE REPAIR CENTER FLAG OF WORK CODE */

         if tr_type = "38"
            and tx2_method = "20"
         then
            assign
               tax_zone_from = car_tax_zone_from
               tax_zone_to   = car_tax_zone_to.

         assign
            tx2d_tr_type        = tr_type
            tx2d_tax_code       = tx2_tax_code
            tx2d_effdate        = tax_date
            tx2d_posted_date    = tax_gl_date
            tx2d_curr           = tax_curr
            tx2d_tax_env        = tax_env
            tx2d_zone_from      = tax_zone_from
            tx2d_zone_to        = tax_zone_to
            tx2d_tax_type       = tx2_tax_type
            tx2d_trans_ent      = entity
            tx2d_line_site_ent  = det_entity.

         if tax_by_line
         then
            assign
               tx2d_taxc      = taxc_this_txed
               tx2d_tax_usage = usage.
         else
            assign
               tx2d_taxc      = tx2_pt_taxc
               tx2d_tax_usage = tx2_tax_usage.

         assign
            tx2d_tax_in         = use_tax_in
            tx2d_by_line        = tax_by_line
            tx2d_edited         = false
            tx2d_rcpt_tax_point = tx2_rcpt_tax_point.

      end. /* IF NOT AVAILABLE TX2D_DET */

      /* CALCULATING THE TAXABLE AMOUNT BASE ON TAX_BY_LINE FLAG */
      /* IF BY-TOTAL THEN USE TOTAL FOR CALCULATION */
      if tx2_inv_disc
         and inv_disc <> 0
      then do:
         tmp_amt = taxable_amt_this_txed * (1 - ( inv_disc / 100)).
         /* ROUND USING DOC CURRENCY RNDMTHD */

         {gprunp.i "mcpl" "p" "mc-curr-rnd"
            "(input-output tmp_amt,
              input rndmthd,
              output mc-error-number)"}
         /* ERROR CHECK FOR RNDMTHD DONE ABOVE */

         if tax_by_line
         then
            tot_amt = tmp_amt.
         else
            tot_amt = tx2d_totamt + tmp_amt.
      end.
      /* IF TAX INCLUDED = "YES" AND DR/CR MEMOS */
      else
      if tr_type = "18"
         and use_tax_in
      then
         tot_amt = tx2d_totamt + tax_amt.
      else
      if tax_by_line
      then
         tot_amt = taxable_amt_this_txed.
      else
         tot_amt = tx2d_totamt + taxable_amt_this_txed.

      /* CHECK FOR SPECIAL CASE ADJUSTMENT FACTORS */
      if (tr_type = "19" and tx2_pmt_disc)
      or (tr_type = "16" and tx2_inv_disc)
      then
         adj_factor = adj_fact.
      else
         adj_factor = 1.

      if recid(tx2d_det) = -1
      then.

      /* MAKE SURE THAT ALL RUN PROGRAMS ARE REFERENCED */
      if false
      then do:
         {gprun.i ""xxxtxmeth11.p""}
      end.

     /* FOR TAX-BY-LINE = NO, tx2d__qadd02[1] STORES THE PREVIOUS   */
     /* TRANSACTIONS TAX AMOUNT FOR THE CORRESPONDING TAX-TYPE USED */
     /* TO CALCULATE THE TAX ON TAX, WHEN TAX BASE IS ATTACHED TO   */
     /* TAX TYPE IN TAX RATE MAINTENANCE                            */
     if tx2d_line = 0
     then
        tx2d__qadd02[1] = tx2d_cur_tax_amt.

      /* METHOD 3 HAS A VARIABLE NUMBER OF TAXES.  IF IT      */
      /* IS USED, AT LEAST ONE TAX RECORD MUST BE FOUND.      */
      /* IF ANY OTHER METHODS ARE USED IN CONJUNCTION WITH    */
      /* METHOD 3, DO NOT RAISE WARNING IF NO 3'S WERE FOUND. */
      /* IF NOT taxable_this_txed THEN method_3_found = 2.    */
      /* ELSE IF tx2_method <> "03" THEN method_3_found = 2.  */


      /* DETERMINE TAX METHOD TO USE */
      if not taxable_this_txed
      then
         /* THIS IS OVERALL TAXABLE,                    */
         /* BUT THIS PARTICULAR TAX TYPE IS NON-TAXABLE */
         assign
            taxes        = 0
            adj_amt      = 0
            recoverable  = 0
            tax_base_amt = 0
            ntax_amt     = taxable_amt_this_txed.
      else
      if (tx2_method = ""
          or tx2_method = "01")
      then do:

         /* ADDED 12TH PARAMETER exrate AND 13TH        */
         /* PARAMETER exrate2                           */

         {gprun.i ""xxxtxmeth01.p""   "(input tx2_tax_code,
                                     input tax_round,
                                     input tax_curr,
                                     input use_tax_in,
                                     input tr_type,
                                     input ref,
                                     input nbr,
                                     input line,
                                     input tx2d_trl,
                                     input tx2d_line,
                                     input adj_factor,
                                     input exrate,
                                     input exrate2,
                                     input-output tot_amt,
                                     output taxes,
                                     output adj_amt,
                                     output recoverable,
                                     output tax_base_amt,
                                     output ntax_amt)"}

      end.

      else
      if (tx2_method = "02")
      then do:

         /* ADDED 12TH PARAMETER exrate AND 13TH        */
         /* PARAMETER exrate2                           */

         {gprun.i ""xxxtxmeth02.p""   "(input tx2_tax_code,
                                     input tax_round,
                                     input tax_curr,
                                     input tax_in,
                                     input tr_type,
                                     input ref,
                                     input nbr,
                                     input line,
                                     input tx2d_trl,
                                     input tx2d_line,
                                     input adj_factor,
                                     input exrate,
                                     input exrate2,
                                     input-output tot_amt,
                                     output taxes,
                                     output adj_amt,
                                     output recoverable,
                                     output tax_base_amt,
                                     output ntax_amt)"}

      end. /* IF tx2_method = "02" */

      else
      if (tx2_method = "03")
      then do:

         /* METHOD 3 ALLOWS FOR EXTERNALLY GENERATED */
         /* TAX DATA TO BE USED.  TAXES ARE IMPORTED */
         /* ALONG WITH A SALES ORDER VIA THE LOGISTICS */
         /* SYSTEM.  THIS TAX METHOD WILL CONTINUE TO */
         /* USE THE IMPORTED DATA TO UPDATE THE TAX */
         /* AMOUNTS AS THE ORDER IS PROCESSED BY MFG/PRO */
         /* WITHOUT HAVING TO RECALCULATE THE AMOUNTS. */

         /* IF FIRST TIME SET FOUND TO LOOKING */
         if method_3_found = 0
         then
            method_3_found = 1.

         {gprun.i ""xxxtxmeth03.p""   "(input tx2_tax_code,
                                     input tax_round,
                                     input tax_curr,
                                     input use_tax_in,
                                     input tr_type,
                                     input ref,
                                     input nbr,
                                     input line,
                                     input tx2d_trl,
                                     input tx2d_line,
                                     input adj_factor,
                                     input-output tot_amt,
                                     output taxes,
                                     output adj_amt,
                                     output recoverable,
                                     output tax_base_amt,
                                     output ntax_amt)"}

         /* A FEATURE OF THIS METHOD IS THAT NOT ALL TAX TYPES     */
         /* FOR A GIVEN SYSTEM WILL BE USED ON EVERY ORDER.  WE    */
         /* WANT TO UNDO THE CREATION OF tx2d_det WHEN A GIVEN     */
         /* TAX TYPE IS PRESENT IN MFG/PRO BUT NOT IN THE IMPORTED */
         /* DATA.                                                  */

         if return-value <> ""
         then
            undo, next.

         /* AN EXTERNAL TAX RECORD WAS FOUND */
         method_3_found = 2.
      end.
      else
      if (tx2_method = "04")
      then do:
         /* THIS TAX METHOD "04" HAS BEEN INTRODUCED FOR         */
         /* CALCULATION OF THE TAX DETAILS WHEN TAX INCLUDED IS  */
         /* YES/NO AND A TAX BASE NOT EQUAL TO 100 IS SPECIFIED  */
         /* IN THE TAX RATE MASTER.                              */
         {gprun.i ""xxxtxmeth04.p""   "(input tx2_tax_code,
                                     input tax_round,
                                     input tax_curr,
                                     input use_tax_in,
                                     input tr_type,
                                     input ref,
                                     input nbr,
                                     input line,
                                     input tx2d_trl,
                                     input tx2d_line,
                                     input adj_factor,
                                     input-output tot_amt,
                                     output taxes,
                                     output adj_amt,
                                     output recoverable,
                                     output tax_base_amt,
                                     output ntax_amt)"}
      end. /* IF (tx2_method = "04") THEN */
      else
      if (tx2_method = "20")
      then do:

         /**************************************************************/
         /* TAX METHOD 20 WILL BE USED IF QUANTUM MUST BE CALLED TO    */
         /* CALCULATE TAXES. THIS IS DEALT WITH SEPARTELY HERE BECAUSE */
         /* WE NEED TO PASS ADDITIONAL QUANTUM RELATED PARAMETERS TO   */
         /* TXMETH20.P. PASSING USAGE INSTEAD OF CMVD-ADDR             */
         /**************************************************************/

         /**************************************************************/
         /* CHANGES MADE TO ADDRESS BETA CUSTOMER FEEDBACK.            */
         /* THE FOLLOWING ADDITIONAL PARAMETERS ARE BEING PASSED TO    */
         /* TXMETH20.P:                                                */
         /* RNDMTHD,                                                   */
         /* TAX_BY_LINE,                                               */
         /* ENTITY,                                                    */
         /* ENTITY_EXRATE,                                             */
         /* EXRATE                                                     */
         /**************************************************************/
         vtx_flag = yes.

         /* ADDED SEVENTEENTH PARAMETER tx2d_posted_date */
         {gprun.i ""xxxtxmeth20.p""   "(input  tx2_tax_code,
                                     input  tax_round,
                                     input  rndmthd,
                                     input  tax_by_line,
                                     input  tax_curr,
                                     input  use_tax_in,
                                     input  entity,
                                     input  entity_exrate,
                                     input  exrate,
                                     input  tr_type,
                                     input  ref,
                                     input  nbr,
                                     input  line,
                                     input  tx2d_trl,
                                     input  tx2d_line,
                                     input  tax_date,
                                     input  tx2d_posted_date,
                                     input  adj_factor,
                                     input  company-code,
                                     input  divn-code,
                                     input  cmvd-addr,
                                     input  usage,
                                     input  tax_zone_from,
                                     input  tax_zone_to,
                                     input  orderaccept-taxzone,
                                     input  shipfrom-incity,
                                     input  shipto-incity,
                                     input  orderaccept-incity,
                                     input  lineitem-qty,
                                     input  taxc,
                                     input  first-taxtype,
                                     input  vq-post,
                                     input  vq-exch-rate,
                                     input  vq-exch-rate2,
                                     input  vq-rndmthd,
                                     output result-status,
                                     input-output tot_amt,
                                     output taxes,
                                     output adj_amt,
                                     output recoverable,
                                     output tax_base_amt,
                                     output ntax_amt)"}
         if first-taxtype
         then
            first-taxtype = no.
      end. /* if tax method = "20" ...*/
      else do:
         filename = "xxxtxmeth" + tx2_method + ".p".
         if search(global_user_lang_dir + substring(filename,1,2) + "/"
            + substring(filename,1,length(filename) - 1) + "r") <> ?
         then do:

            {gprun.i "filename"   "(input tx2_tax_code,
                                    input tax_round,
                                    input tax_curr,
                                    input tax_in,
                                    input tr_type,
                                    input ref,
                                    input nbr,
                                    input line,
                                    input tx2d_trl,
                                    input tx2d_line,
                                    input adj_factor,
                                    input-output tot_amt,
                                    output taxes,
                                    output adj_amt,
                                    output recoverable,
                                    output tax_base_amt,
                                    output ntax_amt)"}
         end.
         else
         if search(filename) <> ?
         then do:

            run value(filename)    (input tx2_tax_code,
                                    input tax_round,
                                    input tax_curr,
                                    input tax_in,
                                    input tr_type,
                                    input ref,
                                    input nbr,
                                    input line,
                                    input tx2d_trl,
                                    input tx2d_line,
                                    input adj_factor,
                                    input-output tot_amt,
                                    output taxes,
                                    output adj_amt,
                                    output recoverable,
                                    output tax_base_amt,
                                    output ntax_amt).
         end.
         else do:
            /* DISPLAY ERROR MESSAGE */
            /* TAX METHOD PROGRAM DOES NOT EXIST */
            {pxmsg.i &MSGNUM=870 &ERRORLEVEL=4}
            if c-application-mode = "API" then
               return.
         end.
      end.

      /* THE FOLLOWING PROCESSING MUST TAKE PLACE ONLY WHEN TXMETH20.P */
      /* IS NOT USED FOR TAX CALCULATIONS (QUANTUM IS NOT USED FOR TAX */
      /* CALCULATIONS). IF TXMETH20.P IS USED FOR TAX CALCULATIONS,    */
      /* THIS PROCESSING WILL TAKE PLACE IN VQTXCALC.P. THE CHANGE WAS */
      /* MADE IN ORDER TO ADDRESS SOME PERFORMANCE ISSUES WHEN QUANTUM */
      /* IS BEING USED TO CALCULATE TAXES.                             */

      if tx2_method <> "20"
      then do:

         /* IF DOC CURRENCY ROUND METHOD IS DIFFERENT FROM THE TAX */
         /* ROUND METHOD THEN ROUND PER DOC ROUND METHOD           */
         if rndmthd <> tax_round
         then do:
            /* ROUND THE TAX AMOUNTS ONLY USING DOCUMENT RNDMTHD       */
            /* THEY HAVE ALREADY BEEN ROUNDED USING THE TAX ROUND MTHD */

            {gprunp.i "mcpl" "p" "mc-curr-rnd"
               "(input-output tax_base_amt,
                 input rndmthd,
                 output mc-error-number)"}
            /* ERROR CHECK FOR RNDMTHD DONE ABOVE */

            {gprunp.i "mcpl" "p" "mc-curr-rnd"
               "(input-output taxes,
                 input rndmthd,
                 output mc-error-number)"}
            /* ERROR CHECK FOR RNDMTHD DONE ABOVE */

            {gprunp.i "mcpl" "p" "mc-curr-rnd"
               "(input-output recoverable,
                 input rndmthd,
                 output mc-error-number)"}
            /* ERROR CHECK FOR RNDMTHD DONE ABOVE */

            {gprunp.i "mcpl" "p" "mc-curr-rnd"
               "(input-output adj_amt,
                 input rndmthd,
                 output mc-error-number)"}
            /* ERROR CHECK FOR RNDMTHD DONE ABOVE */

            {gprunp.i "mcpl" "p" "mc-curr-rnd"
               "(input-output ntax_amt,
                 input rndmthd,
                 output mc-error-number)"}
            /* ERROR CHECK FOR RNDMTHD DONE ABOVE */
         end.

         /* STORE TAXABLE AMOUNT FROM FIRST TAX TYPE */
         /* (ONLY THE FIRST TAX TYPE CAN INCLUDE TAX */
         /* OTHERWISE TAX CALCULATION WILL BE INCORRECT) */
         if first(txed_seq)
            and use_tax_in
         then
            taxable_amt_this_line = taxable_amt_this_line - taxes.

         /* STORE DATA IN TAX DETAIL */
         assign
            tx2d_totamt      = tot_amt
            tx2d_tottax      = tax_base_amt
            tx2d_cur_tax_amt = taxes
            tx2d_tax_amt     = taxes
            tx2d_ent_tax_amt = taxes

            /* STORE RECOVERABLE AMOUNT */
            tx2d_cur_recov_amt = recoverable
            tx2d_recov_amt     = recoverable
            tx2d_ent_recov_amt = recoverable

            /* STORE REVERSE CHARGE / ABSORBED AMOUNT */
            tx2d_cur_abs_ret_amt = adj_amt
            tx2d_abs_ret_amt     = adj_amt
            tx2d_ent_abs_ret_amt = adj_amt.

         /* CALCULATE BASE AMT */
         if tx2d_curr <> base_curr
         then do:

            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input tx2d_curr,
                 input base_curr,
                 input exrate,
                 input exrate2,
                 input tx2d_tax_amt,
                 input true, /* ROUND */
                 output tx2d_tax_amt,
                 output mc-error-number)"}.
            /* ERROR CHECK ROUND METHOD FOR base_curr */
            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.

            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input tx2d_curr,
                 input base_curr,
                 input exrate,
                 input exrate2,
                 input tx2d_recov_amt,
                 input true, /* ROUND */
                 output tx2d_recov_amt,
                 output mc-error-number)"}.
            /* ERROR CHECK ROUND METHOD FOR base_curr DONE ABOVE */

            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input tx2d_curr,
                 input base_curr,
                 input exrate,
                 input exrate2,
                 input tx2d_abs_ret_amt,
                 input true, /* ROUND */
                 output tx2d_abs_ret_amt,
                 output mc-error-number)"}.
            /* ERROR CHECK ROUND METHOD FOR base_curr DONE ABOVE */

         end. /* IF tx2d_curr <> base_curr */

         /* CALCULATE ENTITY AMT */

         for first en_mstr
            fields (en_curr en_entity)
            where en_entity = entity no-lock :
         end.

         if available en_mstr
         then do:
            if tx2d_curr <> en_curr
            then do:
               assign
                  entity_exrate = 1
                  entity_exrate2 = 1.

               /* GET EXCHANGE RATE */
               {gprunp.i "mcpl" "p" "mc-get-ex-rate"
                  "(input tx2d_curr,
                    input en_curr,
                    input exratetype,
                    input tax_date,
                    output entity_exrate,
                    output entity_exrate2,
                    output mc-error-number)"}
               /* NO ERROR CHECK - EXCH RATES SET TO 1 */

               if (gl_base_curr <> en_curr)
               then do:

                  /* CHANGED SECOND OUTPUT PARAMETER  */
                  /* TO RNDMTHD1 FROM RNDMTHD         */
                  {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                     "(input en_curr,
                       output rndmthd1,
                       output mc-error-number)"}
                  if mc-error-number <> 0
                  then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
                  end.
               end.

               else
                  rndmthd1 = gl_rnd_mthd.

               /* CONVERT FROM FOREIGN TO ENTITY CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input tx2d_curr,
                    input en_curr,
                    input entity_exrate,
                    input entity_exrate2,
                    input tx2d_ent_tax_amt,
                    input false, /* DO NOT ROUND */
                    output tx2d_ent_tax_amt,
                    output mc-error-number)"}
               /* NO ERROR CHECK - ROUND PARAMETER IS FALSE */

               /* CONVERT FROM FOREIGN TO ENTITY CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input tx2d_curr,
                    input en_curr,
                    input entity_exrate,
                    input entity_exrate2,
                    input tx2d_ent_recov_amt,
                    input false, /* DO NOT ROUND */
                    output tx2d_ent_recov_amt,
                    output mc-error-number)"}
               /* NO ERROR CHECK - ROUND PARAMETER IS FALSE */

               /* CONVERT FROM FOREIGN TO ENTITY CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input tx2d_curr,
                    input en_curr,
                    input entity_exrate,
                    input entity_exrate2,
                    input tx2d_ent_abs_ret_amt,
                    input false, /* DO NOT ROUND */
                    output tx2d_ent_abs_ret_amt,
                    output mc-error-number)"}
               /* NO ERROR CHECK - ROUND PARAMETER IS FALSE */

               /* CHANGED SECOND INPUT PARAMETER TO RNDMTHD1 FROM */
               /* RNDMTHD TO ROUND ENTITY TAX IN ENTITY CURRENCY  */
               {gprunp.i "mcpl" "p" "mc-curr-rnd"
                  "(input-output tx2d_ent_tax_amt,
                    input rndmthd1,
                    output mc-error-number)"}
               /* ERROR CHECK FOR VALID ROUND METHOD */
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.

               /* CHANGED SECOND INPUT PARAMETER TO RNDMTHD1 */
               /* FROM RNDMTHD TO ROUND ENTITY RECOVERABLE   */
               /* IN ENTITY CURRENCY                         */
               {gprunp.i "mcpl" "p" "mc-curr-rnd"
                  "(input-output tx2d_ent_recov_amt,
                    input rndmthd1,
                    output mc-error-number)"}
               /* ERROR CHECK FOR RNDMTHD DONE ABOVE */

               /* CHANGED SECOND INPUT PARAMETER TO RNDMTHD1     */
               /* FROM RNDMTHD TO ROUND ENTITY ABSORBED/RETAINED */
               /* IN ENTITY CURRENCY                             */
               {gprunp.i "mcpl" "p" "mc-curr-rnd"
                  "(input-output tx2d_ent_abs_ret_amt,
                    input rndmthd1,
                    output mc-error-number)"}
               /* ERROR CHECK FOR RNDMTHD DONE ABOVE */

            end. /* IF (tx2d_curr <> en_curr) */
         end. /* IF AVAILABLE en_mstr */

         assign
            tx2d_cur_nontax_amt = ntax_amt
            tx2d_carrier        = carrier.

         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input tx2d_curr,
              input base_curr,
              input exrate,
              input exrate2,
              input tx2d_tottax,
              input true, /* ROUND */
              output tx2d_taxable_amt,
              output mc-error-number)"}.
         /* ERROR CHECK ROUND METHOD FOR base_curr */
         if mc-error-number <> 0
         then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end. /* IF mc-error-number <> 0 */

         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input tx2d_curr,
              input base_curr,
              input exrate,
              input exrate2,
              input tx2d_cur_nontax_amt,
              input true, /* ROUND */
              output tx2d_nontax_amt,
              output mc-error-number)"}.
         /* ERROR CHECK ROUND METHOD FOR base_curr */
         if mc-error-number <> 0
         then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end. /* IF mc-error-number <> 0 */

      end.  /*if tx2_method <> "20" ...*/
      release tx2d_det.
   end. /* FOR EACH txed_det */

   /* IF METHOD 3 WAS USED AND NO EXTERNAL DATA FOUND */
   /* THEN WARN THE USER. */

   if method_3_found = 1
   then do:
      /* UNABLE TO CALCULATE EXTERNALLY SUPPLIED TAX RATE. */
      {pxmsg.i &MSGNUM=3324 &ERRORLEVEL=2}
   end.

end.  /* TAXABLE */

else do:
   /* IF NOT TAXABLE */
   {txtx2_nt.i}

   /* ASSIGN DOCUMENT NUMBER TO nbr */
   nbr = p_nbr.

   for first tx2_mstr
      fields (tx2_apr_acct tx2_apr_cc tx2_ap_acct tx2_ap_cc
              tx2_apr_sub  tx2_ap_sub tx2_ara_sub tx2_ar_sub
              tx2_ara_acct tx2_ara_cc tx2_ar_acct tx2_ar_cc
              tx2_by_line  tx2_desc tx2_effdate tx2_exp_date
              tx2_inv_disc tx2_max tx2_method tx2_pmt_disc
              tx2_pt_taxc  tx2_rcpt_tax_point tx2_tax_code
              tx2_tax_in   tx2_tax_type tx2_tax_usage
              tx2_pct_recv tx2_update_tax)
      where tx2_tax_code = "00000000"
      no-lock :
   end.

   if tr_type = "18"
   then
      tax_by_line = false.
   else
      tax_by_line = tx2_by_line.

   if not tax_by_line
   then do:

      entity_or_trlr_code = "".

      if (tr_type = "22"  /* AP VOUCHER           */
      or  tr_type = "32") /* AP RECURRING VOUCHER */
      then
         assign
            /* FORCE TAX TO A BLANK DOCUMENT NUMBER          */
            nbr = ""
            /* FOR AP VOUCHER, USE tx2d_trl TO STORE ENTITY, */
            /* BECAUSE WE NEED SEPARATE TAX FOR EACH ENTITY. */
            /* AP VOUCHER DOES NOT USE TRAILER CODES.        */
            entity_or_trlr_code = det_entity.

   end. /* IF NOT tax_by_line */

   /* FIND/CREATE TAX DETAIL */
   if tax_by_line
   then
      for first tx2d_det
         where tx2d_ref      = ref
         and   tx2d_nbr      = nbr
         and   tx2d_line     = line
         and   tx2d_trl      = trlr_code
         and   tx2d_tr_type  = tr_type
         and   tx2d_tax_code = tx2_tax_code
         exclusive-lock:
      end.
   else /* BY-TOTAL RECORDS HAVE LINE = 0 */
      for first tx2d_det
         where tx2d_ref      = ref
         and   tx2d_nbr      = nbr
         and   tx2d_line     = 0
         and   tx2d_trl      = entity_or_trlr_code
         and   tx2d_tr_type  = tr_type
         and   tx2d_tax_code = tx2_tax_code
         exclusive-lock:
      end.

   /* CREATE TAX DETAIL */
   if not available(tx2d_det)
   then do:
      create tx2d_det.
      assign
         tx2d_ref = ref
         tx2d_nbr = nbr.

      /* IF BY-LINE USE LINE ITEM # ; ELSE USE 0 */
      if tax_by_line
      then
         assign
            tx2d_line = line
            tx2d_trl  = trlr_code.
      else
         assign
            tx2d_line = 0
            tx2d_trl  = entity_or_trlr_code.

      assign
         tx2d_tr_type       = tr_type
         tx2d_tax_code      = tx2_tax_code
         tx2d_effdate       = tax_date
         tx2d_posted_date   = tax_gl_date
         tx2d_curr          = tax_curr
         tx2d_tax_env       = tax_env
         tx2d_zone_from     = tax_zone_from
         tx2d_zone_to       = tax_zone_to
         tx2d_tax_type      = tx2_tax_type
         tx2d_trans_ent     = entity
         tx2d_line_site_ent = det_entity.

      if tax_by_line
      then
         assign
            tx2d_taxc      = taxc
            tx2d_tax_usage = usage.
      else
         assign
            tx2d_taxc      = tx2_pt_taxc
            tx2d_tax_usage = tx2_tax_usage.

      assign
         tx2d_tax_in      = use_tax_in
         tx2d_by_line     = tax_by_line
         tx2d_cur_tax_amt = 0
         tx2d_tax_amt     = 0
         tx2d_ent_tax_amt = 0
         tx2d_tottax      = 0
         tx2d_edited      = false.

   end. /* IF NOT AVAILABLE tx2d_det */

   /* STORE DATA IN TAX DETAIL */
   if tax_by_line
   then
      assign
         tx2d_totamt         = tax_amt
         tx2d_cur_nontax_amt = tax_amt.
   else
      assign
         tx2d_totamt     = tx2d_totamt + tax_amt
         tx2d_cur_nontax_amt = tx2d_cur_nontax_amt + tax_amt.

   tx2d_carrier = carrier.

   if recid(tx2d_det) = -1
   then.

   /* WE ARE FORCING QUANTUM TO CALCULATE THE TAXES IF THE LAST TAXTYPE, */
   /* AND last-line = YES FOR TAXABLE = NO                               */

   if (vtx_flag and last-line and last-taxtype)
   then do:
      {gprun.i ""vqtxcalc.p"" "(input company-code,
                                input entity,
                                input tr_type,
                                input ref,
                                input nbr,
                                input vq-post,
                                input first-taxtype)"}

      /* WE ARE DONE. SO INITIALIZE THE VALUES BACK TO 'NO'. */
      assign
         last-line    = no
         last-taxtype = no.
   end. /* IF last-line AND last-taxtype... */

   /* CONVERT FROM FOREIGN TO BASE CURRENCY */
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input tx2d_curr,
        input base_curr,
        input exrate,
        input exrate2,
        input tx2d_tottax,
        input true, /* ROUND */
        output tx2d_taxable_amt,
        output mc-error-number)"}.
   /* ERROR CHECK ROUND METHOD FOR base_curr */
   if mc-error-number <> 0
   then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end. /* IF mc-error-number <> 0 */

   /* CONVERT FROM FOREIGN TO BASE CURRENCY */
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input tx2d_curr,
        input base_curr,
        input exrate,
        input exrate2,
        input tx2d_cur_nontax_amt,
        input true, /* ROUND */
        output tx2d_nontax_amt,
        output mc-error-number)"}.
   /* ERROR CHECK ROUND METHOD FOR base_curr */
   if mc-error-number <> 0
   then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end. /* IF mc-error-number <> 0 */

   release tx2d_det.
end. /* NON-TAXABLE */
