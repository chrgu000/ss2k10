/* xxsoimp2.p - export to xls                                              */
{mfdeclre.i}
{xxsoimp.i}
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
   bsheet:cells(i,1)  = "订单号".
   bsheet:cells(i,2)  = "销往".
   bsheet:cells(i,3)  = "发票地址".
   bsheet:cells(i,4)  = "货物发往".
   bsheet:cells(i,5)  = "要求日期".
   bsheet:cells(i,6)  = "截止日期".
   bsheet:cells(i,7)  = "备注".
   bsheet:cells(i,8)  = "地点".
   bsheet:cells(i,9)  = "货币".
   bsheet:cells(i,10) = "项次".
   bsheet:cells(i,11) = "ERP 号".
   bsheet:cells(i,12)  = "地点".
   bsheet:cells(i,13)  = "数量".
   bsheet:cells(i,14)  = "库位".
   bsheet:cells(i,15)  = "账户".
   bsheet:cells(i,16)  = "分账户".
   bsheet:cells(i,17)  = "截止日期".
   bsheet:cells(i,18)  = "说明1".
   bsheet:cells(i,19)  = "结果".
/*   bsheet:Range("A1:B2"):Interior:ColorIndex = 6.                */
/*   bsheet:Range("A1"):AddComment NO-ERROR.                       */
/*   bsheet:Range("A1"):Comment:TEXT("必填") NO-ERROR.             */
   i = i + 1.
   for each tmp-so no-lock:
       bsheet:cells(i,1) = "'" + tso_nbr.
       bsheet:cells(i,2) = "'" + tso_cust.
       bsheet:cells(i,3) = "'" + tso_bill.
       bsheet:cells(i,4) = "'" + tso_ship.
       bsheet:cells(i,5) = "'" + string(tso_req_date,"9999/99/99").
       bsheet:cells(i,6) = "'" + string(tso_due_date,"9999/99/99").
       bsheet:cells(i,7) = tso_rmks.
       bsheet:cells(i,8) = tso_site.
       bsheet:cells(i,9) = tso_curr.
       bsheet:cells(i,10) = tsod_line.
       bsheet:cells(i,11) = "'" + tsod_part.
       bsheet:cells(i,12) = "'" + tsod_site.
       bsheet:cells(i,13) = tsod_qty_ord.
       bsheet:cells(i,14) = "'" + tsod_loc.
       bsheet:cells(i,15) = "'" + tsod_acct.
       bsheet:cells(i,16) = "'" + tsod_sub.
       bsheet:cells(i,17) = "'" + string(tsod_due_date,"9999/99/99").
       bsheet:cells(i,18) = "'" + tsod_rmks1.
       bsheet:cells(i,19) = "'" + tsod_chk.

/*
       if xsd_chk = "" then do:
            bsheet:Range("a" + string(i) + ":" + "R" + string(i)):Interior:Color = 65535.
       end.
       else if xsd_chk <> "PASS" and xsd_chk <> "OK" then do:
            bsheet:Range("a" + string(i) + ":" + "R" + string(i)):Interior:Color = 255.
       end.
*/

       i = i + 1.
   end.
  bsheet:Cells:EntireColumn:AutoFit.
  bsheet:Range("B2"):Select.
  bexcel:ActiveWindow:FreezePanes = True.

bbook:SaveAs(thfile ,,,,,,1).
bexcel:visible = true.
bbook:saved = false.

RELEASE OBJECT bsheet NO-ERROR.
RELEASE OBJECT bbook NO-ERROR.
RELEASE OBJECT bexcel NO-ERROR.
