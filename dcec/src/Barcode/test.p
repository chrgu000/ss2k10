DEFINE VAR i AS INT.
    i = 1.
FOR EACH tr_hist WHERE tr_date >= 10/08/06 AND tr_date <= 12/28/06 BY tr_trnbr.
        IF tr_trnbr - i <> 1 THEN
        DISP tr_date tr_effdate i LABEL "First" tr_trnbr (tr_trnbr - i - 1) LABEL "Var".
        i = tr_trnbr.
END.

