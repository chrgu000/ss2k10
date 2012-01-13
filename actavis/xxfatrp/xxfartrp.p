/* GUI CONVERTED from fartrp.p (converter v1.78) Fri Oct 29 14:36:32 2004 */
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


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}
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
define variable yrPeriod1 like fabd_yrper no-undo.
define variable nonDepr like mfc_logical label "Include Non-Depreciating Assets"
                                         no-undo.
define variable entity_ok like mfc_logical.
define variable l_error   as   integer   no-undo.

/* DEFINE RETIREMENT FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
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
   yrPeriod1 colon 42
   label {t001.i}
   nonDepr colon 40
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF DEFINED(GPLABEL_I)=0 &THEN
   &IF (DEFINED(SELECTION_CRITERIA) = 0)
   &THEN " Selection Criteria "
   &ELSE {&SELECTION_CRITERIA}
   &ENDIF 
&ELSE 
   getTermLabel("SELECTION_CRITERIA", 25).
&ENDIF.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i &io-frame = "a"}

/* BEGIN MAINLOOP FOR RETIREMENT REPORT */

/*GUI mainloop removed */


/*GUI*/ {mfguirpa.i true "printer" 132 " " " " " "  }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


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
      yrPeriod1= string(year(today), "9999") +
                 string(month(today), "99").

   if c-application-mode <> "WEB"
   then
      
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


   {wbrp06.i
      &command = update
      &fields = "l-asset l-asset1 l-book l-book1 l-loc l-loc1 l-class
                 l-class1 l-entity l-entity1 l-retrsn l-retrsn1 
                 yrPeriod yrPeriod1 nonDepr"}

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
      {mfquoter.i yrPeriod1}
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

   /* ADDS PRINTER FOR OUTPUT WITH BATCH OPTION */
   /* OUTPUT DESTINATION SELECTION */
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i "printer" 132 " " " " " " " " }
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:




   /* PRINTS PAGE HEADING FOR REPORT */
   {mfphead.i}

   /* CALLS THE RETIREMENT REPORT PROGRAM */

   {gprun.i ""xxfartrpa.p"" "(input l-asset,
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

   /* ADDS REPORT TRAILER */
   
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

end. /*MAIN-LOOP*/

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" l-asset l-asset1 l-book l-book1 l-loc l-loc1 l-class l-class1 l-entity l-entity1 l-retrsn l-retrsn1 yrPeriod yrPeriod1 nonDepr "} /*Drive the Report*/
