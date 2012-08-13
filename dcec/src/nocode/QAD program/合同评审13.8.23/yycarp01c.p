/*zzcarp01c.p for 合同评审报表计算												*/

/*LAST MODIFIED BY *LB01*             LONG BO   2004-7-14                            
  LAST MODIFIED BY *phi*             Philips Li 2008-4-11
------------------------------------------------------------------------------------*/
	 {mfdeclre.i}

	def  shared var y# as integer.
	def  shared  var m# as integer.
	def  shared  var nbr as char.

	/*lb01*/
	def shared var effdate as date label "月度计划发布日期".
	def shared var mstart as date label "月度范围".		/*月度开始日期 */
	def shared var mend as date.		/*月度结束日期 */
	/*lb01*/

	def var iRow as integer.
	def var iCol as integer.

	define variable record as integer extent 100.
	define variable comp like ps_comp.
	define variable level as integer.
	define variable maxlevel as integer format ">>>" label "层次".
	
	define var site like si_site.
	def var dfrom as date.
	def var dend   as date.
	def var rsid as char.
	def var totlines as integer.
	
	def var item1 as char format "x(16)".
	def var item2 as char.
	
form    
	item1 no-label
	item2 no-label
with frame d down.


def workfile xxwk						/***********************************************************************/
	field xxpart 	like pt_part  	    /*	  零件号：采购件零件号码	                                           */
	field xxdesc1	like pt_desc1       /*	描述：零件描述                                                     */
	field xxqtyoh	like in_qty_oh	    /*	  库存量：当前库存量                                                 */
	field xxum		 like pt_um         /*	UM                                                                 */
	field xxstatus  like pt_status      /*	状态                                                               */
	field xxpm		like pt_pm_code     /*	采/制                                                              */
	field xxprod like pt_prod_line      /*	类                                                                 */
    field xxcumld like pt_cum_lead      /*	  提前期                                                             */
    field xxcumrcv like in_qty_oh       /*	累计收货量：月度期间的收货量                                       */
    field xxqty like in_qty_oh          /*	日程确认量：报表当天日程确认量，一般确认当天，第二天到货           */
    field xxqtymrp like in_qty_oh       /*	MRP计划量：报表第二天到月底MRP计划到货量	                       */
    field xxqtyplan like in_qty_oh      /*	月度采购计划：                                                     */
    field xxqtytest like in_qty_oh      /*	  合同评审量：根据输入的SO确定的采购量                               */
    field xxqtyvar like in_qty_oh       /*	实际计划差异量 = 月度采购计划 - 收货量 - 日程确认量 - MRP计划量    */
    field xxqtysft like in_qty_oh       /*	  安全库存 安全量 计划员 供应商：1.4.17中维护的数据				   */
    field xxqtyrop like in_qty_oh       /***********************************************************************/
    field xxplaner like pt_buyer
    field xxvend   like pt_vend
    field xxmsg		as char
/*phi*/ FIELD xxpar AS CHAR FORMAT "x(200)".
    .
    

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

	/*地点*/ 
	find first usrw_wkfl no-lock where usrw_key1 = nbr and usrw_key2 = "ORDER-TEST-MSTR"
	and usrw_key3 = "ORDER-TEST-MSTR" no-error.
	site = "DCEC-C".
	if available usrw_wkfl then
		if usrw_key4 = "B" then site = "DCEC-B".

/*
	dfrom = date(m#,1,y#).
	if m# = 12 then 
		dend = date(1,1,y# + 1).	
	else
		dend = date(m# + 1,1,y#).	
	
	rsid = "m" + substring(string(y#),3,2) + substring(string(m# + 100),2,2).

*/	

	/*展开BOM，计算需要那些零件*/
	display "展开BOM,请等待" @ item1 "..." @ item2 with frame d.

	{yycarpbom.i}

	totlines = 0.
	clear all no-pause.
	
	for each xxwk:
		totlines = totlines + 1.
		
		display "计算零件" @ item1 xxpart @ item2 with frame d.
		if (totlines mod 10) = 0 then
			clear frame d all no-pause.
		down 1 with frame d.
			
		/*库存量 */
		find first in_mstr no-lock where in_part = xxpart 
		and in_site = site no-error.
		if available in_mstr then do:
			xxqtyoh = in_qty_oh - in_qty_all.
		end.
		
		/*采/制 提前期 安全量 安全库存 计划员 供应商*/
		find first ptp_det no-lock where
		ptp_part = xxpart and ptp_site = site no-error.
		if available ptp_det then do:
			assign
			xxpm		= ptp_pm_code
			xxcumld 	= ptp_cum_lead
			xxqtysft   	= ptp_sfty_stk
			xxqtyrop   	= ptp_rop
			xxplaner   	= ptp_buyer
			xxvend     	= ptp_vend.
		end.
		
		find first pt_mstr no-lock where
		pt_part = xxpart no-error.
		if available pt_mstr then do:
			assign
			xxprod   	= pt_prod_line
			xxdesc1		= pt_desc2
			xxum		= pt_um
			xxstatus   	= pt_status.
		end.
	
		/*收货量*/
		for each prh_hist no-lock where
		prh_rcp_date >= mstart and prh_rcp_date <= today
		and prh_part = xxpart
		and prh_site = site:
			xxcumrcv = xxcumrcv + prh_rcvd.
		end.
		
		/*日程量*/
		for each pod_det no-lock
		where pod_part = xxpart,
		each schd_det no-lock
		where schd_type = 4
		and schd_nbr = pod_nbr and schd_line = pod_line
		and schd_rlse_id = pod_curr_rlse_id[1]
		and schd_date = today:
			xxqty = xxqty + schd_upd_qty.
		end.	

		/*MRP量*/
		for each mrp_det no-lock where
		mrp_site = site and mrp_part = xxpart 
		and mrp_due_date >= today and mrp_due_date <= mend
		and index(mrp_type,"demand") > 0:
			xxqtymrp = xxqtymrp + mrp_qty.
		end.			

		/*月度计划*/
		xxmsg = "警告：未找到月度计划".
		for each pod_det no-lock
		where pod_part = xxpart
		and pod_site = site,
		
		last /*each*/ sch_mstr no-lock
		where sch_cr_date = effdate
		and sch_type = 4
		and sch_nbr = pod_nbr and sch_line = pod_line
		use-index sch_cr_date,
		
		each schd_det no-lock
		where schd_type = 4
		and schd_nbr = pod_nbr and schd_line = pod_line
		and schd_rlse_id = sch_rlse_id /*rsid*/
		and schd_date >= mstart and schd_date < mend:
			xxqtyplan = xxqtyplan + schd_discr_qty /*schd_upd_qty*/ .
			xxmsg = "".
		end.	
	
		/*差异 = 月度采购计划 - 收货量 - 日程确认量 - MRP计划量 */
		xxqtyvar = xxqtyplan - xxcumrcv - xxqty - xxqtymrp.

	end.

	/* Create a New chExcel Application object */
	CREATE "Excel.Application" chExcelApplication.
    
    chExcelWorkbook = chExcelApplication:Workbooks:ADD.
    
    /*ADD DATA INTO EXCEL FILE */
	chExcelWorkbook:Worksheets(1):Cells(1,1) = "合同评审报表".
	
	iRow = 3.
	chExcelWorkbook:Worksheets(1):Cells(iRow,1) = "零件号".
	chExcelWorkbook:Worksheets(1):Cells(iRow,2) = "零件描述".
	chExcelWorkbook:Worksheets(1):Cells(iRow,3) = "数量".

	for each usrw_wkfl no-lock where
	usrw_key1 = nbr and usrw_key3 = "ORDER-TEST-DET":
		iRow = iRow + 1.
		chExcelWorkbook:Worksheets(1):Cells(iRow,1) = usrw_key2.
		find pt_mstr no-lock where pt_part = usrw_key2 no-error.
		chExcelWorkbook:Worksheets(1):Cells(iRow,2) = if available pt_mstr then pt_desc1 else "".
		chExcelWorkbook:Worksheets(1):Cells(iRow,3) = usrw_decfld[1].
    end.
	/*--*/


	iRow = iRow + 2.
	iCol = 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "零件号". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "描述". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "库存量". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "UM". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "状态". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "采/制". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "类  ". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "提前期". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "累计收货量". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "日程确认量". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "MRP计划量". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "月度采购计划". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "合同评审量". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "实际计划差异量". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "安全库存	". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "安全量". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "计划员 ". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "供应商". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "备注". 		iCol = iCol + 1.
/*phi*/   chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "所用机型". 		iCol = iCol + 1.
	totlines = totlines + iRow.
	
	for each xxwk:
		message "写入EXCEL, 剩余 " + string(totlines - iRow).
		iRow = iRow + 1.
		iCol = 1.

		chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "'" + xxpart 	.		iCol = iCol + 1.											
		chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = xxdesc1	.		iCol = iCol + 1.											
		chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = xxqtyoh	.		iCol = iCol + 1.											
		chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = xxum		.		iCol = iCol + 1.											
		chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = xxstatus   .		iCol = iCol + 1.											
		chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = xxpm		.		iCol = iCol + 1.											
		chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = xxprod   	.		iCol = iCol + 1.										
		chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = xxcumld 	.		iCol = iCol + 1.									
		chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = xxcumrcv   .   	iCol = iCol + 1.    
		chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = xxqty      .   	iCol = iCol + 1.    
		chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = xxqtymrp   .   	iCol = iCol + 1.    
		chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = xxqtyplan  .   	iCol = iCol + 1.    
		chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = xxqtytest  .   	iCol = iCol + 1.    
		chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = xxqtyvar   .   	iCol = iCol + 1.    
		chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = xxqtysft   .   	iCol = iCol + 1.    
		chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = xxqtyrop   .   	iCol = iCol + 1.    
		chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = xxplaner   .   	iCol = iCol + 1.    
		chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = xxvend     .   	iCol = iCol + 1. 
		chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = xxmsg	    .   	iCol = iCol + 1. 
/*phi*/        chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = xxpar	    .   	iCol = iCol + 1. 
	end.
	
	hide message no-pause.
		
	chExcelApplication:Visible = True.

	/* release com - handles */
	RELEASE OBJECT chExcelWorkbook.
	/*release object chexcelworkbooktemp .*/
	RELEASE OBJECT chExcelApplication.

