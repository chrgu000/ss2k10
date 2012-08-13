/*zzwobomld.p, for batch matirial lood               */
/*Last modified by: Long Bo, Feb/19/2004              */

         /* DISPLAY TITLE */
         {mfdtitle.i "++ "} /*FN07*/

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

def var finputfile  as char format "x(55)".
def var foutputfile as char format "x(55)".

def var l_dot_pos as integer.			/* used to generate the string of foutputfile..*/
def var iError as integer.
def var iWarning as integer.
def var iZero as integer.				/* if disassemble part has the same part with assemeble part, then iZero = iZero + 1 */

def var iRow as integer.				

def stream wobomld.
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
	wo_nbr         colon 25
    wo_lot         colon 50
    part           colon 25
    wodesc1        no-label
    at 47 no-attr-space
    status_name    colon 25
    wodesc2        no-label at 47 no-attr-space
    skip(1)
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

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



     /* DISPLAY */
   view frame a.
	mainloop:
	repeat with frame a:

        prompt-for wo_nbr wo_lot editing:

           if frame-field = "wo_nbr" then do:
              nbr = input wo_nbr.

              /* FIND NEXT/PREVIOUS RECORD */
              {mfnp.i wo_mstr wo_nbr wo_nbr wo_nbr wo_nbr wo_nbr}
           end.
           else if frame-field = "wo_lot" then do:

              /* FIND NEXT/PREVIOUS RECORD */
              if nbr = "" then do:
                 {mfnp.i wo_mstr wo_lot wo_lot wo_lot wo_lot wo_lot}
              end.
              else do:
                 {mfnp01.i wo_mstr wo_lot wo_lot nbr wo_nbr wo_nbr}
              end.
           end.
           else do:
              readkey.
              apply lastkey.
           end.

           if recno <> ? then do:
              part = "".
              wodesc1 = "".
              wodesc2 = "".
              status_name = "".
              if wo_bom_code = "" then
              	part = wo_part.
              else
              	part = wo_bom_code.
              {mfwostat.i status_name wo_status}
              find pt_mstr where pt_part = wo_part no-lock no-error.
              if available pt_mstr then
              assign wodesc1 = pt_desc1
                     wodesc2 = pt_desc2.

              find first wod_det no-lock where wod_nbr = wo_nbr
              and wod_lot = wo_lot no-error.

              if not available wod_det then clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.

              display wo_nbr wo_lot part wodesc1 wodesc2 status_name.

           end. /* IF RECNO <> ? */
        end. /* PROMPT-FOR...EDITING */

        if input wo_nbr = "" and input wo_lot = "" then undo, retry.
        nbr = input wo_nbr.
        lot = input wo_lot.

        if nbr <> "" and lot <> "" then
          find wo_mstr where wo_nbr = nbr and wo_lot = lot no-lock no-error.
        if not available wo_mstr then if nbr = "" and lot <> "" then
           find wo_mstr where wo_lot = lot no-lock no-error.
        if not available wo_mstr then if nbr <> "" and lot = "" then
           find first wo_mstr where wo_nbr = nbr no-lock no-error.
        if nbr <> "" or lot <> "" then
        if not available wo_mstr then do:
           {mfmsg.i 510 3} /*  WORK ORDER DOES NOT EXIST.*/
           next-prompt wo_nbr.
           if nbr = "" then next-prompt wo_lot.
           undo, retry.
        end.
        /* SKIP WORK ORDERS CREATED BY CALL ACTIVITY RECORDING */
        if wo_fsm_type = "FSM-RO" then do:
            {mfmsg.i 7492 3}    /* FIELD SERVICE CONTROLLED */
            next-prompt wo_nbr.
            if nbr = "" then next-prompt wo_lot.
            undo, retry.
        end.

        {gprun.i ""gpsiver.p""
         "(input wo_site, input ?, output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

        if return_int = 0 then do:
           {mfmsg02.i 2710 3 wo_site} /* USER DOES NOT HAVE  */
                                      /* ACCESS TO SITE XXXX */
           undo , retry.
        end.

        part = "".
        status_name = "".
        wodesc1 = "".
        wodesc2 = "".
        if available wo_mstr then do:
           lot = wo_lot.
           if wo_bom_code = "" then
           	part = wo_part.
           else
           	part = wo_bom_code.
           nbr = wo_nbr.
           woqtyord = wo_qty_ord.
           find pt_mstr where pt_part = wo_part no-lock no-error.
           if available pt_mstr then
           assign wodesc1 = pt_desc1
                  wodesc2 = pt_desc2.
           {mfwostat.i status_name wo_status}
        end.

        display wo_nbr wo_lot part wodesc1 wodesc2 status_name.

        if lookup(wo_status,"P,F,B,C,") <> 0
        then do:
           {mfmsg.i 523 3} /* MODIFICATION TO PLANNED AND
                              FIRM PLANNED COMPONENTS NOT ALLOWED */
			undo, retry.
        end.

        if index("1234",wo_joint_type) <> 0 then do:
           /* WORK ORDER BILLS & ROUTINGS CANNOT EXIST FOR CO-BY-PRODUCTS */
           {mfmsg.i 6526 3}
           undo, retry.
        end.
		
		/* input file and output file:*/
		repeat with frame a:
	 		
	 		foutputfile = "".
	 		display foutputfile.
	 		
	 		update finputfile with frame a.
	
			if search(finputfile) = ? then do:
				message "找不到导入文件，请输入正确的路径和文件名！" view-as alert-box.
				undo, retry.
			end.
			
			l_dot_pos = index(finputfile,".").
			if (l_dot_pos) < 1 or (substring(finputfile,l_dot_pos + 1,3) <> "xls") then do:
				message "导入文件必须是EXCEL表格，以xls为文件后缀名，请重新输入！" view-as alert-box.
				undo, retry.
			end.
			foutputfile = substring(finputfile,1,length(finputfile,"CHARACTER") - 4) + ".out".
			display foutputfile.
			leave.
		end.

	    if keyfunction(lastkey) = "END-ERROR" then leave.
	    if keyfunction(lastkey) = "." then leave.
	
		/* Create a New chExcel Application object */
		CREATE "Excel.Application" chExcelApplication.
		/*Create a new workbook based on the template chExcel file */
		chExcelWorkbook = chExcelApplication:Workbooks:OPEN(finputfile,0,true,,,,true).

		/* read EXCEL file and load data begin..*/
		iRow = 2.	/* from the 3rd row in the excel file, read data.*/
	   iError = 0.
	   iWarning = 0.
	   iZero = 0.
	
		
		output stream outputfile to value(foutputfile).
		/* out put file header */		
		put stream outputfile "发动机拆装机型的加工单物料清单导入  " + string(today) + "  "+ STRING(TIME,"HH:MM:SS") at 1 format "x(60)".
		put stream outputfile " " at 1.
		put stream outputfile "加工单:" + nbr + "  ID:" + lot at 1 format "x(60)".
		put stream outputfile "零  件：" + part at 1 format "x(60)".
		put stream outputfile "导入文件:" + finputfile at 1 format "x(60)".
		put stream outputfile "用  户：" + global_userid at 1 format "x(60)".
		put stream outputfile " " at 1.
		
		/*check if the part in the EXCEL file is the same as the part of the work order*/ 
		if part <> chExcelWorkbook:Worksheets(1):Cells(2,6):value then do:
			put stream outputfile "错误：导入文件中拆装机零件号与加工单零件不一致，导入失败！" at 1 format "x(60)".
			iError = iError + 1.
			iRow = iRow + 1.
		end.
		else do:
		
			/* check if the disassemble machine is a sub part of this work order. */
			daPart = chExcelWorkbook:Worksheets(1):Cells(2,5):value. 
			find wod_det where wod_nbr = wo_nbr 
				and wod_lot = wo_lot
				and wod_part = daPart 
				no-lock no-error.
			if not available wod_det then do:
				put stream outputfile "警告：被拆装机在该加工单物料单中找不到！" at 1 format "x(60)".
				iWarning = iWarning + 1.
			end.
			
   	   output stream wobomld to "c:\wobomldfile".
         put stream wobomld "~"" at 1 wo_nbr "~" -".

			
			BillLoadFromExcel:
			repeat:
				
				iRow = iRow + 1.
				wodpart = chExcelWorkbook:Worksheets(1):Cells(iRow,2):value.
				
				if wodpart = "" or wodpart = ? then do:
					leave.	/* import data finished. */
				end.								
	
				if chExcelWorkbook:Worksheets(1):Cells(iRow,7):value = 0 then do:
					iZero = iZero + 1.
					next.
				end.
			
				find wod_det exclusive-lock
				where wod_nbr = wo_nbr and wod_lot = wo_lot
					and wod_part = wodpart and wod_op = 0
					no-error.
				if available wod_det then do:
					/* warning, item has exists.*/
					put stream outputfile "警告：" + wodpart + "已经存在，忽略导入。" at 1 format "x(50)".
					iwarning = iwarning + 1.
					next.
				end.
			
				find pt_mstr where pt_part = wodpart no-lock no-error.
				if not available pt_mstr then do:
					put stream outputfile "错误：" + wodpart + "不存在，忽略导入。" at 1 format "x(50)".
					iError = iError + 1.
					next.
				end.
         	
         	put stream wobomld "~"" at 1 wodpart "~" -" skip.
         	put stream wobomld string(woqtyord * chExcelWorkbook:Worksheets(1):Cells(iRow,7):value)
         				  "- - no " string(chExcelWorkbook:Worksheets(1):Cells(iRow,7):value).
				
				/*
				create wod_det.
				assign
					wod_nbr = wo_nbr
					wod_lot = wo_lot
					wod_part = pt_part
					wod_op = 0
					wod_iss_date = wo_rel_date
					wod_site = wo_site
					wod_recno = recid(wod_det)
					wod_loc = pt_loc
					wod_critical = pt_critical
					wod_qty_req = woqtyord * chExcelWorkbook:Worksheets(1):Cells(iRow,7):value
					wod_bom_qty = chExcelWorkbook:Worksheets(1):Cells(iRow,7):value.
				
				* Added section 
				if not  can-find (wr_route where wr_lot = wod_lot
				and wr_nbr = wod_nbr and wr_op = wod_op)
				and wod_op <> 0 then do:
					{mfmsg.i 511 2}
				end.
				 End of added section *?
	
						
				find in_mstr where in_site = wod_site
				and in_part = wodpart no-lock no-error.
				if available in_mstr then do:
					{gpsct03.i &cost=sct_cst_tot}
					wod_bom_amt = glxcst.
				end.
				
		       find ptp_det where ptp_part = wod_part and
		            ptp_site = wod_site no-lock no-error.
			   if available ptp_det then iss_pol = ptp_iss_pol.
	           else do:
	           	   find pt_mstr where pt_part = wodpart no-lock no-error.
	           	   if available pt_mstr then
		              iss_pol = pt_iss_pol.
		       end.     
	
	           find in_mstr where in_part = wodpart and in_site = wod_site
	           exclusive-lock no-error.
	           if available in_mstr then do:
				  		in_qty_req = in_qty_req - wod_qty_req.
	           end.
	
				if  iss_pol = no
				and index("AR",wo_status) > 0
				and wo_type = "R" then wod_qty_iss = wod_qty_req.

          	{mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot """"}

				{mfmrw.i "wod_det" wod_part wod_nbr wod_lot string(wod_op)
                   ? wod_iss_date wod_qty_req "DEMAND" "加工单子零件"
                   wod_site}
				*/
				
			end. /* end of BillLoadFromExcel , repeat.*/
			
			/*release wod_det.*/
		
			put stream wobomld "." at 1.
			put stream wobomld "." at 1.
	      
	      output stream wobomld close.
	
			batchrun = yes.
			input from "c:\wobomldfile".
			output to  "c:\wobomldout" keep-messages.
			 
			hide message no-pause.
			 
			{gprun.i ""wowamt.p""}
			 
			hide message no-pause.
			
			output close.
			input close.
			batchrun = no.

		end. /*if part <> partchExcelWorkbook:Worksheets(1):Cells(2,6):value then do: */

				
		put stream outputfile " " at 1.
		put stream outputfile "执  行：" + string(iRow - 3) at 1 format "x(60)".
		put stream outputfile "无差异：" + string(iZero) at 1 format "x(60)".
		put stream outputfile "错  误：" + string(ierror) at 1 format "x(60)".
		put stream outputfile "警  告：" + string(iwarning) at 1 format "x(60)".
		put stream outputfile "执行结束!" at 1.
		
		output stream outputfile close.
		
		chExcelWorkbook:CLOSE.
		chExcelApplication:Workbooks:CLOSE.
		chExcelApplication:QUIT.
		
	 /* release com - handles */
		 RELEASE OBJECT chExcelWorkbook.
	 /*release object chexcelworkbooktemp .*/
	 	RELEASE OBJECT chExcelApplication.       

		hide message no-pause.
		message "执行结束，请查看输出文件。" + "错误:" + string(iError) + " 警告：" + string(iWarning).

    end.

