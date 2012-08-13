{mfdeclre.i}
{bcdeclre.i  }
{bcwin.i}

DEFINE SHARED VARIABLE batchid LIKE b_shp_batch LABEL "批号".

DEFINE VARIABLE bfid LIKE b_bf_id.
DEFINE VARIABLE bfparid LIKE b_bf_id.
DEFINE VARIABLE shippernbr LIKE ABS_id.
DEFINE VARIABLE succeed AS LOGICAL.

DEFINE BUTTON btn_exec LABEL "移库".
DEFINE BUTTON btn_quit LABEL "退出".

DEFINE TEMP-TABLE t_shp
    FIELD t_part LIKE b_shp_part
    FIELD t_qty LIKE b_shp_qty.

DEFINE QUERY q_shp FOR t_shp.
DEFINE BROWSE b_shp QUERY q_shp
    DISP
    t_part LABEL "零件"
    t_qty LABEL "数量"
    WITH 12 DOWN WIDTH 29.7
    TITLE "移库列表".
/*DEFINE BROWSE b_shp QUERY q_shp
    DISP
    b_shp_batch LABEL "批号"
    b_shp_sonbr LABEL "订单"
    b_shp_soline LABEL "行"
    b_shp_part LABEL "零件"
    b_shp_qty LABEL "数量"
    b_shp_date LABEL "下达日期"
    WITH 12 DOWN WIDTH 29.7
    TITLE "下达任务列表".*/

DEFINE FRAME a
    SKIP(1)
    b_shp
    SKIP(.3)
    space(15)  SPACE(2)  btn_exec /*SPACE(2) btn_quit*/
 WITH  WIDTH  30  TITLE "YFK发货"  SIDE-LABELS  NO-UNDERLINE THREE-D.


ON 'choose':U OF btn_exec
DO:
    btn_exec:SENSITIVE = FALSE.
    RUN exec.
    btn_exec:SENSITIVE = TRUE.
    RETURN.
END.

    FOR EACH b_shp_wkfl WHERE b_shp_batch = batchid AND b_shp_status = "TOCIM"
        BREAK BY b_shp_part:
        ACCUMULATE b_shp_qty (TOTAL BY b_shp_part).
        IF LAST-OF(b_shp_part) THEN DO:
            CREATE t_shp.
            ASSIGN t_part = b_shp_part
                t_qty =  ACCUMU SUB-TOTAL BY b_shp_part b_shp_qty.
        END.
    END.

OPEN QUERY q_shp FOR EACH t_shp.
REPEAT:
    UPDATE btn_exec WITH FRAME a.
END.
/*ENABLE ALL WITH FRAME a.
{bctrail.i}*/

PROCEDURE exec:
 mainloop:
 DO ON ERROR UNDO, RETRY:


         RUN sotr.
             IF NOT succeed THEN DO:
                 STATUS INPUT "非销售移库出现问题,退出".
                 UNDO , LEAVE mainloop.
             END.
             ELSE DO:
                  {bcco002.i ""FINI-SHIPPED""}
                 STATUS INPUT "非销售移库成功".
             END.

     RUN sotrprt.

     FOR EACH b_shp_wkfl WHERE b_shp_batch = batchid AND b_shp_type = "nsotr" AND b_shp_status = "TOCIM":
         ASSIGN b_shp_status = "CIMED".
     END.

     FOR EACH t_shp:
         DELETE t_shp.
     END.

    
     OPEN QUERY q_shp FOR EACH t_shp.
 END.
END.


/***************************************************************************************/
     /*the followng is the transactions that simple transfer*/
 /***************************************************************************************/

PROCEDURE sotr:
   RUN GetShipperNbr(OUTPUT shippernbr).
    FOR EACH b_shp_wkfl WHERE b_shp_batch = batchid AND b_shp_type = "nsotr" AND b_shp_status = "TOCIM"
        BREAK BY b_shp_part BY b_shp_lot:
        ACCUMULATE b_shp_qty (TOTAL BY b_shp_part  BY b_shp_lot).

        IF LAST-OF(b_shp_lot) THEN DO:
            {bcrun.i ""bcmgwrbf.p"" "(INPUT b_shp_sonbr,
                                                 INPUT b_shp_soline,
                                                 INPUT """",
                                                 INPUT b_shp_part,
                                                 INPUT b_shp_lot,
                                                 INPUT batchid,
                                                 INPUT ACCUMU TOTAL BY b_shp_lot b_shp_qty,
                                                 INPUT """",
                                                 INPUT b_shp_date,
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT b_shp_loc,
                                                 INPUT b_shp_site,
                                                 INPUT ""iclotr04.p"",
                                                 INPUT b_shp_site1,
                                                 INPUT b_shp_loc1,
                                                 INPUT b_shp_lot,
                                                 INPUT """",
                                                 INPUT YES,
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT b_shp_cust,
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT shippernbr,
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT ""abs_mstr"",
                                                 INPUT """",
                                                 OUTPUT bfid)"}
         /*b_bf_nbr*/  /*b_bf_line*/ /*b_bf_code*/ /*b_bf_part*/  /*b_bf_lot*/   /*b_bf_ser*/   /*b_bf_qty*/  /*b_bf_um*/  /*b_bf_enterdate*/ /*b_bf_tr_date*/ 
         /*b_bf_eff_date*/ /*b_bf_trtype*/  /*b_bf_trnbr*/  /*b_bf_ntime*/  /*b_bf_loc*/  /*b_bf_site*/  /*b_bf_program*/  /*b_bf_tosite*/ /*b_bf_toloc*/  
         /*b_bf_tolot*/ /*b_bf_toser*/  /*b_bf_tocim*/   /*b_bf_sess*/  /*b_bf_ref*/ /*b_bf_trid1*/  /*b_bf_trid2*/  /*b_bf_bc01*/  /*b_bf_bc02*/    /*b_bf_bc03*/  
         /*b_bf_bc04*/   /*b_bf_bc05*/ /*b_bf_emp*/   /*b_bf_par_id*/ /*b_bf_dataset*/ /*b_bf_abs_id*/
        
                {bcrun.i ""bcmgwrfl.p"" "(input ""iclotr04.p"", input bfid)"}
                {bcrun.i ""bcmgecim06.p"" "(input bfid, output succeed)"} 
                
        END. /*last-of part*/

    END. /*for each*/
       
END.        /*loc transfer*/



PROCEDURE sotrprt:
    STATUS INPUT "开始打印非销售类型出门证".
    DEFINE VARIABLE cust LIKE ad_addr.
    FIND FIRST b_shp_wkfl NO-LOCK  WHERE b_shp_batch = batchid AND 
        b_shp_type = "nsotr" NO-ERROR. 
    IF AVAILABLE b_shp_wkfl THEN DO:
       /* RUN GetShipperNbr(OUTPUT shippernbr).*/
        
        FOR EACH b_shp_wkfl WHERE b_shp_batch = batchid AND b_shp_type = "NSOTR" BREAK BY b_shp_part:
            ACCUMULATE b_shp_qty (TOTAL BY b_shp_part).
            ACCUMULATE b_shp_code (COUNT BY b_shp_part).
            IF LAST-OF(b_shp_part) THEN DO:
                CREATE b_trs_det.
                ASSIGN b_trs_shipper = shippernbr
                    b_trs_site = b_shp_site
                    b_trs_part = b_shp_part
                    b_trs_f_loc = b_shp_loc
                    b_trs_t_loc = b_shp_loc1
                    b_trs_qty = (ACCUMU SUB-TOTAL BY b_shp_part  b_shp_qty)
                    b_trs_date = b_shp_date
                    b_trs_print = NO
                    b_trs_cust = b_shp_cust
                    b_trs_type = "非销售移库"
                    b_trs_lot_count =  (ACCUMU SUB-COUNT BY b_shp_part b_shp_code).
            END.
        END.
        {gprun.i ""soshpprt01.p"" " (INPUT shippernbr)"}.
        STATUS INPUT "打印程序完成".
     END.
END.


 
Procedure GetShipperNbr:
    define output parameter NextNbr like nr_seg_value.
    define variable Nbr  as integer.
    define variable Len1 as integer.
    define variable Len2 as integer.
    define variable Pos  as integer.

    find first shc_ctrl no-lock no-error.
    if available shc_ctrl then do:
        find first nr_mstr exclusive-lock where nr_seqid =  shc_ship_nr_id no-error.
        if avail nr_mstr then do:
             
            if index(nr_seg_value,",") = 0 then do:
                pos = length(nr_seg_value).
                Len1 = pos. 
            end.
            else do:
                Len1 = index(nr_seg_value,",") - 1.
                pos = index(nr_seg_value,",") - 1.
            end.

            Nbr = int(substr(nr_seg_value, 1 , pos)) + 1.
            Len2 = length(string(Nbr)).
            
            NextNbr = fill( "0", Len1 - Len2 ) + string(Nbr).
            
            if index(nr_seg_value,",") = 0 then 
                nr_seg_value = NextNbr.
            else nr_seg_value = NextNbr + substr(nr_seg_value,pos + 1).
        end.
    end.

    release shc_ctrl.
    release nr_mstr.
end.



Procedure FindShipperNbr:
    define output parameter NextNbr like nr_seg_value.
    define variable Nbr  as integer.
    define variable Len1 as integer.
    define variable Len2 as integer.
    define variable Pos  as integer.

    find first shc_ctrl no-lock no-error.
    if available shc_ctrl then do:
        find first nr_mstr exclusive-lock where nr_seqid =  shc_ship_nr_id no-error.
        if avail nr_mstr then do:
             
            if index(nr_seg_value,",") = 0 then do:
                pos = length(nr_seg_value).
                Len1 = pos. 
            end.
            else do:
                Len1 = index(nr_seg_value,",") - 1.
                pos = index(nr_seg_value,",") - 1.
            end.

            Nbr = int(substr(nr_seg_value, 1 , pos)) + 1.
            Len2 = length(string(Nbr)).
            
            NextNbr = fill( "0", Len1 - Len2 ) + string(Nbr).
            
        end.
    end.

    release shc_ctrl.
    release nr_mstr.
end.
