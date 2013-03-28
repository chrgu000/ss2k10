find first usrw_wkfl where usrw_domain = global_domain
        and usrw_key1 = execname
        and usrw_key2 = global_userid no-error.
if not available usrw_wkfl then do:
   create usrw_wkfl. usrw_domain = global_domain.
   assign usrw_key1 = execname
          usrw_key2 = global_userid.
end.
if locked(usrw_wkfl) then do:
   assign usrw_datefld[1] = as_of_date
          usrw_intfld[1] = days[1]
          usrw_intfld[2] = days[2]
          usrw_intfld[3] = days[3]
          usrw_intfld[4] = days[4]
          usrw_intfld[5] = days[5]
          usrw_intfld[6] = days[6]
          usrw_intfld[7] = days[7]
          usrw_intfld[8] = days[8]
          usrw_intfld[9] = days[9]
          usrw_key3 = part
          usrw_key4 = part1
          usrw_key5 = line
          usrw_key6 = line1
          usrw_charfld[1] = abc
          usrw_charfld[2] = abc1
          usrw_charfld[3] = site
          usrw_charfld[4] = site1
          usrw_charfld[5] = part_type
          usrw_charfld[6] = part_type1
          usrw_charfld[7] = part_group
          usrw_charfld[8] = part_group1
/*          usrw_charfld[9] = loc           */
/*          usrw_charfld[10] = loc1         */
          usrw_logfld[1] = neg_qty
          usrw_logfld[2] = net_qty
          usrw_logfld[3] = inc_zero_qty
          usrw_logfld[4] = zero_cost
          usrw_logfld[5] = cost_qty
          usrw_logfld[6] = l_excel
          usrw_charfld[11] = customer_consign
          usrw_charfld[12] = supplier_consign
          usrw_charfld[15] = fName.
end.
release usrw_wkfl.