/*zzrssld.p, CREATE BY LONG BO   2004-06-14            	*/
/* LOAD SUPPLIER SCHEDULE FROM REPORT  5.5.3.11       	*/
/*						  INTO 5.5.3.3					*/
/* 														*/
/*------------------------------------------------------*/
/* rev: eb2 + sp7     last modified: 05/08/23   by : judy liu*/


         /* DISPLAY TITLE */
       {mfdtitle.i "f+"}

define variable part like wo_part.			/* assemble part    */
define variable wodpart like wod_part.
define variable daPart like wod_part.		/* disassemble part */
define variable nbr like wod_nbr.
define variable lot like wod_lot.
define variable woqtyord like wo_qty_ord.

define variable iss_pol like pt_iss_pol.

define variable wodesc1 like pt_desc1.
define variable wodesc2 like pt_desc1.
define variable status_name like wo_status format "x(12)".
define variable wod_recno as recid.


def var iError as integer.
def var iWarning as integer.

/*------------*/
def var finputfile  as char format "x(55)".
def var foutputfile as char format "x(55)".

def var iRow as integer.				
def var strtmp as char.
def var ponbr like po_nbr.
def var poline like pod_line.
def var schdate as date.
def var schqty like schd_upd_qty.
def var schid like pod_curr_rlse_id[1].

DEF TEMP-TABLE xxwk
    field xxwk_ponbr like po_nbr 
    field xxwk_line  LIKE pod_line  
    field xxwk_date as DATE 
    field xxwk_qty LIKE tr_qty_loc
    field xxwk_err as character format "x(40)" .

def var ponbrline as char format "x(40)".
def var msg_file as char format "x(40)".

def stream rssld.
def stream outputfile.

/* define Excel	object handle */
DEFINE NEW SHARED VARIABLE chExcelApplication AS COM-HANDLE.
/*DEFINE VARIABLE chExcelWorksheet AS COM-HANDLE.*/
DEFINE NEW SHARED VARIABLE chExcelWorkbook AS COM-HANDLE.


         /* DISPLAY SELECTION FORM */
         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
    finputfile	   colon 20		label	"导入文件"
    foutputfile    colon 20		label	"输出文件"
  SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

  DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
/*tfq*/   setFrameLabels(frame a:handle) .

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



     /* DISPLAY */
   	view frame a.
   	
   	find first code_mstr no-lock where code_fldname = "xx-rssld-dir" and code_value = global_userid no-error.
   	if available code_mstr then
		finputfile = code_cmmt.

  mainloop:
  repeat with frame a:
    DO TRANSACTION ON ERROR UNDO, LEAVE:
       
		FOR EACH xxwk:
            DELETE xxwk.
        END.
		/* input file and output file:*/
	    if finputfile = "" then finputfile = "C:\Purchase daily schedule\". 
 		update finputfile with frame a.
	
		if search(finputfile) = ? then do:
			message "找不到导入文件，请输入正确的路径和文件名！" view-as alert-box.
			undo, retry.
		end.
			
		if (substring(finputfile,length(finputfile) - 3,4) <> ".xls") then do:
			message "导入文件必须是EXCEL表格，以xls为文件后缀名，请重新输入！" view-as alert-box.
			undo, retry.
		end.

        msg_file = substring(finputfile,1,length(finputfile) - 4) + "o.txt".
		
        setoutputfile:
		do on error undo, retry:
			foutputfile = substring(finputfile,1,length(finputfile) - 4) + ".txt".
			update foutputfile with frame a.
			if search(foutputfile) <> ? then do:
				message "输出文件存在，覆盖已经存在的文件？" view-as alert-box button YES-NO update yn as logic.
				if yn <> yes then do:
					next-prompt foutputfile with frame a.
					undo, retry.
				end.
			end.
		end.
		
		/* Create a New chExcel Application object */
		CREATE "Excel.Application" chExcelApplication.
		/*Create a new workbook based on the template chExcel file */
		chExcelWorkbook = chExcelApplication:Workbooks:OPEN(finputfile,0,true,,,,true).

		/* read EXCEL file and load data begin..*/
		iRow = 16.	/* from the 17th row in the excel file, read data.*/
		iError = 0.
		iWarning = 0.
		
		schdate = ?.
		setschdate:
		do on error undo setschdate: 
			schdate = chExcelWorkbook:Worksheets(1):Cells(5,"AA"):value.
		end.
		if schdate = ? then do:
			message "日程日期错误，无法导入" view-as alert-box.
			iRow = 60000.
		end.

		output stream outputfile to value(foutputfile).
		
		/*------------------------------ EXCEL TABLE ----------------------------		
		| A		B     S           U   W        Y        AA   AC      AE      AG | 
		|序号 零件号 供应商编码 数量 限定时间 接收库位 包装 保管员 采购单号 PO序|
		------------------------------------------------------------------------*/
		repeat:
			iRow = iRow + 1.
			if string(chExcelWorkbook:Worksheets(1):Cells(iRow,"A"):value) = "" then leave.
			if string(chExcelWorkbook:Worksheets(1):Cells(iRow,"A"):value) = ? then leave.
			
			ponbr = string(chExcelWorkbook:Worksheets(1):Cells(iRow,"AE"):value).
			poline = (chExcelWorkbook:Worksheets(1):Cells(iRow,"AG"):value).
			find first scx_ref no-lock where scx_po = ponbr and scx_line = poline no-error.
			if not available scx_ref then do:
				put stream outputfile "日程不存在，EXCEL行：" + string(iRow) at 1 format "x(60)".
				iError = iError + 1.
				next.
			end.
			find first pod_det no-lock where pod_nbr = ponbr and pod_line = poline no-error.
			if not available pod_det then do:
				put stream outputfile "采购项不存在，EXCEL行：" + string(iRow) at 1 format "x(60)".
				iError = iError + 1.
				next.
			end.
			
			schqty = -1.
			getqty:
			do on error undo getqty: 
				schqty = chExcelWorkbook:Worksheets(1):Cells(iRow,"U"):value.
			end.
			if schqty < 0 then do:
				put stream outputfile "数量错误，EXCEL行：" + string(iRow) at 1 format "x(60)".
				iError = iError + 1.
				next.
			end.
			
			find first sch_mstr where sch_type = 4
						      and sch_nbr = scx_order 
						      and sch_line = scx_line
						      and sch_rlse_id = pod_curr_rlse_id[1] no-lock no-error.
			if not available sch_mstr then do:
				put stream outputfile "不存在有效日程单，EXCEL行：" + string(iRow) at 1 format "x(60)".			
				iError = iError + 1.
				next.
			end.
				

/*judy 05/08/23*/	
             IF TRIM(ponbr) + TRIM(STRING(poline)) + TRIM(STRING(schqty)) + TRIM(STRING(schdate)) = ""  THEN
             DO:
                chExcelWorkbook:CLOSE.
                chExcelApplication:Workbooks:CLOSE.
                chExcelApplication:QUIT.
                
                
                /* release com - handles */
                RELEASE OBJECT chExcelWorkbook.
                /*release object chexcelworkbooktemp .*/
                RELEASE OBJECT chExcelApplication.  
             END.
             ELSE DO:
             
                    FIND FIRST xxwk WHERE xxwk_ponbr = ponbr AND xxwk_line = poline NO-ERROR.
                    IF NOT AVAIL xxwk THEN DO:
                        CREATE xxwk .
                        ASSIGN xxwk_ponbr = ponbr 
                               xxwk_line = poline
                               xxwk_qty = schqty
                               xxwk_date = schdate.
                    END.
             END.
        END.  /*repeat*/
        run tran_rss_cimload.
        hide message no-pause.
		message "执行结束，请查看输出文件。" + "错误:" + string(iError) + " 警告：" + string(iWarning).
   END.  /*repeat*/
  END.
            
    
Procedure tran_rss_cimload:               
       
 
        
        for each xxwk break by xxwk_ponbr by xxwk_line :
           
            if first-of(xxwk_line) then
           do:
              ponbrline = TRIM(xxwk_ponbr) + TRIM(string(xxwk_line)).
              output to value(ponbrline).
              
              put 
                    '"' xxwk_ponbr '"' "- - -" xxwk_line skip 
                    "-" skip 
                    "-" skip
                    xxwk_date SKIP
                    xxwk_qty SKIP
                    "." skip 
                    "-" SKIP
                    "." skip . 
          
 
                output close .
                
                /*OS-COMMAND notepad  value(ponbrline).*/
               batchrun = yes .
               output to value(msg_file) APPEND.
               input from value(ponbrline) .
               {gprun.i ""rssmt.p""}
               input close .
               output close . 

           end.
                
                             
        end. /*for each */
           
        
            
           OS-COMMAND notepad  value(msg_file) .
           
           os-delete value(msg_file) . 


End procedure.
                         



	    

