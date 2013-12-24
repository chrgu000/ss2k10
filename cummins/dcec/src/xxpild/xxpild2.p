/* xxpold2.p - export to xls                                              */
{mfdeclre.i}
{xxpild.i}
/* define input parameter thfile as CHAR FORMAT "x(50)".                     */
define variable bexcel as com-handle.
define variable bbook as com-handle.
define variable bsheet as com-handle.
define variable I as integer.
   CREATE "Excel.Application" bexcel.
   bbook = bexcel:Workbooks:add().
   bsheet = bexcel:sheets:item(1) no-error.
   bbook:Activate.
   assign i = 1.
   bsheet:cells(i,1)  = "销售价格单号".
   bsheet:cells(i,2)  = "客户编码".
   bsheet:cells(i,3)  = "零件编码".
   bsheet:cells(i,4)  = "货币".
   bsheet:cells(i,5)  = "计量单位".
   bsheet:cells(i,6)  = "开始日期".
   bsheet:cells(i,7)  = "结束日期".
   bsheet:cells(i,8)  = "单价".
   bsheet:cells(i,9) = "结果".
/*   bsheet:Range("H1:H1"):Interior:ColorIndex = 6.                          */
/*   bsheet:Range("H1"):AddComment NO-ERROR.                                 */
/*   bsheet:Range("H1"):Comment:TEXT('如果是L类型则可以不填') NO-ERROR.      */
   i = i + 1.
   for each xxtmppi no-lock:
       bsheet:cells(i,1) = xxpi_list.
       bsheet:cells(i,2) = xxpi_cs.
       bsheet:cells(i,3) = xxpi_part.
       bsheet:cells(i,4) = xxpi_curr.
       bsheet:cells(i,5) = xxpi_um.
       bsheet:cells(i,6) = string(year(xxpi_start),"9999")
                         + "-" + string(month(xxpi_start),"99")
                         + "-" + string(day(xxpi_start),"99") .
       bsheet:cells(i,7) = string(year(xxpi_expir),"9999") + "-"
                         + string(month(xxpi_expir),"99") + "-"
                         + string(day(xxpi_expir),"99") .
       bsheet:cells(i,8) = xxpi_amt.
       bsheet:cells(i,9) = "'" + xxpi_chk.
       i = i + 1.
   end.
  bsheet:Cells:EntireColumn:AutoFit.
  bsheet:Range("G2"):Select.
  bexcel:ActiveWindow:FreezePanes = True.

/* bbook:SaveAs(thfile ,,,,,,1).                                            */
bexcel:visible = true.
bbook:saved = false.

RELEASE OBJECT bsheet NO-ERROR.
RELEASE OBJECT bbook NO-ERROR.
RELEASE OBJECT bexcel NO-ERROR.
