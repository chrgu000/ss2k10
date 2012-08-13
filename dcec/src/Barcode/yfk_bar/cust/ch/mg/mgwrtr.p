{mfdeclre.i}
DEFINE INPUT PARAMETER bccode LIKE b_co_code.
DEFINE INPUT PARAMETER bcpart LIKE b_co_part.
DEFINE INPUT PARAMETER trnbr LIKE b_tr_nbr.
DEFINE INPUT PARAMETER trtype LIKE b_tr_type.
DEFINE INPUT PARAMETER trsite LIKE b_tr_site.
DEFINE INPUT PARAMETER trfloc LIKE b_tr_floc.
DEFINE INPUT PARAMETER trtloc LIKE b_tr_tloc.
DEFINE INPUT PARAMETER trqty LIKE b_tr_qty_loc.
DEFINE INPUT PARAMETER trdate LIKE b_tr_date.
DEFINE INPUT PARAMETER trtime LIKE b_tr_time.

DEFINE VARIABLE i AS INTEGER.

/*SELECT MAX(b_tr_id) INTO i FROM b_tr_hist.
IF i = ? THEN i = 1. ELSE i = i + 1.*/
i = NEXT-VALUE(btr_seq01).
 IF i = ?  THEN DO:
     MESSAGE '«Î≥ı ºªØb_tr_hist£°' VIEW-AS ALERT-BOX ERROR.
     LEAVE.
 END.
DO ON ERROR UNDO ,LEAVE:
     CREATE b_tr_hist.
     ASSIGN 
         b_tr_trnbr = i
         b_tr_code = bccode
         b_tr_part = bcpart
         b_tr_type = trtype
          b_tr_site = trsite
          b_tr_floc = trfloc
          b_tr_tloc = trtloc
          b_tr_loc = trfloc
          b_tr_qty_loc = trqty
          b_tr_date = trdate
          b_tr_time = trtime.
END.

