/* SS - 091112.1 By: Bill Jiang */

/* SS - 091112.1 - RNB
[091112.1]

����:��������ûά��,���������ѽ�,����δ��,�����ѽ�!

[091112.1]

SS - 091112.1 - RNE */

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
   /* ��Ч�ڼ�/��� */
   {pxmsg.i &MSGNUM=3008 &ERRORLEVEL=3}

   RETURN "no".
END.
ASSIGN
   START_glc = glc_start
   END_glc = glc_end
   .

/*
FOR EACH glcd_det NO-LOCK
   WHERE glcd_domain = GLOBAL_domain
   AND glcd_year = yr
   AND glcd_per = per
   AND glcd_entity = entity
   :
   IF glcd_gl_clsd = YES THEN DO:
      /* �ڼ��Ѿ��ر� */
      {pxmsg.i &MSGNUM=3023 &ERRORLEVEL=3}

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
   IF xxpcc_closed = YES THEN DO:
      /* 301604 - �ɱ������¼�Ѿ����� */
      {pxmsg.i &MSGNUM=301604 &ERRORLEVEL=3}

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
      /* ��Ч�ڼ�/��� */
      {pxmsg.i &MSGNUM=3008 &ERRORLEVEL=3}

      RETURN "no".
   END.
END.
ELSE DO:
   yr1 = yr.
   per1 = per - 1.
END.

find-can = NO.
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
   find-can = YES.

   IF xxpcc_closed = NO THEN DO:
      /* 301605 - ���ڳɱ������¼������ */
      {pxmsg.i &MSGNUM=301605 &ERRORLEVEL=3}

      RETURN "no".
   END.
END.
IF find-can = NO THEN DO:
   /* 301605 - ���ڳɱ������¼������ */
   {pxmsg.i &MSGNUM=301605 &ERRORLEVEL=3}

   RETURN "no".
END.
*/

RETURN "yes".
