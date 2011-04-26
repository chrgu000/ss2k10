/* xxbwxp.p - convert browse to create record.                               */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION:0AY2      LAST MODIFIED: 10/15/10   BY: zy                       */

/* display title */
{mfdtitle.i "14Y1"}

define variable browse1 like brwf_det.brw_name no-undo.
define variable browse2 like brwf_det.brw_name no-undo.
define variable consolidate as logical label "consolidate" no-undo .
define variable filename as character format "x(40)" no-undo.

define stream history.
{}
form
   browse1 colon 21
   browse2 colon 42 label {t001.i}
   skip(1)
   consolidate colon 21 skip
   filename colon 21
with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

repeat:
   if browse2   = hi_char then browse2   = "".
   update browse1 browse2 consolidate with frame a.
      if consolidate
      then do:
         /*  FILE NAME CREATION  IS CHANGED. GENERATED  FILE NAME   IS       */
         /*  INDEPENDENT  OF PROGRESS -D PARAMETER  AND  UNIFORM IN ALL      */
         /*  OTHER PROGRAMS  .                                               */
         filename = "xxbwx" + string(month(today),"99")
            + string(day(today),"99") + ".p".
         display filename with frame a.
         update filename with frame a.
      end. /* IF consolidate */

if browse2 = "" then browse2 = hi_char.
if filename <> "" then do:
os-delete value(filename) no-error.
output to value(filename).
put unformat "~/*V8:ConvertMode=Maintenance" fill(" ",50) "*~/" skip.
put unformat "~{mfdtitle.i """ substring(string(year(today),"9999"),3,2)
             string(month(today),"99")
             string(day(today),"99") ".1" """~}" skip.
put unformat "define variable yn like mfc_logical no-undo." skip.
put unformat "~{gpcdget.i ""UT""~}" skip(1).
put unformat "Form yn colon 40" skip.
put unformat "with frame a side-labels width 80 attr-space." skip.
put unformat "setFrameLabels(frame a:handle)." skip(1).
put unformat "repeat with frame a:" skip.
put unformat "update yn." skip.
put unformat "if not yn then leave." skip(1).
output close.
end.
FOR EACH brw_mstr NO-LOCK WHERE brw_mstr.brw_name >= browse1
     and brw_mstr.brw_name <= browse2 :
   {gprun.i 'xxbwmta.p' "(input brw_mstr.brw_name,input filename)"}
END.
output to value(filename) APPEND.
put unformat "end.  ~/* DO ON ERROR UNDO, RETRY *~/" skip.
put unformat "status input." skip.
output close.

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

FOR EACH brw_mstr NO-LOCK WHERE brw_mstr.brw_name >= browse1
     and (brw_mstr.brw_name <= browse2 or browse2 = "") with frame b width 90:
   display brw_mstr.brw_name brw_mstr.brw_desc brw_mstr.brw_view brw_userid
   brw_mod_date.
end.

   {mfrtrail.i}

end. /* REPEAT */
