/* GUI CONVERTED from pirp01.p (converter v1.78) Mon Aug 21 03:36:19 2006 */
/* pirp01.p - PRINT TAGS                                                      */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 6.0      LAST MODIFIED: 03/06/90   BY: WUG *D015*                */
/* REVISION: 6.0      LAST MODIFIED: 11/14/90   BY: WUG *D210*                */
/* REVISION: 6.0      LAST MODIFIED: 07/12/91   BY: WUG *D765*                */
/* REVISION: 7.0      LAST MODIFIED: 09/25/91   BY: pma *F003*                */
/* REVISION: 7.0      LAST MODIFIED: 11/11/91   BY: WUG *D887*                */
/* REVISION: 6.0      LAST MODIFIED: 03/05/92   BY: WUG *F254*                */
/* REVISION: 6.0      LAST MODIFIED: 04/30/92   BY: WUG *F460*                */
/* Revision: 7.3      Last edit    : 11/19/92   By: jcd *G348*                */
/* REVISION: 7.3      LAST MODIFIED: 07/23/93   BY: qzl *GD66*                */
/* REVISION: 7.2      LAST MODIFIED: 01/28/94   BY: ais *FL74*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 08/31/98   BY: *L086* A.Shobha           */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 07/26/00   BY: *N0GQ* BalbeerS Rajput    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.11      BY: Falguni D.         DATE: 06/14/01   ECO: *M1B9*    */
/* Revision: 1.12      BY: Jean Miller        DATE: 09/07/01   ECO: *N122*    */
/* Revision: 1.14      BY: Paul Donnelly (SB) DATE: 06/28/03   ECO: *Q00J*    */
/* Revision: 1.15      BY: Kirti Desai        DATE: 10/23/03   ECO: *P173*    */
/* Revision: 1.16      BY: Abhishek Jha       DATE: 11/22/04   ECO: *P2VW*    */
/* $Revision: 1.16.4.2 $ BY: Jayesh Sawant      DATE: 08/17/06   ECO: *P528*    */


/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=FullGUIReport                                                */


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "1+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE pirp01_p_3 "Forms Across"
/* MaxLen: Comment: */

&SCOPED-DEFINE pirp01_p_5 "Maximum Print Width in Characters"
/* MaxLen: Comment: */

&SCOPED-DEFINE pirp01_p_7 "Form Width in Characters"
/* MaxLen: Comment: */

&SCOPED-DEFINE pirp01_p_9 "Lines Per Form"
/* MaxLen: Comment: */

&SCOPED-DEFINE pirp01_p_17 "Print Bar Code"
/* MaxLen: Comment: */

&SCOPED-DEFINE pirp01_p_18 "Reprint Tags"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define variable tag             like tag_nbr initial ?.
define variable tag1            like tag_nbr label {t001.i} initial ?.
define variable reprint_tags    like mfc_logical label {&pirp01_p_18}
   initial no.
define variable print_barcode   like mfc_logical label {&pirp01_p_17}
   initial no.
define variable forms_across    as integer format "9" initial 1
   label {&pirp01_p_3}.
define variable lines_form      as integer format ">9" initial 18
   label {&pirp01_p_9}.
define variable form_width      as integer format ">>9" initial 50
   label {&pirp01_p_7}.
define variable max_printwidth  as integer format ">>9" initial 131
   label {&pirp01_p_5}.
define variable site            like si_site.
define variable loc             like loc_loc.
define variable part            like pt_part.
define variable desc1           like pt_desc1.
define variable desc2           like pt_desc2.
define variable lotserial       like tag_serial.
define variable lotref          like tag_ref.
define variable um              like pt_um.
define variable abc             like pt_abc.
define variable tagline         as character extent 16.
define variable printline       as character extent 16.
define variable forms_built     as integer initial 0.
define variable i               as integer.
define variable j               as integer.
define variable tagnumber       like tag_nbr extent 20.
define variable barctrlcode     as character.

assign
   tagline[01] = getTermLabelRtColon("TAG_NUMBER",13)
   tagline[02] = "                                                  "
   tagline[03] = getTermLabelRtColon("SITE",13)
   tagline[04] = getTermLabelRtColon("LOCATION",13)
   tagline[05] = getTermLabelRtColon("ITEM_NUMBER",13) +
                 "                    " +
                 getTermLabelRtColon("UNIT_OF_MEASURE",4) +
                 "    " + getTermLabelRtColon("ABC_CLASS",5)
   tagline[06] = getTermLabelRtColon("DESCRIPTION",13)
   tagline[07] = "                                                  "
   tagline[08] = getTermLabelRtColon("LOT/SERIAL",13) +
                 "                     " +
                 getTermLabelRtColon("REFERENCE",5)
   tagline[09] = "                                                  "
   tagline[10] = getTermLabelRtColon("QUANTITY_COUNTED",13)    + " ________  " +
                 getTermLabelRtColon("QUANTITY_RECOUNTED",15)  + " ________  "
   tagline[11] = getTermLabelRtColon("COUNT_UM",13)       + " ________  " +
                 getTermLabelRtColon("RECOUNT_UM",15)     + " ________  "
   tagline[12] = getTermLabelRtColon("COUNT_CONV",13)     + " ________  " +
                 getTermLabelRtColon("RECOUNT_CONV",15)   + " ________  "
   tagline[13] = getTermLabelRtColon("COUNTED_BY",13)     + " ________  " +
                 getTermLabelRtColon("RECOUNTED_BY",15)   + " ________  "
   tagline[14] = getTermLabelRtColon("DATE_COUNTED",13)   + " ________  " +
                 getTermLabelRtColon("DATE_RECOUNTED",15) + " ________  "
   tagline[15] = "                                                  "
   tagline[16] = getTermLabelRtColon("REMARKS",13) + " " + fill("_",35).


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
tag                  colon 20
   tag1                 colon 49
   skip(1)
   reprint_tags         colon 40
   print_barcode        colon 40
   forms_across         colon 40
   lines_form           colon 40
   form_width           colon 40
   max_printwidth       colon 40
 SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

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

{wbrp01.i}


/*GUI*/ {mfguirpa.i true "printer" 80 " " " " " "  }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

   if tag = 0
   then
      tag = ?.

   if tag1 = 99999999
   then
      tag1 = ?.

   display
      reprint_tags
      print_barcode
      forms_across
      lines_form
      form_width
      max_printwidth
   with frame a.

   if c-application-mode <> 'WEB'
   then
      
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


   {wbrp06.i &command = set
      &fields = " tag tag1 reprint_tags print_barcode
                  forms_across lines_form
                  form_width max_printwidth "
      &frm = "a"}

   if c-application-mode <> 'WEB' or
      (c-application-mode = 'WEB' and
      c-web-request begins 'DATA' )
   then do:
      if forms_across < 1
      then do:
         /* Forms across must be positive */
         {pxmsg.i &MSGNUM=705 &ERRORLEVEL=3}

         if c-application-mode = 'WEB'
         then
            return.

         /*GUI NEXT-PROMPT removed */
         /*GUI UNDO removed */ RETURN ERROR.
      end.

      if lines_form < 16
      then do:
         /* Lines per form must be at least 16 */
         {pxmsg.i &MSGNUM=706 &ERRORLEVEL=3}

         if c-application-mode = 'WEB'
         then
            return.

         /*GUI NEXT-PROMPT removed */

         /*GUI UNDO removed */ RETURN ERROR.
      end.

      if form_width < 50
      then do:
         /* Form width must be at least 50 characters */
         {pxmsg.i &MSGNUM=707 &ERRORLEVEL=3}

         if c-application-mode = 'WEB'
         then
            return.

         /*GUI NEXT-PROMPT removed */

         /*GUI UNDO removed */ RETURN ERROR.
      end.

      if forms_across * form_width > max_printwidth
      then do:
         /* Line is not wide enough for requested forms per line */
         {pxmsg.i &MSGNUM=719 &ERRORLEVEL=3}

         if c-application-mode = 'WEB'
         then
            return.

         /*GUI NEXT-PROMPT removed */
         /*GUI UNDO removed */ RETURN ERROR.
      end.

      if print_barcode and forms_across <> 1
      then do:
         /* Only 1 label across allowed with bar code */
         {pxmsg.i &MSGNUM=699 &ERRORLEVEL=3}

         if c-application-mode = 'WEB'
         then
            return.
         /*GUI UNDO removed */ RETURN ERROR.
      end.

      bcdparm = "".
      {mfquoter.i tag}
      {mfquoter.i tag1}
      {mfquoter.i reprint_tags}
      {mfquoter.i print_barcode}
      {mfquoter.i forms_across}
      {mfquoter.i lines_form}
      {mfquoter.i form_width}
      {mfquoter.i max_printwidth}

      if tag = ? then tag = 0.
      if tag1 = ? then tag1 = 99999999.
   end.

   /* OUTPUT DESTINATION SELECTION */
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i "printer" 80 " " " " " " " " }
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:




   for each tag_mstr exclusive-lock  where tag_mstr.tag_domain = global_domain
   and (  tag_nbr >= tag and
         tag_nbr <= tag1 and (reprint_tags or tag_prt_dt = ?) ) :
      assign
         tag_prt_dt = today
         site       = "________"
         loc        = "________"
         part       = "__________________"
         um         = ""
         abc        = ""
         desc1      = ""
         desc2      = ""
         lotserial  = "__________________"
         lotref     = "________".

      if tag_type = "I"
      then do:
         
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

         assign
            site = tag_site
            loc = tag_loc
            part = tag_part.
         find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
         tag_part no-lock no-error.
         if available pt_mstr
         then
            assign
               um = pt_um
               desc1 = pt_desc1
               desc2 = pt_desc2.
         find in_mstr  where in_mstr.in_domain = global_domain and  in_part =
         tag_part and in_site = tag_site
            no-lock no-error.
         if available in_mstr
         then
            abc = in_abc.

         assign
            lotserial = tag_serial
            lotref = tag_ref.
      end.

      assign
         substring(tagline[01],15,8,"RAW")  = substring(string(tag_nbr)
                                              + fill(" ",8),1,8,"RAW")
         substring(tagline[03],15,8,"RAW")  = substring(site
                                              + fill(" ",8),1,8,"RAW")
         substring(tagline[04],15,8,"RAW")  = substring(loc
                                              + fill(" ",8),1,8,"RAW")
         substring(tagline[05],15,18,"RAW") = substring(part
                                              + fill(" ",18),1,18,"RAW")
         substring(tagline[05],39,2,"RAW")  = substring(um
                                              + fill(" ",2),1,2,"RAW")
         substring(tagline[05],48,1,"RAW")  = substring(abc
                                              + " ",1,1,"RAW")
         substring(tagline[06],15,24,"RAW") = substring(desc1
                                              + fill(" ",24),1,24,"RAW")
         substring(tagline[07],15,24,"RAW") = substring(desc2
                                              + fill(" ",24),1,24,"RAW")
         substring(tagline[08],15,18,"RAW") = substring(lotserial
                                              + fill(" ",18),1,18,"RAW")
         substring(tagline[08],41,8,"RAW")  = substring(lotref
                                              + fill(" ",8),1,8,"RAW").

      do i = 1 to 16:
         if forms_built > 0
         then
            printline[i] = printline[i]
                           + fill(" ",form_width
                           - {gprawlen.i &strng = tagline[i] } )
                           + tagline[i].
         else
            printline[i] = printline[i] + tagline[i].
      end.

      assign
         forms_built = forms_built + 1
         tagnumber[forms_built] = tag_nbr.

      if forms_built >= forms_across
      then do:
         {pirp01.i}
      end. /* IF forms_built >= .. */
   end.  /* FOR EACH tag_mstr */

   if forms_built >= 1
   then do:
      {pirp01.i}
   end.

   
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

end.
{wbrp04.i &frame-spec=a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" tag tag1 reprint_tags print_barcode forms_across lines_form form_width max_printwidth "} /*Drive the Report*/
