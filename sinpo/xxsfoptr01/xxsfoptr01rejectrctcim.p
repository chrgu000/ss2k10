/* SS - 101130.1 By: Kaine Zhang */

{mfdeclre.i}

define input parameter sWoLot like wo_lot.
define input parameter sSite like loc_site.
define input parameter sLoc like loc_loc.
define input parameter decReject as decimal.

{xxcimdefvar.i}

{xxcreatecimfilename.i}

{xxsfoptr01rejectrctciminput.i}

{xxbeforecimtransflag.i}

{xxcimtranswoworc.i}

/* todo error log */

{xxdeletecimfile.i}

{xxsfoptr01rejectrctcimverify.i}


