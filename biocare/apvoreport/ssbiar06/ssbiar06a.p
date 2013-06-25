      
      {mfdeclre.i}
      {cxcustom.i "SSBIGL05GLTR.P"}
      {gplabel.i} /* EXTERNAL LABEL INCLUDE */

      {ssardrrp0001.i}
      {ssbiar06a.i}

      define shared variable ttssardrrp0001_recno  as recid         no-undo.
      define shared variable line_tt1  as INTEGER         no-undo.

      FOR FIRST ttssardrrp0001 NO-LOCK WHERE 
         RECID(ttssardrrp0001) = ttssardrrp0001_recno
         ,EACH ac_mstr NO-LOCK
         WHERE ac_domain = global_domain
         AND ac_code = ttssardrrp0001_ar_acct
         AND INDEX("ALIE",ac_type) > 0
         ,EACH sb_mstr NO-LOCK
         WHERE sb_domain = global_domain
         AND sb_sub = ttssardrrp0001_ar_sub
         ,EACH cc_mstr NO-LOCK
         WHERE cc_domain = global_domain
         AND cc_ctr = ttssardrrp0001_ar_cc
         :

         /* line */
         CREATE tt1.
         ASSIGN
            tt1_ref = ttssardrrp0001_ar_nbr 
            tt1_line = LINE_tt1
            tt1_effdate = STRING(YEAR(ttssardrrp0001_ar_effdate)) + "." +  STRING(MONTH(ttssardrrp0001_ar_effdate)) + "." +  STRING(DAY(ttssardrrp0001_ar_effdate))
            tt1_desc = ttssardrrp0001_ar_po
            tt1_ascp  = ac_code
            tt1_as_desc = ac_desc
            /*
            /* 8 - 发票 */
            tt2_user2 = "截止日期: " + ttssardrrp0001_ar_due_date + "        发票: " + ttssardrrp0001_vo_invoice
            */
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
            tt1_dr_amt = ttssardrrp0001_ar_base_amt
            .
               
         IF ac_curr <> base_curr THEN DO:
            ASSIGN
               tt1_curramt = ABS(ttssardrrp0001_ar_amt)
               tt1_ex_rate = ac_curr + "汇" + STRING(ttssardrrp0001_ar_ex_rate2 / ttssardrrp0001_ar_ex_rate ) 
               .
         END.
      END. /* for each ttssardrrp0001 */

