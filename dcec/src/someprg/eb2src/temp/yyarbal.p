DEF INPUT PARAMETER ref LIKE ard_ref .
DEF INPUT PARAMETER dt AS DATE .
DEF INPUT-OUTPUT PARAMETER a AS DEC .
        
FOR EACH ard_det NO-LOCK WHERE ard_ref = ref USE-INDEX ard_ref :
    FIND ar_mstr NO-LOCK WHERE ar_nbr = ard_nbr NO-ERROR .
    IF AVAILABLE ar_mstr AND ar_effdate > dt THEN a = a + (ard_amt / ar_ex_rate).
END.

FIND ar_mstr NO-LOCK WHERE ar_nbr = ref NO-ERROR .
IF ar_type <> "P" THEN LEAVE .
FIND FIRST ard_det NO-LOCK WHERE ard_nbr = ref AND ard_type = "u" NO-ERROR .
IF NOT AVAILABLE ard_det THEN LEAVE .
FOR EACH ar_mstr NO-LOCK WHERE ar_check = SUBSTRING(ref,9) AND ar_type = "A" USE-INDEX ar_check :
    IF ar_effdate > dt THEN a = a - ar_base_applied .
END.

