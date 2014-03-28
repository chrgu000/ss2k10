{mfdeclre.i}

on write of a6fcs_sum do:
    find first usrw_wkfl where usrw_domain  = "test2014"
           and usrw_key1 = "test2014"
           and usrw_key2 = a6fcs_part no-error.
    if not available usrw_wkfl then do:
       create usrw_wkfl .
       assign usrw_domain = "test2014"
              usrw_key1 = "test2014"
              usrw_key2 = a6fcs_part.
    end.
    assign usrw__qadc01 = "execname:" + execname + ";Call---;" +
                          program-name(1) + ";" +
                          program-name(2) + ";" +
                          program-name(3) + ";" +
                          program-name(4) + ";" +
                          program-name(5) + ";" +
                          program-name(6) + ";" +
                          program-name(7) + ";" +
                          program-name(8) + ";" +
                          program-name(9).

    assign usrw_user2 = string(today,"9999-99-99") + " " + string(time,"HH:MM:SS") + ";" + usrw_user2.
    assign usrw_user1 = usrw_charfld[15].
    assign usrw_charfld[15] = usrw_charfld[14].
    assign usrw_charfld[14] = usrw_charfld[13].
    assign usrw_charfld[13] = usrw_charfld[12].
    assign usrw_charfld[12] = usrw_charfld[11].
    assign usrw_charfld[11] = usrw_charfld[10].
    assign usrw_charfld[10] = usrw_charfld[9].
    assign usrw_charfld[9] = usrw_charfld[8].
    assign usrw_charfld[8] = usrw_charfld[7].
    assign usrw_charfld[7] = usrw_charfld[6].
    assign usrw_charfld[6] = usrw_charfld[5].
    assign usrw_charfld[5] = usrw_charfld[4].
    assign usrw_charfld[4] = usrw_charfld[3].
    assign usrw_charfld[3] = usrw_charfld[2].
    assign usrw_charfld[2] = usrw_charfld[1].
    assign usrw_charfld[1] = usrw__qadc01.

 end.
      run mf.p.
