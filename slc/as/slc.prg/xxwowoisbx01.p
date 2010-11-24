/*By: Neil Gao 08/10/07 ECO: *SS 20081007* */

{mfdeclre.i}
{gplabel.i}

define input parameter wo_recno as recid.
define input parameter wo-op as integer.
define input parameter fill_all as logical.
define input parameter fill_pick as logical.
define output parameter undo-all as logical.

define variable tot_lad_all like lad_qty_all.
define variable ladqtychg like lad_qty_all.
define variable msg-counter as integer no-undo.
define variable rejected like mfc_logical.

define buffer woddet for wod_det.

define var yn as logical.
/* ss 20070412.1 - b */
DEFINE SHARED VARIABLE strLoc LIKE loc_loc.
/* ss 20070412.1 - e */

undo-all = yes.

mainloop:
do:

   find first wo_mstr
      where wo_domain      = global_domain
      and   recid(wo_mstr) = wo_recno
/*SS 20080329 - B*/
/*
   exclusive-lock no-error.
*/
		no-lock no-error.
/*SS 20080329 - E*/
   if available wo_mstr
   then
      recno = recid(wo_mstr).
/*SS 20081010 - B*/
/*
   if keyfunction(lastkey) = "end-error" then leave mainloop.
*/
/*SS 20081010 - E*/
   for each sr_wkfl exclusive-lock  where sr_wkfl.sr_domain = global_domain and
    sr_userid = mfguser:
      delete sr_wkfl.
   end.
 
   for each wod_det  where wod_det.wod_domain = global_domain and (  wod_lot =
   wo_lot
      and (wod_op = wo-op or wo-op = 0)
   )
/*SS 20081117 - B*/
	and ( wod_loc = strloc)
/*SS 20081117 - E*/
   no-lock:

      find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
      wod_part no-lock.
/*SS 20081117 - B*/
/*
			if avail pt_mstr and pt_article <> strloc and strloc <> "" then next.
*/
/*SS 20081117 - E*/
			
			do for woddet:

         find woddet no-lock where recid(woddet) = recid(wod_det).

         if fill_all or fill_pick then do:

            tot_lad_all = 0.

            for each lad_det  where lad_det.lad_domain = global_domain and
            lad_dataset = "wod_det"
                  and lad_nbr = wod_lot and lad_line = string(wod_op)
                  and lad_part = wod_part:

               {gprun.i ""icedit2.p""
                  "(""ISS-WO"",
                    lad_site,
                    lad_loc,
                    wod_part,
                    lad_lot,
                    lad_ref,
                    (if fill_all then lad_qty_all else 0)
                  + (if fill_pick then lad_qty_pick else 0),
                    pt_um,
                    """",
                    """",
                    output rejected)"}

               if rejected then do on endkey undo, retry:
                  {pxmsg.i
                      &MSGNUM=161
                      &ERRORLEVEL=2
                      &MSGARG1=wod_part
                      &PAUSEAFTER=TRUE}
                  next.
               end.

               ladqtychg = 0.

               if fill_all then
                  assign
                     ladqtychg = lad_qty_all
                     tot_lad_all = tot_lad_all + lad_qty_all.

               if fill_pick then
                  assign
                     ladqtychg = ladqtychg + lad_qty_pick
                     .

               if ladqtychg <> 0 then do:
                  create sr_wkfl. sr_wkfl.sr_domain = global_domain.
                  assign
                     sr_userid = mfguser
                     sr_lineid = string(wod_part,"x(18)") + string(wod_op)
                     sr_site = lad_site
                     sr_loc = lad_loc
                     sr_lotser = lad_lot
                     sr_ref = lad_ref
                     sr_qty = ladqtychg.
                  if recid(sr_wkfl) = -1 then .
               end.

            end.

            if fill_all and tot_lad_all <> wod_qty_all then do:

               find pt_mstr  where pt_mstr.pt_domain = global_domain and
               pt_part = wod_part no-lock no-error.

               if not available pt_mstr or pt_lot_ser = "" then do:

                  find sr_wkfl  where sr_wkfl.sr_domain = global_domain and
                  sr_userid = mfguser
                     and sr_lineid = string(wod_part,"x(18)") + string(wod_op)
                     and sr_site = wod_site
                     and sr_loc = wod_loc and sr_lotser = ""
                     and sr_ref = ""
                  no-error.

                  {gprun.i ""icedit2.p""
                     "(input ""ISS-WO"",
                       input wod_site,
                       input wod_loc,
                       input wod_part,
                       input """",
                       input """",
                       input ((wod_qty_all - tot_lad_all)
                     + if available sr_wkfl then sr_qty else 0),
                       input if available pt_mstr
                       then pt_um else """",
                       """",
                       """",
                       output rejected)"}

                  if rejected then do on endkey undo, retry:
                     {pxmsg.i
                         &MSGNUM=161
                         &ERRORLEVEL=2
                         &MSGARG1=wod_part
                         &PAUSEAFTER=TRUE}

                     next.
                  end.

                  if not available sr_wkfl then do:
                     create sr_wkfl. sr_wkfl.sr_domain = global_domain.
                     assign
                        sr_userid = mfguser
                        sr_lineid = string(wod_part,"x(18)") + string(wod_op)
                        sr_site = wod_site
                        sr_loc = wod_loc
                        sr_lotser = ""
                        sr_ref = "".
                     if recid(sr_wkfl) = -1 then .
                  end.

                  assign
                     sr_qty = sr_qty + (wod_qty_all - tot_lad_all)
                     .

               end.

            end.

         end.

      end. /* DO FOR woddet */

   end. /*FOR EACH wod_det*/

   undo-all = no.

end.

define var iy as logical.
for each wod_det
 		fields( wod_domain wod_bo_chg  wod_critical wod_iss_date
         wod_loc     wod_lot      wod_nbr
         wod_op      wod_part     wod_qty_all
         wod_qty_chg wod_qty_iss  wod_qty_pick
         wod_qty_iss
         wod_qty_req wod_site)
  	where wod_det.wod_domain = global_domain and  wod_lot = wo_lot
 		no-lock with frame dd width 80: 

	 	/* SET EXTERNAL LABELS */
 		setFrameLabels(frame dd:handle).

		iy = no.
  	for  each sr_wkfl
    	fields( sr_domain sr_lineid sr_loc      sr_lotser
            sr_qty    sr_ref      sr_site
            sr_userid sr_vend_lot)
     	where sr_wkfl.sr_domain = global_domain and  sr_userid =	mfguser
    				and   sr_lineid = string(wod_part,"x(18)") +  string(wod_op)
    	no-lock
			break by sr_lineid by substring(sr_lotser,7,6):
    

			iy = yes.
 			accumu sr_qty (total by substring(sr_lotser,7,6)).
			if last-of( substring(sr_lotser,7,6) ) then do:
 				find first pt_mstr where pt_domain = global_domain and pt_part = wod_part no-lock no-error.
 				find first vd_mstr where vd_domain = global_domain and vd_addr = substring(sr_lotser,7,6) no-lock no-error.
 				find first cd_det where cd_domain = global_domain and cd_ref = wod_part and cd_type = "SC" and cd_lang = "ch"
 					no-lock no-error.               		
 				display
 					wod_part
 					pt_desc1 when (avail pt_mstr) format "x(16)"
 					substring(sr_lotser,7,6) label "供应商"
 					vd_sort when (avail vd_mstr ) format "x(8)" label "名称"
 					accumulate total by substring(sr_lotser,7,6) sr_qty label "发料量"
 					with frame dd.
 		
 				if avail cd_det then do:
 					find first pt_mstr where pt_domain = global_domain and pt_part = substring(cd_cmmt[1],1,4) no-lock no-error.
 					if avail pt_mstr then disp pt_desc1 @ pt_desc2 format "x(10)" with frame dd.
 				end.
 				down with frame dd.
 				/*
 				{gpwait.i &INSIDELOOP=yes &FRAMENAME=dd}*/
			end.

		/*end.*/

		end.  /* for each sr_hist */
		
		if not iy and ( wod_loc = strloc ) and wod_qty_req > wod_qty_iss then do:
			find first pt_mstr where pt_domain = global_domain and pt_part = wod_part no-lock no-error.
/*SS 20081117 - B*/
/*
			if avail pt_mstr and pt_article <> strloc and strloc <> "" then next.
*/
/*SS 20081117 - E*/
			disp wod_part	pt_desc1 when (avail pt_mstr) format "x(16)"	with frame dd.
			find first cd_det where cd_domain = global_domain and cd_ref = wod_part and cd_type = "SC" and cd_lang = "ch"
 			no-lock no-error.
			if avail cd_det then do:
 				find first pt_mstr where pt_domain = global_domain and pt_part = substring(cd_cmmt[1],1,4) no-lock no-error.
 				if avail pt_mstr then disp pt_desc1 @ pt_desc2 format "x(10)" with frame dd.
 				down with frame dd.
			end.
			/*
			{gpwait.i &INSIDELOOP=yes &FRAMENAME=dd}*/
		end.
		

end. /* FOR EACH wod_det */

{gpwait.i &OUTSIDELOOP=yes}

undo-all = yes.

message "所有信息是否正确?" update yn.

if yn = yes then undo-all = no.

hide frame dd no-pause.


