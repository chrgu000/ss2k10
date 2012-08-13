{mfdeclre.i}
{bcdeclre.i  }
{bcwin.i}

DEFINE INPUT PARAMETER rcttype AS CHAR.   /*receipt or return*/

DEFINE SHARED VARIABLE batchid LIKE b_shp_batch LABEL "批号".

DEFINE VARIABLE bfid LIKE b_bf_id.
DEFINE VARIABLE bfparid LIKE b_bf_id.
DEFINE VARIABLE succeed AS LOGICAL.

DEFINE BUTTON btn_exec LABEL "执行".
DEFINE BUTTON btn_quit LABEL "退出".

DEFINE TEMP-TABLE t_rct
    FIELD t_part LIKE b_rct_part
    FIELD t_qty LIKE b_rct_qty.

DEFINE QUERY q_rct FOR t_rct.
/*DEFINE BROWSE b_rct QUERY q_rct
    DISP
    b_rct_part LABEL "零件"
    b_rct_qty LABEL "数量"
    b_rct_batch LABEL "批号"
    b_rct_ponbr LABEL "订单"
    b_rct_podline LABEL "行"
    b_rct_site LABEL "入库地点"
    b_rct_loc LABEL "入库库位"
    b_rct_date LABEL "下达日期"
    WITH 12 DOWN WIDTH 29.7
    TITLE "收货清单".*/

DEFINE BROWSE b_rct QUERY q_rct
    DISP
    t_part LABEL "零件"
    t_qty LABEL "数量"
    WITH 12 DOWN WIDTH 28
    TITLE "收货清单".

DEFINE FRAME a
   SKIP(1)
    b_rct
    SKIP(.3)
    space(20)  SPACE(2)  btn_exec /*SPACE(2) btn_quit*/
 WITH  WIDTH 30  TITLE "采购收货"  SIDE-LABELS  NO-UNDERLINE THREE-D.


ON 'choose':U OF btn_exec
DO:
    btn_exec:SENSITIVE = FALSE.
    RUN exec.
    FOR EACH b_rct_wkfl WHERE b_rct_batch = batchid:
        ASSIGN b_rct_status = "YES".
    END.
    FOR EACH t_rct:
        DELETE t_rct.
    END.
    OPEN QUERY q_rct FOR EACH t_rct.
    btn_exec:SENSITIVE = TRUE.
    APPLY "ESC":U TO FRAME a.
    RETURN.
END.

FOR EACH b_rct_wkfl WHERE b_rct_batch =  batchid AND b_rct_status = ""
         BREAK BY b_rct_part:
    ACCUMULATE b_rct_qty (TOTAL BY b_rct_part).
    IF LAST-OF(b_rct_part) THEN DO:
        CREATE t_rct.
        ASSIGN t_part = b_rct_part
            t_qty = ACCUMU SUB-TOTAL BY b_rct_part b_rct_qty.
    END.
END.

OPEN QUERY q_rct FOR EACH t_rct.
REPEAT:
    UPDATE btn_exec WITH FRAME a.
END.



PROCEDURE exec:
 mainloop:
 DO ON ERROR UNDO,LEAVE:
     FOR EACH b_rct_wkfl WHERE b_rct_batch =  batchid AND b_rct_status = ""
         BREAK BY b_rct_ponbr  BY b_rct_part:
         ACCUMULATE b_rct_qty (TOTAL BY b_rct_ponbr BY b_rct_part).
         IF FIRST-OF(b_rct_ponbr) THEN DO:
             {gprun.i ""mgwrbf.p"" "(INPUT b_rct_ponbr,
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT b_rct_date,
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT b_rct_loc,
                                                  INPUT b_rct_site,
                                                  INPUT ""poporc.p"",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT YES,
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  OUTPUT bfid)"}
         /*b_bf_nbr*/  /*b_bf_line*/ /*b_bf_code*/ /*b_bf_part*/  /*b_bf_lot*/   /*b_bf_ser*/   /*b_bf_qty*/  /*b_bf_um*/  /*b_bf_enterdate*/ /*b_bf_tr_date*/ 
         /*b_bf_eff_date*/ /*b_bf_trtype*/  /*b_bf_trnbr*/  /*b_bf_ntime*/  /*b_bf_loc*/  /*b_bf_site*/  /*b_bf_program*/  /*b_bf_tosite*/ /*b_bf_toloc*/  
         /*b_bf_tolot*/ /*b_bf_toser*/  /*b_bf_tocim*/   /*b_bf_sess*/  /*b_bf_ref*/ /*b_bf_trid1*/  /*b_bf_trid2*/  /*b_bf_bc01*/  /*b_bf_bc02*/    /*b_bf_bc03*/  
         /*b_bf_bc04*/   /*b_bf_bc05*/ /*b_bf_emp*/   /*b_bf_par_id*/ /*b_bf_dataset*/ /*b_bf_abs_id*/
                 bfparid = bfid.
         END.

                 IF LAST-OF(b_rct_part) THEN DO:
                     DEFINE VARIABLE lotnbr LIKE ld_lot.
                     {gprun.i ""bcltcr.p"" "(input b_rct_part, output lotnbr)"}
                     {gprun.i ""mgwrbf.p"" "(INPUT b_rct_ponbr,
                                                         INPUT b_rct_podline,
                                                         INPUT b_rct_code,
                                                         INPUT b_rct_part,
                                                         INPUT lotnbr,
                                                         INPUT """",
                                                         INPUT ACCUMU TOTAL BY b_rct_part b_rct_qty,
                                                         INPUT """",
                                                         INPUT b_rct_date,
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT b_rct_loc,
                                                         INPUT b_rct_site,
                                                         INPUT ""poporc.p"",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT YES,
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT """",
                                                         INPUT bfparid,
                                                         INPUT ""pod_det"",
                                                         INPUT """",
                                                         OUTPUT bfid)"}
                 END.  /*last of part*/         

         IF LAST-OF(b_rct_ponbr) THEN DO:
             CASE rcttype:
                 WHEN "RCT" THEN DO:
                     {gprun.i ""mgwrfl.p"" "(input ""poporc.p"", input bfid)"}
                     {gprun.i ""mgecim01.p"" "(input bfid, output succeed)"} 
                 END.
                 WHEN "RTN" THEN DO:
                     {gprun.i ""mgwrfl.p"" "(input ""poporc.p"", input bfid)"}
                     {gprun.i ""mgecim0101.p"" "(input bfid, output succeed)"} 
                 END.
             END CASE.

             IF succeed = TRUE THEN DO:
                 {bcco004.i lotnbr}
                 IF b_rct_loc = "s001a" THEN DO:
                     {bcco002.i ""FINI-GOOD""}
                 END.
                 IF CAN-FIND (FIRST xshloc_mstr WHERE xshloc_yfk_loc = b_rct_loc
                              AND xshloc_part = b_rct_part) THEN DO:
                     {bcco002.i ""FINI-GOOD""}
                 END.
                 ELSE DO:
                     {bcco002.i ""MAT-STOCK""}
                 END.
                 STATUS INPUT "完成".
             END.
             ELSE DO:
                 STATUS INPUT "".
                 UNDO, LEAVE mainloop.
             END.
         END.  /*last-of ponbr*/

         
     END.  /*for each*/

     IF succeed THEN DO:
          FOR EACH b_rct_wkfl WHERE b_rct_batch =  batchid AND b_rct_status = "":
              FIND FIRST  b_co_mstr EXCLUSIVE-LOCK  WHERE b_co_code = b_rct_code NO-ERROR.
              IF AVAILABLE b_co_mstr THEN DO:
                  IF b_rct_loc = "s001a" THEN b_co_status = "FINI-GOOD".
                  IF b_rct_loc = "r001a"  THEN b_co_status = "MAT-STOCK".
              END.
          END.
     END.


     /*FIND FIRST b_bf_det WHERE b_bf_id = bfid NO-LOCK NO-ERROR.
     IF AVAILABLE b_bf_det THEN DO:
         FIND FIRST ABS_mstr NO-LOCK WHERE ABS_id = b_bf_absid NO-ERROR.
         IF AVAILABLE ABS_mstr THEN DO:
              {gprun.i ""xgicshprt2.p"" "(input recid(abs_mstr))"}
         END.
     END.*/

 


 END. /*do*/
END. /*procedure exec*/

 
