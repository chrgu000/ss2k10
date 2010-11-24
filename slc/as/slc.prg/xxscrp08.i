/* By: Neil Gao Date: 08/03/03 ECO: * ss 20080303 * */

define {1} shared temp-table tt-rqm-mstr no-undo
    field tt-dwn    as integer  label "行" format ">>>"
    field tt-nbr    like sod_nbr label "订单" column-label "订单"
    field tt-line   like sod_line label "项"  column-label "项"
    field tt-cffw-nbr as character 
    field tt-part   like sod_part  label "物料号"
    field tt-status    like pt_status label "旧机型" column-label "旧机型" format "x(18)"
    field tt-pur-lt  as integer label "采购期" format ">>>>>>"
    field tt-req-date as date   label "需求日期"
    field tt-yn     as integer label "生产期" column-label "生产期" format ">>>>>>"
    field tt-yn1     as logic label "确认" column-label "确认"
    field tt-rt     as character format "x(3)" label "返回"
    field tt-qty    like sod_qty_ord label "数量" format ">>>>>9"
    field tt-desc   as character  format "x(24)"
    field tt-vin    as char format "x(12)" label "VIN码规则"
    index tt-dwn is primary
       tt-dwn.
