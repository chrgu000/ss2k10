/* xxarrp01.i - xxarrp01 report parameter file                               */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 121201.1 LAST MODIFIED: 12/01/12 BY: zy                         */
/* REVISION END                                                              */

/* Detail Table */
define {1} shared temp-table tab0
    fields t0_type like ard_sub
    fields t0_dept like ard_cc
    fields t0_cust like ar_bill
    fields t0_eff  like ar_effdate
    fields t0_pa_amt like ar_amt
    fields t0_dm_amt like ar_amt
    fields t0_dr_amt like ar_amt
    fields t0_tx_amt like ar_amt.

/* Summary table*/
define {1} shared temp-table tab1
    fields t1_type like ard_sub
    fields t1_dept like ard_cc
    fields t1_cust like ar_bill
    fields t1_pa_amt like ar_amt
    fields t1_pa_amtm like ar_amt
    fields t1_pa_amty like ar_amt
    fields t1_dm_amt like ar_amt
    fields t1_dm_amtm like ar_amt
    fields t1_dm_amty like ar_amt
    fields t1_dr_amt like ar_amt
    fields t1_dr_amtm like ar_amt
    fields t1_dr_amty like ar_amt
    fields t1_tx_amt like ar_amt
    fields t1_tx_amtm like ar_amt
    fields t1_tx_amty like ar_amt
    index idx1 is primary t1_type t1_dept t1_cust.
