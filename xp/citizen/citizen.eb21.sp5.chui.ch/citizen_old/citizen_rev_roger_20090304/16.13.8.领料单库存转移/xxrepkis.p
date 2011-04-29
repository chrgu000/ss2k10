/* xxrepkis.p - REPETITIVE PICKLIST ISSUE                                       */
/* $Revision: 1.18.2.13 $ BY: Apple Tam DATE: 03/15/06 ECO: *SS-MIN001*     */

{mfdtitle.i "2+ "}
{cxcustom.i "REPKIS.P"}

{gldydef.i new}
{gldynrm.i new}

define new shared variable nbr as character format "x(10)" label "Picklist".
define new shared variable eff_date like mfc_date.
define new shared variable use-to-loc-status like mfc_logical
   label "Use To Location Status" no-undo.
define new shared variable multi_entry like mfc_logical label "Multi Entry"
   no-undo.
define new shared variable cline as character.
define new shared variable lotserial_control like pt_lot_ser.
define new shared variable issue_or_receipt as character.
define new shared variable total_lotserial_qty like sr_qty.
define new shared variable site like sr_site no-undo.
define new shared variable location like sr_loc no-undo.
define new shared variable location1 like sr_loc no-undo.
define new shared variable lotserial like sr_lotser no-undo.
define new shared variable lotserial_qty like sr_qty no-undo.
define new shared variable trans_um like pt_um.
define new shared variable trans_conv like sod_um_conv.
define new shared variable transtype as character.
define new shared variable lotref like sr_ref no-undo.

define     shared variable global_recid as recid.

define variable disp_qopen as decimal no-undo.
define variable disp_all   as decimal no-undo.
define variable disp_pick  as decimal no-undo.
define variable disp_chg   as decimal no-undo.

{&REPKIS-P-TAG1}
define variable i          as   integer.
define variable undo-input like mfc_logical.
define variable seq        as   integer format ">>>" label "Sequence".
define variable lotnext    like wo_lot_next .
define variable lotprcpt   like wo_lot_rcpt no-undo.
define variable oldnbr     like nbr no-undo.
/*ss-min001 define variable line       like op_wkctr.*/
/*ss-min001*/ define variable line       like xic_line.
define variable wkctr      like op_wkctr.
define variable comp       like ps_comp.
define variable prod_site  like lad_site.
define variable alloc      like mfc_logical label "Alloc" initial yes.
define variable picked     like mfc_logical label "Picked" initial yes.
define variable part       like lad_part.
define variable qopen      like lad_qty_all.
define variable yn         like mfc_logical.
define variable l_recno    as   recid        no-undo.
/*ss-min001 add*/
define variable loc-to     like loc_loc.
define variable line2      like xic_line.
define variable p-desc1    like pt_desc1.
/*ss-min001 add*/

issue_or_receipt = getTermLabel("ISSUE",8).

/* THE FRAME E IS DEFINED SO THAT THE COMPONENTS BEING */
/* TRANSFERRED ARE NOT DISPLAYED ON THE SAME LINE.     */

define frame e
   line format ">>9"
   xic_part
   xic_site_from   
   xic_loc_from
   xic_lot_from
   xic_qty_from

with down no-attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame e:handle).

{gpglefv.i}

form
   space(1)
   
   nbr
   prod_site label "转入地点"
   loc-to label "转入库位"

with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   space(1)
   eff_date
   use-to-loc-status
   space(2)
with frame b centered row 4 overlay side-labels.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

form with frame c 6 down no-attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

form
   line           colon 13       lotserial_qty  colon 53 pt_um
   part           colon 13       site           colon 53 location label "Loc"
   pt_desc1       colon 13       lotserial      colon 53
   pt_desc2       at 15 no-label lotref         colon 53 location1 label "Loc"
/*ss-min001   multi_entry    colon 53*/
with frame d side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

/* GLOBAL_ADDR IS INITIALISED TO BLANK WHICH PREVENTS */
/* ASSIGNMENT OF ADDRESS FROM PREVIOUS TRANSACTION.   */

assign
   eff_date          = today
   use-to-loc-status = yes
   nbr               = ""
   prod_site         = global_site
   global_addr       = ""
   transtype         = "ISS-TR".

/* DISPLAY */
mainloop:
repeat:

   assign
      nbr     = oldnbr
      part    = ""
      l_recno = 0
      line    = 0.

   view frame a.
   view frame c.
   view frame d.

   display
      prod_site
      nbr
     loc-to

   with frame a.

   setsite:
   do on error undo, retry with frame a:

      global_recid = ?.
      set
         
         nbr prod_site
/*ss-min001*/ loc-to
        /*ss-min001 seq
         alloc
         picked*/
      with frame a editing:
         if frame-field = "nbr"
         then do:

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i xic_det
                      xic_line
                     " xic_det.xic_domain = global_domain and xic_flag = no "
                      xic_nbr 
                     " input nbr "}

            if recno <> ? then
               display
                  substring(xic_nbr,1,8) @ nbr
                  substring(xic_site_to,1,8) @ prod_site
				  substring(xic_loc_to,1,8) @ loc-to
               with frame a.

         end. /* ELSE IF frame-field = "nbr" */
         else if frame-field = "prod_site"
         then do:

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i si_mstr
                      si_site
                     " si_mstr.si_domain = global_domain "
                      si_site
                      prod_site}

            if recno <> ?
            then
               display
                  si_site @ prod_site  with frame a.
            recno = ?.
         end. /* IF frame-field = "prod_site" */
		 else if frame-field = "loc-to"
         then do:

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i loc_mstr
                      loc_loc
                     " loc_mstr.loc_domain = global_domain and loc_site = input prod_site"
                      loc_loc
                      loc-to}

            if recno <> ?
            then
               display
                  loc_loc @ loc-to  with frame a.
            recno = ?.
         end. /* IF frame-field = "prod_site" */

         else do:
            status input.
            readkey.
            apply lastkey.
         end. /* ELSE DO */
      end. /* EDITING */

      if not can-find(si_mstr  where si_mstr.si_domain = global_domain and
      si_site = prod_site)
      then do:

         /* SITE DOES NOT EXIST */
         {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}
         next-prompt prod_site.
         undo, retry.
      end. /* IF NOT CAN-FIND(si_mstr WHERE si_site = prod_site) */

      {gprun.i ""gpsiver.p"" "(input prod_site,
           input ?,
           output return_int)"}

      if return_int = 0
      then do:
         /* USER DOES NOT HAVE ACCESS TO THIS SITE */
         {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
         next-prompt prod_site with frame a.
         undo, retry.
      end. /* IF return_int = 0 */
      find first xic_det where xic_det.xic_domain = global_domain and xic_nbr = nbr and xic_flag = no no-lock no-error.
      if not available xic_det then do:
         message "错误:该单已确认,请重新输入".
	 undo,retry.
      end.

if  available xic_det and ( xic_nbr begins "UI" or xic_nbr begins "UO" )  then do:
	message "错误:非转移类型单据,不允许转移!!! 请重新输入".
	undo,retry.
end.

      if not can-find(first xic_det  where xic_det.xic_domain = global_domain
         and xic_site_to begins prod_site)
      then do:
         /* REFERENCE DOES NOT EXIST */
         {pxmsg.i &MSGNUM=1156 &ERRORLEVEL=3}
         next-prompt prod_site.
         undo, retry.
      end. /* IF NOT CAN-FIND ... */

				if loc-to <> "" then do:  end.
	    for first loc_mstr
            fields( loc_domain loc_loc)
             where loc_mstr.loc_domain = global_domain 
			 and loc_site = prod_site 
			 and  loc_loc = loc-to
            no-lock:
         end. /* FOR FIRST loc_mstr */

         if not available loc_mstr
         then do:
            /* LOCATION DOES NOT EXIST */
            {pxmsg.i &MSGNUM=709 &ERRORLEVEL=3}
            next-prompt loc-to.
            undo, retry.
         end. /* IF NOT AVAILABLE loc_mstr */
      
if loc-to <> "" then do:
	for each xic_det where xic_det.xic_domain = global_domain and xic_nbr = nbr :
	xic_loc_to = loc-to.
	xic_site_to = prod_site .
	end.
end.


      pause 0.

      if eff_date = ?
      then
         eff_date = today.

      setb:
      do with frame b on error undo:

         update
            eff_date
            use-to-loc-status.
         /* CHECK EFFECTIVE DATE */

         for first si_mstr
            fields( si_domain si_entity si_site)
             where si_mstr.si_domain = global_domain and  si_site = prod_site
            no-lock:
         end. /* FOR FIRST si_mstr */

         {gpglef1.i &module = ""IC""
                    &entity = si_entity
                    &date   = eff_date
                    &prompt = "eff_date"
                    &frame  = "b"
                    &loop   = "setb"
            }
      end. /* DO WITH FRAME b ... */
   end.  /* SETSITE:  DO: */
  oldnbr = nbr .


  {gprun.i ""xxrepkisb.p"" "(nbr, prod_site, loc-to, picked)"}

   setd:
   do while true:

      /* DISPLAY DETAIL */
      repeat:
         clear frame c all no-pause.
         clear frame d all no-pause.
         view frame c.
         view frame d.


/*ss-min001 add*********************************************************/
         for each xic_det
             where xic_det.xic_domain = global_domain 
              and xic_nbr     =  nbr
              and xic_line    >= line
              /*and xic_part    >= part */
	      and xic_flag    = no
	      and xic_qty_from <> 0
            no-lock
         break by xic_nbr by xic_line :
         find first pt_mstr where pt_mstr.pt_domain = global_domain and pt_part = xic_part no-lock no-error.
	 if available pt_mstr then do:
            p-desc1 = pt_desc1.
	 end.
	 else do:
	    p-desc1 = "".
	 end.
            display
               xic_line       label "项次"
               xic_part       label "零件号"
	       p-desc1        label "说明"
	       xic_qty_from   label "数量"
	       xic_loc_from   label "转出库位"
            with frame c.

            if frame-line(c) = frame-down(c)
            then
               leave.

            down 1 with frame c.
         end. /* FOR EACH lad_det ... */
/*ss-min001 add*********************************************************/

         /* CONDITION ADDED TO IMPROVE PERFORMANCE IN DESKTOP 2 */
         if not {gpiswrap.i}
         then
            input clear.

         hide frame b no-pause.

         run setline.

         /* TO RELEASE LOCKING OF WINDOWS WHEN ALT+X OR        */
         /* EXIT OR WINDOW CLOSE BUTTON X IS CLICKED, BEING IN */
         /* LINE FRAME OF WINDOWS VERSION.                     */
         /*V8! if global-beam-me-up then undo mainloop, leave mainloop.  */

         if return-value = "undo"
         then
            leave.

      end. /* REPEAT:  (DISPLAY DETAIL) */

      do on endkey undo mainloop, retry mainloop:

         yn = yes.
         /* DISPLAY WO LINES BEING SHIPPED? */
         {pxmsg.i &MSGNUM=636 &ERRORLEVEL=1 &CONFIRM=yn &CONFIRM-TYPE='LOGICAL'}

         if yn = yes
         then do:

            hide frame c no-pause.
            hide frame d no-pause.

            /* ADDED CHECK FOR lad_qty_chg TO DISPLAY WORK CENTER */
            /* AND PART FOR ALL COMPONENTS IN ISSUE SCREEN.       */
/*ss-min001**************************************************************
            for each lad_det
               fields( lad_domain lad_dataset lad_line lad_loc lad_lot lad_nbr
               lad_part
                      lad_qty_all lad_qty_chg lad_qty_pick lad_ref lad_site)
                where lad_det.lad_domain = global_domain and  lad_dataset =
                "rps_det"
               and   lad_nbr     =  nbr
               and   lad_qty_chg <> 0
            no-lock break by lad_dataset by lad_nbr by lad_line by lad_part
            with frame e:

               for each sr_wkfl
                  fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
                  sr_rev
                          sr_site sr_user2 sr_userid)
                   where sr_wkfl.sr_domain = global_domain and  sr_userid =
                   mfguser
                    and sr_lineid = string(lad_line,"x(8)") + "::" + lad_part
                    and sr_site   = lad_site
                    and sr_loc    = lad_loc
                    and sr_lotser = lad_lot
                    and sr_ref    = lad_ref
                    no-lock
               with frame e:

                  if first-of (lad_part)
                     or frame-line < 2
                  then
                     display
                        lad_line @ line
                        lad_part.

                  display
                     sr_site
                     sr_loc
                     sr_lotser
                     sr_qty.

                  if sr_ref > ""
                  then do:
                     down 1.
                     display
                        getTermLabel("REFERENCE",8) + ": " +
                           sr_ref @ sr_lotser.
                  end. /* IF sr_ref > ... */

               end. /* FOR EACH sr_wkfl ...*/
            end. /* FOR EACH lad_det ... */
*ss-min001**************************************************************/
/*ss-min001 add**************************************************************/
            for each xic_det
                where xic_det.xic_domain = global_domain 
               and   xic_nbr     =  nbr
	       and   xic_flag    = no
	       and   xic_qty_from <> 0
            no-lock break by xic_nbr by xic_line 
            with frame e:

               for each sr_wkfl
                  fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
                  sr_rev
                          sr_site sr_user1 sr_user2 sr_userid)
                   where sr_wkfl.sr_domain = global_domain and  sr_userid =
                   mfguser
                    and sr_lineid = string(xic_line) + "::" + xic_part
                    and sr_user1   = xic_nbr
                    no-lock
               with frame e:


                  display
                     xic_line  @ line
                     xic_part  label "零件号"
                     xic_site_from label "地点"
					 xic_loc_from label "转出仓库"
                     xic_lot_from  label "批号"
                     xic_qty_from  label  "数量"    
		     .

               end. /* FOR EACH sr_wkfl ...*/
            end. /* FOR EACH lad_det ... */
/*ss-min001**************************************************************/
         end. /* IF yn = yes ... */
      end.  /* DO ON ENDKEY... */

      do on endkey undo mainloop, retry mainloop:

         yn = yes.

         /* IS ALL INFO CORRECT? */
         {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=yn &CONFIRM-TYPE='LOGICAL'}
         /*V8!
         if yn = ?
         then
            undo mainloop, retry mainloop. */

         if yn
         then do:

/*ss-min001 delete*************************************************************
            for each lad_det
               fields( lad_domain lad_dataset lad_line lad_loc lad_lot lad_nbr
               lad_part
                      lad_qty_all lad_qty_chg lad_qty_pick lad_ref lad_site)
                where lad_det.lad_domain = global_domain and  lad_dataset =
                "rps_det"
                 and lad_nbr     = nbr
               no-lock
            break
            by lad_dataset by lad_nbr by lad_line by lad_part:

               for each sr_wkfl
                  fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
                  sr_rev
                          sr_site sr_user2 sr_userid)
                   where sr_wkfl.sr_domain = global_domain and  sr_userid =
                   mfguser
                    and sr_lineid = string(lad_line,"x(8)") + "::" + lad_part
                    and sr_site   = lad_site
                    and sr_loc    = lad_loc
                    and sr_lotser = lad_lot
                    and sr_ref    = lad_ref
                  no-lock
               with width 80:

                  for first pt_mstr
                     fields( pt_domain pt_desc1 pt_desc2 pt_lot_ser pt_part
                     pt_um)
                      where pt_mstr.pt_domain = global_domain and  pt_part =
                      lad_part
                     no-lock:
                  end. /* FOR FIRST pt_mstr */
                  {gprun.i ""icedit.p"" " (""ISS-TR"",
                      sr_site,
                      sr_loc,
                      lad_part,
                      sr_lotser,
                      sr_ref,
                      sr_qty,
                      pt_um,
                      """",
                      """",
                      output undo-input )" }

                  if not undo-input
                  then do:

                     {gprun.i ""icedit.p"" " (""RCT-TR"",
                         lad_site,
                         lad_line,
                         lad_part,
                         sr_lotser,
                         sr_ref,
                         sr_qty,
                         pt_um,
                         """",
                         """",
                         output undo-input )" }
                  end. /* IF NOT undo-input ... */

                  if undo-input
                  then do:
                     assign
                        line = lad_line
                        part = lad_part.
                     next setd.
                  end. /* IF undo-input */

                  /* VALIDATE GRADE ASSAY EXPIRE & INVENTORY STATUS */
                  {gprun.i ""repkisc.p"" 
                     "(input sr_site,
                       input lad_site,
                       input sr_loc,
                       input lad_line,
                       input lad_part,
                       input sr_lotser,
                       input sr_ref,
                       input sr_qty,
                       input use-to-loc-status,
                       output undo-input)" }
                  if undo-input
                  then do:
                     assign
                        line = lad_line
                        part = lad_part.
                     next setd.
                  end. /* IF undo-input */

               end. /* FOR EACH sr_wkfl ... */
            end. /* FOR EACH lad_det ... */
*ss-min001 delete*************************************************************/
/*ss-min001 add*************************************************************/
            for each xic_det
                where xic_det.xic_domain = global_domain   
                 and xic_nbr     = nbr
		 and xic_flag    = no
		 and xic_qty_from <> 0
               no-lock
            break
            by xic_nbr by xic_line :

               for each sr_wkfl
                  fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
                  sr_rev
                          sr_site sr_user2 sr_userid)
                   where sr_wkfl.sr_domain = global_domain and  sr_userid =
                   mfguser
                    and sr_lineid = string(xic_line) + "::" + xic_part
                    and sr_site   = xic_site_from
                    and sr_loc    = xic_loc_from
                    and sr_lotser = xic_lot_from
                    and sr_ref    = xic_ref_from
                  no-lock
               with width 80:
				/*message sr_site xic_site_to skip
				sr_loc xic_loc_to skip
				sr_lot xic_lot_to skip
				sr_ref xic_ref_to view-as alert-box.*/
                  for first pt_mstr
                     fields( pt_domain pt_desc1 pt_desc2 pt_lot_ser pt_part
                     pt_um)
                      where pt_mstr.pt_domain = global_domain and  pt_part =
                      xic_part
                     no-lock:
                  end. /* FOR FIRST pt_mstr */

                  {gprun.i ""icedit.p"" " (""ISS-TR"",
                      sr_site,
                      sr_loc,
                      xic_part,
                      sr_lotser,
                      sr_ref,
                      sr_qty,
                      pt_um,
                      """",
                      """",
                      output undo-input )" }

                  if not undo-input
                  then do:

                     {gprun.i ""icedit.p"" " (""RCT-TR"",
                         xic_site_to,
                         xic_loc_to,
                         xic_part,
                         sr_lotser,
                         sr_ref,
                         sr_qty,
                         pt_um,
                         """",
                         """",
                         output undo-input )" }
                  end. /* IF NOT undo-input ... */

                  if undo-input
                  then do:
                     assign
                        line = xic_line
                        part = xic_part.
                     next setd.
                  end. /* IF undo-input */

                  /* VALIDATE GRADE ASSAY EXPIRE & INVENTORY STATUS */
                  {gprun.i ""xxrepkisc.p""
                     "(input sr_site,
                       input xic_site_to,
                       input sr_loc,
                       input xic_loc_to,
                       input xic_part,
                       input sr_lotser,
                       input sr_ref,
                       input sr_qty,
                       input use-to-loc-status,
                       output undo-input)" }

                  if undo-input
                  then do:
                     assign
                        line = xic_line
                        part = xic_part.
                     next setd.
                  end. /* IF undo-input */

               end. /* FOR EACH sr_wkfl ... */
            end. /* FOR EACH lad_det ... */
/*ss-min001 add*************************************************************/

            {&REPKIS-P-TAG2}
            hide frame c.
            hide frame d.
            leave setd.
         end. /* IF yn THEN DO */
      end.  /* DO ON ENDKEY... */
   end. /* SETD:  DO WHILE TRUE: */

/*ss-min001   {gprun.i ""repkisa.p""}*/
/*ss-min001*/   {gprun.i ""xxrepkisa.p""}

/*ss-min001 add*********************************/
for each xic_det
    where xic_det.xic_domain = global_domain 
      and xic_nbr = nbr
exclusive-lock:
    assign
       xic_flag = yes
       xic_eff_date = eff_date
       xic_user2 = mfguser.
end. 
/*ss-min001 add*********************************/



   {&REPKIS-P-TAG3}

   nbr = substring(nbr,9).

end.  /* MAINLOOP */

/* DELETE STRANDED sr_wkfl and lad_det RECORDS */

for each sr_wkfl
    where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
exclusive-lock:
   delete sr_wkfl.
end. /* FOR EACH sr_wkfl */
/*ss-min001*********************************
for each lad_det
    where lad_det.lad_domain = global_domain and  lad_dataset  = "rps_det"
   and   lad_nbr     >=  string(prod_site,"x(8)")
                         + string(oldnbr,"x(10)")
   and   lad_nbr     <=  string(prod_site,"x(8)")
                         + string(oldnbr,"x(10)")
                         + hi_char
   and   lad_qty_all  = 0
   and   lad_qty_pick = 0
exclusive-lock:
   delete lad_det.
end. /* FOR EACH lad_det */
*ss-min001*********************************/
/*********START INTERNAL PROCEDURE LOGIC*************/

PROCEDURE setline:

   setline:
   do on error undo, retry on endkey undo, return "undo":

      update
         line
         
      with frame d editing:

         if frame-field = "line"
         then do:

            if l_recno <> 0
            then
               recno = l_recno.

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i
               xic_det
               xic_line
              " xic_det.xic_domain = global_domain and xic_nbr = nbr and xic_flag = no"
               xic_line
               line}

            if recno <> ?
            then do:
				   assign
					  line = xic_line
					  part = xic_part.
				   display
					  line
					  part
				   with frame d.

					for first pt_mstr
					fields( pt_domain pt_desc1 pt_desc2 pt_lot_ser pt_part pt_um)
					 where pt_mstr.pt_domain = global_domain and  pt_part = part
					no-lock:

					display
					   pt_um
					   pt_desc1
					   pt_desc2
					with frame d.
					end. /* FOR FIRST pt_mstr ... */

					display
						xic_qty_from @ lotserial_qty
						xic_site_from @ site
						xic_loc_from @ location
						xic_lot_from @ lotserial
						xic_ref_from @ lotref
						loc-to       @ location1
					with frame d.


            end. /* IF recno <> ? */

            /* STORE THE recid TO RETRIEVE THE LAST VISITED WORK CENTER */
            /* THIS IS STORED HERE AS mfnp05.i CALLED BELOW             */
            /* (frame-field = "part") WILL RESET THE recno TO '?'       */
            l_recno = recid (xic_det).

         end. /* IF frame-field = "line" */

         /*else if frame-field = "part"
         then do:

           
            {mfnp05.i
               xic_det
               xic_line
              " xic_det.xic_domain = global_domain and
               xic_nbr     = nbr         and
               xic_line    = line"
               xic_part
               part}

            if recno <> ?
            then do:
               part = xic_part.
               display part with frame d.
            end. 
            recno = ?.
         end.  ELSE IF frame-field = "part" */

         else do:
            status input.
            readkey.
            apply lastkey.
         end. /* ELSE DO */

      end. /* UPDATE... EDITING */

      status input.

      if line = 0
      then
         leave.

      multi_entry = no.

      for first xic_det
          where xic_det.xic_domain = global_domain 
           and xic_nbr     = nbr
           and xic_line    = line
         no-lock:
      end. /* FOR FIRST lad_det ... */

      if available xic_det
      then do:

		part = xic_part .

         for first pt_mstr
            fields( pt_domain pt_desc1 pt_desc2 pt_lot_ser pt_part pt_um)
             where pt_mstr.pt_domain = global_domain and  pt_part = part
            no-lock:
         end. /* FOR FIRST pt_mstr */

         if not available pt_mstr
         then do:
            /* ITEM NUMBER DOES NOT EXIST */
            {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3}
            undo, retry.
         end. /* IF NOT AVAILABLE pt_mstr */

         if recid(lad_det) = -1 then .
      end. /* IF AVAILABLE lad_det */
	  else leave .

      for first pt_mstr
         fields( pt_domain pt_desc1 pt_desc2 pt_lot_ser pt_part pt_um)
          where pt_mstr.pt_domain = global_domain and  pt_part = part
         no-lock:
      end. /* FOR FIRST pt_mstr */

      if not available pt_mstr
      then do with frame d:
         /* ITEM NUMBER DOES NOT EXIST */
         {pxmsg.i &MSGNUM=16 &ERRORLEVEL=2}
         display part
            " " @ pt_um
            " " @ pt_desc1
            " " @ pt_desc2.
      end. /* IF NOT AVAILABLE pt_mstr */

      else do with frame d:
         display
            pt_part @ part
            pt_um
            pt_desc1
            pt_desc2.
      end. /* ELSE DO ... */

      assign
         qopen         = 0
         lotserial_qty = 0.

      for each xic_det
          where xic_det.xic_domain = global_domain
         and   xic_nbr     = nbr
         and   xic_line    = line
      no-lock:
         assign
            lotserial_qty = xic_qty_from.
	    display lotserial_qty with frame d.
      end. /* FOR EACH lad_det */

      assign
         total_lotserial_qty = lotserial_qty
         lotserial_control   = "".

      if available pt_mstr
      then
         lotserial_control = pt_lot_ser.

      assign
         site        = ""
         location    = ""
         location1    = loc-to
         lotserial   = ""
         lotref      = ""
         cline       = string(line) + "::" + part
         global_part = part.

      for first sr_wkfl
         fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref sr_rev
                 sr_site sr_user2 sr_userid)
          where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
         and   sr_lineid = cline
         no-lock:
      end. /* FOR FIRST sr_wkfl */

      if not available sr_wkfl
      then do:

         for first xic_det
             where xic_det.xic_domain = global_domain 
            and   xic_nbr     = nbr
            and   xic_line    = line
            no-lock:
         end. /* FOR FIRST lad_det */

         assign
            site     = xic_site_from
            location = xic_loc_from
			location1    = loc-to.

      end. /* IF NOT AVAILABLE sr_wkfl */

      else do:

         for first sr_wkfl
            fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref sr_rev
                    sr_site sr_user2 sr_userid)
             where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
            and   sr_lineid = cline
            no-lock:

            assign
               site      = sr_site
               location  = sr_loc
               lotserial = sr_lotser
               lotref    = sr_ref
			   location1    = loc-to.

			   /*for first xic_det
					 where xic_det.xic_domain = global_domain 
					and   xic_nbr     = nbr
					and   xic_line    = line
					no-lock:
				 end. 
				location1    = xic_loc_to. */
         end.  /*FOR FIRST sr_wkfl */

       /*ss-min001  if not available sr_wkfl
         then
            multi_entry = yes.*/

      end. /* ELSE DO */

	  if site = "" then site = prod_site .

      setrest:
      do on error undo, retry on endkey undo, leave:

         update
            lotserial_qty /*ss-min001 */ 
            site
            location
            lotserial
            lotref
/*ss-min001
			location1
           multi_entry*/
         with frame d editing:

            assign
               global_site = input site
               global_loc  = input location.

            readkey.
            apply lastkey.
         end. /* UPDATE ... */

         i = 0.
         for each sr_wkfl
            fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref sr_rev
                    sr_site sr_user2 sr_userid)
             where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
            and   sr_lineid = cline
         no-lock:

            i = i + 1.

            if i > 1
            then do:
               multi_entry = yes.
               leave.
            end. /* IF i > 1 */

         end. /* FOR EACH sr_wkfl */

         assign
            trans_um   = if available pt_mstr
                         then
                            pt_um
                         else
                            ""
            trans_conv = 1.

         if multi_entry
         then do:

            if i >= 1
            then do:

               assign
                  site      = ""
                  location  = ""
                  lotserial = ""
                  lotref    = "".
            end. /* IF i >= 1 */

            assign
               lotnext  = ""
               lotprcpt = no.

            {gprun.i ""repksrup.p"" "(input prod_site,
                 input line,
                 input use-to-loc-status,
                 input """",
                 input """",
                 input-output lotnext,
                 input lotprcpt)"}

         end. /* IF multi_entry */
         else do:

            if lotserial_qty <> 0
            then do:

               {gprun.i ""icedit.p"" "(input ""ISS-TR"",
                    input site,
                    input location,
                    input part,
                    input lotserial,
                    input lotref,
                    input lotserial_qty,
                    input trans_um,
                    input """",
                    input """",
                    output undo-input
                    )" }

               if undo-input
               then
                  undo, retry.

               {gprun.i ""xxrepkisc.p""
                  "(input site,
                    input prod_site,
                    input location,
                    input location1,
                    input part,
                    input lotserial,
                    input lotref,
                    input lotserial_qty,
                    input use-to-loc-status,
                    output undo-input)" }

               if undo-input then undo, retry.

            end. /* IF lotserial_qty <> 0 */

            find first sr_wkfl
                where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
               and   sr_lineid = cline
               exclusive-lock
            no-error.

            if lotserial_qty <> 0
            then do:

               if not available sr_wkfl
               then
                   do: create sr_wkfl. sr_wkfl.sr_domain = global_domain. end.

               assign
                  sr_userid = mfguser
                  sr_lineid = cline
                  sr_site   = site
                  sr_loc    = location
                  sr_lotser = lotserial
                  sr_ref    = lotref
                  sr_qty    = lotserial_qty
                  sr_rev    = string(line)
                  sr_user2  = part.

               if recid(sr_wkfl) = -1 then .
            end.  /* IF lotserial_qty <> 0 */

            else if available sr_wkfl
               and lotserial_qty = 0
            then
               delete sr_wkfl.

         end.  /* (NOT MULTI_ENRY) */

         for each xic_det
             where xic_det.xic_domain = global_domain 
            and   xic_nbr     = nbr
            and   xic_line    = line
            and xic_part      = part
         exclusive-lock:

        xic_loc_to = location1.
	    xic_ref_to  = lotref.
	    xic_lot_to = lotserial.
		xic_loc_from = location.
		xic_lot_from = lotserial.
		xic_ref_from  = lotref.
	    xic_qty_from = lotserial_qty .
		xic_qty_to = lotserial_qty .
	    xic_user2 = global_userid.
         end. /* */

         for each sr_wkfl
            fields( sr_domain sr_lineid sr_loc   sr_lotser sr_qty sr_ref sr_rev
                    sr_site   sr_user2 sr_userid)
             where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
            and   sr_lineid = cline
            no-lock:
/*
            find lad_det
                where lad_det.lad_domain = global_domain and  lad_dataset =
                "rps_det"
               and   lad_nbr     = nbr
               and   lad_line    = line
               and   lad_part    = part
               and   lad_site    = sr_site
               and   lad_loc     = sr_loc
               and   lad_lot     = sr_lot
               and   lad_ref     = sr_ref
            exclusive-lock
            no-error.

            if available lad_det
            then do:
               if lad_qty_chg <> sr_qty
               then
                  lad_qty_chg = sr_qty.
            end. /* IF AVAILABLE lad_det */

            else do:
               create lad_det. lad_det.lad_domain = global_domain.
               assign
                  lad_dataset = "rps_det"
                  lad_nbr     = nbr
                  lad_line    = line
                  lad_part    = part
                  lad_site    = sr_site
                  lad_loc     = sr_loc
                  lad_lot     = sr_lot
                  lad_ref     = sr_ref
                  lad_qty_chg = sr_qty
                  recno       = recid(lad_det).
            end. /* IF NOT AVAILABLE lad_det */  ss-min001*/
         end.  /* EACH sr_wkfl */
      end. /* SETREST: DO: */
   end. /* SETLINE: DO: */

END PROCEDURE. /* PROCEDURE setline */
