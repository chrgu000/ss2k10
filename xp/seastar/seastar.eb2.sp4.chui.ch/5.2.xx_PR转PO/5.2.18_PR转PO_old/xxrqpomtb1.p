/* rqpomtb1.p - PURCHASE ORDER MAINTENANCE -- ORDER HEADER subroutine       */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                       */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                     */
/* REVISION: 8.5      LAST MODIFIED: 04/15/97   BY: *J1Q2* Patrick Rowan    */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L040* Brenda Milton    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KP* myb                */


/*!
 ----------------------------------------------------------------------------
 DESCRIPTION: ADDS/MODS/DELETES horizontal requisition approvers.
              Supports the multi-line Purchase Requisition Module of MFG/PRO.

 Notes:
 1) Similar to popomtb1.p, except frame a is not shared.  PO Build, rqpobld.p
    uses frame a for reporting, and mfselprt does not like frame a to be
    a shared frame.
 ============================================================================
 !*/

     {mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE rqpomtb1_p_1 "Ln Disc"
/* MaxLen: Comment: */

&SCOPED-DEFINE rqpomtb1_p_2 "Comments"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         define shared variable po_recno as recid.
         define shared variable ponbr like po_nbr.
         define shared variable new_po like mfc_logical.
         define shared variable so_job like pod_so_job.
         define shared variable disc like pod_disc label {&rqpomtb1_p_1}.
         define shared variable undo_all like mfc_logical.
         define shared variable pocmmts like mfc_logical label {&rqpomtb1_p_2}.
         define shared frame b.
         define shared variable pocrt_int like pod_crt_int.
         define shared variable impexp   like mfc_logical no-undo.
/*L040*/ define variable mc-error-number like msg_nbr no-undo.

         {popomt02.i}  /* Shared frames a and b */

         undo_all = yes.

         find po_mstr exclusive-lock where recid(po_mstr) = po_recno.

         setb_sub:
         do on error undo, retry:

            /* ALLOW CHG TO EXRATE ON ADD AND MODIFY */
            /* AS LONG AS NO PRH_HIST EXISTS */
            if not can-find(first prh_hist where prh_nbr = po_nbr)
            and po_curr <> base_curr then do:


/*L040*/       if new_po then do:
/*L040*/          {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                    "(input po_curr,
                      input base_curr,
                      input po_ex_ratetype,
                      input po_ord_date,
                      output po_ex_rate,
                      output po_ex_rate2,
                      output po_exru_seq,
                      output mc-error-number)"}
/*L040*/          if mc-error-number <> 0 then do:
/*L040*/             {mfmsg.i mc-error-number 3}
/*L040*/             undo setb_sub, retry.
/*L040*/          end.
/*L040*/       end.


/*
      {gprunp.i "mcui" "p" "mc-ex-rate-input"
                 "(input po_curr,
                   input base_curr,
                   input today,
                   input po_exru_seq,
                   input true,
                   input 12,
                   input-output po_ex_rate,
                   input-output po_ex_rate2,
                   input-output po_fix_rate)"}
*/  /*xp001 marked : no exr input */ 

            end.
            undo_all = no.
         end.  /*setb_sub*/
