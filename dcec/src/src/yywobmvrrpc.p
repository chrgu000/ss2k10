{mfdeclre.i} /*GUI moved to top.*/
{gplabel.i} /* EXTERNAL LABEL INCLUDE */


DEF INPUT PARAMETER inp_value AS CHAR.

DEFINE TEMP-TABLE ttx2 RCODE-INFORMATION
    FIELDS ttx2_woid     AS CHARACTER FORMAT "x(10)"        LABEL "WOID"
    FIELDS ttx2_part     AS CHARACTER FORMAT "x(18)"        LABEL "零件"
    FIELDS ttx2_desc     AS CHARACTER FORMAT "x(24)"        LABEL "描述"
    FIELDS ttx2_qty      LIKE xxwobmvd_bom_qty              LABEL "数量"
    FIELDS ttx2_act_cost     LIKE xxwobmvd_bom_amt              LABEL "零件成本"
    FIELDS ttx2_cwo_cost     LIKE xxwobmvd_cwo_amt              LABEL "工单成本"
    FIELDS ttx2_var_rate     LIKE xxwobmvd_cwo_amt              LABEL "差异"
    .

DEFINE SHARED TEMP-TABLE ttx1 RCODE-INFORMATION
    FIELDS ttx1_i        AS INTEGER          LABEL "序号"
    FIELDS ttx1_j        AS INTEGER          LABEL "子序号"
    FIELDS ttx1_par      LIKE wo_part        LABEL "产品"
    FIELDS ttx1_desc_p   LIKE pt_desc1       LABEL "描述"
    FIELDS ttx1_pline_p  LIKE pt_prod_line   LABEL "产品类"
    FIELDS ttx1_woid     LIKE wo_lot         LABEL "标号"
    FIELDS ttx1_date     LIKE wo_due_date     LABEL "日期"
    FIELDS ttx1_line     LIKE wo_line        LABEL "生产线"
    FIELDS ttx1_rct_qty  LIKE xxwobmvm_rct_qty LABEL "产量"
    FIELDS ttx1_comp     LIKE wo_part        LABEL "零件"
    FIELDS ttx1_desc_c   LIKE pt_desc1       LABEL "描述"
    FIELDS ttx1_pline_c  LIKE pt_prod_line   LABEL "产品类"
    FIELDS ttx1_op       LIKE wod_op            LABEL "工序"
    FIELDS ttx1_bom_unit LIKE xxwobmvd_bom_unit LABEL "卷集单位用量"
    FIELDS ttx1_bom_cost LIKE xxwobmvd_bom_cost LABEL "卷集成本"
    FIELDS ttx1_bom_qty  LIKE xxwobmvd_bom_qty  LABEL "卷集总用量"
    FIELDS ttx1_bom_amt  LIKE xxwobmvd_bom_amt  LABEL "卷集总成本"
    FIELDS ttx1_cwo_unit LIKE xxwobmvd_cwo_unit LABEL "工单冻结单位用量"
    FIELDS ttx1_cwo_cost LIKE xxwobmvd_cwo_cost LABEL "工单冻结成本"
    FIELDS ttx1_cwo_qty  LIKE xxwobmvd_cwo_qty  LABEL "工单冻结总用量"
    FIELDS ttx1_cwo_amt  LIKE xxwobmvd_cwo_amt  LABEL "工单冻结总成本"
    FIELDS ttx1_act_unit LIKE xxwobmvd_act_unit LABEL "实际单位用量"
    FIELDS ttx1_act_cost LIKE xxwobmvd_act_cost LABEL "实际成本"
    FIELDS ttx1_act_qty  LIKE xxwobmvd_act_qty  LABEL "实际总用量"
    FIELDS ttx1_act_amt  LIKE xxwobmvd_act_amt  LABEL "实际总成本"
    FIELDS ttx1_var_tot  LIKE xxwobmvd_act_amt  LABEL "总差异"
    FIELDS ttx1_var_muv  LIKE xxwobmvd_act_amt    LABEL "量差"
    FIELDS ttx1_var_mrv  LIKE xxwobmvd_act_amt  LABEL "率差"
    FIELDS ttx1_var_mmv1 LIKE xxwobmvd_act_amt  LABEL "方法差异-量差"
    FIELDS ttx1_var_mmv2 LIKE xxwobmvd_act_amt  LABEL "方法差异-率差"
    FIELDS ttx1_var_mmv3 LIKE xxwobmvd_act_amt LABEL "方法差异-其他"
    FIELDS ttx1_varflag  AS   LOGICAL INITIAL NO LABEL "存在差异"
    INDEX  ttx1_idx1     ttx1_i ttx1_j
    INDEX  ttx1_idx2     ttx1_woid
    .

DEF VAR v-key AS CHAR EXTENT 5.
DEF VAR h-a AS HANDLE.
FOR EACH ttx2: DELETE ttx2. END.
v-key = "".
ASSIGN 
    v-key[1] = entry(1,inp_value,"|")
    v-key[2] = entry(2,inp_value,"|")
    .
FOR EACH xxwobmvr_det NO-LOCK 
    WHERE xxwobmvr_woid = v-key[1]
    AND   xxwobmvr_comp = v-key[2]:
    CREATE ttx2.
    ASSIGN 
        ttx2_woid = v-key[1]
        ttx2_part = v-key[2]
        ttx2_qty  = xxwobmvr_qty
        ttx2_act_cost = xxwobmvr_cost
        .
    FIND FIRST pt_mstr WHERE pt_part = ttx2_part NO-LOCK NO-ERROR.
    IF AVAILABLE pt_mstr THEN ASSIGN ttx2_desc = pt_desc1 + pt_desc2.
    FIND FIRST ttx1 WHERE ttx1_woid = ttx2_woid AND ttx1_comp = ttx2_part NO-LOCK NO-ERROR.
    IF AVAILABLE ttx1 THEN do:
        ASSIGN ttx2_cwo_cost = ttx1_cwo_cost.
        IF ttx1_j = 0 THEN ASSIGN ttx2_cwo_cost = ttx2_act_cost.
        ASSIGN ttx2_var_rate = (ttx2_act_cost - ttx2_cwo_cost) * ttx2_qty.
    END.
END.


{yywobmvrrpbw4.i}
