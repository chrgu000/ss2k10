{mfdeclre.i}
DEFINE SHARED VARIABLE cimcase AS CHARACTER.
DEFINE INPUT PARAMETER bfid AS INTEGER.

DEFINE BUFFER bf_det FOR b_bf_det.

FOR FIRST b_ct_ctrl NO-LOCK:
END.

FIND FIRST b_bf_det  EXCLUSIVE-LOCK WHERE b_bf_tocim = YES /*AND b_bf_sess = g_user*/ AND b_bf_program = cimcase 
     AND b_bf_id = bfid AND b_bf_par_id = 0 NO-ERROR.
IF AVAILABLE b_bf_det THEN DO:
     OUTPUT TO VALUE(mfguser).
     PUT "@@batchload ". PUT  b_bf_program SKIP.
     PUT '"'. PUT CONTROL  b_bf_nbr. PUT '"' SKIP.
     PUT  "- - ". PUT '"'. PUT CONTROL b_bf_date. PUT '"' SKIP.

     FOR EACH  bf_det NO-LOCK WHERE bf_det.b_bf_par_id =bfid:
         PUT CONTROL bf_det.b_bf_line. PUT "" SKIP.
         PUT CONTROL bf_det.b_bf_qty_loc.  PUT " - - - - - ". PUT '"'. PUT CONTROL bf_det.b_bf_site.
         PUT '" "'. PUT CONTROL bf_det.b_bf_loc. PUT '" "'. PUT CONTROL bf_det.b_bf_lot.   PUT '"' SKIP.
     END.


     PUT '.'. PUT SKIP.
     PUT "Y". PUT SKIP.
     PUT "Y". PUT SKIP.
     PUT '.'. PUT SKIP.
     PUT '.'. PUT SKIP.
     PUT "@@end".
    OUTPUT CLOSE.
END.  /*if available b_bf_det*/
