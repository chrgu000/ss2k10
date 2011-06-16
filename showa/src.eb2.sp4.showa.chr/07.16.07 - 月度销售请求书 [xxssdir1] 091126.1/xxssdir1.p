/* soivrp09.p - INVOICE HISTORY REPORT BY INVOICE                       */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
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
/* ss - 091116.1 by: jack */  /* 增加增值税发票价格，正式发票税用途 ,借用qty_effdate[4]  等4的序列存储发票价格*/ 
/* ss - 091125.1 by: jack */  /* 修改输出格式*/
/* ss - 091126.1 by: jack */  /* 按月零件汇总*/

/******************************************************************************/

/* 以下为版本历史 */
/* SS - 090511.1 By: Bill Jiang */
/* ss - 090824.1 by: jack */


/*以下为发版说明 */
/* SS - 090511.1 - RNB
【090511.1】

修改于以下标准菜单程序:
  - 发票历史记录报表 [soivrp09.p]

注意: 本程序限定了程序名
  - xxssdir1.p: 按零件号和日期汇总输出的已申请未打印的月度销售请求书
  - xxssdira.p: 按零件号和日期汇总输出的已打印未确认的月度销售请求书
  - xxssdir2.p: 按零件号汇总输出的已申请未打印的月度销售明细一览表
  - xxssdirb.p: 按零件号汇总输出的已打印未确认的月度销售明细一览表

以下是主要输入字段的使用说明:
  - 物料类型[part_type_pt]: 物料主记录维护[ppptmt.p].物料类型[pt_part_type]
  -   以上为空则输出所有
  - 图纸[draw_pt]: 物料主记录维护[ppptmt.p].图纸[pt_draw]
  -   以上为空则输出所有

以下是主要输出字段的数据源:
  - 客户名称: 客户维护[adcsmt.p].名称[ad_name]
  - 报表名称前缀: (物料主记录维护[ppptmt.p].物料类型[pt_part_type]),若有
  - 报表名称后缀: (物料主记录维护[ppptmt.p].图纸[pt_draw]),若有
  - 对象纳入月日: 生效日期[eff_dt] - 至[eff_dt1]
  - 客户确认: 客户维护[adcsmt.p].排序名[cm_sort]
  - 作成: 用户维护[mgurmt.p].用户名称[usr_name]
  - 日期: TODAY
  - 部番: 客户物料维护[ppcpmt.p].客户物料[cp_cust_part]
  -   注意: 以上取发票历史记录
  - 部品名: 客户物料维护[ppcpmt.p].显示客户物料[cp_cust_partd]
  -   注意: 以上取发票历史记录
  - 色调: 物料主记录维护[ppptmt.p].图纸[pt_draw]

【090511.1】

SS - 090511.1 - RNE */

/* SS - 20070726.1 - B */
{xxsoivrp0901.i "new"}
{xxssdir1.i "new"}
/* SS - 20070726.1 - E */

/* DISPLAY TITLE */
/*
{mfdtitle.i "2+ "}
*/
/*
{mfdtitle.i "090511.1"}
*/
    /*
{mfdtitle.i "090902.1"}
*/
    {mfdtitle.i "091126.1"}

{cxcustom.i "SOIVRP09.P"}

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

    /* ss - 091116.1 -b */
    DEFINE VAR v_list_price LIKE xxpi_list_price .
    /* ss - 091116.1 -e */

/* ********** End Translatable Strings Definitions ********* */

{soivtot1.i "NEW" }  /* Define variables for invoice totals. */

maint = no.

{&SOIVRP09-P-TAG1}
form
   /* SS - 20070726.1 - B */
   entity            colon 15
   entity1           label {t001.i} colon 49 skip
   eff_dt            colon 15
   eff_dt1           label {t001.i} colon 49 skip
   inv_date            colon 15
   inv_date1           label {t001.i} colon 49 skip
   /* SS - 20070726.1 - E */
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
   /* SS - 090511.1 - B */
   part_type_pt       colon 15 skip
   draw_pt       colon 15 skip
   SUMMARY_only COLON 15
   UPDATE_yn       colon 49
   /* SS - 090511.1 - E */
with frame a side-labels width 80.
{&SOIVRP09-P-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}

/* SS - 090511.1 - B */
ASSIGN
/* ss - 090824.1 -b
   entity = "2000"
   ss - 090824.1 -e */
   /* ss - 090824.1 -b */
      entity = "gsa1"
   /* ss - 090824.1 -e */

   entity1 = entity
   eff_dt1 = DATE(MONTH(TODAY),1,YEAR(TODAY)) - 1
   eff_dt = DATE(MONTH(eff_dt1),1,YEAR(eff_dt1))
   .

DISPLAY
   entity
   entity1
   eff_dt
   eff_dt1
   WITH FRAME a.
/* SS - 090511.1 - E */

repeat:
	/* SS - 090511.1 - B */
	hide all no-pause .
	view frame dtitle .
	/* SS - 090511.1 - E */

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
   /* SS - 20070726.1 - B */
   IF entity1 = hi_char THEN entity1 = "".
   IF eff_dt = low_date THEN eff_dt = ?.
   IF eff_dt1 = hi_date THEN eff_dt1 = TODAY.
   IF inv_date = low_date THEN inv_date = ?.
   IF inv_date1 = hi_date THEN inv_date1 = TODAY.
   /* SS - 20070726.1 - E */

   if c-application-mode <> 'web' then
   {&SOIVRP09-P-TAG3}
   update 
      /* SS - 20070726.1 - B */
      entity  entity1  eff_dt eff_dt1 inv_date inv_date1 
      /* SS - 20070726.1 - E */
      inv inv1 nbr nbr1 cust 
      /* SS - 090511.1 - B
      cust1
      SS - 090511.1 - E */
      bill 
      /* SS - 090511.1 - B
      bill1
      SS - 090511.1 - E */
      spsn spsn1 po po1
      base_rpt 
      /* SS - 090511.1 - B */
      part_type_pt
      draw_pt
      SUMMARY_only
      UPDATE_yn
      /* SS - 090511.1 - E */
      with frame a.

   {wbrp06.i &command = update &fields = "  
      /* SS - 20070726.1 - B */
      entity  entity1  eff_dt eff_dt1 inv_date inv_date1 
      /* SS - 20070726.1 - E */
      inv inv1 nbr nbr1 cust 
      /* SS - 090511.1 - B
      cust1
      SS - 090511.1 - E */
      bill
      /* SS - 090511.1 - B
      bill1
      SS - 090511.1 - E */
      spsn spsn1 po po1 base_rpt
      /* SS - 090511.1 - B */
      part_type_pt
      draw_pt
      SUMMARY_only
      UPDATE_yn
      /* SS - 090511.1 - E */
      " &frm = "a"}
   {&SOIVRP09-P-TAG4}

   /* SS - 090511.1 - B */
   ASSIGN
      cust1 = cust
      bill1 = bill
      .

   DISPLAY
      cust1
      bill1
      WITH FRAME a.

   /* 客户 */
   /* ss - 090824.1 -b
   FIND FIRST ad_mstr 
      WHERE ad_domain = GLOBAL_domain
      AND ad_addr = cust
      NO-LOCK NO-ERROR.
    ss - 090824.1 -e */
    /* ss - 090824.1 -b */
       FIND FIRST ad_mstr 
      WHERE  ad_addr = cust
      NO-LOCK NO-ERROR.
    /* ss - 090824.1 -e */

   IF NOT AVAILABLE ad_mstr THEN DO:
      /* Invalid entry. */
      {pxmsg.i &MSGNUM=4509 &ERRORLEVEL=3}
      UNDO,RETRY.
   END.
   /* SS - 090511.1 - E */

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      /* SS - 20070726.1 - B */
      {mfquoter.i entity     }
      {mfquoter.i entity1    }
      {mfquoter.i eff_dt     }
      {mfquoter.i eff_dt1    }
      {mfquoter.i inv_date     }
      {mfquoter.i inv_date1    }
      /* SS - 20070726.1 - E */
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
      /* SS - 090511.1 - B */
      {mfquoter.i part_type_pt }
      {mfquoter.i draw_pt }
      {mfquoter.i SUMMARY_only }
      {mfquoter.i UPDATE_yn }
      /* SS - 090511.1 - E */
      {&SOIVRP09-P-TAG5}

      if inv1 = "" then inv1 = hi_char.
      if nbr1 = "" then nbr1 = hi_char.
      if cust1 = "" then cust1 = hi_char.
      if bill1 = "" then bill1 = hi_char.
      if spsn1 = "" then spsn1 = hi_char.
      if po1 = "" then po1 = hi_char.
      /* SS - 20070726.1 - B */
      if entity1 = "" then entity1 = hi_char.
      IF eff_dt = ? THEN eff_dt = low_date.
      IF eff_dt1 = ? THEN eff_dt1 = TODAY.
      IF inv_date = ? THEN inv_date = low_date.
      IF inv_date1 = ? THEN inv_date1 = TODAY.
      /* SS - 20070726.1 - E */

   end.

   /* SELECT PRINTER */
   {mfselbpr.i "printer" 132}

   /* SS - 20070726.1 - B */
   /*
   {mfphead.i}
   {gprun.i ""soivrp9a.p""}
   /* REPORT TRAILER */
   {mfrtrail.i}
   */
   /*
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.
   */
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
   
   /* 删除未创建的记录 */
   /* ss - 090824.1 -b
   FOR EACH ttxxsoivrp0901
      ,EACH ih_hist  NO-LOCK
      WHERE ih_domain = GLOBAL_domain 
      AND ih_inv_nbr = ttxxsoivrp0901_ih_inv_nbr
      AND ih_nbr = ttxxsoivrp0901_idh_nbr
      AND ih_user1 = ""
      :
    ss - 090824.1 -e */
    /* ss - 090824.1 -b */
       FOR EACH ttxxsoivrp0901
      ,EACH ih_hist  NO-LOCK
      WHERE  ih_inv_nbr = ttxxsoivrp0901_ih_inv_nbr
      AND ih_nbr = ttxxsoivrp0901_idh_nbr
      AND ih_user1 = ""
      :

    /* ss - 090824.1 -e */

      DELETE ttxxsoivrp0901.
   END.

   /* 删除非库存的记录 */
   FOR EACH ttxxsoivrp0901
      WHERE ttxxsoivrp0901_idh_type <> ''
      :
      DELETE ttxxsoivrp0901.
   END.

   IF part_type_pt <> "" THEN DO:
      FOR EACH ttxxsoivrp0901:
         FIND FIRST pt_mstr 
            WHERE  pt_part = ttxxsoivrp0901_idh_part
            NO-LOCK NO-ERROR.
         IF AVAILABLE pt_mstr AND pt_part_type <> part_type_pt THEN DO:
            DELETE ttxxsoivrp0901.
         END.
      END.
   END.

   IF draw_pt <> "" THEN DO:
      FOR EACH ttxxsoivrp0901:
         FIND FIRST pt_mstr 
            WHERE  pt_part = ttxxsoivrp0901_idh_part
            NO-LOCK NO-ERROR.
         IF AVAILABLE pt_mstr AND pt_draw <> draw_pt THEN DO:
            DELETE ttxxsoivrp0901.
         END.
      END.
   END.

   EMPTY TEMP-TABLE tta.
   EMPTY TEMP-TABLE ttb.
   EMPTY TEMP-TABLE tt1.
   EMPTY TEMP-TABLE tt2.
   EMPTY TEMP-TABLE tt3.
   qty_effdate[1] = 0.
   qty_part[1] = 0.
   amt_part[1] = 0.
   amt_tot[1] = 0.

   /* ss - 091116.1 -b */
   qty_effdate[4] = 0 .
   qty_part[4] = 0 .
   amt_part[4] = 0 .
   amt_tot[4] = 0 .
   /* ss - 091116.1 -e */

   DO TRANSACTION ON STOP UNDO:
      FOR EACH ttxxsoivrp0901
         ,EACH ih_hist  NO-LOCK
         WHERE /* ih_domain = GLOBAL_domain 
         AND */ ih_inv_nbr = ttxxsoivrp0901_ih_inv_nbr
         AND ih_nbr = ttxxsoivrp0901_idh_nbr
         /* 已创建 */
         AND ih_user1 <> ""
         ,EACH idh_hist NO-LOCK
         WHERE /*idh_domain = GLOBAL_domain
         AND */ idh_inv_nbr = ih_inv_nbr
         AND idh_nbr = ih_nbr
         AND idh_line = ttxxsoivrp0901_idh_line
         ,EACH tr_hist NO-LOCK
         WHERE /* tr_domain = GLOBAL_domain
         AND */ tr_type = "ISS-SO"
         AND tr_nbr = ih_nbr
         AND tr_line = idh_line
         AND tr_rmks = ih_inv_nbr
         ,EACH pt_mstr NO-LOCK
         WHERE /*pt_domain = GLOBAL_domain
         AND */ pt_part = ttxxsoivrp0901_idh_part
         ,EACH usrw_wkfl NO-LOCK
         WHERE /*usrw_domain = GLOBAL_domain
         AND */ usrw_key1 = "SoftspeedDI_History"
         AND usrw_key2 = STRING(tr_trnbr)
         ,EACH rqm_mstr EXCLUSIVE-LOCK
         WHERE /*rqm_domain = GLOBAL_domain
         /* 未确认 */
         AND */ rqm_open = NO
         /* 注意: 限定了程序名 */
         AND (
            (rqm_status = ""  AND (execname = "xxssdir1.p" OR execname = "xxssdir2.p")) 
            OR 
            (rqm_status = "P" AND (execname = "xxssdira.p" OR execname = "xxssdirb.p"))
            )
         ,EACH rqd_det NO-LOCK
         WHERE /* rqd_domain = GLOBAL_domain
         AND */ rqd_nbr = rqm_nbr
         AND rqd_cmtindx = tr_trnbr
         
         BREAK 
         BY rqm_nbr
           /* ss - 091125.1 -b
         BY rqd_part
         BY tr_part
         BY tr_effdate
         ss - 091125.1 -e */
         :

          /* ss - 091125.1 -b
         qty_effdate[2] = rqd_req_qty.
         qty_effdate[1] = qty_effdate[1] + qty_effdate[2].
         amt_part[1] = amt_part[1] + qty_effdate[2] * ttxxsoivrp0901_base_net_price.
          ss - 091125.1 -e */

         /* ss - 091116.1 -b */
         
         FIND LAST xxpi_mstr WHERE xxpi_list = ih_cust AND xxpi_part = idh_part AND xxpi_curr = ih_curr AND xxpi_um = idh_um NO-LOCK NO-ERROR .
         IF AVAILABLE xxpi_mstr THEN DO:
             amt_part[4] = amt_part[4] + qty_effdate[2] * xxpi_list_price .
             v_list_price = xxpi_list_price .
         END.
         ELSE DO:
             v_list_price = 0 .
         END.


         /* ss - 091125.1 -b */
            CREATE ttb.
            ASSIGN
               ttb_cust = ih_cust
               ttb_inv = rqd_part
               ttb_part = tr_part
               ttb_qty = rqd_req_qty
               ttb_custpart = idh_custpart
               ttb_um = idh_um
               ttb_list_price = v_list_price 
               ttb_inv_amt = v_list_price * rqd_req_qty
               ttb_tax_usage = idh_tax_usage 
               ttb_curr = ih_curr
                .
              
            /* ss - 091126.1 -b
               IF idh_tax_usage = "s17"  THEN DO:
                  ASSIGN
                  ttb_tax = ROUND ( ttb_inv_amt * 0.17 , 2 ) 
                 ttb_tax_amt =  ROUND ( ttb_inv_amt * 1.17 , 2 ) .
                END.
               ELSE DO:
                ASSIGN
                    ttb_tax = 0 
                    ttb_tax_amt = 0 .
               END.
                ss - 091126.1 -e */

            /* ss - 091126.1 -b */
            FIND LAST tx2_mstr WHERE tx2_tax_type = "zzs" AND tx2_pt_taxc = idh_taxc 
                AND tx2_tax_usage = idh_tax_usage  NO-LOCK NO-ERROR .
            IF AVAILABLE tx2_mstr  THEN DO:
                ASSIGN
                ttb_tax = ROUND( ttb_inv_amt * ( tx2_tax_pct / 100 ) , 2 ) 
                ttb_tax_amt =  ROUND ( ttb_inv_amt * ( 1 + ( tx2_tax_pct / 100 ) )  , 2 )
                    .

            END.
            ELSE DO:
                ASSIGN
                ttb_tax = 0
                ttb_tax_amt =   ttb_inv_amt 
                    .
            END.
            /* ss - 091126.1 -e */
              
         /* ss - 091125.1 -e */


         /* ss - 091116.1 -e */

         /* ss - 091125.1 b 
         /* 明细 */
         IF LAST-OF(tr_effdate) THEN DO:
            CREATE tta.
            ASSIGN
               tta_inv = rqd_part
               tta_part = tr_part
               tta_effdate = tr_effdate
               tta_qty = qty_effdate[1]
               .

            qty_part[1] = qty_part[1] + qty_effdate[1].
            qty_effdate[1] = 0.
         END. /* IF LAST-OF(tr_effdate) THEN DO: */

         /* 零件 */
         IF LAST-OF(tr_part) THEN DO:
            CREATE ttb.
            ASSIGN
               ttb_inv = rqd_part
               ttb_part = tr_part
               ttb_qty = qty_part[1]
               ttb_amt = amt_part[1]
               ttb_custpart = idh_custpart
               ttb_um = idh_um
                 /* ss - 091116.1 -b */
               ttb_list_price = v_list_price 
               ttb_inv_amt = amt_part[4]
               ttb_tax_usage = ih_tax_usage
              /* ss - 091116.1 -e */
               .
           

            amt_tot[1] = amt_tot[1] + amt_part[1].
            
            /* ss - 091116.1 -b */
            amt_tot[4] = amt_tot[4] + amt_part[4] .
            amt_part[4] = 0 .
            /* ss - 091116.1 -e */

            qty_part[1] = 0.
            amt_part[1] = 0.
         END.
         ss - 091125.1 -e */

         /* 更新状态为已打印 */
         IF UPDATE_yn = YES THEN DO:
            IF LAST-OF(rqm_nbr) THEN DO:
               IF rqm_status = "" THEN DO:
                  ASSIGN
                     rqm_status = "P"
                     .
               END.
            END.
         END.
      END. /* FOR EACH ttxxsoivrp0901 */
   END. /* DO TRANSACTION ON STOP UNDO: */

   /* ss - 091125.1 -b
   IF summary_only = YES THEN DO:
      FOR EACH tta
         BREAK 
         BY tta_part
         BY tta_effdate
         :
         ACCUMULATE tta_qty (TOTAL BY tta_part BY tta_effdate).
         IF LAST-OF(tta_effdate) THEN DO:
            CREATE tt1.
            ASSIGN
               tt1_part = tta_part
               tt1_effdate = tta_effdate
               tt1_qty = (ACCUMULATE TOTAL BY tta_effdate tta_qty)
               .
         END.
      END. /* FOR EACH tta */
      FOR EACH ttb
         BREAK 
         BY ttb_part
         :
         ACCUMULATE ttb_qty (TOTAL BY ttb_part).
         ACCUMULATE ttb_amt (TOTAL BY ttb_part).
         /* ss - 091116.1 -b */
         ACCUMULATE ttb_inv_amt (TOTAL BY ttb_part).
      /* ss - 091116.1 -e */

         IF LAST-OF(ttb_part) THEN DO:
            CREATE tt2.
            ASSIGN
               tt2_part = ttb_part
               tt2_qty = (ACCUMULATE TOTAL BY ttb_part ttb_qty)
               tt2_amt = (ACCUMULATE TOTAL BY ttb_part ttb_amt)
               tt2_custpart = ttb_custpart
               tt2_um = ttb_um
                /* ss - 091116.1 -b */
                tt2_inv_amt =  (ACCUMULATE TOTAL BY ttb_part ttb_inv_amt)
                tt2_list_price = ttb_list_price
                tt2_curr = ttb_curr
                /* ss - 091116.1 -e */
               .
         END.
      END. /* FOR EACH ttb */
   END.
   ELSE DO:
      FOR EACH tta:
         CREATE tt1.
         ASSIGN
            tt1_inv = tta_inv + "."
            tt1_part = tta_part
            tt1_effdate = tta_effdate
            tt1_qty = tta_qty
            .
      END.
      FOR EACH ttb:
         CREATE tt2.
         ASSIGN
            tt2_inv = ttb_inv + "."
            tt2_part = ttb_part
            tt2_qty = ttb_qty
            tt2_amt = ttb_amt
            tt2_custpart = ttb_custpart
            tt2_um = ttb_um
           /* ss - 091116.1 -b */
            tt2_inv_amt =  ttb_inv_amt
            tt2_list_price = ttb_list_price
            tt2_curr = ttb_curr
            /* ss - 091116.1 -e */
            .
      END.
   END.
   
   /* 日期 */
   FOR EACH tt1 BREAK BY tt1_effdate:
      IF LAST-OF(tt1_effdate) THEN DO:
         CREATE tt3.
         ASSIGN
            tt3_effdate = tt1_effdate
            .
      END.
   END.
   
   ss - 091125.1 -e */


   /* 按零件号和日期汇总输出的月度销售请求书 */
   IF LOOKUP(execname,"xxssdir1.p,xxssdira.p",",") <> 0 THEN DO:
      {gprun.i ""xxssdir1a.p""}
   END.

   /* 按零件号汇总输出的月度销售明细一览表 */
   IF LOOKUP(execname,"xxssdir2.p,xxssdirb.p",",") <> 0 THEN DO:
      {gprun.i ""xxssdir1b.p""}
   END.
   
   {xxmfrtrail.i}
   /* SS - 20070726.1 - E */

end.

{wbrp04.i &frame-spec = a}
