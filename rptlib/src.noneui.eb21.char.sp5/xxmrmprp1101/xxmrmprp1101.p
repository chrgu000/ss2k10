/* mrmprp11.p - MRP SUMMARY REPORT WITH DETAIL & ACTION MESSAGES OPTIONAL     */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */

/* $Revision: 1.8.1.5 $                                                    */

/* REVISION: 1.0           LAST EDIT: 05/12/86         MODIFIED BY: pml       */
/* REVISION: 1.0           LAST EDIT: 07/17/86         MODIFIED BY: EMB       */
/* REVISION: 1.0           LAST EDIT: 09/12/86         MODIFIED BY: EMB *20*  */
/* REVISION: 1.0           LAST EDIT: 10/21/86         MODIFIED BY: EMB *36*  */
/* REVISION: 2.0           LAST EDIT: 03/06/87         MODIFIED BY: EMB *A39* */
/* REVISION: 2.0           LAST EDIT: 08/07/87         MODIFIED BY: EMB *A75* */
/* REVISION: 2.0       LAST MODIFIED: 01/06/88                  BY: pml A125 */
/* REVISION: 4.0           LAST EDIT: 01/07/88         MODIFIED BY: EMB *A133**/
/* REVISION: 4.0           LAST EDIT: 01/27/88         MODIFIED BY: EMB *A162**/
/* REVISION: 4.0           LAST EDIT: 02/05/88         MODIFIED BY: emb *A173**/
/* REVISION: 4.0           LAST EDIT: 02/16/88         MODIFIED BY: FLM *A175**/
/* REVISION: 4.0           LAST EDIT: 12/05/88         MODIFIED BY: emb *A549**/
/* REVISION: 5.0           LAST EDIT: 11/13/89         MODIFIED BY: emb *B386**/
/* REVISION: 5.0           LAST EDIT: 02/21/90         MODIFIED BY: MLB *B557**/
/* REVISION: 5.0           LAST EDIT: 03/27/90         MODIFIED BY: emb *B634**/
/* REVISION: 6.0           LAST EDIT: 08/10/90         MODIFIED BY: emb *D040**/
/* REVISION: 6.0           LAST EDIT: 08/16/90         MODIFIED BY: emb *D057**/
/* REVISION: 7.0           LAST EDIT: 03/31/92         MODIFIED BY: pma *F318**/
/* REVISION: 7.0           LAST EDIT: 04/28/92         MODIFIED BY: emb *F443**/
/* REVISION: 7.0           LAST EDIT: 05/11/92         MODIFIED BY: emb *F475**/
/* REVISION: 7.3           LAST EDIT: 08/19/93         MODIFIED BY: emb *GE37**/
/* REVISION: 7.3           LAST EDIT: 10/18/94         MODIFIED BY: jzs *GN61**/
/* REVISION: 7.3           LAST EDIT: 11/29/94         MODIFIED BY: ame *GO62**/
/* REVISION: 7.5           LAST EDIT: 01/25/95         MODIFIED BY: tjs *J014**/
/* REVISION: 8.6           LAST MODIFIED: 10/22/97              BY: ays *K14V**/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KR* myb                  */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Revision: 1.8.1.3  BY: Russ Witt DATE: 09/21/01 ECO: *P01H* */
/* $Revision: 1.8.1.5 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00J* */
/*-Revision end---------------------------------------------------------------*/
/* SS - 20081029.1 By: Bill Jiang */

/*V8:ConvertMode=FullGUIReport                                       */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20081029.1 - B */
{xxmrmprp1101.i}

define input parameter i_part like pt_part.
define input parameter i_part1 like pt_part.
define input parameter i_bom like wo_bom_code.
define input parameter i_bom1 like wo_bom_code.
define input parameter i_site like si_site.
define input parameter i_site1 like si_site.
define input parameter i_buyer like pt_buyer.
define input parameter i_buyer1 like pt_buyer.
define input parameter i_prod_line like pt_prod_line.
define input parameter i_prod_line1 like pt_prod_line.
define input parameter i_ptgroup like pt_group.
define input parameter i_ptgroup1 like pt_group.
define input parameter i_part_type like pt_part_type.
define input parameter i_part_type1 like pt_part_type.
define input parameter i_vendor like pt_vend.
define input parameter i_vendor1 like pt_vend.
define input parameter i_pm_code like pt_pm_code.
define input parameter i_start like ro_start.
define input parameter i_ending like ro_end.
define input parameter i_dwm as character .
define input parameter i_idays as integer.

/*
/* DISPLAY TITLE */
{mfdtitle.i "2+ "}
*/
{xxmfdtitle.i "2+ "}
/* SS - 20081029.1 - E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mrmprp11_p_1 "Include Base Process Orders"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmprp11_p_2 "Per Column"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmprp11_p_3 "Include Zero Requirements"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmprp11_p_4 "Print Action Messages"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmprp11_p_5 "Item Number/BOM Formula"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmprp11_p_6 "Print Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmprp11_p_7 "Print Substitute Items"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmprp11_p_8 "Day/Week/Month"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmprp11_p_9 "Use Cost Plans"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrmprp11_p_10 "Sort by Item or BOM/Formula"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define new shared variable site like si_site.
define new shared variable site1 like si_site.
define new shared variable part like pt_part.
define new shared variable part1 like pt_part.
define new shared variable bom like wo_bom_code.
define new shared variable bom1 like wo_bom_code.
define new shared variable buyer like pt_buyer.
define new shared variable buyer1 like pt_buyer.
define new shared variable prod_line like pt_prod_line.
define new shared variable prod_line1 like pt_prod_line.
define new shared variable ptgroup like pt_group.
define new shared variable ptgroup1 like pt_group.
define new shared variable part_type like pt_part_type.
define new shared variable part_type1 like pt_part_type.
define new shared variable vendor like pt_vend.
define new shared variable vendor1 like pt_vend.
define new shared variable start like ro_start.
define new shared variable ending like ro_end.
define new shared variable pm_code like pt_pm_code.
define new shared variable dwm as character format "!(1)"
   label {&mrmprp11_p_8}.
define new shared variable idays as integer format ">>>>>9"
   label {&mrmprp11_p_2}.
define new shared variable out_dev as character.
define new shared variable detail like mfc_logical
   label {&mrmprp11_p_6}.
define new shared variable action like mfc_logical
   label {&mrmprp11_p_4}.

define variable old_start as date.
define variable not_part as integer.
define new shared variable show_zero like mfc_logical
   label {&mrmprp11_p_3}.
define new shared variable subs like mfc_logical
   label {&mrmprp11_p_7}.
define new shared variable show_base like mfc_logical initial true
   label {&mrmprp11_p_1}.
define new shared variable item_sort like mfc_logical initial true
   format {&mrmprp11_p_5}
   label {&mrmprp11_p_10}.
define new shared variable plan_yn like mfc_logical
   label {&mrmprp11_p_9}.

form
   part           colon 27
   part1          label {t001.i} colon 52
   bom            colon 27
   bom1           label {t001.i} colon 52
   site           colon 27
   site1          label {t001.i} colon 52
   buyer          colon 27
   buyer1        label {t001.i} colon 52
   prod_line      colon 27
   prod_line1     label {t001.i} colon 52
   ptgroup        colon 27
   ptgroup1        label {t001.i} colon 52
   part_type      colon 27
   part_type1        label {t001.i} colon 52
   vendor         colon 27
   vendor1        label {t001.i} colon 52
   pm_code        colon 27
   detail         colon 27
   plan_yn        colon 65
   action         colon 27
   show_base      colon 65
   subs           colon 27
   show_zero      colon 27
   item_sort      colon 65

   skip(1)
   start          colon 27
   ending         colon 47
   dwm            colon 27
   idays          colon 47
with frame a side-labels width 80 attr-space.

/* SS - 20081029.1 - B */
/*
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
*/
ASSIGN
   part = i_part
   part1 = i_part1
   bom = i_bom
   bom1 = i_bom1
   site = i_site
   site1 = i_site1
   buyer = i_buyer
   buyer1 = i_buyer1
   prod_line = i_prod_line
   prod_line1 = i_prod_line1
   ptgroup = i_ptgroup
   ptgroup1 = i_ptgroup1
   part_type = i_part_type
   part_type1 = i_part_type1
   vendor = i_vendor
   vendor1 = i_vendor1
   pm_code = i_pm_code
   start = i_start
   ending = i_ending
   dwm = i_dwm
   idays = i_idays
   .
/* SS - 20081029.1 - E */

find first mrpc_ctrl  where mrpc_ctrl.mrpc_domain = global_domain no-lock
no-error.
start = today.

if (mrpc_sum_def > 0) and (mrpc_sum_def < 8) then
   do while not (weekday(start) = mrpc_sum_def):
   start = start - 1.
end.

site = global_site.
site1 = global_site.

{wbrp01.i}

/* SS - 20081029.1 - B */
/*
repeat:
*/
/* SS - 20081029.1 - E */

   if start = ? then start = today.
   if old_start <> ? then start = old_start.
   if dwm = "" then dwm = "W".
   if idays = 0 or idays = ? then idays = 1.
   if part1 = hi_char then part1 = "".
   if bom1  = hi_char then bom1 = "".
   if site1 = hi_char then site1 = "".
   if buyer1 = hi_char then buyer1 = "".
   if prod_line1 = hi_char then prod_line1 = "".
   if ptgroup1 = hi_char then ptgroup1 = "".
   if part_type1 = hi_char then part_type1 = "".
   if vendor1 = hi_char then vendor1 = "".
   if ending = hi_date then ending = ?.

   /* SS - 20081029.1 - B */
   /*
   if c-application-mode <> 'web' then
   update
      part
      part1
      bom
      bom1
      site
      site1
      buyer
      buyer1
      prod_line
      prod_line1
      ptgroup
      ptgroup1
      part_type
      part_type1
      vendor
      vendor1
      pm_code
      detail
      action
      subs
      show_zero
      plan_yn
      show_base
      item_sort
      start
      ending
      dwm
      idays
   with frame a.

   {wbrp06.i &command = update &fields = "  part part1  bom bom1 site site1
         buyer buyer1 prod_line prod_line1 ptgroup ptgroup1 part_type part_type1
         vendor vendor1 pm_code detail action subs show_zero  plan_yn
         show_base item_sort start ending dwm idays" &frm = "a"}
   */
   /* SS - 20081029.1 - E */

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i part      }
      {mfquoter.i part1     }
      {mfquoter.i bom       }
      {mfquoter.i bom1      }
      {mfquoter.i site      }
      {mfquoter.i site1     }
      {mfquoter.i buyer     }
      {mfquoter.i buyer1    }
      {mfquoter.i prod_line }
      {mfquoter.i prod_line1 }
      {mfquoter.i ptgroup   }
      {mfquoter.i ptgroup1   }
      {mfquoter.i part_type }
      {mfquoter.i part_type1 }
      {mfquoter.i vendor    }
      {mfquoter.i vendor1    }
      {mfquoter.i pm_code   }
      {mfquoter.i detail    }
      {mfquoter.i action    }
      {mfquoter.i subs      }
      {mfquoter.i show_zero }
      {mfquoter.i plan_yn   }
      {mfquoter.i show_base }
      {mfquoter.i item_sort }
      {mfquoter.i start     }
      {mfquoter.i ending    }
      {mfquoter.i dwm       }
      {mfquoter.i idays     }

      /* SS - 20081029.1 - B */
      /*
      /* STANDARD DWMP CRITERION VALIDATION */
      if index("dwmp",dwm) = 0 then do:
         {pxmsg.i &MSGNUM=14 &ERRORLEVEL=3}
         /* "INTERVAL MUST BE (D)ay (W)eek OR (M)onth.*/

         if c-application-mode = 'web' then return.
         else next-prompt dwm with frame a.
         undo, retry.
      end.
      */
      /* SS - 20081029.1 - E */

      if start = ? then start = today.
      if part1 = "" then part1 = hi_char.
      if bom1 = "" then bom1 = hi_char.
      if site1 = "" then site1 = hi_char.
      if buyer1 = "" then buyer1 = hi_char.
      if prod_line1 = "" then prod_line1 = hi_char.
      if ptgroup1 = "" then ptgroup1 = hi_char.
      if part_type1 = "" then part_type1 = hi_char.
      if vendor1 = "" then vendor1 = hi_char.
      if ending = ? then ending = hi_date.

   end.

   /* SS - 20081029.1 - B */
   /*
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

   out_dev = dev.
   {mfphead.i}
   */
   /* SS - 20081029.1 - E */

   loopb:
   do on error undo , leave:

      if item_sort then do:
         /* SS - 20081029.1 - B */
         /*
         {gprun.i ""mrmprp1a.p""}
         */
         {gprun.i ""xxmrmprp11a.p""}
         /* SS - 20081029.1 - E */
      end.
      else do: /* BOM Sort */
         {gprun.i ""mrmprp1i.p""}
      end.
   end. /* loopb */

   /* SS - 20081029.1 - B */
   /*
   {mfrtrail.i}
end. /* repeat */
   */
   /* SS - 20081029.1 - E */

{wbrp04.i &frame-spec = a}
