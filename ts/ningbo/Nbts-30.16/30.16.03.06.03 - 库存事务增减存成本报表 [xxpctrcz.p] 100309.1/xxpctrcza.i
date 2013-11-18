/* SS - 090808.1 By: Bill Jiang */

/* SS - 090808.1 - RNB
[090808.1]

期间总成
      
参考xxpctrcr.p

[090808.1]

SS - 090808.1 - RNE */

      FOR EACH enmstr NO-LOCK
         WHERE enmstr.en_domain = GLOBAL_domain
         AND enmstr.en_entity >= entity
         AND enmstr.en_entity <= entity1
         ,EACH simstr NO-LOCK
         WHERE simstr.si_domain = GLOBAL_domain
         AND simstr.si_site >= site
         AND simstr.si_site <= site1
         AND simstr.si_entity = enmstr.en_entity
         ,EACH xxpctrc_hist NO-LOCK
         WHERE xxpctrc_domain = xxpctr_domain
         AND xxpctrc_site = si_site
         AND xxpctrc_year = xxpctr_year
         AND xxpctrc_per = xxpctr_per
         AND xxpctrc_part = xxpctr_part
         AND xxpctrc_type = xxpctr_type
         ,EACH CODE_mstr NO-LOCK
         WHERE CODE_domain = GLOBAL_domain
         AND CODE_fldname = "SoftspeedPC_element"
         AND CODE_value = STRING(xxpctrc_element)
         AND CODE_value >= element
         AND CODE_value <= element1
         BY CODE_value
         :
         ASSIGN
            ttt1_cst = ttt1_cst + xxpctrc_cst
            .
      END.
