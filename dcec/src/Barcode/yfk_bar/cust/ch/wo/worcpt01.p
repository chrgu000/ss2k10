
{mfdeclre.i}
{bcdeclre.i  }
{bcwin.i}


DEFINE SHARED VARIABLE batchid LIKE b_shp_batch LABEL "批号".

DEFINE VARIABLE bfid LIKE b_bf_id.
DEFINE VARIABLE bfparid LIKE b_bf_id.
DEFINE VARIABLE succeed AS LOGICAL.

DEFINE VARIABLE tosite LIKE pod_site LABEL "地点".
DEFINE VARIABLE toloc LIKE pod_loc LABEL "库位".

DEFINE BUTTON btn_exec LABEL "确认".
DEFINE BUTTON btn_quit LABEL "退出".

DEFINE TEMP-TABLE t_fin
    FIELD t_part LIKE b_fin_part
    FIELD t_qty LIKE b_fin_qty.

DEFINE QUERY q_fin FOR t_fin.
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

DEFINE BROWSE b_fin QUERY q_fin
    DISP
    t_part LABEL "零件"
    t_qty LABEL "数量"
    WITH 12 DOWN WIDTH 29.7
    TITLE "入库清单".

DEFINE FRAME a
   SKIP(1)
    b_fin
    SKIP(.3)
    space(20)  SPACE(1)  btn_exec 
 WITH  WIDTH 30 TITLE "成品入库"  SIDE-LABELS  NO-UNDERLINE THREE-D.


ON 'choose':U OF btn_exec
DO:
    btn_exec:SENSITIVE = FALSE.
    RUN exec.
    RUN getlist.
    OPEN QUERY q_fin FOR EACH t_fin.
    btn_exec:SENSITIVE = TRUE.
    APPLY "ESC":U TO CURRENT-WINDOW.
    RETURN.
END.

RUN getlist.

OPEN QUERY q_fin FOR EACH t_fin.
REPEAT:
    UPDATE btn_exec WITH FRAME a.
END.
/*
ENABLE ALL WITH FRAME a.
{bctrail.i}*/

PROCEDURE exec:
  STATUS INPUT "".
  FOR EACH b_fin_wkfl WHERE b_fin_status = "" AND  b_fin_source = "FINI-COMP":
      DO ON ERROR UNDO,LEAVE:
         FIND FIRST b_wis_wkfl NO-LOCK WHERE b_wis_code = b_fin_code NO-ERROR.
         IF AVAILABLE b_wis_wkfl THEN DO:
             ASSIGN b_fin_status = "HOLD".
             STATUS INPUT  "发现有重复入库的条码,退出" .
             
             /*UNDO,*/  NEXT.
         END.
         ELSE DO:
           
             {bcco001.i b_fin_code b_fin_part b_fin_qty b_fin_site b_fin_loc b_fin_lot """"}
             {bcco002.i ""FINI-RCT""}

             FIND FIRST b_wod_det EXCLUSIVE-LOCK WHERE b_wod_code = b_fin_code NO-ERROR.
             IF AVAILABLE b_wod_det THEN ASSIGN b_wod_status = "FINI-RCT".
             RELEASE b_wod_det.
         
             CREATE b_wis_wkfl.
             ASSIGN  
                  b_wis_loc = b_fin_loc
                  b_wis_site = b_fin_site
                  b_wis_part = b_fin_part
                  b_wis_lot = b_fin_lot
                  b_wis_op = b_fin_op
                  b_wis_qty = b_fin_qty
                  b_wis_date = b_fin_bkdate
                  b_wis_status = "TOBK"
                  b_wis_code = b_fin_code.
             ASSIGN b_fin_status = "yes".
             STATUS INPUT b_fin_code + "入库".
         END.
      END. /*do*/
  END.  /*for each*/

  FOR EACH b_fin_wkfl WHERE b_fin_status = "" AND b_fin_source = "REWORK":
      DO ON ERROR UNDO,LEAVE:
         FIND FIRST xgpl_ctrl NO-LOCK WHERE xgpl_lnr = b_fin_line NO-ERROR.
              IF AVAILABLE xgpl_ctrl THEN DO:
                   tosite = xgpl_site.
                   toloc = xgpl_loc.
              END.
              ELSE DO:
                   MESSAGE "在29.16.24没有维护相关生产线记录,无法取得返修地点及库位,推出".
                   RETURN.
              END.

         FIND FIRST b_rwk_mstr EXCLUSIVE-LOCK WHERE b_rwk_code = b_fin_code NO-ERROR.
         IF AVAILABLE b_rwk_mstr THEN DO:
              ASSIGN b_rwk_status = "FINISH"
                          b_rwk_end_date = TODAY.
                   {bcco001.i b_fin_code b_fin_part b_fin_qty tosite toloc b_fin_lot """"}
                   {gprun.i ""mgwrbf.p"" "(INPUT """",
                                                        INPUT """",
                                                        INPUT b_fin_code,
                                                        INPUT b_fin_part,
                                                        INPUT b_fin_lot,
                                                        INPUT """",
                                                        INPUT b_fin_qty,
                                                        INPUT """",
                                                        INPUT TODAY,
                                                        INPUT """",
                                                        INPUT """",
                                                        INPUT """",
                                                        INPUT """",
                                                        INPUT """",
                                                        INPUT b_fin_loc,
                                                        INPUT b_fin_site,
                                                        INPUT ""iclotr04.p"",
                                                        INPUT tosite,
                                                        INPUT toloc,
                                                        INPUT b_fin_lot,
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
               /*b_bf_bc04*/   /*b_bf_bc05*/ /*b_bf_emp*/   
                       {gprun.i ""mgwrfl.p"" "(input ""iclotr04.p"", input bfid)"}
                       {gprun.i ""mgecim06.p"" "(input bfid, output succeed)"} 
               {bcco002.i ""FINI-GOOD""}
         END.
         ASSIGN b_fin_status = "yes".
     END.   /*do*/
 END. /*for each*/
END. /*procedure exec*/

 
PROCEDURE getlist:
    FOR EACH t_fin:
        DELETE t_fin.
    END.
    FOR EACH b_fin_wkfl WHERE b_fin_status = ""
         BREAK BY b_fin_part:
    ACCUMULATE b_fin_qty (TOTAL BY b_fin_part).
         IF LAST-OF(b_fin_part) THEN DO:
             CREATE t_fin.
             ASSIGN t_part = b_fin_part
                t_qty = ACCUMU SUB-TOTAL BY b_fin_part b_fin_qty.
        END.
   END.

END.

