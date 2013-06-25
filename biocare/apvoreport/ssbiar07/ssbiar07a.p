      
      {mfdeclre.i}
      {cxcustom.i "SSBIGL05GLTR.P"}
      {gplabel.i} /* EXTERNAL LABEL INCLUDE */

      {ssarparp0001.i}
      {ssbiar07a.i}

      define shared variable ttssarparp0001_recno  as recid         no-undo.
      define shared variable line_tt1  as INTEGER         no-undo.

      FOR FIRST ttssarparp0001 NO-LOCK WHERE 
         RECID(ttssarparp0001) = ttssarparp0001_recno
         ,EACH ac_mstr NO-LOCK
         WHERE ac_domain = global_domain
         AND ac_code = ttssarparp0001_ar_acct
         AND INDEX("ALIE",ac_type) > 0
         ,EACH sb_mstr NO-LOCK
         WHERE sb_domain = global_domain
         AND sb_sub = ttssarparp0001_ar_sub
         ,EACH cc_mstr NO-LOCK
         WHERE cc_domain = global_domain
         AND cc_ctr = ttssarparp0001_ar_cc
         :

         /* line */
         CREATE tt1.
         ASSIGN
            tt1_ref = ttssarparp0001_ar_nbr 
            tt1_line = LINE_tt1
            tt1_effdate = STRING(YEAR(ttssarparp0001_ar_effdate)) + "." +  STRING(MONTH(ttssarparp0001_ar_effdate)) + "." +  STRING(DAY(ttssarparp0001_ar_effdate))
            tt1_desc = ttssarparp0001_ar_po
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
            tt1_dr_amt = ttssarparp0001_ar_base_amt
            .
               
         IF ac_curr <> base_curr THEN DO:
            ASSIGN
               tt1_curramt = ABS(ttssarparp0001_ar_amt)
               tt1_ex_rate = ac_curr + "»ã" + STRING(ttssarparp0001_ar_ex_rate2 / ttssarparp0001_ar_ex_rate ) 
               .
         END.
      END. /* for each ttssarparp0001 */

