/* SS - 090807.1 By: Bill Jiang */

/* SS - 090807.1 - RNB

1.�ڿ�Ʒ�ɱ���ת
1)�Ӽ����� = <�ӹ���������ʷ��¼�ļ�>.����
2)�Ӽ��ܳ� = �Ӽ����� * <�ڿ�Ʒ�ɱ�������ϸ�ļ�(1)>.�ڼ����
3)�Ӽ����ɱ� = �Ӽ��ܳ� * <�ӹ������������ļ�>.�ڼ�������

SS - 090807.1 - RNE */

{mfdeclre.i}

DEFINE INPUT PARAMETER entity AS CHARACTER.
DEFINE INPUT PARAMETER yr AS INTEGER.
DEFINE INPUT PARAMETER per AS INTEGER.

FOR EACH si_mstr NO-LOCK
   WHERE si_domain = GLOBAL_domain
   AND si_entity = entity
   ,EACH xxpcwoi_hist NO-LOCK
   WHERE xxpcwoi_domain = GLOBAL_domain
   AND xxpcwoi_site = si_site
   AND xxpcwoi_year = yr
   AND xxpcwoi_per = per
   ,EACH xxpcinc_det NO-LOCK
   WHERE xxpcinc_domain = GLOBAL_domain
   AND xxpcinc_site = si_site
   AND xxpcinc_year = yr
   AND xxpcinc_per = per
   AND xxpcinc_part = xxpcwoi_comp
   ,EACH xxpcwo_mstr NO-LOCK
   WHERE xxpcwo_domain = GLOBAL_domain
   AND xxpcwo_site = si_site
   AND xxpcwo_year = yr
   AND xxpcwo_per = per
   AND xxpcwo_part = xxpcwoi_par
   AND xxpcwo_lot = xxpcwoi_lot
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
      xxpcwipc_n = 1
      xxpcwipc_element = xxpcinc_element
      xxpcwipc_qty = - xxpcwoi_qty
      xxpcwipc_cst = xxpcinc_cst
      xxpcwipc_cst_tot = xxpcwipc_qty * xxpcwipc_cst
      xxpcwipc_cst_rct = xxpcwipc_cst_tot * xxpcwo_pct_comp
      .
END.
