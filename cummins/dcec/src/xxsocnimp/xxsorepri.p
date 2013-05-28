/*用新价格表写价格                                                           */
{mfdeclre.i}

define input parameter sonbr like so_nbr.
define input parameter soline like sod_line.
define input parameter soprice like sod_list_pr.

define stream sob.
output stream sob to "xxsorepri.bpi".
  put stream sob unformat '"' sonbr '"' skip.
  put stream sob unformat '-' skip '-' skip '-' skip.
  put stream sob unformat '-' skip '-' skip '-' skip.
  put stream sob unformat '.' skip 'S' skip.
  put stream sob unformat soline skip.
  put stream sob unformat '-' skip '-' skip.
  put stream sob unformat 'y' skip.
  put stream sob unformat soprice skip '-' skip.
  put stream sob unformat '-' skip.
  put stream sob unformat '-' skip.
  put stream sob unformat '.' skip.
  put stream sob unformat '.' skip.
  put stream sob unformat '-' skip '-' skip.
output stream sob close.

pause 0 before-hide.
batchrun = yes.
input from value ("xxsorepri.bpi").
output to value ("xxsorepri.bpo") keep-messages.
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
