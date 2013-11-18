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

如果成功,则返回"yes",否则返回"no"

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
