/*V8:ConvertMode=Report                                                       */

DEFINE {1} SHARED VARIABLE file_name AS CHARACTER FORMAT "x(50)".
DEFINE {1} SHARED VARIABLE v_qty_oh LIKE IN_qty_oh.
DEFINE {1} SHARED VARIABLE fn_i AS CHARACTER.
DEFINE {1} SHARED VARIABLE v_tr_trnbr LIKE tr_trnbr.
DEFINE {1} SHARED VARIABLE v_flag AS CHARACTER.

DEFINE {1} SHARED TEMP-TABLE xxmps
   FIELD xxmps_dept AS CHARACTER LABEL "部门"
   FIELD xxmps_cx   AS CHARACTER LABEL "车型样式"
   FIELD xxmps_line AS CHARACTER LABEL "生产线"
   FIELD xxmps_seq  AS INTEGER LABEL "序号"
   FIELD xxmps_bc   AS CHARACTER LABEL "班次"
   FIELD xxmps_date AS DATE
   FIELD xxmps_qty  AS DECIMAL LABEL "数量"
   FIELD xxmps_part LIKE pt_part
   FIELD xxmps_error AS CHARACTER FORMAT "x(20)" LABEL "提示"
   INDEX index1 xxmps_dept xxmps_date xxmps_seq .
