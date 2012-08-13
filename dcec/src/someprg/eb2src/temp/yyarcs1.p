DEF INPUT PARAMETER cust LIKE ar_bill .
DEF INPUT-OUTPUT PARAMETER efdt LIKE ar_effdate .
DEF INPUT-OUTPUT PARAMETER efdt1 LIKE ar_effdate .

{mfdeclre.i}

for FIRST ar_mstr WHERE ar_bill = cust and
         ar_effdate >= efdt AND ar_effdate <= efdt1 AND
         ar_type <> "A" and
         (not ar_type = "D" or ar_draft = true) no-lock :
END.
IF AVAILABLE ar_mstr THEN efdt = ar_effdate .

for LAST ar_mstr WHERE ar_bill = cust and
         ar_effdate >= efdt AND ar_effdate <= efdt1 AND
         ar_type <> "A" and
         (not ar_type = "D" or ar_draft = true) no-lock :
END.
IF AVAILABLE ar_mstr THEN efdt1 = ar_effdate .

