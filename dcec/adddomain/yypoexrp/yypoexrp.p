/*yypoexrp.p, CREATE BY Han Jia   2008-11-18          	*/
/* Load receipt and output 5.13.5 to excel       	*/

/* DISPLAY TITLE */
{mfdtitle.i "120816.1"}

def var iError as integer.

def var finputfile  as char format "x(55)".
def var foutputfile as char format "x(55)".

def var iRow as integer.  
def stream outputfile .

DEF TEMP-TABLE xxwk
    field xxwk_rc   like tr_lot 
    field xxwk_line LIKE tr_line
    FIELD xxwk_nbr  AS INT .

DEF TEMP-TABLE xxwk1
    field xxwk1_rc like tr_lot 
    field xxwk1_line  LIKE tr_line 
    FIELD xxwk1_nbr  AS INT .

def var msg_file as char format "x(80)".

/* define Excel	object handle */
DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE VARIABLE chExcelWorkbook AS COM-HANDLE.
DEFINE VARIABLE chExcelWorksheet AS COM-HANDLE.

DEFINE VARIABLE chExcelApplication1 AS COM-HANDLE.
DEFINE VARIABLE chWorkbook AS COM-HANDLE.
DEFINE VARIABLE chWorksheet AS COM-HANDLE.
DEFINE VARIABLE iCount AS INTEGER  .
DEFINE VARIABLE iColumn AS INTEGER .
DEFINE VARIABLE cColumn AS CHARACTER.
DEFINE VARIABLE cRange AS CHARACTER.

define variable rdate           like prh_rcp_date.
define variable rdate1          like prh_rcp_date.
define variable part            like pt_part.
define variable part1           like pt_part.
define variable site            like pt_site.
define variable site1           like pt_site.
define variable vendor          like po_vend.
define variable vendor1         like po_vend.
define variable sel_inv         like mfc_logical
   label "Inventory Items" initial yes.
define variable sel_sub         like mfc_logical
   label "Subcontracted Items" initial yes.
define variable sel_mem         like mfc_logical
   label "Memo Items" initial no.
define variable uninv_only      like mfc_logical
   label "只打未做凭证的收货" /* "Non-Vouchered Only" */ initial yes.


FORM /*GUI*/ 
    finputfile	   colon 15		label	"导入文件"
    foutputfile    colon 15		label	"输出文件"  SKIP(1)     
    rdate            colon 15
    rdate1           label "To" colon 49 skip
    vendor           colon 15
    vendor1          label "To" colon 49 skip
    part             colon 15
    part1            label "To" colon 49 skip
    site             colon 15
    site1            label "To" colon 49
    sel_inv          colon 20
    sel_sub          colon 20
    sel_mem          colon 20 /* det COLON 49 SKIP */
    uninv_only       colon 20
    SKIP(.4)  /*GUI*/
    with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

setFrameLabels(frame a:handle) .
   	
mainloop:
repeat with frame a:
    DO TRANSACTION ON ERROR UNDO, LEAVE: 
    	for each xxwk:
		delete xxwk.
	end.
	for each xxwk1:
		delete xxwk1.
	end .
    		/* input file and output file:*/
    	if finputfile = "" then finputfile = "D:\receipt\". 
     	update finputfile with frame a.
    	
    	if search(finputfile) = ? then do:
    		message "找不到导入文件，请输入正确的路径和文件名！" view-as alert-box.
    		undo, retry.
    	end.
    			
    	if (substring(finputfile,length(finputfile) - 3,4) <> ".xls") then do:
    		message "导入文件必须是EXCEL表格，以XLS为文件后缀名，请重新输入！" view-as alert-box.
    	    NEXT mainloop.
    	end.
    
        /* Create a New chExcel Application object */
    	CREATE "Excel.Application" chExcelApplication.
        
    	/*Create a new workbook based on the template chExcel file */
    	chExcelWorkbook = chExcelApplication:Workbooks:OPEN(finputfile,0,true,,,,true).
        chExcelWorkSheet = chExcelApplication:Sheets:Item(1).
    
    	/* read EXCEL file begin..*/
    	iRow = 1.	
    	iError = 0.
    	
    	output stream outputfile to 
            VALUE(substring(finputfile,1,length(finputfile) - 4) + ".lg") APPEND .
    
    	setschdate:
        repeat:
    		iRow = iRow + 1.
    		if string(chExcelWorkbook:Worksheets(1):Cells(iRow,"A"):value) = "" then leave.
    		if string(chExcelWorkbook:Worksheets(1):Cells(iRow,"A"):value) = ? then leave.
        	CREATE xxwk .
            ASSIGN xxwk_rc = string(chExcelWorkbook:Worksheets(1):Cells(iRow,"A"):value) 
                xxwk_line = INT(chExcelWorkbook:Worksheets(1):Cells(iRow,"B"):value)
                xxwk_nbr = INT(chExcelWorkbook:Worksheets(1):Cells(iRow,"C"):value) .
            FIND FIRST prh_hist NO-LOCK WHERE prh_domain = global_domain and prh_receiver = xxwk_rc NO-ERROR .
            IF NOT AVAIL prh_hist THEN DO: 
                iError = iError + 1 .
                msg_file = string(TODAY) + " " + string(TIME,"HH:MM") + 
                    " Error: 没有收货单" + xxwk_rc + "的收货记录."  .
                put stream outputfile  msg_file SKIP .
                DELETE xxwk .
            END.
        END. /*setschdate end*/
    
        OUTPUT STREAM outputfile CLOSE .
        
        chExcelWorkbook:CLOSE(FALSE).
        chExcelApplication:QUIT.
        RELEASE OBJECT chExcelApplication. 
        RELEASE OBJECT chExcelWorkbook .
        RELEASE OBJECT chExcelWorkSheet .

    END. /* DO TRANSACTION ON ERROR UNDO, LEAVE end */

    IF iError > 0 THEN DO: 
        MESSAGE "有" + string(iError) 
            + "条错误！请查看LOG文件："  
            + substring(finputfile,1,length(finputfile) - 4) + ".lg" VIEW-AS ALERT-BOX ERROR.
        NEXT mainloop .
    END.
        
    IF iError = 0 THEN 
        os-delete value(substring(finputfile,1,length(finputfile) - 4) + ".lg") .

    FIND FIRST xxwk NO-ERROR .
    IF NOT AVAIL xxwk THEN DO:
        MESSAGE "没有任何匹配此导入文件的系统收货记录,可能是导入文件有误,请检查! "   .
        NEXT mainloop .
    END.

    FOR EACH xxwk BREAK BY xxwk_rc :
        IF FIRST-OF(xxwk_rc) THEN DO:
            FOR EACH prh_hist FIELDS(prh_domain prh_receiver prh_line) 
                NO-LOCK WHERE prh_domain = global_domain and prh_receiver = xxwk_rc 
                USE-INDEX prh_receiver :
                CREATE xxwk1.
                ASSIGN xxwk1_rc = prh_receiver
                    xxwk1_line = prh_line 
                    xxwk1_nbr = xxwk_nbr .
            END.
        END.
    END.
    FOR EACH xxwk WHERE xxwk_line > 0 :
            FIND FIRST xxwk1 WHERE xxwk1_rc = xxwk_rc 
                AND xxwk1_line = xxwk_line NO-ERROR .
            IF AVAIL xxwk1 THEN DELETE xxwk1.
    END.

    FIND FIRST xxwk1 NO-ERROR .
    IF NOT AVAIL xxwk1 THEN DO:
        MESSAGE "没有任何匹配此导入文件的系统收货记录,可能是导入文件有误,请检查!"   .
        NEXT mainloop .
    END.

    SecondLoop:
    REPEAT:
        foutputfile = substring(finputfile,1,length(finputfile) - 4) + "rp.xls" .
        if rdate = low_date then rdate = ?. 
        if rdate1 = hi_date then rdate1 = today. 
        if vendor1 = hi_char then vendor1 = "".
        if part1 = hi_char then part1 = "".
        if site1 = hi_char then site1 = "".
        
        update foutputfile 
               rdate      
               rdate1     
               vendor     
               vendor1    
               part       
               part1      
               site       
               site1      
               sel_inv    
               sel_sub    
               sel_mem    
               uninv_only
            with frame a.
    
        bcdparm = ""  .
        if rdate = ? then rdate = low_date.
        if rdate1 = ? then rdate1 = today.
        if vendor1 = "" then vendor1 = hi_char.
        if part1 = "" then part1 = hi_char.
        if site1 = "" then site1 = hi_char.
    
        IF foutputfile = "" THEN DO:
            MESSAGE "Please maintain filename!" VIEW-AS ALERT-BOX ERROR.
            UNDO .
            NEXT SecondLoop .
        END.
        if search(foutputfile) <> ? then do:
    		message "输出文件存在，请确认没有打开此文件! 此操作将覆盖已有文件!" 
                view-as alert-box button YES-NO update yn as logic.
    		if yn <> yes then do:
    			UNDO .
                NEXT SecondLoop .
    		end.
    	end.
    
        ASSIGN iColumn = 1 .
        /* create a new Excel Application object */
        CREATE "Excel.Application" chExcelApplication1.
        
        /* create a new Workbook */
        chWorkbook = chExcelApplication1:Workbooks:Add().
        
        /* get the active Worksheet */
        chWorkSheet = chExcelApplication1:Sheets:Item(1).
        chWorkSheet:Columns("A"):ColumnWidth = 8.
        chWorkSheet:Columns("B"):ColumnWidth = 10.
        chWorkSheet:Columns("C"):ColumnWidth = 10.
        chWorkSheet:Columns("D"):ColumnWidth = 10.
        chWorkSheet:Columns("E"):ColumnWidth = 4.
        chWorkSheet:Columns("F"):ColumnWidth = 18.
        chWorkSheet:Columns("G"):ColumnWidth = 10.
        chWorkSheet:Columns("H"):ColumnWidth = 12.
        chWorkSheet:Columns("I"):ColumnWidth = 12.
        chWorkSheet:Columns("J"):ColumnWidth = 16.
        chWorkSheet:Range("A1:K1"):Font:Bold = TRUE.
        chWorkSheet:Range("A1"):Value = "地点".
        chWorkSheet:Range("B1"):Value = "供应商".   
        chWorkSheet:Range("C1"):Value = "收货单号". 
        chWorkSheet:Range("D1"):Value = "采购单号". 
        chWorkSheet:Range("E1"):Value = "行号".     
        chWorkSheet:Range("F1"):Value = "零件号".
        chWorkSheet:Range("G1"):Value = "收货日期".
        chWorkSheet:Range("H1"):Value = "收货数量".
        chWorkSheet:Range("I1"):Value = "采购成本".
        chWorkSheet:Range("J1"):Value = "采购金额".
        chWorkSheet:Range("K1"):Value = "发票目录".
    
        FOR EACH xxwk1 :
            for EACH prh_hist no-lock
                where prh_domain = global_domain 
                 and (prh_rcp_date >= rdate and prh_rcp_date <= rdate1
                     or  (prh_rcp_date = ? and rdate = low_date))
                and (prh_vend >= vendor and prh_vend <= vendor1)
                and (prh_part >= part and prh_part <= part1)
                and (prh_site >= site and prh_site <= site1)
             /*   and (prh_ps_nbr >= fr_ps_nbr and prh_ps_nbr <= to_ps_nbr) */
                and ((prh_type = "" and sel_inv = yes)
                or  (prh_type = "S" and sel_sub = yes)
                or  (prh_type <> "" and prh_type <> "S" and sel_mem = yes))
    	        and prh_receiver = xxwk1_rc and prh_line = xxwk1_line
                and (uninv_only = no  /* Non-Vouchered Receipts Only = NO */
                       or
                     (uninv_only   and  /* Non-Vouchered Receipts Only = YES */
                        not can-find (first pvo_mstr no-lock where 
                        		pvo_domain = global_domain and
                            pvo_lc_charge         = ""                 and
                            pvo_internal_ref_type = "07"		 and
                            pvo_internal_ref      = prh_receiver       and
                            pvo_line              = prh_line           and
                            pvo_last_voucher      <> ""))) :
                iColumn = iColumn + 1.
                cColumn = STRING(iColumn).
                cRange = "A" + cColumn.
                chWorkSheet:Range(cRange):Value = prh_site .
                cRange = "B" + cColumn.
                chWorkSheet:Range(cRange):Value = prh_vend .
                cRange = "C" + cColumn.
                chWorkSheet:Range(cRange):Value = prh_receiver .
                cRange = "D" + cColumn.
                chWorkSheet:Range(cRange):Value = prh_nbr .
                cRange = "E" + cColumn.
                chWorkSheet:Range(cRange):Value = prh_line .
                cRange = "F" + cColumn.
                chWorkSheet:Range(cRange):Value = prh_part .
                cRange = "G" + cColumn.
                chWorkSheet:Range(cRange):Value = prh_rcp_date .
                cRange = "H" + cColumn.
                chWorkSheet:Range(cRange):Value = prh_rcvd .
                cRange = "I" + cColumn.
                chWorkSheet:Range(cRange):Value = prh_pur_cost .
                cRange = "J" + cColumn.
                chWorkSheet:Range(cRange):Value = prh_pur_cost * prh_rcvd .
                cRange = "K" + cColumn.
                chWorkSheet:Range(cRange):Value = xxwk1_nbr .
            END.
        END.
        
        chWorkbook:saveas(foutputfile , , , , , , 1) . 
        chExcelApplication1:Visible = TRUE.
        
        RELEASE OBJECT chExcelApplication1. 
        RELEASE OBJECT chWorkbook.
        RELEASE OBJECT chWorksheet.
    END . /*SecondLoop end*/

END.  /* mainloop end */







	    

