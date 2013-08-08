/* xxrqdld.i - rqrqmt.p cim load                                             */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

define shared variable global_user_lang_dir like lng_mstr.lng_dir.       
{xxrqdld.i}

for each xxrqd exclusive-lock:
   find first rqd_det exclusive-lock where rqd_nbr = xxrqd_nbr 
   				and rqd_line = xxrqd_line no-error.
   if available rqd_det then do:
        		 assign rqd_due_date = xxrqd_due_date
        		        rqd_status = "".
        		 {gprun.i ""rqmrw.p""
                "(input false, input rqd_site, input rqd_nbr, input rqd_line)"}
   end.
   else do:
         assign xxrqd_chk = getMsg(1853).
   end.
end.
for each xxrqd exclusive-lock where xxrqd_chk = "":
    find first rqd_det no-lock where rqd_nbr = xxrqd_nbr 
    				and rqd_line = xxrqd_line no-error.
    if available rqd_det and rqd_due_date = xxrqd_due_date and
                 rqd_status = xxrqd_stat
    then do:
       assign xxrqd_chk = "OK".
    end.
    else do:
       assign xxrqd_chk = "FAIL".
    end.
end.