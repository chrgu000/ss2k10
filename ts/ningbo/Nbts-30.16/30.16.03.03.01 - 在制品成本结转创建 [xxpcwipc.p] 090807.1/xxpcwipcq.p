/* SS - 090807.1 By: Bill Jiang */

/* SS - 090807.1 - RNB
期初数量 + 收货数量 + 入库数量 + 不计成本的其他增加数量
SS - 090807.1 - RNE */

{mfdeclre.i}

{xxpcwipc.i}

DEFINE INPUT PARAMETER entity AS CHARACTER.
DEFINE INPUT PARAMETER yr AS INTEGER.
DEFINE INPUT PARAMETER per AS INTEGER.

EMPTY TEMP-TABLE ttsp.
/* 在库品期初成本主文件 */
FOR EACH si_mstr NO-LOCK
   WHERE si_domain = GLOBAL_domain
   AND si_entity = entity
   ,EACH xxpcinb_mstr NO-LOCK
   WHERE xxpcinb_domain = GLOBAL_domain
   AND xxpcinb_site = si_site
   AND xxpcinb_year = yr
   AND xxpcinb_per = per
   BREAK 
   BY xxpcinb_site
   BY xxpcinb_part
   :
   ACCUMULATE xxpcinb_qty (TOTAL
                           BY xxpcinb_site
                           BY xxpcinb_part
                           ).
   IF LAST-OF(xxpcinb_part) THEN DO:
      IF (ACCUMULATE TOTAL BY xxpcinb_part xxpcinb_qty) = 0 THEN DO:
         NEXT.
      END.

      CREATE ttsp.
      ASSIGN
         ttsp_site = xxpcinb_site
         ttsp_part = xxpcinb_part
         ttsp_qty = (ACCUMULATE TOTAL BY xxpcinb_part xxpcinb_qty)
         .
   END.
END.

/* 库存事务历史记录文件 - 数量 */
FOR EACH si_mstr NO-LOCK
   WHERE si_domain = GLOBAL_domain
   AND si_entity = entity
   ,EACH xxpctr_hist NO-LOCK
   WHERE xxpctr_domain = GLOBAL_domain
   AND xxpctr_site = si_site
   AND xxpctr_year = yr
   AND xxpctr_per = per
   BREAK 
   BY xxpctr_site
   BY xxpctr_part
   :
   /*
   IF FIRST-OF(xxpctr_part) THEN DO:
   */
      FIND FIRST ttsp
         WHERE ttsp_site = xxpctr_site
         AND ttsp_part = xxpctr_part
         EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAILABLE ttsp THEN DO:
         CREATE ttsp.
         ASSIGN
            ttsp_site = xxpctr_site
            ttsp_part = xxpctr_part
            .
      END.
   /*
   END.
   */

   /* 收货数量 */
   IF xxpctr_type = "RCT-PO" OR xxpctr_type = "ISS-PRV" THEN DO:
      ttsp_qty = ttsp_qty + xxpctr_qty.
   END.
   /* 入库数量 */
   ELSE IF xxpctr_type = "RCT-WO" THEN DO:
      ttsp_qty = ttsp_qty + xxpctr_qty.
   END.
   /* 不计成本的其他增加数量 */
   ELSE IF xxpctr_qty0 > 0 THEN DO:
      ttsp_qty = ttsp_qty + xxpctr_qty0.
   END.
END.

FOR EACH ttsp:
   IF ttsp_qty = 0 THEN DO:
      DELETE ttsp.
   END.
END.
