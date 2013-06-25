/* edsicmt.p - customer sic MAINTENANCE                                      */
/* revision: 110712.1   created on: 20110712   by: zhang yun                 */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1C04  QAD:eb21sp7    Interface:Character         */
/*-Revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "110712.1"}

define variable del-yn like mfc_logical initial no.

/* DISPLAY SELECTION FORM */

form
   cm_domain      colon 36
   cm_addr        colon 36
   cm_sort        colon 36 skip(2)
   cm_sic         colon 36 format "x(8)"
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
repeat with frame a:
   del-yn = no.
   prompt-for cm_mstr.cm_domain cm_mstr.cm_addr editing:
      /* FIND NEXT/PREVIOUS RECORD */
      if frame-field = "cm_domain" then do:
          {mfnp.i dom_mstr cm_domain dom_domain cm_domain
              dom_domain dom_domain}
         if recno <> ? then do:
            display dom_domain @ cm_domain.
         end.
      end.
      else do:
     {mfnp.i cm_mstr cm_addr  " cm_mstr.cm_domain = input cm_domain and
               cm_addr " cm_addr cm_addr cm_addr}
      if recno <> ? then do:
         display cm_domain cm_addr cm_sort cm_sic.
      end.
      end.
   end.

   if input cm_addr = "" then do:
      {pxmsg.i &MSGNUM=3 &ERRORLEVEL=3}
      undo, retry.
   end.

   /* ADD/MOD/DELETE  */
  find cm_mstr where cm_domain = input cm_domain and
       cm_addr = input cm_addr exclusive-lock no-error.
 
   if not available cm_mstr then do: 
      {pxmsg.i &MSGNUM=8601 &ERRORLEVEL=3}
      undo , retry.
   end.

   ststatus = stline[2].
   status input ststatus.

   update cm_sic go-on(F5 CTRL-D).

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
