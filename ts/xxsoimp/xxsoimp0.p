/*V8:ConvertMode=Report                                                       */

{mfdeclre.i}
{xxsoimp.i}

define variable intI as integer.
define variable intJ as integer.
define variable excelAppl as com-handle.
define variable xworkbook as com-handle.
define variable xworksheet as com-handle.
define variable fn as character.

empty temp-table tmp-so no-error.
for each tmp-so exclusive-lock: delete tmp-so. end.
  assign fn = file_name.
  CREATE "Excel.Application" excelAppl.

   xworkbook = excelAppl:Workbooks:OPEN(fn,,true).
   xworksheet = excelAppl:sheets:item(1).

   DO intI = 2 TO xworksheet:UsedRange:Rows:Count:
       if trim(xworksheet:cells(intI,1):VALUE) <> "" then do:
       CREATE tmp-so.
       ASSIGN  tso_nbr = string(xworksheet:cells(intI,1):VALUE)
               tso_cust = string(xworksheet:cells(intI,2):VALUE)
               tso_bill = string(xworksheet:cells(intI,3):VALUE)
               tso_ship = string(xworksheet:cells(intI,4):VALUE)
               tso_req_date = xworksheet:cells(intI,5):VALUE
               tso_due_date = xworksheet:cells(intI,6):VALUE
               tso_rmks = string(xworksheet:cells(intI,7):VALUE)
               tso_site = string(xworksheet:cells(intI,8):VALUE)
               tso_curr = string(xworksheet:cells(intI,9):VALUE)
               tsod_line = xworksheet:cells(intI,10):VALUE
               tsod_part = string(xworksheet:cells(intI,11):VALUE)
               tsod_site = string(xworksheet:cells(intI,12):VALUE)
               tsod_qty_ord = xworksheet:cells(intI,13):VALUE
               tsod_loc = string(xworksheet:cells(intI,14):VALUE)
               tsod_acct = string(xworksheet:cells(intI,15):VALUE)
               tsod_sub = string(xworksheet:cells(intI,16):VALUE)
               tsod_due_date = xworksheet:cells(intI,17):VALUE
               tsod_rmks1 = string(xworksheet:cells(intI,18):VALUE).
      end.
      else do:
          next.
      end.
   END.

   excelAppl:quit.
   release object excelAppl.
   RELEASE OBJECT xworkbook.
   RELEASE OBJECT xworksheet.


FOR EACH TMP-SO EXCLUSIVE-LOCK :
    IF  TSO_NBR = '' OR tso_nbr = ? THEN DO:
        DELETE TMP-SO.
    END.
    ELSE DO:
         IF tso_curr = ? THEN DO:
             FIND FIRST cm_mstr NO-LOCK WHERE cm_addr = tso_cust NO-ERROR.
             IF AVAILABLE cm_mstr THEN DO:
                 ASSIGN tso_curr = cm_curr.
             END.
             ELSE DO:
                   for first en_mstr
                     fields( en_domain en_curr en_entity en_name)
                      where en_mstr.en_domain = global_domain
                        and en_entity = current_entity
                     no-lock:
                   END.
                   IF AVAILABLE en_mstr THEN DO:
                       ASSIGN tso_curr = en_curr.
                   END.
             END.
         END.
         IF tso_rmks = ? THEN ASSIGN tso_rmks = "-".

         IF tsod_acct = ? THEN do:
           ASSIGN tsod_acct = "-".
         END.
         IF index(tsod_acct,".") > 0 THEN DO:
             ASSIGN tsod_acct = substring(tsod_acct,1,index(tsod_acct,".") - 1).
         END.

         IF tsod_sub = ? THEN ASSIGN tsod_sub = "-".
         IF tsod_rmks1 = ? THEN ASSIGN tsod_rmks1 = "-".
         IF tsod_loc = ? THEN ASSIGN tsod_loc = "-".
         if tsod_site = ? and tso_site <> ? then assign tsod_site = tso_site.
    END.
END.

/* Check user data*/
for each tmp-so exclusive-lock:
    assign tsod_chk = "".
    if not can-find(pt_mstr no-lock where pt_domain = global_domain and
                    pt_part = tsod_part) then do:
       assign tsod_chk = "Item number " + tsod_part + " does not exist".
    end.
    find first sod_det no-lock where sod_domain = global_domain
           and sod_nbr = tso_nbr and sod_line = tsod_line no-error.
    if available sod_det then do:
       assign tsod_chk = "订单" + tso_nbr + "项次" + trim(string(tsod_line)) + "已存在".
    end.
end.
