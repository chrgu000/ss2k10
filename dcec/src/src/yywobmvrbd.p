/*xxwobm001.p - create roll-up bom for production item*/

/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

DEFINE VARIABLE v_woid1  LIKE wo_lot.
DEFINE VARIABLE v_woid2  LIKE wo_lot.
DEFINE VARIABLE v_part1  LIKE pt_part.
DEFINE VARIABLE v_part2  LIKE pt_part.
DEFINE VARIABLE v_site1  LIKE pt_site.
DEFINE VARIABLE v_site2  LIKE pt_site.
DEFINE VARIABLE v_date1  LIKE wo_due_date.
DEFINE VARIABLE v_date2  LIKE wo_due_date.
DEFINE VARIABLE v_line1  LIKE wo_line.
DEFINE VARIABLE v_line2  LIKE wo_line.
DEFINE VARIABLE v_rebud  AS LOGICAL initial NO.
DEFINE VARIABLE v_results AS CHAR.
DEFINE VARIABLE v_ok      AS LOGICAL.

DEFINE TEMP-TABLE ttt1
    FIELDS ttt1_woid LIKE wo_lot
    FIELDS ttt1_part LIKE wo_part
    FIELDS ttt1_cmmt AS CHAR FORMAT "x(30)" LABEL "状态".

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
FORM
    RECT-FRAME       AT ROW 1.4 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
    SKIP(.1)  /*GUI*/
    v_part1 COLON 20 
    v_part2 COLON 45 LABEL "至"
    SKIP
    v_site1 COLON 20
    v_site2 COLON 45 LABEL "至"
    SKIP
    v_woid1 COLON 20
    v_woid2 COLON 45 LABEL "至"
    SKIP
    v_date1 COLON 20
    v_date2 COLON 45 LABEL "至"
    SKIP
    v_line1 COLON 20
    v_line2 COLON 45 LABEL "至"
    SKIP
    v_rebud COLON 30 LABEL "重新计算已计算过的工单"
    SKIP
    SKIP(.4)  /*GUI*/
    WITH FRAME a SIDE-LABELS WIDTH 80 NO-BOX THREE-D.

DEFINE VARIABLE F-a-title AS CHARACTER.
F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
            &THEN " Selection Criteria "
            &ELSE {&SELECTION_CRITERIA}
            &ENDIF .
RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
                 FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
                 RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", 
                 RECT-FRAME-LABEL:FONT).
RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
REPEAT:
    IF v_part2 = hi_char THEN v_part2 = "".
    IF v_site1 = hi_char THEN v_site2 = "".
    IF v_woid1 = hi_char THEN v_woid1 = "".
    IF v_line2 = hi_char THEN v_line2 = "".
    IF v_date1 = low_date THEN v_date1 = ?.
    IF v_date2 = hi_date THEN v_date2 = ?.


    UPDATE 
        v_part1 v_part2
        v_site1 v_site2
        v_woid1 v_woid2
        v_date1 v_date2 
        v_line1 v_line2 
        v_rebud
        WITH FRAME a.
    
    IF v_date1 = ? THEN v_date1 = low_date.
    IF v_date2 = ? THEN v_date2 = hi_date.
    IF v_part2 = "" THEN v_part2 = hi_char.
    IF v_site2 = "" THEN v_site2 = hi_char.
    IF v_woid2 = "" THEN v_woid2 = hi_char.
    IF v_line2 = "" THEN v_line2 = hi_char.


   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "terminal"
               &printWidth = 80
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.

    /*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

    FOR EACH ttt1:
        DELETE ttt1.
    END.
    FOR EACH wo_mstr NO-LOCK
        WHERE wo_type = "C"
        AND   wo_status = "C"
        AND  (wo_part >= v_part1 AND wo_part <= v_part2)
        AND  (wo_site >= v_site1 AND wo_site <= v_site2)
        AND  (wo_lot >= v_woid1 AND wo_lot <= v_woid2)
        AND  (wo_due_date >= v_date1 AND wo_due_date <= v_date2)
        AND  (wo_line >= v_line1 AND wo_line <= v_line2):
        
        v_results = "".
        RUN xxpro-chk-exist (INPUT wo_part, INPUT wo_site, INPUT wo_lot, INPUT wo_due_date, OUTPUT v_results).
        IF v_results <> "" AND v_rebud = NO THEN DO:
            CREATE ttt1.
            ASSIGN 
                ttt1_woid = wo_lot
                ttt1_part = wo_part
                ttt1_cmmt = v_results.
            NEXT.
        END.
        RUN xxpro-chk-bom (INPUT wo_part, INPUT wo_site, INPUT wo_lot, INPUT wo_due_date, OUTPUT v_results).
        IF v_results <> "" THEN DO:
            CREATE ttt1.
            ASSIGN 
                ttt1_woid = wo_lot
                ttt1_part = wo_part
                ttt1_cmmt = v_results.
            NEXT.
        END.
        
        CREATE ttt1.
        ASSIGN
            ttt1_woid = wo_lot
            ttt1_part = wo_part
            ttt1_cmmt = "计算(" + STRING(TIME,"HH:MM:SS") .
        RUN xxpro-cal-del (INPUT RECID(wo_mstr), OUTPUT v_ok).
        RUN xxpro-cal-cwoh (INPUT RECID(wo_mstr), OUTPUT v_ok).
        RUN xxpro-cal-cwor (INPUT RECID(wo_mstr), OUTPUT v_ok).
        RUN xxpro-cal-cwod (INPUT RECID(wo_mstr), OUTPUT v_ok).
        ASSIGN ttt1_cmmt = ttt1_cmmt + "---" + STRING(TIME,"HH:MM:SS") + ")".

    END.
    
    FOR EACH ttt1 WITH STREAM-IO DOWN WIDTH 80:
        DISP ttt1.
    END.
    


    {mfreset.i}
    {mfgrptrm.i} /*Report-to-Window*/
END.
{wbrp04.i &frame-spec = a}


/**********************************/
PROCEDURE xxpro-chk-bom:
    DEFINE INPUT PARAMETER p_part AS CHAR.
    DEFINE INPUT PARAMETER p_site AS CHAR.
    DEFINE INPUT PARAMETER p_woid AS CHAR.
    DEFINE INPUT PARAMETER p_date AS DATE.
    DEFINE OUTPUT PARAMETER p_results AS CHAR.

    p_results = "".
    FIND LAST xxwobmfm_mstr 
        WHERE xxwobmfm_part = p_part 
        AND xxwobmfm_site = p_site 
        AND xxwobmfm_date_eff <= p_date 
        USE-INDEX xxwobmfm_idx2
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE xxwobmfm_mstr THEN DO:
        p_results = "卷集BOM未复制,不能计算".
    END.
END PROCEDURE.
/**********************************/
PROCEDURE xxpro-chk-exist:
    DEFINE INPUT PARAMETER p_part AS CHAR.
    DEFINE INPUT PARAMETER p_site AS CHAR.
    DEFINE INPUT PARAMETER p_woid AS CHAR.
    DEFINE INPUT PARAMETER p_date AS DATE.
    DEFINE OUTPUT PARAMETER p_results AS CHAR.

    p_results = "".
    FIND LAST xxwobmvm_mstr WHERE xxwobmvm_woid = p_woid NO-LOCK NO-ERROR.
    IF AVAILABLE xxwobmvm_mstr THEN DO:
        p_results = "已计算过,跳过".
    END.
END PROCEDURE.
/**********************************/
PROCEDURE xxpro-cal-del:
    DEFINE INPUT PARAMETER p_recid AS RECID.
    DEFINE OUTPUT PARAMETER p_ok   AS LOGICAL.
    p_ok = YES.
    FIND FIRST wo_mstr WHERE recid(wo_mstr) = p_recid NO-LOCK NO-ERROR.
    IF NOT AVAILABLE wo_mstr THEN LEAVE.
    FOR EACH xxwobmvm_mstr WHERE xxwobmvm_woid = wo_lot:
        DELETE xxwobmvm_mstr.
    END.
    FOR EACH xxwobmvd_det WHERE xxwobmvd_woid = wo_lot:
        DELETE xxwobmvd_det.
    END.
    FOR EACH xxwobmvr_det WHERE xxwobmvr_woid = wo_lot:
        DELETE xxwobmvr_det.
    END.
END PROCEDURE.

/**********************************/
PROCEDURE xxpro-cal-cwoh:
    DEFINE INPUT PARAMETER p_recid AS RECID.
    DEFINE OUTPUT PARAMETER p_ok   AS LOGICAL.
    FIND FIRST wo_mstr WHERE recid(wo_mstr) = p_recid NO-LOCK NO-ERROR.
    IF NOT AVAILABLE wo_mstr THEN LEAVE.
    FIND FIRST xxwobmvm_mstr WHERE xxwobmvm_woid = wo_lot NO-ERROR.
    IF NOT AVAILABLE xxwobmvm_mstr THEN DO:
        CREATE xxwobmvm_mstr.
        ASSIGN xxwobmvm_woid = wo_lot
               xxwobmvm_site = wo_site
               xxwobmvm_part = wo_part
               xxwobmvm_date = wo_due_date
               xxwobmvm_date_mod = TODAY
               xxwobmvm_line = wo_line
               xxwobmvm_userid   = GLOBAL_userid
               .
    END.
END PROCEDURE.
/**********************************/
PROCEDURE xxpro-cal-cwor:
    DEFINE INPUT PARAMETER p_recid AS RECID.
    DEFINE OUTPUT PARAMETER p_ok   AS LOGICAL.
    
    DEFINE VARIABLE v_mmv AS DECIMAL.

    p_ok = NO.
    v_mmv = 0.

    FIND FIRST wo_mstr WHERE recid(wo_mstr) = p_recid NO-LOCK NO-ERROR.
    IF NOT AVAILABLE wo_mstr THEN LEAVE.
    FIND FIRST xxwobmvm_mstr WHERE xxwobmvm_woid = wo_lot NO-ERROR.
    IF NOT AVAILABLE xxwobmvm_mstr THEN LEAVE.



    /*new logical*/
    FOR EACH xxtr_hist WHERE xxtr_key1 = wo_lot NO-LOCK:
        FIND FIRST tr_hist WHERE tr_trnbr = xxtr_trnbr NO-LOCK NO-ERROR.
        IF NOT AVAILABLE tr_hist THEN NEXT.

        IF tr_type = "RCT-WO" AND tr_part = wo_part THEN DO:
            assign
                xxwobmvm_rct_qty  = xxwobmvm_rct_qty + tr_qty_loc
                xxwobmvm_rct_amt  = xxwobmvm_rct_amt + tr_qty_loc * (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std)
                .

            FIND FIRST xxwobmvr_det 
                WHERE xxwobmvr_woid = tr_lot
                AND   xxwobmvr_comp = tr_part
                AND   xxwobmvr_op   = /*tr_wod_op*/ 0
                AND   xxwobmvr_cost = (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std)
            NO-ERROR.
            IF NOT AVAILABLE xxwobmvr_det THEN DO:
                CREATE xxwobmvr_det.
                ASSIGN xxwobmvr_woid = tr_lot
                       xxwobmvr_comp = tr_part
                       xxwobmvr_op   = /*tr_wod_op*/ 0
                       xxwobmvr_cost = (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std).
            END.
            ASSIGN xxwobmvr_qty = xxwobmvr_qty + tr_qty_loc.
            FOR EACH trgl_det NO-LOCK WHERE trgl_trnbr = tr_trnbr:
                IF trgl_type = "MTHD CHG" THEN DO:
                    xxwobmvm_var_det[6] = xxwobmvm_var_det[6] + trgl_gl_amt.
                END.
            END.
        END.
        ELSE IF tr_type = "ISS-WO" THEN DO:
            FIND FIRST xxwobmvr_det 
                WHERE xxwobmvr_woid = tr_lot
                AND   xxwobmvr_comp = tr_part
                AND   xxwobmvr_op   = /*tr_wod_op*/ 0
                AND   xxwobmvr_cost = (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std)
            NO-ERROR.
            IF NOT AVAILABLE xxwobmvr_det THEN DO:
                CREATE xxwobmvr_det.
                ASSIGN xxwobmvr_woid = tr_lot
                       xxwobmvr_comp = tr_part
                       xxwobmvr_op   = /*tr_wod_op*/ 0
                       xxwobmvr_cost = (tr_mtl_std + tr_lbr_std + tr_ovh_std + tr_bdn_std + tr_sub_std).
            END.
            ASSIGN xxwobmvr_qty = xxwobmvr_qty - tr_qty_loc.
        END.
    END.
    
    p_ok = YES.
END PROCEDURE.

/**********************************/
PROCEDURE xxpro-cal-cwod:
    DEFINE INPUT PARAMETER p_recid AS RECID.
    DEFINE OUTPUT PARAMETER p_ok   AS LOGICAL.

    DEFINE VARIABLE v_costsum AS DECIMAL EXTENT 10.
    DEFINE VAR      j         AS INTEGER.

    p_ok = NO.

    FIND FIRST wo_mstr WHERE recid(wo_mstr) = p_recid NO-LOCK NO-ERROR.
    IF NOT AVAILABLE wo_mstr THEN LEAVE.
    FIND FIRST xxwobmvm_mstr WHERE xxwobmvm_woid = wo_lot NO-ERROR.
    IF NOT AVAILABLE xxwobmvm_mstr THEN LEAVE.
    FIND LAST xxwobmfm_mstr WHERE xxwobmfm_part = xxwobmvm_part
        AND xxwobmfm_site = xxwobmvm_site
        AND xxwobmfm_date_eff <= xxwobmvm_date
        USE-INDEX xxwobmfm_idx2
        NO-LOCK NO-ERROR.
    IF NOT AVAILABLE xxwobmfm_mstr THEN LEAVE.

    ASSIGN xxwobmvm_bom_cost = xxwobmfm_cost_tot.
    ASSIGN xxwobmvm_bom_amt  = xxwobmvm_bom_cost * xxwobmvm_rct_qty.

    ASSIGN xxwobmvm_cwo_amt = xxwobmvm_rct_amt.
    IF xxwobmvm_rct_qty <> 0 THEN xxwobmvm_cwo_cost = xxwobmvm_cwo_amt / xxwobmvm_rct_qty.

    /*bom*/
    FOR EACH xxwobmfd_det  NO-LOCK
        WHERE xxwobmfd_par = xxwobmvm_part
        AND   xxwobmfd_site = xxwobmvm_site
        AND   xxwobmfd_version = xxwobmfm_version:

        FIND FIRST xxwobmvd_det 
            WHERE xxwobmvd_woid = wo_lot
            AND   xxwobmvd_comp = xxwobmfd_comp
            AND   xxwobmvd_op   = /*xxwobmfd_op*/ 0
        NO-ERROR.
        IF NOT AVAILABLE xxwobmvd_det THEN DO:
            CREATE xxwobmvd_det.
            ASSIGN xxwobmvd_woid = wo_lot
                   xxwobmvd_comp = xxwobmfd_comp
                   xxwobmvd_op   = /*xxwobmfd_op*/ 0 .
        END.
        ASSIGN 
            xxwobmvd_bom_cost = xxwobmfd_cost_tot
            xxwobmvd_bom_unit = xxwobmvd_bom_unit + xxwobmfd_qty.
        ASSIGN 
            xxwobmvd_bom_qty  = xxwobmvd_bom_qty + xxwobmfd_qty * xxwobmvm_rct_qty
            xxwobmvd_bom_amt  = xxwobmvd_bom_amt + xxwobmvd_bom_cost * xxwobmfd_qty * xxwobmvm_rct_qty.
    END.
    /*cwo and act*/
    FOR EACH wod_det NO-LOCK 
        WHERE wod_lot = wo_lot:
        FIND FIRST xxwobmvd_det 
            WHERE xxwobmvd_woid = wod_lot
            AND   xxwobmvd_comp = wod_part
            AND   xxwobmvd_op   = /*wod_op*/ 0
        NO-ERROR.
        IF NOT AVAILABLE xxwobmvd_det THEN DO:
            CREATE xxwobmvd_det.
            ASSIGN xxwobmvd_woid = wo_lot
                   xxwobmvd_comp = wod_part
                   xxwobmvd_op   = /*wod_op*/ 0 .
        END.
        ASSIGN 
            xxwobmvd_cwo_unit = xxwobmvd_cwo_unit + wod_bom_qty
            xxwobmvd_cwo_cost = wod_bom_amt
            xxwobmvd_cwo_qty  = xxwobmvd_cwo_qty + xxwobmvm_rct_qty * wod_bom_qty
            xxwobmvd_cwo_amt  = xxwobmvd_cwo_amt + wod_bom_amt * xxwobmvm_rct_qty * wod_bom_qty.
        ASSIGN
            xxwobmvd_act_qty  = xxwobmvd_act_qty + wod_qty_iss
            xxwobmvd_act_amt  = xxwobmvd_act_amt + wod_tot_std.
        ASSIGN
            xxwobmvd_var_det[1] = xxwobmvd_var_det[1] + wod_mvuse_post
            xxwobmvd_var_det[2] = xxwobmvd_var_det[2] + wod_mvrte_post
            .
    END.
    /*cal cost and var*/
    v_costsum = 0.
    FOR EACH xxwobmvd_det WHERE xxwobmvd_woid = wo_lot:
        IF xxwobmvd_act_qty <> 0 THEN xxwobmvd_act_cost = xxwobmvd_act_amt / xxwobmvd_act_qty.
                                 ELSE xxwobmvd_act_cost = xxwobmvd_act_amt.
        IF xxwobmvm_rct_qty <> 0 THEN xxwobmvd_act_unit = xxwobmvd_act_qty / xxwobmvm_rct_qty.
                                 ELSE xxwobmvd_act_unit = xxwobmvd_act_qty.

        /*if item not in BOM but in CWO, then BOM cost use CWO cost*/
        IF xxwobmvd_bom_cost = 0 AND xxwobmvd_bom_unit = 0 THEN xxwobmvd_bom_cost = xxwobmvd_cwo_cost.
        /*if item not in CWO but in BOM, then CWO cost use BOM cost*/
        IF xxwobmvd_cwo_cost = 0 AND xxwobmvd_cwo_unit = 0 AND xxwobmvd_act_qty = 0 AND xxwobmvd_act_amt = 0 THEN ASSIGN xxwobmvd_cwo_cost = xxwobmvd_bom_cost.

        /*MMV-usage*/
        xxwobmvd_var_det[3] = (xxwobmvd_cwo_qty  - xxwobmvd_bom_qty) * xxwobmvd_bom_cost.
        /*MMV-rate*/
        xxwobmvd_var_det[4] =  xxwobmvd_cwo_qty * (xxwobmvd_cwo_cost - xxwobmvd_bom_cost).
        DO j = 1 TO 4:
            ASSIGN xxwobmvm_var_det[j] = xxwobmvm_var_det[j] + xxwobmvd_var_det[j].
            /*variance total*/
            ASSIGN xxwobmvd_var_tot = xxwobmvd_var_tot + xxwobmvd_var_det[j].
        END.
    END.
    /*header variance*/
    ASSIGN xxwobmvm_var_det[5] = xxwobmvm_var_det[6] - xxwobmvm_var_det[3] - xxwobmvm_var_det[4].
    ASSIGN xxwobmvm_var_tot =  xxwobmvm_var_det[1] + xxwobmvm_var_det[2] + xxwobmvm_var_det[3] + xxwobmvm_var_det[4] + xxwobmvm_var_det[5].
    p_ok = YES.
END PROCEDURE.
