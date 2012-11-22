/* GUI CONVERTED from recrtcl.p (converter v1.78) Thu Sep  2 02:34:14 2010 */
/* recrtcl.p  - REPETITIVE   SUBPROGRAM TO CREATE A BACKFLUSH COMPONENT LIST  */
/* Copyright 1986-2010 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: WUG *GN77*                */
/* REVISION: 7.3      LAST MODIFIED: 12/02/94   BY: emb *GO69*                */
/* REVISION: 7.3      LAST MODIFIED: 12/16/94   BY: WUG *G09J*                */
/* REVISION: 8.5      LAST MODIFIED: 05/12/95   BY: pma *J04T*                */
/* REVISION: 8.5      LAST MODIFIED: 04/24/96   BY: jym *G1TH*                */
/* REVISION: 8.5      LAST MODIFIED: 12/31/96   BY: *H0Q8* Julie Milligan     */
/* REVISION: 8.5      LAST MODIFIED: 11/21/97   BY: *H1GT* Santhosh Nair      */
/* REVISION: 8.6E     LAST MODIFIED: 08/17/98   BY: *H1J5* Dana Tunstall      */
/* REVISION: 9.0      LAST MODIFIED: 04/16/99   BY: *J2DG* Reetu Kapoor       */
/* REVISION: 9.1      LAST MODIFIED: 11/17/99   BY: *N04H* Vivek Gogte        */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb                */
/* Revision: 1.17  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.17.2.1   BY: Munira Savai         DATE: 08/21/07  ECO: *P61P*  */
/* $Revision: 1.17.2.2 $  BY: Ravi Swami         DATE: 08/25/10  ECO: *Q4BF*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*-Revision end---------------------------------------------------------------*/

/* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO          */
/* WHEREVER MISSING AND REPLACED FIND STATEMENTS WITH FOR FIRST           */
/* STATEMENTS FOR ORACLE PERFORMANCE.                                     */

/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}

define temp-table tt_po_lineqty no-undo
   field tt_part    like pt_part
   field tt_site    like pt_site
   field tt_loc     like pt_loc
   field tt_tpoline like pod_line
   field tt_qty     like mrp_qty
   index tt_index_part tt_part
         tt_site
         tt_loc.

define input  parameter cumwo_lot                   as   character no-undo.
define input  parameter op                          as   integer   no-undo.
define input  parameter include_prior_nonmilestones as   logical   no-undo.
define input  parameter backflush_qty               as   decimal   no-undo.
define input  parameter eff_date                    as   date      no-undo.
define input  parameter do_zero_unissuable          as   logical   no-undo.
define input  parameter wkctr                       like op_wkctr  no-undo.
define input  parameter poline                      like pod_line  no-undo.
define output parameter any_not_issuable            as   logical   no-undo.
define output parameter lotserials_req              as   logical   no-undo.
define input-output parameter table for tt_po_lineqty.

define variable bomcode                as character no-undo.
define variable routecode              as character no-undo.
define variable oplist                 as character no-undo.
define variable following_op_input_que as decimal   no-undo.
define variable qty_to_move_next_op    as decimal   no-undo.
define variable qty_to_process         as decimal   no-undo.
define variable rejected               as logical   no-undo.

define variable temp_qty  like pk_qty no-undo.
define variable mfc-recid as   recid  no-undo.
define variable l_pk_qty  like pk_qty no-undo.
define variable l_tpk_qty  like pk_qty no-undo.

define workfile work_ops
   field work_ops_op       as integer
   field work_ops_bkfl_qty as decimal.

/**************tfq added begin*************************************** 
	 {yyrebktt.i "new"}
   for each zzpk_det where zzpk_user = mfguser :
   delete zzpk_det .
   end.           
           
 ************tfq added end******************************************/


if can-find(mfc_ctrl
               where mfc_ctrl.mfc_domain = global_domain
           and   mfc_field           = "rpc_zero_bal_wip")
then do:
   for first mfc_ctrl
      fields( mfc_domain mfc_char mfc_field mfc_label mfc_logical
              mfc_module mfc_seq mfc_type)
      where mfc_ctrl.mfc_domain = global_domain
      and   mfc_field           = "rpc_zero_bal_wip"
   no-lock:
   end. /*FOR FIRST mfc_ctrl*/
end. /* IF CAN-FIND (mfc_ctrl..*/
else do:
   {gprun.i
      ""remfccr.p""
      "(output mfc-recid)"
   }
/*GUI*/ if global-beam-me-up then undo, leave.

   for first mfc_ctrl
      fields( mfc_domain mfc_char mfc_field mfc_label mfc_logical
              mfc_module mfc_seq mfc_type)
      where recid(mfc_ctrl) = mfc-recid
   no-lock:
   end. /*FOR EACH mfc_ctrl*/
end.

assign
   any_not_issuable = no
   lotserials_req   = no.

/*EXPLODE PRODUCT STRUCTURE AND CREATE PK_DET RECORDS*/

for each pk_det
   where pk_det.pk_domain = global_domain
   and   pk_user          = mfguser
exclusive-lock:
   delete pk_det.
end. /*FOR EACH pk_det*/

for each work_ops
exclusive-lock:
   delete work_ops.
end. /*FOR EACH wprk_ops*/

for first wo_mstr
   fields( wo_domain wo_bom_code wo_lot wo_part wo_routing wo_site)
   where wo_mstr.wo_domain = global_domain
   and   wo_lot            = cumwo_lot
no-lock:
end. /* FOR FIRST WO_MSTR */

assign
   bomcode   = if wo_bom_code > ""
               then
              wo_bom_code
           else
              wo_part
   routecode = if wo_routing > ""
               then
              wo_routing
           else
              wo_part
   oplist    = string(op).

if include_prior_nonmilestones
then do:
   for each wr_route
         fields( wr_domain wr_lot wr_milestone wr_op wr_qty_inque wr_qty_outque)
         where wr_route.wr_domain = global_domain
     and   wr_lot             = cumwo_lot
         and   wr_op              < op
   no-lock
   by wr_lot descending
   by wr_op descending
   while not wr_milestone:
      oplist = oplist + "," + string(wr_op).
   end. /*FOR EACH wr_route*/
end. /*IF include_prior_nonmilestones*/

{gpxpld01.i "new shared"}
incl_nopk = no.                 /*DON'T INCLUDE FLOORSTOCK*/

{yygpxpldps.i
   &date=eff_date
   &site=wo_site
   &comp=bomcode
   &op=op
   &op_list=oplist
}

/*FIGURE QTIES TO BACKFLUSH AT EACH OPERATION BASED ON CURRENT QUEUES*/
/*AND REMEMBER THEM*/

/*CREATION OF WORKFILE IS CONDITIONALLY RESTRICTED WHEN        */
/*backflush_qty IS ZERO. THIS IS, TO ALWAYS DEFAULT COMPONENT  */
/*QTY BACKFLUSHED TO ZERO REGARDLESS OF MILESTONE OR           */
/*NON-MILESTONE OPERATION(S) WHILE PROCESSING REWORK           */
/*TRANSACTION.                                                 */

if backflush_qty <> 0
then do:

   create work_ops.
   assign
      work_ops_op       = op
      work_ops_bkfl_qty = backflush_qty.

   if include_prior_nonmilestones
   then do:

      for first wr_route
         fields( wr_domain wr_lot wr_milestone wr_op wr_qty_inque
                 wr_qty_outque)
         where wr_route.wr_domain = global_domain
     and   wr_lot             = cumwo_lot
         and   wr_op              = op
      no-lock:
      end. /* FOR FIRST WR_ROUTE */

      following_op_input_que = wr_qty_inque - backflush_qty.

      /* WHEN 'Zero Balance WIP' FLAG IS SET TO 'Yes' IN THE        */
      /* REPETITIVE CONTROL FILE (18.22.24), CURRENT LOGIC OF ZERO  */
      /* BALANCING WIP PRESENT IN THE INPUT Q OF MILESTONE OPERATION*/
      /* AND PRIOR NON-MILESTONE OPERTAIONS INPUT/OUTPUT Q SHOULD BE*/
      /* EXECUTED.                                                  */

      if (available mfc_ctrl
            and mfc_logical = yes)
      then do:
         for each wr_route
               fields( wr_domain wr_lot wr_milestone wr_op wr_qty_inque wr_qty_outque)
               where wr_route.wr_domain = global_domain
           and   wr_lot             = cumwo_lot
           and   wr_op              < op
         no-lock
         while not wr_milestone
         by wr_lot descending
          by wr_op descending:

            assign
               qty_to_move_next_op = - following_op_input_que
               qty_to_process      = qty_to_move_next_op - wr_qty_outque.

            create work_ops.
            assign
               work_ops_op            = wr_op
               work_ops_bkfl_qty      = qty_to_process
               following_op_input_que = wr_qty_inque - qty_to_process.

         end. /*FOR EACH wr-route*/

      end. /* IF mfc_logical = yes */

      /* BEGIN OF ADDED SECTION */

      else
         if (available mfc_ctrl
             and mfc_logical = no)
         then do:

            /* WHEN 'Zero Balance WIP' FLAG IS SET TO 'No' IN REP.     */
            /* CONTROL FILE, COMPONENTS TO BE BACKFLUSHED AT THE PRIOR */
            /* NM OP'S ARE DETERMINED BY TAKING INTO ACCOUNT THE WIP   */
            /* BALANCES AT THE INPUT Q OF THE CURRENT OP & INPUT/OUTPUT*/
            /* Q OF PRIOR NON-MILESTONE OPERATIONS. IF BACKFLUSH QTY IS*/
            /* GREATER THAN ZERO, WIP BALANCES AT INPUT Q OF CURRENT   */
            /* OP & INPUT/OUTPUT Q OF PRIOR NM OP'S SHOULD BE          */
            /* CONSIDERED APPROPRIATELY WHILE BACKFLUSHING COMPONENTS  */
            /* AT PRIOR NM OP'S.                                       */
            /* FOR A CORRECTING TRANSACTION,                           */
            /* 1. COMPONENTS ASSOCIATED WITH THE  CURRENT OP ARE       */
            /* RECIEVED INTO INVENTORY.                                */
            /* 2. INCASE OF SUB SHIPPER ISSUE, NO COMPONENT RECEIPT IS */
            /* CONCERNED W.R.T PRIOR NM OP's AS IT PUTS BACK THE QTY   */
            /* INTO THE OUTPUT QUEUE OF THE OP WHICH IS PRIOR TO       */
            /* SUB-CONTRACT OP.                                        */
            /* 3. IF OCCURS AT THE LAST OP AND IF 'Move to next op' =  */
            /* yes, PARENT QTY IS ISSUED OUT OF INVENTORY CORRECPONDING*/
            /* TO THE -VE QTY BACKFLUSHED.                             */

            if backflush_qty > 0
            then do:

               for each wr_route
                  fields( wr_domain wr_lot wr_milestone wr_op
                          wr_qty_inque wr_qty_outque)
                  where wr_route.wr_domain = global_domain
                  and   wr_lot             = cumwo_lot
                  and   wr_op              < op
               no-lock
               while not wr_milestone
               by wr_lot descending
               by wr_op descending:

                  if following_op_input_que >= 0
                  then
                     leave.

                  qty_to_move_next_op = - following_op_input_que.

                  if qty_to_move_next_op - wr_qty_outque <= 0
                  then
                     leave.

                  qty_to_process = qty_to_move_next_op - wr_qty_outque.

                  create work_ops.
                  assign
                     work_ops_op            = wr_op
                     work_ops_bkfl_qty      = qty_to_process
                     following_op_input_que = wr_qty_inque -
                     qty_to_process.

               end. /* FOR EACH wr_route */

            end. /* if backflush_qty > 0 */

         end. /* IF AVAILABLE mfc_ctrl and mfc_logical = no */

   end. /* if include_prior_nonmilestones */

   /* BEGIN OF ADDED SECTION */

   else
      if (available mfc_ctrl
            and mfc_logical = no)
      then do:

         /* WHEN 'Zero Balance WIP' FLAG IS SET TO 'No' IN REP.     */
         /* CONTROL FILE, COMPONENTS TO BE BACKFLUSHED AT THE PRIOR */
         /* NM OP'S ARE DETERMINED BY TAKING INTO ACCOUNT THE WIP   */
         /* BALANCES AT THE INPUT Q OF THE CURRENT OP & INPUT/OUTPUT*/
         /* Q OF PRIOR NON-MILESTONE OPERATIONS. IF BACKFLUSH QTY IS*/
         /* GREATER THAN ZERO, WIP BALANCES AT INPUT Q OF CURRENT   */
         /* OP & INPUT/OUTPUT Q OF PRIOR NM OP'S SHOULD BE          */
         /* CONSIDERED APPROPRIATELY WHILE BACKFLUSHING COMPONENTS  */
         /* AT PRIOR NM OP'S.                                       */
         /* FOR A CORRECTING TRANSACTION,                           */
         /* 1. COMPONENTS ASSOCIATED WITH THE  CURRENT OP ARE       */
         /* RECIEVED INTO INVENTORY.                                */
         /* 2. INCASE OF SUB SHIPPER ISSUE, NO COMPONENT RECEIPT IS */
         /* CONCERNED W.R.T PRIOR NM OP's AS IT PUTS BACK THE QTY   */
         /* INTO THE OUTPUT QUEUE OF THE OP WHICH IS PRIOR TO       */
         /* SUB-CONTRACT OP.                                        */
         /* 3. IF OCCURS AT THE LAST OP AND IF 'Move to next op' =  */
         /* yes, PARENT QTY IS ISSUED OUT OF INVENTORY CORRECPONDING*/
         /* TO THE -VE QTY BACKFLUSHED.                             */

         if backflush_qty > 0
         then do:

            for each wr_route
               fields( wr_domain wr_lot wr_milestone wr_op
                       wr_qty_inque wr_qty_outque)
               where wr_route.wr_domain = global_domain
               and   wr_lot             = cumwo_lot
               and   wr_op              < op
            no-lock
            while not wr_milestone
            by wr_lot descending
            by wr_op descending:

               if following_op_input_que >= 0
               then
                  leave.

               qty_to_move_next_op = - following_op_input_que.

               if qty_to_move_next_op - wr_qty_outque <= 0
               then
                  leave.

               qty_to_process = qty_to_move_next_op - wr_qty_outque.

               create work_ops.
               assign
                  work_ops_op            = wr_op
                  work_ops_bkfl_qty      = qty_to_process
                  following_op_input_que = wr_qty_inque -
                  qty_to_process.

            end. /* FOR EACH wr_route */

         end. /* if backflush_qty > 0 */

      end. /* IF AVAILABLE mfc_ctrl and mfc_logical = no */

end. /*IF BACKFLUSH_QTY <> 0 */

/*CONSOLIDATE LIKE PART/REFERENCE NUMBER INTO ONE RECORD */
/* pk_reference STORES THE OPERATION NUMBER */
for each pk_det
   where pk_det.pk_domain = global_domain
   and   pk_user          = mfguser
exclusive-lock
break by pk_user
      by pk_part
      by pk_reference:

   if first-of(pk_reference)
   then
      temp_qty = 0.

   assign
      temp_qty = temp_qty + pk_qty
      pk_qty   = 0.
   if last-of(pk_reference)
   then
      pk_qty = temp_qty.
end. /*FOR EACH pk_det*/

for each pk_det
   where pk_det.pk_domain = global_domain
   and   pk_user = mfguser
   and   pk_qty = 0
 exclusive-lock:
   delete pk_det.
end. /*FOR EACH pk_det*/

/*RUN THRU THE COMPONENT LIST AND...*/

for each pk_det
   where pk_det.pk_domain = global_domain
   and   pk_user = mfguser
exclusive-lock
break by pk_user
      by pk_part :

   /*SET DEFAULT ISSUE LOCATION*/
   if integer(pk_reference) <> op
   then do:

      for each ro_det
         fields( ro_domain ro_end ro_op ro_routing ro_start ro_wkctr)
         where ro_det.ro_domain = global_domain
     and  (ro_routing       = routecode
                and ro_op       = integer(pk_reference)
         and (ro_start          = ?
            or ro_start     <= eff_date)
         and (ro_end            = ?
            or ro_end       >= eff_date) )
      no-lock:

         for first loc_mstr
            fields( loc_domain loc_loc loc_site)
            where loc_mstr.loc_domain = global_domain
        and   loc_site            = wo_site
            and   loc_loc             = ro_wkctr
     no-lock:
         end. /* FOR FIRST LOC_MSTR */

         if available loc_mstr
     then
        pk_loc = ro_wkctr.
      end. /*FOR EACH ro_det*/

   end. /*IF integer(pk_reference) <> op*/
   else do:
      if can-find (loc_mstr
                      where loc_mstr.loc_domain = global_domain
                      and   loc_site            = wo_site
              and   loc_loc             = wkctr)
      then
         pk_loc = wkctr.
   end. /*ELSE DO:*/

   /*SET THE BACKFLUSH QTY*/
   find first work_ops
   where work_ops_op = integer(pk_reference)
   no-lock no-error.
   if available work_ops
   then
      pk_qty = pk_qty * work_ops_bkfl_qty / bombatch.
   else
      pk_qty = 0.

   /*SEE IF ANY LOT/SERIAL REQUIRED*/

   for first pt_mstr
      fields( pt_domain pt_lot_ser pt_part pt_um)
      where pt_mstr.pt_domain = global_domain
      and   pt_part           = pk_part
   no-lock:
   end. /* FOR FIRST PT_MSTR */

   if available pt_mstr
      and index("LS",pt_lot_ser) > 0
   then
      lotserials_req = yes.

   accumulate pk_qty (sub-total by pk_part).

   if include_prior_nonmilestones
      and execname = "rebkfl.p"
   then
      l_pk_qty = accum sub-total by pk_part pk_qty.
   else
      l_pk_qty = pk_qty.


   /* ACCUMULATE COMPONENT QUANTITY TO BE ISSEUED */
   /* FOR SUBCONTRACT PURCHASE ORDER              */

   if poline <> 0
   then do:
      for each tt_po_lineqty
         where tt_part = pk_part
         and   tt_site = wo_site
         and   tt_loc  = pk_loc
      no-lock:
         if tt_tpoline <> poline
         then
            l_tpk_qty = l_tpk_qty + tt_qty.

      end. /* FOR EACH tt_po_lineqty*/
      for first tt_po_lineqty
         where tt_part    = pk_part
         and   tt_site    = wo_site
         and   tt_loc     = pk_loc
         and   tt_tpoline = poline
      exclusive-lock:
            tt_qty = l_pk_qty.
      end. /* FOR FIRST tt_po_lineqty */
      if not available tt_po_lineqty
      then do :
         create tt_po_lineqty.
         assign
            tt_part    = pk_part
            tt_site    = wo_site
            tt_loc     = pk_loc
            tt_tpoline = poline
            tt_qty     = l_pk_qty.
      end. /* IF NOT AVAILABLE tt_po_lineqty */
      l_pk_qty = l_pk_qty + l_tpk_qty.
   end. /* IF poline <> 0 */

   /*SEE IF ANY NOT ISSUABLE*/
   /*ADD BLANKS FOR TRNBR AND TRLINE INPUT PARAMTERS */
   {gprun.i
      ""icedit2.p""
      "(input ""ISS-WO"",
        input wo_site,
        input pk_loc,
        input pk_part,
        input """",
        input """",
        input l_pk_qty,
        input if available pt_mstr then pt_um
        else """",
        input """",
        input """",
        output rejected)"
   }
/*GUI*/ if global-beam-me-up then undo, leave.


   if rejected
   then do:
      any_not_issuable = yes.
      /*SET TO ZERO ACCORDING TO FLAG*/
      if do_zero_unissuable
      then
         pk_qty = 0.

      if available tt_po_lineqty
      then
         tt_qty = 0.
   end. /*IF rejected*/
end. /*FOR EACH pk_det*/
/********tfq added begin****************** 
for each pk_det where pk_domain = global_domain and pk_user = mfguser :
find first xxpk_det where xxpk_user = mfguser and xxpk_part = pk_part and xxpk_ref = pk_reference no-error .
if available xxpk_det and pk_reference <> string(xxpk_op) then do:
         pk_reference = string(xxpk_op) .
      end.
end.
for each  xxpk_det where xxpk_user = mfguser :
delete xxpk_det .
end.
for each pk_det where pk_domain = global_domain and pk_user = mfguser :
  find first zzpk_det where zzpk_user = pk_user
                        and zzpk_part = pk_part 
                        and zzpk_reference = pk_reference no-error .
        if not available zzpk_det then
        do:                
            create zzpk_det.
                   assign zzpk_user      = pk_user
                          zzpk_part      = pk_part
/*G656*/                  zzpk_reference = pk_reference
                          zzpk_loc       = pk_loc
                          zzpk_start     = pk_start
                          zzpk_end       = pk_end 
                          zzpk_lot = pk_lot
                          zzpk_user1= pk_user1
                          zzpk_user2 = pk_user2
                          zzpk__qadc01 = pk__qadc01 .
                          zzpk_qty = pk_qty .
           end.               
                          
           else       zzpk_qty = pk_qty + zzpk_qty .
           delete pk_det .
           end.               
                  
for each zzpk_det where zzpk_user = mfguser :
                  create pk_det.
                   assign pk_user      = zzpk_user
                          pk_part      = zzpk_part
/*G656*/                  pk_reference = zzpk_reference
                          pk_loc       = zzpk_loc
                          pk_start     = zzpk_start
                          pk_end       = zzpk_end 
                          pk_lot = zzpk_lot
                          pk_user1= zzpk_user1
                          pk_user2 = zzpk_user2
                          pk__qadc01 = zzpk__qadc01 .
                          pk_qty = zzpk_qty .
                 delete zzpk_det .
           end.               

 ********tfq added end***************/
