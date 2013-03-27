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
   bsheet:cells(i,1) = "�ص�".
   bsheet:cells(i,2) = "�ص�˵��".
   bsheet:cells(i,3) = "����".
   bsheet:cells(i,4) = "���".
   bsheet:cells(i,5) = "�ͻ�".
   bsheet:cells(i,6) = "�ͻ�˵��".
   bsheet:cells(i,7) = "����-��".
   bsheet:cells(i,8) = "����-��˵��".
   bsheet:cells(i,9) = "����".
   bsheet:cells(i,10) = "��������".
   bsheet:cells(i,11) = "�ɹ�������".
   bsheet:cells(i,12) = "����������".
   bsheet:cells(i,13) = "��λ".
   bsheet:cells(i,14) = "��/���".
   bsheet:cells(i,15) = "�ο���".
   bsheet:cells(i,16) = "����".
   bsheet:cells(i,17) = "��λ".
   bsheet:cells(i,18) = "�ұ�".
   bsheet:cells(i,19) = "����".
   bsheet:cells(i,20) = "�ѷ�����".
   bsheet:cells(i,21) = "��Ȩ".
   bsheet:cells(i,22) = "������".
   bsheet:cells(i,23) = "��;��".
   bsheet:cells(i,24) = "��������".
   bsheet:cells(i,25) = "����������".

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
       bsheet:cells(i,22) = "'" + t0_asn_shipper. /*������*/
       bsheet:cells(i,23) = string(t0_intransit). /*��;��*/
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
