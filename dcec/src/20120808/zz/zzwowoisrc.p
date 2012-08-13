/* GUI CONVERTED from wowoisrc.p (converter v1.69) Wed Feb  5 17:32:13 1997 */
/* wowoisrc.p - WORK ORDER RECEIPT BACKFLUSH                            */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 6.0     LAST MODIFIED: 05/24/90    BY: emb                 */
/* REVISION: 6.0     LAST MODIFIED: 03/14/91    BY: emb *D413*          */
/* REVISION: 6.0     LAST MODIFIED: 04/24/91    BY: ram *D581*          */
/* REVISION: 6.0     LAST MODIFIED: 07/02/91    BY: emb *D741*          */
/* REVISION: 6.0     LAST MODIFIED: 07/02/91    BY: emb *D744*          */
/* REVISION: 6.0     LAST MODIFIED: 08/29/91    BY: emb *D841*          */
/* REVISION: 6.0     LAST MODIFIED: 10/03/91    BY: alb *D887*          */
/* REVISION: 6.0     LAST MODIFIED: 11/27/91    BY: ram *D954*          */
/* REVISION: 7.0     LAST MODIFIED: 01/28/92    BY: pma *F104*          */
/* REVISION: 7.0     LAST MODIFIED: 09/11/92    BY: ram *F896*          */
/* REVISION: 7.3     LAST MODIFIED: 09/30/92    BY: ram *G115*          */
/* REVISION: 7.3     LAST MODIFIED: 10/21/92    BY: emb *G216*          */
/* REVISION: 7.3     LAST MODIFIED: 09/27/93    BY: jcd *G255*          */
/* REVISION: 7.3     LAST MODIFIED: 11/09/92    BY: emb *G292*          */
/* REVISION: 7.3     LAST MODIFIED: 02/03/93    BY: fwy *G630*(rev only)*/
/* REVISION: 7.3     LAST MODIFIED: 02/09/93    BY: emb *G656*(rev only)*/
/* REVISION: 7.3     LAST MODIFIED: 03/04/93    BY: ram *G782*          */
/* REVISION: 7.3     LAST MODIFIED: 07/06/93    BY: pma *GD11*(rev only)*/
/* REVISION: 7.3     LAST MODIFIED: 08/18/93    BY: pxd *GE21*(rev only)*/
/* REVISION: 7.3     LAST MODIFIED: 09/08/93    BY: emb *GE91*          */
/* REVISION: 7.3     LAST MODIFIED: 09/15/93    BY: ram *GF19*(rev only)*/
/* REVISION: 7.4     LAST MODIFIED: 07/22/93    BY: pcd *H039*          */
/* REVISION: 7.2     LAST MODIFIED: 02/17/94    BY: ais *FL87*          */
/* Oracle changes (share-locks)    09/15/94           BY: rwl *GM56*    */
/* REVISION: 7.2     LAST MODIFIED: 09/28/94    BY: ljm *GM78*          */
/* REVISION: 7.3     LAST MODIFIED: 10/31/94    BY: wug *GN76*          */
/* REVISION: 8.5     LAST MODIFIED: 12/08/94    BY: mwd *J034*          */
/* REVISION: 8.5     LAST MODIFIED: 12/09/94    BY: taf *J038*          */
/* REVISION: 8.5     LAST MODIFIED: 01/05/95    BY: ktn *J041*          */
/* REVISION: 8.5     LAST MODIFIED: 01/05/95    BY: pma *J040*          */
/* REVISION: 8.5     LAST MODIFIED: 03/08/95    BY: dzs *J046*          */
/* REVISION: 7.2     LAST MODIFIED: 04/13/95    BY: srk *G0KT*          */
/* REVISION: 8.5     LAST MODIFIED: 10/03/95    BY: tjs *J082*          */
/* REVISION: 8.5     LAST MODIFIED: 11/01/95    BY: tjs *J08X*          */
/* REVISION: 7.3     LAST MODIFIED: 12/12/95    BY: rvw *G1FL*          */
/* REVISION: 8.5     LAST MODIFIED: 03/06/96    BY: kxn *J09C*          */
/* REVISION: 8.5     LAST MODIFIED: 01/18/96    BY: bholmes *J0FY*      */
/* REVISION: 8.5     LAST MODIFIED: 04/15/96    BY: *J04C* Sue Poland    */
/* REVISION: 8.5     LAST MODIFIED: 04/15/96    BY: *J04C* Markus Barone */
/* REVISION: 8.5     LAST MODIFIED: 04/18/96    BY: jym *G1Q9*          */
/* Revision  8.5     Last Modified: 04/26/96    BY: BHolmes *J0KF*      */
/* Revision  8.5     Last Modified: 06/24/96    BY: RWitt   *G1XY*      */
/* Revision  8.5     Last Modified: 07/08/96    BY: kxn     *J0Y1*      */
/* Revision  8.5     Last Modified: 07/16/96    BY: kxn     *J0QX*      */
/* Revision  8.5     Last Modified: 07/23/96    BY: GWM     *J10N*      */
/* Revision  8.5     Last Modified: 02/04/97    BY: *J1GW* Murli Shastri*/
/* Revision  8.5     Last Modified: 11/28/03    BY: *LB01* Long Bo      */


define input parameter wosublot like wod_lot.
define input parameter wosubqty like pod_qty_chg.


	/** {mfdtitle.i "++ "}*/
/*G1Q9*/ define new shared variable gldetail like mfc_logical no-undo init no.
/*G1Q9*/ define new shared variable gltrans like mfc_logical no-undo init no.
	 define new shared variable rmks like tr_rmks.
	 define new shared variable serial like tr_serial.
	 define new shared variable conv like um_conv
	    label "换算因子" no-undo.
	 define new shared variable reject_conv like conv no-undo.
	 define new shared variable pl_recno as recid.
	 define new shared variable close_wo like mfc_logical label "结算".
	 define new shared variable undo_all like mfc_logical no-undo.

	 define new shared variable comp like ps_comp.
	 define new shared variable qty like wo_qty_ord.
	 define new shared variable leadtime like pt_mfg_lead.
	 define new shared variable prev_status like wo_status.
	 define new shared variable prev_release like wo_rel_date.
	 define new shared variable prev_due like wo_due_date.
	 define new shared variable prev_qty like wo_qty_ord.
	 define new shared variable prev_site like wo_site.
	 define new shared variable del-yn like mfc_logical.
	 define new shared variable deliv like wod_deliver.
	 define new shared variable any_issued like mfc_logical.
/*F896*/ define new shared variable any_feedbk like mfc_logical.

	 define new shared variable part like wod_part.
	 define variable issue like mfc_logical label "回冲" initial yes.
	 define variable receive like mfc_logical label "收货" initial yes.
/*J046   define variable nbr like wo_nbr.              **/
/*J046*/ define new shared variable nbr like wo_nbr.
	 define variable qwopen like wod_qty_all label "短缺量".
/*J046   define variable yn like mfc_logical.          **/
/*J046*/ define new shared variable yn like mfc_logical.
/*J046*/ define new shared variable sf_cr_acct like dpt_lbr_acct.
/*J046*/ define new shared variable sf_dr_acct like dpt_lbr_acct.
/*J046*/ define new shared variable sf_cr_cc like dpt_lbr_cc.
/*J046*/ define new shared variable sf_dr_cc like dpt_lbr_cc.
/*J046*/ define new shared variable sf_cr_proj like glt_project.
/*J046*/ define new shared variable sf_dr_proj like glt_project.
/*J046*/ define new shared variable sf_gl_amt like tr_gl_amt.
/*J046*/ define new shared variable sf_entity like en_entity.
	 define new shared variable eff_date like glt_effdate.
	 define  shared variable ref like glt_ref.
	 define variable desc1 like pt_desc1.
/*J046   define variable i as integer.                 **/
/*J046*/ define new shared variable i as integer.
	 define variable trqty like tr_qty_chg.
	 define variable trlot like tr_lot.
	 define variable qty_left like tr_qty_chg.
	 define new shared variable wopart_wip_acct like pl_wip_acct.
	 define new shared variable wopart_wip_cc like pl_wip_cc.
	 define variable j as integer.
/*       define shared variable mfguser as character.           *G255* */
	 define new shared variable wo_recno as recid.
	 define new shared variable site like sr_site no-undo.
	 define new shared variable location like sr_loc no-undo.
	 define new shared variable lotref like sr_ref format "x(8)" no-undo.
	 define new shared variable lotserial like sr_lotser no-undo.
	 define new shared variable lotserial_qty like sr_qty no-undo.
	 define new shared variable multi_entry like mfc_logical label "多记录"
	    no-undo.
	 define new shared variable lotserial_control as character.
	 define new shared variable cline as character.
	 define new shared variable row_nbr as integer.
	 define new shared variable col_nbr as integer.
	 define new shared variable issue_or_receipt as character
	    initial "发放".
	 define new shared variable total_lotserial_qty like wod_qty_chg.
	 define new shared variable wo_recid as recid.
	 define new shared variable wod_recno as recid.
/*G0KT*/ define new shared variable outta_here like mfc_logical initial "no" no-undo.
/*G1FL*/ define new shared variable rejected   like mfc_logical initial "no" no-undo.
/*G1XY*/ define new shared variable critical-part like wod_part no-undo.

	 define variable tot_lad_all like lad_qty_all.
	 define variable ladqtychg like lad_qty_all.

	 define variable sub_comp like mfc_logical label "发放代用品".
	 define variable firstpass like mfc_logical.
	 define variable cancel_bo like mfc_logical label "取消欠交量".

/*G292*  define variable fas_wo_rec as character. */
/*G292*/ define variable fas_wo_rec like fac_wo_rec.
/*J046*/ define new shared variable jp like mfc_logical.
/*J046*/ define new shared variable joint_type like wo_joint_type.
/*J046*/ define new shared variable base like mfc_logical.
/*J046*/ define new shared variable base_id like wo_base_id.
/*J046*/ define new shared variable jp-yn like mfc_logical.
/*J046*/ define new shared variable recv like mfc_logical initial yes.
/*J046*/ define new shared variable recv_all like mfc_logical initial no.
/*J046*/ define variable regular like mfc_logical initial yes.
/*J046*/ define new shared variable open_ref like sr_qty.
/*J046*/ define new shared variable um like pt_um no-undo.
/*J046*/ define new shared variable tot_units like wo_qty_chg.
/*J046*/ define new shared variable reject_um like pt_um no-undo.
/*J046*/ define new shared variable reject_qty like wo_rjct_chg no-undo.
/*J046*/ define new shared variable trans_um like pt_um.
/*J046*/ define new shared variable transtype as character
/*J09C*/ initial "RCT-WO".
/*J046*/ define new shared variable trans_conv like sod_um_conv.
/*J046*/ define new shared variable msg-counter as integer no-undo.
/*J046*/ define new shared variable recpt-bkfl like mfc_logical initial yes.
/*J046*/ define new shared variable back_qty like sr_qty.
/*J046*/ define variable backqty like sr_qty.
/*J046*/ define variable base_qty like sr_qty.
/*J046*/ define variable parent_item like pt_part.
/*J046*/ define variable base_item like pt_part.
/*J046*/ define variable reg as character format "x(1)".
/*J046*/ define variable parent_qty like sr_qty.
/*J046*/ define new shared variable undo_setd like mfc_logical no-undo.
/*J046*/ define new shared variable undo_jp like mfc_logical.
/*J046*/ define buffer womstr for wo_mstr.
/*J046*/ define variable glcost like sct_cst_tot.
/*J046*/ define variable msgref like tr_msg.
/*J082** begin deleted block **********************
      *  define variable wip_accum like wo_wip_tot.
      *  define variable glx_mthd like cs_method.
      *  define variable glx_set like cs_set.
      *  define variable cur_mthd like cs_method.
      *  define variable cur_set like cs_set.
      *  define variable alloc_mthd like acm_method.
      *  define new shared workfile alloc_wkfl no-undo
      *     field alloc_wonbr as character
      *     field alloc_recid as recid
      *     field alloc_numer as decimal
      *     field alloc_pct   as decimal.
**J082** end deleted block */

/*J040*/ define new shared variable chg_attr like mfc_logical no-undo
	 label "设置属性".
/*J040*/ define new shared variable wolot like wo_lot.
/*J040*/ /*DEFINE VARIABLES FOR CHANGE ATTRIBUTES FEATURE*/
/*J040*/ {gpatrdef.i "new shared"}

/*J041*/ define variable oldlot like sr_lotser .
/*J041*/ define variable trans_ok like mfc_logical.

/*J0FY*/ define variable w-file-type as character format "x(25)".
/*J0FY*/ define variable w_nbr like wo_mstr.wo_nbr.
/*J0FY*/ define variable w_wip_site like si_mstr.si_site.
/*J0FY*/ define variable w_wo_lot   like wo_mstr.wo_lot.
/*J0FY*/ define variable w_part     like pt_mstr.pt_part.
/*J0KF* moved from include file icrcex.i */
/*J0KF*/ define variable w-te_nbr as integer.
/*J0KF*/ define variable w-te_type as character.
/*J0KF*/ define variable w-datastr as character format "x(255)".
/*J0KF*/ define variable w-len as integer.
/*J0KF*/ define variable w-counter as integer.
/*J0KF*/ define variable w-tstring as character format "x(50)".
/*J0KF*/ define variable w-group as character format "x(18)".
/*J0KF*/ define variable w-str-len as integer.
/*J0KF*/ define variable w-update as character format "x".
/*J0KF*/ define variable w_whl_src_dest_id like whl_mstr.whl_src_dest_id.
/*J0KF*/ define variable w-sent as integer initial 0.

			{mfdeclre.i}
/*J0QX* /*H039*/ {gpglefdf.i} */
/*J0QX*/ {gpglefv.i}

	 /* INPUT OPTION FORM */
	 
/*GUI preprocessor Frame B define */
&SCOPED-DEFINE PP_FRAME_NAME B
FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
	wo_nbr      colon 12 wo_lot      eff_date    colon 68
/*G782      wo_part     colon 12 wo_status   issue       colon 68 */
/*G782      desc1       at 14 no-label       receive     colon 68 */
/*G782*/    wo_part     colon 12 wo_status   receive     colon 68
/*G782*/    desc1       at 14 no-label       issue       colon 68
	  SKIP(.4)  /*GUI*/
with frame B side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.
 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame B = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame B = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame B =
  FRAME B:HEIGHT-PIXELS - RECT-FRAME:Y in frame B - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME B = FRAME B:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame B undefine */
&UNDEFINE PP_FRAME_NAME


/*J046*/ FORM /*GUI*/ 
/*J046*/            
/*J1GW* /*J046*/    recv_all colon 40 label "Receive All Joint Products" */
/*J1GW*/    recv_all colon 40 label "收到所有的复合产品/副产品"
/*J046*/    recv     colon 40 label "           收货量 = 缺缺量"
/*J046*/            skip (1)
/*J046*/  SKIP(.4)  /*GUI*/
with frame rr side-labels overlay row 9 column 19
/*J1GW* /*J046*/ title color normal " Joint Products Receipt Options " */
/*J1GW*/ 
/*J046*/ width 50 attr-space NO-BOX THREE-D /*GUI*/.


	 eff_date = today.

	 do transaction:
/*G292*     fas_wo_rec = string(true).      /*DEFAULT VALUE*/
	    {mfctrl01.i mfc_ctrl fas_wo_rec fas_wo_rec false} */

/*G292*/    /* Added section */
	    find mfc_ctrl exclusive-lock where mfc_field = "fas_wo_rec"
	    no-error.
	    if available mfc_ctrl then do:
	       find first fac_ctrl exclusive-lock no-error.
	       if available fac_ctrl then do:
		  fac_wo_rec = mfc_logical.
		  delete mfc_ctrl.
	       end.
	       release fac_ctrl.
	    end.

/*GE91*/    release mfc_ctrl.

	    find first fac_ctrl no-lock no-error.
	    if available fac_ctrl then fas_wo_rec = fac_wo_rec.
/*G292*/    /* End of added section */

	 end.

	 /* DISPLAY */
	 mainloop:

	 repeat:

/*GUI*/ if global-beam-me-up then undo, leave.


/*J038*/    do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.

/*J038*/      for each sr_wkfl exclusive-lock where sr_userid = mfguser:
/*J038*/         delete sr_wkfl.
/*J038*/      end.
/*J038*/      {gprun.i ""gplotwdl.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J038*/    end.
/*GUI*/ if global-beam-me-up then undo, leave.


/*J046*/    jp = no.
	    nbr = "".
	    
/*LB01 add section*/
		 find wo_mstr where wo_lot = wosublot no-lock no-error.
		 if not available wo_mstr then do:
		 	message "找不到加工单." view-as alert-box.
		 	leave.
	    end.
	    desc1 = "".
		 find pt_mstr where pt_part = wo_part no-lock no-error.
		 if available pt_mstr then desc1 = pt_desc1.
	    
/*LB01 add section end*/
/*LB01*/
		 display wo_nbr wo_lot eff_date wo_part wo_status desc1 issue receive with frame B.
/*G782      prompt-for wo_nbr wo_lot eff_date issue receive */
/*G782    prompt-for wo_nbr wo_lot eff_date receive issue*/


/*LB01*/  prompt-for eff_date receive issue
	    with frame B editing:
	       if frame-field = "wo_nbr" then do:
		  /* FIND NEXT/PREVIOUS RECORD */
		  {mfnp.i wo_mstr wo_nbr wo_nbr wo_nbr wo_nbr wo_nbr}
	       end.
	       else if frame-field = "wo_lot" then do:
		  /* FIND NEXT/PREVIOUS RECORD */
		  if input wo_nbr <> "" then do:
		     {mfnp01.i
			wo_mstr
			wo_lot
			wo_lot
			"input wo_nbr"
			wo_nbr
			wo_nbr}
		  end.
		  else do:
		     {mfnp.i wo_mstr wo_lot wo_lot wo_lot wo_lot wo_lot}
		  end.
	       end.
	       else do:
		  status input.
		  readkey.
		  apply lastkey.
	       end.
	       if recno <> ? then do:
/*J040*/          wolot = wo_lot.
		  desc1 = "".
		  find pt_mstr where pt_part = wo_part no-lock no-error.
		  if available pt_mstr then desc1 = pt_desc1.
		  display wo_nbr wo_lot wo_part wo_status desc1 with frame B.
	       end.
/*J040*/       else do:
/*J040*/          wolot = input wo_lot.
/*J040*/       end.
	    end.

	    assign eff_date issue receive.
	    if eff_date = ? then eff_date = today.

	    /* CHECK EFFECTIVE DATE */
/*H039*     {mfglef.i eff_date} */
/*J0QX* /*H039*/    {gpglef.i ""IC"" glentity eff_date} */

	    nbr = input wo_nbr.
	    if input wo_nbr <> "" then
	    if not can-find(first wo_mstr using wo_nbr)
	    then do:
	       {mfmsg.i 503 3}.
	       undo, retry.
	    end.

	    if nbr = "" and input wo_lot = "" then undo, retry.
	    if nbr <> "" and input wo_lot <> "" then
	    find wo_mstr where wo_nbr = nbr using wo_lot no-error.
	    if nbr = "" and input wo_lot <> "" then
	    find wo_mstr using wo_lot no-error.
	    if nbr <> "" and input wo_lot = "" then
	    find first wo_mstr where wo_nbr = nbr no-error.
	    if not available wo_mstr then do:
	       {mfmsg.i 510 3}
	       /*  WORK ORDER DOES NOT EXIST.*/
	       undo, retry.
	    end.
/*J0QX*/    find si_mstr where si_site = wo_site no-lock.
/*J0QX*/    {gpglef1.i &module = ""WO""
		     &entity = si_entity
		     &date = eff_date
		     &prompt = "eff_date"
		     &frame = "B"
		     &loop = "mainloop"
		     }

/*J082*/    desc1 = "".
/*J082*/    display wo_nbr wo_part wo_lot wo_status desc1 with frame B.

/*J040*/    if input wo_lot <> "" or
/*J040*/       input wo_lot <> " " then do:
/*J040*/       wolot = input wo_lot.
/*J040*/    end.
/*J040*/    else do:
/*J040*/       wolot = wo_lot.
/*J040*/    end.

	    if lookup(wo_status,"A,R" ) = 0
	    and (issue or receive)
	    then do:
	       {mfmsg.i 523 3}
	       /* WORK ORDER LOT IS CLOSED, PLANNED OR FIRM PLANNED */
	       {mfmsg02.i 525 1 wo_status}
	       /* CURRENT WORK ORDER STATUS: */
	       undo, retry.
	    end.

	    /* DON'T ALLOW CALL ACTIVITY RECORDING WORK ORDERS */
/*J04C*/    if wo_fsm_type = "FSM-RO" then do:
/*J04C*/        {mfmsg.i 7492 3}    /* FIELD SERVICE CONTROLLED */
/*J04C*/        undo, retry.
/*J04C*/    end.

/*J034*/    {gprun.i ""gpsiver.p""
	     "(input wo_site, input ?, output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/    if return_int = 0 then do:
/*J034*/       {mfmsg02.i 2710 3 wo_site} /* USER DOES NOT HAVE */
/*J034*/                                  /* ACCESS TO SITE XXXXX*/
/*J034*/       undo mainloop, retry.
/*J034*/    end.

/*GN76      ADDED FOLLOWING SECTION*/
	    if wo_type = "c" and wo_nbr = "" then do:
	       {mfmsg.i 5123 3}
	       undo, retry.
	    end.
/*GN76      END SECTION*/

	    if receive then do:
/*G292*        if wo_type = "F" and fas_wo_rec = string(false) then do: */
/*G292*/       if wo_type = "F" and fas_wo_rec = false then do:
		  {mfmsg04.i
		  """总装加工单不允许加工单收货""" 3}
		  undo, retry.
	       end.
	    end.

	    prev_status = wo_status.
	    prev_release = wo_rel_date.
	    prev_due = wo_due_date.
	    prev_qty = wo_qty_ord.
	    prev_site = wo_site.

	    wopart_wip_acct = wo_acct.
	    wopart_wip_cc = wo_cc.

	    desc1 = "".
	    find pt_mstr where pt_part = wo_part no-lock no-error.
	    if available pt_mstr then do:
	       desc1 = pt_desc1.
	       find pl_mstr where pl_prod_line = pt_prod_line no-lock no-error.
	       if available(pl_mstr) and wopart_wip_acct = "" then do:
		  wopart_wip_acct = pl_wip_acct.
		  wopart_wip_cc = pl_wip_cc.
	       end.
	    end.

	    display wo_nbr wo_part wo_lot wo_status desc1 with frame B.
	    if eff_date = ? then eff_date = today.

	    wo_recno = recid(wo_mstr).

/*J046*/   /* CHECK FOR JOINT PRODUCT FLAGS */
/*J046*/   if wo_joint_type <> "" then do:
/*J046*/      jp = yes.
/*J046*/      if wo_joint_type = "5" then do:
/*J046*/         base_id = wo_lot.
/*J046*/         base = yes.
/*J046*/      end.
/*J046*/      else do:
/*J046*/         base = no.
/*J046*/         parent_item = wo_part.
/*J046*/         base_id = wo_base_id.
/*J046*/         parent_qty = wo_qty_ord.
/*J046*/      end.
/*J046*/   end.

/*J046*/    if jp then do:
/*J046*/       regular = no.
/*J046*/       jp-yn = yes.
/*J046*/       recv = yes.
/*J046*/    end.

	    do transaction:
/*GM56*/       for each sr_wkfl exclusive-lock where sr_userid = mfguser:
		  delete sr_wkfl.
	       end.
/*G782*/       assign
/*G782*/          wo_qty_chg = 0
/*G782*/          wo_rjct_chg = 0.
	    end.

/*G782      if issue then do:                                           */
/*G782         {gprun.i ""woisrc01.p""}                                 */
/*G782         if keyfunction(lastkey) = "end-error" then undo, retry.  */
/*G782      end.                                                        */

/*J046*/    if jp and receive then do:
/*J046*/       regular = no.
/*J046*/       jp-yn = yes.
/*J046*/       firstpass = yes.
/*J046*/       recv_all = yes.
/*J046*/       recv = no.
/*J046*/       pause 0.
/*J08X*/       if base then display recv_all with frame rr.
/*J046*/       update recv_all when (not base) with frame rr.
/*J046*/       if recv_all then update recv with frame rr.
/*J046*/       if recv_all or base then do:
/*J046*/          hide frame B no-pause.
/*J0Y1*/          hide frame rr no-pause.
/*J046*/          {gprun.i ""wojprc.p"" "(input wo_nbr)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J046*/          if undo_jp then undo, retry.
/*J046*/       end.
/*J046*/    end.

/*J046      if receive then do:  ****/
/*J046*/    if (regular and receive)  or (not recv_all and receive) then do:
/*J046*/       view frame B.

/*J041*        {gprun.i ""woisrc02.p""}                                 */
/*J041       {gprun.i ""woisrc02.p"" "(output trans_ok)"}*/
/*LB01*/       {gprun.i ""zzwoisrc02.p"" "(input wosubqty, output trans_ok)"}
					hide frame v no-pause.
/*GUI*/ if global-beam-me-up then undo, leave.

/*J041*/       if not trans_ok then undo, retry.
/*GM78*/ /*V8+*/
	    end.

/*J046*/    /*   DISPLAY THE BASE ITEM IN FRAME B ***/
/*J046*/    if jp and issue then do:
/*J046*/       find first wo_mstr no-lock where wo_lot = base_id no-error.
/*J046*/       if available wo_mstr then do:
/*J046*/          wo_recno = recid(wo_mstr).
/*J046*/          find pt_mstr where pt_part = wo_part no-lock no-error.
/*J046*/          if available pt_mstr then desc1 = pt_desc1.
/*J046*/          base_item = wo_part.
/*J046*/          base_qty = wo_qty_ord.
/*J046*/          find bom_mstr where bom_parent = base_item no-lock no-error.
/*J046*/          display wo_nbr wo_lot wo_part wo_status desc1 with frame B.
/*J046*/          if bom_mthd = "2" then back_qty = base_qty.
/*J046*/       end.
/*J046*/    end.

/*G782*/    if issue then do:
/*J046*/       if jp and undo_jp then undo, retry.
/*G0KT*/       outta_here = no.   
/*G782         {gprun.i ""woisrc01.p""}*/
/*LB01*/       {gprun.i ""zzwoisrc01.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*G0KT*/ /*V8+*/
/*G0KT*/       if outta_here then undo, retry.   
/*G782*/    end.

			hide frame v no-pause.

	    do transaction on endkey undo mainloop, retry mainloop:
/*GUI*/ if global-beam-me-up then undo, leave.

	       yn = yes.

	       {mfmsg01.i 32 1 yn} /* "Please confirm update" */
			
	       if yn then do:

		  if issue then do:
/*G1FL*/             /* RECHECK INVENTORY TO VERIFY ALL IS STILL OK    */
/*G1FL*/             {gprun.i ""woisrc1c.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*G1FL*/             if rejected then undo mainloop, retry mainloop.
		     {gprun.i ""wowoisa.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

		  end.

/*J046            if receive then do:     **/
/*J046*/          if not jp and receive then do:

/*FL87*/ /*          find in_mstr where in_part = wo_part and in_site = wo_site
	  *          exclusive no-error.
	  *
	  *          if available in_mstr then do:
	  *             in_qty_ord = in_qty_ord
	  *                        - max(wo_qty_ord
	  *                             - (wo_qty_comp + wo_qty_rjct),0)
	  *                        + max(wo_qty_ord
/*F104    *                             - (wo_qty_comp + (wo_qty_chg * conv) */
/*F104    *                               + wo_qty_rjct                      */
/*F104    *                               + (wo_rjct_chg * reject_conv)),0). */
/*F104*/  *                             - (wo_qty_comp + wo_qty_chg
/*F104*/  *                               + wo_qty_rjct
/*F104*/  *                               + wo_rjct_chg),0).
	  *
	  *             if in_qty_ord < 0 then in_qty_ord = 0.
	  *          end.
/*FL87*/  */

/*J10N************ REPLACED BELOW INCLUDE FILE ICRCEX.I WITH WIICRCEX.P ***/

		     /* DETERMINE IF WAREHOUSING INTERFACE IS ACTIVE */
/*J10N*/             if can-find(first whl_mstr
/*J10N*/                         where whl_act = true no-lock) then do:

/*J10N*/                for each sr_wkfl where sr_userid = mfguser no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


/*J10N*/                   find wo_mstr where recid(wo_mstr) = wo_recno no-lock.

			   /* EXPORT DATA TO WAREHOUSE INTERFACE */
/*J10N*/                   if sr_site = wo_site then location = sr_loc.
/*J10N*/                   else location = pt_loc.

/*J10N*/                   {gprun.i ""wiicrcex.p""
				    "(input 'wi-wowoisrc',
				      input wo_nbr,
				      input wo_lot,
				      input wo_part,
				      input sr_qty,
				      input trans_um,
				      input trans_conv,
				      input sr_site,
				      input sr_loc,
				      input sr_lot,
				      input sr_ref,
				      input eff_date)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J10N*/                end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH SR_WKFL */

/*J10N*/             end. /* IF WAREHOUSING ACTIVE */

/*J10N ************ REPLACED BELOW CODE WITH ABOVE CODE ******************
 * /*ben*/
 * /*J0FY*/            for each sr_wkfl where sr_userid = mfguser:
 * /*J0FY*/                find wo_mstr where recid(wo_mstr) = wo_recno.
 * /*J0FY*/                assign
 * /*J0FY*/                    w_nbr       = wo_nbr
 * /*J0FY*/                    w_wip_site  = ""
 * /*J0FY*/                    site        = wo_site
 * /*J0FY*/                location = if sr_site = wo_site then sr_loc else pt_l
 * /*J0FY*/                    w_wo_lot    = wo_lot
 * /*J0FY*/                    w_part      = wo_part
 * /*J0FY*/                    w-file-type = "wowoisrc".
 * /*J0FY*/                       {icrcex.i}
 *
 * /*J0FY*/            end.
 *J10N ************ END OF REPLACED CODE *********************************/

		     /* CREATE TRANSACTION HISTORY RECORD */
		     {gprun.i ""woworca.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

		     find wo_mstr where recid(wo_mstr) = wo_recno.
		     if close_wo then wo_status = "C".
		     {gprun.i ""wowomta.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

		  end.

/*J046*/          /* JOINT PRODUCT INVENTORY, GL, AND WO_MSTR UPDATES */
/*J046*/          if jp and not undo_jp and receive then do:
/*J082*/             {gprun.i ""wojprcb.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J082*/          end.

/*J082************** begin deleted block *************************************
/*J046*/ *           find womstr no-lock where recid(womstr) = wo_recno
/*J046*/ *           no-error.
	 *
/*J046*/ *           /* MEMO RECEIPT FOR BASE PROCESS ORDER */
/*J046*/ *           find first wo_mstr exclusive-lock
/*J046*/ *           where wo_mstr.wo_nbr = womstr.wo_nbr
/*J046*/ *           and wo_mstr.wo_joint_type = "5"
/*J046*/ *           no-error.
	 *
/*J046*/ *           if available wo_mstr then do:
/*J046*/ *              wo_mstr.wo_qty_chg = 1.
/*J046*/ *              {ictrans.i
	 *               &addrid=""""
	 *               &bdnstd=0
	 *               &cracct=""""
	 *               &crcc=""""
	 *               &crproj=""""
	 *               &curr=""""
	 *               &dracct=""""
	 *               &drcc=""""
	 *               &drproj=""""
	 *               &effdate=eff_date
	 *               &exrate=0
	 *               &glamt=0
	 *               &lbrstd=0
	 *               &line=0
	 *               &location=""""
	 *               &lotnumber=wo_mstr.wo_lot
	 *               &lotserial=""""
	 *               &lotref=""""
	 *               &mtlstd=0
	 *               &ordernbr=wo_mstr.wo_nbr
	 *               &ovhstd=0
	 *               &part=wo_mstr.wo_part
	 *               &perfdate=?
	 *               &price=glcost
	 *               &quantityreq=0
	 *               &quantityshort=0
	 *               &quantity=1
	 *               &revision=""""
	 *               &rmks=rmks
	 *               &shiptype=""M""
	 *               &site=wo_mstr.wo_site
	 *               &slspsn1=""""
	 *               &slspsn2=""""
	 *               &sojob=""""
	 *               &substd=0
	 *               &transtype=""RCT-WO""
	 *               &msg=0
	 *               &ref_site=wo_mstr.wo_site
	 *              }
	 *
/*J046*/ *            /* MEMO ISSUES OF BASE PROCESS ITEM TO
	 *               JOINT PRODUCT LOT#s */
/*J046*/ *            for each womstr where womstr.wo_nbr = wo_mstr.wo_nbr
/*J046*/ *            and womstr.wo_joint_type <> "5"
/*J046*/ *            and wo_mstr.wo_joint_type > ""
/*J046*/ *            and womstr.wo_base_id = wo_mstr.wo_lot:
/*J046*/ *                find first sr_wkfl where sr_userid = mfguser
/*J046*/ *                and substring(sr_lineid,4,18) = womstr.wo_part
/*J046*/ *                and sr_lineid begins "RCT" no-lock no-error.
/*J046*/ *                if available sr_wkfl then do:
/*J046*/ *                   {ictrans.i
	 *                    &addrid=""""
	 *                    &bdnstd=0
	 *                    &cracct=""""
	 *                    &crcc=""""
	 *                    &crproj=""""
	 *                    &curr=""""
	 *                    &dracct=""""
	 *                    &drcc=""""
	 *                    &drproj=""""
	 *                    &effdate=eff_date
	 *                    &exrate=0
	 *                    &glamt=0
	 *                    &lbrstd=0
	 *                    &line=0
	 *                    &location=""""
	 *                    &lotnumber=womstr.wo_lot
	 *                    &lotserial=wo_mstr.wo_lot
	 *                    &lotref=""""
	 *                    &mtlstd=0
	 *                    &ordernbr=womstr.wo_nbr
	 *                    &ovhstd=0
	 *                    &part=wo_mstr.wo_part
	 *                    &perfdate=?
	 *                    &price=glcost
	 *                    &quantityreq=0
	 *                    &quantityshort=0
	 *                    &quantity=1
	 *                    &revision=""""
	 *                    &rmks=rmks
	 *                    &shiptype=""M""
	 *                    &site=wo_mstr.wo_site
	 *                    &slspsn1=""""
	 *                    &slspsn2=""""
	 *                    &sojob=""""
	 *                    &substd=0
	 *                    &transtype=""ISS-WO""
	 *                    &msg=0
	 *                    &ref_site=wo_mstr.wo_site
	 *                   }
/*J046*/ *                   if available trgl_det then delete trgl_det.
/*J046*/ *                end.
/*J046*/ *            end.
	 *
/*J046*/ *            /* BASE PROCESS WORK ORDER */
/*J046*/ *            find womstr no-lock where womstr.wo_nbr = wo_mstr.wo_nbr
/*J046*/ *                                  and womstr.wo_joint_type = "5".
	 *
/*J046*/ *            /* JOINT PRODUCT WORK ORDERS */
/*J046*/ *            for each wo_mstr exclusive-lock where
/*J046*/ *            wo_mstr.wo_nbr = womstr.wo_nbr and
/*J046*/ *            wo_mstr.wo_joint_type <> "" and
/*J046*/ *            recid(wo_mstr) <> recid(womstr):
/*J046*/ *               wo_recno = recid(wo_mstr).
	 *
/*J046*/ *               /* INVENTORY AND GL TRANSACTIONS FOR
	 *                  JOINT PRODUCT ORDERS */
	 *
/*J046*/ *               {gprun.i ""woworca.p""}
	 *
/*J046*/ *               /* UPDATE wip_accum */
/*J046*/ *               wip_accum = wip_accum + wo_mstr.wo_wip_tot.
/*J046*/ *               wo_mstr.wo_wip_tot = 0.
	 *
/*J046*/ *               /* CLOSE JOINT PRODUCT WORK ORDERS */
/*J046*/ *               if close_wo then do:
/*J046*/ *                  wo_mstr.wo_status = "C".
/*J046*/ *                  {gprun.i ""wowomta.p""}
/*J046*/ *               end.
	 *
/*J046*/ *            end. /* END - JOINT PRODUCT WORK ORDERS */
	 *
/*J046*/ *            /* UPDATE BASE PROCESS ORDER */
/*J046*/ *            find wo_mstr exclusive-lock
/*J046*/ *            where wo_mstr.wo_nbr = womstr.wo_nbr
/*J046*/ *            and wo_mstr.wo_joint_type = "5" no-error.
/*J046*/ *            if available wo_mstr then do:
	 *
/*J046*/ *               /* UPDATE RATE AND USAGE VARIANCES FOR
	 *                  BASE PROCESS ORDER */
/*J046*/ *               if wip_accum <> 0 then do:
/*J046*/ *                  /*DETERMINE COSTING METHOD*/
/*J046*/ *                  {gprun.i ""csavg01.p"" "(input wo_mstr.wo_part,
	 *                                           input wo_mstr.wo_site,
	 *                                           output glx_set,
	 *                                           output glx_mthd,
	 *                                           output cur_set,
	 *                                           output cur_mthd)"
	 *                  }
/*J046*/ *                  if glx_mthd <> "AVG" then do:
/*J046*/ *                     wo_recid = recid(wo_mstr).
/*J046*/ *                     transtype = "VAR-POST".
/*J046*/ *                     {gprun.i ""wovarup.p""}
/*J046*/ *                  end.
/*J046*/ *               end.
/*J046*/ *               /* UPDATE wo_wip_tot FOR BASE PROCESS ORDER */
/*J046*/ *               wo_mstr.wo_wip_tot = wo_mstr.wo_wip_tot + wip_accum.
/*J046*/ *               wip_accum = 0.
	 *
/*J041*/ *               if (wo_mstr.wo_lot_rcpt = no) then
/*J041*/ *                  wo_mstr.wo_lot_next = lotserial.
	 *
/*J046*/ *               /* CLOSE BASE PROCESS ORDER */
/*J046*/ *               if close_wo then do:
/*J046*/ *                  wo_mstr.wo_status = "C".
/*J046*/ *                  {gprun.i ""wowomta.p""}
	 *
/*J046*/ *                  if glx_mthd = "AVG" or cur_mthd = "AVG"
/*J046*/ *                  or cur_mthd = "LAST" then do:
	 *
/*J046*/ *                     /*ADD STANDARD METHODS TO PROGRAM TRACE*/
/*J046*/ *                     if false then do:
/*J046*/ *                        {gprun0.i ""wocsal01.p""}
/*J046*/ *                        {gprun0.i ""wocsal02.p""}
/*J046*/ *                        {gprun0.i ""wocsal03.p""}
/*J046*/ *                     end.
	 *
/*J046*/ *                     /*CHOOSE ALLOCATION METHOD*/
/*J046*/ *                     {gprun.i ""wocsjpal.p"" "(input wo_mstr.wo_part,
	 *                                               input wo_mstr.wo_site,
	 *                                               output alloc_mthd)"}
	 *
/*J046*/ *                     /*CALCULATE ALLOCATION PERCENTAGE*/
/*J046*/ *                     {gprun.i alloc_mthd "(input recid(wo_mstr))"}
	 *
/*J046*/ *                     /*UPDATE AVERAGE/LAST COSTS FOR JOINT PRODUCTS*/
/*J046*/ *                     {gprun.i ""csavg04.p"" "(input recid(wo_mstr),
	 *                                              input glx_mthd,
	 *                                              input glx_set,
	 *                                              input cur_mthd,
	 *                                              input cur_set,
	 *                                              output wip_accum)"}
	 *
/*J046*/ *                     wo_mstr.wo_wip_tot = wo_mstr.wo_wip_tot
	 *                                        - wip_accum.
	 *
/*J046*/ *                  end. /* IF GLX_MTHD = "AVG" ... */
/*J046*/ *               end. /*IF CLOSE_WO */
/*J046*/ *            end. /* BASE PROCESS ORDER UPDATE */
/*J046*/ *         end. /* DO TRANSACTION */
/*J046*/ *       end. /* IF JP THEN DO */
**J082********** end deleted block ********************************************/
	       end.
	    end.
/*GUI*/ if global-beam-me-up then undo, leave.

/*J08X*/    if available wo_mstr then
/*J08X*/    display wo_nbr wo_lot wo_part wo_status with frame B.
/*LB01*/		hide frame B no-pause.
				leave.		
	
	 end.
	 
/*GUI*/ if global-beam-me-up then undo, leave.

		hide frame v no-pause.
		hide frame b no-pause.

