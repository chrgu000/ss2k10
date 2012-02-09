/* SS - 111020.1 BY KEN */
/*V8:ConvertMode=Report                                                       */
/*SS - 111220.1 BY KEN*/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{xxmpsim2.i}

define variable vppt like seq_priority.
DEFINE SHARED VARIABLE v_date AS DATE EXTENT 32.

DEFINE VARIABLE v_i AS INTEGER.

/*SS - 111220.1 B*/
  /*
  FOR EACH xxmps,
      EACH usrw_wkfl no-lock where
           usrw_wkfl.usrw_domain = global_domain and
           usrw_wkfl.usrw_key1 = key1 and
           usrw_wkfl.usrw_key3 = xxmps_dept and
           usrw_wkfl.usrw_key4 = xxmps_cx
     BREAK BY usrw_key6 BY xxmps_date:
     if first-of(xxmps_date) then do:
         for each seq_mstr use-index seq_sequence exclusive-lock where
                  seq_mstr.seq_domain = global_domain and
                  seq_mstr.seq_site = "TS" and
                  seq_mstr.seq_line = usrw_key6 and
                  seq_due_date = xxmps_date:
           delete seq_mstr.
         end.
     end.
  end.
  */

  for each xxmps no-lock break by xxmps_dept:
      if first-of(xxmps_dept) then do:
            DO v_i = 1 TO 32:
               IF v_date[v_i] <> ? THEN DO:
                   for each seq_mstr  where
                            seq_mstr.seq_domain = global_domain 
                            AND seq_mstr.seq_site = "TS" 
                            AND seq_due_date = v_date[v_i]
                            :
                             FIND FIRST usrw_wkfl WHERE usrw_domain = GLOBAL_domain
                                          AND usrw_key1 = "SSGZTS-CX"
                                          AND usrw_key6 = seq_line
                                          AND usrw_key5 = seq_part 
                                          AND CAN-FIND(FIRST CODE_mstr WHERE CODE_domain = GLOBAL_domain AND CODE_fldname = "dept-34" AND CODE_value = usrw_key3)
                                 NO-LOCK NO-ERROR.
                             IF AVAIL usrw_wkfl THEN DO:
                                delete seq_mstr.
                             END.                                 
                   END.
               END.
            END.
      END.
  end.


/*SS - 111220.1 E*/

  
/*cimload */
v_i = 0.
FOR EACH xxmps,
   EACH usrw_wkfl no-lock where
       usrw_wkfl.usrw_domain = global_domain and
       usrw_wkfl.usrw_key1 = key1 and
       usrw_wkfl.usrw_key3 = xxmps_dept and
       usrw_wkfl.usrw_key4 = xxmps_cx
   BREAK BY usrw_key6 BY xxmps_date BY usrw_key5:

        IF FIRST-OF(xxmps_date) THEN DO:
           v_i = 0.
        END.

        IF FIRST-OF(usrw_key5) THEN DO:
            v_i = v_i + 1.
        END.

        FIND FIRST seq_mstr WHERE seq_domain = GLOBAL_domain
             AND seq_site = "ts" 
             AND seq_line = usrw_wkfl.usrw_key6
             AND seq_due_date = xxmps_date 
             AND seq_priority = v_i NO-ERROR.
        IF NOT AVAIL seq_mstr THEN DO:

             create seq_mstr.
             assign seq_mstr.seq_domain = global_domain
                    seq_mstr.seq_site = "TS"
                    seq_mstr.seq_line = usrw_wkfl.usrw_key6
                    seq_mstr.seq_priority = v_i
                    seq_mstr.seq__chr01 = xxmps_bc
                    seq_mstr.seq_part = usrw_wkfl.usrw_key5
                    seq_mstr.seq_qty_req = xxmps_qty
                    seq_mstr.seq_due_date = xxmps_date.

                    xxmps_error = "导入成功".
        END.
        ELSE DO:
            seq_mstr.seq_qty_req = seq_mstr.seq_qty_req + xxmps_qty.
            xxmps_error = "导入成功".
        END.
END.
