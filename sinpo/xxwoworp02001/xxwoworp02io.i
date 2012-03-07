/*V8:ConvertMode=Report                                                       */
define {1} shared temp-table xxwoworp02wr
       fields xx_wr_wo_lot like wo_lot
       fields xx_wr_desc1  like pt_desc1
       fields xx_wr_rcpt_userid as character
       fields xx_wr_rcpt_date as date
       fields xx_wr_op like wr_op
       fields xx_wr_std_op like wr_std_op
       fields xx_wr_desc like wr_desc
       fields xx_wr_wkctr like wr_wkctr
       fields xx_wr_start like wr_start
       fields xx_wr_due like wr_due
       fields xx_wr_setup like wr_setup
       fields xx_wr_runtime like wr_run
       fields xx_wr_open_ref like wo_qty_ord  label "Qty Open"
       fields xx_wr_op_status as character
       fields xx_wr_wc_desc like wc_desc.

define {1} shared temp-table xxwoworp02wod
       fields xx_wod_lot like wo_lot
       fields xx_wod_desc1  like pt_desc1
       fields xx_wod_rcpt_userid as character
       fields xx_wod_rcpt_date as date
       fields xx_wod_part like wod_part
       fields xx_wod_qty_req like wod_qty_req
       fields xx_wod_qty_all like wod_qty_all
       fields xx_wod_qty_pick like wod_qty_pick
       fields xx_wod_qty_iss like wod_qty_iss
       fields xx_wod_open_ref like wo_qty_ord label "Qty Open"
       fields xx_wod_iss_date like wod_iss_date
       fields xx_wod_deliver like wod_deliver
       fields xx_wod_pt_desc like pt_desc1.
