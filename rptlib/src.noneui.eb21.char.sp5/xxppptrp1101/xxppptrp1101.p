/* ppptrp11.p - ITEM MASTER DATA REPORT                                 */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.8.1.7 $                                                         */
/*K0R8         */
/*V8:ConvertMode=FullGUIReport                                 */
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
/* Revision: 1.8.1.5  BY: Narathip W. DATE: 04/16/03 ECO: *P0PW* */
/* $Revision: 1.8.1.7 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 100412.1 By: Bill Jiang */

/* SS - 100412.1 - B
{mfdtitle.i "2+ "}
SS - 100412.1 - E */
/* SS - 100412.1 - B */
{xxmfdtitle.i "2+ "}

{xxppptrp1101.i}

define input parameter i_line like pt_prod_line no-undo.
define input parameter i_line1 like pt_prod_line no-undo.
define input parameter i_part like pt_part no-undo.
define input parameter i_part1 like pt_part no-undo.
define input parameter i_type like pt_part_type no-undo.
define input parameter i_type1 like pt_part_type no-undo.
/* SS - 100412.1 - E */
{cxcustom.i "PPPTRP11.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ppptrp11_p_1 "Drawing!Brk Cat"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp11_p_3 "Size"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define variable line like pt_prod_line no-undo.
define variable line1 like pt_prod_line no-undo.
define variable part like pt_part no-undo.
define variable part1 like pt_part no-undo.
define variable type like pt_part_type no-undo.
define variable type1 like pt_part_type no-undo.
define variable pldesc like pl_desc no-undo.

/* SELECT FORM */
form
   line           colon 15
   line1          label {t001.i} colon 49 skip
   part           colon 15
   part1          label {t001.i} colon 49 skip
   type           colon 15
   type1          label {t001.i} colon 49 skip

with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* SS - 100412.1 - B */
line = i_line.
line1 = i_line1.
part = i_part.
part1 = i_part1.
type = i_type.
type1 = i_type1.
/* SS - 100412.1 - E */

/* REPORT BLOCK */

{wbrp01.i}
/* SS - 100412.1 - B
repeat:
SS - 100412.1 - E */

   if part1 = hi_char then part1 = "".
   if line1 = hi_char then line1 = "".
   if type1 = hi_char then type1 = "".

   /* SS - 100412.1 - B
   if c-application-mode <> 'web' then
      update line line1 part part1 type type1 with frame a.

   {wbrp06.i &command = update &fields = "line line1 part part1 type
        type1" &frm = "a"}
   SS - 100412.1 - E */

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

   /* SS - 100412.1 - B
   /* PRINTER SELECTION */
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
   {mfphead.i}
   SS - 100412.1 - E */

   for each pt_mstr  where pt_mstr.pt_domain = global_domain and  (pt_part >=
   part
         and pt_part <= part1)
         and (pt_prod_line >= line
         and pt_prod_line <= line1)
         and (pt_part_type >= type
         and pt_part_type <= type1)
      no-lock use-index pt_prod_part  break by pt_prod_line
      {&PPPTRP11-P-TAG1}

         by pt_part with frame b width 132 no-box down:
      {&PPPTRP11-P-TAG2}

      /* SS - 100412.1 - B
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      if first-of(pt_prod_line) then do with frame c:
         if page-size  - line-counter < 7 then page.
         find pl_mstr  where pl_mstr.pl_domain = global_domain and
         pl_prod_line = pt_prod_line no-lock no-error.
         pldesc = pl_desc.
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame c:handle).
         display pt_prod_line pldesc no-label with frame c side-labels.
      end.

      form
         header
         skip(1)

         pt_prod_line pldesc " (" + getTermLabel("CONTINUED",20) + ")"
         format "x(24)"
      with frame a1 page-top side-labels width 132.
      view frame a1.

      if page-size - line-counter < 3 then page.
      display
         pt_part
         pt_desc1
         {&PPPTRP11-P-TAG3}
         pt_um
         pt_rev
         pt_draw
         column-label {&ppptrp11_p_1}
         pt_group
         pt_part_type
         pt_status
         pt_added
         pt_dsgn_grp pt_drwg_loc pt_drwg_size column-label {&ppptrp11_p_3}.

      if pt_desc2 <> "" or pt_break_cat <> "" then do:
         down 1.
         display pt_desc2 @ pt_desc1
            {&PPPTRP11-P-TAG4}
            pt_break_cat @ pt_draw.
      end.
      SS - 100412.1 - E */
      /* SS - 100412.1 - B */
      CREATE ttxxppptrp1101.
      ASSIGN
         ttxxppptrp1101_pt_part = pt_part
         ttxxppptrp1101_pt_um = pt_um
         ttxxppptrp1101_pt_desc1 = pt_desc1
         ttxxppptrp1101_pt_desc2 = pt_desc2
         ttxxppptrp1101_pt_prod_line = pt_prod_line
         ttxxppptrp1101_pt_added = pt_added
         ttxxppptrp1101_pt_dsgn_grp = pt_dsgn_grp
         ttxxppptrp1101_pt_promo = pt_promo
         ttxxppptrp1101_pt_part_type = pt_part_type
         ttxxppptrp1101_pt_status = pt_status
         ttxxppptrp1101_pt_group = pt_group
         ttxxppptrp1101_pt_draw = pt_draw
         ttxxppptrp1101_pt_rev = pt_rev
         ttxxppptrp1101_pt_drwg_loc = pt_drwg_loc
         ttxxppptrp1101_pt_drwg_size = pt_drwg_size
         ttxxppptrp1101_pt_break_cat = pt_break_cat
         .
      /* SS - 100412.1 - E */

      {mfrpchk.i}

   end.

   /* SS - 100412.1 - B
   /* REPORT TRAILER */

   {mfrtrail.i}

end.
   SS - 100412.1 - E */

{wbrp04.i &frame-spec = a}
