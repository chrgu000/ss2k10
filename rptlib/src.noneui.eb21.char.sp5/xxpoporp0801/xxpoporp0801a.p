/* poporp8a.p - PURCHASE ORDER VENDOR SCHEDULE REPORT SUBROUTINE        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*K0NF*/
/*V8:ConvertMode=Report                                        */
/* REVISION: 6.0     LAST MODIFIED: 02/05/91    BY: RAM *D432**/
/* REVISION: 7.0     LAST MODIFIED: 06/09/92    BY: afs *F591**/
/* REVISION: 7.0     LAST MODIFIED: 09/17/92    BY: WUG *G159**/
/* REVISION: 7.3     LAST MODIFIED: 12/06/93    BY: WUG *GH73**/
/* REVISION: 7.3     LAST MODIFIED: 03/10/95    BY: dxk *F0MM**/
/* REVISION: 7.3     LAST MODIFIED: 09/11/95    BY: dxk *F0V5**/
/* REVISION: 8.6     LAST MODIFIED: 10/08/97    BY: GYK *K0NF*         */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 09/04/00   BY: *N0RC* Mark Brown       */
/* REVISION: 9.1      LAST MODIFIED: 08/16/00   BY: *N0KM* Mudit Mehta  */
/* $Revision: 1.8.1.6 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00J* */
/*-Revision end---------------------------------------------------------------*/

/* 以下为版本历史 */
/* SS - 090226.1 By: Ellen Xu */

/* SS - 090226.1 - B */
/* 固定 */
{xxmfdtitle.i "1+ "}

/* 临时表 */
{xxpoporp0801.i}

/*
{mfdeclre.i}
*/
/*N0KM*/ {gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

/*N0KM***********START COMMENTED****************
 * &SCOPED-DEFINE poporp8a_p_1 "SUPPLIER:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE poporp8a_p_2 "UM"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE poporp8a_p_3 "Item Number"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE poporp8a_p_4 "     Prior"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE poporp8a_p_5 "    Total"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE poporp8a_p_6 "  Future"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE poporp8a_p_7 "   Periods"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE poporp8a_p_8 " Periods"
 * /* MaxLen: Comment: */
 *N0KM**************END COMMENTED***************** */

/* ********** End Translatable Strings Definitions ********* */

/*K0NF*/ {wbrp02.i}


define shared variable vendor like po_vend.
define shared variable vendor1 like po_vend.
define shared variable buyer like po_buyer.
define shared variable buyer1 like po_buyer.
define shared variable ship like po_ship.
define shared variable ship1 like po_ship.
define shared variable part like pt_part.
define shared variable part1 like pt_part.
define shared variable site  like pod_site.
define shared variable site1 like pod_site.
define shared variable sel_inv like mfc_logical.
define shared variable sel_sub like mfc_logical.
define shared variable sel_mem like mfc_logical.
define shared variable start like ro_start.
define shared variable dwm as character.
define shared variable idays as integer.

define shared variable sdate as date extent 8.
define shared variable num_intervals as integer.
define shared variable i as integer.

define variable povend like po_vend.
define variable vendname like ad_name.
define variable desc1 like pt_desc1 format "x(27)".
define variable desc2 like pt_desc2 format "x(27)".
define variable um like pt_um.
define variable purchqty as decimal extent 8
      format "->>>>>>9.9<<<<<<".
define variable tot_qty as decimal
      format "->>>>>>>9.9<<<<<<<".
define variable prior_cum_net_req as decimal.   /*GH73*/
define variable cum_net_req as decimal.     /*GH73*/
define variable net_req as decimal.         /*GH73*/

/*F0V5*/ define variable old_db as character no-undo.
/*F0V5*/ define variable error-flag as integer no-undo.

/*
   form header
/*N0KM*
 * {&poporp8a_p_1} povend vendname skip(1)
 * {&poporp8a_p_4} at 32 space(3)
 *N0KM*/
/*N0KM*/ caps(getTermLabel("SUPPLIER",20)) + ": " + povend + " " +
/*N0KM*/ vendname  format "x(60)" skip(1)
/*N0KM*/ getTermLabelRt("PRIOR",10) at 32 format "x(10)" space(3)
   sdate[2] space(3) sdate[3] space(3)
   sdate[4] space(3) sdate[5] space(3)
   sdate[6] space(3) sdate[7] space(3)
/*N0KM*
 * {&poporp8a_p_6} skip
 * {&poporp8a_p_3}
 * {&poporp8a_p_2} at 29
 * {&poporp8a_p_7} space(3)
 *N0KM*/
/*N0KM*/ " " + getTermLabelRt("FUTURE",7) format "x(8)" skip
/*N0KM*/ getTermLabel("ITEM_NUMBER",20) format "x(20)"
/*N0KM*/ getTermLabel("UNIT_OF_MEASURE",2) format "x(2)" at 29
/*N0KM*/ " " + getTermLabelRt("PERIODS",9) format "x(10)" space(3)
   sdate[3] - 1 space(3) sdate[4] - 1 space(3)
   sdate[5] - 1 space(3) sdate[6] - 1 space(3)
   sdate[7] - 1 space(3) sdate[8] - 1 space(3)
/*N0KM*  {&poporp8a_p_8} space(3) {&poporp8a_p_5} skip */
/*N0KM*/       getTermLabelRt("PERIODS",8) format "x(8)" space(3)
/*N0KM*/       getTermLabelRt("TOTAL",9) format "x(9)" skip
   "--------------------------- --"
   "---------- ---------- ---------- ---------- ----------"
   "---------- ---------- ---------- -----------"
   with frame aa no-labels width 132 page-top no-attr-space.

/*F0V5 view frame phead.  */
   view frame aa.
*/

   for each po_mstr  where po_mstr.po_domain = global_domain and (  (po_stat <>
   "c" and po_stat <> "x")
   and (po_vend >= vendor and po_vend <= vendor1)
   and (po_buyer >= buyer and po_buyer <= buyer1)
   and (po_ship >= ship and po_ship <= ship1)
   and po_type <> "B"
   ) no-lock,
   each pod_det  where pod_det.pod_domain = global_domain and (  pod_nbr =
   po_nbr
/*GH73   and not pod_sched /*G159*/ */
/*F591*/ and pod_status <> "c" and pod_status <> "x" /* and pod_pur_cost <> 0 */
   and (pod_part >= part and pod_part <= part1)
   and (pod_site >= site and pod_site <= site1)
   and ((pod_type = " " and sel_inv = yes)
/*F0V5 *F0MM* and pod_po_db=global_db  */
   or  (pod_type = "S" and sel_sub = yes)
   or  (pod_type <> "" and pod_type <> "S" and sel_mem = yes))
   and ((pod_qty_ord - pod_qty_rcvd) >= 0 or pod_sched) /*GH73*/
   ) no-lock
/*F0V5   break by po_vend by pod_part with frame bb:  */
/*F0V5*/ break by po_vend by pod_part by pod_nbr with frame bb:


      if first-of (po_vend) then do:
     povend = po_vend.

/*F0V5*  find ad_mstr where ad_addr = po_vend no-lock no-wait no-error. */
/*F0V5*  if available ad_mstr then vendname = ad_name. */
/*F0V5*  else vendname = "". */

/*F0V5*/ if first-of(pod_nbr) then do:
/*F0V5*/   old_db = global_db.
/*F0V5*/   if global_db <> pod_po_db then do:
/*F0V5*/      {gprun.i ""gpalias3.p"" "(input pod_po_db, output error-flag)"}
/*F0V5*/   end.
/*F0V5*/   {gprun.i ""poporp5b.p"" "(input po_vend, output vendname)"}.
/*F0V5*/   if global_db <> old_db then do:
/*F0V5*/    {gprun.i ""gpalias3.p"" "(input old_db, output error-flag)"}
/*F0V5*/   end.
/*F0V5*/ end.

     page.
      end.

      if first-of (pod_part) then do:
     find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
     pod_part no-lock no-error.
     if available pt_mstr then
        assign
           desc1 = "   " + pt_desc1
           desc2 = "   " + pt_desc2
           um = pt_um.
     else
        assign
           desc1 = "   " + pod_desc
           desc2 = ""
           um = pod_um.
     /*    INITIALIZE VARIABLES */
     assign
        purchqty = 0
        tot_qty = 0.
      end.

      /*GH73 ADDED FOLLOWING SECTION TO HANDLE SCHEDULES PO'S*/
      if pod_sched then do:
     find sch_mstr  where sch_mstr.sch_domain = global_domain and  sch_type = 4
     and sch_nbr = pod_nbr
     and sch_line = pod_line
     and sch_rlse_id = pod_curr_rlse_id[1]
     no-lock no-error.

     if available sch_mstr then do:
        i = 1.

        prior_cum_net_req = max(sch_pcr_qty - pod_cum_qty[1],0).

        tot_qty = tot_qty + (prior_cum_net_req * pod_um_conv).

        loopc:
        do i = num_intervals + 1 to 1 by -1 on error undo, leave:
           if sch_pcs_date >= sdate[i]
           or (i = 1 and (sch_pcs_date = ? or sch_pcs_date < sdate[2]))
           then do:
          purchqty[i] = purchqty[i]
          + (prior_cum_net_req * pod_um_conv).

          leave loopc.
           end.
        end. /* loopb */

        for each schd_det no-lock
         where schd_det.schd_domain = global_domain and  schd_type = sch_type
        and schd_nbr = sch_nbr
        and schd_line = sch_line
        and schd_rlse_id = sch_rlse_id:
           cum_net_req = max(schd_cum_qty - pod_cum_qty[1],0).
           net_req = cum_net_req - prior_cum_net_req.
           prior_cum_net_req = cum_net_req.

           tot_qty = tot_qty + (net_req * pod_um_conv).

           loopd:
           do i = num_intervals + 1 to 1 by -1 on error undo, leave:
          if schd_date >= sdate[i]
          or (i = 1 and (schd_date = ? or schd_date < sdate[2]))
          then do:
             purchqty[i] = purchqty[i]
             + (net_req * pod_um_conv).

             leave loopd.
          end.
           end. /* loopb */
        end.
     end.
      end.                          /*GH73*/
      else do:                          /*GH73*/
     tot_qty = tot_qty + ((pod_qty_ord - pod_qty_rcvd) * pod_um_conv).

     loopb:
     do i = num_intervals + 1 to 1 by -1 on error undo, leave:
        if pod_due_date >= sdate[i]
        or (i = 1 and (pod_due_date = ? or pod_due_date < sdate[2]))
        then do:
           purchqty[i] = purchqty[i]
               + ((pod_qty_ord - pod_qty_rcvd) * pod_um_conv).
           leave loopb.
        end.
     end. /* loopb */
      end.                          /*GH73*/

      /*    DISPLAY PURCHASE ORDER TOTALS */
      if last-of (pod_part) and tot_qty <> 0 then do:
      /* SS - 090226.1 - B */
	/* 写入临时表 */
	CREATE ttxxpoporp0801.
	ASSIGN
	ttxxpoporp0801_pod_part = pod_part
	ttxxpoporp0801_desc1	= desc1
	ttxxpoporp0801_desc2 = desc2
	ttxxpoporp0801_um = um
	ttxxpoporp0801_purchqty[1] = purchqty[1]
	ttxxpoporp0801_purchqty[2] = purchqty[2]
	ttxxpoporp0801_purchqty[3] = purchqty[3]
	ttxxpoporp0801_purchqty[4] = purchqty[4]
	ttxxpoporp0801_purchqty[5] = purchqty[5]
	ttxxpoporp0801_purchqty[6] = purchqty[6]
	ttxxpoporp0801_purchqty[7] = purchqty[7]
	ttxxpoporp0801_purchqty[8] = purchqty[8]
	ttxxpoporp0801_tot_qty = tot_qty
	.

	if desc2 <> "" then do:
	ASSIGN
	ttxxpoporp0801_desc2 = desc2.
	end.
	/* SS - 090226.1 - E */

     /* SS - 090226.1 - B
      禁止标准输出
     if page-size - line-counter < 2 then page.
     display
     pod_part format "x(27)"
     um
     purchqty[1] format "->>>>>>9.9<<<<<<"
     purchqty[2] format "->>>>>>9.9<<<<<<"
     purchqty[3] format "->>>>>>9.9<<<<<<"
     purchqty[4] format "->>>>>>9.9<<<<<<"
     purchqty[5] format "->>>>>>9.9<<<<<<"
     purchqty[6] format "->>>>>>9.9<<<<<<"
     purchqty[7] format "->>>>>>9.9<<<<<<"
     purchqty[8] format "->>>>>>9.9<<<<<<"
     tot_qty format "->>>>>>>9.9<<<<<<<"
     with frame bb no-labels width 132 no-attr-space no-box.
     down 1 with frame bb.
     display desc1 @ pod_part
     with frame bb no-labels width 132 no-attr-space no-box.
     if desc2 <> "" then do:
        down 1 with frame bb.
        display desc2 @ pod_part
        with frame bb no-labels width 132 no-attr-space no-box.
     end.
           SS - 090226.1 - E */
      end.


	

   end. /* for each po_mstr */


   {mfrpexit.i}
/*K0NF*/ {wbrp04.i}

