DEF VAR umconv AS DECIMAL.
DEF VAR mqty AS DECIMAL.
DEF VAR lstop AS INT.
DEF VAR sumid AS CHAR.
DEFINE TEMP-TABLE t_tr_hist
    field t_tr_part like tr_part
    field t_tr_effdate like tr_effdate
    field t_tr_site like tr_site
    field t_tr_loc like tr_loc
    FIELD t_tr_lot LIKE tr_lot
    field t_tr_serial like tr_serial
    field t_tr_qty_loc like tr_qty_loc
    field t_tr_type like tr_type
    field t_tr_nbr like tr_nbr
    field t_tr_line like tr_line
    field t_tr_um like tr_um
    field t_tr_userid like tr_userid
    field t_tr_time like tr_time
    field t_tr_addr like tr_addr
    field t_tr_trnbr like tr_trnbr
    FIELD t_tr_site1 LIKE tr_site
    FIELD t_tr_loc1 LIKE tr_loc
    FIELD t_tr_sess AS CHAR.
FOR EACH b_tr_hist USE-INDEX b_tr_sum WHERE b_tr_sum_id = "" AND b_tr_trnbr_qad = 0 AND b_tr_part = '0001' AND b_tr_type <> 'rct-tr':
    CREATE t_tr_hist.
     t_tr_part = b_tr_part.
     t_tr_effdate = b_tr_effdate.
     t_tr_site = b_tr_site.
     t_tr_loc = b_tr_loc.
     t_tr_lot = b_tr_lot.
     t_tr_serial = b_tr_serial.
     t_tr_qty_loc = b_tr_qty_loc.
     t_tr_type = b_tr_type.
     t_tr_nbr = b_tr_nbr.
     t_tr_line = b_tr_line.
     t_tr_um = b_tr_um.
     t_tr_userid = b_tr_userid.
     t_tr_time = b_tr_time.
     t_tr_addr = b_tr_addr.
     t_tr_trnbr = b_tr_trnbr.
     t_tr_sess = "aaaa".
     t_tr_site1 = b_tr_site1.
     t_tr_loc1 = b_tr_loc1.
END.
/*
sumid = STRING(TODAY) + STRING(TIME) + STRING(ETIME).
FOR EACH t_tr_hist WHERE t_tr_type = "RCT-PO" AND index(t_tr_userid,'*>?/<') = 0 BREAK BY month(t_tr_effdate) BY t_tr_nbr BY t_tr_line BY t_tr_site BY t_tr_loc BY t_tr_part :
    ACCUMULATE t_tr_qty_loc (TOTAL BY t_tr_part).
    FIND FIRST b_tr_hist WHERE b_tr_trnbr = t_tr_trnbr EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE b_tr_hist THEN b_tr_sum_id = sumid.
    IF LAST-OF(t_tr_part) THEN DO:
       IF t_tr_type = "RCT-PO" THEN DO:
           OUTPUT TO RCTPO1.
           FIND FIRST pt_mstr WHERE pt_part = t_tr_part NO-LOCK NO-ERROR.
           PUT "@@batchload poporc.p" SKIP.
         PUT UNFORMAT '"' t_tr_nbr '"' SKIP.
          PUT  "- - -  Y N N " SKIP.
          PUT UNFORMAT string(t_tr_line) SKIP.
          PUT UNFORMAT string(ACCUMULATE TOTAL BY t_tr_part t_tr_qty_loc)  ' - - ' pt_um ' - - "' t_tr_site '" "' t_tr_loc '"' SKIP.
        
          PUT     SKIP (3)
              "." SKIP
              "@@END" SKIP.
          OUTPUT CLOSE.
          RUN bcmgbdpro.p(INPUT 'rctpo1',INPUT 'cim').
          FIND LAST tr_hist WHERE tr_date = TODAY AND tr_type = 'rct-po' AND tr_program = 'popoprc.p' AND tr_nbr = t_tr_nbr AND tr_line = t_tr_line AND tr_userid = 'mfg' NO-LOCK NO-ERROR.
          IF AVAILABLE tr_hist THEN DO:
              FIND FIRST b_tr_hist WHERE b_tr_trnbr_qad = tr_trnbr NO-LOCK NO-ERROR.
              IF NOT AVAILABLE b_tr_hist THEN 
                  FOR EACH b_tr_hist WHERE b_tr_sum_id = sumid EXCLUSIVE-LOCK:
                      ASSIGN
                          b_tr_trnbr_qad = tr_trnbr.
                  END.
                  ELSE DO:
                      OUTPUT TO c:\cim_log.txt APPEND.
                      PUT UNFORMAT STRING(TODAY) ' ' t_tr_type ' ' t_tr_nbr ' '  STRING(t_tr_line) ' ' t_tr_part ' CIM导入失效!' SKIP.
                      OUTPUT CLOSE.
                  END.
              END.
              ELSE DO:
                  OUTPUT TO c:\cim_log.txt APPEND.
                      PUT UNFORMAT STRING(TODAY) ' ' t_tr_type ' ' t_tr_nbr ' '  STRING(t_tr_line) ' ' t_tr_part ' CIM导入失效!' SKIP.
                      OUTPUT CLOSE.
              END.
            sumid = STRING(TODAY) + STRING(TIME) + STRING(ETIME).
          END.


       END.
    END.
*/

mqty = 0.
    sumid = substr(string(YEAR(TODAY)),3,2) + string(MONTH(TODAY)) + STRING(DAY(TODAY)) + STRING(TIME) + STRING(ETIME).
    
    FOR EACH t_tr_hist WHERE t_tr_type = "ISS-TR" BREAK BY month(t_tr_effdate)  BY t_tr_site BY t_tr_loc BY t_tr_site1 BY t_tr_loc1 BY t_tr_part:
        mqty = mqty + t_tr_qty_loc.

   
    FIND FIRST b_tr_hist WHERE b_tr_trnbr = t_tr_trnbr EXCLUSIVE-LOCK NO-ERROR.
   IF AVAILABLE b_tr_hist THEN b_tr_sum_id = sumid.
    IF LAST-OF(t_tr_part) THEN DO:
       IF t_tr_type = "ISS-TR" THEN DO:
           OUTPUT TO RCTPO1.
           put  "@@BATCHLOAD iclotr02.P" skip.
            PUT UNFORMAT '"' t_tr_part '"' SKIP.
            PUT UNFORMAT STRING(mqty * -1)  skip.
            PUT UNFORMAT '"' + t_tr_site + '" "' + t_tr_loc + '"'  SKIP.
            PUT UNFORMAT '"' t_tr_site1 '" "' t_tr_loc1 '"' SKIP.
          PUT      " " skip
                     "." SKIP
                     "@@END" SKIP.
          OUTPUT CLOSE.
          RUN bcmgbdpro.p(INPUT 'rctpo1',INPUT 'cim').
          FIND LAST tr_hist WHERE tr_date = TODAY AND tr_type = 'iss-tr' AND tr_program = 'iclotr02.p' AND tr_site = t_tr_site AND tr_loc = t_tr_loc  AND tr_part = t_tr_part AND tr_userid = 'mfg' NO-LOCK NO-ERROR.
          
          IF AVAILABLE tr_hist THEN DO:
              FIND LAST b_tr_hist WHERE b_tr_trnbr_qad = tr_trnbr NO-LOCK NO-ERROR.
              IF NOT AVAILABLE b_tr_hist THEN 
                  FOR EACH b_tr_hist USE-INDEX b_tr_sum WHERE b_tr_sum_id = sumid EXCLUSIVE-LOCK:
                      ASSIGN
                          b_tr_trnbr_qad = tr_trnbr.
                  END.
                  ELSE DO:
                      OUTPUT TO c:\cim_log.txt APPEND.
                      PUT UNFORMAT STRING(TODAY) ' ' t_tr_type ' ' t_tr_nbr ' '  STRING(t_tr_line) ' ' t_tr_part ' CIM导入失效!' SKIP.
                      OUTPUT CLOSE.
                  END.
              END.
              ELSE DO:
                  OUTPUT TO c:\cim_log.txt APPEND.
                      PUT UNFORMAT STRING(TODAY) ' ' t_tr_type ' ' t_tr_nbr ' '  STRING(t_tr_line) ' ' t_tr_part ' CIM导入失效!' SKIP.
                      OUTPUT CLOSE.
              END.
           sumid = substr(string(YEAR(TODAY)),3,2) + string(MONTH(TODAY)) + STRING(DAY(TODAY)) + STRING(TIME) + STRING(ETIME).
    
          END.

        mqty = 0.
       END.
    END.
   


