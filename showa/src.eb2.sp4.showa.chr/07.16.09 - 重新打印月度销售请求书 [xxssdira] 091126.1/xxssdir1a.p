
/* ����Ϊ�汾��ʷ */
/* SS - 090511.1 By: Bill Jiang */

/*����Ϊ����˵�� */
/* SS - 090511.1 - RNB
������ź����ڻ���������¶�����������
SS - 090511.1 - RNE */

/* ss - 091125.1 by: jack */
/* ss - 091126.1 by: jack */

{mfdeclre.i }
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{xxssdir1.i}

    DEFINE VAR v_name LIKE ad_name .
    DEFINE VAR v_desc LIKE pt_desc1 .

    /* ss - 091125.1 -b */
    EXPORT DELIMITER ";" "�ͻ�����" "�ͻ�����" "ERPͼ��"  "�ͻ�ͼ��" "��������"  "����" "����˰����Ʊ����"  "����˰���"  "˰��" "��˰���" "�ұ�" . 
    /* ss - 091125.1 -e */
/* �ͻ� */
FIND FIRST ad_mstr 
   WHERE /* ad_domain = GLOBAL_domain
   AND */ ad_addr = cust
   NO-LOCK NO-ERROR.
IF AVAILABLE ad_mstr THEN DO:
   v_name = ad_name.
END.
ELSE DO:
  v_name = "" .
END.

/* ss - 091125.1 -b */
IF summary_only THEN DO:
FOR EACH ttb BREAK BY month(ttb_effdate) BY ttb_part  :
    ACCUMULATE ttb_qty (TOTAL BY ttb_part) .
    ACCUMULATE ttb_inv_amt (TOTAL BY  ttb_part) .
    ACCUMULATE ttb_tax ( TOTAL BY  ttb_part) .
    ACCUMULATE ttb_tax_amt ( TOTAL BY  ttb_part ) .

    IF LAST-OF( ttb_part ) THEN DO:
        FIND FIRST pt_mstr WHERE pt_part = ttb_part NO-LOCK NO-ERROR .
        IF AVAILABLE pt_mstr THEN
            v_desc = pt_desc1 .
        ELSE 
            v_desc = "" .

      EXPORT DELIMITER ";" cust v_name ttb_part ttb_custpart   v_desc  ROUND ( ( ACCUMULATE TOTAL BY  ttb_part ttb_qty  )  , 2 )  ttb_list_price 
         ROUND (  ( ACCUMULATE TOTAL BY  ttb_part ttb_inv_amt ) , 2 ) ROUND (  ( ACCUMULATE TOTAL BY  ttb_part ttb_tax ) , 2 ) 
           ROUND (  ( ACCUMULATE TOTAL BY  ttb_part ttb_tax_amt  )  , 2 )  ttb_curr .
    END.

END.
END.
ELSE DO:
    FOR EACH ttb BREAK BY month(ttb_effdate) BY ttb_part  :
       FIND FIRST pt_mstr WHERE pt_part = ttb_part NO-LOCK NO-ERROR .
        IF AVAILABLE pt_mstr THEN
            v_desc = pt_desc1 .
        ELSE 
            v_desc = "" .

             EXPORT DELIMITER ";" cust v_name ttb_part ttb_custpart   v_desc   ttb_qty   ttb_list_price ttb_inv_amt  ttb_tax   ttb_tax_amt  ttb_curr .

    END.
END.
/* ss - 091125.1 -e */


/* ss - 091125.1 -b
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
char1[1] = char1[1] + STRING(MONTH(eff_dt1)) + '�¶�����������'.
IF draw_pt <> '' THEN DO:
   char1[1] = char1[1] + "(" + draw_pt + ")".
END.
PUT UNFORMATTED ";" char1[1].

/* �ͻ�ȷ�� */
FIND FIRST cm_mstr 
   WHERE /* cm_domain = global_domain
   AND */ cm_addr = cust
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
FOR EACH tt3:
   PUT UNFORMATTED ";".
END.
PUT SKIP.

/* ������1 */
PUT UNFORMATTED "��;����;ɫ��".
/* �ٰ����� */
FOR EACH tt3
   BY tt3_effdate
   :
   PUT UNFORMATTED ";" + STRING(MONTH(tt3_effdate)) + "/" + STRING(DAY(tt3_effdate)).
END. /* FOR EACH tt3 */
PUT UNFORMATTED ";��;�ϼ�;�ϼ�" SKIP.

/* ������2 */
/* �Ȱ���� */
PUT UNFORMATTED "��;(��Ʒ��);����".
/* �ٰ����� */
FOR EACH tt3
   BY tt3_effdate
   :
   PUT UNFORMATTED ";����".
END. /* FOR EACH tt3 */
PUT UNFORMATTED ";λ;����;���" SKIP.

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
         /* �ٰ����� */
         FOR EACH tt3 BY tt3_effdate:
            PUT UNFORMATTED ";".
         END. /* FOR EACH tt3 */
         PUT UNFORMATTED ";;;" SKIP.
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
         /* �ٰ����� */
         FOR EACH tt3 BY tt3_effdate:
            /* �����ϸ */
            FIND FIRST tt1
               WHERE tt1_part = tt2_part
               AND tt1_effdate = tt3_effdate
               NO-LOCK NO-ERROR.
            IF AVAILABLE tt1 THEN DO:
               PUT UNFORMATTED ";" tt1_qty.
            END.
            ELSE DO:
               PUT UNFORMATTED ";".
            END.
         END. /* FOR EACH tt3 */
         PUT UNFORMATTED ";" tt2_um ";" tt2_qty ";" tt2_amt SKIP.
      END. /* ELSE IF line1[2] = 2 THEN DO: */
      /* ��ϸ��3 */
      ELSE IF line1[2] = 3 THEN DO:
         PUT UNFORMATTED "".
         /* TODO: ����(��Ʒ��) */
         PUT UNFORMATTED ";".
         PUT UNFORMATTED ";".
         /* �ٰ����� */
         FOR EACH tt3 BY tt3_effdate:
            PUT UNFORMATTED ";".
         END. /* FOR EACH tt3 */
         PUT UNFORMATTED ";;;" SKIP.
      END. /* ELSE IF line1[2] = 3 THEN DO: */
   END. /* DO line1[2] = 1 TO 3: */
END. /* FOR EACH tt2 */

/* �ϼ���1 */
PUT UNFORMATTED "�ϼƽ��;;".
/* �ٰ����� */
FOR EACH tt3
   BY tt3_effdate
   :
   PUT UNFORMATTED ";".
END. /* FOR EACH tt3 */
PUT UNFORMATTED ";;;" amt_tot[1] SKIP.

/* �ϼ���2 */
PUT UNFORMATTED "17%��ֵ˰;;".
/* �ٰ����� */
FOR EACH tt3
   BY tt3_effdate
   :
   PUT UNFORMATTED ";".
END. /* FOR EACH tt3 */
PUT UNFORMATTED ";;;" ROUND((amt_tot[1] * 0.17),2) SKIP.

/* �ϼ���3 */
PUT UNFORMATTED "�����ܽ��ϼ�;;".
/* �ٰ����� */
FOR EACH tt3
   BY tt3_effdate
   :
   PUT UNFORMATTED ";".
END. /* FOR EACH tt3 */
PUT UNFORMATTED ";;;" ROUND((amt_tot[1] * 1.17),2) SKIP.
                        
ss - 091125.1 -e */
