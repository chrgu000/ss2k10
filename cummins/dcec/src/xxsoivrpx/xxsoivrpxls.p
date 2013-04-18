/* xxsocnimp02.p - export to xls                                              */
{mfdeclre.i}
{xxgetsoivrp.i}
define input parameter thfile as CHAR FORMAT "x(50)".
define variable bexcel as com-handle.
define variable bbook as com-handle.
define variable bsheet as com-handle.
define variable I as integer.
   CREATE "Excel.Application" bexcel.
   bbook = bexcel:Workbooks:add().
   bsheet = bexcel:sheets:item(1) no-error.
   bbook:Activate.
   assign i = 1.
   bsheet:cells(i,1)  = "发票号".     
   bsheet:cells(i,2)  = "票据开往".       
   bsheet:cells(i,3)  = "开往名称".  
   bsheet:cells(i,4)  = "客户".       
   bsheet:cells(i,5)  = "客户名称".  
   bsheet:cells(i,6)  = "推销员".     
   bsheet:cells(i,7)  = "应收帐户".    
   bsheet:cells(i,8)  = "应收分账户".     
   bsheet:cells(i,9)  = "成本中心".      
   bsheet:cells(i,10) = "纳税环境".    
   bsheet:cells(i,11) = "税用途".  
   bsheet:cells(i,12) = "订单号".        
   bsheet:cells(i,13) = "发货至".       
   bsheet:cells(i,14) = "发货地名称".     
   bsheet:cells(i,15) = "订单日".   
   bsheet:cells(i,16) = "采购单".         
   bsheet:cells(i,17) = "项次".      
   bsheet:cells(i,18) = "料号".      
   bsheet:cells(i,19) = "料号说明".     
   bsheet:cells(i,20) = "单位".        
   bsheet:cells(i,21) = "销售帐户".      
   bsheet:cells(i,22) = "销售分帐户".       
   bsheet:cells(i,23) = "成本中心".        
   bsheet:cells(i,24) = "发票数量".   
   bsheet:cells(i,25) = "应纳税".   
   bsheet:cells(i,26) = "税".      
   bsheet:cells(i,27) = "税用途". 
   bsheet:cells(i,28) = "纳税环境".   
   bsheet:cells(i,29) = "价格".                      
   bsheet:cells(i,30) = "合计价格".    
   bsheet:cells(i,31) = "毛利合计".                     
                    
   i = i + 1.          

   for each tmp-soivdet36 no-lock:
       bsheet:cells(i,1) =  t36_so_invnbr.
       bsheet:cells(i,2) =  t36_so_bill.
       bsheet:cells(i,3) =  t36_so_bill_name.
       bsheet:cells(i,4) =  t36_so_cust.
       bsheet:cells(i,5) =  t36_so_cust_name.
       bsheet:cells(i,6) =  t36_so_slspsn.
       bsheet:cells(i,7) =  t36_so_ar_acct.
       bsheet:cells(i,8) =  t36_so_ar_sub.
       bsheet:cells(i,9) =  t36_so_ar_cc.
       bsheet:cells(i,10) = t36_so_tax_env.
       bsheet:cells(i,11) = t36_so_tax_usage.
       bsheet:cells(i,12) = t36_so_nbr.
       bsheet:cells(i,13) = t36_so_ship.
       bsheet:cells(i,14) = t36_ship_name.
       bsheet:cells(i,15) = t36_so_ord_date.
       bsheet:cells(i,16) = t36_so_po.
       bsheet:cells(i,17) = t36_sod_line.
       bsheet:cells(i,18) = t36_sod_part.
       bsheet:cells(i,19) = t36_sod_desc1.
       bsheet:cells(i,20) = t36_sod_um.
       bsheet:cells(i,21) = t36_sod_acct.
       bsheet:cells(i,22) = t36_sod_sub.
       bsheet:cells(i,23) = t36_sod_cc.
       bsheet:cells(i,24) = t36_sod_qty_inv.
       bsheet:cells(i,25) = string(t36_sod_taxable).
       bsheet:cells(i,26) = t36_sod_taxc.
       bsheet:cells(i,27) = t36_sod_tax_usage.
       bsheet:cells(i,28) = t36_sod_tax_env.
       bsheet:cells(i,29) = t36_net_price.
       bsheet:cells(i,30) = t36_ext_price.
       bsheet:cells(i,31) = t36_ext_gr_margin.

       i = i + 1.
   end.
  bsheet:Cells:EntireColumn:AutoFit.
  bsheet:Range("F2"):Select.
  bexcel:ActiveWindow:FreezePanes = True.
if thfile <> "" then do:
  if search(thfile) = "" or search(thfile) = ? then bbook:SaveAs(thfile ,,,,,,1).
end.
bexcel:visible = true.

RELEASE OBJECT bsheet NO-ERROR.
RELEASE OBJECT bbook NO-ERROR.
RELEASE OBJECT bexcel NO-ERROR.
