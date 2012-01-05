/*V8:ConvertMode=Report                                                       */

{xxfcsimp.i}

define variable intI as integer.
define variable intJ as integer.
define variable excelAppl as com-handle.
define variable xworkbook as com-handle.
define variable xworksheet as com-handle.
define variable fn as character.

empty temp-table xfcs_det no-error.

  assign fn = file_name.
  CREATE "Excel.Application" excelAppl.

   xworkbook = excelAppl:Workbooks:OPEN(fn,,true).
   xworksheet = excelAppl:sheets:item(1).

   DO intI = 4 TO xworksheet:UsedRange:Rows:Count:
      /*
      MESSAGE v_i VIEW-AS ALERT-BOX.
      MESSAGE xworksheet:cells(v_i,1):VALUE VIEW-AS ALERT-BOX.
      */

     IF xworksheet:cells(intI,1):VALUE <> ? THEN DO:
         CREATE xfcs_det.
         ASSIGN xfd_part = string(xworksheet:cells(intI,1):VALUE)
                xfd_site = xworksheet:cells(intI,2):VALUE
                xfd_year = xworksheet:cells(intI,3):VALUE.
         do intJ = 1 to 52:
              if xworksheet:cells(intI,3 + intJ):VALUE = "" then do:
                 xfd_fcs_qty[intJ] = ?.
              end.
              else do:
                xfd_fcs_qty[intJ] = xworksheet:cells(intI,3 + intJ):VALUE.
              end.
         end.
      END.
      ELSE DO:
         LEAVE.
      END.

   END.

   excelAppl:quit.
   release object excelAppl.
   RELEASE OBJECT xworkbook.
   RELEASE OBJECT xworksheet.