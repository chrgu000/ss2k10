/* SS - 111020.1 BY KEN */
/*V8:ConvertMode=Report                                                       */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{xxmpsimp.i}
define variable vppt like seq_priority.
define variable date1 like seq_due_date.

    for each xxmps WHERE xxmps_date <> ? and xxmps_line <> "" no-lock
        break by xxmps_line by xxmps_date:
        if first-of(xxmps_line) then do:
           assign date1 = xxmps_date.
        end.
        if last-of(xxmps_line) then do:
         for each seq_mstr where
                  seq_mstr.seq_domain = global_domain and
                  seq_mstr.seq_site = "TS" and
                  seq_line = xxmps_line and
                  seq_due_date >= date1 and seq_due_date <= xxmps_date:
           delete seq_mstr.
         /*  MESSAGE seq_line xxmps_date VIEW-AS ALERT-BOX.
             FIND FIRST usrw_wkfl WHERE usrw_domain = GLOBAL_domain
                          AND usrw_key1 = "SSGZTS-CX"
                          AND usrw_key6 = seq_line
                          AND usrw_key5 = seq_part
                          AND CAN-FIND(FIRST CODE_mstr WHERE
                                             CODE_domain = GLOBAL_domain AND
                                             CODE_fldname = "dept-12" AND
                                             CODE_value = usrw_key3)
                 NO-LOCK NO-ERROR.
             IF AVAIL usrw_wkfl THEN DO:
                delete seq_mstr.
             END.
              */
         end.
       end.   /*if last-of(xxmps_line) then do:*/
      end.

/*
for each xxmps no-lock break by xxmps_line by xxmps_date :
if first-of(xxmps_date) then do:
assign vppt = 1.
end.
display xxmps_line xxmps_date xxmps_seq vppt.
assign vppt = vppt + 1.
end.
*/
/*cimload 18.22.1.14  */

  FOR EACH xxmps where xxmps_line <> "" and xxmps_qty >= 1:
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

