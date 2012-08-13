/*zzporcp02.p for 供应商厂家供货情况报表										*/

/*LAST MODIFIED BY *frk*              Frank Sun 2008-4-02                           

------------------------------------------------------------------------------------*/

         /* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*GI32*/ {mfdtitle.i "F"}

def var vend like vd_addr.
def var vend1 like vd_addr.
def var part like pt_part.
def var part1 like pt_part.

def var yfrom as integer.
def var mfrom as integer.
def var yend as integer.
def var mend as integer.
def var dfrom as date.
def var dend as date.
def var tmpqty as decimal.

def var ytmp as integer.
def var mtmp as integer.
DEF VAR yetmp AS INTEGER.
DEF VAR metmp AS INTEGER.

def var iRow as integer.
def var iCol as integer.

def workfile xxwk
	field xxpart 	like pt_part
	field xxvend 	like vd_addr
	field xxpo		like po_nbr
	field xxqtyplan as integer
	field xxqtyrcv  as integer
	field xxmsg		as CHAR
	field xxfrom as date
	field xxto as date
	field xxmonth	as char
	.

def buffer tmpwk for xxwk.
def var totqtyplan like xxqtyplan.
def var totqtyrcv	like xxqtyrcv.

def workfile zzwk
	field zzrsid as char
	field zzcrdate as DATE
	field zzfrom as date
	field zzto as date
    field zzmonth as CHAR.


/* define Excel object handle */
DEFINE NEW SHARED VARIABLE chExcelApplication AS COM-HANDLE.
/*DEFINE VARIABLE chExcelWorksheet AS COM-HANDLE.*/
DEFINE NEW SHARED VARIABLE chExcelWorkbook AS COM-HANDLE.
/*Define Sheet Variavble*/
DEFINE VARIABLE iLine AS INTEGER.
DEFINE VARIABLE iTotalLine AS INTEGER.
DEFINE VARIABLE iHeaderLine AS INTEGER.
DEFINE VARIABLE iHeaderStartLine AS INTEGER.
DEFINE VARIABLE iMAXPageLine AS INTEGER.
DEFINE VARIABLE iFooterLine AS INTEGER.
DEFINE VARIABLE iPageNum AS INTEGER.
DEFINE VARIABLE iLoop1 AS INTEGER.


form
   RECT-FRAME       AT ROW 1 COLUMN 1.25
   RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
   SKIP(1)  /*GUI*/
   	vend colon 22   label "供应商"     vend1 colon 45 label "至"
   	/*part colon 22   label "零件"     part1 colon 45 label "至"*/ skip(1)
	yfrom colon 22 label "统计月份" format "9999" "年"
	mfrom   no-label format "99" "月"
	yend  colon 45 label {t001.i} format "9999" "年"
	mend    no-label format "99" "月"
   skip (1)
   with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

   DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
   RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
   RECT-FRAME-LABEL:HIDDEN in frame a = yes.
   RECT-FRAME:HEIGHT-PIXELS in frame a =
   FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
   RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

repeat:
    
    hide message no-pause.
    
	if yfrom = 0 then yfrom = year(TODAY).
	if mfrom = 0 then mfrom = 1. /*month(today - 30).*/
	if yend = 0 then yend = year(TODAY).
	if mend = 0 then mend = month(today - 30).
	if vend1 = hi_char then vend1 = "".
	if part1 = hi_char then part1 = "".	
	
	view frame a.	
		    
    update vend vend1 /*part part1*/ with frame a.
    
    {mfquoter.i  vend	 	 }
    {mfquoter.i  vend1	 	 }
    /*{mfquoter.i  part	 	 }
    {mfquoter.i  part1	 	 }*/


    if vend1 = "" then vend1 = hi_char.
    if part1 = "" then part1 = hi_char.
    
	sets:
	do on error undo, retry:
if global-beam-me-up then undo, leave.
    
    	update yfrom mfrom yend mend with frame a.
		
	    {mfquoter.i  yfrom	 	 }
	    {mfquoter.i  mfrom	 	 }
	    {mfquoter.i  yend	 	 }
	    {mfquoter.i  mend	 	 }

		if yfrom < 1990 or yfrom > 3000 then do:
			message "错误的年度范围，请重新输入" view-as alert-box.
			next-prompt yfrom with frame a.
			undo, retry sets.
		end.
			   	
		if mfrom < 1 or mfrom > 12 then do:
			message "错误的月份范围，请重新输入" view-as alert-box.
			next-prompt mfrom with frame a.
			undo, retry sets.
		end.

		if yend < 1990 or yend > 3000 then do:
			message "错误的年度范围，请重新输入" view-as alert-box.
			next-prompt yend with frame a.
			undo, retry sets.
		end.
			   	
		if mend < 1 or mend > 12 then do:
			message "错误的月份范围，请重新输入" view-as alert-box.
			next-prompt mend with frame a.
			undo, retry sets.
		end.
		
		if yfrom * 12 + mfrom > yend * 12 + mend then do:
			message "时间范围错误，请重新输入" view-as alert-box.
			undo,retry sets.
		end.
		
	end. /*end sets */
	
	
	display yfrom yend mfrom mend with frame a.

/*
	dfrom = date(mfrom,1,yfrom).
	if mend = 12 then 
		dend = date(1,1,yend + 1).	
	else
		dend = date(mend + 1,1,yend).	
*/
	
	dfrom = date(mfrom,1,yfrom) - 1. /*上月最后一天*/
	dfrom = dfrom + 28 - day(dfrom).  /*上月28*/  /*DCEC*/
	
	dend = date(mend,1,yend).  /*本月1号*/
	dend = dend + 26.    /*本月27*/

	
	/*calculate*/
	for each xxwk:
		delete xxwk.
	end.
	
	/*create */
	for each zzwk:
		delete zzwk.
	end.
	
	ytmp = yfrom.
	mtmp = mfrom.
    yetmp = yend.
    metmp = mend.
	repeat:
		create zzwk.
        zzfrom = date(mtmp,1,ytmp).
        IF mtmp = 2 THEN zzto = date(mtmp,28 ,ytmp).
/*frk*/	if year(zzfrom) / 4 = int(year(zzfrom) / 4) then zzto = date(mtmp,29,ytmp).
        IF mtmp = 1 OR mtmp =3 OR mtmp =5 OR mtmp =7 OR mtmp =8 OR mtmp =10 OR mtmp =12 THEN zzto = date(mtmp,31 ,ytmp).
        IF mtmp = 4 OR mtmp = 6 OR mtmp = 9 OR mtmp =11 THEN zzto = date(mtmp,30 ,ytmp).
        
        zzcrdate = zzfrom.
        zzmonth = string(year(zzto)) + "." + string(month(zzto),"99").
        mtmp = mtmp + 1.

        IF mtmp = 13 THEN DO:
           ytmp = ytmp + 1.
           mtmp = 1.
        END.    

	    IF DATE(mtmp,1,ytmp) > date(mend,1,yend) then leave.
	end.

    FOR EACH zzwk:
        FOR EACH vd_mstr NO-LOCK WHERE vd_addr >= vend AND vd_addr <= vend1:
           CREATE xxwk.
           ASSIGN
           xxvend = vd_addr
           xxfrom = zzfrom
           xxto    = zzto
           xxmonth = zzmonth.
        END.
    END.

	for each xxwk:
		/*收货量*/
    tmpqty = 0.
    for each prh_hist no-lock where
		prh_rcp_date >= xxfrom and prh_rcp_date <= xxto
		/*and prh_part >= part and prh_part <= part1*/
		and prh_vend = xxvend /* >= vend and prh_vend <= vend1*
		break by prh_vend *by prh_part*/ :
		   /* if first-of(prh_vend) /*or first-of(prh_vend)*/ then do:
				tmpqty = 0.
			end. */
			
			tmpqty = tmpqty + prh_rcvd.
	
			/*if last-of(prh_vend) /*or last-of(prh_vend)*/ then do:
                /*FIND FIRST xxwk WHERE xxvend = prh_vend NO-ERROR NO-WAIT.
                IF NOT AVAIL xxwk THEN DO:
                
				create xxwk.
				assign
				 	/*xxpart 		= prh_part*/
					xxvend 		= prh_vend
					/*xxpo		= prh_nbr*/
					xxqtyrcv  	= tmpqty
					xxmonth		= zzmonth. /*string(year(zzto)) + "." + string(month(zzto)).*/
                END.
                ELSE DO: */
                    xxqtyrcv   = tmpqty.
             end.*/
		end.
        xxqtyrcv = tmpqty.
	end.	
	
    
    OUTPUT TO "c:\xxxxx.txt".
    FOR EACH zzwk:
        DISP zzrsid zzcrdate SPACE(6) zzfrom SPACE(6) zzto space(6) zzmonth.
    END.
    FOR EACH xxwk NO-LOCK BREAK BY xxvend:
        DISP xxvend SPACE(6) xxqtyrcv SPACE(10) xxfrom SPACE(8) xxto SPACE(8) xxmonth.
    END.
    OUTPUT CLOSE.
     

    /*frk * begin to delete the section*

	/*计划量*/
	for each zzwk,
	each scx_ref where scx_part >= part and scx_part <= part1 and scx_type = 2 
	no-lock,
	each po_mstr where po_nbr = scx_po and po_vend >= vend and po_vend <= vend1
	:

		find last sch_mstr where sch_type = 4
		and sch_cr_date = zzwk.zzcrdate
		and sch_nbr = scx_order
		and sch_line = scx_line
		 use-index sch_cr_date no-lock no-error.
		
		find first xxwk where xxpart = scx_part and xxpo = scx_order 
		and xxmonth = (string(year(zzto)) + "." + string(month(zzto))) no-error.
		if not available xxwk then do:
			create xxwk.
			assign
				xxpart  = scx_part
				xxpo 	= scx_order.
		/*	find po_mstr where po_nbr = xxpo no-error.
			if available po_mstr then */
				xxvend = po_vend.
				xxmonth = string(year(zzto)) + "." + string(month(zzto)).
		end.
	
		if not available sch_mstr then do:
			xxmsg = "月度计划不存在". /*月度计划不存在*/
			next.
		end.

        for each schd_det no-lock
        where schd_type = sch_type
        and schd_nbr = sch_nbr
        and schd_line = sch_line
        and schd_rlse_id = sch_rlse_id
        and schd_date >= zzfrom and schd_date <= zzto : /*
        and schd__chr02 = "p" and schd_fc_qual = "f": */
 			xxqtyplan = xxqtyplan + schd_discr_qty.
		end.
	end.
	
    *frk * end to delete the section*/
	
	/* Create a New chExcel Application object */
	CREATE "Excel.Application" chExcelApplication.
    
    chExcelWorkbook = chExcelApplication:Workbooks:ADD.
    
    /*ADD DATA INTO EXCEL FILE */
	chExcelWorkbook:Worksheets(1):Cells(1,1) = "供应商厂家供货情况报表".
	
	/*frk chExcelWorkbook:Worksheets(1):Cells(3,1) = "供应商".
	chExcelWorkbook:Worksheets(1):Cells(3,2) = vend.
	chExcelWorkbook:Worksheets(1):Cells(3,3) = vend1.
	frk* chExcelWorkbook:Worksheets(1):Cells(4,1) = "零  件".
	chExcelWorkbook:Worksheets(1):Cells(4,2) = part.
	chExcelWorkbook:Worksheets(1):Cells(4,3) = part1.*/

	chExcelWorkbook:Worksheets(1):Cells(3,1) = "统计月份".
	chExcelWorkbook:Worksheets(1):Cells(3,2) = string(yfrom) + "/" + string(mfrom).
	chExcelWorkbook:Worksheets(1):Cells(3,3) = string(yend) + "/" + string(mend).
	   
	iRow = 5.
	chExcelWorkbook:Worksheets(1):Cells(iRow,1) = "序号".
	/*frk*chExcelWorkbook:Worksheets(1):Cells(iRow,2) = "零件中文描述".
	chExcelWorkbook:Worksheets(1):Cells(iRow,3) = "零件英文描述".
	chExcelWorkbook:Worksheets(1):Cells(iRow,4) = "日程单". */
	chExcelWorkbook:Worksheets(1):Cells(iRow,2) = "供应商".
	chExcelWorkbook:Worksheets(1):Cells(iRow,3) = "供应商名".

	iCol = 4.
	for each zzwk:
		/*frk*chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "计划数". */
/*		chExcelWorkbook:Worksheets(1):Range(Cells(iRow - 1, iCol), Cells(iRow - 1, iCol + 1)):Select.
		chExcelWorkbook:Worksheets(1):selection:MergeCells = -1. */
		chExcelWorkbook:Worksheets(1):Cells(iRow - 1,iCol) = string(year(zzto)) + " - " + string(month(zzto)).
		/*iCol = iCol + 1.*/
		chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "到货数".
		iCol = iCol + 1.
	end.		

/*frkchExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "计划数".*/
/*	chExcelWorkbook:Worksheets(1):Range(Cells(iRow - 1, iCol), Cells(iRow - 1, iCol + 1)):MergeCells = -1.*/
	chExcelWorkbook:Worksheets(1):Cells(iRow - 1,iCol) = "合计".
	/*iCol = iCol + 1.*/
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "到货数".
	iline = 1.
	for each xxwk /*where can-find(first tmpwk where 
		tmpwk.xxvend = xxwk.xxvend /*and tmpwk.xxpo = xxwk.xxpo*/
		and	/*(tmpwk.xxqtyplan <> 0 or*/ tmpwk.xxqtyrcv <> 0)*/
	break BY xxvend :
		if first-of(xxvend) /*or first-of(xxpo)*/ then do:
			iRow = iRow + 1.
			chExcelWorkbook:Worksheets(1):Cells(iRow,1) = iline.
			/*frk* find pt_mstr no-lock where pt_part = xxpart no-error.
			chExcelWorkbook:Worksheets(1):Cells(iRow,2) = if available pt_mstr then pt_desc2 else "".
			chExcelWorkbook:Worksheets(1):Cells(iRow,3) = if available pt_mstr then pt_desc1 else "".
			chExcelWorkbook:Worksheets(1):Cells(iRow,4) = xxpo.*/
			chExcelWorkbook:Worksheets(1):Cells(iRow,2) = xxvend.
			find first vd_mstr no-lock where vd_addr = xxvend no-error.
			chExcelWorkbook:Worksheets(1):Cells(iRow,3) = if available vd_mstr then vd_sort else "".
			iCol = 3.
			/*totqtyplan = 0.*/
			totqtyrcv = 0.
		end.
		/*frk totqtyplan = totqtyplan + xxqtyplan.*/
		totqtyrcv = totqtyrcv + xxqtyrcv.
		/*frk* iCol = iCol + 1.
		chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = xxqtyplan.*/
		iCol = iCol + 1.
		chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = xxqtyrcv.
		if last-of(xxvend) /*or last-of(xxpo)*/ then do:
			/*frk iCol = iCol + 1.
			chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = totqtyplan.*/
			iCol = iCol + 1.
            iline = iline + 1.
			chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = totqtyrcv.
		end.
			
    end.
	/*--*/
	
	chExcelApplication:Visible = True.

	/* release com - handles */
	RELEASE OBJECT chExcelWorkbook.
	/*release object chexcelworkbooktemp .*/
	RELEASE OBJECT chExcelApplication.
end.
