/* yyictrcfcrpx1.i - parameter file                                          */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION END                                                              */

find first usrw_wkfl no-lock where usrw_domain = global_domain
       and usrw_key1 = global_userid
       and usrw_key2 = execname no-error.
if available usrw_wkfl then do:
   assign  site     = usrw_key3
           site1    = usrw_key4
           effdate  = usrw_datefld[1]
           effdate1 = usrw_datefld[2]
           line     = usrw_key5
           line1    = usrw_key6
           type     = usrw_charfld[1]
           type1    = usrw_charfld[2]
           group1   = usrw_charfld[3]
           group2   = usrw_charfld[4]
           part     = usrw_charfld[5]
           part1    = usrw_charfld[6]
           loc      = usrw_charfld[7]
           loc1     = usrw_charfld[8]
           keeper   = usrw_charfld[9]
           keeper1  = usrw_charfld[10]
           yn_zero  = usrw_logfld[1].
           if opsys = "unix" then do:
              fName    = usrw_charfld[14].
           end.
           else if opsys = "msdos" or opsys = "win32" then do:
              fName    = usrw_charfld[15].
           end.
end.
