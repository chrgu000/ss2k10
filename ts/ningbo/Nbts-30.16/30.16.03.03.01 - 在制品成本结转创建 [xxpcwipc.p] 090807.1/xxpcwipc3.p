/* SS - 090807.1 By: Bill Jiang */

/* SS - 090807.1 - RNB

3.在库(制)品入库成本结转
             上次入库成本
1)子件单成 = ------------------------------------------------------
             期初数量 + 收货数量 + 入库数量 + 不计成本的其他增加数量
2)子件用量 = <加工单领料历史记录文件>.数量
3)子件总成 = 子件用量 * 子件单成
4)子件入库成本 = 子件总成 * <加工单增减存主文件>.期间入库比例
5)直到上次入库成本小于设置的容差

SS - 090807.1 - RNE */

{mfdeclre.i}

{xxpcwipc.i}

DEFINE INPUT PARAMETER entity AS CHARACTER.
DEFINE INPUT PARAMETER yr AS INTEGER.
DEFINE INPUT PARAMETER per AS INTEGER.

{gprun.i ""xxpcwipc3c.p"" "(
   INPUT entity,
   INPUT yr,
   INPUT per
   ")}

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
      xxpcwipc_n = 3
      xxpcwipc_element = ttwipc_element
      xxpcwipc_qty = - xxpcwoi_qty
      xxpcwipc_cst = ttwipc_cst
      xxpcwipc_cst_tot = ttwipc_cst * xxpcwipc_qty
      xxpcwipc_cst_rct = xxpcwipc_cst_tot * xxpcwo_pct_comp
      .
END.
