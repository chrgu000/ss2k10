/* yyictrcfcp-2x.p - Export Data to XLS Format                               */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION END                                                              */
{mfdeclre.i}
{yyictrcfcp-2.i}
define input parameter thfile as CHAR FORMAT "x(50)".
define variable ptdesc2 like pt_desc2.
define variable ptprodline like pt_prod_line.
define variable bexcel as com-handle.
define variable bbook as com-handle.
define variable bsheet as com-handle.
define variable I as integer.
   CREATE "Excel.Application" bexcel.
   bbook = bexcel:Workbooks:add().
   bsheet = bexcel:sheets:item(1) no-error.
   bbook:Activate.
   assign i = 1.
   bsheet:cells(i,1)  = "�����".
   bsheet:cells(i,2)  = "�ص�".
   bsheet:cells(i,3)  = "�������".
   bsheet:cells(i,4)  = "��Ʒ��".
   bsheet:cells(i,5)  = "ABC��".
   bsheet:cells(i,6)  = "����Ա����".
   bsheet:cells(i,7)  = "Ĭ�Ͽ�λ".
   bsheet:cells(i,8)  = "�ɹ�Ա����".
   bsheet:cells(i,9)  = "��Ӧ�̴���".
   bsheet:cells(i,10) = "E&O".
   bsheet:cells(i,11) = "�ɹ��ջ�".
   bsheet:cells(i,12) = "ת�����".
   bsheet:cells(i,13) = "�ƻ������".
   bsheet:cells(i,14) = "�ӹ������".
   bsheet:cells(i,15) = "�ɹ��˻�".
   bsheet:cells(i,16) = "ת�Ƴ���".
   bsheet:cells(i,17) = "�ƻ������".
   bsheet:cells(i,18) = "���۳���".
   bsheet:cells(i,19) = "�ӹ�������".
   bsheet:cells(i,20) = "�̵����".
   bsheet:cells(i,21) = "����".

   i = i + 1.
for each temptr no-lock break by ttr_part by ttr_site:
        if first-of(ttr_part) then do:
           assign ptdesc2 = ""
                  ptprodline = "".
           find first pt_mstr no-lock where pt_domain = global_domain
                  and pt_part = ttr_part no-error.
           if available pt_mstr then do:
              assign ptdesc2 = pt_desc2
                     ptprodline = pt_prod_line.
           end.
        end.
        find first ptp_det no-lock where ptp_domain = global_domain
               and ptp_part = ttr_part and ptp_site = ttr_site no-error.
        find first in_mstr no-lock where in_domain = global_domain
               and in_part = ttr_part and in_site = ttr_site.
                bsheet:cells(i,1) = "'" + ttr_part.
                bsheet:cells(i,2) = "'" + ttr_site.
                bsheet:cells(i,3) = "'" + ptdesc2.
                bsheet:cells(i,4) = "'" + ptprodline.
                if available (in_mstr) then do:
                   bsheet:cells(i,5) = "'" + in_abc.
                   bsheet:cells(i,6) = "'" + in__qadc01.
                   bsheet:cells(i,7) = "'" + in_loc.
                end.
                if available ptp_det then do:
                   bsheet:cells(i,8) = "'" + ptp_buyer.
                   bsheet:cells(i,9) = "'" + ptp_vend.
                   bsheet:cells(i,10) = "'" + ptp_run_seq2.
                end.
                bsheet:cells(i,11) = ttr_rctpo.
                bsheet:cells(i,12) = ttr_rcttr.
                bsheet:cells(i,13) = ttr_rctunp.
                bsheet:cells(i,14) = ttr_rctwo.
                bsheet:cells(i,15) = ttr_isspo.
                bsheet:cells(i,16) = ttr_isstr.
                bsheet:cells(i,17) = ttr_issunp.
                bsheet:cells(i,18) = ttr_issso.
                bsheet:cells(i,19) = ttr_isswo.
                bsheet:cells(i,20) = ttr_invadj.
                bsheet:cells(i,21) = ttr_oth.
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
