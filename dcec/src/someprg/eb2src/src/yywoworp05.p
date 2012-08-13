/* GUI CONVERTED from woworp05.p (converter v1.76) Mon Sep 17 22:18:59 2001 */
/* woworp05.p - WORK ORDER COST REPORT                                        */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.15 $                                                        */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 1.0     LAST MODIFIED: 05/01/86    BY: emb                       */
/* REVISION: 2.1     LAST MODIFIED: 09/11/87    BY: wug *A94*                 */
/* REVISION: 4.0     LAST MODIFIED: 02/24/88    BY: wug *A175*                */
/* REVISION: 4.0     LAST MODIFIED: 03/30/88    BY: rxl *A171*                */
/* REVISION: 4.0     LAST MODIFIED: 01/04/89    BY: flm *A579*                */
/* REVISION: 5.0     LAST MODIFIED: 01/24/90    BY: ftb *B531*                */
/* REVISION: 5.0     LAST MODIFIED: 02/12/90    BY: wug *B562*                */
/* REVISION: 5.0     LAST MODIFIED: 05/15/90    BY: ram *B688*                */
/* REVISION: 5.0     LAST MODIFIED: 01/08/91    BY: ram *B870*                */
/* REVISION: 6.0     LAST MODIFIED: 05/01/91    BY: ram *D611*                */
/* REVISION: 7.0     LAST MODIFIED: 10/23/91    BY: pma *F003*                */
/* REVISION: 7.3     LAST MODIFIED: 04/23/93    BY: ram *GA24*                */
/* REVISION: 7.3     LAST MODIFIED: 04/28/93    BY: pma *GA47*(rev only)      */
/* REVISION: 7.4     LAST MODIFIED: 03/29/95    BY: dzn *F0PN*                */
/* REVISION: 8.6     LAST MODIFIED: 10/14/97    BY: ays *K0XV*                */
/* REVISION: 7.4     LAST MODIFIED: 02/05/98    BY: *H1JC* Jean Miller        */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane          */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan         */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1     LAST MODIFIED: 08/12/00    BY: *N0KC* Mark Brown         */
/* Revision: 1.11    BY: Jyoti Thatte           DATE: 04/03/01 ECO: *P008*    */
/* Revision: 1.14    BY: Vivek Gogte            DATE: 04/30/01 ECO: *P001*    */
/* $Revision: 1.15 $  BY: Manjusha Inglay        DATE: 08/28/01 ECO: *P01R*   */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "b+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE woworp05_p_1 "Subcontract"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp05_p_2 "Material"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp05_p_3 "Page Break on Work Order"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp05_p_4 "Burden"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp05_p_5 "Labor"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp05_p_6 "Detail/Summary"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define new shared variable nbr    like wo_nbr.
define new shared variable nbr1   like wo_nbr.
define new shared variable lot    like wo_lot.
define new shared variable lot1   like wo_lot.
define new shared variable site   like wo_site no-undo.
define new shared variable site1  like wo_site no-undo.
define new shared variable part   like wo_part .
define new shared variable part1  like wo_part .
define new shared variable due    like wo_due_date .
define new shared variable due1   like wo_due_date .
define new shared variable vend   like wo_vend.
define new shared variable so_job like wo_so_job.
define new shared variable stat   like wo_status.

define new shared variable skpage like mfc_logical initial yes
                                  label "Page Break on Work Order".
define new shared variable mtlyn  like mfc_logical initial yes
                                  label "Material" format "Detail/Summary".
define new shared variable lbryn  like mfc_logical initial yes
                                  label "Labor" format "Detail/Summary".
define new shared variable bdnyn  like mfc_logical initial yes
                                  label "Burden" format "Detail/Summary".
define new shared variable subyn  like mfc_logical initial yes
                                  label "Subcontract" format "Detail/Summary".


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
nbr         colon 15
   nbr1        label {t001.i} colon 49 skip
   lot         colon 15
   lot1        label {t001.i} colon 49 skip
   site        colon 15
   site1       label {t001.i} colon 49 skip
   part        colon 15
   part1       label {t001.i} colon 49 skip
   due         colon 15
   due1        label {t001.i} colon 49 skip (1)
   so_job      colon 30 skip
   vend        colon 30 skip
   stat        colon 30 skip (1)
   mtlyn       colon 30 skip
   lbryn       colon 30 skip
   bdnyn       colon 30 skip
   subyn       colon 30 skip
   skpage      colon 30
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

{wbrp01.i}


/*GUI*/ {mfguirpa.i true "printer" 132 " " " " " "  }

/*GUI repeat  on error undo, retry: */
/*GUI*/ procedure p-enable-ui:


   if nbr1  = hi_char then nbr1 = "".
   if lot1  = hi_char then lot1 = "".
   if site1 = hi_char then site1 = "".

   if c-application-mode <> "WEB" then
   
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


   {wbrp06.i &command = update &fields = "  nbr nbr1 lot lot1 site site1
             part part1 due due1 so_job vend stat   mtlyn lbryn bdnyn subyn
             skpage" &frm = "a"}

   if (c-application-mode <> "WEB") or
      (c-application-mode = "WEB" and
      (c-web-request begins "DATA")) then do:

      bcdparm = "".
      {mfquoter.i nbr     }
      {mfquoter.i nbr1    }
      {mfquoter.i lot     }
      {mfquoter.i lot1    }
      {mfquoter.i site    }
      {mfquoter.i site1   }
      {mfquoter.i part    }
      {mfquoter.i part1   }
      {mfquoter.i due     }
      {mfquoter.i due1    }
      {mfquoter.i so_job  }
      {mfquoter.i vend    }
      {mfquoter.i stat    }
      {mfquoter.i mtlyn   }
      {mfquoter.i lbryn   }
      {mfquoter.i bdnyn   }
      {mfquoter.i subyn   }
      {mfquoter.i skpage  }

      /* ADD THIS DO LOOP SO THE CONVERTER WONT CREATE AN 'ON LEAVE' */
      do:

         if index("PFEARCB",stat) = 0 and stat <> ""
            then do with frame a:
            /* INVALID STATUS */
            {pxmsg.i &MSGNUM=19 &ERRORLEVEL=3}
            if c-application-mode = "WEB" then return.
            else
               /*GUI NEXT-PROMPT removed */
            /*GUI UNDO removed */ RETURN ERROR.
         end.
      end.

   end. /* if c-application-mode */

   /* SELECT PRINTER */
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i "printer" 132 " " " " " " " " }
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:




   {mfphead.i}

   if nbr1  = "" then nbr1 = hi_char.
   if lot1  = "" then lot1 = hi_char.
   if site1 = "" then site1 = hi_char.

   {gprun.i ""yywoworp5a.p""}

   
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


end. /* REPEAT */

{wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" nbr nbr1 lot lot1 site site1 part part1 due due1 so_job vend stat mtlyn lbryn bdnyn subyn skpage "} /*Drive the Report*/
