/* 以下为版本历史 */                                                             
/* SS - 090819.1 By: Bill Jiang */

/* 共享 */

DEFINE {1} SHARED TEMP-TABLE tt1
   field tt1_status AS CHARACTER
   field tt1_index AS CHARACTER format "x(18)"
   field tt1_SoftspeedDI_VAT AS INTEGER
   field tt1_tr_trnbr like tr_trnbr
   field tt1_tr_part like tr_part
   field tt1_tr_effdate like tr_effdate
   field tt1_idh_qty_inv like idh_qty_inv
   field tt1_idh_price like idh_price
   field tt1_ih_inv_nbr like ih_inv_nbr
   field tt1_ih_nbr like ih_nbr
   field tt1_idh_line like idh_line
   field tt1_ih_po like ih_po
   field tt1_idh_custpart like idh_custpart
   field tt1_qty_open AS DECIMAL
   field tt1_qty_last AS DECIMAL
   field tt1_pt_desc1 like pt_desc1
   field tt1_pt_desc2 like pt_desc2
   INDEX tt1_index IS PRIMARY tt1_index ASCENDING
   .

DEFINE {1} SHARED VARIABLE INDEX_tt1 LIKE tt1_index.
DEFINE {1} SHARED VARIABLE idh_qty_inv_tt1 LIKE tt1_idh_qty_inv.

DEFINE {1} SHARED FRAME match_maintenance .

FORM
   index_tt1 COLON 18
   tt1_idh_price COLON 54

   tt1_pt_desc1 COLON 18
   tt1_pt_desc2 NO-LABEL
   
   tt1_ih_po COLON 18
   tt1_ih_inv_nbr COLON 54
   
   tt1_idh_custpart COLON 18
   tt1_ih_nbr COLON 54
   

   tt1_qty_open COLON 18
   idh_qty_inv_tt1 COLON 54
   tt1_idh_line
   with frame match_maintenance side-labels title color normal (getFrameTitle("RECEIVER_MATCHING_MAINTENANCE",41)) width 80 no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame match_maintenance:handle).

DEFINE {1} SHARED FRAME w.

form
   tt1_index
   tt1_tr_part
   tt1_tr_effdate
   tt1_qty_open
   with frame w scroll 1 4 down NO-VALIDATE ATTR-SPACE TITLE COLOR normal (getFrameTitle("RECEIVER_MATCHING_DETAIL",34))  WIDTH 80 .

/* SET EXTERNAL LABELS */
setFrameLabels(frame w:handle).
