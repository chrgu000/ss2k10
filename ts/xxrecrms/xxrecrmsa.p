/* recrmsa.p - Validate Repetitive Schedule Against Sequence File       */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */

/* REVISION: 7.3      LAST MODIFIED 08/06/93    BY: emb       *GE01*    */
/* REVISION: 7.4      LAST MODIFIED: 08/26/97   BY: *H1D9* Manmohan Pardesi  */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 07/25/00   BY: *N0GD* Ganga Subramanian */
/* REVISION: 9.1      LAST MODIFIED: 11/08/00   BY: *N0TN* Jean Miller       */
/* $Revision: 1.7.1.4 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/*-Revision end---------------------------------------------------------------*/


/*H1D9*/ {mfdeclre.i}
/*N0GD*/ {gplabel.i}

/* ********** Begin Translatable Strings Definitions ********* */

/*N0GD* &SCOPED-DEFINE recrmsa_p_1 "Repetitive Schedule" */
/*N0GD* /* MaxLen: Comment: */ */

/* ********** End Translatable Strings Definitions ********* */


         define input parameter site like rps_site.
         define input parameter site1 like rps_site.
         define input parameter line  like rps_line.
         define input parameter line1 like rps_line.
         define input parameter part  like rps_part.
         define input parameter part1 like rps_part.
         define input parameter due   like rps_due_date.
         define input parameter due1  like rps_due_date.
/*mage*/         define input parameter ptplan  like pt_buyer.

         define input parameter update-rps like mfc_logical.

         define variable rpsnbr like mrp_nbr.
         define variable i as integer no-undo.
/*H1D9*/ define variable rps_recno as recid no-undo.
         define buffer rpsmstr for rps_mstr.

         define new shared variable prev_qty like wo_qty_chg.
         define new shared variable prev_status like wo_status.
         define new shared variable wo_recno as recid.

         define shared workfile rp like rps_mstr.
/*N0TN* /*N0GD*/ define variable msg1 as character format "x(22)" no-undo.*/

/*H1D9** {mfdeclre.i} */

/*N0TN* /*N0GD*/ msg1 = getTermLabel("REPETITIVE_SCHEDULE",22). */

         do for rp:
{mfdel.i rp " where rp.rps_domain = global_domain"}
         end.

         for each rps_mstr no-lock
          where rps_mstr.rps_domain = global_domain and  (rps_site >= site and
          rps_site <= site1)
         and (rps_line >= line and rps_line <= line1)
         and (rps_due_date >= due and rps_due_date <= due1)
         and (rps_part >= part and rps_part <= part1),
	 each pt_mstr no-lock where pt_domain = global_domain and pt_part = rps_part
	  and pt_buyer = ptplan:

/*H1D9*/    rps_recno = recid(rps_mstr).

            /* if line is not sequenced then do not update schedule */
            find first lnd_det no-lock  where lnd_det.lnd_domain =
            global_domain and (  lnd_line = rps_line
            and lnd_site = rps_site
            and lnd_part = rps_part
            and (lnd_start <= rps_due_date or lnd_start = ?)
            and (lnd_expire >= rps_due_date or lnd_expire = ?)
            ) no-error.
            if not available lnd_det then next.

            find seq_mstr no-lock  where seq_mstr.seq_domain = global_domain
            and  seq_site = rps_site
            and seq_line = rps_line
            and seq_part = rps_part
            and seq_due_date = rps_due_date no-error.

            if not available seq_mstr
            then do:

               do for rp:
                  create rp. rp.rps_domain = global_domain.
                  assign
                     rp.rps_site = rps_mstr.rps_site
                     rp.rps_line = rps_mstr.rps_line
                     rp.rps_part = rps_mstr.rps_part
                     rp.rps_rel_date = rps_mstr.rps_rel_date
                     rp.rps_due_date = rps_mstr.rps_due_date
                     rp.rps_qty_req = 0
                     rp.rps_qty_comp = rps_mstr.rps_qty_req.
               end.

               if update-rps then do:
/*H1D9**  MOVED FOLLOWING BELOW TO QUALIFY FIELDS FROM THE rps_mstr TABLE
 *                find wo_mstr no-lock where wo_lot = string(rps_record)
 *                and wo_part = rps_part
 *                and wo_type = "S"
 *                and wo_line = rps_line
 *                and wo_site = rps_site no-error.
 *                if available wo_mstr then do:
 *                   /* delete work order, wod_det, wr_route */
 *                   wo_recno = recid(wo_mstr).
 *                   prev_status = wo_status.
 *                   prev_qty = wo_qty_ord.
 *
 *                   {gprun.i ""wowomtd.p""}
 *                end.
 *
 *                {dateconv.i rps_due_date rpsnbr}
 *
 *                rpsnbr = rpsnbr + rps_site.
 *
 *                {mfmrw.i "rps_mstr" rps_part rpsnbr string(rps_record)
 *                 """" rps_rel_date rps_due_date 0
 *                 "SUPPLYF" "Repetitive Schedule" rps_site}
 *
 *                find first rpsmstr exclusive where
 *                rpsmstr.rps_site = rps_mstr.rps_site
 *                and rpsmstr.rps_line = rps_mstr.rps_line
 *                and rpsmstr.rps_part = rps_mstr.rps_part
 *                and rpsmstr.rps_due_date = rps_mstr.rps_due_date
 *                no-error.
 *
 *                if available rpsmstr then delete rps_mstr.
 *H1D9*  END OF MOVED SECTION */
/*H1D9*  BEGIN ADD SECTION */
/* MADE CHANGES TO LOCK rps_mstr EXCLUSIVELY PRIOR TO LOCKING mrp_det */
/* TO PREVENT DEADLOCK WITH THE SHEDULE MAINTENANCE FUNCTION. ALSO IT */
/* WAS NEEDED TO QUALIFY THE FIELDS FROM rps_mstr TABLE.              */
                  find rpsmstr where recid(rpsmstr) = rps_recno
                  exclusive-lock no-error.

                  find wo_mstr no-lock  where wo_mstr.wo_domain = global_domain
                  and
                  wo_lot = string(rpsmstr.rps_record)
                  and wo_part = rpsmstr.rps_part
                  and wo_type = "S"
                  and wo_line = rpsmstr.rps_line
                  and wo_site = rpsmstr.rps_site no-error.
                  if available wo_mstr then do:
                     /* delete work order, wod_det, wr_route */
                     wo_recno = recid(wo_mstr).
                     prev_status = wo_status.
                     prev_qty = wo_qty_ord.

                     {gprun.i ""wowomtd.p""}
                  end.

                  {dateconv.i rpsmstr.rps_due_date rpsnbr}

                  rpsnbr = rpsnbr + rpsmstr.rps_site.

/*N0GD*           {mfmrw.i "rps_mstr" rpsmstr.rps_part rpsnbr
 *                  string(rpsmstr.rps_record)
 *                  """" rpsmstr.rps_rel_date rpsmstr.rps_due_date 0
 *                  "SUPPLYF"
 *                {&recrmsa_p_1}
 *                rpsmstr.rps_site} */

/*N0TN*/        /* Replace msg1 with a Term */
/*N0GD*/        {mfmrw.i "rps_mstr" rpsmstr.rps_part rpsnbr
                   string(rpsmstr.rps_record)
                   """" rpsmstr.rps_rel_date rpsmstr.rps_due_date 0
                   "SUPPLYF"
                   REPETITIVE_SCHEDULE
                   rpsmstr.rps_site}


                  if available rpsmstr then delete rpsmstr.
/*H1D9*  END ADD SECTION */
               end.
            end.
         end.
