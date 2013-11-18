/* SS - 091127.1 By: Bill Jiang */

/* SS - 091127.1 - RNB
分配
SS - 091127.1 - RNE */

{mfdeclre.i}

{xxicaldc.i}

DEFINE INPUT PARAMETER entity AS CHARACTER.
DEFINE INPUT PARAMETER yr AS INTEGER.
DEFINE INPUT PARAMETER per AS INTEGER.

DEFINE VARIABLE cst_xxicniac LIKE xxice_cst.
DEFINE VARIABLE fpos_ttwo AS CHARACTER.

/* 明细 */
FOR EACH xxice_mstr NO-LOCK
   WHERE xxice_domain = GLOBAL_domain
   AND xxice_entity = entity
   AND xxice_year = yr
   AND xxice_per = per
   USE-INDEX xxice_eyp
   :
   IF xxice_cst = 0 THEN DO:
      NEXT.
   END.

   cst_xxicniac = 0.
   FOR EACH ttwo NO-LOCK
      WHERE ttwo_fpos = xxice_fpos
      USE-INDEX ttwo_fpos
      ,EACH xxpcwo_mstr NO-LOCK
      WHERE xxpcwo_domain = GLOBAL_domain
      AND xxpcwo_year = yr
      AND xxpcwo_per = per
      AND xxpcwo_lot = ttwo_lot
      USE-INDEX xxpcwo_ypl
      BREAK
      BY xxpcwo_lot
      :
      IF LAST(xxpcwo_lot) THEN DO:
         CREATE xxicald_det.
         ASSIGN
            xxicald_domain = GLOBAL_domain
            xxicald_entity = entity
            xxicald_year = yr
            xxicald_per = per
            xxicald_part = xxpcwo_part
            xxicald_lot = xxpcwo_lot
            xxicald_element = xxice_element
            xxicald_cst = xxice_cst - cst_xxicniac
            xxicald_fpos = xxice_fpos
            xxicald_ac = xxice_ac
            xxicald_sb = xxice_sb
            xxicald_cc = xxice_cc
            xxicald_ar = ttwo_ar
            xxicald_usage_pct = ttwo_usage_pct
            cst_xxicniac = cst_xxicniac + xxicald_cst
            .
      END.
      ELSE DO:
         CREATE xxicald_det.
         ASSIGN
            xxicald_domain = GLOBAL_domain
            xxicald_entity = entity
            xxicald_year = yr
            xxicald_per = per
            xxicald_part = xxpcwo_part
            xxicald_lot = xxpcwo_lot
            xxicald_element = xxice_element
            xxicald_cst = xxice_cst * ttwo_usage_pct
            xxicald_fpos = xxice_fpos
            xxicald_ac = xxice_ac
            xxicald_sb = xxice_sb
            xxicald_cc = xxice_cc
            xxicald_ar = ttwo_ar
            xxicald_usage_pct = ttwo_usage_pct
            cst_xxicniac = cst_xxicniac + xxicald_cst
            .
      END.
   END.

   /* 最后的验证 */
   IF ABS(xxice_cst - cst_xxicniac) >= 0.000001 THEN DO:
      fpos_ttwo = STRING(xxice_fpos).
      /* 301601 - 非库存格式位置#分配比例为0 */
      {pxmsg.i &MSGNUM=301601 &ERRORLEVEL=3 &MSGARG1=fpos_ttwo}

      RETURN "no".
   END.
END.

/* 主 */
FOR EACH xxicald_det NO-LOCK
   WHERE xxicald_domain = GLOBAL_domain
   AND xxicald_entity = entity
   AND xxicald_year = yr
   AND xxicald_per = per
   USE-INDEX xxicald_eyp
   BREAK 
   BY xxicald_part
   BY xxicald_lot
   BY xxicald_element
   :
   ACCUMULATE xxicald_cst (TOTAL
                           BY xxicald_part
                           BY xxicald_lot
                           BY xxicald_element
                           ).
   IF LAST-OF(xxicald_element) THEN DO:
      CREATE xxical_mstr.
      ASSIGN
         xxical_domain = GLOBAL_domain
         xxical_entity = entity
         xxical_year = yr
         xxical_per = per
         xxical_part = xxicald_part
         xxical_lot = xxicald_lot
         xxical_element = xxicald_element
         xxical_cst = (ACCUMULATE TOTAL BY xxicald_element xxicald_cst)
         .
   END.
END.

RETURN "yes".
