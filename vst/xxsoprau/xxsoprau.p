/* xxsoprau.p - sod price auid                                                */
/*V8:ConvertMode=FullGUIReport                                                */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "131211.1"}

define variable nbr like si_site.
define variable nbr1 like si_site.
define variable part like pt_part.
define variable part1 like pt_part.
define variable ln like sod_line.
define variable ln1 like sod_line initial 999.
define variable st  as integer format "9" initial 1.

define temp-table tsod
    fields tsod_id as integer.

form
   nbr  colon 16
   nbr1 colon 42 label "To"
   ln   colon 16
   ln1  colon 42 label "To" 
   part colon 15
   part1 colon 42 label "To" skip(2)
   st   colon 22 label "stat"
               "1.view"   colon 28
               "2.lock"   colon 28
               "3.unlock" colon 28
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

   if nbr1 = hi_char then nbr1 = "".
   if part1 = hi_char then part1 = "".
   if c-application-mode <> 'web' then
      update nbr nbr1 ln ln1 part part1 st with frame a.

   {wbrp06.i &command = update &fields = " nbr nbr1 ln ln1 part part1 st " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      if nbr1 = "" then nbr1 = hi_char.
      if part1 = "" then part1 = hi_char.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
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
  for each tsod exclusive-lock: delete tsod. end.
for each sod_det no-lock where sod_nbr >= nbr and sod_nbr <= nbr1 
     and sod_line >= ln and sod_line <= ln1
     and sod_part >= part and sod_part <= part1 :

     display sod_nbr sod_line sod_part sod_qty_ord sod_price.
     if st <> 1 then do:
        create tsod.
        assign tsod_id = recid(sod_det).
     end.
   {mfrtrail.i}
end.
if st <> 1 then do:
  for each tsod no-lock:
      find first sod_det exclusive-lock where recid(sod_det) = tsod_id no-error.
      if available sod_det then do:
         if st = 2 then sod__chr10 = "HD".
         if st = 3 then sod__chr10 = "".
      end.
  end.
end.
end. /*repeat frame a*/
{wbrp04.i &frame-spec = a}
