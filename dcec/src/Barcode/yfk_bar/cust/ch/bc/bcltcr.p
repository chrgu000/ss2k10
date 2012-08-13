 DEFINE INPUT PARAMETER part LIKE pt_part. 
 DEFINE OUTPUT PARAMETER newlot LIKE ld_lot.
 DEFINE VARIABLE lot LIKE ld_lot.
 DEFINE VARIABLE datemark AS CHARACTER.

 ASSIGN datemark = SUBstring(STRING(YEAR(TODAY),"9999"),3,2) + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY),"99").

 FIND FIRST pt_mstr NO-LOCK WHERE pt_part = part NO-ERROR.
 IF NOT AVAILABLE pt_mstr THEN
        newlot = ?.

 SELECT MAX(ld_lot) INTO lot FROM ld_det WHERE ld_part = part AND LENGTH(ld_lot) = 10.
 IF lot = ? THEN 
     newlot = datemark + "0001".
 ELSE IF SUBSTRING(lot,1,6) NE datemark THEN
     newlot = datemark + "0001".
 ELSE
     newlot = SUBSTRING(lot,1,6) + STRING(int(SUBSTRING(lot,7,4)) + 1,"9999").
