/* recrmsb.p - Repetitive Create Master Schedule from Seq File subroutine.    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*F0PN*/ /*V8:ConvertMode=Report                                              */
/* REVISION: 8.5   Created: 05/03/96 from recrms.p section   BY: jzs *H0KR**/
/* REVISION: 8.5      LAST MODIFIED: 12/22/97   BY: *H1HM* Thomas Fernandes */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 11/08/00   BY: *N0TN* Jean Miller        */
/* $Revision: 1.6.2.4 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/


/*N0TN*/ {mfdeclre.i}
/*N0TN*/ {gplabel.i}

/* ********** Begin Translatable Strings Definitions ********* */

/*N0TN* &SCOPED-DEFINE recrmsb_p_1 "Repetitive Schedule" */
/* MaxLen: Comment: */

/*N0TN* &SCOPED-DEFINE recrmsb_p_2 "Work Order Component" */
/* MaxLen: Comment: */

/*N0TN* &SCOPED-DEFINE recrmsb_p_3 "Work Order"  */
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

     define input parameter site like rps_site no-undo.
     define input parameter site1 like rps_site no-undo.
     define input parameter line  like rps_line no-undo.
     define input parameter line1 like rps_line no-undo.
     define input parameter part  like rps_part no-undo.
     define input parameter part1 like rps_part no-undo.
     define input parameter due   like rps_due_date no-undo.
     define input parameter due1  like rps_due_date no-undo.
     /*mage*/         define input parameter ptplan  like pt_buyer no-undo.
     define input parameter update-rps like mfc_logical no-undo.
     define input parameter update-seq like mfc_logical no-undo.

     {mfdatev.i}

/*N0TN* define variable mrp_recno as recid. */   /* Only 2 varables needed */
/*N0TN* define variable recno as recid.     */   /*  from mfdeclre.i */

     define variable rpsrecord like rps_record no-undo.
     define variable rpsnbr like mrp_nbr no-undo.
     define variable leadtime like pt_mfg_lead no-undo.
     define variable default-route like pt_routing no-undo.
     define variable default-bom like pt_bom_code no-undo.

     define buffer seqmstr for seq_mstr.
     define buffer rpsmstr for rps_mstr.

     define shared workfile rp like rps_mstr.

     for each seq_mstr no-lock
       where seq_mstr.seq_domain = global_domain and  (seq_site >= site and
       seq_site <= site1)
      and (seq_line >= line and seq_line <= line1)
      and (seq_part >= part and seq_part <= part1)
      and (seq_due_date >= due and seq_due_date <= due1)
      use-index seq_sequence,
       each pt_mstr no-lock where pt_domain = global_domain and pt_part = seq_part
	  and pt_buyer = ptplan
      break
      by seq_site by seq_line
      by seq_priority by seq_part by seq_due_date:

/*H1HM* THE ln_mstr IS BEING LOCKED EXCLUSIVELY TO PREVENT CONCURRENT ACCESS */
/*H1HM* AND NOT BECAUSE ANY FIELDS ARE BEING MODIFIED.                       */

/*H1HM*/   find ln_mstr  where ln_mstr.ln_domain = global_domain and  ln_line =
seq_line
/*H1HM*/                  and ln_site = seq_site exclusive-lock.

        assign default-route = ""
           default-bom = "".
        find ptp_det no-lock  where ptp_det.ptp_domain = global_domain and
        ptp_part = seq_part
         and ptp_site = seq_site no-error.
        if available ptp_det then do:
           assign default-route = ptp_routing
              default-bom = ptp_bom_code.
        end.
        else do:
           find pt_mstr no-lock  where pt_mstr.pt_domain = global_domain and
           pt_part = seq_part no-error.
           if available pt_mstr then
          assign default-route = pt_routing
               default-bom = pt_bom_code.
        end.

        /*! If line is not sequenced then do not update schedule */
/*H1HM** find first lnd_det no-lock where lnd_line = seq_line    */
/*H1HM*/ find first lnd_det exclusive-lock
/*H1HM*/       where lnd_det.lnd_domain = global_domain and (  lnd_line =
seq_line
                and lnd_site = seq_site
                and lnd_part = seq_part
                and (lnd_start <= seq_due_date or lnd_start = ?)
                and (lnd_expire >= seq_due_date or lnd_expire = ?)
              ) no-error.

        if not available lnd_det then next.

        if update-rps then
           find rps_mstr exclusive-lock
             where rps_mstr.rps_domain = global_domain and  rps_site = seq_site
            and rps_line = seq_line
            and rps_part = seq_part
            and rps_due_date = seq_due_date no-error.
        else
           find rps_mstr no-lock
             where rps_mstr.rps_domain = global_domain and  rps_site = seq_site
            and rps_line = seq_line
            and rps_part = seq_part
            and rps_due_date = seq_due_date no-error.

        do for rp:
           create rp. rp.rps_domain = global_domain.
           assign
          rp.rps_bom_code = default-bom
          rp.rps_routing = default-route
          rp.rps_site = seq_site
          rp.rps_line = seq_line
          rp.rps_part = seq_part
          rp.rps_rel_date = seq_release
          rp.rps_due_date = seq_due_date
          rp.rps_qty_req = seq_qty_req.

           if available rps_mstr then
          assign
             rp.rps_rel_date = rps_mstr.rps_rel_date
             rp.rps_qty_comp = rps_mstr.rps_qty_req.
           else do:
          leadtime = 0.
          find pt_mstr no-lock  where pt_mstr.pt_domain = global_domain and
          pt_part = rps_part no-error.
          if available pt_mstr then leadtime = pt_mfg_lead.
          find ptp_det no-lock  where ptp_det.ptp_domain = global_domain and
          ptp_part = rps_part
           and ptp_site = rps_site no-error.
          if available ptp_det then leadtime = ptp_mfg_lead.
          {mfdate.i rps_rel_date rps_due_date leadtime rps_site}
           end.
        end. /* do for rp */

        if not available rps_mstr and update-rps then do:
           create rps_mstr. rps_mstr.rps_domain = global_domain.
           assign
              rps_bom_code = default-bom
              rps_routing = default-route
          rps_site = seq_site
          rps_line = seq_line
          rps_part = seq_part.
          rps_due_date = seq_due_date.
          rpsrecord = recid(rps_mstr).

           do while can-find
          (rpsmstr  where rpsmstr.rps_domain = global_domain and
          rpsmstr.rps_record = rpsrecord):
             rpsrecord = integer(rpsrecord) + 1.
           end.

           rps_record = rpsrecord.

           leadtime = 0.
           find pt_mstr no-lock  where pt_mstr.pt_domain = global_domain and
           pt_part = rps_part no-error.
           if available pt_mstr then leadtime = pt_mfg_lead.
           find ptp_det no-lock  where ptp_det.ptp_domain = global_domain and
           ptp_part = rps_part
            and ptp_site = rps_site no-error.
           if available ptp_det then leadtime = ptp_mfg_lead.
           {mfdate.i rps_rel_date rps_due_date leadtime rps_site}

        end. /* not available */

        if available rps_mstr and update-rps then do:
           if seq_qty_req <> rps_qty_req or seq_due_date <> rps_due_date
        then do:
          find wo_mstr no-lock  where wo_mstr.wo_domain = global_domain and
          wo_lot = string(rps_record)
           and wo_part = rps_part no-error.

          if available wo_mstr and wo_type = "S" then do:
             for each wod_det  where wod_det.wod_domain = global_domain and
             wod_lot = wo_lot no-lock:
/*N0TN*/    /* Replaced pre-processor with Term */
            {mfmrw.i "wod_det" wod_part wod_nbr wod_lot """"
             ? wod_iss_date 0 "DEMAND"
             WORK_ORDER_COMPONENT wod_site}
             end.
/*N0TN*/     /* Replaced pre-processor with Term */
             {mfmrw.i "wo_mstr" wo_part wo_nbr wo_lot """"
              wo_rel_date wo_due_date 0 "SUPPLYF"
              WORK_ORDER wo_site}
          end.

          {dateconv.i rps_due_date rpsnbr}

          rpsnbr = rpsnbr + rps_site.
          rps_qty_req = seq_qty_req.

/*N0TN*/  /* Replaced pre-processor with Term */
          {mfmrw.i "rps_mstr" rps_part rpsnbr string(rps_record)
              """" rps_rel_date rps_due_date "rps_qty_req"
             "SUPPLYF" REPETITIVE_SCHEDULE rps_site}
           end. /* qty <> rps_qty */

        end. /* available rps_mstr */

        if update-seq then do:
           find seqmstr where recid(seqmstr) = recid(seq_mstr)
            exclusive-lock no-error.
           if available seqmstr then delete seqmstr.
        end.

     end. /* For each */
