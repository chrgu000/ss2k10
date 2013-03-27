/* xxsocnimp02.p - export to xls                                              */
{mfdeclre.i}
{xxsocnrp01.i}
/* define input parameter thfile as CHAR FORMAT "x(50)".                      */
define variable bexcel as com-handle.
define variable bbook as com-handle.
define variable bsheet as com-handle.
define variable I as integer.
   CREATE "Excel.Application" bexcel.
   bbook = bexcel:Workbooks:add().
   bsheet = bexcel:sheets:item(1) no-error.
   bbook:Activate.
   assign i = 1.
   bsheet:cells(i,1) = "地点".
   bsheet:cells(i,2) = "地点说明".
   bsheet:cells(i,3) = "订单".
   bsheet:cells(i,4) = "项次".
   bsheet:cells(i,5) = "客户".
   bsheet:cells(i,6) = "客户说明".
   bsheet:cells(i,7) = "发货-至".
   bsheet:cells(i,8) = "发货-至说明".
   bsheet:cells(i,9) = "物料".
   bsheet:cells(i,10) = "物料描述".
   bsheet:cells(i,11) = "采购订单号".
   bsheet:cells(i,12) = "最多过期天数".
   bsheet:cells(i,13) = "库位".
   bsheet:cells(i,14) = "批/序号".
   bsheet:cells(i,15) = "参考号".
   bsheet:cells(i,16) = "数量".
   bsheet:cells(i,17) = "单位".
   bsheet:cells(i,18) = "币别".
   bsheet:cells(i,19) = "单价".
   bsheet:cells(i,20) = "已发货量".
   bsheet:cells(i,21) = "授权".
   bsheet:cells(i,22) = "发货人".
   bsheet:cells(i,23) = "在途中".
   bsheet:cells(i,24) = "发货日期".
   bsheet:cells(i,25) = "最多过期日期".

   i = i + 1.
   for each temp0 no-lock:
       bsheet:cells(i,1) = "'" + t0_site.
       bsheet:cells(i,2) = "'" + t0_si_desc.
       bsheet:cells(i,3) = "'" + t0_sod_nbr.
       bsheet:cells(i,4) = t0_sod_ln.
       bsheet:cells(i,5) = "'" + t0_cust.
       bsheet:cells(i,6) = "'" + t0_cm_desc.
       bsheet:cells(i,7) = "'" + t0_shipto.
       bsheet:cells(i,8) = "'" + t0_st_desc.
       bsheet:cells(i,9) = "'" + t0_part.
       bsheet:cells(i,10) = "'" + t0_pt_desc.
       bsheet:cells(i,11) = "'" + t0_po.
       bsheet:cells(i,12) = t0_max_days.
       bsheet:cells(i,13) = "'" + t0_loc.
       bsheet:cells(i,14) = "'" + t0_lot.
       bsheet:cells(i,15) = "'" + t0_ref.
       bsheet:cells(i,16) = t0_stock.
       bsheet:cells(i,17) = "'" + t0_um.
       bsheet:cells(i,18) = "'" + t0_curr.
       bsheet:cells(i,19) = t0_price.
       bsheet:cells(i,20) = t0_qty_ship.
       bsheet:cells(i,21) = "'" + t0_auth.
       bsheet:cells(i,22) = "'" + t0_asn_shipper. /*发货人*/
       bsheet:cells(i,23) = string(t0_intransit). /*在途中*/
       bsheet:cells(i,24) = "'" + string(t0_ship_date).
       bsheet:cells(i,25) = "'" + string(t0_aged_date).

/********************************************
       if tsod_chk = "" then do:
            bsheet:Range("a" + string(i) + ":" + "R" + string(i)):Interior:Color = 65535.
       end.
       else if tsod_chk <> "PASS" and tsod_chk <> "OK" then do:
            bsheet:Range("a" + string(i) + ":" + "R" + string(i)):Interior:Color = 255.
       end.
********************************************/
       i = i + 1.
   end.
  bsheet:Cells:EntireColumn:AutoFit.
  bsheet:Range("E2"):Select.
  bexcel:ActiveWindow:FreezePanes = True.

/* bbook:SaveAs(thfile,,,,,,1).                                               */
bexcel:visible = true.
bbook:saved = false.

RELEASE OBJECT bsheet NO-ERROR.
RELEASE OBJECT bbook NO-ERROR.
RELEASE OBJECT bexcel NO-ERROR.
