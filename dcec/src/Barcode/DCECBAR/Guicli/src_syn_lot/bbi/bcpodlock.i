
FIND FIRST b_ex_pod WHERE b_ex_po = {1} /*AND b_ex_poln = STRING(pod_line)*/ EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE b_ex_pod THEN DO:
    CREATE b_ex_pod.
    ASSIGN 
        b_ex_po = {1}
      /* b_ex_poln = STRING(pod_line)*/.
       FIND FIRST b_ex_pod WHERE b_ex_po = {1} /*AND b_ex_poln = STRING(pod_line) */ EXCLUSIVE-LOCK NO-ERROR.
END.

