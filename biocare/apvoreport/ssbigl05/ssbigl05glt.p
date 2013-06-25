      
      {mfdeclre.i}
      {cxcustom.i "SSBIGL05GLTR.P"}
      {gplabel.i} /* EXTERNAL LABEL INCLUDE */

      {ssbigl05a.i}

      DEFINE VARIABLE tot_dr_amt AS DECIMAL.

      tot_dr_amt = 0.
      FOR EACH glt_det NO-LOCK WHERE 
         /* SS - 20080606.1 - B */
         glt_domain = GLOBAL_domain AND 
         /* SS - 20080606.1 - E */
         glt_ref >= ref 
         AND glt_ref <= ref1 
         AND glt_entity >= entity 
         AND glt_entity <= entity1
         AND glt_date >= dt
         AND glt_date <= dt1
         AND glt_effdate >= effdt
         AND glt_effdate <= effdt1
         AND glt_batch >= batch
         AND glt_batch <= batch1
         AND glt_tr_type >= TYPE
         AND glt_tr_type <= type1
         AND glt_unb = unb
         AND (glt_userid = user-id OR user-id = "" ) 
         ,EACH ac_mstr NO-LOCK
         WHERE ac_domain = glt_domain
         AND ac_code = glt_acct
         AND INDEX("ALIE",ac_type) > 0
         ,EACH sb_mstr NO-LOCK
         WHERE sb_domain = glt_domain
         AND sb_sub = glt_sub
         ,EACH cc_mstr NO-LOCK
         WHERE cc_domain = glt_domain
         AND cc_ctr = glt_cc
         ,EACH pj_mstr NO-LOCK
         WHERE pj_domain = glt_domain
         AND pj_proj = glt_project
         BREAK BY glt_ref 
         :
         ACCUMULATE glt_ref (COUNT BY glt_ref).

         /* line */
         CREATE tt1.
         ASSIGN
            tt1_batch = glt_batch
            tt1_ref = glt_ref 
            tt1_line = (ACCUMULATE COUNT BY glt_ref glt_ref)
            tt1_effdate = STRING(YEAR(glt_effdate)) + "." +  STRING(MONTH(glt_effdate)) + "." +  STRING(DAY(glt_effdate))
            tt1_desc = glt_desc 
            tt1_ascp  = ac_code
            tt1_as_desc = ac_desc
            /* 附件 */
            tt1_user2  = glt_userid
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

         IF pj_project <> "" THEN DO:
            ASSIGN 
               tt1_ascp = tt1_ascp + "-" + pj_project
               .
            IF tt1_cp_desc = "" THEN DO:
               ASSIGN 
                  tt1_cp_desc = pj_desc
                  .
            END.
            ELSE DO:
               ASSIGN 
                  tt1_cp_desc = tt1_cp_desc + "-" + pj_desc 
                  .
            END.
         END.
          
         if (glt_amt >= 0 AND glt_correction = false) or
            (glt_amt <  0 AND glt_correction = true)
            THEN DO:
            assign 
               tt1_dr_amt = glt_amt
               .
         END.
         ELSE DO:
            assign 
               tt1_cr_amt = - glt_amt
               .
         END.
         tot_dr_amt = tot_dr_amt + tt1_dr_amt.
               
         IF ac_curr <> base_curr THEN DO:
            ASSIGN
               tt1_curramt = ABS(glt_curr_amt)
               tt1_ex_rate = ac_curr + "汇" + STRING(glt_ex_rate2 / glt_ex_rate ) 
               .
         END.



         /* ref */
         IF LAST-OF(glt_ref) THEN DO:
            CREATE tt2.
            ASSIGN 
               tt2_batch = glt_batch
               tt2_ref = glt_ref 
               /* 附件 */
               tt2_user2 = glt_userid
               tt2_decimal1 = ABS(tot_dr_amt)
               tt2_effdate = STRING(YEAR(glt_effdate)) + "." +  STRING(MONTH(glt_effdate)) + "." +  STRING(DAY(glt_effdate))
               tt2_page = tt1_page
               tt2_cp_desc = NAME_reports
               tt2_as_desc = "由 " + NAME_usr + " 打印 " + "(日期: " + string(year(today)) + "." + string(month(today)) + "." + string(day(today)) + ", " + "时间: " + STRING(TIME,"HH:MM:SS") + ")" 
               .

            {gprun.i ""ssGetCN"" "(
               INPUT tot_dr_amt,
               OUTPUT tt2_desc
               )"}

            FIND FIRST usr_mstr WHERE usr_userid = glt_userid NO-LOCK NO-ERROR.
            IF AVAIL usr_mstr THEN do:
               ASSIGN 
                  tt2_ascp = "审核:                              复核:                              制单: " + usr_name
                  .
            END.

            tot_dr_amt = 0.
         END. /* IF LAST-OF(glt_ref) THEN DO: */
      END. /* for each glt_det */
