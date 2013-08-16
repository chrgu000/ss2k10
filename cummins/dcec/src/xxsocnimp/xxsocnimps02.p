/* xxsocnimp02.p - export to xls                                              */
{mfdeclre.i}
{xxsocnimp.i}
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
   bsheet:cells(i,1)  = "ShipTO".
   bsheet:cells(i,2)  = "BillTo".
   bsheet:cells(i,3)  = "SO_Nbr".
   bsheet:cells(i,4)  = "Sod_Line".
   bsheet:cells(i,5)  = "SN".
   bsheet:cells(i,6)  = "Sod_Part".
   bsheet:cells(i,7)  = "Chinese Desc".
   bsheet:cells(i,8)  = "Eng Desc".
   bsheet:cells(i,9)  = "Iss-Qty".
   bsheet:cells(i,10) = "Iss-Site".
   bsheet:cells(i,11) = "Iss-Loc".
   bsheet:cells(i,12) = "keep-Qty".
   bsheet:cells(i,13) = "Iss-Lot".
   bsheet:cells(i,14) = "Iss-Ref".
   bsheet:cells(i,15) = "Iss-Due-Date".
   bsheet:cells(i,16) = "Sales_Price".
   bsheet:cells(i,17) = "Total".
   bsheet:cells(i,18) = "UpdatePrice".
   bsheet:cells(i,19) = "Description".
   i = i + 1.
   bsheet:cells(i,1) = "������".
   bsheet:cells(i,2) = "����".
   bsheet:cells(i,3) = "���۶�����".
   bsheet:cells(i,4) = "���۶������".
   bsheet:cells(i,5) = "���".
   bsheet:cells(i,6) = "��������".
   bsheet:cells(i,7) = "��������".
   bsheet:cells(i,8) = "Ӣ������".
   bsheet:cells(i,9) = "ʹ������".
   bsheet:cells(i,10) = "���˵ص�".
   bsheet:cells(i,11) = "���˿�λ".
   bsheet:cells(i,12) = "ʣ����".
   bsheet:cells(i,13) = "��������".
   bsheet:cells(i,14) = "�ο�".
   bsheet:cells(i,15) = "��Ч����".
   bsheet:cells(i,16) = "����".
   bsheet:cells(i,17) = "�ϼ�".
   bsheet:cells(i,18) = "���¼۸�".
   bsheet:cells(i,19) = "���".
   i = i + 1.
   bsheet:Range("A1:B2"):Interior:ColorIndex = 6.
   bsheet:Range("A1"):AddComment NO-ERROR.
   bsheet:Range("A1"):Comment:TEXT("����") NO-ERROR.
   bsheet:Range("B1"):AddComment NO-ERROR.
   bsheet:Range("B1"):Comment:TEXT("����") NO-ERROR.
   bsheet:Range("C1:C2"):Interior:ColorIndex = 7.
   bsheet:Range("C1"):AddComment NO-ERROR.
   bsheet:Range("C1"):Comment:TEXT("ѡ��") NO-ERROR.
   bsheet:Range("F1:F2"):Interior:ColorIndex = 6.
   bsheet:Range("F1"):AddComment NO-ERROR.
   bsheet:Range("F1"):Comment:TEXT("����") NO-ERROR.
   bsheet:Range("I1:J2"):Interior:ColorIndex = 6.
   bsheet:Range("I1"):AddComment NO-ERROR.
   bsheet:Range("I1"):Comment:TEXT("����") NO-ERROR.
   bsheet:Range("J1"):AddComment NO-ERROR.
   bsheet:Range("J1"):Comment:TEXT("����") NO-ERROR.
   for each xsc_d no-lock:
       bsheet:cells(i,1) = "'" + xsd_ship.
       bsheet:cells(i,2) = "'" + xsd_cust.
       bsheet:cells(i,3) = "'" + xsd_so.
       bsheet:cells(i,4) = xsd_line.
       bsheet:cells(i,5) = "'" + xsd_serial.
       bsheet:cells(i,6) = xsd_part.
       bsheet:cells(i,7) = xsd_desc1.
       bsheet:cells(i,8) = xsd_desc2.
       bsheet:cells(i,9) = xsd_qty_used.
       bsheet:cells(i,10) = "'" + xsd_site.
       bsheet:cells(i,11) = "'" + xsd_loc.
       bsheet:cells(i,12) = xsd_qty_keep.
       bsheet:cells(i,13) = "'" + xsd_lot.
       bsheet:cells(i,14) = "'" + xsd_ref.
       bsheet:cells(i,15) = "'" + string(xsd_eff,"99/99/99").
       bsheet:cells(i,16) = xsd_price.
       bsheet:cells(i,17) = xsd_amt.
       bsheet:cells(i,18) = xsd_newpc.
       bsheet:cells(i,19) = xsd_chk.
       if xsd_chk = "" then do:
            bsheet:Range("a" + string(i) + ":" + "R" + string(i)):Interior:Color = 65535.
       end.
       else if xsd_chk <> "PASS" and xsd_chk <> "OK" then do:
            bsheet:Range("a" + string(i) + ":" + "R" + string(i)):Interior:Color = 255.
       end.

       i = i + 1.
   end.
  bsheet:Cells:EntireColumn:AutoFit.
  bsheet:Range("G3"):Select.
  bexcel:ActiveWindow:FreezePanes = True.

/* bbook:SaveAs(thfile ,,,,,,1).                                            */
bexcel:visible = true.
bbook:saved = false.

RELEASE OBJECT bsheet NO-ERROR.
RELEASE OBJECT bbook NO-ERROR.
RELEASE OBJECT bexcel NO-ERROR.
