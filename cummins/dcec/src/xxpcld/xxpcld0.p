/* xxpold0.p - import from xls                                            */
{mfdeclre.i}
{xxloaddata.i}
{xxpcld.i}
define input parameter thfile as CHAR FORMAT "x(50)".

if search(thfile) = "" or search(thfile) = ? then do:
   .
end.
else do:
     define variable bexcel as com-handle.
     define variable bbook as com-handle.
     define variable bsheet as com-handle.
     define variable intI as integer.
      create "Excel.Application" bexcel.
      bexcel:visible = false.
      bbook = bexcel:Workbooks:OPEN(thfile,,true).
      bsheet = bexcel:Sheets:Item(1) NO-ERROR.
      bsheet:Activate NO-ERROR.
      empty temp-table xxtmppc no-error.
      DO intI = 2 TO bsheet:UsedRange:Rows:Count:
         if TRIM(bsheet:cells(intI,1):FormulaR1C1) <> "" and
            TRIM(bsheet:cells(intI,2):FormulaR1C1) <> "" and
            TRIM(bsheet:cells(intI,3):FormulaR1C1) <> "" and
            TRIM(bsheet:cells(intI,4):FormulaR1C1) <> "" and
            TRIM(bsheet:cells(intI,5):FormulaR1C1) <> "" then do:
            create xxtmppc.
            assign xxpc_list = TRIM(bsheet:cells(intI,1):FormulaR1C1)
                   xxpc_part = TRIM(bsheet:cells(intI,2):FormulaR1C1)
                   xxpc_curr = TRIM(bsheet:cells(intI,3):FormulaR1C1)
                   xxpc_um = TRIM(bsheet:cells(intI,4):FormulaR1C1)
                   xxpc_start = str2Date(TRIM(bsheet:cells(intI,5):value),"ymd")
                   xxpc_expir = str2Date(TRIM(bsheet:cells(intI,6):value),"ymd")
                   xxpc_type = TRIM(bsheet:cells(intI,7):FormulaR1C1)
                   xxpc_min_qty = decimal(TRIM(bsheet:cells(intI,8):FormulaR1C1))
                   xxpc_amt = decimal(TRIM(bsheet:cells(intI,9):FormulaR1C1))
                   no-error.
         end.
      END.
    bbook:CLOSE().
    bexcel:quit.
    RELEASE OBJECT bsheet NO-ERROR.
    RELEASE OBJECT bbook NO-ERROR.
    RELEASE OBJECT bexcel NO-ERROR.
end.
