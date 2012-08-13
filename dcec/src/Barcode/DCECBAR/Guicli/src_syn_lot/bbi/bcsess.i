FIND FIRST b_sess_wkfl WHERE b_sess_usrid = g_user AND b_sess_exec = bc_exec EXCLUSIVE-LOCK  NO-ERROR.
IF AVAILABLE b_sess_wkfl THEN DELETE b_sess_wkfl.   
