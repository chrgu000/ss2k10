/* pjivgen5.p - AR DEBIT/CREDIT MEMO GENERATION FOR PROJECT/SUB-PROJECT       */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.27 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 9.1      CREATED       : 06/30/00   BY: *N009* Luke Pokic        */
/* REVISION: 9.1      MODIFIED      : 08/13/00   BY: *N0KQ* myb               */
/* REVISION: 9.1      LAST MODIFIED : 10/27/00   BY: *N0T8* Vincent Koh       */
/* REVISION: 9.1      MODIFIED      : 12/04/00   BY: *N0WW* Mudit Mehta       */
/* REVISION: 9.1      LAST MODIFIED : 06/29/01   BY: *N0ZX* Ed van de Gevel   */
/* $Revision: 1.27 $       BY: Manjusha Inglay        DATE: 08/16/02  ECO: *N1QP*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "PJIVGEN5.P"}
{&PJIVGEN5-P-TAG1}

define input  parameter   ins_recno        as   recid           no-undo.

{&PJIVGEN5-P-TAG2}

/* VARIABLES NECESSARY FOR THE AR GENERAL LEDGER TRANSACTIONS     */
define new shared variable ar_recno        as   recid.
define new shared variable ard_recno       as   recid.
define new shared variable ba_recno        as   recid           no-undo.
define new shared variable undo_all        as   logical.
define new shared variable jrnl            like glt_ref.

define            variable arnbr           like ar_nbr          no-undo.
define            variable bactrl          like ba_ctrl         no-undo.
define            variable exch_rate       like prj_ex_rate     no-undo.
define            variable exch_rate2      like prj_ex_rate2    no-undo.
define            variable exch_ratetype   like prj_ex_ratetype no-undo.
define            variable exch_seq        like prj_exru_seq    no-undo.

/* VARIABLES FOR AR GENERAL LEDGER TRANSACTION */
define new shared variable batch           like ba_batch        no-undo.
define new shared variable base_amt        like ar_amt.
define new shared variable gltline         like glt_line.
define new shared variable curr_amt        like glt_amt.
define new shared variable base_det_amt    like glt_amt.

/* VARIABLES TO CALCULATE TAX AMOUNTS */
define new shared variable taxable_in      like ad_tax_in       no-undo
                                           initial false.
define new shared variable tax_recno       as   recid.
define            variable taxable         like mfc_logical     no-undo.
define            variable tax-class       like prj_taxc        no-undo
                                           initial "".
define            variable tax-pct         as   decimal         no-undo.
define            variable tax-amt         as   decimal         no-undo.
define            variable tax_date        like tax_effdate     no-undo.
define            variable tax             like ard_amt         no-undo
                                           extent 3.
define            variable i               as   integer         no-undo.
define            variable tax_tr_type     like tx2d_tr_type.
define            variable tax_nbr         like tx2d_nbr.
define            variable tax_lines       like tx2d_line
                                           initial 0.

define new shared variable rndmthd         like rnd_rnd_mthd.
define            variable init-daybook    like dy_dy_code      no-undo.
define            variable mc-error-number like msg_nbr         no-undo.
define            variable destentity      like gl_entity.
define            variable cmtindx         like ins_cmtindx     no-undo.
define            variable cnt             as   integer         no-undo.
define buffer cmtdet  for cmt_det.

{&PJIVGEN5-P-TAG3}
{txcalvar.i}
{gldydef.i new}
{gldynrm.i new}

/* GET NEXT JOURNAL REFERENCE NUMBER */
{mfnctrl.i arc_ctrl arc_jrnl glt_det glt_ref jrnl}

/* INVOICE SCHEDULE CONTROL FILE */
for first ivs_ctrl
   fields (ivs_prep_acct ivs_prep_sub ivs_prep_cc
           ivs_ptax_acct ivs_ptax_sub ivs_ptax_cc)
no-lock:
end. /* FOR FIRST ivs_ctrl */

/* RETRIEVE THE NECESSARY INFORMATION */
for first gl_ctrl
   fields (gl_base_curr gl_entity gl_rnd_mthd )
no-lock:
   destentity = gl_entity.

   for first ins_mstr
      where recid(ins_mstr) = ins_recno
   exclusive-lock:
   end. /* FOR FIRST ins_mstr */

   /* RESET THE INVOICE DATE IF IT IS EARLIER THAN TODAY */
   {gprun.i ""pjivgenc.p"" "(input ins_recno)"}

   /* RETRIEVE THE PROJECT INFORMATION */
   for first prj_mstr
      where prj_nbr = ins_prj_nbr
   exclusive-lock:

      if ins_sub_nbr = 0
      then do:
         /* PROJECT ENTITY */
         for first si_mstr
            fields(si_entity si_site)
            where si_site = prj_site
         no-lock:
         end. /* FOR FIRST si_mstr */
      end. /* IF ins_sub_nbr = 0 */
      else do:
         /* SUBPROJECT ENTITY */
         for first pjd_det
            fields(pjd_nbr     pjd_sub_nbr  pjd_site
                   pjd_slspsn  pjd_comm_pct pjd_prepaid pjd_prep_tax)
            where pjd_nbr     = ins_prj_nbr
            and   pjd_sub_nbr = ins_sub_nbr
         no-lock:
            for first si_mstr
               fields(si_entity si_site)
               where si_site = pjd_site
            no-lock:
            end. /* FOR FIRST si_mstr */
         end. /* FOR FIRST pjd_det */
      end. /* ELSE DO */

      if available si_mstr
      then
         destentity = si_entity.

      taxable = prj_taxable.
      if taxable
      then
         tax-class = prj_type_taxc.
      {&PJIVGEN5-P-TAG4}

      {gprun.i ""gldydft.p""
         "(input  ""AR"",
           input  ""M"",
           input  destentity,
           output dft-daybook,
           output daybook-desc)"}
      init-daybook = dft-daybook.

      if dft-daybook = ""
      then do:
         {gprun.i ""gldydft.p""
            "(input  ""AR"",
              input  ""M"",
              input  gl_entity,
              output dft-daybook,
              output daybook-desc)"}
         init-daybook = dft-daybook.
      end. /* IF dft-daybook = "" */

      /* CALCULATE TAX AMOUNT PRIOR TO CONTROL AMOUNT */
      assign
         tax-pct = 0
         tax-amt = 0.
      {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
         "(input ins_curr,
           output rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0
      then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         rndmthd = gl_rnd_mthd.
      end. /* IF mc-error-number <> 0 */

      /* GET NEW AR_MEMO NUMBER */
      {mfnctrl.i arc_ctrl arc_memo ar_mstr ar_nbr arnbr}

      /* TO BALANCE THE BATCH THE CONTROL FIELD IS FILLED WITH AMOUNT   */
      bactrl = ins_inv_amt + tax-amt.

      /* USE GPGETBAT TO GET THE NEXT BATCH    */
      /* AND CREATE THE BATCH MASTER (BA_MSTR) */
      {gprun.i ""gpgetbat.p""
         "(input  """",
           input  ""AR"",
           input  ""M"",
           input  bactrl,
           output ba_recno,
           output batch)"}

      /* GET BILL INFORMATION */

      for first cm_mstr
         where cm_addr = ins_bill_to
      exclusive-lock:
      end. /* FOR FIRST cm_mstr */

      /* SET EXCHANGE RATE IF NON-BASE CURRENCY */
      if base_curr <> ins_curr
      then do:

         /* GET CURRENT RATE IF EXCHANGE RATE IS NOT FIXED */
         if prj_fix_rate = no
         then do:
            {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
               "(input ins_curr,
                 input base_curr,
                 input exch_ratetype,
                 input ins_sched_date,
                 output exch_rate,
                 output exch_rate2,
                 output exch_seq,
                 output mc-error-number)"}
            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end. /* IF mc-error-number <> 0 */
         end. /* IF prj_fix_rate = no */
         else do:
            /* COPY RATE FROM SCHEDULE IF USING FIXED RATE */
            assign
               exch_rate     =  prj_ex_rate
               exch_rate2    =  prj_ex_rate2
               exch_ratetype =  prj_ex_ratetype.
            {gprunp.i "mcpl" "p" "mc-copy-ex-rate-usage"
               "(input prj_exru_seq,
                 output exch_seq)"}
         end. /* ELSE DO */
      end. /* IF base_curr <> ins_curr */
      else
      assign
         exch_rate     = 1.0
         exch_rate2    = 1.0
         exch_seq      = 0
         exch_ratetype = "".

      /*CREATE COMMENT INDEX */
      if ins_cmtindx <> 0
      then do:
         /* COPY COMMENTS FROM INS_MSTR */
         {gpcmtcpy.i &old_index = ins_cmtindx
                     &new_index = cmtindx
                     &counter   = cnt}
      end. /* IF ins_cmtindx <> 0 */
      else
         cmtindx = 0.

      /* CREATE THE DEBIT/CREDIT PREPAYMENT */
      create ar_mstr.
      assign
         ar_nbr         = arnbr
         ar_type        = "M"
         ar_fsm_type    = "PRM"
         ar_prepayment  = yes
         ar_batch       = batch
         ar_date        = today
         ar_effdate     = ins_sched_date
         ar_tax_date    = ar_effdate
         ar_amt         = 0
         ar_cr_terms    = ins_cr_terms
         ar_so_nbr      = ins_prj_nbr
         ar_open        = yes
         ar_curr        = ins_curr
         ar_entity      = destentity
         ar_po          = substring(ins_rmks,1,22)
         ar_sales_amt   = 0
         ar_ex_rate     = exch_rate
         ar_ex_rate2    = exch_rate2
         ar_ex_ratetype = exch_ratetype
         ar_exru_seq    = exch_seq
         ar__log01      = yes
         ar_cmtindx     = cmtindx
         ar_dy_code     = init-daybook
         ar_tax_env     = prj_tax_env.

      if recid(ar_mstr) = -1  then .
      {&PJIVGEN5-P-TAG5}

      /* GET ROUNDING METHOD */
      if gl_base_curr <> ar_curr
      then do:
         /* GET ROUNDING METHOD FROM CURRENCY MASTER */
         {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
            "(input  ar_curr,
              output rndmthd,
              output mc-error-number)"}
         if mc-error-number <> 0
         then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
            if c-application-mode <> "WEB"
            then
               pause 0.
            undo, retry.
         end. /* IF mc-error-number <> 0 */
      end. /* IF gl_base_curr <> ar_curr */

      /* GET THE SALESPERSON INFORMATION */
      if ins_sub_nbr = 0
      then
         assign
            ar_slspsn[1]   = prj_slspsn[1]
            ar_slspsn[2]   = prj_slspsn[2]
            ar_slspsn[3]   = prj_slspsn[3]
            ar_slspsn[4]   = prj_slspsn[4]
            ar_comm_pct[1] = prj_comm_pct[1]
            ar_comm_pct[2] = prj_comm_pct[2]
            ar_comm_pct[3] = prj_comm_pct[3]
            ar_comm_pct[4] = prj_comm_pct[4].
      else
      if available pjd_det
      then
         assign
            ar_slspsn[1]   = pjd_slspsn[1]
            ar_slspsn[2]   = pjd_slspsn[2]
            ar_slspsn[3]   = pjd_slspsn[3]
            ar_slspsn[4]   = pjd_slspsn[4]
            ar_comm_pct[1] = pjd_comm_pct[1]
            ar_comm_pct[2] = pjd_comm_pct[2]
            ar_comm_pct[3] = pjd_comm_pct[3]
            ar_comm_pct[4] = pjd_comm_pct[4].

      /* GET THE SALES ORDER INFORMATION */
      if available prj_mstr
      then
         assign
            ar_cust = prj_cust
            ar_bill = ins_bill_to
            ar_ship = prj_ship_to
            ar_acct = ins_ar_acct
            ar_sub  = ins_ar_sub
            ar_cc   = ins_ar_cc.

      if ar_disc_date = ?
         and ar_due_date = ?
      then do:
         {&PJIVGEN5-P-TAG7}
         /*CALCULATE CREDIT TERMS */
         {adctrms.i &date         = ar_date
                    &cr_terms     = ar_cr_terms
                    &disc_date    = ar_disc_date
                    &due_date     = ar_due_date}
         {&PJIVGEN5-P-TAG8}
      end. /* IF ar_disc_date  = ? AND ... */

      /* CREATE THE AR DISTRIBUTION LINE           */
      /* FOR PREPAYMENT ONLY - TAX LINE MADE AFTER */
      create ard_det.
      assign
         ard_nbr       = ar_nbr
         ard_acct      = if available ivs_ctrl
                         then
                            ivs_prep_acct
                         else
                            ard_acct
         ard_sub       = if available ivs_ctrl
                         then
                            ivs_prep_sub
                         else
                            ard_sub
         ard_cc        = if available ivs_ctrl
                         then
                            ivs_prep_cc
                         else
                            ard_cc
         ard_entity    = destentity
         ard_project   = prj_nbr
         ard_type      = ""
         ard_amt       = ins_inv_amt
         ard_taxc      = prj_type_taxc
         ard_tax_usage = prj_tax_usage
         ard_tax_at    = if taxable
                         then
                            "Yes"
                         else
                            ard_tax_at.
      if recid(ard_det) = -1
      then .

      /* RETRIEVE DISTRIBUTION LINE DESCRIPTION */
      for first ac_mstr
         fields(ac_code ac_desc)
         where ac_code = ard_acct
      no-lock:
         ard_desc = ac_desc.
      end. /* FOR FIRST ac_mstr */

      /* SAVE THE DB/CR MEMO FOR SUB-ROUTINES */
      /* UPDATE THE GL TRANSACTION FILE       */
      assign
         ar_recno = recid(ar_mstr)
         base_amt = ard_amt
         curr_amt = ard_amt.

      if base_curr <> ins_curr
      then do:
         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input ar_curr,
              input base_curr,
              input ar_ex_rate,
              input ar_ex_rate2,
              input base_amt,
              input true, /* ROUND */
              output base_amt,
              output mc-error-number)"}
         if mc-error-number <> 0
         then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end. /* IF mc-error-number <> 0 */
      end. /* IF base_curr <> ins_curr */

      /* UPDATE MEMO TOTAL ar_amt */
      assign
         base_det_amt = base_amt
         ard_recno    = recid(ard_det)
         undo_all     = yes
         ar_amt       = ar_amt + ard_amt.
      if ar_curr <> gl_base_curr
      then do:
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input ar_curr,
              input base_curr,
              input ar_ex_rate,
              input ar_ex_rate2,
              input ar_amt,
              input true,  /* ROUND */
              output ar_base_amt,
              output mc-error-number)"}
         if mc-error-number <> 0
         then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end. /* IF mc-error-number <> 0 */
      end. /* IF ar_curr <> gl_base_curr */

      {gprun.i ""arargl.p""}

      if undo_all
      then
         undo, leave.

      /* CREATE TAX LINE FOR ARD_DET */
      if taxable
      then do:
         /* CALCULATE GTM */
         assign
            tax_tr_type = "18"    /* 18 = DR/CR MEMO */
            tax_nbr     = prj_nbr
            tax_lines   =  0.     /* 0 = ALL LINES */

         {gprun.i ""txcalc.p""
            "(input  tax_tr_type,
              input  ar_nbr,
              input  tax_nbr,
              input  tax_lines,
              input  no /* NO POSTING */,
              output result-status)"}

         /* ASSIGN TAX-AMT */
         for each tx2d_det
            fields(tx2d_cur_tax_amt tx2d_nbr
                   tx2d_ref         tx2d_tr_type)
            where tx2d_ref     = ar_nbr
            and   tx2d_nbr     = ins_prj_nbr
            and   tx2d_tr_type = "18" /* 18 = DR/CR MEMO */
         no-lock:
            tax-amt = tax-amt + tx2d_cur_tax_amt.
         end. /* FOR EACH tx2d_det */

         create ard_det.
         assign
            ard_nbr    = ar_nbr
            ard_acct   = if available ivs_ctrl
                         then
                            ivs_ptax_acct
                         else
                            ard_acct
            ard_sub    = if available ivs_ctrl
                         then
                            ivs_ptax_sub
                         else
                            ard_sub
            ard_cc     = if available ivs_ctrl
                         then
                            ivs_ptax_cc
                         else
                            ard_cc
            ard_entity  = destentity
            ard_project = prj_nbr
            ard_type    = ""
            ard_amt     = tax-amt
            ard_tax     = tax-class
            ard_tax_at  = "N".
         if recid(ard_det) = -1
         then .

         run create-tax-trans.
         if undo_all
         then
            undo, leave.
      end. /* IF taxable */

      /* UPDATE THE BATCH INFORMATION */
      for first ba_mstr
         where ba_batch  = batch
         and   ba_module = "AR"
      exclusive-lock:
         assign
            ba_total  = ar_amt
            ba_status = "".
      end. /* FOR FIRST ba_mstr */

      /* UPDATE PROJECT PREPAYMENT & INVOICE SCHEDULE FIELDS  */
      if ins_sub_nbr = 0
      then do:
         prj_prepaid = prj_prepaid + ins_inv_amt.
         if taxable
         then
            prj_prep_tax = prj_prep_tax + tax-amt.
      end. /* IF ins_sub_nbr = 0 */
      else do:
         for first pjd_det
            where pjd_nbr     = ins_prj_nbr
            and   pjd_sub_nbr = ins_sub_nbr
         exclusive-lock:
            pjd_prepaid = pjd_prepaid + ins_inv_amt.
            if taxable
            then
               pjd_prep_tax = pjd_prep_tax + tax-amt.
         end. /* FOR FIRST pjd_det */
      end. /* ELSE DO */

      assign
         ins_inv_nbr  = ar_nbr
         ins_release  = no
         ins_mod_date = today.

      if available cm_mstr
      then
         cm_balance = cm_balance + ar_base_amt.

      /* DR/CR MEMO # HAS BEEN GENERATED */
      {pxmsg.i &MSGNUM=8626 &ERRORLEVEL=1 &MSGARG1=ar_nbr}
      pause.

   end. /* FOR FIRST PRJ_MSTR  */
end. /* FOR FIRST GL_CTRL */

/* BEGIN CODE MOVED FROM ABOVE AND MODIFIED */
PROCEDURE create-tax-trans:

   /* RETRIEVE DISTRIBUTION LINE DESCRIPTION */
   for first ac_mstr
      fields(ac_code ac_desc)
      where ac_code = ard_det.ard_acct
   no-lock:
      ard_desc = ac_desc.
   end. /* FOR FIRST ac_mstr */

   /* UPDATE THE GL TRANSACTION FILE */
   assign
      ard_recno = recid(ard_det)
      base_amt  = ard_amt
      curr_amt  = ard_amt.

   if base_curr <> ins_mstr.ins_curr
   then do:
      /* CONVERT FROM FOREIGN TO BASE CURRENCY */
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input ar_mstr.ar_curr,
           input base_curr,
           input ar_ex_rate,
           input ar_ex_rate2,
           input base_amt,
           input true, /* ROUND */
           output base_amt,
           output mc-error-number)"}
      if mc-error-number <> 0
      then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end. /* IF mc-error-number <> 0 */
   end. /* IF base_curr <> ins_mstr.ins_curr */
   assign
      base_det_amt = base_amt
      ard_recno    = recid(ard_det)
      undo_all     = yes.

   /* UPDATE MEMO TOTAL */
   ar_amt = ar_amt + ard_amt.
   if ar_curr <> gl_ctrl.gl_base_curr
   then do:
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input ar_curr,
           input base_curr,
           input ar_ex_rate,
           input ar_ex_rate2,
           input ar_amt,
           input true,  /* ROUND */
           output ar_base_amt,
           output mc-error-number)"}
      if mc-error-number <> 0
      then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end. /* IF mc-error-number <> 0 */
   end. /* IF ar_curr <> gl_ctrl.gl_base_curr */

   {gprun.i ""arargl.p""}

   if undo_all
   then
      undo, leave.
END PROCEDURE. /* PROCEDURE create-tax-trans */
{&PJIVGEN5-P-TAG6}
