/* zzbmpscmp.p - PRODUCT STRUCTURE COMPARE,	REPORT EXPORT TO MS EXCEL FILE    */
/* COPYRIGHT AtosOrigin. ALL RIGHTS	RESERVED. THIS IS AN UNPUBLISHED WORK.	  */
/* REVISION: 8.5	LAST MODIFIED: 11/19/03	 BY: *LB01*	Long Bo				  */


		 /*	DISPLAY	TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*GI32*/ {mfdtitle.i "E"}

def	var	parent1	like ps_par.		
def	var	parent2	like ps_par.
define variable iRow as integer.
define variable desc1 like pt_desc1.
define variable desc2 like pt_desc1.
define variable desc11 like pt_desc2.
define variable desc12 like pt_desc2.
define variable showall like mfc_logical initial no.
define new shared var effdate1 like ps_start.
define new shared var effdate2 like ps_start.
def var strdate as char.

define new shared work-table mybomcmp
	field bcomp like ps_comp
	field bdesc like pt_desc1
	field bdesc2 like pt_desc2
	field bqty1 like ps_qty_per
	field bqty2 like ps_qty_per.
	
/* define Excel	object handle */
DEFINE NEW SHARED VARIABLE chExcelApplication AS COM-HANDLE.
/*DEFINE VARIABLE chExcelWorksheet AS COM-HANDLE.*/
DEFINE NEW SHARED VARIABLE chExcelWorkbook AS COM-HANDLE.

form
   RECT-FRAME		AT ROW 1 COLUMN	1.25
   RECT-FRAME-LABEL	AT ROW 1 COLUMN	3 NO-LABEL VIEW-AS TEXT	SIZE-PIXELS	1 BY 1
   SKIP(1)	/*GUI*/
   parent1 colon 15	label "Դ��Ʒ�ṹ"
   parent2 colon 50	label "�Ƚϲ�Ʒ�ṹ"
   desc1 no-label at 15
   desc2 no-label at 50
   desc11 no-label at 15
   desc12 no-label at 50 skip(1)
   effdate1 colon 15 label "��Ч����"
   effdate2 colon 50 label "��Ч����" skip(1)
   showall colon 20 label "��ʾ����Y/N" 
   skip(.4)
   with	frame a	side-labels	width 80 NO-BOX	THREE-D	/*GUI*/.

   DEFINE VARIABLE F-a-title AS	CHARACTER INITIAL "".
   RECT-FRAME-LABEL:SCREEN-VALUE in	frame a	= F-a-title.
   RECT-FRAME-LABEL:HIDDEN in frame	a =	yes.
   RECT-FRAME:HEIGHT-PIXELS	in frame a =
   FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y	in frame a - 2.
   RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

	display today @ effdate1 today @ effdate2 with frame a.
repeat:

  set parent1
	  parent2
	  effdate1
	  effdate2
	with frame a editing:
     message "������Ҫ�Ƚϵ�������Ʒ�ṹ����F2ִ�У����ȴ������EXCEL����...".	   

	 if	frame-field	= "parent1"	then do:
	   /* FIND NEXT/PREVIOUS RECORD	- ALL BOM_MSTR'S ARE
		  VALID	FOR	"SOURCE" */
	   {mfnp.i bom_mstr	parent1	bom_parent parent1
			   bom_parent bom_parent}
	   if recno	<> ? then do:
		  assign
			parent1	= bom_parent
			desc1 =	bom_desc.

		  find pt_mstr where pt_part = bom_parent no-lock no-error.
		  if available pt_mstr then
		  	desc11 = pt_desc2. 				
 
		  display parent1
				  desc1
				  desc11
		  with frame a.
	   end.	   /* if recno <> ?	*/
  
	   recno = ?.
	 end.	/* if frame-field =	"parent1" */
	 else if frame-field = "parent2" then do:

	   /* FIND NEXT/PREVIOUS RECORD	- BOMS TO DISPLAY DEPEND
	   IN THE INPUT	BOM-TYPE PARAMETER */
	   {mfnp.i bom_mstr	parent2	bom_parent parent2
			   bom_parent bom_parent}

	   if recno	<> ? then do:
		  assign
			parent2	= bom_parent
			desc2 =	bom_desc.
			
		  find pt_mstr where pt_part = bom_parent no-lock no-error.
		  if available pt_mstr then
		  	desc12 = pt_desc2. 				


		  display parent2
				  desc2
				  desc12
		  with frame a.

	   end.	   /* if recno <> ?	*/

	 end.	 /*	if frame-field = "parent2" */
	 else do:
	   status input.
	   readkey.
	   apply lastkey.
	 end.
	end.	/* editing */
	
	find first bom_mstr where bom_parent = parent1 no-lock no-error.
	if not available bom_mstr then do:
		message "��Ʒ�ṹ�����ڣ�����������! " view-as alert-box.
		next-prompt parent1 with frame a.
		undo,	retry.
	end.
	else do:
		desc1 = bom_desc.
	end.
	
	find first bom_mstr where bom_parent = parent2 no-lock no-error.
	if not available bom_mstr then do:
		message "��Ʒ�ṹ�����ڣ�����������! " view-as alert-box.
		next-prompt parent2 with frame a.
		undo,	retry.
	end.
	else do:
		desc2 = bom_desc.
	end.
	find pt_mstr where pt_part = parent1 no-lock no-error.
	if available pt_mstr then
		desc11 = pt_desc2. 				
	find pt_mstr where pt_part = parent2 no-lock no-error.
	if available pt_mstr then
		desc12 = pt_desc2. 				
	
		
	if parent1 = parent2 then do:
		message "����Դ�ṹ�ͱȽϽṹ��������ͬһ��Ʒ�ṹ������������! " view-as alert-box.
		next-prompt parent1 with frame a.
		undo,	retry.
	end.
	
	disp desc1 desc2 desc11 desc12 with frame a.
	
	update showall with frame a.
		
	for each mybomcmp exclusive-lock:
		delete mybomcmp.
	end.

	{gprun.i ""zzIstWkf.p"" "(input parent1, input yes)"}
	{gprun.i ""zzIstWkf.p"" "(input parent2, input no)"}
	
	/* Create a New chExcel Application object */
	CREATE "Excel.Application" chExcelApplication.
	/*Create a new workbook based on the template chExcel file */
	chExcelWorkbook = chExcelApplication:Workbooks:ADD.
	iRow = 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,1) = "��Ʒ�ṹ�Ƚϱ���".
	iRow = 2.
	chExcelWorkbook:Worksheets(1):Cells(iRow,1) = "��".
	chExcelWorkbook:Worksheets(1):Cells(iRow,2) = "�����".
	chExcelWorkbook:Worksheets(1):Cells(iRow,3) = "����һ".
	chExcelWorkbook:Worksheets(1):Cells(iRow,4) = "������".
	chExcelWorkbook:Worksheets(1):Cells(iRow,5) = "'" + parent1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,6) = "'" + parent2.
	chExcelWorkbook:Worksheets(1):Cells(iRow,7) = "��������".
	chExcelWorkbook:Worksheets(1):Range("E2"):AddComment.
	if effdate1 = ? then
		strdate = "".
	else
		strdate = string(effdate1).
	chExcelWorkbook:Worksheets(1):Range("E2"):Comment:Text("QAD:" + chr(10) + desc1 + chr(10) + desc11 + chr(10) + "��Ч����" + strdate).
	chExcelWorkbook:Worksheets(1):Range("F2"):AddComment.
	if effdate2 = ? then
		strdate = "".
	else
		strdate = string(effdate2).
	chExcelWorkbook:Worksheets(1):Range("F2"):Comment:Text("QAD:" + chr(10) + desc2 + chr(10) + desc12 + chr(10) + "��Ч����" + strdate).
	
	

	for each mybomcmp by mybomcmp.bcomp:
		if not showall then
			if mybomcmp.bqty2 = mybomcmp.bqty1 then
				next.
		iRow = iRow + 1.
		chExcelWorkbook:Worksheets(1):Cells(iRow,1) = string(iRow - 2).
		chExcelWorkbook:Worksheets(1):Cells(iRow,2) = "'" + mybomcmp.bcomp.
		chExcelWorkbook:Worksheets(1):Cells(iRow,3) = "'" + mybomcmp.bdesc.
		chExcelWorkbook:Worksheets(1):Cells(iRow,4) = "'" + mybomcmp.bdesc2.
		chExcelWorkbook:Worksheets(1):Cells(iRow,5) = string(mybomcmp.bqty1).
		chExcelWorkbook:Worksheets(1):Cells(iRow,6) = string(mybomcmp.bqty2).
		chExcelWorkbook:Worksheets(1):Cells(iRow,7) = string(mybomcmp.bqty2 - mybomcmp.bqty1).
	end.
	
	chExcelWorkbook:Worksheets(1):Range("A1:G1"):HorizontalAlignment = -4108.
    chExcelWorkbook:Worksheets(1):Range("A1:G1"):VerticalAlignment = -4107.
    chExcelWorkbook:Worksheets(1):Range("A1:G1"):WrapText = 0.
    chExcelWorkbook:Worksheets(1):Range("A1:G1"):Orientation = 0.
    chExcelWorkbook:Worksheets(1):Range("A1:G1"):AddIndent = 0.
    chExcelWorkbook:Worksheets(1):Range("A1:G1"):ShrinkToFit = 0.
    chExcelWorkbook:Worksheets(1):Range("A1:G1"):MergeCells = -1.

	chExcelWorkbook:Worksheets(1):Columns("A:A"):EntireColumn:AutoFit.
	chExcelWorkbook:Worksheets(1):Columns("B:B"):EntireColumn:AutoFit.
	chExcelWorkbook:Worksheets(1):Columns("C:C"):EntireColumn:AutoFit.
	chExcelWorkbook:Worksheets(1):Columns("D:D"):EntireColumn:AutoFit.
	chExcelWorkbook:Worksheets(1):Columns("E:E"):EntireColumn:AutoFit.
	chExcelWorkbook:Worksheets(1):Columns("F:F"):EntireColumn:AutoFit.
	chExcelWorkbook:Worksheets(1):Columns("G:G"):EntireColumn:AutoFit.

	 
	chExcelApplication:Visible = True.
	hide message.
	message "�������н���.".	   
     
/*	 chExcelWorkbook:PrintPreview.*/
	
	 /**The tailer of the program**/      
	 /* close the Excel file */
/*	 chExcelWorkbook:CLOSE.
	 chExcelApplication:Workbooks:CLOSE.
	 chExcelApplication:QUIT.
*/	
	 /* release com - handles */
	 RELEASE OBJECT chExcelWorkbook.
	 /*release object chexcelworkbooktemp .*/
	 RELEASE OBJECT chExcelApplication.

  
end. /*repeat*/
