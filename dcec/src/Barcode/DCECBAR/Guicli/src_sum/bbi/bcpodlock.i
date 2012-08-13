FIND FIRST b_ex_pod WHERE b_ex_po = bc_po_nbr AND b_ex_poln = bc_po_line EXCLUSIVE-LOCK NO-ERROR.
IF NOT AVAILABLE b_ex_pod THEN DO:
    CREATE b_ex_pod.
    ASSIGN 
        b_ex_po = bc_po_nbr
       b_ex_poln = bc_po_line.
       FIND FIRST b_ex_pod WHERE b_ex_po = bc_po_nbr AND b_ex_poln = bc_po_line EXCLUSIVE-LOCK NO-ERROR.
END.
