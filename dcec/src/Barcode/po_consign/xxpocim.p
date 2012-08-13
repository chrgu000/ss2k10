  {mfdeclre.i}
  DEF VAR mtime AS INT.
  DEF VAR mdate AS DATE.
  FIND FIRST CODE_mstr WHERE CODE_fldname = 'log' AND CODE_value <> '' NO-LOCK NO-ERROR.
  IF AVAILABLE CODE_mstr THEN DO:
 
  OUTPUT TO VALUE(CODE_value).
    FOR EACH xxpo_consign USE-INDEX xxpo_cim WHERE xxpo_type = 'consume' AND NOT xxpo_cimed :
    FIND FIRST po_mstr WHERE po_nbr = xxpo_nbr AND po_stat = '' NO-LOCK NO-ERROR.
    IF AVAILABLE po_mstr THEN DO:
    FIND FIRST pod_det WHERE pod_nbr = po_nbr AND pod_line = xxpo_line AND pod_stat = '' NO-LOCK NO-ERROR.
    IF AVAILABLE pod_det THEN DO:
        IF pod_qty_rcvd < pod_qty_ord THEN DO:
      FIND FIRST gl_ctrl NO-LOCK NO-ERROR.
      OUTPUT TO value(mfguser).
                PUT UNFORMAT '"' xxpo_nbr '"' SKIP.
          PUT  "- - - Y N N " SKIP.
        IF  NOT po_fix_rate AND po_cur <> gl_base_curr THEN  PUT '- -' SKIP.
          PUT UNFORMAT string(xxpo_line) SKIP.
          PUT UNFORMAT string(xxpo_qty)  ' - - - - - - "' xxpo_loc '"' ' "' xxpo_lot '"'  SKIP.
         PUT '.' SKIP.
          PUT     SKIP (1)
              "." SKIP.
             OUTPUT CLOSE.
        batchrun = YES.   
        mtime = TIME.
          mdate = TODAY.
         INPUT FROM VALUE(mfguser).
          OUTPUT TO VALUE('out').
          {gprun.i ""poporc.p""}
              INPUT CLOSE.
          OUTPUT CLOSE.
          OS-DELETE VALUE(mfguser).
          OS-DELETE VALUE('out').
          FIND LAST tr_hist USE-INDEX tr_date_trn WHERE tr_date >= mdate AND tr_date <= TODAY AND tr_type = 'rct-po' AND tr_program = 'poporc.p' AND tr_nbr = xxpo_nbr AND tr_line = xxpo_line AND tr_serial = xxpo_lot AND tr_site = pod_site AND tr_loc = xxpo_loc  AND tr_qty_loc = xxpo_qty AND tr_userid = global_userid AND tr_time >= mtime AND tr_time <= TIME  NO-LOCK NO-ERROR.
           IF AVAILABLE tr_hist THEN xxpo_cimed = YES.
                  ELSE PUT UNFORMAT xxpo_vend ' ' xxpo_nbr ' ' string(xxpo_line) ' ' xxpo_part ' CIM失败！' SKIP.
        END.
         ELSE PUT UNFORMAT xxpo_vend ' ' xxpo_nbr ' ' string(xxpo_line) ' ' xxpo_part ' 已超收！' SKIP.
    END.
     ELSE PUT UNFORMAT xxpo_vend ' ' xxpo_nbr ' ' string(xxpo_line) ' ' xxpo_part ' 无效PO行，或已关闭，取消！' SKIP. 
    END.
    ELSE PUT UNFORMAT xxpo_vend ' ' xxpo_nbr ' 无效PO，或已关闭，取消！' SKIP.
   END.
   OUTPUT CLOSE.
  END.
