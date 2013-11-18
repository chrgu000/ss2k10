/* SS - 090807.1 By: Bill Jiang */

/* SS - 090807.1 - RNB

3.�ڿ�(��)Ʒ���ɱ���ת
             �ϴ����ɱ�
1)�Ӽ����� = ------------------------------------------------------
             �ڳ����� + �ջ����� + ������� + ���Ƴɱ���������������
2)�Ӽ����� = <�ӹ���������ʷ��¼�ļ�>.����
3)�Ӽ��ܳ� = �Ӽ����� * �Ӽ�����
4)�Ӽ����ɱ� = �Ӽ��ܳ� * <�ӹ������������ļ�>.�ڼ�������
5)ֱ���ϴ����ɱ�С�����õ��ݲ�

����ɹ�,�򷵻�"yes",���򷵻�"no"

SS - 090807.1 - RNE */

{mfdeclre.i}

{xxpcwipc.i}

DEFINE INPUT PARAMETER entity AS CHARACTER.
DEFINE INPUT PARAMETER yr AS INTEGER.
DEFINE INPUT PARAMETER per AS INTEGER.
DEFINE INPUT PARAMETER n AS INTEGER.

EMPTY TEMP-TABLE ttwipc.
FOR EACH si_mstr NO-LOCK
   WHERE si_domain = GLOBAL_domain
   AND si_entity = entity
   ,EACH xxpcwipc_det NO-LOCK
   WHERE xxpcwipc_domain = GLOBAL_domain
   AND xxpcwipc_site = si_site
   AND xxpcwipc_year = yr
   AND xxpcwipc_per = per
   AND xxpcwipc_n = (n - 1)
   ,EACH ttsp NO-LOCK
   WHERE ttsp_site = xxpcwipc_site
   AND ttsp_part = xxpcwipc_par
   BREAK 
   BY xxpcwipc_site
   BY xxpcwipc_par
   BY xxpcwipc_element
   :
   ACCUMULATE xxpcwipc_cst_rct (TOTAL 
                                BY xxpcwipc_site
                                BY xxpcwipc_par
                                BY xxpcwipc_element
                                ).
   IF LAST-OF(xxpcwipc_element) THEN DO:
      IF (ACCUMULATE TOTAL BY xxpcwipc_element xxpcwipc_cst_rct) = 0 OR ttsp_qty = 0 THEN DO:
         NEXT.
      END.

      CREATE ttwipc.
      ASSIGN
         ttwipc_site = xxpcwipc_site
         ttwipc_par = xxpcwipc_par
         ttwipc_element = xxpcwipc_element
         ttwipc_cst = (ACCUMULATE TOTAL BY xxpcwipc_element xxpcwipc_cst_rct) / ttsp_qty
         .
   END.
END.
