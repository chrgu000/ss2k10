DEF VAR umconv AS DECIMAL.
DEF VAR mqty AS DECIMAL.
DEF VAR lstop AS INT.
DEF VAR sumid AS CHAR.
DEF VAR routing AS CHAR.
DEF VAR bomcode AS CHAR.
DEF VAR qtychg AS DECIMAL.
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
DEF BUFFER ttrhist FOR t_tr_hist.
FOR EACH b_tr_hist USE-INDEX b_tr_sum WHERE b_tr_sum_id = "" AND b_tr_trnbr_qad = 0 AND b_tr_type <> 'RCT-TR' AND b_tr_type <> 'RCT-WO' AND b_tr_type <> 'ISS-WO' AND index(b_tr_userid,'*>?/<') = 0 NO-LOCK:
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
         OUTPUT TO rctpo.inp.
         PUT UNFORMAT 'mfg mfg'  SKIP.
      PUT UNFORMAT 'mgbdpro.p' SKIP.
         PUT UNFORMAT '- - - - y "rctpo"' SKIP.
         PUT UNFORMAT '"cim"' SKIP.
         PUT '.' SKIP.
         PUT '.' SKIP.
         PUT 'Y' SKIP.
         OUTPUT CLOSE.
         OUTPUT TO iBATCH.p.
         PUT 'input from rctpo.inp.' SKIP.
          PUT 'output to rctpo.out.' SKIP.
          PUT 'pause 0 before-hide.' SKIP.
          PUT 'run mf.p.' SKIP.
         PUT 'input close.' SKIP.
         PUT 'OUTPUT CLOSE.' SKIP.
         OUTPUT CLOSE.
         IF OPSYS = 'dos' OR OPSYS = 'win32' THEN DO:
          OUTPUT TO ibatch.bat.
        PUT '%dlc%\bin\prowin32.exe -p ibatch.p -pf 
            OUTPUT CLOSE.
         END.
         ELSE 
              IF OPSYS = 'unix' THEN DO:


              END.


          OS-COMMAND VALUE("ibatch.bat").
          FIND LAST tr_hist WHERE tr_date = TODAY AND tr_type = 'rct-po' AND tr_program = 'popoprc.p' AND tr_nbr = t_tr_nbr AND tr_line = t_tr_line AND tr_site = t_tr_site AND tr_loc = t_tr_loc AND tr_qty_loc = (ACCUMULATE TOTAL BY t_tr_part t_tr_qty_loc) AND tr_userid = 'mfg' NO-LOCK NO-ERROR.
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

/*
sumid = STRING(TODAY) + STRING(TIME) + STRING(ETIME).
FOR EACH t_tr_hist WHERE t_tr_type = "RCT-PO" AND index(t_tr_userid,'*>?/<') <> 0 BREAK BY SUBSTR(t_tr_userid,INDEX(t_tr_userid,'*>?/<') + 5)   :
  /*  ACCUMULATE t_tr_qty_loc (TOTAL BY t_tr_part).*/
     FIND FIRST b_tr_hist WHERE b_tr_trnbr = t_tr_trnbr EXCLUSIVE-LOCK NO-ERROR.
    IF AVAILABLE b_tr_hist THEN b_tr_sum_id = sumid.
    IF LAST-OF(SUBSTR(t_tr_userid,INDEX(t_tr_userid,'*>?/<') + 5)) THEN DO:
       IF t_tr_type = "RCT-PO" THEN DO:
            OUTPUT TO RCTPO2.
           FIND FIRST pt_mstr WHERE pt_part = t_tr_part NO-LOCK NO-ERROR.
           PUT "@@batchload rsporc.p" SKIP.
         PUT UNFORMAT '"' t_tr_addr '" "' SUBSTR(t_tr_userid,INDEX(t_tr_userid,'*>?/<') + 5) '"' SKIP.
          PUT '-' SKIP.
          PUT 'yes' SKIP.
          PUT '.' SKIP.
         PUT "@@END" SKIP.
         OUTPUT CLOSE.
          FOR EACH b_tr_hist WHERE b_tr_sum_id = sumid no-LOCK:
                      
              FIND LAST tr_hist WHERE tr_date = TODAY AND tr_type = 'rct-po' AND tr_program = 'rspoprc.p' AND tr_nbr = b_tr_nbr AND tr_line = b_tr_line AND tr_userid = 'mfg' NO-LOCK NO-ERROR.

              
                  END.
          
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
   
END.*/




FOR EACH t_tr_hist WHERE t_tr_type = "RCT-UNP" BREAK BY month(t_tr_effdate)  BY t_tr_site BY t_tr_loc BY t_tr_nbr BY t_tr_lot BY t_tr_part:
    ACCUMULATE t_tr_qty_loc (TOTAL BY t_tr_part).
    FIND FIRST b_tr_hist WHERE b_tr_trnbr = t_tr_trnbr EXCLUSIVE-LOCK NO-ERROR.
   IF AVAILABLE b_tr_hist THEN b_tr_sum_id = sumid.
    IF LAST-OF(t_tr_part) THEN DO:
        IF t_tr_type = "RCT-UNP" THEN DO:
            OUTPUT TO RCTUNP.
           PUT "@@batchload icunrc.p" SKIP.
            PUT UNFORMAT '"' t_tr_part '"' SKIP .
            PUT UNFORMAT string(ACCUMULATE TOTAL BY t_tr_part t_tr_qty_loc) " - - " '"' + t_tr_site + '" "' + t_tr_loc + '"'  SKIP.
            PUT "- - - - - " TODAY SKIP.
            PUT      "yes" skip
                     "." SKIP
                     "@@END" SKIP.
            OUTPUT CLOSE.
    
FIND LAST tr_hist WHERE tr_date = TODAY AND tr_type = 'RCT-UNP' AND tr_program = 'icunrc.p' AND tr_site = t_tr_site AND tr_loc = t_tr_loc AND tr_nbr = t_tr_nbr AND tr_so_job = t_tr_lot AND tr_part = t_tr_part AND tr_qty_loc = (ACCUMULATE TOTAL BY t_tr_part t_tr_qty_loc) AND tr_userid = 'mfg' NO-LOCK NO-ERROR.
          
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

     
       END.
    END.
 
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
          FIND LAST tr_hist WHERE tr_date = TODAY AND tr_type = 'iss-tr' AND tr_program = 'iclotr02.p' AND tr_site = t_tr_site AND tr_loc = t_tr_loc  AND tr_part = t_tr_part AND tr_qty_loc = mqty AND tr_userid = 'mfg' NO-LOCK NO-ERROR.
          
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


/*
mqty = 0.

FOR EACH t_tr_hist WHERE t_tr_type = "RCT-WO" BREAK BY month(t_tr_effdate) BY t_tr_nbr  /*BY t_tr_lot*/ BY t_tr_site BY t_tr_loc BY t_tr_part:
    ACCUMULATE t_tr_qty_loc (TOTAL BY t_tr_part).
     FIND FIRST b_tr_hist WHERE b_tr_trnbr = t_tr_trnbr EXCLUSIVE-LOCK NO-ERROR.
   IF AVAILABLE b_tr_hist THEN b_tr_sum_id = sumid.
    IF LAST-OF(t_tr_part) THEN DO:
        IF t_tr_type = "RCT-WO" THEN DO:
             
                
           routing = t_tr_part.
           bomcode = t_tr_part.
            FIND FIRST ptp_det WHERE ptp_site = t_tr_site AND ptp_part = t_tr_part NO-LOCK NO-ERROR.
            IF AVAILABLE ptp_det AND ptp_routing <> ''THEN assign
                routing = ptp_routing
                bomcode = ptp_bom_code.
                ELSE DO:
                     FIND FIRST pt_mstr WHERE pt_part = t_tr_part NO-LOCK NO-ERROR.
                     IF AVAILABLE pt_mstr THEN assign
                         routing = IF pt_routing <> '' THEN pt_routing ELSE pt_part
                           bomcode = IF pt_bom_code <> '' THEN pt_bom_code ELSE pt_part.
                END.
            FIND LAST ro_det WHERE ro_routing = routing AND (IF ro_start <> ? THEN ro_start <= TODAY ELSE YES) AND (IF ro_end <> ? THEN ro_end >= TODAY ELSE YES) /* ro_milestone*/ NO-LOCK NO-ERROR.
             IF AVAILABLE ro_det THEN lstop = ro_op. 
             
           /* FOR EACH ro_det WHERE ro_routing = routing AND (IF ro_start <> ? THEN ro_start <= mdate ELSE YES) AND (IF ro_end <> ? THEN ro_end >= mdate ELSE YES) /*AND ro_milestone*/ NO-LOCK:
             */  
             OUTPUT TO RCTWO.
            put  "@@BATCHLOAD rebkfl.P" skip.
            PUT UNFORMAT '"' t_tr_addr '"' SKIP.
            PUT UNFORMAT '- - "' t_tr_site '"' SKIP.
            PUT UNFORMAT '"' t_tr_part '" ' string(ro_op) ' "' t_tr_lot '"' SKIP.
            PUT '- - -' SKIP.
            PUT '- -' SKIP.
         /* IF ro_op <> lstop  then
              PUT UNFORMAT '- ' STRING(ACCUMULATE TOTAL BY t_tr_part t_tr_qty_loc) ' - - - - - - - - Y - - -' SKIP.
          
          ELSE*/
              PUT UNFORMAT '- ' STRING(ACCUMULATE TOTAL BY t_tr_part t_tr_qty_loc) ' - - - - - - - - Y Y - -' SKIP.

          PUT '- -' SKIP.
        /*  FIND FIRST ps_mstr WHERE ps__chr01 = t_tr_site AND ps_par = bomcode AND (IF ps_start <> ? THEN ps_start <= mdate ELSE YES) AND (IF ps_end <> ? THEN ps_end >= mdate ELSE YES) AND ps_op = ro_op NO-LOCK NO-ERROR.
            IF AVAILABLE ps_mstr THEN DO:
       
              mqty = 0.
        FOR EACH ttrhist WHERE ttrhist.t_tr_type = 'ISS-WO' AND ttrhist.t_tr_nbr = t_tr_hist.t_tr_nbr BREAK BY month(ttrhist.t_tr_effdate) BY ttrhist.t_tr_nbr  /*BY t_tr_lot*/ BY ttrhist.t_tr_site BY ttrhist.t_tr_loc BY ttrhist.t_tr_part: 
              mqty = mqty + ttrhist.t_tr_qty_loc.
              IF LAST-OF(ttrhist.t_tr_part)   THEN DO:
             IF trhist.t_tr_type = 'ISS-WO' THEN DO:
             PUT UNFORMAT '"' ttrhist.t_tr_part '" -' SKIP.
             PUT UNFORMAT STRING(mqty * -1) ' - "' ttrhist.t_tr_site '" "' ttrhist.t_tr_loc '" - - -' SKIP.
             END.
             mqty = 0.
             END.
                
          END.
            END.*/

          PUT '.' SKIP.
        /* IF ro_op = lstop THEN do:*/
             PUT  'yes' SKIP.
                 PUT  'yes' SKIP.
          
          PUT UNFORMAT '- - - "' t_tr_site '" "' t_tr_loc '"' SKIP.
          PUT "yes " SKIP.
       /*  END.*/
            PUT "yes " SKIP.
            PUT '.' SKIP.
            PUT '@@END' SKIP.
         OUTPUT CLOSE.
            FIND LAST tr_hist WHERE tr_date = TODAY AND tr_type = 'RCT-WO' AND tr_program = 'rebkfl.p' AND tr_nbr = t_tr_nbr AND tr_part = t_tr_part AND tr_qty_loc = (ACCUMULATE TOTAL BY t_tr_part t_tr_qty_loc) AND   tr_userid = 'mfg' NO-LOCK NO-ERROR.
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

FOR EACH t_tr_hist WHERE t_tr_type = "ISS-SO" BREAK BY month(t_tr_effdate) BY t_tr_nbr BY t_tr_line BY t_tr_site BY t_tr_loc BY t_tr_part:
    
   mqty = mqty + t_tr_qty_loc.
   FIND FIRST b_tr_hist WHERE b_tr_trnbr = t_tr_trnbr EXCLUSIVE-LOCK NO-ERROR.
   IF AVAILABLE b_tr_hist THEN b_tr_sum_id = sumid.
    IF LAST-OF(t_tr_part) THEN DO:
       IF t_tr_type = "ISS-SO" THEN DO:
            OUTPUT TO ISSSO.
            FIND FIRST sod_det WHERE sod_nbr = t_tr_nbr AND sod_line = t_tr_line  NO-LOCK NO-ERROR.
            umconv = IF AVAILABLE sod_det AND sod_um_conv <> 0 THEN sod_um_conv ELSE 1.
            PUT "@@batchload sosois.p" SKIP.
          PUT UNFORMAT t_tr_nbr ' - - - -' SKIP.
         PUT UNFORMAT string(t_tr_line) ' -' SKIP.
         PUT UNFORMAT STRING(mqty * -1) ' "' t_tr_site '" "' t_tr_loc '"' SKIP.
         PUT '.' SKIP.
         PUT  'yes' SKIP.
             PUT 'yes' SKIP.
        PUT '-' SKIP.
     PUT '-' SKIP.
     PUT '.' SKIP.
     PUT '@@END' SKIP.
          OUTPUT CLOSE.
           FIND LAST tr_hist WHERE tr_date = TODAY AND tr_type = 'ISS-SO' AND tr_program = 'sosois.p' AND tr_nbr = t_tr_nbr AND tr_line = t_tr_line AND tr_qty_loc = mqty AND tr_userid = 'mfg' NO-LOCK NO-ERROR.
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
       mqty = 0.

       END.
    END.
       






mqty = 0.

FOR EACH t_tr_hist WHERE t_tr_type = "ISS-PRV" BREAK BY month(t_tr_effdate) BY t_tr_nbr BY t_tr_line BY t_tr_site BY t_tr_loc BY t_tr_part:
   mqty = mqty + t_tr_qty_loc.
    /*ACCUMULATE t_tr_qty_loc (TOTAL BY t_tr_part).*/
    
    IF LAST-OF(t_tr_part) THEN DO:
       IF t_tr_type = "ISS-PRV" THEN DO:
           OUTPUT TO ISSPRV.
            FIND FIRST pt_mstr WHERE pt_part = t_tr_part NO-LOCK NO-ERROR.
           PUT "@@batchload porvis.p" SKIP.
         PUT UNFORMAT '"' t_tr_nbr '"' SKIP.
          PUT  "- - - - N N N Y" SKIP.
         PUT UNFORMAT string(t_tr_line) SKIP.
           PUT UNFORMAT string(mqty * -1)  ' - ' pt_um ' - - "' t_tr_site '" "' t_tr_loc '"' SKIP.
        PUT     "yes" SKIP.
        PUT "yes" SKIP.
        PUT "yes" SKIP.
             PUT  "." SKIP
              "@@END" SKIP.
                 OUTPUT CLOSE.
       FIND LAST tr_hist WHERE tr_date = TODAY AND tr_type = 'ISS-PRV' AND tr_program = 'porvis.p' AND tr_nbr = t_tr_nbr AND tr_line = t_tr_line AND tr_site = t_tr_site AND tr_loc = t_tr_loc  AND tr_qty_loc = mqty AND tr_userid = 'mfg' NO-LOCK NO-ERROR.
          
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


mqty = 0.

FOR EACH t_tr_hist WHERE t_tr_type = "ISS-UNP" BREAK BY month(t_tr_effdate)  BY t_tr_site BY t_tr_loc BY t_tr_nbr BY t_tr_lot BY t_tr_part:
   /* ACCUMULATE t_tr_qty_loc (TOTAL BY t_tr_part).*/
    mqty = mqty + t_tr_qty_loc.
     FIND FIRST b_tr_hist WHERE b_tr_trnbr = t_tr_trnbr EXCLUSIVE-LOCK NO-ERROR.
   IF AVAILABLE b_tr_hist THEN b_tr_sum_id = sumid.
    IF LAST-OF(t_tr_part) THEN DO:
        IF t_tr_type = "ISS-UNP" THEN DO:
             OUTPUT TO ISSUNP.
            put  "@@BATCHLOAD icunis.P" skip.
            PUT UNFORMAT '"' t_tr_part '"' SKIP .
            PUT UNFORMAT STRING(mqty * -1) " - - " '"' + t_tr_site + '" "' + t_tr_loc + '"'  SKIP.
            PUT "- - - - - " TODAY SKIP.
            PUT      "yes" skip
                     "." SKIP
                     "@@END" SKIP.
            OUTPUT CLOSE.


       FIND LAST tr_hist WHERE tr_date = TODAY AND tr_type = 'ISS-UNP' AND tr_program = 'icunis.p' AND tr_site = t_tr_site AND tr_loc = t_tr_loc AND tr_nbr = t_tr_nbr AND tr_so_job = t_tr_lot AND tr_part = t_tr_part AND tr_qty_loc = mqty AND tr_userid = 'mfg' NO-LOCK NO-ERROR.
          
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
 

mqty = 0.


FOR EACH t_tr_hist WHERE t_tr_type = "CYC-RCNT" BREAK BY month(t_tr_effdate)  BY t_tr_site BY t_tr_loc BY t_tr_part:
   /* ACCUMULATE t_tr_qty_loc (TOTAL BY t_tr_part).*/
    mqty = mqty + t_tr_qty_loc.
    FIND FIRST b_tr_hist WHERE b_tr_trnbr = t_tr_trnbr EXCLUSIVE-LOCK NO-ERROR.
   IF AVAILABLE b_tr_hist THEN b_tr_sum_id = sumid.
    IF LAST-OF(t_tr_part) THEN DO:
        FIND FIRST ld_det WHERE ld_part = t_tr_part AND ld_site = t_tr_site AND ld_loc = t_tr_loc NO-LOCK NO-ERROR.
        qtychg = mqty.
            mqty = (IF AVAILABLE ld_det THEN ld_qty_oh  ELSE 0) + mqty.
     
        IF t_tr_type = "cyc-rcnt" THEN DO:
            OUTPUT TO CYCRCNT.
            put  "@@BATCHLOAD icccaj.P" skip.
            PUT '"R"' SKIP .
            PUT UNFORMAT '"' t_tr_part '"' SKIP.
            PUT UNFORMAT '"' t_tr_site '" "' t_tr_loc '"' SKIP.
            PUT UNFORMAT STRING(mqty) ' - -'  SKIP.
            PUT "- - - -"  SKIP.
            PUT  "yes" SKIP.
               PUT '.' SKIP.    
               PUT      "@@END" SKIP.
               OUTPUT CLOSE.
        FIND LAST tr_hist WHERE tr_date = TODAY AND tr_type = 'CYC-RCNT' AND tr_program = 'icccaj.p' AND tr_qty_loc = qtychg AND  tr_userid = 'mfg' NO-LOCK NO-ERROR.
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

   mqty = 0.
       END.
    END.



 


