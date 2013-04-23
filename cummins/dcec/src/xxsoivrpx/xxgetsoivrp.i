/* xxgetsoivrp.i - temp-table for soivrp                                     */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120713.1 LAST MODIFIED: 07/13/12 BY: zy                         */
/* REVISION END                                                              */

define {1} shared variable v36_so_invnbr      like so_inv_nbr.
define {1} shared variable v36_so_bill        like so_bill.
define {1} shared variable v36_so_bill_name   like ad_name.
define {1} shared variable v36_so_cust        like so_cust.
define {1} shared variable v36_so_cust_name   like ad_name.
define {1} shared variable v36_so_slspsn      like so_slspsn[1].
define {1} shared variable v36_so_ar_acct     like so_ar_acct.
define {1} shared variable v36_so_ar_sub      like so_ar_sub.
define {1} shared variable v36_so_ar_cc       like so_ar_cc.
define {1} shared variable v36_so_tax_env     like so_tax_env.
define {1} shared variable v36_so_tax_usage   like so_tax_usage.
define {1} shared variable v36_so_nbr         like so_nbr.
define {1} shared variable v36_so_ship        like so_ship.
define {1} shared variable v36_ship_name      like ad_name.
define {1} shared variable v36_so_ord_date    like so_ord_date.
define {1} shared variable v36_so_po          like so_po.

define {1} shared temp-table tmp-soivdet36
       fields t36_so_invnbr      like so_inv_nbr
       fields t36_so_bill        like so_bill
       fields t36_so_bill_name   like ad_name
       fields t36_so_cust        like so_cust
       fields t36_so_cust_name   like ad_name
       fields t36_so_slspsn      like so_slspsn[1]
       fields t36_so_ar_acct     like so_ar_acct
       fields t36_so_ar_sub      like so_ar_sub
       fields t36_so_ar_cc       like so_ar_cc
       fields t36_so_tax_env     like so_tax_env
       fields t36_so_tax_usage   like so_tax_usage
       fields t36_so_nbr         like so_nbr
       fields t36_so_ship        like so_ship
       fields t36_ship_name      like ad_name
       fields t36_so_ord_date    like so_ord_date
       fields t36_so_po          like so_po
       fields t36_sod_line       like sod_line
       fields t36_sod_part       like sod_part
       fields t36_sod_desc1      like pt_desc1
       fields t36_sod_um         like sod_um
       fields t36_sod_acct       like sod_acct
       fields t36_sod_sub        like sod_sub
       fields t36_sod_cc         like sod_cc
       fields t36_sod_qty_inv    like sod_qty_inv
       fields t36_sod_type       like sod_type
       fields t36_sod_tax_in     like sod_tax_in
       fields t36_sod_taxable    like sod_taxable
       fields t36_sod_taxc       like sod_taxc
       fields t36_sod_tax_usage  like sod_tax_usage
       fields t36_sod_tax_env    like sod_tax_env
       fields t36_net_price      like sod_price
       fields t36_ext_price      like sod_price
       fields t36_ext_gr_margin  like sod_price
       .
