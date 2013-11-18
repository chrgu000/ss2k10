/* SS - 091127.1 By: Bill Jiang */
/* SS - 091127.1 By: Bill Jiang */

/* SS - 091127.1 - RNB
分配范围比例
如果出错,返回"no";否则返回"yes"
SS - 091127.1 - RNE */

{mfdeclre.i}

{xxicaldc.i}

DEFINE INPUT PARAMETER entity AS CHARACTER.
DEFINE INPUT PARAMETER yr AS INTEGER.
DEFINE INPUT PARAMETER per AS INTEGER.

DEFINE VARIABLE fpos_ttwo AS CHARACTER.
DEFINE VARIABLE usage_pct_ttwo AS DECIMAL.

/* SS - 091127.1 - B */
DEFINE VARIABLE l_yn AS LOGICAL.
/* SS - 091127.1 - E */

FIND FIRST mfc_ctrl 
   WHERE mfc_domain = GLOBAL_domain
   AND mfc_field = "SoftspeedIC_glr_code_ie"
   NO-LOCK NO-ERROR.
IF NOT AVAILABLE mfc_ctrl THEN DO:
   /* 301602 - 没有设置间接成本分配控制文件 [xxicpm01.p] */
   {pxmsg.i &MSGNUM=301602 &ERRORLEVEL=3}
   RETURN "no".
END.

/* SS - 091127.1 - B
FOR EACH ttwo
   /* 分配比例 */
   ,EACH glrd_det NO-LOCK
   WHERE glrd_domain = GLOBAL_domain
   AND glrd_code = mfc_char
   AND glrd_fpos = ttwo_fpos
   AND glrd_line = 0
   USE-INDEX glrd_code
   :
   FOR EACH xxicar_det NO-LOCK
      WHERE xxicar_domain = GLOBAL_domain
      AND xxicar_entity = entity
      AND xxicar_year = yr
      AND xxicar_per = per
      AND xxicar_part = ttwo_part
      AND (xxicar_lot = ttwo_lot OR xxicar_lot = "")
      AND xxicar_ar = glrd_user1
      USE-INDEX xxicar_eyppla
      BY xxicar_lot DESC
      :
      ASSIGN
         ttwo_ar = xxicar_ar
         ttwo_usage_tot = xxicar_usage_tot
         .
      LEAVE.
   END.
END.
SS - 091127.1 - E */
/* SS - 091127.1 - B */
FOR EACH ttwo EXCLUSIVE-LOCK
   BREAK 
   BY ttwo_fpos
   :
   /* 分配比例 */
   FIND FIRST glrd_det
      WHERE glrd_domain = GLOBAL_domain
      AND glrd_code = mfc_char
      AND glrd_fpos = ttwo_fpos
      AND glrd_line = 0
      USE-INDEX glrd_code
      NO-LOCK NO-ERROR.
   IF NOT AVAILABLE glrd_det THEN DO:
      /* 301614 - 找不到间接费用<#>(格式位置<#>)的分配比例 */
      fpos_ttwo = STRING(ttwo_fpos).
      {pxmsg.i &MSGNUM=301614 &ERRORLEVEL=3 &MSGARG1=mfc_char &MSGARG2=fpos_ttwo}
      RETURN "no".
   END.

   IF FIRST-OF(ttwo_fpos) THEN DO:
      l_yn = NO.
   END.
   FOR EACH xxicar_det NO-LOCK
      WHERE xxicar_domain = GLOBAL_domain
      AND xxicar_entity = entity
      AND xxicar_year = yr
      AND xxicar_per = per
      AND xxicar_part = ttwo_part
      AND (xxicar_lot = ttwo_lot OR xxicar_lot = "")
      AND xxicar_ar = glrd_user1
      USE-INDEX xxicar_eyppla
      BY xxicar_lot DESC
      :
      ASSIGN
         ttwo_ar = xxicar_ar
         ttwo_usage_tot = xxicar_usage_tot
         .
      l_yn = YES.
      LEAVE.
   END.
   IF LAST-OF(ttwo_fpos) THEN DO:
      IF l_yn = NO THEN DO:
         /* 301615 - 间接费用<#>(格式位置<#>)的分配比例为0 */
         fpos_ttwo = STRING(ttwo_fpos).
         {pxmsg.i &MSGNUM=301615 &ERRORLEVEL=3 &MSGARG1=mfc_char &MSGARG2=fpos_ttwo}
         RETURN "no".
      END.
   END.
END.
/* SS - 091127.1 - E */

/* SS - 091127.1 - B */
l_yn = YES.
/* SS - 091127.1 - E */
EMPTY TEMP-TABLE ttwo2.
FOR EACH ttwo
   BREAK BY ttwo_fpos
   :
   ACCUMULATE ttwo_usage_tot (TOTAL BY ttwo_fpos).
   IF LAST-OF(ttwo_fpos) THEN DO:
      CREATE ttwo2.
      ASSIGN
         ttwo2_fpos = ttwo_fpos
         ttwo2_usage_tot = (ACCUMULATE TOTAL BY ttwo_fpos ttwo_usage_tot)
         .

      IF ttwo2_usage_tot = 0 THEN DO:
         fpos_ttwo = STRING(ttwo_fpos).
         /* 301601 - 非库存格式位置#分配比例为0 */
         {pxmsg.i &MSGNUM=301601 &ERRORLEVEL=3 &MSGARG1=fpos_ttwo}

         /* SS - 091127.1 - B
         RETURN "no".
         SS - 091127.1 - E */
         /* SS - 091127.1 - B */
         l_yn = NO.
         LEAVE.
         /* SS - 091127.1 - E */
      END.
   END.
END.
/* SS - 091127.1 - B */
IF l_yn = NO THEN DO:
   FOR EACH ttwo
      WHERE ttwo_fpos = INTEGER(fpos_ttwo)
      :
      DISPLAY
         ttwo_fpos
         ttwo_ar
         ttwo_part
         ttwo_lot
         ttwo_usage_tot
         .
   END.
   RETURN "no".
END.
/* SS - 091127.1 - E */

usage_pct_ttwo = 0.
FOR EACH ttwo
   ,EACH ttwo2
   WHERE ttwo2_fpos = ttwo_fpos
   AND ttwo_usage_tot <> 0
   BREAK BY ttwo_fpos
   :
   IF LAST-OF(ttwo_fpos) THEN DO:
      ASSIGN
         ttwo_usage_pct = 1 - usage_pct_ttwo
         usage_pct_ttwo = 0
         .
   END.
   ELSE DO:
      ASSIGN
         ttwo_usage_pct = (ttwo_usage_tot / ttwo2_usage_tot)
         usage_pct_ttwo = (usage_pct_ttwo + ttwo_usage_pct)
         .
   END.
END.

RETURN "yes".
