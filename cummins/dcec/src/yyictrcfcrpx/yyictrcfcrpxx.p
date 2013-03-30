/* xxsocnimp02.p - export to xls                                              */
{mfdeclre.i}
{yyictrcfcrpx.i}
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
   bsheet:cells(i,4)  = "ABC类".
   bsheet:cells(i,5)  = "保管员代码".
   bsheet:cells(i,6)  = "默认库位".
   bsheet:cells(i,7)  = "采购员代码".
   bsheet:cells(i,8)  = "供应商代码".
   bsheet:cells(i,9)  = "E&O".
   bsheet:cells(i,10)  = "起始日库存".
   bsheet:cells(i,11)  = "起始日成本".
   bsheet:cells(i,12) = "起始日金额".
   bsheet:cells(i,13) = "采购收货".
   bsheet:cells(i,14) = "转移入库".
   bsheet:cells(i,15) = "计划外入库".
   bsheet:cells(i,16) = "加工单入库".
   bsheet:cells(i,17) = "采购退货".
   bsheet:cells(i,18) = "转移出库".
   bsheet:cells(i,19) = "计划外出库".
   bsheet:cells(i,20) = "销售出库".
   bsheet:cells(i,21) = "加工单出库".
   bsheet:cells(i,22) = "盘点调整".
   bsheet:cells(i,23) = "其他".
   bsheet:cells(i,24)  = "截至日库存".
   bsheet:cells(i,25)  = "截至日成本".
   bsheet:cells(i,26) = "截至日金额".

   i = i + 1.
for each temptr no-lock break by ttr_part by ttr_site:
        if first-of(ttr_part) then do:
           find first pt_mstr no-lock where pt_domain = global_domain
                  and pt_part = ttr_part no-error.
        end.
        find first ptp_det no-lock where ptp_domain = global_domain
               and ptp_part = ttr_part and ptp_site = ttr_site no-error.
        find first in_mstr no-lock where in_domain = global_domain
               and in_part = ttr_part and in_site = ttr_site.
                bsheet:cells(i,1) = "'" + ttr_part.
                if available pt_mstr then do:
                   bsheet:cells(i,2) = "'" + pt_desc2.
                   bsheet:cells(i,3) = "'" + pt_prod_line.
                end.
                if available (in_mstr) then do:
                   bsheet:cells(i,4) = "'" + in_abc.
                   bsheet:cells(i,5) = "'" + in__qadc01.
                   bsheet:cells(i,6) = "'" + in_loc.
                end.
                if available ptp_det then do:
                   bsheet:cells(i,7) = "'" + ptp_buyer.
                   bsheet:cells(i,8) = "'" + ptp_vend.
                   bsheet:cells(i,9) = "'" + ptp_run_seq2.
                end.
                bsheet:cells(i,10) = ttr_qtyf.
                bsheet:cells(i,11) = ttr_cstf.
                bsheet:cells(i,12) = ttr_qtyf * ttr_cstf.
                bsheet:cells(i,13) = ttr_rctpo.
                bsheet:cells(i,14) = ttr_rcttr.
                bsheet:cells(i,15) = ttr_rctunp.
                bsheet:cells(i,16) = ttr_rctwo.
                bsheet:cells(i,17) = ttr_isspo.
                bsheet:cells(i,18) = ttr_isstr.
                bsheet:cells(i,19) = ttr_issunp.
                bsheet:cells(i,20) = ttr_issso.
                bsheet:cells(i,21) = ttr_isswo.
                bsheet:cells(i,22) = ttr_invadj.
                bsheet:cells(i,23) = ttr_oth.
                bsheet:cells(i,24) = ttr_qtyt.
                bsheet:cells(i,25) = ttr_cstt.
                bsheet:cells(i,26) = ttr_qtyt * ttr_cstt.
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
