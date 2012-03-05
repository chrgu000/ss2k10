/* fatrrp.p TRANSFER REPORT                                             */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.8.1.6.3.1 $                                                         */
/*V8:ConvertMode=FullGUIReport                                          */
/* REVISION: 9.1     LAST MODIFIED: 10/26/99     BY: *N021* Pat Pigatti */
/* REVISION: 9.1     LAST MODIFIED: 12/01/99     BY: *N066* P Pigatti   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00 BY: *N0L0* Jacolyn Neder    */
/* $Revision: 1.8.1.6.3.1 $    BY: Anitha Gopal          DATE: 07/28/03  ECO: *P0YH*  */
/* $Revision: 1.8.1.6.3.1 $    BY: Bill Jiang            DATE: 04/27/06  ECO: *SS - 20060505.1*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
 
/* SS - 20060505.1 - B */
{a6fatrrp01.i "new" }
/* SS - 20060505.1 - E */

{mfdtitle.i "2+ "}
{gprunpdf.i "fapl" "p"}

/* DEFINE LOCAL VARIABLES */
define variable l-asset like fa_id no-undo.
define variable l-asset1 like fa_id no-undo.
define variable l-loc like fa_faloc_id no-undo.
define variable l-loc1 like fa_faloc_id no-undo.
define variable l-class like fa_facls_id no-undo.
define variable l-class1 like fa_facls_id no-undo.
define variable l-entity like fa_entity no-undo.
define variable l-entity1 like fa_entity no-undo.
define variable yrPeriod like fabd_yrper no-undo.
define variable nonDepr like mfc_logical
   label "Include Non-Depreciating Assets" no-undo.
define variable fullDepr like mfc_logical
   label "Include Fully Depreciated Assets" no-undo.
define variable entity_ok like mfc_logical.
define variable l_error as integer   no-undo.

/* DEFINE TRANSFER FORM */
form
   l-asset colon 25
   l-asset1 colon 42
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
   yrPeriod colon 25
   nonDepr colon 40
   fullDepr colon 40
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i &io-frame = "a"}

/* BEGIN MAINLOOP FOR TRANSFER REPORT */
mainloop:
repeat:

   /* ALLOW LOC, CLASS, ENTITY TO BE UPDATED. */
   if l-asset1 = hi_char
   then
      l-asset1 = "".
   if l-loc1 = hi_char
   then
      l-loc1 = "".
   if l-class1 = hi_char
   then
      l-class1 = "".
   if l-entity1 = hi_char
   then
      l-entity1 = "".

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
   
   if c-application-mode <> "WEB"
   then
      update
         l-asset
         l-asset1
         l-loc
         l-loc1
         l-class
         l-class1
         l-entity
         l-entity1
         yrPeriod
         nonDepr
         fullDepr
      with frame a.

   {wbrp06.i
      &command = update
      &fields = "l-asset l-asset1 l-loc l-loc1 l-class l-class1
        l-entity l-entity1 yrPeriod nonDepr fullDepr"}

   if (c-application-mode <> "WEB") or
      (c-application-mode = "WEB" and
      (c-web-request begins "DATA"))
   then do:

      bcdparm = "".
      {mfquoter.i l-asset}
      {mfquoter.i l-asset1}
      {mfquoter.i l-loc}
      {mfquoter.i l-loc1}
      {mfquoter.i l-class}
      {mfquoter.i l-class1}
      {mfquoter.i l-entity}
      {mfquoter.i l-entity1}
      {mfquoter.i yrPeriod}
      {mfquoter.i nonDepr}
      {mfquoter.i fullDepr}

      /* SET THE UPPER LIMITS TO MAX VALUES IF BLANK. */
      if l-asset1 = ""
      then
         l-asset1 = hi_char.
      if l-asset1 < l-asset
      then
         l-asset1 = l-asset.
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
   end. /* c-application-mode .. */

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

      /* SS - 20060505.1 - B */
   /*
   /* PRINTS PAGE HEADING FOR REPORT */
   {mfphead.i}

   /* CALLS THE TRANSFER REPORT PROGRAM */

   {gprun.i ""fatrrpa.p""
      "(input l-asset,
        input l-asset1,
        input l-loc,
        input l-loc1,
        input l-class,
        input l-class1,
        input l-entity,
        input l-entity1,
        input yrPeriod,
        input nonDepr,
        input fullDepr)"}

   /* Adds report trailer */
   {mfrtrail.i}
   */

   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

   FOR EACH tta6fatrrp01 :
       DELETE tta6fatrrp01.
   END.

   {gprun.i ""a6fatrrp01.p""
      "(input l-asset,
        input l-asset1,
        input l-loc,
        input l-loc1,
        input l-class,
        input l-class1,
        input l-entity,
        input l-entity1,
        input yrPeriod,
        input nonDepr,
        input fullDepr)"}

   EXPORT DELIMITER ";" "fabd_faloc_id" "perdate" "fabd_fa_id" "fa_desc1" "fabd_facls_id" "fabd_entity" "costamt" "fabd_trn_loc".
   FOR EACH tta6fatrrp01 NO-LOCK:
       EXPORT DELIMITER ";" tta6fatrrp01 .
   END.

   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.
   
   {a6mfrtrail.i}
      /* SS - 20060505.1 - E */
       
end. /*MAIN-LOOP*/
   
