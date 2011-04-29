/* xxprhis2.p  采购收货库存转移--按送货单*/
/* 由文件xxrepkis.p修改成   */
/* REVISION: 1.0      LAST MODIFIED: 2008/07/11   BY: Softspeed roger xiao  ECO:*xp001* */ /*默认转移至库位,先输入值,再1.4.16,再1.4.5*/
/*-Revision end--------------------------------------------------------------------------*/





{mfdtitle.i "1+ "}
{cxcustom.i "REPKIS.P"}

{gldydef.i new}
{gldynrm.i new}
/*mage*/ define new shared variable ponbr as character format "x(10)" label "Picklist".

define new shared variable nbr as character format "x(20)" label "Picklist".
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
/*ss-min001*/ define variable line       like tr_line.
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
define variable transok    as logical .
define variable notcomp    as logical .
define variable loc-to     like loc_loc.
define variable line2      like tr_line.
define variable p-desc1    like pt_desc1.
define new shared temp-table  trhist1 
       fields tr1_domain  like tr_domain  
       fields tr1_site    like tr_site  
       fields tr1_trnbr   like tr_trnbr 
       fields tr1_part    like tr_part
       fields tr1_nbr     like tr_nbr     
       fields tr1_line    like tr_line    
       fields tr1_lot     like tr_lot   
	   fields tr1_lot2     like tr_lot /*xp001*/
       fields tr1_serial  like tr_serial  
       fields tr1_ref     like tr_ref     
       fields tr1_loc     like tr_loc     
       fields tr1_qty_loc like tr_qty_loc 
       fields tr1__dec01  like tr__dec01  
       fields tr1__log01  like tr__log01
       fields tr1_chg     like tr_qty_loc
       fields tr1_loc_to     like tr_loc 
       INDEX tr1_nbr IS PRIMARY tr1_nbr tr1_line tr1_trnbr
       INDEX tr1_part  tr1_part tr1_nbr tr1_line.

/*mage*/ define new shared variable transok1 like mfc_logical .
/*mage*/ define new shared variable transok2 like mfc_logical .

/*ss-min001 add*/

issue_or_receipt = getTermLabel("ISSUE",8).

/* THE FRAME E IS DEFINED SO THAT THE COMPONENTS BEING */
/* TRANSFERRED ARE NOT DISPLAYED ON THE SAME LINE.     */

define frame e
   line
   tr1_part
   sr_site
   sr_loc
   sr_qty
with down no-attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame e:handle).

{gpglefv.i}

form
   space(1)
prod_site label "地点"
nbr       label "送货单号"  
loc-to    label "转入库位"   

with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS 
setFrameLabels(frame a:handle).*/

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
/*ss-min001*/ loc-to
/*ss-min001      seq
      alloc
      picked*/
   with frame a.

   setsite:
   do on error undo, retry with frame a:

      global_recid = ?.
      set
      prod_site   nbr loc-to
      with frame a editing:

         if frame-field = "prod_site"
         then do:

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i si_mstr
                      si_site
                     " si_mstr.si_domain = global_domain and yes "
                      si_site
                      prod_site}

            if recno <> ?
            then
               display
                  si_site @ prod_site with frame a.
            recno = ?.
         end. /* IF frame-field = "prod_site" */

         else if frame-field = "nbr"
         then do:

            /* FIND NEXT/PREVIOUS RECORD 
            {mfnp05.i prh_hist
                      prh_ps_nbr
                     " prh_hist.prh_domain = global_domain  "
                      prh_ps_nbr 
                     " input nbr "}*/
			{mfnp.i prh_hist nbr  "prh_hist.prh_domain = global_domain and prh_ps_nbr "  nbr prh_ps_nbr prh_ps_nbr}

            if recno <> ? then
               display
                  substring(prh_ps_nbr,1,20) @ nbr
                  substring(prh_site,1,8) @ prod_site
               with frame a.

         end. /* ELSE IF frame-field = "nbr" */
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
      transok = no.
      for each trhist1:
      delete trhist1.
      end.

	for each  prh_hist no-lock 
			where prh_hist.prh_domain = global_domain 
			and prh_ps_nbr = nbr 
			and prh__log01 = no 
			use-index prh_ps_nbr ,
		each tr_hist no-lock 
			where tr_hist.tr_domain = global_domain 
			and tr_nbr = prh_nbr 
			and tr_lot  = prh_receiver
			and tr_line = prh_line
			and tr_type = "rct-po" 
			and tr__log01 = no 
			and tr_qty_loc > tr__dec01 
			use-index tr_nbr_eff:

				transok = yes.
				ponbr = prh_nbr.
				create trhist1.
				assign tr1_domain = tr_domain
					tr1_site   = tr_site
					tr1_trnbr  = tr_trnbr
					tr1_part   = tr_part
					tr1_line   = tr_line
					tr1_lot    = tr_lot
					tr1_lot2    = nbr /*xp001*/
					tr1_serial = tr_serial
					tr1_qty_loc = tr_qty_loc
					tr1__dec01 = tr__dec01
					tr1__log01 = tr__log01
					tr1_ref    = tr_ref
					tr1_loc   = tr_loc
					tr1_chg    = tr_qty_loc - tr__dec01.

         if loc-to <> "" then tr1_loc_to = loc-to.
         else do:
             find first in_mstr where in_domain = global_domain and in_site = prod_site and in_part = tr_part no-lock no-error .
             if avail in_mstr and length(in_user1) > 1 then do:
                tr1_loc_to = substring(in_user1,2,length(in_user1) - 1).
             end.
             else do:
                find first pt_mstr no-lock where pt_mstr.pt_domain = global_domain and pt_part = tr_part no-error.
                if available pt_mstr then tr1_loc_to = pt_loc.
             end.
         end. /*xp001*/
	end. /*for each **/   
	if not transok  then do:
		message "错误:该单已确认,请重新输入".
		undo,retry.
	end.

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

   {gprun.i ""xxprhisb2.p"" "(nbr, prod_site, loc-to, picked, ponbr)"}

   setd:
   do while true:

      /* DISPLAY DETAIL */
      repeat:
         clear frame c all no-pause.
         clear frame d all no-pause.
         view frame c.
         view frame d.

for   each trhist1 no-lock where trhist1.tr1_domain = global_domain 
        and tr1_line    >= line
        and tr1_part    >= part and tr1__log01 = no and tr1_qty_loc > tr1__dec01 
         break by tr1_nbr by tr1_line :
         find first pt_mstr where pt_mstr.pt_domain = global_domain and pt_part = tr1_part no-lock no-error.
	 if available pt_mstr then do:
            p-desc1 = pt_desc1.
	 end.
	 else do:
	    p-desc1 = "".
	 end.
            display
               tr1_line       label "项次"
               tr1_part       label "零件号"
	       p-desc1        label "说明"
	       tr1_chg    label "数量"
	       tr1_loc   label "转出库位"
            with frame c.

            if frame-line(c) = frame-down(c)
            then
               leave.

            down 1 with frame c.
         end. /* FOR EACH lad_det ... */

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
 for each trhist1
                where trhist1.tr1_domain = global_domain 
               and   tr1_chg   <> 0 
	       and   tr1__log01 = no with frame e   :
               for each sr_wkfl
                  fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
                  sr_rev
                          sr_site sr_user1 sr_user2 sr_userid)
                   where sr_wkfl.sr_domain = global_domain and  sr_userid =
                   mfguser
                    and sr_lineid = string(tr1_line) + "::" + tr1_part
                    and sr_user1   = tr1_lot
                    no-lock
               with frame e   :

                  display
                     tr1_line  @ line
                     tr1_part  label "零件号"
                     tr1_site   @ sr_site label "地点" 
                     tr1_loc_to @ sr_loc label "转入仓库"
                     sr_qty   label  "数量"    
		     with frame e .
                end. /* FOR EACH sr_wkfl ...*/
            end. /* FOR EACH lad_det ... */
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


/*ss-min001 add*************************************************************/
         for each trhist1
                where trhist1.tr1_domain = global_domain 
                and tr1__log01 = no
 	       and   tr1_chg  <> 0
            no-lock break by tr1_nbr by tr1_line  :
 
               for each sr_wkfl
                  fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
                  sr_rev
                          sr_site sr_user2 sr_userid)
                   where sr_wkfl.sr_domain = global_domain and  sr_userid =
                   mfguser
                    and sr_lineid = string(tr1_line) + "::" + tr1_part
                    and sr_site   = tr1_site
                    and sr_loc    = tr1_loc
                    and sr_lotser = tr1_serial
                    and sr_ref    = tr1_ref
                  no-lock
               with width 80:
 
                  for first pt_mstr
                     fields( pt_domain pt_desc1 pt_desc2 pt_lot_ser pt_part
                     pt_um)
                      where pt_mstr.pt_domain = global_domain and  pt_part =
                      tr1_part
                     no-lock:
                  end. /* FOR FIRST pt_mstr */

                  {gprun.i ""icedit.p"" " (""ISS-TR"",
                      sr_site,
                      sr_loc,
                      tr1_part,
                      sr_lotser,
                      sr_ref,
                      sr_qty,
                      pt_um,
                      tr1_lot,
                      tr1_line,
                      output undo-input )" }

                  if not undo-input
                  then do:

                     {gprun.i ""icedit.p"" " (""RCT-TR"",
                         tr1_site,
                         tr1_loc_to,
                         tr1_part,
                         sr_lotser,
                         sr_ref,
                         sr_qty,
                         pt_um,
                         tr1_lot,
                         tr1_line,
                         output undo-input )" }
                  end. /* IF NOT undo-input ... */

                  if undo-input
                  then do:
                     assign
                        line = tr1_line
                        part = tr1_part.
                     next setd.
                  end. /* IF undo-input */

                  /* VALIDATE GRADE ASSAY EXPIRE & INVENTORY STATUS */
                  {gprun.i ""xxprhisc2.p""
                     "(input sr_site,
                       input tr1_site,
                       input sr_loc,
                       input tr1_loc_to,
                       input tr1_part,
                       input sr_lotser,
                       input sr_ref,
                       input sr_qty,
                       input use-to-loc-status,
                       output undo-input)" }

                  if undo-input
                  then do:
                     assign
                        line = tr1_line
                        part = tr1_part.
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

   {gprun.i ""xxprhisa2.p""}

/*ss-min001 add*********************************/
if transok1 then do:
for each trhist1 no-lock where tr1_chg  <> 0 ,
   each tr_hist
    where tr_hist.tr_domain = global_domain 
    and tr_trnbr = tr1_trnbr
      and tr_nbr = ponbr
      and tr_lot = tr1_lot
exclusive-lock:
    assign
       tr__dec01 = tr__dec01 +	tr1_chg.
       if tr_qty_loc <=  tr__dec01 then tr__log01 = yes.
end. 

for each trhist1 no-lock where tr1_chg <> 0 :
notcomp = no.
transok2 = no.
for each tr_hist  no-lock where tr_hist.tr_domain = tr1_domain and tr_nbr = tr1_nbr and 
   tr_line = tr1_line and tr_lot = tr1_lot :
   if tr__log01 = no then notcomp = yes.
   transok2 = yes.
   end.
   if not notcomp and transok2  then do:
    find first prh_hist where prh_hist.prh_domain = global_domain and prh_nbr = tr1_nbr 
    and prh_line = tr1_line  and prh_receiver = tr1_lot no-error.
    if available prh_hist then prh__log01 = yes.
  end.

end.
end. /*if transok1 **********/
for each trhist1 :
delete trhist1.
end.

/*ss-min001 add*********************************/



   {&REPKIS-P-TAG3}

   /*nbr = substring(nbr,9).*/
oldnbr = nbr .
end.  /* MAINLOOP */

/* DELETE STRANDED sr_wkfl and lad_det RECORDS */

for each sr_wkfl
    where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
exclusive-lock:
   delete sr_wkfl.
end. /* FOR EACH sr_wkfl */



/*********START INTERNAL PROCEDURE LOGIC*************/

PROCEDURE setline:

   setline:
   do on error undo, retry on endkey undo, return "undo":

      update
         line
 /*        part */
      with frame d editing:

         if frame-field = "line"
         then do:

            if l_recno <> 0
            then
               recno = l_recno.

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i
               trhist1
               tr1_nbr
              " trhist1.tr1_domain = global_domain and tr1_qty_loc <> tr1__dec01 and tr1__log01 = no"
               tr1_line
               line}

            if recno <> ?
            then do:
               assign
                  line = tr1_line
                  part = tr1_part.
               display
                  line
                  part
		  lotserial_qty
                  tr1_site @ site
                  tr1_loc @ location
                  tr1_serial @ lotserial
                  tr1_ref @ lotref
	          tr1_loc_to @ location1 
               with frame d.
      assign  cline       = string(line) + "::" + part
         global_part = part.
	 location1 = tr1_loc_to.
            end. /* IF recno <> ? */

            /* STORE THE recid TO RETRIEVE THE LAST VISITED WORK CENTER */
            /* THIS IS STORED HERE AS mfnp05.i CALLED BELOW             */
            /* (frame-field = "part") WILL RESET THE recno TO '?'       */
            l_recno = recid (trhist1).

         end. /* IF frame-field = "line" */
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
                  line
                  part
		  tr1_chg @ lotserial_qty
                  tr1_site @ site
                  tr1_loc @ location
                  tr1_serial @ lotserial
                  tr1_ref @ lotref
	          tr1_loc_to @ location1 
               with frame d.
          /*ss-min001  "" @ multi_entry*/
     assign  cline       = string(line) + "::" + part
         global_part = part.
	 	 location1 = tr1_loc_to.

      end. /* UPDATE... EDITING */

      status input.

      if part = "" or line < 1 
      then
         leave.

      multi_entry = no.


      for each trhist1 
          where trhist1.tr1_domain = global_domain
         and    tr1_nbr     = ponbr
	 and    tr1_lot2    = nbr
	 and    tr1_qty_loc <> tr1__dec01
         and    tr1_line    = line
	 and    tr1_part    = part
      no-lock:
         assign
            lotserial_qty = tr1_chg.
	      location1 = tr1_loc_to .
assign  cline       = string(line) + "::" + part
         global_part = part.
	    display lotserial_qty with frame d.
      end. /* FOR EACH lad_det */

      assign
         total_lotserial_qty = lotserial_qty
         lotserial_control   = "".

      if available pt_mstr
      then
         lotserial_control = pt_lot_ser.
/********************
     
         site        = ""
         location    = ""
         location1    = ""
         lotserial   = ""
         lotref      = ""
        
 *******************/
 assign  cline       = string(line) + "::" + part
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
      message "错误, 请重新输入!!" view-as alert-box.
      undo, retry.
/************************
         for first trhist1 
          where trhist1.tr1_domain = global_domain
         and   tr1_nbr     = ponbr
	 and    tr1_lot    = nbr
	 and    tr1_qty_loc <> tr1__dec01
         and   tr1_line    = line
      no-lock:
         end. /* FOR FIRST lad_det */

         assign
            site     = tr1_site
            location = tr1_loc.
	    location1 = tr1_loc_to.
***************************/           
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
	       lotserial_qty = sr_qty.
          
	 for first  trhist1 
          where trhist1.tr1_domain = global_domain
         and    tr1_nbr     = ponbr
	 and    tr1_lot2    =  nbr
	 and    tr1_chg <> 0
         and    tr1_line    = line
	 and    tr1_part    = part:         
      end. 
           if available trhist1 then location1 = tr1_loc_to.

         end. /* FOR FIRST sr_wkfl */

       /*ss-min001  if not available sr_wkfl
         then
            multi_entry = yes.*/

      end. /* ELSE DO */

      setrest:
      do on error undo, retry on endkey undo, leave:

         update
            lotserial_qty
 /*ss-min00            site
1           location 
            lotserial
            lotref  */
	    location1 
/*ss-min001            multi_entry*/
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

               {gprun.i ""xxprhisc2.p""
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
                   do: 
		   /*mage create sr_wkfl. sr_wkfl.sr_domain = global_domain. */ 
		   message "不能增加其它物料" view-as alert-box.
		   undo, retry.
		   end.
		  
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
      for first  trhist1 
          where trhist1.tr1_domain = global_domain
         and    tr1_nbr     = ponbr
	 and    tr1_lot2    =  nbr
	 and    tr1_chg <> 0
         and    tr1_line    = line
	 and    tr1_part    = part:         
      end. 
           if available trhist1 then assign tr1_loc_to =location1 
	                                     tr1_chg = sr_qty.

            end.  /* IF lotserial_qty <> 0 */

            else if available sr_wkfl
               and lotserial_qty = 0
            then
               delete sr_wkfl.

         end.  /* (NOT MULTI_ENRY) */

         for each trhist1
             where trhist1.tr1_domain = global_domain 
	     and tr1_nbr = ponbr
            and   tr1_lot2     = nbr
            and   tr1_line    = line
            and   tr1_part      = part
         exclusive-lock:

            tr1_chg = lotserial_qty.
	    tr1_loc_to = location1.
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
