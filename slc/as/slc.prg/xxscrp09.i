/* By: Neil Gao Date: 08/03/03 ECO: * ss 20080303 * */

define {1} shared var leave_rmks as logical no-undo.

define {1} shared temp-table tt-rqm-mstr no-undo
    field tt-dwn    as integer label "行" format ">>>"
    field tt-nbr    like sod_nbr label "订单" column-label "订单"
    field tt-line   like sod_line label "项"  column-label "项"
    field tt-cffw-nbr as character 
    field tt-part   like sod_part label "物料号"
    field tt-status    like pt_status label "旧机型" column-label "旧机型" format "x(18)"
    field tt-yn      as int label "采购期" column-label "采购期" format ">>>>>>"
    field tt-yn1     as logic label "确认" column-label "确认"
    field tt-rt     as character  format "x(3)" label "返回"
    field tt-req-date like sod_req_date label "发货日期"
    field tt-xc     as integer label "相差" column-label "相差" format "->>>>>"
    field tt-desc   as character format "x(24)"
    field tt-qty    as int format ">>>>>9" label "订单数"
    field tt-due-date like sod_due_date label "截止日期"
    field tt-pur-lt   as integer label "采购"
    field tt-wo-lt   as integer  label "制造"
    field tt-cust   like so_cust
    index tt-dwn is primary
       tt-dwn.