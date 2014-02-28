/* xxpold2.p - export to xls                                              */
{mfdeclre.i}
{xxpcld.i}
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
   bsheet:cells(i,1)  = "�ɹ�/���ۼ۸񵥺�".
   bsheet:cells(i,2)  = "�������".
   bsheet:cells(i,3)  = "����".
   bsheet:cells(i,4)  = "������λ".
   bsheet:cells(i,5)  = "��ʼ����".
   bsheet:cells(i,6)  = "��������".
   bsheet:cells(i,7)  = "�������(L/P)".
   bsheet:cells(i,8)  = "��С��".
   bsheet:cells(i,9)  = "����".
   bsheet:cells(i,10) = "���".
   bsheet:Range("H1:H1"):Interior:ColorIndex = 6.
   bsheet:Range("H1"):AddComment NO-ERROR.
   bsheet:Range("H1"):Comment:TEXT('�����L��������Բ���') NO-ERROR.
   bsheet:Range("F1"):AddComment NO-ERROR.                                        
   bsheet:Range("F1"):Comment:TEXT('����Ϊ�ı���ʽ(YYYY-MM-DD)') NO-ERROR. 
   i = i + 1.
   for each xxtmppc no-lock:
       bsheet:cells(i,1) = xxpc_list.
       bsheet:cells(i,2) = xxpc_part.
       bsheet:cells(i,3) = xxpc_curr.
       bsheet:cells(i,4) = xxpc_um.
       bsheet:cells(i,5) = string(year(xxpc_start),"9999")
                         + "-" + string(month(xxpc_start),"99")
                         + "-" + string(day(xxpc_start),"99") .
       bsheet:cells(i,6) = string(year(xxpc_expir),"9999") + "-"
                         + string(month(xxpc_expir),"99") + "-"
                         + string(day(xxpc_expir),"99") .
       bsheet:cells(i,7) = xxpc_type.
       bsheet:cells(i,8) = xxpc_min_qty.
       bsheet:cells(i,9) = xxpc_amt.
       bsheet:cells(i,10) = "'" + xxpc_chk.
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
