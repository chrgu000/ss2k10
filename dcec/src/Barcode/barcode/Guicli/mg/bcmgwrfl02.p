{mfdeclre.i}
     DEF INPUT PARAMETER bid LIKE b_bf_id.
     DEF SHARED TEMP-TABLE t_error
    FIELD t_er_code AS CHAR FORMAT "x(18)"
   FIELD t_er_mess AS CHAR FORMAT "x(30)".
    DEF SHARED TEMP-TABLE btrid_tmp
        FIELD btrid LIKE b_tr_id.
    FIND FIRST b_ct_ctrl NO-LOCK NO-ERROR.
DEF VAR st AS CHAR.
DEF VAR st1 AS CHAR.
    DEF VAR missid AS INT.
  DEF VAR missdate AS DATE.
  DEF VAR mrctid AS INT.
  DEF VAR mrctdate AS DATE.
    FIND LAST  b_bf_det WHERE b_bf_tocim = YES AND /*b_bf_sess = global_userid AND b_bf_program = cim_case*/ b_bf_id = bid  EXCLUSIVE-LOCK NO-ERROR.
IF AVAILABLE b_bf_det THEN DO:
    FIND FIRST ld_det WHERE ld_site = b_bf_site AND ld_loc = b_bf_loc AND ld_part = b_bf_part AND ld_lot = b_bf_lot AND ld_ref = b_bf_ref NO-LOCK NO-ERROR.

IF AVAILABLE ld_det THEN 
     st = ld_status.
  ELSE do:
      FIND FIRST loc_mstr WHERE loc_site = b_bf_site AND loc_loc = b_bf_loc NO-LOCK NO-ERROR.
      IF AVAILABLE loc_mstr THEN st = loc_status.
      
      END.
     FIND FIRST ld_det WHERE ld_site = b_bf_tosite AND ld_loc = b_bf_toloc AND ld_part = b_bf_part AND ld_lot = b_bf_lot AND ld_ref = b_bf_ref NO-LOCK NO-ERROR.
  
     IF AVAILABLE ld_det THEN  st1 = ld_status.
          ELSE DO:
     FIND FIRST loc_mstr WHERE loc_site = b_bf_tosite AND loc_loc = b_bf_toloc NO-LOCK NO-ERROR.
      IF AVAILABLE loc_mstr THEN st1 = loc_status.

          END.

    OUTPUT TO 'cim.txt'.
     PUT "@@batchload ". PUT  b_bf_program SKIP.
     PUT '"'.
     PUT UNFORMAT right-trim(b_bf_part).
     PUT '"'.
     PUT SKIP.
    
     PUT string(b_bf_qty_loc).
     PUT SKIP.
PUT '"'.
PUT UNFORMAT right-trim(b_bf_site).
PUT '"'.
PUT SPACE(1).
PUT '"'.
PUT UNFORMAT right-trim(b_bf_loc).
PUT '"'.
PUT SPACE(1).
PUT '"'.
PUT UNFORMAT right-trim(b_bf_lot).
PUT '"'.
PUT SPACE(1).
PUT '"'.
PUT UNFORMAT right-trim(b_bf_ref).
PUT '"'.
PUT SPACE(1).
PUT SKIP.
PUT '"'.
PUT UNFORMAT right-trim(b_bf_tosite).
PUT '"'.
PUT SPACE(1).
PUT '"'.
PUT UNFORMAT right-trim(b_bf_toloc).
PUT '"'.
PUT SKIP.
IF st <> st1 THEN do:
    PUT 'y'.
    PUT SKIP.
END.
PUT 'y'.
PUT SKIP.
PUT "@@end".
    OUTPUT CLOSE.
  
  
   {bcrun.i ""bcmgbdpro.p"" "(INPUT ""cim.txt"",INPUT ""out.txt"")"}
    FIND LAST tr_hist USE-INDEX tr_trnbr SHARE-LOCK WHERE tr_type = 'iss-tr' AND tr_program = 'iclotr02.p' AND tr_nbr = b_bf_nbr AND tr_line = b_bf_line AND tr_part = b_bf_part AND tr_site = b_bf_site AND tr_loc = b_bf_loc AND tr_userid = global_userid AND tr_date = b_bf_date AND tr_qty_loc = b_bf_qty_loc * -1  no-error.
   
   IF AVAILABLE tr_hist THEN DO:
   FIND FIRST b_tr_hist WHERE b_tr_trnbr = tr_trnbr NO-LOCK NO-ERROR.
      IF NOT AVAILABLE b_tr_hist THEN 
     
   ASSIGN missid = tr_trnbr
   missdate = tr_date.
    END.
   FIND LAST tr_hist USE-INDEX tr_trnbr SHARE-LOCK WHERE tr_type = 'rct-tr' AND tr_program = 'iclotr02.p' AND tr_nbr = b_bf_nbr AND tr_line = b_bf_line AND tr_part = b_bf_part AND tr_site = b_bf_tosite AND tr_loc = b_bf_toloc AND tr_userid = global_userid AND tr_date = b_bf_date AND tr_qty_loc = b_bf_qty_loc  no-error.
    IF AVAILABLE tr_hist THEN DO:
     FIND FIRST b_tr_hist WHERE b_tr_trnbr = tr_trnbr NO-LOCK NO-ERROR.
      IF NOT AVAILABLE b_tr_hist THEN 
     
        ASSIGN  mrctid = tr_trnbr
      mrctdate = tr_date.
    END.
   IF b_ct_up_mtd = 'online' THEN DO:
  
    IF missid <> 0 AND mrctid <> 0 THEN DO:
    FIND FIRST b_tr_hist EXCLUSIVE-LOCK WHERE b_tr_id = b_bf_btrid1 NO-ERROR.
     b_tr_tr_date = missdate.
     b_tr_trnbr = missid.
  
      FIND FIRST b_tr_hist EXCLUSIVE-LOCK WHERE b_tr_id = b_bf_btrid2 NO-ERROR.
     b_tr_tr_date = mrctdate.
     b_tr_trnbr = mrctid.
     b_bf_tocim = NO.

     MESSAGE '更新QAD成功！' VIEW-AS ALERT-BOX.
        END.
    ELSE MESSAGE '更新QAD失败！' VIEW-AS ALERT-BOX.
    END.
    
ELSE DO:
    
           IF missid <> 0 AND mrctid <> 0 THEN DO:
    FOR EACH btrid_tmp   EXCLUSIVE-LOCK:
         FIND FIRST b_tr_hist EXCLUSIVE-LOCK WHERE b_tr_id = btrid  NO-ERROR.
        IF b_tr_typ = 'iss-tr'  THEN DO:
        
         b_tr_tr_date = missdate.
     b_tr_trnbr = missid.
    END.
    ELSE IF b_tr_typ = 'rct-tr' THEN DO:
   
        ASSIGN   b_tr_tr_date = mrctdate
     b_tr_trnbr = mrctid.
     END.
     b_bf_tocim = NO.

     END.
           END.
        ELSE DO:
        FOR EACH btrid_tmp NO-LOCK:
        CREATE t_error.
          t_er_code = string(btrid).
          t_er_mess = '更新QAD失败！'.
            
            
            END.
          
          
            END.
        
        
        END.
END.
