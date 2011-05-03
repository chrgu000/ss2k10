DEFINE INPUT PARAMETER ref LIKE glt_ref .
DEFINE INPUT PARAMETER v_date1 AS DATE .
DEFINE OUTPUT PARAMETER v_date2  AS DATE .
DEFINE OUTPUT PARAMETER v_error AS LOGICAL .
DEFINE OUTPUT PARAMETER v_type AS CHAR .

DEFINE VAR v_ref AS CHAR .
DEFINE VAR i AS INT .


v_ref = SUBSTRING(ref,1,9) .
i   = INT (SUBSTRING(ref,10,5)) .
/* 不能小于前一笔时间 */
FIND LAST glt_det WHERE glt_tr_type = "JL" AND SUBSTRING(glt_ref , 1, 9) = v_ref AND (  INT (SUBSTRING(glt_ref,10,5)) ) < i use-index glt_tr_type NO-LOCK NO-ERROR .
IF AVAILABLE glt_det  THEN DO:
      IF v_date1 < glt_effdate  THEN DO:
          v_error = YES .
          v_date2 = glt_effdate .
          v_type = "1" .
      END.
END.

/* 不能大于后一笔时间 */

FIND FIRST glt_det WHERE glt_tr_type = "JL" AND SUBSTRING(glt_ref , 1, 9) = v_ref AND (  INT (SUBSTRING(glt_ref,10,5)) ) > i use-index glt_tr_type  NO-LOCK NO-ERROR .
IF AVAILABLE glt_det  THEN DO:
      IF v_date1 > glt_effdate  THEN DO:
          v_error = YES .
          v_date2 = glt_effdate .
          v_type = "2" .
      END.
END.

/*
v_ref = SUBSTRING(ref,1,8) .
i   = INT (SUBSTRING(ref,9,6)) .
/* 不能小于前一笔时间 */
FIND LAST glt_det WHERE SUBSTRING(glt_ref , 1, 8) = v_ref AND (  INT (SUBSTRING(glt_ref,9,6)) ) < i  NO-LOCK NO-ERROR .
IF AVAILABLE glt_det  THEN DO:
      IF v_date1 < glt_effdate  THEN DO:
          v_error = YES .
          v_date2 = glt_effdate .
          v_type = "1" .
      END.
END.

/* 不能大于后一笔时间 */

FIND FIRST glt_det WHERE SUBSTRING(glt_ref , 1, 8) = v_ref AND (  INT (SUBSTRING(glt_ref,9,6)) ) > i  NO-LOCK NO-ERROR .
IF AVAILABLE glt_det  THEN DO:
      IF v_date1 > glt_effdate  THEN DO:
          v_error = YES .
          v_date2 = glt_effdate .
          v_type = "2" .
      END.
END.
*/




