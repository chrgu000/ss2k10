
DEFINE SHARED VARIABLE cimcase AS CHARACTER.
DEFINE INPUT PARAMETER bfid AS INTEGER.

FOR FIRST b_ct_ctrl NO-LOCK:
END.

FIND FIRST b_bf_det  EXCLUSIVE-LOCK WHERE b_bf_tocim = YES /*AND b_bf_sess = g_user*/ AND b_bf_program = cimcase 
     AND b_bf_id = bfid NO-ERROR.
IF AVAILABLE b_bf_det THEN DO:
     OUTPUT TO "d:\temp\wowomt.cim".
     PUT "@@batchload ". PUT  b_bf_program SKIP.
     PUT '"'. PUT CONTROL  b_bf_nbr. PUT '"' SKIP.
     PUT '"'. PUT CONTROL b_bf_part. PUT '" - "'. PUT CONTROL b_bf_site. PUT '"' SKIP.
     PUT '"'. PUT CONTROL b_bf_qty_loc. PUT '" - - - "R"' SKIP.
     PUT "-" SKIP.
     PUT "-" SKIP.
     PUT "-" SKIP.
     PUT "." SKIP.
     PUT "." SKIP.
     PUT "@@end".
    OUTPUT CLOSE.
END.  /*if available b_bf_det*/
