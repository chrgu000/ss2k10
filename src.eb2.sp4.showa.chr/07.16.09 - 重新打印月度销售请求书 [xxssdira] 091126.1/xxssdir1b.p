
/* ����Ϊ�汾��ʷ */
/* SS - 090511.1 By: Bill Jiang */

/*����Ϊ����˵�� */
/* SS - 090511.1 - RNB
������Ż���������¶�������ϸһ����
SS - 090511.1 - RNE */

{mfdeclre.i }
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{xxssdir1.i}

/* �ͻ� */
FIND FIRST ad_mstr 
   WHERE /* ad_domain = GLOBAL_domain
   AND */ ad_addr = cust
   NO-LOCK NO-ERROR.
IF AVAILABLE ad_mstr THEN DO:
   PUT UNFORMATTED ad_name.
END.
ELSE DO:
   PUT UNFORMATTED cust.
END.

/* ������������ */
PUT UNFORMATTED ";������������: " 
   + SUBSTRING(STRING(YEAR(eff_dt)),3,2) + "��"
   + SUBSTRING(STRING(MONTH(eff_dt) + 1000),3,2) + "��"
   + SUBSTRING(STRING(DAY(eff_dt) + 1000),3,2) + "��"
   + " - "
   + SUBSTRING(STRING(YEAR(eff_dt1)),3,2) + "��"
   + SUBSTRING(STRING(MONTH(eff_dt1) + 1000),3,2) + "��"
   + SUBSTRING(STRING(DAY(eff_dt1) + 1000),3,2) + "��"
   .

/* �N �� Ո �� �� */
char1[1] = "".
IF part_type_pt <> "" THEN DO:
   char1[1] = char1[1] + "(" + part_type_pt + ")".
END.
char1[1] = char1[1] + STRING(MONTH(eff_dt1)) + '�¶�������ϸһ����'.
IF draw_pt <> '' THEN DO:
   char1[1] = char1[1] + "(" + draw_pt + ")".
END.
PUT UNFORMATTED ";" char1[1].

/* �ͻ�ȷ�� */
FIND FIRST cm_mstr 
   WHERE /* cm_domain = global_domain
   AND */cm_addr = cust
   NO-LOCK NO-ERROR.
IF AVAILABLE cm_mstr THEN DO:
   PUT UNFORMATTED ";" cm_sort + "ȷ��".
END.
ELSE DO:
   PUT UNFORMATTED ";" cust + "ȷ��".
END.

/* ���� */
FIND FIRST usr_mstr 
   WHERE usr_userid = GLOBAL_userid
   NO-LOCK NO-ERROR.
IF AVAILABLE usr_mstr THEN DO:
   PUT UNFORMATTED ";" usr_name.
END.
ELSE DO:
   PUT UNFORMATTED ";" GLOBAL_userid.
END.

/* ���� */
PUT UNFORMATTED ";" 
   SUBSTRING(STRING(YEAR(TODAY)),3,2) + "��"
   + SUBSTRING(STRING(MONTH(TODAY) + 1000),3,2) + "��"
   + SUBSTRING(STRING(DAY(TODAY) + 1000),3,2) + "��"
   .

/* �������б�����ͬ���� */
PUT UNFORMATTED ";;;".
PUT SKIP.

/* ������1 */
PUT UNFORMATTED "��;����;ɫ��;��".
PUT UNFORMATTED ";��;�ϼ�;˰;˰;��˰" SKIP.

/* ������2 */
/* �Ȱ���� */
PUT UNFORMATTED "��;(��Ʒ��);����;��".
PUT UNFORMATTED ";λ;���;��;��;���" SKIP.

/* ��ϸ */
line1[1] = 0.
/* �Ȱ���� */
FOR EACH tt2 
   BREAK
   BY tt2_inv
   BY tt2_part
   :
   IF FIRST-OF(tt2_inv) THEN DO:
      line1[1] = 0.
   END.

   FIND pt_mstr 
      WHERE /* pt_domain = GLOBAL_domain
      AND */ pt_part = tt2_part
      NO-LOCK NO-ERROR.
   line1[1] = line1[1] + 1.
   DO line1[2] = 1 TO 3:
      /* ��ϸ��1 */
      IF line1[2] = 1 THEN DO:
         PUT UNFORMATTED "".
         /* �ͻ�������� */
         IF tt2_custpart <> "" THEN DO:
            PUT UNFORMATTED ";" tt2_custpart.
         END.
         ELSE DO:
            PUT UNFORMATTED ";" tt2_part.
         END.
         /* ɫ�� */
         IF AVAILABLE pt_mstr THEN DO:
            PUT UNFORMATTED ";" pt_draw.
         END.
         ELSE DO:
            PUT UNFORMATTED ";".
         END.
         PUT UNFORMATTED ";;;;;;" SKIP.
      END. /* IF line1[2] = 1 THEN DO: */
      /* ��ϸ��2 */
      ELSE IF line1[2] = 2 THEN DO:
         /* ��� */
         PUT UNFORMATTED "" tt2_inv + STRING(line1[1]).
         /* ����(��Ʒ��) */
         FIND FIRST cp_mstr
            WHERE /* cp_domain = GLOBAL_domain
            AND */ cp_cust = cust
            AND cp_cust_part = tt2_custpart
            NO-LOCK NO-ERROR.
         IF AVAILABLE cp_mstr THEN DO:
            PUT UNFORMATTED ";" cp_cust_partd.
         END. /* IF AVAILABLE cp_mstr THEN DO: */
         ELSE DO:
            IF AVAILABLE pt_mstr THEN DO:
               PUT UNFORMATTED ";" pt_desc1 + pt_desc2.
            END.
            ELSE DO:
               PUT UNFORMATTED ";".
            END.
         END.
         /* ���� */
         PUT UNFORMATTED ";" ROUND((tt2_amt / tt2_qty),2).
         PUT UNFORMATTED ";" tt2_qty ";" tt2_um ";" tt2_amt ";17%;" ROUND((tt2_amt * 0.17),2) ";" ROUND((tt2_amt * 1.17),2) SKIP.
      END. /* ELSE IF line1[2] = 2 THEN DO: */
      /* ��ϸ��3 */
      ELSE IF line1[2] = 3 THEN DO:
         PUT UNFORMATTED "".
         /* TODO: ����(��Ʒ��) */
         PUT UNFORMATTED ";".
         PUT UNFORMATTED ";".
         PUT UNFORMATTED ";;;;;;" SKIP.
      END. /* ELSE IF line1[2] = 3 THEN DO: */
   END. /* DO line1[2] = 1 TO 3: */
END. /* FOR EACH tt2 */

/* �ϼ� */
PUT UNFORMATTED "�ϼ�;;".
PUT UNFORMATTED ";;;" amt_tot[1] ";;" ROUND((amt_tot[1] * 0.17),2) ";" ROUND((amt_tot[1] * 1.17),2) SKIP.
