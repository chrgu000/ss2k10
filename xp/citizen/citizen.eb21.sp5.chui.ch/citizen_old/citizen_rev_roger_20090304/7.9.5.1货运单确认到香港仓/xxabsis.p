

{mfdtitle.i "2+ "}
{cxcustom.i "REPKIS.P"}

{gldydef.i new}
{gldynrm.i new}
define new shared variable ponbr as character format "x(10)" label "Picklist".

define new shared variable nbr as character format "x(20)" label "货运单".
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

define variable line       like tr_line.
define variable wkctr      like op_wkctr.
define variable comp       like ps_comp.
define variable prod_site  like lad_site.
define variable alloc      like mfc_logical label "Alloc" initial yes.
define variable picked     like mfc_logical label "Picked" initial yes.
define variable part       like pt_part label "零件号".
define variable qopen      like lad_qty_all.
define variable yn         like mfc_logical.
define variable l_recno    as   recid        no-undo.

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

 define new shared variable transok1 like mfc_logical .
 define new shared variable transok2 like mfc_logical .


issue_or_receipt = getTermLabel("ISSUE",8).

/* THE FRAME E IS DEFINED SO THAT THE COMPONENTS BEING */
/* TRANSFERRED ARE NOT DISPLAYED ON THE SAME LINE.     */

define frame e

   line       label "行" format ">>9"
   tr1_nbr    label "销售单"
   tr1_trnbr  label "项次" format ">>9"
   tr1_part   label "零件号"
   sr_loc     label "转出仓库"
   /*sr_lotser  label "批/序号"*/
   sr_qty     label  "数量" 
with down no-attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame e:handle).

{gpglefv.i}

form
   space(1)
   prod_site
   nbr
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
	line           colon 7   label "行"  
	lotserial_qty  colon 49  label "数量" 
	pt_um                    label "UM" 
	part           colon 7   label "零件"        
	site           colon 49  label "地点" 
	location				 label "库位自" 
	pt_desc1       colon 7   label "说明"     
	lotserial      colon 49  label "批/序号" 
	pt_desc2       colon 7   no-label 
	lotref         colon 49  label "参考"
	location1				 label "库位至"
with frame d side-labels width 80 attr-space.

/* SET EXTERNAL LABELS 
setFrameLabels(frame d:handle).*/

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
      nbr     = oldnbr /*?*/
	  prod_site = global_site
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
         prod_site
         nbr
		 loc-to

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

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i abs_mstr
                      abs_id
                     " abs_mstr.abs_domain = global_domain 
					   and abs_shipfrom  = input prod_site 
					   and abs_id begins 'S' "
                      abs_id
                     " 'S' + input nbr "}

            if recno <> ? then
               display
                  substring(abs_id,2,50) @ nbr
                  abs_shipfrom @ prod_site
               with frame a.

         end. /* ELSE IF frame-field = "nbr" */
         else do:
            status input.
            readkey.
            apply lastkey.
         end. /* ELSE DO */
      end. /* EDITING */

	  assign prod_site 
			 loc-to
			 nbr = "S" + nbr .

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

      if loc-to <> "" then do:
			for first loc_mstr	fields( loc_domain loc_loc)
			where loc_mstr.loc_domain = global_domain 
			and loc_site = prod_site
			and  loc_loc = loc-to
			no-lock:
			end. /* FOR FIRST loc_mstr */

			if not available loc_mstr
			then do:
				/* LOCATION DOES NOT EXIST */
				{pxmsg.i &MSGNUM=709 &ERRORLEVEL=3}
				next-prompt loc-to with frame a .
				undo, retry.
			end. /* IF NOT AVAILABLE loc_mstr */

			if not 
			(not can-find(first code_mstr where code_mstr.code_domain = global_domain and  code_fldname = "hk_loc" )
			 or  can-find (code_mstr  where code_mstr.code_domain = global_domain 
						  and code_fldname = "hk_loc" 
						  and code_value   =  loc-to )
			) then do:
			  message "转入库位无效。" view-as alert-box .
			  next-prompt loc-to with frame a .
			  undo,retry .
			end.  

      end.
	  else do :
			message "转入库位不可为空" view-as alert-box.
			undo,retry.
	  end.



/*start trans***********************************************************/
		transok = no.
		for each trhist1:
		delete trhist1.
		end.


		find first abs_mstr where abs_domain = global_domain 
									and abs_shipfrom = prod_site  
									and abs_id = nbr 
									and (substring(abs_status,2,1) <> "y") 
		no-lock no-error .
		if not avail abs_mstr then do:
					message "错误:货运单不存在或已确认,请重新输入".
					undo,retry.
		end.

		line = 0 .
		for each  abs_mstr where abs_domain = global_domain 
							and abs_shipfrom = prod_site  
							and abs_par_id = nbr 
		no-lock :
		
			line = line + 1 .
			create trhist1.
			assign tr1_domain = abs_domain
				tr1_site   = abs_shipfrom
				tr1_part   = abs_item
				tr1_nbr    = abs_order
				tr1_trnbr  = integer(abs_line)
				tr1_lot    = abs_par_id
				tr1_line   = line 
				tr1_loc    = abs_loc	
				tr1_serial = abs_lotser
				tr1_ref    = abs_ref
				tr1_chg    = abs_qty
				tr1_loc_to = loc-to .
		    transok = yes.
		end. /*for each **/

		if not transok  then do:
			message "错误:货运单不存在或已确认,请重新输入".
			undo,retry.
		end.

		line = 0 .

/*ss-min001 add*********************************************************/

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
		 
		 /*VALIDATE OPEN GL PERIOD*/
         {gpglef1.i &module = ""IC""
                    &entity = si_entity
                    &date   = eff_date
                    &prompt = "eff_date"
                    &frame  = "b"
                    &loop   = "setb"
            }
      end. /* DO WITH FRAME b ... */
   end.  /* SETSITE:  DO: */

   {gprun.i ""xxabsissb.p"" }

   setd:
   do while true:

      /* DISPLAY DETAIL */
	  repeat:
         clear frame c all no-pause.
         clear frame d all no-pause.
         view frame c.
         view frame d.

/*ss-min001 add*********************************************************/

for  each trhist1 no-lock where trhist1.tr1_domain = global_domain 
	and tr1_trnbr    >= line
	break by tr1_nbr by tr1_line :

	find first pt_mstr where pt_mstr.pt_domain = global_domain and pt_part = tr1_part no-lock no-error.
	p-desc1 = if available pt_mstr then pt_desc1 else "" .

	display
		tr1_line        label "行"
		tr1_nbr         label "销售单"
		tr1_trnbr       label "项次" format ">>9"
		tr1_part        label "零件号"
		tr1_chg         label "数量"
		tr1_loc         label "转出库位"
	with frame c.

	if frame-line(c) = frame-down(c)
	then leave.

	down 1 with frame c.
end. /* FOR EACH  ... */
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

/*ss-min001 add**************************************************************/
for each trhist1
	where trhist1.tr1_domain = global_domain 
	and   tr1_chg   <> 0 
	with frame e break by tr1_line  :

	for each sr_wkfl
	fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
	sr_rev sr_site sr_user1 sr_user2 sr_userid)
	where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
	and sr_lineid = string(tr1_line) + "::" + tr1_part
	and sr_user1   = tr1_nbr
	no-lock
	with frame e   :


		display
			tr1_line  @ line
			tr1_nbr   
			tr1_trnbr  
			tr1_part    
			/*sr_lotser */ 
			sr_loc 
			sr_qty       
		with frame e .
	end. /* FOR EACH sr_wkfl ...*/
end. /* FOR EACH  ... */
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


/*ss-min001 add*************************************************************/
			for each trhist1
			where trhist1.tr1_domain = global_domain 
			and   tr1_chg  <> 0
			no-lock break by tr1_nbr by tr1_trnbr  :

				for each sr_wkfl
				fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
				sr_rev sr_site sr_user2 sr_userid)
				where sr_wkfl.sr_domain = global_domain 
				and  sr_userid = mfguser
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
                      tr1_trnbr,
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
                         tr1_trnbr,
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
                  {gprun.i ""xxabsissc.p""
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
            end. /* FOR EACH  ... */
/*ss-min001 add*************************************************************/

            {&REPKIS-P-TAG2}
            hide frame c.
            hide frame d.
            leave setd.
         end. /* IF yn THEN DO */
      end.  /* DO ON ENDKEY... */
   end. /* SETD:  DO WHILE TRUE: */


 {gprun.i ""xxabsissa.p""}

/*ss-min001 add*********************************/
if transok1 then do:
	for each trhist1 :
		find first abs_mstr where abs_domain = tr1_domain 
							and abs_par_id = tr1_lot 
							and abs_order = tr1_nbr 
							and integer(abs_line) = tr1_trnbr 
		exclusive-lock no-error.
		if avail abs_mstr then do:
			abs_loc = tr1_loc_to .
		end.

		delete trhist1.
	end.

end. /*if transok1 **********/


/*ss-min001 add*********************************/



   {&REPKIS-P-TAG3}

   oldnbr = substring(nbr,2,50).

end.  /* MAINLOOP */

for each sr_wkfl
	where sr_wkfl.sr_domain = global_domain 
	and  sr_userid = mfguser
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

           /* if l_recno <> 0 then  recno = l_recno.*/
			{mfnp05.i
				trhist1
				tr1_nbr
				" trhist1.tr1_domain = global_domain "
				tr1_line
				line}

            if recno <> ? then do:
				assign
					line = tr1_line
					part = tr1_part.

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
				assign  cline = string(line) + "::" + part
						global_part = part.
						location1 = tr1_loc_to.


            end. /* IF recno <> ? */

            /*l_recno = recid (trhist1).*/

         end. /* IF frame-field = "line" */
         else do:
            status input.
            readkey.
            apply lastkey.
         end. /* ELSE DO */



      end. /* UPDATE... EDITING */
      assign line .

      status input.
	  

      if part = "" or line = 0  
      then
         leave .

        multi_entry = no.


		for each trhist1 
			where trhist1.tr1_domain = global_domain
			and    tr1_line    = line
			and    tr1_part    = part
			no-lock:

				assign
					lotserial_qty = tr1_chg
					location1 = tr1_loc_to .

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
					lotserial_qty
					tr1_site @ site
					tr1_loc @ location
					tr1_serial @ lotserial
					tr1_ref @ lotref
					tr1_loc_to @ location1 
				with frame d.
				assign  cline = string(line) + "::" + part
						global_part = part.

		end. /* FOR EACH ... */

      assign
         total_lotserial_qty = lotserial_qty
         lotserial_control   = "".

      if available pt_mstr
      then
         lotserial_control = pt_lot_ser.

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
and    tr1_line    = line
and    tr1_part    = part:         
end. 
if available trhist1 then location1 = tr1_loc_to.

         end. /* FOR FIRST sr_wkfl */


      end. /* ELSE DO */

      setrest:
      do on error undo, retry on endkey undo, leave:
/* 
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
         end. UPDATE ... */

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

               {gprun.i ""xxabsissc.p""
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
and    tr1_line    = line
and    tr1_part    = part:         
end. 
if available trhist1 then 
assign tr1_loc_to =location1 
	 tr1_chg = sr_qty.

            end.  /* IF lotserial_qty <> 0 */

            else if available sr_wkfl
               and lotserial_qty = 0
            then
               delete sr_wkfl.

         end.  /* (NOT MULTI_ENRY) */

for each trhist1
where trhist1.tr1_domain = global_domain 
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

         end.  /* EACH sr_wkfl */
      end. /* SETREST: DO: */
   end. /* SETLINE: DO: */

END PROCEDURE. /* PROCEDURE setline */
