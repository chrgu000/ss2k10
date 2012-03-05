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

/* 以下为版本历史 */
/* SS - 100412.1 By: Bill Jiang */

/*以下为发版说明 */
/* SS - 100412.1 - RNB
【100412.1】

修改于以下标准菜单程序:
  - 物料数据报表 [ppptrp11.p]

请参考以上标准菜单程序的相关帮助

请参考以下标准菜单程序进行验证:
  - 物料数据报表 [ppptrp11.p]

顺序输出了以下字段:
  - 标准输出: 物料号[pt_part]
  - 标准输出: UM[pt_um]
  - 标准输出: 说明一[pt_desc1]
  - 标准输出: 说明二[pt_desc2]
  - 标准输出: 产品线[pt_prod_line]
  - 标准输出: 加数[pt_added]
  - 标准输出: 设计组[pt_dsgn_grp]
  - 扩展输出: 推销组[pt_promo]
  - 标准输出: 物料类型[pt_part_type]
  - 标准输出: 状态[pt_status]
  - 标准输出: 组[pt_group]
  - 标准输出: 图纸[pt_draw]
  - 标准输出: 版本[pt_rev]
  - 标准输出: 图纸位置[pt_drwg_loc]
  - 标准输出: 大小[pt_drwg_size]
  - 标准输出: 分类[pt_break_cat]

【100412.1】

SS - 100412.1 - RNE */

/*
{mfdtitle.i "2+ "}
*/
{mfdtitle.i "100412.1"}
{cxcustom.i "PPPTRP11.P"}

/* SS - 100412.1 - B */
{xxppptrp1101.i "new"}
/* SS - 100412.1 - E */

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

/* REPORT BLOCK */

{wbrp01.i}
repeat:

   if part1 = hi_char then part1 = "".
   if line1 = hi_char then line1 = "".
   if type1 = hi_char then type1 = "".

   if c-application-mode <> 'web' then
      update line line1 part part1 type type1 with frame a.

   {wbrp06.i &command = update &fields = "line line1 part part1 type
        type1" &frm = "a"}

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
   /* SS - 100412.1 - B
   {mfphead.i}

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

      {mfrpchk.i}

   end.

   /* REPORT TRAILER */

   {mfrtrail.i}
   SS - 100412.1 - E */

   /* SS - 100412.1 - B */
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

   FOR EACH ttxxppptrp1101:
       DELETE ttxxppptrp1101.
   END.

   {gprun.i ""xxppptrp1101.p"" "(
      INPUT line,
      INPUT line1,
      INPUT part,
      INPUT part1,
      INPUT type,
      INPUT type1
      )"}

   EXPORT DELIMITER ";" "物料号" "UM" "说明一" "说明二" "产品线" "加数" "设计组" "推销组" "物料类型" "状态" "组" "图纸" "版本" "图纸位置" "大小" "分类".
   EXPORT DELIMITER ";" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "扩展输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出".
   EXPORT DELIMITER ";" "pt_part" "pt_um" "pt_desc1" "pt_desc2" "pt_prod_line" "pt_added" "pt_dsgn_grp" "pt_promo" "pt_part_type" "pt_status" "pt_group" "pt_draw" "pt_rev" "pt_drwg_loc" "pt_drwg_size" "pt_break_cat".

   FOR EACH ttxxppptrp1101:
      EXPORT DELIMITER ";" ttxxppptrp1101.
   END.

   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

   {xxmfrtrail.i}
   /* SS - 100412.1 - E */

end.

{wbrp04.i &frame-spec = a}
