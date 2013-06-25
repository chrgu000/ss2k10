      
      {mfdeclre.i}
      {cxcustom.i "SSBIGL05GLTR.P"}
      {gplabel.i} /* EXTERNAL LABEL INCLUDE */

      {ssapckrp0001.i}
      {ssbiap07a.i}

      define shared variable ttssapckrp0001_recno  as recid         no-undo.
      define shared variable line_tt1  as INTEGER         no-undo.

      FOR FIRST ttssapckrp0001 NO-LOCK WHERE 
         RECID(ttssapckrp0001) = ttssapckrp0001_recno
         ,EACH ac_mstr NO-LOCK
         WHERE ac_domain = global_domain
         AND ac_code = ttssapckrp0001_ap_acct
         AND INDEX("ALIE",ac_type) > 0
         ,EACH sb_mstr NO-LOCK
         WHERE sb_domain = global_domain
         AND sb_sub = ttssapckrp0001_ap_sub
         ,EACH cc_mstr NO-LOCK
         WHERE cc_domain = global_domain
         AND cc_ctr = ttssapckrp0001_ap_cc
         :

         /* line */
         CREATE tt1.
         ASSIGN
            tt1_ref = ttssapckrp0001_ck_ref 
            tt1_line = LINE_tt1
            tt1_effdate = STRING(YEAR(ttssapckrp0001_ap_effdate)) + "." +  STRING(MONTH(ttssapckrp0001_ap_effdate)) + "." +  STRING(DAY(ttssapckrp0001_ap_effdate))
            tt1_ascp  = ac_code
            tt1_as_desc = ac_desc
            .

         FIND FIRST ap_mstr WHERE ap_domain = GLOBAL_domain AND ap_type = "CK" AND ap_ref = ttssapckrp0001_ck_ref NO-LOCK NO-ERROR.
         IF AVAILABLE ap_mstr THEN DO:
            ASSIGN
               tt1_desc = ap_rmk.
               .
         END.
                                                 
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
            tt1_cr_amt = ttssapckrp0001_base_disp_amt
            .
               
         IF ac_curr <> base_curr THEN DO:
            ASSIGN
               tt1_curramt = ABS(ttssapckrp0001_disp_amt)
               tt1_ex_rate = ac_curr + "»ã" + STRING(ttssapckrp0001_ap_ex_rate2 / ttssapckrp0001_ap_ex_rate ) 
               .
         END.
      END. /* for each ttssapckrp0001 */

