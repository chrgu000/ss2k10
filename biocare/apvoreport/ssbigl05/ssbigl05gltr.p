      
      {mfdeclre.i}
      {cxcustom.i "SSBIGL05GLTR.P"}
      {gplabel.i} /* EXTERNAL LABEL INCLUDE */

      {ssbigl05a.i}

      DEFINE VARIABLE tot_dr_amt AS DECIMAL.

      tot_dr_amt = 0.
      FOR EACH gltr_hist NO-LOCK WHERE 
         /* SS - 20080606.1 - B */
         gltr_domain = GLOBAL_domain AND 
         /* SS - 20080606.1 - E */
         gltr_ref >= ref 
         AND gltr_ref <= ref1 
         AND gltr_entity >= entity 
         AND gltr_entity <= entity1
         AND gltr_ent_dt >= dt
         AND gltr_ent_dt <= dt1
         AND gltr_eff_dt >= effdt
         AND gltr_eff_dt <= effdt1
         AND gltr_batch >= batch
         AND gltr_batch <= batch1
         AND gltr_tr_type >= TYPE
         AND gltr_tr_type <= type1
         AND gltr_unb = unb
         AND (gltr_user = user-id OR user-id = "" ) 
         ,EACH ac_mstr NO-LOCK
         WHERE ac_domain = gltr_domain
         AND ac_code = gltr_acc
         AND INDEX("ALIE",ac_type) > 0
         ,EACH sb_mstr NO-LOCK
         WHERE sb_domain = gltr_domain
         AND sb_sub = gltr_sub
         ,EACH cc_mstr NO-LOCK
         WHERE cc_domain = gltr_domain
         AND cc_ctr = gltr_ctr
         ,EACH pj_mstr NO-LOCK
         WHERE pj_domain = gltr_domain
         AND pj_proj = gltr_proj
         BREAK BY gltr_ref 
         :
         ACCUMULATE gltr_ref (COUNT BY gltr_ref).

         /* line */
         CREATE tt1.
         ASSIGN
            tt1_batch = gltr_batch
            tt1_ref = gltr_ref 
            tt1_line = (ACCUMULATE COUNT BY gltr_ref gltr_ref)
            tt1_effdate = STRING(YEAR(gltr_eff_dt)) + "." +  STRING(MONTH(gltr_eff_dt)) + "." +  STRING(DAY(gltr_eff_dt))
            tt1_desc = gltr_desc 
            tt1_ascp  = ac_code
            tt1_as_desc = ac_desc
            /* 附件 */
            tt1_user2  = gltr_user2
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
          
         if (gltr_amt >= 0 AND gltr_correction = false) or
            (gltr_amt <  0 AND gltr_correction = true)
            THEN DO:
            assign 
               tt1_dr_amt = gltr_amt
               .
         END.
         ELSE DO:
            assign 
               tt1_cr_amt = - gltr_amt
               .
         END.
         tot_dr_amt = tot_dr_amt + tt1_dr_amt.
               
         IF ac_curr <> base_curr THEN DO:
            ASSIGN
               tt1_curramt = ABS(gltr_curramt)
               tt1_ex_rate = ac_curr + "汇" + STRING(gltr_ex_rate2 / gltr_ex_rate ) 
               .
         END.



         /* ref */
         IF LAST-OF(gltr_ref) THEN DO:
            CREATE tt2.
            ASSIGN 
               tt2_batch = gltr_batch
               tt2_ref = gltr_ref 
               /* 附件 */
               tt2_user2 = gltr_user2
               tt2_decimal1 = ABS(tot_dr_amt)
               tt2_effdate = STRING(YEAR(gltr_eff_dt)) + "." +  STRING(MONTH(gltr_eff_dt)) + "." +  STRING(DAY(gltr_eff_dt))
               tt2_page = tt1_page
               tt2_cp_desc = NAME_reports
               tt2_as_desc = "由 " + name_usr + " 打印 " + "(日期: " + string(year(today)) + "." + string(month(today)) + "." + string(day(today)) + ", " + "时间: " + STRING(TIME,"HH:MM:SS") + ")" 
               .

            {gprun.i ""ssGetCN"" "(
               INPUT tot_dr_amt,
               OUTPUT tt2_desc
               )"}

            FIND FIRST usr_mstr WHERE usr_userid = gltr_user NO-LOCK NO-ERROR.
            IF AVAIL usr_mstr THEN do:
               ASSIGN 
                  tt2_ascp = "审核:                              复核:                              制单: " + usr_name
                  .
            END.

            tot_dr_amt = 0.
         END. /* IF LAST-OF(gltr_ref) THEN DO: */
      END. /* for each gltr_hist */
