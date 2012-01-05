/*V8:ConvertMode=Report                                                       */

define {1} shared variable file_name as character format "x(50)".

DEFINE {1} shared TEMP-TABLE tmp-so
    FIELDS tso_nbr    LIKE so_nbr
    FIELDS tso_cust   LIKE so_cust
    FIELDS tso_bill   LIKE so_bill
    FIELDS tso_ship   LIKE so_ship
    FIELDS tso_req_date LIKE so_req_date
    FIELDS tso_due_date LIKE so_due_date
    FIELDS tso_rmks     LIKE so_rmks
    FIELDS tso_site     LIKE so_site
    FIELDS tso_curr     LIKE so_curr
    FIELDS tsod_line    LIKE sod_line
    FIELDS tsod_part    LIKE sod_part
    FIELDS tsod_site    LIKE sod_site
    FIELDS tsod_qty_ord LIKE sod_qty_ord
    FIELDS tsod_loc     LIKE sod_loc
    FIELDS tsod_acct    LIKE sod_acct
    FIELDS tsod_sub     LIKE sod_sub
    FIELDS tsod_due_date LIKE sod_due_date
    FIELDS tsod_rmks1    LIKE so_rmks
    FIELDS tsod_chk      AS   CHARACTER FORMAT "x(40)"
    INDEX tso_nbr IS PRIMARY tso_nbr tsod_line
    .
