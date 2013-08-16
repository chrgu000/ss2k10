/*V8:ConvertMode=Report                                                       */

{xxschimp.i}

define variable intI as integer.
define variable intJ as integer.
define variable excelAppl as com-handle.
define variable xworkbook as com-handle.
define variable xworksheet as com-handle.
define variable fn as character.

empty temp-table xsch_data no-error.

  assign fn = file_name.
  CREATE "Excel.Application" excelAppl.

   xworkbook = excelAppl:Workbooks:OPEN(fn,,true).
   xworksheet = excelAppl:sheets:item(1).

   assign v_rlse_id = trim(string(xworksheet:cells(1,5):FormulaR1C1)).
   DO intI = 5 TO xworksheet:UsedRange:Rows:Count:
      intJ = 8.
      if v_rlse_id = "" then leave.
         test:
         do while xworksheet:cells(3,intJ):FormulaR1C1 <> "":
            if trim(xworksheet:cells(inti,intJ):FormulaR1C1) <> ? then do:
            CREATE xsch_data.
            ASSIGN xsd_nbr = string(xworksheet:cells(intI,1):FormulaR1C1)
                   xsd_line = xworksheet:cells(intI,2):FormulaR1C1
                   xsd_part = string(xworksheet:cells(intI,3):FormulaR1C1)
                   xsd_pcr_qty = xworksheet:cells(intI,4):FormulaR1C1
                   xsd_pcs_date = xworksheet:cells(intI,5):FormulaR1C1
                   xsd__dec01 = xworksheet:cells(intI,6):FormulaR1C1
                   xsd__dec02 = xworksheet:cells(intI,7):FormulaR1C1
                   xsd_fc_qual = xworksheet:cells(2,intJ):FormulaR1C1
                   xsd_date = xworksheet:cells(3,intJ):FormulaR1C1
                   xsd_time = string(xworksheet:cells(4,intJ):FormulaR1C1)
                   xsd_upd_qty = xworksheet:cells(inti,intJ):FormulaR1C1
                   .
            end.
            if trim(xworksheet:cells(2,intJ):FormulaR1C1) = ? then leave test.
            intj = intj + 1.
            if intJ > 256 then leave test.
         end.
   END.

   excelAppl:quit.
   release OBJECT xworksheet.
   release OBJECT xworkbook.
   release object excelAppl.
