/* reupdscf.p - REPETITIVE                                                    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.21 $                                                           */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.3    LAST MODIFIED: 10/31/94 BY: WUG *GN77*                    */
/* REVISION: 7.3    LAST MODIFIED: 03/07/96 BY: jym *G1PZ*                    */
/* REVISION: 7.3    LAST MODIFIED: 03/18/97 BY: *G2LF* Julie Milligan         */
/* REVISION: 8.6    LAST MODIFIED: 02/27/98 BY: *J23R* Santhosh Nair          */
/* REVISION: 9.0    LAST MODIFIED: 04/16/99 BY: *J2DG* Reetu Kapoor           */
/* REVISION: 9.1    LAST MODIFIED: 03/15/99 BY: *N00J* Russ Witt              */
/* REVISION: 9.1    LAST MODIFIED: 10/01/99 BY: *N014* Jeff Wootton           */
/* REVISION: 9.1    LAST MODIFIED: 08/29/00 BY: *N0PN* Mark Brown             */
/* REVISION: 9.1    LAST MODIFIED: 09/22/00 BY: *L0Y1* Kirti Desai            */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.17    BY: Falguni Dalal    DATE: 08/28/01  ECO: *M1JM*         */
/* Revision: 1.19  BY: Irine D'Mello DATE: 09/10/01 ECO: *M164* */
/* $Revision: 1.21 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/*-Revision end---------------------------------------------------------------*/


/* SS - 090622.1  By: Roger Xiao */


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SUBPROGRAM TO UPDATE REPETITIVE SCHEDULE -                                 */
/* UPDATES SCHEDULE WORK ORDER AND SCHEDULE RECORD                            */

{mfdeclre.i}
{pxmaint.i}
{pxphdef.i wocmnrtn}

define input parameter cumwo_lot as character no-undo.
define input parameter qty_comp  as decimal   no-undo.

define new shared buffer gl_ctrl for gl_ctrl.
define new shared variable site          as character.
define new shared variable comp          as character.
define new shared variable wo_recno      as recid.
define new shared variable use_op_yield  as logical no-undo.

define variable item                 as   character    no-undo.
define variable wolot                like wo_lot       no-undo.
define variable line                 as   character    no-undo.
define variable qty_left             as   decimal      no-undo.
define variable open_qty             as   decimal      no-undo.
define variable qty_to_apply         as   decimal      no-undo.
define variable record_count         as   integer      no-undo.
define variable pointer_date         as   date         no-undo.
define variable new_pointer_date     as   date         no-undo.
define variable work_date            as   date         no-undo.
define variable key2                 as   character    no-undo.
define variable proportion_completed as   decimal      no-undo.
define variable yield_pct            like pt_yield_pct no-undo.
define variable v-op                 like ro_op        no-undo.
define variable l_errorno            like mfc_logical  no-undo.

define new shared temp-table tt-routing-yields no-undo
   field tt-routing    like ro_routing
   field tt-op         like ro_op
   field tt-start      like ro_start
   field tt-end        like ro_end
   field tt-yield-pct  like ro_yield_pct
   index tt-routing is unique primary
   tt-routing
   tt-op
   tt-start.

if qty_comp = 0
then
   leave.

for first mrpc_ctrl
   fields( mrpc_domain mrpc_op_yield)
    where mrpc_ctrl.mrpc_domain = global_domain no-lock:
end.

for first wo_mstr
   fields( wo_domain wo_acct wo_sub wo_bom_code wo_cc wo_due_date wo_xvar_acct
           wo_xvar_sub wo_xvar_cc wo_flr_acct wo_flr_sub wo_flr_cc wo_line
           wo_lot wo_mvar_acct wo_mvar_sub wo_mvar_cc wo_mvrr_acct
           wo_mvrr_sub wo_mvrr_cc wo_nbr wo_ord_date wo_part wo_qty_comp
           wo_qty_ord wo_rel_date wo_routing wo_site wo_status wo_svar_acct
           wo_svar_sub wo_svar_cc wo_svrr_acct wo_svrr_sub wo_svrr_cc wo_type
           wo_yield_pct)
    where wo_mstr.wo_domain = global_domain and  wo_lot = cumwo_lot
   no-lock:
end. /* FOR FIRST WO_MSTR */

assign
   item     = wo_part
   site     = wo_site
   line     = wo_line
   qty_left = qty_comp.

/*GET THE DATE OF THE LAST RECORD  WITH  A  COMPLETED  QTY.   THE
PURPOSE OF THIS "POINTER DATE" IS TO REDUCE THE NUMBER OF RECORDS
READ,  WHICH  COULD  OTHERWISE  GET  QUITE  LARGE  IN THE EVENT A
NEGATIVE QUANTITY IS APPLIED TO THE SCHEDULE.  IN  THAT  CASE  WE
WOULD READ FROM THE END OF THE SCHEDULE BACKWARDS.*/

key2 = item + "/" + site + "/" + line + "/".

if not can-find(first qad_wkfl
    where qad_wkfl.qad_domain = global_domain and  qad_key1 = "rps_mstr"
     and qad_key2 = key2)
then do:
   create qad_wkfl. qad_wkfl.qad_domain = global_domain.
   assign
      qad_key1 = "rps_mstr"
      qad_key2 = key2.
end.

for first qad_wkfl
   fields( qad_domain qad_datefld qad_key1 qad_key2)
    where qad_wkfl.qad_domain = global_domain and  qad_key1 = "rps_mstr"
     and qad_key2 = key2
no-lock:
end. /* FOR FIRST qad_wkfl */

if available qad_wkfl
then
   pointer_date = qad_datefld[1].

if qty_comp > 0
then do:
   /*NORMAL QTY PROCESSED.  APPLY FORWARD TO ANY OPEN QUANTITIES.*/

   if pointer_date = ?
   then
      pointer_date = low_date.

   for each wo_mstr
      fields( wo_domain wo_acct wo_sub wo_bom_code wo_cc wo_due_date
      wo_xvar_acct
              wo_xvar_sub wo_xvar_cc wo_flr_acct wo_flr_sub wo_flr_cc wo_line
              wo_lot wo_mvar_acct wo_mvar_sub wo_mvar_cc wo_mvrr_acct
              wo_mvrr_sub wo_mvrr_cc wo_nbr wo_ord_date wo_part wo_qty_comp
              wo_qty_ord wo_rel_date wo_routing wo_site wo_status wo_svar_acct
              wo_svar_sub wo_svar_cc wo_svrr_acct wo_svrr_sub wo_svrr_cc wo_type
              wo_yield_pct)
      no-lock
       where wo_mstr.wo_domain = global_domain and  wo_type      = "s"
        and wo_part      = item
        and wo_site      = site
        and wo_due_date >= pointer_date
        and wo_line      = line
      use-index wo_type_part:

      open_qty = wo_qty_ord - wo_qty_comp.

      if open_qty > 0
      then do:
         qty_to_apply = min(open_qty,qty_left).

         /*UPDATE FINISHED MATERIAL REQS*/
/*mage*/         {gprun.i ""xxreupdscb.p""
            "(input wo_lot, input qty_to_apply)"}

         assign
            new_pointer_date = wo_due_date
            qty_left         = qty_left - qty_to_apply.

         if qty_left = 0
         then
            leave.
      end.
   end.
end.

else do:

   /*NEGATIVE QTY PROCESSED.
   GO BACKWARD AND REMOVE PRIOR QTIES PROCESSED REGISTERED.*/

   if pointer_date = ?
   then
      pointer_date = hi_date.

   /* DRIVE THE REVERSAL BY USING THE RPS_MSTR    */
   /* AS THE SCHEDULED WO_MSTR MAY HAVE BEEN      */
   /* DELETED IF THIS SCHEDULE WAS RE-EXPLOED     */
   /* AFTER A SCHEDULE WO_MSTR WAS FULLY CONSUMED.*/

   for each rps_mstr
      fields( rps_domain rps_bom_code rps_due_date rps_line rps_part
              rps_qty_comp rps_qty_req rps_record rps_rel_date
              rps_routing rps_site)
      no-lock
       where rps_mstr.rps_domain = global_domain and  rps_part      = item
        and rps_site      = site
        and rps_due_date <= pointer_date
        and rps_line      = line
      use-index rps_part
      by rps_part descending
      by rps_site descending
      by rps_line descending
      by rps_due_date descending:

      if rps_qty_comp > 0
      then do:

         qty_to_apply = max(- rps_qty_comp, qty_left).

         /* NOW FIND THE CORRESPONDING WO_MSTR, IF IT DOES NOT EXISTS */
         /* THEN CREATE IT AND THE CORRESPONDING WOD_DET              */

         for first wo_mstr
            fields( wo_domain wo_acct wo_sub wo_bom_code wo_cc wo_due_date
            wo_xvar_acct
                    wo_xvar_sub wo_xvar_cc wo_flr_acct wo_flr_sub wo_flr_cc
                    wo_line wo_lot wo_mvar_acct wo_mvar_sub wo_mvar_cc
                    wo_mvrr_acct wo_mvrr_sub wo_mvrr_cc wo_nbr wo_ord_date
                    wo_part wo_qty_comp wo_qty_ord wo_rel_date wo_routing
                    wo_site wo_status wo_svar_acct wo_svar_sub wo_svar_cc
                    wo_svrr_acct wo_svrr_sub wo_svrr_cc wo_type wo_yield_pct)
             where wo_mstr.wo_domain = global_domain and  wo_part     = rps_part
              and wo_site     = rps_site
              and wo_due_date = rps_due_date
              and wo_lot      = string(rps_record)
              and wo_type     = "s" no-lock:
         end. /* FOR FIRST WO_MSTR */

         if not available wo_mstr
         then do:

            create wo_mstr. wo_mstr.wo_domain = global_domain.
            assign
               wo_lot      = string(rps_record)
               wo_part     = rps_part
               wo_nbr      = rps_part
               wo_type     = "S"
               wo_status   = "E"
               wo_line     = rps_line
               wo_site     = rps_site
               wo_ord_date = today
               wo_rel_date = rps_rel_date
               wo_due_date = rps_due_date
               wo_routing  = if rps_routing <> ""
                             then
                                rps_routing
                             else
                                ""
               wo_bom_code = if rps_bom_code <> ""
                             then
                                rps_bom_code
                             else
                                ""
               wo_qty_ord  = rps_qty_req
               wo_qty_comp = rps_qty_req.

            if recid(wo_mstr) = -1 then .

            /* UPDATE THE WORK ORDER ACCOUNTS */

            for first pt_mstr
               fields( pt_domain pt_part pt_prod_line)
                where pt_mstr.pt_domain = global_domain and  pt_part = rps_part
                no-lock:
            end. /* FOR FIRST PT_MSTR */

            if available pt_mstr
            then do:

               /* DETERMINE YIELD PERCENTAGE TO BE USED */
               yield_pct = 100.
               for first ptp_det
                  fields( ptp_domain ptp_part ptp_site ptp_op_yield ptp_yld_pct)
                  no-lock
                   where ptp_det.ptp_domain = global_domain and  ptp_part =
                   rps_part
                    and ptp_site = rps_site:
               end.

               if available ptp_det
               then
                  assign
                     use_op_yield = ptp_op_yield
                     yield_pct    = ptp_yld_pct.
               else
                  assign
                     use_op_yield = pt_op_yield
                     yield_pct    = pt_yield_pct.

               /* CHECK FOR OPERATION YIELD USE  */
               if available mrpc_ctrl
                  and mrpc_op_yield = yes
                  and use_op_yield  = yes
               then do:

                  /* LOAD TEMP TABLE WITH THIS ITEM'S ROUTING DATA...  */
                  run ip-load-routing-temp-table
                     (input if rps_routing <> ""
                            then
                               rps_routing
                            else
                               rps_part).

                  /* CALCULATE YIELD... */
                  v-op = 999999999.
                  run ip-get-yield
                     (input if rps_routing <> ""
                            then
                               rps_routing
                            else
                               rps_part,
                      input  v-op,
                      input  rps_rel_date,
                      output yield_pct).

               end.  /* if available mrpc_ctrl...  */

               wo_yield_pct = yield_pct.

               /*ASSIGN DEFAULT RECEIPT STATUS AND ACTIVE FLAG */
               {pxrun.i &PROC    = 'get_default_wo_rctstat'
                        &PROGRAM = 'wocmnrtn.p'
                        &HANDLE  = ph_wocmnrtn
                        &PARAM   = "(
                                     input  wo_part,
                                     input  wo_site,
                                     output wo_rctstat,
                                     output wo_rctstat_active,
                                     output l_errorno
                                   )"
               }

               /* ASSIGN DEFAULT VARIANCE ACCOUNT SUB-ACCOUNT */
               /* AND COST CENTER CODE.                       */
               run assign_default_wo_acct(buffer wo_mstr,
                                          input pt_prod_line).

            end.  /* IF AVAILABLE PT_MSTR */

            if recid(wo_mstr) = -1 then .
            assign
               site = rps_site
               comp = rps_part.

            /* IF AN ALTERNATE BOM IS BEING USED, USE THAT INSTEAD OF THE */
            /* PART FOR EXPLODE ITEM TO GET COMPONENT LIST.               */
            if rps_bom_code <> ""
            then
               comp = rps_bom_code.

            {gprun.i ""rerpexb.p""}

            /*RECALCULATE COMPONENT DEMAND FOR MRP*/

            for first pt_mstr
               fields( pt_domain pt_part pt_prod_line)
                where pt_mstr.pt_domain = global_domain and  pt_part = rps_part
                no-lock:
            end. /* FOR FIRST PT_MSTR */

            assign
               wo_recno = recid(wo_mstr)
               pt_recno = recid(pt_mstr).

            {gprun.i ""rerpexa.p""}

         end. /* need to create wo_mstr */

/* SS - 090622.1 - B */
{gprun.i ""xxreupdscb.p"" "(input wo_lot, input qty_to_apply)"}
/* SS - 090622.1 - E */

         assign
            new_pointer_date = wo_due_date
            qty_left         = qty_left - qty_to_apply.

         if qty_left = 0
         then
            leave.
      end.
   end.

   /*MAY NEED TO BACK UP ONE RECORD IN CASE THE LAST PROCESSED
   EXACTLY ZEROED OUT THE QTY REQUIRED*/

   if new_pointer_date <> ?
   then do:

      work_date = new_pointer_date.

      for each wo_mstr
        fields
           (wo_acct
            wo_sub
            wo_bom_code wo_cc wo_due_date
            wo_xvar_acct
            wo_xvar_sub
            wo_xvar_cc
            wo_flr_acct
            wo_flr_sub
            wo_flr_cc wo_line wo_lot wo_mvar_acct
            wo_mvar_sub
            wo_mvar_cc wo_mvrr_acct
            wo_mvrr_sub
            wo_mvrr_cc wo_nbr wo_ord_date
            wo_part wo_qty_comp wo_qty_ord wo_rel_date
            wo_routing wo_site wo_status wo_svar_acct
            wo_svar_sub
            wo_svar_cc
            wo_svrr_acct
            wo_svrr_sub
            wo_svrr_cc wo_type wo_yield_pct)
         no-lock
          where wo_mstr.wo_domain = global_domain and  wo_type      = "s"
           and wo_part      = item
           and wo_site      = site
           and wo_due_date <= work_date
           and wo_line = line
         use-index wo_type_part
         by wo_type descending
         by wo_part descending
         by wo_site descending
         by wo_due_date descending:

         if wo_qty_comp <> 0
         then do:
            new_pointer_date = wo_due_date.
            leave.
         end.

      end.
   end.
end.

/* LOCK THE qad_wkfl RECORD */
find first qad_wkfl
    where qad_wkfl.qad_domain = global_domain and  qad_key1 = "rps_mstr"
     and qad_key2 = key2
exclusive-lock no-error.

if available qad_wkfl
then
   qad_datefld[1] = new_pointer_date.

/******************************************************************/

/*   I N T E R N A L    P R O C E D U R E S     */

/******************************************************************/

/* This routine will load routing information  for a part into  */
/* a temp table.                                                */
{gplodyld.i}

/******************************************************************/

/* This routine will determine operation yield percentage        */
/* used.                                                         */
{gpgetyld.i}

/******************************************************************/

/* INCLUDE FILE WHICH CONTAINS PROCEDURE assign_default_wo_acct */
{woacct.i}
