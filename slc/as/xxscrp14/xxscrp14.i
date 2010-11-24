/* By: Neil Gao Date: 08/03/03 ECO: * ss 20080303 * */

define {1} shared var leave_rmks as logical no-undo.

define {1} shared temp-table tt-rqm-mstr no-undo
    field tt-dwn    as integer label "行" format ">>>"
    field tt-nbr    like sod_nbr label "订单" column-label "订单"
    field tt-line   like sod_line label "项"  column-label "项"
    field tt-cffw-nbr as character 
    field tt-part   like sod_part label "物料号"
    field tt-price  like sod_price label "价格" column-label "价格"
    field tt-status as character format "x(34)" label "价格" column-label "价格"
    field tt-yn1     as logic label "确认" column-label "确认"
    field tt-rt     as character  
    field tt-req-date like sod_req_date label "需求日期"
    field tt-desc   as character format "x(23)"  column-label "描述"
    field tt-qty    as int format ">>>>>9" label "数量"
    index tt-dwn is primary
       tt-dwn.
       