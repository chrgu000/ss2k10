/* GUI CONVERTED from yyderp.p (converter v1.75) Mon May 25 16:15:59 2009 */
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
/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 08/20/12  ECO: *SS-20120821.1*   */
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

{mfdtitle.i "120821.1"}

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
define variable l-yrper1     like fabd_yrper  label "Period " no-undo.
 define variable Retire     like mfc_logical label "是否包含处置资产" no-undo initial "yes".
define variable tax_fa like mfc_logical label "包含税务资产" no-undo. 

define var outpath as char format "x(48)"   no-undo.


/* DEFINE DEPRECIATION EXPENSE FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
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
   l-yrper1      colon 25 
   Retire      colon 25
    tax_fa        colon 25  
   outpath  colon 22
     
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " Selection Criteria "
  &ELSE {&SELECTION_CRITERIA}
  &ENDIF .
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
find first glc_cal where  /* *SS-20120821.1*   */ glc_cal.glc_domain = global_domain and glc_start <= today and glc_end >= today no-lock no-error.
         if avail glc_cal then do:
           if integer(glc_per) < 10 then   l-yrper1 = string(glc_year) + "0" + string(glc_per).
            else l-yrper1 = string(glc_year) +  string(glc_per).
        end.
     outpath = "C:".
/* BEGIN MAINLOOP FOR DEPRECIATION EXPENSE REPORT */

/*GUI mainloop removed */


/*GUI*/ {mfguirpa.i false  "printer"  132  " "  " "  " "  }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


   /* ALLOW ENTITY, BOOK, CLASS, ASSET TO BE UPDATED. */
   if l-entity1 = hi_char then l-entity1 = "".
   if l-book1   = hi_char then l-book1   = "".
   if l-class1  = hi_char then l-class1  = "".
   if l-asset1  = hi_char then l-asset1  = "".
   if l-yrper1  = hi_char then l-yrper1  = "".
   
   if c-application-mode <> "WEB"
   then
      
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:

      
    /*verify whether the output path is existing*/    
     
    if outpath = "" then do:
          message "目录不允许为空,请重新输入!" view-as alert-box error.
          /*GUI NEXT-PROMPT removed */
          /*GUI UNDO removed */ RETURN ERROR.
    end.
      file-info:FILENAME = outpath. 
      if file-info:FILE-TYPE = ? or
      index(file-info:file-type,"D") = 0 then do:
          message "目录不存在,请重新输入!" view-as alert-box error.
          /*GUI NEXT-PROMPT removed */
          /*GUI UNDO removed */ RETURN ERROR.
    end.
   if l-yrper      = ""
      and l-yrper1 = ""
   then do:

      /* NO YR/PER VALUES ENTERED, REPORT */
      /* WILL RUN FOR ENTIRE ASSET LIFE   */
      {pxmsg.i &MSGNUM=4942 &ERRORLEVEL=2}

   end. /* IF l-yrper = "" */

   /* CHANGED yrPeriod TO l-yrper               */
   /* ADDED l-yrper1 TO &fields                 */
   /* ADDED tax_fa TO &fields AS THE LAST FIELD */
   {wbrp06.i
      &command = update
      &fields  = "l-entity l-entity1 l-book  l-book1  l-class  l-class1
                  l-asset l-yrper1 l-asset1 Retire tax_fa outpath"}

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
      {mfquoter.i l-yrper1}
      {mfquoter.i Retire}
      {mfquoter.i tax_fa}  
      {mfquoter.i outpath}
           

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
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer"  132  " "  " "  " "  " " }
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:
find first glc_cal where  /* *SS-20120821.1*   */ glc_cal.glc_domain = global_domain and glc_start <= today and glc_end >= today no-lock no-error.




   /* PRINTS PAGE HEADING FOR REPORT */
   {mfphead.i}

   /* CHANGED NINTH INPUT PARAMETER yrPeriod TO l-yrper */
   /* ADDED TENTH INPUT PARAMETER l-yrper1              */
   /* ADDED tax_fa AS THE LAST INPUT PARAMETER          */
   /* CALLS THE DEPRECIATION EXPENSE REPORT PROGRAM     */
   {gprun.i ""yyderpa.p""
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
        input Retire,
        input tax_fa,  
        input outpath)"}

   /* ADDS REPORT TRAILER */
   
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

end. /*MAIN-LOOP*/

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" l-entity l-entity1 l-book l-book1 l-class l-class1 l-asset l-asset1  l-yrper1 Retire tax_fa  outpath"} /*Drive the Report*/
