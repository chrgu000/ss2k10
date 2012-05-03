/* xxvddrwrp - vendor drawing part reference REPORT                          */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 24YP LAST MODIFIED: 04/24/12 BY: zy expand xrc length to 120    */
/* REVISION END                                                              */

&SCOPED-DEFINE xxvddrwrp_1_1 "SUPPLIER"
&SCOPED-DEFINE xxvddrwrp_1_2 "DRAWING"
&SCOPED-DEFINE xxvddrwrp_1_3 "ITEM_NUMBER"

/* DISPLAY TITLE */
{mfdtitle.i "120503.1"}

/* CONSIGNMENT INVENTORY VARIABLES */
define variable vend1 like pt_vend no-undo.
define variable vend2 like pt_vend no-undo.
define variable draw1 like pt_draw no-undo.
define variable draw2 like pt_draw no-undo.
define variable part1 like pt_part no-undo.
define variable part2 like pt_part no-undo.

form
   skip(.1)
   vend1 colon 15 label {&xxvddrwrp_1_1}
   vend2 colon 45 label {t001.i}
   draw1 colon 15 label {&xxvddrwrp_1_2}
   draw2 colon 45 label {t001.i}
   part1 colon 15 label {&xxvddrwrp_1_3}
   part2 colon 45 label {t001.i} skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

   if vend2 = hi_char then vend2 = "".
   if draw2 = hi_char then draw2 = "".
   if part2 = hi_char then part2 = "".

   if c-application-mode <> 'web' then
      update vend1 vend2 draw1 draw2 part1 part2 with frame a.

   {wbrp06.i &command = update
             &fields = "  vend1 vend2 draw1 draw2 part1 part2"
             &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      if vend2 = "" then vend2 = hi_char.
      if draw2 = "" then draw2 = hi_char.
      if part2 = "" then part2 = hi_char.
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

   for each pt_mstr no-lock
      where (pt_part >= part1 and pt_part <= part2) and
            (pt_vend >= vend1 and pt_vend <= vend2) and pt_vend <> "" and
            (pt_draw >= draw1 and pt_draw <= draw2) and pt_draw <> ""
   with frame b width 132 no-attr-space:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      {mfrpchk.i}

      display  pt_vend pt_draw pt_part pt_desc1.
   end.

   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
