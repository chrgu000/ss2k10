/* ardrmte.p - AR DEBIT/CREDIT MEMO MAINTENANCE GET REFERENCE               */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.11.1.10 $                                                         */
/*V8:ConvertMode=Maintenance                                                */
/* REVISION: 7.2      LAST MODIFIED: 06/27/94   BY: pmf *FP09*              */
/*                                   07/25/94   by: pmf *FP52*              */
/* REVISION: 7.4      LAST MODIFIED: 02/17/95   by: wjk *H0BH*              */
/* REVISION: 7.4      LAST MODIFIED: 05/06/95   by: wjk *G0M4*              */
/* REVISION: 8.5      LAST MODIFIED: 12/19/95   by: taf *J053*              */
/* REVISION: 7.4      LAST MODIFIED: 01/30/96   BY: ais *G1L8*              */
/* REVISION: 8.6      LAST MOFIFIED: 06/18/96   BY: PJG *K001*              */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   BY: taf *J101*              */
/* REVISION: 8.5      LAST MODIFIED: 08/14/96   BY: *G2C6* Aruna P. Patil   */
/* REVISION: 8.6      LAST MODIFIED: 09/03/96   BY: jzw *K00B*              */
/* REVISION: 8.6      LAST MODIFIED: 09/30/96   BY: *G2G2* Aruna P. Patil   */
/* REVISION: 8.6      LAST MODIFIED: 12/31/96   BY: *K03F* Jeff Wootton     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E     LAST MODIFIED: 06/30/98   BY: *J2MQ* Samir Bavkar     */
/* REVISION: 8.6E     LAST MODIFIED: 07/07/98   BY: *L01K* Jaydeep Parikh   */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton      */
/* REVISION: 9.1      LAST MODIFIED: 10/22/99   BY: *N04P* Robert Jensen     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane    */
/* REVISION: 9.1      LAST MODIFIED: 06/19/00   BY: *N0CL* Arul Victoria     */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 09/13/00   BY: *N0VV* BalbeerS Rajput   */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.11.1.9      BY: Vihang Talwalkar DATE: 10/22/01  ECO: *P01V*  */
/* $Revision: 1.11.1.10 $   BY: Saurabh C.       DATE: 05/15/02  ECO: *M1Y7*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "ARDRMTE.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

/* MaxLen: Comment: */

&SCOPED-DEFINE ardrmte_p_2 "Batch"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrmte_p_3 "Memo Control"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{gldydef.i}
{gldynrm.i}

define shared variable rndmthd         like rnd_rnd_mthd.
define shared variable oldcurr         like ar_curr.
define shared variable artotal_old     as character.
define shared variable artotal_fmt     as character.
define shared variable ar_amt_old      as character.
define shared variable ar_amt_fmt      as character.
define shared variable ar_sales_old    as character.
define shared variable ar_sales_fmt    as character.
define shared variable ba_recno        as   recid.
define shared variable batch           like ar_batch label {&ardrmte_p_2}.
define shared variable arnbr           like ar_nbr.
define shared variable artotal         like ar_amt   label {&ardrmte_p_3}.
define shared variable bactrl          like ba_ctrl.
define shared variable bamodule        like ba_module.

define variable inbatch                 like ar_batch.
define variable arc_ext_ref             like mfc_logical.
define variable mc-error-number         like msg_nbr no-undo.
define variable c-trans-label1          as character no-undo.

/* DEFINE LOGISTICS TABLES */
{lgardefs.i &type="lg"}

/* DEFINE SHARED FRAME A */
{ardrfma.i}

/* DEFINE SHARED FRAME B*/

{ardrfmb.i}

if ba_recno <> 0
then
   find ba_mstr
      where recid(ba_mstr) = ba_recno
      no-lock.

find first gl_ctrl
   no-lock no-error.

do transaction:
   if available ba_mstr
   then
      display
         ba_total
      with frame a.

/* IF NOT LOGISTICS, PROCESS NORMALLY */
   if not lgData
   then do:
      prompt-for
         ar_nbr
      with frame b
      editing:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp01.i ar_mstr ar_nbr ar_nbr batch ar_batch ar_batch}
         if recno <> ?
         then do:
            if (oldcurr <> ar_curr)
               or (oldcurr = "")
            then do:
               if ar_curr = base_curr
               then
                  rndmthd = gl_rnd_mthd.
               else do:
                  /* GET ROUNDING METHOD FROM CURRENCY MASTER */
                  {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                                       "(input  ar_curr,
                                         output rndmthd,
                                         output mc-error-number)"}

                  if mc-error-number <> 0
                  then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                     if lgData then return.
                     next-prompt ar_nbr.
                     undo, retry.
                  end.
               end.

               artotal_fmt = artotal_old.
               {gprun.i ""gpcurfmt.p"" "(input-output artotal_fmt,
                                         input        rndmthd)"}
               assign
                  artotal:format = artotal_fmt
                  ar_amt_fmt     = ar_amt_old.

               {gprun.i ""gpcurfmt.p"" "(input-output ar_amt_fmt,
                                         input        rndmthd)"}
               ar_amt:format = ar_amt_fmt.
               ar_sales_fmt  = ar_sales_old.
               {gprun.i ""gpcurfmt.p"" "(input-output ar_sales_fmt,
                                         input        rndmthd)"}
               ar_sales_amt:format = ar_sales_fmt.
               oldcurr             = ar_curr.
            end.
            display
               ar_nbr
               ar_effdate
               ar_date
               ar_bill
               ar_amt
               ar_type
               ar_cr_term
               ar_disc_date
               ar_due_date
               ar_po
               ar_sales_amt
               ar_slspsn[1]
               ar_slspsn[2]
               ar_dy_code
               ar_slspsn[3]
               ar_slspsn[4]
               ar_comm_pct[1]
               ar_comm_pct[2]
               ar_comm_pct[3]
               ar_comm_pct[4]
               ar_acct
               ar_sub
               ar_cc
               ar_entity
               ar_ship
               ar_expt_date
               ar_tax_date
               ar_dun_level
               ar_batch
               ar_curr
               ar_print
               ar_contested
               ar_cust
               ar_shipfrom when (ar_type = "M" or ar_type = "F")
            with frame b.
            {&ARDRMTE-P-TAG1}
            find cm_mstr
               where cm_addr = ar_bill
               no-lock no-error.
            if available cm_mstr
            then
               display
                  cm_sort
               with frame b.
            else
               display
                  " " @ cm_sort
               with frame b.
         end. /* if recno <> ? */
      end. /* editing phrase */
   end. /* if not lgData */
   else do:
      /* NEED TO SET ar_nbr TO BOD REQUESTED VALUE, IF ONE */
      /* 'display' IT TO GET IT INTO INPUT VALUE. */

      for first lgm_lgmstr no-lock:
         if lgm_ar_nbr <> ?
         then
            display
               lgm_ar_nbr @ ar_nbr
            with frame b.
      end.
   end.

   if input ar_nbr = ""
   then do:

      /* IF BATCH NUMBER ENTERED IS AN EXISTING INVOICE */
      /* BATCH, NEW MEMOS AREN'T ALLOWED TO BE ENTERED */
      if bamodule = "SO"
      then do:
         {pxmsg.i &MSGNUM=1185 &ERRORLEVEL=3}
         /* BATCH ALREADY CONTAINS         */
         /* INVOICES - CAN'T ADD NEW MEMOS */
         if lgData
         then
            return.
         pause.
         next-prompt
            ar_nbr
         with frame b.
         undo, retry.
      end.
      else do:
         {mfnctrl.i arc_ctrl arc_memo ar_mstr ar_nbr arnbr}
         display
            arnbr @ ar_nbr
         with frame b.
      end.
   end. /* if input ar_nbr */
   else
      arnbr = input ar_nbr.
   find ar_mstr using ar_nbr
      no-lock no-error.
   if available ar_mstr
   then do:
      if (oldcurr <> ar_curr)
      then do:
         /* DETERMINE ROUND METHOD FROM DOC CURRENCY OR BASE    */

         if (base_curr <> ar_curr)
         then do:
            /* GET ROUNDING METHOD FROM CURRENCY MASTER */
            {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                                 "(input  ar_curr,
                                   output rndmthd,
                                   output mc-error-number)"}
            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
               if lgData
               then
                  return.
               next-prompt
                  ar_nbr
               with frame b.
               undo, retry.
            end.
         end.
         else
            rndmthd = gl_rnd_mthd.
         artotal_fmt = artotal_old.
         {gprun.i ""gpcurfmt.p"" "(input-output artotal_fmt,
                                   input        rndmthd)"}
         assign
            artotal:format = artotal_fmt
            ar_amt_fmt     = ar_amt_old.

         {gprun.i ""gpcurfmt.p"" "(input-output ar_amt_fmt,
                                   input        rndmthd)"}
         assign
            ar_amt:format = ar_amt_fmt
            ar_sales_fmt  = ar_sales_old.

         {gprun.i ""gpcurfmt.p"" "(input-output ar_sales_fmt,
                                   input        rndmthd)"}
         assign
            ar_sales_amt:format = ar_sales_fmt
            oldcurr = ar_curr.
      end.
   end.
   if not available ar_mstr
   then do:
      c-trans-label1 =
      getTermLabel("EXTERNAL_MEMO_REFERENCES_ALLOWED",35).

      /* IF EXTERNAL REFERENCE NOT ALLOWED, REQUIRE THAT NEW
      VOUCHER NUMBER BE SYSTEM GENERATED */

      /* ADD MFC_CTRL FIELD arc_ext_ref if necessary */
      find first mfc_ctrl
         where mfc_field = "arc_ext_ref"
         no-lock no-error.
      if not available mfc_ctrl
      then do:
         create mfc_ctrl.
         assign
            mfc_field   = "arc_ext_ref"
            mfc_type    = "L"
            mfc_label   = c-trans-label1
            mfc_module  = "AR"
            mfc_seq     = 30.
            mfc_logical = yes.
      end.
      arc_ext_ref = mfc_logical.

      if not arc_ext_ref
         and ar_nbr entered
      then do:
         {pxmsg.i &MSGNUM=1178 &ERRORLEVEL=3} /* INVALID MEMO NUMBER */
         if lgData
         then
            return.
         display
            "" @ ar_nbr
         with frame b.
         undo, retry.
      end.

      /* IF BATCH NUMBER ENTERED IS AN EXISTING INVOICE */
      /* BATCH, NEW MEMOS AREN'T ALLOWED TO BE ENTERED */
      if bamodule = "SO"
      then do:
         {pxmsg.i &MSGNUM=1185 &ERRORLEVEL=3}
         /* BATCH ALREADY CONTAINS         */
         /* INVOICES - CAN'T ADD NEW MEMOS */
         pause.
         if lgData
         then
            return.
         next-prompt
            ar_nbr
         with frame b.
         undo, retry.
      end.
      else do:
         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1} /* ADDING NEW RECORD */

      end. /* else do: */
   end. /* if not available ar_mstr */

   /* BATCH NUMBER IS ASSIGNED ONLY FOR REFERENCE OF  */
   /* TRANSACTION TYPES MEMO/FINANCE CHARGES/INVOICE  */

   else
   if batch = ""
      and index("MFI",ar_type) <> 0
   then
      batch = ar_batch.

   if batch <> ""
   then do:
      find first ba_mstr
         where ba_batch = batch
         and ba_module  = "AR"
         no-lock no-error.

      if not available ba_mstr
      then
      find ba_mstr
         where ba_batch  = batch
         and   ba_module = "SO"
         no-lock no-error.
      if available ba_mstr
      then do:
         assign
            bactrl = ba_ctrl
            bamodule = ba_module.
      end.
   end. /* if batch <> "" */

   /*USE GPGETBAT TO GET THE NEXT BATCH NUMBER AND CREATE */
   /*THE BATCH MASTER (BA_MSTR)                           */
   inbatch = batch.
   {gprun.i ""gpgetbat.p"" "(input  inbatch, /*IN-BATCH #     */
                             input  bamodule,/*MODULE         */
                             input  ""M"",   /*DOC TYPE       */
                             input  bactrl,  /*CONTROL AMOUNT */
                             output ba_recno,/*NEW BATCH RECID*/
                             output batch)"} /*NEW BATCH #    */
   display
      batch
   with frame a.
end. /*TRANSACTION*/
