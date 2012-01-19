/* SS - 111020.1 BY KEN */
/******************************************************************************/
/* SCHEDULE MAINTENANCE DETAIL SUBPROGRAM */
/* DISPLAYS/MAINTAINS CUSTOMER LAST RECEIPT INFO */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */



DEFINE SHARED VARIABLE file_name AS CHARACTER FORMAT "x(50)".
DEFINE SHARED VARIABLE v_qty_oh LIKE IN_qty_oh.
DEFINE SHARED VARIABLE fn_i AS CHARACTER.
DEFINE SHARED VARIABLE v_tr_trnbr LIKE tr_trnbr.
DEFINE SHARED VARIABLE v_flag AS CHARACTER.

DEFINE VARIABLE xpath AS CHARACTER.
DEFINE VARIABLE v_i AS INTEGER.
DEFINE VARIABLE v_j AS INTEGER.

DEFINE VARIABLE v_sum_part_qty AS DECIMAL.


DEFINE SHARED TEMP-TABLE xxpod_det
   FIELD xxpod_nbr LIKE po_nbr
   FIELD xxpod_line LIKE pod_line
   FIELD xxpod_due_date LIKE pod_due_date
   FIELD xxpod_per_date LIKE pod_per_date
   FIELD xxpod_need LIKE pod_need
   FIELD xxpod_status LIKE pod_status
   FIELD xxpod_error AS CHARACTER FORMAT "x(48)"
   INDEX index1 xxpod_nbr xxpod_line.


DEFINE TEMP-TABLE tt1 
    FIELD tt1_field1 AS CHARACTER.

   /*检查数据&cimload*/
   FOR EACH xxpod_det:
       DELETE xxpod_det.
   END.

   FOR EACH tt1:
       DELETE tt1.
   END.

   v_flag = "1".

   xpath = FILE_name.


   INPUT FROM VALUE(file_name) .
   REPEAT:
      CREATE tt1 .
      IMPORT UNFORMATTED tt1.
   END.
   INPUT CLOSE.

   v_i = 0.
   FOR EACH tt1 WHERE tt1_field1 <> "":
       v_i = v_i + 1.
       IF v_i > 1 THEN DO:
          CREATE xxpod_det.
          ASSIGN xxpod_nbr = ENTRY(1,tt1_field1)
                 xxpod_status = trim(ENTRY(6,tt1_field1)).

          ASSIGN xxpod_line = INTEGER(trim(ENTRY(2,tt1_field1))) NO-ERROR.
          IF ERROR-STATUS:ERROR THEN DO:
             ASSIGN xxpod_error = "PO Line Format is error".
          END.                 
          
          IF ENTRY(3,tt1_field1) <> "" THEN
              ASSIGN xxpod_due_date = DATE(ENTRY(3,tt1_field1)) NO-ERROR.
              IF ERROR-STATUS:ERROR THEN DO:
                 ASSIGN xxpod_error = "PO Line Due Date Format is error".
              END.                 

          IF ENTRY(4,tt1_field1) <> "" THEN
              ASSIGN xxpod_per_date = DATE(ENTRY(4,tt1_field1)) NO-ERROR.
              IF ERROR-STATUS:ERROR THEN DO:
                 ASSIGN xxpod_error = "PO Line Performance Date Format is error".
              END.

          IF ENTRY(5,tt1_field1) <> "" THEN
              ASSIGN xxpod_need = DATE(ENTRY(5,tt1_field1)) NO-ERROR.
              IF ERROR-STATUS:ERROR THEN DO:
                 ASSIGN xxpod_error = "PO Line Need Date Format is error".
              END.

          IF xxpod_status <> "C" AND xxpod_status <> "" THEN DO:
             ASSIGN xxpod_error = "PO Line status Format is error".
          END.

          FIND FIRST pod_det WHERE pod_domain = GLOBAL_domain AND pod_nbr = xxpod_nbr AND pod_line = xxpod_line NO-LOCK NO-ERROR.
          IF NOT AVAIL pod_det THEN DO:
             ASSIGN xxpod_error = "PO Line not available".
          END.
       END.
   END.

   FIND FIRST xxpod_det  NO-ERROR.
   IF NOT AVAIL xxpod_det THEN DO:
      DISP  "无数据,请重新输入" .
      v_flag = "1".
   END.
   ELSE DO:
     
      FIND FIRST xxpod_det WHERE xxpod_error <> "" NO-LOCK NO-ERROR.
      IF AVAIL xxpod_det THEN DO:
         v_flag = "2".
      END.
      ELSE DO:
              do transaction on error undo, retry:
                  /*cimload */
                  {gprun.i ""xxpopoim02.p""}
                  v_flag = "3".
              END.
      END.
   END.

