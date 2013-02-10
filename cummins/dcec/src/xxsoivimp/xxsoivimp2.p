/* xxsocnimp02.p - export to xls                                              */
{mfdeclre.i}
{xxsoivimp.i}
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
   bsheet:cells(i,1) = "订单号".
   bsheet:cells(i,2) = "销往".
   bsheet:cells(i,3) = "票据至".
   bsheet:cells(i,4) = "发货至".
   bsheet:cells(i,5) = "订货日期".
   bsheet:cells(i,6) = "备注".
   bsheet:cells(i,7) = "地点".
   bsheet:cells(i,8) = "渠道".
   bsheet:cells(i,9) = "税用途".
   bsheet:cells(i,10) = "项次".
   bsheet:cells(i,11) = "料号".
   bsheet:cells(i,12) = "地点".
   bsheet:cells(i,13) = "数量".
   bsheet:cells(i,14) = "账户".
   bsheet:cells(i,15) = "分账户".
   bsheet:cells(i,16) = "成本中心".
   bsheet:cells(i,17) = "项目".
   bsheet:cells(i,17) = "结果".
   i = i + 1.
   for each tmp-so no-lock:
       bsheet:cells(i,1) = "'" + tso_nbr.
       bsheet:cells(i,2) = "'" + tso_cust.
       bsheet:cells(i,3) = "'" + tso_bill.
       bsheet:cells(i,4) = "'" + tso_ship.
       bsheet:cells(i,5) = "'" + string(tso_ord_date).
       bsheet:cells(i,6) = "'" + tso_rmks.
       bsheet:cells(i,7) = "'" + tso_site.
       bsheet:cells(i,8) = "'" + tso_channel.
       bsheet:cells(i,9) = "'" + tso_tax_usage.
       bsheet:cells(i,10) = tsod_line.
       bsheet:cells(i,11) = "'" + tsod_part.
       bsheet:cells(i,12) = "'" + tsod_site.
       bsheet:cells(i,13) = tsod_qty_ord.
       bsheet:cells(i,14) = "'" + tsod_acct.
       bsheet:cells(i,15) = "'" + tsod_sub.
       bsheet:cells(i,16) = "'" + tsod_cc.
       bsheet:cells(i,17) = "'" + tsod_proj.
       bsheet:cells(i,18) = tsod_chk.
       if tsod_chk = "" then do:
            bsheet:Range("a" + string(i) + ":" + "R" + string(i)):Interior:Color = 65535.
       end.
       else if tsod_chk <> "PASS" and tsod_chk <> "OK" then do:
            bsheet:Range("a" + string(i) + ":" + "R" + string(i)):Interior:Color = 255.
       end.

       i = i + 1.
   end.
  bsheet:Cells:EntireColumn:AutoFit.
  bsheet:Range("G2"):Select.
  bexcel:ActiveWindow:FreezePanes = True.

bbook:SaveAs(thfile,,,,,,1).
bexcel:visible = true.
bbook:saved = true.

RELEASE OBJECT bsheet NO-ERROR.
RELEASE OBJECT bbook NO-ERROR.
RELEASE OBJECT bexcel NO-ERROR.
