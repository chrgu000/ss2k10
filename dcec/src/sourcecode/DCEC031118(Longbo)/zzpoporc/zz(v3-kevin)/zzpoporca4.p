/* GUI CONVERTED from poporca4.p (converter v1.69) Tue Jul 16 10:17:00 1996 */
/* poporca4.p - PURCHASE ORDER RECEIPT OVER RECEIPT TOLERANCE CHECKS    */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.3     LAST MODIFIED: 09/14/93    BY: tjs *GE59*          */
/* REVISION: 7.3     LAST MODIFIED: 05/27/93    BY: tjs *FO47*          */
/* REVISION: 7.3     LAST MODIFIED: 02/14/95    BY: WUG *G0F7*          */
/* REVISION: 7.3     LAST MODIFIED: 03/29/95    BY: bcm *G0JN*          */
/* REVISION: 7.3     LAST MODIFIED: 08/07/95    BY: jym *G0TP*          */
/* REVISION: 7.3     LAST MODIFIED: 09/12/95    BY: vrn *G0X3*          */
/* REVISION: 7.4     LAST MODIFIED: 10/06/95    BY: vrn *G0XW*          */
/* REVISION: 8.5     LAST MODIFIED: 09/09/95    by: mwd *J053*          */
/* REVISION: 8.5     LAST MODIFIED: 04/09/96    by: rxm *H0KH*          */
/* REVISION: 8.5     LAST MODIFIED: 07/16/96    BY: rxm *G1SV*          */
/* REVISION: 8.5     LAST MODIFIED: 12/30/03    BY: kevin             */
/*Note(kevin): change over tolerance action 
               from 'message' to 'error' and don't allow to continue   */

/*!
    poporca4.p - PERFORM TOLERANCE CHECKING FOR PO RECEIPTS
*/

/*!
NOT USED IN PO RETURNS (porvis.p)
*/

	 {mfdeclre.i}

	 define shared variable base_amt like pod_pur_cost.
	 define shared variable conv_to_pod_um like pod_um_conv.
	 define shared variable eff_date like glt_effdate.
	 define shared variable exch_rate like exd_rate.
	 define shared variable po_recno as recid.
	 define shared variable pod_recno as recid.
	 define shared variable total_lotserial_qty like pod_qty_chg.
	 define shared variable total_received like pod_qty_rcvd.
	 define shared variable updt_blnkt like mfc_logical.
/*G0TP*/ define shared variable updt_blnkt_list as character no-undo.

	 define variable divisor     like schd_discr_qty.
	 define variable newprice    like pod_pur_cost.
	 define variable overage_qty like pod_qty_rcvd.
	 define variable qty_open    like pod_qty_rcvd.
/*G0F7*/ define variable price_qty as dec.
/*G0TP*/ define variable w-int1 as integer no-undo.
/*G0TP*/ define variable w-int2 as integer no-undo.
/*G0XW*/ define variable dummy_disc like pod_disc_pct no-undo.
/*G0XW*/ define variable pc_recno as recid no-undo.

	 define buffer poddet for pod_det.

	 define output parameter undotran like mfc_logical no-undo.

	 undotran = yes.
	 do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

	    find first poc_ctrl no-lock.
	    find po_mstr where recid(po_mstr) = po_recno.
	    find pod_det where recid(pod_det) = pod_recno.
	    if pod_sched then do:
	       /*G0F7**************************
*              {gprun.i ""rcpccal.p"" "(input pod_part, input pod_pr_list,
*              input eff_date, input pod_um, input po_curr,
*              output newprice)"}
	       **G0F7*************************/

/*G0X3*/       /* Warn if the Max Order Qty is exceeded */
/*G0X3*/       if  pod_cum_qty[3] > 0 and total_lotserial_qty > 0 and
/*G0X3*/           pod_cum_qty[1] + total_lotserial_qty * pod_rum_conv >
/*G0X3*/                            pod_cum_qty[3] then do:
/*G0X3*/           {mfmsg.i 8232 2} /* CUM RCVD QTY GREATER OR EQUAL MAX
/*G0X3*/                            ORDER QTY FOR ORDER SELECTED*/
/*G0X3*/           if not batchrun then pause.
/*G0X3*/       end.

	       /*G0F7 ADDED FOLLOWING SECTION*/
	       {gprun.i ""rsplqty.p"" "(input pod_recno,
	       input (total_lotserial_qty * pod_rum_conv), output price_qty)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*G0XW*
.              {gprun.i ""rspccal.p"" "(input pod_part, input pod_pr_list,
.               input eff_date, input pod_um, input po_curr,
.               input price_qty,
.               output newprice)"}
.*G0XW*/

/*G0XW*/       {gprun.i ""gppccal.p""
		"(input        pod_part,
		  input        price_qty,
		  input        pod_um,
		  input        pod_um_conv,
		  input        po_curr,
		  input        pod_pr_list,
		  input        eff_date,
		  input        pod_pur_cost,
		  input        no,
		  input        dummy_disc,
		  input-output newprice,
		  output       dummy_disc,
		  input-output newprice,
		  output       pc_recno
		 )" }
/*GUI*/ if global-beam-me-up then undo, leave.




/*G1SV*/         /* IF NO LIST PRICE WAS FOUND LETS TRY TO CHECK FOR   */
		 /* A VP_Q_PRICE FOR THE ITEM.  IF WE CANT FIND ONE,   */
		 /* POD_PRICE WILL REMAIN AS IT WAS ORIGINALLY.        */

/*G1SV*/         if pc_recno = 0 then do:
/*G1SV*/           find first vp_mstr where vp_part = pod_part
/*G1SV*/           and vp_vend = po_vend no-lock no-error.
/*G1SV*/           if available vp_mstr then do:
/*G1SV*/              if price_qty >= vp_q_qty and pod_um = vp_um
/*G1SV*/              and vp_q_price > 0 and po_curr = vp_curr then
/*G1SV*/                 pod_pur_cost = vp_q_price.
/*G1SV*/           end.  /* IF AVAIL VP_MSTR */
/*G1SV*/        end.
/*G1SV*/        else
/*G1SV*/           pod_pur_cost = newprice.

	       /*G0F7 END SECTION*/

/*G1SV**
*              /*! DON'T CONVERT: WE LOOKED UP PRICE IN TRANSACTION CURRENCY */
* /*G0JN**       if newprice <> ? then pod_pur_cost = newprice * po_ex_rate.**/
* /*H0KH /*G0JN*/if newprice <> ? then pod_pur_cost = newprice. */
* /*H0KH*/       if pc_recno <> 0 then pod_pur_cost = newprice.
**G1SV*/

	       /* TOLERANCE CHECKING FOR SCHEDULED ORDERS */
	       divisor = 0.
	       qty_open = 0.
	       find last schd_det
	       where schd_type = 4
	       and schd_nbr = pod_nbr
	       and schd_line = pod_line
	       and schd_rlse_id = pod_curr_rlse_id[1]
	       and schd_date <= eff_date
	       no-lock no-error.
	       if available schd_det then do:
		  qty_open = max(schd_cum_qty - pod_cum_qty[1],0).
		  divisor = schd_discr_qty.
	       end.
	       else do:
		  find sch_mstr where sch_type = 4
		  and sch_nbr = pod_nbr
		  and sch_line = pod_line
		  and sch_rlse_id = pod_curr_rlse_id[1]
		  no-lock no-error.
		  if available sch_mstr then do:
		     qty_open = max(sch_pcr_qty - pod_cum_qty[1],0).
		     divisor = qty_open.
		  end.
	       end.
	       /*! CHECK PERCENT OVERSHIP*/
	       if divisor = 0 or
	       ((total_lotserial_qty * conv_to_pod_um - qty_open) * 100)
	       / divisor > poc_tol_pct
	       then do:
/*G0X3*           {mfmsg02.i 337 2 poc_tol_pct} */
/*G0X3*/        /*Overship % exceeds schedule as of <date> Tolerance: <pct> */
/*/*G0X3*/          {mfmsg03.i 8305 2 string(eff_date) string(poc_tol_pct) """"}*/      /*marked by kevin,2003/12/30*/
/*G0X3*/          {mfmsg03.i 8305 3 string(eff_date) string(poc_tol_pct) """"}  /*added by kevin,2003/12/30*/
/*G0X3*/          if not batchrun then pause.
                  undo,retry.                       /*added by kevin,2004/02/03*/
	       end.
	       /*! CHECK DOLLAR AMOUNT OVERSHIP*/
	       base_amt = pod_pur_cost.
	       if po_curr <> base_curr then
		  base_amt = base_amt / exch_rate.
	       overage_qty = (total_lotserial_qty * conv_to_pod_um) - qty_open.
	       if overage_qty < 0 then overage_qty = 0.
	       if overage_qty * base_amt > poc_tol_cst then do:
		  /*WARN OVERSHIPMENT COST EXCEEDS...*/
/*J053** /*FO47*/ if not available gl_ctrl then find first gl_ctrl no-lock. **/
/*FO47**          {mfmsg02.i 338 2 poc_tol_cst} **/
/*G0X3* /*FO47*/  {mfmsg02.i 338 2 "gl_symbol + string(poc_tol_cst)" } */
/*G0X3*/       /*Overship cost exceeds schedule as of <date> Tolerance: <amt> */
/*/*J053*/          {mfmsg03.i 8306 2 string(eff_date) string(poc_tol_cst) """"}*/      /*marked by kevin,2003/12/30*/
/*J053*/          {mfmsg03.i 8306 3 string(eff_date) string(poc_tol_cst) """"}  /*added by kevin,2003/12/30*/
/*J053* /*G0X3*/          {mfmsg03.i 8306 2 string(eff_date)         */
/*J053*                      "gl_symbol + string(poc_tol_cst)" """"} */
/*G0X3*/          if not batchrun then pause.
                  undo,retry.                       /*added by kevin,2004/02/03*/
	       end.

	    end.
	    else do:
	       /*! TOLERANCE CHECKING FOR NON-SCHEDULED ORDERS */
	       if (total_received > pod_qty_ord and pod_qty_ord > 0)
	       or (total_received < pod_qty_ord and pod_qty_ord < 0)
	       then do:
		  overage_qty = total_received - pod_qty_ord.
		  /*! CHECK PERCENT OVERSHIP*/
		  if (overage_qty / pod_qty_ord) * 100 > poc_tol_pct
		  then do:
		     /*Error Overshipment percentage exceeds...*/
		     {mfmsg02.i 337 3 poc_tol_pct}
		     undo, retry.
		  end.
		  /*! CHECK DOLLAR AMOUNT OVERSHIP*/
		  base_amt = pod_pur_cost.
		  if po_curr <> base_curr then
		     base_amt = base_amt / exch_rate.
		  if overage_qty < 0 then overage_qty = 0 - overage_qty.
		  if overage_qty * base_amt > poc_tol_cst then do:
/*J053* /*FO47*/     if not available gl_ctrl then find first gl_ctrl no-lock.*/
/*FO47**             {mfmsg02.i 338 2 poc_tol_cst} **/
/*J053*/             {mfmsg02.i 338 3 poc_tol_cst}
/*J053* /*FO47*/     {mfmsg02.i 338 3 "gl_symbol + string(poc_tol_cst)" }  */
		     /*Error Overshipment cost exceeds...*/
		     undo, retry.
		  end.

		  /*! If overshipment and a blanket order, give user option of
		     updating blanket order's release quantity */
		  if pod_blanket <> "" then do for poddet:
		     find poddet where
			poddet.pod_nbr = pod_det.pod_blanket and
			poddet.pod_line = pod_det.pod_blnkt_ln
		     no-error.
		     if available poddet and
			poddet.pod_status <> "C" and
			poddet.pod_status <> "X"
		     then do:
			/* Update blanket order release quantity? */
			{mfmsg01.i 389 1 updt_blnkt}

/*G0TP* * * UPDT_BLNKT_LIST IS A COMMA SEPARATED LIST OF ALL POD_LINE     *
 *          NUMBERS WHICH MUST HAVE THE BLANK PO RELEASE QUANTITY UPDATED *
 *G0TP*/

/*G0TP*/                if updt_blnkt then do:
/*G0TP*/                  if not can-do(updt_blnkt_list,string(poddet.pod_line))
/*G0TP*/                  then do:
/*G0TP*/                    updt_blnkt_list = updt_blnkt_list +
/*G0TP*/                      string(poddet.pod_line) + ",".
/*G0TP*/                  end. /* add to list */
/*G0TP*/                end. /* updt_blnkt = yes */

/*G0TP*     W-INT1 = THE POSITION THE LINE NUMBER NEEDING REMOVAL STARTS ON */
/*G0TP*     W-INT2 = THE POSITION THE COMMA AFTER THE LINE NUMBER IS ON     */
/*G0TP*/                else do:
/*G0TP*/                  if can-do(updt_blnkt_list,string(poddet.pod_line))
/*G0TP*/                  then do:
/*G0TP*/                    assign
/*G0TP*/                    w-int1 = index(updt_blnkt_list,
/*G0TP*/                      string(poddet.pod_line))
/*G0TP*/                    w-int2 = (index(substring(updt_blnkt_list,w-int1),
/*G0TP*/                      ",")) + w-int1 - 1
/*G0TP*/                    updt_blnkt_list =
/*G0TP*/                      substring(updt_blnkt_list,1,w-int1 - 1) +
/*G0TP*/                      substring(updt_blnkt_list,w-int2 + 1).
/*G0TP*/                  end. /* remove from list */
/*G0TP*/                end. /* updt_blnkt = no */

		     end. /* if available poddet */
		  end. /* if pod_blanket <> "" */
	       end.
	    end.
	    undotran = not undotran.
	    leave.

	 end.
/*GUI*/ if global-beam-me-up then undo, leave.

