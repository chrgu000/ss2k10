

DEFINE INPUT PARAMETER nbr AS CHARACTER.
DEFINE INPUT PARAMETER nline AS INTEGER.

DEFINE INPUT PARAMETER ncode AS CHARACTER.
DEFINE INPUT PARAMETER part AS CHARACTER.
DEFINE INPUT PARAMETER lot AS CHARACTER.
DEFINE INPUT PARAMETER ser AS INTEGER.

DEFINE INPUT PARAMETER qty AS DECIMAL.
DEFINE INPUT PARAMETER um AS CHARACTER.

DEFINE INPUT PARAMETER enterdate AS DATE.
DEFINE INPUT PARAMETER trdate AS DATE.
DEFINE INPUT PARAMETER effdate AS DATE.
DEFINE INPUT PARAMETER trtype AS CHARACTER.

DEFINE INPUT PARAMETER trnbr AS INTEGER.

DEFINE INPUT PARAMETER ntime AS INTEGER.
DEFINE INPUT PARAMETER loc AS CHARACTER.
DEFINE INPUT PARAMETER site AS CHARACTER.
DEFINE INPUT PARAMETER program AS CHARACTER.
DEFINE INPUT PARAMETER tosite AS CHARACTER.
DEFINE INPUT PARAMETER toloc AS CHARACTER.
DEFINE INPUT PARAMETER tolot AS CHARACTER.
DEFINE INPUT PARAMETER toser AS INTEGER.

DEFINE INPUT PARAMETER tocim AS LOGICAL.
DEFINE INPUT PARAMETER sess AS CHARACTER.
DEFINE INPUT PARAMETER ref AS CHARACTER.

DEFINE INPUT PARAMETER b_trid1 LIKE b_tr_id.
DEFINE INPUT PARAMETER b_trid2 LIKE b_tr_id.
DEFINE INPUT PARAMETER bc01 AS CHARACTER.
DEFINE INPUT PARAMETER bc02 AS CHARACTER.
DEFINE INPUT PARAMETER bc03 AS CHARACTER.
DEFINE INPUT PARAMETER bc04 AS CHARACTER.
DEFINE INPUT PARAMETER bc05 AS CHARACTER.

DEFINE INPUT PARAMETER emp AS CHARACTER.

DEFINE INPUT PARAMETER par_id AS INTEGER.
DEFINE INPUT PARAMETER dataset AS CHARACTER.
DEFINE INPUT PARAMETER absid LIKE ABS_id.

DEFINE OUTPUT PARAMETER id AS INTEGER.

IF par_id = 0 THEN DO:
  /*  SELECT MAX(b_bf_id) INTO id FROM b_bf_det.
    IF id NE ? THEN DO: 
        id= id + 1.
    END.
    ELSE do:
        id = 1.
    END.*/
    ID = NEXT-VALUE(BF_SEQ01).
    IF id  = ? THEN DO:
      MESSAGE 'bf_seq01”√æ°,«Î≥ı ºªØ!' VIEW-AS ALERT-BOX  ERROR.
      QUIT.
END.
END.
ELSE id = par_id.

CREATE b_bf_det.
ASSIGN
    b_bf_id = id
    b_bf_nbr = nbr
    b_bf_line = nline
    b_bf_code = ncode
    b_bf_part = part
    b_bf_lot  = lot
    b_bf_ser = ser
    b_bf_ref = ref
    b_bf_qty_loc = qty
    b_bf_um = um
    b_bf_date = enterdate
    b_bf_tr_date = trdate
    b_bf_eff_date =effdate
    b_bf_type = trtype
    b_bf_time = ntime
    b_bf_loc = loc
    b_bf_site = site
    b_bf_program = program
    b_bf_tosite = tosite
    b_bf_toloc = toloc
    b_bf_tolot = tolot
    b_bf_toser = toser
    b_bf_tocim = YES
    b_bf_sess ="" /* GLOBAL_usreid*/
    b_bf_bc01 = bc01
    b_bf_bc02 = bc02
    b_bf_bc03 = bc03
    b_bf_bc04 = bc04
    b_bf_bc05 = bc05
    b_bf_btrid1 = b_trid1
    b_bf_btrid2 = b_trid2
    b_bf_employee = emp 
    b_bf_par_id = par_id
    b_bf_dataset = dataset
    b_bf_abs_id = absid.




