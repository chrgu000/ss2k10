/*V8:ConvertMode=Report                                                       */

{mfdeclre.i}
{yyssld.i}

define variable intI as integer.
define variable rng  as character.
define variable excelAppl as com-handle.
define variable xworkbook as com-handle.
define variable xworksheet as com-handle.

empty temp-table xss_mstr no-error.

  CREATE "Excel.Application" excelAppl.

   xworkbook = excelAppl:Workbooks:OPEN(fn,,true).
   xworksheet = excelAppl:sheets:item(1).
   xworksheet:cells:NumberFormatLocal = "General" no-error.
   DO intI = 2 TO xworksheet:UsedRange:Rows:Count:
       if trim(xworksheet:cells(intI,1):FormulaR1C1) > "0" and
          trim(xworksheet:cells(intI,1):FormulaR1C1) <= "ZZZZZZZZZZZZZZZZZZ" and
          trim(xworksheet:cells(intI,1):FormulaR1C1) <> ? then do:
       CREATE xss_mstr. 
       ASSIGN xss_part    = xworksheet:cells(intI,1):FormulaR1C1 NO-ERROR.
       ASSIGN xss_site    = xworksheet:cells(intI,2):FormulaR1C1 NO-ERROR.
       ASSIGN xss_sfty_stkn = decimal(xworksheet:cells(intI,3):FormulaR1C1) NO-ERROR.
      end.
   END.

   excelAppl:quit.
   release object excelAppl.
   RELEASE OBJECT xworkbook.
   RELEASE OBJECT xworksheet.
 assign intI = 1.
 for each xss_mstr exclusive-lock:
     assign xss_sn = intI.
     assign intI = intI + 1.
     find first pt_mstr no-lock where pt_domain = global_domain and pt_part = xss_part no-error.
     if available pt_mstr then do:
     	  assign xss_desc = pt_desc1.
     end.
     else do:
        assign xss_chk = "料号:" + xss_part + " 不存在".
        next.
     end.
     find first si_mstr no-lock where si_domain = global_domain and si_site = xss_site no-error.
     if not available si_mstr then do:
        assign xss_chk = "地点" + xss_site + "不存在".
        next.
     end.
     find first ptp_det no-lock where ptp_domain = global_domain and
                ptp_part = xss_part and ptp_site = xss_site no-error.
     if available ptp_det then do:
        assign xss_sfty_stk = ptp_sfty_stk.
     end.
     else do:
        assign xss_chk = "料号" + xss_part + " 地点" + xss_site + " 资料不存在".
        next.
     end.
     find first in_mstr no-lock where in_domain = global_domain
            and in_part = xss_part and in_site = xss_site no-error.
     if available in_mstr then do:
        assign xss_abc = in_abc
               xss_qty_loc = in_qty_oh.
     end.
     find first usrw_wkfl no-lock where usrw_domain = global_domain 
     				and usrw_key1 = v_key no-error.
     if available usrw_wkfl then do:
     		if xss_abc = "A" then do:
     			 assign xss_k = usrw_decfld[1].
     	  end.
     	  else if xss_abc = "B" then do:
     	  		assign xss_k = usrw_decfld[2].
     	  end.
     	  else do:
     	  		assign xss_k = usrw_decfld[3].
     	  end.
     	  if usrw_decfld[4] = 0 then assign xss_tat = 1.
     	  	 else assign xss_tat = usrw_decfld[4].
     end.
 end.
