
	 /* DISPLAY TITLE */
         {mfdeclre.i}

define input parameter iLot   like xwck_lot.
define input parameter iwoLot like xwck_wolot.

DEFINE buffer xkmr for xwck_mstr.

DEFINE VARIABLE xsrtid as recid.

for first  xwck_mstr where xwck_mstr.xwck_lot  = ilot
                       and not xwck_mstr.xwck_blkflh no-lock
    use-index xwck_pal: 
 
    xsrtid = recid(xwck_mstr).

    for first xkmr where recid(xkmr) = xsrtid exclusive-lock: end.
    IF available xkmr THEN DO:
       xkmr.xwck_blkflh = yes.
       release xkmr.    	
    END.
end. /*xwck_mstr*/