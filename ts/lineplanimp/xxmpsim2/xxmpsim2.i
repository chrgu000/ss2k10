/*V8:ConvertMode=Report                                                       */

DEFINE {1} SHARED VARIABLE file_name AS CHARACTER FORMAT "x(50)".
DEFINE {1} SHARED VARIABLE v_qty_oh LIKE IN_qty_oh.
DEFINE {1} SHARED VARIABLE fn_i AS CHARACTER.
DEFINE {1} SHARED VARIABLE v_tr_trnbr LIKE tr_trnbr.
DEFINE {1} SHARED VARIABLE v_flag AS CHARACTER.
define {1} SHARED variable key1 as character initial "SSGZTS-CX" no-undo. 

DEFINE {1} SHARED TEMP-TABLE xxmps
   FIELD xxmps_dept AS CHARACTER LABEL "departmennt"
   FIELD xxmps_cx AS CHARACTER LABEL "model"
   FIELD xxmps_line AS CHARACTER LABEL "Line"
   FIELD xxmps_seq AS INTEGER LABEL "sn"
   FIELD xxmps_bc AS CHARACTER LABEL "shift"
   FIELD xxmps_date AS DATE
   FIELD xxmps_qty AS DECIMAL LABEL "qty"
   FIELD xxmps_part LIKE pt_part
   FIELD xxmps_error AS CHARACTER FORMAT "x(40)" LABEL "msg"
   INDEX index1 xxmps_dept xxmps_seq.
