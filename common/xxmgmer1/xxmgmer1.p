/* mgmerp.p - MENU REPORT                                                     */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.7.2.4 $                                                       */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 1.0      LAST MODIFIED: 07/17/86   BY: PML      */
/* REVISION: 4.0      LAST MODIFIED: 01/09/88   BY: WUG *4.0**/
/* REVISION: 4.0      LAST MODIFIED: 02/24/88   BY: WUG *A175**/
/* REVISION: 4.0      LAST MODIFIED: 05/27/88   BY: flm *A258**/
/* REVISION: 4.0      LAST MODIFIED: 12/23/88   BY: MLB *A570**/
/* REVISION: 5.0      LAST MODIFIED: 03/21/89   BY: MLB *B073**/
/* REVISION: 5.0      LAST MODIFIED: 03/27/89   BY: WUG *B075**/
/* REVISION: 6.0      LAST MODIFIED: 06/27/91   BY: emb *D730**/
/* REVISION: 8.5      LAST MODIFIED: 11/22/95   BY: *J094* Tom Vogten         */
/* REVISION: 8.6      LAST MODIFIED: 12/09/97   BY: bvm *K1CT**/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/25/00   BY: *N0W9* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.7.2.4 $   BY: Jean Miller        DATE: 06/25/02  ECO: *P09H*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* 以下为版本历史 */
/* SS - 090414.1 By: Bill Jiang */
/* SS - 090120.1 By: Bill Jiang */

/*以下为发版说明 */
/* SS - 090414.1 - RNB
【090414.1】

此前的输入字段如下:
  - 执行文件前缀:__
  
此后的输入字段如下:
  - 执行文件:__________ 至:__________

【090414.1】

SS - 090414.1 - RNE */

/* SS - 090120.1 - RNB
【090120.1】

初发行版

获得主程序文件的版本

顺序输出以下列(用制表符分隔):
  - 主程序文件名
  - 版本

通过运行程序可以验证结果的正确性

已知问题:
  - 部分固定资产程序由于其退出方式不同,运行异常

【090120.1】

SS - 090120.1 - RNE */

/*
{mfdtitle.i "2+ "}
*/
{mfdtitle.i "090414.1"}
{cxcustom.i "MGMERP.P"}

define new shared variable lang  like lng_lang.
define new shared variable nbr   as integer format ">>" label "Menu Number".
define new shared variable nbr1  as integer format ">>".
define new shared variable menunbr as character.
define new shared variable sel_password as character format "x(24)"
   label "User ID/Group".

/* SS - 090414.1 - B */
DEFINE NEW SHARED VARIABLE exec LIKE mnd_exec.
DEFINE NEW SHARED VARIABLE exec1 LIKE mnd_exec.

exec = "xx".
exec1 = "xy".
/* SS - 090414.1 - E */

lang = global_user_lang.

/* SELECT FORM */
form
   /* SS - 090414.1 - B
   lang              colon 20
   skip(1)
   nbr               colon 20
   nbr1 label        "To" colon 35
   skip(1)
   sel_password      colon 20
   SS - 090414.1 - E */

   /* SS - 090414.1 - B */
   exec               colon 20
   exec1 label        "To" colon 50
   skip(1)
   /* SS - 090414.1 - E */
with frame a side-labels attr-space
   width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* SS - 090414.1 - B */
exec:LABEL IN FRAME a = "Execution File". 
exec1:LABEL IN FRAME a = "To". 
/* SS - 090414.1 - E */

{wbrp01.i}
{&MGMERP-P-TAG1}

/* REPORT BLOCK */
repeat with frame a:

   menunbr = "0".
   if nbr1 = 99 then nbr1 = 0.

   if c-application-mode <> 'web' then
      update 
      /* SS - 090414.1 - B
      lang 
      nbr nbr1 sel_password 
      SS - 090120.1 - E */
      /* SS - 090414.1 - B */
      exec
      exec1
      /* SS - 090120.1 - E */
      with frame a.

   {wbrp06.i &command = update &fields = "  
      /* SS - 090414.1 - B
      lang 
      nbr nbr1 sel_password
      SS - 090414.1 - E */
      /* SS - 090414.1 - B */
      exec
      exec1
      /* SS - 090414.1 - E */
      "
      &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i lang   }
      {mfquoter.i nbr    }
      {mfquoter.i nbr1   }
      {mfquoter.i sel_password}
      /* SS - 090414.1 - B */
      {mfquoter.i exec    }
      {mfquoter.i exec1   }
      /* SS - 090414.1 - E */

      if nbr1 = 0 then nbr1 = 99.

   end.

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

   /* SS - 090120.1 - B
   {gprun.i ""mgmerp01.p""}
   SS - 090120.1 - E */

   /* SS - 090120.1 - B */
   {gprun.i ""xxmgmer101.p""}
   /* SS - 090120.1 - E */

   /* REPORT TRAILER */
   {mfrtrail.i}
end.

{wbrp04.i &frame-spec = a}
