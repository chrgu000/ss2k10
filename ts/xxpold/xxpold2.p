/* xxpold2.p - export to xls                                              */
{mfdeclre.i}
{xxpold.i}
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
   bsheet:cells(i,1)  = "�ɹ���".
   bsheet:cells(i,2)  = "��Ӧ��".
   bsheet:cells(i,3)  = "����-��".
   bsheet:cells(i,4)  = "������".
   bsheet:cells(i,5)  = "�۸��".
   bsheet:cells(i,6)  = "�ۿ۱�".
   bsheet:cells(i,7)  = "�ɹ�Ա".
   bsheet:cells(i,8)  = "��ע".
   bsheet:cells(i,9)  = "�ص�".
   bsheet:cells(i,10) = "���".
   bsheet:cells(i,11) = "�Ϻ�".
   bsheet:cells(i,12) = "������".
   bsheet:cells(i,13) = "Ԥ��1".
   bsheet:cells(i,14) = "Ԥ��2".
   bsheet:cells(i,15) = "���".
   bsheet:Range("A1:A1"):Interior:ColorIndex = 6.
   bsheet:Range("H1:H1"):Interior:ColorIndex = 6.
   bsheet:Range("A1"):AddComment NO-ERROR.
   bsheet:Range("A1"):Comment:TEXT("����") NO-ERROR.
   bsheet:Range("H1"):AddComment NO-ERROR.
   bsheet:Range("H1"):Comment:TEXT('������޸�ԭ�б�ע����"-"') NO-ERROR.
   i = i + 1.
   for each xxpod9 no-lock:
       bsheet:cells(i,1) = "'" + x9_nbr.
       bsheet:cells(i,2) = "'" + x9_vend.
       bsheet:cells(i,3) = "'" + x9_ship.
       bsheet:cells(i,4) = "'" + string(x9_due_date,"99/99/99").
       bsheet:cells(i,5) = "'" + x9_pr_list2.
       bsheet:cells(i,6) = "'" + x9_pr_list.
       bsheet:cells(i,7) = x9_buyer.
       bsheet:cells(i,8) = x9_rmks.
       bsheet:cells(i,9) = x9_site.
       bsheet:cells(i,10) = x9_line.
       bsheet:cells(i,11) = x9_part.
       bsheet:cells(i,12) = x9_qty_ord.
       bsheet:cells(i,13) = x9_qty_fc1.
       bsheet:cells(i,14) = x9_qty_fc2.
       bsheet:cells(i,15) = "'" + x9_chk.
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
  bsheet:Range("J2"):Select.
  bexcel:ActiveWindow:FreezePanes = True.

/* bbook:SaveAs(thfile ,,,,,,1).                                            */
bexcel:visible = true.
bbook:saved = false.

RELEASE OBJECT bsheet NO-ERROR.
RELEASE OBJECT bbook NO-ERROR.
RELEASE OBJECT bexcel NO-ERROR.
