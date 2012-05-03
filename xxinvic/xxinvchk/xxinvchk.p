/* xxinvchk.p - invmt vend drawing pt_part check                             */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */

/* DISPLAY TITLE */
{mfdtitle.i "120503.1"}
/* CONSIGNMENT INVENTORY VARIABLES */
define variable file_name as character format "x(60)" no-undo.
define variable v_keeptax like mfc_logical format "TAX/NOTAX".
define variable v_1char as character.
Define temp-table tt_vddrawpt_ref
       fields ttvp_sn   as   integer format "->>9"
       fields ttvp_vend like pt_vend
       fields ttvp_draw like pt_draw
       fields ttvp_part like pt_part
       fields ttvp_desc like pt_desc1.

{gpcdget.i "UT"}

form
   skip(.1)
   file_name view-as fill-in size 40 by 1 colon 16
   v_keeptax colon 18
   skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

   if c-application-mode <> 'web' then
      update file_name v_keeptax with frame a.

   {wbrp06.i &command = update &fields = " file_name v_keeptax" &frm = "a"}

   for each tt_vddrawpt_ref exclusive-lock: delete tt_vddrawpt_ref. end.

   input from value(file_name).
   repeat:
        create tt_vddrawpt_ref.
        import tt_vddrawpt_ref.
   end.
   input close.

   for each tt_vddrawpt_ref exclusive-lock:
       if ttvp_sn = ? or ttvp_sn = 0 then do:
          delete tt_vddrawpt_ref.
       end.
   end.
   if v_keeptax then v_1char = "P".
                else v_1char = "M".
   for each tt_vddrawpt_ref exclusive-lock:
       find first pt_mstr no-lock where pt_vend = ttvp_vend
              and pt_draw = ttvp_draw and pt_part begins v_1char no-error.
       if available pt_mstr then do:
          assign ttvp_part = pt_part
                 ttvp_desc = pt_desc1.
       end.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 100
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

   {mfphead.i}

   for each tt_vddrawpt_ref no-lock
      where
   with frame b width 100 no-attr-space:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      {mfrpchk.i}

      display ttvp_sn ttvp_vend ttvp_draw ttvp_part ttvp_desc.
   end.

   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
