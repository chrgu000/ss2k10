{mfdeclre.i}
     DEF INPUT PARAMETER bid LIKE b_bf_id.
     DEF SHARED TEMP-TABLE t_error
    FIELD t_er_code AS CHAR FORMAT "x(18)"
   FIELD t_er_mess AS CHAR FORMAT "x(30)".
    DEF SHARED TEMP-TABLE btrid_tmp
        FIELD btrid LIKE b_tr_id.
    FIND FIRST b_ct_ctrl NO-LOCK NO-ERROR.

     FIND LAST  b_bf_det WHERE b_bf_tocim = YES AND /*b_bf_sess = g_user AND b_bf_program = cim_case*/ b_bf_id = bid  EXCLUSIVE-LOCK NO-ERROR.
IF AVAILABLE b_bf_det THEN DO:
    OUTPUT TO 'cim.txt'.
     PUT "@@batchload ". PUT  trim(b_bf_program) SKIP.
     PUT '"'. PUT UNFORMAT right-trim(b_bf_nbr). PUT '"' SKIP.
     PUT  '"" "" '.
     PUT '-'.
     PUT SPACE(1).
     PUT UNFORMAT right-trim(b_bf_bc01).
     
     PUT SKIP.
     PUT  UNFORMAT RIGHT-TRIM(string(b_bf_line)). 
     PUT SKIP.
     PUT string(b_bf_qty_loc).  PUT  ' - - '. PUT '"ea" "' .
          
     PUT UNFORMAT right-trim(b_bf_bc03). 
     PUT '"'.      
     PUT SPACE(1).
     PUT '"'  .    
     PUT UNFORMAT right-trim(b_bf_bc02).
     PUT '"'.      
     PUT SPACE(1).

        PUT '"'.  PUT UNFORMAT right-trim(b_bf_site). PUT  '" "'. PUT UNFORMAT right-trim(b_bf_loc).
              PUT  '" "'. PUT UNFORMAT right-trim(b_bf_lot). PUT  '" "'. PUT UNFORMAT right-trim(b_bf_ref). PUT '"'.
     PUT SKIP.
     PUT '.'.
     PUT SKIP.
     PUT '-'.
     PUT SKIP.
    /* PUT '-'.
     PUT SKIP.*/
     PUT '.'.
     PUT SKIP.
     PUT "@@end".
    OUTPUT CLOSE.
  
   {bcrun.i ""bcmgbdpro.p"" "(INPUT ""cim.txt"",INPUT ""out.txt"")"}
    FIND LAST tr_hist USE-INDEX tr_trnbr SHARE-LOCK WHERE tr_type = 'rct-po' AND tr_program = 'poporc.p' AND tr_nbr = b_bf_nbr AND tr_line = b_bf_line AND tr_part = b_bf_part AND tr_site = b_bf_site AND tr_loc = b_bf_loc AND tr_userid = GLOBAL_userid AND tr_date = b_bf_date AND tr_qty_loc = b_bf_qty_loc   no-error.
   
   IF b_ct_up_mtd = 'online' THEN DO:
  
    IF AVAILABLE tr_hist THEN DO:
      FIND FIRST b_tr_hist WHERE b_tr_trnbr = tr_trnbr NO-LOCK NO-ERROR.
      IF NOT AVAILABLE b_tr_hist THEN DO:
     
        FIND FIRST b_tr_hist EXCLUSIVE-LOCK WHERE b_tr_id = b_bf_btrid1 NO-ERROR.
     b_tr_tr_date = tr_date.
     b_tr_trnbr = tr_trnbr.
     b_bf_tocim = NO.

     MESSAGE '更新QAD成功！' VIEW-AS ALERT-BOX.
        END.
  
    ELSE MESSAGE '更新QAD失败！' VIEW-AS ALERT-BOX.
      END.
    ELSE MESSAGE '更新QAD失败！' VIEW-AS ALERT-BOX.
    END.
    
ELSE DO:
    
         IF AVAILABLE tr_hist THEN DO:
             FIND FIRST b_tr_hist WHERE b_tr_trnbr = tr_trnbr NO-LOCK NO-ERROR.
              IF NOT AVAILABLE b_tr_hist THEN DO:

             FOR EACH btrid_tmp   EXCLUSIVE-LOCK:
         FIND FIRST b_tr_hist EXCLUSIVE-LOCK WHERE b_tr_id = btrid NO-ERROR.
        b_tr_tr_date = tr_date.
     b_tr_trnbr = tr_trnbr.
    

     END.
      b_bf_tocim = NO.
              END.
          ELSE DO:
        
          FOR EACH btrid_tmp :
        CREATE t_error.
          t_er_code = string(btrid).
          t_er_mess = '更新QAD失败！'.
            
            
            END.
      END.
         END.
        ELSE DO:
        
          FOR EACH btrid_tmp :
        CREATE t_error.
          t_er_code = string(btrid).
          t_er_mess = '更新QAD失败！'.
            
            
            END.
          
            END.
        
        
        END.
END.
