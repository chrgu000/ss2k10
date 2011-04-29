/* xxrepkis.p - REPETITIVE PICKLIST ISSUE                                   */
/* $Revision: 1.18.2.13 $ BY: Apple Tam DATE: 03/15/06 ECO: *SS-MIN001*     */


/* mhjit056.p  modified from xxrepkis.p for JIT kb module                            */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                               */
/* All rights reserved worldwide.  This is an unpublished work.                      */
/*V8:ConvertMode=NoConvert                                                           */
/* REVISION: 1.0      LAST MODIFIED: 10/08/07   BY: Softspeed roger xiao   /*xp001*/ */
/*-Revision end------------------------------------------------------------          */


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

/*xp001*/
define var v_check as logical initial yes  .
define var v_type like xkb_type label "看板类型" .
define var v_id like xkb_kb_id format ">>9" label "看板ID".
define var v_qty_req like xkb_kb_raim_qty label "需要数量".
define var v_raim_qty like xkb_kb_raim_qty label "看板余量" .
define var v_qty_oh  like xkb_kb_raim_qty .

define var v_trnbr like tr_trnbr.
define var trnbr like tr_trnbr.
define buffer xkbhhist for xkbh_hist.

define temp-table tmpkb 
    field tmp_line  like line 
    field tmp_id    like xkb_kb_id
    field tmp_type  like xkb_type
    field tmp_site  like xkb_site
    field tmp_part  like xkb_part 
    field tmp_qty   like xkb_kb_raim_qty
    .

/*xp001*/

issue_or_receipt = getTermLabel("ISSUE",8).

/* THE FRAME E IS DEFINED SO THAT THE COMPONENTS BEING */
/* TRANSFERRED ARE NOT DISPLAYED ON THE SAME LINE.     */

define frame e
   line
   xic_part
   sr_site
   sr_loc
   sr_lotser
   sr_qty
with down no-attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame e:handle).

{gpglefv.i}

form
   space(1)
   prod_site
   nbr
/*ss-min001*/ loc-to label "转入库位"
/*ss-min001   seq
   alloc
   picked*/
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

    v_type   colon 13 
    v_id     colon 26 
    v_raim_qty  colon 45  v_qty_req 

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

 /* xp001 */
for each tmpkb exclusive-lock:
    delete tmpkb.
end.
 /* xp001 */

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
/*ss-min001*/ loc-to
/*ss-min001      seq
      alloc
      picked*/
   with frame a.

   setsite:
   do on error undo, retry with frame a:

      global_recid = ?.
      set
         prod_site
         nbr
/*ss-min001*/ loc-to
        /*ss-min001 seq
         alloc
         picked*/
      with frame a editing:

         if frame-field = "prod_site"
         then do:

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i xic_det
                      xic_line
                     " xic_det.xic_domain = global_domain and yes "
                      xic_site_from
                      prod_site}

            if recno <> ?
            then
               display
                  xic_site_from @ prod_site with frame a.
            recno = ?.
         end. /* IF frame-field = "prod_site" */

/*ss-min001 add******************************************************/
         else if frame-field = "nbr"
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
                  substring(xic_site_from,1,8) @ prod_site
               with frame a.

         end. /* ELSE IF frame-field = "nbr" */
/*ss-min001 add******************************************************/

/*ss-min001 delete******************************************************
         else if frame-field = "nbr"
         then do:

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i lad_det
                      lad_det
                     " lad_det.lad_domain = global_domain and lad_dataset  =
                     ""rps_det"" and
                      lad_nbr begins string(input prod_site,""x(8)"") "
                      substring(lad_nbr,1,18)
                     "string(input prod_site,""x(8)"")
                    + string(input nbr,""x(10)"") "}

            if global_recid <> ?
            then
               for first lad_det
                  fields( lad_domain lad_dataset lad_line lad_loc lad_lot
                  lad_nbr lad_part
                         lad_qty_all lad_qty_chg lad_qty_pick lad_ref lad_site)
                  where recid(lad_det) = global_recid
                  no-lock:
               end. /* FOR FIRST lad_det ... */

            if recno <> ?
               or (    global_recid <> ?
                   and available lad_det)
            then
               display
                  substring(lad_nbr,9) @ nbr
                  substring(lad_nbr,1,8) @ prod_site
               /*ss-min001   substring(lad_nbr,19) format "x(3)" @ seq*/
               with frame a.

            assign
               recno        = ?
               global_recid = ?.
         end. /* ELSE IF frame-field = "nbr" */

	 else if frame-field = "seq"
         then do:

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i lad_det
                      lad_det
                     " lad_det.lad_domain = global_domain and lad_dataset  =
                     ""rps_det"" and
                      lad_nbr begins string(input prod_site,""x(8)"")
                    + string(input nbr,""x(10)"") "
                      lad_nbr
                     "string(input prod_site,""x(8)"")
                    + string(input nbr,""x(10)"")
                    + string(input seq,""999"") "}

            if recno <> ?
            then
               display
                  substring(lad_nbr,19) format "x(3)" @ seq with frame a.

            recno = ?.
         end. /* ELSE IF frame-field = "seq" */
*ss-min001 delete******************************************************/

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
      
      /*xp001*/
        find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = prod_site ) no-lock no-error .
        if not avail xkbc_ctrl then do:
            find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = "" ) no-lock no-error .
            if not avail xkbc_ctrl then do:
                /* {pxmsg.i &MSGNUM=???? &ERRORLEVEL=3} */
                message "看板模块没有开启" view-as alert-box .
                undo mainloop , retry mainloop .
            end.
        end.
      /*xp001*/

      find first xic_det where xic_det.xic_domain = global_domain and xic_nbr = nbr and xic_flag = no no-lock no-error.
      if not available xic_det then do:
         message "错误:该单已确认,请重新输入".
	     undo,retry.
      end.

/*mage add*****************************/
if  available xic_det and ( xic_nbr begins "UI" or xic_nbr begins "UO" )  then do:
         message "错误:非转移类型单据,不允许转移!!! 请重新输入".
	 undo,retry.
      end.

      if not can-find(first xic_det  where xic_det.xic_domain = global_domain
         and xic_site_from begins prod_site)
      then do:
         /* REFERENCE DOES NOT EXIST */
         {pxmsg.i &MSGNUM=1156 &ERRORLEVEL=3}
         next-prompt prod_site.
         undo, retry.
      end. /* IF NOT CAN-FIND ... */
/*ss-min001
      for first lad_det
         fields( lad_domain lad_dataset lad_line lad_loc lad_lot lad_nbr
         lad_part
                lad_qty_all lad_qty_chg lad_qty_pick lad_ref lad_site)
          where lad_det.lad_domain = global_domain and  lad_dataset = "rps_det"
           and lad_nbr begins string(prod_site,"x(8)") + nbr
         no-lock:
      end. /* FOR FIRST lad_det ... */
ss-min001*/
/*ss-min001 add******/
      if loc-to <> "" then do:
	 for first loc_mstr
            fields( loc_domain loc_loc)
             where loc_mstr.loc_domain = global_domain and  loc_loc = loc-to
            no-lock:
         end. /* FOR FIRST loc_mstr */

         if not available loc_mstr
         then do:
            /* LOCATION DOES NOT EXIST */
            {pxmsg.i &MSGNUM=709 &ERRORLEVEL=3}
            next-prompt loc-to.
            undo, retry.
         end. /* IF NOT AVAILABLE loc_mstr */
      end.
if loc-to <> "" then
for each xic_det where xic_det.xic_domain = global_domain and xic_nbr = nbr :
xic_loc_to = loc-to.
end.
/*ss-min001 end**********/



/*ss-min001 delete******************************************************

      if seq <> 0
      then
         for first lad_det
            fields( lad_domain lad_dataset lad_line lad_loc lad_lot lad_nbr
            lad_part
                   lad_qty_all lad_qty_chg lad_qty_pick lad_ref lad_site)
             where lad_det.lad_domain = global_domain and  lad_dataset =
             "rps_det"
              and lad_nbr     =  string(prod_site,"x(8)") + string(nbr,"x(10)")
                               + string(seq,"999")
            no-lock:
         end. /* FOR FIRST lad_det ... */

      if not available lad_det
      then do:
         /* REFERENCE DOES NOT EXIST */
         {pxmsg.i &MSGNUM=1156 &ERRORLEVEL=3}
         next-prompt nbr.
         undo, retry.
      end. /* IF NOT AVAILABLE lad_det */

      if seq = 0
         and substring(lad_nbr,19) <> ""
      then
         seq = integer(substring(lad_nbr,19)).

      display
         seq with frame a.
*ss-min001 delete******************************************************/

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

/*ss-min001   assign
      oldnbr = nbr
      nbr    = string(prod_site,"x(8)") + nbr.

   if seq <> 0
   then
      nbr = string(nbr,"x(18)") + string(seq,"999").*/

 /*ss-min001  {gprun.i ""repkisb.p"" "(nbr, prod_site, alloc, picked)"}*/
/*ss-min001*/   {gprun.i ""xxrepkisb.p"" "(nbr, prod_site, loc-to, picked)"}

   setd:
   do while true:

      /* DISPLAY DETAIL */
      repeat:
         clear frame c all no-pause.
         clear frame d all no-pause.
         view frame c.
         view frame d.

/*ss-min001 delete*********************************************************
         for each lad_det
            fields( lad_domain lad_dataset lad_line lad_loc lad_lot lad_nbr
            lad_part
                   lad_qty_all lad_qty_chg lad_qty_pick lad_ref lad_site)
             where lad_det.lad_domain = global_domain and  lad_dataset =
             "rps_det"
              and lad_nbr     =  nbr
              and lad_line    >= line
              and lad_part    >= part
            no-lock
         break by lad_dataset by lad_nbr by lad_line by lad_part by lad_site:

            qopen = lad_qty_all + lad_qty_pick.
            accumulate qopen (total by lad_part).
            accumulate lad_qty_all (total by lad_part).
            accumulate lad_qty_pick (total by lad_part).
            accumulate lad_qty_chg (total by lad_part).

            if not last-of (lad_part)
            then
               next.

            assign
               disp_qopen = accum total by lad_part qopen
               disp_all   = accum total by lad_part lad_qty_all
               disp_pick  = accum total by lad_part lad_qty_pick
               disp_chg   = accum total by lad_part lad_qty_chg.

            display
               lad_line   @ line
               lad_part
               disp_qopen format "->>>>>>>9.9<<<<<<<" label "Qty Open"
               disp_all   format "->>>>>>>9.9<<<<<<<" label "Qty Alloc"
               disp_pick  format "->>>>>>>9.9<<<<<<<" label "Qty Picked"
               disp_chg   format "->>>>>>>9.9<<<<<<<" label "Qty to Iss"
            with frame c.

            if frame-line(c) = frame-down(c)
            then
               leave.

            down 1 with frame c.
         end. /* FOR EACH lad_det ... */
*ss-min001 delete*********************************************************/
/*ss-min001 add*********************************************************/
         for each xic_det
             where xic_det.xic_domain = global_domain 
              and xic_nbr     =  nbr
              and xic_line    >= line
              and xic_part    >= part
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

/*start限制: 所有项次都附选足够看板才可以 */               /*xp001*/ 
v_check = yes .
for each xic_det where xic_det.xic_domain = global_domain 
                   and   xic_nbr     =  nbr
                   and   xic_flag    = no
                   and   xic_qty_from <> 0
no-lock break by xic_nbr by xic_line :

   for each sr_wkfl fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
                            sr_rev sr_site sr_user1 sr_user2 sr_userid)
               where sr_wkfl.sr_domain = global_domain 
                 and  sr_userid = mfguser
                 and sr_lineid = string(xic_line) + "::" + xic_part
                 and sr_user1   = xic_nbr
    no-lock :

          v_qty_oh = 0 .
          for each tmpkb where tmp_line = xic_line and tmp_part = xic_part no-lock :
              v_qty_oh = v_qty_oh + tmp_qty .
          end.
          if v_qty_oh < xic_qty_from then do:
              message "项次" xic_line xic_part v_qty_oh skip "未输入足够看板数量" view-as alert-box.
              v_check = no .
          end.

   end. /* FOR EACH sr_wkfl ...*/
end. /* FOR EACH lad_det ... */        
/*end限制: 所有项次都附选足够看板才可以 */                /*xp001*/ 

if v_check = no then do:
    {pxmsg.i &MSGNUM=36 &ERRORLEVEL=1 &CONFIRM=v_check &CONFIRM-TYPE='LOGICAL'}
    if v_check then do:
        for each tmpkb:
            delete tmpkb .
        end.
        leave setd .
    end.
end.
else do :  /* if v_check = yes */
    

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
                     xic_site_to label "地点"
                     xic_loc_to  label "转入仓库"
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
end.  /* if v_check = yes */

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


    /* xp001 */
    
    for each tmpkb exclusive-lock :
        find xkb_mstr where xkb_domain = global_domain and xkb_type = tmp_type and xkb_site = tmp_site 
                      and xkb_part = tmp_part and xkb_kb_id = tmp_id and xkb_status = "U"  exclusive-lock no-error .
        v_raim_qty = if avail xkb_mstr then xkb_kb_raim_qty else 0 .
        if avail xkb_mstr then do:
            assign xkb_kb_raim_qty = xkb_kb_raim_qty - tmp_qty  xkb_upt_date = today .

            find last tr_hist where tr_domain = global_domain 
                              and tr_effdate = eff_date
                              and tr_type = "RCT-TR" 
                              and tr_nbr = nbr 
                              and tr_part = xkb_part  no-lock no-error.
            v_trnbr = if avail tr_hist then tr_trnbr else 0 .
            {xxkbhist.i   &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                        &kb_id="xkb_kb_id"    &effdate=today        &program="'mhjit056.p'"
                        &qty="xkb_kb_qty"     &ori_qty="v_raim_qty" &tr_trnbr="v_trnbr"
                        &b_status="xkb_status"       &c_status="xkb_status"
                        &rain_qty="xkb_kb_raim_qty"}
            if xkb_kb_raim_qty = 0 then do:
                 xkb_status = "A" .
                 {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                        &kb_id="xkb_kb_id"    &effdate=today        &program="'mhjit056.p'"
                        &qty="xkb_kb_qty"     &ori_qty="v_raim_qty" &tr_trnbr=v_trnbr
                        &b_status="'U'"       &c_status="'A'"
                        &rain_qty="xkb_kb_raim_qty"}  
            end.
        end.

    end.
    
    
    /* xp001 */

   {&REPKIS-P-TAG3}

   nbr = substring(nbr,9).

/* xp001 */
for each tmpkb exclusive-lock:
    delete tmpkb.
end.
/* xp001 */

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
         part
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
            end. /* IF recno <> ? */

            /* STORE THE recid TO RETRIEVE THE LAST VISITED WORK CENTER */
            /* THIS IS STORED HERE AS mfnp05.i CALLED BELOW             */
            /* (frame-field = "part") WILL RESET THE recno TO '?'       */
            l_recno = recid (xic_det).

         end. /* IF frame-field = "line" */

         else if frame-field = "part"
         then do:

            /* FIND NEXT/PREVIOUS RECORD */
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
            end. /* IF recno <> ? */
            recno = ?.
         end. /* ELSE IF frame-field = "part" */

         else do:
            status input.
            readkey.
            apply lastkey.
         end. /* ELSE DO */

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
            "" @ lotserial_qty
            "" @ site
            "" @ location
            "" @ lotserial
            "" @ lotref
	    "" @ location1
          /*ss-min001  "" @ multi_entry*/
         with frame d.

      end. /* UPDATE... EDITING */

      status input.

      if part = ""
      then
         leave.

      multi_entry = no.

      for first xic_det
          where xic_det.xic_domain = global_domain 
           and xic_nbr     = nbr
           and xic_line    = line
           and xic_part    = part
         no-lock:
      end. /* FOR FIRST lad_det ... */

      if available xic_det
      then do:


      /*   for first loc_mstr
            fields( loc_domain loc_loc)
             where loc_mstr.loc_domain = global_domain and  loc_loc = xic_loc_to
            no-lock:
         end. /* FOR FIRST loc_mstr */

         if not available loc_mstr
         then do:
            /* LOCATION DOES NOT EXIST */
            {pxmsg.i &MSGNUM=709 &ERRORLEVEL=3}
            undo, retry.
         end. /* IF NOT AVAILABLE loc_mstr */
*/
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

      for first pt_mstr
         fields( pt_domain pt_desc1 pt_desc2 pt_lot_ser pt_part pt_um)
          where pt_mstr.pt_domain = global_domain and  pt_part = xic_part
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
         location1    = ""
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
	    location1 = xic_loc_to.

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
               lotref    = sr_ref.
       for first xic_det
             where xic_det.xic_domain = global_domain 
            and   xic_nbr     = nbr
            and   xic_line    = line
            no-lock:
         end. /* FOR FIRST lad_det */
	    location1    = xic_loc_to.
         end. /* FOR FIRST sr_wkfl */

       /*ss-min001  if not available sr_wkfl
         then
            multi_entry = yes.*/

      end. /* ELSE DO */

      setrest:
      do on error undo, retry on endkey undo, leave:

         update
/*ss-min001            lotserial_qty*/
            site
            location
            lotserial
            lotref
	    location1
/*ss-min001            multi_entry*/
         with frame d editing:

            assign
               global_site = input site
               global_loc  = input location.

            readkey.
            apply lastkey.
         end. /* UPDATE ... */


/* xp001 */


v_qty_oh = 0 .
for each xkb_mstr where xkb_domain = global_domain and xkb_site = input site  and xkb_part = input part /*and xkb_type = v_type*/ 
    and xkb_status = "U" and  xkb_loc = input location and xkb_lot = input lotserial and xkb_ref = input lotref no-lock:
    v_qty_oh = v_qty_oh + ( xkb_kb_raim_qty ) .
end.
if v_qty_oh < lotserial_qty then do:
    message "该地点库位的看板总余量  " + string(v_qty_oh) + ",不足此次待转数量" view-as alert-box.
    undo, retry .            
end.
else v_qty_oh = lotserial_qty .

for each tmpkb where tmp_line = line and tmp_part = input part no-lock :
    v_qty_oh = v_qty_oh - tmp_qty .
end.   /*防止重复输入*/

    
kbloop:
repeat with frame d:

    assign v_type = "" 
           v_id = 0 
           v_qty_req = 0  .
    disp v_qty_oh @ v_qty_req with frame d . 
    update  v_type v_id 
            with frame d editing:
            readkey.
            apply lastkey.
    end. /* UPDATE ... */
    if v_type = ""  then leave .
    
    find first xkb_mstr where xkb_domain = global_domain and xkb_site = input site  and xkb_part = input part
          and xkb_type = v_type and xkb_kb_id = v_id and xkb_status = "U" and xkb_kb_raim_qty > 0 
          and  xkb_loc = input location and xkb_lot = input lotserial and xkb_ref = input lotref no-lock no-error .
    if not avail xkb_mstr then do:
        message "无对应库位/批许号的看板记录,请重新输入." view-as alert-box .
        undo ,retry .
    end. /* if not avail xkb_mstr */
    else do:
        v_raim_qty = xkb_kb_raim_qty .
        v_qty_req = v_qty_oh .
        disp v_raim_qty with fram d .

        update v_qty_req with frame d  .
        if v_qty_req > min(xkb_kb_raim_qty , v_qty_req) or v_qty_req < 0 then do:
            message "超过允许输入的范围" skip "请确认不超过本次欠缺数量或看板余量" view-as alert-box .
            message "请继续输入,欠缺数量:" + string( v_qty_oh )  .
            undo ,retry .
        end.

        find first tmpkb where tmp_line = line and  tmp_type = xkb_type and tmp_id = xkb_kb_id and tmp_part = xkb_part exclusive-lock no-error .
        if avail tmpkb then do:
              message "同一看板不可重复输入" view-as alert-box.
              undo ,retry .
        end.
        else do :
            v_qty_oh  = (  v_qty_oh   -  v_qty_req ) .
            create tmpkb .
            assign tmp_type  = xkb_type
                   tmp_site  = xkb_site
                   tmp_id    = xkb_kb_id
                   tmp_part  = xkb_part
                   tmp_qty   = v_qty_req
                   tmp_line = line .

            if  v_qty_oh  > 0 then do:
                   message "请继续输入,欠缺数量:" + string( v_qty_oh )  .
            end.
        end.
    end. /* else if avail xkb_mstr */

    if v_qty_oh = 0 then leave .

end.  /*kbloop:*/



/* xp001 */


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
                    input global_part,
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
                    input global_part,
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
	    xic_site_to = site.
	    xic_ref_to  = lotref.
	    xic_lot_to = lotserial.
	    xic_qty_to = xic_qty_from.
	    xic_user2 = mfguser.
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
