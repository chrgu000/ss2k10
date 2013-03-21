/*V8:ConvertMode=Report                                                       */

{mfdeclre.i}
{yyldicunrc.i}

define variable intI as integer.
define variable vdte as character.
define variable excelAppl as com-handle.
define variable xworkbook as com-handle.
define variable xworksheet as com-handle.

empty temp-table xim no-error.

  CREATE "Excel.Application" excelAppl.

   xworkbook = excelAppl:Workbooks:OPEN(fn,,true).
   xworksheet = excelAppl:sheets:item(1).

   DO intI = 2 TO xworksheet:UsedRange:Rows:Count:
       if trim(xworksheet:cells(intI,1):FormulaR1C1) > "0" and
          trim(xworksheet:cells(intI,1):FormulaR1C1) <= "ZZZZZZZZZZZZZZZZZ" and
          trim(xworksheet:cells(intI,1):FormulaR1C1) <> ? then do:
       assign vdte = string(xworksheet:cells(intI,7):FormulaR1C1).
       CREATE xim.
       ASSIGN xim_part    = string(xworksheet:cells(intI,1):FormulaR1C1) NO-ERROR.
       ASSIGN xim_qty     = decimal(xworksheet:cells(intI,2):FormulaR1C1) NO-ERROR.
       ASSIGN xim_site    = string(xworksheet:cells(intI,3):FormulaR1C1) NO-ERROR.
       ASSIGN xim_sojob    = string(xworksheet:cells(intI,4):FormulaR1C1) NO-ERROR.
       if string(xworksheet:cells(intI,8):FormulaR1C1) <> ? then
       ASSIGN xim_lot     = string(xworksheet:cells(intI,8):FormulaR1C1) NO-ERROR.
       ASSIGN xim_nbr     = string(xworksheet:cells(intI,5):FormulaR1C1) NO-ERROR.
       if string(xworksheet:cells(intI,6):FormulaR1C1) <> ? then
       ASSIGN xim_rmks    = string(xworksheet:cells(intI,6):FormulaR1C1) NO-ERROR.
       ASSIGN xim_effdate = date(int(substring(vdte,4,2)),
                                  int(substring(vdte,1,2)),
                                  2000 + int(substring(vdte,7,2))
                                  ) no-error.
      end.
      else do:
          next.
      end.
   END.

   excelAppl:quit.
   release object excelAppl.
   RELEASE OBJECT xworkbook.
   RELEASE OBJECT xworksheet.
 assign intI = 1.
 for each xim exclusive-lock:
     assign xim_sn = intI.
     assign intI = intI + 1.
     find first pt_mstr no-lock where pt_domain = global_domain and pt_part = xim_part no-error.
     if not available pt_mstr then do:
        assign xim_chk = "料号:" + xim_part + " 不存在".
        next.
     end.
     find first si_mstr no-lock where si_domain = global_domain and si_site = xim_site no-error.
     if not available si_mstr then do:
        assign xim_chk = "地点" + xim_site + "不存在".
        next.
     end.
     find first in_mstr no-lock where in_domain = global_domain and
                in_part = xim_part and in_site = xim_site no-error.
     if available in_mstr then do:
        assign xim_loc = in_loc.
     end.
     else do:
        find pt_mstr no-lock where pt_domain = global_domain and
             pt_site = xim_site no-error.
        if available pt_mstr then do:
           assign xim_loc = pt_loc.
        end.
        else do:
          assign xim_chk = "料号地点数据未维护!".
          next.
        end.
     end.
 end.
