/* xxtricmt.p - DIVIDE_LOCATION Maintenance                                  */
/* revision: 120530.1   created on: 20120530   by: zhang yun                 */

/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1C04  QAD:eb21sp7    Interface:Character         */
/*-Revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "120530.1"}
define variable vkey1 like usrw_key1 no-undo
                  initial "DIVIDE_LOCATION".

define variable del-yn like mfc_logical initial no.
define variable fieldlen as integer initial 0 no-undo.


/* Variable added to perform delete during CIM.
* Record is deleted only when the value of this variable
* Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.

{gpfieldv.i}      /* var defs for gpfield.i */

/* DISPLAY SELECTION FORM */
form
   usrw_key1 colon 25 format "x(20)" skip(1)
   usrw_key2 colon 25 format "x(30)"
   usrw_key3 colon 25 format "x(30)"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:

   /* Initialize delete flag before each display of frame */
   batchdelete = "".
   display vkey1 @ usrw_key1.
   /* Determine length of field as defined in db schema */
   {gpfldlen.i}

   do on error undo, retry:

      /* Prompt for the delete variable in the key frame at the
       * End of the key field/s only when batchrun is set to yes */
      prompt-for
         usrw_key2
         batchdelete no-label when (batchrun)
      editing:

         {mfnp05.i usrw_wkfl
             usrw_index1
            " usrw_key1 = input usrw_key1 "
             usrw_key2
            " input usrw_key2 "}

         if recno <> ? then
            display usrw_key1 usrw_key2 usrw_key3.

      end. /* editing: */
      if not can-find(first loc_mstr no-lock where loc_site = "GSA01"
                        and loc_loc = input usrw_key2) then do:
         {pxmsg.i &MSGNUM=709 &ERRORLEVEL=4}
         undo,retry.
      end.
      if length(input usrw_key2) > fieldlen then do:

         /* Length of code value cannot be longer than definition */
         {pxmsg.i &MSGNUM=480 &ERRORLEVEL=4}
         /* MAX ALLOWABLE CHARACTERS */
         {pxmsg.i &MSGNUM=768 &ERRORLEVEL=1 &MSGARG1=fieldlen}

         /* IN BATCHRUN SKIP RECORDS, IF LENGTH OF VALUE IS     */
         /* GREATER THAN FIELD WIDTH                            */
         if batchrun then do:
            import ^.
            next mainloop.
         end. /* if batchrun then do: */
         else
            next-prompt usrw_key2 with frame a.
         undo, retry.

      end. /* if length(input usrw_key2) > fieldlen then do: */

   end. /* do on error undo, retry: */

   /* ADD/MOD/DELETE  */

   find usrw_wkfl where usrw_key1 = input usrw_key1 and
                        usrw_key2 = input usrw_key2 no-error.

   if not available usrw_wkfl then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create usrw_wkfl.
      assign
         usrw_key1 usrw_key2.
   end. /* if not available usrw_wkfl then do: */

   ststatus = stline[2].
   status input ststatus.

   update
      usrw_key3
   go-on(F5 CTRL-D).

   /* Delete to be executed if batchdelete is set or
    * F5 or CTRL-D pressed */
   if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
      or input batchdelete = "x"
   then do:

      del-yn = yes.

      /* Please confirm delete */
      {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}

      if del-yn then do:
         delete usrw_wkfl.
         clear frame a.
      end. /* if del-yn then do: */

   end. /* then do: */

end. /* prompt-for usrw_key1 */

status input.
