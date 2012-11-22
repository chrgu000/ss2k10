/* xxptld.p - ppptmt.p cim load                                                */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

{mfdeclre.i}
{xxshstld.i}
define variable vfile as character.
assign vfile = "".
assign vfile = "xxshstld.p." + string(today,"99999999") + '.' + string(time).
output to value(vfile + ".bpi").
for each tmpsh no-lock where tsh_chk = "".
		put unformat '"' tsh_site '" "' tsh_abs_id '" "' tsh_nbr '"' skip.
		put unformat '"' tsh_stat '"' skip.
end.
output close.

if cloadfile then do:
   batchrun = yes.
   input from value(vfile + ".bpi").
   output to value(vfile + ".bpo") keep-messages.
   hide message no-pause.
   cimrunprogramloop:
   do on stop undo cimrunprogramloop,leave cimrunprogramloop:
      {gprun.i ""xxshstmt.p""}
   end.
   hide message no-pause.
   output close.
   input close.
   batchrun = no.

   for each tmpsh exclusive-lock where tsh_chk = "":
       find first xxsh_mst no-lock where xxsh_nbr = tsh_nbr 
       				and xxsh_site = tsh_site
       			  and xxsh_abs_id = "S" + tsh_abs_id no-error.
			 if available(xxsh_mst) then do:
			 		if tsh_stat = xxsh_stat then do:
			 				assign tsh_chk = getMsg(4171).
			 		 end.
			 		 else do:
			 		 		assign tsh_chk = getMsg(4172).
			 		 end.
			 end.
			 else do:
			 		assign tsh_chk = getMsg(4172).
			 end.       			  
   end.
   os-delete value(vfile + ".bpi").
   os-delete value(vfile + ".bpo").
end.
