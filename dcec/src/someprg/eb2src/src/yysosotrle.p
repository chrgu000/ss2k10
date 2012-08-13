/* sosotrle.p - DISPLAY INVOICE TRAILER                                       */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.39.1.3 $                                                              */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 8.5      CREATED:       08/05/96   BY: jpm *J13Q*                */
/* REVISION: 8.6      CREATED:       11/25/96   BY: jzw *K01X*                */
/* REVISION: 8.6      CREATED:       10/09/97   BY: *K0JV* Surendra Kumar     */
/* REVISION: 8.6   LAST MODIFIED:    01/15/98   BY: *J2B2* Manish  K.         */
/* REVISION: 8.6E  LAST MODIFIED:    02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E  LAST MODIFIED:    03/13/98   BY: *J2B5* Samir Bavkar       */
/* REVISION: 8.6E  LAST MODIFIED:    05/05/98   BY: *L00L* Ed vdGevel         */
/* REVISION: 8.6E  LAST MODIFIED:    05/09/98   BY: *L00Y* Jeff Wootton       */
/* REVISION: 8.6E  LAST MODIFIED:    07/16/98   BY: *L024* sami Kureishy      */
/* REVISION: 8.6E  LAST MODIFIED:    01/22/99   BY: *J38T* Poonam Bahl        */
/* REVISION: 8.6E  LAST MODIFIED:    02/10/99   BY: *L0D4* Satish Chavan      */
/* REVISION: 8.6E  LAST MODIFIED:    02/16/99   BY: *J3B4* Madhavi Pradhan    */
/* REVISION: 8.6E  LAST MODIFIED:    05/07/99   BY: *J3DQ* Niranjan R.        */
/* REVISION: 9.0   LAST MODIFIED:    02/24/00   BY: *M0K0* Ranjit Jain        */
/* REVISION: 9.1   LAST MODIFIED:    03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1   LAST MODIFIED:    03/30/99   BY: *N06R* Sandy Brown        */
/* REVISION: 9.1   LAST MODIFIED:    04/25/00   BY: *N0CG* Santosh Rao        */
/* REVISION: 9.1   LAST MODIFIED:    07/06/00   BY: *N0F4* Mudit Mehta        */
/* REVISION: 9.1   LAST MODIFIED:    09/05/00   BY: *N0RF* Mark Brown         */
/* REVISION: 9.1   LAST MODIFIED:    09/06/00   BY: *N0D0* Santosh Rao        */
/* REVISION: 9.1   LAST MODIFIED:    10/11/00   BY: *N0WC* Mudit Mehta        */
/* Revision: 1.27       BY: Katie Hilbert       DATE: 04/01/01  ECO: *P002*   */
/* Revision: 1.28       BY: Sandeep P.          DATE: 04/06/01  ECO: *M14W*   */
/* Revision: 1.29       BY: Vihang Talwalkar    DATE: 06/13/01  ECO: *M17R*   */
/* Revision: 1.30       BY: Ellen Borden        DATE: 07/09/01  ECO: *P007*   */
/* Revision: 1.31       BY: Kaustubh K.         DATE: 07/26/01  ECO: *M1DS*   */
/* Revision: 1.32       BY: Seema Tyagi         DATE: 12/27/01  ECO: *M1RR*   */
/* Revision: 1.33       BY: Mark Christian      DATE: 02/07/02  ECO: *N18X*   */
/* Revision: 1.34       BY: Jean Miller         DATE: 04/10/02  ECO: *P058*   */
/* Revision: 1.35       BY: Vinod Nair          DATE: 11/19/02  ECO: *P0K0*   */
/* Revision: 1.36       BY: Laurene Sheridan    DATE: 12/10/02  ECO: *M219*   */
/* Revision: 1.37       BY: Mamata Samant       DATE: 01/23/03  ECO: *N23T*   */
/* Revision: 1.38       BY: Manish Dani         DATE: 02/20/03  ECO: *N27Z*   */
/* Revision: 1.39       BY: Vandna Rohira       DATE: 04/28/03  ECO: *N1YL*   */
/* Revision: 1.39.1.1   BY: Vivek Gogte         DATE: 07/14/03  ECO: *N2GZ*   */
/* Revision: 1.39.1.2   BY: Sunil Fegade        DATE: 12/10/03  ECO: *P1F7*   */
/* $Revision: 1.39.1.3 $        BY: Rajaneesh S.        DATE: 12/19/03  ECO: *P1GK*   */
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
{cxcustom.i "SOSOTRLE.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{pxpgmmgr.i} /* Project X persistent procedure functions */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sosotrle_p_4 "Total"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* NEW SHARED VARIABLES, BUFFERS AND FRAMES */
define new shared variable undo_txdetrp     like mfc_logical.
define new shared variable tax_recno        as recid.

/* l_txchg IS SET TO TRUE IN TXEDIT.P WHEN TAXES ARE BEING EDITED  */
/* AND NOT JUST VIEWED IN DR/CR MEMO MAINTENANCE                   */
define new shared variable l_txchg       like mfc_logical initial no.

/* SHARED VARIABLES, BUFFERS AND FRAMES */
define shared variable rndmthd          like rnd_rnd_mthd.
define shared variable display_trail    like mfc_logical.
define shared variable so_recno         as recid.
define shared variable maint            like mfc_logical.
define shared variable taxable_amt      as decimal
   format "->>>>,>>>,>>9.99"
   label "Taxable".
define shared variable line_taxable_amt like taxable_amt.
define shared variable nontaxable_amt   like taxable_amt label "Non-Taxable".
define shared variable line_total       as decimal
   format "-zzzz,zzz,zz9.99"
   label "Line Total".
define shared variable disc_amt         like line_total
   label "Discount"
   format "(zzzz,zzz,zz9.99)".
define shared variable tax_amt          like line_total label "Total Tax".
define shared variable ord_amt          like line_total label "Total".
define shared variable user_desc        like trl_desc extent 3.
define shared variable total_pst        like line_total.
define shared variable tax_date         like so_tax_date.
define shared variable new_order        like mfc_logical.
define shared variable tax_edit         like mfc_logical.
define shared variable tax_edit_lbl     like mfc_char format "x(28)".
define shared variable invcrdt          as character format "x(15)".
define shared variable undo_trl2        like mfc_logical.
define shared  variable container_charge_total as decimal
   format "->>>>>>>>9.99"
   label "Containers" no-undo.
define  shared variable line_charge_total as decimal
  format "->>>>>>>>9.99"
  label "Line Charges" no-undo.

define shared variable l_nontaxable_lbl as character format "x(12)" no-undo.
define shared variable l_taxable_lbl    as character format "x(12)" no-undo.

{&SOSOTRLE-P-TAG1}

define shared frame sotot.
define shared frame d.

/* LOCAL VARIABLES, BUFFERS AND FRAMES */
define variable ext_actual      like sod_price.
define variable tax_tr_type     like tx2d_tr_type initial "11".
define variable tax_nbr         like tx2d_nbr     initial "".
define variable tax_lines       like tx2d_line    initial 0.
define variable disc_pct        like so_disc_pct.
define variable page_break      as   integer      initial 10.
define variable col-80          as   logical      initial true.
define variable recalc          like mfc_logical  initial true.
define variable credit_hold     like mfc_logical                no-undo.
define variable base_amt        like ar_amt.
define variable tmp_amt         as   decimal.
define variable retval          as   integer.
define variable balance_fmt     as   character.
define variable limit_fmt       as   character.
define variable l_tax_in        like tax_amt                    no-undo.
define variable ext_line_actual like sod_price                  no-undo.
define variable l_yn            like mfc_logical                no-undo.
define variable l_qtytoinv      like mfc_logical initial no     no-undo.
define variable l_tax_amt1      like tax_amt                    no-undo.
define variable l_tax_amt2      like tax_amt                    no-undo.
define variable l_trl_tax1      like tax_amt                    no-undo.
define variable l_trl_tax2      like tax_amt                    no-undo.
define variable msg-arg         as   character format "x(20)"   no-undo.
define variable l_tax_line      like tx2d_line initial 99999999 no-undo.
define variable ccOrder         as   logical                    no-undo.
define variable l_nontax_amt    like tx2d_nontax_amt            no-undo.
/* l_ext_actual IS THE EXTENDED AMOUNT EXCLUDING DISCOUNT. IT WILL */
/* BE USED FOR THE CALCULATION OF taxable_amt AND nontaxable_amt   */
define variable l_ext_actual    like sod_price                  no-undo.

{gprunpdf.i "mcpl" "p"}

{fsconst.i} /* FIELD SERVICE CONSTANTS */
{txcalvar.i}
{etdcrvar.i}
{etvar.i}
{etrpvar.i}

{gpfilev.i} /* VARIABLE DEFINITIONS FOR gpfile.i */
{cclc.i}   /* DETERMINE IF CONTAINER AND LINE CHARGES ARE ENABLED */

for first gl_ctrl
      fields(gl_rnd_mthd)
      no-lock:
end. /* FOR FIRST GL_CTRL */

for first soc_ctrl
      fields(soc_cr_hold)
      no-lock:
end. /* FOR FIRST SOC_CTRL */

/* SET LIMIT_FMT ACCORDING TO BASE CURR ROUND METHOD*/
limit_fmt = "->>>>,>>>,>>9.99".
{gprun.i ""gpcurfmt.p"" "(input-output limit_fmt,
                          input gl_rnd_mthd)"}

/* SET BALANCE_FMT ACCORDING TO BASE CURR ROUND METHOD*/
balance_fmt = "->>>>,>>>,>>9.99".
{gprun.i ""gpcurfmt.p"" "(input-output balance_fmt,
                          input gl_rnd_mthd)"}

find so_mstr where recid(so_mstr) = so_recno exclusive-lock.

tax_nbr = so_quote.

if so_fsm_type = 'RMA' then
   assign tax_tr_type = '36'.

/* USE TRANSACTION TYPE 38 FOR CALL INVOICE RECORDING (SSM) */
/* AND SET THE TAX_NBR TO THE CALL'S QUOTE (IF ANY) */
if so_fsm_type = fsmro_c then do:

   for first ca_mstr
         fields(ca_category ca_nbr ca_quote_nbr)
         where ca_category = '0'
         and   ca_nbr      = so_nbr no-lock:
   end. /* FOR FIRST CA_MSTR */
   if available ca_mstr then
      tax_nbr = ca_quote_nbr.
   tax_tr_type = "38".
end.

/**** FORMS ****/
&SCOPED-DEFINE PP_FRAME_NAME A
form
RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
   so_nbr
   so_cust
   so_bill
   so_ship
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
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{sosomt01.i}  /* Define shared frame d */
{socurvar.i}
{txcurvar.i}
{sototfrm.i}

tax_nbr = so_quote.

taxloop:
do on endkey undo, leave:

   l_nontax_amt = 0.

   if not so_sched
   then do:

      for first tx2d_det
         fields(tx2d_by_line tx2d_cur_nontax_amt tx2d_edited     tx2d_line
                tx2d_nbr     tx2d_nontax_amt     tx2d_ref        tx2d_taxc
                tx2d_tax_env tx2d_tax_usage      tx2d_tottax     tx2d_trl
                tx2d_tr_type)
         where tx2d_ref        = so_nbr
           and tx2d_nbr        = so_quote
           and tx2d_tr_type    = tax_tr_type
           and tx2d_nontax_amt <> 0
      no-lock:
         l_nontax_amt = tx2d_nontax_amt.
      end. /* FOR FIRST tx2d_det */

      {pxrun.i &PROC       =  'getSOTotalsBeforeTax'
               &PROGRAM    =  'sosotrlf.p'
               &CATCHERROR =   true
               &PARAM      = "(
                               buffer so_mstr,
                               input  maint,
                               input  rndmthd,
                               output line_total,
                               output line_taxable_amt,
                               output disc_pct,
                               output disc_amt,
                               output taxable_amt,
                               output nontaxable_amt,
                               output container_charge_total,
                               output line_charge_total,
                               output user_desc[1],
                               output user_desc[2],
                               output user_desc[3])"}

   end. /* IF NOT so_sched */

   /* CHECK PREVIOUS DETAIL FOR EDITED VALUES */

   for first tx2d_det
      fields(tx2d_by_line tx2d_cur_nontax_amt tx2d_edited     tx2d_line
             tx2d_nbr     tx2d_nontax_amt     tx2d_ref        tx2d_taxc
             tx2d_tax_env tx2d_tax_usage      tx2d_tottax     tx2d_trl
             tx2d_tr_type)
      where tx2d_ref       = so_nbr
        and   tx2d_nbr     = so_quote
        and   tx2d_tr_type = tax_tr_type
        and   tx2d_edited no-lock:
   end. /* FOR FIRST TX2D_DET */

   if available(tx2d_det) then do:
      /* Previous tax values edited. Recalculate? */
      {pxmsg.i &MSGNUM=917 &ERRORLEVEL=2 &CONFIRM=recalc}
   end.

   /* CALULATE THE TAX AMOUNT BEFORE TXCALC.P CALCULATES THE NEW */
   /* TAXES SO AS TO COMPARE IF THE TAX AMOUNT HAS BEEN CHANGED  */

   /* CALCULATE TOTALS */
   {gprun.i ""txtotal.p"" "(input  tax_tr_type,
                            input  so_nbr,
                            input  tax_nbr,
                            input  tax_lines,   /* ALL LINES */
                            output l_tax_amt1)"}

   /* OBTAINING TOTAL INCLUDED TAX FOR THE TRANSACTION */
   {gprun.i ""txtotal1.p"" "(input  tax_tr_type,
                             input  so_nbr,
                             input  tax_nbr,
                             input  tax_lines,  /* ALL LINES */
                             output l_tax_amt2)"}

   l_tax_amt1 = l_tax_amt1 + l_tax_amt2.

   if can-find (first sod_det
                where sod_nbr     =  so_nbr
                  and sod_qty_inv <> 0)
   then
      l_qtytoinv = yes.

   if can-find (first tx2d_det
                where tx2d_ref     = so_nbr
                and   tx2d_nbr     = so_quote
                and   tx2d_tr_type = tax_tr_type
                and   tx2d_by_line = no
                no-lock)
   then
      l_tax_line = 0.

   if recalc
   then do:

      if not new so_mstr
         and so_fsm_type = ""
         and l_qtytoinv
      then do:
         /* CALCULATE TRAILER TAX BEFORE RE-CALCULATION OF TAXES */
         /* REPLACED FOURTH INPUT PARAMETER 99999 BY l_tax_line  */
         {gprun.i ""txtotal.p"" "(input  tax_tr_type,
                                  input  so_nbr,
                                  input  tax_nbr,
                                  input  l_tax_line,   /* ALL LINES */
                                  output l_trl_tax1)"}
      end. /* IF NOT NEW so_mstr AND l_qtytoinv */

      /* CALCULATE TAXES */
      /* NOTE nbr FIELD BLANK FOR SALES ORDERS */

      /* ADDED TWO PARAMETERS TO TXCALC.P, INPUT PARAMETER VQ-POST
       *  AND OUTPUT PARAMETER RESULT-STATUS. THE POST FLAG IS SET
       *  TO 'NO' BECAUSE WE ARE NOT CREATING QUANTUM REGISTER
       *  RECORDS FROM THIS CALL TO TXCALC.P */

      {&SOSOTRLE-P-TAG2}

      if not so_sched
      then do:

         {gprun.i ""txcalc.p""  "(input  tax_tr_type,
                                  input  so_nbr,
                                  input  tax_nbr,
                                  input  tax_lines /*ALL LINES*/,
                                  input  no,
                                  output result-status)"}

      end. /* IF NOT so_sched */

      {&SOSOTRLE-P-TAG3}

      if not new so_mstr
         and so_fsm_type = ""
         and l_qtytoinv
      then do:
         /* CALCULATE TRAILER TAX AFTER RE-CALCULATION OF TAXES */
         /* REPLACED FOURTH INPUT PARAMETER 99999 BY l_tax_line */
         {gprun.i ""txtotal.p"" "(input  tax_tr_type,
                                  input  so_nbr,
                                  input  tax_nbr,
                                  input  l_tax_line,   /* ALL LINES */
                                  output l_trl_tax2)"}
      end. /* IF NOT NEW so_mstr AND l_qtytoinv */

      /* DISPLAY WARNING MESSAGE WHEN TAXABLE TRAILER AMOUNT IS */
      /* CHANGED FOR A SHIPPED BUT NOT INVOICED SO              */

      if so_fsm_type = ""
         and not new so_mstr
         and l_qtytoinv
         and l_trl_tax1 <> l_trl_tax2
      then
         run p-sotrlmsg.

   end. /* if recalc */

   if not so_sched
   then do:
      /* CHANGED FOURTH PARAMETER disc_amt FROM INPUT TO INPUT-OUTPUT */
      {pxrun.i &PROC       =  'getSOTotalsAfterTax'
               &PROGRAM    =  'sosotrlf.p'
               &CATCHERROR =   true
               &PARAM      = "(
                               buffer       so_mstr,
                               input        tax_tr_type,
                               input        tax_nbr,
                               input-output disc_amt,
                               input        total_pst,
                               input-output line_total,
                               input-output line_taxable_amt,
                               input-output taxable_amt,
                               input-output nontaxable_amt,
                               output tax_amt,
                               output ord_amt)"}

   end. /* IF NOT so_sched */

   /* CHECK CREDIT AMOUNTS */

   if ord_amt < 0 then invcrdt = "**" + getTermLabel("C_R_E_D_I_T",11) + "**".
   else invcrdt = "".

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

      for first cm_mstr
         fields(cm_addr cm_balance cm_cr_limit cm_disc_pct)
         where cm_addr = so_bill no-lock:
      end. /* FOR FIRST CM_MSTR */

      base_amt = ord_amt.
      if so_curr <> base_curr then
      do:
         /* CONVERT TO BASE CURRENCY */

         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input so_curr,
              input base_curr,
              input so_ex_rate,
              input so_ex_rate2,
              input base_amt,
              input true,
              output base_amt,
              output mc-error-number)"}
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.

      end.

      /*  FIND OUT IF THIS IS A CREDITCARD SO */
      ccOrder = can-find(first qad_wkfl
                      where qad_key1
                      begins string(so_nbr, "x(8)")
                      and qad_key2 = "creditcard").

      /* NOTE: IF THE ORDER IS A CREDITCARD ORDER, DON'T                */
      /*    CHECK CREDIT HISTORY - BECAUSE AS LONG AS THE CREDITCARD    */
      /*    AMOUNT COVERS THE ORDER WE DON'T HAVE TO CONSIDER THE       */
      /*    CUSTOMER'S BALANCE OR CREDIT LIMIT.                         */

      /* NOTE: DO NOT PUT CALL REPAIR ORDERS (FSM-RO) ON HOLD - BECAUSE */
      /*    THESE ORDERS WILL NOT BE SHIPPING ANYTHING, ONLY INVOICING  */
      /*    FOR WORK ALREADY DONE.                                      */

      /* NOTE: ALSO DO NOT PUT RMA ORDERS (RMA) ON HOLD - BECAUSE THESE */
      /*    ORDERS WILL BE CHECKED FOR CREDIT LIMIT AND PUT ON HOLD IN  */
      /*    THE PROGRAM FSRMAMTU.P DEPENDING ON THE SERVICE LEVEL FLAG  */
      /*    (SVC_HOLD_CALL)                                             */

      find current cm_mstr no-lock no-error.

      if available cm_mstr
      then do:

         if cm_cr_limit < (cm_balance + base_amt)
            and so_fsm_type <> "FSM-RO"
            and so_fsm_type <> "RMA"
         and not(ccOrder)
         then do:
            /* Sales Order placed on credit hold */
            assign
               credit_hold = true
               so_stat     = "HD".

            display so_stat with frame d.

            msg-arg = string((cm_balance + base_amt),balance_fmt).
            /* Customer Balance plus this Order */
            {pxmsg.i &MSGNUM=616 &ERRORLEVEL=2 &MSGARG1=msg-arg}
            msg-arg = string(cm_cr_limit,limit_fmt).
            /* Credit Limit */
            {pxmsg.i &MSGNUM=617 &ERRORLEVEL=1 &MSGARG1=msg-arg}
            /* Sales Order placed on credit hold */
            {pxmsg.i &MSGNUM=690 &ERRORLEVEL=1
                     &MSGARG1=getTermLabel(""SALES_ORDER"",20)}

         end.

      end. /* IF AVAILABLE cm_mstr */

      if ccOrder then do:
         if so_prepaid < base_amt
         then do:
            /* Sales Order placed on credit hold */
            assign
               credit_hold = true
               so_stat     = "HD".

            display so_stat with frame d.

            /* Sales Order placed on credit hold */
            {pxmsg.i &MSGNUM=690 &ERRORLEVEL=1
                  &MSGARG1=getTermLabel(""SALES_ORDER"",20)}
         end.
      end.
   end.

   run so_tot_dsp. /* DISPLAY ALL FIELDS */

   trlloop:
   do on error undo, retry
      on endkey undo taxloop, leave:
      {&SOSOTRLE-P-TAG4}
      /* STORING THE DEFAULT VOLUME DISCOUNT PERCENTAGE */
      assign disc_pct = so_disc_pct .
      set
         so_disc_pct so_trl1_cd so_trl1_amt so_trl2_cd
         so_trl2_amt so_trl3_cd so_trl3_amt tax_edit
      with frame sotot
      editing:
         readkey.
         if  keyfunction(lastkey) = "end-error"
         and (l_tax_amt1   <> tax_amt         or
              l_nontax_amt <> nontaxable_amt)
         then do:
            hide message no-pause.
            /* TAX DETAIL RECORDS WILL NOT BE SAVED WHEN F4 */
            /* OR ESC IS PRESSED.                           */
            {pxmsg.i &MSGNUM=4773 &ERRORLEVEL=2}
            /* CONTINUE WITHOUT SAVING?                     */
            {pxmsg.i &MSGNUM=4774 &ERRORLEVEL=1 &CONFIRM=l_yn}
            hide message no-pause.
            if l_yn
            then
               undo taxloop, leave.
         end. /* IF KEYFUNCTION(LASTKEY) */
         else
            apply lastkey.
      end. /* EDITING */

      {&SOSOTRLE-P-TAG5}

      /* CHECKING WHETHER VOLUME DISCOUNT IS MANUALLY ENTERED ? */

      if so_disc_pct <> disc_pct
      then do:

         so__qadl01 = yes .

         /* ISSUE MESSAGE WHEN SO TRAILER DISC MANUALLY CHANGED */
         /* AND SHIPMENT IS MADE                                */

         if (can-find (first sod_det
                       where sod_nbr     = so_nbr
                       and   sod_qty_inv <> 0))
         then do:

            hide message.
            /* DISCOUNT HAS CHANGED. TAXES WILL NOT BE UPDATED */
            /* FOR QTY-TO-INVOICE                              */
            {pxmsg.i &MSGNUM=4650 &ERRORLEVEL=2}
            /* USE PENDING INVOICE MAINTENANCE TO ADJUST */
            /* THOSE TAXES                               */
            {pxmsg.i &MSGNUM=4651 &ERRORLEVEL=2}
            pause.

         end. /* IF (CAN-FIND (FIRST sod_det WHERE ... */

      end. /* IF so_disc_pct <> disc_pct */

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
         if (retval <> 0) then do:
            next-prompt so_trl3_amt with frame sotot.
            undo trlloop, retry.
         end.
      end.
   end. /* TRLLOOP: DO ON ERROR UNDO, RETRY */

   /*** RECALCULATE TOTALS FOR LINES ***/
   assign
      line_total     = 0
      taxable_amt    = 0
      nontaxable_amt = 0
      container_charge_total = 0
      line_charge_total = 0.

   /* ACCUMULATE LINE AMOUNTS */
   for each sod_det where sod_nbr = so_nbr:

      assign
         ext_actual   = (sod_price * (sod_qty_ord - sod_qty_ship))
         l_ext_actual = ((sod_price * (sod_qty_ord - sod_qty_ship))
                         * (1 - so_disc_pct / 100)).


      if using_line_charges then do:

         for each sodlc_det
         fields(sodlc_order sodlc_ord_line sodlc_ext_price
                sodlc_one_time sodlc_times_charged sodlc_trl_code)
         where sodlc_order = sod_nbr
           and sodlc_ord_line = sod_line
         no-lock:

            if sodlc_one_time and sodlc_times_charged > 0 then next.

            ext_line_actual = sodlc_ext_price.

            /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
            {gprunp.i "mcpl" "p" "mc-curr-rnd"
               "(input-output ext_line_actual,
                 input rndmthd,
                 output mc-error-number)"}
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM = mc-error-number &ERRORLEVEL = 2}
            end.

            assign
               line_charge_total = line_charge_total + ext_line_actual
               line_total = line_total + ext_line_actual.

            for first trl_mstr
            fields (trl_code trl_taxable)
               where trl_code = sodlc_trl_code
            no-lock: end.

            if available trl_mstr then do:
               if trl_taxable then
                  taxable_amt = taxable_amt + ext_line_actual.
               else
                  nontaxable_amt = nontaxable_amt + ext_line_actual.
            end. /*IF AVAILABLE TRL_MSTR*/

         end. /* FOR EACH SODLC_DET*/
      end. /*IF USING_LINE_CHARGES*/

      /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
      {gprunp.i "mcpl" "p" "mc-curr-rnd"
          "(input-output ext_actual,
            input rndmthd,
            output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output l_ext_actual,
           input rndmthd,
           output mc-error-number)"}

      if mc-error-number <> 0
      then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end. /* IF mc-error-number <> 0 */

      /* CALL THE PROCEDURE TO GET LINE TOTAL ONLY WHEN TAX IS */
      /* INCLUDED                                              */
      if sod_tax_in
      then do:
         {gprunp.i "sopl" "p" "getExtendedAmount"
            "(input        rndmthd,
              input        sod_line,
              input        so_nbr,
              input        so_quote,
              input        tax_tr_type,
              input-output ext_actual)"}
      end. /* IF sod_tax_in ... */

      line_total = line_total + ext_actual.

      /* FOR CALL INVOICES, SFB_TAXABLE (IN 86) OF SFB_DET         */
      /* DETERMINES TAXABILITY AND THERE COULD BE MULTIPLE SFB_DET */
      /* FOR A SOD_DET.                                            */
      if sod_fsm_type = fsmro_c and sod_taxable then do:
         for each sfb_det no-lock
            where sfb_nbr = sod_nbr
              and sfb_so_line = sod_line:
            if sfb_exchange then
               assign
                  ext_actual   = 0 - (sfb_exg_price * sfb_qty_ret)
                  l_ext_actual = (0 - (sfb_exg_price * sfb_qty_ret))
                               * (1 - so_disc_pct / 100).
            else
               assign
                  ext_actual   = (sfb_price * sfb_qty_req) - sfb_covered_amt
                  l_ext_actual = ((sfb_price * sfb_qty_req) - sfb_covered_amt)
                               * (1 - so_disc_pct / 100).

            /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
            {gprunp.i "mcpl" "p" "mc-curr-rnd"
               "(input-output ext_actual,
                 input rndmthd,
                 output mc-error-number)"}
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.

            {gprunp.i "mcpl" "p" "mc-curr-rnd"
               "(input-output l_ext_actual,
                 input rndmthd,
                 output mc-error-number)"}
            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end. /* IF mc-error-number <> 0 */

            if sfb_taxable then
               assign
                  taxable_amt      = taxable_amt + l_ext_actual
                  line_taxable_amt = taxable_amt.
            else
               nontaxable_amt = nontaxable_amt + l_ext_actual.
         end. /* FOR EACH SFB_DET */
      end. /* IF SOD_FSM_TYPE = FSMRO_C ... */
      else

         if sod_taxable then
            assign
               taxable_amt = taxable_amt + l_ext_actual
               line_taxable_amt = taxable_amt.
         else
            nontaxable_amt = nontaxable_amt + l_ext_actual.
   end. /* FOR EACH sod_det */

   /* CALCULATE DISCOUNT */
   disc_amt = (- line_total * (so_disc_pct / 100)).
   /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output disc_amt,
        input rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

   /* ADD TRAILER AMOUNTS */
   {txtrltrl.i so_trl1_cd so_trl1_amt user_desc[1]}
   {txtrltrl.i so_trl2_cd so_trl2_amt user_desc[2]}
   {txtrltrl.i so_trl3_cd so_trl3_amt user_desc[3]}

   /****** CALCULATE TAXES ************/
   if recalc
   then do:

      if not new so_mstr
         and so_fsm_type = ""
         and l_qtytoinv
      then do:
         /* CALCULATE TRAILER TAX BEFORE RE-CALCULATION OF TAXES */
         /* REPLACED FOURTH INPUT PARAMETER 99999 BY l_tax_line  */
         {gprun.i ""txtotal.p"" "(input  tax_tr_type,
                                  input  so_nbr,
                                  input  tax_nbr,
                                  input  l_tax_line,   /* ALL LINES */
                                  output l_trl_tax1)"}

      end. /* IF NOT NEW so_mstr AND l_qtytoinv */

      /* ADDED TWO PARAMETERS TO TXCALC.P, INPUT PARAMETER VQ-POST
       *  AND OUTPUT PARAMETER RESULT-STATUS. THE POST FLAG IS SET
       *  TO 'NO' BECAUSE WE ARE NOT CREATING QUANTUM REGISTER
       *  RECORDS FROM THIS CALL TO TXCALC.P */

      {&SOSOTRLE-P-TAG6}

      if not so_sched
      then do:

         {gprun.i ""txcalc.p""  "(input  tax_tr_type,
                                  input  so_nbr,
                                  input  tax_nbr,
                                  input  tax_lines,  /*ALL LINES*/
                                  input  no,
                                  output result-status)"}

      end. /* IF NOT so_sched */

      {&SOSOTRLE-P-TAG7}

      if not new so_mstr
         and so_fsm_type = ""
         and l_qtytoinv
      then do:
         /* CALCULATE TRAILER TAX AFTER RE-CALCULATION OF TAXES */
         /* REPLACED FOURTH INPUT PARAMETER 99999 BY l_tax_line */
         {gprun.i ""txtotal.p"" "(input  tax_tr_type,
                                  input  so_nbr,
                                  input  tax_nbr,
                                  input  l_tax_line,   /* ALL LINES */
                                  output l_trl_tax2)"}
      end. /* IF NOT NEW so_mstr AND l_qtytoinv */

      /* DISPLAY WARNING MESSAGE WHEN TAXABLE TRAILER AMOUNT IS */
      /* CHANGED FOR A SHIPPED BUT NOT INVOICED SO              */

      if so_fsm_type = ""
         and not new so_mstr
         and l_qtytoinv
         and l_trl_tax1 <> l_trl_tax2
      then
         run p-sotrlmsg.

   end. /* IF recalc */

   {gprun.i ""txabsrb.p"" "(input so_nbr,
                            input so_quote,
                            input tax_tr_type,
                            input-output line_total,
                            input-output taxable_amt)"}

   /* DO TAX DETAIL DISPLAY / EDIT HERE */
   if tax_edit then do:
      hide frame sotot no-pause.
      hide frame d no-pause.

      if so_tax_date <> ?
      then
         tax_date = so_tax_date.
      else
      if so_due_date <> ?
      then
         tax_date = so_due_date.
      else
         tax_date = so_ord_date.

      /* ADDED so_curr,so_ex_ratetype,so_ex_rate,so_ex_rate2  */
      /* AND tax_date AS SIXTH, SEVENTH, EIGTH, NINTH         */
      /* AND TENTH INPUT PARAMETER RESPECTIVELY.              */

      /*tfq {gprun.i ""txedit.p""  "(input  tax_tr_type,
                               input  so_nbr,
                               input  tax_nbr,
                               input  tax_lines, /*ALL LINES*/
                               input  so_tax_env,
                               input  so_curr,
                               input  so_ex_ratetype,
                               input  so_ex_rate,
                               input  so_ex_rate2,
                               input  tax_date,
                               output tax_amt)"} */
         /*tfq*/ {gprun.i ""yytxedit.p""  "(input  tax_tr_type,
                               input  so_nbr,
                               input  tax_nbr,
                               input  tax_lines, /*ALL LINES*/
                               input  so_tax_env,
                               input  so_curr,
                               input  so_ex_ratetype,
                               input  so_ex_rate,
                               input  so_ex_rate2,
                               input  tax_date,
                               output tax_amt)"} 
                      
      view frame sotot.
      /*V8-*/
      view frame d.
      /*V8+*/
   end.

   /* CALCULATE TOTALS */
   {gprun.i ""txtotal.p"" "(input  tax_tr_type,
                            input  so_nbr,
                            input  tax_nbr,
                            input  tax_lines,   /* ALL LINES */
                            output tax_amt)"}

   /* OBTAINING TOTAL INCLUDED TAX FOR THE TRANSACTION */
   {gprun.i ""txtotal1.p"" "(input  tax_tr_type,
                             input  so_nbr,
                             input  tax_nbr,
                             input  tax_lines,       /* ALL LINES */
                             output l_tax_in)"}

   /* DISCOUNT AMOUNT IS ADJUSTED TO AVOID ROUNDING ERROR */
   /* IN CALCULATION OF ORDER AMOUNT                      */
   if l_tax_in <> 0
   then do:
/*cj*/      {gprunp.i "yysopl" "p" "adjustDiscountAmount"
         "(input        taxable_amt - l_tax_in,
           input        nontaxable_amt,
           input        so_trl1_amt,
           input        so_trl2_amt,
           input        so_trl3_amt,
           input        line_total,
           input-output disc_amt)"}
   end. /* IF l_tax_in <> 0 */

   /* ADJUSTING LINE TOTALS AND TOTAL TAX BY INCLUDED TAX */
   assign
      taxable_amt      = taxable_amt - l_tax_in
      line_taxable_amt = taxable_amt
      tax_amt          = tax_amt + l_tax_in
      ord_amt          = line_total + disc_amt + so_trl1_amt +
                         so_trl2_amt + so_trl3_amt + tax_amt + total_pst.

   if ord_amt < 0 then
      invcrdt = "**" + getTermLabel("C_R_E_D_I_T",11) + "**".
   else
      invcrdt = "".

   if display_trail then do:
      run so_tot_dsp. /* DISPLAY ALL FIELDS */
   end.

   undo_trl2 = false.

end. /* taxloop*/

/* Warn user now if order had been put on credit hold */
if credit_hold then
   so_stat = "HD".

/* PROCEDURE so_tot_dsp IS INTRODUCED AS PROGRESS GETS       */
/* CONFUSED BETWEEN TWO FRAMES WITH SAME FIELD IN sototdsp.i */
/* AND ALLOWED UNAUTORIZED USER TO UPDATE so_disc_pct FIELD. */
PROCEDURE so_tot_dsp:
   {sototdsp.i}.
END PROCEDURE. /* PROCEDURE so_tot_dsp */

PROCEDURE p-sotrlmsg:

   hide message.
   /* TRAILER TAXES HAS CHANGED, WILL NOT BE CHANGED IN INVOICE        */
   {pxmsg.i &MSGNUM=3979 &ERRORLEVEL=2}

   /* USE PENDING INVOICE MAINTENANCE TO ADJUST THOSE TAXES            */
   {pxmsg.i &MSGNUM=4651 &ERRORLEVEL=2}

END PROCEDURE. /* PROCEDURE p-sotrlmsg */
~

