/*yysorp01.p ���۷�������   								*/
/* 8.5 F03 LAST MODIFIED BY LONG BO 2004/07/01				*/
/*cj* 08/26/05 add customer type field*/

{mfdtitle.i "120816.1"}

def var nbr			like so_nbr.
def var nbr1		like so_nbr.
def var region 		like cm_region.
def var region1 	like cm_region.
def var cust		like cm_addr.
def var cust1		like cm_addr.
def var slspsn		like cm_slspsn[1].
def var cumdate		like sod_cum_date[1].
def var cumdate1	like sod_cum_date[1].
def var part		like pt_part.
def var part1		like pt_part.
def var sorttype	as logical format "A-����/C-�ͻ�".
def var amt			as decimal label "�ܼ�" format ">>>>,>>>,>>9.99".
def var site		like si_site initial "DCEC-SV".
def var site1		like si_site initial "DCEC-SV".
def var allamt 		as decimal.
/*cj*/ DEF VAR cmtype LIKE cm_type .

def temp-table zzwkso
	field sonbr		like so_nbr
	field sopart	like sod_part
	field invqty	like idh_qty_inv
	field soprice	like idh_price
	field soregion	like cm_region
/*cj*/ FIELD socmtype LIKE cm_type
	field socust	like so_cust
	field ptline	like pt_prod_line
	field soslspsn	like so_slspsn[1]
	field shipdate	like sod_cum_date[2]
	field invnbr	like idh_inv_nbr
	field zzsite	like si_site.


FORM /*GUI*/

	RECT-FRAME       AT ROW 1.4 COLUMN 1.25
	RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
	SKIP(.1)  /*GUI*/
		nbr 	colon 20
		nbr1	colon 50
		region 	colon 20
		region1 	colon 50
		cust		colon 20
		cust1	colon 50
		slspsn		colon 20
		cumdate		colon 20 label "��������"
		cumdate1 colon 50 LABEL {t001.i}
		part		colon 20
		part1	colon 50
		site	colon 20
		site1	colon 50
		sorttype	colon 20 label "����ѡ��"
		"A-����/C-�ͻ�"
/*cj*/  cmtype COLON 50      
    
	SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space THREE-D /*GUI*/.

/*cj*/ setFrameLabels(frame a:handle).

/*
form    
	so_cust label "�ͻ�"
	cm_sort label "�ͻ���"
	idh_part
	pt_group  
	pt_prod_line  
	so_slspsn[1]
	so_nbr
	idh_cum_date[2] label "��ʼ����"
	idh_qty_inv
	amt
	idh_inv_nbr
	idh_site
with frame d down width 200 no-box.*/

/* define Excel object handle */
DEFINE NEW SHARED VARIABLE chExcelApplication AS COM-HANDLE.
/*DEFINE VARIABLE chExcelWorksheet AS COM-HANDLE.*/
DEFINE NEW SHARED VARIABLE chExcelWorkbook AS COM-HANDLE.
/*Define Sheet Variavble*/
DEFINE VARIABLE iLine AS INTEGER.
DEFINE VARIABLE iTotalLine AS INTEGER.
	repeat:

		if nbr1 		= hi_char 	then nbr1	 	= "".
		if region1 		= hi_char 	then region1 	= "".
		if cust1 		= hi_char 	then cust1 		= "".
		if cumdate 		= low_date	then cumdate 	= ?.
		if cumdate1 	= hi_date 	then cumdate1 	= ?.
		if part1 		= hi_char 	then part1 		= "".
		if site1		= hi_char 	then site1		= "".

		hide message no-pause.
		message "����ѡ����������F2�ȴ����н����".
		
		update 
			nbr
			nbr1
			region 	
			region1 
			cust	
			cust1	
			slspsn	
			cumdate	
			cumdate1
			part	
			part1	
			site
			site1
			sorttype
/*cj*/      cmtype
		with frame a.

        {mfquoter.i  nbr	 	 }
        {mfquoter.i  nbr1	 	 }
        {mfquoter.i  region 	 }
        {mfquoter.i  region1     }
        {mfquoter.i  cust	     }
        {mfquoter.i  cust1	     }
        {mfquoter.i  slspsn	     }
        {mfquoter.i  cumdate	 }
        {mfquoter.i  cumdate1    }
        {mfquoter.i  part	     }
        {mfquoter.i  part1	     }
        {mfquoter.i  site		 }
        {mfquoter.i  site1       }
        {mfquoter.i  sorttype    }
        {mfquoter.i  cmtype    }
	
		if nbr1		= ""			then nbr1			= hi_char	.
		if region1 	= ""    		then region1 	    = hi_char 	.
		if cust1 	= ""   			then cust1 		    = hi_char   . 
		if cumdate 	= ?     		then cumdate 	    = low_date	.
		if cumdate1 = ?      		then cumdate1 	    = hi_date 	.
		if part1 	= ""    		then part1 		    = hi_char 	.
		if site1 	= ""    		then site1 		    = hi_char 	.

/*
		{mfselprt.i "printer" 132}
	    {mfphead.i}
	*/	
	
		{yysorp01.i}
		
		/* Create a New chExcel Application object */
		CREATE "Excel.Application" chExcelApplication.
	    
	    chExcelWorkbook = chExcelApplication:Workbooks:ADD.
	    
	    /*ADD DATA INTO EXCEL FILE */
		chExcelWorkbook:Worksheets(1):Cells(1,1) = "���۷�������".

		iLine = 2.
		chExcelWorkbook:Worksheets(1):Cells(iLine,1) = "�ͻ�". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,2) = "�ͻ���". 
/*cj*/  chExcelWorkbook:Worksheets(1):Cells(iLine,3) = "����-�ͻ�����". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,4) = "�����". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,5) = "�����". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,6) = "��Ʒ���λ". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,7) = "����Ա". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,8) = "����". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,9) = "��������". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,10) = "����". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,11) = "���". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,12) = "��Ʊ��". 
		chExcelWorkbook:Worksheets(1):Cells(iLine,13) = "�ص�". 
		
		

		if sorttype then
			{yysorps.i "soregion"}
		else
			{yysorps.i "socust"}

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