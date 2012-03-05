/* faderp.p DEPRECIATION EXPENSE REPORT                                     */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.9.1.8 $                                                         */
/*V8:ConvertMode=FullGUIReport                                              */
/* REVISION: 9.1      LAST MODIFIED: 10/26/99   BY: *N021* Pat Pigatti      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L0* Jacolyn Neder    */
/* REVISION: 9.1      LAST MODIFIED: 12/28/00   BY: *M0YX* Jose Alex        */
/* Revision: 1.9.1.7    BY: Vinod Nair        DATE: 12/21/01  ECO: *M1N8*   */
/* $Revision: 1.9.1.8 $    BY: Rajesh Lokre          DATE: 05/19/03  ECO: *N240*  */
/* $Revision: 1.9.1.8 $    BY: Bill Jiang          DATE: 01/01/06  ECO: *SS - 20060101*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20060101 - B */
{a6faderp01.i "new"}
/* SS - 20060101 - E */
   
{mfdtitle.i "2+ "}

/* DEFINE LOCAL VARIABLES */
define variable l-entity     like fa_entity   no-undo.
define variable l-entity1    like fa_entity   no-undo.
define variable l-book       like fabk_id     no-undo.
define variable l-book1      like fabk_id     no-undo.
define variable l-class      like fa_facls_id no-undo.
define variable l-class1     like fa_facls_id no-undo.
define variable l-asset      like fa_id       no-undo.
define variable l-asset1     like fa_id       no-undo.
define variable l-yrper      like fabd_yrper  no-undo.
define variable l-yrper1     like fabd_yrper  no-undo.
define variable printTot     like mfc_logical label "Print Totals Only" no-undo.
define variable entity_ok    like mfc_logical.
define variable l-ndep       like mfc_logical label "Include Non-Depr Assets"
                                              no-undo.
define variable l_printtrans like mfc_logical label "Print Transfer Details"
                                              no-undo.

/* DEFINE DEPRECIATION EXPENSE FORM */
form
   l-entity      colon 25
   l-entity1     colon 42
      label {t001.i}
   l-book        colon 25
   l-book1       colon 42
      label {t001.i}
   l-class       colon 25
   l-class1      colon 42
      label {t001.i}
   l-asset       colon 25
   l-asset1      colon 42
      label {t001.i}
   l-yrper       colon 25
   l-yrper1      colon 42
      label {t001.i}
   printTot      colon 25
   l-ndep        colon 25
   l_printtrans  colon 25
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i &io-frame = "a"}

/* BEGIN MAINLOOP FOR DEPRECIATION EXPENSE REPORT */
mainloop:
repeat:

   /* ALLOW ENTITY, BOOK, CLASS, ASSET TO BE UPDATED. */
   if l-entity1 = hi_char then l-entity1 = "".
   if l-book1   = hi_char then l-book1   = "".
   if l-class1  = hi_char then l-class1  = "".
   if l-asset1  = hi_char then l-asset1  = "".
   if l-yrper1  = hi_char then l-yrper1  = "".

   if c-application-mode <> "WEB"
   then
      update
         l-entity
         l-entity1
         l-book
         l-book1
         l-class
         l-class1
         l-asset
         l-asset1
         l-yrper
         l-yrper1
         printTot
         l-ndep
         l_printtrans
      with frame a.

   if l-yrper      = ""
      and l-yrper1 = ""
   then do:

      /* NO YR/PER VALUES ENTERED, REPORT */
      /* WILL RUN FOR ENTIRE ASSET LIFE   */
      {pxmsg.i &MSGNUM=4942 &ERRORLEVEL=2}

   end. /* IF l-yrper = "" */

   /* CHANGED yrPeriod TO l-yrper               */
   /* ADDED l-yrper1 TO &fields                 */
   /* ADDED l-ndep TO &fields AS THE LAST FIELD */
   {wbrp06.i
      &command = update
      &fields  = "l-entity l-entity1 l-book  l-book1  l-class  l-class1
                  l-asset  l-asset1  l-yrper l-yrper1 printTot l-ndep
                  l_printtrans"}

   if (c-application-mode <> "WEB")
      or (c-application-mode = "WEB"
         and (c-web-request begins "DATA"))
   then do:

      bcdparm = "".
      {mfquoter.i l-entity}
      {mfquoter.i l-entity1}
      {mfquoter.i l-book}
      {mfquoter.i l-book1}
      {mfquoter.i l-class}
      {mfquoter.i l-class1}
      {mfquoter.i l-asset}
      {mfquoter.i l-asset1}
      {mfquoter.i l-yrper}
      {mfquoter.i l-yrper1}
      {mfquoter.i printTot}
      {mfquoter.i l-ndep}
      {mfquoter.i l_printtrans}

      /* SET THE UPPER LIMITS TO MAX VALUES IF BLANK. */
      if l-entity1 = ""       then l-entity1 = hi_char.
      if l-entity1 < l-entity then l-entity1 = l-entity.
      if l-book1   = ""       then l-book1   = hi_char.
      if l-book1   < l-book   then l-book1   = l-book.
      if l-class1  = ""       then l-class1  = hi_char.
      if l-class1  < l-class  then l-class1  = l-class.
      if l-asset1  = ""       then l-asset1  = hi_char.
      if l-asset1  < l-asset  then l-asset1  = l-asset.
      if l-yrper1  = ""       then l-yrper1  = hi_char.
      if l-yrper1  < l-yrper  then l-yrper1  = l-yrper.

   end. /* c-application-mode ... */

   /* ADDS PRINTER FOR OUTPUT WITH BATCH OPTION */
   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType                = "printer"
               &printWidth               = 132
               &pagedFlag                = " "
               &stream                   = " "
               &appendToFile             = " "
               &streamedOutputToTerminal = " "
               &withBatchOption          = "yes"
               &displayStatementType     = 1
               &withCancelMessage        = "yes"
               &pageBottomMargin         = 6
               &withEmail                = "yes"
               &withWinprint             = "yes"
               &defineVariables          = "yes"}

   /* SS - 20060101 - B */
   /*
   /* PRINTS PAGE HEADING FOR REPORT */
   {mfphead.i}

   /* CHANGED NINTH INPUT PARAMETER yrPeriod TO l-yrper */
   /* ADDED TENTH INPUT PARAMETER l-yrper1              */
   /* ADDED l-ndep AS THE LAST INPUT PARAMETER          */
   /* CALLS THE DEPRECIATION EXPENSE REPORT PROGRAM     */
   {gprun.i ""faderpa.p""
      "(input l-entity,
        input l-entity1,
        input l-book,
        input l-book1,
        input l-class,
        input l-class1,
        input l-asset,
        input l-asset1,
        input l-yrper,
        input l-yrper1,
        input printTot,
        input l-ndep,
        input l_printtrans)"}

   /* ADDS REPORT TRAILER */
   {mfrtrail.i}
   */

   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

   FOR EACH tta6faderp01:
      DELETE tta6faderp01.
   END.

   {gprun.i ""a6faderp01.p""
      "(input l-entity,
        input l-entity1,
        input l-book,
        input l-book1,
        input l-class,
        input l-class1,
        input l-asset,
        input l-asset1,
        input l-yrper,
        input l-yrper1,
        input printTot,
        input l-ndep,
        input l_printtrans)"}

   EXPORT DELIMITER ";" "fabd_entity" "fabd_fabk_id" "fabd_facls_id" "fabd_fa_id" "fa_desc1" "costAmt" "accDepr" "expAmt" "netBook" "annDepr" "fa_puramt" "accDepr_adj" "expAmt_adj" "annDepr_adj".
   FOR EACH tta6faderp01:
       EXPORT DELIMITER ";" tta6faderp01.
   END.

   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

   {a6mfrtrail.i}
   /* SS - 20060101 - E */
end. /*MAIN-LOOP*/
