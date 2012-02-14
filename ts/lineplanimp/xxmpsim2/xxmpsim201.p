/* SS - 111020.1 BY KEN */
/*V8:ConvertMode=Report                                                       */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{xxmpsim2.i}

DEFINE VARIABLE excelAppl AS COM-HANDLE.
define variable xworkbook as com-handle.
define variable xworksheet as com-handle.
DEFINE VARIABLE xpath AS CHARACTER.
DEFINE VARIABLE v_i AS INTEGER.
DEFINE VARIABLE v_j AS INTEGER.

DEFINE NEW SHARED VARIABLE v_date AS DATE EXTENT 32.
DEFINE NEW SHARED VARIABLE v_qty AS DECIMAL EXTENT 32.
DEFINE NEW SHARED VARIABLE v_dept AS CHARACTER.


   /*检查数据&cimload*/
   empty temp-table xxmps no-error.

   v_flag = "".

   xpath = FILE_name.
   CREATE "Excel.Application" excelAppl.

   xworkbook = excelAppl:Workbooks:OPEN(xpath,,true).
   xworksheet = excelAppl:sheets:item(1).

   v_dept = xworksheet:cells(1,1):VALUE.

   DO v_j = 3 TO xworksheet:UsedRange:Columns:count:
       v_date[v_j - 2] = xworksheet:cells(1,v_j):VALUE .
   END.

   DO v_i = 3 TO xworksheet:UsedRange:Rows:Count:
      /*
      MESSAGE v_i VIEW-AS ALERT-BOX.
      MESSAGE xworksheet:cells(v_i,1):VALUE VIEW-AS ALERT-BOX.
      */

      IF xworksheet:cells(v_i,1):VALUE <> ? THEN DO:
           DO v_j = 3 TO xworksheet:UsedRange:Columns:count:
               IF xworksheet:cells(v_i,v_j):VALUE <> ? THEN DO:
                   CREATE xxmps.
                   ASSIGN xxmps_dept = trim(v_dept)
                          xxmps_cx = trim(string(xworksheet:cells(v_i,1):VALUE))
                          xxmps_seq = 1
                          xxmps_bc = ""
                          xxmps_date = v_date[v_j - 2]
                          xxmps_qty = xworksheet:cells(v_i,v_j):VALUE
                       .
               END.
           END.
      END.
      ELSE DO:
         LEAVE.
      END.

   END.

   excelAppl:quit.
   release object excelAppl.
   RELEASE OBJECT xworkbook.
   RELEASE OBJECT xworksheet.


   FIND FIRST xxmps  NO-ERROR.
   IF NOT AVAIL xxmps THEN DO:
      {mfmsg.i  1310 3}
      v_flag = "1".
      /*
      PUT  "无数据,请重新输".
      */

   END.
output to xxxse.txt.
   for each xxmps exclusive-lock:
   export xxmps_dept xxmps_cx.
       if not can-find (first usrw_wkfl no-lock where
           usrw_wkfl.usrw_domain = global_domain and
           usrw_wkfl.usrw_key1 = key1 and
           usrw_wkfl.usrw_key3 = xxmps_dept and
           usrw_wkfl.usrw_key4 = xxmps_cx) THEN DO:
           ASSIGN xxmps_error = "车型错误".
        END.
        else do:
             ASSIGN xxmps_error = "".
        end.
   end.
output close.
   FIND FIRST xxmps WHERE xxmps_error <> "" NO-LOCK NO-ERROR.
   IF AVAIL xxmps THEN DO:
      v_flag = "2".
      /*
      FOR EACH xxso WHERE xxso_error <> "" NO-LOCK:
          DISP xxso WITH WIDTH 200 STREAM-IO.
      END.
      */
   END.
   ELSE DO:
       /*cimload */
     {gprun.i ""xxmpsim202.p""}
       v_flag = "3".
   END.
