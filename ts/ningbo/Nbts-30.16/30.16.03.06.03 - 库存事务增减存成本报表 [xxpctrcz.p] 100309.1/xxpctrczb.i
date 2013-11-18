/* SS - 090808.1 By: Bill Jiang */

/* SS - 090808.1 - RNB
[090808.1]

期初总成
      
参考xxpcincr.p

[090808.1]

SS - 090808.1 - RNE */

   FOR EACH en_mstr NO-LOCK
      WHERE en_domain = GLOBAL_domain
      AND en_entity >= entity
      AND en_entity <= entity1
      ,EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_site >= site
      AND si_site <= site1
      AND si_entity = en_entity
      ,EACH xxpcinc_det NO-LOCK
      WHERE xxpcinc_domain = GLOBAL_domain
      AND xxpcinc_site = si_site
      AND xxpcinc_year = yr
      AND xxpcinc_per = per
      ,EACH pt_mstr NO-LOCK
      WHERE pt_domain = GLOBAL_domain
      AND pt_part = xxpcinc_part
      AND pt_part >= part
      AND pt_part <= part1
      ,EACH CODE_mstr NO-LOCK
      WHERE CODE_domain = GLOBAL_domain
      AND CODE_fldname = "SoftspeedPC_element"
      AND CODE_value = STRING(xxpcinc_element)
      AND CODE_value >= element
      AND CODE_value <= element1
      BREAK
      BY xxpcinc_part
      :
      ACCUMULATE xxpcinc_beg (TOTAL BY xxpcinc_part).
      IF LAST-OF(xxpcinc_part) THEN DO:
         FIND FIRST ttp1
            WHERE ttp1_part = xxpcinc_part
            EXCLUSIVE-LOCK NO-ERROR.
         IF NOT AVAILABLE ttp1 THEN DO:
            CREATE ttp1.
            ASSIGN
               ttp1_part = xxpcinc_part
               .
         END.
         ASSIGN
            ttp1_cst = (ACCUMULATE TOTAL BY xxpcinc_part xxpcinc_beg)
            .
      END.
   END.
