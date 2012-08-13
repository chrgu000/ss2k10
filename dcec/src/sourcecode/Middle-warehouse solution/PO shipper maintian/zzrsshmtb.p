/* GUI CONVERTED from rsshmtb.p (converter v1.69) Fri Nov  8 17:03:40 1996 */
/* rsshmtb.p - Release Management Supplier Schedules                    */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* H074* changes  made here should be applied to posmrc1.p              */
/* REVISION: 7.3    LAST MODIFIED: 10/12/92           BY: WUG *G462*    */
/* REVISION: 7.3    LAST MODIFIED: 02/18/83           BY: WUG *G695*    */
/* REVISION: 7.3    LAST MODIFIED: 03/26/93           BY: WUG *G878*    */
/* REVISION: 7.3    LAST MODIFIED: 03/29/93           BY: WUG *G880*    */
/* REVISION: 7.3    LAST MODIFIED: 05/24/93           BY: WUG *GB29*    */
/* REVISION: 7.3    LAST MODIFIED: 06/10/93           BY: WUG *GB99*    */
/* REVISION: 7.3    LAST MODIFIED: 07/27/93           BY: WUG *GD77*    */
/* REVISION: 7.3    LAST MODIFIED: 09/20/93           BY: WUG *GF65*    */
/* REVISION: 7.3    LAST MODIFIED: 10/25/93           BY: WUG *GG66*    */
/* REVISION: 7.3    LAST MODIFIED: 12/23/93           BY: WUG *GI31*    */
/* REVISION: 7.4    LAST MODIFIED: 01/05/94           BY: dpm *H074*    */
/* REVISION: 7.3    LAST MODIFIED: 04/14/94           BY: WUG *GJ37*    */
/* REVISION: 7.4    LAST MODIFIED: 09/15/94           by: slm *GM62*    */
/* REVISION: 7.4    LAST MODIFIED: 10/23/94           by: dpm *GN52*    */
/* REVISION: 7.4    LAST MODIFIED: 11/01/94           BY: ame *GN88*    */
/* REVISION: 7.3    LAST MODIFIED: 11/09/94           BY: WUG *GN76*    */
/* REVISION: 7.3    LAST MODIFIED: 11/10/94           BY: WUG *GO39*    */
/* REVISION: 8.5    LAST MODIFIED: 11/29/94           BY: mwd *J034*    */
/* REVISION: 8.5    LAST MODIFIED: 12/09/94           by: taf *J038*    */
/* REVISION: 7.3    LAST MODIFIED: 12/23/94           BY: bcm *G09Z*    */
/* REVISION: 8.5    LAST MODIFIED: 01/03/95           by: ktn *J041*    */
/* REVISION: 8.5    LAST MODIFIED: 01/15/95           by: pma *J040*    */
/* REVISION: 7.3    LAST MODIFIED: 03/03/95           BY: WUG *G0G2*    */
/* REVISION: 7.3    LAST MODIFIED: 03/06/95           BY: jxz *G0GG*    */
/* REVISION: 8.5    LAST MODIFIED: 04/26/95           by: sxb *J04D*    */
/* REVISION: 7.4    LAST MODIFIED: 02/17/95           BY: vrn *G0TN*    */
/* REVISION: 8.5    LAST MODIFIED: 03/21/96           BY: vrn *G1NV*    */
/* REVISION: 8.5    LAST MODIFIED: 06/05/96           BY: rxm *G1XG*    */
/* REVISION: 8.5    LAST MODIFIED: 08/21/96           BY: *G1QH* Aruna P.Patil*/
/* REVISION: 8.5    LAST MODIFIED: 11/04/96           BY: *H0NW* Suresh Nayak */
/* REVISION: 8.5    LAST MODIFIED: 11/08/96           BY: *H0NL* Suresh Nayak */


/* SHIPPER MAINT SUBPROGRAM                                             */
/* Maintain list of contained items                                     */


	 {mfdeclre.i}


	 define input param abs_recid as recid.

	 define variable deassign like mfc_logical.
	 define variable del-yn like mfc_logical.
	 define variable i as integer.
	 define variable sr_item like pt_part.
	 define variable old_gwt like pt_net_wt.
	 define variable new_gwt like pt_net_wt.
	 define variable old_nwt like pt_net_wt.
	 define variable new_nwt like pt_net_wt.
	 define variable old_vol like abs_vol.
	 define variable new_vol like abs_vol.
	 define variable wt_conv as decimal.
	 define variable vol_conv as decimal.
	 define variable ship_db as character.
/*G1NV*  define variable qad_wkfl_id as character. */
/*G1NV*/ define new shared variable qad_wkfl_id as character.
	 define variable yn like mfc_logical.
/*J040*  define variable use_stat like ld_status.  */
	 define variable scheduled_orders_exist like mfc_logical.
/*GN76*/ define variable lotop as character.
/*GN76*/ define variable msg_ct as integer.
/*GN76*/ define variable undo_stat like mfc_logical no-undo.
/*J04D*/ define variable lotnext like wo_lot_next.
/*J04D*/ define variable lotprcpt like wo_lot_rcpt no-undo.
/*J038*/ define variable trans-ok like mfc_logical no-undo.

	 define new shared variable multi_entry like mfc_logical no-undo
		label "多记录".
	 define new shared variable cline as character.
	 define new shared variable lotserial_control like pt_lot_ser.
	 define new shared variable issue_or_receipt as character
		initial "收货".
	 define new shared variable total_lotserial_qty like sr_qty.
	 define new shared variable site like sr_site no-undo.
	 define new shared variable location like sr_loc no-undo.
	 define new shared variable lotserial like sr_lotser no-undo.
	 define new shared variable lotserial_qty like sr_qty no-undo.
	 define new shared variable trans_um like pt_um.
	 define new shared variable trans_conv like pod_um_conv.
	 define new shared variable transtype as character init "rct-po".
	 define new shared variable lotref like sr_ref no-undo.
	 define new shared variable loc like pt_loc.
	 define new shared variable change_db like mfc_logical.
	 define new shared variable msgref as character format "x(20)".
	 define new shared variable stat_recno as recid.
	 define new shared variable global_order as character.        /*GB99*/
	 define new shared variable eff_date as date.            /*GG66*/
/*G09Z*/ define new shared variable global_recid as recid.

/*G1NV*/ define variable total_received like pod_qty_rcvd.
/*G1NV*/ define variable base_amt like pod_pur_cost.
/*G1NV*/ define variable exch_rate like exd_rate.
/*G1NV*/ define variable dummy_logi	like mfc_logical no-undo.
/*G1NV*/ define new shared variable s_abs_recid as recid no-undo.
/*G1NV*/ define new shared variable undo_blk like mfc_logical no-undo.

	 define buffer abs_mstr_item for abs_mstr.

        def new shared var qty_asn like sr_qty.                 /*kevin*/
        def new shared var line_asn like pod_line.              /*kevin*/
        
/*J040**************DELETED STAT_WKFL****************************
*        define new shared workfile stat_wkfl no-undo
*          field podnbr like pod_nbr
*          field podline like pod_line
*          field assay like tr_assay initial ?
*          field grade like tr_grade initial ""
*          field expire like tr_expire initial ?
*          field rcpt_stat like ld_status initial ?.
**J040**********************************************************/

/*GN52*/ define workfile uom_abs
/*GN52*/       field uom_nbr     like pod_nbr
/*GN52*/       field uom_line    like pod_line
/*GN52*/       field uom_part    like pt_part
/*GN52*/       field uom_um      like pod_um
/*GN52*/       field uom_um_conv like pod_um_conv .


/*G1NV*/ define new shared frame a.

	 
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
	    
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
scx_part             colon 20 label "零件"
	    pt_desc1             at 46 no-label no-attr-space format "x(23)"
	    scx_po               colon 20 format "x(8)"
	    scx_line
	    skip(1)
	    qty_asn           colon 20 label "送货数量"                       /*kevin*/
	    line_asn         colon 51 label "ASN序"                         /*kevin*/
	    sr_qty               colon 20
	    trans_um
	    trans_conv           colon 51 label "换算"
	    sr_site              colon 20
	    sr_loc               colon 20
	    sr_lotser            colon 20
	    sr_ref               colon 20
	    multi_entry          colon 20
	  SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space
/*G0GG title "Contents (Items)".*/
/*G0GG*/     NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = " 内装物 (零件) ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



	 qad_wkfl_id = mfguser + "rsshmtb.p".

/*J04D*/ find first clc_ctrl no-lock no-error.
/*J04D*/ if not available clc_ctrl then do:
/*J04D*/    {gprun.i ""gpclccrt.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J04D*/    find first clc_ctrl no-lock.
/*J04D*/ end.

	 find abs_mstr where recid(abs_mstr) = abs_recid no-lock.
/*G1NV*/ s_abs_recid = abs_recid.

/*G1NV*/ find first poc_ctrl no-lock no-error.

/*GN52*
 *     trans_um = abs__qad02.
 *     trans_conv = dec(abs__qad03).
 *GN52*/

	 find ad_mstr where ad_addr = abs_shipfrom no-lock.


	 repeat for abs_mstr_item:
/*GUI*/ if global-beam-me-up then undo, leave.

/*GM62     for each sr_wkfl where sr_userid = mfguser: */
/*GM62*/   for each sr_wkfl exclusive-lock where sr_userid = mfguser:
	       delete sr_wkfl.
	    end.

/*GM62     for each qad_wkfl where qad_key1 = mfguser + "rsshmtb.p": */
/*GM62*/   for each qad_wkfl exclusive-lock
	   where qad_key1 = mfguser + "rsshmtb.p":
	       delete qad_wkfl.
	    end.

/*GN88* /*GN52*/ for each uom_abs :*/
/*GN88*/  for each uom_abs exclusive-lock :
/*GN52*/     delete uom_abs.
/*GN52*/  end.

	    for each abs_mstr_item no-lock
	    where abs_shipfrom = abs_mstr.abs_shipfrom
	    and abs_par_id = abs_mstr.abs_id
	    and abs_id begins "i",
	    each pod_det no-lock where pod_nbr = abs_order and
	    pod_line = integer(abs_line)
	    break by pod_nbr by pod_line:
	       if first-of(pod_line) then do:
		  create qad_wkfl.

		  assign
		  qad_key1 = qad_wkfl_id
		  qad_key2 = string(pod_part,"x(18)") + string(pod_nbr,"x(8)")   /*GI31*/
		     + string(pod_line,"9999")                                   /*GI31*/
		  qad_key3 = qad_wkfl_id
		  qad_key4 = string(pod_nbr,"x(8)") + string(pod_line,"9999")
		  qad_charfld[1] = pod_part
		  qad_charfld[2] = pod_nbr
		  qad_charfld[3] = pod_nbr
		  qad_decfld[1] = pod_line.
/*GN88* /*GM62*/ recno = recid(qad_wkfl).*/
/*GN88*/          if recid(qad_wkfl) = -1 then .

/*GN52*/          find first uom_abs where uom_nbr = pod_nbr
/*GN52*/                             and  uom_line = pod_line
/*GN52*/                             and  uom_part = pod_part no-error.
/*GN52*/          if not available uom_abs then do:
/*GN52*/             create uom_abs .
/*GN52*/             assign uom_nbr = pod_nbr
/*GN52*/                    uom_line = pod_line
/*GN52*/                    uom_part = pod_part
/*GN52*/                    uom_um   = abs_mstr_item.abs__qad02.
/*GN52*/                    uom_um_conv = dec(abs_mstr_item.abs__qad03).
/*GN52*/          end.
	       end.
	    end.


/*G1NV* Code moved to rsshmtp.p */
/*G1NV*	
.	    prompt-for
.	       scx_part
.	       scx_po
.	       scx_line
.	    with frame a editing:
.	       assign
.		  global_addr = abs_mstr.abs_shipfrom
.		  global_site = abs_mstr.abs_shipto
.		  global_order = input scx_po       /*GB99*/
.		  global_part = input scx_part.
.
.	       if frame-field = "scx_part" then do:
.		  {mfnp05.i qad_wkfl qad_index1
.		  "qad_key1 = qad_wkfl_id"
.		  qad_key2 "input scx_part"}
./*G09Z*/          if global_recid <> ? then do:
./*G09Z*/             find scx_ref where recid(scx_ref) = global_recid no-lock.
./*G09Z*/             if available scx_ref then
./*G09Z*/                display scx_part scx_po scx_line with frame a.
./*G09Z*/             global_recid = ?.
./*G09Z*/          end.
.	       end.
.	       else
.	       if frame-field = "scx_po" then do:
.		  {mfnp05.i qad_wkfl qad_index1
.		  "qad_key1 = qad_wkfl_id and qad_key2 begins input scx_part"
.		  qad_key2 "string(input scx_part,""x(18)"") + input scx_po"}
./*G09Z*/          if global_recid <> ? then do:
./*G09Z*/             find scx_ref where recid(scx_ref) = global_recid no-lock.
./*G09Z*/             if available scx_ref then
./*G09Z*/                display scx_part scx_po scx_line with frame a.
./*G09Z*/             global_recid = ?.
./*G09Z*/          end.
.	       end.
.	       else
.	       if frame-field = "scx_line" then do:
.		  {mfnp05.i qad_wkfl qad_index2
.		  "qad_key3 = qad_wkfl_id and qad_key4 begins input scx_po"
.		  qad_key4
.	      "string(input scx_po,""x(8)"") + string(input scx_line,""9999"")"}
./*G09Z*/          if global_recid <> ? then do:
./*G09Z*/             find pod_det where recid(pod_det) = global_recid no-lock.
./*G09Z*/             if available pod_det then
./*G09Z*/                display
.			   pod_part @ scx_part
.			   pod_line @ scx_line
.			with frame a.
./*G09Z*/             global_recid = ?.
./*G09Z*/          end.
.
.	       end.
.	       else do:
.		  status input.
.		  readkey.
.		  apply lastkey.
.	       end.
.
.	       if recno <> ? then do:
.		  find pt_mstr where pt_part = qad_charfld[1] no-lock.
.
.		  display
.		     pt_part @ scx_part
.		     pt_desc1
.		     qad_charfld[2] @ scx_po
.		     qad_decfld[1] format ">>>9" @ scx_line
.		  with frame a.
.	       end.
.	    end.
.*G1NV*/

/*G1NV*/ undo_blk = no.
/*/*G1NV*/ {gprun.i ""rsshmtp.p""}*/                  /*marked by kevin,10/28/2003*/
            {gprun.i ""zzrsshmtp.p""}                 /*kevin*/

/*GUI*/ if global-beam-me-up then undo, leave.

/*G1NV*/ if undo_blk = yes then undo, leave.

	    find po_mstr where po_nbr = input scx_po no-lock no-error.


	    if not available po_mstr then do:
	       {mfmsg.i 343 3}
	       undo, retry.
	    end.
	    else do:
	       if po_vend <> abs_mstr.abs_shipfrom then do:
		  {mfmsg.i 8201 3}
		  bell.
		  undo, retry.
	       end.
/*H0NW*/       if po_type = "B" then do:
/*H0NW*/          {mfmsg.i 385 3} /* BLANKET ORDER NOT ALLOWED */
/*H0NW*/          bell.
/*H0NW*/          undo, retry.
/*H0NW*/       end.
	    end.

	    /*GF65 HANDLING OF SCHEDULED/NONSCHEDULED ORDERS*/
	    find pod_det where pod_nbr = po_nbr
	    and pod_line = input scx_line
	    no-lock no-error.

	    if not available pod_det then do:
	       i = 0.

	       for each pod_det no-lock
	       where pod_part = input scx_part
	       and pod_nbr = po_nbr:
		  i = i + 1.
	       end.

	       if i > 1 then do:
		  {mfmsg.i 8247 3}
		  undo, retry.
	       end.
	       else
	       if i = 1 then do:
		  find first pod_det where pod_part = input scx_part
		  and pod_nbr = po_nbr
		  no-lock.
	       end.
	    end.

	    if not available pod_det then do:
	       {mfmsg.i 45 3}
	       undo, retry.
	    end.



	    if pod_site <> abs_mstr.abs_shipto then do:
	       {mfmsg.i 8202 3}
	       bell.
	       undo, retry.
	    end.

	    find pt_mstr where pt_part = pod_part no-lock no-error.

	    display
	       pod_part @ scx_part
	       pt_desc1 when (available pt_mstr)
	       pod_nbr @ scx_po
	       pod_line @ scx_line
	    with frame a.

	    find po_mstr where po_nbr = pod_nbr no-lock.

	    if pod_site <> abs_mstr.abs_shipto then do:
	       {mfmsg02.i 8233 3 pod_site}
	       undo, retry.
	    end.

/*GN76 CHECK WORK ORDER IF SUBCONTRACT*/
/*G1QH** THE PROGRAM rsshmtb1.p HAS BEEN OBSOLETED */
/*G1QH** {gprun.i ""rsshmtb1.p"" "(input pod_nbr, input pod_line, output undo_stat)"}  */
/*G1QH**   if undo_stat then undo, retry. */

/*G1QH** PICK UP CURRENTLY EFFECTIVE CUM ORDER */
/*G1QH*/    eff_date = today.
/*G1QH*/    {gprun.i ""poporca5.p""
                     "(input pod_nbr, input pod_line, input eff_date)"}
/*GUI*/ if global-beam-me-up then undo, leave.


	    if pod_start_eff[1] > today or pod_end_eff[1] < today then do:
	       {mfmsg.i 8204 2}
	       bell.
	    end.

	    if pod_cum_qty[1] >= pod_cum_qty[3]
	    and pod_cum_qty[3] > 0                       /*G878*/
	    then do:
	       {mfmsg.i 8232 2}
	    end.

/*GN52*/    find first uom_abs where uom_nbr = pod_nbr
/*GN52*/                     and  uom_line = pod_line
/*GN52*/                     and  uom_part = pod_part no-error.
/*GN52*/    if not available uom_abs then do:
/*GN52*/       create uom_abs .
/*GN52*/       assign uom_nbr = pod_nbr
/*GN52*/              uom_line = pod_line
/*GN52*/              uom_part = pod_part
/*GN52*/              uom_um   = pod_um.
/*GN52*/             uom_um_conv = pod_um_conv.
/*GN52*/    end.
/*GN52*/    if available uom_abs then do:
/*GN52*/      trans_um = uom_um.
/*GN52*/      trans_conv = uom_um_conv.
/*GN52*/    end.

	    i = 0.
	    total_lotserial_qty = 0.

            qty_asn = 0.                       /*kevin*/
            line_asn = 0.                      /*kevin*/

	    /*GD77 CHANGE PT_UM TO POD_UM*/
	    if trans_um = "" then trans_um = pod_um.

	    /*GD77 CHANGE 1 TO pOD_UM_CONV*/
	    if trans_conv = 0 then trans_conv = pod_um_conv.

	    for each abs_mstr_item no-lock
	    where abs_shipfrom = abs_mstr.abs_shipfrom
	    and abs_par_id = abs_mstr.abs_id
	    and abs_id begins "i"
	    and abs_order = pod_nbr
	    and abs_line = string(pod_line):
	       create sr_wkfl.

	       assign
		  sr_userid = mfguser
		  sr_site = abs_site
		  sr_loc = abs_loc
		  sr_lotser = abs_lotser
		  sr_ref = abs_ref
		  sr_qty = abs_qty / trans_conv.
/*GN88* /*GM62*/ recno = recid(sr_wkfl).*/
/*GN88*/       if recid(sr_wkfl) = -1 then .

	       i = i + 1.
	       total_lotserial_qty = total_lotserial_qty + sr_qty.
             
             qty_asn = abs_mstr_item.abs__dec01.              /*kevin*/
             line_asn = abs_mstr_item.abs__dec02.             /*kevin*/
                 
	    end.

	    multi_entry = no.
	    if i > 1 then do:
	       multi_entry = yes.

	       display
		  trans_um
		  trans_conv
	       /*GJ37 CHANGE ABS_SITE TO ABS_SHIPTO IN FOLLOWING*/
		  abs_mstr.abs_shipto @ sr_site
		  abs_mstr.abs_loc @ sr_loc
		  "" @ sr_lotser
		  "" @ sr_ref
		  "" @ sr_qty
		  multi_entry
	       with frame a.
	    end.
	    else
	    if i = 1 then do:
	       find first sr_wkfl where sr_userid = mfguser no-lock.

	       display
		  trans_um
		  trans_conv
		  sr_site
		  sr_loc
		  sr_lotser
		  sr_ref
		  sr_qty
		  multi_entry
	       with frame a.
	    end.
	    else do:
	       display
		  trans_um
		  trans_conv
		  abs_mstr.abs_shipto @ sr_site
		  pod_loc @ sr_loc
		  "" @ sr_lotser
		  "" @ sr_ref
		  "" @ sr_qty
		  multi_entry with frame a.
	    end.

	    ststatus = stline[3].
	    status input ststatus.

            do with frame a:

/*added by kevin,10/28/2003*/
               update qty_asn line_asn validate(line_asn <> 0,"错误:值必须大于零,请重新输入!").
/*end added by kevin,10/28/2003*/             
                
	       prompt-for
		  sr_qty
		  trans_um
		  trans_conv
		  sr_site
		  sr_loc
		  sr_lotser
		  sr_ref
		  multi_entry
	       editing:
		  assign
		     global_part = pod_part
		     global_site = input sr_site
		     global_loc  = input sr_loc
		     global_lot  = input sr_lotser.

		  readkey.
		  apply lastkey.
	       end.

	       assign
		  multi_entry
		  cline = ""
		  site = input sr_site
		  location = input sr_loc
		  lotserial = input sr_lotser
		  lotserial_qty = input sr_qty
		  trans_um = pod_um
		  trans_conv /*G880 = pod_um_conv */
		  lotref = input sr_ref
		  lotserial_control = if available pt_mstr then pt_lot_ser else ""
		  global_part = pod_part
		  trans_um
		  trans_conv.

/*J034*/       {gprun.i ""gpsiver.p"" "(input (input sr_site),
					input ?,
					output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/       if return_int = 0 then do:
/*J034*/          {mfmsg.i 725 3}  /* USER DOES NOT HAVE ACCESS TO SITE */
/*J034*/          undo, retry.
/*J034*/       end.

	       /*G880 if not trans_conv entered then do: */
/*G1XG	       if trans_conv = 1 and trans_um <> pt_um then do:  /*G880*/ */
/*G1XG*/       if trans_conv = 1 and available pt_mstr
/*G1XG*/       and trans_um <> pt_um then do:
		  {gprun.i ""gpumcnv.p"" "(input trans_um,
					   input pt_um,
					   input pt_part,
					   output trans_conv)"}
/*GUI*/ if global-beam-me-up then undo, leave.

		  if trans_conv = ? then do:
		     {mfmsg.i 33 2}
		     trans_conv = 1.
		  end.

		  disp trans_conv with frame a.
	       end.


	       /* If specified site is not defined ship-from site, */
	       /* make sure it's in the same database              */
	       if site <> abs_mstr.abs_shipto then do:
		  find si_mstr where si_site = abs_mstr.abs_shipto no-lock.
		  ship_db = si_db.
		  find si_mstr where si_site = site no-lock.
		  if si_db <> ship_db then do:
		     {mfmsg.i 8205 3}
		     bell.
		     next-prompt sr_site.
		     undo, retry.
		  end.
	       end.

	       if i > 1 or multi_entry then do:
/*J041*/          lotnext = "".
/*J041*/          lotprcpt = no.
/*J038*           {gprun.i ""icsrup.p"" "(input abs_mstr.abs_shipto)"}        */
/*J038* ADD POD_NBR AND STRING(POD_LINE) AS INPUTS TO ICSRUP.P                */
/*J038*/          {gprun.i ""icsrup.p"" "(input abs_mstr.abs_shipto,
					  input pod_nbr,
					  input string(pod_line),
					  input-output lotnext,
					  input lotprcpt)"}
/*GUI*/ if global-beam-me-up then undo, leave.

	       end.
	       else do trans:
/*GUI*/ if global-beam-me-up then undo, leave.


		  /* FOLLOWING CODE IN THIS BLOCK LIFTED FROM POPORCA.P */

		  if pod_type = "" then do:
		     /*CREATE LD_DET RECORD IF ASSAY, ETC HAS BEEN CHANGED*/
		     /*OR THERE IS AN ITEM DEFINED STATUS FOR THIS ITEM   */
	             eff_date = today.           /*GG66*/
/*J040               {gprun.i ""poporca1.p""} */
/*J040*/             {gprun.i ""poporca1.p"" "(input recid(pod_det))"}
/*GUI*/ if global-beam-me-up then undo, leave.

		     if msgref <> "" then do:
			msgref = trim(msgref).
			{mfmsg03.i 1914 3 msgref """" """"}
			/* # conflicts with existing inventory detail*/
			undo, retry.
		     end.
		  end.

		  /*DOES STATUS ALLOW RECEIPT AT RECEIPT SITE*/
/*J038******************* CHANGE ICEDIT.I TO ICEDIT.P ************************/
/*J038*           {icedit.i     **********************************************/
/*J038*              &transtype=""RCT-PO""                                   */
/*J038*              &site=site                                              */
/*J038*              &location=location                                      */
/*J038*              &part=global_part                                       */
/*J038*              &lotserial=lotserial                                    */
/*J038*              &lotref=lotref                                          */
/*J038*              &quantity="lotserial_qty * trans_conv"                  */
/*J038*              &um=trans_um                                            */
/*J038*           }                                                          */
/*J038********* CALL ICEDIT.P ************************************************/
/*J038*/          {gprun.i ""icedit.p"" "(input ""RCT-PO"",
					  input site,
					  input location,
					  input global_part,
					  input lotserial,
					  input lotref,
					  input lotserial_qty * trans_conv,
					  input trans_um,
					  input pod_nbr,
					  input string(pod_line),
					  output yn )"
		  }
/*GUI*/ if global-beam-me-up then undo, leave.

	 /*J038*/ if yn then undo, retry.

		  if pod_site <> site
		  and pod_type = ""
		  then do:
		     /*DOES STATUS ALLOW RECEIPT AT POD SITE*/
/*J038* ADD POD_NBR AND STRING(POD_LINE) AS INPUTS TO ICEDIT3.P             */
		     {gprun.i ""icedit3.p"" "(input ""RCT-PO"",
					      input pod_site,
					      input location,
					      input global_part,
					      input lotserial,
					      input lotref,
					      input lotserial_qty
						    * trans_conv,
					      input trans_um,
					      input pod_nbr,
					      input string(pod_line),
					      output yn)"
		     }
/*GUI*/ if global-beam-me-up then undo, leave.

		     if yn then undo, retry.

		     /*DOES STATUS ALLOW TRANSFER OUT OF  RECEIPT SITE*/
/*J038* ADD BLANKS FOR TRNBR AND TRLINE INPUTS TO ICEDIT3.P                 */
		     {gprun.i ""icedit3.p"" "(input ""ISS-TR"",
					      input pod_site,
					      input location,
					      input global_part,
					      input lotserial,
					      input lotref,
					      input lotserial_qty
						    * trans_conv,
					      input trans_um,
					      input """",
					      input """",
					      output yn)"
		     }
/*GUI*/ if global-beam-me-up then undo, leave.

		     if yn then undo, retry.

		     /*DOES STATUS ALLOW TRANSFER INTO RECEIPT SITE*/
/*J038* ADD POD_NBR AND STRING(POD_LINE) AS INPUTS TO ICEDIT3.P             */
		     {gprun.i ""icedit3.p"" "(input ""RCT-TR"",
					      input site,
					      input location,
					      input global_part,
					      input lotserial,
					      input lotref,
					      input lotserial_qty
						    * trans_conv,
					      input trans_um,
					      input pod_nbr,
					      input string(pod_line),
					      output yn)"
		     }
/*GUI*/ if global-beam-me-up then undo, leave.

		     if yn then undo, retry.
		  end.

		  find first sr_wkfl where sr_userid = mfguser
		  and sr_lineid = cline no-error.
		  if lotserial_qty = 0 then do:
		     if available sr_wkfl then do:
			total_lotserial_qty = total_lotserial_qty - sr_qty.
			delete sr_wkfl.
		     end.
		  end.
		  else do:
		     if available sr_wkfl then do:
			assign
			   total_lotserial_qty = total_lotserial_qty - sr_qty
			      + lotserial_qty
			   sr_site = site
			   sr_loc = location
			   sr_lotser = lotserial
			   sr_ref = lotref
			   sr_qty = lotserial_qty.
		     end.
		     else do:
			create sr_wkfl.
			assign
			   sr_userid = mfguser
			   sr_lineid = cline
			   sr_site = site
			   sr_loc = location
			   sr_lotser = lotserial
			   sr_ref = lotref
			   sr_qty = lotserial_qty.
			total_lotserial_qty = total_lotserial_qty
			   + lotserial_qty.
/*GN88* /*GM62*/        recno = recid(sr_wkfl).*/
/*GN88*/                if recid(sr_wkfl) = -1 then .
		     end.
		  end.
	       end.
/*GUI*/ if global-beam-me-up then undo, leave.


/*G1NV*/       /* HERE WE DO OUR OVER-RECEIPT TOLERANCE CHECKS */
/*G1NV*/       base_amt = pod_pur_cost.
/*G1NV*/       if base_curr <> po_curr then do:
/*G1NV*/          if po_fix_rate = no then do:
/*G1NV*/             find last exd_det where exd_curr = po_curr and
/*G1NV*/             exd_eff_date <= today and
/*G1NV*/             exd_end_date >= today no-lock no-error.
/*G1NV*/             if not available exd_det then do:
/*G1NV*/	        {mfmsg.i 81 2}
/*G1NV*/	  	/* EXCHANGE RATE DOES NOT EXIST */
/*G1NV*/	        exch_rate = 1.0.
/*G1NV*/             end.
/*G1NV*/             else exch_rate = exd_rate.
/*G1NV*/          end.
/*G1NV*/          else exch_rate = po_ex_rate.
/*G1NV*/       end.
/*G1NV*/       else exch_rate = 1.0.

/*G1NV*/       base_amt = base_amt / exch_rate.
/*G1NV*/       if po_curr <> base_curr then base_amt = base_amt / exch_rate.
/*G1NV*/       total_received = pod_qty_rcvd
/*G1NV*/          + (total_lotserial_qty * trans_conv / pod_um_conv).
/*G1NV*/       if pod_sched or (not pod_sched and
/*G1NV*/       (total_received > pod_qty_ord and pod_qty_ord > 0) or
/*G1NV*/       (total_received < pod_qty_ord and pod_qty_ord < 0)) then do:
/*G1NV*/    	  /* Receipt tolerance checking and max order qty */
/*G1NV*/          {gprun.i ""rsporct.p""
	           "(input total_lotserial_qty * trans_conv ,
	             input recid(po_mstr),
		     input recid(pod_det),
	             input abs_mstr.abs_shp_date,
		     input poc_tol_pct,
		     input poc_tol_cst,
	             input base_amt,
		     input yes,
		     input no,
		     output dummy_logi)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*G1NV*/       end.

	    end. /* do with frame a */

   /*GN76 ADDED FOLLOWING SECTION*/
   if pod_type = "s" then do:
      find wo_mstr where wo_lot = pod_wo_lot no-lock.

      if wo_type = "c" and wo_nbr = "" then do:

	 /*G0G2 COMMENTED FOLLOWING SECTION*********
      .  find wr_route where wr_lot = pod_wo_lot and wr_op = pod_op no-lock.
      .
      .  /*CHECK INPUT QUEUE*/
      .  {gprun.i ""rechkq.p""
      .  "(input wr_lot, input wr_op,
      .  input ""i"",
      .  input (- total_lotserial_qty),
      .  input-output msg_ct)"}
	 **G0G2 END SECTION************************/

	 /*G0G2 ADDED FOLLOWING SECTION*/
	 define buffer prev_wr_route for wr_route.
	 define variable inputq_op as integer.
	 define variable inputq_qty_chg as decimal.
	 find wr_route where wr_lot = pod_wo_lot and wr_op = pod_op no-lock.

	 find last prev_wr_route
	 where prev_wr_route.wr_lot = wr_route.wr_lot
	 and prev_wr_route.wr_op < wr_route.wr_op
	 no-lock no-error.

	 if available prev_wr_route then do:
	    {gprun.i ""reiqchg.p""
	    "(input wr_route.wr_lot, input wr_route.wr_op,
	    input total_lotserial_qty,
	    output inputq_op, output inputq_qty_chg)"}
/*GUI*/ if global-beam-me-up then undo, leave.


	    /*CHECK INPUT QUEUE OF THIS OR THE PRIOR NONMILESTONE OP*/
	    {gprun.i ""rechkq.p""
	    "(input wr_route.wr_lot, input inputq_op,
	    input ""i"",
	    input inputq_qty_chg,
	    input-output msg_ct)"}
/*GUI*/ if global-beam-me-up then undo, leave.

	 end.
	 /*G0G2 END SECTION*/
      end.
   end.
   /*GN76 END SECTION*/


	    old_vol = 0.
	    old_gwt = 0.
	    old_nwt = 0.

	    update_trans:
	    do trans:
/*GUI*/ if global-beam-me-up then undo, leave.

	       for each abs_mstr_item exclusive-lock
	       where abs_shipfrom = abs_mstr.abs_shipfrom
	       and abs_par_id = abs_mstr.abs_id
	       and abs_id begins "i"
	       and abs_order = pod_nbr
	       and abs_line = string(pod_line):
		  old_vol = old_vol + abs_vol.
		  old_gwt = old_gwt + abs_gwt.
		  old_nwt = old_nwt + abs_nwt.
		  delete abs_mstr_item.
	       end.

	       i = 0.

	       find abs_mstr where recid(abs_mstr) = abs_recid exclusive-lock.

	       new_nwt = 0.
	       new_gwt = 0.
	       new_vol = 0.

	       for each sr_wkfl exclusive-lock

	       where sr_userid = mfguser:
/*GUI*/ if global-beam-me-up then undo, leave.

		  i = i + 1.
		  create abs_mstr_item.

		  assign
		  abs_shipfrom = abs_mstr.abs_shipfrom
		  abs_id = "i" + abs_mstr.abs_id +
		  string(pod_nbr,"x(8)") + string(pod_line,"9999") + string(i,"9999")
		  abs_par_id = abs_mstr.abs_id
		  abs_item = pod_part
		  abs_site = sr_site
		  abs_loc = sr_loc
		  abs_lotser = sr_lotser
		  abs_ref = sr_ref
		  abs_qty = sr_qty * trans_conv
		  abs_dataset = "pod_det"
		  abs_order = pod_nbr
		  abs_line = string(pod_line)
		  abs_type = "r".
/*GN88* /*GM62*/ recno = recid(abs_mstr_item).*/
/*GN88*/       if recid(abs_mstr_item) = -1 then .

/*J038*  CALL GPICLT.P TO CHECK FOR AND ADD THE LOT/SERIAL TO THE LOT_MSTR */
/*J04D*/          if (clc_lotlevel <> 0) and (sr_lotser <> "") then do:
/*J038*/             {gprun.i ""gpiclt.p"" "(input pod_part,
					     input sr_lotser,
					     input pod_nbr,
					     input string(pod_line),
					     output trans-ok)" }
/*GUI*/ if global-beam-me-up then undo, leave.

/*J038*/             if not trans-ok then do:
/*J038*/                {mfmsg.i 2740 4}  /* CURRENT TRANSACTION REJECTED --  */
/*J04D*/                undo, next.       /* CONTINUE WITH NEXT TRANSACTION   */
/*J038*/             end. /* IF NOT TRANS-OK THEN DO: */
/*J038*/          end. /* IF CLC_LOTLEV <> 0 ... */

/*H0NL*/	  assign
/*H0NL*/	     abs_mstr_item.abs__qad02 = trans_um
/*H0NL*/	     abs_mstr_item.abs__qad03 = string(trans_conv).

/*added by kevin, 10/28/2003*/
               assign abs_mstr_item.abs__dec01 = qty_asn
                      abs_mstr_item.abs__dec02 = line_asn.
/*end added by kevin, 10/28/2003*/

		  delete sr_wkfl.
	       end.
/*GUI*/ if global-beam-me-up then undo, leave.


/*GN52*****
 *             assign
 *             abs_mstr.abs__qad02 = trans_um
 *             abs_mstr.abs__qad03 = string(trans_conv).
 *GN52***/
	    end.
/*GUI*/ if global-beam-me-up then undo, leave.


/*GM62      for each sr_wkfl where sr_userid = mfguser: */
/*GM62*/    for each sr_wkfl exclusive-lock where sr_userid = mfguser:
	       delete sr_wkfl.
	    end.

/*GM62      for each qad_wkfl where qad_key1 = mfguser + "rsshmtb.p": */
/*GM62*/    for each qad_wkfl exclusive-lock where
	       qad_key1 = mfguser + "rsshmtb.p":
	       delete qad_wkfl.
	    end.
/*GN88* /*GN52*/ for each uom_abs :*/
/*GN88*/    for each uom_abs exclusive-lock :
/*GN52*/       delete uom_abs.
/*GN52*/    end.

	 end.
/*GUI*/ if global-beam-me-up then undo, leave.

/*G0TN*/ hide frame a.
