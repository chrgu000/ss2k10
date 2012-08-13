DEF VAR cur_id AS INT.
FIND LAST b_usrh_hist NO-LOCK NO-ERROR.
IF AVAILABLE b_usrh_hist THEN cur_id = b_usrh_id + 1.
ELSE cur_id = 0.
CREATE b_usrh_hist.
b_usrh_id = cur_id.
b_usrh_usrid = g_user.
b_usrh_date = TODAY.
    b_usrh_time = TIME.
    b_usrh_exec = bc_exec.

    
   
