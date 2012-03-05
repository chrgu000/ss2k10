/* arpamtg.p - AR PAYMENT MAINTENANCE SUBROUTINE: GET PAYMENT KEY DATA      */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.7.1.9 $                                                         */
/*V8:ConvertMode=Maintenance                                                */
/* REVISION: 7.4            CREATED: 09/15/93      By: pcd *H115*           */
/*                    LAST MODIFIED: 02/10/94      By: srk *GI33*           */
/*                                   07/21/94      by: pmf *FP52*           */
/*                                   10/17/94      by: str *FS46*           */
/* REVISION: 8.5      LAST MODIFIED: 01/13/95      by: ccc *J053*           */
/* REVISION: 8.6      LAST MODIFIED: 06/21/96      by: bjl *K001*           */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96      by: taf *J101*           */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E     LAST MODIFIED: 06/02/98   BY: *L01K* Jaydeep Parikh   */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 03/24/99   BY: *K1ZV* Narender Singh    */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Paul Johnson      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 08/05/00   BY: *N0VV* BalbeerS Rajput   */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.7.1.9 $ BY: Seema Tyagi               DATE: 08/21/01  ECO: *M1HQ*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "ARPAMTG.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE arpamtg_p_1 "Total"
/* MaxLen: Comment: */

&SCOPED-DEFINE arpamtg_p_2 "Check Control"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{gldydef.i}
{gldynrm.i}

define shared variable rndmthd         like rnd_rnd_mthd.
define shared variable oldcurr         like ar_curr.
define shared variable ar_amt_old      as   character.
define shared variable ar_amt_fmt      as   character.
define shared variable cm_recno        as   recid.
define shared variable undo_mtg        like mfc_logical.
define shared variable batch           like ar_batch.
define shared variable bactrl          like ba_ctrl.
define shared variable desc1           like bk_desc.
define shared variable batch_total     like ar_amt label {&arpamtg_p_1}.
define shared variable artotal         like ar_amt label {&arpamtg_p_2}.
define shared variable cash_book       like mfc_logical.
define shared variable arnbr           like ar_nbr.
define shared variable bank_curr       like bk_curr.
define shared variable new_line        like mfc_logical.
define shared variable ba_recno        as   recid.
{&ARPAMTG-P-TAG1}

define        variable bank            like bk_code.
{&ARPAMTG-P-TAG2}
define        variable auto_apply      like mfc_logical initial no.
define        variable inbatch         like ap_batch.
define        variable mc-error-number like msg_nbr no-undo.

define shared frame a.
define shared frame b.

/* FORM DEFINITIONS */
{arpafma.i}
{arpafmb.i}

find first gl_ctrl no-lock no-error.

do transaction with frame b:
   display batch_total with frame a.
   auto_apply = false.

   if not cash_book then
      prompt-for ar_mstr.ar_check
   editing:
      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp01.i ar_mstr ar_check ar_check batch ar_batch ar_batch}
      if recno <> ?
      then do:
         /* DETERMINE ROUND METHOD FROM PMT CURRENCY OR BASE*/

         if (oldcurr <> ar_curr) or (oldcurr = "")
         then do:

            /* GET ROUNDING METHOD FROM CURRENCY MASTER */
            {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
               "(input ar_curr,
                 output rndmthd,
                 output mc-error-number)"}
            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
               rndmthd = gl_rnd_mthd.
            end.
            /* SET AR_AMT_FMT */
            ar_amt_fmt = ar_amt_old.
            {gprun.i ""gpcurfmt.p"" "(input-output ar_amt_fmt,
                 input rndmthd)"}
            ar_amt:format = ar_amt_fmt.
            oldcurr = ar_curr.
         end.

         display
            ar_check
            ar_effdate
            ar_date
            ar_bill
            (- ar_amt)     @ ar_amt
            ar_type
            ar_acct
            ar_sub
            ar_cc
            ar_disc_acct
            ar_disc_sub
            ar_disc_cc
            ar_entity
            ar_dy_code
            ar_po
            ar_curr
            ar_bank        @ bank
            ar_batch.
         {&ARPAMTG-P-TAG3}

         find cm_mstr where cm_addr = ar_bill no-lock no-error.
         if available cm_mstr
         then
            display
               cm_sort.
         else
            display " " @ cm_sort.

         find first bk_mstr where bk_code = ar_bank no-lock no-error.
         if available bk_mstr
         then
            display
               bk_desc @ desc1.
         else
            display " " @ desc1.
      end.
   end.

   if (input ar_check = "" and not cash_book)
      {&ARPAMTG-P-TAG4}
   then do:
      {mfnctrl.i arc_ctrl arc_memo ar_mstr ar_check arnbr}
      {&ARPAMTG-P-TAG5}
      display
         arnbr @ ar_check.
   end.
   else do:
      if input ar_check = ?
      then do:
         /* INVALID DATA IN CHECK FIELD */
         {pxmsg.i &MSGNUM=4813 &ERRORLEVEL=3}
         if not batchrun
         then
            pause.
         next-prompt ar_check.
         undo, retry.
      end. /* IF INPUT ar_check = ? */

      if not cash_book
      then
         arnbr = input ar_check.
      else
         display arnbr @ ar_check.
      {&ARPAMTG-P-TAG6}

      find first ar_mstr
         where ar_check = arnbr and ar_batch = batch
      no-lock no-error.

      if available ar_mstr
      then do:
         if (oldcurr <> ar_curr) or (oldcurr = "")
         then do:
            /* GET ROUNDING METHOD FROM CURRENCY MASTER */
            {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
               "(input ar_curr,
                 output rndmthd,
                 output mc-error-number)"}
            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
               undo, retry.
            end.
            /* SET AR_AMT_FMT */
            ar_amt_fmt = ar_amt_old.
            {gprun.i ""gpcurfmt.p"" "(input-output ar_amt_fmt,
                 input rndmthd)"}
            ar_amt:format = ar_amt_fmt.
            oldcurr = ar_curr.
         end.

         display
            ar_effdate
            ar_date
            ar_bill
            (- ar_amt)           @ ar_amt
            ar_type
            ar_acct
            ar_sub
            ar_cc
            ar_disc_acct
            ar_disc_sub
            ar_disc_cc
            ar_entity
            ar_dy_code
            ar_po
            ar_curr
            ar_bank              @ bank
            ar_batch
            auto_apply.
         {&ARPAMTG-P-TAG7}

         find cm_mstr where cm_addr = ar_bill no-lock no-error.
         if available cm_mstr
         then
            display
               cm_sort.
         else
            display
               " " @ cm_sort.

         find first bk_mstr where bk_code = ar_bank no-lock no-error.
         if available bk_mstr
         then
            display
               bk_desc @ desc1.
         else
            display
               " " @ desc1.
         for first dy_mstr fields (dy_dy_code dy_desc)
            where dy_dy_code = ar_dy_code no-lock:
         end.
         if available dy_mstr
         then
            assign
               daybook-desc = dy_desc
               dft-daybook  = ar_dy_code.
      end.
      {&ARPAMTG-P-TAG8}
   end.
   {&ARPAMTG-P-TAG9}
end. /*transaction*/

if not cash_book or (cash_book and new_line) then
   do transaction with frame b:
   do on error undo, retry:
      prompt-for ar_bill
      editing:
         {mfnp.i cm_mstr ar_bill cm_addr ar_bill cm_addr cm_addr}
         if recno <> ? then
         {&ARPAMTG-P-TAG10}
         display cm_addr @ ar_bill cm_sort cm_curr @ ar_curr.
      end.
      find cm_mstr where cm_addr = input ar_bill no-lock no-error.
      if available cm_mstr
      then
         display
            cm_sort.
      else do:
         {pxmsg.i &MSGNUM=3 &ERRORLEVEL=3} /* NOT A VALID CUSTOMER */
         undo, retry.
      end.
      {&ARPAMTG-P-TAG11}
   end.

   if available cm_mstr
      and input ar_curr = ""
      and not cash_book
   then
      display
         cm_curr @ ar_curr.

   if cash_book
   then
      display
         bank_curr @ ar_curr.
   find ar_mstr where ar_nbr = string(input ar_bill, "X(8)" )
      + string(arnbr) no-error.

   if not available ar_mstr
   then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1} /* ADDING NEW RECORD */
   end.
   else
      if batch = ""
      then
         batch = ar_batch.

   if batch <> ""
   then do:
      find first ba_mstr where ba_batch = batch and
         ba_module = "AR" no-lock no-error.
      if available ba_mstr
      then
         bactrl = ba_ctrl.
   end.

   if not cash_book
   then do:
      /*USE GPGETBAT TO GET THE NEXT BATCH NUMBER AND CREATE*/
      /*THE BATCH MASTER (BA_MSTR).  IF THE BA_MSTR ALREADY */
      /*EXISTS THE RECORD WILL BE UPDATED.                  */
      inbatch = batch.
      {gprun.i ""gpgetbat.p"" "(input  inbatch, /*IN-BATCH #     */
           input  ""AR"",  /*MODULE         */
           input  ""P"",   /*DOC TYPE       */
           input  bactrl,  /*CONTROL AMOUNT */
           output ba_recno,/*NEW BATCH RECID*/
           output batch)"} /*NEW BATCH #    */
      display batch bactrl with frame a.
   end.

   if available cm_mstr
   then
      cm_recno = recid (cm_mstr).
end. /*transaction*/

undo_mtg = false.
