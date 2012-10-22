DEF VAR umconv AS DECIMAL.
DEF VAR mqty AS DECIMAL.
DEF VAR lstop AS INT.
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
FOR EACH b_tr_hist WHERE b_tr_sum_id = "" AND b_tr_trnbr_qad = 0:
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
END.

OUTPUT TO RCTPO1.
FOR EACH t_tr_hist WHERE t_tr_type = "RCT-PO" AND index(t_tr_userid,'*>?/<') = 0 BREAK BY month(t_tr_effdate) BY t_tr_nbr BY t_tr_line BY t_tr_site BY t_tr_loc BY t_tr_part :
    ACCUMULATE t_tr_qty_loc (TOTAL BY t_tr_part).
    
    IF LAST-OF(t_tr_part) THEN DO:
       IF t_tr_type = "RCT-PO" THEN DO:
           FIND FIRST pt_mstr WHERE pt_part = t_tr_part NO-LOCK NO-ERROR.
           PUT "@@batchload poporc.p" SKIP.
         PUT UNFORMAT '"' t_tr_nbr '"' SKIP.
          PUT  "- - -  Y N N " SKIP.
          PUT UNFORMAT string(t_tr_line) SKIP.
          PUT UNFORMAT string(ACCUMULATE TOTAL BY t_tr_part t_tr_qty_loc)  ' - - ' pt_um ' - - "' t_tr_site '" "' t_tr_loc '"' SKIP.
        
          PUT     SKIP (3)
              "." SKIP
              "@@END" SKIP.
       END.
    END.
   
END.
 OUTPUT CLOSE.
 RUN bcmgbdpro.p(INPUT 'rctpo1', OUTPUT 'cim').

 OUTPUT TO RCTPO2.
FOR EACH t_tr_hist WHERE t_tr_type = "RCT-PO" AND index(t_tr_userid,'*>?/<') <> 0 BREAK BY SUBSTR(t_tr_userid,INDEX(t_tr_userid,'*>?/<') + 5)   :
  /*  ACCUMULATE t_tr_qty_loc (TOTAL BY t_tr_part).*/
    
    IF LAST-OF(SUBSTR(t_tr_userid,INDEX(t_tr_userid,'*>?/<') + 5)) THEN DO:
       IF t_tr_type = "RCT-PO" THEN DO:
           FIND FIRST pt_mstr WHERE pt_part = t_tr_part NO-LOCK NO-ERROR.
           PUT "@@batchload rsporc.p" SKIP.
         PUT UNFORMAT '"' t_tr_addr '" "' SUBSTR(t_tr_userid,INDEX(t_tr_userid,'*>?/<') + 5) '"' SKIP.
          PUT '-' SKIP.
          PUT  SKIP.
          PUT '.' SKIP.
         PUT "@@END" SKIP.
       END.
    END.
   
END.
 OUTPUT CLOSE.


OUTPUT TO RCTUNP.
FOR EACH t_tr_hist WHERE t_tr_type = "RCT-UNP" BREAK BY month(t_tr_effdate) BY t_tr_nbr BY t_tr_lot BY t_tr_site BY t_tr_loc BY t_tr_part:
    ACCUMULATE t_tr_qty_loc (TOTAL BY t_tr_part).
    
    IF LAST-OF(t_tr_part) THEN DO:
        IF t_tr_type = "RCT-UNP" THEN DO:
           PUT "@@batchload icunrc.p" SKIP.
            PUT UNFORMAT '"' t_tr_part '"' SKIP .
            PUT UNFORMAT string(ACCUMULATE TOTAL BY t_tr_part t_tr_qty_loc) " - - " '"' + t_tr_site + '" "' + t_tr_loc + '"'  SKIP.
            PUT "- - - - - " TODAY SKIP.
            PUT      " " skip
                     "." SKIP
                     "@@END" SKIP.
        END.
    END.
   
END.
 OUTPUT CLOSE.
 mqty = 0.
 OUTPUT TO INTR.
FOR EACH t_tr_hist WHERE t_tr_type = "ISS-TR" BREAK BY month(t_tr_effdate) BY t_tr_nbr BY t_tr_lot BY t_tr_site BY t_tr_loc BY t_tr_site1 BY t_tr_loc1 BY t_tr_part:
    mqty = mqty + t_tr_qty_loc.
   
    IF LAST-OF(t_tr_part) THEN DO:
        IF t_tr_type = "ISS-TR" THEN DO:
           
            put  "@@BATCHLOAD iclotr02.P" skip.
            PUT UNFORMAT '"' t_tr_part '"' SKIP.
            PUT UNFORMAT STRING(mqty * -1)  skip.
            PUT UNFORMAT '"' + t_tr_site + '" "' + t_tr_loc + '"'  SKIP.
            PUT UNFORMAT '"' t_tr_site1 '" "' t_tr_loc1 '"' SKIP.
          PUT      " " skip
                     "." SKIP
                     "@@END" SKIP.
        END.
        mqty = 0.
    END.
    
END.
OUTPUT CLOSE.




OUTPUT TO RCTWO.
FOR EACH t_tr_hist WHERE t_tr_type = "RCT-WO" BREAK BY month(t_tr_effdate) BY t_tr_nbr  BY t_tr_lot BY t_tr_site BY t_tr_loc BY t_tr_part:
    ACCUMULATE t_tr_qty_loc (TOTAL BY t_tr_part).
    
    IF LAST-OF(t_tr_part) THEN DO:
        IF t_tr_type = "RCT-WO" THEN DO:
            FIND FIRST pt_mstr WHERE pt_part = t_tr_part NO-LOCK NO-ERROR.
            FIND LAST ro_det WHERE ro_routing = (IF pt_routing <> '' THEN pt_routing ELSE pt_part) AND ro_milestone NO-LOCK NO-ERROR.
             IF AVAILABLE ro_det THEN lstop = ro_op. 
             
            FOR EACH ro_det WHERE ro_routing = (IF pt_routing <> '' THEN pt_routing ELSE pt_part) AND ro_milestone NO-LOCK:
                
            put  "@@BATCHLOAD rebkfl.P" skip.
            PUT UNFORMAT '"' t_tr_addr '"' SKIP.
            PUT UNFORMAT '- - "' t_tr_site '"' SKIP.
            PUT UNFORMAT '"' t_tr_part '" ' ro_op ' "' t_tr_lot '"' SKIP.
            PUT '- - -' SKIP.
            PUT '- -' SKIP.
          IF ro_op <> lstop  then
              PUT UNFORMAT '- ' STRING(ACCUMULATE TOTAL BY t_tr_part t_tr_qty_loc) ' - - - - - - - - - - - -' SKIP.
          
          ELSE
              PUT UNFORMAT '- ' STRING(ACCUMULATE TOTAL BY t_tr_part t_tr_qty_loc) ' - - - - - - - - Y Y - -' SKIP.

          PUT '- -' SKIP.
          PUT '.' SKIP.
         IF ro_op = lstop THEN do:
             PUT  SKIP(2).
          
          PUT UNFORMAT '- - - "' t_tr_site '" "' t_tr_loc '"' SKIP.
          PUT " " SKIP.
         END.
            PUT " " SKIP.
            PUT '.' SKIP.
            PUT '@@END' SKIP.

            
            END.
        END.
    END.
    
END.
OUTPUT CLOSE.

mqty = 0.
 OUTPUT TO ISSSO.
FOR EACH t_tr_hist WHERE t_tr_type = "ISS-SO" BREAK BY month(t_tr_effdate) BY t_tr_nbr BY t_tr_line BY t_tr_site BY t_tr_loc BY t_tr_part:
    
   mqty = mqty + t_tr_qty_loc.
   
    IF LAST-OF(t_tr_part) THEN DO:
       IF t_tr_type = "ISS-SO" THEN DO:
            FIND FIRST sod_det WHERE sod_nbr = t_tr_nbr AND sod_line = t_tr_line  NO-LOCK NO-ERROR.
            umconv = IF AVAILABLE sod_det AND sod_um_conv <> 0 THEN sod_um_conv ELSE 1.
            PUT "@@batchload sosois.p" SKIP.
          PUT UNFORMAT t_tr_nbr ' - - - -' SKIP.
         PUT UNFORMAT string(t_tr_line) ' -' SKIP.
         PUT UNFORMAT STRING(mqty * -1) ' "' t_tr_site '" "' t_tr_loc '"' SKIP.
         PUT '.' SKIP.
         PUT  SKIP(2).
        PUT '-' SKIP.
     PUT '-' SKIP.
     PUT '.' SKIP.
     PUT '@@END' SKIP.
          
          
       END.
       mqty = 0.
    END.
    
END.

OUTPUT CLOSE.




mqty = 0.
OUTPUT TO ISSPRV.
FOR EACH t_tr_hist WHERE t_tr_type = "ISS-PRV" BREAK BY month(t_tr_effdate) BY t_tr_nbr BY t_tr_line BY t_tr_site BY t_tr_loc BY t_tr_part:
   mqty = mqty + t_tr_qty_loc.
    /*ACCUMULATE t_tr_qty_loc (TOTAL BY t_tr_part).*/
    
    IF LAST-OF(t_tr_part) THEN DO:
       IF t_tr_type = "ISS-PRV" THEN DO:
            FIND FIRST pt_mstr WHERE pt_part = t_tr_part NO-LOCK NO-ERROR.
           PUT "@@batchload porvis.p" SKIP.
         PUT UNFORMAT '"' t_tr_nbr '"' SKIP.
          PUT  "- - - - N N N Y" SKIP.
         PUT UNFORMAT string(t_tr_line) SKIP.
           PUT UNFORMAT string(mqty * -1)  ' - ' pt_um ' - - "' t_tr_site '" "' t_tr_loc '"' SKIP.
        PUT     SKIP (3)
              "." SKIP
              "@@END" SKIP.
       END.
       mqty = 0.
    END.
    
END.
OUTPUT CLOSE.

mqty = 0.
 OUTPUT TO ISSUNP.
FOR EACH t_tr_hist WHERE t_tr_type = "ISS-UNP" BREAK BY month(t_tr_effdate) BY t_tr_nbr BY t_tr_lot BY t_tr_site BY t_tr_loc BY t_tr_part:
   /* ACCUMULATE t_tr_qty_loc (TOTAL BY t_tr_part).*/
    mqty = mqty + t_tr_qty_loc.
   
    IF LAST-OF(t_tr_part) THEN DO:
        IF t_tr_type = "ISS-UNP" THEN DO:
            put  "@@BATCHLOAD icunis.P" skip.
            PUT UNFORMAT '"' t_tr_part '"' SKIP .
            PUT UNFORMAT STRING(mqty * -1) " - - " '"' + t_tr_site + '" "' + t_tr_loc + '"'  SKIP.
            PUT "- - - - - " TODAY SKIP.
            PUT      " " skip
                     "." SKIP
                     "@@END" SKIP.
        END.
        mqty = 0.
    END.
    
END.
OUTPUT CLOSE.
 

mqty = 0.
OUTPUT TO CYCRCNT.

FOR EACH t_tr_hist WHERE t_tr_type = "CYC-RCNT" BREAK BY month(t_tr_effdate) BY t_tr_nbr BY t_tr_lot BY t_tr_site BY t_tr_loc BY t_tr_part:
   /* ACCUMULATE t_tr_qty_loc (TOTAL BY t_tr_part).*/
    mqty = mqty + t_tr_qty_loc.
   
    IF LAST-OF(t_tr_part) THEN DO:
        FIND FIRST ld_det WHERE ld_part = t_tr_part AND ld_site = t_tr_site AND ld_loc = t_tr_loc NO-LOCK NO-ERROR.
        mqty = (IF AVAILABLE ld_det THEN ld_qty_oh  ELSE 0) + mqty.
        IF t_tr_type = "cyc-rcnt" THEN DO:
            put  "@@BATCHLOAD icccaj.P" skip.
            PUT '"R"' SKIP .
            PUT UNFORMAT '"' t_tr_part '"' SKIP.
            PUT UNFORMAT '"' t_tr_site '" "' t_tr_loc '"' SKIP.
            PUT UNFORMAT STRING(mqty) ' - -'  SKIP.
            PUT "- - - -"  SKIP.
            PUT  " " SKIP.
               PUT '.' SKIP.    
               PUT      "@@END" SKIP.
        END.
        mqty = 0.
    END.
    
END.
OUTPUT CLOSE

 

