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

DEFINE VARIABLE v_fmcode AS LOGICAL initial YES FORMAT "h-层次/F-平坦".
DEFINE VARIABLE v_diffonly AS LOGICAL INITIAL NO.

DEFINE TEMP-TABLE ttx3 RCODE-INFORMATION 
    FIELDS ttx3_i        AS INTEGER          LABEL "序号"
    FIELDS ttx3_flag     AS LOGICAL          LABEL "存在差异"
    FIELDS ttx3_par      LIKE wo_part        LABEL "产品"
    FIELDS ttx3_desc_p   LIKE pt_desc1       LABEL "描述"
    FIELDS ttx3_desc_p2  LIKE pt_desc2       LABEL "描述"
    FIELDS ttx3_pline_p  LIKE pt_prod_line   LABEL "产品类"
    FIELDS ttx3_woid     LIKE wo_lot         LABEL "标号"
    FIELDS ttx3_date     LIKE wo_due_date     LABEL "日期"
    FIELDS ttx3_line     LIKE wo_line        LABEL "生产线"
    FIELDS ttx3_rct_qty  LIKE xxwobmvm_rct_qty     LABEL "产品产量"
    FIELDS ttx3_var_tot  LIKE xxwobmvd_bom_unit    LABEL "总差异"
    FIELDS ttx3_var_muv  LIKE xxwobmvd_bom_unit    LABEL "量差"
    FIELDS ttx3_var_mrv  LIKE xxwobmvd_bom_unit    LABEL "率差"
    FIELDS ttx3_var_mmv1 LIKE xxwobmvd_bom_unit    LABEL "方法差异-量差"
    FIELDS ttx3_var_mmv2 LIKE xxwobmvd_bom_unit    LABEL "方法差异-率差"
    FIELDS ttx3_var_mmv3 LIKE xxwobmvd_bom_unit    LABEL "方法差异-其他"
    FIELDS ttx3_recid    AS RECID            LABEL "RECID" format ">>>>>>>>>>>>"
    .

DEFINE NEW SHARED TEMP-TABLE ttx1 RCODE-INFORMATION
    FIELDS ttx1_i        AS INTEGER          LABEL "序号"
    FIELDS ttx1_j        AS INTEGER          LABEL "子序号"
    FIELDS ttx1_par      LIKE wo_part        LABEL "产品"
    FIELDS ttx1_desc_p   LIKE pt_desc1       LABEL "描述"
    FIELDS ttx1_desc_p2  LIKE pt_desc2       LABEL "描述"
    FIELDS ttx1_pline_p  LIKE pt_prod_line   LABEL "产品类"
    FIELDS ttx1_woid     LIKE wo_lot         LABEL "标号"
    FIELDS ttx1_date     LIKE wo_due_date    LABEL "日期"
    FIELDS ttx1_line     LIKE wo_line        LABEL "生产线"
    FIELDS ttx1_rct_qty  LIKE xxwobmvm_rct_qty LABEL "产量"
    FIELDS ttx1_comp     LIKE wo_part        LABEL "零件"
    FIELDS ttx1_desc_c   LIKE pt_desc1       LABEL "描述"
    FIELDS ttx1_desc_c2  LIKE pt_desc1       LABEL "描述"
    FIELDS ttx1_pline_c  LIKE pt_prod_line   LABEL "产品类"
    FIELDS ttx1_op       LIKE wod_op            LABEL "工序"
    FIELDS ttx1_bom_unit LIKE xxwobmvd_bom_unit LABEL "卷集单位用量"
    FIELDS ttx1_bom_cost LIKE xxwobmvd_bom_cost LABEL "卷集成本"
    FIELDS ttx1_bom_qty  LIKE xxwobmvd_bom_qty  LABEL "卷集总用量"
    FIELDS ttx1_bom_amt  LIKE xxwobmvd_bom_amt  LABEL "卷集总成本"
    FIELDS ttx1_cwo_unit LIKE xxwobmvd_cwo_unit LABEL "工单冻结单位用量"
    FIELDS ttx1_cwo_cost LIKE xxwobmvd_cwo_cost LABEL "工单冻结成本"
    FIELDS ttx1_cwo_qty  LIKE xxwobmvd_cwo_qty  LABEL "工单冻结总用量"
    FIELDS ttx1_cwo_amt  LIKE xxwobmvd_cwo_amt  LABEL "工单冻结总成本"
    FIELDS ttx1_act_unit LIKE xxwobmvd_act_unit LABEL "实际单位用量"
    FIELDS ttx1_act_cost LIKE xxwobmvd_act_cost LABEL "实际成本"
    FIELDS ttx1_act_qty  LIKE xxwobmvd_act_qty  LABEL "实际总用量"
    FIELDS ttx1_act_amt  LIKE xxwobmvd_act_amt  LABEL "实际总成本"
    FIELDS ttx1_var_tot  LIKE xxwobmvd_act_amt  LABEL "总差异"
    FIELDS ttx1_var_muv  LIKE xxwobmvd_act_amt    LABEL "量差"
    FIELDS ttx1_var_mrv  LIKE xxwobmvd_act_amt  LABEL "率差"
    FIELDS ttx1_var_mmv1 LIKE xxwobmvd_act_amt  LABEL "方法差异-量差"
    FIELDS ttx1_var_mmv2 LIKE xxwobmvd_act_amt  LABEL "方法差异-率差"
    FIELDS ttx1_var_mmv3 LIKE xxwobmvd_act_amt LABEL "方法差异-其他"
    FIELDS ttx1_varflag  AS   LOGICAL INITIAL NO LABEL "存在差异"
    INDEX  ttx1_idx1     ttx1_i ttx1_j
    INDEX  ttx1_idx2     ttx1_woid
    .


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
    v_fmcode COLON 30 LABEL "显示格式" "(h-层次/F-平坦)"
    SKIP
    v_diffonly COLON 30 LABEL "只显示有差异的累计工单"
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

REPEAT:
    IF v_part2 = hi_char THEN v_part2 = "".
    IF v_site1 = hi_char THEN v_site2 = "".
    IF v_woid1 = hi_char THEN v_woid1 = "".
    IF v_date1 = low_date THEN v_date1 = ?.
    IF v_date2 = hi_date THEN v_date2 = ?.
    IF v_line2 = hi_char THEN v_line2 = "".


    UPDATE 
        v_part1 v_part2
        v_site1 v_site2
        v_woid1 v_woid2
        v_date1 v_date2 
        v_line1 v_line2 
        v_fmcode
        v_diffonly
        WITH FRAME a.
    
    IF v_date1 = ? THEN v_date1 = low_date.
    IF v_date2 = ? THEN v_date2 = hi_date.
    IF v_part2 = "" THEN v_part2 = hi_char.
    IF v_site2 = "" THEN v_site2 = hi_char.
    IF v_woid2 = "" THEN v_woid2 = hi_char.
    IF v_line2 = "" THEN v_line2 = hi_char.


    RUN xxpro-initial.
    RUN xxpro-get-data1.
    RUN xxpro-get-data2.
    IF v_fmcode = YES THEN DO:
        RUN xxpro-report1.
    END.
    ELSE DO:
        RUN xxpro-report2.
    END.
    
END.


/**********************************/
PROCEDURE xxpro-initial:
    FOR EACH ttx1:
        DELETE ttx1.
    END.
    FOR EACH ttx3:
        DELETE ttx3.
    END.
END PROCEDURE.
/**********************************/
PROCEDURE xxpro-get-data1:
    DEFINE VARIABLE i AS INTEGER.
    DEFINE VARIABLE j AS INTEGER.

    DEFINE VARIABLE v_varyes AS LOGICAL INITIAL NO NO-UNDO.

    i = 0.
    FOR EACH xxwobmvm_mstr NO-LOCK
        WHERE ( xxwobmvm_part >= v_part1 AND xxwobmvm_part <= v_part2 )
        AND   ( xxwobmvm_site >= v_site1 AND xxwobmvm_site <= v_site2 )
        AND   ( xxwobmvm_date >= v_date1 AND xxwobmvm_date <= v_date2 )
        AND   ( xxwobmvm_woid >= v_woid1 AND xxwobmvm_woid <= v_woid2 )
        AND   ( xxwobmvm_line >= v_line1 AND xxwobmvm_line <= v_line2 )
        :
                  
        v_varyes = NO.
        DO j = 1 TO 5:
            IF xxwobmvm_var_det[j] <> 0 THEN v_varyes = YES.
        END.
        IF v_varyes = NO THEN DO:
            /*check line var*/
            /*skip*/
        END.
        IF v_varyes = NO AND v_diffonly = YES THEN NEXT.

        i = i + 1.
        CREATE ttx3.
        ASSIGN 
            ttx3_i         = i
            ttx3_par       = xxwobmvm_part
            ttx3_desc_p    = ""
            ttx3_desc_p2   = ""
            ttx3_pline_p   = "" 
            ttx3_woid      = xxwobmvm_woid 
            ttx3_date      = xxwobmvm_date
            ttx3_line      = xxwobmvm_line
            ttx3_var_tot   = xxwobmvm_var_tot
            ttx3_var_muv   = xxwobmvm_var_det[1]
            ttx3_var_mrv   = xxwobmvm_var_det[2]
            ttx3_var_mmv1  = xxwobmvm_var_det[3]
            ttx3_var_mmv2  = xxwobmvm_var_det[4]
            ttx3_var_mmv3  = xxwobmvm_var_det[5]
            ttx3_rct_qty   = xxwobmvm_rct_qty
            ttx3_recid     = recid(xxwobmvm_mstr)
        .
        FIND FIRST pt_mstr WHERE pt_part = ttx3_par NO-LOCK NO-ERROR.
        IF AVAILABLE pt_mstr THEN DO:
            ASSIGN ttx3_pline_p = pt_prod_line
                   ttx3_desc_p  = pt_desc1
                   ttx3_desc_p2 = pt_desc2.
        END.
        IF v_varyes = YES THEN ttx3_flag = YES. ELSE ttx3_flag = NO.
    END.
END.
/*************************/
PROCEDURE xxpro-report1:
    {yywobmvrrpbw1.i}
END PROCEDURE.
/*************************/
PROCEDURE xxpro-report2:
    {yywobmvrrpbw2.i}
END PROCEDURE.

/**********************************/
PROCEDURE xxpro-get-data2:
    DEFINE VARIABLE i AS INTEGER.
    FOR EACH ttx3:
        i = 0.
        CREATE ttx1.
        ASSIGN 
            ttx1_i         = ttx3_i
            ttx1_j         = i
            ttx1_par       = ttx3_par
            ttx1_desc_p    = ttx3_desc_p
            ttx1_desc_p2   = ttx3_desc_p2
            ttx1_pline_p   = ttx3_pline_p
            ttx1_woid      = ttx3_woid 
            ttx1_date      = ttx3_date
            ttx1_line      = ttx3_line
            ttx1_var_tot   = ttx3_var_tot
            ttx1_var_muv   = ttx3_var_muv 
            ttx1_var_mrv   = ttx3_var_mrv 
            ttx1_var_mmv1  = ttx3_var_mmv1
            ttx1_var_mmv2  = ttx3_var_mmv2
            ttx1_var_mmv3  = ttx3_var_mmv3
            ttx1_varflag   = NO
            ttx1_comp      = ttx3_par
            ttx1_pline_c   = ttx3_pline_p
            ttx1_desc_c    = ttx3_desc_p
            ttx1_desc_c2   = ttx3_desc_p2
            ttx1_rct_qty   = ttx3_rct_qty
            .
        IF ttx1_var_muv <> 0 OR ttx1_var_mrv <> 0 OR ttx1_var_mmv1 <> 0 OR ttx1_var_mmv2 <> 0 OR ttx1_var_mmv3 <> 0 THEN ttx1_varflag = YES.
        
        FOR EACH xxwobmvd_det NO-LOCK
            WHERE xxwobmvd_woid = ttx3_woid:
            IF v_diffonly = YES AND 
                (xxwobmvd_var_det[1] = 0 AND 
                 xxwobmvd_var_det[2] = 0 AND 
                 xxwobmvd_var_det[3] = 0 AND 
                 xxwobmvd_var_det[4] = 0 AND 
                 xxwobmvd_var_det[5] = 0 )
                THEN NEXT.

                i = i + 1.
                create ttx1.
                ASSIGN 
                    ttx1_i         = ttx3_i
                    ttx1_j         = i
                    ttx1_par       = ttx3_par
                    ttx1_desc_p    = ttx3_desc_p
                    ttx1_desc_p2   = ttx3_desc_p2
                    ttx1_pline_p   = ttx3_pline_p
                    ttx1_woid      = ttx3_woid 
                    ttx1_date      = ttx3_date
                    ttx1_line      = ttx3_line
                    ttx1_comp      = xxwobmvd_comp
                    ttx1_pline_c   = ""
                    ttx1_desc_c    = ""
                    .
                ASSIGN 
                    ttx1_bom_unit  = xxwobmvd_bom_unit
                    ttx1_bom_cost  = xxwobmvd_bom_cost
                    ttx1_bom_qty   = xxwobmvd_bom_qty
                    ttx1_bom_amt   = xxwobmvd_bom_amt

                    ttx1_cwo_unit  = xxwobmvd_cwo_unit
                    ttx1_cwo_cost  = xxwobmvd_cwo_cost
                    ttx1_cwo_qty   = xxwobmvd_cwo_qty
                    ttx1_cwo_amt   = xxwobmvd_cwo_amt

                    ttx1_act_unit  = xxwobmvd_act_unit
                    ttx1_act_cost  = xxwobmvd_act_cost
                    ttx1_act_qty   = xxwobmvd_act_qty
                    ttx1_act_amt   = xxwobmvd_act_amt

                    ttx1_var_tot   = xxwobmvd_var_tot
                    ttx1_var_muv   = xxwobmvd_var_det[1]
                    ttx1_var_mrv   = xxwobmvd_var_det[2]
                    ttx1_var_mmv1  = xxwobmvd_var_det[3]
                    ttx1_var_mmv2  = xxwobmvd_var_det[4]
                    ttx1_var_mmv3  = xxwobmvd_var_det[5]
                    
                    ttx1_rct_qty   = ttx3_rct_qty
                    .
                IF ttx1_var_muv <> 0 OR ttx1_var_mrv <> 0 OR ttx1_var_mmv1 <> 0 OR ttx1_var_mmv2 <> 0 OR ttx1_var_mmv3 <> 0 THEN ttx1_varflag = YES.

                FIND FIRST pt_mstr WHERE pt_part = ttx1_comp NO-LOCK NO-ERROR.
                IF AVAILABLE pt_mstr THEN ASSIGN 
                    ttx1_pline_c = pt_prod_line
                    ttx1_desc_c  = pt_desc1 
                    ttx1_desc_c2 = pt_desc2.
        END.
    END.
END PROCEDURE.

