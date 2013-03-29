find first usrw_wkfl where usrw_domain = global_domain
        and usrw_key1 = global_userid
        and usrw_key2 = execname no-error.
if not available usrw_wkfl then do:
   create usrw_wkfl. usrw_domain = global_domain.
   assign usrw_key1 = global_userid
          usrw_key2 = execname.
end.
/* if locked(usrw_wkfl) then do: */
   assign  usrw_key3        = site
           usrw_key4        = site1
           usrw_datefld[1]  = effdate
           usrw_datefld[2]  = effdate1
           usrw_key5        = line
           usrw_key6        = line1
           usrw_charfld[1]  = type
           usrw_charfld[2]  = type1
           usrw_charfld[3]  = group1
           usrw_charfld[4]  = group2
           usrw_charfld[5]  = part
           usrw_charfld[6]  = part1
           usrw_charfld[7]  = loc
           usrw_charfld[8]  = loc1
           usrw_charfld[9]  = keeper
           usrw_charfld[10] = keeper1
           usrw_logfld[1]   = yn_zero
           usrw_charfld[15] = fName no-error.
/*end. */
release usrw_wkfl.