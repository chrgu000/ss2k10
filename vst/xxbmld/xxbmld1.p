/* xxinvld.p - bom load                                                      */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120703.1 LAST MODIFIED: 07/03/12 BY:                            */
/* REVISION END                                                              */
{mfdeclre.i}
{xxbmld.i}
define variable vfile as character.
assign vfile = "xxbmld.p." + string(today,"99999999") + '.' + string(time).

output to value(vfile + ".bpi").

for each tmpbomn no-lock :
    put unformat '"' tbmn_par '"' skip.
    put unformat '"' tbmn_comp '" "" ' tbmn_start skip.
    put unformat tbmn_qty_per ' - - ' tbmn_end ' - ' tbmn_scrp ' - - - - - - N' skip.
    put "." skip.
end.
output close.
if cloadfile then do:
       batchrun = yes.
       input from value(vfile + ".bpi").
       output to value(vfile + ".bpo") keep-messages.
       hide message no-pause.
       cimrunprogramloop:
       do on stop undo cimrunprogramloop,leave cimrunprogramloop:
          {gprun.i ""bmpsmt.p""}
       end.
       hide message no-pause.
       output close.
       input close.
       batchrun = no.
       for each tmpbomn exclusive-lock:
       		 find first ps_mstr no-lock where ps_par = tbmn_par 
       		 				and ps_comp = tbmn_comp and ps_ref = "" 
       		 				and ps_start = tbmn_start and ps_end = tbmn_end no-error.
       		 if available ps_mstr then do:
       		 		assign tbmn_chk = "OK".
       		 end.
       		 else do:
       		 		assign tbmn_chk = "CIM_LOAD Fail".
       		 end.
       end.
end.  /*if cloadfile then do:*/
if cloadfile then do:
   os-delete value(vfile + ".bpi").
   os-delete value(vfile + ".bpo").
end.