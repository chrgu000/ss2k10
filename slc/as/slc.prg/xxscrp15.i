/*By: Neil Gao 08/12/29 ECO: *SS 20081229* */

define {1} shared temp-table tt2 no-undo
    field tt2_f1  as integer label "行" format ">>>"
    field tt2_f2  like sod_nbr label "订单" column-label "订单"
    field tt2_f3  like sod_line label "项"  column-label "项"
    field tt2_f4  like sod_part label "物料号"
    field tt2_f5  like pt_desc1 label "说明"
    field tt2_f6 	like sod_req_date column-label "发货日期"
    field tt2_f7  like sod_qty_ord column-label "数量" format ">>>>>>"
    field tt2_f8  as int label "采购期" column-label "采购期" format ">>>"
    field tt2_f9  as logic label "确认" column-label "确认"
    index tt2_f1
    tt2_f1.
