/* SS - 090607.1 By: Bill Jiang */

/* SS - 090607.1 - RNB
[090607.1]

错误:总账日历没维护,总账日历未结,已经初始化!

[090607.1]

SS - 090607.1 - RNE */

{mfdeclre.i}

DEFINE INPUT PARAMETER entity AS CHARACTER.
DEFINE INPUT PARAMETER yr AS INTEGER.
DEFINE INPUT PARAMETER per AS INTEGER.
DEFINE INPUT-OUTPUT PARAMETER START_glc LIKE glc_start.
DEFINE INPUT-OUTPUT PARAMETER END_glc LIKE glc_end.

DEFINE variable yr1 AS INTEGER.
DEFINE variable per1 AS INTEGER.

DEFINE VARIABLE find-can AS LOGICAL.

FIND FIRST glc_cal 
   WHERE glc_domain = GLOBAL_domain 
   AND glc_year = yr 
   AND glc_per = per
   NO-LOCK NO-ERROR.
IF NOT AVAILABLE glc_cal THEN DO:
   /* 无效期间/年份 */
   {pxmsg.i &MSGNUM=3008 &ERRORLEVEL=3}

   RETURN "no".
END.
ASSIGN
   START_glc = glc_start
   END_glc = glc_end
   .

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
   :
   /* 301604 - 成本结算记录已经存在 */
   {pxmsg.i &MSGNUM=301604 &ERRORLEVEL=3}

   RETURN "no".
END.

RETURN "yes".
