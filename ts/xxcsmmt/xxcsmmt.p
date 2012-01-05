/* xxcsmmt.p - Consume Detail MAINTENANCE                                    */
/*V8:ConvertMode=Maintenance                                                 */
/*V8:RunMode=Character,Windows                                               */
/*-Revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "111111.1"}

define variable del-yn like mfc_logical initial no.
define variable ptdesc1 like pt_desc1.
define variable ptdesc2 like pt_desc2.
define variable ptum like pt_um.
define variable pmcode like pt_pm_code.

/* DISPLAY SELECTION FORM */
form
   xcsm_part colon 18
   ptdesc1   colon 52
   ptum      colon 18
   ptdesc2   at 54 no-label
   pmcode    colon 18 skip(1)
   xcsm_qty  colon 25
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.
repeat with frame a:

   prompt-for xcsm_part editing:

      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp.i xcsm_det xcsm_part  " xcsm_part " xcsm_part xcsm_part xcsm_part}

      if recno <> ? then do:
      	 display xcsm_part xcsm_qty.
      	 find first pt_mstr no-lock where pt_domain = global_domain
      	 				and pt_part = input xcsm_part no-error.
      	 if available pt_mstr then do:
      	 		assign ptdesc1 = pt_desc1
      	 					 ptum = pt_um
      	 					 pmcode = pt_pm_code
      	 					 ptdesc2 = pt_desc2.
      	 end.
      	 else do:
      	 		  assign ptdesc1 = ""
      	 		  			 ptum = ""
      	 		  			 pmcode = ""
      	 		  			 ptdesc2 = "".
      	 end.
      	 	  display ptdesc1 ptdesc2 ptum pmcode.
      end.
   end.
	
	 find first pt_mstr no-lock where pt_domain = global_domain and 
	 						pt_part = input xcsm_part no-error.
	 if not available pt_mstr then do:
	    assign ptdesc1 = ""
      	 		 ptum = ""
      	 		 pmcode = ""
      	 		 ptdesc2 = "".
	 	 {mfmsg.i 16 3}
	 	  undo,retry.
	 end.
	 else do:
	 		assign ptdesc1 = pt_desc1
      	 		 ptum = pt_um
      	 		 pmcode = pt_pm_code
      	 		 ptdesc2 = pt_desc2.
	 end.
   /* ADD/MOD/DELETE  */
   find xcsm_det using xcsm_part where xcsm_part = input xcsm_part no-error.
   if not available xcsm_det then do:
      {mfmsg.i 1 1}
      create xcsm_det.
      assign xcsm_part.
   end.
   recno = recid(xcsm_det).

   display xcsm_part xcsm_qty ptdesc1 ptdesc2 ptum pmcode.

   ststatus = stline[2].
   status input ststatus.
   del-yn = no.

   do on error undo, retry:
      set xcsm_qty go-on("F5" "CTRL-D" ).

      /* DELETE */
      if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
      then do:
         del-yn = yes.
         {mfmsg01.i 11 1 del-yn}
         if not del-yn then undo, retry.
         delete xcsm_det.
         clear frame a.
         del-yn = no.
      end.
   end.
end.
status input.
