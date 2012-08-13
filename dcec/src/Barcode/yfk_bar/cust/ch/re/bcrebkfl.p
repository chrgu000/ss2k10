
{mfdeclre.i}
{bcdeclre.i}
{bcini.i}
{bcwin.i}


DEFINE VARIABLE bfid LIKE b_bf_id.
DEFINE VARIABLE suc AS LOGICAL.
DEFINE VARIABLE bfparid LIKE b_bf_id.

DEFINE BUTTON btn_exec LABEL "执行".
DEFINE BUTTON btn_quit LABEL "退出".

DEFINE QUERY q_bkf FOR b_bkf_wkfl.
DEFINE BROWSE b_bkf QUERY q_bkf
    DISPLAY
    b_bkf_part LABEL "零件"
    b_bkf_qty LABEL "数量"
    b_bkf_eff_date LABEL "生效日期"
    b_bkf_shift  LABEL "班次"
    b_bkf_op LABEL "工序"
    b_bkf_site LABEL "地点"
    b_bkf_line LABEL "生产线"
    b_bkf_date LABEL "回冲日期"
    WITH 12 DOWN WIDTH 29.7
    TITLE "回冲清单".

DEFINE FRAME a
    b_bkf
    SKIP(.3)
    space(17)  SPACE(1)  btn_exec SPACE(1) btn_quit
 WITH  SIZE 30 BY 18 TITLE "生产入库"  SIDE-LABELS  NO-UNDERLINE THREE-D.



ON 'choose':U OF btn_exec
DO:
    RUN exec.
    OPEN QUERY q_bkf FOR EACH b_bkf_wkfl WHERE b_bkf_status = "TOBK".
    RETURN.
END.


OPEN QUERY q_bkf FOR EACH b_bkf_wkfl WHERE b_bkf_status = "TOBK".
ENABLE ALL WITH FRAME a.
{bctrail.i}

PROCEDURE exec:
 DO ON ERROR UNDO,LEAVE:
     FOR EACH b_bkf_wkfl WHERE b_bkf_status = "TOBK"
         BREAK  BY b_bkf_eff_date  BY b_bkf_part BY b_bkf_line:
         {bcco001.i b_bkf_code b_bkf_part b_bkf_qty "" "" "" "" }
         ASSIGN b_bkf_status = "HOLD".
         ACCUMULATE b_bkf_qty (TOTAL BY b_bkf_eff_date BY b_bkf_part BY b_bkf_line).
         IF LAST-OF(b_bkf_line) THEN DO:
             {bcrun.i ""bcmgwrbf.p"" "(INPUT """",
                                                  INPUT """",
                                                  INPUT b_bkf_code,
                                                  INPUT b_bkf_part,
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT ACCUMU TOTAL BY b_bkf_line b_bkf_qty,
                                                  INPUT """",
                                                  INPUT b_bkf_eff_date,
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT b_bkf_site,
                                                  INPUT ""rebkfl.p"",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT YES,
                                                  INPUT """",
                                                  INPUT b_bkf_op,
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT b_bkf_line,
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT b_bkf_emp,
                                                  INPUT """",
                                                  INPUT ""rps_mstr"",
                                                  INPUT """",
                                                  OUTPUT bfid)"}
         /*b_bf_nbr*/  /*b_bf_line*/ /*b_bf_code*/ /*b_bf_part*/  /*b_bf_lot*/   /*b_bf_ser*/   /*b_bf_qty*/  /*b_bf_um*/  /*b_bf_enterdate*/ /*b_bf_tr_date*/ 
         /*b_bf_eff_date*/ /*b_bf_trtype*/  /*b_bf_trnbr*/  /*b_bf_ntime*/  /*b_bf_loc*/  /*b_bf_site*/  /*b_bf_program*/  /*b_bf_tosite*/ /*b_bf_toloc*/  
         /*b_bf_tolot*/ /*b_bf_toser*/  /*b_bf_tocim*/   /*b_bf_sess*/  /*b_bf_ref*/ /*b_bf_trid1*/  /*b_bf_trid2*/  /*b_bf_bc01*/  /*b_bf_bc02*/    /*b_bf_bc03*/  
         /*b_bf_bc04*/   /*b_bf_bc05*/ /*b_bf_emp*/   /*b_bf_par_id*/ /*b_bf_dataset*/ /*b_bf_abs_id*/

                 {bcrun.i ""bcmgwrfl.p"" "(input ""rebkfl.p"", input bfid)"}
                 {bcrun.i ""bcmgecim10.p"" "(input bfid, output suc)"} 

                 IF suc = TRUE THEN DO:
                     {bcco003.i ""FINI-GOOD""}
                 END.
                 ELSE DO:
                     UNDO, LEAVE.
                 END.
         END.  /*if last-fo b_bkf_line*/
     END.  /*for each*/

     FOR EACH b_bkf_wkfl WHERE b_bkf_status = "HOLD":
         IF suc = TRUE THEN
         ASSIGN b_bkf_status = "CIMED".
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

 

