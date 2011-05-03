      
      /* SS - 091120.1 - RNB
      输出最后一行,即现金
      如果为0,则忽略
      SS - 091120.1 - RNE */
         
      {mfdeclre.i}
      {cxcustom.i "SSBIGL05GLTR.P"}
      {gplabel.i} /* EXTERNAL LABEL INCLUDE */

      {xxapckrp0001.i}
      {xxcarap2a.i}

      define shared variable ttxxapckrp0001_recno  as recid         no-undo.
      define shared variable line_tt1  as INTEGER         no-undo.

      FOR FIRST ttxxapckrp0001 NO-LOCK WHERE 
         RECID(ttxxapckrp0001) = ttxxapckrp0001_recno
         ,EACH ac_mstr NO-LOCK
         WHERE ac_code = ttxxapckrp0001_ap_acct
         AND INDEX("ALIE",ac_type) > 0
         ,EACH sb_mstr NO-LOCK
         WHERE sb_sub = ttxxapckrp0001_ap_sub
         ,EACH cc_mstr NO-LOCK
         WHERE cc_ctr = ttxxapckrp0001_ap_cc
         :

         /* SS - 091120.1 - B */
         IF ttxxapckrp0001_base_disp_amt = 0 THEN DO:
            RETURN.
         END.

         LINE_tt1 = line_tt1 + 1.
         /* SS - 091120.1 - E */

         /* line */
         CREATE tt1.
         ASSIGN
            tt1_ref = ttxxapckrp0001_ck_ref 
            tt1_line = LINE_tt1
            tt1_effdate = STRING(YEAR(ttxxapckrp0001_ap_effdate)) + "." +  STRING(MONTH(ttxxapckrp0001_ap_effdate)) + "." +  STRING(DAY(ttxxapckrp0001_ap_effdate))
            tt1_ascp  = ac_code
            tt1_as_desc = ac_desc
            .

         FIND FIRST ap_mstr WHERE ap_type = "CK" AND ap_ref = ttxxapckrp0001_ck_ref NO-LOCK NO-ERROR.
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
            tt1_cr_amt = ttxxapckrp0001_base_disp_amt
            .
               
         IF ac_curr <> base_curr THEN DO:
            ASSIGN
               tt1_curramt = ABS(ttxxapckrp0001_disp_amt)
               tt1_ex_rate = ac_curr + "汇" + STRING(ttxxapckrp0001_ap_ex_rate2 / ttxxapckrp0001_ap_ex_rate ) 
               .
         END.
      END. /* for each ttxxapckrp0001 */

