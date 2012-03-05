/* fartrp.p RETIREMENT REPORT                                           */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.9.1.6.3.1 $                                                         */
/*V8:ConvertMode=FullGUIReport                                          */
/* REVISION: 9.1     LAST MODIFIED: 10/26/99     BY: *N021* Pat Pigatti */
/* REVISION: 9.1     LAST MODIFIED: 12/01/99     BY: *N066* P Pigatti   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00 BY: *N0L0* Jacolyn Neder    */
/* $Revision: 1.9.1.6.3.1 $    BY: Anitha Gopal          DATE: 07/28/03  ECO: *P0YH*  */
/* $Revision: 1.9.1.6.3.1 $    BY: Bill Jiang          DATE: 04/19/06  ECO: *SS - 20060419.1*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20060419.1 - B */
/*
{mfdtitle.i "2+ "}
   */
   
define input parameter i_l-asset  like fa_id       .
define input parameter i_l-asset1 like fa_id       .
define input parameter i_l-book   like fabk_id     .
define input parameter i_l-book1  like fabk_id     .
define input parameter i_l-loc    like fa_faloc_id .
define input parameter i_l-loc1   like fa_faloc_id .
define input parameter i_l-class  like fa_facls_id .
define input parameter i_l-class1 like fa_facls_id .
define input parameter i_l-entity like fa_entity   .
define input parameter i_l-entity1 like fa_entity  .
define input parameter i_l-retrsn  like fa_disp_rsn .
define input parameter i_l-retrsn1 like fa_disp_rsn .
define input parameter i_yrPeriod  like fabd_yrper  .
define input parameter i_nonDepr   like mfc_logical .
   
   {a6fartrp01.i}

   {a6mfdtitle.i "2+ "}
   /* SS - 20060419.1 - E */

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
define variable nonDepr like mfc_logical label "Include Non-Depreciating Assets"
                                         no-undo.
define variable entity_ok like mfc_logical.
define variable l_error as integer   no-undo.

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
   nonDepr colon 40
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
/* SS - 20060419.1 - B */
/*
setFrameLabels(frame a:handle).
*/
l-asset   = i_l-asset  .
l-asset1  = i_l-asset1 .
l-book    = i_l-book   .
l-book1   = i_l-book1  .
l-loc     = i_l-loc    .
l-loc1    = i_l-loc1   .
l-class   = i_l-class  .
l-class1  = i_l-class1  .
l-entity  = i_l-entity  .
l-entity1 = i_l-entity1 .
l-retrsn  = i_l-retrsn  .
l-retrsn1 = i_l-retrsn1 .
yrPeriod  = i_yrPeriod  .
nonDepr   = i_nonDepr   .
/* SS - 20060419.1 - E */

{wbrp01.i &io-frame = "a"}

   /* SS - 20060419.1 - B */
   /*
/* BEGIN MAINLOOP FOR RETIREMENT REPORT */
mainloop:
repeat:
   */
   /* SS - 20060419.1 - E */

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

   /* SS - 20060419.1 - B */
   /*
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
         nonDepr
      with frame a.

   {wbrp06.i
      &command = update
      &fields = "l-asset l-asset1 l-book l-book1 l-loc l-loc1 l-class
        l-class1 l-entity l-entity1 l-retrsn l-retrsn1 yrPeriod
        nonDepr"}
      */
      /* SS - 20060419.1 - E */

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
   end. /* c-application-mode ... */

   /* SS - 20060419.1 - B */
   /*
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

   /* PRINTS PAGE HEADING FOR REPORT */
   {mfphead.i}

   /* CALLS THE RETIREMENT REPORT PROGRAM */

   {gprun.i ""fartrpa.p""
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
        input nonDepr)"}

   /* ADDS REPORT TRAILER */
   {mfrtrail.i}
end. /*MAIN-LOOP*/
   */
   /* CALLS THE RETIREMENT REPORT PROGRAM */

   {gprun.i ""a6fartrp01a.p""
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
        input nonDepr)"}
   /* SS - 20060419.1 - E */
