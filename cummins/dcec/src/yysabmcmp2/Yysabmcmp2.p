/* zzbmpscmp.p - PRODUCT STRUCTURE COMPARE,	REPORT EXPORT TO MS EXCEL FILE    */
/* COPYRIGHT AtosOrigin. ALL RIGHTS	RESERVED. THIS IS AN UNPUBLISHED WORK.	  */
/* REVISION: 8.5	LAST MODIFIED: 11/19/03	 BY: *LB01*	Long Bo				  */


		 /*	DISPLAY	TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*GI32*/ {mfdtitle.i "121114.1"}

define variable	parent1	like ps_par.		
define variable	parent2	like ps_par.
define variable iRow as integer.
define variable desc1 like pt_desc1.
define variable desc2 like pt_desc1.
define variable desc11 like pt_desc2.
define variable desc12 like pt_desc2.
define variable showall like mfc_logical initial no.
define new shared var effdate1 like ps_start.
define new shared var effdate2 like ps_start.
define new shared variable site like si_site .
def var strdate as char.

define new shared work-table mybomcmp
	field bcomp like ps_comp
	field bdesc like pt_desc1
	field bdesc2 like pt_desc2
	field bqty1 like ps_qty_per
	field bqty2 like ps_qty_per.
define new shared variable transtype as character format "x(4)".
define new shared variable errmsg as integer .
	
define NEW shared workfile pkdet no-undo
        field pkpart like ps_comp
        field pkop as integer format ">>>>>9"
        field pkstart like pk_start
        field pkend like pk_end
        field pkqty like pk_qty
        field pkbombatch like bom_batch
        field pkltoff like ps_lt_off. 
	
/* define Excel	object handle */
DEFINE NEW SHARED VARIABLE chExcelApplication AS COM-HANDLE.
/*DEFINE VARIABLE chExcelWorksheet AS COM-HANDLE.*/
DEFINE NEW SHARED VARIABLE chExcelWorkbook AS COM-HANDLE.

form
   RECT-FRAME		AT ROW 1 COLUMN	1.25
   RECT-FRAME-LABEL	AT ROW 1 COLUMN	3 NO-LABEL VIEW-AS TEXT	SIZE-PIXELS	1 BY 1
   SKIP(1)	/*GUI*/
   parent1 colon 15	label "产品结构"
  /* parent2 colon 50	label "比较产品结构"  */
   desc1 no-label at 15
  /* desc2 no-label at 50 */
   desc11 no-label at 15
  /* desc12 no-label at 50 skip(1)  */
   effdate1 colon 15 label "生效日期"
   effdate2 colon 50 label "生效日期" skip(1)
   showall colon 20 label "显示所有Y/N" 
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
for each pkdet:
delete pkdet .
end.
for each mybomcmp :
delete mybomcmp .
end. 
  set parent1
	  /* parent2 */
	  effdate1
	  effdate2
	with frame a editing:
     message "输入需要比较的两个产品结构，按F2执行，并等待输出到EXCEL表格...".	   

	 if	frame-field	= "parent1"	then do:
	   /* FIND NEXT/PREVIOUS RECORD	- ALL BOM_MSTR'S ARE
		  VALID	FOR	"SOURCE" */
		  /*ss-20120904-cosesa*/
	   {mfnp.i bom_mstr  parent1 "bom_mstr.bom_domain = global_domain and  	
	   bom_parent " parent1 bom_parent bom_parent} 
	   if recno	<> ? then do:
		  assign
			parent1	= bom_parent
			desc1 =	bom_desc.
                                /*ss-20120904-cosesa*/
		  find pt_mstr where pt_mstr.pt_domain = global_domain and 
		  pt_part = bom_parent no-lock no-error.
		  if available pt_mstr then
		  	desc11 = pt_desc2. 				
 
		  display parent1
				  desc1
				  desc11
		  with frame a.
	   end.	   /* if recno <> ?	*/
  
	   recno = ?.
	 end.	/* if frame-field =	"parent1" */
	 /**********tfq deleted begin***********************************
	 else if frame-field = "parent2" then do:

	   /* FIND NEXT/PREVIOUS RECORD	- BOMS TO DISPLAY DEPEND
	   IN THE INPUT	BOM-TYPE PARAMETER */

	      /*ss-20120904-cosesa*/
	   {mfnp.i bom_mstr parent2 "bom_mstr.bom_domain = global_domain and bom_parent "
	   bom_parent parent2
			   bom_parent bom_parent}

	   if recno	<> ? then do:
		  assign
			parent2	= bom_parent
			desc2 =	bom_desc.
			 /*ss-20120904-cosesa*/
		  find pt_mstr where pt_mstr.pt_domain = global_domain and  pt_part = bom_parent no-lock no-error.
		  if available pt_mstr then
		  	desc12 = pt_desc2. 				


		  display parent2
				  desc2
				  desc12
		  with frame a.

	   end.	   /* if recno <> ?	*/

	 end.	 /*	if frame-field = "parent2" */
	 ***********************tfq deleted end************************/
	 else do:
	   status input.
	   readkey.
	   apply lastkey.
	 end.
	end.	/* editing */
	          /*ss-20120904-cosesa*/
	find first bom_mstr where bom_mstr.bom_domain = global_domain and bom_parent = parent1 no-lock no-error.
	if not available bom_mstr then do:
		message "产品结构不存在，请重新输入! " view-as alert-box.
		next-prompt parent1 with frame a.
		undo,	retry.
	end.
	else do:
		desc1 = bom_desc.
	end.
	/************tfq deleted begin**************************
	find first bom_mstr where bom_parent = parent2 no-lock no-error.
	if not available bom_mstr then do:
		message "产品结构不存在，请重新输入! " view-as alert-box.
		next-prompt parent2 with frame a.
		undo,	retry.
	end.
	else do:
		desc2 = bom_desc.
	end.
	*******************tfq deledted end***********************/
	   /*ss-20120904-cosesa*/
	find pt_mstr where pt_mstr.pt_domain = global_domain and pt_part = parent1 no-lock no-error.
	if available pt_mstr then
		desc11 = pt_desc2. 				
	find pt_mstr where pt_mstr.pt_domain = global_domain and pt_part = parent2 no-lock no-error.
	if available pt_mstr then
		desc12 = pt_desc2. 				
	
	/*********tfq deleted begin*******************	
	if parent1 = parent2 then do:
		message "您在源结构和比较结构中输入了同一产品结构，请重新输入! " view-as alert-box.
		next-prompt parent1 with frame a.
		undo,	retry.
	end.
	************tfq deleted end*******************/
	disp desc1 /*tfq desc2*/  desc11 /*tfq desc12*/ with frame a.
	
	update showall with frame a.
		
	for each mybomcmp exclusive-lock:
		delete mybomcmp.
	end.
        /***********tfq****deleted begin***********************************
	{gprun.i ""zzIstWkf.p"" "(input parent1, input yes)"}
	{gprun.i ""zzIstWkf.p"" "(input parent2, input no)"}
	***********tfq deleted end*************/
	/********tfq added begin******************************/
	transtype = "BM" . 
	 
	find first si_mstr where si_mstr.si_domain = global_domain no-lock .
	if available si_mstr then site = si_site .
	/*ss-20120904-cosesa*/
	find first ps_mstr where ps_mstr.ps_domain = global_domain and 
	ps_par = parent1 and ps__chr01 <> "" no-lock no-error .
	if available ps_mstr then site = ps__chr01 .
	 {gprun.i ""yybmpkiqb.p"" "(input parent1,
                               INPUT site,
                               INPUT effdate1)"}
         for each pkdet  :
          find first mybomcmp where bcomp = pkpart no-error.
          if not available mybomcmp then
          do:
           create mybomcmp .
           assign bcomp = pkpart
                  bqty1 = pkqty.
		   /*ss-20120904-cosesa*/
              find pt_mstr where pt_mstr.pt_domain = global_domain and pt_part = pkpart no-lock no-error  .
              if available pt_mstr then assign bdesc = pt_desc1 
                                               bdesc2 = pt_desc2 .
                         
          end . 
          else do:
          bqty1 = pkqty + bqty1 .
          end.
          
          delete pkdet .
         end. 
           {gprun.i ""yybmpkiqb.p"" "(input parent1,
                               INPUT site,
                               INPUT effdate2)"}
            for each pkdet  :
          find first mybomcmp where bcomp = pkpart no-error.
          if not available mybomcmp then
          do:
           create mybomcmp .
           assign bcomp = pkpart
                  bqty2 = pkqty.
		  /*ss-20120904-cosesa*/
              find pt_mstr where pt_mstr.pt_domain = global_domain and pt_part = pkpart no-lock no-error  .
              if available pt_mstr then assign bdesc = pt_desc1 
                                               bdesc2 = pt_desc2 .
                         
          end . 
          else do:
          bqty2 = pkqty + bqty2 .
          end.
          
          delete pkdet .
         end. 
                        
                 
        /****************tfq added end*************************/
	/* Create a New chExcel Application object */
	CREATE "Excel.Application" chExcelApplication.
	/*Create a new workbook based on the template chExcel file */
	chExcelWorkbook = chExcelApplication:Workbooks:ADD.
	iRow = 1.
	chExcelWorkbook:Worksheets(1):Cells(iRow,1) = "产品结构比较报表--" + parent1 .
	iRow = 2.
	chExcelWorkbook:Worksheets(1):Cells(iRow,1) = "序".
	chExcelWorkbook:Worksheets(1):Cells(iRow,2) = "子零件".
	chExcelWorkbook:Worksheets(1):Cells(iRow,3) = "描述一".
	chExcelWorkbook:Worksheets(1):Cells(iRow,4) = "描述二".
	chExcelWorkbook:Worksheets(1):Cells(iRow,5) = "'" + string(effdate1).
	chExcelWorkbook:Worksheets(1):Cells(iRow,6) = "'" + string(parent1).
	chExcelWorkbook:Worksheets(1):Cells(iRow,7) = "差异数量".
	chExcelWorkbook:Worksheets(1):Range("E2"):AddComment.
	if effdate1 = ? then
		strdate = "".
	else
		strdate = string(effdate1).
	chExcelWorkbook:Worksheets(1):Range("E2"):Comment:Text("QAD:" + chr(10) + desc1 + chr(10) + desc11 + chr(10) + "生效日期" + strdate).
	chExcelWorkbook:Worksheets(1):Range("F2"):AddComment.
	if effdate2 = ? then
		strdate = "".
	else
		strdate = string(effdate2).
	chExcelWorkbook:Worksheets(1):Range("F2"):Comment:Text("QAD:" + chr(10) + desc2 + chr(10) + desc12 + chr(10) + "生效日期" + strdate).
	
	

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
	message "报表运行结束.".	   
     
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


