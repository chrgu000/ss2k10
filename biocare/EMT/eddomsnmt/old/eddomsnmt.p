/* eddomsnmt.p - DOMAIN ShortName MAINTENANCE                                */ 
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
   dom_domain        colon 36
   dom_name          colon 36 skip(2)
   dom_sname         colon 36
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
repeat with frame a:
   del-yn = no.
   prompt-for dom_domain editing:
      /* FIND NEXT/PREVIOUS RECORD */
     {mfnp.i dom_mstr dom_domain dom_domain dom_domain
              dom_domain dom_domain}
      if recno <> ? then do:
         display dom_domain dom_name dom_sname.
      end.
   end.

   if input dom_domain = "" then do:
      {pxmsg.i &MSGNUM=6164 &ERRORLEVEL=3}
      undo, retry.
   end.

   /* ADD/MOD/DELETE  */
  find dom_mstr where dom_domain = input dom_domain exclusive-lock no-error.

   /* Make sure only characters A-Z, a-z, and 0 - 9 */
   if not available dom_mstr then do:
/*      run validateDomainCode                    */
/*         (input (input dom_domain)).            */
      {pxmsg.i &MSGNUM=6135 &ERRORLEVEL=3}
      undo , retry.
   end.

   ststatus = stline[2].
   status input ststatus.

   update dom_sname go-on(F5 CTRL-D).

   /* disble DELETE */
   if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
   then do:
      del-yn = no.
      {pxmsg.i &MSGNUM=1021 &ERRORLEVEL=3}
   end.

   if del-yn then do:
 /*     delete bc_mstr. */
      clear frame a.
   end.
   del-yn = no.
end.

status input.
