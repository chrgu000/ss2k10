/* SS - 091111.1 By: Bill Jiang */

/* SS - 091111.1 - RNB
错误:总账日历没维护,总账日历未结,上期未结,本期未结!
SS - 091111.1 - RNE */

{mfdeclre.i}

DEFINE INPUT PARAMETER entity AS CHARACTER.
DEFINE INPUT PARAMETER yr AS INTEGER.
DEFINE INPUT PARAMETER per AS INTEGER.

DEFINE VARIABLE yr1 AS INTEGER.
DEFINE VARIABLE per1 AS INTEGER.

IF NOT CAN-FIND(FIRST glc_cal WHERE glc_domain = GLOBAL_domain AND glc_year = yr AND glc_per = per) THEN DO:
   /* 无效期间/年份 */
   {pxmsg.i &MSGNUM=3008 &ERRORLEVEL=3}

   RETURN "no".
END.

FOR EACH glcd_det NO-LOCK
   WHERE glcd_domain = GLOBAL_domain
   AND glcd_year = yr
   AND glcd_per = per
   AND glcd_entity = entity
   :
   IF glcd_gl_clsd = NO THEN DO:
      /* 无效期间/年份 */
      {pxmsg.i &MSGNUM=3008 &ERRORLEVEL=3}

      RETURN "no".
   END.
END.

FOR EACH en_mstr NO-LOCK
   WHERE en_domain = GLOBAL_domain
   AND en_entity = entity
   ,EACH si_mstr NO-LOCK
   WHERE si_domain = GLOBAL_domain
   AND si_entity = en_entity
   ,EACH xxpcc_det NO-LOCK
   WHERE xxpcc_domain = GLOBAL_domain
   AND xxpcc_site = si_site
   AND xxpcc_year = yr
   AND xxpcc_per = per
   :
   IF xxpcc_closed = NO THEN DO:
      /* 301616 - 成本结算记录不存在 */
      {pxmsg.i &MSGNUM=301616 &ERRORLEVEL=3}

      RETURN "no".
   END.
END.

IF per = 1 THEN DO:
   yr1 = yr - 1.
   per1 = 0.
   FOR EACH glc_cal NO-LOCK
      WHERE glc_domain = GLOBAL_domain
      AND glc_year = yr1
      BY glc_per DESC
      :
      per1 = glc_per.
      LEAVE.
   END.
   IF per1 = 0 THEN DO:
      /* 无效期间/年份 */
      {pxmsg.i &MSGNUM=3008 &ERRORLEVEL=3}

      RETURN "no".
   END.
END.
ELSE DO:
   yr1 = yr.
   per1 = per - 1.
END.

FOR EACH en_mstr NO-LOCK
   WHERE en_domain = GLOBAL_domain
   AND en_entity = entity
   ,EACH si_mstr NO-LOCK
   WHERE si_domain = GLOBAL_domain
   AND si_entity = en_entity
   ,EACH xxpcc_det NO-LOCK
   WHERE xxpcc_domain = GLOBAL_domain
   AND xxpcc_site = si_site
   AND xxpcc_year = yr1
   AND xxpcc_per = per1
   :
   IF xxpcc_closed = NO THEN DO:
      /* 301605 - 上期成本结算记录不存在 */
      {pxmsg.i &MSGNUM=301605 &ERRORLEVEL=3}

      RETURN "no".
   END.
END.

RETURN "yes".
