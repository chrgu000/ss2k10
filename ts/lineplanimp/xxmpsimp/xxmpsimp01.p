/* SS - 111020.1 BY KEN */
/*V8:ConvertMode=Report                                                       */
{xxmpsimp.i}
{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

DEFINE VARIABLE excelAppl AS COM-HANDLE.
define variable xworkbook as com-handle.
define variable xworksheet as com-handle.
DEFINE VARIABLE v_i AS INTEGER.
DEFINE VARIABLE v_j AS INTEGER.

   /*检查数据&cimload*/
   FOR EACH xxmps:
       DELETE xxmps.
   END.

   v_flag = "".

   CREATE "Excel.Application" excelAppl.
   xworkbook = excelAppl:Workbooks:OPEN(FILE_name,,true).
   xworksheet = excelAppl:sheets:item(1).
   DO v_i = 2 TO xworksheet:UsedRange:Rows:Count:
      /*
      MESSAGE v_i VIEW-AS ALERT-BOX.
      MESSAGE xworksheet:cells(v_i,1):VALUE VIEW-AS ALERT-BOX.
      */

      IF xworksheet:cells(v_i,1):VALUE <> ? THEN DO:
         CREATE xxmps.
         ASSIGN xxmps_dept = string(xworksheet:cells(v_i,1):VALUE)
                xxmps_cx = string(xworksheet:cells(v_i,2):VALUE)
                xxmps_line = string(xworksheet:cells(v_i,3):VALUE)
                xxmps_seq = xworksheet:cells(v_i,4):VALUE
                xxmps_bc = string(xworksheet:cells(v_i,5):VALUE)
                xxmps_date = xworksheet:cells(v_i,6):VALUE
                xxmps_qty = xworksheet:cells(v_i,7):VALUE
             .
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
      MESSAGE "无数据,请重新输入" VIEW-AS ALERT-BOX.
      v_flag = "1".
      /*
      PUT  "无数据,请重新输".
      */

   END.
   ELSE DO:

      v_i  = 0.
      FOR EACH xxmps BREAK BY xxmps_cx BY xxmps_line BY xxmps_date BY xxmps_seq:


          v_i = v_i + 1.


          IF LAST-OF(xxmps_seq) THEN DO:

             IF v_i > 1 THEN DO:
                xxmps_error = "序号重复".
             END.
             v_i = 0.
          END.


          FIND FIRST usrw_wkfl WHERE usrw_domain = GLOBAL_domain
             AND usrw_key1 = "SSGZTS-CX"
             AND usrw_key3 = xxmps_dept
             AND usrw_key4 = xxmps_cx
             NO-LOCK NO-ERROR.
          IF NOT AVAIL usrw_wkfl THEN DO:
             xxmps_error = "车型对应ERP号没维护".
          END.
        else do:
           xxmps_part = usrw_key5.
        end.

          FIND FIRST lnd_det WHERE lnd_domain = global_domain
                 and lnd_line = xxmps_line AND lnd_part = xxmps_part
                      NO-LOCK NO-ERROR.
          IF NOT AVAIL lnd_det THEN DO:
             xxmps_error = "零件生产线没维护".
          END.
      END.


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
          
          {gprun.i ""xxmpsimp02.p""}
          
          v_flag = "3".
      END.
   END.

