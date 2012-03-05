/* ppvprp.p - VENDOR ITEMS REPORT                                            */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.14.1.9 $                                                         */
/*V8:ConvertMode=FullGUIReport                                               */
/* REVISION: 1.0      LAST MODIFIED: 01/20/86   BY: PML                      */
/* REVISION: 1.0      LAST MODIFIED: 08/29/86   BY: EMB *12*                 */
/* REVISION: 2.1      LAST MODIFIED: 10/16/87   BY: WUG *A94*                */
/* REVISION: 4.0      LAST MODIFIED: 12/04/87   BY: pml                      */
/* REVISION: 4.0      LAST MODIFIED: 02/16/88   BY: FLM *A175*               */
/* REVISION: 4.0      LAST MODIFIED: 06/08/88   BY: flm *A268*               */
/* REVISION: 4.0      LAST MODIFIED: 10/10/88   BY: flm *A478*               */
/* REVISION: 5.0      LAST MODIFIED: 02/03/89   BY: pml *C0028*              */
/* REVISION: 7.0      LAST MODIFIED: 08/10/92   BY: afs *F841*               */
/* REVISION: 7.0      LAST MODIFIED: 08/30/94   BY: rxm *GL58*               */
/* REVISION: 8.6      LAST MODIFIED: 09/05/97   BY: Joe Gawel    *K0HL*      */
/* REVISION: 8.6      LAST MODIFIED: 10/13/97   BY: mzv *K0VT*               */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: *L00M*  DS               */
/* REVISION: 8.6E     LAST MODIFIED: 06/24/98   BY: *L01G* R. McCarthy       */
/* REVISION: 8.6E     LAST MODIFIED: 06/25/98   BY: *L03V* Brenda Milton     */
/* REVISION: 8.6E     LAST MODIFIED: 12/01/98   BY: *L0CN* Steve Goeke       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 05/03/00   BY: *N09M* Peter Faherty     */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb               */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.14.1.6  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K*     */
/* Revision: 1.14.1.8  BY: Katie Hilbert      DATE: 10/16/03 ECO: *Q04B*     */
/* $Revision: 1.14.1.9 $        BY: Nishit V           DATE: 11/28/03 ECO: *N2NM*     */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* 以下为版本历史 */
/* SS - 100401.1 By: Bill Jiang */

/*以下为发版说明 */
/* SS - 100401.1 - RNB
【100401.1】

修改于以下标准菜单程序:
  - 按库位排序的库存估价 [ppptrp07.p]

请参考以上标准菜单程序的相关帮助

请参考以下标准菜单程序进行验证:
  - 按库位排序的库存估价 [ppptrp07.p]

顺序输出了以下字段:
  - 标准输出: 地点[site]
  - 标准输出: 库位[loc]
  - 标准输出: 物料号[part]
  - 扩展输出: 批/序号[lot]
  - 标准输出: 说明[desc]
  - 标准输出: ABC[abc]
  - 标准输出: 库存量[qty]
  - 标准输出: UM[um]
  - 标准输出: 总账成本[sct]
  - 标准输出: 总账成本合计[ext]
  - 扩展输出: 非寄售[qty_non_consign]
  - 扩展输出: 客户寄售[qty_cust_consign]
  - 扩展输出: 供应商寄售[qty_supp_consign]

【100401.1】

SS - 100401.1 - RNE */

/* DISPLAY TITLE */
/*
{mfdtitle.i "1+ "}
*/
{mfdtitle.i "100401.1"}

/* SS - 100401.1 - B */
{xxppvprp0001.i "new"}
/* SS - 100401.1 - E */

/* Definitions needed for Full GUI reports */
{gprunpdf.i "mcpl" "p"}

define variable part        like vp_part no-undo.
define variable part1       like vp_part no-undo.
define variable vend        like vp_vend no-undo.
define variable vend1       like vp_vend no-undo.
define variable desc1       like pt_desc1 format "x(49)".
define variable base_rate1  like exr_rate no-undo.
define variable base_rate2  like exr_rate no-undo.
define variable data_rate   like exr_rate no-undo.
define variable rpt_rate    like exr_rate no-undo.

{etvar.i &new = "new"}        /* Common euro variables */
{etrpvar.i &new = "new"}      /* Common euro report variables*/
{eteuro.i}                    /* Get common used euro information*/
define variable et_pt_price like pt_price no-undo.
define variable mc-seq2     like mc-seq no-undo.

/* SELECT FORM */
form
   part           colon 15
   part1          label "To" colon 49 skip
   vend           colon 15
   vend1          label "To" colon 49 skip
   skip (1)
   et_report_curr colon 30
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* OUTPUT FORM */
form
   space(4)
   vp_vend         column-label "!Supplier! "
   vp_vend_part    column-label "Supplier Item! "
   vp_um           column-label "UM! "
   vp_mfgr         column-label "Mfg! "
   vp_mfgr_part    column-label "Manufacturer Item! "
   vp_vend_lead    column-label "LT! "
   vp_q_price      column-label "Quote Price!List"
   vp_q_date       column-label "Quote!Use Trans Price"
   vp_q_qty        column-label "Quote Qty!Ext%"
   vp_curr         column-label "Cur! "
with frame b down width 132.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

/* REPORT BLOCK */

{wbrp01.i}
repeat:

   if part1 = hi_char then part1 = "".
   if vend1 = hi_char then vend1 = "".

   if c-application-mode <> 'web' then
      update
         part part1
         vend vend1
         et_report_curr
   with frame a.

   {wbrp06.i &command = update &fields = "part part1 vend vend1
        et_report_curr" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i part   }
      {mfquoter.i part1  }
      {mfquoter.i vend   }
      {mfquoter.i vend1  }
      {mfquoter.i et_report_curr}

   if et_report_curr <> "" then do:
      {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
         "(input  et_report_curr,
           output mc-error-number)"}

      /* Check to see if there is a valid exchange rate */
      /* between the reporting and base currencies      */
      if mc-error-number = 0 and
         et_report_curr <> base_curr then do:
         {gprunp.i "mcpl" "p" "mc-get-ex-rate"
            "(input  base_curr,
              input  et_report_curr,
              input  "" "",
              input  et_eff_date,
              output base_rate1,
              output rpt_rate,
              output mc-error-number)"}

      end.  /* if mc-error-number = 0 and not base_curr */

      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
         if c-application-mode = 'web' then return.
         else next-prompt et_report_curr with frame a.
         undo, retry.
      end.  /* if mc-error-number <> 0 */
   end.  /* if et_report_curr <> "" */
   if et_report_curr = "" or et_report_curr = base_curr then
      assign
         et_report_curr = base_curr
         rpt_rate       = 1
         base_rate1     = 1.

   end.  /* if (c-application-mode <> 'web') ... */

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
   /* SS - 100401.1 - B
   {mfphead.i}

   if part1 = "" then part1 = hi_char.
   if vend1 = "" then vend1 = hi_char.

   for each vp_mstr
      where vp_domain = global_domain and
           (vp_part >= part and vp_part <= part1) and
           (vp_vend >= vend and vp_vend <= vend1)
   no-lock break by vp_part with frame b width 132 no-box:

      /* Check to see if there is a direct exchange */
      /* between the reporting and data currencies  */
      {gprunp.i "mcpl" "p" "mc-get-ex-rate"
         "(input  vp_curr,
           input  et_report_curr,
           input  "" "",
           input  et_eff_date,
           output et_rate1,
           output et_rate2,
           output mc-error-number)"}

      /* Get the exchange rate between the data and  */
      /* base currencies if no direct rate exists    */
      if mc-error-number <> 0 then do:
         if et_report_curr <> vp_curr then do:
            {gprunp.i "mcpl" "p" "mc-get-ex-rate"
               "(input  vp_curr,
                 input  base_curr,
                 input  "" "",
                 input  et_eff_date,
                 output data_rate,
                 output base_rate2,
                 output mc-error-number)"}

            /* Derive the exchange rate between the  */
            /* reporting and data currencies through */
            /* the base currency                     */
            if mc-error-number = 0
            then do:
               {gprunp.i "mcpl" "p" "mc-combine-ex-rates"
                  "(input  data_rate,
                    input  rpt_rate,
                    input  base_rate1,
                    input  base_rate2,
                    output et_rate1,
                    output et_rate2)" }
            end.  /* if mc-error-number */

            /* If a rate cannot be derived then */
            /* do not convert amounts in report */
            else do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               assign
                  et_rate1 = 1
                  et_rate2 = 1.
            end.
         end.  /* if et_report_curr <> vp_curr */
      end.  /* if mc-error-number <> 0 */

      /* Convert the quote price */
      {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input  vp_curr,
           input  et_report_curr,
           input  et_rate1,
           input  et_rate2,
           input  vp_q_price,
           input  true,    /* ROUND */
           output et_pt_price,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
      end.

      desc1 = "".
      find pt_mstr
         where pt_domain = global_domain
         and   pt_part = vp_part no-lock no-error.
      if available pt_mstr then desc1 = pt_desc1 + " " + pt_desc2.
      if first-of (vp_part) then do:
         if page-size - line-counter < 6 then page.
         display
         with frame b.

         put skip
            getTermLabel("ITEM",8) + ": " format "x(10)"
            vp_part space(1)
            desc1.
      end.

      display
         vp_vend
         vp_vend_part
         vp_um
         vp_mfgr
         vp_mfgr_part
         vp_vend_lead
         vp_q_date
         vp_q_qty
      with frame b.

      if et_report_curr <> vp_curr then
         display
            et_pt_price    @ vp_q_price
            et_report_curr @ vp_curr
         with frame b.
      else
         display
            vp_q_price
            vp_curr
         with frame b.

      down 1 with frame b.
      display
         vp_pr_list    @ vp_q_price
         vp_tp_use_pct @ vp_q_date
         vp_tp_pct     @ vp_q_qty
      with frame b.

      down 1 with frame b.
      {mfrpchk.i}
   end.  /* for each vp_mstr */

   /* Report trailer  */
   {mfrtrail.i}
   SS - 100401.1 - E */

   /* SS - 100401.1 - B */
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

   FOR EACH ttxxppvprp0001:
       DELETE ttxxppvprp0001.
   END.

   {gprun.i ""xxppvprp0001.p"" "(
      INPUT part,
      INPUT part1,
      INPUT vend,
      INPUT vend1,

      INPUT et_report_curr
      )"}

   EXPORT DELIMITER ";" "物料号" "供应商" "供应商物料" "测量单位" "说明" "制造商物料" "供应商提前期" "报价日期" "报价数量" "报价单价格" "货币" "价目表" "使用客户订购减缩价" "客户订购减缩价百分比" "物料说明一" "物料说明二".
   EXPORT DELIMITER ";" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出" "标准输出".
   EXPORT DELIMITER ";" "vp_part" "vp_vend" "vp_vend_part" "vp_um" "vp_mfgr" "vp_mfgr_part" "vp_vend_lead" "vp_q_date" "vp_q_qty" "vp_q_price" "vp_curr" "vp_pr_list" "vp_tp_use_pct" "vp_tp_pct" "pt_desc1" "pt_desc2".
   FOR EACH ttxxppvprp0001:
      EXPORT DELIMITER ";" ttxxppvprp0001.
   END.

   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

   {xxmfrtrail.i}
   /* SS - 100401.1 - E */

end.  /* repeat */

{wbrp04.i &frame-spec = a}
