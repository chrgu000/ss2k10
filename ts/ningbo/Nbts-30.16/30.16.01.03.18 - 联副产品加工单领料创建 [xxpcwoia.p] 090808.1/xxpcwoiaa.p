/* SS - 090808.1 By: Bill Jiang */
/* SS - 090808.1 - RNB

[090808.1]

更新联副产品

[090808.1]

SS - 090808.1 - RNE */

{mfdeclre.i}

DEFINE INPUT PARAMETER lot_wo LIKE wo_lot.

define shared workfile alloc_wkfl no-undo
   field alloc_wonbr as character
   field alloc_recid as recid
   field alloc_numer as decimal
   field alloc_pct   as decimal.

DEFINE SHARED TEMP-TABLE tt1
   field tt1_site LIKE xxpcwoi_site
   field tt1_year LIKE xxpcwoi_year
   field tt1_per LIKE xxpcwoi_per
   field tt1_par LIKE xxpcwoi_par
   field tt1_lot LIKE xxpcwoi_lot
   field tt1_comp LIKE xxpcwoi_comp
   field tt1_qty LIKE xxpcwoi_qty
   .

/* 写入联副产品 */
FOR EACH tt1
   WHERE tt1_lot = lot_wo
   :
   FOR EACH alloc_wkfl
      ,EACH wo_mstr NO-LOCK
      WHERE RECID(wo_mstr) = alloc_recid
      :
      CREATE xxpcwoi_hist.
      ASSIGN
         xxpcwoi_domain = GLOBAL_domain
         xxpcwoi_site = tt1_site
         xxpcwoi_year = tt1_year
         xxpcwoi_per = tt1_per
         xxpcwoi_par = wo_part
         xxpcwoi_lot = wo_lot
         xxpcwoi_comp = tt1_comp
         xxpcwoi_qty = tt1_qty * alloc_pct
         xxpcwoi_base_id = tt1_lot
         .
   END.
END.

/* 删除基本产品 */
FOR EACH tt1
   WHERE tt1_lot = lot_wo
   :
   FOR EACH xxpcwoi_hist EXCLUSIVE-LOCK
      WHERE xxpcwoi_domain = GLOBAL_domain
      AND xxpcwoi_site = tt1_site
      AND xxpcwoi_year = tt1_year
      AND xxpcwoi_per = tt1_per
      AND xxpcwoi_par = tt1_par
      AND xxpcwoi_lot = tt1_lot
      AND xxpcwoi_comp = tt1_comp
      :
      DELETE xxpcwoi_hist.
   END.
END.
