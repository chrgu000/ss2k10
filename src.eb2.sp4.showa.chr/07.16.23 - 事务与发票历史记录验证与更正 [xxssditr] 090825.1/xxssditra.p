/* SS - 090612.1 By: Bill Jiang */

{mfdeclre.i }

DEFINE INPUT PARAMETER effdate AS DATE.
DEFINE INPUT PARAMETER effdate1 AS DATE.
DEFINE INPUT PARAMETER update-yn AS LOGICAL.

DEFINE VARIABLE qty AS DECIMAL.
DEFINE VARIABLE trnbr AS CHARACTER.

DEFINE TEMP-TABLE tt1
   FIELD tt1_nbr LIKE tr_nbr
   FIELD tt1_line LIKE tr_line
   FIELD tt1_tr LIKE tr_qty_loc
   FIELD tt1_idh LIKE idh_qty_inv
   FIELD tt1_error AS CHARACTER
   INDEX tt1_nbr_line tt1_nbr tt1_line
   .

DEFINE TEMP-TABLE tttr
   FIELD tttr_nbr LIKE tr_nbr
   FIELD tttr_line LIKE tr_line
   FIELD tttr_trnbr LIKE tr_trnbr
   FIELD tttr_qty_loc LIKE tr_qty_loc
   FIELD tttr_rmks LIKE tr_rmks
   INDEX tttr_nbr_line_trnbr tttr_nbr tttr_line tttr_trnbr
   .

DEFINE TEMP-TABLE ttidh
   FIELD ttidh_nbr LIKE tr_nbr
   FIELD ttidh_line LIKE tr_line
   FIELD ttidh_inv_nbr LIKE idh_inv_nbr
   FIELD ttidh_qty_inv LIKE idh_qty_inv
   FIELD ttidh_tr AS CHARACTER
   INDEX ttidh_nbr_line_inv ttidh_nbr ttidh_line ttidh_inv_nbr
   .

EMPTY TEMP-TABLE tt1.

/* tr_hist */
FOR EACH tr_hist NO-LOCK
   WHERE /* tr_domain = GLOBAL_domain
   AND */ tr_effdate >= effdate
   AND tr_effdate <= effdate1
   AND tr_type = 'ISS-SO'
   /* 限库存 */
   AND tr_ship_type = ''
   /* 不含未过账 */
   AND tr_rmks <> ''
   BREAK 
   BY tr_nbr
   BY tr_line
   BY tr_rmks
   :
   ACCUMULATE tr_qty_loc (TOTAL 
                          BY tr_nbr
                          BY tr_line
                          BY tr_rmks
                          ).
   IF LAST-OF(tr_rmks) THEN DO:
      FIND FIRST idh_hist
         WHERE /* idh_domain = GLOBAL_domain
         AND */idh_inv_nbr = tr_rmks
         AND idh_nbr = tr_nbr
         AND idh_line = tr_line
         NO-LOCK NO-ERROR.
      IF NOT AVAILABLE idh_hist THEN DO:
         FIND FIRST tt1
            WHERE tt1_nbr = tr_nbr
            AND tt1_line = tr_line
            NO-LOCK NO-ERROR.
         IF NOT AVAILABLE tt1 THEN DO:
            CREATE tt1.
            ASSIGN
               tt1_nbr = tr_nbr
               tt1_line = tr_line
               .
         END.

         NEXT.
      END.
      /*
      IF ABS(idh_qty_inv + (ACCUMULATE TOTAL BY tr_rmks tr_qty_loc)) > 0.000001 THEN DO:
      */
      IF idh_qty_inv + (ACCUMULATE TOTAL BY tr_rmks tr_qty_loc) <> 0 THEN DO:
         FIND FIRST tt1
            WHERE tt1_nbr = tr_nbr
            AND tt1_line = tr_line
            NO-LOCK NO-ERROR.
         IF NOT AVAILABLE tt1 THEN DO:
            CREATE tt1.
            ASSIGN
               tt1_nbr = tr_nbr
               tt1_line = tr_line
               .
         END.

         NEXT.
      END.
   END.
END.

/* idh_hist */
qty = 0.
FOR EACH ar_mstr NO-LOCK
   WHERE /* ar_domain = GLOBAL_domain
   AND */ ar_effdate >= effdate
   AND ar_effdate >= effdate1
   ,EACH ih_hist NO-LOCK
   WHERE /* ih_domain = GLOBAL_domain
   AND */ ih_inv_nbr = ar_nbr
   ,EACH idh_hist NO-LOCK
   WHERE /* idh_domain = GLOBAL_domain
   AND */ idh_inv_nbr = ih_inv_nbr
   AND idh_nbr = ih_nbr
   /* 限库存 */
   AND idh_type = ''
   :
   qty = idh_qty_inv.

   FOR EACH tr_hist NO-LOCK
      WHERE /* tr_domain = GLOBAL_domain
      AND */ tr_type = 'ISS-SO'
      AND tr_nbr = idh_nbr
      AND tr_line = idh_line
      AND tr_rmks = idh_inv_nbr
      /* 限库存 */
      AND tr_ship_type = ''
      :
      qty = qty + tr_qty_loc.
   END.

   /*
   IF ABS(qty) > 0.000001 THEN DO:
   */
   IF qty <> 0 THEN DO:
      FIND FIRST tt1
         WHERE tt1_nbr = idh_nbr
         AND tt1_line = idh_line
         NO-LOCK NO-ERROR.
      IF NOT AVAILABLE tt1 THEN DO:
         CREATE tt1.
         ASSIGN
            tt1_nbr = idh_nbr
            tt1_line = idh_line
            .
      END.

      NEXT.
   END.
END.

/* 按订单和项匹配tr和idh */
FOR EACH tt1:
   FOR EACH tr_hist NO-LOCK
      WHERE /* tr_domain = GLOBAL_domain
      /*
      AND tr_effdate >= effdate
      AND tr_effdate <= effdate1
      */
      AND */ tr_type = 'ISS-SO'
      AND tr_nbr = tt1_nbr
      AND tr_line = tt1_line
      /* 限库存 */
      AND tr_ship_type = ''
      /* 不含未过账 */
      AND tr_rmks <> ''
      :
      CREATE tttr.
      ASSIGN
         tttr_nbr = tt1_nbr
         tttr_line = tt1_line
         tttr_trnbr = tr_trnbr
         tttr_qty_loc = tr_qty_loc
         tttr_rmks = tr_rmks
         .

      ASSIGN
         tt1_tr = tt1_tr + tr_qty_loc
         .
   END.

   FOR EACH idh_hist NO-LOCK
      WHERE /* idh_domain = GLOBAL_domain
      /*
      AND idh_inv_nbr = ih_inv_nbr
      */
      AND */ idh_nbr = tt1_nbr
      AND idh_line = tt1_line
      /* 限库存 */
      AND idh_type = ''
      :
      CREATE ttidh.
      ASSIGN
         ttidh_nbr = tt1_nbr
         ttidh_line = tt1_line
         ttidh_inv_nbr = idh_inv_nbr
         ttidh_qty_inv = idh_qty_inv
         .

      ASSIGN
         tt1_idh = tt1_idh + idh_qty_inv
         .
   END.
END.

/* 自动匹配发票 */
FOR EACH tt1 EXCLUSIVE-LOCK:
   /*
   IF ABS(tt1_tr + tt1_idh) > 0.000001 THEN DO:
   */
   IF tt1_tr + tt1_idh <> 0 THEN DO:
      ASSIGN
         tt1_error = "按订单和项汇总的事务和发票数量不相等,请联系顾问进一步处理"
         .

      NEXT.
   END.

   qty = 0.
   trnbr = "".
   FOR EACH tttr
      WHERE tttr_nbr = tt1_nbr
      AND tttr_line = tt1_line
      BY tttr_trnbr
      :
      qty = qty + tttr_qty_loc.
      IF trnbr = "" THEN DO:
         trnbr = STRING(tttr_trnbr).
      END.
      ELSE DO:
         trnbr = trnbr + "," + STRING(tttr_trnbr).
      END.
      FIND FIRST ttidh
         WHERE ttidh_nbr = tt1_nbr
         AND ttidh_line = tt1_line
         AND ttidh_tr = ''
         /*
         AND ABS(ttidh_qty_inv + qty) <= 0.000001
         */
         AND ttidh_qty_inv + qty = 0
         EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE ttidh THEN DO:
         ASSIGN
            ttidh_tr = trnbr
            .

         qty = 0.
         trnbr = "".
         NEXT.
      END.
   END.

   /* 正负 */
   IF qty = 0 THEN DO:
      trnbr = "".
   END.

   IF trnbr <> "" THEN DO:
      ASSIGN
         tt1_error = "按订单和项汇总的事务和发票数量相等,但无法按事务顺序更正,请手动更新"
         .

      NEXT.
   END.
END.

/* 更新 */
DO TRANSACTION ON STOP UNDO:
   FOR EACH tt1 EXCLUSIVE-LOCK
      WHERE tt1_error = ""
      ,EACH tttr NO-LOCK
      WHERE tttr_nbr = tt1_nbr
      AND tttr_line = tt1_line
      ,EACH tr_hist EXCLUSIVE-LOCK
      WHERE /* tr_domain = GLOBAL_domain
      AND */ tr_trnbr = tttr_trnbr
      :
      FIND FIRST ttidh
         WHERE ttidh_nbr = tt1_nbr
         AND ttidh_line = tt1_line
         AND CAN-DO(ttidh_tr,STRING(tttr_trnbr))
         NO-LOCK NO-ERROR.
      IF NOT AVAILABLE ttidh THEN DO:
         FIND FIRST ttidh
            WHERE ttidh_nbr = tt1_nbr
            AND ttidh_line = tt1_line
            AND ttidh_inv_nbr = tttr_rmks
            NO-LOCK NO-ERROR.
         IF AVAILABLE ttidh THEN DO:
            NEXT.
         END.

         FIND FIRST ttidh
            WHERE ttidh_nbr = tt1_nbr
            AND ttidh_line = tt1_line
            /*
            AND ttidh_inv_nbr = tttr_rmks
            */
            NO-LOCK NO-ERROR.
         IF AVAILABLE ttidh THEN DO:
            ASSIGN
               tr_rmks = ttidh_inv_nbr
               .

            NEXT.
         END.
         ELSE DO:
            ASSIGN
               tt1_error = "按订单和项汇总的事务和发票数量相等,且能按事务顺序更正,但发票号异常,请手动更新"
               .

            STOP.
         END.
      END.
      ASSIGN
         tr_rmks = ttidh_inv_nbr
         .
   END.

   IF update-yn = NO THEN DO:
      STOP.
   END.
END.

EXPORT DELIMITER ";"
   "订单"
   "项"
   "事务数量"
   "发票数量"
   "错误"
   .
FOR EACH tt1:
   EXPORT DELIMITER ";" tt1.
END.
