/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 08/16/12  ECO: *SS-20120816.1*   */
{mfdeclre.i }

FOR EACH usrw_wkfl WHERE  /* *SS-20120816.1*   */ usrw_wkfl.usrw_domain = global_domain and usrw_key1 = "GOLDTAX-CTRL" AND usrw_key2 = "1".
    ASSIGN usrw_charfld[4] = "CEBJ".

    FOR EACH si_mstr WHERE /* *SS-20120816.1*   */ si_mstr.si_domain = global_domain and si_site <> "CEBJ".
         ASSIGN usrw_charfld[4] = usrw_charfld[4] + "," + si_site.
    END.

END.
