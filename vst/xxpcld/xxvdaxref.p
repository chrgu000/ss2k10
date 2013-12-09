/* xxvdaxref.p - AX Verder and QAD Verder reference                          */
/* revision: 131029.1   created on: 20131029   by: zhang yun                 */
/*V8:ConvertMode=Maintenance                                                 */
/*-Revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "131029.1"}
define variable vkey1 like usrw_key1 no-undo initial "AX_QAD_VENDOR_REFERENCE".
define variable del-yn like mfc_logical initial no.
define variable vadsort like ad_sort.
define variable fieldlen as integer initial 0 no-undo.


/* Variable added to perform delete during CIM.
* Record is deleted only when the value of this variable
* Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.

{gpfieldv.i}      /* var defs for gpfield.i */

/* DISPLAY SELECTION FORM */
form
   usrw_key1 colon 25 format "x(24)" skip(1)
   usrw_key2 colon 25 format "x(12)"
   usrw_key3 colon 25 format "x(8)"
   vadsort colon 25 no-label skip(2)
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
         {mfnp05.i usrw_wkfl usrw_index1  " usrw_key1 = vkey1 "
                   usrw_key2  " input usrw_key2 "}
         if recno <> ? then do:
            find first vd_mstr no-lock where vd_addr = usrw_key3 no-error.
              if available vd_mstr then do:
                 assign vadsort = vd_sort.
              end.
            display usrw_key1 usrw_key2 usrw_key3 vadsort.
         end.

      end. /* editing: */

   end. /* do on error undo, retry: */
   if input usrw_key2 = "" then do:
      {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
      undo,retry.
   end.
   /* ADD/MOD/DELETE  */
   find usrw_wkfl where usrw_key1 = vkey1 and
                        usrw_key2 = input usrw_key2 no-error.

   if not available usrw_wkfl then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create usrw_wkfl.
      assign usrw_key1 = vkey1
             usrw_key2.
   end. /* if not available usrw_wkfl then do: */

   ststatus = stline[2].
   status input ststatus.

  repeat with frame a:
     update usrw_key3 go-on(F5 CTRL-D).
          if usrw_key3 = "" then do:
             {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
             undo,retry.
          end.
          assign vadsort = "".
          find first vd_mstr no-lock where vd_addr = input usrw_key3 no-error.
          if available vd_mstr then do:
             assign vadsort = vd_sort.
          end.
          else do:
              {pxmsg.i &MSGNUM=2 &ERRORLEVEL=3}
              undo,retry.
          end.
          display usrw_key3 vadsort with frame a.
          leave.
  end.
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