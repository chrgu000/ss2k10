{mfdeclre.i}
DEFINE SHARED VARIABLE cimcase AS CHARACTER.
DEFINE INPUT PARAMETER bfid AS INTEGER.

FOR FIRST b_ct_ctrl NO-LOCK:
END.

FIND FIRST b_bf_det  EXCLUSIVE-LOCK WHERE b_bf_tocim = YES /*AND b_bf_sess = g_user*/ AND b_bf_program = cimcase 
     AND b_bf_id = bfid NO-ERROR.
IF AVAILABLE b_bf_det THEN DO:
    OUTPUT TO VALUE(mfguser).
      PUT "@@batchload ". PUT  b_bf_program SKIP.
      PUT '"'.
      PUT UNFORMAT right-trim(b_bf_part).
      PUT '"'.
      PUT SKIP.
      PUT string(b_bf_qty_loc).
      PUT SKIP.
PUT '"'.
PUT UNFORMAT right-trim(b_bf_site).
PUT '"'.
PUT SPACE(1).
PUT '"'.
PUT UNFORMAT right-trim(b_bf_loc).
PUT '"'.
PUT SPACE(1).
PUT '"'.
PUT UNFORMAT right-trim(b_bf_lot).
PUT '"'.
PUT SPACE(1).
PUT '"'.
PUT UNFORMAT right-trim(b_bf_ref).
PUT '"'.
PUT SPACE(1).
PUT SKIP.
PUT '"'.
PUT UNFORMAT right-trim(b_bf_tosite).
PUT '"'.
PUT SPACE(1).
PUT '"'.
PUT UNFORMAT right-trim(b_bf_toloc).
PUT '"'.
PUT SKIP.
PUT 'y'.
PUT SKIP.
PUT "@@end".
   OUTPUT CLOSE.
END.  /*if available b_bf_det*/

