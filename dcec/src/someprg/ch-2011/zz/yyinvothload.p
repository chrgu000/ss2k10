/*zztlupld.p for upload the transfer list created by ATPU into MFG/PRO*/
/*Revision: 8.5f    Last modified: 12/20/2003   By: Kevin*/
/*Revision: 8.5f    Last modified: 12/23/2003   By: Kevin, change qty_pick = 0 to qty_pick = qty_req*/
/*Revision: eb2+sp7 retrofit by tao fengqin   06/22/2005   */
/*Revision: eb2+sp7   Last modified: 08/23/2005   By: judy liu*/

/*display the title*/
{mfdtitle.i "f+"}

def var site as char format "x(20)".
def var site_file as char format "x(40)".
def var src_file as char format "x(40)".


def var i as inte.
def var m as inte.
def var j as inte.
def var v_data as char extent 20.


    define variable sonbr like po_nbr.
    define variable somark as character .
    define variable soqty AS INTE .   
    define variable xxraw as integer label "数据开始行" initial 5 .    
define variable excelapp as com-handle.
define variable excelworkbook as com-handle.
define variable excelsheetmain as com-handle.  
def var conf-yn as logic.
def stream tl.
def var ok_yn as logic.

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 /*tfq site colon 22 sidesc no-label skip(1) */
 src_file colon 22 label "导入文件"
 xxraw    colon 22  label "数据开始行"  skip(1) 
 
 /*  "** 注意该功能要求采购控制文件零件输入为单行模式**" at 5 skip
   "** 供应商维护中税环境设置是正确的** "              at 5 skip     */
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
/*tfq*/   setFrameLabels(frame a:handle) .
repeat:
    DO TRANSACTION ON ERROR UNDO, LEAVE.
      if src_file = "" then src_file = "D:\N-DFL入库计划-101008.XLS".

      UPDATE  src_file xxraw validate(input xxraw > 0 ,"行号小于等于零是不允许的")  with frame a.
     
       IF SEARCH(src_file) = ? THEN DO:
            MESSAGE "错误:导入文件不存在,请重新输入!" view-as alert-box error.
             NEXT-PROMPT src_file WITH FRAME a.
             UNDO, RETRY.
       END.
  
       if substring(src_file , length(src_file) - 3) <> ".xls"  then
       do: 
       MESSAGE "错误:只有EXCEL文件才允许导入,请重新输入!" view-as alert-box error.
             NEXT-PROMPT src_file WITH FRAME a.
             UNDO, RETRY.

       end.
       conf-yn = no.
       message "确认导入" view-as alert-box question buttons yes-no update conf-yn.
       if conf-yn <> yes then undo,retry.
       
       /******************main loop********************/
       /******************input the external transfer list data into a stream**************/

      FOR EACH yyinvoth_det:
          DELETE yyinvoth_det.
      END.

       create "Excel.Application" excelapp.

        excelworkbook = excelapp:workbooks:add(src_file).
        excelsheetmain = excelapp:worksheets("Sheet1").
       
       i = xxraw .
       m = 3 .
       v_data = "".
      
     repeat:    /*asn input repeat*/
           assign   sonbr = excelsheetmain:cells(i,1):TEXT.
                    soqty = excelsheetmain:cells(i,2):TEXT.
                    somark = excelsheetmain:cells(i,3):TEXT.     
            
           IF trim(sonbr) <> "" AND trim(somark) <> "" AND soqty <> 0 THEN DO:
               create  yyinvoth_det .
                    yyinvoth_part = TRIM(sonbr). 
                    yyinvoth_qty = soqty.
                    yyinvoth_mark = TRIM(somark).
               END.           
            
              i = i + 1.

            if trim(sonbr)  = "" then do:
                excelapp:visible = false .
                excelworkbook:close(false).
                excelapp:quit. 
                release object excelapp.
                release object excelworkbook.
                release object excelsheetmain.
                 leave .
             
            END.
        END.
    END.
END.
         




