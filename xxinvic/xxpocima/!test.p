/*  DEFINE VARIABLE id AS RECID.                                                     */
/*  ASSIGN id = CURRENT-VALUE(tr_sq01).                                              */
/*                                                                                   */
/*  FIND FIRST tr_hist WHERE tr_trnbr = integer(id) NO-ERROR.                        */
/*  IF AVAILABLE tr_hist THEN DO:                                                    */
/*      DISPLAY tr_hist  WITH 4 COLUMNS VIEW-AS DIALOG-BOX WITH WIDTH 130 STREAM-IO. */
/*      color disp input tr_trnbr tr_vend_lot.                                       */
/*      pause 100.                                                                   */
/*  END.                                                                             */

 FOR EACH  xxship_det NO-LOCK:
     DISPLAY xxship_det WITH 2 COLUMNS.
     COLOR DISP INPUT xxship_site xxship_rcvd_qty.
 END.
