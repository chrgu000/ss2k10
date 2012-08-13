/* GUI CONVERTED from rsshmtp.p (converter v1.69) Thu May 30 14:32:31 1996 */
/* rsshmtp.p - Supplier Shipper Maintenance - Prompt for shipper line details */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*V8:ConvertMode=Maintenance                                   		*/
/* REVISION: 7.3          CREATED: 03/14/96           BY: vrn *G1NV*    */

/* This code was originally a part of rsshmtb.p. */

	{mfdeclre.i}

	define shared variable 		undo_blk like mfc_logical no-undo.
	define shared variable		trans_um like pt_um.
	define shared variable		trans_conv like pod_um_conv.
	define shared variable		multi_entry like mfc_logical no-undo.
	define shared variable		s_abs_recid as recid no-undo.
	define shared variable		global_order as character.
	define shared variable		global_recid as recid.
	define shared variable		qad_wkfl_id as character.
	define shared frame a.
        
        def shared var qty_asn like sr_qty.                 /*kevin*/
       def shared var line_asn like pod_line.              /*kevin*/
	
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
	   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
scx_part       colon 20 label "零件"
	   pt_desc1       at 46 no-label no-attr-space format "x(23)"
	   scx_po         colon 20 format "x(8)"
	   scx_line       skip (1)
	    qty_asn           colon 20 label "送货数量"                   /*kevin*/
	    line_asn         colon 51 label "ASN序"                       /*kevin*/
	   sr_qty         colon 20
	   trans_um
	   trans_conv     colon 51 label "换算"
	   sr_site        colon 20
	   sr_loc         colon 20
	   sr_lotser      colon 20
	   sr_ref         colon 20
	   multi_entry    colon 20
	 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space
	      NO-BOX THREE-D /*GUI*/.

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



	find abs_mstr where recid(abs_mstr) = s_abs_recid no-lock.

	mainblk:
	do on endkey undo, leave mainblk:
	   prompt-for
	   scx_part
	   scx_po
	   scx_line
	   with frame a editing:
	      assign
	      global_addr = abs_mstr.abs_shipfrom
	      global_site = abs_mstr.abs_shipto
	      global_order = input scx_po
	      global_part = input scx_part.

	      if frame-field = "scx_part" then do:

		 {mfnp05.i qad_wkfl qad_index1
		 "qad_key1 = qad_wkfl_id"
		 qad_key2 "input scx_part"}

		 if global_recid <> ? then do:
		    find scx_ref where recid(scx_ref) = global_recid no-lock.

		    if available scx_ref then
		    display scx_part scx_po scx_line with frame a.
		    global_recid = ?.
		 end.

	      end.

	      else
	      if frame-field = "scx_po" then do:

		 {mfnp05.i qad_wkfl qad_index1
		 "qad_key1 = qad_wkfl_id and qad_key2 begins input scx_part"
		 qad_key2 "string(input scx_part,""x(18)"") + input scx_po"}

		 if global_recid <> ? then do:
		    find scx_ref where recid(scx_ref) = global_recid no-lock.

		    if available scx_ref then
		    display scx_part scx_po scx_line with frame a.
		    global_recid = ?.
		 end.

	      end.

	      else
	      if frame-field = "scx_line" then do:

		 {mfnp05.i qad_wkfl qad_index2
		 "qad_key3 = qad_wkfl_id and qad_key4 begins input scx_po"
		 qad_key4
		 "string(input scx_po,""x(8)"") + string(input scx_line,""9999"")"}

		 if global_recid <> ? then do:
		    find pod_det where recid(pod_det) = global_recid no-lock.

		    if available pod_det then
		    display pod_part @ scx_part pod_line @ scx_line with frame a.
		    global_recid = ?.
		 end.

	      end.

	      else do:
		 status input.
		 readkey.
		 apply lastkey.
	      end.

	      if recno <> ? then do:
		 find pt_mstr where pt_part = qad_charfld[1] no-lock.
		 disp
		 pt_part @ scx_part
		 pt_desc1
		 qad_charfld[2] @ scx_po
		 qad_decfld[1] format ">>>9" @ scx_line
		 with frame a.
	      end.

	   end. /* prompt-for */
	end. /* do on endkey undo, leave mainblk */

	if keyfunction(lastkey) = "end-error" then
	   undo_blk = yes.
