/* woworc.p - work order receipt w/ serial numbers                            */
/* copyright 1986-2005 qad inc., carpinteria, ca, usa.                        */
/* all rights reserved worldwide.  this is an unpublished work.               */


/*-revision end---------------------------------------------------------------*/


{mfdtitle.i "1+ "}
{cxcustom.i "woworc.p"}
{gldydef.i new}
{gldynrm.i new}
{gpglefv.i} /*for gpglef1.i ,check site_eff_date*/


define var v_nbr like wo_nbr .
define var v_lot like wo_lot .
define var v_site like wo_site .
define var v_wopart     like wo_part .
define var v_fsm_type   like wo_fsm_type .
define var v_type       like wo_type .
define var lotprcpt     like wo_lot_next .
define variable wonbr   like wo_nbr.
define variable wolot   like wo_lot.
define variable outfile   as char format "x(40)"  no-undo.  /*for cimload*/
define variable outfile1  as char format "x(40)"  no-undo.  /*for cimload*/
define variable quote     as char initial '"'     no-undo.  /*for cimload*/
define variable v_ok      like mfc_logical initial yes no-undo.  /*for cimload*/


define var eff_date as date label "生效日期" .
define var open_ref      like wo_qty_ord label "open qty".
define var v_qty_ord     like wo_qty_ord .
define var v_qty_comp    like wo_qty_comp.
define var v_qty_rjct    like wo_qty_rjct.
define var v_qty_open    like wo_qty_ord .
define variable yn       like mfc_logical.
define variable l_yn     like mfc_logical initial no no-undo.
define variable wo_recno as recid.
define variable transtype as character initial "RCT-WO".
define variable fas_wo_rec like fac_wo_rec.  /*总装加工单是否允许加工单收货*/
define variable conv like um_conv label "Conversion" no-undo.
define variable um like pt_um no-undo.
define variable lotserial_qty like sr_qty no-undo.
define variable site like sr_site no-undo.
define variable location like sr_loc no-undo.
define variable lotserial like sr_lotser no-undo.
define variable lotref like sr_ref format "x(8)" no-undo.
define variable reject_qty like wo_rjct_chg  label "Scrapped Qty" no-undo.
define variable reject_um like pt_um no-undo.
define variable reject_conv like conv no-undo.
define variable rmks like tr_rmks.
define variable old_rmks like tr_rmks.
define variable close_wo like mfc_logical label "Close".
define variable lotserial_control as character. /* ? *********************************/



define var v_line as integer .
define new shared temp-table temp     /*used by xxworc001a.p*/
	field t_line   as char format "X(4)"
	field t_nbr    like wo_nbr 
	field t_part   like wo_part 
	field t_lot    like wo_lot 	
	field t_qty_ord  like wo_qty_ord  label "总订购量"
	field t_qty_comp like wo_qty_comp label "累计完成量"
	field t_qty_rjct like wo_qty_rjct label "累计次品量"
	field t_uncomp   like wo_qty_comp label "未结数量"
	index t_line IS PRIMARY 
	t_line ascending .
define new shared frame w .  /*used by xxworc001a.p*/


define temp-table xxwo    
	field xx_nbr    like wo_nbr     label "加工单"
	field xx_lot    like wo_lot 	label "工单ID"
	field xx_qty    like wo_qty_ord  label "本次收货数"
	field xx_rjct   like wo_qty_ord  label "本次次品数"
	field xx_uncomp like wo_qty_comp label "未结数量"
	field xx_comp   like wo_qty_comp label "完成数量"
	index xx_lot IS PRIMARY 
	xx_lot ascending .



define frame a .
define frame b .


form
   wo_nbr                             colon 15
   eff_date                           colon 58

   wo_rmks        format "x(33)"      colon 15
   wo_batch                           colon 58

   wo_part                            colon 15
   pt_lot_ser                         colon 58
   pt_um                              colon 65

   pt_desc1                           colon 15
   wo_status                          colon 58

   open_ref                           colon 15
   pt_auto_lot                        colon 58

with frame a side-labels width 80 attr-space.
setframelabels(frame a:handle).

/**/
form
	skip(1)
   lotserial_qty                      colon 15
   site                               colon 54
   um                                 colon 15
   location                           colon 54
   conv                               colon 15
   lotserial                          colon 54
   reject_qty                         colon 15
   lotref                             colon 54
   reject_um                          colon 15   
   reject_conv                        colon 15
   
   skip(1)
   rmks                               colon 15
   close_wo                           colon 15


with frame b side-labels width 80 attr-space.
setframelabels(frame b:handle).



form 
t_line       label "项次"     space(1)
t_lot   	 label "工单id"   space(1)
t_qty_ord    label "总订购量"   space(1)
t_qty_comp 	 label "累计完成量"   space(1)
t_qty_rjct   label "累计次品量"   space(1)
t_uncomp 	 label "未结量"   

with frame w 
scroll 1 6 down  no-validate attr-space
title "" width 80 .
setframelabels(frame w:handle).

eff_date = today.

for first gl_ctrl
   fields (gl_domain gl_rnd_mthd)
   where   gl_domain = global_domain
no-lock: end.

do transaction:

   find mfc_ctrl
       where mfc_domain = global_domain
       and   mfc_field = "fas_wo_rec"
   exclusive-lock no-error.

   if available mfc_ctrl then do:

      find first fac_ctrl
         where fac_domain = global_domain
      exclusive-lock no-error.

      if available fac_ctrl then do:
         fac_wo_rec = mfc_logical.
         delete mfc_ctrl.
      end. /* IF AVAILABLE fac_ctrl */
      release fac_ctrl.
   end. /* IF AVAILABLE mfc_ctrl */
   release mfc_ctrl.

   for first fac_ctrl
      fields (fac_domain fac_wo_rec)
      where   fac_domain = global_domain
   no-lock:
      fas_wo_rec = fac_wo_rec.
   end.

end. /* DO TRANSACTION */



mainloop:
repeat with frame a:
	transtype = "RCT-WO".
	hide frame c-1 no-pause .
	hide frame c-2  no-pause .
	view frame a .
	view frame w .

   display eff_date with frame a.
   prompt-for wo_nbr eff_date with frame a
      editing:
      if frame-field = "wo_nbr"
      then do:
         {mfnp.i wo_mstr 
				 wo_nbr  
				 " wo_mstr.wo_domain = global_domain and wo_nbr "  
				 wo_nbr 
				 wo_nbr 
				 wo_nbr}
         if recno <> ?
         then do:
			v_nbr = wo_nbr .
            display
               wo_nbr
               wo_batch
               wo_part
               wo_status
               wo_rmks.
            {&WOWORCF-P-TAG2}
            find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part
            = wo_part no-lock no-error.
            if available pt_mstr
            then
               display
                  pt_desc1
                  pt_um
                  pt_lot_ser
                  pt_auto_lot.
            else
               display
                  " " @ pt_desc1
                  " " @ pt_um
                  " " @ pt_lot_ser
                  " " @ pt_auto_lot.
         end.
      end.
      else do:
         status input.
         readkey.
         apply lastkey.
      end.
   end.

	v_nbr = input wo_nbr.
	status input.

	if v_nbr = ""   then    undo, retry.


	find first wo_mstr no-lock  where wo_mstr.wo_domain = global_domain and  wo_nbr = v_nbr no-error.
	if not available wo_mstr then do:
		{pxmsg.i &MSGNUM=510 &ERRORLEVEL=3}
		undo, retry.
	end.

	find first wo_mstr where wo_domain = global_domain and wo_nbr = v_nbr and (lookup(wo_status,"A,R") <> 0 ) no-lock no-error . /*xp001*/  
	if not available wo_mstr then do:
		message "工单非备料/发放状态,不可收货." . 
		undo, retry.
	end.

	eff_date = input eff_date.
	if eff_date = ?	then eff_date = today.

	find si_mstr  where si_mstr.si_domain = global_domain and  si_site = wo_site no-lock.
	{gpglef1.i &module = ""WO""
		&entity = si_entity
		&date   = eff_date
		&prompt = "eff_date"
		&frame  = "a"
		&loop   = "mainloop"}

	/* PREVENT PROJECT ACTIVITY RECORDING ORDERS FROM BEING UPDATED */
	if wo_fsm_type = "PRM"
	then do:
		/* CONTROLLED BY PRM MODULE*/
		{pxmsg.i &MSGNUM=3426 &ERRORLEVEL=3}
		undo, retry.
	end.

	/* PREVENT CALL ACTIVITY RECORDING ORDERS FROM BEING UPDATED */
	if wo_fsm_type = "FSM-RO"
	then do:
		/* FIELD SERVICE CONTROLLED */
		{pxmsg.i &MSGNUM=7492 &ERRORLEVEL=3}
		undo, retry.
	end.

	{gprun.i ""gpsiver.p"" "(input wo_site, input ?, output return_int)"}
	if return_int = 0
	then do:
		{pxmsg.i &MSGNUM=2710 &ERRORLEVEL=3 &MSGARG1=wo_site}
		undo mainloop, retry.
	end.

	if wo_type = "c" and wo_nbr  = ""
	then do:
		{pxmsg.i &MSGNUM=5123 &ERRORLEVEL=3} /*加工单类型是 '累计' (Cumulative)*/
		undo, retry.
	end.

	/* Word Order type is flow */
	if wo_type = "w" then do:
		{pxmsg.i &MSGNUM=5285 &ERRORLEVEL=3}
		undo, retry.
	end.

	/* CHECK FOR JOINT PRODUCT FLAGS ********************/
	if wo_joint_type <> "" then do:
		message "错误:不允许联合工单" .
		undo, retry.
	end.

	if wo_qty_ord < 0 then do:
		message "错误:不允许工单需求量为负" .
		undo, retry.
	end.

	display
		wo_nbr
		wo_batch
		wo_part
		wo_status
		wo_rmks
	with frame a.

	find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = wo_part
	no-lock no-error.

	assign
		um   = ""
		conv = 1.
	if available pt_mstr
	then do:
		um = pt_um.
		display pt_desc1 pt_um pt_lot_ser pt_auto_lot with frame a.
	end.
	else do:
		display
			"" @ pt_desc1
			"" @ pt_um
			"" @ pt_lot_ser
			"" @ pt_auto_lot
		with frame a.
	end.

	if not avail pt_mstr then do:
		message "零件编号不存在." .
		undo,retry.
	end.
	else do:  /*else if avail pt_mstr*/
		if pt_auto_lot = yes then do: /* pt_auto_lot 不同,woworcd.p的update也不同; */
			message "启用批序号自动分配,请各工单ID单独收货" .
			undo,retry.
		end.

	   if can-find(first isd_det
		  where isd_domain  = global_domain
		  and   isd_status  = string(pt_status,"x(8)") + "#"
		  and   isd_tr_type = "RCT-WO")
	   then do:
		  {pxmsg.i &MSGNUM=358
			 &ERRORLEVEL=3
			 &MSGARG1=pt_status}
		  undo , retry .
	   end. /* IF CAN-FIND(FIRST isd_det)... */



	end. /*else if avail pt_mstr*/





	if lookup(wo_status,"A,R" ) = 0
	then do:
		/* WORK ORDER LOT IS CLOSED, PLANNED OR FIRM PLANNED */
		{pxmsg.i &MSGNUM=523 &ERRORLEVEL=3}
		/* CURRENT WORK ORDER STATUS: */
		{pxmsg.i &MSGNUM=525 &ERRORLEVEL=1 &MSGARG1=wo_status}
		undo, retry.
	end.

	if wo_type    = "F" and	fas_wo_rec = false
	then do:
		/* WORK ORDER RECEIPT NOT ALLOWED FOR FINAL ASSY ORDER */
		{pxmsg.i &MSGNUM=3804 &ERRORLEVEL=3}
		undo, retry.
	end.


		wo_recno     = recid(wo_mstr).
		v_lot        = wo_lot .
		v_site       = wo_site .
		v_wopart     = wo_part .
		v_fsm_type   = wo_fsm_type .
		v_type       = wo_type .
		lotprcpt     = wo_lot_next.

	   if index("ER",wo_type) > 0
	   then
		  assign
			 wonbr    = ""
			 wolot    = "".
	   else
		  assign
			 wonbr    = wo_nbr
			 wolot    = wo_lot .
			 
	/**以上检查首笔工单,这里检查所有同nbr工单:***********/
    for each wo_mstr where wo_domain = global_domain and wo_nbr = v_nbr and lookup(wo_status,"A,R" ) <> 0 no-lock :
			if  v_site  <> wo_site  then do:
				message "错误:工单地点不一致" .
				undo,retry .
			end.
			if 	v_wopart    <> wo_part then do:
				message "工单成品编号不一致" .
				undo,retry .
			end.

			if 	v_fsm_type    <> wo_fsm_type then do:
				message "WO_FSM_TYPE不一致" .
				undo,retry .
			end.

			if 	v_type    <> wo_type then do:
				message "工单类型不一致" .
				undo,retry .
			end.

			if 	lotprcpt    <> wo_lot_next then do:
				message "工单收货批序号不一致" .
				undo,retry .
			end.

			if wo_qty_ord < 0 then do:
				message "错误:不允许工单需求量为负" .
				undo, retry.
			end.

			if wo_fsm_type = "PRM"
			then do:
				/* CONTROLLED BY PRM MODULE*/
				{pxmsg.i &MSGNUM=3426 &ERRORLEVEL=3}
				undo, retry.
			end.
			if wo_fsm_type = "FSM-RO"
			then do:
				/* FIELD SERVICE CONTROLLED */
				{pxmsg.i &MSGNUM=7492 &ERRORLEVEL=3}
				undo, retry.
			end.

			if wo_type = "c" and wo_nbr  = ""
			then do:
				{pxmsg.i &MSGNUM=5123 &ERRORLEVEL=3} /*加工单类型是 '累计' (Cumulative)*/
				undo, retry.
			end.	
			if wo_type = "w" then do:
				{pxmsg.i &MSGNUM=5285 &ERRORLEVEL=3} /* Word Order type is flow */
				undo, retry.
			end.
			if wo_type    = "F" and	fas_wo_rec = false
			then do:
				/* WORK ORDER RECEIPT NOT ALLOWED FOR FINAL ASSY ORDER */
				{pxmsg.i &MSGNUM=3804 &ERRORLEVEL=3}
				undo, retry.
			end.

			if wo_joint_type <> "" then do:
				message "错误:不允许联合工单" .
				undo, retry.
			end.

			if lookup(wo_status,"A,R" ) = 0
			then do:
				/* WORK ORDER LOT IS CLOSED, PLANNED OR FIRM PLANNED */
				{pxmsg.i &MSGNUM=523 &ERRORLEVEL=3}
				/* CURRENT WORK ORDER STATUS: */
				{pxmsg.i &MSGNUM=525 &ERRORLEVEL=1 &MSGARG1=wo_status}
				undo, retry.
			end.

	end. /*for each wo_mstr*/

	/*检查无误,产生临时table: */
	v_qty_ord  = 0 .
	v_qty_comp = 0 .
	v_qty_rjct = 0 .
	v_line = 0.
	open_ref = 0 .
	for each temp : delete temp . end.
    for each wo_mstr where wo_domain = global_domain and wo_nbr = v_nbr  and lookup(wo_status,"A,R" ) <> 0 no-lock :
		find first temp where t_lot = wo_lot no-lock no-error .
		if not avail temp then do:	
			v_line = v_line + 1 .
			create temp.
			assign 
				t_nbr = wo_nbr .
				t_lot = wo_lot .
				t_part     = wo_part.
				t_line     = string(v_line) .
				t_qty_ord  = wo_qty_ord .
				t_qty_comp = wo_qty_comp.
				t_qty_rjct = wo_qty_rjct.
				t_uncomp   = wo_qty_ord - wo_qty_comp - wo_qty_rjct .
				open_ref = t_uncomp + open_ref .

			v_qty_ord  = v_qty_ord  + wo_qty_ord .
			v_qty_comp = v_qty_comp + wo_qty_comp .
			v_qty_rjct = v_qty_rjct + wo_qty_rjct .
		end.
	end. /*for each wo_mstr*/

	disp open_ref with frame a .



	/*run /home/mfg/test/xxworc001a.p .**************/
   {gprun.i ""xxworc001a.p""}  /*disp details with frame w*/


find first wo_mstr  where recid(wo_mstr) = wo_recno  exclusive-lock no-error.
	assign
		global_part = wo_part
		lotserial_qty = 0
		reject_qty    = 0
		close_wo      = no
		rmks          = ""
		um            = ""
		reject_um     = ""
		conv              = 1
        reject_conv       = 1
		site = wo_site
		/*location = wo_loc */
		location = "100"
		lotserial = wo_lot_next .

        lotserial_control = "".

   if available pt_mstr then
      assign
         um        = pt_um
         reject_um = pt_um

		 lotserial_control = pt_lot_ser.


	/*if location = "" and available pt_mstr  then location = pt_loc.*/


locloop:
do on error undo ,retry :
	hide frame w no-pause.
	view frame b .

	disp    lotserial_qty  um conv 
			reject_qty  reject_um reject_conv 
			site  location  lotserial lotref 
			rmks  close_wo  with frame b .

	update	lotserial_qty  um conv 
			reject_qty  reject_um reject_conv 
			site  location  lotserial lotref 
			rmks  close_wo  
	with frame b editing:

		  assign
			 global_site = input site
			 global_loc = input location
			 global_lot = input lotserial
			 global_ref = input lotref.
		  readkey.
		  apply lastkey.
	end. /* EDITING */


		if rmks <> "" then do:
			old_rmks = rmks .
			rmks = REPLACE(rmks," ","") .  /*单字节空格*/
			rmks = REPLACE(rmks,"　","") . /*双字节空格*/
			if old_rmks <> rmks then do:
				message "警告:注释中的空格已删除 ." .
			end.
		end.

	    if um <> pt_um
	    then do:

		  if not conv entered
		  then do:

			 {gprun.i ""gpumcnv.p"" "(input  um,
									  input  pt_um,
									  input  wo_part,
									  output conv)"}

			 if conv = ?
			 then do:

				/* NO UNIT OF MEASURE EXISTS */
				{pxmsg.i &MSGNUM=33 &ERRORLEVEL=2}
				conv = 1.
			 end. /* IF conv = ? */
			 display conv with frame b.
		  end. /* IF NOT conv ENTERED */
	    end. /* IF um <> pt_um */

		if reject_um <> pt_um
		then do:

		  if not reject_conv entered
		  then do:

			 {gprun.i ""gpumcnv.p"" "(input  reject_um,
									  input  pt_um,
									  input  wo_part,
									  output reject_conv)"}
			 if reject_conv = ?
			 then do:
				/* NO UNIT OF MEASURE EXISTS */
				{pxmsg.i &MSGNUM=33 &ERRORLEVEL=2}
				reject_conv = 1.
			 end. /* IF reject_conv = ? */
			 display reject_conv with frame b.
		  end. /* IF NOT reject_conv ENTERED */
		end. /* IF REJECT_UM <> PT_UM */

		if reject_qty <> 0
		then do:
		   if can-find(first isd_det
			  where isd_domain  = global_domain
			  and   isd_status  = string(pt_status,"x(8)") + "#"
			  and   isd_tr_type = "RJCT-WO")
		   then do:
			  {pxmsg.i &MSGNUM=358
				 &ERRORLEVEL=3
				 &MSGARG1=pt_status}
			  undo locloop, retry locloop.
		   end. /* IF CAN-FIND(FIRST isd_det)... */
		end. /* IF reject_qty > 0 */

		if lotserial_qty <> 0
		then do:
		   if can-find(first isd_det
			  where isd_domain  = global_domain
			  and   isd_status  = string(pt_status,"x(8)") + "#"
			  and   isd_tr_type = "RCT-WO")
		   then do:
			  {pxmsg.i &MSGNUM=358
				 &ERRORLEVEL=3
				 &MSGARG1=pt_status}
			  undo locloop, retry locloop.
		   end. /* IF CAN-FIND(FIRST isd_det)... */
		end. /* IF reject_qty > 0 */
		
		find first si_mstr where si_domain = global_domain 
						   and si_site = site 
		no-lock no-error.
		if not avail si_mstr then do:
			message "地点无效" .
			site = wo_site .
			next-prompt site with frame b.
			undo,retry.
		end.

		find first loc_mstr where loc_domain = global_domain 
						   and loc_site = site 
						   and loc_loc  = location
		no-lock no-error.
		if not avail loc_mstr then do:
			message "库位无效" .
			 location = wo_loc .
			next-prompt  location  with frame b.
			undo,retry.
		end.

        if lotserial_qty <> 0
               then do:

                  if available pt_mstr
                  and pt_lot_ser <> ""
                  and available wo_mstr
                  and wo_fsm_type = "RMA"
                  and wonbr       = ""
                  then
                     l_yn = yes.

                  /* FOR WORK ORDERS RELEASED FROM RMA, SET TRANSACTION */
                  /* TYPE TO "RCT-WOR" IF ITEM-LOT/SERIAL ISSUED TO WO  */
                  /* IS SAME AS FOR RECEIPT.                            */

                  if  available pt_mstr
                  and pt_lot_ser <> ""
                  and l_yn
                  then
						 for first tr_hist
							fields( tr_domain tr_fsm_type tr_nbr tr_part tr_serial
							tr_type)
							 where tr_hist.tr_domain = global_domain and  tr_nbr
							   = wo_nbr
							and   tr_part     = wo_part
							and   tr_serial   = lotserial
							and   tr_type     = "ISS-WO"
							and   tr_fsm_type = "RMA"
							no-lock:
							transtype = "RCT-WOR".
						 end. /* FOR FIRST tr_hist */

                  /* CHANGED FIRST INPUT PARAMETER TO transtype */
                  /* FROM ""RCT-WO""                            */

                  { gprun.i ""icedit.p"" " ( input  transtype,
                                             input  site,
                                             input  location,
                                             input  wo_part,
                                             input  lotserial,
                                             input  lotref,
                                             input  lotserial_qty * conv,
                                             input  um,
                                             input  wonbr,
                                             input  wolot,
                                             output yn )"
                  }
                  if yn
                  then
                     undo locloop, retry.
        end. /* IF lotserial_qty <> 0 */


	   if wo_site <> site
	   then do:

		  if lotserial_qty <> 0
		  then do:
			 {gprun.i ""icedit4.p"" "(input ""RCT-WO"",
									  input wo_site,
									  input site,
									  input pt_loc,
									  input location,
									  input wo_part,
									  input lotserial,
									  input lotref,
									  input lotserial_qty
											* conv,
									  input um,
									  input wonbr,
									  input wolot,
									  output yn)"
			 }
			 if yn then
				undo locloop, retry.
		  end. /* IF lotserial_qty <> 0 */
	   end. /* IF wo_site <> site */

         if ((lotserial_qty * conv > 0) and
            (reject_qty * reject_conv < 0)) or
            ((lotserial_qty * conv < 0) and
            (reject_qty * reject_conv > 0))
         then do:

            /*GOOD & SCRAPPED MUST HAVE SAME SIGN*/
            {pxmsg.i &MSGNUM=502 &ERRORLEVEL=3}
            reject_qty = 0.
			next-prompt reject_qty  with frame b.
            undo, retry.
         end. /* IF ((total_lotserial_qty * conv > 0) */

         /* CHECK FOR lotserial_qty ENTERED */
         if (v_qty_ord > 0 and (v_qty_comp + (lotserial_qty * conv)) < 0) or
            (v_qty_ord < 0 and (v_qty_comp + (lotserial_qty * conv)) > 0)
         then do:

            /*REVERSE RCPT MAY NOT EXCEED PREV RCPT*/
            {pxmsg.i &MSGNUM=556 &ERRORLEVEL=3}
            lotserial_qty = 0 .
			reject_qty = 0.
			next-prompt lotserial_qty  with frame b.
            undo, retry.
         end. /* IF (v_qty_ord > 0 */

         /* CHECK FOR reject_qty ENTERED */
         if (v_qty_ord > 0 and (v_qty_rjct + (reject_qty * reject_conv)) < 0) or
            (v_qty_ord < 0 and (v_qty_rjct + (reject_qty * reject_conv)) >  0)
         then do:

            /*REVERSE SCRAP MAY NOT EXCEED PREV SCRAP*/
            {pxmsg.i &MSGNUM=1373 &ERRORLEVEL=3}.
            reject_qty = 0.
			next-prompt reject_qty  with frame b.
            undo, retry.
         end. /* IF (v_qty_ord > 0 */



		for each xxwo : delete xxwo . end.
		/*********part_A: 算各ID入库数*/
		if lotserial_qty <> 0 then do:
			v_qty_open = lotserial_qty .
			for each temp no-lock break by t_nbr by t_lot :
				if lotserial_qty >  0  then do:
					if t_uncomp < v_qty_open then do:
						create xxwo.
						assign 
							xx_nbr  = t_nbr
							xx_lot  = t_lot 
							xx_uncomp = t_uncomp
							xx_comp   = t_qty_comp
							xx_rjct   = 0
							xx_qty    = t_uncomp.
							
							v_qty_open = v_qty_open - t_uncomp.

						if last-of(t_nbr) and v_qty_open <> 0 then do:
							xx_qty = xx_qty + v_qty_open .
						end.

					end.
					else do:
						create xxwo.
						assign 
							xx_nbr  = t_nbr
							xx_lot  = t_lot 
							xx_uncomp = t_uncomp
							xx_comp   = t_qty_comp
							xx_rjct   = 0
							xx_qty    = v_qty_open.
						v_qty_open = 0.	
						leave .
					end.
				end. /*if lotserial_qty >=  0 */
				else do: /*if lotserial_qty < 0 */
					if t_qty_comp < - v_qty_open then do:
						create xxwo.
						assign 
							xx_nbr  = t_nbr
							xx_lot  = t_lot 
							xx_uncomp = t_uncomp
							xx_comp   = t_qty_comp
							xx_rjct   = 0
							xx_qty    = - t_qty_comp.
							
							v_qty_open = v_qty_open + t_qty_comp.

						if last-of(t_nbr) and v_qty_open <> 0 then do:
							xx_qty = xx_qty + v_qty_open .
						end.  /*这种情况应该不会出现,总量不可超*/

					end.
					else do:
						create xxwo.
						assign 
							xx_nbr  = t_nbr
							xx_lot  = t_lot 
							xx_uncomp = t_uncomp
							xx_comp   = t_qty_comp
							xx_rjct   = 0
							xx_qty    = v_qty_open.
						v_qty_open = 0.	
						leave .
					end.
				end.  /*if lotserial_qty < 0 */

			end. /*for each temp*/
		end. /*if lotserial_qty <> 0 */

		/*********part_B: 算各ID中的次品数*/
		if reject_qty <> 0 then do:
			v_qty_open = reject_qty .
			for each temp no-lock break by t_nbr by t_lot :
				if reject_qty  >=  0  then do:
					if t_uncomp < v_qty_open then do:
						find first xxwo where xx_lot = t_lot no-error .
						if not avail xxwo then do:
							create xxwo.
							assign 
								xx_nbr  = t_nbr
								xx_lot  = t_lot 
								xx_uncomp = t_uncomp
								xx_comp   = t_qty_comp
								xx_qty = 0.
						end.
							xx_rjct    = t_uncomp.
							
							v_qty_open = v_qty_open - t_uncomp.

						if last-of(t_nbr) and v_qty_open <> 0 then do:
							xx_rjct = xx_rjct + v_qty_open .
						end.

					end.
					else do:
						find first xxwo where xx_lot = t_lot no-error .
						if not avail xxwo then do:
							create xxwo.
							assign 
								xx_nbr  = t_nbr
								xx_lot  = t_lot 
								xx_uncomp = t_uncomp
								xx_comp   = t_qty_comp
								xx_qty = 0.
						end.
							xx_rjct    = v_qty_open.
						v_qty_open = 0.	
						leave .
					end.
				end. /*if reject_qty  >=  0 */
				else do:   /*if reject_qty < 0 */
					if t_qty_rjct < - v_qty_open then do:
						find first xxwo where xx_lot = t_lot no-error .
						if not avail xxwo then do:
							create xxwo.
							assign 
								xx_nbr  = t_nbr
								xx_lot  = t_lot 
								xx_uncomp = t_uncomp
								xx_comp   = t_qty_comp
								xx_qty = 0.
						end.
							xx_rjct    = - t_qty_rjct.
							
							v_qty_open = v_qty_open + t_qty_rjct.

						if last-of(t_nbr) and v_qty_open <> 0 then do:
							xx_rjct = xx_rjct + v_qty_open .
						end. /*这种情况应该不会出现,总量不可超*/

					end.
					else do:
						find first xxwo where xx_lot = t_lot no-error .
						if not avail xxwo then do:
							create xxwo.
							assign 
								xx_nbr  = t_nbr
								xx_lot  = t_lot 
								xx_uncomp = t_uncomp
								xx_comp   = t_qty_comp
								xx_qty = 0.
						end.
						xx_rjct    = v_qty_open.
						v_qty_open = 0.	
						leave .
					end.
				end.  /*if reject_qty < 0 */

			end. /*for each temp*/
		end. /*if reject_qty <> 0*/


		do on endkey undo locloop, retry locloop:
			yn = yes.
            /* Display lotserials being received? */
            {pxmsg.i &MSGNUM=359 &ERRORLEVEL=1 &CONFIRM=yn}
            if yn
            then do:

               hide frame a.
			   hide frame b.
			   hide frame w.
               form
                     wo_nbr  colon 15   site colon 45          location  colon 68  skip
					 wo_part colon 15   lotserial  colon 45    lotref  colon 68 
               with frame c-1 side-labels width 80.
               setFrameLabels(frame c-1:handle).
               display wo_nbr wo_part site location lotserial lotref with frame c-1.

               for each xxwo no-lock break by xx_lot 
                  with frame c-2 width 80:
                  setFrameLabels(frame c-2:handle).
                  display 
                           xx_lot
						   xx_comp 
						   xx_uncomp
                           xx_qty 
						   xx_rjct.
               end. /* FOR EACH sr_wkfl */
            end. /* IF yn */
		end. /*do on endkey undo locloop, retry locloop:*/

         do on endkey undo  locloop, retry  locloop:

            yn = yes.
            /* "IS ALL INFO CORRECT?" */
            {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=yn}

            if yn
            then do:

				{gplock1.i  &domain="wo_mstr.wo_domain = global_domain and "
							&file-name      = wo_mstr
							&group-criteria = "wo_mstr.wo_nbr = v_nbr  and (lookup(wo_status,'A,R') <> 0 ) "
							&find-criteria  = "recid(wo_mstr) = wo_recno"
							&undo-block     = locloop
							&retry          = "retry locloop"
							&record-id      = recno} 
				

					/*********cimload here***********/


					outfile = "xxworc_" 
							+ substring(string(today),1,2) 
							+ substring(string(today),4,2)
							+ substring(string(today),7,2) 
							+ "_" + substring(string(time,"hh:mm"),1,2)
							+ ":" + substring(string(time,"hh:mm"),4,2) 
							+ ".prn".	       


					output to value(outfile ).


							for each xxwo no-lock break by xx_nbr by xx_lot :
								/**line1**/
								put unformatted 
									quote xx_nbr     quote space
									quote xx_lot     quote space
									trim(string(eff_date))  space skip .
								/**line2**/
								put unformatted xx_qty space .

								if um <> ""  then 
									  put unformatted 	quote um   quote space .
								else  put unformatted 	"-" space .

								put unformatted 	conv   space. 
								put unformatted 	xx_rjct space .

								if reject_um <> ""  then 
									  put unformatted 	quote reject_um   quote space .
								else  put unformatted 	"-" space .

								put unformatted 	reject_conv  space.

								if site <> ""  then 
									  put unformatted 	quote site   quote space .
								else  put unformatted 	"-" space .
								if location <> ""  then 
									  put unformatted 	quote location   quote space .
								else  put unformatted 	"-" space .
								if lotserial <> ""  then 
									  put unformatted 	quote lotserial   quote space .
								else  put unformatted 	"-" space .
								if lotref <> ""  then 
									  put unformatted 	quote lotref   quote space .
								else  put unformatted 	"-" space .

								put unformatted 	"N" space "N" space skip .

								/**line3**/
								if rmks <> ""  then 
									  put unformatted 	quote rmks   quote space .
								else  put unformatted 	"-" space .
								if close_wo = no then put unformatted   "N" space skip .
								else put unformatted   "Y" space skip .
								
								put unformatted   "Y" space skip . /*disp all?*/
								put unformatted   "Y" space skip . /*all correct?*/
								

							end. /*for each xxwo no-lock*/

					output close.

					/** 数据开始更新处理**/
					/**do transaction on error undo,retry:end.   do transaction ***/

						batchrun = yes.
						outfile1  = outfile + ".o".

						input from value(outfile).
						output to  value (outfile1) .

						{gprun.i ""woworc.p""}

						input close.
						output close.
					

					run write_error_to_log(input outfile,input outfile1 ,output v_ok) . 
					if not v_ok then do:
						message "有错误发生,请参考log.err最后几行" view-as alert-box.
					end.

					  

				release wo_mstr.
            end. /* if yn */
			else do:
			hide frame c-1 no-pause .
			hide frame c-2  no-pause .
			end.


         end. /* do on endkey  */



hide frame c-1 no-pause .
hide frame c-2  no-pause .

end. /*locloop:*/



hide frame c-1 no-pause .
hide frame c-2  no-pause .
end. /* mainloop */


/********************************************************/

procedure write_error_to_log:
	define input parameter file_name as char .
	define input parameter file_name_o as char .
	define output parameter v_ok as logical .
	define variable linechar as char .
	define variable woutputstatment as char.

	linechar = "" .
	input from value (file_name_o) .

		repeat: 
			import unformatted woutputstatment.                         

			IF  index (woutputstatment,"ERROR:")   <> 0 OR    /* for us langx */ 
				index (woutputstatment,"错误:")	<> 0 OR    /* for ch langx */
				index (woutputstatment,"岿粇:")	<> 0       /* for tw langx */ 		     
			then do:			  
				output to  value ( "log.err") APPEND.
					put unformatted today " " string (time,"hh:mm:ss")  " " file_name_o " " woutputstatment  skip.
				output close.
				linechar = "ERROR" .			  
			end.		     
		End.

	input close.

	if linechar <> "ERROR" then do:
		unix silent value ("rm -f "  + trim(file_name)).
		unix silent value ("rm -f "  + trim(file_name_o)).
	end. 

	v_ok = if linechar = "ERROR" then no else yes .

end. /*PROCEDURE write_error_to_log*/