/* xxlgvdmt.p - logistics vendor maintenance                                 */
/* revision: 120714.1   created on: 20120614   by: zhang yun                 */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1C04  QAD:eb21sp7    Interface:Character         */
/*-Revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "120714.1"}
{xxusrwkey1202.i}
define variable del-yn like mfc_logical initial no.
define variable fieldlen as integer initial 0 no-undo.
define variable v_lgvddesc as character format "x(16)".
define variable v_sptodesc as character format "x(16)".
define variable errorst as logical.
define variable errornum as integer.
/* Variable added to perform delete during CIM.
* Record is deleted only when the value of this variable
* Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.
{gpfieldv.i}      /* var defs for gpfield.i */

/* DISPLAY SELECTION FORM */
form
  /* qad_key1 colon 25 format "x(20)" skip(1) */
   qad_key3 colon 25 format "x(18)" v_lgvddesc no-label
   qad_key4 colon 25 format "x(18)" v_sptodesc no-label skip(1)
   qad_decfld[1] colon 25
   qad_decfld[2] colon 25
   qad_decfld[3] colon 25
   qad_decfld[4] colon 25
   qad_decfld[5] colon 25
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:

   /* Initialize delete flag before each display of frame */
   batchdelete = "".
/*   display vdefcstkey @ qad_key1. */
   /* Determine length of field as defined in db schema */
   {gpfldlen.i}

   do on error undo, retry:

      /* Prompt for the delete variable in the key frame at the
       * End of the key field/s only when batchrun is set to yes */
      prompt-for
         qad_key3 qad_key4
         batchdelete no-label when (batchrun)
      editing:
      if frame-field = "qad_key3" then do:
      {mfnp05.i qad_wkfl qad_index1 " {xxqaddom.i} {xxand.i}
                qad_key1 = vdefcstkey " qad_key3 " input qad_key3 "}

         if recno <> ? then do:
            display qad_key3 qad_key4 qad_decfld[1] qad_decfld[2] 
            						      qad_decfld[3] qad_decfld[4] qad_decfld[5].
            find first usrw_wkfl no-lock where {xxusrwdom.i} {xxand.i}
   				       usrw_key1 = vlgvdkey and usrw_key2 = input qad_key3 no-error.
            if available usrw_wkfl then do:
            		display usrw_key3 @ v_lgvddesc with frame a.
            end.
            find first usrw_wkfl no-lock where {xxusrwdom.i} {xxand.i}
   				       usrw_key1 = vsptokey and usrw_key2 = input qad_key4 no-error.
            if available usrw_wkfl then do:
            		display usrw_key3 @ v_sptodesc with frame a.
            end.
         end.
       end.
       else if frame-field = "qad_key4" then do:
       {mfnp05.i qad_wkfl qad_index1 " {xxqaddom.i} {xxand.i}
                 qad_key1 = vdefcstkey and qad_key3 = input qad_key3 " 
                 qad_key4 
                 " input qad_key4 "}
         if recno <> ? then do:
            display qad_key4 qad_decfld[1] qad_decfld[2] 
            						      qad_decfld[3] qad_decfld[4] qad_decfld[5].
            find first usrw_wkfl no-lock where {xxusrwdom.i} {xxand.i}
   				       usrw_key1 = vsptokey and usrw_key2 = input qad_key4 no-error.
            if available usrw_wkfl then do:
            		display usrw_key3 @ v_sptodesc with frame a.
            end.
         end.
       end.
       else do:
            status input.
            readkey.
            apply lastkey.
       end. /* else do: */
      end. /* editing: */

   end. /* do on error undo, retry: */
   
   if input qad_key3 = "" then do:
   		{mfmsg.i 40 3}
   		next-prompt qad_key3.
   		undo,retry.
   end.
   if input qad_key4 = "" then do:
   		{mfmsg.i 40 3}
   		next-prompt qad_key4.
   		undo,retry.
   end.
   find first usrw_wkfl no-lock where {xxusrwdom.i} {xxand.i}
   				    usrw_key1 = vlgvdkey and usrw_key2 = input qad_key3 no-error.
   if available usrw_wkfl then do:
   		display usrw_key3 @ v_lgvddesc with frame a.
   end.
   else do:
   		{mfmsg.i 99800 3}
   		next-prompt qad_key3.
   		undo,retry.
   end.
   find first usrw_wkfl no-lock where {xxusrwdom.i} {xxand.i}
   				    usrw_key1 = vsptokey and usrw_key2 = input qad_key4 no-error.
   if available usrw_wkfl then do:
   		display usrw_key3 @ v_sptodesc with frame a.
   end.
   else do:
   		{mfmsg.i 99801 3}
   		next-prompt qad_key4.
   		undo,retry.
   end.
   
   /* ADD/MOD/DELETE  */

   find first qad_wkfl where {xxqaddom.i} {xxand.i} qad_key1 = vdefcstkey and
   						qad_key2 = input qad_key3 + "-" + input qad_key4 and
              qad_key3 = input qad_key3 and
              qad_key4 = input qad_key4 no-error.

   if not available qad_wkfl then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create qad_wkfl. {xxqaddom.i}.
      assign qad_key1 = vdefcstkey
             qad_key2 = input qad_key3 + "-" + input qad_key4.
   end. /* if not available qad_wkfl then do: */
	 assign qad_key3 qad_key4 .
   ststatus = stline[2].
   status input ststatus.

   update qad_decfld[1] qad_decfld[2] 
          qad_decfld[3] qad_decfld[4] qad_decfld[5] go-on(F5 CTRL-D).

   /* Delete to be executed if batchdelete is set or
    * F5 or CTRL-D pressed */
   if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
      or input batchdelete = "x"
   then do:

      del-yn = yes.

      /* Please confirm delete */
      {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}

      if del-yn then do:
         delete qad_wkfl.
         clear frame a.
      end. /* if del-yn then do: */

   end. /* then do: */

end. /* prompt-for qad_key1 */

status input.
