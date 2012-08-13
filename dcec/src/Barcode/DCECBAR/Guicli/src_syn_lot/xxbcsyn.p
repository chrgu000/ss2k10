
{mfdtitle.i}
  DEF VAR bc_id AS CHAR FORMAT "x(18)" LABEL "条码".
DEF VAR mid LIKE tr_lot.
DEF FRAME a
SKIP(1)
    bc_id COLON 15
    WITH WIDTH 80 THREE-D SIDE-LABELS.
REPEAT:

UPDATE bc_id WITH FRAME a.
FIND FIRST b_co_mstr WHERE b_co_code = bc_id AND b_co_status <> 'ia' NO-LOCK NO-ERROR.
IF NOT AVAILABLE b_co_mstr THEN DO:
    MESSAGE '无效条码！' VIEW-AS ALERT-BOX ERROR.
    UNDO,RETRY.
END.
ELSE DO:

FIND LAST tr_hist USE-INDEX tr_part_trn WHERE tr_part = b_co_part AND tr_serial = b_co_lot AND abs(tr_qty_loc) = b_co_qty_cur NO-LOCK NO-ERROR.
IF AVAILABLE tr_hist THEN DO:
IF tr_type = 'iss-tr' THEN DO:
    mid = tr_lot.
FIND LAST tr_hist WHERE tr_type = 'rct-tr' AND tr_lot = mid NO-LOCK NO-ERROR.
IF AVAILABLE tr_hist THEN DO:
    IF tr_serial <> '' AND tr_serial <> b_co_lot THEN 
        ASSIGN
              b_co_lot = tr_serial
              b_co_site= tr_site
               b_co_loc = tr_loc.
    ELSE
        IF tr_serial = '' THEN ASSIGN
                               b_co_site = tr_site
                                b_co_loc = tr_loc
                                b_co_status = 'issln'.
END.
LEAVE.
END.



IF tr_type = 'iss-so' THEN DO:
    ASSIGN b_co_status = 'iss'.
    LEAVE.
END.

IF tr_type = 'iss-prv' THEN DO:
    ASSIGN b_co_status = 'iss'.
    LEAVE.
END.

IF tr_type = 'iss-wo' THEN DO:
   
        ASSIGN 
               b_co_status = 'iss'.
               
    LEAVE.
END.

IF tr_type = 'iss-do' THEN DO:
    FIND FIRST dsd_det WHERE dsd_nbr = tr_nbr AND dsd_part = tr_part NO-LOCK NO-ERROR.
    IF AVAILABLE dsd_det THEN 
        ASSIGN SUBSTR(b_co_desc1,82,8) = b_co_site
               b_co_site = dsd_site
               b_co_loc = dsd_trans_id
               substr(b_co_desc1,80,1) = 'd' .
          ELSE MESSAGE '该条码不能同步！' VIEW-AS ALERT-BOX ERROR.      
    LEAVE.
END.

IF tr_type = 'rct-tr' THEN DO:
    ASSIGN b_co_lot = IF tr_serial <> b_co_lot THEN tr_serial ELSE b_co_lot
           b_co_site = tr_site
         b_co_loc = tr_loc.
LEAVE.

END.
IF tr_type = 'rct-wo' THEN DO:
   
        ASSIGN 
               b_co_status = 'rct'
               b_co_site = tr_site
               b_co_loc = tr_loc.
               
    LEAVE.
END.

IF tr_type = 'rct-po' THEN DO:
   
        ASSIGN 
               b_co_status = 'rct'
               b_co_site = tr_site
               b_co_loc = tr_loc.
               
    LEAVE.
END.
IF tr_type = 'rct-do' THEN DO:
    FIND FIRST dsd_det WHERE dsd_nbr = tr_nbr AND dsd_part = tr_part NO-LOCK NO-ERROR.
    IF AVAILABLE dsd_det THEN 
        ASSIGN 
               b_co_site = tr_site
               b_co_loc = tr_loc
               substr(b_co_desc1,80,1) = 'r' .
          ELSE MESSAGE '该条码不能同步！' VIEW-AS ALERT-BOX ERROR.      
    LEAVE.
END.
 MESSAGE '该条码不能同步,可能是盘点事务！' VIEW-AS ALERT-BOX ERROR. 

END.
  ELSE MESSAGE '该条码不能同步！' VIEW-AS ALERT-BOX ERROR. 
END.
END.
