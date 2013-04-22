/* xxsocnimp02.p - export to xls                                              */
{mfdeclre.i}
{yysocnrp4b.i}
define input parameter thfile as CHAR FORMAT "x(50)".
define variable ptdesc2 like pt_desc2.
define variable ptprodline like pt_prod_line.
define variable bexcel as com-handle.
define variable bbook as com-handle.
define variable bsheet as com-handle.
define variable I as integer.
   CREATE "Excel.Application" bexcel.
   bbook = bexcel:Workbooks:add().
   bsheet = bexcel:sheets:item(1) no-error.
   bbook:Activate.
   bsheet:cells(1,1)  = "使用 ID !客户使用参考".
   bsheet:cells(1,2)  = "生效日期".
   bsheet:cells(1,3)  = "发货-至".
   bsheet:cells(1,4)  = "发货地名称".
   bsheet:cells(1,5)  = "客户".
   bsheet:cells(1,6)  = "客户名称".
   bsheet:cells(1,7)  = "客户料号".
   bsheet:cells(1,8)  = "批/序号".
   bsheet:cells(1,9)  = "订单".
   bsheet:cells(1,10) = "项次".
   bsheet:cells(1,11) = "寄售使用数量".
   bsheet:cells(1,12) = "寄售使用单位".
   bsheet:cells(1,13) = "寄售累计使用数量".
   bsheet:cells(1,14) = "销售单单位".
   bsheet:cells(1,15) = "销售单单价".
   bsheet:cells(1,16) = "含税".
   bsheet:cells(1,17) = "类型".
   bsheet:cells(1,18) = "价格单价格".
   bsheet:cells(1,19) = "使用日期".
   bsheet:cells(1,20) = "自行账单".
   bsheet:cells(1,21) = "参考".
   bsheet:cells(1,22) = "客户寄售使用参考".
   i = 2.
for each tmp_t no-lock:
    bsheet:cells(i,1) = t_cncu_batch.
    bsheet:cells(i,2) = t_cncu_eff_date.
    bsheet:cells(i,3) = t_cncu_shipto.
    bsheet:cells(i,4) = t_shipto_name.
    bsheet:cells(i,5) = t_cncu_cust.
    bsheet:cells(i,6) = t_cust_name.
    bsheet:cells(i,7) = t_cncu_part.
    bsheet:cells(i,8) = t_cncu_lotser.
    bsheet:cells(i,9) = t_cncu_so_nbr.
    bsheet:cells(i,10) = t_cncu_sod_line.
    bsheet:cells(i,11) = t_cncu_usage_qty.
    bsheet:cells(i,12) = t_cncu_usage_um.
    bsheet:cells(i,13) = t_cncu_cum_qty.
    bsheet:cells(i,14) = t_sod_um.
    bsheet:cells(i,15) = t_sod_list_pr.
    bsheet:cells(i,16) = string(t_sod_tax_in).
    bsheet:cells(i,17) = t_sod_type.
    bsheet:cells(i,18) = t_pc_price.
    bsheet:cells(i,19) = t_cncu_cust_usage_date.
    bsheet:cells(i,20) = t_cncu_selfbill_auth.
    bsheet:cells(i,21) = t_cncu_ref.
    bsheet:cells(i,22) = t_cncu_cust_usage_ref.
    i = i + 1.
end.

  bsheet:Cells:EntireColumn:AutoFit.
  bsheet:Range("F2"):Select.
  bexcel:ActiveWindow:FreezePanes = True.

bbook:SaveAs(thfile ,,,,,,1).
bexcel:visible = true.
bbook:saved = true.

RELEASE OBJECT bsheet NO-ERROR.
RELEASE OBJECT bbook NO-ERROR.
RELEASE OBJECT bexcel NO-ERROR.
