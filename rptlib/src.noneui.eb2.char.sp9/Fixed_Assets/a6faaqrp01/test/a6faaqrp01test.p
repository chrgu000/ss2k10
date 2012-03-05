/* faaqrp.p AQUISITION REPORT                                               */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* Revision: $                                                         */
/*V8:ConvertMode=FullGUIReport                                              */
/* REVISION: 9.1      LAST MODIFIED: 10/26/99   BY: *N021* Pat Pigatti      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0KW* Jacolyn Neder    */
/* Revision: $    BY: Vinod Nair            DATE: 12/24/01  ECO: *M1N8*  */
/* Revision: $    BY: Bill Jiang            DATE: 05/05/06  ECO: *SS - 20060505.1*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20060505.1 - B */
{a6faaqrp01.i "new"}
/* SS - 20060505.1 - E */
                                                                               
{mfdtitle.i "b+ "}

/* ********** BEGIN TRANSLATABLE STRINGS DEFINITION ********* */

&SCOPED-DEFINE faaqrp_p_1 "Include Non-Depreciating Assets"
/* MaxLen: 39 Comment:  Flag to include non depreciating assets */

/* ********** END TRANSLATABLE STRINGS DEFINITION ********* */

/* DEFINE LOCAL VARIABLES */
define variable l-class   like fa_facls_id no-undo.
define variable l-class1  like fa_facls_id no-undo.
define variable l-loc     like fa_faloc_id no-undo.
define variable l-loc1    like fa_faloc_id no-undo.
define variable l-entity  like fa_entity   no-undo.
define variable l-entity1 like fa_entity   no-undo.
define variable l-yrper   like fabd_yrper  no-undo.
define variable l-yrper1  like fabd_yrper  no-undo.
define variable nonDepr   like mfc_logical label {&faaqrp_p_1} no-undo.
define variable entity_ok like mfc_logical.

/* DEFINE ACQUISITION FORM */
form
   l-class   colon 25
   l-class1  colon 42
      label {t001.i}
   l-loc     colon 25
   l-loc1    colon 42
      label {t001.i}
   l-entity  colon 25
   l-entity1 colon 42
      label {t001.i}
   l-yrper   colon 25
   l-yrper1  colon 42
      label {t001.i}
   nonDepr   colon 40
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i &io-frame = "a"}

/* BEGIN MAINLOOP FOR ACQUISITION REPORT */
mainloop:
repeat:

   /* ALLOW LOC, CLASS, ENTITY TO BE UPDATED. */
   if l-class1  = hi_char then l-class1  = "".
   if l-loc1    = hi_char then l-loc1    = "".
   if l-entity1 = hi_char then l-entity1 = "".
   if l-yrper1  = hi_char then l-yrper1  = "".

   if c-application-mode <> "WEB"
   then
      update
         l-class
         l-class1
         l-loc
         l-loc1
         l-entity
         l-entity1
         l-yrper
         l-yrper1
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
      &fields  = "l-class l-class1 l-loc l-loc1 l-entity l-entity1
                  l-yrper l-yrper1 nonDepr"}

   if (c-application-mode <> "WEB")
       or (c-application-mode = "WEB"
           and (c-web-request begins "DATA"))
   then do:

      bcdparm = "".
      {mfquoter.i l-class}
      {mfquoter.i l-class1}
      {mfquoter.i l-loc}
      {mfquoter.i l-loc1}
      {mfquoter.i l-entity}
      {mfquoter.i l-entity1}
      {mfquoter.i l-yrper}
      {mfquoter.i l-yrper1}
      {mfquoter.i nonDepr}

      /* SET THE UPPER LIMITS TO MAX VALUES IF BLANK. */
      if l-class1  = ""       then l-class1  = hi_char.
      if l-class1  < l-class  then l-class1  = l-class.
      if l-loc1    = ""       then l-loc1    = hi_char.
      if l-loc1    < l-loc    then l-loc1    = l-loc.
      if l-entity1 = ""       then l-entity1 = hi_char.
      if l-entity1 < l-entity then l-entity1 = l-entity.
      if l-yrper1  = ""       then l-yrper1  = hi_char.
      if l-yrper1  < l-yrper  then l-yrper1  = l-yrper.

   end. /* c-application-web ... */

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

   /* SS - 20060505.1 - B */
   /*
   /* PRINTS PAGE HEADING FOR REPORT */
   {mfphead.i}

   /* CHANGED SEVENTH INPUT PARAMETER yrPeriod TO l-yrper */
   /* ADDED EIGHTH INPUT PARAMETER l-yrper1               */
   /* CALLS THE ACQUISITION REPORT PROGRAM                */
   {gprun.i ""faaqrpa.p""
      "(input l-class,
        input l-class1,
        input l-loc,
        input l-loc1,
        input l-entity,
        input l-entity1,
        input l-yrper,
        input l-yrper1,
        input nonDepr)"}

   /* ADDS REPORT TRAILER */
   {mfrtrail.i}
   */
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.
   
   FOR EACH tta6faaqrp01:
      DELETE tta6faaqrp01.
   END.
   
   {gprun.i ""a6faaqrp01.p""
      "(input l-class,
        input l-class1,
        input l-loc,
        input l-loc1,
        input l-entity,
        input l-entity1,
        input l-yrper,
        input l-yrper1,
        input nonDepr)"}
   
   EXPORT DELIMITER ";" "fa_facls_id" "fa_id" "fa_desc1" "fa_faloc_id" "fa_entity" "costAmt" "fa_startdt".
   FOR EACH tta6faaqrp01:
      EXPORT DELIMITER ";" tta6faaqrp01.
   END.
   
   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.
   
   {a6mfrtrail.i}
   /* SS - 20060505.1 - E */
end. /*MAIN-LOOP*/
