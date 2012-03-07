/*V8:ConvertMode=Report                                                      */
DEFINE {1} SHARED TEMP-TABLE tmpap
   FIELDS ta_ap_vend LIKE ap_vend
   FIELDS ta_ap_effdate LIKE ap_effdate
   FIELDS ta_ap_date LIKE ap_date
   FIELDS ta_ap_ref LIKE ap_ref
   FIELDS ta_ap_curr LIKE ap_curr
   FIELDS ta_ap_amt LIKE ap_amt
   FIELDS ta_ap_base_amt LIKE ap_base_amt
   FIELDS ta_ap_acct LIKE ap_acct
   FIELDS ta_ap_sub LIKE ap_sub
   FIELDS ta_ap_cc LIKE ap_cc
   FIELDS ta_ap_type LIKE ap_type
   FIELDS ta_vo_type like vo_type
   FIELDS ta_vo_invoice LIKE vo_invoice
   FIELDS ta_vo_due_date LIKE vo_due_date
   FIELDS ta_ck_nbr as character
   INDEX ta_ap_vend ta_ap_vend
   .
 