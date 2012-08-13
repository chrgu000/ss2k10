/*yyporcrp.p, CREATE BY Han Jia   2008-11-20          	*/
/*Supplier Schedule and Receipt contrast to excel    	*/
/*Modify: by Han Jia   2009-03-26  ECO: hj090326
  Logic: 报关员字段是1.4.16的in__qadc01而不是pt_article */

/* DISPLAY TITLE */
{mfdtitle.i "ao+"}

define variable foutputfile as char format "x(54)" INIT "D:\Sche_RC_Comp\".

/* define Excel	object handle */
DEFINE VARIABLE chExcelApplication1 AS COM-HANDLE.
DEFINE VARIABLE chWorkbook AS COM-HANDLE.
DEFINE VARIABLE chWorksheet AS COM-HANDLE.
DEFINE VARIABLE iCount AS INTEGER  .
DEFINE VARIABLE iColumn AS INTEGER .
DEFINE VARIABLE cColumn AS CHARACTER.
DEFINE VARIABLE cRange AS CHARACTER.

define variable site            like pt_site INIT "DCEC-B".
define variable site1           like pt_site INIT "DCEC-B".
define variable rdate           like prh_rcp_date INIT today .
define variable rdate1          like prh_rcp_date INIT today .
define variable vendor          like po_vend.
define variable vendor1         like po_vend.
define variable po              like po_nbr.
define variable po1             like po_nbr.
define variable part            like pt_part.
define variable part1           like pt_part.
define variable zzk             like pod__chr01 LABEL "中转库" .
define variable zzk1            like pod__chr01 .

define variable v_sh_qty        like schd_discr_qty .
define variable v_rc_qty        like prh_rcvd .
define variable v_date          AS CHAR FORMAT "x(18)" LABEL "日期范围" .
/*hj090326--*/
define variable keeping         AS CHAR .
/*--hj090326*/
FORM /*GUI*/ 
    site             colon 15
    site1            label "至" colon 49
    rdate            colon 15
    rdate1           label "至" colon 49 skip
    vendor           colon 15
    vendor1          label "至" colon 49 skip
    po               colon 15
    po1              label "至" colon 49 skip
    part             colon 15
    part1            label "至" colon 49 skip
    zzk              colon 15
    zzk1             label "至" colon 49 skip(1)
    "**** 请尽量减小选择范围,这样可以保证报表运行效率 ****"      AT 10 skip
    "**** 此报表只包含指定范围的有效采购日程与采购收货的对比,不包含历史日程和零星采购! ****"  AT 10 skip(1)
    foutputfile	     colon 15   label	"输出文件"  skip(1)    
    SKIP(.4)  /*GUI*/
    with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

setFrameLabels(frame a:handle) .

mainloop:
repeat with frame a:

    if site1 = hi_char then site1 = "".
    if vendor1 = hi_char then vendor1 = "".
    if po1 = hi_char then po1 = "".
    if part1 = hi_char then part1 = "".
    if zzk1 = hi_char then zzk1 = "".

    update  
        site    site1
        rdate   rdate1     
        vendor  vendor1   
        po      po1
        part    part1 
        zzk     zzk1
        foutputfile  with frame a.

    bcdparm = ""  .

    if site1 = "" then site1 = hi_char.
    if rdate = ? then rdate = today .
    if rdate1 = ? then rdate1 = today .
    if vendor1 = "" then vendor1 = hi_char.
    if po1 = "" then po1 = hi_char.
    if part1 = "" then part1 = hi_char.
    if zzk1 = "" then zzk1 = hi_char.

    IF rdate1 < rdate THEN DO:
        message "日期范围无效" 
            view-as alert-box ERROR.
        UNDO .
        NEXT .
    END.
    
    IF rdate1 - rdate > 1 THEN DO:
        message "日期范围过大,报表将运行较长时间,确认要运行吗?!" 
            view-as alert-box button YES-NO update yn as logic.
    	if yn <> yes then do:
    		UNDO .
            NEXT .
    	end.  
    END.
    v_date = string(rdate) + "-" + string(rdate1) .

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
    chWorkSheet:Columns("D"):ColumnWidth = 18.
    chWorkSheet:Columns("E"):ColumnWidth = 11.
    chWorkSheet:Columns("F"):ColumnWidth = 8.
    chWorkSheet:Columns("G"):ColumnWidth = 10.
    chWorkSheet:Columns("H"):ColumnWidth = 5.
    chWorkSheet:Columns("I"):ColumnWidth = 18.
    chWorkSheet:Columns("J"):ColumnWidth = 10.
    chWorkSheet:Columns("K"):ColumnWidth = 10.
    chWorkSheet:Columns("L"):ColumnWidth = 10.
    chWorkSheet:Columns("M"):ColumnWidth = 10.
    chWorkSheet:Columns("N"):ColumnWidth = 10.
    chWorkSheet:Range("A1:N1"):Font:Bold = TRUE.
    chWorkSheet:Range("A1"):Value = "地点".
    chWorkSheet:Range("B1"):Value = "零件号".   
    chWorkSheet:Range("C1"):Value = "零件名称". 
    chWorkSheet:Range("D1"):Value = "供应商名称". 
    chWorkSheet:Range("E1"):Value = "供应商编码".     
    chWorkSheet:Range("F1"):Value = "计划员" .
    chWorkSheet:Range("G1"):Value = "日程单号".   
    chWorkSheet:Range("H1"):Value = "行号". 
    chWorkSheet:Range("I1"):Value = "对比日期段".    
    chWorkSheet:Range("J1"):Value = "日程单数量".    
    chWorkSheet:Range("K1"):Value = "收货数量".  
    chWorkSheet:Range("L1"):Value = "差额".          
    chWorkSheet:Range("M1"):Value = "保管员".        
    chWorkSheet:Range("N1"):Value = "中转库".        

    FOR EACH scx_ref NO-LOCK WHERE scx_type = 2
        AND scx_shipto >= site AND scx_shipto <= site1
        AND scx_shipfrom >= vendor  AND scx_shipfrom <= vendor1
        AND scx_po >= po AND scx_po <= po1
        AND scx_part >= part AND scx_part <= part1 ,
        each pod_det 
        FIELDS(pod_nbr pod_line pod__chr01 pod_curr_rlse_id[1]) no-lock
        where pod_nbr = scx_po and pod_line = scx_line
        AND pod__chr01 >= zzk AND pod__chr01 <= zzk1:
        find sch_mstr where sch_type = 4
            and sch_nbr = pod_nbr and sch_line = pod_line
            and sch_rlse_id = pod_curr_rlse_id[1] NO-LOCK NO-ERROR .
        if available sch_mstr then do:
            FOR EACH schd_det NO-LOCK WHERE schd_type = 4
                AND schd_nbr = sch_nbr AND schd_line = sch_line 
                and schd_rlse_id = sch_rlse_id
                AND schd_date >= rdate AND schd_date <= rdate1
                BREAK BY schd_nbr BY schd_line
                /*BY schd_date */ :
                ACCUMULATE schd_discr_qty (TOTAL BY schd_line) .
                IF LAST-OF(schd_line) THEN DO:
                    v_sh_qty = (ACCUM TOTAL BY schd_line schd_discr_qty) .
                    
                    FOR FIRST pt_mstr 
                        FIELDS(pt_part pt_desc1 pt_desc2 pt_article) 
                        NO-LOCK WHERE pt_part = scx_part :
                    END.
    
                    FOR FIRST ptp_det
                        FIELDS(ptp_part ptp_buyer) 
                        NO-LOCK WHERE ptp_part = scx_part 
                        AND ptp_site = scx_shipto:
                    END.
    
                    v_rc_qty = 0 .
                    FOR EACH prh_hist NO-LOCK WHERE prh_site = scx_shipto
                        AND prh_vend = scx_shipfrom AND prh_part = scx_part
                        AND prh_nbr = scx_po AND prh_line = scx_line 
                        AND prh_rcp_date >= rdate AND prh_rcp_date <= rdate1
                        BREAK BY prh_nbr BY prh_line :
                        ACCUMULATE prh_rcvd (TOTAL BY prh_line) .
                        v_rc_qty = (ACCUM TOTAL BY prh_line prh_rcvd) .
                    END.
                    
                    FOR FIRST vd_mstr FIELDS(vd_addr vd_sort)
                        NO-LOCK WHERE vd_addr = scx_shipfrom :
                    END.
/*hj090326--*/
                    FOR FIRST in_mstr FIELDS(in_site in_part in__qadc01) 
                        NO-LOCK WHERE in_site = scx_shipto AND in_part = scx_part:
                    END.
                    IF AVAIL in_mstr THEN keeping = in__qadc01 .
                    ELSE keeping = "" .
/*--hj090326*/    
                    IF v_sh_qty > 0 OR v_rc_qty > 0 THEN DO: 

                        iColumn = iColumn + 1.
                        cColumn = STRING(iColumn).
                        cRange = "A" + cColumn.
                        chWorkSheet:Range(cRange):Value = scx_shipto .
                        cRange = "B" + cColumn.
                        chWorkSheet:Range(cRange):Value = scx_part .
                        cRange = "C" + cColumn.
                        chWorkSheet:Range(cRange):Value = pt_desc2 .
                        cRange = "D" + cColumn.
                        chWorkSheet:Range(cRange):Value = vd_sort .
                        cRange = "E" + cColumn.
                        chWorkSheet:Range(cRange):Value = scx_shipfrom .
                        cRange = "F" + cColumn.
                        chWorkSheet:Range(cRange):Value = ptp_buyer .
                        cRange = "G" + cColumn.
                        chWorkSheet:Range(cRange):Value = scx_po .
                        cRange = "H" + cColumn.
                        chWorkSheet:Range(cRange):Value = schd_line .
                        cRange = "I" + cColumn.
                        chWorkSheet:Range(cRange):Value = v_date .
                        cRange = "J" + cColumn.
                        chWorkSheet:Range(cRange):Value = v_sh_qty .
                        cRange = "K" + cColumn.
                        chWorkSheet:Range(cRange):Value = v_rc_qty .
                        cRange = "L" + cColumn.
                        chWorkSheet:Range(cRange):Value = v_sh_qty - v_rc_qty .
                        cRange = "M" + cColumn.
                        chWorkSheet:Range(cRange):Value = keeping .  /*hj090326-- pt_article. --*/ 
                        cRange = "N" + cColumn.
                        chWorkSheet:Range(cRange):Value = pod__chr01 .
                    END.  /*IF v_sh_qty > 0 OR v_rc_qty > 0 end */  
                END. /*IF LAST-OF(schd_line) end */
            END. /*FOR EACH schd_det end */
        END. /*if available sch_mstr end */
    END. /*FOR EACH scx_ref end */

    chWorkbook:saveas(foutputfile , , , , , , 1) . 
    chExcelApplication1:Visible = TRUE.
    
    RELEASE OBJECT chExcelApplication1. 
    RELEASE OBJECT chWorkbook.
    RELEASE OBJECT chWorksheet.
END.
