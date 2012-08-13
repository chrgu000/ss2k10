 {bcdeclre.i}
 DEF SHARED TEMP-TABLE t_error
    FIELD t_er_code AS CHAR FORMAT "x(18)"
   FIELD t_er_mess AS CHAR FORMAT "x(30)".
    DEF SHARED TEMP-TABLE btrid_tmp
        FIELD btrid LIKE b_tr_id.
    FIND FIRST b_ct_ctrl NO-LOCK NO-ERROR.

     FIND LAST  b_bf_det EXCLUSIVE-LOCK WHERE b_bf_tocim = YES AND b_bf_sess = g_user AND b_bf_program = cim_case NO-ERROR.
IF AVAILABLE b_bf_det THEN DO:
    OUTPUT TO 'cim.txt'.
     PUT "@@batchload ". PUT  b_bf_program SKIP.
     PUT '"'. PUT CONTROL  b_bf_nbr. PUT '"' SKIP.
     PUT  '"" "" '.
     PUT b_bf_date.
     PUT SPACE(1).
     PUT b_bf_bc01.
     
     PUT SKIP.
     PUT CONTROL b_bf_line. SKIP.
     PUT '"'. PUT CONTROL b_bf_qty_loc.  PUT  '" - - '. PUT '"ea" "' .
          
     PUT b_bf_bc03. 
     PUT '"'.      
     PUT SPACE(1).
     PUT '"'  .    
     PUT b_bf_bc02.
     PUT '"'.      
     PUT SPACE(1).

        PUT '"'.  PUT CONTROL b_bf_site. PUT  '" "'. PUT CONTROL  b_bf_loc.
              PUT  '" "'. PUT CONTROL  b_bf_lot. PUT  '" "'. PUT b_bf_ref. PUT '"'.
     PUT SKIP.
     PUT '.'.
     PUT SKIP.
     PUT '-'.
     PUT SKIP.
     PUT '-'.
     PUT SKIP.
     PUT '.'.
     PUT SKIP.
     PUT "@@end".
    OUTPUT CLOSE.
  
   {bcrun.i ""bcmgbdpro.p"" "(INPUT ""cim.txt"",INPUT ""out.txt"")"}
    FIND LAST tr_hist SHARE-LOCK WHERE tr_type = 'rct-po' AND tr_program = 'poporc' AND tr_nbr = b_bf_nbr AND tr_line = b_bf_line AND tr_part = b_bf_part AND tr_site = b_bf_site AND tr_loc = b_bf_loc AND tr_usrid = g_user AND tr_date = b_bf_date AND tr_qty_loc = b_bf_qty_loc   no-error.
   
   IF b_ct_up_mtd = 'online' THEN DO:
  
    IF AVAILABLE tr_hist THEN DO:
    FIND FIRST b_tr_hist EXCLUSIVE-LOCK WHERE b_tr_id = b_bf_trid1 NO-ERROR.
     b_tr_tr_date = tr_date.
     b_tr_trnbr = tr_trnbr.
     b_bf_tocim = NO.

     MESSAGE '更新QAD成功！' VIEW-AS ALERT-BOX.
        END.
    ELSE MESSAGE '更新QAD失败！' VIEW-AS ALERT-BOX.
    END.
    
ELSE DO:
    
         IF AVAILABLE tr_hist THEN DO:
    FOR EACH btrid_tmp   EXCLUSIVE-LOCK:
         FIND FIRST b_tr_hist EXCLUSIVE-LOCK WHERE b_tr_id = btrid NO-ERROR.
        b_tr_tr_date = tr_date.
     b_tr_trnbr = tr_trnbr.
    

     END.
      b_bf_tocim = NO.
        END.
        ELSE DO:
        
          FOR EACH btrid_tmp NO-LOCK:
        CREATE t_error.
          t_er_code = btrid.
          t_er_mess = '更新QAD失败！'.
            
            
            END.
          
            END.
        
        
        END.
