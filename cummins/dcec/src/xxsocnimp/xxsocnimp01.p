/* xxsocnimp01.p - import from xls                                            */

{mfdeclre.i}

{xxsocnimp.i}
define input parameter thfile as CHAR FORMAT "x(50)".
define variable bexcel as com-handle.
define variable bbook as com-handle.
define variable bsheet as com-handle.
define variable intI as integer.
  create "Excel.Application" bexcel.
  bexcel:visible = false.
  bbook = bexcel:Workbooks:OPEN(thfile,,true).
  bsheet = bexcel:Sheets:Item(1) NO-ERROR.
  bsheet:Activate NO-ERROR.

  DO intI = 3 TO bsheet:UsedRange:Rows:Count:
     if TRIM(bsheet:cells(intI,1):FormulaR1C1) <> "" and
        TRIM(bsheet:cells(intI,2):FormulaR1C1) <> "" and
        TRIM(bsheet:cells(intI,6):FormulaR1C1) <> "" and
        TRIM(bsheet:cells(intI,9):FormulaR1C1) <> "" then do:
        create xsc_m.
        assign xsm_ship = TRIM(bsheet:cells(intI,1):FormulaR1C1)
               xsm_cust = TRIM(bsheet:cells(intI,2):FormulaR1C1)
               xsm_so = TRIM(bsheet:cells(intI,3):FormulaR1C1)
               xsm_serial = TRIM(bsheet:cells(intI,5):FormulaR1C1)
               xsm_part = TRIM(bsheet:cells(intI,6):FormulaR1C1)
               xsm_qty_used = decimal(TRIM(bsheet:cells(intI,9):FormulaR1C1))
               xsm_site = TRIM(bsheet:cells(intI,10):FormulaR1C1)
               xsm_loc = TRIM(bsheet:cells(intI,11):FormulaR1C1)
               xsm_ref = TRIM(bsheet:cells(intI,14):FormulaR1C1)
               no-error.
     end.
  END.
bbook:CLOSE().
bexcel:quit.
RELEASE OBJECT bsheet NO-ERROR.
RELEASE OBJECT bbook NO-ERROR.
RELEASE OBJECT bexcel NO-ERROR.
