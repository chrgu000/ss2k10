/* zzdivmt.i - Diversion Maintenance                                         */
/*V8:ConvertMode=NOCONVERT                                                   */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 24YP LAST MODIFIED: 04/24/12 BY: zy expand xrc length to 120    */
/* REVISION END                                                              */

DEFINE {1} SHARED VARIABLE x_part AS CHARACTER FORMAT "x(18)".
DEFINE {1} SHARED VARIABLE x_part1 AS CHARACTER FORMAT "x(18)".
DEFINE {1} SHARED VARIABLE transfer_rs AS CHARACTER .
DEFINE {1} SHARED VARIABLE jsyc_dec AS DECIMAL.
DEFINE {1} SHARED VARIABLE qtyc_dec AS DECIMAL.

DEFINE {1} SHARED  TEMP-TABLE ttld_det
    FIELD ttld_sel AS logical
    FIELD ttld_lot AS CHARACTER FORMAT "x(15)"
    FIELD ttld_part AS CHARACTER FORMAT "x(10)"
    FIELD ttld_check AS CHARACTER FORMAT "x(4)"
    FIELD ttld_mfd AS DECIMAL FORMAT ">9.9<"
    FIELD ttld_rc AS DECIMAL format ">>,>>9.9<"
    FIELD ttld_r0 AS DECIMAL format ">>,>>9.9<"
    FIELD ttld_wj AS DECIMAL format ">>9.9<"
    FIELD ttld_yxc AS DECIMAL format ">>,>>9.9<"
    FIELD ttld_zzl AS DECIMAL format ">>,>>9.9<"
    FIELD ttld_jszl AS DECIMAL format ">>,>>9.9<"
    FIELD ttld_jbd AS DECIMAL format ">>9.9<"
    FIELD ttld_rn AS DECIMAL format ">>9.9<"
    FIELD ttld_pxl AS DECIMAL format ">>9.9<"
    FIELD ttld_bow AS DECIMAL format ">>9.9<"
    FIELD ttld_fy AS DECIMAL format ">>9.9<"
    FIELD ttld_qp AS CHARACTER format "x(1)"
    FIELD ttld_D_core AS DECIMAL format ">>9.9<"
    FIELD ttld_slope AS DECIMAL format ">>9.9<"
    FIELD ttld_D1285 AS DECIMAL format "->>>9.9<"
    FIELD ttld_defect AS CHARACTER FORMAT "x(8)"
    FIELD ttld_part1 AS CHARACTER FORMAT "x(10)"
    FIELD ttld_site AS CHARACTER
    FIELD ttld_loc   AS CHARACTER FORMAT "x(8)"
    FIELD ttld_ref   AS CHARACTER
    FIELD ttld_loc_to AS CHARACTER FORMAT "x(8)"
    FIELD ttld_qty_oh AS DECIMAL
    FIELD ttld_ok  AS CHARACTER
    FIELD ttld_sum_weight AS DECIMAL
    FIELD ttld_insp_good_weight like zzsellot_insp_goodweight
    FIELD ttld_count AS INTEGER
    FIELD ttld_defstat as logical    /*defect 品*/
    FIELD ttld_caniss as logical    /*issued able*/
    FIELD ttld_inspec as logical     /*规格内*/
    FIELD ttld_engstat as logical   /*工程进度*/
    FIELD ttld_qastat as logical    /*品质保证*/
    FIELD ttld_engcode as character /*工程进度代码*/
    FIELD ttld_pa_date as date
    INDEX index1 ttld_lot
    index ttld_padtlot ttld_pa_date ttld_lot.
