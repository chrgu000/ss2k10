/* xxbwxp.p - convert browse to create record.                               */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION:0AY2      LAST MODIFIED: 10/15/10   BY: zy                       */

/* display title */
{mfdtitle.i "0AY2"}

define variable brwnamef like brwf_det.brw_name no-undo.
define variable brwnamet like brwf_det.brw_name no-undo.
define variable COMBINED as logical label "Combined" no-undo .
define variable filename as character format "x(40)" no-undo.

define stream history.

form
   brwnamef colon 21
   brwnamet colon 55 label "To"
   skip(1)
   COMBINED colon 21 skip
   filename colon 21
with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

repeat:
   if brwnamet   = hi_char then brwnamet   = "".
   update brwnamef brwnamet COMBINED with frame a.
      if COMBINED
      then do:
         /*  FILE NAME CREATION  IS CHANGED. GENERATED  FILE NAME   IS       */
         /*  INDEPENDENT  OF PROGRESS -D PARAMETER  AND  UNIFORM IN ALL      */
         /*  OTHER PROGRAMS  .                                               */
         filename = "xxbw"
            + string(month(today),"99")
            + string(day(today),"99")
            + ".p".

         display
            filename
         with frame a.
         update filename with frame a.

      end. /* IF COMBINED */

   if brwnamet = "" then brwnamet = hi_char.
os-delete value(filename) no-error.
FOR EACH brw_mstr NO-LOCK WHERE brw_mstr.brw_name >= brwnamef
     and brw_mstr.brw_name <= brwnamet :
   {gprun.i 'xxbwmta.p' "(input brw_mstr.brw_name,input filename,input no)"}
end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType                = "Printer"
               &printWidth               = 90
               &pagedFlag                = " "
               &stream                   = " "
               &appendToFile             = " "
               &streamedOutputToTerminal = " "
               &withBatchOption          = "no"
               &displayStatementType     = 1
               &withCancelMessage        = "yes"
               &pageBottomMargin         = 6
               &withEmail                = "yes"
               &withWinprint             = "yes"
               &defineVariables          = "yes"}
   {mfphead.i}

FOR EACH brw_mstr NO-LOCK WHERE brw_mstr.brw_name >= brwnamef
     and brw_mstr.brw_name <= brwnamet with frame b width 90:
   display brw_mstr.brw_name brw_mstr.brw_desc brw_mstr.brw_view brw_userid
   brw_mod_date.
end.

   {mfrtrail.i}

end. /* REPEAT */
