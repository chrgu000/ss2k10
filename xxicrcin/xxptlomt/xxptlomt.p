/* xxptlomt.p - part loc reference maintenance                               */
/* revision: 110728.1   created on: 20110728   by: zhang yun                 */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1C04  QAD:eb21sp7    Interface:Character         */
/*-Revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "110728.1"}
define variable sw_reset    like mfc_logical.
define variable del-yn like mfc_logical initial no.
define variable part like pt_part.
define variable template1 as character.
define variable only_activate like mfc_logical.
define variable templated as character format "x(40)".
define variable sidesc like si_desc.
define variable locdesc like loc_desc.

/* DISPLAY SELECTION FORM */

form {ppptmta1.i}
with frame a side-labels width 80 attr-space.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form xxpl_site colon 25 sidesc no-label
     xxpl_loc  colon 25 locdesc no-label skip(1)     
     xxpl_type colon 25
     xxpl_rank colon 25
     xxpl_cap  colon 25
with frame bb title color 
		 normal(getFrameTitle("PREVENTIVE_MAINTENANCE_DETAIL",30))
     side-labels width 80.
setFrameLabels(frame bb:handle).
/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:
      prompt-for pt_mstr.pt_part
      editing:
          {mfnp.i pt_mstr pt_part pt_part pt_part pt_part pt_part}
         if recno <> ? then do:
            display pt_part pt_desc1 pt_desc2 pt_um
            with frame a.
            clear frame bb.
            find first xxpl_ref no-lock where xxpl_part = pt_part
                 no-error.
            if available xxpl_ref then do:
               display xxpl_site xxpl_loc xxpl_type 
               			   xxpl_rank xxpl_cap with frame bb.
               run disploc(input xxpl_site,input xxpl_loc).
            end.
         end.
      end.
  repeat with frame bb:
  		if input xxpl_site = "" then do:
  			find first si_mstr no-lock where si_site <> "".
  			if available si_mstr then do:
  				 display si_site @ xxpl_site si_desc @ sidesc with frame bb.
  		  end.
  	  end.
      prompt-for
         xxpl_site xxpl_loc
      editing:
         if frame-field = "xxpl_site" then do:
            {mfnp01.i xxpl_ref xxpl_site xxpl_site
                      pt_part xxpl_part xxpl_part}

            if recno <> ? then do:
               display xxpl_site xxpl_loc xxpl_type
               				 xxpl_rank xxpl_cap with frame bb.
               run disploc(input xxpl_site,input xxpl_loc).
            end. /* if recno */
         end. /* frame-field */
         else if frame-field = "xxpl_loc" then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp05.i loc_mstr
                   loc_loc
                   "(loc_site = input xxpl_site)"
                   xxpl_loc
                   "input xxpl_loc"}
         if recno <> ? then do:
            /* FIND NEXT/PREVIOUS RECORD */
            display 
               loc_loc @ xxpl_loc
            with frame bb. 
            run disploc(loc_site,loc_loc).
            find first xxpl_ref no-lock where xxpl_part = pt_part 
                   and xxpl_site = input xxpl_site
            		   and xxpl_loc = input xxpl_loc no-error.
            if available xxpl_ref then do:
            	 display xxpl_type xxpl_rank xxpl_cap with frame bb.
            	 run disploc(input xxpl_site,input xxpl_loc).
            end.
            else do:
            	 display "" @ xxpl_type 
            	 				 "" @ xxpl_rank 
            	 				 "" @ xxpl_cap
            	  with frame bb.
            end.
         end.  /* if recno <> ? */
      end.  /* if frame-field = "xxpl_loc" */
         else do:
            readkey.
            apply lastkey.
         end.
      end. /* editing */

      if input xxpl_site = "" then do:
          {pxmsg.i &MSGNUM=941 &ERRORLEVEL=3}
         undo,retry.
      end.
      else do:
      	if not can-find(si_mstr no-lock where si_site = input xxpl_site)
      	then do:
      		  {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}
            undo,retry.
        end.
      end.
      if input xxpl_loc = "" then do:
         {pxmsg.i &MSGNUM=709 &ERRORLEVEL=3}
         undo,retry.
      end.
      else do:
      	if not can-find(first loc_mstr no-lock where
      			 (loc_site = input xxpl_site) and loc_loc = input xxpl_loc) and 
      			 input xxpl_site <> ""
      	then do:
      		  {pxmsg.i &MSGNUM=8292 &ERRORLEVEL=3}
            undo,retry.
        end.
    	end.

      find xxpl_ref
         where xxpl_part = input pt_part
           and xxpl_site = input xxpl_site
           and xxpl_loc = input xxpl_loc
      exclusive-lock no-error.
      if not available xxpl_ref then do:
         create xxpl_ref.
         assign xxpl_part = input pt_part
                xxpl_site
                xxpl_loc.
      end.
            display xxpl_site xxpl_loc xxpl_type xxpl_rank xxpl_cap
      with frame bb.

      set2:
      do on error undo, retry:

         del-yn = no.
         ststatus = stline[2].
         status input ststatus.

         set xxpl_type xxpl_rank xxpl_cap
         go-on (F5 CTRL-D) with frame bb.
         display xxpl_site xxpl_loc xxpl_type xxpl_rank xxpl_cap with frame bb.
         if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
            del-yn = no.
            /*CHECK FOR EXISTENCE OF REPETITIVE SCHEDULE FOR AN ITEM BEFORE  */
            /*  DELETING IT.                                                 */
            hide message.
            {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}

            if del-yn = no then undo set2.
            else do:
                delete xxpl_ref.
                clear frame bb no-pause.
            end.
         end.  /* if lastkey */

      end. /* set2 */
   end.

end.

   ststatus = stline[2].
   status input ststatus.

procedure disploc:
	define input parameter isite like pt_site.
	define input parameter iloc  like loc_loc.
	find first loc_mstr where loc_site = isite and loc_loc = iloc 
			 no-lock no-error.
	if available loc_mstr then do:
		 display loc_desc @ locdesc with frame bb.
	end.
	else do:
		 display "" @ locdesc with frame bb.
	end.
	run dispsite(input isite).
end procedure.

procedure dispsite:
	define input parameter isite like pt_site.
	find first si_mstr where si_site = isite no-lock no-error.
	if available si_mstr then do:
		 display si_desc @ sidesc with frame bb.
	end.
	else do:
		 display "" @ sidesc with frame bb.
	end.
end procedure.