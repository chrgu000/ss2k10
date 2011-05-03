/* soivrp09.p - INVOICE HISTORY REPORT BY INVOICE                       */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.8.2.5 $                                             */
/*V8:ConvertMode=FullGUIReport                                          */
/* REVISION: 5.0      LAST MODIFIED: 01/09/90   BY: ftb *B511**/
/* REVISION: 6.0      LAST MODIFIED: 04/13/90   BY: ftb *D002**/
/* REVISION: 6.0      LAST MODIFIED: 09/18/90   BY: MLB *D055**/
/* REVISION: 6.0      LAST MODIFIED: 11/12/90   BY: MLB *D202**/
/* REVISION: 6.0      LAST MODIFIED: 03/28/91   BY: afs *D464**/
/* REVISION: 6.0      LAST MODIFIED: 04/05/91   BY: bjb *D507**/
/* REVISION: 6.0      LAST MODIFIED: 04/10/91   BY: MLV *D506**/
/* REVISION: 6.0      LAST MODIFIED: 05/07/91   BY: MLV *D617**/
/* REVISION: 6.0      LAST MODIFIED: 08/14/91   BY: MLV *D825**/
/* REVISION: 6.0      LAST MODIFIED: 08/21/91   BY: bjb *D811*/
/* REVISION: 7.0      LAST MODIFIED: 09/16/91   BY: MLV *F015**/
/* REVISION: 7.0      LAST MODIFIED: 02/02/92   BY: pml *F129**/
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: tjs *F202**/
/* REVISION: 7.0      LAST MODIFIED: 03/04/92   BY: tjs *F247* (rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 03/17/92   BY: TMD *F259**/
/* REVISION: 7.0      LAST MODIFIED: 03/20/92   BY: TMD *F263* (rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 03/20/92   BY: dld *F322*           */
/* REVISION: 7.0      LAST MODIFIED: 04/08/92   BY: tmd *F367* (rev only)*/
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: dld *F358*           */
/* REVISION: 7.0      LAST MODIFIED: 06/19/92   BY: tmd *F458**/
/* REVISION: 7.3      LAST MODIFIED: 09/06/92   BY: afs *G047**/
/* REVISION: 7.4      LAST MODIFIED: 08/19/93   BY: pcd *H009* */
/* REVISION: 7.4      LAST MODIFIED: 05/31/94   BY: dpm *GK02* */
/* REVISION: 8.5      LAST MODIFIED: 07/27/95   BY: taf *J053* */
/* REVISION: 8.5      LAST MODIFIED: 04/09/96   BY: jzw *G1P6* */
/* REVISION: 8.6      LAST MODIFIED: 10/04/97   BY: ckm *K0LH* */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb              */
/* REVISION: 9.1      LAST MODIFIED: 10/10/00   BY: *N0W8* Mudit Mehta      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.8.2.4     BY: Katie Hilbert  DATE: 04/01/01 ECO: *P002* */
/* $Revision: 1.8.2.5 $    BY: Karan Motwani  DATE: 10/16/02 ECO: *N1WF* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 090819.1 By: Bill Jiang */

/* SS - 090819.1 - RNB
[090819.1]

修改于以下标准菜单程序:
  - 发票历史记录报表 [soivrp09.p]

不包括已经处理过的记录(ih_user1 <> '')和非库存(idh_type <> '')的记录
  - ih_user1取当前时间,格式为YYYYMMDDHHMMSS
  
顺序输出了以下字段:
  - 扩展输出: 地点[idh_site]
  - 标准输出: 客户代码[ih_cust]
  - 标准输出: 客户名称[name]
  - 标准输出: 发票号[ih_inv_nbr]
  - 标准输出: 发票日期[inv_date]
  - 扩展输出: 生效日期[ar_effdate]
  - 标准输出: 截止日期[idh_due_date]
  - 标准输出: 销售订单[idh_nbr]
  - 标准输出: 采购订单[ih_po]
  - 扩展输出: 渠道[ih_channel]
  - 标准输出: 行[idh_line]
  - 标准输出: 类型[idh_type]
  - 扩展输出: 产品类[idh_prodline]
  - 标准输出: 物料号[idh_part]
  - 标准输出: 计量单位[idh_um]
  - 标准输出: 发票数量[idh_qty_inv]
  - 标准输出: 本币单价[base_net_price]
  - 标准输出: 本币金额[base_price]
  - 标准输出: 货币[ih_curr]
  - 标准输出: 兑换率1[ih_ex_rate]
  - 标准输出: 兑换率2[ih_ex_rate2]
  - 扩展输出: 原币金额[ext_price]
  - 扩展输出: 账户[idh_acct]
  - 扩展输出: 分账户[idh_sub]
  - 扩展输出: 成本中心[idh_cc]
  - 扩展输出: 项目[idh_project]
  - 扩展输出: 纳税类别[idh_taxc]
  - 扩展输出: 是否纳税[idh_taxable]
  - 扩展输出: 是否含税[idh_tax_in]
  - 扩展输出: 税额合计[ext_tax]
  - 标准输出: 备注[ih_rmks]

[090819.1]

SS - 090819.1 - RNE */

/* DISPLAY TITLE */
/*
{mfdtitle.i "2+ "}
*/
{mfdtitle.i "090819.1"}
{cxcustom.i "SOIVRP09.P"}

/* SS - 090819.1 - B */
{xxsoivrp0901.i "new"}

DEFINE VARIABLE user1_ih LIKE ih_user1.
/* SS - 090819.1 - E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE soivrp09_p_1 "Ext Margin"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp09_p_2 "Ext Price"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp09_p_3 "Discount"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp09_p_4 "Total"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp09_p_5 "Unit Margin"
/* MaxLen: Comment: */

&SCOPED-DEFINE soivrp09_p_6 "Total Tax"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define new shared variable rndmthd like rnd_rnd_mthd.
define new shared variable oldcurr like ih_curr.
/*CHANGED ALL LOCAL VARIABLES TO NEW SHARED FOR soivrp09a.p */
define new shared variable cust like ih_cust.
define new shared variable cust1 like ih_cust.
define new shared variable inv like ih_inv_nbr.
define new shared variable inv1 like ih_inv_nbr.
define new shared variable nbr like ih_nbr.
define new shared variable nbr1 like ih_nbr.
define new shared variable name like ad_name.
define new shared variable spsn like sp_addr.
define new shared variable spsn1 like spsn.
define new shared variable po like ih_po.
define new shared variable po1 like ih_po.
define new shared variable gr_margin like idh_price label {&soivrp09_p_5}
   format "->>>>>,>>9.99".
define new shared variable ext_price like idh_price label {&soivrp09_p_2}
   format "->>,>>>,>>>.99".
define new shared variable ext_gr_margin like gr_margin
   label {&soivrp09_p_1}.
define new shared variable desc1 like pt_desc1 format "x(49)".
define new shared variable curr_cost like idh_std_cost.
define new shared variable base_price like ext_price.
define new shared variable base_margin like ext_gr_margin.
define new shared variable ext_cost like idh_std_cost.
define new shared variable base_rpt like ih_curr.
define new shared variable disp_curr as character
   format "x(1)" label "C".
define new shared variable ih_recno as recid.
define new shared variable tot_trl1 like ih_trl1_amt.
define new shared variable tot_trl3 like ih_trl3_amt.
define new shared variable tot_trl2 like ih_trl2_amt.
define new shared variable tot_disc like ih_trl1_amt label {&soivrp09_p_3}.
define new shared variable rpt_tot_tax like ih_trl2_amt
   label {&soivrp09_p_6}.
define new shared variable tot_ord_amt like ih_trl3_amt label {&soivrp09_p_4}.
define new shared variable net_price like idh_price.
define new shared variable base_net_price like net_price
                                 format "->>>>,>>>,>>9.99".
define new shared variable detail_lines like mfc_logical.
define new shared variable bill  like ih_bill.
define new shared variable bill1 like ih_bill.
define variable maint like mfc_logical.

/* SS - 090819.1 - B */
DEFINE NEW SHARED VARIABLE entity LIKE gltr_entity.
DEFINE NEW SHARED VARIABLE entity1 LIKE gltr_entity.
DEFINE NEW SHARED VARIABLE eff_dt LIKE gltr_eff_dt.
DEFINE NEW SHARED VARIABLE eff_dt1 LIKE gltr_eff_dt.
DEFINE NEW SHARED VARIABLE inv_date LIKE ih_inv_date.
DEFINE NEW SHARED VARIABLE inv_date1 LIKE ih_inv_date.
/* SS - 090819.1 - E */

{soivtot1.i "NEW" }  /* Define variables for invoice totals. */

maint = no.

{&SOIVRP09-P-TAG1}
form
   /* SS - 090819.1 - B */
   entity            colon 15
   entity1           label {t001.i} colon 49 skip
   eff_dt            colon 15
   eff_dt1           label {t001.i} colon 49 skip
   inv_date            colon 15
   inv_date1           label {t001.i} colon 49 skip
   /* SS - 090819.1 - E */
   inv            colon 15
   inv1           label {t001.i} colon 49 skip
   nbr            colon 15
   nbr1           label {t001.i} colon 49 skip
   cust           colon 15
   cust1          label {t001.i} colon 49 skip
   bill           colon 15
   bill1          label {t001.i} colon 49 skip
   spsn           colon 15
   spsn1          label {t001.i} colon 49 skip
   po             colon 15
   po1            label {t001.i} colon 49
   base_rpt       colon 15 skip
with frame a side-labels width 80.
{&SOIVRP09-P-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

repeat:
	/* SS - 090819.1 - B */
	hide all no-pause .
	view frame dtitle .
	/* SS - 090819.1 - E */

   assign
      oldcurr = ""
      tot_trl1     = 0
      tot_trl2     = 0
      tot_trl3     = 0
      tot_disc     = 0
      rpt_tot_tax  = 0
      tot_ord_amt  = 0.

   if inv1 = hi_char then inv1 = "".
   if nbr1 = hi_char then nbr1 = "".
   if cust1 = hi_char then cust1 = "".
   if bill1 = hi_char then bill1 = "".
   if spsn1 = hi_char then spsn1 = "".
   if po1 = hi_char then po1 = "".
   /* SS - 090819.1 - B */
   IF entity1 = hi_char THEN entity1 = "".
   IF eff_dt = low_date THEN eff_dt = ?.
   IF eff_dt1 = hi_date THEN eff_dt1 = TODAY.
   IF inv_date = low_date THEN inv_date = ?.
   IF inv_date1 = hi_date THEN inv_date1 = TODAY.
   /* SS - 090819.1 - E */

   if c-application-mode <> 'web' then
   {&SOIVRP09-P-TAG3}
   update 
      /* SS - 090819.1 - B */
      entity entity1 eff_dt eff_dt1 inv_date inv_date1 
      /* SS - 090819.1 - E */
      inv inv1 nbr nbr1 cust cust1
      bill bill1
      spsn spsn1 po po1
      base_rpt with frame a.

   {wbrp06.i &command = update &fields = "  
      /* SS - 090819.1 - B */
      entity entity1 eff_dt eff_dt1 inv_date inv_date1 
      /* SS - 090819.1 - E */
      inv inv1 nbr nbr1 cust cust1  bill
                                  bill1 spsn spsn1 po po1 base_rpt" &frm = "a"}
   {&SOIVRP09-P-TAG4}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      /* SS - 090819.1 - B */
      {mfquoter.i entity     }
      {mfquoter.i entity1    }
      {mfquoter.i eff_dt     }
      {mfquoter.i eff_dt1    }
      {mfquoter.i inv_date     }
      {mfquoter.i inv_date1    }
      /* SS - 090819.1 - E */
      {mfquoter.i inv     }
      {mfquoter.i inv1    }
      {mfquoter.i nbr     }
      {mfquoter.i nbr1    }
      {mfquoter.i cust    }
      {mfquoter.i cust1   }
      {mfquoter.i bill    }
      {mfquoter.i bill1   }
      {mfquoter.i spsn    }
      {mfquoter.i spsn1   }
      {mfquoter.i po      }
      {mfquoter.i po1     }
      {mfquoter.i base_rpt }
      {&SOIVRP09-P-TAG5}

      if inv1 = "" then inv1 = hi_char.
      if nbr1 = "" then nbr1 = hi_char.
      if cust1 = "" then cust1 = hi_char.
      if bill1 = "" then bill1 = hi_char.
      if spsn1 = "" then spsn1 = hi_char.
      if po1 = "" then po1 = hi_char.
      /* SS - 090819.1 - B */
      if entity1 = "" then entity1 = hi_char.
      IF eff_dt = ? THEN eff_dt = low_date.
      IF eff_dt1 = ? THEN eff_dt1 = TODAY.
      IF inv_date = ? THEN inv_date = low_date.
      IF inv_date1 = ? THEN inv_date1 = TODAY.
      /* SS - 090819.1 - E */

   end.

   /* SELECT PRINTER */
   {mfselbpr.i "printer" 132}

   /* SS - 090819.1 - B
   {mfphead.i}
   {gprun.i ""soivrp9a.p""}
   /* REPORT TRAILER */
   {mfrtrail.i}
   SS - 090819.1 - E */
   /* SS - 090819.1 - B */
   PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname,1,LENGTH(execname) - 2) SKIP.
   PUT UNFORMATTED "#def :end" SKIP.

   EMPTY TEMP-TABLE ttxxsoivrp0901.

   {gprun.i ""xxsoivrp0901.p"" "(
      INPUT entity,
      INPUT entity1,
      INPUT eff_dt,
      INPUT eff_dt1,
      INPUT inv_date,
      INPUT inv_date1,
      
      INPUT inv,
      INPUT inv1,
      INPUT nbr,
      INPUT nbr1,
      INPUT cust,
      INPUT cust1,
      INPUT bill,
      INPUT bill1,
      INPUT spsn,
      INPUT spsn1,
      INPUT po,
      INPUT po1,
      INPUT base_rpt
      )"}
   
   /* 删除已经处理的记录 */
   FOR EACH ttxxsoivrp0901
      ,EACH ih_hist  NO-LOCK
      WHERE 
      /*
      ih_domain = GLOBAL_domain AND 
      */
      ih_inv_nbr = ttxxsoivrp0901_ih_inv_nbr
      AND ih_nbr = ttxxsoivrp0901_idh_nbr
      AND ih_user1 <> ""
      :
      DELETE ttxxsoivrp0901.
   END.

   /* 删除非库存的记录 */
   FOR EACH ttxxsoivrp0901
      WHERE ttxxsoivrp0901_idh_type <> ''
      :
      DELETE ttxxsoivrp0901.
   END.

   {gprun.i ""xxGetTodayTime"" "(
      OUTPUT user1_ih
      )"}

   DO TRANSACTION:
      FOR EACH ttxxsoivrp0901
         ,EACH ih_hist  EXCLUSIVE-LOCK
         WHERE 
         /*
         ih_domain = GLOBAL_domain AND 
         */
         ih_inv_nbr = ttxxsoivrp0901_ih_inv_nbr
         AND ih_nbr = ttxxsoivrp0901_idh_nbr
         AND ih_user1 = ""
         ,EACH idh_hist NO-LOCK
         WHERE 
         /*
         idh_domain = GLOBAL_domain AND 
         */
         idh_inv_nbr = ih_inv_nbr
         AND idh_nbr = ih_nbr
         AND idh_line = ttxxsoivrp0901_idh_line
         ,EACH tr_hist NO-LOCK
         WHERE 
         /*
         tr_domain = GLOBAL_domain AND 
         */
         tr_type = "ISS-SO"
         AND tr_nbr = ih_nbr
         AND tr_line = idh_line
         AND tr_rmks = ih_inv_nbr
         BREAK 
         BY ih_inv_nbr
         BY ih_nbr
         :
         CREATE usrw_wkfl.
         ASSIGN
            /*
            usrw_domain = GLOBAL_domain
            */
            usrw_key1 = 'SoftspeedDI_History'
            usrw_key2 = string(tr_trnbr)
            usrw_intfld[1] = tr_trnbr
            usrw_decfld[1] = - tr_qty_loc
            usrw_decfld[2] = idh_price
            usrw_decfld[4] = - tr_qty_loc
            .

         /* 计量单位 */
         IF tr_um <> idh_um THEN DO:
            {gprun.i ""gpumcnv.p"" "(
               input  idh_um,
               input  tr_um,
               input  tr_part,
               output usrw_decfld[5]
               )"}

            ASSIGN
               usrw_decfld[1] = tr_qty_loc / usrw_decfld[5]
               usrw_decfld[4] = tr_qty_loc / usrw_decfld[5]
               .
         END.

         IF LAST-OF(ih_nbr) THEN DO:
            ASSIGN
               ih_user1 = user1_ih
               .
         END.
      END.
   END.

   EXPORT DELIMITER ";" "地点" "客户代码" "客户名称" "发票号" "发票日期" "生效日期" "截止日期" "销售订单" "采购订单" "渠道" "行" "类型" "产品类" "物料号" "计量单位" "发票数量" "本币单价" "本币金额" "货币" "兑换率1" "兑换率2" "原币金额" "账户" "分账户" "成本中心" "项目" "纳税类别" "是否纳税" "是否含税" "税额合计" "备注".
   FOR EACH ttxxsoivrp0901:
      EXPORT DELIMITER ";" 
         ttxxsoivrp0901_idh_site
         ttxxsoivrp0901_ih_cust
         ttxxsoivrp0901_name
         ttxxsoivrp0901_ih_inv_nbr
         ttxxsoivrp0901_inv_date
         ttxxsoivrp0901_ar_effdate
         ttxxsoivrp0901_idh_due_date
         ttxxsoivrp0901_idh_nbr
         ttxxsoivrp0901_ih_po
         ttxxsoivrp0901_ih_channel
         ttxxsoivrp0901_idh_line
         ttxxsoivrp0901_idh_type
         ttxxsoivrp0901_idh_prodline
         ttxxsoivrp0901_idh_part
         ttxxsoivrp0901_idh_um
         ttxxsoivrp0901_idh_qty_inv
         ttxxsoivrp0901_base_net_price
         ttxxsoivrp0901_base_price
         ttxxsoivrp0901_ih_curr
         ttxxsoivrp0901_ih_ex_rate
         ttxxsoivrp0901_ih_ex_rate2
         ttxxsoivrp0901_ext_price
         ttxxsoivrp0901_idh_acct
         ttxxsoivrp0901_idh_sub
         ttxxsoivrp0901_idh_cc
         ttxxsoivrp0901_idh_project
         ttxxsoivrp0901_idh_taxc
         ttxxsoivrp0901_idh_taxable
         ttxxsoivrp0901_idh_tax_in
         ttxxsoivrp0901_ext_tax
         ttxxsoivrp0901_ih_rmks
         .
   END.
   
   /*
   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.
   */
   
   {xxmfrtrail.i}
   /* SS - 090819.1 - E */

end.

{wbrp04.i &frame-spec = a}
