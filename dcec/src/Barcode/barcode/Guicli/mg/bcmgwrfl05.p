 
{mfdeclre.i}
     DEF INPUT PARAMETER bid LIKE b_bf_id. 
     
 define shared variable global_recid as recid.
 DEF VAR isheader AS LOGICAL.
 DEF VAR isdetail AS LOGICAL.
 DEF VAR mid LIKE ABS_id.
 DEF VAR sid LIKE b_bf_bc03.
 isheader = NO.
 isdetail = NO.
 FIND LAST  b_bf_det WHERE b_bf_tocim = YES AND /*b_bf_sess = global_userid AND b_bf_program = cim_case*/  b_bf_id = bid   EXCLUSIVE-LOCK NO-ERROR.
sid = b_bf_bc03.

IF AVAILABLE b_bf_det THEN DO: 
    FIND FIRST scx_ref WHERE SCX_TYPE = 1 AND scx_shipfrom = b_bf_TOsite AND scx_shipto = b_bf_bc02 NO-LOCK NO-ERROR.
    FIND LAST ABS_mstr USE-INDEX ABS_id WHERE ABS_shipfrom = b_bf_tosite AND ABS_shipto = b_bf_bc02 NO-LOCK NO-ERROR.
        GLOBAL_recid = RECID(ABS_mstr).
 OUTPUT TO 'cim.txt'.
     PUT "@@batchload ". PUT  b_bf_program SKIP.
       PUT '"'.
PUT UNFORMAT right-trim(b_bf_TOsite).
PUT '"'.
PUT SPACE (1).
PUT UNFORMAT '"' RIGHT-TRIM(b_bf_bc03) '"'.
PUT SPACE(1).
PUT '"'.
PUT UNFORMAT right-trim(b_bf_bc02).
PUT '"'.
PUT SPACE(1).
PUT SKIP.
PUT '- - - - '.
PUT '"'.
PUT UNFORMAT right-trim(b_bf_bc01).
PUT '"'.
PUT SPACE(1).
PUT SKIP.
PUT '.'.

  FOR EACH  b_bf_det WHERE b_bf_tocim = YES AND /*b_bf_sess = global_userid AND b_bf_program = cim_case*/  b_bf_bc03 = sid   NO-LOCK:

    
 PUT SKIP.
IF AVAILABLE scx_ref THEN DO:
    FIND FIRST scx_ref WHERE SCX_TYPE = 1 AND scx_shipfrom = b_bf_TOsite AND scx_shipto = b_bf_bc02 AND SCX_ORD = B_BF_NBR NO-LOCK NO-ERROR.
    IF AVAILABLE SCX_REF THEN DO:
    
    PUT '"'.
    PUT UNFORMAT RIGHT-TRIM(b_bf_part).
    PUT '"'.
    END.
    ELSE DO:
PUT '- - - - '.
PUT '"'.
PUT UNFORMAT RIGHT-TRIM(b_bf_NBR).
    PUT '"'.
    PUT SPACE(1).
    PUT UNFORMAT RIGHT-TRIM(STRING(b_bf_line)).
    END.
END.
ELSE DO:
    PUT '"'.
    PUT UNFORMAT RIGHT-TRIM(b_bf_NBR).
    PUT '"'.
    PUT SPACE(1).
    PUT UNFORMAT RIGHT-TRIM(STRING(b_bf_line)).
END.
  PUT SKIP.  

PUT UNFORMAT RIGHT-TRIM(string(b_bf_qty_loc)).
PUT SPACE(1).
PUT '- - '.
PUT '"'.
 PUT UNFORMAT RIGHT-TRIM(b_bf_TOSITE).
PUT '"'.
PUT SPACE(1).
PUT '"'.
PUT UNFORMAT RIGHT-TRIM(b_bf_TOloc).
PUT '"'.

  END.

PUT '.'.
PUT SKIP.
/*PUT '.'.
PUT SKIP.*/
PUT '-'.
PUT SKIP.
PUT '.'.
PUT SKIP.
     PUT "@@end".
    OUTPUT CLOSE.
  
    
   {bcrun.i ""bcmgbdpro.p"" "(INPUT ""cim.txt"",INPUT ""out.txt"")"}
    FIND LAST ABS_mstr  WHERE substr(ABS_id,2,50) = sid  NO-LOCK NO-ERROR.
  IF AVAILABLE ABS_mstr THEN DO: 
      
      isHEADER = YES.
  END.
   isdetail = YES.
  FOR EACH  b_bf_det WHERE b_bf_tocim = YES AND /*b_bf_sess = global_userid AND b_bf_program = cim_case*/  b_bf_bc03 = sid   EXCLUSIVE-LOCK :
FIND FIRST ABS_mstr WHERE substr(ABS_par_id,2,50) = sid AND ABS_order = b_bf_nbr AND ABS_line = string(b_bf_line) NO-LOCK NO-ERROR.
   IF NOT AVAILABLE ABS_mstr THEN do:
       isdetail = NO.
MESSAGE  b_bf_nbr + STRING(b_BF_line) + b_bf_part '更新QAD失败！' VIEW-AS ALERT-BOX.
   END.
         ELSE b_bf_tocim = NO.
  END.
  
   IF isheader AND isdetail THEN do:
    .
     
      MESSAGE '更新QAD成功！' VIEW-AS ALERT-BOX.
  END.
     
   
        
        
        
END.
