/* xxptcurp.p - ITEM MASTER DATA REPORT  INCLUDE COPPER USAGE     */
/* Copyright 2004 Shanghai e-Steering Inc., Shanghai , CHINA                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* REVISION: 1.0      LAST MODIFIED: 06/03/86   BY: PML                 */
/* REVISION: 7.0      LAST MODIFIED: 11/28/91   BY: pml                 */
/* REVISION: 7.4      LAST MODIFIED: 08/05/93   BY: pma *H055*          */
/* REVISION: 7.4      LAST MODIFIED: 08/27/94   BY: rxm *GL58*          */
/* REVISION: 7.5      LAST MODIFIED: 02/01/95   BY: tjm *J042*          */
/* REVISION: 8.6      LAST MODIFIED: 10/10/97   BY: mzv *K0R8*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 07/20/00   BY: *N0GF* Mudit Mehta      */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb              */
/* REVISION: 9.1      LAST MODIFIED: 10/27/00   BY: *N0TF* Katie Hilbert    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.8.1.5 $    BY: Narathip W.           DATE: 04/16/03  ECO: *P0PW*  */
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
{cxcustom.i "PPPTRP11.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ppptrp11_p_1 "Drawing!Brk Cat"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp11_p_2 "Copper Std. Usage"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp11_p_3 "Additional Usage"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define variable line like pt_prod_line no-undo.
define variable line1 like pt_prod_line no-undo.
define variable part like pt_part no-undo.
define variable part1 like pt_part no-undo.
define variable type like pt_part_type no-undo.
define variable type1 like pt_part_type no-undo.
define variable pldesc like pl_desc no-undo.
DEFINE VARIABLE xxin LIKE mfc_logical INITIAL YES .
/* SELECT FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
line           colon 15
   line1          label {t001.i} colon 49 skip
   part           colon 15
   part1          label {t001.i} colon 49 skip
   type           colon 15
   type1          label {t001.i} colon 49 skip(1)
   xxin         COLON 25 LABEL "Only Including Copper" 
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

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

/* REPORT BLOCK */

{wbrp01.i}

/*GUI*/ {mfguirpa.i true "printer" 132 " " " " " "  }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


   if part1 = hi_char then part1 = "".
   if line1 = hi_char then line1 = "".
   if type1 = hi_char then type1 = "".

   if c-application-mode <> 'web' then
      
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


   {wbrp06.i &command = update &fields = "line line1 part part1 type
        type1" &frm xxin = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i line   }
      {mfquoter.i line1  }
      {mfquoter.i part   }
      {mfquoter.i part1  }
      {mfquoter.i type   }
      {mfquoter.i type1  }

      if part1 = "" then part1 = hi_char.
      if line1 = "" then line1 = hi_char.
      if type1 = "" then type1 = hi_char.
   end.

   /* PRINTER SELECTION */
   /* OUTPUT DESTINATION SELECTION */
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i "printer" 132 " " " " " " " " }
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:



   {mfphead.i}

   for each pt_mstr where (pt_part >= part
         and pt_part <= part1)
         and (pt_prod_line >= line
         and pt_prod_line <= line1)
         and (pt_part_type >= type
         and pt_part_type <= type1)
         AND ( NOT xxin OR pt__dec01 <> 0 ) 
      no-lock use-index pt_prod_part  break by pt_prod_line
      {&PPPTRP11-P-TAG1}

         by pt_part with frame b width 132 no-box down:
      {&PPPTRP11-P-TAG2}

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      if first-of(pt_prod_line) then do with frame c:
         if page-size  - line-counter < 7 then page.
         find pl_mstr where pl_prod_line = pt_prod_line no-lock no-error.
         pldesc = pl_desc.
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame c:handle).
         display pt_prod_line pldesc no-label with frame c side-labels STREAM-IO /*GUI*/ .
      end.

      FORM /*GUI*/ 
         header
         skip(1)

         pt_prod_line pldesc " (" + getTermLabel("CONTINUED",20) + ")"
         format "x(24)"
      with STREAM-IO /*GUI*/  frame a1 page-top side-labels width 132.
      view frame a1.

      if page-size - line-counter < 3 then page.
      display
         pt_part
         pt_desc1
         {&PPPTRP11-P-TAG3}
         pt_um
         pt_rev
         pt_draw         column-label {&ppptrp11_p_1}
         pt_group
         pt_part_type
         pt_status
         pt_added                                                         
         pt__dec01  FORMAT "->,>>>,>>9.9<<<<<<<" column-label {&ppptrp11_p_2}   
         pt__dec02  FORMAT "->,>>>,>>9.9<<<<<<<"  column-label {&ppptrp11_p_3}   
      WITH STREAM-IO /*GUI*/  WIDTH 168.

      if pt_desc2 <> "" or pt_break_cat <> "" then do:
         down 1.
         display pt_desc2 @ pt_desc1
            {&PPPTRP11-P-TAG4}
            pt_break_cat @ pt_draw WITH STREAM-IO /*GUI*/ .
      end.

      
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/


   end.

   /* REPORT TRAILER */

   
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


end.

{wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" line line1 part part1 type type1 xxin "} /*Drive the Report*/
