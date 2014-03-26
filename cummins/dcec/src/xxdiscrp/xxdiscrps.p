/* xxsocnimp02.p - export to xls                                              */
{mfdeclre.i}
{xxdiscrp.i}
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
   bsheet:cells(i,1) = "票据开往地".
   bsheet:cells(i,2) = "客户描述".
   bsheet:cells(i,3) = "折扣总额".
   bsheet:cells(i,4) = "累计已开折扣额".
   bsheet:cells(i,5) = "未开折扣额".

   i = i + 1.

   for each t1 NO-LOCK BREAK BY t1_bill:
          /* SET EXTERNAL LABELS */
          FIND FIRST cm_mstr NO-LOCK WHERE cm_domain = GLOBAL_domain AND cm_addr = t1_bill NO-ERROR.
           bsheet:cells(i,1) = "'" + t1_bill.
           if available cm_mstr then
           bsheet:cells(i,2) = "'" + cm_sort.
           bsheet:cells(i,3) = t1_ds_amt.
           bsheet:cells(i,4) = t1_sum_amt.
           bsheet:cells(i,5) = t1_open_amt.
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
