/* SS - 090828.1 By: Neil Gao */

{mfdtitle.i "090827.1"}

define variable del-yn like mfc_logical initial no.
define variable name like ad_name.
define variable desc1 like pt_desc1.
define variable batchdelete as character format "x(1)" no-undo.
define new shared variable vppart like vp_part.
define new shared variable vpvend like vp_vend.

form
	vp_part        	colon 25
  desc1          	no-label at 50
  vp_vend        	colon 25
  name           	no-label at 50
  vp_vend_part   	colon 25 
  skip(1)
  vp_tp_use_pct		colon 25
with frame a side-labels width 80 attr-space.
  
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* SS 090828.1 - B */
/*
判断控制文件
*/
find first mfc_ctrl where mfc_field = "SoftspeedSCM_VP_Part_Sync" no-lock no-error.
if not avail mfc_ctrl or not mfc_logical then do:
	message "SCM未启用".
	pause.
	return.
end.
disp mfc_char @ vp_part with frame a.
/* SS 090828.1 - E */

mainloop:
repeat with frame a:
	
	prompt-for vp_vend vp_vend_part
		batchdelete no-label when (batchrun)	
	editing:
      if frame-field = "vp_vend" then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp05.i vp_mstr vp_partvend "vp_part = input vp_part"
            vp_vend_part "input vp_vend_part"}
         assign vppart = input vp_part.
      end.
      else do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp05.i vp_mstr vp_partvend "vp_part = input vp_part and
          vp_vend = input vp_vend" vp_vend_part "input vp_vend_part"}
          assign vpvend = input vp_vend.
      end.
      if recno <> ? then do:
         desc1 = "".
         find pt_mstr where pt_part = vp_part no-lock no-error.
         if available pt_mstr then desc1 = pt_desc1.
         name = "".
         find ad_mstr where ad_addr = vp_vend no-lock no-error.
         if available ad_mstr then name = ad_name.
         display desc1 name vp_part vp_vend vp_vend_part vp_tp_use_pct.
      end.
   end.

   /* ADD/MOD/DELETE  */
   find vp_mstr where vp_part = input vp_part and vp_vend = input vp_vend
      and vp_vend_part = input vp_vend_part no-error.
   if not available vp_mstr then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create vp_mstr.
      assign vp_part.
      assign vp_vend.
      assign vp_vend_part.
   end.

   /* STORE MODIFY DATE AND USERID */
   vp_mod_date = today.
   vp_userid = global_userid.

   recno = recid(vp_mstr).

   desc1 = "".
   find pt_mstr where pt_part = vp_part no-lock no-error.
   if available pt_mstr then desc1 = pt_desc1.
   name = "".

   find ad_mstr where ad_addr = vp_vend no-lock no-error.
   if available ad_mstr then name = ad_name.
   if not available ad_mstr then do:
      {pxmsg.i &MSGNUM=2 &ERRORLEVEL=2}
      /* Vendor does not exist */
   end.

   find vd_mstr where vd_addr = vp_vend no-lock no-error.
   if not available vd_mstr then
   do:
      {pxmsg.i &MSGNUM=2 &ERRORLEVEL=3}
      next-prompt vp_vend with frame a.
      undo mainloop, retry.
   end.   /*  IF NOT AVAILABLE VD_MSTR  */

  if  new vp_mstr
  and available vd_mstr
  then
     assign
        vp_tp_pct = vd_tp_pct
        vp_curr   = vd_curr.

   /* SET GLOBAL PART VARIABLE */
   global_part = vp_part.

   display vp_part vp_vend vp_vend_part vp_tp_use_pct.

	loop1:
	do on error undo, retry:
		
		del-yn = no.
		update vp_tp_use_pct
		go-on ("F5" "CTRL-D" ).
	
		/* DELETE */
    if lastkey = keycode("F5")
    	or lastkey = keycode("CTRL-D")
      /* Delete to be executed if batchdelete is set to "x" */
      or input batchdelete = "x":U
    then do:
    	del-yn = yes.
      {mfmsg01.i 11 1 del-yn}
      if not del-yn then undo.
      delete vp_mstr.
      clear frame a.
      del-yn = no.
      next mainloop.
		end. /* if lastkey = keycode("F5") */
	
	end. /* loop1 */

end. /* mainloop */
  