/* arsbpu.p   - SELFBILLING PAYMENT APPLICATION UNDO                          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.9.1.8 $                                                  */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 8.6E   CREATED    : 08/18/98      BY: *K1DR* Suresh Nayak        */
/* REVISION: 9.1    LAST MODIFIED: 10/01/99    BY: *N014* Paul Johnson        */
/* REVISION: 9.1    LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane    */
/* REVISION: 9.1    LAST MODIFIED: 08/11/00    BY: *N0KK* Jacolyn Neder       */
/* Revision: 1.9.1.6  BY: Jean Miller        DATE: 03/01/02  ECO: *N1BJ*      */
/* Revision: 1.9.1.7  BY: Manjusha Inglay    DATE: 07/29/02  ECO: *N1P4*      */
/* $Revision: 1.9.1.8 $   BY: K Paneesh          DATE: 08/07/02  ECO: *N1QF*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */
/*                                                                          */
/*         THIS PROGRAM IS A BOLT-ON TO STANDARD PRODUCT MFG/PRO.           */
/* ANY CHANGES TO THIS PROGRAM MUST BE PLACED ON A SEPARATE ECO THAN        */
/* STANDARD PRODUCT CHANGES.  FAILURE TO DO THIS CAUSES THE BOLT-ON CODE TO */
/* BE COMBINED WITH STANDARD PRODUCT AND RESULTS IN PATCH DELIVERY FAILURES.*/
/*                                                                          */
/* -----  W A R N I N G  -----  W A R N I N G  -----  W A R N I N G  -----  */

{mfdtitle.i "2+ "}

define new shared variable h-arpamtpl as handle no-undo.
define new shared variable apply2_rndmthd like rnd_rnd_mthd.
define new shared variable old_doccurr    like ar_curr.
define new shared variable rndmthd  like rnd_rnd_mthd.
define new shared variable undo_all like mfc_logical.
define new shared variable base_amt like ar_amt.
define new shared variable disc_amt like ar_amt.
define new shared variable curr_amt like ar_amt.
define new shared variable gain_amt like ar_amt.
define new shared variable curr_disc like glt_curr_amt.
define new shared variable base_det_amt like glt_amt.
define new shared variable gltline like glt_line.
define new shared variable jrnl like glt_ref.
define new shared variable ar_recno as recid.
define new shared variable ard_recno as recid.

define new shared variable shared_bill_to like so_bill no-undo.
define new shared variable cash_book      like mfc_logical.

define variable applied_amt like ard_amt no-undo.
define variable archeck like ar_check no-undo.
define variable bill_to like so_bill no-undo.
define variable daybook_desc like dy_desc no-undo.
define variable dy_code like ar_dy_code no-undo.
define variable not_successful as log no-undo.
define variable unapplied_amt like ard_amt no-undo.
define variable unapplied_ref_nbr as character no-undo.
define variable w_jrnl like glt_ref no-undo.
define variable yn like mfc_logical no-undo.
define buffer armstr for ar_mstr.

{etvar.i &new = new} /* COMMON EURO TOOLKIT VARIABLES */
{gpglefdf.i}    /*VARIABLE DEFINITIONS FOR gpglef.p*/
{gldydef.i new} /*VARIABLE DEFINITIONS FOR DAYBOOKS*/
{gldynrm.i new} /*VARIABLE DEFINITIONS FOR NRM*/

form
   bill_to             colon 38
   ad_name             no-label
   archeck             colon 38
   skip(1)
   ar_batch            colon 38
   ar_date             colon 38
   ar_effdate          colon 38
   ar_bank             colon 38
   bk_desc             no-label
   ar_curr             colon 38
   ar_entity           colon 38
   ar_acct             colon 38
   ar_sub              no-label
   ar_cc               no-label
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


/*LOAD THE PAYMENT MAINT PROCESS LOGIC PROGRAM USED FOR AUTO APPLY*/
{gprun.i ""arpamtpl.p"" "persistent set h-arpamtpl"}

/*GET THE GL CONTROL RECORD*/
find first gl_ctrl no-lock.

/* GET NEXT JOURNAL REFERENCE NUMBER */

do transaction:
   {mfnctrl.i arc_ctrl arc_jrnl glt_det glt_ref w_jrnl}
end.

/*OBTAIN DEFAULT DAYBOOK*/
{gprun.i ""gldydft.p""
   "(input ""AR"",
     input ""P"",
     input gl_entity,
     output dy_code,
     output daybook_desc)"}

mainloop:
repeat transaction:

   /*GET BILL-TO, SELFBILL NBR, TRANSMISSION NBR FROM USER*/
   set
      bill_to
      archeck
   with frame a
   editing:

      if frame-field = 'bill_to' then do:
         {mfnp05.i
            cm_mstr
            cm_addr
            yes
            cm_addr
            "input frame a bill_to"}

         if recno <> ? then do:
            find ad_mstr where ad_addr = cm_addr no-lock.

            display
               cm_addr @ bill_to
               ad_name
            with frame a.
         end.
      end.

      else do:
         ststatus = stline[3].
         status input ststatus.
         readkey.
         apply lastkey.
      end.

      shared_bill_to = input frame a bill_to.
      {gpbrparm.i &browse=gplu548.p &parm=c-brparm1 &val="shared_bill_to"}
      {gpbrparm.i &browse=gplu549.p &parm=c-brparm1 &val="shared_bill_to"}
      {gpbrparm.i &browse=gplu551.p &parm=c-brparm1 &val="shared_bill_to"}

   end.

   /*VALIDATE BILL-TO*/
   find cm_mstr where cm_addr = bill_to exclusive-lock no-error.

   if not available cm_mstr then do:
      {pxmsg.i &MSGNUM=3 &ERRORLEVEL=3}
      /*NOT A VALID CUSTOMER*/
      next-prompt bill_to with frame a.
      undo, retry.
   end.

   find ad_mstr where ad_addr = cm_addr no-lock.
   display ad_name with frame a.

   /*SEE IF PAYMENT RECORD EXISTS*/
   find first ar_mstr
      where ar_type = "P"
        and ar_check = archeck
        and ar_bill = bill_to
   use-index ar_check
   no-lock no-error.

   if available ar_mstr then do:

      ar_recno = recid(ar_mstr).

      /*VALIDATE NO UNAPPLIED CASH APPLICATIONS MADE*/
      do for armstr:

         find first armstr where ar_check = archeck
                             and ar_bill = bill_to
                             and ar_type = "A"
         no-lock no-error.

         if available armstr then do:
            /*CANNOT DELETE - MUST REVERSE UNAPPLIED CASH APPLICATION*/
            {pxmsg.i &MSGNUM=1174 &ERRORLEVEL=3 &MSGARG1=ar_nbr}
            undo, retry.
         end.
      end.

      /*VALIDATE EFFECTIVE DATE AGAINST GL CALENDAR*/
      {gpglef02.i
         &module = ""AR""
         &entity = gl_entity
         &date   = ar_effdate
         &prompt = archeck
         &frame  = a
         &loop   = mainloop}

      /*DISPLAY PAYMENT INFO*/
      find bk_mstr where bk_code = ar_bank no-lock no-error.

      display
         ar_batch
         ar_date
         ar_effdate
         ar_bank
         bk_desc     when (available bk_mstr)
         ar_curr
         ar_entity
         ar_acct
         ar_sub
         ar_cc
      with frame a.

   end.

   else do:
      /* Check Number not found */
      {pxmsg.i &MSGNUM=4021 &ERRORLEVEL=2}
      ar_recno = ?.
   end.

   /*VALIDATE AT LEAST ONE SELFBILL REFERENCES THE CHECK*/
   find first sbi_mstr
        where sbi_check = archeck
          and sbi_bill = bill_to
   no-lock no-error.

   if not available sbi_mstr then do:
      {pxmsg.i &MSGNUM=4346 &ERRORLEVEL=3}
      /*NO SELF-BILLS EXIST FOR THIS PAYMENT RECORD*/
      undo, retry.
   end.

   /*ASK USER IF OK TO PROCEED*/
   yn = false.

   /*PLEASE CONFIRM UPDATE*/
   {pxmsg.i &MSGNUM=32 &ERRORLEVEL=1 &CONFIRM=yn}

   if not yn then undo mainloop, retry mainloop.

   /*REVERSE THE AMOUNT APPLIED IN THE SHIPMENT INVOICE XREF RECORDS*/
   for each sbi_mstr no-lock
      where sbi_bill = bill_to
        and sbi_check = archeck,
       each sbid_det no-lock
      where sbid_bill = sbi_bill
        and sbid_nbr = sbi_nbr
        and sbid_inv_nbr > ""
        and sbid_trnbr > 0:

      /* GET ANY UNAPPLIED AMT THAT WAS CREATED DUE TO THE
         SELFBILL AMT EXCEEDING THE OPEN AMT IN THE XREF RECORD.
         WHAT WE UNDO IS THE SELFBILL AMT LESS THE UNAPPLIED AMT.*/
      unapplied_amt = 0.

      run create_unapplied_ref_nbr
         (input sbid_nbr,
          input sbid_line,
          output unapplied_ref_nbr).

      find first ard_det
           where ard_nbr = string(sbi_bill,"x(8)") + archeck
             and ard_ref = ""
             and ard_type = "U"
             and ard_tax_at = ""
             and ard_tax = unapplied_ref_nbr
      no-lock no-error.

      if available ard_det then
         unapplied_amt = ard_amt.

      /*REVERSE AMOUNT APPLIED*/
      applied_amt = sbid_amt - unapplied_amt.
      find six_ref where six_trnbr = sbid_trnbr exclusive-lock.
      six_amt_appld = six_amt_appld - applied_amt.

   end.

   if ar_recno <> ? then do:

      /*DELETE THE PAYMENT RECORD*/
      run delete_payment
         (input bill_to,
          input archeck,
          input w_jrnl,
          output not_successful).

      if not_successful then do:
         {pxmsg.i &MSGNUM=4342 &ERRORLEVEL=3}
         /*UNABLE TO DELETE EXISTING PAYMENT*/
         undo mainloop, retry mainloop.
      end.

   end.

   /*BLANK THE SELFBILL HEADER RECORD(S) CHECK NUMBER*/
   for each sbi_mstr exclusive-lock
      where sbi_bill = bill_to
        and sbi_check = archeck:
      sbi_check = "".
   end.

end.  /*mainloop*/

/* DELETE THE PAYMENT MAINT PROCESS LOGIC PROGRAM USED FOR AUTO APPLY*/
delete PROCEDURE h-arpamtpl no-error.

PROCEDURE delete_payment:
   /* DELETES AN ENTIRE PAYMENT RECORD AND ASSOCIATED DETAILS
      BY CALLING ARPAMTD.P.  ARPAMTD.P NEEDS A BUNCH OF SHARED VARIABLES
      WHICH ARE DEFINED ABOVE.*/
   define input parameter p_bill_to like cm_addr no-undo.
   define input parameter p_check like ar_check no-undo.
   define input parameter p_jrnl as character no-undo.
   define output parameter p_not_successful as log no-undo.

   assign
      apply2_rndmthd = ""
      old_doccurr = ""
      jrnl = p_jrnl.

   find first ar_mstr where ar_type = "P"
                        and ar_check = p_check
                       and ar_bill = p_bill_to
   no-lock.

   ar_recno = recid(ar_mstr).

   {gprun.i ""arpamtd.p""}

   p_not_successful = undo_all.

END PROCEDURE.

PROCEDURE create_unapplied_ref_nbr:
   define input parameter p_sbid_nbr like sbid_nbr no-undo.
   define input parameter p_sbid_line like sbid_line no-undo.
   define output parameter p_unapplied_ref_nbr as character no-undo.

   define variable strlen as integer no-undo.

   p_unapplied_ref_nbr = p_sbid_nbr + "/" + string(p_sbid_line).

   /* SHORTEN IT DOWN TO LENGTH 8 SO IT WILL FIT IN THE AR
      UNAPPLIED REF FIELD.  DO IT BY DROPPING LEADING CHARS*/
   strlen = length(p_unapplied_ref_nbr).

   if strlen > 8 then
      p_unapplied_ref_nbr = substring(p_unapplied_ref_nbr, strlen - 7).

END PROCEDURE.
