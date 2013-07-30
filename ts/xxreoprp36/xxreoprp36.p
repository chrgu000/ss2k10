/* reoprp36.p - REPETITIVE OPERATIONS BY WORK CENTER REPORT                   */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.5.1.9 $                                                       */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: WUG *GN77*                */
/* REVISION: 7.3      LAST MODIFIED: 01/05/95   BY: cpp *FT95*                */
/* REVISION: 7.3      LAST MODIFIED: 03/01/95   BY: WUG *G0G3*                */
/* REVISION: 7.3    LAST MODIFIED: 07/02/96 BY: *G1Z2* Julie Milligan         */
/* REVISION: 8.6    LAST MODIFIED: 10/22/97     BY: ays *K14L*                */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 05/04/00   BY: *N09M* Inna Lyubarsky     */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.5.1.5     BY: Hualin Zhong         DATE: 05/30/01  ECO: *N0YY* */
/* Revision: 1.5.1.6     BY: Manisha Sawant       DATE: 08/20/01  ECO: *P01N* */
/* Revision: 1.5.1.7  BY: Narathip W. DATE: 05/04/03 ECO: *P0R5* */
/* $Revision: 1.5.1.9 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/****************************************************************************** 
 * 注意：此程序是CHAR版的程序，需要做转换才能在GUI使用
 ******************************************************************************/
/* DISPLAY TITLE */
{mfdtitle.i "130730.1"}
{cxcustom.i "REOPRP36.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE reoprp36_p_4 "Qty!Processed"
/* MaxLen: Comment: */

&SCOPED-DEFINE reoprp36_p_5 "Qty!Reworked"
/* MaxLen: Comment: */

&SCOPED-DEFINE reoprp36_p_6 "Qty!Moved"
/* MaxLen: Comment: */

&SCOPED-DEFINE reoprp36_p_7 "Qty!Rejected"
/* MaxLen: Comment: */

&SCOPED-DEFINE reoprp36_p_8 "Qty!Scrapped"
/* MaxLen: Comment: */

&SCOPED-DEFINE reoprp36_p_14 "Act Hrs"
/* MaxLen: Comment: */

&SCOPED-DEFINE reoprp36_p_15 "Include Nonmilestone Operations"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*CHANGE VARIABLES TO HAVE no-undo STATUS */
define variable wkctr like wc_wkctr no-undo.
define variable wkctr1 like wc_wkctr no-undo.
define variable mch like wr_mch no-undo.
define variable mch1 like wr_mch no-undo.
define variable emp like op_emp no-undo.
define variable emp1 like op_emp no-undo.
define variable part like op_part no-undo.
define variable part1 like op_part no-undo.
define variable opdate like op_date no-undo.
define variable opdate1 like op_date no-undo.
define variable shift like op_shift no-undo.
define variable op_qty_scrap like op_qty_comp no-undo.
define variable op_qty_move like op_qty_comp no-undo.
define variable include_nonmilestone like mfc_logical
   label {&reoprp36_p_15} no-undo.
define variable act-hrs like op_act_run no-undo.
define variable act-hrs-sub like act-hrs no-undo.
{&REOPRP36-P-TAG1}
define variable act-hrs-tot like act-hrs no-undo.

{&REOPRP36-P-TAG2}
form
   wkctr     colon 20      wkctr1    label {t001.i} colon 49
   mch       colon 20      mch1      label {t001.i} colon 49
   opdate    colon 20      opdate1   label {t001.i} colon 49
   emp       colon 20      emp1      label {t001.i} colon 49
   part      colon 20      part1     label {t001.i} colon 49
   shift     colon 20
   skip(1)
   include_nonmilestone        colon 35
with frame a side-labels width 80 attr-space.
{&REOPRP36-P-TAG3}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
   if wkctr1 = hi_char then wkctr1 = "".
   if mch1 = hi_char then mch1 = "".
   if opdate = low_date then opdate = ?.
   if opdate1 = hi_date then opdate1 = ?.
   if emp1 = hi_char then emp1 = "".
   if part1 = hi_char then part1 = "".
   {&REOPRP36-P-TAG4}

   if c-application-mode <> 'web' then
   {&REOPRP36-P-TAG5}
   update
      wkctr
      wkctr1
      mch
      mch1
      opdate
      opdate1
      emp
      emp1
      part
      part1
      shift
      include_nonmilestone
   with frame a.

   {wbrp06.i &command = update
             &fields = "  wkctr wkctr1 mch mch1 opdate
                        opdate1 emp emp1 part part1 shift include_nonmilestone"
             &frm = "a"}
   {&REOPRP36-P-TAG6}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i wkctr  }
      {mfquoter.i wkctr1 }
      {mfquoter.i mch    }
      {mfquoter.i mch1   }
      {mfquoter.i opdate }
      {mfquoter.i opdate1}
      {mfquoter.i emp    }
      {mfquoter.i emp1   }
      {mfquoter.i part   }
      {mfquoter.i part1  }
      {&REOPRP36-P-TAG7}
      {mfquoter.i shift  }
      {mfquoter.i include_nonmilestone}

      if wkctr1 = "" then wkctr1 = hi_char.
      if mch1 = "" then mch1 = hi_char.
      if opdate = ? then opdate = low_date.
      if opdate1 = ? then opdate1 = hi_date.
      if emp1 = "" then emp1 = hi_char.
      if part1 = "" then part1 = hi_char.
      {&REOPRP36-P-TAG8}

   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 142
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

   {mfphead.i}

   form
      skip
   with frame skip1 width 142 page-top.

   view frame skip1.

   if shift > "" then do:
      form header
         getTermLabelRtColon("SHIFT",10) format "x(10)"
         shift
      with frame shift width 142 no-attr-space page-top.
      view frame shift.
   end.

   act-hrs-tot = 0.

   for each op_hist  where op_hist.op_domain = global_domain and (  (op_wkctr
   >= wkctr and op_wkctr <= wkctr1)
         and (op_mch >= mch and op_mch <= mch1)
         and (op_date >= opdate and op_date <= opdate1)
         and (op_emp >= emp and op_emp <= emp1)
         and (op_part >= part and op_part <= part1)
         and (op_shift = shift or shift = "")
         {&REOPRP36-P-TAG9}
         and (include_nonmilestone or op_milestone)
         ) use-index op_date no-lock
         break by op_wkctr by op_mch by op_date
         by op_part by op_wo_op by op_emp by op_trnbr
         {&REOPRP36-P-TAG10}
      with frame f_op width 142 no-box.
      {&REOPRP36-P-TAG11}

      setFrameLabels(frame f_op:handle). /* SET EXTERNAL LABELS */

      if first-of(op_mch) then do:
         if page-size - line-counter < 4 then page.
         display.

         put {gplblfmt.i &FUNC=getTermLabel(""WORK_CENTER"",15)
                         &CONCAT="': '"} op_wkctr " "
            {gplblfmt.i &FUNC=getTermLabel(""MACHINE"",14)
                        &CONCAT="': '"} op_mch.

         find wc_mstr  where wc_mstr.wc_domain = global_domain and  wc_wkctr =
         op_wkctr and wc_mch = op_mch
            no-lock no-error.
         if available wc_mstr then

         put
            wc_desc
            " "
            {gplblfmt.i &FUNC=getTermLabel(""DEPARTMENT"",20)
                        &CONCAT="': '"}
            wc_dept.
         put skip(1).
         assign act-hrs-sub = 0.
      end.

      assign
         op_qty_scrap = op__dec01
         op_qty_move = op_qty_wip.

      if op_type = "setup" then
         act-hrs = op_act_setup.
      else act-hrs = op_act_run.

      {&REOPRP36-P-TAG12}
      assign act-hrs-sub = act-hrs-sub + act-hrs.
      {&REOPRP36-P-TAG13}
      find first lnd_det no-lock where lnd_domain = global_domain
             and lnd_line = op_wkctr and lnd_site = "TS"
             and lnd_part = op_part and lnd_start <= today no-error.
      display
         op_date
         op_part
         op_wo_op      format ">>>>9"
         op_emp
         op_qty_comp   column-label {&reoprp36_p_4}
         op_qty_move   column-label {&reoprp36_p_6}
         op_qty_rjct   column-label {&reoprp36_p_7}
         op_qty_scrap  column-label {&reoprp36_p_8} format "->>>>,>>9.9<<<<<<"
         op_qty_rwrk   column-label {&reoprp36_p_5} format "->>>>,>>9.9<<<<<<"
         act-hrs       column-label {&reoprp36_p_14}
         op_type
         op_trnbr      format ">>>>>>>9"
         lnd_run when available lnd_det.
      {&REOPRP36-P-TAG14}
      accumulate op_qty_comp (total by op_mch).
      accumulate op_qty_move (total by op_mch).
      accumulate op_qty_rjct (total by op_mch).
      accumulate op_qty_scrap (total by op_mch).
      accumulate op_qty_rwrk (total by op_mch).
      accumulate op_act_run (total by op_mch).
      accumulate op_act_setup (total by op_mch).

      if last-of (op_mch) then do:
         if page-size - line-counter < 2 then page.

         underline
            op_qty_comp
            op_qty_move
            op_qty_rjct
            op_qty_scrap
            op_qty_rwrk
            act-hrs.

         down 1.

         display
            getTermLabel("TOTAL",10) + ":" format "x(11)" @ op_part
            accum total by op_mch op_qty_comp @ op_qty_comp
            accum total by op_mch op_qty_move @ op_qty_move
            accum total by op_mch op_qty_rjct @ op_qty_rjct
            accum total by op_mch op_qty_scrap @ op_qty_scrap
            accum total by op_mch op_qty_rwrk @ op_qty_rwrk
            act-hrs-sub @ act-hrs.

         down 1.

         display
            getTermLabel("ACTUAL_RUN",9) + ":" format "x(10)" @ op_part
            accum total by op_mch op_act_run @ act-hrs.
         down 1.

         display
            getTermLabel("ACTUAL_SETUP",11) + ":" format "x(12)" @ op_part
            accum total by op_mch op_act_setup @ act-hrs.
         act-hrs-tot = act-hrs-tot + act-hrs-sub.
      end.

      if last (op_mch) then do:
         if page-size - line-counter < 3 then page.

         underline
            op_qty_comp
            op_qty_move
            op_qty_rjct
            op_qty_scrap
            op_qty_rwrk
            act-hrs.

         down 1.

         display
            getTermLabel("REPORT_TOTAL",17) + ":" format "x(17)" @ op_part
            accum total op_qty_comp @ op_qty_comp
            accum total op_qty_move @ op_qty_move
            accum total op_qty_rjct @ op_qty_rjct
            accum total op_qty_scrap @ op_qty_scrap
            accum total op_qty_rwrk @ op_qty_rwrk
            act-hrs-tot @ act-hrs.

         down 1.

         display
            getTermLabel("ACTUAL_RUN",9) + ":"
            format "x(10)" @ op_part
            accum total op_act_run @ act-hrs.
         down 1.

         display
            getTermLabel("ACTUAL_SETUP",11) + ":"
            format "x(12)" @ op_part
            accum total op_act_setup @ act-hrs.
      end.

      {mfrpchk.i}
   end.

   hide frame shift.

   /* REPORT TRAILER */
   {mfrtrail.i}
end.

{wbrp04.i &frame-spec = a}
