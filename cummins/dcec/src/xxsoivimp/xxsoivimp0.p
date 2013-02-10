/*V8:ConvertMode=Report                                                       */

{mfdeclre.i}
{xxsoivimp.i}

define variable intI as integer.
define variable intJ as integer.
define variable excelAppl as com-handle.
define variable xworkbook as com-handle.
define variable xworksheet as com-handle.
define variable fn as character.

empty temp-table tmp-so no-error.

  assign fn = file_name.
  CREATE "Excel.Application" excelAppl.

   xworkbook = excelAppl:Workbooks:OPEN(fn,,true).
   xworksheet = excelAppl:sheets:item(1).

   DO intI = 2 TO xworksheet:UsedRange:Rows:Count:
       if trim(xworksheet:cells(intI,1):FormulaR1C1) <> "" then do:
       CREATE tmp-so.
       ASSIGN  tso_nbr = string(xworksheet:cells(intI,1):FormulaR1C1)
               tso_cust = string(xworksheet:cells(intI,2):FormulaR1C1)
               tso_bill = string(xworksheet:cells(intI,3):FormulaR1C1)
               tso_ship = string(xworksheet:cells(intI,4):FormulaR1C1)
               tso_ord_date = xworksheet:cells(intI,5):FormulaR1C1
               tso_rmks = xworksheet:cells(intI,6):FormulaR1C1
               tso_site = string(xworksheet:cells(intI,7):FormulaR1C1)
               tso_channel = string(xworksheet:cells(intI,8):FormulaR1C1)
               tso_tax_usage = string(xworksheet:cells(intI,9):FormulaR1C1)
               tsod_line = xworksheet:cells(intI,10):FormulaR1C1
               tsod_part = string(xworksheet:cells(intI,11):FormulaR1C1)
               tsod_site = string(xworksheet:cells(intI,12):FormulaR1C1)
               tsod_qty_ord = xworksheet:cells(intI,13):FormulaR1C1
               tsod_acct = string(xworksheet:cells(intI,14):FormulaR1C1)
               tsod_sub = string(xworksheet:cells(intI,15):FormulaR1C1)
               tsod_cc = string(xworksheet:cells(intI,16):FormulaR1C1)
               tsod_project = string(xworksheet:cells(intI,17):FormulaR1C1).
      end.
      else do:
          next.
      end.
   END.

   excelAppl:quit.
   release object excelAppl.
   RELEASE OBJECT xworkbook.
   RELEASE OBJECT xworksheet.
