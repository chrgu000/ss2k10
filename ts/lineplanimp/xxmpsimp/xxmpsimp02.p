/* SS - 111020.1 BY KEN */
/*V8:ConvertMode=Report                                                       */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{xxmpsimp.i}
define variable vppt like seq_priority.


  for each xxmps WHERE xxmps_date <> ? no-lock break by xxmps_date:
      if first-of(xxmps_date) then do:        
         
         for each seq_mstr where
                       seq_mstr.seq_domain = global_domain 
                       AND seq_mstr.seq_site = "TS"           
                       AND seq_due_date = xxmps_date
                       :
                /*
                MESSAGE seq_line  xxmps_date VIEW-AS ALERT-BOX.
                */

             FIND FIRST usrw_wkfl WHERE usrw_domain = GLOBAL_domain
                          AND usrw_key1 = "SSGZTS-CX"
                          AND usrw_key6 = seq_line
                          AND usrw_key5 = seq_part 
                          AND CAN-FIND(FIRST CODE_mstr WHERE CODE_domain = GLOBAL_domain AND CODE_fldname = "dept-12" AND CODE_value = usrw_key3)
                 NO-LOCK NO-ERROR.
             IF AVAIL usrw_wkfl THEN DO:
                delete seq_mstr.
             END.                                 
         end.         
      end.
  end.


/*cimload 18.22.1.14*/
  
  FOR EACH xxmps:
               
               create seq_mstr.
               assign
                  seq_domain = global_domain
                  seq_site = "TS"
                  seq_line = xxmps_line
                  seq_priority = xxmps_seq
                  seq__chr01 = xxmps_bc
                  seq_part = xxmps_part
                  seq_qty_req = xxmps_qty
                  seq_due_date = xxmps_date.
                  xxmps_error = "导入成功".
  END.
  
