/*用新价格表写价格                                                           */
{mfdeclre.i}

define input parameter sonbr like so_nbr.
define output parameter oret  as character.

define variable vcimfile as character.
define stream sob.
assign vcimfile = "xxmodspdt" + "." + sonbr.
output stream sob to value(vcimfile + ".bpi") .
  put stream sob unformat '"' sonbr '"' skip.
  put stream sob unformat '-' skip '-' skip '-' skip.
  put stream sob unformat '- - - - ' today ' - - - - - - ' today ' - - - - - - - Y' skip.
  put stream sob unformat '-' skip .  /*tax*/
  put stream sob unformat 'N - - - - - - - - - - N' skip.
  put stream sob unformat '.' skip '.' skip '-' skip '-' skip.
output stream sob close.

pause 0 before-hide.
batchrun = yes.
input from value (vcimfile + ".bpi").
output to value (vcimfile + ".bpo") keep-messages.
hide message no-pause.
cimrunprogramloop:
do transaction on stop undo cimrunprogramloop,leave cimrunprogramloop:
   {gprun.i ""soivmt.p""}
end.
hide message no-pause.
output close.
input close.
batchrun = no.
pause before-hide.

assign oret = "".
find first so_mstr no-lock where so_domain = global_domain and so_nbr = sonbr
       and so_ship_date = today no-error.
if not available sod_det then do:
   assign oret = "e".
end.
if oret = "" then do:
   os-delete value(vcimfile + ".bpi").
   os-delete value(vcimfile + ".bpo").
end.
