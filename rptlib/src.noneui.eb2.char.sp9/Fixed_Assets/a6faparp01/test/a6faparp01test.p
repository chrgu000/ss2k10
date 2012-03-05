/* faparp.p PERIODIC ACTIVITY REPORT                                        */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* Revision: $                                                         */
/*V8:ConvertMode=FullGUIReport                                              */
/* REVISION: 9.1      LAST MODIFIED: 10/26/99   BY: *N021* Pat Pigatti      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L0* Jacolyn Neder    */
/* Revision: $    BY: Vinod Nair            DATE: 12/24/01  ECO: *M1N8*  */
/* Revision: $    BY: Bill Jiang            DATE: 05/08/06  ECO: *SS - 20060508.1*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20060508.1 - B */
{a6faparp01.i "new"}
/* SS - 20060508.1 - E */

{mfdtitle.i "b+ "}

/* ********** BEGIN TRANSLATABLE STRINGS DEFINITION ********* */

&SCOPED-DEFINE faparp_p_1 "Print Totals Only"
/* MaxLen: 24 Comment: Determines whether to print totals */

&SCOPED-DEFINE faparp_p_2 "Include Non-Depreciating Assets"
/* MaxLen: 39 Comment: Flag to include non depreciating assets */

/* ********** END TRANSLATABLE STRINGS DEFINITION ********* */

/* DEFINE LOCAL VARIABLES */
define variable l-entity  like fa_entity  no-undo.
define variable l-entity1 like fa_entity  no-undo.
define variable l-asset   like fa_id      no-undo.
define variable l-asset1  like fa_id      no-undo.
define variable l-yrper   like fabd_yrper no-undo.
define variable l-yrper1  like fabd_yrper no-undo.
define variable printTot  like mfc_logical label {&faparp_p_1} no-undo.
define variable nonDepr   like mfc_logical label {&faparp_p_2} no-undo.
define variable entity_ok like mfc_logical.

/* DEFINE PERIODIC ACTIVITY FORM */
form
   l-entity  colon 25
   l-entity1 colon 42
      label {t001.i}
   l-asset   colon 25
   l-asset1  colon 42
      label {t001.i}
   l-yrper   colon 25
   l-yrper1  colon 42
      label {t001.i}
   printTot  colon 25
   nonDepr   colon 40
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i &io-frame = "a"}

/* BEGIN MAINLOOP FOR PERIODIC ACTIVITY REPORT */
/*MAINLOOP:*/
repeat:

   /* ALLOW ASSET, BOOK, LOC, CLASS, ENTITY TO BE UPDATED. */
   if l-entity1 = hi_char then l-entity1 = "".
   if l-asset1  = hi_char then l-asset1  = "".
   if l-yrper1  = hi_char then l-yrper1  = "".

   if c-application-mode <> "WEB" then
   update
      l-entity
      l-entity1
      l-asset
      l-asset1
      l-yrper
      l-yrper1
      printTot
      nonDepr
   with frame a.

   if l-yrper      = ""
      and l-yrper1 = ""
   then do:

      /* NO YR/PER VALUES ENTERED, REPORT */
      /* WILL RUN FOR ENTIRE ASSET LIFE   */
      {pxmsg.i &MSGNUM=4942 &ERRORLEVEL=2}

   end. /* IF l-yrper = "" */

   /* CHANGED yrPeriod TO l-yrper */
   /* ADDED l-yrper1 TO &fields   */
   {wbrp06.i
      &command = update
      &fields  = "l-entity l-entity1 l-asset l-asset1
                  l-yrper l-yrper1 printTot nonDepr"}

   if (c-application-mode <> "WEB") or
      (c-application-mode = "WEB"
       and (c-web-request begins "DATA"))
   then do:

      bcdparm = "".
      {mfquoter.i l-entity}
      {mfquoter.i l-entity1}
      {mfquoter.i l-asset}
      {mfquoter.i l-asset1}
      {mfquoter.i l-yrper}
      {mfquoter.i l-yrper1}
      {mfquoter.i printTot}
      {mfquoter.i nonDepr}

      /* SET THE UPPER LIMITS TO MAX VALUES IF BLANK.    */
      if l-entity1 = ""       then l-entity1 = hi_char.
      if l-entity1 < l-entity then l-entity1 = l-entity.
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

      /* SS - 20060508.1 - B */
      /*
   /* PRINTS PAGE HEADING FOR REPORT */
   {mfphead.i}

   /* CHANGED FIFTH INPUT PARAMETER yrPeriod TO l-yrper */
   /* ADDED SIXTH INPUT PARAMETER l-yrper1              */
   /* CALLS THE PERIODIC ACTIVITY REPORT PROGRAM        */
   {gprun.i ""faparpa.p""
      "(input l-entity,
        input l-entity1,
        input l-asset,
        input l-asset1,
        input l-yrper,
        input l-yrper1,
        input printTot,
        input nonDepr)"}

   /* ADDS REPORT TRAILER */
   {mfrtrail.i}
   */

           PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

           FOR EACH tta6faparp01:
              DELETE tta6faparp01.
           END.

           /* CHANGED FIFTH INPUT PARAMETER yrPeriod TO l-yrper */
           /* ADDED SIXTH INPUT PARAMETER l-yrper1              */
           /* CALLS THE PERIODIC ACTIVITY REPORT PROGRAM        */
           {gprun.i ""a6faparp01.p""
              "(input l-entity,
                input l-entity1,
                input l-asset,
                input l-asset1,
                input l-yrper,
                input l-yrper1,
                input printTot,
                input nonDepr)"}

           EXPORT DELIMITER ";" "enty" "fabk_id" "yrper" "asst" "assetDesc" "cost" "acqr" "trsfrs" "retmnt" "adjmnt" "endBal".
           FOR EACH tta6faparp01:
              EXPORT DELIMITER ";" tta6faparp01.
           END.

           PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

           /* ADDS REPORT TRAILER */
           {a6mfrtrail.i}
      /* SS - 20060508.1 - E */
end. /*MAIN-LOOP*/
