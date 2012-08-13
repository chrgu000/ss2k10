{mfdeclre.i}
{bcdeclre.i  }
{bcwin.i}

DEFINE SHARED VARIABLE dh AS CHARACTER FORMAT "x(10)".
DEFINE SHARED VARIABLE batchid LIKE b_shp_batch LABEL "批号".
DEFINE SHARED VARIABLE shptype LIKE loc_status.  /*by shptype to decide if exec 7.9.8 cimload*/

DEFINE VARIABLE bfid LIKE b_bf_id.
DEFINE VARIABLE bfparid LIKE b_bf_id.
DEFINE VARIABLE shippernbr LIKE ABS_id.
DEFINE VARIABLE succeed AS LOGICAL.
DEFINE VARIABLE packqty AS INT.
DEFINE VARIABLE shpqty AS DECIMAL.

DEFINE BUTTON btn_exec LABEL "发货".
DEFINE BUTTON btn_quit LABEL "退出".

DEFINE TEMP-TABLE tt_shp
    FIELD tt_part LIKE b_shp_part
    FIELD tt_qty LIKE b_shp_qty.

DEFINE TEMP-TABLE t_shp
    FIELD t_part LIKE b_shp_part
    FIELD t_site LIKE b_shp_site
    FIELD t_loc LIKE b_shp_loc
    FIELD t_lot LIKE b_shp_lot
    FIELD t_qty LIKE b_shp_qty
    FIELD t_site1 LIKE b_shp_site
    FIELD t_loc1 LIKE b_shp_loc
    FIELD t_cust LIKE b_shp_cust.

DEFINE QUERY q_shp FOR tt_shp.
DEFINE BROWSE b_shp QUERY q_shp
    DISP
    tt_part LABEL "零件"
    tt_qty LABEL "数量"
    WITH 12 DOWN WIDTH 28
    TITLE "发运任务列表".
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
    space(18)  SPACE(2)  btn_exec /*SPACE(2) btn_quit*/
 WITH  WIDTH  30 TITLE "YFK发货"  SIDE-LABELS  NO-UNDERLINE THREE-D.


ON 'choose':U OF btn_exec
DO:
    btn_exec:SENSITIVE = FALSE.

    RUN VerifyFIFO.
    CASE shptype:
        WHEN "CUSTOMER" THEN RUN exec_customer.
        WHEN "TRANS" THEN RUN exec_trans.
    END CASE.
    btn_exec:SENSITIVE = TRUE.
    RUN getlist.
    OPEN QUERY q_shp FOR EACH tt_shp.
    /*APPLY "ESC":U TO FRAME a.*/
    RETURN.
END.



RUN getlist.
OPEN QUERY q_shp FOR EACH tt_shp.

REPEAT:
    UPDATE btn_exec WITH FRAME a.
END.
/*
ENABLE ALL WITH FRAME a.
{bctrail.i}*/




PROCEDURE exec_customer:

      RUN GetShipperNbr(OUTPUT shippernbr).

      FOR EACH t_shp BREAK BY t_part:
          IF FIRST-OF(t_part)  THEN DO:
              shpqty = 0.
              packqty = 0.
          END.
          recno = RECID(t_shp).
          loop:
          DO ON ERROR UNDO, LEAVE:

                           RUN sotrans (INPUT recno).
                                              IF NOT succeed  THEN DO:
                                                         RUN errorproc (INPUT t_part, INPUT t_lot, INPUT "SHIPPMENT", INPUT "FAILED", INPUT "货运单移库出现错误"). 
                                                         STATUS INPUT "货运单移库出现错误,执行下一零件".
                                                         LEAVE loop.
                                               END.
                                               ELSE DO:
                                                        shpqty = shpqty + t_qty.
                                                        packqty = packqty + 1.
                                                        STATUS INPUT "货运单移库正常".
                                              END.

                           RUN soship (INPUT packqty, INPUT shpqty, INPUT recno).
                                              IF NOT succeed  THEN DO:
                                                         RUN errorproc (INPUT t_part, INPUT t_lot, INPUT "SHIPPMENT", INPUT "FAILED", INPUT "维护货运单出现错误"). 
                                                         RUN conversesotrans (INPUT recno).
                                                         shpqty = shpqty - t_qty.
                                                         packqty = packqty - 1.
                                                         STATUS INPUT "维护货运单出现错误,执行下一零件".
                                                         LEAVE loop.
                                               END.
                                               ELSE DO:
                                                        RUN succeedproc (INPUT t_part, INPUT t_lot, INPUT "FINI-SHIPPED",  INPUT "SHIPPMENT", INPUT "SUCCEED", INPUT "",INPUT "FINI-SHIP"). 
                                                        STATUS INPUT "维护货运单正常".
                                              END.
                    

          END. /*do */
      END. /*for each t_shp*/

      STATUS INPUT "执行发运完成".
      RUN shpprt.

END.   /*exec_customer*/



PROCEDURE exec_trans:

      RUN GetShipperNbr(OUTPUT shippernbr).

      FOR EACH t_shp:
          recno = RECID(t_shp).
          loop:
          DO ON ERROR UNDO, LEAVE:
                           
                           RUN loctrans (INPUT recno).
                                              IF NOT succeed  THEN DO:
                                                         RUN errorproc (INPUT t_part, INPUT t_lot, INPUT "SHIPPMENT", INPUT "FAILED", INPUT "TRANS移库出现错误"). 
                                                         STATUS INPUT "TRANS移库出现错误,执行下一零件".
                                                         LEAVE loop.
                                               END.
                                               ELSE DO:
                                                         RUN succeedproc (INPUT t_part, INPUT t_lot, INPUT "FINI-SHIPPED",  INPUT "SHIPPMENT", INPUT "SUCCEED", INPUT "",INPUT "FINI-SHIP"). 
                                                        STATUS INPUT "TRANS移库正常".
                                              END.
                           RUN transprt.
          END. /*do */
      END. /*for each t_shp*/

END.   /*exec_TRANS*/





/***************************************************************************************/
     /*the followng is the transactions that simple transfer*/
 /***************************************************************************************/

PROCEDURE loctrans:

    DEFINE INPUT PARAMETER rec AS RECID.
    FIND t_shp WHERE RECID(t_shp) = rec.

            {bcrun.i ""bcmgwrbf.p"" "(INPUT """",
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT t_part,
                                                 INPUT t_lot,
                                                 INPUT batchid,
                                                 INPUT t_qty,
                                                 INPUT """",
                                                 INPUT TODAY,
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT t_loc,
                                                 INPUT t_site,
                                                 INPUT ""iclotr04.p"",
                                                 INPUT t_site1,
                                                 INPUT t_loc1,
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT YES,
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT t_cust,
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


END.        /*loc transfer*/



PROCEDURE sotrans:

    DEFINE INPUT PARAMETER rec AS RECID.
    FIND t_shp WHERE RECID(t_shp) = rec.

            {bcrun.i ""bcmgwrbf.p"" "(INPUT """",
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT t_part,
                                                 INPUT t_lot,
                                                 INPUT batchid,
                                                 INPUT t_qty,
                                                 INPUT """",
                                                 INPUT TODAY,
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT t_loc,
                                                 INPUT t_site,
                                                 INPUT ""iclotr04.p"",
                                                 INPUT t_site1,
                                                 INPUT t_loc1,
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

END.        /*so  transfer*/



PROCEDURE ConverseSotrans:

    DEFINE INPUT PARAMETER rec AS RECID.
    FIND t_shp WHERE RECID(t_shp) = rec.

            {bcrun.i ""bcmgwrbf.p"" "(INPUT """",
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT t_part,
                                                 INPUT """",
                                                 INPUT batchid,
                                                 INPUT t_qty,
                                                 INPUT """",
                                                 INPUT TODAY,
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT t_loc1,
                                                 INPUT t_site1,
                                                 INPUT ""iclotr04.p"",
                                                 INPUT t_site,
                                                 INPUT t_loc,
                                                 INPUT t_lot,
                                                 INPUT """",
                                                 INPUT YES,
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT """",
                                                 INPUT t_cust,
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

END.        /*so  converse transfer*/


/* the following is simulate the 7.9.8 procedure*/
PROCEDURE soship:

    DEFINE INPUT PARAMETER packqty AS INT.
    DEFINE INPUT PARAMETER shpqty AS DECIMAL.
    DEFINE INPUT PARAMETER rec AS RECID.
    DO ON ERROR UNDO,LEAVE:
     FIND t_shp WHERE RECID(t_shp) = rec.
     
             {bcrun.i ""bcmgwrbf.p"" "(INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT batchid,
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT TODAY,
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT t_site,
                                                  INPUT ""rcshmt.p"",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT YES,
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT t_cust,
                                                  INPUT dh,
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT """",
                                                  INPUT ""ABS_mstr"",
                                                  INPUT shippernbr,
                                                  OUTPUT bfid)"}
         /*b_bf_nbr*/  /*b_bf_line*/ /*b_bf_code*/ /*b_bf_part*/  /*b_bf_lot*/   /*b_bf_ser*/   /*b_bf_qty*/  /*b_bf_um*/  /*b_bf_enterdate*/ /*b_bf_tr_date*/ 
         /*b_bf_eff_date*/ /*b_bf_trtype*/  /*b_bf_trnbr*/  /*b_bf_ntime*/  /*b_bf_loc*/  /*b_bf_site*/  /*b_bf_program*/  /*b_bf_tosite*/ /*b_bf_toloc*/  
         /*b_bf_tolot*/ /*b_bf_toser*/  /*b_bf_tocim*/   /*b_bf_sess*/  /*b_bf_ref*/ /*b_bf_trid1*/  /*b_bf_trid2*/  /*b_bf_bc01*/  /*b_bf_bc02*/    /*b_bf_bc03*/  
         /*b_bf_bc04*/   /*b_bf_bc05*/ /*b_bf_emp*/   /*b_bf_par_id*/ /*b_bf_dataset*/ /*b_bf_abs_id*/
                 bfparid = bfid.
          
                     {bcrun.i ""bcmgwrbf.p"" "(INPUT """",
                                                          INPUT """",
                                                          INPUT """",
                                                          INPUT t_part,
                                                          INPUT """",
                                                          INPUT batchid,
                                                          INPUT shpqty,
                                                          INPUT """",
                                                          INPUT TODAY,
                                                          INPUT """",
                                                          INPUT """",
                                                          INPUT """",
                                                          INPUT """",
                                                          INPUT """",
                                                          INPUT """",
                                                          INPUT t_site,
                                                          INPUT ""rcshmt.p"",
                                                          INPUT """",
                                                          INPUT """",
                                                          INPUT """",
                                                          INPUT """",
                                                          INPUT YES,
                                                          INPUT """",
                                                          INPUT """",
                                                          INPUT """",
                                                          INPUT packqty,
                                                          INPUT t_cust,
                                                          INPUT """",
                                                          INPUT """",
                                                          INPUT """",
                                                          INPUT """",
                                                          INPUT """",
                                                          INPUT bfparid,
                                                          INPUT ""abs_mstr"",
                                                          INPUT shippernbr,
                                                          OUTPUT bfid)"}
                 {bcrun.i ""bcmgwrfl.p"" "(input ""rcshmt.p"", input bfid)"}
                 {bcrun.i ""bcmgecim05.p"" "(input bfid, output succeed)"} 
 END. /*do*/
END.



/* the following is print the shippment document*/

PROCEDURE shpprt:

    STATUS INPUT "开始打印CUMSTOMER类型出门证".
    FIND FIRST b_bf_det WHERE b_bf_abs_id = shippernbr NO-LOCK NO-ERROR.
    IF AVAILABLE b_bf_det THEN DO:
        DEFINE BUFFER absmstr FOR abs_mstr.
        DEFINE BUFFER bfdet FOR b_bf_det.
        FIND FIRST ABS_mstr NO-LOCK WHERE ABS_id = "s" + b_bf_abs_id NO-ERROR.
        IF AVAILABLE ABS_mstr THEN DO:
               FOR EACH absmstr WHERE absmstr.ABS_par_id = ABS_mstr.ABS_id:
                   DEFINE VARIABLE k AS INTEGER.
                   SELECT  COUNT(DISTINCT b_shp_code) INTO k FROM b_shp_wkfl WHERE b_shp_batch = batchid AND b_shp_status = "SHIPPED"
                       AND b_shp_type = "CUSTOMER" AND b_shp_part = absmstr.ABS_item.
                   FIND LAST bfdet WHERE bfdet.b_bf_abs_id = shippernbr AND bfdet.b_bf_part = absmstr.ABS_item.
                   CREATE b_trs_det.
                   ASSIGN b_trs_shipper = b_bf_abs_id
                       b_trs_site = b_bf_site
                       b_trs_part = absmstr.ABS_item
                       b_trs_f_loc = b_bf_loc
                       b_trs_t_loc = b_bf_toloc
                       b_trs_qty = absmstr.ABS_qty
                       b_trs_date = ABS_shp_date
                       b_trs_print = NO
                       b_trs_cust = abs_mstr.ABS_shipto
                       b_trs_type = "销售"
                       b_trs_lot_count = k.
               END.
        END.
     {gprun.i ""soshpprt01.p"" " (INPUT b_bf_abs_id)"}.
    END.
    /*STATUS INPUT "打印程序完成".*/
END.    


PROCEDURE transprt:
    STATUS INPUT "开始打印TRANS类型出门证".
    DEFINE VARIABLE cust LIKE ad_addr.
    FIND FIRST b_shp_wkfl NO-LOCK  WHERE b_shp_batch = batchid AND 
        b_shp_type = "TRANS" NO-ERROR. 
    IF AVAILABLE b_shp_wkfl THEN DO:
        /*RUN GetShipperNbr(OUTPUT shippernbr).*/

        FOR EACH b_shp_wkfl WHERE b_shp_batch = batchid AND b_shp_type = "TRANS"
            AND b_shp_status = "SHIPPED"  BREAK BY b_shp_part:
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
                    b_trs_type = "移库"
                    b_trs_lot_count = (ACCUMU SUB-COUNT BY b_shp_part b_shp_code).
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



PROCEDURE ChkCustLocInv:
    DEFINE INPUT PARAMETER part LIKE b_shp_part.
    DEFINE INPUT PARAMETER site LIKE b_shp_site.
    DEFINE INPUT PARAMETER loc LIKE b_shp_loc.
    DEFINE INPUT PARAMETER lot LIKE b_shp_lot.
    DEFINE INPUT PARAMETER qty LIKE b_shp_qty.
    DEFINE OUTPUT PARAMETER succeed AS LOGICAL.
    FIND FIRST ld_det WHERE ld_part = part AND ld_site = site
        AND ld_loc = loc AND ld_lot = lot NO-ERROR.
    IF AVAILABLE ld_det THEN DO:
        IF ld_qty_oh >= qty THEN succeed = TRUE. ELSE succeed = FALSE.
    END.
    ELSE DO:
        succeed = FALSE.
    END.
END.


PROCEDURE GetList:
     FOR EACH t_shp:
         DELETE t_shp.
     END.
     FOR EACH tt_shp:
         DELETE tt_shp.
     END.
   
    FOR EACH b_shp_wkfl WHERE b_shp_batch = batchid AND b_shp_status = "TOSHIP"
        BREAK BY b_shp_part BY b_shp_site BY b_shp_loc BY b_shp_lot:
        ACCUMULATE b_shp_qty (TOTAL BY b_shp_part BY b_shp_lot).
                 IF LAST-OF(b_shp_lot) THEN DO:
                     CREATE t_shp.
                     ASSIGN
                         t_part = b_shp_part
                         t_site = b_shp_site
                         t_loc = b_shp_loc
                         t_lot = b_shp_lot
                         t_qty = ACCUMU TOTAL BY b_shp_lot b_shp_qty
                         t_site1 = b_shp_site1
                         t_loc1 = b_shp_loc1
                         t_cust = b_shp_cust.
                 END.
        IF LAST-OF(b_shp_part) THEN DO:
            CREATE tt_shp.
            ASSIGN
                 tt_part = b_shp_part
                tt_qty =  ACCUMU TOTAL BY b_shp_part b_shp_qty.
        END.
    END.
END.

PROCEDURE VerifyFIFO:
    DEFINE VARIABLE succeed AS LOGICAL.
    succeed = TRUE.
    FOR FIRST b_ct_ctrl:
    END.
    IF b_ct_fifo_shp THEN DO:
        DEFINE VARIABLE lot1 LIKE ld_lot.
        DEFINE VARIABLE co1 LIKE b_co_code.
        DEFINE VARIABLE lot2 LIKE ld_lot.
        FOR EACH tt_shp:
            SELECT MAX(b_shp_lot) INTO lot2 FROM b_shp_wkfl WHERE b_shp_batch = batchid AND b_shp_part = tt_part AND b_shp_status = "TOSHIP".
             FOR EACH b_co_mstr WHERE b_co_part = tt_part AND b_co_status = "FINI-GOOD" BY b_co_lot:
                 lot1 = b_co_lot.
                 co1 = b_co_code.
                 IF NOT CAN-FIND(b_shp_wkfl WHERE b_shp_code = b_co_code AND b_shp_batch = batchid AND b_shp_part = tt_par) THEN DO:
                     IF lot1 < lot2 THEN DO:
                         STATUS INPUT  "没有执行先进先出,零件号是:" + b_co_part + "最早批号是:" + lot1 + "条码号是" + co1.
                         succeed = FALSE.
                     END.
                     ELSE DO:
                         succeed = TRUE.
                     END.
                 END.
             END.
        END.
    END.
END.




PROCEDURE errorproc:
    DEFINE INPUT PARAMETER spart LIKE b_wis_part.
    DEFINE INPUT PARAMETER slot LIKE b_wis_lot.

    DEFINE INPUT PARAMETER optype LIKE b_op_type.
    DEFINE INPUT PARAMETER opstatus LIKE b_op_status.
    DEFINE INPUT PARAMETER opdesc LIKE b_op_desc.


    FOR EACH b_shp_wkfl WHERE b_shp_status = "TOSHIP" AND b_shp_part = spart
        AND b_shp_lot = slot AND  b_shp_batch = batchid :

        b_shp_status = "HOLD".

        {gprun.i ""mgwrop.p"" "(
            INPUT b_shp_code,
            INPUT b_shp_part,
            INPUT optype,
            INPUT opstatus,
            INPUT b_shp_site,
            INPUT b_shp_loc,
            INPUT b_shp_loc,
            INPUT b_shp_qty,
            INPUT TODAY,
            INPUT TIME,
            INPUT opdesc
            )"}

    END.
END.


PROCEDURE succeedproc:
    DEFINE INPUT PARAMETER spart LIKE b_shp_part.
    DEFINE INPUT PARAMETER slot LIKE b_shp_lot.

    DEFINE INPUT PARAMETER bcstatus LIKE b_co_status.

    DEFINE INPUT PARAMETER optype LIKE b_op_type.
    DEFINE INPUT PARAMETER opstatus LIKE b_op_status.
    DEFINE INPUT PARAMETER opdesc LIKE b_op_desc.
    DEFINE INPUT PARAMETER trtype LIKE b_tr_type.


    FOR EACH b_shp_wkfl WHERE b_shp_status = "TOSHIP" AND b_shp_part = spart
        AND b_shp_lot = slot AND  b_shp_batch = batchid :
        
        FIND FIRST b_co_mstr EXCLUSIVE-LOCK WHERE b_co_code = b_shp_code NO-ERROR.
        IF AVAILABLE b_co_mstr THEN DO:
            ASSIGN b_co_status = bcstatus
                         b_co_absid = shippernbr
                         b_co_lot  = slot.
        END.
        RELEASE b_co_mstr.


        FIND b_wod_det EXCLUSIVE-LOCK WHERE b_wod_code = b_shp_code NO-ERROR.
        IF AVAILABLE b_wod_det THEN DO:
            ASSIGN b_wod_shp_date = TODAY.
            ASSIGN b_wod_status = "FINI-SHIPPED".
        END.
        RELEASE b_wod_det.

        {wrcotrtime.i b_shp_code bcstatus}
        b_shp_status = "SHIPPED".

        {gprun.i ""mgwrop.p"" "(
            INPUT b_shp_code,
            INPUT b_shp_part,
            INPUT optype,
            INPUT opstatus,
            INPUT b_shp_site,
            INPUT b_shp_loc,
            INPUT b_shp_loc,
            INPUT b_shp_qty,
            INPUT TODAY,
            INPUT TIME,
            INPUT opdesc
            )"}

        {gprun.i ""mgwrtr.p"" "(
            INPUT b_shp_code,
            INPUT b_shp_part,
            INPUT shippernbr,
            INPUT trtype,
            INPUT b_shp_site,
            INPUT b_shp_loc,
            INPUT b_shp_loc,
            INPUT b_shp_qty,
            INPUT TODAY,
            INPUT TIME
            )"}
    END.

END.

/*

    STATUS INPUT "开始打印CUMSTOMER类型出门证".
        DEFINE BUFFER absmstr FOR abs_mstr.
        FIND FIRST ABS_mstr NO-LOCK WHERE ABS_id = "s" + "3016348"  NO-ERROR.
        IF AVAILABLE ABS_mstr THEN DO:
             /*{bcrun.i ""xgicshprt2.p"" "(input recid(abs_mstr))"}*/
            FOR FIRST ad_mstr WHERE ad_addr = ABS_shipto: END.
            OUTPUT TO PRINTER PAGE-SIZE 60.
               PUT SKIP(6).
               PUT SPACE(100). PUT unformatted ABS_id. PUT SKIP.
               PUT SPACE(100).  PUT "共页第页". PUT SKIP.
               PUT space(15). PUT unformatted ad_name. PUT SPACE(60). PUT unformatted ad_line1. PUT SKIP.
               PUT SPACE(100). PUT "销售". PUT SKIP(5).

               FOR EACH absmstr WHERE absmstr.ABS_par_id = ABS_mstr.ABS_id:
                   FOR FIRST cp_mstr WHERE cp_cust = ABS_shipto AND cp_part = absmstr.ABS_item: END.
                   FOR FIRST pt_mstr WHERE pt_part = absmstr.ABS_item: END.
                  PUT SPACE(10).  PUT unformatted absmstr.ABS_item. PUT SPACE(5). PUT unformatted cp_cust_part. PUT SPACE(10).  PUT unformatted pt_desc1.
                       PUT SPACE(6). PUT unformatted absmstr.ABS_loc. PUT SPACE(28). PUT unformatted pt_um. PUT SPACE(2).
                       PUT unformatted absmstr.ABS_qty. PUT SKIP.
               END.

               PUT SKIP(10).
               /*IF PAGE-SIZE - LINE-COUNTER = 3 THEN DO:*/
                   PUT SPACE(10). PUT unformatted ABS_shipto. PUT SKIP.
                   PUT SPACE(10). PUT unformatted ABS_shp_date.
               /*END.*/
               

            OUTPUT CLOSE.
        END.
    STATUS INPUT "打印程序完成".
    
    
    
    */
