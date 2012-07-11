/* xxrqdld.i - rqrqmt.p cim load                                             */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

{mfdeclre.i}
{xxrqdld.i}
define variable vfile as character.

assign vfile = "xxrqdld.p." + string(today,"99999999") + '.' + string(time).

for each xxrqd no-lock where xxrqd_chk = "".
    output to value(vfile + ".bpi").
    put unformat '"' xxrqd_nbr '"' skip.
    put unformat "-" skip.
    put unformat "-" skip.
    put unformat "-" skip.
    put unformat "-" skip.
    put unformat xxrqd_line skip.
    put unformat "-" skip.
    put unformat "-" skip.
    put unformat "-" skip.
    put unformat "-" skip.
    put unformat "-" skip.
    put unformat "-" skip.
    /* put unformat "y" skip.   msg 4389*/
    put unformat xxrqd_due_date ' - - - - - - - - "' xxrqd_stat '" N' skip.
    put unformat "." skip.
    put unformat "." skip.
    put unformat "y" skip.
    output close.
    if cloadfile then do:
    	 assign global_userid = xxrqd_rqby.
       batchrun = yes.
       input from value(vfile + ".bpi").
       output to value(vfile + ".bpo") keep-messages.
       hide message no-pause.
       cimrunprogramloop:
       do on stop undo cimrunprogramloop,leave cimrunprogramloop:
          {gprun.i ""rqrqmt.p""}
       end.
       hide message no-pause.
       output close.
       input close.
       batchrun = no.
		 end.
end.

if cloadfile then do:		 
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
/* os-delete value(vfile + ".bpi").     */
/* os-delete value(vfile + ".bpo").     */
end.
