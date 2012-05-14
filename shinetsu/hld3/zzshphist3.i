/*zzshphist3.i   Create Histgram Data with type "3" */
/*Last Modify by Leo Zhou   03/20/2012 */

/*Clear old data and refresh*/
for each usrw_wkfl where usrw_domain = global_domain
     and usrw_key1 = "HIST_DAT" 
     and usrw_key2 <> ""
     and usrw_key3 = "3"
     and usrw_key4 = v_part:
    delete usrw_wkfl.
end.

for each th :
  do transaction:
    find first usrw_wkfl where usrw_domain = global_domain
         and usrw_key1 = "HIST_DAT" and usrw_key2 = th_lotno no-error.
    if not avail usrw_wkfl then do:
       create usrw_wkfl.
       assign usrw_domain = global_domain
           usrw_key1   = "HIST_DAT"
	   usrw_key2   = th_lotno
	   usrw_key3   = "3"
	   usrw_key4   = v_part
	   usrw_charfld[1] = global_userid
	   usrw_datefld[1] = today.
    end.
    else assign usrw_key3   = "3"
	        usrw_key4   = v_part
	        usrw_charfld[1] = global_userid
	        usrw_datefld[1] = today.
  end.
  release usrw_wkfl.
end.  /*for each tt*/
