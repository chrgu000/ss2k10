/* yyedaddpm.p - GENERAL PURPOSE CODES FILE MAINT                             */
/*V8:ConvertMode=Maintenance                                                  */

/* DISPLAY TITLE */
{mfdtitle.i "120920.1"}

define variable key1 as character initial "XXEDADDPM" no-undo.
define variable del-yn like mfc_logical initial no.
define variable desc1 like pt_desc1 no-undo.
/* Variable added to perform delete during CIM.
* Record is deleted only when the value of this variable
* Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.

/* DISPLAY SELECTION FORM */
form
   usrw_wkfl.usrw_key2 colon 25 format "x(30)" skip(1)
   usrw_wkfl.usrw_charfld[1] colon 25 format "x(48)"
   usrw_wkfl.usrw_charfld[2] colon 25 format "x(48)"
   usrw_wkfl.usrw_charfld[3] colon 25 format "x(48)"
   usrw_wkfl.usrw_charfld[4] colon 25 format "x(48)"
   usrw_wkfl.usrw_charfld[5] colon 25 format "x(48)"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:

   /* Initialize delete flag before each display of frame */
   batchdelete = "".

   prompt-for usrw_wkfl.usrw_key2
   editing:
      {mfnp05.i usrw_wkfl usrw_index1 " usrw_wkfl.usrw_domain = global_domain
      and usrw_key1 = ""XXEDADDPM"" " usrw_key2 "input usrw_key2"}
      if recno <> ? then do:
         display
            usrw_wkfl.usrw_key2
            usrw_wkfl.usrw_charfld[1]
            usrw_wkfl.usrw_charfld[2]
            usrw_wkfl.usrw_charfld[3]
            usrw_wkfl.usrw_charfld[4]
            usrw_wkfl.usrw_charfld[5].
       end.
   end. /* editing: */
   if input usrw_wkfl.usrw_key2 = "" then do:
      {mfmsg.i 4452 3}
      undo,retry.
   end.
   /* ADD/MOD/DELETE  */
     find first usrw_wkfl where usrw_wkfl.usrw_domain = global_domain and
                usrw_wkfl.usrw_key1 = key1 and
                usrw_wkfl.usrw_key2 = input usrw_key2 exclusive-lock no-error.

   if not available usrw_wkfl then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create usrw_wkfl. usrw_wkfl.usrw_domain = global_domain.
      assign usrw_key1 = key1
             usrw_key2 = input usrw_key2.
    end.
      assign usrw_wkf.usrw_charfld[1]
             usrw_wkf.usrw_charfld[2]
             usrw_wkf.usrw_charfld[3]
             usrw_wkf.usrw_charfld[4]
             usrw_wkf.usrw_charfld[5].
  /* if not available code_mstr then do: */

   ststatus = stline[2].
   status input ststatus.

   update usrw_wkf.usrw_charfld[1]
          usrw_wkf.usrw_charfld[2]
          usrw_wkf.usrw_charfld[3]
          usrw_wkf.usrw_charfld[4]
          usrw_wkf.usrw_charfld[5]
   go-on(F5 CTRL-D).

   /* Delete to be executed if batchdelete is set or
    * F5 or CTRL-D pressed */
   if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
   then do:

      del-yn = yes.

      /* Please confirm delete */
      {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}

      if del-yn then do:
         delete usrw_wkfl.
         clear frame a.
      end. /* if del-yn then do: */

   end. /* then do: */

end. /* prompt-for code_fldname */

status input.
