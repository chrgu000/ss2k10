/*------------------------------------------------------------------------
  History
     2006-2-16, Xiang Wenhui,

-------------------------------------------------------------------------*/

{pxmaint.i}
{pxphdef.i xkutlib}


define input parameter psnbr as char.
define variable eline as integer.
define variable pageline as integer.
define variable filetmp as char format "x(50)" .
define variable vend like po_vend.
define variable shipto like po_ship.
define variable urgent as logical.
define variable buyer as char.
define variable orddate as char.  
define variable ordtime as char.
define variable rctdate as char.   
define variable rcttime as char.
DEFINE VARIABLE sSuperdesc AS CHAR FORMAT "x(24)".
DEFINE VARIABLE dSuperdesc AS CHAR FORMAT "x(24)".
DEFINE BUFFER bf_xkromstr FOR xkro_mstr.
DEFINE VARIABLE recordid AS RECID.

define variable tempDate as date .
define variable tempTime as int .


define workfile temp
    field temp_line like pod_line
    field temp_part like pod_part
    field temp_vend_part like pod_part
    field temp_desc like pt_desc1    
    field temp_um like pod_um
    field temp_uc like pt_ord_mult
    field temp_qty_ord like pod_qty_ord.

 DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
 DEFINE VARIABLE chExcelWorkbook AS COM-HANDLE.
 DEFINE VARIABLE chExcelWorksheet AS COM-HANDLE.

       filetmp = search("pullsheet.xlt").
       if filetmp = ? then do:
            message "打印模板pullsheet.xlt不存在".
            quit.
       end.          
       for each temp:
            delete temp.
       end.     
     
         find first xkro_mstr where xkro_nbr = psnbr no-lock no-error.
         if available xkro_mstr then do:
            recordid = RECID(xkro_mstr).
    	    assign buyer = xkro_user
                   urgent = xkro_urgent
    	           orddate = string(xkro_ord_date , "99-99-9999")
    	           ordtime = string(xkro_ord_time, "HH:MM") 
    		       rctDate = string(xkro_due_date, "99-99-9999")
    	           rctTime = string(xkro_due_time, "HH:MM").
            IF xkro_type = 'J' THEN DO:
                FIND FIRST loc_mstr WHERE loc_loc = xkro__chr01 NO-LOCK NO-ERROR.
                IF AVAILABLE loc_mstr THEN sSuperdesc = loc_desc.

                find first xgpl_ctrl where xgpl_lnr = xkro__chr02 no-lock no-error.
                IF AVAILABLE xgpl_ctrl THEN dSuperdesc = xgpl_desc.
            END.

            ELSE DO:
                FIND FIRST knbsm_mstr WHERE knbsm_supermarket_id = xkro__chr01 NO-LOCK NO-ERROR.
                IF AVAILABLE knbsm_mstr THEN sSuperdesc = knbsm_desc.
    
                FIND FIRST knbsm_mstr WHERE knbsm_supermarket_id = xkro__chr02 NO-LOCK NO-ERROR.
                IF AVAILABLE knbsm_mstr THEN dSuperdesc = knbsm_desc.
            END.


		/*** Detail information ***/  
            for each xkrod_det where xkrod_nbr = xkro_nbr no-lock,
    	    each pt_mstr no-lock
    	    where pt_part = xkrod_part:
               create temp.
               assign temp_line = xkrod_line
                      temp_part = xkrod_part
                      temp_qty_ord = xkrod_qty_ord
                      temp_desc = pt_desc1
                      temp_um = pt_um
                      temp_uc = xkrod_pack .
                    
    	    end. /*for each xkrod_det where xkrod_nbr = */        
         end. /*find first xkro_mstr where xkro_nbr*/
         
         FIND bf_xkromstr WHERE RECID(bf_xkromstr) = recordid EXCLUSIVE-LOCK NO-ERROR.
            bf_xkromstr.xkro_print = NO.
         RELEASE bf_xkromstr.


	   /* Create a New chExcel Application object */
             CREATE "Excel.Application" chExcelApplication.          
             chExcelWorkbook = chExcelApplication:Workbooks:Open(filetmp).            
             chExcelWorksheet = chExcelWorkbook:Activesheet. 

             /* Display header */
             if urgent = No then 
                chExcelWorksheet:Cells(2 , 5) = "√".
             else 
                chExcelWorksheet:Cells(3 , 5) = "√".             
             eline = 1.
             chExcelWorksheet:Cells(eline , 8) = "*" + psnbr + "*".
             chExcelWorksheet:Cells(eline + 1, 8) = "*" + psnbr + "*".
             chExcelWorksheet:Cells(eline + 2, 3) = sSuperdesc.
             chExcelWorksheet:Cells(eline + 2, 9) = orddate + " " + ordtime .
             chExcelWorksheet:Cells(eline + 3, 3) = dSuperdesc.
             chExcelWorksheet:Cells(eline + 3, 9) = rctDate + " " + rctTime .

             /* Display detail */
             eline = 8.
             pageline = 1.
/*Jeff061221*             chExcelWorkSheet:Rows("8:39"):Copy. */
             for each temp by temp_line:
                chExcelWorksheet:Cells(eline , 1) =  temp_line.
                chExcelWorksheet:Cells(eline , 2) =  temp_part.
                chExcelWorksheet:Cells(eline , 3) =  temp_desc.
                chExcelWorksheet:Cells(eline , 4) =  temp_um.
                chExcelWorksheet:Cells(eline , 5) =  temp_uc.
                chExcelWorksheet:Cells(eline , 6) =  temp_qty_ord / temp_uc.
                chExcelWorksheet:Cells(eline , 7) =  temp_qty_ord.                                                                                
                eline = eline + 1.
                pageline = pageline + 1.
                if pageline > 32 then do:
                    eline = eline + 5.
                    pageline = 1.
/*Jeff061221*/      chExcelWorkSheet:Rows("8:39"):Copy.                     
                    chExcelWorkSheet:cells(eline,1):SELECT.
                    chExcelWorkSheet:PASTE.
                    chExcelWorkSheet:Rows(STRING(eline) + ":" + string(eline + 31)):clearcontents.
                end.
             end.             
             
             /*Print */
             chExcelApplication:Visible = FALSE.
/*             chExcelWorkSheet:PrintPreview().*/
             chExcelWorksheet:printout.
             chExcelWorkbook:CLOSE(FALSE).
             chExcelApplication:QUIT.
              /* Release com - handles */
             RELEASE OBJECT chExcelWorksheet. 
             RELEASE OBJECT chExcelWorkbook.
             RELEASE OBJECT chExcelApplication.


