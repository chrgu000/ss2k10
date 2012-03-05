/* rwdprp.p - DEPARTMENT REPORT                                         */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.6.1.7 $                                                     */
/*V8:ConvertMode=FullGUIReport                                          */
/* REVISION: 2.0      LAST MODIFIED: 03/25/87   BY: EMB */
/* REVISION: 4.0      LAST MODIFIED: 02/03/88   BY: RL  *A171**/
/* REVISION: 4.0      LAST MODIFIED: 02/24/88   BY: WUG *A175**/
/* REVISION: 6.0      LAST MODIFIED: 11/02/90   BY: emb *D175**/
/* REVISION: 6.0      LAST MODIFIED: 08/23/91   BY: pma *D806**/
/* REVISION: 7.0      LAST MODIFIED: 08/21/91   BY: pma *F003**/
/* REVISION: 8.6      LAST MODIFIED: 10/15/97   BY: bvm *K10X**/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb              */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Revision: 1.6.1.4     BY: Hualin Zhong   DATE: 05/04/01 ECO: *N0YC*   */
/* Revision: 1.6.1.5  BY: Manjusha Inglay DATE: 08/28/01 ECO: *P01R* */
/* $Revision: 1.6.1.7 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* 以下为版本历史 */
/* SS - 090223.1 By: Amy Wu */

/* DISPLAY TITLE */
/* SS - 090223.1 - B
禁止显示页眉
{mfdtitle.i "1+ "}
SS - 090223.1 - E */

/* SS - 090223.1 - B */
/* 固定 */
{xxmfdtitle.i "1+ "}

/* 临时表 */
{xxrwdprp0001.i}

/* 定义输入参数 */
define input parameter i_dept like dpt_dept no-undo.
define input parameter i_dept1 like dpt_dept no-undo.
/* SS - 090223.1 - E */
                                     

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE rwdprp_p_2 "Accounts !Bdn Usage"
/* MaxLen: Comment: */

&SCOPED-DEFINE rwdprp_p_3 "--------!Bdn Rate"
/* MaxLen: Comment: */

&SCOPED-DEFINE rwdprp_p_4 "---------!Lbr Usage"
/* MaxLen: Comment: */

&SCOPED-DEFINE rwdprp_p_5 "Labor Capacity"
/* MaxLen: Comment: */

&SCOPED-DEFINE rwdprp_p_6 "Variance!Lbr Rate"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define variable dept like dpt_dept.
define variable dept1 like dpt_dept.
define variable acct_label as character format "x(5)".

/* SELECT FORM */
form
   dept           colon 25
   dept1          label {t001.i}
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */

{wbrp01.i}

/* SS - 090223.1 - B
禁止循环执行
repeat:
SS - 090223.1 - E */

/* SS - 090223.1 - B */
/* 将输入参数的值传递给本地变量 */
dept = i_dept.
dept1 = i_dept1.
/* SS - 090223.1 - E */


   if dept1 = hi_char then dept1 = "".

   /* SS - 090223.1 - B
   禁止编辑本地变量

   if c-application-mode <> 'web' then
      update dept dept1 with frame a.

   {wbrp06.i &command = update &fields = "  dept dept1" &frm = "a"}
   SS - 090223.1 - E */

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i dept   }
      {mfquoter.i dept1  }

      if dept1 = "" then dept1 = hi_char.

   end.

   /* SS - 090223.1 - B
   禁止选择打印机和显示页眉
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
   SS - 090223.1 - E */

   for each dpt_mstr  where dpt_mstr.dpt_domain = global_domain and  dpt_dept
   >= dept and dpt_dept <= dept1
         no-lock with frame b width 132 no-attr-space:

      {mfrpchk.i}

      /* SS - 090223.1 - B
      禁止标准输出

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).
      display
         dpt_dept
         dpt_desc
         space(4)
         dpt_lbr_cap  column-label {&rwdprp_p_5}
         space(4)
         getTermLabelRtColon("ACCOUNT",5) @ acct_label no-label
         dpt_cop_acct
         dpt_lbr_acct
         dpt_bdn_acct
         space(4)
         dpt_lvar_acc column-label {&rwdprp_p_4}
         dpt_lvrr_acc column-label {&rwdprp_p_6}
         dpt_bvar_acc column-label {&rwdprp_p_2}
         dpt_bvrr_acc column-label {&rwdprp_p_3}.

      down 1.

      display
         getTermLabelRtColon("SUB-ACCOUNT",5) @ acct_label no-label
         dpt_cop_sub  @ dpt_cop_acct
         dpt_lbr_sub  @ dpt_lbr_acct
         dpt_bdn_sub  @ dpt_bdn_acct
         dpt_lvar_sub @ dpt_lvar_acc
         dpt_lvrr_sub @ dpt_lvrr_acc
         dpt_bvar_sub @ dpt_bvar_acc
         dpt_bvrr_sub @ dpt_bvrr_acc.
      down 1.

      display
         getTermLabelRtColon("COST_CENTER",5) @ acct_label no-label
         dpt_cop_cc  @ dpt_cop_acct
         dpt_lbr_cc  @ dpt_lbr_acct
         dpt_bdn_cc  @ dpt_bdn_acct
         dpt_lvar_cc @ dpt_lvar_acc
         dpt_lvrr_cc @ dpt_lvrr_acc
         dpt_bvar_cc @ dpt_bvar_acc
         dpt_bvrr_cc @ dpt_bvrr_acc.
      SS - 090223.1 - E */

      /* SS - 090223.1 - B */
      /* 写入临时表 */
      CREATE ttxxrwdprp0001.
      ASSIGN
         ttxxrwdprp0001_dpt_dept = dpt_dept
         ttxxrwdprp0001_dpt_desc = dpt_desc
         ttxxrwdprp0001_dpt_lbr_cap = dpt_lbr_cap
         ttxxrwdprp0001_dpt_cop_acct = dpt_cop_acct
         ttxxrwdprp0001_dpt_lbr_acct = dpt_lbr_acct
         ttxxrwdprp0001_dpt_bdn_acct = dpt_bdn_acct
         ttxxrwdprp0001_dpt_lvar_acc = dpt_lvar_acc
         ttxxrwdprp0001_dpt_lvrr_acc = dpt_lvrr_acc
         ttxxrwdprp0001_dpt_bvar_acc = dpt_bvar_acc
         ttxxrwdprp0001_dpt_bvrr_acc = dpt_bvrr_acc
         ttxxrwdprp0001_dpt_cop_sub = dpt_cop_sub
         ttxxrwdprp0001_dpt_lbr_sub = dpt_lbr_sub
         ttxxrwdprp0001_dpt_bdn_sub = dpt_bdn_sub
         ttxxrwdprp0001_dpt_lvar_sub = dpt_lvar_sub
         ttxxrwdprp0001_dpt_lvrr_sub = dpt_lvrr_sub
         ttxxrwdprp0001_dpt_bvar_sub = dpt_bvar_sub
         ttxxrwdprp0001_dpt_bvrr_sub = dpt_bvrr_sub
         ttxxrwdprp0001_dpt_cop_cc = dpt_cop_cc
         ttxxrwdprp0001_dpt_lbr_cc = dpt_lbr_cc
         ttxxrwdprp0001_dpt_bdn_cc = dpt_bdn_cc
         ttxxrwdprp0001_dpt_lvar_cc = dpt_lvar_cc
         ttxxrwdprp0001_dpt_lvrr_cc = dpt_lvrr_cc
         ttxxrwdprp0001_dpt_bvar_cc = dpt_bvar_cc
         ttxxrwdprp0001_dpt_bvrr_cc = dpt_bvrr_cc
         .
      /* SS - 090223.1 - E */

   end.

   /* SS - 090223.1 - B
   禁止显示页脚和循环执行
   /* REPORT TRAILER  */
   {mfrtrail.i}

end.
SS - 090223.1 - E */

{wbrp04.i &frame-spec = a}
