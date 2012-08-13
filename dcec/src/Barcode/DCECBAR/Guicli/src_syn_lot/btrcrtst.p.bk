
  DEF VAR i AS INT.
  DEF VAR cnt AS INT.

  cnt = 1.
        FOR EACH pt_mstr:
            i = 1.
            DO WHILE i <= 10:
                CREATE b_tr_hist.
                b_tr_trnbr = NEXT-VALUE(b_tr_sq01).
                b_tr_type = 'iss-tr'.
                b_tr_part = pt_part.
                b_tr_site = 'dcec-b'.
                b_tr_loc = 'tst-a'.
                b_tr_site1 = 'dcec-b'.
                b_tr_loc1 = 'tst-b'.
                b_tr_qty_loc = -1.
                b_tr_qty_chg = -1.
                cnt = cnt + 1.
                i = i + 1.
            END.
IF cnt = 1000 THEN LEAVE.
END.
