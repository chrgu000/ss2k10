/* xxlwnrp.p - line work time report                                         */
/* revision: 110818.1   created on: 20110818   by: zhang yun                 */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1C04  QAD:eb21sp7    Interface:Character         */
/*-Revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "111031.1"}

define variable effdt as date.
define variable effdt1 as date.
define variable line like ln_line.
define variable line1 like ln_line.
define variable qtytmp like wod_qty_iss.
define variable qtychk like wod_qty_iss.
define variable unitconsumed as decimal format "->>>,>>9.9<".
define temp-table tmp_wo
       fields two_par like pt_part
       fields two_qty_op  like wod_qty_iss
       fields two_part like pt_part
       fields two_line like ln_line
       fields two_qty_iss like wod_qty_iss
       fields two_qty_chk like wod_qty_iss
       index two_par two_par two_part.

/* SELECT FORM */
form
   effdt colon 15
   effdt1 label {t001.i} colon 39
   line  colon 15
   line1 label {t001.i} colon 39 skip(1)
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */

{wbrp01.i}
repeat:

   if line1 = hi_char then line1 = "".
   if effdt = low_date then effdt = ?.
   if effdt1 = hi_date then effdt1 = ?.

   if c-application-mode <> 'web' then
      update effdt effdt1 line line1 with frame a.

   {wbrp06.i &command = update
      &fields = " effdt effdt1 line line1" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i effdt  }
      {mfquoter.i effdt1 }
      {mfquoter.i line   }
      {mfquoter.i line1  }

      if line1 = "" then line1 = hi_char.
      if effdt = ? then effdt = low_date.
      if effdt1 = ? then effdt1 = hi_date.

   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 240
               &pagedFlag = "nopage"
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
   {mfphead.i}
	 empty temp-table tmp_wo no-error.
   for each tr_hist
            fields(tr_part tr_effdate tr_type tr_qty_loc tr_qty_chg tr_rmks)
            use-index tr_type
            no-lock where tr_type = "iss-wo" and
            tr_effdate >= effdt and (tr_effdate <= effdt1 or effdt1 = ?) and
            tr_qty_chg <> 0,
       each wo_mstr fields(wo_lot wo_line wo_part)
            no-lock where wo_lot = tr_lot and
            wo_line >= line and (wo_line <= line1 or line1 = "")
            break by wo_line by wo_part by tr_part:
       if first-of(tr_part) then do:
          assign qtytmp = 0
                 qtychk = 0.
       end.
       if tr_rmks = "" then do:
          assign qtytmp = qtytmp + tr_qty_loc.
       end.
       else do:
          assign qtychk = qtychk + tr_qty_loc.
       end.
       if last-of(tr_part) then do:
          find first tmp_wo no-lock where two_par = wo_part and
                     two_part = tr_part no-error.
          if not available tmp_wo then do:
             create tmp_wo.
             assign two_line = wo_line
                    two_par = wo_part
                    two_part = tr_part.
          end.
          assign two_qty_iss = qtytmp * -1
                 two_qty_chk = qtychk * -1.
       end.
   end. /* for each tr_hist */

   for each op_hist no-lock where op_date >= effdt and
            (op_date <= effdt1 or effdt1 = ?) and
            op_line >= line and (op_line <= line1 or line1 = "")
            break by op_line by op_part:
       if first-of(op_part) then do:
          assign qtytmp = 0.
       end.
       assign qtytmp = qtytmp + op_qty_comp.
       if last-of(op_part) then do:
          for each tmp_wo exclusive-lock where two_line = op_line and
                   two_par = op_part:
              assign two_qty_op = qtytmp.
          end.
       end.
   end.

   export delimiter "~011" getTermLabel("DRAWING_NUMBER",12)
                           getTermLabel("QTY_RECIVED",12)
                           getTermLabel("PART_DRAWING",12)
                           getTermLabel("PART_NAME",12)
                           getTermLabel("QTY_CONSUMED",12)
                           getTermLabel("QTY_CHK_CONSUMED",12)
                           getTermLabel("UNIT_CONSUMED",12)
                           getTermLabel("REASONS",12).


   for each tmp_wo no-lock,each pt_mstr no-lock where pt_part = two_part:
   		 if  two_qty_iss <> 0 then unitconsumed = two_qty_op / two_qty_iss.
   		                     else unitconsumed = 0.
       export delimiter "~011" two_par two_qty_op  two_part pt_desc1
              two_qty_iss two_qty_chk unitconsumed.
   end.

   /* REPORT TRAILER  */
  {mfrtrail.i}
end.

{wbrp04.i &frame-spec = a}
