/*V8:ConvertMode=FullGUIReport                                                */

define {1} shared variable v_ar_entity like ar_entity.
define {1} shared variable v_ar_bank like ar_bank.
define {1} shared variable v_ar_batch like ar_batch.
define {1} shared variable v_ar_bill like ar_bill.
define {1} shared variable v_name like ad_sort.
define {1} shared variable v_ar_nbr like ar_nbr.
define {1} shared variable v_ar_acct like ar_acct.
define {1} shared variable v_ar_sub like ar_sub.
define {1} shared variable v_ar_cc like ar_cc.
define {1} shared variable v_ard_acct like ar_acct.
define {1} shared variable v_ard_sub like ar_sub.
define {1} shared variable v_ard_cc like ar_cc.
define {1} shared variable v_ar_date like ar_date.
define {1} shared variable v_ar_effdate like ar_effdate.
define {1} shared variable v_ar_curr like ar_curr.
define {1} shared variable v_disp_curr as character format "x(1)"  label "C".
define {1} shared variable v_base_amt like ar_amt   format "->,>>>,>>>,>>9.99".
define {1} shared variable v_ex_rate_relation1 as character format "x(40)".
define {1} shared variable v_statl as character  format "x(8)" label "Status".
define {1} shared variable v_ar_due_date like ar_due_date.
define {1} shared variable v_base_curr like ar_curr.
define {1} shared variable v_artotal like ar_amt.

define {1} shared temp-table xxdm_det
       fields xxdm_ar_entity like ar_entity
       fields xxdm_ar_bank like ar_bank
       fields xxdm_ar_batch like ar_batch
       fields xxdm_ar_bill like ar_bill
       fields xxdm_name like ad_sort
       fields xxdm_ar_nbr like ar_nbr
       fields xxdm_ar_acct like ar_acct
       fields xxdm_ar_sub like ar_sub
       fields xxdm_ar_cc like ar_cc
       fields xxdm_ar_date like ar_date
       fields xxdm_ar_effdate like ar_effdate
       fields xxdm_ar_curr like ar_curr
       fields xxdm_disp_curr as character format "x(1)" label "C"
       fields xxdm_base_amt like ar_amt   format "->,>>>,>>>,>>9.99"
       fields xxdm_ex_rate_relation1 as character format "x(40)"
       fields xxem_statl as character  format "x(8)" label "Status"
       fields xxdm_ar_due_date like ar_due_date
       fields xxdm_ard_nbr like ard_nbr
       fields xxdm_ard_acct like ar_acct
       fields xxdm_ard_sub like ar_sub
       fields xxdm_ard_cc like ar_cc
       fields xxdm_base_open like ar_amt format "->,>>>,>>>,>>9.99"
              label "Open Amount"
       fields xxdm_base_damt like ard_amt
       fields xxdm_base_disc like ard_disc format "->,>>>,>>>,>>9.99"
       fields xxdm_det_curr like ar_curr
       fields xxdm_base_curr like ar_curr
       fields xxdm_artotal like ar_amt   format "->,>>>,>>>,>>9.99"
       fields xxdm_ex_rate_relation2 as character format "x(40)"
       .
