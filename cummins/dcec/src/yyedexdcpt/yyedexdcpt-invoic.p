DEF INPUT PARAMETER X_fname1 AS CHAR.
DEF INPUT PARAMETER X_fname2 AS CHAR.
DEF INPUT PARAMETER X_rid    AS RECID.
DEF INPUT PARAMETER X_check  AS LOGICAL.

{mfdeclre.i}
{yyedcomlib.i}

DEF VAR v_sys_status AS CHAR.
DEF VAR v_fexcel     AS CHAR.
DEF VAR v_fname      AS CHAR.

v_fexcel = X_fname1.
v_fname  = X_fname2.



DEFINE FRAME WaitingFrame 
        "处理中，请稍候..." 
        SKIP
WITH VIEW-AS DIALOG-BOX.



DEF TEMP-TABLE xxwk1
    FIELDS xxwk1_inv_nbr AS CHAR
    FIELDS xxwk1_nbr_po  AS CHAR
    FIELDS xxwk1_nbr_so  AS CHAR
    FIELDS xxwk1_nbr_asn AS CHAR
    FIELDS xxwk1_buyer AS CHAR EXTENT 5
    FIELDS xxwk1_seller AS CHAR EXTENT 5
    FIELDS xxwk1_billto AS CHAR EXTENT 5
    FIELDS xxwk1_sender AS CHAR EXTENT 5
    FIELDS xxwk1_tot_amt AS DECIMAL
    FIELDS xxwk1_curr    AS CHAR
    FIELDS xxwk1_date    AS DATE EXTENT 5
    FIELDS xxwk1_ref     AS CHAR EXTENT 5
    FIELDS xxwk1_flag    AS CHAR
    FIELDS xxwk1_payterm AS CHAR
    FIELDS xxwk1_mot     AS CHAR
    FIELDS xxwk1_org     AS CHAR
    FIELDS xxwk1_carrierc AS CHARACTER
    FIELDS xxwk1_carriern AS CHARACTER
    FIELDS xxwk1_carrierd AS CHARACTER
    FIELDS xxwk1_tot_box AS INTEGER
    FIELDS xxwk1_tot_nwt AS DECIMAL
    FIELDS xxwk1_mfg_nwt AS DECIMAL
    FIELDS xxwk1_tot_gwt AS DECIMAL
    FIELDS xxwk1_tot_vol AS DECIMAL

    .

DEF TEMP-TABLE xxwk2
    FIELDS xxwk2_inv_nbr AS CHAR
    FIELDS xxwk2_order   AS CHAR
    FIELDS xxwk2_line    AS INTEGER
    FIELDS xxwk2_part    AS CHAR
    FIELDS xxwk2_desc    AS CHAR
    FIELDS xxwk2_qty     AS DECIMAL
    FIELDS xxwk2_um      AS CHAR
    FIELDS xxwk2_price   AS DECIMAL
    FIELDS xxwk2_amt     AS DECIMAL
    FIELDS xxwk2_box_nbr AS CHARACTER
    FIELDS xxwk2_mfg_nwt AS DECIMAL
    FIELDS xxwk2_hscode  AS CHAR
    FIELDS xxwk2_hsrate  AS DECIMAL
    FIELDS xxwk2_mfg_line AS INTEGER
    .


DEF TEMP-TABLE xxwk3     
    FIELDS xxwk3_inv_nbr   AS CHAR
    FIELDS xxwk3_cnt_nbr   AS CHAR
    FIELDS xxwk3_box_nbr   AS CHAR
    FIELDS xxwk3_box_type  AS CHARACTER
    FIELDS xxwk3_box_nwt   AS DECIMAL
    FIELDS xxwk3_box_gwt   AS DECIMAL
    FIELDS xxwk3_box_dim   AS CHAR
    FIELDS xxwk3_box_vol   AS DECIMAL
    FIELDS xxwk3_qty       AS DECIMAL
    FIELDS xxwk3_mfg_nwt   AS DECIMAL
    INDEX xxwk3_idx1 xxwk3_cnt_nbr xxwk3_box_nbr.

DEF TEMP-TABLE xxwk4
    FIELDS xxwk4_doc_nbr  AS CHAR
    FIELDS xxwk4_err_type AS CHAR
    FIELDS xxwk4_err_desc AS CHAR
    FIELDS xxwk4_err_cmt  AS CHAR.


RUN xxpro-build  (OUTPUT v_sys_status).
RUN xxpro-post-process.
/*
FOR EACH xxwk1: DISP xxwk1 WITH 1 COLUMN.
END.
FOR EACH xxwk2: DISP xxwk2 WITH 1 COLUMN.
END.
FOR EACH xxwk3: DISP xxwk3 WITH 1 COLUMN.
END.
FOR EACH xxwk4: DISP xxwk4 WITH 1 COLUMN.
END.*/

FIND FIRST xxwk1 NO-LOCK NO-ERROR.
IF NOT AVAILABLE xxwk1 THEN DO:
    MESSAGE "无数据,不能输出." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END.
ELSE DO:
    VIEW FRAME waitingframe.
    RUN xxpro-excel  (INPUT v_fname, OUTPUT v_sys_status).
    HIDE FRAME waitingframe NO-PAUSE.
    MESSAGE "输出完毕，要预览吗" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO TITLE "" UPDATE choice AS LOGICAL.
    IF choice = YES THEN DO:
        run xxpro-view (INPUT v_fname).
    END.
END.



/*---------------------------*/
PROCEDURE xxpro-build:
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.
    p_sys_status = "".
    

    DEFINE VARIABLE v_container_id AS CHAR.

    FOR EACH xxwk1: DELETE xxwk1. END.
    FOR EACH xxwk2: DELETE xxwk2. END.
    FOR EACH xxwk3: DELETE xxwk3. END.
    FOR EACH xxwk4: DELETE xxwk4. END.
    
    v_container_id = "".

    FOR EACH edxr_mstr NO-LOCK WHERE recid(edxr_mstr) = X_rid:
        FOR EACH edxrd_det NO-LOCK WHERE edxrd_domain = global_domain and
                 edxrd_exf_seq = edxr_exf_seq:
            CASE edxrd_exf_rec_seq:
                WHEN 1 THEN DO:
                    CREATE xxwk1.
                    ASSIGN
                        xxwk1_inv_nbr = edxrd_exf_fld[1]  /*invoice number*/
                        xxwk1_flag    = IF edxrd_exf_fld[9] = '380' THEN 'Invoice'
                                        ELSE 'Memo'  /*inoive or memo*/
                        .
                    xxwk1_date[1] = f-conv-date-c2d(edxrd_exf_fld[2]).
                END.
                WHEN 30 THEN DO:
                    IF edxrd_exf_fld[1] = "BDT" THEN DO:
                        ASSIGN 
                            xxwk1_buyer[1] = edxrd_exf_fld[2] /*code*/
                            xxwk1_buyer[2] = edxrd_exf_fld[4] /*Name*/
                            xxwk1_buyer[3] = edxrd_exf_fld[5] /*addr*/
                            xxwk1_buyer[4] = edxrd_exf_fld[6] /*addr*/
                            xxwk1_buyer[5] = edxrd_exf_fld[7] /*addr*/
                            .
                    END.
                    ELSE IF edxrd_exf_fld[1] = "SDT" THEN DO:
                        ASSIGN 
                            xxwk1_seller[1] = edxrd_exf_fld[2] /*code*/
                            xxwk1_seller[2] = edxrd_exf_fld[4] /*Name*/
                            xxwk1_seller[3] = edxrd_exf_fld[5] /*addr*/
                            xxwk1_seller[4] = edxrd_exf_fld[6] /*addr*/
                            xxwk1_seller[5] = edxrd_exf_fld[7] /*addr*/
                            .
                    END.
                    ELSE IF edxrd_exf_fld[1] = "PAT" THEN DO:
                        ASSIGN 
                            xxwk1_billto[1] = edxrd_exf_fld[2] /*code*/
                            xxwk1_billto[2] = edxrd_exf_fld[4] /*Name*/
                            xxwk1_billto[3] = edxrd_exf_fld[5] /*addr*/
                            xxwk1_billto[4] = edxrd_exf_fld[6] /*addr*/
                            xxwk1_billto[5] = edxrd_exf_fld[7] /*addr*/
                            .
                    END.
                    ELSE IF edxrd_exf_fld[1] = "CDT" THEN DO:
                        ASSIGN 
                            xxwk1_sender[1] = edxrd_exf_fld[2] /*code*/
                            xxwk1_sender[2] = edxrd_exf_fld[4] /*Name*/
                            xxwk1_sender[3] = edxrd_exf_fld[5] /*addr*/
                            xxwk1_sender[4] = edxrd_exf_fld[6] /*addr*/
                            xxwk1_sender[5] = edxrd_exf_fld[7] /*addr*/
                            .
                    END.
                END.
                WHEN 40 THEN DO:
                    ASSIGN 
                        xxwk1_curr    = edxrd_exf_fld[1] /*currency*/
                        xxwk1_payterm = edxrd_exf_fld[9] /*payment term*/
                        .
                END.
                WHEN 110 THEN DO:  /*carrier*/
                    ASSIGN 
                        xxwk1_carrierc = edxrd_exf_fld[1]
                        xxwk1_carriern = edxrd_exf_fld[3].
                END.
                WHEN 120 THEN DO:  /*tef detail*/
                    ASSIGN xxwk1_carrierd = edxrd_exf_fld[2].

                    IF edxrd_exf_fld[4] <> "" THEN DO:
                        xxwk1_date[2] = f-conv-date-c2d(edxrd_exf_fld[4]).
                    END.
                    IF edxrd_exf_fld[7] <> "" THEN DO:
                        xxwk1_date[3] = f-conv-date-c2d(edxrd_exf_fld[7]).
                    END.
                END.
                WHEN 140 THEN DO:
                    /*packing information*/
                    IF edxrd_exf_fld[1] = "PAC" THEN DO:
                        IF edxrd_exf_fld[2] BEGINS "M" THEN DO:
                            ASSIGN v_container_id = trim(substring(edxrd_exf_fld[2],3,24)).
                        END.
                        ELSE IF edxrd_exf_fld[2] BEGINS "H" THEN DO:
                            CREATE xxwk3.
                            ASSIGN 
                            xxwk3_inv_nbr   = xxwk1_inv_nbr
                            xxwk3_cnt_nbr   = v_container_id
                            xxwk3_box_nbr   = trim(substring(edxrd_exf_fld[2],3,24))
                            xxwk3_box_type  = trim(substring(edxrd_exf_fld[2],30,10))
                            xxwk3_box_gwt   = DECIMAL(substring(edxrd_exf_fld[2],40,10))
                            xxwk3_box_nwt   = DECIMAL(substring(edxrd_exf_fld[2],50,10))
                            xxwk3_box_dim   = trim(substring(edxrd_exf_fld[2],70,30))
                            .
                        END.
                    END.
                END.
                WHEN 150 THEN DO:
                    ASSIGN xxwk1_mot = edxrd_exf_fld[1].
                    FIND FIRST CODE_mstr WHERE code_domain = global_domain and
                               code_fldname = "xx-mot" AND CODE_value = xxwk1_mot NO-LOCK NO-ERROR.
                    IF AVAILABLE CODE_mstr THEN xxwk1_mot = CODE_cmmt.
                END.
                WHEN 160 THEN DO:
                    CREATE xxwk2.
                    ASSIGN 
                        xxwk2_inv_nbr = xxwk1_inv_nbr
                        xxwk2_order = edxrd_exf_fld[5] /*order*/
                        xxwk2_line = INTEGER(edxrd_exf_fld[7])  /*order line*/
                        xxwk2_part = edxrd_exf_fld[1]  /*item code*/
                        xxwk2_desc = edxrd_exf_fld[4]  /*desc*/
                        xxwk2_qty  = decimal(edxrd_exf_fld[8]) /*qty*/
                        xxwk2_um   = edxrd_exf_fld[9] /*um*/
                        xxwk2_box_nbr = trim(edxrd_exf_fld[25])
                        .
                END.
                WHEN 190 THEN DO:
                    ASSIGN 
                        xxwk2_price = decimal(edxrd_exf_fld[1]) /*price*/
                        xxwk2_amt   = decimal(edxrd_exf_fld[3])  /*amount*/
                        .
                END.
                WHEN 260 THEN DO:
                    ASSIGN 
                        xxwk1_tot_amt = decimal(edxrd_exf_fld[2]) /*tot amt*/
                        .
                END.
            END CASE.
        END.
    END.



    p_sys_status = "0".
END PROCEDURE.

/*---------------------------*/
PROCEDURE xxpro-excel:
    DEF INPUT PARAMETER  p_fname      AS CHARACTER.
    DEF OUTPUT PARAMETER p_sys_status AS CHAR.

    p_sys_status = "".

    IF p_fname = "" THEN LEAVE.

    DEF VAR chExcel AS COM-HANDLE.
    DEF VAR chWorkbook AS COM-HANDLE.
    DEF VAR chWorksheet AS COM-HANDLE.
    
    DEF VAR i   AS INTEGER.
    DEF VAR j   AS INTEGER.
    DEF VAR k   AS INTEGER.
    DEF VARIABLE v_part_qty AS DECIMAL.
    DEF VARIABLE v_part_price AS DECIMAL.
    DEF VARIABLE v_part_amt   AS DECIMAL.

    
    /* read EXCEL file and load data begin..*/
    FOR EACH xxwk1 BREAK BY xxwk1_inv_nbr:
        CREATE "Excel.Application" chExcel.
        /*chWorkbook =  chExcel:Workbooks:ADD(v_fexcel).*/
        chWorkbook =  chExcel:Workbooks:ADD().
        chExcel:visible = NO.

        /*sheet-1 invoice*/
        chWorkSheet = chWorkbook:workSheets(1).
        chWorkSheet:NAME = "INVOICE".
        chWorksheet:COLUMNS:Font:SIZE = 10.
        DO j = 1 TO 10:
            chWorkSheet:COLUMNS(j):NumberFormatLocal = "@".
        END.

        /*header*/
        i = 1.
        chWorkbook:worksheets(1):cells(i,6):Font:SIZE = 16.
        chWorkbook:worksheets(1):cells(i,6):Font:BOLD = TRUE.
        chWorkSheet:range("F" + string(i) + ":" + "H" + STRING(i)):merge().
        chWorkbook:worksheets(1):cells(i,6):value = "发票 INVOICE".

        DO j = 1 TO 5:
            chWorkSheet:range("A" + string(j) + ":" + "D" + string(j)):merge().
        END.

        DO j = 6 TO 10:
            chWorkSheet:range("A" + string(j) + ":" + "D" + string(j)):merge().
            chWorkSheet:range("F" + string(j) + ":" + "J" + string(j)):merge().
        END.

        chWorkbook:worksheets(1):cells(6,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(6,1):value = "客户 SOLD TO".
        chWorkbook:worksheets(1):cells(6,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(6,6):value = "发往 SHIP TO".

        DO j = 1 TO 5:
            chWorkbook:worksheets(1):cells(j    ,1):value = xxwk1_seller[j].
            chWorkbook:worksheets(1):cells(j + 6,1):value = xxwk1_buyer[j].
            chWorkbook:worksheets(1):cells(j + 6,6):value = xxwk1_buyer[j].
        END.

        i = 12.
        chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
        chWorkSheet:range("F" + string(i) + ":" + "G" + string(i)):merge().
        chWorkbook:worksheets(1):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(i,1):VALUE = "付款方式 TERMS:".
        chWorkbook:worksheets(1):cells(i,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(i,6):VALUE = "运输方式 SHIP VIA:".
        chWorkbook:worksheets(1):cells(i,3):value = xxwk1_payterm.
        chWorkbook:worksheets(1):cells(i,8):value = xxwk1_mot.


        i = i + 1.
        chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
        chWorkSheet:range("F" + string(i) + ":" + "G" + string(i)):merge().
        chWorkbook:worksheets(1):cells(i,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(i,1):VALUE = "承运人CARRIER:".
        chWorkbook:worksheets(1):cells(i,6):VALUE = "承运单据CARRIER DOC:".
        chWorkbook:worksheets(1):cells(i,3):value = xxwk1_carriern.
        chWorkbook:worksheets(1):cells(i,8):value = xxwk1_carrierd.


        /*i = 13.*/
        i = i + 1.
        chWorkSheet:range("B" + string(i) + ":" + "C" + string(i)):merge().
        chWorkSheet:range("D" + string(i) + ":" + "E" + string(i)):merge().
        chWorkSheet:range("F" + string(i) + ":" + "G" + string(i)):merge().
        chWorkSheet:range("H" + string(i) + ":" + "I" + string(i)):merge().
        DO k = 2 TO 9:
            chWorkbook:worksheets(1):cells(i,k):Borders(7):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(1):cells(i,k):Borders(7):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(1):cells(i,k):Borders(8):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(1):cells(i,k):Borders(8):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(1):cells(i,k):Borders(9):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(1):cells(i,k):Borders(9):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(1):cells(i,k):Borders(10):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(1):cells(i,k):Borders(10):Weight = 2.      /*  Hairline border's weight */ 
        END.
        chWorkbook:worksheets(1):cells(i,2):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(i,2):value = "客户 CUSTOMER".
        chWorkbook:worksheets(1):cells(i,4):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(i,4):value = "发货日期 SHIP DATE".
        chWorkbook:worksheets(1):cells(i,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(i,6):value = "发票日期 INVOICE DATE".
        chWorkbook:worksheets(1):cells(i,8):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(i,8):value = "发票 INVOICE".

        /*i = 14.*/
        i = i + 1.

        chWorkSheet:range("B" + string(i) + ":" + "C" + string(i)):merge().
        chWorkSheet:range("D" + string(i) + ":" + "E" + string(i)):merge().
        chWorkSheet:range("F" + string(i) + ":" + "G" + string(i)):merge().
        chWorkSheet:range("H" + string(i) + ":" + "I" + string(i)):merge().
        DO k = 2 TO 9:
            chWorkbook:worksheets(1):cells(i,k):Borders(7):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(1):cells(i,k):Borders(7):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(1):cells(i,k):Borders(8):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(1):cells(i,k):Borders(8):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(1):cells(i,k):Borders(9):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(1):cells(i,k):Borders(9):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(1):cells(i,k):Borders(10):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(1):cells(i,k):Borders(10):Weight = 2.      /*  Hairline border's weight */ 
        END.
        chWorkbook:worksheets(1):cells(i,2):value = xxwk1_buyer[1].
        chWorkbook:worksheets(1):cells(i,4):value = xxwk1_date[2].
        chWorkbook:worksheets(1):cells(i,6):value = xxwk1_date[1].
        chWorkbook:worksheets(1):cells(i,8):value = xxwk1_inv_nbr.

        /*body*/
        /*i = 16.	*/
        i = 17.
        
        chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
        chWorkSheet:range("C" + string(i) + ":" + "D" + string(i)):merge().
        chWorkSheet:range("E" + string(i) + ":" + "F" + string(i)):merge().
        chWorkSheet:range("I" + string(i) + ":" + "J" + string(i)):merge().
        DO k = 1 TO 10:
            chWorkbook:worksheets(1):cells(i,k):Borders(7):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(1):cells(i,k):Borders(7):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(1):cells(i,k):Borders(8):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(1):cells(i,k):Borders(8):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(1):cells(i,k):Borders(9):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(1):cells(i,k):Borders(9):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(1):cells(i,k):Borders(10):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(1):cells(i,k):Borders(10):Weight = 2.      /*  Hairline border's weight */ 
        END.
        chWorkbook:worksheets(1):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(i,1):value = "零件 PART NUMBER".
        chWorkbook:worksheets(1):cells(i,3):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(i,3):value = "描述 DESCRIPTION".
        chWorkbook:worksheets(1):cells(i,5):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(i,5):value = "客户参考 CUSTOMER REF".
        chWorkbook:worksheets(1):cells(i,7):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(i,7):value = "数量 QTY".
        chWorkbook:worksheets(1):cells(i,8):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(i,8):value = "单价 PRICE".
        chWorkbook:worksheets(1):cells(i,9):Font:BOLD = TRUE.
        chWorkbook:worksheets(1):cells(i,9):value = "金额 AMOUNT".

        FOR EACH xxwk2 WHERE xxwk2_inv_nbr = xxwk1_inv_nbr BREAK BY xxwk2_part:
            IF FIRST-OF(xxwk2_part) THEN DO:
                v_part_qty   = 0.
                v_part_price = 0.
                v_part_amt   = 0.
            END.
            v_part_qty = v_part_qty + xxwk2_qty.
            v_part_amt = v_part_amt + xxwk2_amt.
            v_part_price = xxwk2_price.

            IF LAST-OF(xxwk2_part) THEN DO:
                IF v_part_qty <> 0 THEN v_part_price = v_part_amt / v_part_qty.
                
                i = i + 1.
                chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
                chWorkSheet:range("C" + string(i) + ":" + "D" + string(i)):merge().
                chWorkSheet:range("E" + string(i) + ":" + "F" + string(i)):merge().
                chWorkSheet:range("I" + string(i) + ":" + "J" + string(i)):merge().
                chWorkbook:worksheets(1):cells(i,7):HorizontalAlignment = -4152.
                chWorkbook:worksheets(1):cells(i,8):HorizontalAlignment = -4152.
                chWorkbook:worksheets(1):cells(i,9):HorizontalAlignment = -4152.

                chWorkbook:worksheets(1):cells(i,1):value = xxwk2_part.
                chWorkbook:worksheets(1):cells(i,3):value = xxwk2_desc.
                chWorkbook:worksheets(1):cells(i,5):value = xxwk2_order.
                chWorkbook:worksheets(1):cells(i,7):value = v_part_qty.
                chWorkbook:worksheets(1):cells(i,8):value = v_part_price.
                chWorkbook:worksheets(1):cells(i,9):value = v_part_amt.
            END.
        END.
        /*foot*/
        i = i + 1.
        DO k = 1 TO 10:
            chWorkbook:worksheets(1):cells(i,k):Borders(8):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(1):cells(i,k):Borders(8):Weight = 2.      /*  Hairline border's weight */ 
        END.
        chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
        chWorkSheet:range("C" + string(i) + ":" + "D" + string(i)):merge().
        chWorkSheet:range("E" + string(i) + ":" + "F" + string(i)):merge().
        chWorkSheet:range("I" + string(i) + ":" + "J" + string(i)):merge().
        chWorkbook:worksheets(1):cells(i,8):HorizontalAlignment = -4152.
        chWorkbook:worksheets(1):cells(i,9):HorizontalAlignment = -4152.
        
        chWorkbook:worksheets(1):cells(i,5):value = "合计 TOTAL".
        chWorkbook:worksheets(1):cells(i,8):value = xxwk1_curr.
        chWorkbook:worksheets(1):cells(i,9):value = xxwk1_tot_amt.

        i = i + 2.
        chWorkSheet:range("A" + string(i) + ":" + "C" + string(i)):merge().
        chWorkbook:worksheets(1):cells(i,1):value = "原产地 COUNTRY OF ORIGIN:".
        chWorkbook:worksheets(1):cells(i,4):value = xxwk1_org.

        i = i + 5.
        chWorkSheet:range("F" + string(i) + ":" + "J" + string(i)):merge().
        chWorkbook:worksheets(1):cells(i,6):value = "签字 SIGNED:___________________________".

        
       
        /*for sheet2 *packlist*/
        chWorkSheet = chWorkbook:workSheets(2).
        chWorkSheet:NAME = "PACKLIST".
        chWorksheet:COLUMNS:Font:SIZE = 10.
        DO j = 1 TO 10:
            chWorkSheet:COLUMNS(j):NumberFormatLocal = "@".
        END.
         
        /*header*/ 
        chWorkbook:worksheets(2):cells(1,3):Font:SIZE = 16.
        chWorkbook:worksheets(2):cells(1,3):Font:BOLD = TRUE.
        chWorkSheet:range("C1" + ":" + "E1"):merge().
        /*chWorkbook:worksheets(2):cells(1,3):HorizontalAlignment = -4152.*/
        chWorkbook:worksheets(2):cells(1,3):VALUE = "发货/装箱单".
        chWorkSheet:range("C2" + ":" + "E2"):merge().
        chWorkbook:worksheets(2):cells(2,3):VALUE = "SHIPPING-NOTICE&PACKING LIST".

        chWorkbook:worksheets(2):cells(1,6):HorizontalAlignment = -4152.
        chWorkbook:worksheets(2):cells(1,6):VALUE = "NO:".
        chWorkbook:worksheets(2):cells(1,7):VALUE = xxwk1_inv_nbr.
        chWorkbook:worksheets(2):cells(2,6):HorizontalAlignment = -4152.
        chWorkbook:worksheets(2):cells(2,6):VALUE = "Date:".
        chWorkbook:worksheets(2):cells(2,7):VALUE = xxwk1_date[1].


        DO j = 4 TO 9:
            chWorkSheet:range("A" + string(j) + ":" + "D" + string(j)):merge().
            chWorkSheet:range("F" + string(j) + ":" + "I" + string(j)):merge().
        END.
        chWorkbook:worksheets(2):cells(4,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(4,1):value = "供应商 SUPPLIER".
        chWorkbook:worksheets(2):cells(5,1):value = xxwk1_seller[1].
        chWorkbook:worksheets(2):cells(6,1):value = xxwk1_seller[2].
        chWorkbook:worksheets(2):cells(7,1):value = xxwk1_seller[3].
        chWorkbook:worksheets(2):cells(8,1):value = xxwk1_seller[4].
        chWorkbook:worksheets(2):cells(9,1):value = xxwk1_seller[5].

        chWorkbook:worksheets(2):cells(4,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(4,6):value = "发往 SHIP-TO".
        chWorkbook:worksheets(2):cells(5,6):value = xxwk1_buyer[1].
        chWorkbook:worksheets(2):cells(6,6):value = xxwk1_buyer[2].
        chWorkbook:worksheets(2):cells(7,6):value = xxwk1_buyer[3].
        chWorkbook:worksheets(2):cells(8,6):value = xxwk1_buyer[4].
        chWorkbook:worksheets(2):cells(9,6):value = xxwk1_buyer[5].

        i = 11.
        chWorkSheet:range("B" + string(i) + ":" + "C" + string(i)):merge().
        chWorkSheet:range("D" + string(i) + ":" + "E" + string(i)):merge().
        chWorkSheet:range("G" + string(i) + ":" + "H" + string(i)):merge().
        chWorkSheet:range("I" + string(i) + ":" + "J" + string(i)):merge().
        DO k = 1 TO 10:
            chWorkbook:worksheets(2):cells(i,k):Borders(7):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(2):cells(i,k):Borders(7):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(2):cells(i,k):Borders(8):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(2):cells(i,k):Borders(8):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(2):cells(i,k):Borders(10):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(2):cells(i,k):Borders(10):Weight = 2.      /*  Hairline border's weight */ 
        END.
        chWorkbook:worksheets(2):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,1):value = "箱号".
        chWorkbook:worksheets(2):cells(i,2):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,2):value = "零件号".
        chWorkbook:worksheets(2):cells(i,4):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,4):value = "零件名称".
        chWorkbook:worksheets(2):cells(i,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,6):value = "数量".
        chWorkbook:worksheets(2):cells(i,7):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,7):value = "净重".
        chWorkbook:worksheets(2):cells(i,9):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,9):value = "订单".

        i = 12.
        chWorkSheet:range("B" + string(i) + ":" + "C" + string(i)):merge().
        chWorkSheet:range("D" + string(i) + ":" + "E" + string(i)):merge().
        chWorkSheet:range("G" + string(i) + ":" + "H" + string(i)):merge().
        chWorkSheet:range("I" + string(i) + ":" + "J" + string(i)):merge().
        DO k = 1 TO 10:
            chWorkbook:worksheets(2):cells(i,k):Borders(7):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(2):cells(i,k):Borders(7):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(2):cells(i,k):Borders(9):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(2):cells(i,k):Borders(9):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(2):cells(i,k):Borders(10):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(2):cells(i,k):Borders(10):Weight = 2.      /*  Hairline border's weight */ 
        END.
        chWorkbook:worksheets(2):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,1):value = "CASE NO.".
        chWorkbook:worksheets(2):cells(i,2):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,2):value = "Buyer P/N".
        chWorkbook:worksheets(2):cells(i,4):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,4):value = "DESCRIPTION".
        chWorkbook:worksheets(2):cells(i,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,6):value = "QTY".
        chWorkbook:worksheets(2):cells(i,7):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,7):value = "Net Weight".
        chWorkbook:worksheets(2):cells(i,9):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,9):value = "Order".





        /*body*/
        i = 12.
        FOR EACH xxwk3 WHERE xxwk3_inv_nbr = xxwk1_inv_nbr 
            BREAK BY xxwk3_cnt_nbr BY xxwk3_box_nbr:
            IF FIRST-OF(xxwk3_cnt_nbr) THEN DO:
                i = i + 1.
                chWorkSheet:range("A" + string(i) + ":" + "J" + string(i)):merge().
                chWorkbook:worksheets(2):cells(i,1):value = "Container#:" + xxwk3_cnt_nbr.
            END.

            FOR EACH xxwk2 WHERE xxwk2_inv_nbr = xxwk3_inv_nbr 
                AND trim(xxwk2_box_nbr) = trim(xxwk3_box_nbr)
                BY xxwk2_part:
            
                i = i + 1.            
                chWorkSheet:range("B" + string(i) + ":" + "C" + string(i)):merge().
                chWorkSheet:range("D" + string(i) + ":" + "E" + string(i)):merge().
                chWorkSheet:range("G" + string(i) + ":" + "H" + string(i)):merge().
                chWorkSheet:range("I" + string(i) + ":" + "J" + string(i)):merge().
                chWorkbook:worksheets(2):cells(i,6):HorizontalAlignment = -4152.
                chWorkbook:worksheets(2):cells(i,7):HorizontalAlignment = -4152.
             
                chWorkbook:worksheets(2):cells(i,1):value = xxwk2_box_nbr.
                chWorkbook:worksheets(2):cells(i,2):value = xxwk2_part.
                chWorkbook:worksheets(2):cells(i,4):value = xxwk2_desc.
                chWorkbook:worksheets(2):cells(i,6):value = xxwk2_qty.
                chWorkbook:worksheets(2):cells(i,7):value = xxwk2_mfg_nwt.
                chWorkbook:worksheets(2):cells(i,9):value = xxwk2_order + "-" + STRING(xxwk2_line).
            END.
        END.


        /*foot*/
        i = i + 2.
        chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
        chWorkSheet:range("D" + string(i) + ":" + "E" + string(i)):merge().
        chWorkSheet:range("G" + string(i) + ":" + "H" + string(i)):merge().
        chWorkSheet:range("I" + string(i) + ":" + "J" + string(i)):merge().
        DO k = 1 TO 10:
            chWorkbook:worksheets(2):cells(i,k):Borders(7):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(2):cells(i,k):Borders(7):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(2):cells(i,k):Borders(8):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(2):cells(i,k):Borders(8):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(2):cells(i,k):Borders(10):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(2):cells(i,k):Borders(10):Weight = 2.      /*  Hairline border's weight */ 
        END.
        chWorkbook:worksheets(2):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,1):value = "集装箱号".
        chWorkbook:worksheets(2):cells(i,3):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,3):value = "箱号".
        chWorkbook:worksheets(2):cells(i,4):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,4):value = "包装箱尺寸".
        chWorkbook:worksheets(2):cells(i,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,6):value = "数量".
        chWorkbook:worksheets(2):cells(i,7):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,7):value = "净重(KGS)".
        chWorkbook:worksheets(2):cells(i,9):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,9):value = "毛重(KGS)".
        i = i + 1.
        chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
        chWorkSheet:range("D" + string(i) + ":" + "E" + string(i)):merge().
        chWorkSheet:range("G" + string(i) + ":" + "H" + string(i)):merge().
        chWorkSheet:range("I" + string(i) + ":" + "J" + string(i)):merge().
        DO k = 1 TO 10:
            chWorkbook:worksheets(2):cells(i,k):Borders(7):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(2):cells(i,k):Borders(7):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(2):cells(i,k):Borders(9):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(2):cells(i,k):Borders(9):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(2):cells(i,k):Borders(10):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(2):cells(i,k):Borders(10):Weight = 2.      /*  Hairline border's weight */ 
        END.
        chWorkbook:worksheets(2):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,1):value = "CONTAINER NO".
        chWorkbook:worksheets(2):cells(i,3):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,3):value = "CASE NO".
        chWorkbook:worksheets(2):cells(i,4):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,4):value = "DIMENSION".
        chWorkbook:worksheets(2):cells(i,6):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,6):value = "QTY".
        chWorkbook:worksheets(2):cells(i,7):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,7):value = "NET WEIGHT".
        chWorkbook:worksheets(2):cells(i,9):Font:BOLD = TRUE.
        chWorkbook:worksheets(2):cells(i,9):value = "GROSS WEIGHT".


        FOR EACH xxwk3 WHERE xxwk3_inv_nbr = xxwk1_inv_nbr 
            BREAK BY xxwk3_cnt_nbr BY xxwk3_box_nbr:

            ACCUMULATE xxwk3_qty (TOTAL BY xxwk3_cnt_nbr).
            ACCUMULATE xxwk3_box_gwt (TOTAL BY xxwk3_cnt_nbr).
            ACCUMULATE xxwk3_box_nwt (TOTAL BY xxwk3_cnt_nbr).
            ACCUMULATE xxwk3_box_nbr (COUNT BY xxwk3_cnt_nbr).
            ACCUMULATE xxwk3_mfg_nwt (TOTAL BY xxwk3_cnt_nbr).

            i = i + 1.
            chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
            chWorkSheet:range("D" + string(i) + ":" + "E" + string(i)):merge().
            chWorkSheet:range("G" + string(i) + ":" + "H" + string(i)):merge().
            chWorkSheet:range("I" + string(i) + ":" + "J" + string(i)):merge().
            chWorkbook:worksheets(2):cells(i,6):HorizontalAlignment = -4152.
            chWorkbook:worksheets(2):cells(i,7):HorizontalAlignment = -4152.
            chWorkbook:worksheets(2):cells(i,9):HorizontalAlignment = -4152.

            chWorkbook:worksheets(2):cells(i,1):value = xxwk3_cnt_nbr.
            chWorkbook:worksheets(2):cells(i,3):value = xxwk3_box_nbr.
            chWorkbook:worksheets(2):cells(i,4):value = xxwk3_box_dim.
            chWorkbook:worksheets(2):cells(i,6):value = xxwk3_qty.
            chWorkbook:worksheets(2):cells(i,7):value = xxwk3_box_nwt.
            chWorkbook:worksheets(2):cells(i,9):value = xxwk3_box_gwt.

            /*subtotal*/
            IF LAST-OF(xxwk3_cnt_nbr) THEN DO:
                i = i + 1.
                chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
                chWorkSheet:range("D" + string(i) + ":" + "E" + string(i)):merge().
                chWorkSheet:range("G" + string(i) + ":" + "H" + string(i)):merge().
                chWorkSheet:range("I" + string(i) + ":" + "J" + string(i)):merge().
                chWorkbook:worksheets(2):cells(i,3):HorizontalAlignment = -4152.
                chWorkbook:worksheets(2):cells(i,6):HorizontalAlignment = -4152.
                chWorkbook:worksheets(2):cells(i,7):HorizontalAlignment = -4152.
                chWorkbook:worksheets(2):cells(i,9):HorizontalAlignment = -4152.

                chWorkbook:worksheets(2):cells(i,3):value = (ACCUM COUNT BY xxwk3_cnt_nbr xxwk3_box_nbr).
                chWorkbook:worksheets(2):cells(i,7):value = (ACCUM TOTAL BY xxwk3_cnt_nbr xxwk3_box_nwt).
                chWorkbook:worksheets(2):cells(i,9):value = (ACCUM TOTAL BY xxwk3_cnt_nbr xxwk3_box_gwt).
            END.
            IF LAST(xxwk3_cnt_nbr) THEN DO:
                i = i + 1.
                chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
                chWorkSheet:range("D" + string(i) + ":" + "E" + string(i)):merge().
                chWorkSheet:range("G" + string(i) + ":" + "H" + string(i)):merge().
                chWorkSheet:range("I" + string(i) + ":" + "J" + string(i)):merge().
                DO k = 3 TO 10:
                    chWorkbook:worksheets(2):cells(i,k):Borders(8):LineStyle  = 1.   /* Top border    */
                    chWorkbook:worksheets(2):cells(i,k):Borders(8):Weight = 2.      /*  Hairline border's weight */ 
                END.
                chWorkbook:worksheets(2):cells(i,1):HorizontalAlignment = -4152.
                chWorkbook:worksheets(2):cells(i,3):HorizontalAlignment = -4152.
                chWorkbook:worksheets(2):cells(i,6):HorizontalAlignment = -4152.
                chWorkbook:worksheets(2):cells(i,7):HorizontalAlignment = -4152.
                chWorkbook:worksheets(2):cells(i,9):HorizontalAlignment = -4152.
                chWorkbook:worksheets(2):cells(i,1):value = "合计".
                chWorkbook:worksheets(2):cells(i,3):value = (ACCUM COUNT xxwk3_box_nbr).
                chWorkbook:worksheets(2):cells(i,7):value = (ACCUM TOTAL xxwk3_box_nwt).
                chWorkbook:worksheets(2):cells(i,9):value = (ACCUM TOTAL xxwk3_box_gwt).
            END.
            
        END.




        
        /*for 3 sheet*hssummary*/
        chWorkSheet = chWorkbook:workSheets(3).
        chWorkSheet:NAME = "CHECK".
        chWorksheet:COLUMNS:Font:SIZE = 10.
        DO j = 1 TO 10:
            chWorkSheet:COLUMNS(j):NumberFormatLocal = "@".
        END.

        i = 1.
        chWorkSheet:range("A" + string(i) + ":" + "F" + string(i)):merge().
        chWorkbook:worksheets(3):cells(i,1):value = "HS 汇总".
        i = i + 1.
        chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
        chWorkSheet:range("C" + string(i) + ":" + "D" + string(i)):merge().
        chWorkSheet:range("E" + string(i) + ":" + "F" + string(i)):merge().
        DO k = 1 TO 6:
            chWorkbook:worksheets(3):cells(i,k):Borders(7):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(3):cells(i,k):Borders(7):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(3):cells(i,k):Borders(8):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(3):cells(i,k):Borders(8):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(3):cells(i,k):Borders(9):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(3):cells(i,k):Borders(9):Weight = 2.      /*  Hairline border's weight */ 
            chWorkbook:worksheets(3):cells(i,k):Borders(10):LineStyle  = 1.   /* Top border    */
            chWorkbook:worksheets(3):cells(i,k):Borders(10):Weight = 2.      /*  Hairline border's weight */ 
        END.
        chWorkbook:worksheets(3):cells(i,1):Font:BOLD = TRUE.
        chWorkbook:worksheets(3):cells(i,1):value = "HS CODE".
        chWorkbook:worksheets(3):cells(i,3):Font:BOLD = TRUE.
        chWorkbook:worksheets(3):cells(i,3):value = "数量 QTY".
        chWorkbook:worksheets(3):cells(i,5):Font:BOLD = TRUE.
        chWorkbook:worksheets(3):cells(i,5):value = "净重 NET WEIGHT".


        FOR EACH xxwk2 WHERE xxwk2_inv_nbr = xxwk1_inv_nbr BREAK BY xxwk2_hscode:
            ACCUMULATE xxwk2_mfg_nwt (TOTAL BY xxwk2_hscode).
            ACCUMULATE xxwk2_qty     (TOTAL BY xxwk2_hscode).
            IF LAST-OF(xxwk2_hscode) THEN DO:
                    i = i + 1.
                    chWorkSheet:range("A" + string(i) + ":" + "B" + string(i)):merge().
                    chWorkSheet:range("C" + string(i) + ":" + "D" + string(i)):merge().
                    chWorkSheet:range("E" + string(i) + ":" + "F" + string(i)):merge().
                    chWorkbook:worksheets(3):cells(i,1):HorizontalAlignment = -4152.
                    chWorkbook:worksheets(3):cells(i,3):HorizontalAlignment = -4152.
                    chWorkbook:worksheets(3):cells(i,5):HorizontalAlignment = -4152.
                    chWorkbook:worksheets(3):cells(i,1):value = xxwk2_hscode.
                    chWorkbook:worksheets(3):cells(i,3):value = (ACCUM TOTAL BY xxwk2_hscode xxwk2_qty).
                    chWorkbook:worksheets(3):cells(i,5):value = (ACCUM TOTAL BY xxwk2_hscode xxwk2_mfg_nwt).
            END.
        END.
        /*for 3 notes*/
        i = i + 3.
        chWorkbook:worksheets(3):cells(i,1):value = "备注:".
        i = i + 1.
        chWorkbook:worksheets(3):cells(i,1):value = "预计到达日期".
        chWorkbook:worksheets(3):cells(i,3):value = xxwk1_date[3].
        i = i + 1.
        chWorkbook:worksheets(3):cells(i,1):value = "承运人".
        chWorkbook:worksheets(3):cells(i,3):value = xxwk1_carrierc.
        chWorkbook:worksheets(3):cells(i,4):value = xxwk1_carriern.

        /*for 3 sheet*error*/
        i = i + 3.
        chWorkbook:worksheets(3):cells(i,1):value = "检查结果:".
        FOR EACH xxwk4 WHERE xxwk4_doc_nbr = xxwk1_inv_nbr BY xxwk4_err_type:
            i = i + 1.
            chWorkbook:worksheets(3):cells(i,1):value = xxwk4_err_type + ":" + xxwk4_err_desc + "(" + xxwk4_err_cmt + ")".
        END.



        /*close*/
        chExcel:DisplayAlerts = FALSE.
        chWorkbook:SaveAs(p_fname,, , ,,,).
        chWorkbook:CLOSE.
        chExcel:QUIT.

        RELEASE OBJECT chWorksheet.
        RELEASE OBJECT chWorkbook.
        RELEASE OBJECT chExcel.
    END.


    p_sys_status = "0".
END PROCEDURE.

/*-----------------------*/
PROCEDURE xxpro-view:
    def input parameter p_fname as char.
    DEF VAR chExcel AS COM-HANDLE.
    DEF VAR chWorkbook AS COM-HANDLE.
    DEF VAR chWorksheet AS COM-HANDLE.

    CREATE "Excel.Application" chExcel.
    chExcel:VISIBLE = YES.
    chWorkbook = chExcel:Workbooks:Open(p_fname).
    chWorkSheet = chWorkbook:workSheets(1).


    MESSAGE "关闭EXCEL，返回" VIEW-AS ALERT-BOX BUTTONS OK.  
    /* Perform housekeeping and cleanup steps */
    chExcel:Application:Workbooks:CLOSE() NO-ERROR.
    chExcel:Application:QUIT NO-ERROR.

    RELEASE OBJECT chWorksheet.
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chExcel.
END PROCEDURE.

/*-----------*/
PROCEDURE xxpro-bud-xxwk4:
    DEF INPUT PARAMETER p_nbr AS CHAR.
    DEF INPUT PARAMETER p_type AS CHAR.
    DEF INPUT PARAMETER p_id AS CHAR.
    DEF INPUT PARAMETER p_cmt AS CHAR.

    CREATE xxwk4.
    ASSIGN 
        xxwk4_doc_nbr  = p_nbr
        xxwk4_err_type = p_type
        xxwk4_err_desc = p_id
        xxwk4_err_cmt  = p_cmt.
    RELEASE xxwk4.
END.


/*****************/
PROCEDURE xxpro-post-process:

    FOR EACH Xxwk1:
        FOR EACH xxwk2 WHERE xxwk2_inv_nbr = xxwk1_inv_nbr:
            FIND FIRST pt_mstr WHERE pt_domain = global_domain and
                       pt_part = xxwk2_part NO-LOCK NO-ERROR.
            IF AVAILABLE pt_mstr THEN DO:
                ASSIGN 
                    xxwk2_mfg_nwt = xxwk2_qty * pt_net_wt
                    xxwk2_hscode  = pt__chr05.
                IF xxwk2_desc = "" THEN xxwk2_desc = pt_desc2.
            END.
            ASSIGN xxwk1_mfg_nwt = xxwk1_mfg_nwt + xxwk2_mfg_nwt.
            FIND FIRST xxwk3 WHERE xxwk3_inv_nbr = xxwk2_inv_nbr AND xxwk3_box_nbr = xxwk2_box_nbr
                NO-ERROR.
            IF AVAILABLE Xxwk3 THEN DO:
                ASSIGN xxwk3_qty = xxwk3_qty + xxwk2_qty.
            END.
        END.
        FOR EACH xxwk3 WHERE xxwk3_inv_nbr = xxwk1_inv_nbr:
            ASSIGN 
                xxwk1_tot_nwt = xxwk1_tot_nwt + xxwk3_box_nwt
                xxwk1_tot_gwt = xxwk1_tot_gwt + xxwk3_box_gwt
                xxwk1_tot_box = xxwk1_tot_box + 1.
        END.
    END.
    IF X_check = YES THEN RUN xxpro-check-data.

END PROCEDURE.

/*****************/
PROCEDURE xxpro-check-data:
    
    DEF VAR v_check_price AS DECIMAL.

    FOR EACH xxwk1:
        FOR EACH xxwk2 WHERE xxwk2_inv_nbr = xxwk1_inv_nbr:
            /*check price*/
            v_check_price = f-getpoprice(xxwk2_order, xxwk2_mfg_line, xxwk1_date[1], xxwk2_qty).
            IF v_check_price <> xxwk2_price THEN
            RUN xxpro-bud-xxwk4 ( INPUT xxwk1_inv_nbr, INPUT "Price", INPUT "EDI and MFG does not match", INPUT STRING(xxwk2_price) + "<>" + STRING(v_check_price)).
        END.
        IF xxwk1_tot_nwt > xxwk1_tot_gwt THEN
            RUN xxpro-bud-xxwk4 ( INPUT xxwk1_inv_nbr, INPUT "Weight", INPUT "Net Weight > Gross Weight", INPUT STRING(xxwk1_tot_nwt) + ">" + STRING(xxwk1_tot_gwt)).
        IF xxwk1_tot_nwt <> xxwk1_mfg_nwt THEN
            RUN xxpro-bud-xxwk4 ( INPUT xxwk1_inv_nbr, INPUT "Weight", INPUT "Net Weight <> DCEC's", INPUT STRING(xxwk1_tot_nwt) + "<>" + STRING(xxwk1_mfg_nwt)).
    END.

    
    /*check netweight*/
    

END PROCEDURE.                                      

