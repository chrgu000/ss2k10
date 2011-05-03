Define variable Eoutputstatment AS CHARACTER FORMAT "x(200)". 
Define variable Eonetime        AS CHARACTER FORMAT "x(1)" init "N".
Define variable outputstatment AS CHARACTER FORMAT "x(200)".
Define variable woutputstatment AS CHARACTER .
DEF VAR fn_me AS CHAR FORMAT "x(30)" .
def var v9000 as char.

def var site like si_site init "gsa01".
def var site1 like   si_site init "gsa01".
def var vend like  po_vend  .
def var vend1 like    po_vend  .
def var shipno like xx_ship_no  .
def var shipno1 like xx_ship_no  .
def var shipline like xx_ship_line init 0.
def var shipline1 like xx_ship_line init 9999.
def var rcvddate like tr_effdate init today.
def var tmpstr as char.
define variable usection as char format "x(16)".
def var tmpmonth as char.
def var j as integer.
def var i as integer.
def var datestr as char.
def var glbasecurr like gl_base_curr.
DEF VAR v_flag AS LOGICAL.
def buffer poms for po_mstr.
def buffer pomst for po_mstr.
def var tstr as char.
def var tstr1 as char.
def var errstr as char.
def var ciminputfile  as char.
def var cimoutputfile as char.
def var tmp_order_qty like tr_qty_loc.
def var tmp_lot as char.
def var tmp_cost like tr_qty_loc.
def var tmp_fix_rate as char.
def var tmp_loc like pt_loc.
def var tmp_qty like tr_qty_loc.
def var tmp_part like pt_part.
def var tmp_flagt like pt_part.
def var tmp_line like pod_line.
def buffer podde for pod_det.
def var  curr like  po_curr.

/* 取得xx_inv_mstr 和 xx_ship_det中的原始资料 */
DEF TEMP-TABLE pott 
    FIELD pott_shipno LIKE xx_ship_no
    FIELD pott_site LIKE xx_inv_site
    FIELD pott_vend LIKE xx_inv_vend
    FIELD pott_case like xx_ship_case
    FIELD pott_part_vend LIKE xx_ship_part
    FIELD pott_pkg LIKE xx_ship_pkg
    FIELD pott_qty_unit like xx_ship_qty_unit
    FIELD pott_qty like xx_ship_qty
    FIELD pott_status like xx_ship_status
    FIELD pott_price like xx_ship_price
    FIELD pott_value like xx_ship_value
    FIELD pott_curr like xx_ship_curr
    FIELD pott_duedate like tr_effdate
    FIELD pott_etadate like tr_effdate
    FIELD pott_line like xx_ship_line
    FIELD pott_part_zh like xx_ship_part
    field pott_loc like pt_loc
    field pott_lot like tr_serial
    field pott_ponbr like po_nbr
    FIELD pott_poline like xx_ship_line
    field pott_fix_rate as char
    field pott_qty_open like pod_qty_ord
    field pott_flag as char
    field pott_CIMQTY like pod_qty_ord
    field pott_add_CIMQTY like pod_qty_ord
    field pott_addpo like pod_nbr
    field pott_order_type like xx_ship_type
    field pott_rate like xx_inv_rate
    field pott_cost like xx_ship_price
    field pott_loadOKqty like pod_qty_ord
    
    .

/* 在进行CIMLOAD之前，先显示要处理的数据 */
DEF TEMP-TABLE  tt1a
    field   tt1a_nbr like po_nbr
    field   tt1a_curr like po_curr
    field   tt1a_line like pod_line
    field   tt1a_vend like po_vend
    field   tt1a_fix_rate  as char
    field   tt1a_openqty like pod_qty_ord
    field   tt1a_part like pod_part
    field   tt1a_site like pod_site
    field   tt1a_lot like tr_serial
    field   tt1a_loc like pt_loc
    field   tt1a_flag as char
    field   tt1a_shipno like xx_ship_no
    field   tt1a_rmks like pt_desc1
    field   tt1a_vendpart like pt_part
    field   tt1a_shipline like xx_ship_line
     
.
DEF TEMP-TABLE  tt2
    field   tt2_nbr like po_nbr.

/* 存放错误信息的资料 */
DEF TEMP-TABLE tte 
    FIELD tte_type1 AS CHAR
    FIELD tte_type AS CHAR
    FIELD tte_vend LIKE po_vend
    FIELD tte_part LIKE pt_part
    FIELD tte_desc AS CHAR FORMAT "x(120)".
