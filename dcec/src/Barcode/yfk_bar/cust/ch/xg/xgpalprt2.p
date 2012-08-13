/* Revision: 1.0    BY: Xiang Wenhui, Atos Origin          DATE: 08/18/2005  */



/* DISPLAY TITLE */

{mfdtitle.i "AO"}


/*  LW01
define variable pallet like xwck_pallet.
*/
define VARIABLE pallet like xwck_pallet.

DEFINE VARIABLE palqty LIKE xwck_qty_chk.
define variable filetmp as char format "x(50)".
define variable eline as integer.
DEFINE VARIABLE cust LIKE cm_addr.
DEFINE VARIABLE custname LIKE ad_name.
DEFINE VARIABLE custpart LIKE pt_part.
DEFINE VARIABLE partdes LIKE pt_desc1.

 DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
 DEFINE VARIABLE chExcelWorkbook AS COM-HANDLE.
 DEFINE VARIABLE chExcelWorksheet AS COM-HANDLE.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
RECT-FRAME       AT ROW 1 COLUMN 1.25
RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
SKIP(.1)  /*GUI*/
    space(1)
   pallet         colon 25 label "托盘号"
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
/*GUI*/ if global-beam-me-up then undo, leave.

    filetmp = search("palletlab.xls").
        if filetmp = ? then do:
        message "打印模板palletlab.xls不存在".
        quit.
    end.          

    update  pallet
       with frame a.


    FOR EACH xwck_mstr NO-LOCK 
        WHERE xwck_pallet = pallet USE-INDEX xwck_paldt:
        ACCUMULATE xwck_qty_chk (TOTAL).
    END.
    palqty = ACCUM TOTAL xwck_qty_chk.

    FIND FIRST xwck_mstr WHERE xwck_pallet = pallet NO-LOCK NO-ERROR.
    IF AVAILABLE(xwck_mstr) THEN DO:
        FIND FIRST ad_mstr WHERE ad_addr = xwck_cust NO-LOCK NO-ERROR.
        IF AVAILABLE(ad_mstr) THEN DO:
            custname = ad_name.
        END.
        FIND FIRST cp_mstr WHERE cp_part = xwck_part AND cp_cust = xwck_cust NO-LOCK NO-ERROR.
        IF AVAILABLE cp_mstr THEN DO:
            custpart = cp_cust_part.
        END.
        FIND FIRST pt_mstr WHERE pt_part = xwck_part NO-LOCK NO-ERROR.
        IF AVAILABLE pt_mstr THEN DO:
            partdes = pt_desc1.
        END.
    END.
    ELSE DO:
        MESSAGE "没有找到托盘".
        UNDO /*mainloop*/.
    END.



   /* Create a New chExcel Application object */
     CREATE "Excel.Application" chExcelApplication.          
     chExcelWorkbook = chExcelApplication:Workbooks:Open(filetmp).                         
     chExcelWorksheet = chExcelWorkbook:ActiveSheet(). 

    /* Display detail */
    eline = 1.     
    chExcelWorksheet:Cells(eline , 2) =  
                  "*" + trim(xwck_part) +  "*".
    chExcelWorksheet:Cells(eline , 4) =  
                "*" + trim(xwck_cust) + "*".
    chExcelWorksheet:Cells(eline + 2, 2) =  
                 "*" + string(palqty) +  "*".
    chExcelWorksheet:Cells(eline + 2, 4) =  
                "*" + xwck_pallet + "*".
    chExcelWorksheet:Cells(eline + 4, 2) =  
                 "*" + xwck_loc_des +  "*".
    chExcelWorksheet:Cells(eline + 4, 4) =  
                 "*" + custpart +  "*".
    chExcelWorksheet:Cells(eline + 6, 2) =  custname.
    chExcelWorksheet:Cells(eline + 6, 4) =  partdes.

             
         /*Print */
 

     chExcelApplication:Visible = FALSE.
/*   chExcelWorkSheet:PrintPreview().  */
     chExcelWorksheet:printout.
     chExcelWorkbook:CLOSE(FALSE).
     chExcelApplication:QUIT.


      /* Release com - handles */
     RELEASE OBJECT chExcelWorksheet. 
     RELEASE OBJECT chExcelWorkbook.
     RELEASE OBJECT chExcelApplication.

end.
