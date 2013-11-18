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

DEFINE VARIABLE cst_rct AS DECIMAL.

cst_rct = 0.
FOR EACH si_mstr NO-LOCK
   WHERE si_domain = GLOBAL_domain
   AND si_entity = entity
   ,EACH xxpcwipc_det NO-LOCK
   WHERE xxpcwipc_domain = GLOBAL_domain
   AND xxpcwipc_site = si_site
   AND xxpcwipc_year = yr
   AND xxpcwipc_per = per
   AND xxpcwipc_n = (n - 1)
   :
   cst_rct = cst_rct + xxpcwipc_cst_rct.
END.
IF abs(cst_rct) <= 0.000001 THEN DO:
   RETURN.
END.

{gprun.i ""xxpcwipcnc.p"" "(
   INPUT entity,
   INPUT yr,
   INPUT per,
   INPUT n
   )"}

FOR EACH si_mstr NO-LOCK
   WHERE si_domain = GLOBAL_domain
   AND si_entity = entity
   ,EACH xxpcwoi_hist NO-LOCK
   WHERE xxpcwoi_domain = GLOBAL_domain
   AND xxpcwoi_site = si_site
   AND xxpcwoi_year = yr
   AND xxpcwoi_per = per
   ,EACH xxpcwo_mstr NO-LOCK
   WHERE xxpcwo_domain = GLOBAL_domain
   AND xxpcwo_site = si_site
   AND xxpcwo_year = yr
   AND xxpcwo_per = per
   AND xxpcwo_part = xxpcwoi_par
   AND xxpcwo_lot = xxpcwoi_lot
   ,EACH ttwipc NO-LOCK
   WHERE ttwipc_site = si_site
   AND ttwipc_par = xxpcwoi_comp
   :
   CREATE xxpcwipc_det.
   ASSIGN
      xxpcwipc_domain = GLOBAL_domain
      xxpcwipc_site = xxpcwoi_site
      xxpcwipc_year = yr
      xxpcwipc_per = per
      xxpcwipc_par = xxpcwoi_par
      xxpcwipc_lot = xxpcwoi_lot
      xxpcwipc_comp = xxpcwoi_comp
      xxpcwipc_n = n
      xxpcwipc_element = ttwipc_element
      xxpcwipc_qty = - xxpcwoi_qty
      xxpcwipc_cst = ttwipc_cst
      xxpcwipc_cst_tot = ttwipc_cst * xxpcwipc_qty
      xxpcwipc_cst_rct = xxpcwipc_cst_tot * xxpcwo_pct_comp
      .
END.

n = n + 1.
{gprun.i ""xxpcwipcn.p"" "(
   INPUT entity,
   INPUT yr,
   INPUT per,
   INPUT n
   )"}
