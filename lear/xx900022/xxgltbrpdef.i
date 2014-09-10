/* xxgltbrpdef.i - GENERAL LEDGER TRIAL BALANCE REPORT (PART II)             */
/*V8:ConvertMode=Report                                                      */

define {1} shared temp-table tmp88
    fields t88_acct like asc_acc
    fields t88_sub  like asc_sub
    fields t88_cc   like asc_cc
    fields t88_account as char format "x(22)"
    fields t88_desc like cc_desc
    fields t88_beg as decimal format "->>>,>>>,>>>,>>9.99"
    fields t88_per as decimal format "->>>,>>>,>>>,>>9.99"
    fields t88_ups as decimal format "->>>,>>>,>>>,>>9.99"
    fields t88_end as decimal format "->>>,>>>,>>>,>>9.99".

DEFINE {1} SHARED TEMP-TABLE ttxxglutrrp001
   field ttxxglutrrp001_glt_ref like glt_det.glt_ref
   field ttxxglutrrp001_glt_date like glt_det.glt_date
   field ttxxglutrrp001_glt_userid like glt_det.glt_userid
   field ttxxglutrrp001_glt_effdate like glt_det.glt_effdate
   field ttxxglutrrp001_glt_line like glt_det.glt_line
   field ttxxglutrrp001_glt_acc like glt_det.glt_acc
   field ttxxglutrrp001_glt_sub like glt_det.glt_sub
   field ttxxglutrrp001_glt_cc like glt_det.glt_cc
   field ttxxglutrrp001_glt_project like glt_det.glt_project
   field ttxxglutrrp001_glt_entity like glt_det.glt_entity
   field ttxxglutrrp001_glt_desc like glt_det.glt_desc
   field ttxxglutrrp001_glt_amt like glt_det.glt_amt
   field ttxxglutrrp001_glt_curr like glt_det.glt_curr
   field ttxxglutrrp001_glt_dy_code like glt_det.glt_dy_code
   field ttxxglutrrp001_glt_error like glt_det.glt_error
   field ttxxglutrrp001_glt_dy_num like glt_det.glt_dy_num
   field ttxxglutrrp001_glt_unb like glt_det.glt_unb
   .