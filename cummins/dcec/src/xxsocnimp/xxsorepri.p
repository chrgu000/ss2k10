/*用新价格表写价格                                                           */
{mfdeclre.i}

define input parameter sonbr like so_nbr.
define input parameter soline like sod_line.
define input parameter soprice like sod_list_pr.
define output parameter oret  as character.

define variable vcimfile as character.
define stream sob.
assign vcimfile = "xxsorepri" + "." + sonbr + "." + string(soline,"999999").
output stream sob to value(vcimfile + ".bpi") .
  put stream sob unformat '"' sonbr '"' skip.
  put stream sob unformat '-' skip '-' skip '-' skip.
  put stream sob unformat '- - - - ' today ' - - - - - - ' today ' - - - - - - - Y' skip.
  put stream sob unformat '-' skip .  /*tax*/
  put stream sob unformat 'N - - - - - - - - - - N' skip.
  put stream sob unformat '.' skip 'S' skip.
  put stream sob unformat soline skip.
  put stream sob unformat '-' skip '-' skip.
  put stream sob unformat '-' skip. /*重新定价*/
  put stream sob unformat '-' skip '-' skip. /*价格*/
  put stream sob unformat '-' skip.
  put stream sob unformat '-' skip. /*明细*/
  put stream sob unformat '.' skip.
  put stream sob unformat '.' skip.
  put stream sob unformat '-' skip '-' skip.
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
find first sod_det no-lock where sod_domain = global_domain and sod_nbr = sonbr
       and sod_line = soline no-error.
if available sod_det and sod_list_pr <> soprice then do:
   assign oret = "e".
end.
if oret = "" then do:
   os-delete value(vcimfile + ".bpi").
   os-delete value(vcimfile + ".bpo").
end.
