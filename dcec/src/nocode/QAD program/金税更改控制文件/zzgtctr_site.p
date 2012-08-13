FOR EACH usrw_wkfl WHERE usrw_key1 = "GOLDTAX-CTRL" AND usrw_key2 = "1".
    ASSIGN usrw_charfld[4] = "CEBJ".

    FOR EACH si_mstr WHERE si_site <> "CEBJ".
         ASSIGN usrw_charfld[4] = usrw_charfld[4] + "," + si_site.
    END.

END.
