/* pppcrp.p - type_xxpctt PRICE REPORT                                         */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.16 $                                                     */
/*V8:ConvertMode=FullGUIReport                                          */
/* REVISION: 6.0      LAST MODIFIED: 02/20/91   BY: afs *D355**/
/* REVISION: 7.0      LAST MODIFIED: 04/24/92   BY: tjs *F425**/
/* REVISION: 7.3      LAST MODIFIED: 09/12/92   BY: tjs *G035**/
/* REVISION: 7.4      LAST MODIFIED: 06/30/94   BY: qzl *H420**/
/* REVISION: 7.4      LAST MODIFIED: 10/17/95   BY: ais *H0GH**/
/* REVISION: 8.6      LAST MODIFIED: 10/07/97   BY: mzv *K0MD**/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 07/20/98   BY: *J2S0* Samir Bavkar */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 07/25/00   BY: *N0GQ* BalbeerS Rajput    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.15     BY: Paul Donnelly (SB)  DATE: 06/28/03  ECO: *Q00K*     */
/* $Revision: 1.16 $     BY: Katie Hilbert       DATE: 10/13/03  ECO: *Q04B*   */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 090520.1 By: Bill Jiang */

/* SS - 090520.1 - RNB
[090520.1]

顺序输出了以下字段:
  - 地点代码
  - 零件类型代码
  - 事务类型代码
  - 开始生效日期
  - 结束生效日期
  - 成本选项

按以下字段排序:
  - 地点代码
  - 零件类型代码
  - 事务类型代码
  - 开始生效日期

[090520.1]

SS - 090520.1 - RNE */

/* DISPLAY TITLE */
{mfdtitle.i "1+ "}

define variable site_xxpctt  like xxpctt_site no-undo.
define variable site_xxpctt1 like xxpctt_site no-undo.
define variable type_xxpctt   like xxpctt_type no-undo.
define variable type_xxpctt1  like xxpctt_type no-undo.
define variable prod_line_xxpctt   like xxpctt_prod_line no-undo.
define variable prod_line_xxpctt1  like xxpctt_prod_line no-undo.
define variable eff    like ap_effdate initial today no-undo.

DEFINE VARIABLE addr_global LIKE GLOBAL_addr.

/* SELECT FORM */
form
   site_xxpctt          colon 15
   site_xxpctt1         label "To" colon 49 skip
   prod_line_xxpctt           colon 15
   prod_line_xxpctt1          label "To" colon 49 skip
   type_xxpctt           colon 15
   type_xxpctt1          label "To" colon 49 skip
   eff            colon 15 skip
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* REPORT BLOCK */

{wbrp01.i}
repeat:
   if site_xxpctt1 = hi_char then site_xxpctt1 = "".
   if type_xxpctt1  = hi_char then type_xxpctt1  = "".
   if prod_line_xxpctt1  = hi_char then prod_line_xxpctt1  = "".

   addr_global = GLOBAL_addr.
   GLOBAL_addr = "tr_type".

   if c-application-mode <> 'web' then
      update
         site_xxpctt 
         site_xxpctt1
         prod_line_xxpctt 
         prod_line_xxpctt1
         type_xxpctt 
         type_xxpctt1
         eff
      with frame a.

   {wbrp06.i &command = update &fields = "  site_xxpctt site_xxpctt1 prod_line_xxpctt prod_line_xxpctt1 type_xxpctt
        type_xxpctt1 eff" &frm = "a"}

   GLOBAL_addr = addr_global.

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i site_xxpctt  }
      {mfquoter.i site_xxpctt1 }
      {mfquoter.i prod_line_xxpctt   }
      {mfquoter.i prod_line_xxpctt1  }
      {mfquoter.i type_xxpctt   }
      {mfquoter.i type_xxpctt1  }
      {mfquoter.i eff    }
      if site_xxpctt1 = "" then site_xxpctt1 = hi_char.
      if prod_line_xxpctt1  = "" then prod_line_xxpctt1  = hi_char.
      if type_xxpctt1  = "" then type_xxpctt1  = hi_char.
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

   /* SS - 090520.1 - B */
   PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname, 1, LENGTH(execname) - 2) SKIP.
   PUT UNFORMATTED "#def :end" SKIP.

   /* DISPLAY INFORMATION */
   EXPORT DELIMITER ";"
      "地点代码"
      "零件类型代码"
      "事务类型代码"
      "开始生效日期"
      "结束生效日期"
      "成本选项"
      .
   FOR EACH xxpctt_mstr NO-LOCK
      WHERE xxpctt_domain = GLOBAL_domain
      AND xxpctt_site >= site_xxpctt
      AND xxpctt_site <= site_xxpctt1
      AND xxpctt_prod_line >= prod_line_xxpctt
      AND xxpctt_prod_line <= prod_line_xxpctt1
      AND xxpctt_type >= TYPE_xxpctt
      AND xxpctt_type <= TYPE_xxpctt1
      AND (((xxpctt_start <= eff OR xxpctt_start = ?) AND (xxpctt_expire >= eff OR xxpctt_expire = ?)) OR eff = ?)
      BREAK 
      BY xxpctt_site DESC
      BY xxpctt_prod_line DESC
      BY xxpctt_type DESC
      BY xxpctt_start
      :
      EXPORT DELIMITER ";"
         xxpctt_site
         xxpctt_prod_line
         xxpctt_type
         xxpctt_start
         xxpctt_expire
         xxpctt_cost
         .
   END.

   {xxmfrtrail.i}
   /* SS - 090520.1 - E */
end.

{wbrp04.i &frame-spec = a}
