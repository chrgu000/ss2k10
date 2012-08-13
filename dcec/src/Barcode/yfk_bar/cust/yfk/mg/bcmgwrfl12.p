 {bcdeclre.i}

DEFINE SHARED VARIABLE cimcase AS CHARACTER.
DEFINE INPUT PARAMETER bfid AS INTEGER.
     /*DEF SHARED TEMP-TABLE t_error
        FIELD t_er_code AS CHAR FORMAT "x(18)"
       FIELD t_er_mess AS CHAR FORMAT "x(30)".*/
     /*   DEF SHARED TEMP-TABLE btrid_tmp
            FIELD btrid LIKE b_tr_id.*/
        FIND FIRST b_ct_ctrl NO-LOCK NO-ERROR.

FIND FIRST b_bf_det  EXCLUSIVE-LOCK WHERE b_bf_tocim = YES /*AND b_bf_sess = g_user*/ AND b_bf_program = cimcase 
     AND b_bf_id = bfid NO-ERROR.
IF AVAILABLE b_bf_det THEN DO:

    OUTPUT TO 'd:\temp\woisrc.cim'.
     PUT "@@batchload ". PUT  b_bf_program SKIP.
     PUT '"'. PUT CONTROL b_bf_nbr.  PUT '"' SKIP.
     PUT '"'. PUT CONTROL b_bf_qty_loc. PUT '" - - - - - - - "'. put control b_bf_lot. PUT '"' SKIP.
     PUT "-"  SKIP. 
     PUT "" SKIP.
     PUT "" SKIP.
     PUT "-" SKIP.
     PUT "-" SKIP.
     PUT "-" SKIP.
     PUT "." SKIP.
     PUT "" SKIP.
     PUT "" SKIP.
     PUT "" SKIP.
     PUT "@@end".
    OUTPUT CLOSE.

END.
