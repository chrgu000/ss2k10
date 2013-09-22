/*V8:ConvertMode=FullGUIReport                                               */

{mfdtitle.i "130812.1"}
define variable part      like pt_part.
define variable part1     like pt_part.
define variable added     as date.
define variable added1    as date.
define variable ptadded   as date.
define variable ptadded1  as date.
define variable dsgngrp   like pt_dsgn_grp.
define variable dsgngrp1  like pt_dsgn_grp.
define variable var_pmc_days like xapt_pmc_days.
define variable var_pur_days like xapt_pur_days.
define variable var_eng_days like xapt_eng_days.
define variable var_doc_days like xapt_doc_days.
define variable var_fin_days like xapt_fin_days.
define variable var_tot_days as   integer.
define variable var_pmc_noconf like mfc_logical initial No.
define variable var_pur_noconf like mfc_logical initial No.
define variable var_eng_noconf like mfc_logical initial No.
define variable var_doc_noconf like mfc_logical initial No.
define variable var_fin_noconf like mfc_logical initial No.
define variable var_pm_code like pt_pm_code.
define variable var_cst     as logical.
define variable var_routing as character format "x(4)".
define variable n           as integer.
define variable talb        AS character FORMAT "x(60)".
define variable cSpec as char FORMAT "x(64)" EXTENT 18 no-undo.
form
   part    colon 16 part1    colon 40 label {t001.i}
   added   colon 16 added1   colon 40 label {t001.i}
   ptadded colon 16 ptadded1 colon 40 label {t001.i}
   dsgngrp colon 16 dsgngrp1 colon 40 label {t001.i} skip(2)

   var_pmc_noconf colon 16 var_pur_noconf colon 40
   var_eng_noconf colon 16 var_doc_noconf colon 40
   var_fin_noconf colon 16
   skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

   if part1 = hi_char then part1 = "".
   if added = low_date then added = ?.
   if added1 = hi_date then added1 = ?.
   if ptadded = low_date then ptadded = ?.
   if ptadded1 = hi_date then ptadded1 = ?.
   if dsgngrp1 = hi_char then dsgngrp1 = "".

   if c-application-mode <> 'web' then
      update part part1 added added1 ptadded ptadded1 dsgngrp dsgngrp1
             var_pmc_noconf var_pur_noconf var_eng_noconf
             var_doc_noconf var_fin_noconf with frame a.

   {wbrp06.i &command = update
             &fields = " part part1 added added1 ptadded ptadded1 dsgngrp dsgngrp1
                         var_pmc_noconf var_pur_noconf var_eng_noconf
                         var_doc_noconf var_fin_noconf
                        " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      if part1 = "" then part1 = hi_char.
      if added = ? then added = low_date.
      if added1 = ? then added1 = hi_date.
      if ptadded = ? then ptadded = low_date.
      if ptadded1 = ? then ptadded1 = hi_date.
      if dsgngrp1 = "" then dsgngrp1 = hi_char.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 320
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

for each xapt_aud no-lock where xapt_part >= part
               and (xapt_part <= part1 or part1 = "")
               and (xapt_added >= added or added = ?)
               and (xapt_added <= added1 or added1 = ?)
               and (xapt_adm_date = ?)
               and ((xapt_pmc_date = ? and var_pmc_noconf) or (not var_pmc_noconf))
               and ((xapt_pur_date = ? and var_pur_noconf) or (not var_pur_noconf))
               and ((xapt_eng_date = ? and var_eng_noconf) or (not var_eng_noconf))
               and ((xapt_doc_date = ? and var_doc_noconf) or (not var_doc_noconf))
               and ((xapt_fin_date = ? and var_fin_noconf) or (not var_fin_noconf))
   ,each pt_mstr no-lock where pt_part = xapt_part
               and pt_dsgn_grp >= dsgngrp
               and (pt_dsgn_grp <= dsgngrp1 or dsgngrp1 = "")
               and (pt_added >= ptadded or ptadded = ?)
               and (pt_added <= ptadded1 or ptadded1 = ?)
               and pt_stat <> "AC"
   with frame b width 320 no-attr-space:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).
      var_pm_code = pt_pm_code.
      var_cst = no.
      if pt_routing <> "" then do:
         assign var_routing = pt_routing.
      end.
      else do:
         assign var_routing = pt_part.
      end.
      if pt_site = "VST2" then do:
         find first ptp_det no-lock where ptp_part = pt_part
                and ptp_site = pt_site no-error.
         if available ptp_det then do:
            assign var_pm_code = ptp_pm_code.
            if ptp_routing <> "" then do:
               assign var_routing = ptp_routing.
            end.
            else do:
               assign var_routing = ptp_part.
            end.
         end.
      end.
      if var_pm_code = "M" then do:
         find first ro_det no-lock where ro_routing = var_routing
                and (ro_start <= today or ro_start = ?) no-error.
         if available ro_det then do:
            assign var_routing = "OK".
         end.
         else do:
            assign var_routing = "Err".
         end.
      end.
      else do:
         var_routing = var_pm_code.
      end.
      find first sct_det no-lock where sct_sim = "Standard" and sct_part = pt_part
             and sct_site = pt_site no-error.
      if available sct_det and sct_cst_tot <> 0 then do:
         assign var_cst = yes.
      end.
      if xapt_pmc_days = ? then assign var_pmc_days = today - xapt_added.
                           else assign var_pmc_days = xapt_pmc_days.
      if xapt_pur_days = ? then assign var_pur_days = today - xapt_added.
                           else assign var_pur_days = xapt_pur_days.
      if xapt_eng_days = ? then assign var_eng_days = today - xapt_added.
                           else assign var_eng_days = xapt_eng_days.
      if xapt_doc_days = ? then assign var_doc_days = today - xapt_added.
                           else assign var_doc_days = xapt_doc_days.
      if xapt_fin_days = ? then do:
                                assign var_fin_days = today - xapt_added
                                       var_tot_days = 0.
                           end.
                           else do:
                                assign var_fin_days = xapt_fin_days
                                       var_tot_days = xapt_fin_date - xapt_added.
                           end.
      talb = ''.
      {xxgetspec.i pt_part 64 cSpec 18 hi_date hi_date}.
      REPEAT n = 1 to 18:
         IF trim(cSpec[n])<>"" then talb = talb + cSpec[n].
      end.
      display xapt_part pt_site format "x(4)"
              pt_dsgn_grp pt_desc1 talb var_pm_code pt_um
              pt_draw format "x(12)" pt_added
              pt_status format "x(3)" xapt_added var_cst
              var_routing format "x(4)"
              xapt_pmc_date var_pmc_days format "->>9"
              xapt_pur_date var_pur_days format "->>9"
              xapt_eng_date var_eng_days format "->>9"
              xapt_doc_date var_doc_days format "->>9"
              xapt_fin_date var_fin_days format "->>9"
              var_tot_days format "->>9".
       {mfrpchk.i}
   end.
   {mfrtrail.i}
end.

{wbrp04.i &frame-spec = a}
