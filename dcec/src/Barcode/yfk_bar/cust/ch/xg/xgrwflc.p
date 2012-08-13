
	 /* DISPLAY TITLE */
         {mfdeclre.i}

define input parameter iLot   like xwck_lot.

DEFINE buffer xkmr for xwck_mstr.

DEFINE VARIABLE xsrtid as recid.

for first  xwck_mstr where xwck_mstr.xwck_lot  = ilot
                       and not xwck_mstr.xwck_tr no-lock
    use-index xwck_pal: 
 
    xsrtid = recid(xwck_mstr).

    for first xkmr where recid(xkmr) = xsrtid exclusive-lock: end.
    IF available xkmr THEN DO:
       xkmr.xwck_tr = No.
       release xkmr.    	
    END.
end. /*xwck_mstr*/