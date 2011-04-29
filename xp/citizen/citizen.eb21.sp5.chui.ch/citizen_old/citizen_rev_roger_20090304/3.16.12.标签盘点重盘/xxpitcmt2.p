/* xxpitcmt2.p - TAG RECOUNT ENTRY                                                */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */


/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/********************************************************************/
/* NOTE:  GENERAL CODE CLEANUP PLUS ADDED SITE SECURITY CHECK       */
/* NOTE:  RE-INDENTED ENTIRE PROGRAM, ADDED MAINLOOP, TAGLOOP,      */
/*        AND SETCNT LABELS AND REFERENCES TO THOSE ON UNDO'S.      */
/********************************************************************/

/*V8:ConvertMode=Maintenance                                                  */

{mfdtitle.i "1+ "}

define variable new_count like mfc_logical.
define variable new_date  as date.
define variable new_name  as character.
define variable yn        like mfc_logical.
define variable trans-ok  like mfc_logical.

define var v_site like tag_site label "地点".
define var v_loc  like tag_loc  label "库位".
define var v_part like pt_part  label "部品/成品编号" .
define var v_serial like tag_serial label "批/序号" .
define var v_ref  like tag_ref  label "参考" .
define var v_nbr  like tag_nbr  label "标签号".
define var v_qty_frz like ld_qty_frz label "冻结数量" .
define var v_qty_cnt like tag_cnt_qty label "盘点数量" .

form
   v_site           colon 20
      si_desc       no-label
   v_loc            colon 20
      loc_desc      no-label
   v_part           colon 20
      pt_um
      in_abc
      pt_desc1      colon 20
      pt_desc2      at 22 no-label
   v_serial         colon 20
   v_ref		    colon 20
   v_nbr            colon 20
   skip(1)
   v_qty_frz     colon 20
   tag_rcnt_qty  colon 50
   tag_cnt_qty   colon 20  
   v_qty_cnt     colon 50
   tag_cnt_um    colon 20
   tag_rcnt_um   colon 50
   tag_cnt_cnv   colon 20
   tag_rcnt_cnv  colon 50
   tag_cnt_nam   colon 20
   tag_rcnt_nam  colon 50
   tag_cnt_dt    colon 20
   tag_rcnt_dt   colon 50
   skip(1)
   tag_rmks      colon 20
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

mainloop:
repeat with frame a:
	clear frame a no-pause .

	prompt-for v_site v_loc with frame a editing:
		if frame-field = "v_site" then do:
			{mfnp.i si_mstr v_site  " si_domain = global_domain and si_site "  v_site si_site si_site}
			if recno <> ? then do:
				v_site = si_site .
				display v_site si_desc.
			end.  /* IF RECNO <> ? */
		end.
		else if frame-field = "v_loc" then do:
			{mfnp01.i loc_mstr v_loc  " loc_domain = global_domain and loc_loc "  "input v_site" loc_site loc_loc}
			if recno <> ? then do:
				v_site = loc_site .
				v_loc  = loc_loc  .
				find si_mstr   where si_mstr.si_domain = global_domain and  si_site = input v_site no-lock no-error.
				display v_site v_loc si_desc loc_desc.
			end.  /* IF RECNO <> ? */
		end.
		else do:
			status input.
			readkey.
			apply lastkey.
		end.
	end. /* PROMPT-FOR... EDITING */
	assign v_site v_loc .

	find si_mstr   where si_mstr.si_domain = global_domain and  si_site = v_site no-lock no-error.
	if not avail si_mstr then do:
		message "地点无效,请重新输入" .
		next-prompt v_site with frame a.
		undo ,retry.
	end.

	if available si_mstr then do:
		{gprun.i ""gpsiver.p""
		"(input si_site, input recid(si_mstr), output return_int)"}
		if return_int = 0 then do:
			{pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
			next-prompt v_site with frame a.
			undo mainloop, retry mainloop.
		end.
		disp v_site si_desc .
	end.


	find loc_mstr  where loc_mstr.loc_domain = global_domain and  loc_site = v_site and loc_loc = v_loc no-lock no-error.
	if not avail loc_mstr then do:
		message "库位无效,请重新输入" .
		next-prompt v_loc with frame a.
		undo ,retry.
	end.
	else do:
		disp v_loc loc_desc .
	end.

v_qty_frz = 0 .
v_qty_cnt = 0 .

loopnbr:
repeat with frame a:
	prompt-for v_part v_serial v_ref v_nbr with frame a editing:
		if frame-field = "v_part" then do:
			{mfnp.i tag_mstr 
					v_part  
					" tag_mstr.tag_domain = global_domain 
						and tag_site = v_site 
						and tag_loc = v_loc 
						and tag_part "  
					v_part
					tag_part 
					tag_slpsn
			}
			if recno <> ? then do:
				 find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = tag_part no-lock no-error.
				 find in_mstr  where in_mstr.in_domain = global_domain and  in_part = tag_part and in_site = tag_site no-lock no-error.
				 find ld_det   where ld_domain = global_domain and ld_site = tag_site and ld_loc = tag_loc 
								 and ld_part = tag_part and ld_lot = tag_serial and ld_ref = tag_ref no-lock no-error .
				 if avail ld_Det then disp ld_qty_frz @ v_qty_frz with frame a .
				 else disp 0 @ v_qty_frz with frame a .

				 if available pt_mstr then
				 display
					pt_um
					pt_desc1
					pt_desc2.

				 else
				 display
					"" @ pt_um
					"" @ pt_desc1
					"" @ pt_desc2.

				 if available in_mstr then
					display in_abc.
				 else
					display "" @ in_abc.

				 display
					tag_nbr @ v_nbr 
					tag_part @ v_part 
					tag_serial @ v_serial
					tag_ref @ v_Ref
					tag_rcnt_qty
					tag_rcnt_um
					tag_rcnt_cnv
					tag_rcnt_nam
					tag_rcnt_dt
					tag_rmks.
			end.  /* IF RECNO <> ? */
		end.
		else if frame-field = "v_serial" then do:
			{mfnp.i tag_mstr 
					v_serial  
					" tag_mstr.tag_domain = global_domain 
						and tag_site = v_site 
						and tag_loc  = v_loc 
						and tag_part = input v_part 
						and tag_serial "  
					v_serial
					tag_serial 
					tag_slpsn
			}
			if recno <> ? then do:
				 find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = tag_part no-lock no-error.
				 find in_mstr  where in_mstr.in_domain = global_domain and  in_part = tag_part and in_site = tag_site no-lock no-error.
				 find ld_det   where ld_domain = global_domain and ld_site = tag_site and ld_loc = tag_loc 
								 and ld_part = tag_part and ld_lot = tag_serial and ld_ref = tag_ref no-lock no-error .
				 if avail ld_Det then disp ld_qty_frz @ v_qty_frz with frame a .
				 else disp 0 @ v_qty_frz with frame a .				 
				 
				 if available pt_mstr then
				 display
					pt_um
					pt_desc1
					pt_desc2.

				 else
				 display
					"" @ pt_um
					"" @ pt_desc1
					"" @ pt_desc2.

				 if available in_mstr then
					display in_abc.
				 else
					display "" @ in_abc.

				 display
					tag_nbr @ v_nbr 
					tag_part @ v_part 
					tag_serial @ v_serial
					tag_ref @ v_Ref
					tag_rcnt_qty
					tag_rcnt_um
					tag_rcnt_cnv
					tag_rcnt_nam
					tag_rcnt_dt
					tag_rmks.
			end.  /* IF RECNO <> ? */
		end.
		else if frame-field = "v_ref" then do:
			{mfnp.i tag_mstr 
					v_ref  
					" tag_mstr.tag_domain = global_domain 
						and tag_site = v_site 
						and tag_loc  = v_loc 
						and tag_part = input v_part 
						and tag_serial = input v_serial
						and tag_ref "  
					v_ref
					tag_ref
					tag_slpsn
			}
			if recno <> ? then do:
				 find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = tag_part no-lock no-error.
				 find in_mstr  where in_mstr.in_domain = global_domain and  in_part = tag_part and in_site = tag_site no-lock no-error.
				 find ld_det   where ld_domain = global_domain and ld_site = tag_site and ld_loc = tag_loc 
								 and ld_part = tag_part and ld_lot = tag_serial and ld_ref = tag_ref no-lock no-error .
				 if avail ld_Det then disp ld_qty_frz @ v_qty_frz with frame a .
				 else disp 0 @ v_qty_frz with frame a .
				 
				 if available pt_mstr then
				 display
					pt_um
					pt_desc1
					pt_desc2.

				 else
				 display
					"" @ pt_um
					"" @ pt_desc1
					"" @ pt_desc2.

				 if available in_mstr then
					display in_abc.
				 else
					display "" @ in_abc.

				 display
					tag_nbr @ v_nbr 
					tag_part @ v_part 
					tag_serial @ v_serial
					tag_ref @ v_Ref
					tag_rcnt_qty
					tag_rcnt_um
					tag_rcnt_cnv
					tag_rcnt_nam
					tag_rcnt_dt
					tag_rmks.
			end.  /* IF RECNO <> ? */
		end.
		else if frame-field = "v_nbr" then do:
			{mfnp.i tag_mstr 
					v_nbr  
					" tag_mstr.tag_domain = global_domain 
						and tag_site = v_site 
						and tag_loc  = v_loc 
						and tag_part = input v_part 
						and tag_serial = input v_serial
						and tag_ref = input v_ref 
						and tag_nbr"  
					v_nbr
					tag_nbr
					tag_slpsn
			}
			if recno <> ? then do:
				 find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = tag_part no-lock no-error.
				 find in_mstr  where in_mstr.in_domain = global_domain and  in_part = tag_part and in_site = tag_site no-lock no-error.
				 find ld_det   where ld_domain = global_domain and ld_site = tag_site and ld_loc = tag_loc 
								 and ld_part = tag_part and ld_lot = tag_serial and ld_ref = tag_ref no-lock no-error .
				 if avail ld_Det then disp ld_qty_frz @ v_qty_frz with frame a .
				 else disp 0 @ v_qty_frz with frame a .				 
				 
				 if available pt_mstr then
				 display
					pt_um
					pt_desc1
					pt_desc2.

				 else
				 display
					"" @ pt_um
					"" @ pt_desc1
					"" @ pt_desc2.

				 if available in_mstr then
					display in_abc.
				 else
					display "" @ in_abc.

				 display
					tag_nbr @ v_nbr 
					tag_part @ v_part 
					tag_serial @ v_serial
					tag_ref @ v_Ref
					tag_rcnt_qty
					tag_rcnt_um
					tag_rcnt_cnv
					tag_rcnt_nam
					tag_rcnt_dt
					tag_rmks.
			end.  /* IF RECNO <> ? */
		end.
		else do:
			status input.
			readkey.
			apply lastkey.
		end.
	end. /* PROMPT-FOR... EDITING */
	assign v_part v_serial v_ref v_nbr .



find tag_mstr use-index tag_slpsn 
	where tag_mstr.tag_domain = global_domain
	and tag_site = v_site 
	and tag_loc  = v_loc 
	and tag_part = v_part 
	and tag_serial = v_serial
	and tag_ref =  v_ref 	
	and tag_nbr = v_nbr 
exclusive-lock no-error.
   if not available tag_mstr then do:
      {pxmsg.i &MSGNUM=281 &ERRORLEVEL=3} /* TAG RECORD DOES NOT EXIST */
      undo , retry.
   end.

   if tag_void then do:
      {pxmsg.i &MSGNUM=710 &ERRORLEVEL=3} /* TAG RECORD HAS BEEN VOIDED */
      undo , retry.
   end.

   if tag_posted then do:
      {pxmsg.i &MSGNUM=4100 &ERRORLEVEL=3} /* TAG HAS BEEN POSTED */
      undo , retry.
   end.

   if tag_cnt_dt = ? then do:
      {pxmsg.i &MSGNUM=713 &ERRORLEVEL=3}  /*初盘未输入*/
      undo mainloop, retry.
   end.


	/* if TAG_TYPE = "B" then do:
		message "标签类型:(B)ulk,请使用标准程式盘点".
		undo , retry.
	end.  IF TAG_TYPE = "B" */

   find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
   tag_part no-lock no-error.
   find in_mstr  where in_mstr.in_domain = global_domain and  in_part =
   tag_part and in_site = tag_site
   no-lock no-error.
   find si_mstr   where si_mstr.si_domain = global_domain and  si_site =
   tag_site no-lock no-error.
   find loc_mstr  where loc_mstr.loc_domain = global_domain and  loc_site =
   tag_site and loc_loc = tag_loc
   no-lock no-error.
   find ld_det   where ld_domain = global_domain and ld_site = tag_site and ld_loc = tag_loc 
				 and ld_part = tag_part and ld_lot = tag_serial and ld_ref = tag_ref no-lock no-error .
   if avail ld_Det then disp ld_qty_frz @ v_qty_frz with frame a .
   else disp 0 @ v_qty_frz with frame a .

   display
      tag_nbr @ v_nbr
      tag_site @ v_site
      tag_loc @ v_loc
      tag_part @ v_part .

   /* MAKE SURE THAT ITEM STATUS ALLOWS TRANSTYPE */
   if available pt_mstr
   then do:
      if can-find(first isd_det
                     where isd_domain  = global_domain
                     and   isd_status  = string(pt_status,"x(8)") + "#"
                     and   isd_tr_type = "TAG-CNT")
      then do:
         /* RESTRICTED PROCEDURE FOR ITEM STATUS CODE */
         {pxmsg.i &MSGNUM=358
                  &ERRORLEVEL=3
                  &MSGARG1=pt_mstr.pt_status}
         undo , retry.
      end. /*IF CAN-FIND (FIRST isd_det */
   end. /* IF AVAILABLE pt_mstr */

   if available pt_mstr then
      display
         pt_um
         pt_desc1
         pt_desc2.
   else
      display
         "" @ pt_um
         "" @ pt_desc1
         "" @ pt_desc2.

   if available in_mstr then
      display in_abc.
   else
      display "" @ in_abc.
   if available si_mstr then
      display si_desc.
   else
      display "" @ si_desc.
   if available loc_mstr then
      display loc_desc.
   else
      display "" @ loc_desc.

   display
      tag_serial @ v_serial
      tag_ref    @ v_ref
      tag_rcnt_qty
      tag_rcnt_um
      tag_rcnt_cnv
      tag_rcnt_nam
      tag_rcnt_dt
      tag_rmks.


	if TAG_TYPE = "B" then do:
		/*removed by roger *******************************************/
	end.  /* IF TAG_TYPE = "B" */

   ststatus = stline[3].
   status input ststatus.

   for first pt_mstr
      fields (pt_part  pt_loc_type pt_lot_ser pt_um
              pt_desc1 pt_desc2    pt_domain)
      where pt_mstr.pt_domain = global_domain
      and   pt_part           = tag_part
   no-lock:
   end. /* FOR FIRST pt_mstr */

   if available pt_mstr
   then do:

      for first loc_mstr
         fields(loc_site loc_loc loc_type loc_domain)
         where loc_mstr.loc_domain = global_domain
         and   loc_site            = tag_site
         and   loc_loc             = tag_loc
      no-lock:
      end. /* FOR FIRST loc_mstr */

      if ((available loc_mstr
          and loc_type <> pt_loc_type)
          or (not available loc_mstr))
      then do:
         /* INVALID LOCATION TYPE FOR ITEM */
         {pxmsg.i &MSGNUM=240 &ERRORLEVEL=2}
      end. /* IF AVAILABLE loc_mstr */

   end. /* IF AVAILABLE pt_mstr */



   new_count = no.
   if tag_rcnt_dt = ? then
   assign
      tag_rcnt_um = tag_cnt_um
      tag_rcnt_cnv = tag_cnt_cnv
      tag_rcnt_dt = new_date
      tag_rcnt_nam = new_name
	  v_qty_cnt = 0
      new_count = yes.

   /* THE FOLLOWING CODE ENSURES THAT FOR SERIAL CONTROLLED ITEMS   */
   /* THE QUANTITY RECOUNTED IS NOT LESSER THAN -1 AND NOT GREATER  */
   /* THAN 1 AND THE RECOUNT UM IS THE SAME AS THAT ENTERED IN THE  */
   /* ITEM MASTER                                                   */

   if available pt_mstr
      and pt_lot_ser = "S"
      then do on error undo, retry:

      update
         tag_rcnt_qty
         tag_rcnt_um.

      /* QUANTITY RECOUNTED VALIDATION */
      if (tag_rcnt_qty < -1)
         or (tag_rcnt_qty >  1)
      then do:
         /* QUANTITY MUST BE -1, 0 OR 1 */
         {pxmsg.i
            &MSGNUM     = 4562
            &ERRORLEVEL = 3}
         undo, retry.
      end. /* IF tag_rcnt_qty < -1 */

      /* RECOUNT UM VALIDATION */
      if tag_rcnt_um <> pt_um
      then do:
         /* UM MUST BE EQUAL TO STOCKING   */
         /* UM FOR SERIAL-CONTROLLED ITEMS */
         {pxmsg.i
            &MSGNUM     = 367
            &ERRORLEVEL = 3}
         undo, retry.
      end. /* IF tag_rcnt_um <> pt_um */

   end. /* IF AVAILABLE pt_mstr */

   else
   update v_qty_cnt
      tag_rcnt_um.

   tag_rcnt_qty = tag_rcnt_qty + v_qty_cnt .
   v_qty_cnt = 0 .
   disp tag_rcnt_qty v_qty_cnt with frame a .


   {mfumcnv.i tag_rcnt_um tag_part tag_rcnt_cnv}

   setcnt:
   do on error undo, retry:
      update tag_rcnt_cnv
         tag_rcnt_nam
         tag_rcnt_dt
         tag_rmks.
      if tag_rcnt_dt = ? then do:
         {pxmsg.i &MSGNUM=711 &ERRORLEVEL=3}
         next-prompt tag_rcnt_dt.
         undo setcnt, retry.
      end.
      if new_count then
      assign
         new_name = tag_rcnt_nam
         new_date = tag_rcnt_dt.

   end. /* SETCNT */

end.  /*loopnbr*/

end. /* MAINLOOP */
