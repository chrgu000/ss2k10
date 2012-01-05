/* xxcxysmt.p - GENERAL PURPOSE CODES FILE MAINT                              */
/*V8:ConvertMode=Maintenance                                                  */

/* DISPLAY TITLE */
{mfdtitle.i "111201.1"}

define variable key1 as character initial "SSGZTS-CX" no-undo.
define variable del-yn like mfc_logical initial no.
define variable desc1 like pt_desc1 no-undo.
/* Variable added to perform delete during CIM.
* Record is deleted only when the value of this variable
* Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.

{gpfieldv.i}      /* var defs for gpfield.i */

/* DISPLAY SELECTION FORM */
form
   usrw_wkfl.usrw_key3 colon 25
   usrw_wkfl.usrw_key4 colon 25 format "x(16)"
   usrw_wkfl.usrw_charfld[1] colon 25 format "x(48)"
   skip(1)
   usrw_wkfl.usrw_intfld[1] colon 25 format "->>9"
   usrw_wkfl.usrw_key5 colon 25 format "x(18)" skip
   desc1 no-label colon 25 skip(1)
   usrw_wkfl.usrw_key6 colon 25
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:

   /* Initialize delete flag before each display of frame */
   batchdelete = "".
/*
   if input usrw_wkfl.usrw_key3 <> "" and input usrw_wkfl.usrw_key4 <> "" then
      find usrw_wkfl  where usrw_wkfl.usrw_domain = global_domain and
      usrw_wkfl.usrw_key1 = key1
      and usrw_wkfl.usrw_key2 = (input usrw_key4 + "-" + INPUT usrw_key5)
   no-lock no-error.
   if available usrw_wkfl then
      recno = recid(usrw_wkfl).
*/
   prompt-for usrw_wkfl.usrw_key3
              usrw_wkfl.usrw_key4
              usrw_wkfl.usrw_charfld[1]
   editing:
      {mfnp05.i usrw_wkfl usrw_index1 " usrw_wkfl.usrw_domain = global_domain
      and usrw_key1 = ""SSGZTS-CX"" " usrw_key2 "input usrw_key4"}
      if recno <> ? then do:
         assign desc1 = "".
         find first pt_mstr no-lock where pt_domain = global_domain
                and pt_part = usrw_key5 no-error.
         if available pt_mstr then do:
            assign desc1 = pt_desc1.
         end.
         display
            usrw_wkf.usrw_key3
            usrw_wkf.usrw_key4
            usrw_wkf.usrw_key5
            desc1
            usrw_wkf.usrw_key6
            usrw_wkfl.usrw_intfld[1]
            usrw_wkf.usrw_charfld[1].
       end.
   end. /* editing: */
   if input usrw_key3 = "" then do:
      assign desc1 = "[" + trim(getTermLabel("PLAN_DEPARTMENT",12)) + "]".
      {pxmsg.i &MSGNUM=4452 &MSGARG1=desc1 &ERRORLEVEL=3}
      undo,retry.
   end.
   if input usrw_key4 = "" then do:
      assign desc1 = "[" + trim(getTermLabel("MODELE",12)) + "]".
      {pxmsg.i &MSGNUM=4452 &MSGARG1=desc1 &ERRORLEVEL=3}
      undo,retry.
   end.
   do on error undo, retry:

      /* Prompt for the delete variable in the key frame at the
       * End of the key field/s only when batchrun is set to yes */
      prompt-for
         usrw_wkfl.usrw_intfld[1] 
         usrw_wkf.usrw_key5
      editing:

    {mfnp05.i usrw_wkfl usrw_index2 " usrw_wkfl.usrw_domain = global_domain
      and usrw_key1 = ""SSGZTS-CX"" and usrw_key3 = input usrw_key3
      and usrw_key4 = input usrw_key4 " usrw_key5 "input usrw_key5"}

         if recno <> ? then do:
            assign desc1 = "".
            find first pt_mstr no-lock where pt_domain = global_domain
                    and pt_part = input usrw_wkfl.usrw_key5 no-error.
            if available pt_mstr then do:
                assign desc1 = pt_desc1.
            end.
            display usrw_wkf.usrw_key3
                    usrw_wkf.usrw_key4
                    usrw_wkf.usrw_key5
                    desc1
                    usrw_wkf.usrw_key6
                    usrw_wkfl.usrw_intfld[1]
                    usrw_wkf.usrw_charfld[1].
          end.
      end. /* editing: */
      if input usrw_key5 = "" then do:
         {mfmsg.i 7127 3}
         undo,retry.
      end.
      find first pt_mstr no-lock where pt_domain = global_domain
             and pt_part = input usrw_key5 no-error.
      if not available pt_mstr then do:
         {mfmsg.i 16 3}
         undo,retry.
      end.

      if can-find(first usrw_wkfl where
                        usrw_wkfl.usrw_domain = global_domain and
                        usrw_wkfl.usrw_key1 = "SSGZTS-CX" and
                        usrw_wkfl.usrw_key3 = input usrw_key3 and
                        usrw_wkfl.usrw_key4 = input usrw_key4 and
                        usrw_wkfl.usrw_key5 <> input usrw_key5 and
                        usrw_wkfl.usrw_intfld[1] = input usrw_intfld[1])
      then do:
         {mfmsg.i 7482 3}
         undo,retry.
      end.
    end. /* do on error undo, retry: */
   /* ADD/MOD/DELETE  */
     find usrw_wkfl  where usrw_wkfl.usrw_domain = global_domain and
      usrw_wkfl.usrw_key1 = key1
      and usrw_wkfl.usrw_key2 = (input usrw_wkfl.usrw_key4 + "-" +
                                       INPUT usrw_wkfl.usrw_key5)
      no-error.

   if not available usrw_wkfl then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create usrw_wkfl. usrw_wkfl.usrw_domain = global_domain.
      assign usrw_key1 = key1
             usrw_key2 = input usrw_wkfl.usrw_key4 + "-" +
                        INPUT usrw_wkfl.usrw_key5.
    end.
      assign usrw_wkf.usrw_key3
             usrw_wkf.usrw_key4
             usrw_wkf.usrw_key5
             usrw_wkfl.usrw_intfld[1]
             usrw_wkf.usrw_charfld[1].
  /* if not available code_mstr then do: */

   ststatus = stline[2].
   status input ststatus.

   update
      usrw_wkf.usrw_key6
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
