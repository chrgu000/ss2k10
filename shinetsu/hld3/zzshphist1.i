/*zzshphist1.i   Create Histgram Data with type "1" */
/*Last Modify by Leo Zhou   03/20/2012 */

if month(today) = 1 then do:
   v_year = year(today) - 1.
   v_last_month = 12.
end.
else do:
   v_year = year(today).
   v_last_month = month(today) - 1.
end.

/*Clear old data and refresh*/
for each usrw_wkfl where usrw_domain = global_domain
     and usrw_key1 = "HIST_DAT" 
     and usrw_key2 <> ""
     and usrw_key3 = "1"
     and usrw_key4 = v_part
     and (year(usrw_datefld[1]) = v_year and month(usrw_datefld[1]) <= v_last_month
          or
	  year(usrw_datefld[1]) < v_year):
    delete usrw_wkfl.
end.

/*Find the data that prepared at last month*/
for each usrw_wkfl where usrw_domain = global_domain
     and usrw_key1 = "HIST_DAT" 
     and usrw_key2 <> ""
     and usrw_key3 = "2"
     and usrw_key4 = v_part
     and year(usrw_datefld[1])  = v_year
     and month(usrw_datefld[1]) = v_last_month:
    assign usrw_key3 = "1".
end.

release usrw_wkfl.
