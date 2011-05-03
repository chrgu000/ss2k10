/* 以下为版本历史 */                                                             
/* SS - 090511.1 By: Bill Jiang */
/* ss - 091116.1 by: jack */
/* ss - 091125.1 by: jack */

/* 共享 */

DEFINE {1} SHARED VARIABLE char1 AS CHARACTER EXTENT 10.
DEFINE {1} SHARED VARIABLE qty_effdate AS DECIMAL EXTENT 10.
DEFINE {1} SHARED VARIABLE qty_part AS DECIMAL EXTENT 10.
DEFINE {1} SHARED VARIABLE amt_part AS DECIMAL EXTENT 10.
DEFINE {1} SHARED VARIABLE amt_tot AS DECIMAL EXTENT 10.
DEFINE {1} SHARED VARIABLE line1 AS INTEGER EXTENT 10.

DEFINE {1} SHARED TEMP-TABLE tta
   FIELD tta_inv LIKE rqd_part
   FIELD tta_part LIKE tr_part
   FIELD tta_effdate LIKE tr_effdate
   FIELD tta_qty LIKE tr_qty_loc
   .

DEFINE {1} SHARED TEMP-TABLE ttb
   FIELD ttb_inv LIKE rqd_part
   FIELD ttb_part LIKE tr_part
   FIELD ttb_qty LIKE tr_qty_loc
   FIELD ttb_amt LIKE tr_qty_loc
   FIELD ttb_custpart LIKE idh_custpart
   FIELD ttb_um LIKE idh_um
    /* ss - 091116.1 -b */
    FIELD ttb_inv_amt LIKE tr_qty_loc
    FIELD ttb_list_price LIKE xxpi_list_price
    FIELD ttb_tax_usage LIKE ih_tax_usage
      /* ss - 091116.1 -e */
   /* ss - 091125.1 -b */
    FIELD ttb_effdate LIKE tr_effdate
    FIELD ttb_cust LIKE tr_addr
    FIELD ttb_tax_amt LIKE tr_qty_loc
    FIELD ttb_tax LIKE tr_qty_loc
    FIELD ttb_curr LIKE tr_curr
    /* ss - 091125.1 -e */
   .

DEFINE {1} SHARED TEMP-TABLE tt1
   FIELD tt1_inv LIKE rqd_part
   FIELD tt1_part LIKE tr_part
   FIELD tt1_effdate LIKE tr_effdate
   FIELD tt1_qty LIKE tr_qty_loc
   .

DEFINE {1} SHARED TEMP-TABLE tt2
   FIELD tt2_inv LIKE rqd_part
   FIELD tt2_part LIKE tr_part
   FIELD tt2_qty LIKE tr_qty_loc
   FIELD tt2_amt LIKE tr_qty_loc
   FIELD tt2_custpart LIKE idh_custpart
   FIELD tt2_um LIKE idh_um
    /* ss - 091116.1 -b */
    FIELD tt2_inv_amt LIKE tr_qty_loc
    FIELD tt2_list_price LIKE xxpi_list_price
    FIELD tt2_tax_usage LIKE ih_tax_usage
      /* ss - 091116.1 -e */
   .

DEFINE {1} SHARED TEMP-TABLE tt3
   FIELD tt3_effdate LIKE tr_effdate
   .

define {1} SHARED variable rndmthd like rnd_rnd_mthd.
define {1} SHARED variable oldcurr like ih_curr.
/*CHANGED ALL LOCAL VARIABLES TO {1} SHARED FOR soivrp09a.p */
define {1} SHARED variable cust like ih_cust.
define {1} SHARED variable cust1 like ih_cust.
define {1} SHARED variable inv like ih_inv_nbr.
define {1} SHARED variable inv1 like ih_inv_nbr.
define {1} SHARED variable nbr like ih_nbr.
define {1} SHARED variable nbr1 like ih_nbr.
define {1} SHARED variable name like ad_name.
define {1} SHARED variable spsn like sp_addr.
define {1} SHARED variable spsn1 like spsn.
define {1} SHARED variable po like ih_po.
define {1} SHARED variable po1 like ih_po.
define {1} SHARED variable gr_margin like idh_price /* label {&soivrp09_p_5} */
   format "->>>>>,>>9.99".
define {1} SHARED variable ext_price like idh_price /* label {&soivrp09_p_2} */
   format "->>,>>>,>>>.99".
define {1} SHARED variable ext_gr_margin like gr_margin
   /* label {&soivrp09_p_1} */.
define {1} SHARED variable desc1 like pt_desc1 format "x(49)".
define {1} SHARED variable curr_cost like idh_std_cost.
define {1} SHARED variable base_price like ext_price.
define {1} SHARED variable base_margin like ext_gr_margin.
define {1} SHARED variable ext_cost like idh_std_cost.
define {1} SHARED variable base_rpt like ih_curr.
define {1} SHARED variable disp_curr as character
   format "x(1)" label "C".
define {1} SHARED variable ih_recno as recid.
define {1} SHARED variable tot_trl1 like ih_trl1_amt.
define {1} SHARED variable tot_trl3 like ih_trl3_amt.
define {1} SHARED variable tot_trl2 like ih_trl2_amt.
define {1} SHARED variable tot_disc like ih_trl1_amt /* label {&soivrp09_p_3} */.
define {1} SHARED variable rpt_tot_tax like ih_trl2_amt
   /* label {&soivrp09_p_6} */.
define {1} SHARED variable tot_ord_amt like ih_trl3_amt /* label {&soivrp09_p_4}*/.
define {1} SHARED variable net_price like idh_price.
define {1} SHARED variable base_net_price like net_price
                                 format "->>>>,>>>,>>9.99".
define {1} SHARED variable detail_lines like mfc_logical.
define {1} SHARED variable bill  like ih_bill.
define {1} SHARED variable bill1 like ih_bill.
define variable maint like mfc_logical.

/* SS - 20070726.1 - B */
DEFINE {1} SHARED VARIABLE entity LIKE gltr_entity.
DEFINE {1} SHARED VARIABLE entity1 LIKE gltr_entity.
DEFINE {1} SHARED VARIABLE eff_dt LIKE gltr_eff_dt.
DEFINE {1} SHARED VARIABLE eff_dt1 LIKE gltr_eff_dt.
DEFINE {1} SHARED VARIABLE inv_date LIKE ih_inv_date.
DEFINE {1} SHARED VARIABLE inv_date1 LIKE ih_inv_date.

DEFINE {1} SHARED VARIABLE part_type_pt LIKE pt_part_type.
DEFINE {1} SHARED VARIABLE draw_pt LIKE pt_draw.
define {1} SHARED variable summary_only like mfc_logical
   label "Summary/Detail" format "Summary/Detail" initial no.
DEFINE {1} SHARED VARIABLE UPDATE_yn LIKE mfc_logical.
/* SS - 20070726.1 - E */
