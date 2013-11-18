/* SS - 091014.1 By: Bill Jiang */
/* SS - 091015.1 By: Bill Jiang */

/* SS - 091014.1 - RNB
[091014.1]

地点间库存转移增加成本计算

[091014.1]

SS - 091014.1 - RNE */

IF incl-move = YES THEN DO:
   /* 创建库存转移临时表 - 数量 */
   FOR EACH ttpt:
      DELETE ttpt.
   END.
   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      ,EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_entity = en_entity
      ,EACH tr_hist NO-LOCK
      WHERE tr_domain = GLOBAL_domain
      AND tr_effdate >= efdate
      AND tr_effdate <= efdate1
      AND tr_site = si_site
      AND tr_ship_type = ""
      AND (tr_type = "RCT-TR" OR tr_type = "ISS-TR")
      AND tr_site <> tr_ref_site
      AND tr_ref_site = FROM_site
      AND tr_qty_loc > 0
      BREAK
      BY tr_site
      BY tr_part
      BY tr_type
      :
      ACCUMULATE tr_qty_loc (TOTAL BY tr_site BY tr_part BY tr_type).

      IF LAST-OF(tr_type) 
         AND (ACCUMULATE TOTAL BY tr_type tr_qty_loc) <> 0
         THEN DO:
         CREATE ttpt.
         ASSIGN
            ttpt_site = tr_site
            ttpt_part = tr_part
            ttpt_type = tr_type
            ttpt_qty_loc = (ACCUMULATE TOTAL BY tr_type tr_qty_loc)
            .
      END. /* IF LAST-OF(tr_type) THEN DO: */
   END.

   /* 创建库存转移临时表 - 成本 */
   FOR EACH ttpte:
      DELETE ttpte.
   END.
   /* SS - 091015.1 - B */
   FOR EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_entity = entity
      ,EACH xxpctrc_hist EXCLUSIVE-LOCK
      WHERE xxpctrc_domain = GLOBAL_domain
      AND xxpctrc_site = si_site
      AND xxpctrc_year = yr
      AND xxpctrc_per = per
      AND (xxpctrc_type = "RCT-TR" OR xxpctrc_type = "ISS-TR")
      :
      ASSIGN
         xxpctrc_decfld[1] = 0
         .
   END.
   /* SS - 091015.1 - E */
   FOR EACH ttpt:
      FOR EACH xxpcinc_det NO-LOCK
         WHERE xxpcinc_domain = GLOBAL_domain
         AND xxpcinc_site = from_site
         AND xxpcinc_year = yr
         AND xxpcinc_per = per
         AND xxpcinc_part = ttpt_part
         :
         FIND FIRST xxpctrc_hist
            WHERE xxpctrc_domain = GLOBAL_domain
            AND xxpctrc_site = ttpt_site
            AND xxpctrc_year = yr
            AND xxpctrc_per = per
            AND xxpctrc_part = ttpt_part
            AND xxpctrc_type = ttpt_type
            AND xxpctrc_element = xxpcinc_element
            EXCLUSIVE-LOCK NO-ERROR.
         IF NOT AVAILABLE xxpctrc_hist THEN DO:
            CREATE xxpctrc_hist.
            ASSIGN
               xxpctrc_domain = GLOBAL_domain
               xxpctrc_site = ttpt_site
               xxpctrc_year = yr
               xxpctrc_per = per
               xxpctrc_part = ttpt_part
               xxpctrc_type = ttpt_type
               xxpctrc_element = xxpcinc_element
               .
         END.

         ASSIGN
            xxpctrc_decfld[1] = (ttpt_qty_loc * xxpcinc_cst_tot)
            .
      END.
   END.
END. /* IF incl-move = YES THEN DO: */
