find first usrw_wkfl exclusive-lock where usrw_domain = global_domain
       and usrw_domain = global_domain and usrw_key1 = execname
       and usrw_key2 = global_userid no-error.
if available usrw_wkfl then do:
   assign  as_of_date       = usrw_datefld[1]
           days[1]          = usrw_intfld[1]
           days[2]          = usrw_intfld[2]
           days[3]          = usrw_intfld[3]
           days[4]          = usrw_intfld[4]
           days[5]          = usrw_intfld[5]
           days[6]          = usrw_intfld[6]
           days[7]          = usrw_intfld[7]
           days[8]          = usrw_intfld[8]
           days[9]          = usrw_intfld[9]
           part             = usrw_key3
           part1            = usrw_key4
           line             = usrw_key5
           line1            = usrw_key6
           abc              = usrw_charfld[1]
           abc1             = usrw_charfld[2]
           site             = usrw_charfld[3]
           site1            = usrw_charfld[4]
           part_type        = usrw_charfld[5]
           part_type1       = usrw_charfld[6]
           part_group       = usrw_charfld[7]
           part_group1      = usrw_charfld[8]
           loc              = usrw_charfld[9]
           loc1             = usrw_charfld[10]
           neg_qty          = usrw_logfld[1]
           net_qty          = usrw_logfld[2]
           inc_zero_qty     = usrw_logfld[3]
           zero_cost        = usrw_logfld[4]
           customer_consign = usrw_charfld[11]
           supplier_consign = usrw_charfld[12]
           fName            = usrw_charfld[15].
end.
