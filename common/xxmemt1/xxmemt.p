/* xxmemt.p - MENU MAINTENANCE with cim delete                                */
/*V8:ConvertMode=Maintenance                                                  */
/* $Revision: 1.5.2.8.3.2 $   BY: Meng Ge   DATE: 07/03/07       ECO: *Q178*  */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "23YO"}
{cxcustom.i "MGMEMT.P"}

define variable del-yn like mfc_logical initial no.
define variable newrec like mfc_logical.

define buffer mnddet for mnd_det.
define variable mndnbr like mnd_nbr.
define variable mntLabel      like mnt_det.mnt_label no-undo.
define variable execProcedure like mnd_det.mnd_uri no-undo.

/* Variable added to perform delete during CIM.
* Record is deleted only when the value of this variable
* Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.
{&MGMEMT-P-TAG1}

form
   lng_lang          colon 15
   /*V8-*/   lng_desc          at 35 no-label /*V8+*/
   /*V8!     lng_desc          at 40 no-label view-as fill-in size 35 by 1 */
   mnd_det.mnd_nbr           colon 15
   /*V8-*/   mntLabel         at 35 no-label format "x(40)" /*V8+*/
   /*V8!     mntLabel         at 40 no-label format "x(40)"
   view-as fill-in size 35 by 1 */
   skip(1)
   mnd_det.mnd_select   colon 15
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   mnt_det.mnt_label  colon 15  label "Label"
   mnd_det.mnd_name   colon 15
   execProcedure      colon 15 view-as fill-in size 60 by 1 label "Exec Procedure"
   mnd_help           colon 15
with frame b side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

{&MGMEMT-P-TAG2}

display
   global_user_lang @ lng_lang
with frame a.

repeat:
   batchdelete = "".
   view frame a.
   view frame b.

   prompt-for lng_lang with frame a
   editing:
      {mfnp05.i lng_mstr lng_lang yes lng_lang "input lng_lang"}
      if recno <> ? then do:
         display lng_lang lng_desc with frame a.
      end.
   end.

   find lng_mstr using lng_lang no-lock.

   display
      lng_lang
      lng_desc
   with frame a.

   repeat:

      if mndnbr <> "" then
         find first mnd_det where mnd_exec = mndnbr no-lock no-error.

      prompt-for mnd_nbr with frame a
      editing:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp05.i mnd_det mnd_exec yes mnd_exec "input mnd_nbr"}

         if recno <> ? then do:
            display mnd_exec @ mnd_nbr with frame a.

            find mnt_det where mnt_nbr = mnd_nbr and mnt_select = mnd_select
               and mnt_lang = lng_lang no-lock no-error.

            if available mnt_det then do:
               mntLabel = mnt_label.
               display mntLabel with frame a.
            end.
            else
               display "" @ mntLabel with frame a.
         end.
      end.

      mndnbr = input mnd_nbr.

      find first mnd_det where mnd_exec = mndnbr no-lock no-error.
      if available mnd_det then do:

         find mnt_det where mnt_nbr = mnd_nbr and
                            mnt_select = mnd_select
                        and mnt_lang = lng_lang
         no-lock no-error.
         if available mnt_det then do:
            mntLabel = mnt_label.
            display mntLabel with frame a.
         end.
         else
            display "" @ mntLabel with frame a.
      end.

      else
         display "" @ mntLabel with frame a.

      ststatus = stline[2].
      status input ststatus.

      del-yn = no.

      prompt-for mnd_select 
                 batchdelete no-label when (batchrun)
      with frame a
         editing:

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i mnd_det mnd_nbr
               "mnd_nbr = mndnbr" mnd_select "input mnd_select"}

            if recno <> ? then do:
               display
                  mnd_select
               with frame a.

               if mnd_uri <> "" and mnd_exec = "" then
                  execProcedure = mnd_uri.
               else
                  execProcedure = mnd_exec.

               find mnt_det where mnt_nbr = mndnbr
                  and mnt_select = input mnd_select
                  and mnt_lang = lng_lang no-lock no-error.

               do with frame b:
                  display
                     mnd_name
                     execProcedure
                     mnd_help
                  with frame b.

                  if available mnt_det then
                     display mnt_label.
                  else
                     display "" @ mnt_label.
               end. /* do with frame b */
            end.
         end.

         /* ADD/MOD/DELETE  */
         find mnd_det where mnd_nbr = mndnbr and
                            mnd_select = input mnd_select
         no-error.
         newrec = no.
         if not available mnd_det then do:
            create mnd_det.
            assign
               mnd_nbr    = mndnbr
               mnd_select = input mnd_select.

            assign
               execProcedure = "".

            {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
            newrec = yes.
         end.
         /* Set the Executable to either the .p or the Activity */
         else do:
            if mnd_uri <> "" and mnd_exec = "" then
               execProcedure = mnd_uri.
            else
               execProcedure = mnd_exec.
         end.

         recno = recid(mnd_det).
         del-yn = no.

         ststatus = stline[2].
         status input ststatus.

         display
            mnd_det.mnd_name
            execProcedure
            mnd_help
         with frame b.

         find mnt_det where mnt_nbr = mndnbr and
                            mnt_select = input mnd_select
                        and mnt_lang = lng_lang
         no-lock no-error.

         if available mnt_det then
            display mnt_label with frame b.
         else
            display "" @ mnt_label with frame b.

         /* Get additional data */
         do with frame b on error undo, retry:

            prompt-for
               mnt_label
               mnd_det.mnd_name
               execProcedure
               mnd_help 
            go-on(F5 CTRL-D).

            if index(input mnt_label,",") > 0 then do:
               /* Commas are not allowed in Menu Labels */
               {pxmsg.i &MSGNUM=1773 &ERRORLEVEL=3}
               next-prompt mnt_label.
               undo, retry.
            end.

            if newrec and can-find(mnd_det using mnd_name) then do:
               {pxmsg.i &MSGNUM=60 &ERRORLEVEL=3}
               next-prompt mnd_name.
               undo, retry.
            end.

            /* DELETE */
            if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") or 
               input batchdelete = "x"
            then do:
               del-yn = yes.
               /* Please confirm delete */
               {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
               if del-yn then do:
                  for each mnt_det
                     where mnt_nbr = mnd_nbr
                       and mnt_select = mnd_select
                  exclusive-lock:
                     delete mnt_det.
                  end.
                  delete mnd_det.
                  clear frame b.
                  del-yn = no.
                  next.
               end.
            end.

            {&MGMEMT-P-TAG5}
            assign
               mnd_name = input mnd_name
               mnd_help = input mnd_help
               execProcedure.

            /* URN - assign mnd_exec and mnd_uri */
            if execProcedure begins "urn:" then do:
               assign
                  mnd_uri = execProcedure
                  mnd_exec = "".
            end.
            /* MFG/PRO Functions */
            else if index(execProcedure,".p") > 0 or
                 index(execProcedure,".w") > 0
            then do:
               assign
                  mnd_uri = ""
                  mnd_exec = execProcedure.
            end.
            /* Sub-Menus */
            else do:
               assign
                  mnd_uri = ""
                  mnd_exec = execProcedure.
            end.

            find mnt_det where mnt_nbr = mnd_nbr
                           and mnt_select = mnd_select
                           and mnt_lang = lng_lang
            exclusive-lock no-error.

            if not available mnt_det then do:
               create mnt_det.
               assign
                  mnt_nbr = mnd_nbr
                  mnt_select = mnd_select
                  mnt_lang = lng_lang.
            end.

            mnt_label = input mnt_label.

            {&MGMEMT-P-TAG6}
            if mnd_name <> "" then do:
               define variable mndsel as character format "x(10)".
               for each mnddet no-lock where
                        mnddet.mnd_name = mnd_det.mnd_name
                   and (mnddet.mnd_nbr <> mnd_det.mnd_nbr
                     or mnddet.mnd_select <> mnd_det.mnd_select)
               use-index mnd_name:
                  mndsel = mnd_nbr + "." + string(mnd_select).
                  /* Name is also used in menu selection */
                  {pxmsg.i &MSGNUM=290 &ERRORLEVEL=2 &MSGARG1=mndsel}
                  pause.
               end.
            end.

            /* Check for duplicates on URN Value */
            if mnd_uri <> "" then do:
               for each mnddet no-lock where
                  mnddet.mnd_uri = mnd_det.mnd_uri
                  and (mnddet.mnd_nbr <> mnd_det.mnd_nbr
                    or mnddet.mnd_select <> mnd_det.mnd_select)
               use-index mnd_name:
                  mndsel = mnd_nbr + "." + string(mnd_select).
                  /* Executable is also used in menu selection */
                  {pxmsg.i &MSGNUM=1620 &ERRORLEVEL=2 &MSGARG1=mndsel}
                  pause.
               end.
            end. /* if mnd_uri <> "" */

         end. /* do with frame b */

   end.

end.

status input.
