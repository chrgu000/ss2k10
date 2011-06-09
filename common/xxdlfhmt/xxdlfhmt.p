/* xxdlfhmt.p - Drill Down/Lookup Maintenance Program                        */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 16Y9 LAST MODIFIED: 06/09/11 BY: zy                             */
/* REVISION END                                                              */

/* STANDARD INCLUDE FILES */
{mfdtitle.i "16Y9"}
{pxmaint.i}

/* DEFINE HANDLES FOR PROGRAMS */
{pxphdef.i mgdlxr}
{pxphdef.i mgfhxr}
{pxphdef.i mglbxr}
{pxphdef.i mgbwxr}

/* LOCAL VARIABLES */
define variable l_drl_lookup       like mfc_logical    no-undo
   label "Drill Down/Lookup" format "Drill Down/Lookup".
define variable fieldname          like drl_field      no-undo
   label "Field Name".
define variable call_pgm           like flh_call_pgm  no-undo format "x(14)".
define variable exec               like drl_exec      no-undo.
define variable l_createConfirm    like mfc_logical   no-undo.
define variable l_label            as   character     no-undo format "x(45)".
define variable l_del-yn           like mfc_logical   no-undo.
define variable pBrowseName        as   character     no-undo.

/* FORM DEFINITIONS */
form
   l_drl_lookup   colon 30
   fieldname      colon 30
   call_pgm       colon 30
   skip(1)
   exec           colon 30
   with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   drl_desc      colon 30 label "Description Term"
   l_label       colon 31 no-label
   flh_desc      colon 30
   flh_y         colon 30
   flh_down      colon 30
   with frame b side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

mainloop:
repeat:
   assign
      l_del-yn        = false
      l_createConfirm = false
      pBrowseName     = "".

   view frame a.
   view frame b.

   display
      l_drl_lookup
      with frame a.

   set
      l_drl_lookup
      fieldname
      call_pgm
      with frame a
   editing:

      /* SCROLLING LOGIC FOR DRILL DOWN */
      if input l_drl_lookup = true
      then do:
         {mfnp06.i drl_mstr drl_field "true"
            drl_field "input fieldname" drl_field "input fieldname"}

         if recno <> ?
         then do:
            assign
               fieldname   = drl_field
               call_pgm    = drl_call_pgm
               exec        = drl_exec

            l_label = getTermLabel(drl_desc, 45).

            display
               fieldname
               call_pgm
               exec
               with frame a.

            display
               drl_desc
               l_label
               ""          @ flh_desc
               ""          @ flh_y
               ""          @ flh_down
               with frame b.
         end.
      end. /* IF INPUT l_drl_lookup = true */
      else

         /* SCROLLING LOGIC FOR WINDOW HELP */
         if input l_drl_lookup = false
         then do:
            {mfnp06.i flh_mstr flh_field "true"
               flh_field "input fieldname" flh_field "input fieldname"}

            if recno <> ?
            then do:
               assign
                  fieldname   = flh_field
                  call_pgm    = flh_call_pgm
                  exec        = flh_exec
                  l_label     = ''.

               display
                  fieldname
                  call_pgm
                  exec
                  with frame a.

               display
                  ""          @ drl_desc
                  l_label
                  flh_desc
                  flh_y
                  flh_down
               with frame b.
            end.
         end. /* IF INPUT l_drl_lookup  = false */
         else do:
           readkey.
           apply lastkey.
         end.

   end. /* EDITING */

   if l_drl_lookup = false
   then do:
      {pxrun.i &PROC='validateFieldNameForBlank' &PROGRAM='mgfhxr.p'
               &HANDLE=ph_mgfhxr
               &PARAM="(input fieldname)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT}
      then do:
         next-prompt
            fieldname
            with frame a.
         undo mainloop, retry mainloop.
      end.

      {pxrun.i &PROC='processRead' &PROGRAM='mgfhxr.p'
               &HANDLE=ph_mgfhxr
               &PARAM="(input fieldname,
                        input call_pgm,
                        buffer flh_mstr,
                        input {&LOCK_FLAG},
                        input {&WAIT_FLAG})"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if return-value = {&RECORD-NOT-FOUND}
      then do:
         {pxrun.i &PROC='processCreate' &PROGRAM='mgfhxr.p'
                  &HANDLE=ph_mgfhxr
                  &PARAM="(input fieldname,
                           input call_pgm,
                           buffer flh_mstr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         {pxmsg.i
            &MSGNUM=1
            &ERRORLEVEL={&INFORMATION-RESULT}}

         {pxrun.i &PROC='defaultFieldHelpDetails' &PROGRAM='mgfhxr.p'
                  &HANDLE=ph_mgfhxr
                  &PARAM="(input fieldname,
                           output flh_desc,
                           output flh_y,
                           output flh_down)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         exec = "".
      end.
      else do:
         {pxrun.i &PROC='getProcToExecute' &PROGRAM='mgfhxr.p'
                  &HANDLE=ph_mgfhxr
                  &PARAM="(input fieldname,
                           input call_pgm,
                           output exec)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}
      end.

      l_label = ''.

      display
         ""         @ drl_desc
         l_label
         flh_desc
         flh_y
         flh_down
         with frame b.
   end. /* IF l_drl_lookup = false */

   display
      exec
      with frame a.

   seta:
   do on error undo seta, retry seta:

      set
         exec
         with frame a.

      if l_drl_lookup = false
      then do:
         {pxrun.i &PROC='validateProcedureToExecuteForBlank' &PROGRAM='mgfhxr.p'
                  &HANDLE=ph_mgfhxr
                  &PARAM="(input exec)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if return-value <> {&SUCCESS-RESULT}
         then do:
            next-prompt
               exec
               with frame a.
            undo seta, retry seta.
         end.
      end. /* IF l_drl_lookup = false */

   end. /* SETA */
   if l_drl_lookup = false
   then do:
      {pxrun.i &PROC='setModificationInfo' &PROGRAM='mgfhxr.p'
               &HANDLE=ph_mgfhxr
               &PARAM="(buffer flh_mstr)"
               &NOAPPERROR=true
               &CATCHERROR=true}
   end.

   if l_drl_lookup = true
   then do:
      {pxrun.i &PROC='processRead' &PROGRAM='mgdlxr.p'
               &HANDLE=ph_mgdlxr
               &PARAM="(input fieldname,
                        input call_pgm,
                        input exec,
                        buffer drl_mstr,
                        input {&LOCK_FLAG},
                        input {&WAIT_FLAG})"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if return-value = {&RECORD-NOT-FOUND}
      then do:
         {pxrun.i &PROC='processCreate' &PROGRAM='mgdlxr.p'
                  &HANDLE=ph_mgdlxr
                  &PARAM="(input fieldname,
                           input call_pgm,
                           input exec,
                           buffer drl_mstr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         /* Default the drill down description to be the same as the browse
            description */
         assign
            pBrowseName = substring(drl_exec,1,index(drl_exec,".p") - 1)
            pBrowseName = right-trim(substring(pBrowseName,1,2)
                        + substring(pBrowseName,5,4)).

         {pxrun.i &PROC='processRead' &PROGRAM='mgbwxr.p'
                  &HANDLE=ph_mgbwxr
                  &PARAM="(input pBrowseName,
                           buffer brw_mstr,
                           input {&NO_LOCK_FLAG},
                           input {&NO_WAIT_FLAG})"
                  &NOAPPERROR=true
                  &CATCHERROR=true}
         if return-value = {&SUCCESS-RESULT}
         then
            drl_desc = brw_desc.

         {pxmsg.i
            &MSGNUM=1
            &ERRORLEVEL={&INFORMATION-RESULT}}
      end.

      l_label = getTermLabel(drl_desc, 45).

      display
         drl_desc
         l_label
         ""          @ flh_desc
         ""          @ flh_y
         ""          @ flh_down
         with frame b.
   end. /* IF l_drl_lookup = true */

   if {gpiswrap.i} then do:
      ststatus = stline[2].
   end.
   else if l_drl_lookup = true
   then do:
      /*V8-*/
      if not {gpiswrap.i} then
      do:
         {pxmsg.i &MSGNUM=4908 &ERRORLEVEL=1 &MSGBUFFER=ststatus}
      end.
      /* If under DTUI, then show a DT friendly status bar to enable DELETE */
      else do:
         {pxmsg.i &MSGNUM=8802 &ERRORLEVEL=1 &MSGBUFFER=ststatus}
      end.
      /*V8+*/

      /*V8!
      {pxmsg.i &MSGNUM=4909 &ERRORLEVEL=1 &MSGBUFFER=ststatus}
      */
   end.
   else do:
      ststatus = stline[2].
   end.

   status input ststatus.


   setb:
   do on error undo setb, retry setb:

      set
         drl_desc    when (l_drl_lookup = true)
         flh_desc    when (l_drl_lookup = false)
         flh_y       when (l_drl_lookup = false)
         flh_down    when (l_drl_lookup = false)
         with frame b
      editing:

         if l_drl_lookup = true and frame-field = "drl_desc"
         then do:

            {mfnp09.i lbl_mstr drl_desc lbl_long
               global_user_lang lbl_lang lbl_long}


            if recno <> ?
            then do:
               drl_desc = lbl_term.

               l_label = getTermLabel(drl_desc, 45).

               display
                  drl_desc
                  l_label
                  with frame b.
            end.

         end. /* IF l_drl_lookup = true AND FRAME-FIELD = "drl_desc" */
         else do:
            readkey.
            apply lastkey.
         end.

         if
            /*V8-*/
            keyfunction(lastkey) = "get"
            /*V8+*/
            /*V8!
            keyfunction(lastkey) = "delete-character" */
            or lastkey = keycode("F5")
            or lastkey = keycode("CTRL-D")
         then do:
            l_del-yn = true.

            /* MESSAGE #11 - PLEASE CONFIRM DELETE */
            {pxmsg.i &MSGNUM     = 11
                     &ERRORLEVEL = {&INFORMATION-RESULT}
                     &CONFIRM    = l_del-yn}

            if l_del-yn then
               leave.
            else
               undo setb, retry setb.
         end.
      end. /* EDITING */

      if l_del-yn
      then do:
         if l_drl_lookup = true then do:
            {pxrun.i &PROC='processDelete' &PROGRAM='mgdlxr.p'
                     &HANDLE=ph_mgdlxr
                     &PARAM="(buffer drl_mstr)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}

            exec = "".
         end.
         else do:
            {pxrun.i &PROC='processDelete' &PROGRAM='mgfhxr.p'
                     &HANDLE=ph_mgfhxr
                     &PARAM="(buffer flh_mstr)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}
         end.

         clear frame a.
         clear frame b.

         next mainloop.
      end. /* IF l_del-yn */

      if l_drl_lookup = false
      then do:

         {pxrun.i &PROC='validateWindowRow' &PROGRAM='mgfhxr.p'
                  &HANDLE=ph_mgfhxr
                  &PARAM="(input flh_y)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if return-value <> {&SUCCESS-RESULT}
         then do:
            next-prompt
               flh_y
               with frame b.
            undo setb, retry setb.
         end.

         {pxrun.i &PROC='validateWindowLines' &PROGRAM='mgfhxr.p'
                  &HANDLE=ph_mgfhxr
                  &PARAM="(input flh_y,
                           input flh_down)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if return-value <> {&SUCCESS-RESULT}
         then do:
            next-prompt
               flh_down
               with frame b.
            undo setb, retry setb.
         end.

         {pxrun.i &PROC='updateProcToExecute' &PROGRAM='mgfhxr.p'
                  &HANDLE=ph_mgfhxr
                  &PARAM="(input exec,
                           buffer flh_mstr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}
      end. /* IF l_drl_lookup = false */
      else do:

         {pxrun.i &PROC='updateLabelTerm' &PROGRAM='mglbxr.p'
                  &HANDLE=ph_mglbxr
                  &PARAM="(input-output drl_desc)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         display
            drl_desc
            with frame b.

         {pxrun.i &PROC='validateTermForExistence' &PROGRAM='mglbxr.p'
                  &HANDLE=ph_mglbxr
                  &PARAM="(input drl_desc,
                           output l_createConfirm)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if return-value <> {&SUCCESS-RESULT}
         then do:

            if not l_createConfirm
            then do:
               next-prompt
                  drl_desc
                  with frame b.
               undo setb, retry setb.
            end.
            else do:
               {pxrun.i &PROC='validateTerm' &PROGRAM='mglbxr.p'
                        &HANDLE=ph_mglbxr
                        &PARAM="(input drl_desc)"
                        &NOAPPERROR=true
                        &CATCHERROR=true}

               if return-value <> {&SUCCESS-RESULT}
               then do:
                  next-prompt
                     drl_desc
                     with frame b.
                  undo setb, retry setb.
               end.

               hide frame b.

               {gprun.i ""mglbmt1.p""
                  "(input global_user_lang,
                    input drl_desc)"}

               {pxrun.i &PROC='processRead' &PROGRAM='mglbxr.p'
                        &HANDLE=ph_mglbxr
                        &PARAM="(input global_user_lang,
                                 input drl_desc,
                                 buffer lbl_mstr,
                                 input {&NO_LOCK_FLAG},
                                 input {&NO_WAIT_FLAG})"
                        &NOAPPERROR=true
                        &CATCHERROR=true}

               if return-value = {&RECORD-NOT-FOUND}
               then do:
                  next-prompt
                     drl_desc
                     with frame b.
                  undo setb, retry setb.
               end.

               view frame a.
               view frame b.

               l_label = getTermLabel(drl_desc, 45).

               display
                  l_label
                  with frame b.
            end.
         end.  /* IF RETURN-VALUE <> {&SUCCESS-RESULT} */
      end. /* ELSE */

   end. /* SETB */

   if l_drl_lookup = true
   then do:
      {pxrun.i &PROC='setModificationInfo' &PROGRAM='mgdlxr.p'
               &HANDLE=ph_mgdlxr
               &PARAM="(buffer drl_mstr)"
               &NOAPPERROR=true
               &CATCHERROR=true}
   end.

end. /* MAINLOOP */
