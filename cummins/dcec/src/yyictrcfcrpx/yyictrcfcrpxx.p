/* xxsocnimp02.p - export to xls                                             */
/*V8:ConvertMode=Maintenance                                                 */
{mfdeclre.i}
{yyictrcfcrpx.i}
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
   bsheet:cells(i,1)  = "零件号".
   bsheet:cells(i,2)  = "地点".
   bsheet:cells(i,3)  = "零件描述".
   bsheet:cells(i,4)  = "产品类".
   bsheet:cells(i,5)  = "ABC类".
   bsheet:cells(i,6)  = "保管员代码".
   bsheet:cells(i,7)  = "默认库位".
   bsheet:cells(i,8)  = "采购员代码".
   bsheet:cells(i,9)  = "供应商代码".
   bsheet:cells(i,10) = "E&O".
   bsheet:cells(i,11)  = "起始日库存".
   bsheet:cells(i,12)  = "起始日成本".
   bsheet:cells(i,13) = "起始日金额".
   bsheet:cells(i,14) = "采购收货".
   bsheet:cells(i,15) = "采购收货额".
   bsheet:cells(i,16) = "转移入库".
   bsheet:cells(i,17) = "转移入库额".
   bsheet:cells(i,18) = "计划外入库".
   bsheet:cells(i,19) = "计划外入库额".
   bsheet:cells(i,20) = "加工单入库".
   bsheet:cells(i,21) = "加工单入库额".
   bsheet:cells(i,22) = "采购退货".
   bsheet:cells(i,23) = "采购退货额".
   bsheet:cells(i,24) = "转移出库".
   bsheet:cells(i,25) = "转移出库额".
   bsheet:cells(i,26) = "计划外出库".
   bsheet:cells(i,27) = "计划外出库额".
   bsheet:cells(i,28) = "销售出库".
   bsheet:cells(i,29) = "销售出库额".
   bsheet:cells(i,30) = "加工单出库".
   bsheet:cells(i,31) = "加工单出库额".
   bsheet:cells(i,32) = "盘点调整".
   bsheet:cells(i,33) = "盘点调整额".
   bsheet:cells(i,34) = "其他".
   bsheet:cells(i,35) = "其他额".
   bsheet:cells(i,36)  = "截至日库存".
   bsheet:cells(i,37)  = "截至日成本".
   bsheet:cells(i,38) = "截至日金额".

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
                bsheet:cells(i,11) = ttr_qtyf.
                bsheet:cells(i,12) = ttr_cstf.
                bsheet:cells(i,13) = ttr_qtyf * ttr_cstf.
                bsheet:cells(i,14) = ttr_rctpo.
                bsheet:cells(i,15) = ttr_rctpoc.
                bsheet:cells(i,16) = ttr_rcttr.
                bsheet:cells(i,17) = ttr_rcttrc.
                bsheet:cells(i,18) = ttr_rctunp.
                bsheet:cells(i,19) = ttr_rctunpc.
                bsheet:cells(i,20) = ttr_rctwo.
                bsheet:cells(i,21) = ttr_rctwoc.
                bsheet:cells(i,22) = ttr_isspo.
                bsheet:cells(i,23) = ttr_isspoc.
                bsheet:cells(i,24) = ttr_isstr.
                bsheet:cells(i,25) = ttr_isstrc.
                bsheet:cells(i,26) = ttr_issunp.
                bsheet:cells(i,27) = ttr_issunpc.
                bsheet:cells(i,28) = ttr_issso.
                bsheet:cells(i,29) = ttr_isssoc.
                bsheet:cells(i,30) = ttr_isswo.
                bsheet:cells(i,31) = ttr_isswoc.
                bsheet:cells(i,32) = ttr_invadj.
                bsheet:cells(i,33) = ttr_invadjc.
                bsheet:cells(i,34) = ttr_oth.
                bsheet:cells(i,35) = ttr_othc.
                bsheet:cells(i,36) = ttr_qtyt.
                bsheet:cells(i,37) = ttr_cstt.
                bsheet:cells(i,38) = ttr_qtyt * ttr_cstt.
                i = i + 1.
    end.

  bsheet:Cells:EntireColumn:AutoFit.
  bsheet:Range("F2"):Select.
  bexcel:ActiveWindow:FreezePanes = True.
if search(thfile) = "" and search(thfile) = ? then
   bbook:SaveAs(thfile ,,,,,,1).
bexcel:visible = true.
bbook:saved = true.

RELEASE OBJECT bsheet NO-ERROR.
RELEASE OBJECT bbook NO-ERROR.
RELEASE OBJECT bexcel NO-ERROR.
