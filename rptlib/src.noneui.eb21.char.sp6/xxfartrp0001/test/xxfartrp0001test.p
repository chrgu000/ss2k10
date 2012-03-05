/* fartrp.p RETIREMENT REPORT                                           */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.9.1.9 $                                                         */
/*V8:ConvertMode=FullGUIReport                                          */
/* REVISION: 9.1     LAST MODIFIED: 10/26/99     BY: *N021* Pat Pigatti */
/* REVISION: 9.1     LAST MODIFIED: 12/01/99     BY: *N066* P Pigatti   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00 BY: *N0L0* Jacolyn Neder    */
/* $Revision: 1.9.1.9 $    BY: Anitha Gopal          DATE: 07/29/03  ECO: *P0YH*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 091106.1 By: Bill Jiang */

/* SS - 091106.1 - RNB
[091106.1]

增加了以下输入字段:
  - 年度/期间
  
[091106.1]

SS - 091106.1 - RNE */

/* SS - 091106.1 - B */
{xxfartrp0001.i "new" }
/* SS - 091106.1 - E */

/*
{mfdtitle.i "2+ "}
*/
{mfdtitle.i "091106.1"}
{gprunpdf.i "fapl" "p"}

/* DEFINE LOCAL VARIABLES */
define variable l-asset like fa_id no-undo.
define variable l-asset1 like fa_id no-undo.
define variable l-book like fabk_id no-undo.
define variable l-book1 like fabk_id no-undo.
define variable l-loc like fa_faloc_id no-undo.
define variable l-loc1 like fa_faloc_id no-undo.
define variable l-class like fa_facls_id no-undo.
define variable l-class1 like fa_facls_id no-undo.
define variable l-entity like fa_entity no-undo.
define variable l-entity1 like fa_entity no-undo.
define variable l-retrsn like fa_disp_rsn no-undo.
define variable l-retrsn1 like fa_disp_rsn no-undo.
define variable yrPeriod like fabd_yrper no-undo.
/* SS - 091106.1 - B */
define variable yrPeriod1 like fabd_yrper no-undo.
/* SS - 091106.1 - E */
define variable nonDepr like mfc_logical label "Include Non-Depreciating Assets"
                                         no-undo.
define variable entity_ok like mfc_logical.
define variable l_error   as   integer   no-undo.

/* DEFINE RETIREMENT FORM */
form
   l-asset colon 25
   l-asset1 colon 42
   label {t001.i}
   l-book colon 25
   l-book1 colon 42
   label {t001.i}
   l-loc colon 25
   l-loc1 colon 42
   label {t001.i}
   l-class colon 25
   l-class1 colon 42
   label {t001.i}
   l-entity colon 25
   l-entity1 colon 42
   label {t001.i}
   l-retrsn colon 25
   l-retrsn1 colon 42
   label {t001.i}
   yrPeriod colon 25
   /* SS - 091106.1 - B */
   yrPeriod1 colon 42
   label {t001.i}
   /* SS - 091106.1 - E */
   nonDepr colon 40
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i &io-frame = "a"}

/* BEGIN MAINLOOP FOR RETIREMENT REPORT */
mainloop:
repeat:

   /* ALLOW LOC, CLASS, ENTITY TO BE UPDATED. */
   if l-asset1 = hi_char
   then
      l-asset1 = "".
   if l-book1 = hi_char
   then
      l-book1 = "".
   if l-loc1 = hi_char
   then
      l-loc1 = "".
   if l-class1 = hi_char
   then
      l-class1 = "".
   if l-entity1 = hi_char
   then
      l-entity1 = "".
   if l-retrsn1 = hi_char
   then
      l-retrsn1 = "".

   /* SS - 091106.1 - B
   /* ASSIGN yrPeriod TO GL PERIOD FOR TODAY'S DATE */
   {gprunp.i "fapl" "p" "fa-get-per"
      "(input  today,
        input  """",
        output yrPeriod,
        output l_error)"}

   if l_error <> 0
   then
      /* ASSIGN yrPeriod TO TODAY'S DATE */
      yrPeriod = string(year(today), "9999") +
                 string(month(today), "99").
   SS - 091106.1 - E */
   /* SS - 091106.1 - B */
   /* ASSIGN yrPeriod TO GL PERIOD FOR TODAY'S DATE */
   {gprunp.i "fapl" "p" "fa-get-per"
      "(input  today,
        input  """",
        output yrPeriod1,
        output l_error)"}

   if l_error <> 0
   then
      /* ASSIGN yrPeriod1 TO TODAY'S DATE */
      yrPeriod1 = string(year(today), "9999") +
                 string(month(today), "99").
   /* SS - 091106.1 - E */

   if c-application-mode <> "WEB"
   then
      update
         l-asset
         l-asset1
         l-book
         l-book1
         l-loc
         l-loc1
         l-class
         l-class1
         l-entity
         l-entity1
         l-retrsn
         l-retrsn1
         yrPeriod
         /* SS - 091106.1 - B */
         yrPeriod1
         /* SS - 091106.1 - E */
         nonDepr
      with frame a.

   {wbrp06.i
      &command = update
      &fields = "l-asset l-asset1 l-book l-book1 l-loc l-loc1 l-class
                 l-class1 l-entity l-entity1 l-retrsn l-retrsn1 yrPeriod
                 /* SS - 091106.1 - B */
                 yrPeriod1
                 /* SS - 091106.1 - E */
                 nonDepr"}

   if (c-application-mode <> "WEB") or
      (c-application-mode = "WEB" and
      (c-web-request begins "DATA"))
   then do:

      bcdparm = "".
      {mfquoter.i l-asset}
      {mfquoter.i l-asset1}
      {mfquoter.i l-book}
      {mfquoter.i l-book1}
      {mfquoter.i l-loc}
      {mfquoter.i l-loc1}
      {mfquoter.i l-class}
      {mfquoter.i l-class1}
      {mfquoter.i l-entity}
      {mfquoter.i l-entity1}
      {mfquoter.i l-retrsn}
      {mfquoter.i l-retrsn1}
      {mfquoter.i yrPeriod}
      /* SS - 091106.1 - B */
      {mfquoter.i yrPeriod1}
      /* SS - 091106.1 - E */
      {mfquoter.i nonDepr}

      /* SET THE UPPER LIMITS TO MAX VALUES IF BLANK. */
      if l-asset1 = ""
      then
         l-asset1 = hi_char.
      if l-asset1 < l-asset
      then
         l-asset1 = l-asset.
      if l-book1 = ""
      then
         l-book1 = hi_char.
      if l-book1 < l-book
      then
         l-book1 = l-book.
      if l-loc1 = ""
      then
         l-loc1 = hi_char.
      if l-loc1 < l-loc
      then
         l-loc1 = l-loc.
      if l-class1 = ""
      then
         l-class1 = hi_char.
      if l-class1 < l-class
      then
         l-class1 = l-class.
      if l-entity1 = ""
      then
         l-entity1 = hi_char.
      if l-entity1 < l-entity
      then
         l-entity1 = l-entity.
      if l-retrsn1 = ""
      then
         l-retrsn1 = hi_char.
      if l-retrsn1 < l-retrsn
      then
         l-retrsn1 = l-retrsn.
      /* SS - 091106.1 - B */
      if yrPeriod1 = ""
      then
         yrPeriod1 = hi_char.
      if yrPeriod1 < yrPeriod
      then
         yrPeriod1 = yrPeriod.
      /* SS - 091106.1 - E */
   end. /* c-application-mode ... */

   /* ADDS PRINTER FOR OUTPUT WITH BATCH OPTION */
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
               
   /* SS - 091106.1 - B
   /* PRINTS PAGE HEADING FOR REPORT */
   {mfphead.i}

   /* CALLS THE RETIREMENT REPORT PROGRAM */

   {gprun.i ""fartrpa.p"" "(input l-asset,
        input l-asset1,
        input l-book,
        input l-book1,
        input l-loc,
        input l-loc1,
        input l-class,
        input l-class1,
        input l-entity,
        input l-entity1,
        input l-retrsn,
        input l-retrsn1,
        input yrPeriod,
        input nonDepr)"}

   /* ADDS REPORT TRAILER */
   {mfrtrail.i}
   SS - 091106.1 - E */
   /* SS - 091106.1 - B */
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

   FOR EACH ttxxfartrp0001:
       DELETE ttxxfartrp0001.
   END.

   {gprun.i ""xxfartrp0001.p""
      "(input l-asset,
        input l-asset1,
        input l-book,
        input l-book1,
        input l-loc,
        input l-loc1,
        input l-class,
        input l-class1,
        input l-entity,
        input l-entity1,
        input l-retrsn,
        input l-retrsn1,
        input yrPeriod,
        input yrPeriod1,
        input nonDepr)"}

   EXPORT DELIMITER ";" "账目" "资产" "库位" "类型" "单位" "成本" "累计折旧额" "处置额" "盈利/亏损" "处置原因" "报废日期".
   EXPORT DELIMITER ";" "扩展输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出".
   EXPORT DELIMITER ";" "fabk_id" "fa_id" "fa_faloc_id" "fa_facls_id" "fa_entity" "fabd_peramt" "fabd_accamt" "fa_dispamt" "fabd_gainamt" "fa_disp_rsn" "fa_disp_dt".

   FOR EACH ttxxfartrp0001:
       EXPORT DELIMITER ";" ttxxfartrp0001 .
   END.

   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.
   
   {xxmfrtrail.i}
   /* SS - 091106.1 - E */
end. /*MAIN-LOOP*/
