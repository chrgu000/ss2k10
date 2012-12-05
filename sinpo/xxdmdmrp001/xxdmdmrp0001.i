/* xxdmdmrp0001.i - xxdmdmrp0001.p Variable define                           */
/*V8:ConvertMode=FullGUIReport                                               */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120713.1 LAST MODIFIED: 07/13/12 BY: zy                         */
/* REVISION END                                                              */

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

define {1} shared temp-table ttssdmdmrp0001_det
       fields ttssdmdmrp0001_ar_entity like ar_entity
       fields ttssdmdmrp0001_ar_bank like ar_bank
       fields ttssdmdmrp0001_ar_batch like ar_batch
       fields ttssdmdmrp0001_ar_bill like ar_bill
       fields ttssdmdmrp0001_name like ad_sort
       fields ttssdmdmrp0001_ar_nbr like ar_nbr
       fields ttssdmdmrp0001_ar_acct like ar_acct
       fields ttssdmdmrp0001_ar_sub like ar_sub
       fields ttssdmdmrp0001_ar_cc like ar_cc
       fields ttssdmdmrp0001_ar_date like ar_date
       fields ttssdmdmrp0001_ar_effdate like ar_effdate
       fields ttssdmdmrp0001_ar_curr like ar_curr
       fields ttssdmdmrp0001_disp_curr as character format "x(1)" label "C"
       fields ttssdmdmrp0001_base_amt like ar_amt   format "->,>>>,>>>,>>9.99"
       fields ttssdmdmrp0001_ex_rate_relation1 as character format "x(40)"
       fields ttssdmdmrp0001_statl as character  format "x(8)" label "Status"
       fields ttssdmdmrp0001_ar_due_date like ar_due_date
       fields ttssdmdmrp0001_ard_nbr like ard_nbr
       fields ttssdmdmrp0001_ard_acct like ar_acct
       fields ttssdmdmrp0001_ard_sub like ar_sub
       fields ttssdmdmrp0001_ard_cc like ar_cc
       fields ttssdmdmrp0001_base_open like ar_amt format "->,>>>,>>>,>>9.99"
              label "Open Amount"
       fields ttssdmdmrp0001_base_damt like ard_amt
       fields ttssdmdmrp0001_base_disc like ard_disc format "->,>>>,>>>,>>9.99"
       fields ttssdmdmrp0001_det_curr like ar_curr
       fields ttssdmdmrp0001_base_curr like ar_curr
       fields ttssdmdmrp0001_artotal like ar_amt   format "->,>>>,>>>,>>9.99"
       fields ttssdmdmrp0001_ex_rate_relation2 as character format "x(40)"
       .
