/* xxswotrrp.p  - 委外调拨单打印                                             */
/* Copyright 2010 SoftSpeed gz                                               */
/* SS - 101223.1 By: zhangyun                                                */
/* REVISION: 09$5 LAST MODIFIED: 12/09/10   BY: zy                           */
/* REVISION END                                                              */

/* DISPLAY TITLE */
{mfdeclre.i}
{xxswotrv.i}
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
{xxphead.i "st"}
   for each tmp_powoin no-lock where tpwi_sel = "*" and tpwi_stat
            with frame rpt width 132 no-attr-space:
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame rpt:handle).
      display tpwi_po
              tpwi_lot
              tpwi_part
              tpwi_desc1
              tpwi_um
              tpwi_fsite
              tpwi_floc
              tpwi_tloc
              tpwi_eff_dte
              tpwi_qty_tr with frame rpt.
   end.
 {xxrtrail.i "st"}
end.

{wbrp04.i &frame-spec = a}
