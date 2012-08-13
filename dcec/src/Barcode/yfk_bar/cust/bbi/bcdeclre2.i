
DEF VAR success AS LOGICAL INITIAL  YES.
DEF VAR pass AS LOGICAL INITIAL YES.
DEFINE VARIABLE pname AS CHARACTER FORMAT "x(10)".  /*printer name*/

DEFINE {1} SHARED TEMP-TABLE t_co_mstr
    FIELD t_co_code LIKE b_co_code
    FIELD t_co_part LIKE b_co_part
    FIELD t_co_um LIKE b_co_um
    FIELD t_co_lot LIKE b_co_lot
    FIELD t_co_status LIKE b_co_status
    FIELD t_co_desc1 LIKE b_co_desc1
    FIELD t_co_desc2 LIKE b_co_desc2
    FIELD t_co_qty_ini LIKE b_co_qty_ini
    FIELD t_co_qty_cur LIKE b_co_qty_cur
    FIELD t_co_qty_std LIKE b_co_qty_std
    FIELD t_co_ser LIKE b_co_ser
    FIELD t_co_ref LIKE b_co_ref
    FIELD t_co_site LIKE b_co_site
    FIELD t_co_loc LIKE b_co_loc
    FIELD t_co_format LIKE b_co_format
    FIELD t_co_vcode LIKE b_co_vcode
    FIELD t_co_parcode LIKE b_co_parcode
    FIELD t_co_wolot LIKE b_co_wolot
    FIELD t_co_absid LIKE b_co_absid
    FIELD t_co_usrid LIKE b_co_usrid
    FIELD t_co_wodate LIKE b_co_wodate
    FIELD t_co_shift LIKE b_co_shift
    FIELD t_co_line AS CHARACTER
    FIELD t_co_date AS DATE
    FIELD t_co_woqty AS DECIMAL
    FIELD t_userid LIKE mfguser.
   





