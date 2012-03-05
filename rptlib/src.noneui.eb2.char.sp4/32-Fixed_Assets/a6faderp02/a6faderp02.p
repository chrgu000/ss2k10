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
/* $Revision: 1.9.1.8 $    BY: Bill Jiang          DATE: 12/31/05  ECO: *SS - 20051231*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20051231 - B */
define input parameter i_l-entity     like fa_entity   .
define input parameter i_l-entity1    like fa_entity   .
define input parameter i_l-book       like fabk_id     .
define input parameter i_l-book1      like fabk_id     .
define input parameter i_l-class      like fa_facls_id .
define input parameter i_l-class1     like fa_facls_id .
define input parameter i_l-asset      like fa_id       .
define input parameter i_l-asset1     like fa_id       .
define input parameter i_l-yrper      like fabd_yrper  .
define input parameter i_l-yrper1     like fabd_yrper  .
define input parameter i_printTot     like mfc_logical .
define input parameter i_l-ndep       like mfc_logical .
define input parameter i_l_printtrans like mfc_logical .
/*
{mfdtitle.i "2+ "}
*/
{a6mfdtitle.i "2+ "}
/* SS - 20051231 - E */

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
/* SS - 20051231 - B */
/*
setFrameLabels(frame a:handle).
*/
l-entity = i_l-entity.
l-entity1 = i_l-entity1.
l-book = i_l-book.
l-book1 = i_l-book1.
l-class = i_l-class.
l-class1 = i_l-class1.
l-asset = i_l-asset.
l-asset1 = i_l-asset1.
l-yrper = i_l-yrper.
l-yrper1 = i_l-yrper1.
printTot = i_printTot.
l-ndep = i_l-ndep.
l_printtrans = i_l_printtrans.
/* SS - 20051231 - E */

{wbrp01.i &io-frame = "a"}

/* BEGIN MAINLOOP FOR DEPRECIATION EXPENSE REPORT */
/* SS - 20051231 - B */
/*
mainloop:
repeat:
*/
/* SS - 20051231 - E */

   /* ALLOW ENTITY, BOOK, CLASS, ASSET TO BE UPDATED. */
   if l-entity1 = hi_char then l-entity1 = "".
   if l-book1   = hi_char then l-book1   = "".
   if l-class1  = hi_char then l-class1  = "".
   if l-asset1  = hi_char then l-asset1  = "".
   if l-yrper1  = hi_char then l-yrper1  = "".

   /* SS - 20051231 - B */
   /*
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
   */
   /* SS - 20051231 - E */

   if l-yrper      = ""
      and l-yrper1 = ""
   then do:

      /* NO YR/PER VALUES ENTERED, REPORT */
      /* WILL RUN FOR ENTIRE ASSET LIFE   */
      {pxmsg.i &MSGNUM=4942 &ERRORLEVEL=2}

   end. /* IF l-yrper = "" */

   /* SS - 20051231 - B */
   /*
   /* CHANGED yrPeriod TO l-yrper               */
   /* ADDED l-yrper1 TO &fields                 */
   /* ADDED l-ndep TO &fields AS THE LAST FIELD */
   {wbrp06.i
      &command = update
      &fields  = "l-entity l-entity1 l-book  l-book1  l-class  l-class1
                  l-asset  l-asset1  l-yrper l-yrper1 printTot l-ndep
                  l_printtrans"}
   */
   /* SS - 20051231 - E */

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

   /* SS - 20051231 - B */
   /*
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

   /* PRINTS PAGE HEADING FOR REPORT */
   {mfphead.i}
   */
   define variable l_textfile        as character no-undo.
   /* SS - 20051231 - E */

   /* SS - 20051231 - B */
   /*
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
   {gprun.i ""a6faderpa02.p""
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
   /* SS - 20051231 - E */

/* SS - 20051231 - B */
/*
end. /*MAIN-LOOP*/
*/
/* SS - 20051231 - E */
