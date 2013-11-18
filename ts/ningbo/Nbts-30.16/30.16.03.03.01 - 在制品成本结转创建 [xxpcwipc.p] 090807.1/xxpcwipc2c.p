/* SS - 090807.1 By: Bill Jiang */

/* SS - 090807.1 - RNB

2.在制品成本结转
             ∑期初和期间非领料总成 * 期间入库比例
4)子件单成 = ------------------------------------------------------
             期初数量 + 收货数量 + 入库数量 + 不计成本的其他增加数量

SS - 090807.1 - RNE */

{mfdeclre.i}

{xxpcwipc.i}

DEFINE INPUT PARAMETER site AS CHARACTER.
DEFINE INPUT PARAMETER yr AS INTEGER.
DEFINE INPUT PARAMETER per AS INTEGER.
DEFINE INPUT PARAMETER part AS CHARACTER.

EMPTY TEMP-TABLE ttwoc.
FOR EACH xxpcwoc_det NO-LOCK
   WHERE xxpcwoc_domain = GLOBAL_domain
   AND xxpcwoc_site = site
   AND xxpcwoc_year = yr
   AND xxpcwoc_per = per
   AND xxpcwoc_part = part
   ,EACH xxpcwo_mstr NO-LOCK
   WHERE xxpcwo_domain = GLOBAL_domain
   AND xxpcwo_site = site
   AND xxpcwo_year = yr
   AND xxpcwo_per = per
   AND xxpcwo_part = part
   AND xxpcwo_lot = xxpcwoc_lot
   ,EACH ttsp NO-LOCK
   WHERE ttsp_site = site
   AND ttsp_part = part
   BREAK 
   BY xxpcwoc_element
   :
   ACCUMULATE ((xxpcwoc_beg + xxpcwoc_rct) * xxpcwo_pct_comp) (TOTAL BY xxpcwoc_element).
   IF LAST-OF(xxpcwoc_element) THEN DO:
      IF (ACCUMULATE TOTAL BY xxpcwoc_element ((xxpcwoc_beg + xxpcwoc_rct) * xxpcwo_pct_comp)) = 0 OR ttsp_qty = 0 THEN DO:
         NEXT.
      END.

      CREATE ttwoc.
      ASSIGN
         ttwoc_element = xxpcwoc_element
         ttwoc_cst = (ACCUMULATE TOTAL BY xxpcwoc_element ((xxpcwoc_beg + xxpcwoc_rct) * xxpcwo_pct_comp)) / ttsp_qty
         .
   END.
END.
