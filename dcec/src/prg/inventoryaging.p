
DEFINE VAR v_local_amount LIKE IN_qty_oh INITIAL 0.
DEFINE VAR v_import_amount LIKE IN_qty_oh INITIAL 0.
DEFINE VAR v_fg_amount LIKE IN_qty_oh INITIAL 0.
DEFINE VAR v_a_amount LIKE IN_qty_oh INITIAL 0.
DEFINE VAR v_b_amount LIKE IN_qty_oh INITIAL 0.
DEFINE VAR v_c_amount LIKE IN_qty_oh INITIAL 0.

DEFINE VAR v_180_qty LIKE IN_qty_oh INITIAL 0.
DEFINE VAR v_360_qty LIKE IN_qty_oh INITIAL 0.
DEFINE VAR v_720_qty LIKE IN_qty_oh INITIAL 0.
DEFINE VAR v_1080_qty LIKE IN_qty_oh INITIAL 0.
DEFINE VAR v_over_qty LIKE IN_qty_oh INITIAL 0.

DEFINE VAR v_qty LIKE IN_qty_oh INITIAL 0.

DEFINE VAR i AS INTEGER INITIAL 0.

DEFINE WORKFILE xxwk
    FIELD xx_part LIKE in_part
    FIELD xx_line LIKE pt_prod_line
    FIELD xx_qty LIKE IN_qty_oh
    FIELD xx_price LIKE sct_cst_tot
    FIELD xx_desc1 LIKE pt_desc1
    FIELD xx_desc2 LIKE pt_desc2
    FIELD xx_planner LIKE ptp_buyer.

DEFINE WORKFILE yywk
    FIELD yy_part LIKE in_part
    FIELD yy_line LIKE pt_prod_line
    FIELD yy_qty LIKE IN_qty_oh Label "Qty On Total"
    FIELD yy_180_qty LIKE IN_qty_oh Label "Qty On(180)"
    FIELD yy_360_qty LIKE IN_qty_oh Label "Qty On(360)"
    FIELD yy_720_qty LIKE IN_qty_oh Label "Qty On(720)"
    FIELD yy_1080_qty LIKE IN_qty_oh Label "Qty On(1080)"
    FIELD yy_over_qty LIKE IN_qty_oh Label "Qty On(Over)"
    FIELD yy_price LIKE sct_cst_tot Label "cost"
    FIELD yy_desc1 LIKE pt_desc1
    FIELD yy_desc2 LIKE pt_desc2
    FIELD yy_planner LIKE ptp_buyer
    FIELD yy_l360_amount LIKE IN_qty_oh Label "Amount>360"
    FIELD yy_pl_name LIKE CODE_cmmt.

/*
DEFINE NEW SHARED VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE NEW SHARED VARIABLE chExcelWorkbook AS COM-HANDLE.
*/

FOR EACH IN_mstr WHERE in_qty_oh <> 0 OR in_qty_nonet <> 0 NO-LOCK.
    FIND FIRST pt_mstr WHERE pt_part = IN_part NO-LOCK NO-ERROR.
    IF AVAIL pt_mstr THEN DO:
        FIND si_mstr NO-LOCK WHERE si_site = "DCEC-C" NO-ERROR.
        FIND FIRST sct_det NO-LOCK WHERE sct_part = in_part AND sct_sim = si_gl_set AND sct_cst_tot <> 0 NO-ERROR.
        IF AVAIL sct_det THEN DO:
            IF pt_prod_line >= "1000" AND pt_prod_line <= "11ZZ" THEN v_local_amount = v_local_amount + (IN_qty_oh + IN_qty_nonet) * sct_cst_tot.
            IF (pt_prod_line >= "1200" AND pt_prod_line <= "1ZZZ") OR (pt_prod_line >= "5000" AND pt_prod_line <= "6ZZZ") 
                THEN v_import_amount = v_import_amount + (IN_qty_oh + IN_qty_nonet) * sct_cst_tot.
            IF (pt_prod_line >= "2000" AND pt_prod_line <= "2ZZZ") OR (pt_prod_line >= "7000" AND pt_prod_line <= "80ZZ")
                THEN v_fg_amount  = v_fg_amount + (IN_qty_oh + IN_qty_nonet) * sct_cst_tot.
            IF IN_abc = "A" THEN v_a_amount  = v_a_amount + (IN_qty_oh + IN_qty_nonet) * sct_cst_tot.
            IF IN_abc = "B" THEN v_b_amount  = v_b_amount + (IN_qty_oh + IN_qty_nonet) * sct_cst_tot.
            IF IN_abc = "C" THEN v_c_amount  = v_c_amount + (IN_qty_oh + IN_qty_nonet) * sct_cst_tot.
        END.
    END.
END.


/*IF SEARCH("\\dcecssy009\bp-report\存货Inventory.xls") = ? THEN DO: 
   MESSAGE "报表模板不存在!" VIEW-AS ALERT-BOX ERROR.
   UNDO,RETRY.
END.

CREATE "Excel.Application" chExcelApplication.
chExcelWorkbook = chExcelApplication:Workbooks:OPEN("\\dcecssy009\bp-report\存货Inventory.xls").



chExcelWorkbook:worksheets("Yearly Inventory(1)"):cells(2,INTEGER(YEAR(TODAY - 1)) - 2002):VALUE = v_local_amount / 1000000.
chExcelWorkbook:worksheets("Yearly Inventory(1)"):cells(3,INTEGER(YEAR(TODAY - 1)) - 2002):VALUE = v_import_amount / 1000000.
chExcelWorkbook:worksheets("Yearly Inventory(1)"):cells(4,INTEGER(YEAR(TODAY - 1)) - 2002):VALUE = v_fg_amount / 1000000.
chExcelWorkbook:worksheets("Yearly Inventory(1)"):cells(9,INTEGER(YEAR(TODAY - 1)) - 2002):VALUE = v_a_amount / 1000000.
chExcelWorkbook:worksheets("Yearly Inventory(1)"):cells(10,INTEGER(YEAR(TODAY - 1)) - 2002):VALUE = v_b_amount / 1000000.
chExcelWorkbook:worksheets("Yearly Inventory(1)"):cells(11,INTEGER(YEAR(TODAY - 1)) - 2002):VALUE = v_c_amount / 1000000.

chExcelWorkbook:worksheets("Monthly Inventory(1)"):cells(2,INTEGER(MONTH(TODAY - 1)) + 1):VALUE = v_local_amount / 1000000.
chExcelWorkbook:worksheets("Monthly Inventory(1)"):cells(3,INTEGER(MONTH(TODAY - 1)) + 1):VALUE = v_import_amount / 1000000.
chExcelWorkbook:worksheets("Monthly Inventory(1)"):cells(4,INTEGER(MONTH(TODAY - 1)) + 1):VALUE = v_fg_amount / 1000000.
chExcelWorkbook:worksheets("Monthly Inventory(1)"):cells(9,INTEGER(MONTH(TODAY - 1)) + 1):VALUE = v_a_amount / 1000000.
chExcelWorkbook:worksheets("Monthly Inventory(1)"):cells(10,INTEGER(MONTH(TODAY - 1)) + 1):VALUE = v_b_amount / 1000000.
chExcelWorkbook:worksheets("Monthly Inventory(1)"):cells(11,INTEGER(MONTH(TODAY - 1)) + 1):VALUE = v_c_amount / 1000000.
*/

/*aging*/

FOR EACH IN_mstr NO-LOCK WHERE in_qty_oh <> 0 OR in_qty_nonet <> 0 BREAK BY IN_part.
    IF FIRST-OF(IN_part) THEN v_qty = 0.
    v_qty = v_qty + IN_qty_oh + IN_qty_nonet.
    IF LAST-OF(IN_part) THEN DO:
        FIND FIRST pt_mstr NO-LOCK WHERE pt_part = IN_part NO-ERROR.
        FIND FIRST si_mstr NO-LOCK WHERE si_site = "DCEC-C" NO-ERROR.
        FIND FIRST sct_det NO-LOCK WHERE sct_part = in_part AND sct_sim = si_gl_set AND sct_cst_tot <> 0 NO-ERROR.
        FIND FIRST ptp_det NO-LOCK WHERE ptp_part = IN_part AND ptp_buyer <> "" NO-ERROR.
        FIND FIRST xxwk WHERE xx_part = IN_part NO-ERROR.
        IF NOT AVAIL xxwk THEN DO:
            CREATE xxwk.
                    xx_part = IN_part.
                    xx_line = IF AVAIL pt_mstr THEN pt_prod_line ELSE "".
                    xx_qty = v_qty.
                    xx_price = IF AVAIL sct_det THEN sct_cst_tot ELSE 0.
                    xx_desc1 = IF AVAIL pt_mstr THEN pt_desc1 ELSE "".
                    xx_desc2 = IF AVAIL pt_mstr THEN pt_desc2 ELSE "".
                    xx_planner = IF AVAIL ptp_det THEN ptp_buyer ELSE "".
            END.
    END.
END.




FOR EACH xxwk NO-LOCK.
    v_180_qty = 0.
    v_360_qty = 0.
    v_720_qty = 0.
    v_1080_qty = 0.
    v_over_qty = 0.

    FOR EACH tr_hist NO-LOCK WHERE tr_part = xx_part AND (tr_type = "RCT-PO" OR tr_type = "RCT-WO" OR tr_type = "RCT-UNP") AND TODAY - tr_effdate <= 1080 BY tr_effdate DESCENDING.
        IF (TODAY - tr_effdate) <= 180 THEN v_180_qty = v_180_qty + tr_qty_loc.
        IF xx_qty - v_180_qty <= 0 THEN DO:
            v_180_qty = MIN(v_180_qty, xx_qty).
            LEAVE.
        END.

        IF (TODAY - tr_effdate) >= 181 AND (TODAY - tr_effdate) <= 360 THEN v_360_qty = v_360_qty + tr_qty_loc.
        IF xx_qty - v_180_qty - v_360_qty <= 0 THEN DO:
            v_360_qty = MIN(v_360_qty, xx_qty - v_180_qty).
            LEAVE.
        END.

        IF (TODAY - tr_effdate) >= 361 AND (TODAY - tr_effdate) <= 720 THEN v_720_qty = v_720_qty + tr_qty_loc.
        IF xx_qty - v_180_qty - v_360_qty - v_720_qty <= 0 THEN DO:
            v_720_qty = MIN(v_720_qty, xx_qty - v_180_qty - v_360_qty).
            LEAVE.
        END.

        IF (TODAY - tr_effdate) >= 721 AND (TODAY - tr_effdate) <= 1080 THEN v_1080_qty = v_1080_qty + tr_qty_loc.
        IF xx_qty - v_180_qty - v_360_qty - v_720_qty - v_1080_qty <= 0 THEN DO:
            v_1080_qty = MIN(v_1080_qty, xx_qty - v_180_qty - v_720_qty).
            LEAVE.
        END.
    END.
    FIND FIRST yywk WHERE yy_part = xx_part NO-ERROR.
    FIND FIRST emp_mstr WHERE emp_addr = xx_planner NO-ERROR.
    IF NOT AVAIL yywk THEN DO:
        CREATE yywk.
            yy_part = xx_part.
            yy_line = xx_line.
            yy_qty = xx_qty.
            yy_180_qty = v_180_qty.
            yy_360_qty = v_360_qty.
            yy_720_qty = v_720_qty.
            yy_1080_qty = v_1080_qty.
            yy_over_qty = IF xx_qty - v_180_qty - v_360_qty - v_720_qty - v_1080_qty > 0 THEN xx_qty - v_180_qty - v_360_qty - v_720_qty - v_1080_qty ELSE 0.
            yy_price = xx_price.
            yy_desc1 = xx_desc1.
            yy_desc2 = xx_desc2.
            yy_planner = xx_planner.
            yy_l360_amount = (yy_over_qty + yy_1080_qty + yy_720_qty) * yy_price.
            yy_pl_name = IF AVAIL emp_mstr THEN emp_lname + emp_fname ELSE "". 
    END.
END.


v_180_qty = 0.
v_360_qty = 0.
v_720_qty = 0.
v_1080_qty = 0.
v_over_qty = 0.

OUTPUT TO d:\inventoryaging.txt.
FOR EACH yywk.
    DISP yywk WITH WIDTH 300 STREAM-IO.
    v_180_qty = v_180_qty + yy_180_qty * yy_price.
    v_360_qty = v_360_qty + yy_360_qty * yy_price.
    v_720_qty = v_720_qty + yy_720_qty * yy_price.
    v_1080_qty = v_1080_qty + yy_1080_qty * yy_price.
    v_over_qty = v_over_qty + yy_over_qty * yy_price.

END.


/*
chExcelWorkbook:worksheets("Yearly Aging"):cells(2,INTEGER(YEAR(TODAY - 1)) - 2002):VALUE = v_over_qty / 1000000.
chExcelWorkbook:worksheets("Yearly Aging"):cells(3,INTEGER(YEAR(TODAY - 1)) - 2002):VALUE = v_1080_qty / 1000000.
chExcelWorkbook:worksheets("Yearly Aging"):cells(4,INTEGER(YEAR(TODAY - 1)) - 2002):VALUE = v_720_qty / 1000000.
chExcelWorkbook:worksheets("Yearly Aging"):cells(5,INTEGER(YEAR(TODAY - 1)) - 2002):VALUE = v_360_qty / 1000000.
chExcelWorkbook:worksheets("Yearly Aging"):cells(6,INTEGER(YEAR(TODAY - 1)) - 2002):VALUE = v_180_qty / 1000000.

chExcelWorkbook:worksheets("Monthly Aging(1)"):cells(2,INTEGER(MONTH(TODAY - 1)) + 1):VALUE = v_over_qty / 1000000.
chExcelWorkbook:worksheets("Monthly Aging(1)"):cells(3,INTEGER(MONTH(TODAY - 1)) + 1):VALUE = v_1080_qty / 1000000.
chExcelWorkbook:worksheets("Monthly Aging(1)"):cells(4,INTEGER(MONTH(TODAY - 1)) + 1):VALUE = v_720_qty / 1000000.
chExcelWorkbook:worksheets("Monthly Aging(1)"):cells(5,INTEGER(MONTH(TODAY - 1)) + 1):VALUE = v_360_qty / 1000000.
chExcelWorkbook:worksheets("Monthly Aging(1)"):cells(6,INTEGER(MONTH(TODAY - 1)) + 1):VALUE = v_180_qty / 1000000.


/*for top 10*/

i = 0.

FOR EACH yywk  WHERE (yy_line >= "1100" AND yy_line <= "1ZZZ") OR (yy_line >= "5201" AND yy_line <= "6ZZZ") BY yy_l360_amount DESCENDING.
    i = i + 1.
    chExcelWorkbook:worksheets("Top10(>360)-part"):cells(i + 1,1):VALUE = yy_part.
    chExcelWorkbook:worksheets("Top10(>360)-part"):cells(i + 1,2):VALUE = yy_desc1.
    chExcelWorkbook:worksheets("Top10(>360)-part"):cells(i + 1,3):VALUE = yy_desc2.
    chExcelWorkbook:worksheets("Top10(>360)-part"):cells(i + 1,4):VALUE = yy_over_qty + yy_1080_qty + yy_720_qty.
    chExcelWorkbook:worksheets("Top10(>360)-part"):cells(i + 1,5):VALUE = yy_l360_amount / 1000.
    chExcelWorkbook:worksheets("Top10(>360)-part"):cells(i + 1,6):VALUE = yy_pl_name.
    IF i = 10 THEN LEAVE.
END.

i = 0.
FOR EACH yywk  WHERE (yy_line >= "2000" AND yy_line <= "2ZZZ") OR (yy_line >= "7000" AND yy_line <= "80ZZ") BY yy_l360_amount DESCENDING.
    i = i + 1.
    chExcelWorkbook:worksheets("Top10(>360)-Engine"):cells(i + 1,1):VALUE = yy_part.
    chExcelWorkbook:worksheets("Top10(>360)-Engine"):cells(i + 1,2):VALUE = yy_desc1.
    chExcelWorkbook:worksheets("Top10(>360)-Engine"):cells(i + 1,3):VALUE = yy_desc2.
    chExcelWorkbook:worksheets("Top10(>360)-Engine"):cells(i + 1,4):VALUE = yy_over_qty + yy_1080_qty + yy_720_qty.
    chExcelWorkbook:worksheets("Top10(>360)-Engine"):cells(i + 1,5):VALUE = yy_l360_amount / 1000.
    chExcelWorkbook:worksheets("Top10(>360)-Engine"):cells(i + 1,6):VALUE = yy_pl_name.
    IF i = 10 THEN LEAVE.
END.

/*DISP v_local_amount v_import_amount v_fg_amount v_a_amount v_b_amount v_c_amount WITH WIDTH 180 STREAM-IO.*/

/*
chExcelWorkbook:worksheets("Chart"):cells(22,"R"):value = TODAY.
*/

chExcelApplication:DisplayAlerts = FALSE.
chExcelWorkbook:saveas("\\dcecssy009\bp-report\存货Inventory.xls" , , , , , , 1). 
chExcelApplication:Visible = TRUE.
RELEASE OBJECT chExcelWorkbook.
chExcelApplication:QUIT.
RELEASE OBJECT chExcelApplication. */
