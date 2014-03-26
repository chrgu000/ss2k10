/* xxsocnimp02.p - export to xls                                              */
{mfdeclre.i}
{xxdiscrp.i}
define input parameter thfile as CHAR FORMAT "x(50)".
define variable cmsort like cm_sort.
define variable bexcel as com-handle.
define variable bbook as com-handle.
define variable bsheet as com-handle.
define variable I as integer.
   CREATE "Excel.Application" bexcel.
   bbook = bexcel:Workbooks:add().
   bsheet = bexcel:sheets:item(1) no-error.
   bbook:Activate.
   assign i = 1.
   bsheet:cells(i,1) = "票据开往地".
   bsheet:cells(i,2) = "客户描述".
   bsheet:cells(i,3) = "折扣总额".
   bsheet:cells(i,4) = "发票号".
   bsheet:cells(i,5) = "发票折扣额".
   bsheet:cells(i,6) = "累计已开折扣额".
   bsheet:cells(i,7) = "发票日期".
   bsheet:cells(i,8) = "未开折扣额".

   i = i + 1.
       for each t0 NO-LOCK BREAK BY t0_bill BY t0_inv_date:
          /* SET EXTERNAL LABELS */
          IF FIRST-OF(t0_bill) THEN do:
              assign cmsort = "".
              FIND FIRST cm_mstr NO-LOCK WHERE
                         cm_domain = GLOBAL_domain AND
                         cm_addr = t0_bill NO-ERROR.
              if available cm_mstr then assign cmsort = cm_sort.
          end.
           bsheet:cells(i,1) = "'" + t0_bill.
           bsheet:cells(i,2) = "'" + cmsort.
           bsheet:cells(i,3) =  t0_ds_amt.
           bsheet:cells(i,4) = "'" + t0_ih_nbr.
           bsheet:cells(i,5) = t0_ih_amt.
           bsheet:cells(i,6) = t0_sum_amt.
           bsheet:cells(i,7) = string(year(t0_inv_date),"9999") + "-" + string(month(t0_inv_date),"99") + "-" + string(day(t0_inv_date),"99").
           bsheet:cells(i,8) = t0_open_amt.
           i = i + 1.
   end.
  bsheet:Cells:EntireColumn:AutoFit.
  bsheet:Range("B2"):Select.
  bexcel:ActiveWindow:FreezePanes = True.
if search(thfile) = "" and search(thfile) = ? then
   bbook:SaveAs(thfile ,,,,,,1).
bexcel:visible = true.
bbook:saved = true.

RELEASE OBJECT bsheet NO-ERROR.
RELEASE OBJECT bbook NO-ERROR.
RELEASE OBJECT bexcel NO-ERROR.
