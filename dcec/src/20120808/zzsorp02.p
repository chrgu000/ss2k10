/*zzsorp02.p 销售统计报表   								*/
/* 8.5 F03 LAST MODIFIED BY LONG BO 2004/07/07				*/

/*GN61*/ {mfdtitle.i "d+ "}

def var nbr			like so_nbr.
def var nbr1		like so_nbr.
def var region 		like cm_region.
def var region1 	like cm_region.
def var cust		like cm_addr.
def var cust1		like cm_addr.
def var slspsn		like cm_slspsn[1].
def var slspsn1		like cm_slspsn[1].
def var cumdate		like sod_cum_date[1].
def var cumdate1	like sod_cum_date[1].
def var part		like pt_part.
def var part1		like pt_part.
def var prodline	like pt_prod_line.
def var prodline1 	like pt_prod_line.
def	var opt			as 	integer format "9".
def var soissed		as logical.
def var site		like si_site initial "DCEC-SV".
def var site1 		like si_site initial "DCEC-SV".

def var amt			as decimal label "合计" format ">>>>,>>>,>>9.99".
def var allamt 		as decimal.  

def var itemcode	as char format "x(18)".
def var itemdesc	as char format "x(24)".
def var subamt		as decimal label "总价" format ">>>>,>>>,>>9.99".
def var subqty		as decimal.



def temp-table zzwkso
	field sonbr		like so_nbr
	field sopart	like sod_part
	field invqty	like idh_qty_inv
	field soprice	like idh_price
	field soregion	like cm_region
	field socust	like so_cust
	field ptline	like pt_prod_line
	field soslspsn	like so_slspsn[1].




FORM /*GUI*/

	RECT-FRAME       AT ROW 1.4 COLUMN 1.25
	RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
	SKIP(.1)  /*GUI*/
		nbr 		colon 20 label "订单"
		nbr1		colon 50 label {t001.i}
		region 		colon 20 label "区域"
		region1 	colon 50 label {t001.i}
		cust		colon 20 label "客户"
		cust1		colon 50 label {t001.i}
		slspsn		colon 20 label "销售员"
		slspsn1		colon 50 label {t001.i}
		cumdate		colon 20 label "发货日期"
		cumdate1 	colon 50 label {t001.i}
		part		colon 20 label "零件"
		part1		colon 50 label {t001.i}
		prodline	colon 20 label "产品类"
		prodline1	colon 50 label {t001.i}
		site		colon 20 label "地点"
		site1		colon 50 label {t001.i}
		opt			colon 20 label "统计选项"
				"1-区域         " colon 30
				"2-销售员       " colon 30
				"3-零件类别+库位" colon 30		
				"4-客户零件数	" colon 30		
				"5-客户销售额	" colon 30		
				"6-零件号		" colon 30	
				"7-零件价值排序 " colon 30    

	SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space THREE-D /*GUI*/.

/* 
form    
	"-----------------------" colon 87
	amt colon 100
with frame st side-labels down width 200 no-box.
 
form    
	itemcode 	label "区域代码"
	itemdesc 	label "区域描述"
	idh_part	label "零件号"
	pt_desc1	label "说明"
	idh_qty_inv label "数量"
	subamt
with frame d1 down width 200 no-box.

form    
	itemcode 	label "销售员代码"
	itemdesc 	label "销售员"
	idh_part	label "零件号"
	pt_desc1	label "说明"
	idh_qty_inv label "数量"
	subamt
	
with frame d2 down width 200 no-box.

form    
	itemcode 	label "产品类"
	itemdesc 	label "描述"
	idh_part	label "零件号"
	pt_desc1	label "说明"
	idh_qty_inv label "数量"
	subamt
	
with frame d3 down width 200 no-box.

form    
	idh_part	label "零件号"
	pt_desc1	label "说明"
	itemcode 	label "客户"
	itemdesc 	label "客户名"
	idh_qty_inv label "数量"
	subamt
	
with frame d4 down width 200 no-box.

form    
	itemcode 	label "客户"
	itemdesc 	label "客户名"
	subamt
	
with frame d5 down width 200 no-box.

form    
	idh_part	label "零件号"
	pt_desc1	label "说明"
	idh_qty_inv label "数量"
	subamt
	
with frame d6 down width 200 no-box.

form    
	idh_part	label "零件号"
	pt_desc1	label "说明"
	idh_qty_inv label "数量"
	subamt
	
with frame d7 down width 200 no-box.
*/

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

	repeat:

		if nbr1 		= hi_char 	then nbr1	 	= "".
		if region1 		= hi_char 	then region1 	= "".
		if cust1 		= hi_char 	then cust1 		= "".
		if cumdate 		= low_date	then cumdate 	= ?.
		if cumdate1 	= hi_date 	then cumdate1 	= ?.
		if part1 		= hi_char 	then part1 		= "".
		if slspsn1 		= hi_char 	then slspsn1 	= "".
		if prodline1	= hi_char 	then prodline1	= "".
		if site1		= hi_char 	then site1		= "".

		update 
			nbr
			nbr1
			region 	
			region1 
			cust	
			cust1	
			slspsn
			slspsn1	
			cumdate	
			cumdate1
			part	
			part1	
			prodline
			prodline1
			site
			site1
		with frame a.

        {mfquoter.i  nbr	 	 }
        {mfquoter.i  nbr1	 	 }
        {mfquoter.i  region 	 }
        {mfquoter.i  region1     }
        {mfquoter.i  cust	     }
        {mfquoter.i  cust1	     }
        {mfquoter.i  slspsn	     }
        {mfquoter.i  slspsn	     }
        {mfquoter.i  cumdate	 }
        {mfquoter.i  cumdate1    }
        {mfquoter.i  part	     }
        {mfquoter.i  part1	     }
        {mfquoter.i  prodline    }
        {mfquoter.i  prodline1   }
        {mfquoter.i  site    }
        {mfquoter.i  site1   }
	
		if nbr1		= ""			then nbr1			= hi_char	.
		if region1 	= ""    		then region1 	    = hi_char 	.
		if cust1 	= ""   			then cust1 		    = hi_char   . 
		if cumdate 	= ?     		then cumdate 	    = low_date	.
		if cumdate1 = ?      		then cumdate1 	    = hi_date 	.
		if part1 	= ""    		then part1 		    = hi_char 	.
		if slspsn1 	= ""    		then slspsn1	    = hi_char 	.
		if prodline1= ""    		then prodline1	    = hi_char 	.
		if site1	= ""			then site1			= hi_char	.

		find first code_mstr where code_fldname = "xx-sorpt-ctrl"
		and code_value = global_userid exclusive-lock no-error.
		if not available code_mstr then do:
			create code_mstr.
			assign
				code_fldname = "xx-sorpt-ctrl"
				code_value   = global_userid
				code_cmmt	 = "1".
		end.
		if length(code_cmmt) <> 1 or code_cmmt < "1" or code_cmmt > "7" then
			code_cmmt = "1".
		opt = integer(code_cmmt).
		
	/*	message "开始计算，并写入EXCEL表格中，请等待..." view-as alert-box.*/
	
		update opt with frame a.
        {mfquoter.i  opt 	 }
		code_cmmt = string(opt).
		if opt < 1 or opt > 7 then do:
			message "选项错误" view-as alert-box.
			next-prompt opt with frame a.
			undo, retry.
		end.
		release code_mstr.
		
/*		{mfselprt.i "printer" 132}
	    {mfphead.i}  */
 		message "开始计算，并写入EXCEL表格中" view-as alert-box. 
		
		
		/*get so data*/
		{zzsorp02.i}
		
		
		/* Create a New chExcel Application object */
		CREATE "Excel.Application" chExcelApplication.
	    
	    chExcelWorkbook = chExcelApplication:Workbooks:ADD.
	    
	    /*ADD DATA INTO EXCEL FILE */
		chExcelWorkbook:Worksheets(1):Cells(1,1) = "销售统计报表".
		
		case opt:
			when 1 then {zzsorp0201.i}
			when 2 then {zzsorp0202.i}
			when 3 then {zzsorp0203.i}
			when 4 then {zzsorp0204.i}
			when 5 then {zzsorp0205.i}
			when 6 then {zzsorp0206.i}
	 		when 7 then {zzsorp0207.i} 
		end case.	
		
		hide message no-pause.		

		chExcelApplication:Visible = True.
		
		/* release com - handles */
		RELEASE OBJECT chExcelWorkbook.
		/*release object chexcelworkbooktemp .*/
		RELEASE OBJECT chExcelApplication.
		
/*		
		{mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
*/

	end. /*repeat*/
