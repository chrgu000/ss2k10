{mfdeclre.i}
define variable L1 as character.
define variable qty1 as decimal.
define variable lo as character.
define variable avv as decimal.
  {gprun.i ""xxicrcin.p""
      "(input 'MHSE02-407-0-LX', input 'gsa01', input 3000 ,
        output Lo ,output avv)"}
    message lo avv.
    pause 100.