{mfdeclre.i}
{bcdeclre.i}

DEFINE SHARED VARIABLE cimcase AS CHARACTER.
DEFINE INPUT PARAMETER bfid AS INTEGER.

DEFINE BUFFER bf_det FOR b_bf_det.

FOR FIRST b_ct_ctrl NO-LOCK:
END.

/*������һ����������EB2SP9 ��7��9��8��CIM��ʽ�ļ���YFK�������ͬ����Ҫר�õ�һ�ס�*/
/*
FIND FIRST b_bf_det  NO-LOCK WHERE b_bf_tocim = YES /*AND b_bf_sess = g_user*/ AND b_bf_program = cimcase 
     AND b_bf_id = bfid AND b_bf_par_id = 0 NO-ERROR.
IF AVAILABLE b_bf_det THEN DO:
     OUTPUT TO "d:\temp\rcshmt.cim".
     PUT "@@batchload ". PUT  b_bf_program SKIP.
     PUT '"'. PUT CONTROL  b_bf_site. PUT '"'. PUT ' "" '. PUT '"'. PUT CONTROL  b_bf_bc01. PUT '" -' SKIP.
     PUT "-" SKIP.
     PUT "." SKIP.

     FOR EACH bf_det NO-LOCK WHERE bf_det.b_bf_par_id =bfid:
     PUT '"'. PUT CONTROL bf_det.b_bf_nbr. PUT '" '. PUT CONTROL bf_det.b_bf_line. PUT SKIP.
     PUT CONTROL bf_det.b_bf_qty_loc.  PUT " - - - - ". PUT '"'. PUT CONTROL bf_det.b_bf_lot. PUT '"' SKIP. 
     END.

     PUT "." SKIP.
     PUT '-'. PUT SKIP.
     PUT '-'. PUT SKIP.
     PUT '-'. PUT SKIP.
     PUT '.'. PUT SKIP.
     PUT "Y" SKIP.
     PUT "." SKIP.
     PUT "@@end".
    OUTPUT CLOSE.
END.  /*if available b_bf_det*/
*/





/*������YFKר�ø�ʽ*/

FIND FIRST b_bf_det  NO-LOCK WHERE b_bf_tocim = YES /*AND b_bf_sess = g_user*/ AND b_bf_program = cimcase 
     AND b_bf_id = bfid AND b_bf_par_id = 0 NO-ERROR.
IF AVAILABLE b_bf_det THEN DO:
     OUTPUT TO value(mfguser).
     PUT "@@batchload ". PUT  b_bf_program SKIP.
     PUT '"'. PUT CONTROL  b_bf_site. PUT '"'. PUT ' "'. PUT CONTROL b_bf_abs_id. PUT '" '. PUT '"'. PUT CONTROL  b_bf_bc01. PUT '"' SKIP.
     PUT "-" SKIP.
     PUT "." SKIP.

     FOR EACH bf_det NO-LOCK WHERE bf_det.b_bf_par_id =bfid:
     PUT '"'. PUT CONTROL b_bf_part. PUT '"'. PUT ' "" "" "" "" ""' SKIP.
     PUT '"'. PUT CONTROL bf_det.b_bf_qty_loc. PUT '"'.  PUT " - - ". PUT '"'. PUT CONTROL bf_det.b_bf_site. PUT '" - '. 
                 /*PUT CONTROL bf_det.b_bf_lot.*/ PUT "-". PUT ' - no no' SKIP. 
     END.

     PUT "." SKIP.
     PUT ".". PUT SKIP.
     PUT ".". PUT SKIP.

     PUT "@@end".
    OUTPUT CLOSE.
END.  /*if available b_bf_det*/
