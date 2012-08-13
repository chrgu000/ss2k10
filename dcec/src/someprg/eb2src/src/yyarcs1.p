DEF INPUT PARAMETER cust LIKE ar_bill .
DEF INPUT-OUTPUT PARAMETER efdt LIKE ar_effdate .
DEF INPUT-OUTPUT PARAMETER efdt1 LIKE ar_effdate .
DEF OUTPUT PARAMETER startamt LIKE ar_base_amt .
DEF OUTPUT PARAMETER endamt LIKE ar_base_amt .

DEF VAR base_amt LIKE ar_amt .
DEF VAR amtrmb LIKE ar_base_amt .
DEF VAR peramt LIKE ar_base_amt .

find first gl_ctrl no-lock.

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

peramt = 0 .
for each ar_mstr WHERE ar_bill = cust and
         ar_effdate >= efdt AND ar_effdate <= efdt1 AND
         ar_type <> "A" and
         (not ar_type = "D" or ar_draft = true) no-lock :

    base_amt = ar_amt.

    /*NOTE: USED FOR EACH BECAUSE WITH VAT MAY HAVE MORE THAN 1 BLANK REF*/
    if ar_type = "P" and
        can-find(first ard_det where ard_nbr = ar_nbr and
        ard_ref = "")
    then do:
        for each ard_det where
              ard_nbr = ar_nbr and
              ard_ref = ""
        no-lock:
           if ard_type = "N" then do:
              base_amt = base_amt + ard_amt.
           end.
        end.
    end.

    IF ar_type = "D" THEN base_amt = - base_amt .

    if ar_type = "P" and
        can-find(first ard_det where ard_nbr = ar_nbr and
        ard_type = "d")
    then do:
        for each ard_det where
              ard_nbr = ar_nbr and
              ard_type = "d"
        no-lock:
              base_amt = base_amt + ard_amt.
        end.
    end.

     IF ar_curr <> gl_base_curr THEN DO :
         IF base_amt <> ar_amt THEN amtrmb = base_amt / ar_ex_rate .
         ELSE amtrmb = ar_base_amt .
     END.
     ELSE amtrmb = base_amt .

     peramt = peramt + amtrmb .
end. /* for each ar_mstr */

endamt = 0 .
for each ar_mstr WHERE ar_bill = cust and
         ar_effdate <= efdt1 AND
         ar_type <> "A" and
         (not ar_type = "D" or ar_draft = true) no-lock :

    base_amt = ar_amt.

    /*NOTE: USED FOR EACH BECAUSE WITH VAT MAY HAVE MORE THAN 1 BLANK REF*/
    if ar_type = "P" and
        can-find(first ard_det where ard_nbr = ar_nbr and
        ard_ref = "")
    then do:
        for each ard_det where
              ard_nbr = ar_nbr and
              ard_ref = ""
        no-lock:
           if ard_type = "N" then do:
              base_amt = base_amt + ard_amt.
           end.
        end.
    end.

    IF ar_type = "D" THEN base_amt = - base_amt .

    if ar_type = "P" and
        can-find(first ard_det where ard_nbr = ar_nbr and
        ard_type = "d")
    then do:
        for each ard_det where
              ard_nbr = ar_nbr and
              ard_type = "d"
        no-lock:
              base_amt = base_amt + ard_amt.
        end.
    end.

     IF ar_curr <> gl_base_curr THEN DO :
         IF base_amt <> ar_amt THEN amtrmb = base_amt / ar_ex_rate .
         ELSE amtrmb = ar_base_amt .
     END.
     ELSE amtrmb = base_amt .

     endamt = endamt + amtrmb .
end. /* for each ar_mstr */

startamt = endamt - peramt .


