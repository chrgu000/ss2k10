/* GUI CONVERTED from poporca3.p (converter v1.69) Thu Aug  1 15:50:12 1996 
*/
/* poporca3.p - PO RECEIPT Checking AP Vouchers etc                     */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.3     LAST MODIFIED: 04/19/93    BY: tjs *G964**/
/* REVISION: 7.3     LAST MODIFIED: 06/30/93    BY: dpm *GC87**/
/* REVISION: 7.3     LAST MODIFIED: 10/25/94    BY: cdt *FS78**/
/* REVISION: 7.3     LAST MODIFIED: 12/27/94    BY: bcm *F0BT**/
/* REVISION: 8.5     LAST MODIFIED: 01/04/95    BY: ktn *J041**/
/* REVISION: 8.5     LAST MODIFIED: 01/20/95    BY: taf *J038**/
/* REVISION: 8.5     LAST MODIFIED: 07/19/96    BY: kxn *J12S**/
/* Revision:    8.5         Last Modified: 03/14/2004     By: kevin         
**/
/***Note by kevin:
        change the default value of 'location' to in_user1*************/

/*J12S*/ {mfdeclre.i}
/*J038*/ define     shared variable vendlot like tr_vend_lot no-undo.
/*GC87*/ define     shared variable site like sr_site no-undo.
/*GC87*/ define     shared variable location like sr_loc no-undo.
/*GC87*/ define     shared variable lotref like sr_ref no-undo.
/*GC87*/ define     shared variable lotserial like sr_lotser no-undo.
	 define     shared variable total_lotserial_qty like pod_qty_chg.
	 define     shared variable lotserial_control as char.
	 define     shared variable cline as char.
/*GC87*/ define     shared variable line like pod_line format ">>>".
	 define     shared variable lotserial_qty like sr_qty no-undo.
	 define     shared variable pod_recno as recid.
	 define variable i as integer.

/*J12S*	 {mfdeclre.i}       */


	 find pod_det where recid(pod_det) = pod_recno no-lock no-error.

	       lotserial_control = "".
	       find pt_mstr where pt_part = pod_part no-lock no-error.
	       if available pt_mstr then lotserial_control = pt_lot_ser.

	       assign
	       site = ""
	       location = ""
/*J041	       lotserial = ""               */
	       lotref = ""
/*J038*/       vendlot = ""
	       lotserial_qty = pod_qty_chg
	       cline = string(line)
	       global_part = pod_part.

	       i = 0.
	       for each sr_wkfl no-lock where sr_userid = mfguser
	       and sr_lineid = cline:
		  i = i + 1.
		  if i > 1 then leave.
	       end.
	       if i = 0 then do:
		  site = pod_site.

		  /*location = pod_loc.*/                 /*marked by kevin,03/14/2004*/

/*added by kevin,03/14/2004*/
                                 if available pt_mstr then do:
                                        find in_mstr where in_site = 
pod_site and in_part = pod_part no-lock no-error.
                                        if available in_mstr then location = 
in_user1.
                                        else location = pod_loc.
                                 end.
                                 else do:
                                        location = pod_loc.
                                 end.
/*end added by kevin*/

/*FS78*/          /* For field service RTS orders default the serial # */
/*FS78*/          /* from the order.                                   */
/*J12S* /*FS78*/          if pod_rma_type <> "" then                   */
/*J12S*/          if pod_rma_type <> "" and lotserial = "" then
/*FS78*/             assign
/*FS78*/                lotserial = pod_serial.
	       end.
	       else
/*G443*        if i = 1 then do: */
/*G443*/       if i <> 0 then do:
		  find first sr_wkfl where sr_userid = mfguser
		  and sr_lineid = cline no-lock.
		  site = sr_site.
		  location = sr_loc.
		  lotserial = sr_lotser.
		  lotref = sr_ref.
/*J038*/          vendlot = sr_vend_lot.
	       end.

/*GA90* Check to see if there are open vouchered receipts on this line */
/*F0BT*/ /* But NOT for Supplier Schedules */
/*F0BT*/       if not pod_sched then
/*GA90*/       for each prh_hist no-lock where
/*GA90*/          prh_nbr = pod_nbr and
/*GA90*/          prh_line = pod_line and
/*GA90*/          prh_last_vo <> "":
/*GUI*/ if global-beam-me-up then undo, leave.

/*GA90*/          find ap_mstr where
/*GA90*/             ap_type = "VO" and
/*GA90*/             ap_ref = prh_last_vo
/*GA90*/          no-lock no-error.
/*GA90*/          if available ap_mstr and ap_open = yes then do:
/*GA90*/             {mfmsg02.i 2204 2 prh_receiver}
/*GA90*/             /* PO RECEIPT PREVIOUSLY VOUCHERED, REFERENCE: */
/*GA90*/             leave.
/*GA90*/          end.
/*GA90*/       end.
/*GUI*/ if global-beam-me-up then undo, leave.



