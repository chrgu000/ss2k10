/* SS - 091120.1 By: Bill Jiang */

/* SS - 091120.1 - RNB
¶Ò»»ËðÒæ
SS - 091120.1 - RNE */
      
{mfdeclre.i}
{cxcustom.i "SSBIGL05GLTR.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{xxapckrp0001.i}
{xxcarap2a.i}

DEFINE INPUT-OUTPUT PARAMETER tot_dr_amt AS DECIMAL.

define shared variable ttxxapckrp0001_recno  as recid         no-undo.
define shared variable line_tt1  as INTEGER         no-undo.

FOR FIRST ttxxapckrp0001 NO-LOCK WHERE 
   RECID(ttxxapckrp0001) = ttxxapckrp0001_recno
   ,EACH ttxxapckrp0001a NO-LOCK
   WHERE ttxxapckrp0001a_ap_ref = ttxxapckrp0001_ck_ref
   AND ttxxapckrp0001a_rmks = "ap_gain"
   ,EACH ac_mstr NO-LOCK
   WHERE ac_code = ttxxapckrp0001a_acct
   AND INDEX("ALIE",ac_type) > 0
   ,EACH sb_mstr NO-LOCK
   WHERE sb_sub = ttxxapckrp0001a_sub
   ,EACH cc_mstr NO-LOCK
   WHERE cc_ctr = ttxxapckrp0001a_cc
   :

   /* SS - 091120.1 - B */
   LINE_tt1 = LINE_tt1 + 1.
   /* SS - 091120.1 - E */

   /* line */
   CREATE tt1.
   ASSIGN
      tt1_ref = ttxxapckrp0001_ck_ref 
      tt1_line = LINE_tt1
      tt1_effdate = STRING(YEAR(ttxxapckrp0001_ap_effdate)) + "." +  STRING(MONTH(ttxxapckrp0001_ap_effdate)) + "." +  STRING(DAY(ttxxapckrp0001_ap_effdate))
      tt1_desc = ttxxapckrp0001_ckd_type + ttxxapckrp0001_ckd_voucher
      tt1_ascp  = ac_code
      tt1_as_desc = ac_desc
      .
                                           
   {gprun.i ""ssGetInt"" "(
      INPUT tt1_line,
      INPUT 4,
      OUTPUT tt1_page
      )"}

   IF sb_sub <> "" THEN DO:
      ASSIGN
         tt1_ascp = tt1_ascp + "-" + sb_sub
         tt1_as_desc = tt1_as_desc + "-" + sb_desc
         .
   END.

   IF cc_ctr <> "" THEN DO:
      ASSIGN
         tt1_ascp = tt1_ascp + "-" + cc_ctr
         tt1_cp_desc = cc_desc
         .
   END.
    
   assign 
      tt1_dr_amt = ttxxapckrp0001a_amt
      .
         
   tot_dr_amt = tot_dr_amt + tt1_dr_amt.

   /*
   IF ac_curr <> base_curr THEN DO:
      ASSIGN
         tt1_curramt = ABS(ttxxapckrp0001_ckd_disc)
         tt1_ex_rate = ac_curr + "»ã" + STRING(ttxxapckrp0001_ap_ex_rate2 / ttxxapckrp0001_ap_ex_rate ) 
         .
   END.
   */
END. /* for each ttxxapckrp0001 */

