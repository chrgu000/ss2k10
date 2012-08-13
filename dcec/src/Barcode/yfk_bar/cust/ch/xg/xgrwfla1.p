
	 /* DISPLAY TITLE */
         {mfdeclre.i}

define input parameter iLot   like xwck_lot.
define input parameter iwoLot like xwo_wolot.

DEFINE buffer xwosrt for xwo_srt.

DEFINE VARIABLE xsrtid as recid.

for first wo_mstr where wo_lot = iWoLot no-lock : end.
IF not available wo_mstr THEN
DO:
	return.
END. /* not available wo_mstr*/

for each xwo_srt where xwo_srt.xwo_lot  = ilot
          no-lock  use-index xwo_lnr:
 
    xsrtid = recid(xwo_srt).

    for first xwosrt where recid(xwosrt) = xsrtid exclusive-lock: end.
    IF available xwosrt THEN DO:
       xwosrt.xwo_wolot  = iwolot.
       release xwosrt.    	
    END.
end. /*xwo_srt*/

