
{mfdeclre.i}
{bcdeclre.i  }
{bcwin.i}


DEFINE SHARED VARIABLE batchid LIKE b_shp_batch LABEL "批号".

DEFINE VARIABLE bfid LIKE b_bf_id.
DEFINE VARIABLE bfparid LIKE b_bf_id.

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
    space(14)  SPACE(1)  btn_exec SPACE(1) btn_quit
 WITH  SIZE 30 BY 18 TITLE "成品入库"  SIDE-LABELS  NO-UNDERLINE THREE-D.


ON 'choose':U OF btn_exec
DO:
    RUN exec.
    FOR EACH b_fin_wkfl WHERE b_fin_batch = batchid:
        ASSIGN b_fin_status = "YES".
    END.
    FOR EACH t_fin:
        DELETE t_fin.
    END.
    OPEN QUERY q_fin FOR EACH t_fin.
    RETURN.
END.

FOR EACH b_fin_wkfl WHERE b_fin_batch =  batchid AND b_fin_status = ""
         BREAK BY b_fin_part:
    ACCUMULATE b_fin_qty (TOTAL BY b_fin_part).
    IF LAST-OF(b_fin_part) THEN DO:
        CREATE t_fin.
        ASSIGN t_part = b_fin_part
            t_qty = ACCUMU SUB-TOTAL BY b_fin_part b_fin_qty.
    END.
END.

OPEN QUERY q_fin FOR EACH t_fin.
ENABLE ALL WITH FRAME a.
{bctrail.i}

PROCEDURE exec:
 DO ON ERROR UNDO,LEAVE:
     FOR EACH b_fin_wkfl WHERE b_fin_batch = batchid AND b_fin_source = "FINI-COMP":
         {bcco001.i b_fin_code b_fin_part b_fin_qty b_fin_site b_fin_loc b_fin_lot """"}
         {bcco002.i ""FINI-RCT""}

         FIND FIRST b_wod_det EXCLUSIVE-LOCK WHERE b_wod_code = b_fin_code NO-ERROR.
         IF AVAILABLE b_wod_det THEN ASSIGN b_wod_status = "FINI-RCT".

         CREATE b_bkf_wkfl.
         ASSIGN b_bkf_emp = b_fin_emp
              b_bkf_eff_date = b_fin_bkdate
              b_bkf_shift = ""
              b_bkf_site = b_fin_site
              b_bkf_part = b_fin_part
              b_bkf_op = b_fin_op
              b_bkf_line = b_fin_line
              b_bkf_bom_code = ""
              b_bkf_routing = ""
              b_bkf_qty = b_fin_qty
              b_bkf_date = b_fin_bkdate
              b_bkf_status = "TOBK"
              b_bkf_code = b_fin_code.
     END.

     FOR EACH b_fin_wkfl WHERE b_fin_batch = batchid AND b_fin_source = "REWORK":
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
                   {bcrun.i ""bcmgwrbf.p"" "(INPUT """",
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
                                                        INPUT ""iclotr02.p"",
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
                       {bcrun.i ""bcmgwrfl.p"" "(input ""iclotr0201.p"", input bfid)"}
                       {bcrun.i ""bcmgecim02.p"" "(input bfid)"} 
               {bcco002.i ""FINI-GOOD""}
          END.
     END.
 END. /*do*/
END. /*procedure exec*/

 

