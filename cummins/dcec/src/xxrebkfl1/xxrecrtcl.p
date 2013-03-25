/* recrtcl.p  - REPETITIVE   SUBPROGRAM TO CREATE A BACKFLUSH COMPONENT LIST  */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*H1J5*/ /*V8:RunMode=Character,Windows          */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                         */
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

/*J2DG*/ /* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO */
/*J2DG*/ /* WHEREVER MISSING AND REPLACED FIND STATEMENTS WITH FOR FIRST  */
/*J2DG*/ /* STATEMENTS FOR ORACLE PERFORMANCE.                            */

         {mfdeclre.i}
         define input parameter cumwo_lot as character no-undo.
         define input parameter op        as integer   no-undo.
         define input parameter include_prior_nonmilestones as logical no-undo.
         define input parameter backflush_qty as decimal no-undo.
         define input parameter eff_date      as date    no-undo.
/*G09J*/ define input parameter do_zero_unissuable as logical    no-undo.
/*H0Q8*/ define input parameter wkctr              like op_wkctr no-undo.
         define output parameter any_not_issuable  as logical no-undo.
         define output parameter lotserials_req    as logical no-undo.

/*N04H** {rewrsdef.i}                                                         */

         define variable bomcode   as character no-undo.
         define variable routecode as character no-undo.
         define variable oplist    as character no-undo.
         define variable following_op_input_que as decimal no-undo.
         define variable qty_to_move_next_op    as decimal no-undo.
         define variable qty_to_process         as decimal no-undo.
         define variable rejected  as logical   no-undo.
/*GO69*  define variable tmprnd as decimal initial 10000000000000000. */
/*G1TH*/ define variable temp_qty  like pk_qty  no-undo.
/*H1J5*/ define variable mfc-recid as recid     no-undo.

         define workfile work_ops
            field work_ops_op as integer
            field work_ops_bkfl_qty as decimal.
/**************tfq added begin***************************************/
define new shared temp-table xxpk_det 
			  field xxpk_domain like global_domain
        field xxpk_user like pk_user
        field xxpk_part like pk_part
        field xxpk_ref like pk_reference
        field xxpk_op like ps_op  .
 define  temp-table zzpk_det 
 						  field  zzpk_domain    like global_domain
              field  zzpk_user      like pk_user
              field  zzpk_part      like pk_part
/*G656*/      field  zzpk_reference like pk_reference
              field  zzpk_loc       like pk_loc
              field  zzpk_start     like pk_start
              field  zzpk_end       like pk_end 
              field  zzpk_lot like pk_lot
              field  zzpk_user1 like pk_user1
              field  zzpk_user2 like pk_user2
              field  zzpk__qadc01 like pk__qadc01 
              field  zzpk_qty like pk_qty .
   for each zzpk_det where zzpk_domain = global_domain and zzpk_user = mfguser :
   delete zzpk_det .
   end.           
           
/*************tfq added end******************************************/

/*H1J5*/ /* BEGIN OF ADDED CODE */

         if can-find(mfc_ctrl where mfc_domain = global_domain and mfc_field = "rpc_zero_bal_wip")
         then do:
            for first mfc_ctrl
                fields (mfc_domain mfc_char mfc_field mfc_label mfc_logical
                mfc_module mfc_seq mfc_type)
                where mfc_domain  = global_domain and mfc_field = "rpc_zero_bal_wip" no-lock:
            end.
         end.
         else do:
            {gprun.i ""remfccr.p"" "(output mfc-recid)"}
            for first mfc_ctrl
                fields (mfc_domain mfc_char mfc_field mfc_label mfc_logical
                mfc_module mfc_seq mfc_type)
                where recid(mfc_ctrl) = mfc-recid no-lock:
            end.
         end.
/*H1J5*/ /* END OF ADDED CODE */


         any_not_issuable = no.
         lotserials_req = no.


         /*EXPLODE PRODUCT STRUCTURE AND CREATE PK_DET RECORDS*/

         for each pk_det
/*GO69*/ exclusive-lock
         where pk_domain = global_domain and pk_user = mfguser:
            delete pk_det.
         end.

/*H1J5*/ for each work_ops exclusive-lock:
/*H1J5*/    delete work_ops.
/*H1J5*/ end.

/*J2DG** find wo_mstr where wo_lot = cumwo_lot no-lock. */
/*J2DG*/ for first wo_mstr
/*J2DG*/    fields (wo_domain wo_bom_code wo_lot wo_part wo_routing wo_site)
/*J2DG*/    where wo_domain = global_domain and wo_lot = cumwo_lot no-lock:
/*J2DG*/ end. /* FOR FIRST WO_MSTR */

/*J2DG*/ assign
            bomcode   = if wo_bom_code > "" then  wo_bom_code else wo_part
            routecode = if wo_routing > "" then wo_routing else wo_part
            oplist    = string(op).

         if include_prior_nonmilestones then do:
            for each wr_route
/*J2DG*/       fields (wr_domain wr_lot wr_milestone wr_op wr_qty_inque wr_qty_outque)
               no-lock
               where wr_domain = global_domain and wr_lot = cumwo_lot
               and wr_op < op
               by wr_lot descending by wr_op descending
               while not wr_milestone:
               oplist = oplist + "," + string(wr_op).
            end.
         end.

         {gpxpld01.i "new shared"}
         incl_nopk = no.    
                  /*DON'T INCLUDE FLOORSTOCK*/
                    /***  
         message "call xxgpxldps.i" .
         pause .
         ***/
         {yygpxpldps.i &date=eff_date &site=wo_site &comp=bomcode &op=op
         &op_list=oplist}

         /*FIGURE QTIES TO BACKFLUSH AT EACH OPERATION BASED ON CURRENT QUEUES
         AND REMEMBER THEM*/

/*H1GT*        CREATION OF WORKFILE IS CONDITIONALLY RESTRICTED WHEN      */
/*H1GT*        backflush_qty IS ZERO. THIS IS, TO ALWAYS DEFAULT COMPONENT*/
/*H1GT*        QTY BACKFLUSHED TO ZERO REGARDLESS OF MILESTONE OR         */
/*H1GT*        NON-MILESTONE OPERATION(S) WHILE PROCESSING REWORK         */
/*H1GT*        TRANSACTION.                                               */

/*H1GT*/ if backflush_qty <> 0 then
/*H1GT*/ do:

            create work_ops.
/*J2DG*/       assign
                  work_ops_op       = op
                  work_ops_bkfl_qty = backflush_qty.

            if include_prior_nonmilestones then do:
/*J2DG**       find wr_route where wr_lot = cumwo_lot and wr_op = op no-lock.*/
/********tfq deleted begin*******************************************
/*J2DG*/       for first wr_route
/*J2DG*/          fields (wr_domain wr_lot wr_milestone wr_op wr_qty_inque wr_qty_outque)
/*J2DG*/          where wr_domain = global_domain and wr_lot = cumwo_lot
/*J2DG*/            and wr_op  = op no-lock:
/*J2DG*/       end. /* FOR FIRST WR_ROUTE */

/*N04H**       {rewrsget.i &lot=wr_lot &op=wr_op}                             */

               following_op_input_que = wr_qty_inque - backflush_qty.
*******************tfq deleted end*********************************/
/******************tfq added begin******************************/
find first wr_route
/*J2DG*/          where wr_domain = global_domain and wr_lot = cumwo_lot
/*J2DG*/            and wr_op  = op no-lock no-error .
if available wr_route then  following_op_input_que = wr_qty_inque - backflush_qty.
/*****************tfq added end********************************/
/*H1J5*/       /* WHEN 'Zero Balance WIP' FLAG IS SET TO 'Yes' IN THE        */
/*H1J5*/       /* REPETITIVE CONTROL FILE (18.22.24), CURRENT LOGIC OF ZERO  */
/*H1J5*/       /* BALANCING WIP PRESENT IN THE INPUT Q OF MILESTONE OPERATION*/
/*H1J5*/       /* AND PRIOR NON-MILESTONE OPERTAIONS INPUT/OUTPUT Q SHOULD BE*/
/*H1J5*/       /* EXECUTED.                                                  */

/*H1J5*/       if (available mfc_ctrl and mfc_logical = yes) then do:
               for each wr_route
/*J2DG*/          fields (wr_domain wr_lot wr_milestone wr_op wr_qty_inque wr_qty_outque)
                  no-lock
                  where wr_domain  = global_domain and wr_lot = cumwo_lot and wr_op < op
                  while not wr_milestone
                  by wr_lot descending by wr_op descending:

/*N04H**          {rewrsget.i &lot=wr_lot &op=wr_op}                          */

/*J2DG*/          assign
                     qty_to_move_next_op = - following_op_input_que
                     qty_to_process      = qty_to_move_next_op - wr_qty_outque.

                  create work_ops.
                  assign
                     work_ops_op            = wr_op
                     work_ops_bkfl_qty      = qty_to_process
                     following_op_input_que = wr_qty_inque - qty_to_process.

               end.

/*H1J5*/       end. /* IF mfc_logical = yes */

/*H1J5*/ /* BEGIN OF ADDED SECTION */

               else if (available mfc_ctrl and mfc_logical = no) then do:

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

                  if backflush_qty > 0 then do:

                     for each wr_route
/*J2DG*/                 fields (wr_domain wr_lot wr_milestone wr_op
/*J2DG*/                         wr_qty_inque wr_qty_outque)
                         no-lock
                         where wr_domain = global_domain and wr_lot = cumwo_lot and wr_op < op
                         while not wr_milestone
                         by wr_lot descending
                         by wr_op descending:

/*N04H**                 {rewrsget.i &lot=wr_lot &op=wr_op}                   */


                         if following_op_input_que >= 0 then leave.

                         qty_to_move_next_op = - following_op_input_que.

                         if qty_to_move_next_op - wr_qty_outque <= 0 then
                            leave.

                         qty_to_process = qty_to_move_next_op -
                                                  wr_qty_outque.

                         create work_ops.
                         assign work_ops_op            = wr_op
                                work_ops_bkfl_qty      = qty_to_process
                                following_op_input_que = wr_qty_inque -
                                                         qty_to_process.

                     end. /* FOR EACH wr_route */

                  end. /* if backflush_qty > 0 */

               end. /* IF AVAILABLE mfc_ctrl and mfc_logical = no */

/*H1J5*/ /* END OF ADDED SECTION */

            end. /* if include_prior_nonmilestones */

/*H1J5*/ /* BEGIN OF ADDED SECTION */

               else if (available mfc_ctrl and mfc_logical = no) then do:

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

                  if backflush_qty > 0 then do:

                     for each wr_route
/*J2DG*/                 fields (wr_domain wr_lot wr_milestone wr_op
/*J2DG*/                         wr_qty_inque wr_qty_outque)
             no-lock
                         where wr_domain = global_domain and wr_lot = cumwo_lot and wr_op < op
                         while not wr_milestone
                         by wr_lot descending
                         by wr_op descending:

/*N04H**                 {rewrsget.i &lot=wr_lot &op=wr_op}                   */


                         if following_op_input_que >= 0 then leave.

                         qty_to_move_next_op = - following_op_input_que.

                         if qty_to_move_next_op - wr_qty_outque <= 0 then
                            leave.

                         qty_to_process = qty_to_move_next_op -
                                                 wr_qty_outque.

                         create work_ops.
                         assign work_ops_op            = wr_op
                                work_ops_bkfl_qty      = qty_to_process
                                following_op_input_que = wr_qty_inque -
                                                         qty_to_process.

                     end. /* FOR EACH wr_route */

                  end. /* if backflush_qty > 0 */

               end. /* IF AVAILABLE mfc_ctrl and mfc_logical = no */

/*H1J5*/ /* END OF ADDED SECTION */
/*H1GT*/ end. /*IF BACKFLUSH_QTY <> 0 */

         /*CONSOLIDATE LIKE PART/REFERENCE NUMBER INTO ONE RECORD */
         /* pk_reference STORES THE OPERATION NUMBER */
/*G1TH*/ /* BEGIN ADD SECTION */
         for each pk_det exclusive-lock
           where pk_domain = global_domain and pk_user = mfguser
           break by pk_user
                 by pk_part
                 by pk_reference:
           if first-of(pk_reference) then
              temp_qty = 0.
              assign
                 temp_qty = temp_qty + pk_qty
                 pk_qty   = 0.
           if last-of(pk_reference) then
              pk_qty = temp_qty.
         end.
         for each pk_det exclusive-lock
           where pk_domain  = global_domain and pk_user = mfguser and
                 pk_qty = 0:
           delete pk_det.
         end.

/*G1TH*/ /* END ADD SECTION*/

         /*RUN THRU THE COMPONENT LIST AND...*/

         for each pk_det exclusive-lock
         where pk_domain = global_domain and pk_user = mfguser:
/*GO69*     pk_qty = pk_qty / tmprnd. */


            /*SET DEFAULT ISSUE LOCATION*/
/*H0Q8*/    if integer(pk_reference) <> op then do:

               for each ro_det
/*J2DG*/          fields (ro_domain ro_end ro_op ro_routing ro_start ro_wkctr)
                  no-lock
                  where ro_domain = global_domain and ro_routing = routecode
                  and ro_op = integer(pk_reference)
                  and (ro_start = ? or ro_start <= eff_date)
                  and (ro_end   = ? or ro_end   >= eff_date):
/*J2DG**       find loc_mstr where loc_site = wo_site and loc_loc = ro_wkctr */
/*J2DG**       no-lock no-error.                                             */
/*J2DG*/          for first loc_mstr
/*J2DG*/             fields (loc_domain loc_loc loc_site)
/*J2DG*/             where loc_domain = global_domain and loc_site = wo_site
/*J2DG*/               and loc_loc = ro_wkctr no-lock:
/*J2DG*/          end. /* FOR FIRST LOC_MSTR */

                  if available loc_mstr then pk_loc = ro_wkctr.
               end.

/*H0Q8*/    end.
/*H0Q8*/    else do:
/*H0Q8*/      if can-find (loc_mstr where loc_domain = global_domain and loc_site = wo_site and
/*H0Q8*/        loc_loc = wkctr) then pk_loc = wkctr.
/*H0Q8*/    end.


            /*SET THE BACKFLUSH QTY*/
            find first work_ops where work_ops_op = integer(pk_reference)
            no-lock no-error.
            if available work_ops
            then pk_qty = pk_qty * work_ops_bkfl_qty / bombatch.
            else pk_qty = 0.


            /*SEE IF ANY LOT/SERIAL REQUIRED*/
/*J2DG**    find pt_mstr where pt_part = pk_part no-lock no-error. */
/*J2DG*/    for first pt_mstr
/*J2DG*/       fields (pt_domain pt_lot_ser pt_part pt_um)
/*J2DG*/       where pt_domain = global_domain and pt_part = pk_part no-lock:
/*J2DG*/    end. /* FOR FIRST PT_MSTR */

            if available pt_mstr and index("LS",pt_lot_ser) > 0 then do:
               lotserials_req = yes.
            end.


            /*SEE IF ANY NOT ISSUABLE*/
/*J04T*/    /*ADD BLANKS FOR TRNBR AND TRLINE INPUT PARAMTERS */
            {gprun.i ""icedit2.p"" "(input ""ISS-WO"",
                                     input wo_site,
                                     input pk_loc,
                                     input pk_part,
                                     input """",
                                     input """",
                                     input pk_qty,
                                     input if available pt_mstr then pt_um
                                                                else """",
                                     input """",
                                     input """",
                                     output rejected)"
            }

            if rejected then do:
               any_not_issuable = yes.
/*G09J*/       /*SET TO ZERO ACCORDING TO FLAG*/
/*G09J*/       if do_zero_unissuable then
                  pk_qty = 0.
            end.
         end.
/********tfq added begin********************/
for each pk_det where pk_domain = global_domain and pk_user = mfguser :
find first xxpk_det where xxpk_domain = global_domain and 
           xxpk_user = mfguser and xxpk_part = pk_part and xxpk_ref = pk_reference no-error .
      if available xxpk_det and pk_reference <> string(xxpk_op) then do:
         pk_reference = string(xxpk_op) .
      end.
end.
for each  xxpk_det where xxpk_domain = global_domain and xxpk_user = mfguser :
delete xxpk_det .
end.
for each pk_det where pk_domain = global_domain and  pk_user = mfguser :
  find first zzpk_det where zzpk_domain = global_domain and zzpk_user = pk_user
                        and zzpk_part = pk_part 
                        and zzpk_reference = pk_reference no-error .
        if not available zzpk_det then
        do:                
            create zzpk_det. zzpk_domain = global_domain.
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
                  create pk_det. pk_domain = global_domain.
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

/**********tfq added end***************/
