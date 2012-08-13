DEF INPUT PARAMETER cust AS CHAR .
DEF INPUT PARAMETER dt AS DATE .
DEF OUTPUT PARAMETER amt AS DEC .

{mfdeclre.i}

amt = 0 .
FOR EACH ar_mstr NO-LOCK WHERE ar_bill = cust AND ar_effdate <= dt AND ar_type <> "d" :

    if ar_type = "D" and not ar_draft then next.

    amt = amt + ar_base_amt - ar_base_applied .

    {gprun.i ""yyarbal.p"" "(input ar_nbr,
        INPUT dt,
        INPUT-OUTPUT amt)"
    }

END.
