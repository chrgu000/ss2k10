/*zzshphist2.i   Create Histgram Data with type "2" */
/*Last Modify by Leo Zhou   03/20/2012 */

for each tt where tt_key3 = "1":
    do transaction:
	find first usrw_wkfl where usrw_domain = global_domain
             and usrw_key1 = "HIST_DAT" and usrw_key2 = tt_lotno no-error.
	if avail usrw_wkfl then delete usrw_wkfl.

        create usrw_wkfl.
        assign usrw_domain = global_domain
               usrw_key1 = "HIST_DAT"
	       usrw_key2 = tt_lotno
	       usrw_key3 = "2"
	       usrw_key4 = v_part
	       usrw_charfld[1] = global_userid
	       usrw_datefld[1] = today.
    end.
    release usrw_wkfl.
end.  /*for each tt*/
