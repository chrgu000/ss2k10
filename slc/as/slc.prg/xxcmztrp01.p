/*By: Neil Gao 08/11/26 ECO: *SS 20081126* */

{mfdeclre.i}  
{gplabel.i} 

define var cust like so_cust.
define var part like pt_part.
define var tt_recid as recid.
define var first-recid as recid.
define var sw_reset     like mfc_logical. 
define var eff_date as date init today.
define variable lvl as char.
define variable maxlevel as int.
define variable level as integer.
define var tcmmt1 as char format "x(76)".
define var tcmmt2 as char format "x(76)".
define var tcmmt3 as char format "x(76)".
define var tcmmt4 as char format "x(76)".
define var tcmmt5 as char format "x(76)".
define var tcmmt6 as char format "x(76)".
define var tcmmt7 as char format "x(76)".
define var tcmmt8 as char format "x(76)".

define temp-table xxtt
  field xxtt_f1 like so_cust
	field xxtt_f2 like pt_part
	field xxtt_f3 like cm_sort format "x(24)"
	field xxtt_f4 like pt_desc1
	index xxtt_f2 
	      xxtt_f1 xxtt_f2.

define new shared temp-table xxtt1 
	field xxtt1_f1 as char format "x(6)"
	field xxtt1_f2 like ps_comp
	field xxtt1_f3 like pt_desc1
	field xxtt1_f4 like ps_qty_per
	field xxtt1_f5 like pt_um
	field xxtt1_f6 like pt_phantom
	field xxtt1_f7 like pt_pm_code
	field xxtt1_f8 like pt_iss_pol.
	
form
	cust colon 15
	part colon 15
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
	 xxtt_f1 label "客户"
   xxtt_f3 label "简称"
   xxtt_f2 label "成品号"
   xxtt_f4 label "说明"
with frame b width 80 no-attr-space scroll 1.
/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

define new shared frame c .

form
	tcmmt1 no-label
	tcmmt2 no-label
	tcmmt3 no-label
	tcmmt4 no-label
	tcmmt5 no-label
	tcmmt6 no-label
	tcmmt7 no-label
	tcmmt8 no-label
with frame c width 80 .

mainloop:
repeat with frame a:

	update cust part with frame a editing:
		global_addr = input cust.
		status input .
		readkey.
		apply lastkey.
	end.
	
	empty temp-table xxtt.
	for each cp_mstr where cp_domain = global_domain 
		and ( cp_cust = cust or cust = "" ) 
		and ( cp_part = part or part = "" ) no-lock,
		each pt_mstr where pt_domain = global_domain and pt_part = cp_part no-lock,
		each cm_mstr where cm_domain = global_domain and cm_addr = cp_cust no-lock:
		
		create xxtt.
		assign xxtt_f1 = cp_cust
						xxtt_f2 = cp_part
						xxtt_f3 = cm_sort
						xxtt_f4 = pt_desc1.
			
	end.
	
	find first xxtt no-lock no-error.
	if not avail xxtt then do:
		message "没有记录存在".
		next.
	end.
	
	scroll_loop:
	repeat:
		hide frame a no-pause.
		{xuview.i
    	     &buffer = xxtt
    	     &scroll-field = xxtt_f2
    	     &framename = "b"
    	     &framesize = 6
    	     &display1     = xxtt_f1
    	     &display2     = xxtt_f3
    	     &display3     = xxtt_f2
    	     &display4     = xxtt_f4
    	     &searchkey    = true
    	     &logical1     = false
    	     &first-recid  = first-recid
    	     &exitlabel = scroll_loop
    	     &exit-flag = true
    	     &record-id = tt_recid
    	     &cursordown = " 	if avail xxtt then run dispcmmt(xxtt_f2 ).
                         "
    	     &cursorup   = "  if avail xxtt then run dispcmmt(xxtt_f2 ).
                         "
    	     }
    
    if not avail xxtt then leave.
    
    if keyfunction(lastkey) = "end-error" then do:
    	leave.
    end.
    
    if keyfunction(lastkey) = "return" then do:
    	level    = 1.
    	run process_crtb (input xxtt_f2,input level).
  		hide frame b no-pause.
  		{gprun.i ""xxcmztrp02.p""}
    end.
    
    if keyfunction(lastkey) = "go" then do:
    	hide frame b no-pause.
    	hide frame c no-pause.
    	
    	{mfselprt.i "printer" 132}
    	{gprun.i ""xxcmztrp03.p""}
	
			{mfreset.i}
			{mfgrptrm.i}
			/*view frame a .*/
			view frame b .
			view frame c .
			
			
    end.
	
	end.
	hide frame b no-pause.
	hide frame c no-pause.
	
	
end. /* mainloop */

procedure dispcmmt:

	define input parameter iptpart like pt_part.
	
	tcmmt1 = "".
	tcmmt2 = "".
	tcmmt3 = "".
	tcmmt4 = "".
	tcmmt5 = "".
	tcmmt6 = "".
	tcmmt7 = "".
	tcmmt8 = "".
	
	find first cd_det where cd_domain = global_domain and cd_ref = iptpart and cd_lang = "ch"
 		and cd_type = "SC" no-lock no-error.
	if avail cd_det then do:
		tcmmt1 = cd_cmmt[1] .
		tcmmt2 = cd_cmmt[2] .
		tcmmt3 = cd_cmmt[3] .
		tcmmt4 = cd_cmmt[4] .
		tcmmt5 = cd_cmmt[5] .
		tcmmt6 = cd_cmmt[6] .
		tcmmt7 = cd_cmmt[7] .
		tcmmt8 = cd_cmmt[8] .

	end.
	disp tcmmt1 tcmmt2 tcmmt3 tcmmt4 tcmmt5 tcmmt6 tcmmt7 tcmmt8 with frame c.

end.

PROCEDURE process_crtb:
   define input parameter comp like ps_comp no-undo.
   define input parameter level as integer no-undo.

   define query q_ps_mstr for ps_mstr
      fields( ps_domain ps_comp ps_end ps_par ps_ps_code ps_qty_per ps_start).

   for first bom_mstr
      fields( bom_domain bom_batch_um bom_desc bom_fsm_type bom_parent)
       where bom_mstr.bom_domain = global_domain and  bom_parent = comp
      no-lock:
   end. /* FOR FIRST bom_mstr */

   for first pt_mstr
      fields( pt_domain pt_bom_code pt_desc1 pt_desc2 pt_pm_code
      pt_iss_pol  pt_part  pt_phantom pt_um)
      no-lock
       where pt_mstr.pt_domain = global_domain and  pt_part = comp:
   end. /* FOR FIRST pt_mstr */

   if available pt_mstr
   and pt_bom_code <> ""
   then
      comp = pt_bom_code.

   open query q_ps_mstr
      for each ps_mstr
      use-index ps_parcomp
       where ps_mstr.ps_domain = global_domain and  ps_par = comp no-lock.

   get first q_ps_mstr no-lock.

   if not available ps_mstr
   then
      return.

   repeat while available ps_mstr with frame heading  down:


      if eff_date = ? or (eff_date <> ? and
         (ps_start = ? or ps_start <= eff_date)
         and (ps_end = ? or eff_date <= ps_end))
      then do:

         for first pt_mstr
            fields( pt_domain pt_bom_code pt_desc1 pt_desc2 pt_iss_pol pt_pm_code
                   pt_part pt_phantom pt_um)
             where pt_mstr.pt_domain = global_domain and  pt_part = ps_comp
            no-lock:
         end. /* FOR FIRST pt_mstr */
					
				create xxtt1.
				assign xxtt1_f2 = ps_comp.
					
         if available pt_mstr
         then do:
            assign
               xxtt1_f5 = pt_um
               xxtt1_f3 = pt_desc1
               xxtt1_f8 = pt_iss_pol
               xxtt1_f7 = pt_pm_code
               xxtt1_f6 = pt_phantom.
         end.
         else do:
            for first bom_mstr
               fields( bom_domain bom_batch_um bom_desc bom_fsm_type bom_parent)
                where bom_mstr.bom_domain = global_domain and  bom_parent =
                ps_comp
               no-lock:
            end. /* FOR FIRST bom_mstr */
            if available bom_mstr
            then
               assign
                  xxtt1_f5 = bom_batch_um
                  xxtt1_f3 = bom_desc.
         end.

         assign
            lvl = "......."
            lvl = substring(lvl,1,min(level - 1,6)) + string(level).
					
         if length(lvl) > 7
         then
            lvl = substring(lvl,length(lvl) - 6,7).
					
					xxtt1_f1 = lvl.
					xxtt1_f4 = ps_qty_per.

         if level < maxlevel
         or maxlevel = 0
         then do:

            run process_crtb (input ps_comp, input level + 1).
            get next q_ps_mstr no-lock.
         end.
         else do:
            get next q_ps_mstr no-lock.
         end.
      end.  /* End of Valid date */
      else do:
         get next q_ps_mstr no-lock.
      end.
   end.  /* End of Repeat loop */
   close query q_ps_mstr.
END PROCEDURE.

