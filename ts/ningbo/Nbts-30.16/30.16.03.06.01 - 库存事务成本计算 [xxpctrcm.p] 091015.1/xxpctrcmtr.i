/* SS - 091014.1 By: Bill Jiang */

/* SS - 091014.1 - RNB
[091014.1]

库存转移成本计算

[091014.1]

SS - 091014.1 - RNE */

FOR EACH si_mstr NO-LOCK
   WHERE si_domain = GLOBAL_domain
   AND si_entity = entity
   ,EACH xxpcinc_det NO-LOCK
   WHERE xxpcinc_domain = GLOBAL_domain
   AND xxpcinc_site = si_site
   AND xxpcinc_year = yr
   AND xxpcinc_per = per
   ,EACH xxpctr_hist NO-LOCK
   WHERE xxpctr_domain = GLOBAL_domain
   AND xxpctr_site = xxpcinc_site
   AND xxpctr_year = xxpcinc_year
   AND xxpctr_per = xxpcinc_per
   AND xxpctr_part = xxpcinc_part
   AND LOOKUP(xxpctr_type, "RCT-TR,ISS-TR", ",") <> 0
   AND (xxpctr_qty1 - xxpctr_decfld[1]) <> 0
   BREAK
   BY xxpcinc_site
   BY xxpcinc_part
   BY xxpctr_type
   BY xxpcinc_element
   :
   ACCUMULATE (xxpcinc_cst_tot * (xxpctr_qty1 - xxpctr_decfld[1])) (TOTAL 
                                              BY xxpcinc_site 
                                              BY xxpcinc_part 
                                              BY xxpctr_type
                                              BY xxpcinc_element
                                              ).

   IF LAST-OF(xxpcinc_element) 
      AND (ACCUMULATE TOTAL BY xxpcinc_element (xxpcinc_cst_tot * (xxpctr_qty1 - xxpctr_decfld[1]))) <> 0
      THEN DO:
      FIND FIRST xxpctrc_hist
         WHERE xxpctrc_domain = GLOBAL_domain
         AND xxpctrc_site = si_site
         AND xxpctrc_year = yr
         AND xxpctrc_per = per
         AND xxpctrc_part = xxpcinc_part
         AND xxpctrc_type = xxpctr_type
         AND xxpctrc_element = xxpcinc_element
         EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE xxpctrc_hist THEN DO:
         CREATE xxpctrc_hist.
         ASSIGN
            xxpctrc_domain = GLOBAL_domain
            xxpctrc_site = si_site
            xxpctrc_year = yr
            xxpctrc_per = per
            xxpctrc_part = xxpcinc_part
            xxpctrc_type = xxpctr_type
            xxpctrc_element = xxpcinc_element
            .
      END.

      ASSIGN
         xxpctrc_cst = (ACCUMULATE TOTAL BY xxpcinc_element (xxpcinc_cst_tot * (xxpctr_qty1 - xxpctr_decfld[1])))
         .
   END. /* IF LAST-OF(xxpcinc_element) THEN DO: */
END.

FOR EACH xxpctrc_hist EXCLUSIVE-LOCK
   WHERE xxpctrc_domain = GLOBAL_domain
   AND xxpctrc_site = si_site
   AND xxpctrc_year = yr
   AND xxpctrc_per = per
   AND (xxpctrc_type = "RCT-TR" OR xxpctrc_type = "ISS-TR")
   :
   ASSIGN
      xxpctrc_cst = xxpctrc_cst + xxpctrc_decfld[1]
      .
END.
