/* xxsocnimp02.p - export to xls                                              */
{mfdeclre.i}
{xxptrp07.i}
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
   bsheet:cells(i,1)  = "零件号".
   bsheet:cells(i,2)  = "零件描述".
   bsheet:cells(i,3)  = "产品类".
   bsheet:cells(i,4)  = "库存总数量".
   bsheet:cells(i,5)  = "库存单位标准成本".
   bsheet:cells(i,6)  = "小于等于" + string(days[1]) + "天".
   bsheet:cells(i,7)  = days[2].
   bsheet:cells(i,8)  = days[3].
   bsheet:cells(i,9)  = days[4].
   bsheet:cells(i,10) = days[5].
   bsheet:cells(i,11) = days[6].
   bsheet:cells(i,12) = days[7].
   bsheet:cells(i,13) = days[8].
   bsheet:cells(i,14) = days[9].
   bsheet:cells(i,15) = "大于" + string(days[9]).

   i = i + 1.

   for each x_ret no-lock:
       bsheet:cells(i,1) = "'" + xr_part.
       bsheet:cells(i,2) = "'" + xr_desc1.
       bsheet:cells(i,3) = "'" + xr_prodline.
       bsheet:cells(i,4) = xr_qty_oh.
       bsheet:cells(i,5) = xr_cst.
       bsheet:cells(i,6) = xr_qty[1].
       bsheet:cells(i,7) = xr_qty[2].
       bsheet:cells(i,8) = xr_qty[3].
       bsheet:cells(i,9) = xr_qty[4].
       bsheet:cells(i,10) =xr_qty[5].
       bsheet:cells(i,11) =xr_qty[6].
       bsheet:cells(i,12) =xr_qty[7].
       bsheet:cells(i,13) =xr_qty[8].
       bsheet:cells(i,14) =xr_qty[9].
       bsheet:cells(i,15) =xr_qty[10].
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
