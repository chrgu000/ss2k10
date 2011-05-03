      
      {mfdeclre.i}
      {cxcustom.i "SSBIGL05GLTR.P"}
      {gplabel.i} /* EXTERNAL LABEL INCLUDE */

      {ssapvorp0002.i}
      {xxcarap1a.i}

      define shared variable ttssapvorp0002_recno  as recid         no-undo.
      define shared variable line_tt1  as INTEGER         no-undo.

      FOR FIRST ttssapvorp0002 NO-LOCK WHERE 
         RECID(ttssapvorp0002) = ttssapvorp0002_recno
         ,EACH ac_mstr NO-LOCK
         WHERE ac_code = ttssapvorp0002_ap_acct
         AND INDEX("ALIE",ac_type) > 0
         ,EACH sb_mstr NO-LOCK
         WHERE sb_sub = ttssapvorp0002_ap_sub
         ,EACH cc_mstr NO-LOCK
         WHERE cc_ctr = ttssapvorp0002_ap_cc
         :

         /* line */
         CREATE tt1.
         ASSIGN
            tt1_ref = ttssapvorp0002_vo_ref 
            tt1_line = LINE_tt1
            tt1_effdate = STRING(YEAR(ttssapvorp0002_ap_effdate)) + "." +  STRING(MONTH(ttssapvorp0002_ap_effdate)) + "." +  STRING(DAY(ttssapvorp0002_ap_effdate))
            tt1_desc = ttssapvorp0002_ap_rmk
            tt1_ascp  = ac_code
            tt1_as_desc = ac_desc
            /*
            /* 8 - 发票 */
            tt2_user2 = "截止日期: " + ttssapvorp0002_vo_due_date + "        发票: " + ttssapvorp0002_vo_invoice
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
            tt1_cr_amt = ttssapvorp0002_ap_base_amt
            .
               
         IF ac_curr <> base_curr THEN DO:
            ASSIGN
               tt1_curramt = ABS(ttssapvorp0002_ap_amt)
               tt1_ex_rate = ac_curr + "汇" + STRING(ttssapvorp0002_ap_ex_rate2 / ttssapvorp0002_ap_ex_rate ) 
               .
         END.
      END. /* for each ttssapvorp0002 */

