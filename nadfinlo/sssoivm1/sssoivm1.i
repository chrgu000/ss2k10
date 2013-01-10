/* sssoivm1.i - procedureDesc                                                */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */

define {1} shared variable xxrqmnbr like xxrqm_nbr.
define {1} shared variable xxrqmsite  like xxrqm_site.
define {1} shared variable xxrqmcust  like xxrqm_cust.
define {1} shared variable xxrqmrqby_userid like xxrqm_rqby_userid.
define {1} shared variable xxrqmreq_date like xxrqm_req_date.
define {1} shared variable xxrqmtax_in like xxrqm_tax_in.
DEFINE {1} SHARED FRAME match_maintenance .
DEFINE {1} SHARED FRAME w.


DEFINE {1} SHARED TEMP-TABLE tt1
   FIELD tt1_stat     as character format "x(1)"
   FIELD tt1_shipfrom LIKE ABS_shipfrom
   FIELD tt1_id LIKE ABS_id FORMAT "x(58)"
   FIELD tt1_disp_id like abs_id label "»õÔËµ¥ºÅ" FORMAT "x(58)"
   FIELD tt1_par_id LIKE ABS_par_id
   FIELD tt1_shipto         LIKE ABS_shipto
   FIELD tt1_order        AS CHAR FORMAT "x(8)"
   FIELD tt1_po           LIKE so_po
   FIELD tt1_line     LIKE ABS_line FORMAT "x(3)"
   FIELD tt1_item     AS CHAR FORMAT "x(18)"
   FIELD tt1_cust_part LIKE cp_cust_part
   FIELD tt1_desc1        like pt_desc1
   FIELD tt1_desc2        like pt_desc2
   FIELD tt1_um           AS CHAR FORMAT "x(2)"
   FIELD tt1_ship_qty AS DECIMAL FORMAT "->,>>>,>>9.99"
   FIELD tt1_qty_inv AS DECIMAL FORMAT "->,>>>,>>9.9<<<<<<<"
   FIELD tt1_price LIKE sod_price
   FIELD tt1_close_abs AS LOGICAL
   FIELD tt1_type LIKE sod_type
   FIELD tt1_new  AS LOGICAL INITIAL YES
   FIELD tt1_ord_date LIKE so_ord_date
   FIELD tt1__qad02 LIKE ABS__qad02
   FIELD tt1_conv AS DECIMAL INITIAL 1
   INDEX tt1_disp_id tt1_disp_id
   INDEX tt1_id tt1_id
   INDEX tt1_stat tt1_stat
   INDEX tt1_par_id_line tt1_par_id tt1_line
   INDEX tt1_shipfrom_id tt1_shipfrom tt1_id
   .

FORM
   tt1_disp_id COLON 18
   pt_desc1 COLON 18
   pt_desc2 NO-LABEL
   tt1_po COLON 18
   tt1_ship_qty COLON 18
   tt1_cust_part COLON 58 FORMAT "x(18)"
   tt1_qty_inv COLON 18 FORMAT "->,>>>,>>9.99999"
   tt1_close_abs COLON 48 LABEL "Closed"
   tt1_type COLON 72
   with frame match_maintenance side-labels title color
   normal (getFrameTitle("SHIPPER_MATCHING_MAINTENANCE",41))
   width 80 no-attr-space.
setFrameLabels(frame match_maintenance:handle).

form
   tt1_disp_id
   tt1_qty_inv
   with frame w scroll 1 4 down NO-VALIDATE ATTR-SPACE TITLE COLOR
   normal (getFrameTitle("SHIPPER_MATCHING_DETAIL",34)) WIDTH 80.
setFrameLabels(frame w:handle).
