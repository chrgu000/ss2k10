/* xxporcldrp.p  - 采购收货报表                                              */
/* Copyright 2010 SoftSpeed gz                                               */
/* SS - 101223.1 By: zhangyun                                                */
/* REVISION: 09$5 LAST MODIFIED: 12/09/10   BY: zy                           */
/* REVISION END                                                              */

/* DISPLAY TITLE */
{mfdeclre.i}
{xxporcld.i}
{gplabel.i}
form
  skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
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
   for each tmp_pod no-lock where tpo_sel = "*"
            with frame rpt width 132 no-attr-space:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame rpt:handle).
      display  tpo_sel
               tpo_po
               tpo_line
               tpo_part
               tpo_loc
               tpo_qty_req
               tpo_qty_rc
               tpo_id
               tpo_stat
               with frame rpt.
   end.
 {mfrtrail.i}
end.

{wbrp04.i &frame-spec = a}
