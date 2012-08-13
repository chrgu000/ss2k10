OUTPUT TO RCTWO.
FOR EACH t_tr_hist WHERE t_tr_type = "RCT-WO" BREAK BY month(t_tr_effdate) BY t_tr_nbr  /*BY t_tr_lot*/ BY t_tr_site BY t_tr_loc BY t_tr_part:
    ACCUMULATE t_tr_qty_loc (TOTAL BY t_tr_part).
    
    IF LAST-OF(t_tr_part) THEN DO:
        IF t_tr_type = "RCT-WO" THEN DO:
             
                
           routing = t_tr_part.
           bomcode = t_tr_part.
            FIND FIRST pdp_det WHERE ptp_site = t_tr_site AND ptp_part = t_tr_part NO-LOCK NO-ERROR.
            IF AVAILABLE ptp_det AND ptp_routing <> ''THEN assign
                routing = ptp_routing
                bomcode = ptp_bom_code.
                ELSE DO:
                     FIND FIRST pt_mstr WHERE pt_part = t_tr_part NO-LOCK NO-ERROR.
                     IF AVAILABLE pt_mstr THEN assign
                         routing = IF pt_routing <> '' THEN pt_routing ELSE pt_part
                           bomcode = IF pt_bom_code <> '' THEN pt_bom_code ELSE pt-part..
                END.
            FIND LAST ro_det WHERE ro_routing = routing AND (IF ro_start <> ? THEN ro_start <= mdate ELSE YES) AND (IF ro_end <> ? THEN ro_end >= mdate ELSE YES) /* ro_milestone*/ NO-LOCK NO-ERROR.
             IF AVAILABLE ro_det THEN lstop = ro_op. 
             
            FOR EACH ro_det WHERE ro_routing = routing AND (IF ro_start <> ? THEN ro_start <= mdate ELSE YES) AND (IF ro_end <> ? THEN ro_end >= mdate ELSE YES) /*AND ro_milestone*/ NO-LOCK:
               
            put  "@@BATCHLOAD rebkfl.P" skip.
            PUT UNFORMAT '"' t_tr_addr '"' SKIP.
            PUT UNFORMAT '- - "' t_tr_site '"' SKIP.
            PUT UNFORMAT '"' t_tr_part '" ' string(ro_op) ' "' t_tr_lot '"' SKIP.
            PUT '- - -' SKIP.
            PUT '- -' SKIP.
          IF ro_op <> lstop  then
              PUT UNFORMAT '- ' STRING(ACCUMULATE TOTAL BY t_tr_part t_tr_qty_loc) ' - - - - - - - - Y - - -' SKIP.
          
          ELSE
              PUT UNFORMAT '- ' STRING(ACCUMULATE TOTAL BY t_tr_part t_tr_qty_loc) ' - - - - - - - - Y Y - -' SKIP.

          PUT '- -' SKIP.
          FIND FIRST ps_mstr WHERE ps__chr01 = t_tr_site AND ps_par = bomcode AND (IF ps_start <> ? THEN ps_start <= mdate ELSE YES) AND (IF ps_end <> ? THEN ps_end >= mdate ELSE YES) AND ps_op = ro_op NO-LOCK NO-ERROR.
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
            END.

          PUT '.' SKIP.
         IF ro_op = lstop THEN do:
             PUT  'yes' SKIP.
                 PUT  'yes' SKIP.
          
          PUT UNFORMAT '- - - "' t_tr_site '" "' t_tr_loc '"' SKIP.
          PUT "yes " SKIP.
         END.
            PUT "yes " SKIP.
            PUT '.' SKIP.
            PUT '@@END' SKIP.

            
            END.
        END.
    END.
    
END.
OUTPUT CLOSE.
