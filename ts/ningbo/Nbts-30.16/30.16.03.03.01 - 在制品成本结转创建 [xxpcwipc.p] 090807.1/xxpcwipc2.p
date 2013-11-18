/* SS - 090807.1 By: Bill Jiang */

/* SS - 090807.1 - RNB

2.����Ʒ�ɱ���ת
             ���ڳ����ڼ�������ܳ� * �ڼ�������
4)�Ӽ����� = ------------------------------------------------------
             �ڳ����� + �ջ����� + ������� + ���Ƴɱ���������������

SS - 090807.1 - RNE */

{mfdeclre.i}

{xxpcwipc.i}

DEFINE INPUT PARAMETER entity AS CHARACTER.
DEFINE INPUT PARAMETER yr AS INTEGER.
DEFINE INPUT PARAMETER per AS INTEGER.

DEFINE VARIABLE cst_tot AS DECIMAL.

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
   BREAK
   BY xxpcwoi_site
   BY xxpcwoi_comp
   :
   IF FIRST-OF(xxpcwoi_comp) THEN DO:
      cst_tot = 0.
      {gprun.i ""xxpcwipc2c.p"" "(
         INPUT xxpcwoi_site,
         INPUT yr,
         INPUT per,
         INPUT xxpcwoi_comp
         )"}
   END.

   FOR EACH ttwoc:
      CREATE xxpcwipc_det.
      ASSIGN
         xxpcwipc_domain = GLOBAL_domain
         xxpcwipc_site = xxpcwoi_site
         xxpcwipc_year = yr
         xxpcwipc_per = per
         xxpcwipc_par = xxpcwoi_par
         xxpcwipc_lot = xxpcwoi_lot
         xxpcwipc_comp = xxpcwoi_comp
         xxpcwipc_n = 2
         xxpcwipc_element = ttwoc_element
         xxpcwipc_qty = - xxpcwoi_qty
         xxpcwipc_cst = ttwoc_cst
         xxpcwipc_cst_tot = ttwoc_cst * xxpcwipc_qty
         xxpcwipc_cst_rct = xxpcwipc_cst_tot * xxpcwo_pct_comp
         .
   END.
END.
