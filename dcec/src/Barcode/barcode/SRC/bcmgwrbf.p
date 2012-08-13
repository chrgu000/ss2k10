{mfdeclre.i}
{gplabel.i}

DEFINE INPUT PARAMETER nbr AS CHARACTER.
DEFINE INPUT PARAMETER nline AS INTEGER.
DEFINE INPUT PARAMETER ncode AS CHARACTER.
DEFINE INPUT PARAMETER part AS CHARACTER.
DEFINE INPUT PARAMETER lot AS CHARACTER.
DEFINE INPUT PARAMETER ser AS INTEGER.
DEF INPUT PARAMETER ref AS CHAR.
DEFINE INPUT PARAMETER qty AS DECIMAL.
DEFINE INPUT PARAMETER um AS CHARACTER.
DEFINE INPUT PARAMETER enterdate AS DATE.
DEFINE INPUT PARAMETER trdate AS DATE.
DEFINE INPUT PARAMETER effdate AS DATE.
DEFINE INPUT PARAMETER trtype AS CHARACTER.
DEFINE INPUT PARAMETER ntime AS INTEGER.
DEFINE INPUT PARAMETER loc AS CHARACTER.
DEFINE INPUT PARAMETER site AS CHARACTER.
DEFINE INPUT PARAMETER program AS CHARACTER.
DEFINE INPUT PARAMETER tosite AS CHARACTER.
DEFINE INPUT PARAMETER toloc AS CHARACTER.
DEFINE INPUT PARAMETER tolot AS CHARACTER.
DEFINE INPUT PARAMETER toser AS INTEGER.
DEF INPUT PARAMETER bc01 AS CHAR.
DEF INPUT PARAMETER bc02 AS CHAR.
DEF INPUT PARAMETER bc03 AS CHAR.
DEF INPUT PARAMETER bc04 AS CHAR.
DEF INPUT PARAMETER bc05 AS CHAR.
DEF INPUT PARAMETER b_trid1 LIKE b_tr_id.
DEF INPUT PARAMETER b_trid2 LIKE b_tr_id.
DEFINE VARIABLE id AS INTEGER.

FIND LAST b_bf_det NO-LOCK NO-ERROR.
IF AVAILABLE b_bf_det THEN DO: 
    id= b_bf_id + 1.
END.
ELSE do:
    id = 1.
END.

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
    b_bf_sess = GLOBAL_usreid.
    b_bf_bc01 = bc01
    b_bf_bc02 = bc02
    b_bf_bc03 = bc03
    b_bf_bc04 = bc04
    b_bf_bc05 = bc05
        b_bf_btrid1 = b_trid1
        b_bf_btrid2 = b_trid2.



