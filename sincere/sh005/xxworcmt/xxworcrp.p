/* xxworcmt.p -- 进仓单开单报表                                              */
/* Copyright 2010 SoftSpeed gz                                               */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* SS - 101124.1 By: zhangyun                                                */
/* 101124.1 remove expir ctrl and display pt_desc to report.              *bo*/

{xxworcmt.i}
{mfdeclre.i}
{gplabel.i}
define variable i as integer.
define variable v_qty_open like wo_qty_comp.
define variable v_qty_rct  as character format "x(22)". /*实入数（手工填写）*/
define variable v_pt_desc1 like pt_desc1.
define variable v_pt_desc2 like pt_desc2.

form v_nbr colon 30 with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat:

   if c-application-mode <> 'web' then
      update v_nbr with frame a.

   {wbrp06.i &command = update &fields = "  v_nbr" &frm = "a1"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i v_nbr}
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
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
   {xxphead.i}

   for each tt_wo no-lock break by tw_line
       with frame b1 width 132 no-attr-space no-box:
       setFrameLabels(frame b1:handle).
       find first pt_mstr no-lock where pt_domain = global_domain
             and pt_part = tw_part no-error.
       if available pt_mstr then do:
          assign v_pt_desc1 = pt_desc1
                 v_pt_desc2 = pt_desc2.
       end.
       else do:
          assign v_pt_desc1 = ""
                 v_pt_desc2 = "".
       end.
       display
          tw_line
          tw_ass_nbr format "x(14)"
          tw_wo
          tw_id
          tw_part @ v_pt_desc1
          tw_site
          tw_loc
          tw_qty_open @ v_qty_open
          v_qty_rct.
       if v_pt_desc1 <> "" then do:
          down 1.
          put v_pt_desc1 at 52.
       end.
       if v_pt_desc2 <> "" then do:
          if v_pt_desc1 = "" then do:
             down 1.
          end.
          put v_pt_desc2 at 77 skip.
       end.
     {mfrpchk.i}
   end.
 {xxrtrail.i}
end. /* (MAINLOOP) */

{wbrp04.i &frame-spec = a}
