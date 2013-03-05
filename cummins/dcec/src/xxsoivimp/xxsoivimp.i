/*V8:ConvertMode=Report                                                       */
/* jordan 21030227.1 增加单价 */
define {1} shared variable file_name as character format "x(50)".
define {1} shared variable vcurr like so_curr.
DEFINE {1} shared TEMP-TABLE tmp-so
    FIELDS tso_nbr    LIKE so_nbr
    FIELDS tso_cust   LIKE so_cust
    FIELDS tso_bill   LIKE so_bill
    FIELDS tso_ship   LIKE so_ship
    FIELDS tso_ord_date LIKE so_ord_date
/*  FIELDS tso_req_date LIKE so_req_date           */
/*  FIELDS tso_due_date LIKE so_due_date           */
    FIELDS tso_rmks     LIKE so_rmks
    FIELDS tso_site     LIKE so_site
    FIELDS tso_channel  LIKE so_channel
    FIELDS tso_tax_usage LIKE so_tax_usage
/*  FIELDS tso_curr     LIKE so_curr               */
    FIELDS tsod_line    LIKE sod_line
    FIELDS tsod_part    LIKE sod_part
    FIELDS tsod_site    LIKE sod_site
    FIELDS tsod_qty_ord LIKE sod_qty_ord
/*  FIELDS tsod_loc     LIKE sod_loc                */
    FIELDS tsod_acct    LIKE sod_acct
    FIELDS tsod_sub     LIKE sod_sub
    FIELDS tsod_cc      LIKE sod_cc
    FIELDS tsod_project LIKE sod_project
/*  FIELDS tsod_due_date LIKE sod_due_date          */
/*  FIELDS tsod_type    LIKE sod_type initial "M"   */
    FIELDS tsod_rmks1    LIKE so_rmks
    FIELDS tsod_pr   like sod_list_pr
    FIELDS tsod_inv_nbr   like so_inv_nbr
    FIELDS tsod_chk      AS   CHARACTER FORMAT "x(40)"
    INDEX tso_nbr IS PRIMARY tso_nbr tsod_line
    .
