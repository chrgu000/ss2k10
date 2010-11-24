/* wowomta1.p - WORK ORDER MAINTENANCE SUBROUTINE                             */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.17 $                                                               */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 6.0      LAST MODIFIED: 05/02/90    BY: mlb *D024*               */
/* REVISION: 6.0      LAST MODIFIED: 06/26/90    BY: emb *D024*               */
/* REVISION: 6.0      LAST MODIFIED: 07/06/90    BY: emb *D040*               */
/* REVISION: 6.0      LAST MODIFIED: 11/02/90    BY: emb *D172*               */
/* REVISION: 6.0      LAST MODIFIED: 02/08/91    BY: emb *D340*               */
/* REVISION: 6.0      LAST MODIFIED: 02/19/91    BY: emb *D342*               */
/* REVISION: 6.0      LAST MODIFIED: 03/04/91    BY: emb *D395*               */
/* REVISION: 6.0      LAST MODIFIED: 03/14/91    BY: emb *D413*               */
/* REVISION: 6.0      LAST MODIFIED: 05/01/91    BY: emb *D609*               */
/* REVISION: 6.0      LAST MODIFIED: 07/02/91    BY: emb *D741*               */
/* REVISION: 7.0      LAST MODIFIED: 09/04/91    BY: pma *F003*               */
/* REVISION: 7.0      LAST MODIFIED: 10/11/91    BY: emb *F024*               */
/* REVISION: 7.0      LAST MODIFIED: 09/14/92    BY: emb *F892*               */
/* REVISION: 7.3      LAST MODIFIED: 10/19/92    BY: emb *G208*               */
/* REVISION: 7.3      LAST MODIFIED: 10/21/92    BY: emb *G220*               */
/* REVISION: 7.3      LAST MODIFIED: 09/27/93    BY: jcd *G247*               */
/* REVISION: 7.3      LAST MODIFIED: 12/31/92    BY: pma *G382*               */
/* REVISION: 7.3      LAST MODIFIED: 02/09/93    BY: emb *G656*               */
/* REVISION: 7.3      LAST MODIFIED: 03/25/93    BY: emb *G870*               */
/* REVISION: 7.3      LAST MODIFIED: 04/22/93    BY: ram *G995*               */
/* REVISION: 7.3      LAST MODIFIED: 01/27/94    BY: pma *FL71*               */
/* REVISION: 7.2      LAST MODIFIED: 03/18/94    BY: ais *FM19*               */
/* REVISION: 7.2      LAST MODIFIED: 04/25/94    BY: ais *FN55*               */
/* REVISION: 7.2      LAST MODIFIED: 06/21/94    BY: pxd *FO90*               */
/* REVISION: 7.2      LAST MODIFIED: 07/30/94    BY: qzl *FP72*               */
/* REVISION: 7.2      LAST MODIFIED: 09/01/94    BY: ljm *FQ67*               */
/* REVISION: 7.2      LAST MODIFIED: 09/22/94    BY: qzl *FR72*               */
/* REVISION: 7.2      LAST MODIFIED: 10/10/94    BY: pxd *FR91*               */
/* REVISION: 7.2      LAST MODIFIED: 11/01/94    BY: ais *FT19*               */
/* REVISION: 7.2      LAST MODIFIED: 11/18/94    BY: qzl *FT74*               */
/* REVISION: 7.2      LAST MODIFIED: 12/06/94    BY: emb *FU13*               */
/* REVISION: 7.2      LAST MODIFIED: 02/21/94    BY: ais *F0JR*               */
/* REVISION: 8.5      LAST MODIFIED: 06/16/95    BY: rmh *J04R*               */
/* REVISION: 7.2      LAST MODIFIED: 11/09/95    BY: rvw *F0W0*               */
/* REVISION: 7.4      LAST MODIFIED: 01/16/96    BY: jym *G1JF*               */
/* REVISION: 7.4      LAST MODIFIED: 01/16/96    BY: jym *G1LP*               */
/* REVISION: 7.2      LAST MODIFIED: 03/21/96    BY: rvw *F0X4*               */
/* REVISION: 8.5      LAST MODIFIED: 03/06/97    BY: *H0T3* Murli Shastri     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 01/18/99   BY: *N00J* Russ Witt          */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 10/16/00   BY: *N0SX* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 11/06/00   BY: *N0TN* Jean Miller        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.14  BY: Jyoti Thatte       DATE: 04/01/01 ECO: *P008*          */
/* Revision: 1.16  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00N*          */
/* $Revision: 1.17 $    BY: Surajit Roy        DATE: 12/30/04 ECO: *P2QK*          */
/* By: Neil Gao Date: 07/11/26 ECO: * ss 20071126 * */
/*By: Neil Gao 08/04/15 ECO: *SS 20080415* */
/*By: Neil Gao 08/05/08 ECO: *SS 20080508* */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i}

define input parameter part_global  like mfc_logical no-undo.

/* Shared Variables */
define new shared variable eff_date     as date.
define new shared variable wod_recno    as recid.
define new shared variable re-explode   like mfc_logical no-undo.
define new shared variable phantom-loop like mfc_logical
                                        initial yes no-undo.
define new shared variable first-loop   like mfc_logical
                                        initial yes no-undo.
define new shared variable qty_to_all   like wod_qty_all.
define new shared variable gen_alloc    like wod_qty_all.
define new shared variable site         like ptp_site no-undo.
define new shared variable phantom      like mfc_logical initial no.

define shared variable par_bombatch like bom_batch.
define shared variable prev_site    like wo_site.
define shared variable undo_all     like mfc_logical no-undo.
define shared variable comp         like ps_comp.
define shared variable qty          like wo_qty_ord decimals 10.
define shared variable wo_recno     as recid.
define shared variable leadtime     like pt_mfg_lead.
define shared variable prev_status  like wo_status.
define shared variable prev_release like wo_rel_date.
define shared variable prev_due     like wo_due_date.
define shared variable prev_qty     like wo_qty_ord.
define shared variable del-yn       like mfc_logical.
define shared variable deliv        like wod_deliver.
define shared variable any_issued   like mfc_logical.
define shared variable use_op_yield as logical no-undo.

/* DEFINE VARIABLES FOR BILL OF MATERIAL EXPLOSION */
{gpxpld01.i "new shared"}

/* Local Variables */
define variable assy_qty like wo_qty_ord.
define variable save_wo_recno as recid.
define variable save_prev_status like wo_status.
define variable save_prev_release like wo_rel_date.
define variable save_prev_due like wo_due_date.
define variable save_prev_qty like wo_qty_ord.
define variable i as integer.
define variable nonwdays as integer.
define variable workdays as integer.
define variable overlap as integer.
define variable know_date as date.
define variable find_date as date.
define variable interval as integer.
define variable frwrd as integer.
define variable lt_off like ps_lt_off.
define variable open_ref like mrp_qty.
define variable in_recno as recid.
define variable oldwod_qty_req like wod_qty_req.
define variable bomqty like wod_bom_qty.
define variable yield_pct like wo_yield_pct no-undo.

/* Workfiles, Temp Tables */
define new shared workfile pkdet no-undo
   field pkpart like pk_part
   field pkop as integer
   field pkstart like pk_start
   field pkend like pk_end
   field pkqty like pk_qty
   field pkltoff like ps_lt_off.

define workfile wf-wod-recid no-undo
   field wod-det-recid as recid.

define shared temp-table tt-routing-yields no-undo
   field tt-op         like ro_op
   field tt-yield-pct  like ro_yield_pct
   index tt-op is primary
   tt-op.

/* Buffers */
define buffer womstr for wo_mstr.
define buffer woddet for wod_det.

find wo_mstr where recid(wo_mstr) = wo_recno no-lock.

assign
   eff_date = wo_rel_date.

/*SS 20080415 - B*/
define new shared temp-table xxld_det
	field xxld_vend like po_vend
	field xxld_part like pod_part
	field xxld_sub_part like pod_part
	field xxld_qty  like ld_qty_oh
	field xxld_sub_qty like ld_qty_oh
	field xxld_zd   as char
/*SS 20080508*/ field xxld_flot like ld_lot
	index xxld_part xxld_part.

define var xxqty1 like ld_qty_oh.
define var xxqty2 like ld_qty_oh.
define buffer s1 for xxld_det.

/*SS 20080508 - B*/
define var xxflot like ld_lot.
/*SS 20080508 - E*/

empty temp-table xxld_det.

/*SS 20080508*/ xxflot = "zzz".
for each wod_det where wod_domain = global_domain and wod_lot = wo_Lot no-lock:
	xxqty1 = 0.
	for each ld_det where ld_domain = global_domain and ld_part = wod_part and ld_site = wod_site
		and ld_status begins "Y"	and ld_qty_oh > 0 and substring(ld_lot,7) <> ""  no-lock 
		break by substring(ld_lot,7) : 
		xxqty1 = xxqty1 + ld_qty_oh - ld_qty_all.
/*SS 20080508*/	if xxflot > ld_lot then xxflot = ld_lot.
		if last-of( substring(ld_lot,7) ) then do:
			create xxld_det.
			assign xxld_vend = substring(ld_lot,7)
						 xxld_part = ld_part
						 xxld_qty  = xxqty1
						 xxld_zd   = "2"
/*SS 20080508*/ xxld_flot = xxflot						 
						 .
/*SS 20080508*/ xxflot = "zzz".
			find first xxsob_det where xxsob_domain = global_domain and xxsob_part = ld_part 
				and xxsob_user1 = xxld_vend no-lock no-error.
			if avail xxsob_det then	xxld_zd = "3".
			xxqty1 = 0.
		end.
	end.
end.

for each xxld_det ,
  first xxpts_det where xxpts_domain = global_domain and xxld_part begins xxpts_part no-lock,
  each S1 where S1.xxld_part begins xxpts_sub_part and S1.xxld_vend = xxld_det.xxld_vend :
  	
	if S1.xxld_zd = "3" or xxld_det.xxld_zd = "3" then do:
		S1.xxld_zd = "1".
		xxld_det.xxld_zd = "1".
	end.
	else do:
		S1.xxld_zd = "0".
		xxld_det.xxld_zd = "0".
	end.
	S1.xxld_sub_qty = min(S1.xxld_qty,xxld_det.xxld_qty).
	xxld_det.xxld_sub_qty = S1.xxld_sub_qty.
	/*message S1.xxld_sub_qty xxld_det.xxld_vend S1.xxld_qty xxld_det.xxld_qty. pause.*/
end.

/*SS 20080415 - E*/

alloc-loop:
do while true:

   if index("PBFCEAR",wo_status) >= index("PBFCEAR",prev_status) and
      index("EAR",wo_status) > 0
   then do:

      /* MOVED SECTION TO WOWOMTA2 DUE TO R-CODE CONSTRAINT */
/* ss 20071127 - b */
/*
      {gprun.i ""wowomta2.p""}
*/
      {gprun.i ""xxwowomta2.p""}
/* ss 20071127 - e */
      if undo_all = yes then
         leave alloc-loop.

   end.

   if index("AR",wo_status) = 0 then
      leave.

   assign
      re-explode = no.

   if first-loop or phantom-loop then
      re-explode = yes.

   first-loop = no.
   if not phantom-loop then
      leave.
   phantom-loop = no.

   find first wod_det  where wod_det.wod_domain = global_domain and  wod_lot =
   wo_lot no-lock no-error.

   repeat:

      if not available wod_det then
         leave.

      for each wod_det  where wod_det.wod_domain = global_domain and  wod_lot =
      wo_lot no-lock:
         find first wf-wod-recid where wod-det-recid = recid(wod_det)
         no-error.
         if not available wf-wod-recid then do:
            create wf-wod-recid.
            wod-det-recid = recid(wod_det).
         end.
      end. /* FOR EACH WOD_DET */

      /* PHANTOM USE-UP LOGIC TO THOSE PHANTOMS */
      for each wf-wod-recid:

         find wod_det where recid(wod_det) = wod-det-recid no-lock.

         find qad_wkfl  where qad_wkfl.qad_domain = global_domain and
              qad_key1 = "MFWORLA" and
              qad_key2 = wod_lot + wod_part + string(wod_op)
         no-error.

         if available qad_wkfl and qad_decfld[2] <> 0 then
            par_bombatch = qad_decfld[2].
         else
            par_bombatch = 1.

         find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
         wod_part no-lock no-error.

         wod_recno = recid(wod_det).

         find ptp_det  where ptp_det.ptp_domain = global_domain and
              ptp_part = wod_part and
              ptp_site = wod_site
         no-lock no-error.

         find in_mstr  where in_mstr.in_domain = global_domain and
              in_part = wod_part and
              in_site = wod_site
         no-lock no-error.
         in_recno = recid(in_mstr).

         if ((available ptp_det and ptp_phantom) or
            (not available ptp_det and available pt_mstr and pt_phantom))
            and (wod_qty_req - wod_qty_all - wod_qty_pick - wod_qty_iss <> 0)
            and not (wo_type = "R" and wod_part = wo_part)
         then do transaction:

            comp = wod_part.

            if available ptp_det and ptp_bom_code <> "" then
               comp = ptp_bom_code.

            if not available ptp_det and
               available pt_mstr and pt_bom_code <> "" then
               comp = pt_bom_code.

            site = wod_site.

            {mfwday.i prev_release wod_iss_date lt_off wod_site}

            if wod_iss_date < prev_release then
               lt_off = lt_off * -1.

            if available ptp_det then
               lt_off = lt_off - ptp_mfg_lead.
            if not available ptp_det and available pt_mstr then
               lt_off = lt_off - pt_mfg_lead.

            qty = wod_qty_req - wod_qty_all - wod_qty_pick - wod_qty_iss.
            if wod_qty_req >= 0 then
               qty = max(qty,0).
            else
               qty = min(qty,0).

            if qty <> 0 then do:

               assign
                  bomqty = wod_bom_qty
                  assy_qty = qty.

               {gprun.i ""woworla.p""}

               /* CODE AS THE PHANTOM. */
               for each pkdet:
                  pkop = wod_op.
               end.

               find first pkdet no-lock no-error.

               if available pkdet then do:

                  find wod_det where recid(wod_det) = wod_recno
                  exclusive-lock.

                  find qad_wkfl  where qad_wkfl.qad_domain = global_domain and
                       qad_key1 = "MFWORLA" and
                       qad_key2 = wod_lot + wod_part + string(wod_op)
                  no-error.

                  if available qad_wkfl then do:
                     if wod_qty_req <> 0 then
                        qad_decfld[1] =
                           (wod_qty_req - qty) * par_bombatch / wo_qty_ord.
                     else
                        qad_decfld[1] = 0.
                  end.
                  else do:
                     if wod_qty_req <> 0 then
                        wod_bom_qty =
                           (wod_bom_qty * (wod_qty_req - qty)) / wod_qty_req.
                     else
                        wod_bom_qty = 0.
                  end.

                  assign
                     wod_qty_req = wod_qty_req - qty
                     wod_bom_qty = wod_qty_req / wo_qty_ord.

                  find in_mstr where recid(in_mstr) = in_recno
                  exclusive-lock no-error.

                  if available in_mstr then
                     in_qty_req = in_qty_req - qty.

                  if wod_qty_req >= 0 then
                     open_ref = max(wod_qty_req - wod_qty_iss,0).
                  else
                     open_ref = min(wod_qty_req - wod_qty_iss,0).

                  {mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot """"}

                  {mfmrw.i "wod_det" wod_part wod_nbr wod_lot
                     string(wod_op) ? wod_iss_date open_ref "DEMAND"
                     WORK_ORDER_COMPONENT wod_site}

                  {gprun.i ""womsup.p"" "(wod_part,wod_site,qty)"}

                  {mfworla.i "nodelete"}

                  re-explode = yes.

                  find pt_mstr  where pt_mstr.pt_domain = global_domain and
                  pt_part = wod_part
                  no-lock no-error.

                  find ptp_det  where ptp_det.ptp_domain = global_domain and
                       ptp_part = wod_part and
                       ptp_site = wod_site
                  no-lock no-error.

               end.     /* AVAIL PK_DET */

            end.        /* QTY <> 0     */

         end.           /* TRANSACTION  */

      end. /* FOR EACH wf-wod-recid */

      next alloc-loop.

      find wod_det no-lock where recid(wod_det) = wod_recno.

      find next wod_det  where wod_det.wod_domain = global_domain and  wod_lot
      = wo_mstr.wo_lot no-lock no-error.

   end.

   if re-explode = no then
      leave alloc-loop.

end. /* ALLOC-LOOP */

/* RE-INITIALISING part_global AFTER PICKLIST PRINTING FINISHED FOR     */
/* WORK ORDER THAT INVOLVES ITEM HAVING A GLOBAL PHANTOM IN ITS PRODUCT */
/* STRUCTURE                                                            */

   part_global = no.

/* THIS SECTION IS FOR TAKING A WORK ORDER THAT DOESN'T YET HAVE ANY */
/* ALLOCATIONS AGAINST IT AND RESTORING IT TO THE PRE-EXISTING STATE */
/* OF NO ALLOCATIONS IF A CRITICAL ITEM PREVENTS THE WORK ORDER FROM */
/* BEING RELEASED AND DETAIL ALLOCATED.                              */
if undo_all and wo_status = "R" and index("PFBE",prev_status) > 0
then do:

   for each wod_det  where wod_det.wod_domain = global_domain and
            wod_lot = wo_lot
        and wod_qty_all <> 0
   exclusive-lock:

      /* DECREASE THE IN_MSTR ALLOCATED QTY */
      find in_mstr  where in_mstr.in_domain = global_domain and
           in_part = wod_part and
           in_site = wod_site
      exclusive-lock no-error.

      if available in_mstr then
         in_qty_all = in_qty_all - wod_qty_all.

      /* DELETE THE LAD_DET RECORD(S) (DETAIL ALLOCATIONS) */
      for each lad_det  where lad_det.lad_domain = global_domain and
               lad_dataset = "wod_det"
           and lad_nbr     = wod_lot
           and lad_line    = string(wod_op)
           and lad_part    = wod_part
      exclusive-lock:

         find ld_det  where ld_det.ld_domain = global_domain and
              ld_part = lad_part and
              ld_site = lad_site and
              ld_loc  = lad_loc  and
              ld_lot  = lad_lot  and
              ld_ref  = lad_ref
         exclusive-lock no-error.

         if available ld_det then
            ld_qty_all = ld_qty_all - lad_qty_all.

         delete lad_det.

      end. /* FOR EACH lad_det */

      /* RESTORE THE WOD_QTY_ALL TO 0 IF PREVIOUS WOD_STATUS <> "A" */
      wod_qty_all = 0.

   end. /* FOR EACH wod_det */

end. /* IF INDEX .... THEN DO */

/* NOTE: IF THE WORK ORDER ALREADY HAS DETAIL ALLOCATIONS (MEANING      */
/* IT'S AT STATUS "R") AND WE TRY TO RE-RELEASE IT, WE HAVE NO WAY      */
/* OF KNOWING WHAT DETAIL ALLOCATIONS WERE CREATED FROM WHICH RELEASE   */
/* SO WE LEAVE THEM ALL OUT THERE. SINCE THE WORK ORDER IS LEFT AT      */
/* STATUS "R", WE WON'T HAVE THE PROBLEM OF ALLOCATIONS BEING STRANDED. */

if wo_status = "A" or wo_status = "R" then
for each wod_det  where wod_det.wod_domain = global_domain and  wod_lot = wo_lot
                   and wod_part <> wo_part
no-lock:

   find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
   wod_part no-lock no-error.
   find ptp_det  where ptp_det.ptp_domain = global_domain and  ptp_part =
   wod_part
                  and ptp_site = wod_site
   no-lock no-error.

   if ((available ptp_det and ptp_pm_code = "R")
      or (not available ptp_det and available pt_mstr
      and pt_pm_code = "R")) and
      wod_qty_req - wod_qty_all - wod_qty_pick - wod_qty_iss <> 0
   then do:

      wod_recno = recid(wod_det).

      find in_mstr  where in_mstr.in_domain = global_domain and  in_part =
      wod_part
                     and in_site = wod_site
      no-lock no-error.

      in_recno = recid(in_mstr).

      do transaction:

         qty = wod_qty_req - wod_qty_all - wod_qty_pick - wod_qty_iss.

         if wod_qty_req >= 0 then
            qty = max(qty,0).
         else
            qty = min(qty,0).

         if qty <> 0 then do:
            {gprun.i ""wowomta3.p""}
            find wo_mstr no-lock where recid(wo_mstr) = wo_recno.
         end.

      end.

   end.

end.
