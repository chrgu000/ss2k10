define {1} shared var v_bk_type as char initial "IMP" . 
define {1} shared var v_form_type as char initial "2" . 
define {1} shared var v_sl_type like xxsl_type format "1-转厂转入/2-转厂转出" initial yes  .
define {1} shared var v_vend like po_vend  .

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



define {1} shared var v_amt like xximp_amt .
define {1} shared var v_nbr as char .
define {1} shared var v_line  as integer format ">>9" .
define {1} shared var v_qty_b1 like prh_rcvd .
define {1} shared var v_qty_b2 like prh_rcvd .
define {1} shared var v_error as char format "x(18)".
define {1} shared var v_um_conv like xxccpt_um_conv initial 1 .
define {1} shared var v_curr like po_curr initial "USD".
define {1} shared  var v_recid like recno  .

define {1} shared temp-table temp 
    field t_nbr  like prh_receiver 
    field t_line as integer format ">>9" label "项"
    field t_ponbr like prh_nbr
    field t_vend  like prh_vend
    field t_rcp_date as date label "收货日期" 
    field t_part     like prh_part 
    field t_cu_ln    as integer format ">>>9" label "序"
    field t_cu_part  like xxcpt_cu_part label "商品编码"
    field t_ctry     like xxccpt_ctry 
    field t_um       like prh_um
    field t_um_conv1  like prh_um_conv
    field t_um_conv2  like xxccpt_um_conv
    field t_rcvd     like prh_rcvd /*prh_rcvd - prh__dec01*/
    field t_yn       as logical initial yes .

define {1} shared temp-table temp2
    field t2_sl_nbr   like xxsld_nbr
    field t2_sl_line  like xxsld_line 
    field t2_cu_ln    like xxcpt_ln
    field t2_bk_nbr   like xxcbk_bk_nbr 
    .



define {1} shared  frame h1 .
define {1} shared  frame h2 .
define {1} shared  frame d1. 
define {1} shared  frame d2.  
define {1} shared  frame d3. 




form
    space(1)
    v_nbr                  label "报关单号"  
    xximp_sl_nbr           label "关封号"
    xximp_rct_date         label "进口日期" colon 58    
    v_add                  label "自动"     colon 74
    skip
    space(1)     
    xximp_bk_nbr        label "海关手册" 
    xximp_req_date      label "申报日期"    colon 58
    v_all               label "全部"        colon 74
with frame h1  side-labels width 80 attr-space.


form
    xximp_cu_nbr       label "海关编号"    colon 13 xximp_pre_nbr      label "预录入编号"  colon 45   
    xximp_dept         label "进口口岸"    colon 13 xximp_from         label "起运地"      colon 45  
    xximp_ship_via     label "运输方式"    colon 13 xximp_to           label "目的地"      colon 45  
    xximp_ship_tool    label "运输工具"    colon 13 xximp_port         label "装货港"      colon 45  
    xximp_bl_nbr       label "提运单"      colon 13 xximp_fob          label "成交方式"    colon 45  
    xximp_trade_mtd    label "贸易方式"    colon 13 xximp_box_num      label "件数"        colon 45  
    xximp_tax_mtd      label "征免性质"    colon 13 xximp_tax_rate     label "征税比例"    colon 45  
    xximp_box_type     label "包装类型"    colon 13 xximp_net          label "净重"        colon 45  
    xximp_license      label "许可证号"    colon 13 xximp_gross        label "毛重"        colon 45  
    xximp_appr_nbr     label "批准文号"    colon 13 xximp_curr         label "币别"        colon 45  
    xximp_contract     label "合同协议号"  colon 13 xximp_amt          label "金额"        colon 45 
    xximp_container    label "集装箱号"    colon 13 xximp_stat         label "状态"        colon 45 
    xximp_rmks1        label "唛头"        colon 13 xximp_use          label "用途"        colon 45  
    xximp_rmks2        label "备注"        colon 13                                               
with frame h2 side-labels width 80 attr-space .   


form
    v_line           label "项" 
    xximpd_rct_nbr   label "收货单号"
    xximpd_rct_ln    label "项"
    xximpd_rct_order label "采购单"
    xximpd_rct_part  label "零件号"
    xximpd_um        label "UM"
    xximpd_rct_qty   label "收货数量"
with frame d1  width 80 attr-space.



form
    xximpd_rct_date  label "收货日期"     colon 13
    xximpd_cu_part   label "商品编码"     colon 13 xximpd_ctry      label "原产地"   colon 45  
    xximpd_cu_ln     label "商品序"       colon 13 xxcpt_desc       label "品名"   
    xximpd_cu_um     label "海关单位"     colon 13 xximpd_um_conv   label "单位换算因子"   colon 45  
    xximpd_price     label "单价"         colon 13     
    xximpd_cu_qty    label "海关数量"     colon 13 xximpd_stat      label "报关状态"     colon 45  
    xximpd_amt       label "金额"         colon 13 xximpd_used      label "已转厂数"   colon 45     

with frame d2  side-labels  width 80 attr-space.

form
    space(1)
    xximp_nbr           label "报关单号"  
    xximp_bk_nbr        label "海关手册" 
with frame d3  side-labels width 80 attr-space.