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
   bsheet:cells(i,1) = "������".
   bsheet:cells(i,2) = "����".
   bsheet:cells(i,3) = "Ʊ����".
   bsheet:cells(i,4) = "������".
   bsheet:cells(i,5) = "��������".
   bsheet:cells(i,6) = "��ע".
   bsheet:cells(i,7) = "�ص�".
   bsheet:cells(i,8) = "����".
   bsheet:cells(i,9) = "˰��;".
   bsheet:cells(i,10) = "���".
   bsheet:cells(i,11) = "�Ϻ�".
   bsheet:cells(i,12) = "�ص�".
   bsheet:cells(i,13) = "����".
   bsheet:cells(i,14) = "�˻�".
   bsheet:cells(i,15) = "���˻�".
   bsheet:cells(i,16) = "�ɱ�����".
   bsheet:cells(i,17) = "��Ŀ".
   bsheet:cells(i,17) = "���".
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
