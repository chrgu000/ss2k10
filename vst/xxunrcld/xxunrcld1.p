/* xxunrcld.p - icunrc.p cim load                                            */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120704.1 LAST MODIFIED: 07/04/12 BY:                            */
/* REVISION END                                                              */
{mfdeclre.i}
{xxunrcld.i}
define variable vfile as character.
define variable trrecid as recid.
assign vfile = "xxunrcld.p." + string(today,"99999999") + '.' + string(time).

output to value(vfile + ".bpi").
for each tmpic no-lock where tic_chk = "".
    put unformat '"' tic_part '"' skip.
    put unformat tic_qty ' - - "' tic_site '" "' tic_loc '"' skip.
    put unformat '"' tic_nbr '" - - - - - "' tic_acct '"'.
    if tic_sub = "" then put unformat ' ""'.
       else if tic_sub = '-' then put unformat ' -'.
       else put unformat ' "' tic_sub '"'.
    put unformat ' ' tic_cc.
    if tic_proj = "" then put unformat ' ""'.
       else if tic_proj = "-" then put unformat ' -'.
       else put unformat ' ' tic_proj.
    put skip.
    put "Y" skip.
end.
output close.

if cloadfile then do:
   assign trrecid = current-value(tr_sq01).
   batchrun = yes.
   input from value(vfile + ".bpi").
   output to value(vfile + ".bpo") keep-messages.
   hide message no-pause.
   cimrunprogramloop:
   do on stop undo cimrunprogramloop,leave cimrunprogramloop:
      {gprun.i ""icunrc.p""}
   end.
   hide message no-pause.
   output close.
   input close.
   batchrun = no.

   for each tmpic exclusive-lock where tic_chk = "":
       find first tr_hist no-lock where tr_trnbr > integer(trrecid) and
                  tr_nbr = tic_nbr and tr_type = "RCT-UNP" and
                  tr_part = tic_part and tr_site = tic_site and
                  tr_loc = tic_loc and tr_qty_loc = tic_qty no-error.
       if available tr_hist then do:
          assign tic_chk = "TRNBR:" + string(tr_trnbr).
       end.
       else do:
          assign tic_chk = "FAIL".
       end.
   end.
   os-delete value(vfile + ".bpi").
   os-delete value(vfile + ".bpo").
end.