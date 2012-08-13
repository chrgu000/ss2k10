/*zzcarp01c.p for ��ͬ���󱨱����												*/

/*LAST MODIFIED BY *LB01*             LONG BO   2004-7-14                            
  LAST MODIFIED BY *phi*             Philips Li 2008-4-11
------------------------------------------------------------------------------------*/
	 {mfdeclre.i}

	def  shared var y# as integer.
	def  shared  var m# as integer.
	def  shared  var nbr as char.

	/*lb01*/
	def shared var effdate as date label "�¶ȼƻ���������".
	def shared var mstart as date label "�¶ȷ�Χ".		/*�¶ȿ�ʼ���� */
	def shared var mend as date.		/*�¶Ƚ������� */
	/*lb01*/

	def var iRow as integer.
	def var iCol as integer.

	define variable record as integer extent 100.
	define variable comp like ps_comp.
	define variable level as integer.
	define variable maxlevel as integer format ">>>" label "���".
	
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
	field xxpart 	like pt_part  	    /*	  ����ţ��ɹ����������	                                           */
	field xxdesc1	like pt_desc1       /*	�������������                                                     */
	field xxqtyoh	like in_qty_oh	    /*	  ���������ǰ�����                                                 */
	field xxum		 like pt_um         /*	UM                                                                 */
	field xxstatus  like pt_status      /*	״̬                                                               */
	field xxpm		like pt_pm_code     /*	��/��                                                              */
	field xxprod like pt_prod_line      /*	��                                                                 */
    field xxcumld like pt_cum_lead      /*	  ��ǰ��                                                             */
    field xxcumrcv like in_qty_oh       /*	�ۼ��ջ������¶��ڼ���ջ���                                       */
    field xxqty like in_qty_oh          /*	�ճ�ȷ�������������ճ�ȷ������һ��ȷ�ϵ��죬�ڶ��쵽��           */
    field xxqtymrp like in_qty_oh       /*	MRP�ƻ���������ڶ��쵽�µ�MRP�ƻ�������	                       */
    field xxqtyplan like in_qty_oh      /*	�¶Ȳɹ��ƻ���                                                     */
    field xxqtytest like in_qty_oh      /*	  ��ͬ�����������������SOȷ���Ĳɹ���                               */
    field xxqtyvar like in_qty_oh       /*	ʵ�ʼƻ������� = �¶Ȳɹ��ƻ� - �ջ��� - �ճ�ȷ���� - MRP�ƻ���    */
    field xxqtysft like in_qty_oh       /*	  ��ȫ��� ��ȫ�� �ƻ�Ա ��Ӧ�̣�1.4.17��ά��������				   */
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

	/*�ص�*/ 
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

	/*չ��BOM��������Ҫ��Щ���*/
	display "չ��BOM,��ȴ�" @ item1 "..." @ item2 with frame d.

	{yycarpbom.i}

	totlines = 0.
	clear all no-pause.
	
	for each xxwk:
		totlines = totlines + 1.
		
		display "�������" @ item1 xxpart @ item2 with frame d.
		if (totlines mod 10) = 0 then
			clear frame d all no-pause.
		down 1 with frame d.
			
		/*����� */
		find first in_mstr no-lock where in_part = xxpart 
		and in_site = site no-error.
		if available in_mstr then do:
			xxqtyoh = in_qty_oh - in_qty_all.
		end.
		
		/*��/�� ��ǰ�� ��ȫ�� ��ȫ��� �ƻ�Ա ��Ӧ��*/
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
	
		/*�ջ���*/
		for each prh_hist no-lock where
		prh_rcp_date >= mstart and prh_rcp_date <= today
		and prh_part = xxpart
		and prh_site = site:
			xxcumrcv = xxcumrcv + prh_rcvd.
		end.
		
		/*�ճ���*/
		for each pod_det no-lock
		where pod_part = xxpart,
		each schd_det no-lock
		where schd_type = 4
		and schd_nbr = pod_nbr and schd_line = pod_line
		and schd_rlse_id = pod_curr_rlse_id[1]
		and schd_date = today:
			xxqty = xxqty + schd_upd_qty.
		end.	

		/*MRP��*/
		for each mrp_det no-lock where
		mrp_site = site and mrp_part = xxpart 
		and mrp_due_date >= today and mrp_due_date <= mend
		and index(mrp_type,"demand") > 0:
			xxqtymrp = xxqtymrp + mrp_qty.
		end.			

		/*�¶ȼƻ�*/
		xxmsg = "���棺δ�ҵ��¶ȼƻ�".
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
	
		/*���� = �¶Ȳɹ��ƻ� - �ջ��� - �ճ�ȷ���� - MRP�ƻ��� */
		xxqtyvar = xxqtyplan - xxcumrcv - xxqty - xxqtymrp.

	end.

	/* Create a New chExcel Application object */
	CREATE "Excel.Application" chExcelApplication.
    
    chExcelWorkbook = chExcelApplication:Workbooks:ADD.
    
    /*ADD DATA INTO EXCEL FILE */
	chExcelWorkbook:Worksheets(1):Cells(1,1) = "��ͬ���󱨱�".
	
	iRow = 3.
	chExcelWorkbook:Worksheets(1):Cells(iRow,1) = "�����".
	chExcelWorkbook:Worksheets(1):Cells(iRow,2) = "�������".
	chExcelWorkbook:Worksheets(1):Cells(iRow,3) = "����".

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
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "�����". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "����". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "�����". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "UM". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "״̬". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "��/��". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "��  ". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "��ǰ��". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "�ۼ��ջ���". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "�ճ�ȷ����". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "MRP�ƻ���". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "�¶Ȳɹ��ƻ�". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "��ͬ������". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "ʵ�ʼƻ�������". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "��ȫ���	". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "��ȫ��". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "�ƻ�Ա ". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "��Ӧ��". 		iCol = iCol + 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "��ע". 		iCol = iCol + 1.
/*phi*/   chExcelWorkbook:Worksheets(1):Cells(iRow,iCol) = "���û���". 		iCol = iCol + 1.
	totlines = totlines + iRow.
	
	for each xxwk:
		message "д��EXCEL, ʣ�� " + string(totlines - iRow).
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

