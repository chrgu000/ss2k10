/* rercvlst.p - REPETITIVE   SUBPROGRAM TO MODIFY FINISHED PART RECEIVE LIST  */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.       */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                         */
/* REVISION: 7.X      LAST MODIFIED: 10/31/94   BY: WUG *GN77*                */
/* REVISION: 8.5      LAST MODIFIED: 05/12/95   BY: pma *J04T*                */
/* REVISION: 7.2      LAST MODIFIED: 08/17/95   BY: qzl *F0TC*                */
/* REVISION: 8.5      LAST MODIFIED: 09/05/95   BY: kxn *J07P*                */
/* REVISION: 8.5      LAST MODIFIED: 09/11/95   BY: tjs *J060*                */
/* REVISION: 8.5      LAST MODIFIED: 10/30/95   BY: kxn *J095*                */
/* REVISION: 8.5      LAST MODIFIED: 03/11/96   BY: jpm *J0F5*                */

/* TAKEN FROM reiscr02.p                                                      */

	 {mfdeclre.i}

	 define input parameter cumwo_lot as character.
	 define input parameter qty_rcv as decimal.
	 define output parameter undo_stat like mfc_logical no-undo.

	 define buffer rpsmstr for rps_mstr.
	 define new shared variable any_issued like mfc_logical.
	 define new shared variable cline as character.
	 define new shared variable comp like ps_comp.
	 define new shared variable conv like um_conv
	    label "换算因子" no-undo.
	 define new shared variable deliv like wod_deliver.
	 define new shared variable issue_or_receipt as character
	    initial "收货".
	 define new shared variable leadtime like pt_mfg_lead.
	 define new shared variable location like sr_loc no-undo.
	 define new shared variable lotref like sr_ref format "x(8)" no-undo.
/*J095*  define new shared variable lotserial like sr_lotser no-undo.  */
/*J095*/ define shared variable lotserial like sr_lotser no-undo.
	 define new shared variable lotserial_control like pt_lot_ser.
	 define new shared variable lotserial_qty like sr_qty no-undo.
	 define new shared variable multi_entry like mfc_logical
	    label "多记录" no-undo.
	 define new shared variable pl_recno as recid.
	 define new shared variable prev_due like wo_due_date.
	 define new shared variable prev_qty like wo_qty_ord.
	 define new shared variable prev_release like wo_rel_date.
	 define new shared variable prev_status like wo_status.
	 define new shared variable qty like wo_qty_ord.
	 define new shared variable site like si_site no-undo.
	 define new shared variable total_lotserial_qty like sr_qty.
	 define new shared variable trans_conv like sod_um_conv.
	 define new shared variable trans_um like pt_um.
	 define new shared variable transtype as character initial "RCT-WO".
	 define variable del-yn like mfc_logical.
	 define variable fas_wo_rec as character.
	 define variable i as integer.
	 define variable loc like ld_loc.
	 define variable lot like ld_lot.
	 define variable lotqty like wo_qty_chg.
	 define variable nbr like wo_nbr.
	 define variable null_ch as character initial "".
	 define variable qty_left like tr_qty_chg.
	 define variable ref like glt_ref.
	 define variable rmks like tr_rmks.
	 define variable rpsnbr like mrp_nbr.
	 define variable rpsrecord like rps_record.
	 define variable serial like tr_serial.
	 define variable temp_qty like wo_qty_chg.
	 define variable tot_units like wo_qty_chg label "总量".
	 define variable totlotqty like wo_qty_chg.
	 define variable trqty like tr_qty_chg.
	 define variable um like pt_um no-undo.
	 define variable yn like mfc_logical.

/*J04T*/ /*DEFINE VARIABLES FOR CHANGE ATTRIBUTES FEATURE*/
/*J04T*/ {gpatrdef.i "shared"}
/*J04T*/ define new shared variable chg_attr like mfc_logical
/*J04T*/    label "改变属性" no-undo.
/*J04T*/ define variable trans-ok like mfc_logical.
/*J04T*/ define variable srlot like sr_lotser no-undo.
/*J04T*/ define new shared variable lotnext like wo_lot_next .
/*J04T*/ define new shared variable lotprcpt like wo_lot_rcpt no-undo.
/*J04T*/ define variable newlot like pod_lot_next.
/*J04T*/ define variable alm_recno as recid.
/*J04T*/ define variable filename as character.
/*J07P*/ define variable almr like alm_pgm.
/*J07P*/ define variable ii as integer.

	 undo_stat = yes.
	 find wo_mstr where wo_lot = cumwo_lot no-lock.

/*J04T*/ find first clc_ctrl no-lock no-error.
/*J04T*/ if not available clc_ctrl then do:
/*J04T*/    {gprun.i ""gpclccrt.p""}
/*J04T*/    find first clc_ctrl no-lock no-error.
/*J04T*/ end.

	 total_lotserial_qty = qty_rcv.

	 form
	    pt_desc1       colon 15
	    pt_lot_ser
	    pt_desc2       at 17 no-label skip (1)
	    lotserial_qty  colon 15
	    um
	    conv           colon 50
	    site           colon 15
	    tot_units      colon 50
	    pt_um          no-label
	    location       colon 15
	    lotserial      colon 15
	    lotref         colon 15
	    multi_entry    colon 15
/*J04T*/    chg_attr       colon 50
	 with frame a side-labels width 80 attr-space
	 title color normal " 收货数据输入 ".

/*J04T*/ /*FIND NEXT PRE-ASSIGNED OR AUTO-ASSIGNED LOT NUMBER*/
/*J04T*/ find pt_mstr where pt_part = wo_part no-lock no-error.
/*J04T*/ lotprcpt = wo_lot_rcpt.
/*J04T*/ if pt_lot_ser = "L" and not pt_auto_lot then lotserial = wo_lot_next.
/*J04T*/ else if (pt_lot_ser = "L" and pt_auto_lot = yes and pt_lot_grp <> "")
/*J04T*/ then do:
/*J04T*/    find alm_mstr where alm_lot_grp = pt_lot_grp
/*J04T*/    and alm_site = wo_site no-lock no-error.
/*J04T*/    if not available alm_mstr then
/*J04T*/    find alm_mstr where alm_lot_grp = pt_lot_grp
/*J04T*/                    and alm_site = "" no-lock no-error.
/*J04T*/    if not available alm_mstr then do:
/*J04T*/       {mfmsg.i 2737 3}  /* LOT FORMAT RECORD DOES NOT EXIST */
/*J04T*/       return.
/*J04T*/    end.
/*J04T*/    else do:
/*J04T*/       if (search(alm_pgm) = ?) then do:

/*J07P*/          ii = index(alm_pgm,".p").
/*J0F5* /*J07P*/  almr = substring(alm_pgm, 1, 2) + "/"  */
/*J0F5*/          almr = global_user_lang_dir + "/"
/*J0F5*/               + substring(alm_pgm, 1, 2) + "/"
/*J07P*/               + substring(alm_pgm,1,ii - 1) + ".r".
/*J07P*/          if (search(almr)) = ? then do:
/*J04T*/             {mfmsg02.i 2732 4 alm_pgm} /* AUTO LOT PROGRAM NOT FOUND */
/*J04T*/             return.
/*J07P*/          end.
/*J04T*/       end.
/*J04T*/    end.
/*J04T*/    find first sr_wkfl where sr_userid = mfguser
/*J04T*/    and sr_lineid = cline no-lock no-error.
/*J04T*/    if available sr_wkfl then lotserial = sr_lotser.
/*J04T*/    filename = "wo_mstr".
/*J04T*/    if newlot = "" then do:
/*J04T*/       alm_recno = recid(alm_mstr).
/*J04T*/       if false then do:
/*J0F5*********************************************************
 * /*J04T*/          {gprun0.i ""gpauto01.p"" "(alm_recno,
 *					     recid(wo_mstr),
 *					     "filename",
 *					      output newlot,
 *					      output trans-ok)"
 *		  }
 ***************************************************************/
/*J0F5*/          {gprun.i ""gpauto01.p"" "(alm_recno,
					    recid(wo_mstr),
					    "filename",
					    output newlot,
					    output trans-ok)"
		  }
	       end.
	
/*J04T*/       {gprun.i alm_pgm "(alm_recno,
				  recid(wo_mstr),
				  "filename",
				  output newlot,
				  output trans-ok)"
	       }
/*J04T*/       if not trans-ok then do:
/*J04T*/          {mfmsg.i 2737 3}  /* LOT FORMAT RECORD DOES NOT EXIST */
/*J04T*/          return.
/*J04T*/       end.
/*J04T*/       lotserial = newlot.
/*J04T*/       release alm_mstr.
/*J04T*/    end.
/*J04T*/ end.

	 mainloop:
	 do
/*J04T*/ transaction
	 on error undo , retry with frame a:
	    {mfdel.i sr_wkfl "where sr_userid = mfguser
			      and sr_lineid begins ""+"""}
/*J04T*/    {gprun.i ""gplotwdl.p""}
	    nbr = wo_nbr.
	    status input.
/*J04T      find pt_mstr where pt_part = wo_part no-lock no-error.  */
	    um = "".
	    lotserial_control = "".
	    conv = 1.

	    if available pt_mstr then do:
	       um = pt_um.
	       lotserial_control = pt_lot_ser.
/*J04T         disp pt_desc1 pt_desc2 pt_lot_ser with frame a.      */
/*J04T*/       display pt_desc1 pt_desc2 pt_lot_ser lotserial with frame a.
	    end.
	    else do:
	       display "" @ pt_desc1 "" @ pt_desc2 "" @ pt_lot_ser with frame a.
	    end.

	    setd:
	    repeat on endkey undo mainloop , leave mainloop:
	       location = "".
/*J04T         lotserial = "".   */
	       lotref = "".
	       lotserial_qty = total_lotserial_qty.
	       cline = "+" + wo_part.
	       global_part = wo_part.
	       i = 0.
	       for each sr_wkfl no-lock where sr_userid = mfguser
	       and sr_lineid = cline:
		  i = i + 1.
		  if i > 1 then leave.
	       end.

	       if i = 0 and available pt_mstr then do:
		  location = pt_loc.
	       end.
	       else if i = 1 then do:
		  find first sr_wkfl where sr_userid = mfguser
		  and sr_lineid = cline no-lock.
		  site = sr_site.
		  location = sr_loc.
		  lotserial = sr_lotser.
		  lotref = sr_ref.
	       end.

	       if i = 0 then site = wo_site.

	       locloop:
	       do on error undo, retry on endkey undo mainloop, leave mainloop:
		  update lotserial_qty um conv
/*J095*           site location lotserial                             */
/*J095*/          site location lotserial when (not
/*J095*/              (available pt_mstr and pt_auto_lot and pt_lot_ser = "L"
/*J095*/                         and pt_lot_grp <> ""))
		  lotref multi_entry
/*J04T*/          chg_attr
		  with frame a
		  editing:
		     global_site = input site.
		     global_loc = input location.
		     global_lot = input lotserial.
		     ststatus = stline[3].
		     status input ststatus.
		     readkey.
		     apply lastkey.
		  end.

		  if available pt_mstr then do:
		     if um <> pt_um then do:
			if um entered and not conv entered then do:
			   {gprun.i ""gpumcnv.p"" "(input um,
			    input pt_um, input wo_part, output conv)"}

			   if conv = ? then do:
			      {mfmsg.i 33 2}
			      conv = 1.
			   end.

			   display conv with frame a.
			end.
		     end.
		  end.

/*J095* DELETE FOLLOWING SECTION */
/*J04T*/          /*IF SINGLE LOT PER RECEIPT THEN VERIFY IF LOT IS USED */
/*J04T*/          if (lotprcpt = yes) and (pt_lot_ser = "L")
/*J04T*/          and (clc_lotlevel <> 0) then do:
/*J04T*/             find first lot_mstr where lot_serial = lotserial
/*J04T*/             and lot_part = pt_part and lot_nbr = wo_nbr
/*J04T*/             and lot_line = wo_lot no-lock no-error.
/*J04T*/             if available lot_mstr
/*J04T*/             then do:
/*J04T*/                {mfmsg.i 2759 3} /* LOT IS IN USE */
/*J04T*/                 next-prompt lotserial with frame a.
/*J04T*/                undo locloop, retry.
/*J04T*/             end.
/*J04T*/             find first lotw_wkfl where lotw_lotser = lotserial and
/*J04T*/             lotw_mfguser <> mfguser and lotw_part <> pt_part
/*J04T*/             no-lock no-error.
/*J04T*/             if available lotw_wkfl then do:
/*J04T*/                {mfmsg.i 2759 3} /* LOT IS IN USE */
/*J04T*/                next-prompt lotserial with frame a.
/*J04T*/                undo locloop, retry.
/*J04T*/             end.
/*J04T*/          end.
/*J095* END DELETION */

/*J095*/       if (clc_lotlevel = 1) and (lotserial <> "") then do:
/*J095*/          find first lot_mstr where lot_serial = lotserial
/*J095*/             and lot_part = pt_part
/*J095*/             no-lock no-error.
/*J095*/          if available lot_mstr and
/*J095*/             (lotprcpt = yes or lot_line <> wo_lot)
/*J095*/          then do:
/*J095*/             {mfmsg.i 2759 3} /* LOT IS IN USE */
/*J095*/             next-prompt lotserial with frame a.
/*J095*/             undo locloop, retry.
/*J095*/          end.
/*J095*/          find first lotw_wkfl where lotw_lotser = lotserial
/*J095*/             and lotw_mfguser <> mfguser and lotw_part <> pt_part
/*J095*/             no-lock no-error.
/*J095*/          if available lotw_wkfl then do:
/*J095*/             {mfmsg.i 2759 3} /* LOT IS IN USE */
/*J095*/             next-prompt lotserial with frame a.
/*J095*/             undo locloop, retry.
/*J095*/          end.
/*J095*/       end. /* if clc_lotlevel = 1 */

/*J095*/       if (clc_lotlevel = 2) and (lotserial <> "") then do:
/*J095*/          find first lot_mstr where lot_serial = lotserial
/*J095*/             no-lock no-error.
/*J095*/          if available lot_mstr and
/*J095*/             (lotprcpt = yes or lot_line <> wo_lot)
/*J095*/          then do:
/*J095*/             {mfmsg.i 2759 3} /* LOT IS IN USE */
/*J095*/             next-prompt lotserial with frame a.
/*J095*/             undo locloop, retry.
/*J095*/          end.

/*J095*/          find first lotw_wkfl where lotw_lotser = lotserial
/*J095*/             and lotw_mfguser <> mfguser
/*J095*/             no-lock no-error.
/*J095*/          if available lotw_wkfl then do:
/*J095*/             {mfmsg.i 2759 3} /* LOT IS IN USE */
/*J095*/             next-prompt lotserial with frame a.
/*J095*/             undo locloop, retry.
/*J095*/          end.
/*J095*/       end. /* if clc_lotlevel = 2 */

/*J04T*/          /*CHANGE ATTRIBUTES*/
/*J04T*/          /*INITIALIZE ATTRIBUTE VARIABLES WITH CURRENT SETTINGS*/
/*J04T*/          chg_assay = wo_assay.
/*J04T*/          chg_grade = wo_grade.
/*J04T*/          chg_expire = wo_expire.
/*J04T*/          chg_status = wo_rctstat.
/*J04T*/          assay_actv = yes.
/*J04T*/          grade_actv = yes.
/*J04T*/          expire_actv = yes.
/*J04T*/          status_actv  = yes.

/*J04T*/          if wo_rctstat_active = no then do:
/*J04T*/             find in_mstr where in_part = wo_part and in_site = wo_site
/*J04T*/             no-lock no-error.
/*J04T*/             if available in_mstr and in_rctwo_active = yes then
/*J04T*/                chg_status = in_rctwo_status.
/*J04T*/             else if available pt_mstr and pt_rctwo_active = yes then
/*J04T*/                chg_status = pt_rctwo_status.
/*J04T*/             else do:
/*J04T*/                chg_status = "".
/*J04T*/                status_actv = no.
/*J04T*/             end.
/*J04T*/          end.

/*J04T*/          /*SET AND UPDATE INVENTORY DETAIL ATTRIBUTES*/
/*J04T*/          pause 0.
/*J04T*/          if chg_attr then do:
/*J04T*/             {gprun.i ""worcat02.p"" "(input recid(wo_mstr),
					       input chg_attr,
					       input-output chg_assay,
					       input-output chg_grade,
					       input-output chg_expire,
					       input-output chg_status,
					       input-output assay_actv,
					       input-output grade_actv,
					       input-output expire_actv,
					       input-output status_actv)"}
/*J04T*/          end.

		  i = 0.
		  for each sr_wkfl no-lock where sr_userid = mfguser
		  and sr_lineid = cline:
		     i = i + 1.

		     if i > 1 then do:
			multi_entry = yes.
			leave.
		     end.
		  end.

		  trans_um = um.
		  trans_conv = conv.
		  temp_qty = lotserial_qty.

		  if multi_entry then do:
		     if i >= 1 then do:
			site = "".
			location = "".
/*J04T                  lotserial = "".  */
			lotref = "".
		     end.

/*J04T*/             if (lotprcpt = yes) then lotnext = lotserial.

/*J04T*/             /*ADDED BLANKS FOR INPUTS TRNBR AND TRLINE  */
/*J04T*/             /*TO ICSRUP.P CALL BELOW                    */
/*J060*****          {gprun.i ""icsrup.p"" "(wo_site,
	  *                                  """",
	  *                                  """")"}             */
/*/*J060*/             {gprun.i ""xxicsrup.p"" "(input wo_site,*/            /*marked by kevin,11/12/2003*/  
/*J060*/             {gprun.i ""xxicsrup.p"" "(input wo_site,                   /*added by kevin, 11/12/2003*/
					     input """",
					     input """",
					     input-output lotnext,
					     input lotprcpt)"}
		  end.

		  else do:
/*J04T******************* CHANGED ICEDIT.I TO ICEDIT.P **********************
 *                  {icedit.i
 *                       &transtype=""RCT-WO""
 *                       &site=site
 *                       &location=location
 *                       &part=wo_part
 *                       &lotserial=lotserial
 *                       &lotref=lotref
 *                       &quantity="lotserial_qty * trans_conv"
 *                       &um=trans_um
 *                   }
**J04T**********************************************************************/

/*J04T*/             {gprun.i ""icedit.p"" "(""RCT-WO"",
					     site,
					     location,
					     wo_part,
					     lotserial,
					     lotref,
					     lotserial_qty * trans_conv,
					     trans_um,
					     """",
					     """",
					     output yn)"
		     }
/*J04T*/             if yn then undo locloop, retry.

		     if wo_site <> site then do:
/*F0TC*/ /**** The following code has been replaced by icedit4.p which ****/
/*F0TC*/ /**** can be used in both multi line and single line mode.    ****/
/*F0TC*/ /*************************** Delete: Begin ***********************
 *             {gprun.i ""icedit3.p""
 *               "(""RCT-WO"", wo_site, location, wo_part, lotserial,
 *                 lotref, lotserial_qty * trans_conv, trans_um,
 *                 output yn)" }
 *
 *             if yn then undo locloop , retry.
 *
 *             {gprun.i ""icedit3.p""
 *               "(""ISS-TR"", wo_site, location, wo_part, lotserial,
 *                 lotref, lotserial_qty * trans_conv, trans_um,
 *                 output yn)" }
 *
 *             if yn then undo locloop , retry.
 *
 *             {gprun.i ""icedit3.p""
 *               "(""RCT-TR"", site, location, wo_part, lotserial,
 *                 lotref, lotserial_qty * trans_conv, trans_um,
 *                 output yn)" }
/*F0TC*/ **************************** Delete: End *************************/

/*J04T* Added 2 input """", (wo_nbr and wo_lot)   Done during 1/5/96 merge. */
/*F0TC*/                {gprun.i ""icedit4.p"" "(input ""RCT-WO"",
						 input wo_site,
						 input site,
						 input pt_loc,
						 input location,
						 input wo_part,
						 input lotserial,
						 input lotref,
						 input lotserial_qty
						       * trans_conv,
						 input trans_um,
						 input """",
						 input """",
						 output yn)"
			}

			if yn then undo locloop , retry.
		     end.

		     find first sr_wkfl where sr_userid = mfguser
		     and sr_lineid = cline no-error.

		     if lotserial_qty = 0 then do:
			if available sr_wkfl then do:
			   total_lotserial_qty = total_lotserial_qty - sr_qty.
			   delete sr_wkfl.
			end.
/*J04T*/                {gprun.i ""gplotwdl.p""}
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
			   assign sr_userid = mfguser
			   sr_lineid = cline
			   sr_site = site
			   sr_loc = location
			   sr_lotser = lotserial
			   sr_ref = lotref.
			   sr_qty = lotserial_qty.
			   total_lotserial_qty = lotserial_qty.
			end.
		     end.
		  end.

/*J04T*/          /*TEST FOR ATTRIBUTE CONFLICTS*/
/*J04T*/          for each sr_wkfl where sr_userid = mfguser
/*J04T*/          and sr_lineid = "+" + wo_part no-lock:

/*J04T*/             {gprun.i ""worcat01.p"" "(input recid(wo_mstr),
					       input sr_site,
					       input sr_loc,
					       input sr_ref,
					       input sr_lotser,
					       input-output chg_assay,
					       input-output chg_grade,
					       input-output chg_expire,
					       input-output chg_status,
					       input-output assay_actv,
					       input-output grade_actv,
					       input-output expire_actv,
					       input-output status_actv,
					       output trans-ok)"}

/*J04T*/             if not trans-ok then do:
/*J04T*/                srlot = sr_lotser.
/*J04T*/                if sr_ref <> "" then srlot = srlot + "/" + sr_ref.
/*J04T*/                /*ATTRIBUTES DO NOT MATCH LD_DET*/
/*J04T*/                {mfmsg02.i 2742 4 srlot}
/*J04T*/                next-prompt site.
/*J04T*/                undo locloop, retry.
/*J04T*/             end.
/*J04T*/          end. /*for each sr_wkfl*/
	       end.

	       tot_units = total_lotserial_qty * conv.
	       display tot_units pt_um with frame a.
	       i = 0.

	       for each sr_wkfl no-lock where sr_userid = mfguser
	       and sr_lineid = cline:
		  i = i + 1.
		  if i > 1 then leave.
	       end.

	       if i > 1
	       then do on endkey undo mainloop , retry mainloop:
		  yn = yes.
		  {mfmsg01.i 359 1 yn} /*DISPLAY ITEM & LOT/SERIAL DETAIL*/

		  if yn then do:
		     hide frame a.

		     for each sr_wkfl no-lock where sr_userid = mfguser
		     and sr_lineid = cline
		     with frame b width 80 no-attr-space
		     title " 收货数据查看 ":
			display sr_site sr_loc sr_lotser
			sr_ref format "x(8)" column-label "参考"
			sr_qty um.
		     end.
		  end.
	       end.


	       do on endkey undo mainloop , retry mainloop:
		  if temp_qty <> total_lotserial_qty then do:
		     display total_lotserial_qty @ lotserial_qty with frame a.
		     {mfmsg02.i 300 2 total_lotserial_qty um """" }
		  end.

		  yn = yes.
		  {mfmsg01.i 12 1 yn} /*IS ALL INFORMATION CORRECT*/

		  if yn then do:
		     if index("LS",lotserial_control) > 0 then
		     for each sr_wkfl no-lock where sr_userid = mfguser
		     and sr_lineid = cline
		     and sr_lotser = "":
			{mfmsg.i 1119 3}
			next setd.
		     end.

		     if conv <> 1 then
		     for each sr_wkfl where sr_userid = mfguser
		     and sr_lineid = cline:
			sr_qty = sr_qty * conv.
		     end.

		     if total_lotserial_qty * conv <> qty_rcv then do:
			{mfmsg02.i 5109 3 "string(total_lotserial_qty) + "" ""
			+ string(qty_rcv / conv)"}
			next setd.
		     end.

		     undo_stat = no.

		     total_lotserial_qty = total_lotserial_qty * conv.
		     leave setd.
		  end.
	       end.
	    end.

	    hide frame a.
	    hide frame b.
	 end.
