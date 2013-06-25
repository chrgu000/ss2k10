/* edsicmt.p - vendor pct MAINTENANCE                                        */
/* revision: 110712.1   created on: 20110712   by: zhang yun                 */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1C04  QAD:eb21sp7    Interface:Character         */
/*-Revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "110712.1"}

/* ********** Begin Translatable Strings Definitions ********* */

/*N0GD* &SCOPED-DEFINE mgbcmt_p_1 "Batch Control Detail records exist"
/* MaxLen: Comment: */  */

/* ********** End Translatable Strings Definitions ********* */

define variable del-yn like mfc_logical initial no.
/*N0GD*   define variable msgdel as character*/
/*N0GD*   initial {&mgbcmt_p_1}.*/

/* DISPLAY SELECTION FORM */
/* DISPLAY SELECTION FORM */
form
   vd_domain      colon 36
   vd_addr        colon 36
   vd_sort        colon 36 skip(2)
   vd_tp_pct      colon 36
   vd_tp_use_pct  colon 36
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
repeat with frame a:
   del-yn = no.
   prompt-for vd_mstr.vd_domain vd_mstr.vd_addr editing:
      /* FIND NEXT/PREVIOUS RECORD */
      if frame-field = "vd_domain" then do:
          {mfnp.i dom_mstr vd_domain dom_domain vd_domain
              dom_domain dom_domain}
         if recno <> ? then do:
            display dom_domain @ vd_domain.
         end.
      end.
      else do:
     {mfnp.i vd_mstr vd_addr  " vd_mstr.vd_domain = input vd_domain and
               vd_addr "  vd_addr vd_addr vd_addr}
      if recno <> ? then do:
         display vd_domain vd_addr vd_sort vd_tp_pct vd_tp_use_pct.
      end.
      end.
   end.

   if input vd_addr = "" then do:
      {pxmsg.i &MSGNUM=2 &ERRORLEVEL=3}
      undo, retry.
   end.

   /* ADD/MOD/DELETE  */
  find vd_mstr where vd_domain = input vd_domain and
       vd_addr = input vd_addr exclusive-lock no-error.

   /* Make sure only characters A-Z, a-z, and 0 - 9 */
   if not available vd_mstr then do:
/*      run validateDomainCode                    */
/*         (input (input dom_domain)).            */
      {pxmsg.i &MSGNUM=8601 &ERRORLEVEL=3}
      undo , retry.
   end.

   ststatus = stline[2].
   status input ststatus.

   update vd_tp_pct vd_tp_use_pct go-on(F5 CTRL-D).

   /* disble DELETE */
   if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
   then do:
      del-yn = no.
      {pxmsg.i &MSGNUM=1021 &ERRORLEVEL=3}
   end.

   if del-yn then do:
      delete bc_mstr.
      clear frame a.
   end.
   del-yn = no.
end.

status input.
