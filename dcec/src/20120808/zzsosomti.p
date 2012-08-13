/* GUI CONVERTED from sosomti.p (converter v1.69) Wed Apr 24 17:34:22 1996 */
/* sosomti.p - UPDATE PART MASTER QTY REQUIRED FOR SALES ORDER BILL     */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 6.0      LAST MODIFIED: 08/31/90   BY: emb *D 040**/
/* REVISION: 6.0      LAST MODIFIED: 11/29/90   BY: emb *D 232**/
/* REVISION: 7.0      LAST MODIFIED: 09/04/91   BY: pma *F 003**/
/* REVISION: 7.0      LAST MODIFIED: 07/28/92   BY: emb *F817**/
/* REVISION: 7.3      LAST MODIFIED: 09/27/92   BY: jcd *G247**/
/* REVISION: 7.3      LAST MODIFIED: 11/02/92   BY: emb *G266**/
/* REVISION: 7.3      LAST MODIFIED: 03/09/93   BY: tjs *G789**/
/* REVISION: 7.3      LAST MODIFIED: 04/08/93   BY: tjs *G830**/
/* REVISION: 7.3      LAST MODIFIED: 07/06/93   BY: tjs *GA64**/
/* REVISION: 7.3      LAST MODIFIED: 08/10/93   BY: tjs *GD80**/
/* REVISION: 7.3      LAST MODIFIED: 02/15/94   BY: pxd *FL60**/
/* REVISION: 7.4      LAST MODIFIED: 10/31/94   BY: afs *H587**/
/* REVISION: 7.4      LAST MODIFIED: 05/19/95   BY: rxm *F0RS**/
/* REVISION: 7.4      LAST MODIFIED: 06/08/95   BY: jym *G0PG**/
/* REVISION: 7.4      LAST MODIFIED: 04/24/96   BY: rxm *G1QJ**/


	 /*********************************************************/
	 /* NOTES:   1. Patch FL60 sets in_level to a value       */
	 /*             of 99999 when in_mstr is created or      */
	 /*             when any structure or network changes are */
	 /*             made that affect the low level codes.     */
	 /*          2. The in_levels are recalculated when MRP   */
	 /*             is run or can be resolved by running the  */
	 /*             mrllup.p utility program.                 */
	 /*********************************************************/

	 {mfdeclre.i}

	 define shared variable sod_recno as recid.
	 define shared workfile sobfile no-undo
	    field sobpart like sob_part
	    field sobsite like sob_site
	    field sobissdate like sob_iss_date
	    field sobqtyreq like sob_qty_req
	    field sobconsume like sob_qty_req
	    field sobabnormal like sob_qty_req.

	 define variable prev_consume like sod_consume.
/*G247** define shared variable mfguser as character. **/
	 define variable i as integer.
	 define new shared variable qty like sod_qty_ord.
	 define new shared variable part as character format "x(18)".
	 define new shared variable eff_date as date.
	 define variable soc_sob_fcst as character.
	 define variable open_ref like sod_qty_ord.
/*G266*/ define variable sodreldate like mrp_rel_date.
/*G266*/ define variable mfg_lead like pt_mfg_lead.
/*G830*/ define shared variable prev_due like sod_due_date.
/*GA64*/ define shared variable prev_site like sod_site.
/*GA64*/ define variable fixed_date like sod_due_date.
/*G830*/ define variable offset like ps_lt_off.
/*GD80*/ define variable pm_code like pt_pm_code.
/*H587*/ define shared variable new_line  like mfc_logical.

/*G266*/ {mfdatev.i}

	 soc_sob_fcst = string(no).
	 {mfctrl01.i "mfc_ctrl" "soc_sob_fcst" soc_sob_fcst no}

	 find sod_det no-lock where recid(sod_det) = sod_recno.
/*H587*/ find first soc_ctrl no-lock no-error.

/*G266*/ /* Added section (moved here from sosomtu2.p) */

/*GA64*  find pt_mstr no-lock where pt_part = sod_part no-error. */
/*GA64*  find ptp_det no-lock where ptp_part = sod_part          */
/*GA64*  and ptp_site = sod_site no-error.                       */

/*GA64*** Added section */
/*G0PG if prev_due = ? then fixed_date = 01/12/1994.*/ /* See e.p j.p & g.p  */
/*G0PG*/ if prev_due = ? then fixed_date = today.
			 else fixed_date = prev_due.   /* and notes below:   */
	 /* sod_due_date plus prod struc leadtime offset gives sob_iss_date  */
	 /* which is used for MRP. When the user leaves the due date ? we    */
	 /* offset from 1/12/94 because a known date is reqd to place p.s.   */
	 /* leadtime offset in sob_iss_date. When due date changes, new      */
	 /* issue date is adjusted by number of days due date changed.       */

	 /* DUE DATE CHANGE, CALC NUMBER OF DAYS TO OFFSET */
/*H587*/ /* (If pricing by line, sob_due_date has already been set to */
/*H587*/ /* the correct date.)                                        */
/*H587** if fixed_date <> sod_due_date then do: **/
/*H587*/ if fixed_date <> sod_due_date and not new_line then do:
	    if sod_due_date <> ? then do:
	       {mfwday.i fixed_date sod_due_date offset sod_site}
	       if fixed_date < sod_due_date then offset = offset * -1.
	    end.
	    else do:
	       {mfwday.i fixed_date "01/12/1994" offset sod_site}
	       if fixed_date < 01/12/1994 then offset = offset * -1.
	    end.
	 end.
	 else offset = 0.
/*GA64*** End of added section */

	 /* update release dates and demand for CONFIG parts */
/*G789*  if can-find (first sob_det where sob_nbr = sod_nbr */
/*G789*  and sob_line = sod_line) then do:                  */

/*G789*/ for each sob_det where sob_nbr = sod_nbr and sob_line = sod_line
/*G789*/ break by sob_nbr:
/*GUI*/ if global-beam-me-up then undo, leave.


/*GA64***Delete block***********************************************************
/*G789*/    if first-of(sob_nbr) then do:                                      *
/*G830******                                                                   *
	*      if available pt_mstr then do:                                   *
	*         sodreldate = ?.                                              *
	*         if available ptp_det then mfg_lead = ptp_mfg_lead.           *
	*         else mfg_lead = pt_mfg_lead.                                 *
	*         {mfdate.i sodreldate sod_due_date mfg_lead sod_site}         *
	*      end.                                                            *
	*      else do:                                                        *
	*         sodreldate = sod_due_date.                                   *
	*         {mfhdate.i sodreldate -1 sod_site}                           *
	*      end.                                                            *
 *G830*******/                                                                 *
/*G830*/       if prev_due <> sod_due_date then do: /* Due date change */      *
/*G830*/          {mfwday.i prev_due sod_due_date offset sod_site} /*DaysChgd*/*
/*G830*/          if prev_due < sod_due_date then offset = offset * -1.        *
/*G830*/       end.                                                            *
/*G830*/       else offset = 0.                                                *
									       *
/*G789*/    end.                                                               *
									       *
/*G789*     for each sob_det where sob_nbr = sod_nbr and sob_line = sod_line:*/*
 *GA64*************************************************************************/

/*G0PG* CALCULATE YOUR OFFSET */
/*G0PG*/    assign offset = 0.
/*G0PG*/    find pt_mstr no-lock where pt_part = sod_part no-error.
/*G0PG*/    if avail pt_mstr then offset = pt_mfg_lead.
/*G0PG*/    find ptp_det no-lock where ptp_part = sod_part and
/*G0PG*/      ptp_site = sod_site no-error.
/*G0PG*/    if avail ptp_det then assign offset = ptp_mfg_lead.

/*G0PG*/    for each ps_mstr no-lock where
/*G0PG*/      ps_par = sod_part and
/*G0PG*/      ps_comp = sob_part and
/*G0PG*/        (sod_sob_rev = ? or
/*G0PG*/          (
/*G0PG*/            (
/*G0PG*/            ps_start <= sod_sob_rev or
/*G0PG*/            ps_start = ?
/*G0PG*/            )
/*G0PG*/            and
/*G0PG*/            (
/*G0PG*/            ps_end >= sod_sob_rev or
/*G0PG*/            ps_end = ?
/*G0PG*/            )
/*G0PG*/          )
/*G0PG*/        ):
/*G0PG*/      assign offset = offset - ps_lt_off.
/*G0PG*/    end.

/*G0PG
 *  /*H587**    if offset <> 0 then do: **/
 *  /*H587*/    if offset <> 0 and not new_line then do:
 *  /*G830*/       sodreldate = ?.
 *  /*G830*/       {mfdate.i sodreldate sob_iss_date offset sod_site}
 *                 sob_iss_date = sodreldate.
 *   /*GA64*/    end.
 *G0PG*/

/*F0RS
 * /*H587*/ else if new_line then do:
 * /*H587*/    sob_iss_date = sod_due_date.
 * /*H587*/ end.
 *   ****** sob_iss_date HAS ALREADY BEEN CORRECTLY SET WHEN THIS PROGRAM
 *          IS USED BY SALES ORDER MAINTENANCE.  WHEN USED BY SALES QUOTE
 *          MAINTENANCE, IT WAS UNDOING THE LEAD TIME OFFSET CALCULATION BY
 *   ****** RESETTING IT TO sod_due_date.
 *F0RS*/
/*G0PG*/    sodreldate = ?.
/*G0PG*/    {mfdate.i sodreldate sod_due_date offset sod_site}
/*G0PG*/     sob_iss_date = sodreldate.
	    sob_site = sod_site.

/*G0PG* WHEN THE SOD_DUE_DATE = ?, THEN NO MRP SHOULD BE CREATED.  IN THE  */
/*      CASE WHERE SOD_DUE_DATE WAS MODIFIED FROM A DATE VALUE TO ?, THE   */
/*      ORPHAN MRP_DET RECORDS DO NOT GET REMOVED.  THIS CODE ENSURES THAT */
/*      NO ORPHAN MRP_DET RECORDS WILL REMAIN.                             */

/*G0PG*/    if sod_due_date = ? then do:
/*G0PG*/      find mrp_det where mrp_nbr = sob_nbr and
/*G0PG*/        mrp_part = sob_part and
/*G0PG*/        mrp_dataset = "sob_det" and
/*G0PG*/        mrp_line = trim(string(sob_line,">>>")) + "-" + sob_feature
/*G0PG*/        no-error.
/*G0PG*/      if avail mrp_det then delete mrp_det.
/*G0PG*/    end. /*if due date = ? then do not create mrp_det */

/*GA64*/    if sod_confirm then do:
	       if sob_qty_req >= 0
	       then open_ref = max(sob_qty_req - max(sob_qty_iss,0),0).
	       else open_ref = min(sob_qty_req - min(sob_qty_iss,0),0).

	       if sod_confirm = no or sod_status > ""
	       or sod_fa_nbr > "" or sod_lot > ""
	       or sod_type > "" then open_ref = 0.

/*GA64*/       find pt_mstr where pt_part = sob_part no-lock no-error.
/*GD80*        if pt_pm_code <> "C" and sod_due_date <> ? then do: */
/*GD80*/       pm_code = pt_pm_code.
/*GD80*/       find ptp_det where ptp_part = pt_part and ptp_site = sob_site
/*GD80*/       no-lock no-error.
/*GD80*/       if available ptp_det then pm_code = ptp_pm_code.
/*GD80*/       if pm_code <> "C" and sod_due_date <> ? then do:
		  {mfmrw.i "sob_det" sob_part sob_nbr
		  "string(sob_line) + ""-"" + sob_feature" sob_parent
		  ? sob_iss_date open_ref "DEMAND" "客户订单零件"
		  sob_site}
/*GA64*/       end.

/*GA64*/    end.
	 end.
/*GUI*/ if global-beam-me-up then undo, leave.

/*G789*  end. */
/*G266*/ /* End of added section */

/*GA64*/ if sod_confirm then do:
	 if soc_sob_fcst = string(yes) then do:
	    if sod_type = ""
/*GA64*     and sod_confirm */
	    then
	    for each sob_det no-lock where sob_nbr = sod_nbr
	    and sob_line = sod_line:
	       find first sobfile where sobpart = sob_part
	       and sobsite = sob_site
/*G266*        and sobissdate = sod_due_date */
/*G266*/       and sobissdate = sob_iss_date
	       no-error.
	       if not available sobfile then do:
		  create sobfile.
		  assign sobpart = sob_part
			 sobsite = sod_site
/*G266*               sobissdate = sod_due_date. */
/*G266*/              sobissdate = sob_iss_date.
	       end.
	       if sod_consume then sobconsume = sobconsume + sob_qty_req.
			     else sobabnormal = sobabnormal + sob_qty_req.
	    end.
	    for each sobfile:
/*GUI*/ if global-beam-me-up then undo, leave.

	       {sobfc.i sobpart sobissdate sobconsume sobabnormal sobsite}
	    end.
/*GUI*/ if global-beam-me-up then undo, leave.

	 end.

	 if sod_status <> "FAS" and sod_fa_nbr = "" then do:

	    for each sob_det no-lock where sob_nbr = sod_nbr
	    and sob_line = sod_line:
	       open_ref = 0.
	       for each sobfile where sobpart = sob_part
	       and sobsite = sob_site
/*G266*/       and sobqtyreq <> 0:
		  open_ref = open_ref + sobqtyreq.
		  sobqtyreq = 0.
	       end.
	       open_ref = sob_qty_req - open_ref.

	       if open_ref = 0 then next.

/*GA64*/       find pt_mstr where pt_part = sob_part no-lock no-error.
	       find in_mstr exclusive-lock where in_part = sob_part
	       and in_site = sob_site no-error.
	       if not available in_mstr then do:
		  create in_mstr.
		  assign in_part = sob_part
			 in_site = sob_site.
/*G266*/                 in_mrp = yes.

/*FL60*/                 in_level = 99999.

/*FL60            find ptp_det no-lock where ptp_part = in_part     */
/*FL60            and ptp_site = in_site no-error.                  */
/*FL60            if available ptp_det then do:                     */
/*FL60               if ptp_pm_code = "D"                           */
/*FL60               then in_level = ptp_ll_drp.                    */
/*FL60               else in_level = ptp_ll_bom.                    */
/*FL60            end.                                              */
/*FL60            else if pt_pm_code <> "D"                         */
/*FL60            then in_level = pt_ll_code.                       */

		  find si_mstr where si_site = in_site no-lock no-error.
		  /*F003 - Get default costs based on site */
		  if available si_mstr
		  then assign in_gl_set = si_gl_set in_cur_set = si_cur_set.
/*GA64*           find pt_mstr where pt_part = sob_part no-lock no-error. */
		  if available pt_mstr
		  then assign in_abc = pt_abc
			  in_avg_int = pt_avg_int
			  in_cyc_int = pt_cyc_int.
	       end.

/*G1QJ*/       find pt_mstr where pt_part = sob_part no-lock no-error.
/*G1QJ*/       pm_code = pt_pm_code.
/*G1QJ*/       find ptp_det where ptp_part = pt_part and ptp_site = sob_site
/*G1QJ*/       no-lock no-error.
/*G1QJ*/       if available ptp_det then pm_code = ptp_pm_code.
/*G1QJ*/       if pm_code <> "C" then
	          in_qty_req = in_qty_req + open_ref.

	       /* UPDATE PART MASTER MRP FLAG */
/*G266*        {inmrp.i &part=sob_part &site=sob_site} */
	    end.
	    for each sobfile where sobqtyreq <> 0:
/*G1QJ*/       find pt_mstr where pt_part = sob_part no-lock no-error.
/*G1QJ*/       pm_code = pt_pm_code.
/*G1QJ*/       find ptp_det where ptp_part = pt_part and ptp_site = sob_site
/*G1QJ*/       no-lock no-error.
/*G1QJ*/       if available ptp_det then pm_code = ptp_pm_code.
/*G1QJ*/       if pm_code <> "C" then do:
	          find in_mstr exclusive-lock where in_part = sobpart
	          and in_site = sobsite no-error.
	          if available in_mstr then do:
		     in_qty_req = in_qty_req - sobqtyreq.
	          end.
/*G1QJ*/       end.

	       /* UPDATE PART MASTER MRP FLAG */
/*G266*        {inmrp.i &part=sobpart &site=sobsite} */

	       sobqtyreq = 0.
	    end.
	 end.
/*GA64*/ end. /* sod_confirm */
