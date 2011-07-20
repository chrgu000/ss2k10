/* xxinsorp.p - 客户订单原始数据报表.                                        */
/*V8:ConvertMode=Report                                                      */
/* REVISION: 17YJ LAST MODIFIED: 07/20/11   BY: zy                           */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

/*----110720.1------------------------------------------------------------------
  Purpose:Display Item-number and drawing number to report
  Parameters:<NONE>
  Memo:
------------------------------------------------------------------------------*/


{mfdtitle.i "110720.1"}
DEFINE VARIABLE v_type LIKE xxsod_type.
DEFINE VARIABLE v_cust LIKE xxsod_cust.
DEFINE VARIABLE v_cust1 LIKE xxsod_cust.
DEFINE VARIABLE v_project LIKE xxsod_project .
DEFINE VARIABLE v_project1 LIKE xxsod_project .
DEFINE VARIABLE v_vend LIKE xxsod_vend.
DEFINE VARIABLE v_vend1 LIKE xxsod_vend.
DEFINE VARIABLE v_addr LIKE xxsod_addr.
DEFINE VARIABLE v_addr1 LIKE xxsod_addr.
DEFINE VARIABLE v_part LIKE xxsod_part.
DEFINE VARIABLE v_part1 LIKE xxsod_part .
DEFINE VARIABLE v_due_date AS DATE initial today.
DEFINE VARIABLE v_due_date1 AS DATE initial today.
DEFINE VARIABLE v_invnbr LIKE xxsod_invnbr .
DEFINE VARIABLE v_invnbr1 LIKE xxsod_invnbr .
DEFINE VARIABLE v_week LIKE xxsod_week .
DEFINE VARIABLE v_week1 LIKE xxsod_week.
DEFINE VARIABLE v_ptdraw  LIKE pt_draw.
DEFINE VARIABLE v_pt like pt_part.

form
    SKIP(.2)
    v_type       COLON 15 
    v_cust       COLON 15 v_cust1     label {t001.i} COLON 49 SKIP
    v_project    COLON 15 v_project1  LABEL {t001.i} COLON 49 SKIP
    v_vend       COLON 15 v_vend1     LABEL {t001.i} COLON 49 SKIP
    v_addr       COLON 15 v_addr1     LABEL {t001.i} COLON 49 SKIP
    v_part       COLON 15 v_part1     LABEL {t001.i} COLON 49 SKIP
    v_due_date   COLON 15 v_due_date1 LABEL {t001.i} COLON 49 SKIP
    v_invnbr     COLON 15 v_invnbr1   LABEL {t001.i} COLON 49 SKIP
    v_week       COLON 15 v_week1     LABEL {t001.i} COLON 49 SKIP

skip(1)
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    IF v_cust1 = hi_char THEN v_cust1 = "".
    IF v_project1 = hi_char THEN v_project1 = "".
    IF v_vend1 = hi_char THEN v_vend1 = "".
    IF v_addr1 = hi_char THEN v_addr1 = "".
    IF v_part1 = hi_char THEN v_part1 = "".
    IF v_due_date = low_date THEN v_due_date = ? .
    IF v_due_date1 = hi_date THEN v_due_date1 = ?.
    IF v_invnbr1 = hi_char THEN v_invnbr1 = "" .

    update
        v_type v_cust v_cust1 v_project v_project1
        v_vend v_vend1 v_addr v_addr1 v_part v_part1
        v_due_date v_due_date1 v_invnbr v_invnbr1
        v_week v_week1
    with frame a.

    IF v_cust1 = "" THEN v_cust1 = hi_char.
    IF v_project1 = "" THEN v_project1 = hi_char.
    IF v_vend1 = "" THEN v_vend1 = hi_char.
    IF v_addr1 = "" THEN v_addr1 = hi_char.
    IF v_part1 = "" THEN v_part1 = hi_char.
    IF v_due_date = ? THEN v_due_date = low_date.
    IF v_due_date1 = ? THEN v_due_date1 = hi_date .
    IF v_invnbr1 = "" THEN v_invnbr1 = hi_char.

    {gpselout.i &printType = "printer"
                &printWidth = 500
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
mainloop:
do on error undo, return error on endkey undo, return error:
  {mfphead.i}

   /* EXPORT DELIMITER ";" "类型" "客户" "项目" "顺序号"  "供应商号"  "收货地点"  "零件号"  "零件颜色"  "零件名称"  "计划代码"  "传票日期"  "传票时间"  "订货数量"  "传票号码"
                           "版本号"   "周次"  "分类"  "交货规则"  "备注"  "备注1"  "送货日期" "送货时间" .*/

      put unformatted "类型   客户     项目    顺序号  供应商号  收货地点        零件号        零件颜色            零件名称       计划代码  送货日期   送货时间      订货数量            传票号码      版本号    周次      分类       交货规则              备注                 备注1       传票日期  传票时间   数量        料号               条码" SKIP.
      put unformatted "---- -------- -------- ------- --------- --------- -------------------- --------- ------------------------ --------- ---------- --------- ---------------- -------------------- ------ ---------- -------- ---------------- -------------------- -------------------- --------- --------- ------- ------------------ ------------------" SKIP .
      FOR EACH xxsod_det NO-LOCK WHERE xxsod_cust >= v_cust
                                   AND xxsod_cust <= v_cust1
                                   AND xxsod_project >= v_project
                                   AND xxsod_project <= v_project1
                                   AND xxsod_vend >= v_vend
                                   AND xxsod_vend <= v_vend1
                                   AND xxsod_addr >= v_addr
                                   AND xxsod_addr <= v_addr1
                                   AND xxsod_part >= v_part
                                   AND xxsod_part <= v_part1
                                   AND date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-"))) >= v_due_date
                                   AND date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-"))) <= v_due_date1
                                   AND xxsod_invnbr >= v_invnbr
                                   AND xxsod_invnbr <= v_invnbr1
                                   AND (xxsod_week >= v_week OR v_week = 0)
                                   AND (xxsod_week <= v_week1 OR v_week1 = 0):
          assign v_pt = "" v_ptdraw = "".
          find first cp_mstr no-lock where cp_cust = xxsod_cust and xxsod_part = cp_cust_part no-error.
          if available cp_mstr then do:
             find first pt_mstr no-lock where pt_part = cp_part no-error.
             if available pt_mstr then do:
                assign v_pt = pt_part v_ptdraw = "P" + pt_draw.
             end.
          end.
          PUT UNFORMATTED xxsod_type AT 1.
          PUT UNFORMATTED xxsod_cust AT 6.
          PUT UNFORMATTED xxsod_project AT 15.
          PUT UNFORMATTED xxsod_item AT 24 .
          PUT UNFORMATTED xxsod_vend AT 32 .
          PUT UNFORMATTED xxsod_addr AT 42 .
          PUT UNFORMATTED xxsod_part AT 52 .
          PUT UNFORMATTED xxsod_color AT 73 .
          PUT UNFORMATTED xxsod_desc AT 83 .
          PUT UNFORMATTED xxsod_plan AT 108 .
          PUT UNFORMATTED xxsod_due_date1 AT 118.
          PUT UNFORMATTED xxsod_due_time1 AT 129.
          PUT UNFORMATTED xxsod_qty_ord TO 154 .
          PUT UNFORMATTED xxsod_invnbr AT 156 .
          PUT UNFORMATTED xxsod_rev AT 177.
          PUT UNFORMATTED xxsod_week TO 193.
          PUT UNFORMATTED xxsod_category AT 195.
          PUT UNFORMATTED xxsod_ship AT 204.
          PUT UNFORMATTED xxsod_rmks AT 221.
          PUT UNFORMATTED xxsod_rmks1 AT 242.
          PUT UNFORMATTED xxsod_due_date AT 263.
          PUT UNFORMATTED xxsod_due_time  AT 273.
          PUT UNFORMATTED xxsod__chr02 TO 286.
          PUT UNFORMATTED v_pt at 292.
          PUT UNFORMATTED v_ptdraw at 310.
          PUT SKIP.

      END. /*FOR EACH xxsod_det*/

end. /* mainloop: */
{mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
