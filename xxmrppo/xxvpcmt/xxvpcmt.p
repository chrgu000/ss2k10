/* xxvpcmt.p - vender po part ctrl maintance                                 */
/* revision: 110826.1   created on: 20110826   by: zhang yun                 */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "110826.1"}

define variable del-yn like mfc_logical initial no.
define variable vdsort like vd_sort.
define variable ptdesc1 like pt_desc1.

/* DISPLAY SELECTION FORM */
form
   xvp_vend colon 20 vdsort no-label colon 40
   xvp_part colon 20 ptdesc1 no-label skip(1) 
   xvp_rule colon 20
   xvp_ord_min colon 20
   xvp_week colon 20
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.
repeat with frame a:

   prompt-for xvp_vend xvp_part editing:

      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp.i xvp_ctrl xvp_vend xvp_vend xvp_part xvp_part xvp_vend_part}

      if recno <> ? then do:
         display xvp_vend xvp_part xvp_rule xvp_ord_min xvp_week.
         find first vd_mstr no-lock where vd_addr = input xvp_vend no-error.
         if available vd_mstr then do:
            display vd_sort @ vdsort with frame a.
         end.
         else do:
            display "" @ vdsort with frame a.
         end.
         find first pt_mstr no-lock where pt_part = xvp_part no-error.
			   if available pt_mstr then do:
			   	  display pt_desc1 @ ptdesc1 with frame a.
			   end. 
			   else do:
			   	  display "" @ ptdesc1 with frame a.
			   end.
      end.
   end.
   if not can-find(first vd_mstr no-lock where vd_addr = input xvp_vend)
     then do:
     {pxmsg.i &MSGNUM=2 &ERRORLEVEL=3}
      undo, retry.
   end.
   if not can-find(first pt_mstr no-lock where pt_part = input xvp_part)
      then do:
      {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3}
      undo, retry.
   end.
   find first vd_mstr no-lock where vd_addr = input xvp_vend no-error.
   if available vd_mstr then do:
      display vd_sort @ vdsort with frame a.
   end.
   else do:
      display "" @ vdsort with frame a.
   end.
   find first pt_mstr no-lock where pt_part = input xvp_part no-error.
   if available pt_mstr then do:
   	  display pt_desc1 @ ptdesc1 with frame a.
   end. 
   else do:
   	  display "" @ ptdesc1 with frame a.
   end.
   /* ADD/MOD/DELETE  */
   find xvp_ctrl using xvp_vend where xvp_part = input xvp_part no-error.
   if not available xvp_ctrl then do:
      {mfmsg.i 1 1}
      create xvp_ctrl.
      assign xvp_vend xvp_part.
   end.
   recno = recid(xvp_ctrl).

   display xvp_vend xvp_part xvp_rule xvp_ord_min xvp_week.

   ststatus = stline[2].
   status input ststatus.
   del-yn = no.
	
	 setx:
   do on error undo, retry:
      set xvp_rule xvp_ord_min xvp_week go-on("F5" "CTRL-D" ).
			if index("MW",substring(xvp_rule,1,1)) = 0 then do:
		  	 {pxmsg.i &MSGNUM=2479 &ERRORLEVEL=3}
         undo, retry.
		  end.
		  if substring(xvp_rule,1,1) = "W" then do:
		  	 assign ptdesc1 = substring(xvp_rule,2).
		  	 del-yn = no.
		  	 repeat: 
		  	 	   if integer(substring(ptdesc1,1,index(ptdesc1,",") - 1)) > 6 or
		  	 	   	  integer(substring(ptdesc1,1,index(ptdesc1,",") - 1)) < 0 
		  	 	   then do:
			  	 	   del-yn = yes.
	         		 leave.
		  	 	   end.
		  	 	   assign ptdesc1 = substring(ptdesc1,index(ptdesc1,",") + 1).
		  	 	   if index(ptdesc1,",") = 0 then do:
		  	 	      if integer(ptdesc1) < 0 or integer(ptdesc1) > 6 then do:
		  	 	      	 del-yn = yes.
		  	 	      end.
		  	 	   		leave.
		  	 	   end.
		  	 end.
		  end.
		  else if substring(xvp_rule,1,1) = "M" then do:
		  	 assign ptdesc1 = substring(xvp_rule,2).
		  	 del-yn = no.
		  	 repeat: 
		  	 	   if integer(substring(ptdesc1,1,index(ptdesc1,",") - 1)) > 28 or
		  	 	   	  integer(substring(ptdesc1,1,index(ptdesc1,",") - 1)) < 0 
		  	 	   then do:
			  	 	   del-yn = yes.
	         		 leave.
		  	 	   end.
		  	 	   assign ptdesc1 = substring(ptdesc1,index(ptdesc1,",") + 1).
		  	 	   if index(ptdesc1,",") = 0 then do:
		  	 	      if integer(ptdesc1) < 0 or integer(ptdesc1) > 28 then do:
		  	 	      	 del-yn = yes.
		  	 	      end.
		  	 	   		leave.
		  	 	   end.
		  	 end.
		  end.
		  if del-yn then do:
		  	  {pxmsg.i &MSGNUM=2479 &ERRORLEVEL=3}
		  	  next-prompt xvp_rule with frame a.
          undo, retry.
		  end.
      /* DELETE */
      if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
      then do:
         del-yn = yes.
         {mfmsg01.i 11 1 del-yn}
         if not del-yn then undo, retry.
         delete xvp_ctrl.
         clear frame a.
         del-yn = no.
      end.
   end.
end.
status input.
