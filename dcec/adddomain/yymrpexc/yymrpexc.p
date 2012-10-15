/*yymrpexc.p    create by: Han Jia  , 2008-11-20    */
/*MRP detail inquire to excel                       */
/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 08/13/12  ECO: *SS-20120813.1*   */

{mfdtitle.i "120813.1"}

def var site        like si_site INIT "DCEC-B".
def var due_date    like tr_effdate INIT TODAY .
def var buyer       like ptp_buyer.
def var buyer1      like ptp_buyer.
def var part        like pt_part.
def var part1       like pt_part.
def var vend        like pt_vend.
def var vend1       like pt_vend.

def var v_buyer     like pt_buyer.
def var v_vend      like pt_vend.
def var v_qty       like mrp_qty.
def var v_trqty     like tr_qty_loc .
def var v_rctpoqty  like tr_qty_loc LABEL "本月累计到货".
def var v_firstday  AS DATE.
def var foutputfile AS CHAR FORMAT "x(55)" INIT "d:\mrp\" LABEL "输出文件".
def var dt          AS DATE EXTENT 32 .
def var dt_qty      AS DEC FORMAT ">>>>>>9.9<" EXTENT 32 .
def var i           AS INT .
def var v_trnbr     LIKE tr_trnbr .

/* define Excel	object handle */
DEFINE VARIABLE chExcelApplication1 AS COM-HANDLE.
DEFINE VARIABLE chWorkbook AS COM-HANDLE.
DEFINE VARIABLE chWorksheet AS COM-HANDLE.
DEFINE VARIABLE iCount AS INTEGER  .
DEFINE VARIABLE iColumn AS INTEGER .
DEFINE VARIABLE cColumn AS CHARACTER.
DEFINE VARIABLE cRange AS CHARACTER.

FORM
   site     colon 22        
   due_date colon 22     
   buyer    colon 22       buyer1 colon 45 label {t001.i}
   part     colon 22        part1 colon 45 label {t001.i} 
   vend     colon 22        vend1 COLON 45 label {t001.i} SKIP(1)
    "**** 请尽量减小选择范围,这样可以保证报表运行效率 ****"      AT 18 skip
   SKIP(1)
   foutputfile colon 22
   skip (1)
   with frame a side-labels width 80 NO-BOX THREE-D .

setframelabels(frame a:handle) .

repeat:
    
    if buyer1 = hi_char then buyer1 = "".
    if part1 = hi_char then part1 = "".
    if vend1 = hi_char then vend1 = "".

    update 
        site VALIDATE(CAN-FIND(si_mstr NO-LOCK WHERE  /* *SS-20120813.1*   */ si_mstr.si_domain = global_domain and si_site = site),
                         "地点错误,请重新输入!" )
        due_date VALIDATE(due_date >= TODAY , "截止日期不能在今天以前!" )
        buyer buyer1 part part1 vend vend1 foutputfile 
        with frame a.

    bcdparm = ""  .
    if due_date = ? then due_date = TODAY.
    if buyer1 = "" then buyer1 = hi_char.
    if part1 = "" then part1 = hi_char.
    if vend1 = "" then vend1 = hi_char.

    if due_date - TODAY > 30 then  DO:
        message "日期范围不允许大于31天!"  view-as alert-box ERROR.
    	UNDO .
        NEXT .  
    END.

    v_firstday = DATE("01/" + SUBSTRING(string(TODAY),4,3) 
                      + SUBSTRING(string(TODAY),7,2)) .
    FIND FIRST tr_hist NO-LOCK WHERE  /* *SS-20120813.1*   */ tr_hist.tr_domain = global_domain and tr_effdate >= v_firstday NO-ERROR .
    IF AVAIL tr_hist THEN v_trnbr = tr_trnbr .

    if foutputfile = "" OR (substring(foutputfile,length(foutputfile) - 3,4) <> ".xls") then do:
		message "输出文件必须是EXCEL表格，以XLS为文件后缀名，请重新输入！" view-as alert-box.
	    NEXT .
	end.
    if search(foutputfile) <> ? then do:
    	message "输出文件存在，请确认没有打开此文件! 此操作将覆盖已有文件!" 
            view-as alert-box button YES-NO update yn1 as logic.
    	if yn1 <> yes then do:
    		UNDO .
            NEXT .
    	end.
    end.
    REPEAT i = 1 TO due_date - TODAY + 1:
        dt[i] = TODAY + i - 1 .
    END.

    ASSIGN iColumn = 1 .
        /* create a new Excel Application object */
    CREATE "Excel.Application" chExcelApplication1.
    
    /* create a new Workbook */
    chWorkbook = chExcelApplication1:Workbooks:Add().
    
    /* get the active Worksheet */
    chWorkSheet = chExcelApplication1:Sheets:Item(1).
    chWorkSheet:Columns("A"):ColumnWidth = 8.
    chWorkSheet:Columns("B"):ColumnWidth = 12.
    chWorkSheet:Columns("C"):ColumnWidth = 18.
    chWorkSheet:Columns("D"):ColumnWidth = 12.
    chWorkSheet:Columns("E"):ColumnWidth = 4.
    chWorkSheet:Columns("F"):ColumnWidth = 8.
    chWorkSheet:Columns("G"):ColumnWidth = 10.
    chWorkSheet:Columns("H"):ColumnWidth = 12.
    chWorkSheet:Columns("I"):ColumnWidth = 12.
    chWorkSheet:Range("A1"):Value = "地点".
    chWorkSheet:Range("B1"):Value = "零件号".   
    chWorkSheet:Range("C1"):Value = "零件名称". 
    chWorkSheet:Range("D1"):Value = "当前库存量". 
    chWorkSheet:Range("E1"):Value = "状态".     
    chWorkSheet:Range("F1"):Value = "计划员" .
    chWorkSheet:Range("G1"):Value = "供应商".   
    chWorkSheet:Range("H1"):Value = "月初库存". 
    chWorkSheet:Range("I1"):Value = "本月累计到货".    
 
    REPEAT i = 10 TO due_date - TODAY + 11 :
        chWorkSheet:cells(1,i):Value = SUBSTRING(string(dt[i - 9]),4,3) + SUBSTRING(string(dt[i - 9]),1,2) .
    END.

    FOR EACH in_mstr fields(in_part in_site in_qty_oh)
        NO-LOCK WHERE  /* *SS-20120813.1*   */ in_mstr.in_domain = global_domain and in_site = site
        AND in_part >= part AND in_part <= part1:
        FIND FIRST ptp_det NO-LOCK WHERE  /* *SS-20120813.1*   */ ptp_det.ptp_domain = global_domain and ptp_part = in_part 
            AND ptp_site = site NO-ERROR .
        FIND FIRST pt_mstr NO-LOCK WHERE  /* *SS-20120813.1*   */ pt_mstr.pt_domain = global_domain and pt_part = in_part NO-ERROR .

        IF AVAIL pt_mstr THEN DO:
            IF AVAIL ptp_det THEN ASSIGN v_buyer = ptp_buyer v_vend = ptp_vend .
            ELSE ASSIGN v_buyer = pt_buyer v_vend = pt_vend .
        END.
        ELSE DO:
            NEXT .
        END.

        IF v_buyer >= buyer AND v_buyer <= buyer1 
            AND v_vend >= vend AND v_vend <= vend1 THEN DO:
            v_qty = 0 .
            FOR EACH mrp_det 
                fields(mrp_dataset mrp_part mrp_nbr mrp_line mrp_line2 
                       mrp_site mrp_type mrp_detail mrp_due_date mrp_qty mrp_rel_date)
                WHERE  /* *SS-20120813.1*   */ mrp_det.mrp_domain = global_domain and mrp_dataset = "wod_det" AND mrp_part = in_part
                AND mrp_site = in_site AND mrp_due_date <= due_date 
                AND mrp_due_date >= TODAY NO-LOCK
                BREAK BY mrp_site BY mrp_part BY mrp_due_date:
                v_qty = v_qty + mrp_qty .
                IF LAST-OF (mrp_due_date) THEN DO: 
                    ASSIGN dt_qty[int(mrp_due_date) - int(TODAY) + 1] = v_qty 
                        v_qty = 0 .
                END.
                IF LAST-OF(mrp_part) THEN do:
                    ASSIGN v_trqty = 0 
                        v_rctpoqty = 0 .
                    FOR EACH tr_hist FIELDS(tr_site tr_part tr_nbr tr_type
                                            tr_effdate tr_ship_type tr_qty_loc)
                        NO-LOCK WHERE /* *SS-20120813.1*   */ tr_hist.tr_domain = global_domain and tr_trnbr >= v_trnbr
                        AND tr_effdate >= v_firstday AND tr_effdate <= TODAY 
                        AND tr_site = site AND tr_part = mrp_part 
                        AND (tr_type BEGINS "iss" OR tr_type BEGINS "rct")
                        AND tr_ship_type = ""  :
                        IF tr_type = "rct-po" THEN ASSIGN v_rctpoqty = v_rctpoqty + tr_qty_loc .
                        ASSIGN v_trqty = v_trqty + tr_qty_loc .
                    END.
    
                    iColumn = iColumn + 1.
                    cColumn = STRING(iColumn).
                    cRange = "A" + cColumn.
                    chWorkSheet:Range(cRange):Value = in_site .
                    cRange = "B" + cColumn.
                    chWorkSheet:Range(cRange):Value = in_part .
                    cRange = "C" + cColumn.
                    chWorkSheet:Range(cRange):Value = pt_desc2 .
                    cRange = "D" + cColumn.
                    chWorkSheet:Range(cRange):Value = in_qty_oh .
                    cRange = "E" + cColumn.
                    chWorkSheet:Range(cRange):Value = pt_status .
                    cRange = "F" + cColumn.
                    chWorkSheet:Range(cRange):Value = v_buyer .
                    cRange = "G" + cColumn.
                    chWorkSheet:Range(cRange):Value = v_vend .
                    cRange = "H" + cColumn.
                    chWorkSheet:Range(cRange):Value = in_qty_oh - v_trqty .
                    cRange = "I" + cColumn.
                    chWorkSheet:Range(cRange):Value = v_rctpoqty .
                    REPEAT i =  1 TO due_date - TODAY + 1:
                        chWorkSheet:cells(iColumn,i + 9):VALUE = dt_qty[i] .
                        dt_qty[i] = 0 .
                    END. /*REPEAT i =  1 end */
                END. /*IF LAST-OF(mrp_part) end */
            END.  /*FOR EACH mrp_det end */
        END. /*IF v_buyer >= buyer AND v_buyer <= buyer1 */
    END. /*FOR EACH in_mstr end */
    chWorkbook:saveas(foutputfile , , , , , , 1) . 
    chExcelApplication1:Visible = TRUE.
    
    RELEASE OBJECT chExcelApplication1. 
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.
END.
                                               
