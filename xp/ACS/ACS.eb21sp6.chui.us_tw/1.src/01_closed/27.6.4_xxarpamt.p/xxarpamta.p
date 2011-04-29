/* arpamta.p - AR PAYMENT MAINTENANCE line items                        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.14.1.11 $                                                  */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 6.0      LAST MODIFIED: 08/27/90   BY; MLB *D055*          */
/*                                   09/06/90   BY: MLB *D065*          */
/*                                   10/01/90   BY: afs *D088*          */
/*                                   12/04/90   BY: afs *D241*          */
/*                                   02/28/91   BY: afs *D387*          */
/*                                   03/12/91   BY: MLB *D360*          */
/*                                   03/12/91   BY: MLB *D385*          */
/*                                   03/12/91   BY: afs *D424*          */
/*                                   04/25/91   BY: afs *D498*          */
/*                                   05/02/91   BY: MLV *D595*          */
/*                                   03/25/92   by: jms *F332*          */
/* REVISION: 7.3      LAST MODIFIED: 10/08/92   by: jms *G146*          */
/*                                   03/15/93   by: jms *G797*          */
/*                                   04/23/93   by: jms *GA27*          */
/* REVISION: 7.4      LAST MODIFIED: 08/10/93   by: wep *H105*          */
/*                                   09/02/94   by: pmf *FQ78*          */
/*                                   12/18/94   by: pmf *F09V*          */
/*                                   01/04/95   BY: jzw *F0CQ*          */
/*                                   01/31/95   BY: srk *H09T*          */
/* REVISION: 8.5      LAST MODIFIED: 01/13/95   by: ccc *J053*          */
/*                                   07/22/96   by: *J0VY* M. Deleeuw   */
/*                                   02/20/97   by: bkm *J1J5*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E    MODIFIED AT: 07 apr 98     BY: rup *L00K* */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 06/02/98   BY: *L01K* Jaydeep Parikh */
/* REVISION: 8.6E     LAST MODIFIED: 09/16/98   BY: *J305* Rajesh Talele*/
/* REVISION: 8.6E     LAST MODIFIED: 10/01/98   BY: *L09V* Jeff Wootton */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Paul Johnson      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00 BY: *N0KK* jyn                 */
/* REVISION: 9.1      LAST MODIFIED: 01/03/01   BY: *M0Y4* Jose Alex         */
/* REVISION: 9.1      LAST MODIFIED: 09/13/00   BY: *N0VV* BalbeerS Rajput   */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.14.1.8   BY: Orawan S.          DATE: 05/20/03 ECO: *P0RX*    */
/* Revision: 1.14.1.10  BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B*    */
/* $Revision: 1.14.1.11 $         BY: K Paneesh          DATE: 08/08/03 ECO: *N2JT* */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110114.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/************************************************************************/
{mfdeclre.i}
{cxcustom.i "ARPAMTA.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{etvar.i}            /* COMMON EURO TOOLKIT VARIABLES */
/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE arpamta_p_1 "N/U Ref"
/* MaxLen: Comment: */

&SCOPED-DEFINE arpamta_p_2 "Check Control"
/* MaxLen: Comment: */

&SCOPED-DEFINE arpamta_p_3 "Amt to Apply"
/* MaxLen: Comment: */

&SCOPED-DEFINE arpamta_p_4 "Cash Amount"
/* MaxLen: Comment: */

&SCOPED-DEFINE arpamta_p_5 "Applied Amount"
/* MaxLen: Comment: */

&SCOPED-DEFINE arpamta_p_6 "Balance"
/* MaxLen: Comment: */

&SCOPED-DEFINE arpamta_p_7 "  Total"
/* MaxLen: Comment: */

&SCOPED-DEFINE arpamta_p_8 " Unapplied"
/* MaxLen: Comment: */

&SCOPED-DEFINE arpamta_p_9 " Payment Application Maintenance "
/* MaxLen: Comment: */

&SCOPED-DEFINE arpamta_p_10 " Payment Application Detail "
/* MaxLen: Comment: */

&SCOPED-DEFINE arpamta_p_12 "Ref"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{xxgpdescm1.i }     /* SS - 110114.1 */

define new shared variable ard_recno    as recid.
define new shared variable arbuff_recno as recid.
define new shared variable arddet_recno as recid initial ?.
define new shared variable type         like ard_type.

define shared variable rndmthd    like rnd_rnd_mthd.
define shared variable ar_amt_fmt as character.
define shared variable old_doccurr like ar_curr.
define shared variable apply2_rndmthd like rnd_rnd_mthd.
define shared variable ar_recno  as recid.
define shared variable arnbr     like ar_nbr.
define shared variable jrnl      like glt_ref.
define shared variable unappamt  like ar_amt label {&arpamta_p_8}.
define shared variable artotal   like ar_amt label {&arpamta_p_2}.
define shared variable base_amt  like ar_amt.
define shared variable disc_amt  like ar_amt.
define shared variable gain_amt  like ar_amt.
define shared variable curr_amt  like ar_amt.
define shared variable cash_curr like gl_base_curr.
define shared variable gltline   like glt_line.
define shared variable curr_disc like glt_curr_amt.
define shared variable l_batch_err like mfc_logical   no-undo.

define variable dwn           as integer.
define variable first_sw_call as logical initial true.
define variable ardamt        like ard_amt label {&arpamta_p_3}.
define variable open_amt      like ar_amt.
define variable ref_nu        like ard_ref.
define variable disc_draft    like mfc_logical.
define variable memo_or_inv   like mfc_logical.

define new shared frame d.
define new shared frame b1.
define new shared frame c.

define buffer armstr for ar_mstr.
define buffer arddet for ard_det.
define buffer armstr1 for ar_mstr.

/* DEFINED TEMP TABLE FOR GETTING THE RECORDS ADDED IN ARPAMTC.P WITH INDEX */
/* SAME AS PRIMARY UNIQUE INDEX OF ard_det.                                 */
{ardydef.i &type="shared"}

{&ARPAMTA-P-TAG5}
/*DEFINE CONTROL TOTALS FRAME */
form
   ar_check       colon 10
   artotal
   ar_amt         label {&arpamta_p_7}
   ar_bill        colon 10
   cm_sort        no-label
   unappamt
with frame b1 side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b1:handle).

/*DEFINE DOCUMENT SCROLLING FRAME */
/* SINCE 'SWINDAR.I' SCROLLING FRAME HANDLER LACKS ANY 'SPECIAL */
/* PROCESSING' FEATURE WHICH WOULD ALLOW SPECIFICATION OF A FORMAT */
/* VARIABLE, FRAME C HAS BEEN MODIFIED TO ALLOW FOR THE GREATEST   */
/* POSSIBLE NUMBER OF DECIMAL POSITIONS.                           */
/* CORRECTION TO J053: ALLOW FOR GREATEST POSSIBLE NUMBER OF       */
/* POSITIONS INCLUDING DIGITS AND DECIMALS                         */
form
   ard_ref
   ard_type
   ref_nu              column-label {&arpamta_p_1}
   armstr.ar_due_date
   open_amt            column-label {&arpamta_p_6}
   format "->>>>,>>>,>>9.999"
   ard_amt             column-label {&arpamta_p_5}
   format "->>>>,>>>,>>9.999"
with frame c title color normal
   (getFrameTitle("PAYMENT_APPLICATION_DETAIL",37))

   width 80 6 down.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

/*DEFINE DOCUMENT EDIT FRAME */

{&ARPAMTA-P-TAG1}
form
   ard_ref       colon 10 label {&arpamta_p_12}
   type          colon 28 format "!"  /*CONVERT TO UPPERCASE*/
   ard_entity    colon 50
   ard_tax       colon 10 label {&arpamta_p_1} format "x(8)"
   ardamt        colon 50
   ard_acct      colon 10
   ard_sub                no-label
   ard_cc                 no-label
   ard_amt       colon 50 label {&arpamta_p_4}
   ard_tax_at    colon 10
   ard_disc      colon 50
with frame d title color normal
   (getFrameTitle("PAYMENT_APPLICATION_MAINTENANCE",43))
   side-labels width 80.

{&ARPAMTA-P-TAG2}
/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

/*PERFORM INITIAL READS */
find ar_mstr where recid(ar_mstr) = ar_recno.
find cm_mstr  where cm_mstr.cm_domain = global_domain and  cm_addr =
ar_mstr.ar_bill no-lock no-error.
global_addr = ar_bill.
find first gl_ctrl   where gl_ctrl.gl_domain = global_domain no-lock.

/* INITIALIZE DISPLAY FORMATS PER PAYMENT CURRENCY ROUND METHOD */
assign
   artotal:format = ar_amt_fmt
   ar_amt:format = ar_amt_fmt
   unappamt:format = ar_amt_fmt
   ard_amt:format in frame d = ar_amt_fmt
   ardamt:format = ar_amt_fmt
   {&ARPAMTA-P-TAG3}
   ard_disc:format = ar_amt_fmt.
{&ARPAMTA-P-TAG4}

/*INITIALIZE CONTROL TOTALS */
unappamt = artotal - ar_amt.
display ar_check artotal ar_amt ar_bill unappamt
   cm_sort when (available cm_mstr)
with frame b1.

/*BEGIN BY DISPLAYING SCROLLING FRAME, USER CAN JUMP BACK    */
/*AND FORTH BETWEEN SELECTING A DOCUMENT AND EDITING THE DOC */
loopc:
repeat for armstr with frame c:
   unappamt = artotal - ar_mstr.ar_amt.
   display ar_mstr.ar_amt unappamt with frame b1.
   view frame c.
   view frame d.

   if not batchrun then do:

      /* IF BOTH A DISCOUNTED DRAFT & A NORMAL MEMO OR INVOICE      */
      /* HAVE BEEN SELECTED FOR PAYMENT, SHOW A WARNING MESSAGE.    */
      /* THE USER MAY NOT WANT TO COMBINE THESE 2 TYPES ON THE SAME */
      /* CHECK, DUE TO GL POSTING ISSUES.                           */
      disc_draft = false.
      memo_or_inv = false.
      for each ard_det  where ard_det.ard_domain = global_domain and  ard_nbr =
      ar_mstr.ar_nbr
         no-lock:

         if available ard_det then do:

            find armstr1  where armstr1.ar_domain = global_domain and
            armstr1.ar_nbr = ard_ref
            no-lock no-error.
            if available armstr1
               and armstr1.ar_type = "D"

               and ( armstr1.ar_dd_ex_rate <> 1
               or  armstr1.ar_dd_ex_rate2 <> 1
               or  armstr1.ar_dd_curr <> "" ) then
               disc_draft = true.
            else
               memo_or_inv = true.
         end. /* if available ard_det */
      end. /* for each ard_det ... */

      if disc_draft and memo_or_inv then do:
         {pxmsg.i &MSGNUM=3556 &ERRORLEVEL=2}
         /* DISCOUNTED DRAFT AND NORMAL MEMO */
         /* INCLUDED IN SELECTION            */
      end.

      /* Include scrolling window to allow the user to scroll      */
      /* through (and select from) existing payments applications. */

      {&ARPAMTA-P-TAG6}
      {swindar.i &domain="ard_det.ard_domain = global_domain and "
      &domain2="armstr.ar_domain = global_domain and "
         &searchkey = ar_mstr.ar_nbr
         &detfile = ard_det
         &detkey  = ard_nbr
         &detlink = ard_ref
         &mstrfile = armstr
         &mstrkey  = armstr.ar_nbr
         &scroll-field = ard_ref
         &framename = "c"
         &framesize = 6
         &display1 = ard_ref
         &display2 = ard_type
         &display3 = "ard_tax when (ard_type = '"N"' or
         ard_typ = '"U"')  @ ref_nu"
         &display4 = "ar_due_date when (available armstr)"
         &display5 = "if ar_mstr.ar_curr <> armstr.ar_curr
           then
           round(((armstr.ar_amt - armstr.ar_applied)
           * ar_mstr.ar_ex_rate
           / ar_mstr.ar_ex_rate2
           * armstr.ar_ex_rate2
           / armstr.ar_ex_rate)
           ,3)
           else
           armstr.ar_amt - armstr.ar_applied
           when (available armstr) @ open_amt"

         &display6 = ard_amt
         &exitlabel = loopc
         &exit-flag = first_sw_call
         &record-id = arddet_recno
         }

      {&ARPAMTA-P-TAG7}
   end. /* if not batchrun */
   if first_sw_call then first_sw_call = false.

   /* UPDATE APPLICATION DETAIL */
   pause 0.
   {gprun.i ""xxarpamtc.p""}  /* SS - 110114.1 */

   if batchrun then leave loopc.

end.  /* loopc */

hide frame b1 no-pause.
hide frame c no-pause.
hide frame d no-pause.
