/* glcalrp.p - GENERAL LEDGER CALENDAR REPORT                           */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.9 $                                                     */
/*V8:ConvertMode=FullGUIReport                                          */
/* REVISION: 1.0      LAST MODIFIED: 09/18/86   BY: JMS                 */
/*                                   01/29/88   by: jms                 */
/*                                   02/24/88   by: jms                 */
/* REVISION: 4.0      LAST MODIFIED: 02/29/88   BY: WUG  *A175*         */
/* REVISION: 5.0      LAST MODIFIED: 06/22/89   BY: JMS  *B066*         */
/* REVISION: 6.0      LAST MODIFIED: 07/03/90   by: jms  *D034*         */
/* REVISION: 7.0      LAST MODIFIED: 10/04/91   by: jms  *F058*         */
/* REVISION: 7.4      LAST MODIFIED: 07/20/93   by: pcd  *H040*         */
/*                                   09/03/94   by: srk  *FQ80*         */
/* REVISION: 8.6      LAST MODIFIED: 10/11/97   BY: ays  *K0TT*         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.7  BY: Katie Hilbert DATE: 08/03/01 ECO: *P01C* */
/* $Revision: 1.9 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 091127.1 By: Bill Jiang */

/* SS - 091127.1 - RNB
[091127.1]

计算顺序如下:
1. 删除旧数据
2. 计算分配比例明细文件的单量和总量
2.1 不是在导入时计算
3. 分别每一个间接费用格式位置计算分配范围
3.1 按以下优先顺序计算:
3.1.1 零件
3.1.2 产品线
3.1.3 在制品成本中心(适用于标准加工单)
3.1.4 生产线(适用于累计加工单)
3.2 仅适用于加工单[期初数量] + [期间增加数量] <> 0的记录
3.3 如果分配范围为空,则提示如下错误:
3.3.1 301601 - 非库存格式位置#分配比例为0
4. 基于分配范围和分配比例明细文件计算最终使用的分配比例:
4.1 可能的错误: 
4.1.1 301602 - 没有设置间接成本分配控制文件 [xxicpm01.p]
4.1.2 301614 - 找不到间接费用<#>(格式位置<#>)的分配比例
4.1.3 301615 - 间接费用<#>(格式位置<#>)的分配比例为0
4.1.4 301601 - 非库存格式位置#分配比例为0
4.2 如果出错，则顺序输出以下字段信息:
4.2.1 间接费用格式位置 [ttwo_fpos]
4.2.2 分配比例 [ttwo_ar]
4.2.3 零件 [ttwo_part]
4.2.4 加工单标志(ID) [ttwo_lot]
4.2.5 总量 [ttwo_usage_tot]
4.3 分别第一个间接费用格式位置计算最终使用的分配比例
4.4 间接费用格式位置的最后一个分配比例 = 1 - 此前的累计分配比例
5. 最后的分配:
5.1 可能的错误:
5.1.1 301601 - 非库存格式位置#分配比例为0(分配前后的差异绝对值大于0.000001)
5.2 间接费用的最后一个分配金额 = 间接费用分配前的金额 - 此前的累计分配金额
 
如果成功,则顺序输出以下列:
1. 会计单位
2. 年份
3. 期间
4. 件号
5. 工单
6. 成本要素
7. 金额

可能的错误:
1. 期间未定义

可能的警告:
1. 数据已经存在
1.1 有可选择的继续执行(覆盖已有的数据)
1.2 或中止执行

注意事项:
1. 如果出现任何异常,则已经执行的事务将被撤消,即要么全部成功,要么全部失败

[091127.1]

SS - 091127.1 - RNE */

/* DISPLAY TITLE */
{mfdtitle.i "091127.1"}

/* 定义 */
{xxiceyp1.i}
{xxicaldc.i "new"}

{wbrp01.i}

/* REPORT BLOCK */
mainloop:
repeat:
   {xxiceyp2.i}

   /* 已经创建 */
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      ,EACH xxical_mstr NO-LOCK
      WHERE xxical_domain = GLOBAL_domain
      AND xxical_entity = en_entity
      AND xxical_year = yr
      AND xxical_per = per
      :
      /* Do you want to continue? */
      {pxmsg.i &MSGNUM=6398 &ERRORLEVEL=2 &CONFIRM=l_yn}

      if not l_yn then do:
         next-prompt per.
         UNDO mainloop, retry.
      end. /* IF NOT l_yn */

      LEAVE.
   END.

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      /* CREATE BATCH INPUT STRING */
      bcdparm = "".
      {mfquoter.i entity }
      {mfquoter.i yr     }
      {mfquoter.i per     }
   end.

   {xxSoftspeedLic.i "SoftspeedPC.lic" "SoftspeedPC"}

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 80
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

   DO TRANSACTION ON STOP UNDO:
      /* 删除 */
      {gprun.i ""xxicaldcdel.p"" "(
         INPUT entity,
         INPUT yr,
         INPUT per
         )"}

      /* 分配比例 */
      {gprun.i ""xxicaldcar.p"" "(
         INPUT entity,
         INPUT yr,
         INPUT per
         )"}

      /* 分配范围 */
      {gprun.i ""xxicaldcto.p"" "(
         INPUT entity,
         INPUT yr,
         INPUT per
         )"}
      IF RETURN-VALUE = "no" THEN DO:
         STOP.
      END.

      /* 分配范围比例 */
      {gprun.i ""xxicaldctoar.p"" "(
         INPUT entity,
         INPUT yr,
         INPUT per
         )"}
      IF RETURN-VALUE = "no" THEN DO:
         STOP.
      END.

      /* 分配 */
      {gprun.i ""xxicaldcal.p"" "(
         INPUT entity,
         INPUT yr,
         INPUT per
         )"}
      IF RETURN-VALUE = "no" THEN DO:
         STOP.
      END.
   END. /* DO TRANSACTION ON STOP UNDO: */

   PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname, 1, LENGTH(execname) - 2) SKIP.
   PUT UNFORMATTED "#def :end" SKIP.

   EXPORT DELIMITER ";" 
      "会计单位"
      "年份"
      "期间"
      "件号"
      "工单"
      "成本要素"
      "金额"
      .
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      ,EACH xxical_mstr NO-LOCK
      WHERE xxical_domain = GLOBAL_domain
      AND xxical_entity = entity
      AND xxical_year = yr
      AND xxical_per = per
      BY xxical_entity
      BY xxical_year
      BY xxical_per
      BY xxical_part
      BY xxical_lot
      BY xxical_element
      :
      EXPORT DELIMITER ";"
         xxical_entity
         xxical_year
         xxical_per
         xxical_part
         xxical_lot
         xxical_element
         xxical_cst
         .
   END.
   
   {xxmfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
