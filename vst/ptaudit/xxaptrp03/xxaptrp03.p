/*V8:ConvertMode=FullGUIReport                                               */

{mfdtitle.i "130720.1"}
define variable part      like pt_part.
define variable part1     like pt_part.
define variable added     like pt_added.
define variable added1    like pt_added.
define variable dsgngrp   like pt_dsgn_grp.
define variable dsgngrp1  like pt_dsgn_grp.
define variable convdate  as   date.
define variable convdate1 as   date.
define variable var_pmc_days like xapt_pmc_days.
define variable var_pur_days like xapt_pur_days.
define variable var_eng_days like xapt_eng_days.
define variable var_doc_days like xapt_doc_days.
define variable var_fin_days like xapt_fin_days.

form
   part    colon 16 part1    colon 40 label {t001.i}
   added   colon 16 added1   colon 40 label {t001.i}
   dsgngrp colon 16 dsgngrp1 colon 40 label {t001.i}
   convdate colon 16 convdate1 colon 40 label {t001.i}
    skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

   if part1 = hi_char then part1 = "".
   if added = low_date then added = ?.
   if added1 = hi_date then added1 = ?.
   if convdate = low_date then convdate = ?.
   if convdate1 = hi_date then convdate1 = ?.
   if dsgngrp1 = hi_char then dsgngrp1 = "".

   if c-application-mode <> 'web' then
      update part part1 added added1 dsgngrp dsgngrp1 convdate convdate1 with frame a.

   {wbrp06.i &command = update &fields = " part part1 added added1 dsgngrp dsgngrp1 convdate convdate1" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      if part1 = "" then part1 = hi_char.
      if added = ? then added = low_date.
      if added1 = ? then added1 = hi_date.
      if convdate = ?  then convdate = low_date.
      if convdate1 = ? then convdate1 = hi_date.
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
               and (xapt_adm_date >= convdate or convdate = ?)
               and (xapt_adm_date <= convdate1 or convdate1 = ?)
   ,each pt_mstr no-lock where pt_part = xapt_part
               and pt_dsgn_grp >= dsgngrp
               and (pt_dsgn_grp <= dsgngrp1 or dsgngrp1 = "")
   with frame b width 320 no-attr-space:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      if xapt_pmc_days = ? then assign var_pmc_days = today - xapt_added.
                           else assign var_pmc_days = xapt_pmc_days.
      if xapt_pur_days = ? then assign var_pur_days = today - xapt_added.
                           else assign var_pur_days = xapt_pur_days.
      if xapt_eng_days = ? then assign var_eng_days = today - xapt_added.
                           else assign var_eng_days = xapt_eng_days.
      if xapt_doc_days = ? then assign var_doc_days = today - xapt_added.
                           else assign var_doc_days = xapt_doc_days.
      if xapt_fin_days = ? then assign var_fin_days = today - xapt_added.
                           else assign var_fin_days = xapt_fin_days.

      {mfrpchk.i}
      display xapt_part pt_site format "x(4)"
              pt_dsgn_grp pt_desc1 pt_pm_code pt_um
              pt_draw format "x(12)" 
              pt_added pt_status format "x(3)" xapt_added
              xapt_pmc_date var_pmc_days format "->>9"
              xapt_pur_date var_pur_days format "->>9"
              xapt_eng_date var_eng_days format "->>9"
              xapt_doc_date var_doc_days format "->>9"
              xapt_fin_date var_fin_days format "->>9"
              xapt_adm_date.
   end.
   {mfrtrail.i}
end.

{wbrp04.i &frame-spec = a}
