 /**送检单打印   Created by Judy Liu   2006-11-16  Verison: 1**/
 
 
 
 {mfdtitle.i}

 DEF VAR ponbr LIKE po_nbr .
 DEF VAR cty AS CHAR FORMAT "x(1)".
 DEF VAR sel-yn AS LOGICAL INIT NO.
 def VAR aa_from_recno as recid format "->>>>>>9".         
 define variable first_sw_call as logical initial true.     
 def var framename as char format "x(40)".
 DEF VAR yn AS LOGICAL INIT NO.
 DEF VAR desc1 LIKE pt_desc1.
 DEF VAR vd1 LIKE vd_sort.
 DEF VAR i AS INTE.
 DEF VAR j AS INTE.
 DEF VAR k AS INTE.
 DEF VAR m AS INTE.
 DEF VAR ym AS LOG INIT YES.

 DEF WORKFILE aa
     FIELD aa_nbr LIKE po_nbr
     FIELD aa_line LIKE pod_line
     FIELD aa_part LIKE pod_part 
     FIELD aa_qty_open LIKE pod_qty_ord
     FIELD aa_desc1 LIKE pt_desc1
     FIELD aa_select AS CHAR FORMAT "x(1)".

/* define Excel object handle */
DEFINE VARIABLE chExcelApplication AS COM-HANDLE.
DEFINE VARIABLE chExcelWorkbook AS COM-HANDLE.
DEFINE VARIABLE chExcelsheet1 AS COM-HANDLE.
DEFINE VARIABLE chExcelsheet2 AS COM-HANDLE.
DEFINE VARIABLE chExcelsheet3 AS COM-HANDLE.
/*Define Sheet Variavble*/
DEFINE VARIABLE iLine AS INTEGER.
DEFINE VARIABLE iTotalLine AS INTEGER.
DEFINE VARIABLE iHeaderLine AS INTEGER.
DEFINE VARIABLE iHeaderStartLine AS INTEGER.
DEFINE VARIABLE iMAXPageLine AS INTEGER.
DEFINE VARIABLE iFooterLine AS INTEGER.
DEFINE VARIABLE iLoop1 AS INTEGER.
/*End Added by Jeffrey Liang*/

{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{fsconst.i}    /* SSM CONSTANTS */
 

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A
form
RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
  ponbr        colon 15  LABEL "采购单号码"
   cty     COLON 15 LABEL "材料类型" HELP "请输入材料类型"
    "A)原材料 /  B) 外购产品 /  C) 外协产品  / D) 外购量具 / E) 外协量具" AT 17
    "F) 外购的装夹具、刀具  / G) 外协的工装夹具、刀具 /  H) 辅助物资"
    AT 17
   skip(1) sel-yn colon 15 label "选择性打印"    
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

/* SET EXTERNAL LABELS */
/*setFrameLabels(frame a:handle).*/

 
 
form
 SKIP(.1)  /*GUI*/
   aa.aa_select  format "x(2)" label "选择" 
   /*aa.aa_nbr     FORMAT "x(8)" LABEL "采购单"*/
   aa.aa_line     FORMAT ">9"
   aa.aa_part   FORMAT "x(20)"
   aa.aa_desc1  FORMAT "x(25)"
    aa.aa_qty_open LABEL "未结数量"
   skip(.1)
   with frame c  /*column 5*/ row 7   CENTERED   overlay 
   width 60 title framename THREE-D   stream-io /*GUI*/.

 
repeat:
     
clear frame a no-pause.
   clear frame b no-pause.               
   clear frame c no-pause.                      
    cty = "".

  FOR  EACH aa:
      DELETE aa.
  END.
             
 
          PROMPT-FOR  ponbr WITH FRAME a EDITING:

            {mfnp06.i po_mstr po_nbr 
                   "po_stat = ''"
                   ponbr  ponbr ponbr ponbr } 
            /*if recno = ? then message "aaa".
            pause.*/
            IF recno <> ?  THEN DO:
              DISP  po_nbr @  ponbr with frame a.
               
            END.  /*if recno<> ?*/
            /*status input.
            readkey.
            apply lastkey.*/
            
       END.    /*editing*/

       ASSIGN ponbr. 
 
     
   

        FIND  FIRST pod_det no-lock where pod_nbr = ponbr AND pod_status = ""  no-error.
        IF  not available pod_det then do:
                     MESSAGE "采购单不存在或已结，请重新输入！".
                     next-prompt ponbr.
                     undo, retry.
          end.
            
         if available pod_det then disp pod_nbr @ ponbr with frame a.
       UPDATE cty validate(lookup(cty,"a,b,c,d,e,f,g,h") > 0,"错误代号")
                sel-yn WITH FRAME a.
       
       FOR EACH  pod_det WHERE pod_nbr = ponbr NO-LOCK:
           FIND FIRST pt_mstr WHERE pt_part = pod_part NO-LOCK NO-ERROR.
           FIND FIRST aa WHERE aa_nbr = pod_nbr AND aa_line = pod_line NO-LOCK NO-ERROR.
           IF NOT AVAIL aa THEN   DO:
               CREATE aa.
               ASSIGN aa_nbr = pod_nbr
                           aa_line  = pod_line
                           aa_part = pod_part
                           aa_desc1 = pt_desc1 WHEN AVAIL pt_mstr
                           aa_select = "*" WHEN NOT sel-yn 
                           aa_qty_open = pod_qty_ord - pod_qty_rcvd.
           END.
       END. 
 
    
    if sel-yn then do:     
         yn = no.
           
         sw_block:
         do transaction: /*on endkey undo, leave:*/
              message "请按 'enter' or 'space', 键去选择要送检的零件.".         
              framename = "送检零件选择".      
         /* INCLUDE SCROLLING WINDOW TO ALLOW THE USER TO SCROLL      */
               /* THROUGH (AND SELECT FROM) EXISTING PAYMENTS APPLICATIONS  */
               {swselect.i
                  &detfile      = aa
                 &detkey = "where"
                 &searchkey = "aa.aa_nbr = ponbr "
                  &scroll-field =aa.aa_select
                  &framename    = "c"
                  &framesize    = 10
                  &sel_on       = ""*""
                  &sel_off      = """"
                  &display1   =aa.aa_select
                  &display2     = """"
                  &display3     = aa.aa_line
                  &display4     = aa.aa_part
                  &display5     = aa.aa_desc1
                  &display6     = aa.aa_qty_open
                  &display7     = """"
                  &display8     = """"
                  &display9     = """"
                  &exitlabel    = sw_block
                  &exit-flag    = first_sw_call 
                  &record-id    = aa_from_recno
                   }
           if keyfunction(lastkey) = "end-error"
            or lastkey = keycode("F4")
            or keyfunction(lastkey) = "."
            or lastkey = keycode("CTRL-E") then do:
               undo sw_block, leave.
            end.        
            else do:
             yn = no.
             /*tfq {mfmsg01.i 12 1 yn}*/
             /*tfq*/{pxmsg.i
               &MSGNUM=12
               &ERRORLEVEL=1
               &CONFIRM=yn
            } /* IS ALL INFORMATION CORRECT */
             if yn = no then do:
                undo sw_block, leave.
             end.
          end.
        end. /*sw_block*/
              
       hide message no-pause.
       
       if yn = no then undo,retry.   
    end. /*if sel-yn*/
    
    HIDE frame c no-pause.  

  /* Create a New chExcel Application object */
     CREATE "Excel.Application" chExcelApplication.
      chExcelApplication:Visible = TRUE.
     /*Create a new workbook based on the template chExcel file */
   
     chExcelWorkbook = chExcelApplication:Workbooks:ADD( "P:\template\zbinsp.xls").
     chExcelsheet1 = chExcelApplication:worksheets("P1").
     chExcelsheet2 = chExcelApplication:worksheets("P2").
    /* chExcelsheet3 = chExcelApplication:worksheets(Array("p1", "P2")).*/
     chExcelsheet1:Activate.

     /* Set Excel Format Variable.*/
     iHeaderLine = 9.
     iLine = iHeaderLine + 1.
     iHeaderStartLine = 1.
     iTotalLine = iLine.
     iMAXPageLine = 21.
     iFooterLine = 21.

     j = 0.
     FOR EACH aa  WHERE aa_select = "*" NO-LOCK:
         j = j + 1.
     END.
    i = 12.
    k = 7.
    m = 0.
    FOR EACH aa WHERE aa_select = "*" NO-LOCK,
          EACH pod_det WHERE pod_nbr = aa_nbr 
            AND pod_line = aa_line NO-LOCK,
          EACH po_mstr WHERE po_nbr = pod_nbr NO-LOCK:
          FIND FIRST pt_mstr WHERE pt_part = pod_part NO-LOCK NO-ERROR.
          IF AVAIL pt_mstr THEN DESC1 = trim(pt_desc1) + " " + trim(pt_desc2).
          ELSE desc1 = "".
          FIND FIRST vd_mstr WHERE vd_addr = po_vend NO-LOCK NO-ERROR.
          IF AVAIL vd_mstr THEN  vd1 = vd_sort.
          ELSE vd1 = "".
          m = po__dec01 + 1.
          IF j < 4  THEN DO:
        
                   chExcelSheet1:range("O5"):VALUE = pod_nbr + "-" + STRING(m).
                   IF cty = "A" THEN chExcelSheet1:range("C7"):VALUE = "a".
                   IF cty = "B" THEN chExcelSheet1:range("F7"):VALUE = "a".
                   IF cty = "C" THEN chExcelSheet1:range("I7"):VALUE = "a".
                   IF cty = "D" THEN chExcelSheet1:range("L7"):VALUE = "a".
                   IF cty = "E" THEN chExcelSheet1:range("N7"):VALUE = "a".
                   IF cty = "F" THEN chExcelSheet1:range("C9"):VALUE = "a".
                   IF cty = "G" THEN chExcelSheet1:range("I9"):VALUE = "a".
                   IF cty = "H" THEN chExcelSheet1:range("N9"):VALUE = "a".
                    chExcelSheet1:range("D15" ) = po_vend.  /*judy*/
                   chExcelSheet1:range("P15"):VALUE = TODAY.
                   chExcelSheet1:Cells(i, 1 ) = pod_line .
                   chExcelSheet1:Cells(i , 2 ) = pod_part .
                   chExcelSheet1:Cells(i , 7 ) = desc1 .
                   chExcelSheet1:Cells(i, 13 ) = vd1.
                   chExcelSheet1:Cells(i , 16 ) = pod_qty_ord - pod_qty_rcvd.
                   i = i + 1.
            END.
            IF J >= 4 THEN DO:
                chExcelsheet2:Activate.
                chExcelSheet2:Rows(k):Copy. 
                chExcelSheet1:range("O5"):VALUE = pod_nbr + "-" + STRING(m).
                 IF cty = "A" THEN chExcelSheet1:range("C7"):VALUE = "a".
                   IF cty = "B" THEN chExcelSheet1:range("F7"):VALUE = "a".
                   IF cty = "C" THEN chExcelSheet1:range("I7"):VALUE = "a".
                   IF cty = "D" THEN chExcelSheet1:range("L7"):VALUE = "a".
                   IF cty = "E" THEN chExcelSheet1:range("N7"):VALUE = "a".
                   IF cty = "F" THEN chExcelSheet1:range("C9"):VALUE = "a".
                   IF cty = "G" THEN chExcelSheet1:range("I9"):VALUE = "a".
                   IF cty = "H" THEN chExcelSheet1:range("N9"):VALUE = "a". 
                chExcelSheet1:range("P15"):VALUE = TODAY.
                chExcelSheet1:Cells(12 , 2 ) = "请查看材料送检明细清单 " .
                chExcelSheet2:range("O4"):VALUE = pod_nbr + "-" + STRING(m).
                chExcelSheet2:Cells(k, 1 ) = pod_line .
                chExcelSheet2:Cells(k , 2 ) = pod_part .
                chExcelSheet2:Cells(k , 7 ) = desc1 .
                chExcelSheet2:Cells(k, 13 ) = vd1.
                chExcelSheet2:Cells(k , 16 ) = pod_qty_ord - pod_qty_rcvd.
                k = k + 1.
                
                IF k < j + 7 THEN DO: 
                    chExcelSheet2:Rows(k):Insert.   
                    chExcelSheet2:Rows(k):ClearContents.
                END. 
                
            END.

   END.

    FOR EACH aa WHERE aa_select = "*" NO-LOCK,
          EACH pod_det WHERE pod_nbr = aa_nbr 
            AND pod_line = aa_line EXCLUSIVE-LOCK:
        ASSIGN pod__dte01 = TODAY.
    END.
   
    IF j < 4 THEN chExcelsheet1:SELECT.
     
     chExcelWorkbook:SaveAs("c:\insp01.xls",,,,,,1).  
    /* chExcelWorkbook:Worksheets(1):printpreview.*/
     chExcelWorkbook:printpreview.  
    /* close the Excel file */
   /* chExcelWorkbook:CLOSE(FALSE).*/
    chExcelApplication:QUIT.
    /* release com - handles */
    RELEASE OBJECT  chExcelsheet1.
    RELEASE OBJECT  chExcelsheet2. 
    RELEASE OBJECT chExcelWorkbook.
    RELEASE OBJECT chExcelApplication.
   
     OS-DELETE "c:\insp01.xls".  

    ym = YES.
    MESSAGE "是否更新打印次数？" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL              
              TITLE "" UPDATE  ym .   
   IF ym =YES THEN DO:
       FIND FIRST po_mstr WHERE po_nbr = ponbr NO-ERROR.
       IF AVAIL po_mstr THEN ASSIGN po__dec01 = m.

   END.
end.   /* repeat */
/*GUI if global-beam-me-up then undo, leave.*/


