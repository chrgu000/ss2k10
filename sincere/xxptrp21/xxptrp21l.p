/* xxptrp21l.p - CURRENT SURPLUS INVENTORY                              */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.6.2.7 $                                                     */
/*V8:ConvertMode=FullGUIReport                                          */
/* REVISION: 7.0      LAST MODIFIED: 03/13/92   BY: pma *F088*          */
/* REVISION: 7.3      LAST MODIFIED: 09/18/92   BY: pma *G068*          */
/* REVISION: 7.3      LAST MODIFIED: 04/12/93   BY: pma *G940*          */
/* REVISION: 7.3      LAST MODIFIED: 12/23/93   BY: ais *GI30*          */
/* REVISION: 7.3      LAST MODIFIED: 08/04/94   BY: pxd *GL11*          */
/* REVISION: 8.6      LAST MODIFIED: 10/09/97   BY: GYK *K0Q5*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 06/26/00   BY: *N0DM* Rajinder Kamra   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb              */
/* REVISION: 9.1      LAST MODIFIED: 09/13/00   BY: *N0W9* BalbeerS Rajput  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.6.2.6  BY: Paul Donnelly (SB)  DATE: 06/28/03  ECO: *Q00K*     */
/* $Revision: 1.6.2.7 $ BY: Katie Hilbert       DATE: 10/13/03  ECO: *Q04B*   */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/


/* 130827 *********************************************************************
 * 如果Tr里选定日期内的iss-wo数量在指定数量范围内则不算做呆滞。

2、请提供以下客制化开发的报价    EMAIL： 2013/8/21 (周三) 17:34
具体如下：
现我司需要在“3.6.8 当前多余库存报表 ”增加数量筛选过滤条件

此条件为：筛选物料编码发生领用事务的数量（每一条数据），
          如果符合此条件，此数据算到多余库存上

ppptrp21.p 1+                 3.6.8 当前多余库存报表                  13/08/19
?              地点:                            至:                           ?
?            产品线:                            至:                           ?
?            物料号:                            至:                           ?
?            ABC 类:                            至:                           ?
?              库位:                            至:                           ?
?          库存状态:                            至:                           ?
?          物料状态:                            至:                           ?
       事务变化数量：                           至：
?                                                                             ?
?                        上次发放:   /  /                                     ?
?          成本计算法 (当前/总账): G)总账                                     ?
?                   S)汇总/D)明细: D)明细                      输出:          ?
?                                                         批处理 ID:
-------------------------------------------------------------------------------
例如：设定数量0至100

以下物料不算到多余库存
日期     类型   数量  库位
12/08/17 ISS-WO -20   1043 （此数据没触发）
12/08/17 ISS-WO -150  1043 （此数据，超过了设定，触发了筛选条件）
---------------------------
以下物料算多余库存
日期     类型   数量  库位
12/08/17 ISS-WO -20   1043 （此数据没触发）
12/08/17 ISS-WO -100  1043 （此数据没触发）

顺德盛熙/阿源

注意：此程序查询TR时有对地点,库位做匹配
 * 130827 *********************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "130827"}
{cxcustom.i "PPPTRP21.P"}

define variable abc     like pt_abc       no-undo.
define variable abc1    like pt_abc       no-undo.
define variable loc     like ld_loc       no-undo.
define variable loc1    like ld_loc       no-undo.
define variable site    like ld_site      no-undo.
define variable site1   like ld_site      no-undo.
define variable part    like pt_part      no-undo.
define variable part1   like pt_part      no-undo.
define variable line    like pt_prod_line no-undo.
define variable line1   like pt_prod_line no-undo.
define variable stat    like ld_status    no-undo.
define variable stat1   like ld_status    no-undo.
define variable ptstat  like pt_status label "Item Status" no-undo.
define variable ptstat1 like pt_status    no-undo.
define variable summary like mfc_logical  no-undo
                        label "Summary/Detail" format "Summary/Detail".
define variable date1   like in_iss_date initial ? no-undo.
define variable issdate like in_iss_date  no-undo.
define variable curr_yn like mfc_logical format "Current/GL"
                        label "Cost Method (Current/GL)" no-undo.
define variable qty_x   like in_qty_oh column-label "Expired Qty"
                        format "->,>>>,>>9.9<<<<<<<" no-undo.
define variable qty_1   like in_qty_oh
                        format "->,>>>,>>9.9<<<<<<<" no-undo.
define variable val_x   like glt_amt column-label "Expired Value"
                        format "->>,>>>,>>>,>>9" no-undo.
define variable val_1   like val_x column-label "Value on Hand" no-undo.
define variable prodhdr like pt_part format "x(26)" no-undo.
define variable sitehdr like pt_part format "x(26)" no-undo.
define variable prod_yn as logical no-undo.
define variable pgflag  as logical no-undo.
define variable qty     as decimal initial 0.
define variable qty1    as decimal initial 100.

/*VARIABLE DEFINITIONS FOR GPFIELD.I*/
{gpfieldv.i}

/* SELECT FORM */
form
   site           colon 20
   site1          label "To" colon 51
   line           colon 20
   line1          label "To" colon 51 skip
   part           colon 20
   part1          label "To" colon 51 skip
   abc            colon 20
   abc1           label "To" colon 51
   loc            colon 20
   loc1           label "To" colon 51
   stat           colon 20
   stat1          label "To" colon 51
   ptstat         colon 20
   ptstat1        label "To" colon 51
   qty            colon 20
   qty1           label "To" colon 51 skip(1)
   date1          colon 34
   curr_yn        colon 34
   summary        colon 34
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form header
   skip(1)
with frame hdr page-top width 132 attr-space.

/* REPORT BLOCK */

{wbrp01.i}
repeat:

   if line1   = hi_char then line1 = "".
   if part1   = hi_char then part1 = "".
   if abc1    = hi_char then abc1 = "".
   if site1   = hi_char then site1 = "".
   if loc1    = hi_char then loc1 = "".
   if stat1   = hi_char then stat1 = "".
   if ptstat1 = hi_char then ptstat1 = "".
   if date1   = low_date then date1 = ?.

   if c-application-mode <> 'web' then
      update
         site site1
         line line1
         part part1
         abc abc1
         loc loc1
         stat stat1
         ptstat ptstat1
         qty qty1
         date1
         curr_yn
         summary
      with frame a.

   {wbrp06.i &command = update &fields = "  site site1 line line1
        part part1 abc abc1 loc loc1 stat stat1 ptstat ptstat1 qty qty1
        date1 curr_yn summary" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".

      {mfquoter.i site   }
      {mfquoter.i site1  }
      {mfquoter.i line   }
      {mfquoter.i line1  }
      {mfquoter.i part   }
      {mfquoter.i part1  }
      {mfquoter.i abc    }
      {mfquoter.i abc1   }
      {mfquoter.i loc    }
      {mfquoter.i loc1   }
      {mfquoter.i stat   }
      {mfquoter.i stat1  }
      {mfquoter.i ptstat }
      {mfquoter.i ptstat1}
      {mfquoter.i date1  }
      {mfquoter.i curr_yn}
      {mfquoter.i summary}

      if line1   = "" then line1 = hi_char.
      if part1   = "" then part1 = hi_char.
      if abc1    = "" then abc1 = hi_char.
      if site1   = "" then site1 = hi_char.
      if loc1    = "" then loc1 = hi_char.
      if stat1   = "" then stat1 = hi_char.
      if ptstat1 = "" then ptstat1 = hi_char.
      if date1   = ?  then date1 = low_date.

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
   view frame hdr.

   assign
      pgflag = yes
      qty_x  = 0
      qty_1  = 0
      val_x  = 0
      val_1  = 0.

   for each ld_det no-lock
      where  ld_domain = global_domain
         and ld_part >= part and ld_part <= part1
         and ld_site >= site and ld_site <= site1
         and ld_loc >= loc and ld_loc <= loc1
         and (ld_status >= stat and ld_status <= stat1),
      each in_mstr no-lock
         where in_domain = global_domain
           and in_part = ld_part and in_site = ld_site
           and in_abc >= abc and in_abc <= abc1,
      each is_mstr no-lock
         where is_domain = global_domain
           and is_status = ld_status,
      each pt_mstr no-lock
         where pt_domain = global_domain
           and pt_part = ld_part
           and (pt_prod_line >= line and pt_prod_line <= line1)
           and (pt_status >= ptstat and pt_status <= ptstat1)
   break by ld_site by pt_prod_line by ld_part
   with frame c down width 132:

      form
         pt_part    format "x(26)"
         pt_desc1
         issdate
         pt_pm_code column-label "P!M"
         pt_status
         qty_x
         val_x
         qty_1
         val_1
      with frame c width 132.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame c:handle).

      if first-of(ld_site) then do:
         sitehdr = "".
         find si_mstr
            where si_domain = global_domain
             and  si_site = ld_site no-lock no-error.

         {gpfield.i &field_name='si_site'}
         if field_found then
            sitehdr = (substring((field_label),1,9)) + ": " + si_site.
      end.

      if first-of(pt_prod_line) then do:
         prodhdr = "".
         find pl_mstr
            where pl_domain = global_domain
              and pl_prod_line = pt_prod_line
         no-lock no-error.
         {gpfield.i &field_name='pl_prod_line'}
         if field_found then
            prodhdr = fill(" ",2) + (substring((field_label),1,12))
                    + ": " + pl_prod_line.
         prod_yn = yes.
      end.

      if page-size - line-counter <= 3 then pgflag = yes.
      if first-of(ld_site)
         and page-size - line-counter <= 5 then pgflag = yes.
      if first-of(pt_prod_line)
         and page-size - line-counter <= 4 then pgflag = yes.
      if last-of(ld_site)
         and page-size - line-counter <= 8 then pgflag = yes.
      if last-of(pt_prod_line)
         and page-size - line-counter <= 6 then pgflag = yes.

      if pgflag then do:
         page.
         display sitehdr @ pt_part.
         down.
         assign
            pgflag  = no
            prod_yn = yes.
      end.
      else if first-of(ld_site) then do:
         down 2.
         display sitehdr @ pt_part.
         down.
      end.

      if first-of(ld_part) then do:
         /*FIND DATE OF LAST ISSUE*/
         issdate = ?.
         {&PPPTRP21-P-TAG1}
         find last tr_hist
            where tr_domain = global_domain
             and (tr_part = ld_part
             and (tr_type = "ISS-SO" or tr_type = "ISS-WO"
             or tr_type = "ISS-UNP" or tr_type = "ISS-FAS")
             and tr_site = ld_site)
         use-index tr_part_eff no-lock no-error.
         {&PPPTRP21-P-TAG2}
         if available tr_hist then do:
            issdate = tr_effdate.
         end.
         else do:
            if in_iss_date <> ? then issdate = in_iss_date.
            else if in_rec_date <= date1 then issdate = in_rec_date.
         end.
      end.

/*828*/   find first tr_hist use-index tr_part_eff no-lock
/*828*/        where tr_domain = global_domain
/*828*/          and tr_part = ld_part
/*828*/          and tr_type = "iss-wo"
/*828*/          and tr_site = ld_site
/*828*/          and tr_loc = ld_loc
/*828*/          and ((tr_effdate >= date1 and date1 <> ?) or date1 = ?)
/*828*/          and tr_qty_loc < 0
/*828*/          and (tr_qty_loc * -1 > qty1  or tr_qty_loc * -1 < qty) no-error.
/*828*/   if not available tr_hist then do:
/*828*/      qty_x = qty_x + ld_qty_oh.
/*828*/   end.
             qty_1 = qty_1 + ld_qty_oh.

/******************************************************************************
      if ld_expire <> ? and ld_expire < today then do:
              qty_x = qty_x + ld_qty_oh.
      end.
      else if issdate <> ? and issdate <= date1
         then qty_1 = qty_1 + ld_qty_oh.
******************************************************************************/

      if last-of(ld_part) and (qty_x <> 0 or qty_1 <> 0) then do:
         /*FIND UNIT COST TO USE*/
         assign
            glxcst = 0
            curcst = 0.
         {gpsct03.i &cost=sct_cst_tot}

         /*CALCULATE INVENTORY VALUES*/
         if curr_yn then
            assign
               val_x = qty_x * curcst
               val_1 = qty_1 * curcst.
         else
            assign
               val_x = qty_x * glxcst
               val_1 = qty_1 * glxcst.

         accumulate val_x(total by ld_site by pt_prod_line).
         accumulate val_1(total by ld_site by pt_prod_line).
         accumulate qty_x(total by ld_site by pt_prod_line).
         accumulate qty_1(total by ld_site by pt_prod_line).

         if not summary then do:
            if prod_yn then do:
               display prodhdr @ pt_part.
               down.
               prod_yn = no.
            end.
            display
               fill(" ",4) + pt_part @ pt_part
               pt_desc1
               issdate
               pt_pm_code
               pt_status
               qty_x
               val_x
               qty_1
               val_1.
         end.

         assign
            qty_x = 0
            qty_1 = 0.

      end. /*if last-of(ld_part)*/

      if last-of(pt_prod_line) then do:
         if prod_yn then display prodhdr @ pt_part.

         if ((accum total by pt_prod_line qty_x) = 0 and
             (accum total by pt_prod_line qty_1) = 0)
            or summary
         then do:

            display
               prodhdr when (not prod_yn)          @ pt_part
               (accum total by pt_prod_line val_x) @ val_x
               (accum total by pt_prod_line val_1) @ val_1.
            if summary then down.
            else down 1.
         end.
         else do:
            down.
            underline val_x val_1.
            display
               prodhdr + " " + getTermLabel("TOTAL",6) @ pt_part
               (accum total by pt_prod_line val_x)     @ val_x
               (accum total by pt_prod_line val_1)     @ val_1.
            down 1.
         end.
         prod_yn = no.
      end.

      if last-of(ld_site) then do:
         underline val_x val_1.
         display
            sitehdr + " " + getTermLabel("TOTAL",6) @ pt_part
            (accum total by ld_site val_x)          @ val_x
            (accum total by ld_site val_1)          @ val_1.
      end.

      if last(ld_part) then do:
         underline val_x val_1.
         display
            getTermLabel("REPORT_TOTAL",26) @ pt_part
            (accum total val_x)             @ val_x
            (accum total val_1)             @ val_1.
      end.

      {mfrpchk.i}

   end.

   /* REPORT TRAILER */
   {mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}
