/* SS - 091127.1 By: Bill Jiang */

/* SS - 091127.1 - RNB
分配范围
如果出错,返回"no";否则返回"yes"
SS - 091127.1 - RNE */

{mfdeclre.i}

{xxicaldc.i}

DEFINE INPUT PARAMETER entity AS CHARACTER.
DEFINE INPUT PARAMETER yr AS INTEGER.
DEFINE INPUT PARAMETER per AS INTEGER.

DEFINE VARIABLE lSoftspeedIC_to AS LOGICAL EXTENT 4.
DEFINE VARIABLE cSoftspeedIC_to AS CHARACTER EXTENT 4.

DEFINE VARIABLE fpos_ttwo AS CHARACTER.

/* 零件 */
FIND FIRST mfc_ctrl
   WHERE mfc_domain = GLOBAL_domain
   AND mfc_field = "SoftspeedIC_to_pt"
   NO-LOCK NO-ERROR.
IF NOT AVAILABLE mfc_ctrl THEN DO:
   lSoftspeedIC_to[1] = NO.
END.
ELSE DO:
   lSoftspeedIC_to[1] = YES.
   cSoftspeedIC_to[1] = mfc_char.
END.
/* 产品线 */
FIND FIRST mfc_ctrl
   WHERE mfc_domain = GLOBAL_domain
   AND mfc_field = "SoftspeedIC_to_pl"
   NO-LOCK NO-ERROR.
IF NOT AVAILABLE mfc_ctrl THEN DO:
   lSoftspeedIC_to[2] = NO.
END.
ELSE DO:
   lSoftspeedIC_to[2] = YES.
   cSoftspeedIC_to[2] = mfc_char.
END.
/* 在制品成本中心 */
FIND FIRST mfc_ctrl
   WHERE mfc_domain = GLOBAL_domain
   AND mfc_field = "SoftspeedIC_to_cc"
   NO-LOCK NO-ERROR.
IF NOT AVAILABLE mfc_ctrl THEN DO:
   lSoftspeedIC_to[3] = NO.
END.
ELSE DO:
   lSoftspeedIC_to[3] = YES.
   cSoftspeedIC_to[3] = mfc_char.
END.
/* 生产线 */
FIND FIRST mfc_ctrl
   WHERE mfc_domain = GLOBAL_domain
   AND mfc_field = "SoftspeedIC_to_ln"
   NO-LOCK NO-ERROR.
IF NOT AVAILABLE mfc_ctrl THEN DO:
   lSoftspeedIC_to[4] = NO.
END.
ELSE DO:
   lSoftspeedIC_to[4] = YES.
   cSoftspeedIC_to[4] = mfc_char.
END.

EMPTY TEMP-TABLE ttwo.

xxicniacloop:
FOR EACH xxice_mstr NO-LOCK
   WHERE xxice_domain = GLOBAL_domain
   AND xxice_entity = entity
   AND xxice_year = yr
   AND xxice_per = per
   BREAK BY xxice_fpos
   :
   IF NOT LAST-OF(xxice_fpos) THEN DO:
      NEXT.
   END.

   xxpcwoloop:
   FOR EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_entity = entity
      ,EACH xxpcwo_mstr NO-LOCK
      WHERE xxpcwo_domain = GLOBAL_domain
      AND xxpcwo_site = si_site
      AND xxpcwo_year = yr
      AND xxpcwo_per = per
      ,EACH pt_mstr NO-LOCK
      WHERE pt_domain = GLOBAL_domain
      AND pt_part = xxpcwo_part
      ,EACH wo_mstr NO-LOCK
      WHERE wo_domain = GLOBAL_domain
      AND wo_lot = xxpcwo_lot
      :
      IF xxpcwo_qty_beg + xxpcwo_qty_ord = 0 THEN DO:
         NEXT.
      END.

      /* 零件 */
      REPEAT:
         IF NOT lSoftspeedIC_to[1] THEN DO:
            LEAVE.
         END.

         FOR EACH glrd_det NO-LOCK
            WHERE glrd_domain = GLOBAL_domain
            AND glrd_code = cSoftspeedIC_to[1]
            AND glrd_sums = xxice_fpos
            AND glrd_fpos = 0
            USE-INDEX glrd_ind1
            :
            IF (glrd_acct <= pt_part OR glrd_acct = "") AND (glrd_acct1 >= pt_part OR glrd_acct1 = "") THEN DO:
               CREATE ttwo.
               ASSIGN
                  ttwo_fpos = xxice_fpos
                  /*
                  ttwo_site = xxpcwo_site
                  */
                  ttwo_part = xxpcwo_part
                  ttwo_lot = xxpcwo_lot
                  .

               NEXT xxpcwoloop.
            END.
         END.

         LEAVE.
      END.

      /* 产品线 */
      REPEAT:
         IF NOT lSoftspeedIC_to[2] THEN DO:
            LEAVE.
         END.

         FOR EACH glrd_det NO-LOCK
            WHERE glrd_domain = GLOBAL_domain
            AND glrd_code = cSoftspeedIC_to[2]
            AND glrd_sums = xxice_fpos
            AND glrd_fpos = 0
            USE-INDEX glrd_ind1
            :
            IF (glrd_acct <= pt_prod_line OR glrd_acct = "") AND (glrd_acct1 >= pt_prod_line OR glrd_acct1 = "") THEN DO:
               CREATE ttwo.
               ASSIGN
                  ttwo_fpos = xxice_fpos
                  /*
                  ttwo_site = xxpcwo_site
                  */
                  ttwo_part = xxpcwo_part
                  ttwo_lot = xxpcwo_lot
                  .

               NEXT xxpcwoloop.
            END.
         END.

         LEAVE.
      END.

      /* 在制品成本中心 */
      REPEAT:
         IF NOT lSoftspeedIC_to[3] THEN DO:
            LEAVE.
         END.

         /* 标准加工单 */
         IF wo_type <> "" THEN DO:
            LEAVE.
         END.

         FOR EACH glrd_det NO-LOCK
            WHERE glrd_domain = GLOBAL_domain
            AND glrd_code = cSoftspeedIC_to[3]
            AND glrd_sums = xxice_fpos
            AND glrd_fpos = 0
            USE-INDEX glrd_ind1
            :
            IF (glrd_acct <= wo_cc OR glrd_acct = "") AND (glrd_acct1 >= wo_cc OR glrd_acct1 = "") THEN DO:
               CREATE ttwo.
               ASSIGN
                  ttwo_fpos = xxice_fpos
                  /*
                  ttwo_site = xxpcwo_site
                  */
                  ttwo_part = xxpcwo_part
                  ttwo_lot = xxpcwo_lot
                  .

               NEXT xxpcwoloop.
            END.
         END.

         LEAVE.
      END.

      /* 生产线 */
      REPEAT:
         IF NOT lSoftspeedIC_to[4] THEN DO:
            LEAVE.
         END.

         /* 非标准加工单 */
         IF wo_type = "" THEN DO:
            LEAVE.
         END.

         FOR EACH glrd_det NO-LOCK
            WHERE glrd_domain = GLOBAL_domain
            AND glrd_code = cSoftspeedIC_to[4]
            AND glrd_sums = xxice_fpos
            AND glrd_fpos = 0
            USE-INDEX glrd_ind1
            :
            IF (glrd_acct <= wo_line OR glrd_acct = "") AND (glrd_acct1 >= wo_line OR glrd_acct1 = "") THEN DO:
               CREATE ttwo.
               ASSIGN
                  ttwo_fpos = xxice_fpos
                  /*
                  ttwo_site = xxpcwo_site
                  */
                  ttwo_part = xxpcwo_part
                  ttwo_lot = xxpcwo_lot
                  .

               NEXT xxpcwoloop.
            END.
         END.

         LEAVE.
      END.

   END. /* FOR EACH si_mstr NO-LOCK */

   FIND FIRST ttwo WHERE ttwo_fpos = xxice_fpos NO-LOCK NO-ERROR.
   IF NOT AVAILABLE ttwo THEN DO:
      /* 301601 - 非库存格式位置#分配比例为0 */
      fpos_ttwo = STRING(ttwo_fpos).
      {pxmsg.i &MSGNUM=301601 &ERRORLEVEL=3 &MSGARG1=fpos_ttwo}

      RETURN "no".
   END.
END. /* FOR EACH xxice_mstr NO-LOCK */

RETURN "yes".
