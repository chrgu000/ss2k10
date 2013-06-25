/* edvpmt.p - EDI VENDOR PART MAINTENANCE                                    */
/* revision: 110712.1   created on: 20110712   by: zhang yun                 */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1C04  QAD:eb21sp7    Interface:Character         */
/*-Revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "110712.1"}

define variable mc-error-number like msg_nbr no-undo.

define variable del-yn like mfc_logical initial no.
define variable name like ad_name.
define variable desc1 like pt_desc1.
define new shared variable vppart like vp_part.
define new shared variable vpvend like vp_vend.

/* Variable added to perform delete during CIM.
 * Record is deleted only when the value of this variable
 * Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.

/* DISPLAY SELECTION FORM */
form
   vp_part        colon 25
   desc1          no-label at 50
   vp_vend        colon 25
   name           no-label at 50 skip(1)
   vp_tp_use_pct  colon 25 vp_tp_pct  no-label colon 35
   vp_comment     colon 25
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */

view frame a.
mainloop:
repeat with frame a:

   /* Initialize delete flag before each display of frame */
   batchdelete = "".

   prompt-for vp_mstr.vp_part vp_vend
   /* Prompt for the delete variable in the key frame at the
    * End of the key field/s only when batchrun is set to yes */
   batchdelete no-label when (batchrun)
   editing:
      if frame-field = "vp_part" then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i vp_mstr vp_part  " vp_mstr.vp_domain = global_domain and
         vp_part "  vp_part vp_part vp_partvend}
         assign vppart = input vp_part.
      end.
      else do:
          readkey.
          apply lastkey.
      end.
      if recno <> ? then do:
         desc1 = "".
         find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
         vp_part no-lock no-error.
         if available pt_mstr then desc1 = pt_desc1.
         name = "".
         find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr =
         vp_vend no-lock no-error.
         if available ad_mstr then name = ad_name.
         display desc1 name vp_part vp_vend
                 vp_tp_use_pct vp_tp_pct vp_comment.
      end.
   end.

   /* ADD/MOD/DELETE  */

   find vp_mstr  where vp_mstr.vp_domain = global_domain and  vp_part = input
   vp_part and vp_vend = input vp_vend no-error.
   if not available vp_mstr then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create vp_mstr. vp_mstr.vp_domain = global_domain.
      assign vp_part.
      assign vp_vend.
   end.

   /* STORE MODIFY DATE AND USERID */
   vp_mod_date = today.
   vp_userid = global_userid.

   recno = recid(vp_mstr).

   desc1 = "".
   find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = vp_part
   no-lock no-error.
   if available pt_mstr then desc1 = pt_desc1.
   name = "".

   find ad_mstr where ad_domain = global_domain
                and   ad_addr   = vp_vend
      no-lock no-error.
   if available ad_mstr
   then
      name = ad_name.

   /* ISSUE AN ERROR IN CASE OF INVALID SUPPLIER, EXCEPT BLANK */
   find vd_mstr  where vd_mstr.vd_domain = global_domain
      and  vd_addr = vp_vend
   no-lock no-error.
   if not available vd_mstr
      and vp_vend <> ""
   then do:
      /* NOT A VALID SUPPLIER */
      {pxmsg.i &MSGNUM=2 &ERRORLEVEL=3}
      next-prompt vp_vend with frame a.
      undo mainloop, retry.
   end.   /*  IF NOT AVAILABLE vd_mstr  */

   if  new vp_mstr
   and available vd_mstr
   then
      assign
         vp_tp_pct = vd_tp_pct
         vp_curr   = vd_curr.

   /* SET GLOBAL PART VARIABLE */
   global_part = vp_part.

   display vp_part vp_vend vp_tp_use_pct vp_tp_pct
           desc1 name vp_comment.

   set-a:
   do on error undo, retry:

      ststatus = stline[2].
      status input ststatus.

      del-yn = no.

      set vp_tp_use_pct vp_tp_pct vp_comment
         go-on ("F5" "CTRL-D" ).

      if vp_tp_use_pct and vp_tp_pct = 0 then do:
         {pxmsg.i &MSGNUM=2832 &ERRORLEVEL=2}
         /* PURCHASE PRICE IS EQUAL TO THE SALES PRICE */
      end.

      if vp_tp_pct > 100 then do:
         {pxmsg.i &MSGNUM=2803 &ERRORLEVEL=3}
         /* VALUE CAN NOT BE GREATER THAN 100% */
         next-prompt vp_tp_pct.
         undo, retry.
      end.


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
      end.
   end.  /* set-a */

end.
