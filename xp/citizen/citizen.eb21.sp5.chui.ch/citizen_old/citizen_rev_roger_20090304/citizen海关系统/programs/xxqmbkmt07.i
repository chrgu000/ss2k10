define {1} shared var v_bk_type as char initial "OUT" . 
define {1} shared var v_form_type as char initial "4" . 



define {1} shared var del-yn   as logical initial no .
define {1} shared var leave-yn as logical initial no .
define {1} shared var new_add as logical initial no .
define {1} shared var detail_add as logical initial no .
define {1} shared var v_all   as logical format "Y/N"  initial yes .
define {1} shared var v_add   as logical format "Y/N"  initial yes .
define {1} shared variable info_correct  like mfc_logical no-undo.
define {1} shared  var v_round1 as decimal .
define {1} shared  var v_round2 as integer .



v_round1 = 0.00001.
v_round2 = 5 .


define {1} shared var v_abs_id like abs_id .
define {1} shared var v_amt like xxexp_amt .
define {1} shared var v_nbr as char .
define {1} shared var v_line  as integer format ">>9" .
define {1} shared var v_qty_b1 like prh_rcvd .
define {1} shared var v_qty_b2 like prh_rcvd .
define {1} shared var v_error as char format "x(18)".
define {1} shared var v_um_conv like xxccpt_um_conv initial 1 .
define {1} shared var v_curr like po_curr initial "USD".
define {1} shared  var v_recid like recno  .

define {1} shared temp-table temp 
    field t_nbr  as char format "x(10)"
    field t_line as integer format ">>9" label "项"
    field t_ponbr like prh_nbr
    field t_vend  like prh_vend
    field t_rcp_date as date label "发货日期" 
    field t_part     like prh_part 
    field t_cu_ln    as integer format ">>>>>9" label "序"
    field t_cu_part  like xxcpt_cu_part label "商品编码"
    field t_ctry     like xxccpt_ctry 
    field t_um       like prh_um
    field t_um_conv1  like prh_um_conv
    field t_um_conv2  like xxccpt_um_conv
    field t_rcvd     like prh_rcvd /*prh_rcvd - prh__dec01*/
    field t_yn       as logical initial yes format "Y/N".


define {1} shared  frame h1 .
define {1} shared  frame h2 .
define {1} shared  frame d1. 
define {1} shared  frame d2.  
define {1} shared  frame d3. 



form
    space(1)
    v_nbr                  label "报关单号"  
    xxexp_iss_date         label "出口日期" colon 58     
    v_add                  label "自动"     colon 74
    skip
    space(1)     
    xxexp_bk_nbr        label "海关手册" 
    xxexp_req_date      label "申报日期"    colon 58  
    v_all               label "全部"        colon 74
with frame h1  side-labels width 80 attr-space.



form
    xxexp_cu_nbr       label "海关编号"    colon 13 xxexp_pre_nbr      label "预录入编号"  colon 45   
    xxexp_dept         label "进口口岸"    colon 13 xxexp_from         label "起运地"      colon 45  
    xxexp_ship_via     label "运输方式"    colon 13 xxexp_to           label "目的地"      colon 45  
    xxexp_ship_tool    label "运输工具"    colon 13 xxexp_port         label "装货港"      colon 45  
    xxexp_bl_nbr       label "提运单"      colon 13 xxexp_fob          label "成交方式"    colon 45  
    xxexp_trade_mtd    label "贸易方式"    colon 13 xxexp_box_num      label "件数"        colon 45  
    xxexp_tax_mtd      label "征免性质"    colon 13 xxexp_tax_rate     label "征税比例"    colon 45  
    xxexp_box_type     label "包装类型"    colon 13 xxexp_net          label "净重"        colon 45  
    xxexp_license      label "许可证号"    colon 13 xxexp_gross        label "毛重"        colon 45  
    xxexp_appr_nbr     label "批准文号"    colon 13 xxexp_curr         label "币别"        colon 45  
    xxexp_contract     label "合同协议号"  colon 13 xxexp_amt          label "金额"        colon 45 
    xxexp_container    label "集装箱号"    colon 13 xxexp_stat         label "状态"        colon 45 
    xxexp_rmks1        label "唛头"        colon 13 xxexp_use          label "用途"        colon 45  
    xxexp_rmks2        label "备注"        colon 13                                               
with frame h2 side-labels width 80 attr-space .   



form
    v_line           label "项" 
    xxexpd_iss_nbr   label "货运单号"
    xxexpd_iss_ln    label "项"
    xxexpd_iss_order label "销售单"
    xxexpd_iss_part  label "零件号"
    xxexpd_um        label "UM"
    xxexpd_iss_qty   label "发货数"
with frame d1  width 80 attr-space.



form
    xxexpd_iss_date  label "发货日期"     colon 13
    xxexpd_cu_part   label "商品编码"     colon 13 xxexpd_ctry      label "原产地"   colon 45  
    xxexpd_cu_ln     label "商品序"       colon 13 xxcpt_desc       label "品名"   
    xxexpd_cu_um     label "海关单位"     colon 13 xxexpd_um_conv   label "单位换算因子"   colon 45  
    xxexpd_price     label "单价"         colon 13     
    xxexpd_cu_qty    label "海关数量"     colon 13 xxexpd_stat      label "报关状态"     colon 45  
    xxexpd_amt       label "金额"         colon 13 xxexpd_used      label "已转仓数"   colon 45     

with frame d2  side-labels  width 80 attr-space.

form
    space(1)
    xxexp_nbr           label "报关单号"   
    xxexp_bk_nbr        label "海关手册" 
with frame d3  side-labels width 80 attr-space.