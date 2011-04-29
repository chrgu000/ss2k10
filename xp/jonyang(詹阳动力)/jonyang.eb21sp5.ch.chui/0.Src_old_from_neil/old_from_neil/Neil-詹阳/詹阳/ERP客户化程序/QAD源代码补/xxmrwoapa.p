/* xxmrwoapa.p - APPROVE PLANNED WORK ORDERS 1st subroutine               */
/* GUI CONVERTED from mrwoapa.p (converter v1.69) Thu Oct 17 11:43:50 1996 */
/* mrwoapa.p - APPROVE PLANNED WORK ORDERS 1st subroutine               */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 1.0      LAST EDIT: 06/26/86   MODIFIED BY: EMB      */
/* REVISION: 1.0      LAST EDIT: 10/24/86   MODIFIED BY: EMB *37* */
/* REVISION: 1.0      LAST EDIT: 03/06/87   MODIFIED BY: EMB *A39* */
/* REVISION: 2.1      LAST EDIT: 09/17/87   MODIFIED BY: WUG *A94* */
/* REVISION: 2.1      LAST EDIT: 12/23/87   MODIFIED BY: emb       */
/* REVISION: 4.0      LAST EDIT: 02/05/88   MODIFIED BY: emb *A173* */
/* REVISION: 4.0      LAST EDIT: 09/06/88   MODIFIED BY: emb *A420* */
/* REVISION: 4.0      LAST EDIT: 05/30/89   MODIFIED BY: emb *A740* */
/* REVISION: 6.0      LAST EDIT: 12/17/91   MODIFIED BY: emb *D966**/
/* REVISION: 7.3      LAST EDIT: 01/06/93   MODIFIED BY: emb *G508**/
/* REVISION: 7.3      LAST EDIT: 09/12/94   MODIFIED BY: rwl *GM39**/
/* REVISION: 7.3      LAST EDIT: 09/20/94   MODIFIED BY: jpm *GM74**/
/* REVISION: 7.5      LAST EDIT: 11/09/94   MODIFIED BY: tjs *J027**/
/* REVISION: 7.3      LAST EDIT: 11/09/94   MODIFIED BY: srk *GO05**/
/* REVISION: 8.5     LAST MODIFIED: 10/16/96    BY: *J164* Murli Shastri */
/* REVISION: 8.5     LAST MODIFIED: 05/22/2000   BY: *JY008** Frankie Xu */

{mfdeclre.i}

/*J027*/ define new shared variable wo_recno     as recid.
/*J027*/ define new shared variable prev_status  like wo_status.
/*J027*/ define new shared variable prev_due     like wo_due_date.
/*J027*/ define new shared variable prev_qty     like wo_qty_ord.
/*J027*/ define new shared variable del-joint    like mfc_logical.
/*J027*/ define new shared variable undo_all     like mfc_logical no-undo.
/*J027*/ define new shared variable leadtime     like pt_mfg_lead.
/*J027*/ define new shared variable joint_type   like wo_joint_type.
/*J027*/ define new shared variable comp         like ps_comp.
/*J027*/ define new shared variable qty          like wo_qty_ord decimals 10.
/*J027*/ define new shared variable prev_release like wo_rel_date.
/*J027*/ define new shared variable any_issued   like mfc_logical.
/*J027*/ define new shared variable any_feedbk   like mfc_logical.
/*J027*/ define new shared variable prev_site    like wo_site.
/*J027*/ define new shared variable err_msg      as integer.
/*J027*/ define new shared variable no_msg       like mfc_logical initial no.

define shared variable release_all like mfc_logical.
define shared variable worecno as recid extent 100 no-undo.
define shared variable numlines as integer initial 100.
define variable nbr like wo_nbr.
define variable dwn like pod_line.
define shared variable mindwn as integer.
define shared variable maxdwn as integer.
define variable wonbrs as character extent 100.
define variable wolots as character extent 100.
define variable yn like mfc_logical column-label "批准".
define variable flag as integer initial 0 no-undo.
/*A740*/ define variable wocnbr like nbr.

/*J027*  define variable qty like wo_qty_ord. */
/*J027*/ define variable qt  like wo_qty_ord.
define variable approve like mfc_logical extent 100.

/*J027*/ define buffer wo_mstr1 for wo_mstr.

  approve = release_all.

  do transaction on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

/*GO05*/ mainloop:
     repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

/*GM74*/ /*V8+*/
/*GM74*/
      
	do dwn = mindwn to maxdwn with frame b 15 down width 80
		 bgcolor 8:   
	   wonbrs[dwn - mindwn + 1] = "".
	   wolots[dwn - mindwn + 1] = "".
	   /* DISPLAY DETAIL */
	   if worecno[dwn - mindwn + 1] <> ? then
	   do with frame b 15 down width 80:
	      find wo_mstr no-lock
	      where recid(wo_mstr) = worecno[dwn - mindwn + 1] no-error.
	      if available wo_mstr then do:

/*D966*          if index("YN",wo_status) = 0 then
      *             wo_status = caps(substring(string(release_all),1,1)). */
		 display dwn wo_nbr @ nbr
/*J027*          wo_lot wo_part wo_qty_ord @ qty */
/*J027*/         wo_lot wo_part wo_qty_ord @ qt
		 wo_rel_date
/*D966*          wo_status column-label "OK". */
/*D966*/         approve[dwn - mindwn + 1] @ yn.
		 wonbrs[dwn - mindwn + 1] = wo_nbr.
		 wolots[dwn - mindwn + 1] = wo_lot.
	      end.
	   end.
	end.
	nbr = "".
	do on error undo, leave:
/*GUI*/ if global-beam-me-up then undo, leave.

	   do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

	      dwn = mindwn - 1.
/*GM74*/ /*V8+*/
/*GM74*/ 
	      set dwn with frame d width 80 three-d editing:    
		 {mfnarray.i dwn mindwn maxdwn}
		 if dwn >= mindwn and dwn <= maxdwn
		 and wonbrs[dwn - mindwn + 1] <> "" then do:
		    find wo_mstr no-lock where
		    recid(wo_mstr) = worecno[dwn - mindwn + 1] no-error.

		    display dwn
		    wo_nbr @ nbr
/*JY008**
/*J027*             wo_lot wo_part wo_qty_ord @ qty */
/*J027*/            wo_lot wo_part wo_qty_ord @ qt
		    wo_rel_date
/*D966*             wo_status column-label "OK" */
***JY008***/
/*D966*/            approve[dwn - mindwn + 1] @ yn
		    with frame d.
		 end.
	      end.
/*J164*	      if dwn <> 0 and ((dwn < mindwn or dwn > maxdwn)  */
/*J164*	      or (dwn <> 0 and wonbrs[dwn - mindwn + 1] = "")) */
/*J164*/      if input  dwn <> 0 and ((dwn < mindwn or dwn > maxdwn)
/*J164*/      or (input dwn <> 0 and wonbrs[dwn - mindwn + 1] = ""))
	      then do:
		 {mfmsg.i 18 3} /* MUST SELECT A NUMBER LISTED ABOVE */
		 undo, retry.
	      end.

/*J164*	      if dwn <> 0 then if wonbrs[dwn - mindwn + 1] = "" */
/*J164*/        if input dwn <> 0 then if wonbrs[dwn - mindwn + 1] = ""
	      then undo, retry.
	   end.
/*GUI*/ if global-beam-me-up then undo, leave.

	   if dwn >= mindwn and dwn <= maxdwn then do:
	      find wo_mstr no-lock where
	      recid(wo_mstr) = worecno[dwn - mindwn + 1] no-error.
	      if not available wo_mstr then do:
		 {mfmsg.i 503 3} /*  WORK ORDER NUMBER DOES NOT EXIST */
		 undo, retry.
	      end.
	      else do:
/*JY008***
		 display dwn wo_nbr @ nbr wo_lot wo_part
/*J027*             wo_qty_ord @ qty */
/*J027*/            wo_qty_ord @ qt
		    wo_rel_date
/*D966*             wo_status column-label "OK" */
/*D966*/            approve[dwn - mindwn + 1] @ yn
		    with frame d.
*JY008**/     
/*JY008*/          display wo_nbr @ nbr   approve[dwn - mindwn + 1] @ yn   with frame d.

		 do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

		    set  nbr
/*D966*             wo_status column-label "OK" */
/*D966*/            yn
		    with frame d.

/*D966*/            approve[dwn - mindwn + 1] = yn.
/*D966*             wo_status = caps(wo_status).
      *             if index("YN",wo_status) = 0 then do:
      *                {mfmsg.i 504 3} /* ERROR: INVALID APPROVED INPUT */
      *                next-prompt wo_status.
      *                undo, retry.
      *             end. */

/*JY008*/	do dwn = mindwn to maxdwn :
/*JY008*/ 	      find wo_mstr no-lock where   recid(wo_mstr) = worecno[dwn - mindwn + 1] no-error.

/*J027*/ /* begin added block */
		    /* Change work order number, check for joint order */
		    if wo_nbr <> nbr then do for wo_mstr1:
		       find first wo_mstr1 no-lock where wo_mstr1.wo_nbr = nbr
		       and (wo_mstr1.wo_joint_type <> "" or
			    wo_mstr.wo_joint_type <> "")
		       no-error.
		       if available wo_mstr1 then do:
			  /* ORDER CANNOT BE ADDED TO A SET OF JOINT ORDERS */
			  {mfmsg.i 6540 3}
			  undo, retry.
		       end.
		    end.
/*J027*/ /* end added block */

		    /* Change work order number */
		    if wo_nbr <> nbr   then do:

		       if nbr = "" then do:
			  {mfnctrla.i woc_ctrl woc_nbr wo_mstr wo_nbr nbr}
			  wocnbr = nbr.
		       end.

		       if nbr = "" then do:
			  /* BLANK NOT ALLOWED */
			  {mfmsg.i 40 3}
			  undo, retry.
		       end.
		       if can-find(first wo_mstr where wo_nbr = nbr)   then do:
			  {mfmsg.i  505 2}
			  /* WORK ORDER ALREADY EXISTS WITH THAT NUMBER */
		       end.
/*JY008**	       dwn = 0.             **/
/*JY008**	       do while wo_nbr <> nbr and dwn < 100:        **/
/*JY008*/	       do while wo_nbr <> nbr and dwn <= 100:
/*JY008**	            dwn = dwn + 1.      **/
		            if wo_nbr = wonbrs[dwn] then do:
		               wonbrs[dwn] = nbr.
/*D966*/                                find wo_mstr exclusive where
/*G508
/*D966*/                                recid(wo_mstr) = worecno[dwn - mindwn + 1] */
/*G508*/                                recid(wo_mstr) = worecno[dwn]
/*D966*/                                no-error.

/*J027*/ /* Begin added block */
			     /* Updates for Joint Product WOs in the set */
			     if wo_joint_type <> "" then do:

				do for wo_mstr1:
				   for each wo_mstr1 where
				   wo_mstr1.wo_nbr =  wo_mstr.wo_nbr and
				   wo_mstr1.wo_lot <> wo_mstr.wo_lot:

				      find mrp_det where
				      mrp_dataset = "wo_mstr"
				      and mrp_part = wo_mstr1.wo_part
				      and mrp_nbr  = wo_mstr1.wo_nbr
				      and mrp_line = wo_mstr1.wo_lot no-error.
				      if available mrp_det then mrp_nbr = nbr.

				      find mrp_det where
				      mrp_dataset = "wo_scrap"
				      and mrp_part = wo_mstr1.wo_part
				      and mrp_nbr  = wo_mstr1.wo_nbr
				      and mrp_line = wo_mstr1.wo_lot no-error.
				      if available mrp_det then mrp_nbr = nbr.

				      if wo_mstr1.wo_joint_type = "5" then do:
					find mrp_det where
					mrp_dataset = "jp_det"
					and mrp_part = wo_mstr1.wo_part
					and mrp_nbr  = wo_mstr1.wo_nbr
					and mrp_line = wo_mstr1.wo_lot no-error.
					if available mrp_det then mrp_nbr = nbr.

					for each wod_det where
					wod_lot = wo_mstr1.wo_lot:
					   find mrp_det where
					   mrp_dataset  = "wod_det"
					   and mrp_part = wod_part
					   and mrp_nbr  = wod_nbr
					   and mrp_line = wod_lot
					   no-error.
					   if available mrp_det then
					   mrp_nbr = nbr.
					   wod_nbr = nbr.
					end.

					for each wr_route where wr_lot = wo_lot:
					   wr_nbr = nbr.
					end.
				      end. /* wo_joint_type = "5" */

				      wo_mstr1.wo_nbr = nbr.
				   end.
				end. /* do for wo_mstr1 */

				if wo_joint_type = "5" then do:
				   find mrp_det where mrp_dataset = "jp_det"
				   and mrp_part = wo_part and mrp_nbr  = wo_nbr
				   and mrp_line = wo_lot no-error.
				   if available mrp_det then mrp_nbr = nbr.
				end.
			     end. /* wo_joint_type <> "" */
			     if index("1234",wo_joint_type) = 0 then do:
/*J027*/ /* End added block */
/*GM39*/                      for each wod_det exclusive where wod_lot = wo_lot:
				   find mrp_det where mrp_dataset = "wod_det"
				   and mrp_part = wod_part and mrp_nbr = wod_nbr
				   and mrp_line = wod_lot no-error.
				   if available mrp_det then mrp_nbr = nbr.
				   wod_nbr = nbr.
				end.

/*GM39*/                      for each wr_route exclusive where wr_lot = wo_lot:
				   wr_nbr = nbr.
				end.
/*J027*/                     end.

			     find mrp_det where mrp_dataset = "wo_mstr"
			     and mrp_part = wo_part and mrp_nbr = wo_nbr
			     and mrp_line = wo_lot no-error.
			     if available mrp_det then mrp_nbr = nbr.

			     find mrp_det where mrp_dataset = "wo_scrap"
			     and mrp_part = wo_part and mrp_nbr = wo_nbr
			     and mrp_line = wo_lot no-error.
			     if available mrp_det then mrp_nbr = nbr.

			     wo_nbr = nbr.

			  end.
		       end.
		    end.
		 end.
/*JY008**/  end.  /**do dwn = mindwn to maxdwn   **/		 
		 
/*GUI*/ if global-beam-me-up then undo, leave.
  /* do on error undo, retry */
	      end.
	      
	   end.
	   else do:
	      repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

		 yn = no.
/*GO05*/ /*V8+*/
/*GO05*/         {mfgmsg10.i 12 1 yn} /* IS ALL INFO CORRECT? */
/*GO05*/         if yn = ? then undo mainloop, leave mainloop.   
		 leave.
	      end.
	      
/*GUI*/ if global-beam-me-up then undo, leave.

	      if yn then do:
		 do dwn = 1 to 100:
		    if worecno[dwn] <> ?
/*D966*/            and approve[dwn]
		    then do:
		       find wo_mstr exclusive where
		       recid(wo_mstr) = worecno[dwn] no-error.
		       if available wo_mstr then do:

/*D966*                   if wo_status begins "N" then wo_status = "P".
      *                   if wo_status begins "Y" then do: */

			  wo_status = "F".
			  find mrp_det where mrp_dataset = "wo_mstr"
			  and mrp_part = wo_part and mrp_nbr = wo_nbr
			  and mrp_line = wo_lot no-error.
			  if available mrp_det then do:
			     mrp_type = "SUPPLYF".
			     mrp_detail = "固定计划加工单".
			  end.
/*J027*/ /* Begin added block */
			  /* Updates for Joint Product WOs in the set */
			  if wo_joint_type <> "" then do:
			     do for wo_mstr1:
				for each wo_mstr1 where
				wo_mstr1.wo_nbr =  wo_mstr.wo_nbr and
				wo_mstr1.wo_lot <> wo_mstr.wo_lot:
				   wo_mstr1.wo_status = "F".
				   find mrp_det where mrp_dataset = "wo_mstr"
				   and mrp_part = wo_mstr1.wo_part
				   and mrp_nbr  = wo_mstr1.wo_nbr
				   and mrp_line = wo_mstr1.wo_lot no-error.
				   if available mrp_det then do:
				      mrp_type = "SUPPLYF".
				      mrp_detail = "固定计划加工单".
				   end.
				end.
			     end.
			  end.
/*J027*/ /* End added block */
                       end.
		    end.
		 end.
		 flag = 1.
		 leave.
	      end.
	    end.  
	end.     
/*GUI*/ if global-beam-me-up then undo, leave.

     end.
/*GUI*/ if global-beam-me-up then undo, leave.


     if flag = 0 then do:
	worecno[1] = ?.
	hide frame d.
	undo, leave.
     end.

     if wocnbr > "" then do:
	{mfnctrlb.i woc_ctrl woc_nbr wo_mstr wo_nbr wocnbr}
     end.

     hide frame d.

  end.
/*GUI*/ if global-beam-me-up then undo, leave.

/*GO05*/ hide frame b.
