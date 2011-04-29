/* wopkall.p - WORK ORDER PICK LIST HARD ALLOCATIONS                    */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:WebEnabled=No                                             */
/* REVISION: 6.0      LAST MODIFIED: 05/03/90   BY: MLB **D024**/
/* REVISION: 6.0      LAST MODIFIED: 05/30/90   BY: emb */
/* REVISION: 6.0      LAST MODIFIED: 10/07/91   BY: alb *D887*(rev only) */
/* REVISION: 7.3      LAST MODIFIED: 02/08/93   BY: emb *G656*/
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan    */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* myb           */
/* Revision: eB.SP5.Chui    Modified: 08/14/06  By: Kaine Zhang     *ss-20060818.1* */
/* Revision: eB.SP5.Chui    Modified: 09/12/06  By: Kaine Zhang     *ss-20060912.1* */


     define shared variable wod_recno as recid.
     define shared variable qty_to_all like wod_qty_all.

     define variable all_this_loc like wod_qty_all.
     define buffer lddet for ld_det.
     define variable this_lot like ld_lot.

    /* ***********************ss-20060818.1 B Add********************** */
    DEFINE SHARED VARIABLE rcdXwtp AS RECID NO-UNDO.
    
    DEFINE TEMP-TABLE tmploc_tmp NO-UNDO
        FIELD tmploc_loc    LIKE    loc_loc
        FIELD tmploc_lev    AS      INTEGER
        /* ********************ss-20060818.1 B Del*******************
         *  ss-20060818.1: not necessary to use index...
         *  INDEX tmploc_lev
         *      IS PRIMARY
         *      tmploc_lev
         * ********************ss-20060818.1 E Del*******************/
        .
    /* ***********************ss-20060818.1 E Add********************** */

     find first icc_ctrl no-lock.
     find wod_det where recid(wod_det) = wod_recno.
     
     
    
     this_lot = ?.

     if qty_to_all > 0 then do:


        /* ***********************ss-20060818.1 B Add********************** */
        EMPTY TEMP-TABLE tmploc_tmp .
        
        FOR FIRST xwtp_det
            WHERE RECID(xwtp_det) = rcdXwtp
            NO-LOCK:
        END.
        
        IF AVAILABLE xwtp_det THEN DO:
            CREATE tmploc_tmp.
            ASSIGN
                tmploc_loc = xwtp_loc
                tmploc_lev = 0
                .
        END.
        
        FOR EACH loc_mstr WHERE loc_site = wod_site
            AND (NOT
                /*ss-20060912.1*  CAN-FIND(xwtp_det WHERE xwtp_site = loc_site AND xwtp_loc = loc_loc NO-LOCK)  */
                /*ss-20060912.1*/ CAN-FIND(FIRST xwtp_det WHERE xwtp_site = loc_site AND xwtp_loc = loc_loc NO-LOCK)
                )
            AND loc_type <> "sub"
            NO-LOCK
            :
            FIND FIRST tmploc_tmp WHERE tmploc_loc = loc_loc NO-ERROR.
            IF NOT AVAILABLE tmploc_tmp THEN DO:
                CREATE tmploc_tmp.
                ASSIGN
                    tmploc_loc = loc_loc
                    tmploc_lev = 1
                    .
            END.
        END.
        /* ***********************ss-20060818.1 E Add********************** */


        find pt_mstr where pt_part = wod_part no-lock no-error.
        if pt_sngl_lot then do:
           find first lad_det no-lock where lad_dataset = "wod_det"
/*G656*        and lad_nbr = wod_nbr and lad_line = wod_lot */
/*G656*/       and lad_nbr = wod_lot and lad_line = string(wod_op)
           and lad_part = wod_part
           and (lad_qty_all > 0 or lad_qty_pick > 0) no-error.
           if available lad_det then this_lot = lad_lot.
        end.

        if icc_ascend then do:
           if icc_pk_ord <= 2 then do:
          /*ss-20060818.1*  {wopkall.i  */
          /*ss-20060818.1*/ {xxwopkall.i
           &sort1 = "(if icc_pk_ord = 1 then ld_loc else ld_lot)" }
           end.
           else do:
          /*ss-20060818.1*  {wopkall.i  */
          /*ss-20060818.1*/ {xxwopkall.i
          &sort1 = "(if icc_pk_ord = 3 then ld_date else ld_expire)" }
           end.
        end.
        else do:
           if icc_pk_ord <= 2 then do:
          /*ss-20060818.1*  {wopkall.i  */
          /*ss-20060818.1*/ {xxwopkall.i
          &sort1 = "(if icc_pk_ord = 1 then ld_loc else ld_lot)"
          &sort2 = "descending"}
           end.
           else do:
          /*ss-20060818.1*  {wopkall.i  */
          /*ss-20060818.1*/ {xxwopkall.i
          &sort1 = "(if icc_pk_ord = 3 then ld_date else ld_expire)"
          &sort2 = "descending"}
           end.
        end.
     end.
