/* xxbwmt.p - Browse Maintenance Program                                     */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION:0AY1      LAST MODIFIED: 10/15/10   BY: zy                       */

/* STANDARD INCLUDE FILES */
{mfdtitle.i "0AY1"}
{pxmaint.i}

/* DEFINE HANDLES FOR PROGRAMS */
{pxphdef.i mgbwxr}
{pxphdef.i mgbtxr}
{pxphdef.i mgbfxr}
{pxphdef.i mgvwxr}
{pxphdef.i mglbxr}

/* LOCAL VARIABLES */
define variable l_browseName      as   character    no-undo.
define variable l_browseLabel     as   character    no-undo format "x(45)".
define variable l_viewLabel       as   character    no-undo format "x(45)".
define variable l_whereLabel      as   character    no-undo format "x(11)".
define variable l_del-yn          like mfc_logical  no-undo.
define variable l_createConfirm   like mfc_logical  no-undo.
define variable l_tempBrowse      as   character    no-undo.
define variable l_oldBrowseView   as   character    no-undo.
define variable l_oldPowerBrowse  like mfc_logical  no-undo.
define variable l_tableDesc       as   character    no-undo format "x(27)".
define variable l_fieldDesc       as   character    no-undo format "x(60)".
define variable l_schemaLabel     as   character    no-undo format "x(27)".
define variable l_schemaFormat    as   character    no-undo format "x(27)".
define variable l_schemaTerm      as   character    no-undo format "x(35)".
define variable l_fieldLabel      as   character    no-undo format "x(45)".
define variable l_formatLabel     as   character    no-undo format "x(45)".
define variable l_dataType        as   character    no-undo.
define variable temp_term         as   character    no-undo format "x(35)".


/* BUTTON DEFINITIONS */
define button button-preview       label "Preview"    size 12 by 1.

/* SET INITIAL VALUES */
l_whereLabel   = getTermLabel("WHERE",10) + ":".


/* FORM DEFINITIONS */
form
   brw_mstr.brw_name colon 30
   button-preview    at    60
with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   brw_desc       colon 20 label "Description Term"
   l_browseLabel  colon 22 no-label
   skip
   brw_pwr_brw    colon 70
   brw_lu_brw     colon 70
   brw_view       colon 20
   l_viewLabel    colon 22 no-label
   skip(1)
   l_whereLabel   colon 2  no-label
   brw_filter     no-label view-as editor scrollbar-vertical
                                    size 76 by 5
with frame b title color normal (getFrameTitle("BROWSE_DATA",17))
   side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

form
   brwf_seq   colon 30
with frame c side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

form
   brwf_table      colon 12
   l_tableDesc     colon 46 no-label
   brwf_field      colon 12
   l_fieldDesc     colon 14 no-label
   skip (1)
   brwf_label      colon 12 label "Label Term"
   l_schemaLabel   colon 46 no-label
   l_fieldLabel    colon 14 no-label
   brwf__qadc01    colon 12 label "Max Length" format "x(3)"
   skip (1)
   brwf_format     colon 12
   l_schemaFormat  colon 46 no-label
   l_formatLabel   colon 14 no-label
with frame d title color normal (getFrameTitle("BROWSE_FIELD_DATA",26))
   side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

/* EVENT HANDLING */

/* PREVIEW BUTTON */
on choose of button-preview
do:
   /* GENERATE THE TEMPORARY BROWSE */
   {gprun.i 'mgpl009c.p'
      "(input brw_mstr.brw_name,
        input global_user_lang,
        output l_tempBrowse)"}

   /* PREVIEW THE BROWSE */
   {gprun.i 'mgpl009d.p'
      "(input l_tempBrowse)"}

   /* REMOVE THE TEMPORARY BROWSE */
   {gprun.i 'mgpl009f.p'
      "(input l_tempBrowse)"}

end. /* ON CHOOSE OF button-preview */

on leave of brwf_label do:
   if brwf_label:screen-value <> "" then do:
      temp_term = brwf_label:screen-value.
      {pxrun.i &PROC='updateLabelTerm' &PROGRAM='mglbxr.p'
               &HANDLE=ph_mglbxr
               &PARAM="(input-output temp_term)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      run getBrowseFieldLabel
         (input temp_term,
          input brwf__qadc01:screen-value,
          output l_fieldLabel).

   end.
   else
      assign
         l_fieldLabel = ""
         temp_term = "".
   display
      temp_term @ brwf_label
      l_fieldLabel
   with frame d.

end.

on leave of brwf__qadc01 do:
   if brwf__qadc01:screen-value <> "" then do:

      {pxrun.i &PROC='validateMaxLength' &PROGRAM='mgbfxr.p'
               &HANDLE=ph_mgbfxr
               &PARAM="(input brwf__qadc01:screen-value)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if return-value <> {&SUCCESS-RESULT}
      then
         return no-apply.
      else
         hide message no-pause.

      run getBrowseFieldLabel
         (input brwf_label:screen-value,
          input brwf__qadc01:screen-value,
          output l_fieldLabel).

      display
         l_fieldLabel
      with frame d.
   end.
end.

mainloop:
repeat:

   clear frame c.
   clear frame d.

   hide frame c.
   hide frame d.

   assign
      l_del-yn         = false
      l_createConfirm  = false
      l_oldBrowseView  = ""
      l_oldPowerBrowse = false
      l_tableDesc      = ""
      l_fieldDesc      = ""
      l_schemaLabel    = ""
      l_fieldLabel     = ""
      l_schemaFormat   = ""
      l_formatLabel    = "".

   view frame a.
   view frame b.

   display
      l_whereLabel
   with frame b.

   prompt-for
      brw_mstr.brw_name
   with frame a
   editing:

      {mfnp.i brw_mstr brw_name brw_name
         brw_name brw_name brw_mstr}

      if recno <> ?
      then do:
         display
            brw_name
         with frame a.

         l_browseLabel = getTermLabel(brw_desc, 45).

         {pxrun.i &PROC='getBrowseViewDescription' &PROGRAM='mgbwxr.p'
                  &HANDLE=ph_mgbwxr
                  &PARAM="(input brw_view,
                           output l_viewLabel)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         display
            brw_desc
            l_browseLabel
            brw_pwr_brw
            brw_lu_brw
            brw_view
            l_viewLabel
            brw_filter
         with frame b.

         l_oldPowerBrowse = brw_pwr_brw.

      end. /* IF recno <> ? */
   end. /* EDITING */

   {pxrun.i &PROC='validateNameForBlank' &PROGRAM='mgbwxr.p'
            &HANDLE=ph_mgbwxr
            &PARAM="(input brw_name:screen-value)"
            &NOAPPERROR=true
            &CATCHERROR=true}

   if return-value <> {&SUCCESS-RESULT}
   then do:
      next-prompt
         brw_name
      with frame a.
      undo mainloop, retry mainloop.
   end.

   l_browseName = brw_name:screen-value.

   {pxrun.i &PROC='getNextBrowseSequence' &PROGRAM='mgbwxr.p'
            &HANDLE=ph_mgbwxr
            &PARAM="(input-output l_browseName)"
            &NOAPPERROR=true
            &CATCHERROR=true}

   brw_name:screen-value = l_browseName.

   {pxrun.i &PROC='validateNameForStandard' &PROGRAM='mgbwxr.p'
            &HANDLE=ph_mgbwxr
            &PARAM="(input brw_name:screen-value)"
            &NOAPPERROR=true
            &CATCHERROR=true}

   if return-value <> {&SUCCESS-RESULT}
   then do:
      next-prompt
         brw_name
      with frame a.
      undo mainloop, retry mainloop.
   end.

   do transaction:
      {pxrun.i &PROC='processRead' &PROGRAM='mgbwxr.p'
               &HANDLE=ph_mgbwxr
               &PARAM="(input brw_name:screen-value,
                        buffer brw_mstr,
                        input {&LOCK_FLAG},
                        input {&WAIT_FLAG})"
               &NOAPPERROR=true
               &CATCHERROR=true}

      if return-value = {&RECORD-NOT-FOUND}
      then do:
         {pxrun.i &PROC='processCreate' &PROGRAM='mgbwxr.p'
                  &HANDLE=ph_mgbwxr
                  &PARAM="(input brw_name:screen-value,
                           buffer brw_mstr)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         {pxrun.i &PROC='defaultBrowseDetails' &PROGRAM='mgbwxr.p'
                  &HANDLE=ph_mgbwxr
                  &PARAM="(input brw_name:screen-value,
                           output brw_pwr_brw,
                           output brw_lu_brw)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         {pxmsg.i &MSGNUM=1 &ERRORLEVEL={&INFORMATION-RESULT}}
      end.
      else
         l_oldPowerBrowse = brw_pwr_brw.


      /* ACTIVATE PREVIEW BUTTON, IF BROWSE FIELD DETAIL EXISTS */
      if can-find(first brwf_det
                     where brwf_det.brw_name = brw_mstr.brw_name:screen-value)
      then do:
         update
            button-preview
         with frame a.
      end. /* IF CAN-FIND(FIRST brwf_det ... */

      assign
         l_browseLabel    = getTermLabel(brw_desc, 45)
         l_oldBrowseView  = brw_view.

      {pxrun.i &PROC='getBrowseViewDescription' &PROGRAM='mgbwxr.p'
               &HANDLE=ph_mgbwxr
               &PARAM="(input brw_view,
                        output l_viewLabel)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      display
         brw_desc
         l_browseLabel
         brw_pwr_brw
         brw_lu_brw
         brw_view
         l_viewLabel
         brw_filter
      with frame b.

      setb:
      do on error undo setb, retry setb:

         set
            brw_desc
            brw_pwr_brw
            brw_lu_brw
            brw_view
            brw_filter
         with frame b
         editing:

            if frame-field = "brw_desc"
            then do:
               run getStatusLine.

               {mfnp09.i lbl_mstr brw_desc lbl_long
                  global_user_lang lbl_lang lbl_long}

               if recno <> ?
               then do:
                  assign
                     l_browseLabel = getTermLabel(lbl_term, 45)
                     brw_desc = lbl_term.

                  display
                     brw_desc
                     l_browseLabel
                  with frame b.
               end.
            end. /* IF FRAME-FIELD = "brw_desc" */
            else do:
               ststatus = stline[2].
               status input ststatus.

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
            {pxrun.i &PROC='processDelete' &PROGRAM='mgbwxr.p'
                     &HANDLE=ph_mgbwxr
                     &PARAM="(buffer brw_mstr)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}

            clear frame a.
            clear frame b.

            brw_desc:screen-value = "".

            next mainloop.
         end.

         {pxrun.i &PROC='updateLabelTerm' &PROGRAM='mglbxr.p'
                  &HANDLE=ph_mglbxr
                  &PARAM="(input-output brw_desc)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}
         l_browseLabel = getTermLabel(brw_desc, 45).

         display
            brw_desc
            l_browseLabel
         with frame b.

         {pxrun.i &PROC='validateBrowseType' &PROGRAM='mgbwxr.p'
                  &HANDLE=ph_mgbwxr
                  &PARAM="(input brw_pwr_brw,
                           input brw_lu_brw)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if return-value <> {&SUCCESS-RESULT}
         then do:
            next-prompt
               brw_pwr_brw
            with frame b.
            undo setb, retry setb.
         end.

         {pxrun.i &PROC='validateNameForBlank' &PROGRAM='mgvwxr.p'
                  &HANDLE=ph_mgvwxr
                  &PARAM="(input brw_view)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if return-value <> {&SUCCESS-RESULT}
         then do:
            next-prompt
               brw_view
            with frame b.
            undo setb, retry setb.
         end.

         {pxrun.i &PROC='validateBrowseView' &PROGRAM='mgbwxr.p'
                  &HANDLE=ph_mgbwxr
                  &PARAM="(input brw_view)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if return-value <> {&SUCCESS-RESULT}
         then do:
            next-prompt
               brw_view
            with frame b.
            undo setb, retry setb.
         end.

         {pxrun.i &PROC='validateViewAccess' &PROGRAM='mgvwxr.p'
                  &HANDLE=ph_mgvwxr
                  &PARAM="(input brw_view)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if return-value <> {&SUCCESS-RESULT}
         then do:
            next-prompt
               brw_view
            with frame b.
            undo setb, retry setb.
         end.

         run replaceOldwithNew
            (input brw_name,
             input brw_view,
             input brw_pwr_brw,
             input brw_lu_brw,
             input l_oldBrowseView,
             input l_oldPowerBrowse).

         if new brw_mstr then do:
            {pxrun.i &PROC='addBrowseTableDetails' &PROGRAM='mgbtxr.p'
                     &HANDLE=ph_mgbtxr
                     &PARAM="(input brw_name,
                              input brw_view)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}
         end. /* IF NEW brw_mstr */

         {pxrun.i &PROC='validateTermForExistence' &PROGRAM='mglbxr.p'
                  &HANDLE=ph_mglbxr
                  &PARAM="(input brw_desc,
                           output l_createConfirm)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if return-value <> {&SUCCESS-RESULT}
         then do:

            if not l_createConfirm
            then do:
               next-prompt
                  brw_desc
               with frame b.
               undo setb, retry setb.
            end.
            else do:
               {pxrun.i &PROC='validateTerm' &PROGRAM='mglbxr.p'
                        &HANDLE=ph_mglbxr
                        &PARAM="(input brw_desc)"
                        &NOAPPERROR=true
                        &CATCHERROR=true}

               if return-value <> {&SUCCESS-RESULT}
               then do:
                  next-prompt
                     brw_desc
                  with frame b.
                  undo setb, retry setb.
               end.

               hide frame b.

               {gprun.i ""mglbmt1.p""
                  "(input global_user_lang,
                    input brw_desc)"}

               {pxrun.i &PROC='processRead' &PROGRAM='mglbxr.p'
                        &HANDLE=ph_mglbxr
                        &PARAM="(input global_user_lang,
                                 input brw_desc,
                                 buffer lbl_mstr,
                                 input {&NO_LOCK_FLAG},
                                 input {&NO_WAIT_FLAG})"
                        &NOAPPERROR=true
                        &CATCHERROR=true}

               if return-value = {&RECORD-NOT-FOUND}
               then do:
                  next-prompt
                     brw_desc
                  with frame b.
                  undo setb, retry setb.
               end.
            end. /* ELSE */
         end.  /* IF RETURN-VALUE <> {&SUCCESS-RESULT} */

      end. /* SETB */

      {pxrun.i &PROC='setModificationInfo' &PROGRAM='mgbwxr.p'
               &HANDLE=ph_mgbwxr
               &PARAM="(buffer brw_mstr)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      hide frame b no-pause.

      {gprun.i ""mgbwmt1.p""
               "(buffer brw_mstr)"}

      view frame c.
      view frame d.

      setc:
      repeat on error undo setc, retry setc:
         l_del-yn = false.

         prompt-for
            brwf_seq
         with frame c
         editing:

            {mfnp01.i brwf_det brwf_seq brwf_seq
               brw_mstr.brw_name brwf_det.brw_name brwf_det}

            if recno <> ? then do:
               display
                  brwf_seq
               with frame c.

               display
                  brwf_table
                  brwf_field
                  brwf_label
                  brwf__qadc01
                  brwf_format
               with frame d.

               run getSchemaDetails
                  (input  brw_view,
                   input  brwf_table,
                   input  brwf_field,
                   output l_tableDesc,
                   output l_fieldDesc,
                   output l_schemaLabel,
                   output l_schemaFormat,
                   output l_schemaTerm).

               if brwf_datatype = "" then do:
                  {pxrun.i &PROC='getFieldDataType' &PROGRAM='mgbfxr.p'
                           &HANDLE=ph_mgbfxr
                           &PARAM="(input brw_view,
                                    input brwf_table,
                                    input brwf_field,
                                    output l_dataType)"
                           &NOAPPERROR=true
                           &CATCHERROR=true}
               end.
               else
                  l_dataType = brwf_datatype.

               if l_dataType = 'logical' then
                  l_formatLabel = getTermLabel(brwf_format, 45).
               else
                  l_formatLabel = ''.

              run getBrowseFieldLabel
                 (input brwf_label,
                  input brwf__qadc01,
                  output l_fieldLabel).

               display
                  l_tableDesc
                  l_fieldDesc
                  l_schemaLabel
                  l_fieldLabel
                  l_schemaFormat
                  l_formatLabel
               with frame d.
            end.
         end. /* EDITING */

         {pxrun.i &PROC='validateSequence' &PROGRAM='mgbfxr.p'
                  &HANDLE=ph_mgbfxr
                  &PARAM="(input integer(brwf_seq:screen-value))"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if return-value <> {&SUCCESS-RESULT}
         then do:
            next-prompt
               brwf_seq
            with frame c.
            undo setc, retry setc.
         end.

         {pxrun.i &PROC='processRead' &PROGRAM='mgbfxr.p'
                  &HANDLE=ph_mgbfxr
                  &PARAM="(input brw_mstr.brw_name,
                           input integer(brwf_seq:screen-value),
                           buffer brwf_det,
                           input {&LOCK_FLAG},
                           input {&WAIT_FLAG})"
                  &NOAPPERROR=true
                  &CATCHERROR=true}

         if return-value = {&RECORD-NOT-FOUND}
         then do:
            {pxrun.i &PROC='processCreate' &PROGRAM='mgbfxr.p'
                     &HANDLE=ph_mgbfxr
                     &PARAM="(input brw_mstr.brw_name,
                              input integer(brwf_seq:screen-value),
                              buffer brwf_det)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}

            {pxrun.i &PROC='defaultBrowseTableName' &PROGRAM='mgbfxr.p'
                     &HANDLE=ph_mgbfxr
                     &PARAM="(input  brw_mstr.brw_name,
                              input  brw_view,
                              output brwf_table)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}

            /* Adding new record */
            {pxmsg.i &MSGNUM=1 &ERRORLEVEL={&INFORMATION-RESULT}}
         end.

         run getSchemaDetails
            (input brw_view,
             input brwf_table,
             input brwf_field,
             output l_tableDesc,
             output l_fieldDesc,
             output l_schemaLabel,
             output l_schemaFormat,
             output l_schemaTerm).

         if brwf_datatype = "" then do:
            {pxrun.i &PROC='getFieldDataType' &PROGRAM='mgbfxr.p'
                     &HANDLE=ph_mgbfxr
                     &PARAM="(input brw_view,
                              input brwf_table,
                              input brwf_field,
                              output l_dataType)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}
         end.
         else
            l_dataType = brwf_datatype.

         if l_dataType = "logical" then
            l_formatLabel = getTermLabel(brwf_format, 45).
         else
            l_formatLabel = ''.

         run getBrowseFieldLabel
            (input brwf_label,
             input brwf__qadc01,
             output l_fieldLabel).

         display
            brwf_table
            l_tableDesc
            brwf_field
            l_fieldDesc
            brwf_label
            brwf__qadc01
            l_schemaLabel
            l_fieldLabel
            brwf_format
            l_schemaFormat
            l_formatLabel
         with frame d.

         setd:
         do on error undo setd, leave setd:
            l_createConfirm = false.

            set
               brwf_table
               brwf_field
            with frame d editing:

               {pxmsg.i &MSGNUM=8803 &ERRORLEVEL=1 &MSGBUFFER=ststatus}
               status input ststatus.

               readkey.
               apply lastkey.
            end.

            {pxrun.i &PROC='validateBrowseTable' &PROGRAM='mgbtxr.p'
                     &HANDLE=ph_mgbtxr
                     &PARAM="(input brw_mstr.brw_name,
                              input brwf_table)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}

            if return-value <> {&SUCCESS-RESULT}
            then do:
               next-prompt
                  brwf_table
               with frame d.
               undo setd, retry setd.
            end.

            {pxrun.i &PROC='getSchemaDetailsForTable' &PROGRAM='mgbtxr.p'
                     &HANDLE=ph_mgbtxr
                     &PARAM="(input brwf_table,
                              output l_tableDesc)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}

            if brwf_table <> "" then
               display l_tableDesc with frame d.
            else
               display "" @ l_tableDesc with frame d.

            {pxrun.i &PROC='validateFieldForDuplicate' &PROGRAM='mgbfxr.p'
                     &HANDLE=ph_mgbfxr
                     &PARAM="(input brw_mstr.brw_name,
                              input brwf_seq,
                              input brwf_table,
                              input brwf_field)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}

            if return-value <> {&SUCCESS-RESULT}
            then do:
               next-prompt
                  brwf_field
               with frame d.
               undo setd, retry setd.
            end.

            {pxrun.i &PROC='validateField' &PROGRAM='mgbfxr.p'
                     &HANDLE=ph_mgbfxr
                     &PARAM="(input brw_mstr.brw_name,
                              input brw_view,
                              input brwf_table,
                              input brwf_field)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}

            if return-value <> {&SUCCESS-RESULT}
            then do:
               next-prompt
                  brwf_field
               with frame d.
               undo setd, retry setd.
            end.

            {pxrun.i &PROC='defaultBrowseFieldDetails' &PROGRAM='mgbfxr.p'
                     &HANDLE=ph_mgbfxr
                     &PARAM="(input brw_view,
                              input brwf_table,
                              input brwf_field,
                              output l_fieldDesc,
                              output l_schemaLabel,
                              output l_schemaFormat,
                              output l_schemaTerm)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}

            if return-value <> {&SUCCESS-RESULT}
            then do:
               next-prompt
                  brwf_table
               with frame d.
               undo setd, retry setd.
            end.

            display
               l_fieldDesc
               l_schemaLabel
               l_schemaFormat
            with frame d.

            setd2:
            do on error undo setd2, leave setd2:

               l_createConfirm = false.

               set
                  brwf_label
                  brwf__qadc01
                  brwf_format
               with frame d
               editing:

                  if frame-field = "brwf_label"
                  then do:
                     run getStatusLine.

                     {mfnp09.i lbl_mstr brwf_label lbl_long
                        global_user_lang lbl_lang lbl_long}

                     if recno <> ?
                     then do:
                        assign
                           l_fieldLabel = getTermLabel(lbl_term, 45)
                           brwf_label = lbl_term.

                        display
                           brwf_label
                           l_fieldLabel
                        with frame d.
                     end.
                  end. /* IF FRAME-FIELD = "brwf_label" */
                  else
                     if frame-field = "brwf_format" then do:

                        {pxrun.i &PROC='getFieldDataType' &PROGRAM='mgbfxr.p'
                                 &HANDLE=ph_mgbfxr
                                 &PARAM="(input brw_view,
                                          input brwf_table:screen-value,
                                          input brwf_field:screen-value,
                                          output l_dataType)"
                                 &NOAPPERROR=true
                                 &CATCHERROR=true}

                        if l_dataType = "logical"
                        then do:
                           run getStatusLine.

                           {mfnp09.i lbl_mstr brwf_format lbl_long
                              global_user_lang lbl_lang lbl_long}

                           if recno <> ?
                           then do:
                              assign
                                 l_formatLabel = getTermLabel(lbl_term, 45)
                                 brwf_format = lbl_term.

                              display
                                 brwf_format
                                 l_formatLabel
                              with frame d.
                           end.
                        end. /* IF l_dataType = "logical" */
                        else do:
                           ststatus = stline[2].
                           status input ststatus.

                           readkey.
                           apply lastkey.
                        end.

                     end. /* IF FRAME-FIELD = "brwf_format" */
                     else do:
                        ststatus = stline[2].
                        status input ststatus.

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
                     {pxmsg.i &MSGNUM=11 &ERRORLEVEL={&INFORMATION-RESULT}
                              &CONFIRM    = l_del-yn}

                     if l_del-yn then
                        leave.
                     else
                        undo setd, retry setd.
                  end.
              end. /* EDITING */

               if l_del-yn
               then do:
                  {pxrun.i &PROC='processDelete' &PROGRAM='mgbfxr.p'
                           &HANDLE=ph_mgbfxr
                           &PARAM="(buffer brwf_det,
                                    buffer brw_mstr)"
                           &NOAPPERROR=true
                           &CATCHERROR=true}

                  clear frame c.
                  clear frame d.

                  next setc.
               end.

               {pxrun.i &PROC='getFieldDataType' &PROGRAM='mgbfxr.p'
                        &HANDLE=ph_mgbfxr
                        &PARAM="(input brw_view,
                                 input brwf_table,
                                 input brwf_field,
                                 output brwf_datatype)"
                        &NOAPPERROR=true
                        &CATCHERROR=true}

               {pxrun.i &PROC='validateTermForExistence' &PROGRAM='mglbxr.p'
                        &HANDLE=ph_mglbxr
                        &PARAM="(input brwf_label,
                                 output l_createConfirm)"
                        &NOAPPERROR=true
                        &CATCHERROR=true}

               if return-value <> {&SUCCESS-RESULT}
               then do:

                  if not l_createConfirm
                  then do:
                     next-prompt
                        brwf_label
                     with frame d.
                     undo setd2, retry setd2.
                  end.
                  else do:
                     {pxrun.i &PROC='validateTerm' &PROGRAM='mglbxr.p'
                              &HANDLE=ph_mglbxr
                              &PARAM="(input brwf_label)"
                              &NOAPPERROR=true
                              &CATCHERROR=true}

                     if return-value <> {&SUCCESS-RESULT}
                     then do:
                        next-prompt
                           brwf_label
                        with frame d.
                        undo setd2, retry setd2.
                     end.

                     hide frame d.

                     {gprun.i ""mglbmt1.p""
                        "(input global_user_lang,
                          input brwf_label)"}

                     {pxrun.i &PROC='processRead' &PROGRAM='mglbxr.p'
                              &HANDLE=ph_mglbxr
                              &PARAM="(input global_user_lang,
                                       input brwf_label,
                                       buffer lbl_mstr,
                                       input {&NO_LOCK_FLAG},
                                       input {&NO_WAIT_FLAG})"
                              &NOAPPERROR=true
                              &CATCHERROR=true}

                     if return-value = {&RECORD-NOT-FOUND}
                     then do:
                        next-prompt
                           brwf_label
                        with frame d.
                        undo setd2, retry setd2.
                     end.

                     view frame d.

                     run getBrowseFieldLabel
                        (input brwf_label,
                         input brwf__qadc01,
                         output l_fieldLabel).

                     display
                        l_fieldLabel
                     with frame d.
                  end.
               end.  /* IF RETURN-VALUE <> {&SUCCESS-RESULT} */

               {gprun.i ""mglbdmt1.p""
                   "(input brwf_field,
                    input brwf_label,
                    input brwf_seq,
                    input l_schemaTerm,
                    input brw_name,
                    input brw_pwr_brw,
                    input brw_lu_brw)"}

               if brwf_datatype = 'logical'
               then do:
                  l_createConfirm = false.

                  {pxrun.i &PROC='updateLabelTerm' &PROGRAM='mglbxr.p'
                           &HANDLE=ph_mglbxr
                           &PARAM="(input-output brwf_format)"
                           &NOAPPERROR=true
                           &CATCHERROR=true}

                  display
                     brwf_format
                  with frame d.

                  {pxrun.i &PROC='validateTermForExistence' &PROGRAM='mglbxr.p'
                           &HANDLE=ph_mglbxr
                           &PARAM="(input brwf_format,
                                    output l_createConfirm)"
                           &NOAPPERROR=true
                           &CATCHERROR=true}

                  if return-value <> {&SUCCESS-RESULT}
                  then do:

                     if not l_createConfirm
                     then do:
                        next-prompt
                           brwf_format
                        with frame d.
                        undo setd2, retry setd2.
                     end.
                     else do:
                        {pxrun.i &PROC='validateTerm' &PROGRAM='mglbxr.p'
                                 &HANDLE=ph_mglbxr
                                 &PARAM="(input brwf_format)"
                                 &NOAPPERROR=true
                                 &CATCHERROR=true}

                        if return-value <> {&SUCCESS-RESULT}
                        then do:
                           next-prompt
                              brwf_format
                           with frame d.
                           undo setd2, retry setd2.
                        end.

                        hide frame d.

                        {gprun.i ""mglbmt1.p""
                           "(input global_user_lang,
                             input brwf_format)"}

                        {pxrun.i &PROC='processRead' &PROGRAM='mglbxr.p'
                                 &HANDLE=ph_mglbxr
                                 &PARAM="(input global_user_lang,
                                          input brwf_format,
                                          buffer lbl_mstr,
                                          input {&NO_LOCK_FLAG},
                                          input {&NO_WAIT_FLAG})"
                                 &NOAPPERROR=true
                                 &CATCHERROR=true}

                        if return-value = {&RECORD-NOT-FOUND}
                        then do:
                           next-prompt
                              brwf_format
                           with frame d.
                           undo setd2, retry setd2.
                         end.

                        view frame d.

                        l_formatLabel = getTermLabel(brwf_format, 45).

                        display
                           l_formatLabel
                        with frame d.
                     end.
                  end.  /* IF RETURN-VALUE <> {&SUCCESS-RESULT} */

               end. /* IF brwf_datatype = 'logical' */
            end. /* SETD2 */
         end. /* SETD */

         {pxrun.i &PROC='setModificationInfo' &PROGRAM='mgbfxr.p'
                  &HANDLE=ph_mgbfxr
                  &PARAM="(buffer brwf_det)"
                  &NOAPPERROR=true
                  &CATCHERROR=true}
      end. /* SETC */

      hide frame c.
      hide frame d.

      /* Generate the Revision History lines for the browse */
      {gprun.i ""mgbwmt2.p"" "(input brw_mstr.brw_name)"}

      /* GENERATE BROWSE */
      {gprun.i 'mgpl009e.p' "(input brw_mstr.brw_name)"}

      {gprun.i 'xxbwmta.p' "(input brw_mstr.brw_name,input '',input yes)"}
   end. /* DO TRANSACTION */

end. /* MAINLOOP */

PROCEDURE getBrowseFieldLabel :
/*------------------------------------------------------------------------------
  Purpose:       Retrieves the browse field label based on user supplied max length
  Exceptions:    None
  Notes:
  History:
------------------------------------------------------------------------------*/
   define input parameter pbrwf_label    as character no-undo.
   define input parameter pbrwf__qadc01  as character no-undo.
   define output parameter p_fieldLabel  as character no-undo.
   define variable l_length              as integer   no-undo.

   if pbrwf_label <> "" then do:

      l_length = if pbrwf__qadc01 <> "" then
                    integer(pbrwf__qadc01)
                 else
                    45.
      p_fieldLabel = getTermLabel(pbrwf_label,l_length).

   end.
   else
      p_fieldLabel = "".

END PROCEDURE.

PROCEDURE getSchemaDetails :
/*------------------------------------------------------------------------------
  Purpose:       Retrieves the schema details for the Browse table and
                 the default Browse field details
  Exceptions:    None
  Notes:
  History:
------------------------------------------------------------------------------*/
   define input  parameter pbrw_view      as character no-undo.
   define input  parameter pbrwf_table    as character no-undo.
   define input  parameter pbrwf_field    as character no-undo.
   define output parameter p_tableDesc    as character no-undo.
   define output parameter p_fieldDesc    as character no-undo.
   define output parameter p_schemaLabel  as character no-undo.
   define output parameter p_schemaFormat as character no-undo.
   define output parameter p_schemaTerm   as character no-undo.

   {pxrun.i &PROC='getSchemaDetailsForTable' &PROGRAM='mgbtxr.p'
            &HANDLE=ph_mgbtxr
            &PARAM="(input pbrwf_table,
                     output p_tableDesc)"
            &NOAPPERROR=true
            &CATCHERROR=true}

   {pxrun.i &PROC='defaultBrowseFieldDetails' &PROGRAM='mgbfxr.p'
            &HANDLE=ph_mgbfxr
            &PARAM="(input pbrw_view,
                     input pbrwf_table,
                     input pbrwf_field,
                     output p_fieldDesc,
                     output p_schemaLabel,
                     output p_schemaFormat,
                     output p_schemaTerm)"
            &NOAPPERROR=true
            &CATCHERROR=true}

END PROCEDURE.

PROCEDURE getStatusLine :
/*------------------------------------------------------------------------------
  Purpose:       Gets the appropriate status line to display
  Exceptions:    None
  Notes:
  History:
------------------------------------------------------------------------------*/

   /*V8-*/
   {pxmsg.i &MSGNUM=4908 &ERRORLEVEL=1 &MSGBUFFER=ststatus}
   /*V8+*/

   /*V8!
   {pxmsg.i &MSGNUM=4909 &ERRORLEVEL=1 &MSGBUFFER=ststatus}
   */
   status input ststatus.

END PROCEDURE.

PROCEDURE replaceOldwithNew :
/*------------------------------------------------------------------------------
  Purpose:       Replaces the old browse table details with new table
                 details when the user changes the browse view or modifies the
                 view join expression or adds/deletes tables to the existing view.
  Exceptions:    None
  Notes:
  History:
------------------------------------------------------------------------------*/
   define input  parameter pBrowseName     as character no-undo.
   define input  parameter pBrowseView     as character no-undo.
   define input  parameter pPowerBrowse    as logical   no-undo.
   define input  parameter pLookupBrowse   as logical   no-undo.
   define input  parameter poldBrowseView  as character no-undo.
   define input  parameter poldPowerBrowse as logical   no-undo.
   define variable br_filename             as character initial "" no-undo.
   define variable lu_filename             as character initial "" no-undo.
   define variable temp_table              as character no-undo.

   if poldBrowseView <> "" and
      poldBrowseView <> pBrowseView
   then do:
      {pxrun.i &PROC='deleteBrowseTableDetails' &PROGRAM='mgbtxr.p'
               &HANDLE=ph_mgbtxr
               &PARAM="(input pBrowseName)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      {pxrun.i &PROC='deleteBrowseFieldDetails' &PROGRAM='mgbfxr.p'
               &HANDLE=ph_mgbfxr
               &PARAM="(input pBrowseName,
                        input pPowerBrowse,
                        input pLookupBrowse)"
               &NOAPPERROR=true
               &CATCHERROR=true}

      {pxrun.i &PROC='addBrowseTableDetails' &PROGRAM='mgbtxr.p'
               &HANDLE=ph_mgbtxr
               &PARAM="(input pBrowseName,
                        input pBrowseView)"
               &NOAPPERROR=true
               &CATCHERROR=true}
   end. /* IF poldBrowseView <> "" AND ... */
   else
   if poldBrowseView <> "" and
      poldBrowseView = pBrowseView and
      poldPowerBrowse <> pPowerBrowse
   then do:
      /* Need to check for when the state of the power browse flag has
         been changed on an existing Browse. This is because we need
         to replace the executable file name in the label detail records */
      {pxrun.i &PROC='createFilename' &PROGRAM='mgbwxr.p'
               &HANDLE=ph_mgbwxr
               &PARAM="(input 'br',
                        input pBrowseName,
                        output br_filename)"}
      {pxrun.i &PROC='createFilename' &PROGRAM='mgbwxr.p'
               &HANDLE=ph_mgbwxr
               &PARAM="(input 'lu',
                        input pBrowseName,
                        output lu_filename)"}
      if poldPowerBrowse = true then do:
        if can-find (first lbld_det
                      where lbld_fieldname <> ""
                      and   lbld_execname = br_filename)
         then do:
            for each lbld_det
               where lbld_fieldname <> ""
               and   lbld_execname = br_filename
            exclusive-lock:
               lbld_execname = lu_filename.
            end.
         end.
      end.
      else
      if poldPowerBrowse = false then do:
        if can-find (first lbld_det
                      where lbld_fieldname <> ""
                      and   lbld_execname = lu_filename)
         then do:
            for each lbld_det
               where lbld_fieldname <> ""
               and   lbld_execname = lu_filename
            exclusive-lock:
               lbld_execname = br_filename.
            end.
         end.
      end.
   end.

   if poldBrowseView <> "" and
      poldBrowseView = pBrowseView and
      can-find(first vue_mstr where vue_mstr.vue_name = pBrowseView)
   then do:
      for each vwj_det where
         vwj_det.vue_name = pBrowseView no-lock:
      /* Check to see if the View Join expression was changed, new tables added
         to the view, or the view join type was changed (outer vs inner join).
         If so, delete the existing Browse Table details and create
         new ones for the updated view */

         if not can-find(first brwt_det where
                         brwt_det.brw_name = pBrowseName and
                         brwt_table = vwj_table and
                         brwt_join = vwj_join and
                         brwt__qadc01 = vwj__qadc01)
         then do:
            {pxrun.i &PROC='deleteBrowseTableDetails' &PROGRAM='mgbtxr.p'
               &HANDLE=ph_mgbtxr
               &PARAM="(input pBrowseName)"
               &NOAPPERROR=true
               &CATCHERROR=true}

            {pxrun.i &PROC='addBrowseTableDetails' &PROGRAM='mgbtxr.p'
               &HANDLE=ph_mgbtxr
               &PARAM="(input pBrowseName,
                        input pBrowseView)"
               &NOAPPERROR=true
               &CATCHERROR=true}
         end.
      end.
      for each brwt_det where
         brwt_det.brw_name = pBrowseName no-lock:

         /* Check to see if any tables were deleted from the View.*/
         /* If so, delete and recreate the browse table details.  */
         if not can-find (first vwj_det where
            vwj_det.vue_name  = pBrowseView and
            vwj_det.vwj_table = brwt_table  and
            vwj_det.vwj_join  = brwt_join)
         then do:
            temp_table = brwt_det.brwt_table.
            {pxrun.i &PROC='deleteBrowseTableDetails' &PROGRAM='mgbtxr.p'
                     &HANDLE=ph_mgbtxr
                     &PARAM="(input pBrowseName)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}

            /* If the browse fields include fields from the view table
               that was deleted then delete all browse field details. */
            if can-find (first brwf_det where
                               brwf_det.brw_name = pBrowseName
                         and   brwf_table = temp_table)
            then do:
               {pxrun.i &PROC='deleteBrowseFieldDetails'
                        &PROGRAM='mgbfxr.p'
                        &HANDLE=ph_mgbfxr
                        &PARAM="(input pBrowseName,
                                 input pPowerBrowse,
                                 input pLookupBrowse)"
                        &NOAPPERROR=true
                        &CATCHERROR=true}
            end.

            {pxrun.i &PROC='addBrowseTableDetails' &PROGRAM='mgbtxr.p'
               &HANDLE=ph_mgbtxr
               &PARAM="(input pBrowseName,
                        input pBrowseView)"
               &NOAPPERROR=true
               &CATCHERROR=true}
         end.
      end.

      /* Check to see if any local variables were deleted from the view */
      /* If so, delete the browse field details.               */
      for each brwf_det where brwf_det.brw_name = pBrowseName
         and brwf_field begins "local" no-lock:
         if not can-find (first vuf_det where vuf_det.vue_name = pBrowseView
                           and vuf_field = brwf_field)
         then do:
            {pxrun.i &PROC='deleteBrowseFieldDetails'
                     &PROGRAM='mgbfxr.p'
                     &HANDLE=ph_mgbfxr
                     &PARAM="(input pBrowseName,
                              input pPowerBrowse,
                              input pLookupBrowse)"
                     &NOAPPERROR=true
                     &CATCHERROR=true}
         end.
      end.
   end. /* IF poldBrowseView <> "" AND ... */

END PROCEDURE.
