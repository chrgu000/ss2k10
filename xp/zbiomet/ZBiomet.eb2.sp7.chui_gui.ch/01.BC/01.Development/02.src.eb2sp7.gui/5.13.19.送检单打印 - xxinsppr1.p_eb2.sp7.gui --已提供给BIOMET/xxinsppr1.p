 /**送检单打印   Created by Judy Liu   2006-11-16  Verison: 1**/
 /* LAST MODIFIED: 2008-10-13   BY: QAD-Roger        ECO:*xp001*        */
 /* LAST MODIFIED: 2008-10-20   BY: Biomet-Judy      ECO:*judy*         */
 /* LAST MODIFIED: 2008-12-08   BY: QAD-Roger        ECO:*xp002*        */
 /*-Revision end---------------------------------------------------------------*/

/*xp001*******
1.界面增加合同号,送检时需输入合同号,并保存
2.保存每张送检单的打印记录(合同号,送检单号,PO#,PO项,各项的批号,数量)
3.各项的批号自动产生,格式:日期+流水号+采购方式:  999999-99HC
 ******xp001*/
 /*judy  去掉“外协产品”类型  */
 /*xp002************
 批号产生规则:
 同vend,同rcp_date同part,仅产生同一个批号
 ***********xp002*/ 
 
 {mfdtitle.i}
 define var v_nbr as char format "x(18)" . /*xp001*/  
 define var v_nbr2 as char format "x(12)" . /*xp001*/ 
 define var v_so_job as char . /*xp001*/  
 define var v_id as char . /*xp001*/  
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

define var ii as integer .
define var v1100xp as char format "x(20)" .

 DEF WORKFILE aa
     FIELD aa_nbr LIKE po_nbr
     FIELD aa_line LIKE pod_line
     FIELD aa_part LIKE pod_part 
     FIELD aa_qty_open LIKE pod_qty_ord
     FIELD aa_desc1 LIKE pt_desc1
     FIELD aa_select AS CHAR FORMAT "x(1)"
     field aa_lot as char format "x(18)" /*xp001*/  .

define temp-table temp1 /*今天所有的送检记录*/
    field t1_vend like po_vend 
    field t1_part like pt_part 
    field t1_lot  like ld_lot 
    . /*xp002*/
 
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

    v_nbr2       colon 15  label "送检单号" /*xp001*/  
    ponbr        colon 15  LABEL "采购单号码"
    po_vend      colon 15  label "供应商" ad_name no-label  /*xp001*/
    v_nbr        colon 15  label "合同号" /*xp001*/
    cty     COLON 15 LABEL "材料类型" HELP "请输入材料类型"
    "A)原材料 /  B) 外购产品 /  C)  辅助物资  / D) 外购量具 / E) 外协量具" AT 17
    "F) 外购的装夹具、刀具  / G) 外协的工装夹具、刀具 "   /*judy*/

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

mainloop: 
repeat:
   
   clear frame b no-pause.               
   clear frame c no-pause.                      
    cty = "".

  FOR  EACH aa:
      DELETE aa.
  END.

for each temp1 : delete temp1 . end . /*xp002*/  

/*xp001*********begin*/
PROMPT-FOR  v_nbr2 WITH FRAME a EDITING:
    {mfnp.i xsj_hist v_nbr2 xsj_nbr v_nbr2 xsj_nbr xsj_nbr2 }
    IF recno <> ?  THEN DO:
        DISP xsj_nbr @ v_nbr2  
             xsj_ponbr @  ponbr 
             xsj_ht @ v_nbr
             xsj_cty @ cty 
        with frame a.
        find first po_mstr where po_nbr = xsj_ponbr no-lock no-error .
        if avail po_mstr then do:
            find first ad_mstr where ad_addr = po_vend no-lock no-error .
            if avail ad_mstr then do:
                disp po_vend ad_name with frame a .
            end.
        end.
    END.  /*if recno<> ?*/
END.    /*editing*/
ASSIGN v_nbr2. 

if v_nbr2 <> "" then do:
    find first xsj_hist use-index xsj_nbr where xsj_nbr = v_nbr2 no-lock no-error.
    if not avail xsj_hist then do :
        message "请重新输入正确送检单号,或留空产生新单".
        undo,retry .
    end.

    for each xsj_hist use-index xsj_nbr where xsj_nbr = v_nbr2 no-lock :
        FIND FIRST pt_mstr WHERE pt_part = xsj_part NO-LOCK NO-ERROR.
        CREATE aa.
        ASSIGN aa_nbr = xsj_ponbr
               aa_line  = xsj_line
               aa_part = xsj_part
               aa_desc1 = pt_desc1 WHEN AVAIL pt_mstr
               aa_select = "*" 
               aa_qty_open = xsj_qty 
               aa_lot = xsj_lot .

        assign cty = xsj_cty
               ponbr = xsj_ponbr
               v_nbr = xsj_ht.
    end.



    ii = 0 .
    repeat:
    ii = ii + 1 .
    /*message ii substring(v_nbr2,1,length(v_nbr2) - ii ) substring(v_nbr2,length(v_nbr2) - ii + 1 ,1 ) view-as alert-box.*/
    if ii = length(v_nbr2) or substring(v_nbr2,length(v_nbr2) - ii + 1 ,1 ) = "-" then leave .
    end.
    v1100xp = substring(v_nbr2,length(v_nbr2) - ii + 2 ,ii - 1 )  .



end. /*if v_nbr2 <> "" */
else do: /*if v_nbr2 = "" */
    clear frame a no-pause. 
    v_nbr2 = "" .
    v_nbr = "" .
    ponbr = "" .
    cty = "a" .

/*所有已产生的批号**xp002*/  
for each xsj_hist where xsj_date = today no-lock ,
    each po_mstr where po_nbr = xsj_ponbr no-lock: 
    find first temp1 where t1_vend = po_vend and t1_part = xsj_part no-error .
    if not avail temp1 then do:
        create temp1 .
        assign  t1_vend = po_Vend 
                t1_part = xsj_part 
                t1_lot  = xsj_lot 
                .
    end.
    
end. /*for each xsj_hist*/

looppo:
do on error undo,retry:
/*xp001***********end*/ 


        PROMPT-FOR  ponbr WITH FRAME a EDITING:

            /*{mfnp06.i po_mstr po_nbr "po_stat = ''"  ponbr  ponbr ponbr ponbr } *xp001*/
            {mfnp01.i po_mstr ponbr po_nbr  """" po_stat po_nbr } /*xp001*/  
            IF recno <> ?  THEN DO:
                DISP  po_nbr @  ponbr with frame a.

                find first ad_mstr where ad_addr = po_vend no-lock no-error .
                if avail ad_mstr then do:
                    disp po_vend ad_name with frame a .
                end. /*xp001*/
            END.  /*if recno<> ?*/
            /*status input.
            readkey.
            apply lastkey.*/

        END.    /*editing*/

        ASSIGN ponbr. 
 
     
   

         find  first pod_det no-lock where pod_nbr = ponbr and pod_status = ""  no-error.
         if  not available pod_det then do:
                     message "采购单不存在或已结，请重新输入！".
                     next-prompt ponbr.
                     undo, retry.
         end.
         if available pod_det then do:
                disp pod_nbr @ ponbr with frame a.
                find first po_mstr where po_nbr = pod_nbr no-lock no-error .
                if avail po_mstr then do:
                    find first ad_mstr where ad_addr = po_vend no-lock no-error .
                    if avail ad_mstr then do:
                        disp po_vend ad_name with frame a .
                    end.
                end.

                for each pod_det where pod_nbr = ponbr  and pod_status = ""   no-lock :
                    find first pt_mstr where pt_part = pod_part  no-lock no-error .
                    if avail pt_mstr then do:
                        if pt_lot_Ser <> "L" and pt_prod_line <> "T000" then do:
                            
                            message "零件的'批次控制'设定有误,请联系仓库修改.      " skip
                                    "采购单:" pod_nbr  " 项:" pod_line skip
                                    "项目号:" pod_part "产品线:" pt_prod_line "  批次控制:否" skip 
                            view-as alert-box .
                            undo looppo,retry looppo .
                        end.
                    end.
                    else do:
                        /*非库存件*/
                    end.
                end.

         end.

        /*xp001*********begin*/
        find last xsj_hist use-index xsj_nbr 
            where xsj_nbr begins pod_nbr 
            and xsj_line = pod_line
        no-lock no-error .
        if avail xsj_hist then v_nbr = xsj_ht .
        else do:
            find last xsj_hist use-index xsj_nbr 
                where xsj_nbr begins pod_nbr 
            no-lock no-error .
            if avail xsj_hist then v_nbr = xsj_ht .           
        end.

        do on error undo,retry:
            update v_nbr with frame a .
            /*if v_nbr = "" then do:
                MESSAGE "合同号不允许为空，请重新输入！".
                next-prompt v_nbr.
                undo, retry.
            end.*/
        end.
        /*xp001***********end*/ 

      /* UPDATE cty validate(lookup(cty,"a,b,c,d,e,f,g,h") > 0,"错误代号")judy*/
     UPDATE cty validate(lookup(cty,"a,b,c,d,e,f,g") > 0,"错误代号") /*judy*/
                sel-yn WITH FRAME a.

       FOR EACH  pod_det WHERE pod_nbr = ponbr and index( "XC",pod_status ) = 0 NO-LOCK:
           FIND FIRST pt_mstr WHERE pt_part = pod_part NO-LOCK NO-ERROR.
           FIND FIRST aa WHERE aa_nbr = pod_nbr AND aa_line = pod_line NO-LOCK NO-ERROR.
           IF NOT AVAIL aa THEN   DO:
               CREATE aa.
               ASSIGN aa_nbr = pod_nbr
                           aa_line  = pod_line
                           aa_part = pod_part
                           aa_desc1 = pt_desc1 WHEN AVAIL pt_mstr
                           aa_select = "*" WHEN NOT sel-yn 
                           aa_qty_open = pod_qty_ord - pod_qty_rcvd
                           aa_lot = "" /*xp001*/  .

           END.
       END. 
 
    
    if sel-yn then do:     
         yn = no.
           
         sw_block:
         /*do transaction: /*on endkey undo, leave:*/ *xp001*/  
         do on endkey undo, leave: /*xp001*/  
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
end.  /*looppo*/  


   /*xp001*********begin*/
   v_id = "00" .
   find last xsj_hist use-index xsj_date_lot where xsj_date = today exclusive-lock no-error .  /*独占锁定,以避免多人同时取号*/
   if not avail xsj_hist then do:
       v_id   = "00" .
   end.
   else do:
       if xsj_lot = "" then do:
            v_id = "00" .
       end.
       else do:
           if substring(xsj_lot,8,1) >= "0" 
              and substring(xsj_lot,8,1) <= "9" 
              and substring(xsj_lot,9,1) >= "0" 
              and substring(xsj_lot,9,1) <= "9" 
           then do:
                v_id  = string(integer(substring(xsj_lot,8,2)) ,"99") .
           end.
           else v_id = "XX" .
       end.
   end. 

   /*message "最后笔流水号:" v_id view-as alert-box. */
   /*xp001***********end*/     

end.  /*if v_nbr2 = "" */ /*xp001*/  

  /* Create a New chExcel Application object */
     CREATE "Excel.Application" chExcelApplication.
      chExcelApplication:Visible = TRUE.
     /*Create a new workbook based on the template chExcel file */
   
    chExcelWorkbook = chExcelApplication:Workbooks:ADD( "P:\template\qadzbinsp.xls"). /*chExcelWorkbook = chExcelApplication:Workbooks:ADD( "P:\template\zbinsp.xls"). *xp001*/  
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
          /*m = po__dec01 + 1.**xp001*/  
          m = if v_nbr2 = "" then po__dec01 + 1 else integer(v1100xp) . /*xp001*/  
               /*xp001*********begin*/
                   if v_nbr2 = "" and pt_lot_ser = "L" then do:
                       find first temp1 where t1_vend = po_vend and t1_part = aa_part no-error . /*xp002*/  
                       if avail temp1 then do: /*xp002*/  
                           aa_lot = t1_lot .
                       end. /*xp002*/  
                       else do: /*xp002*/  
                           if v_id <> "XX" then v_id = string(integer(v_id) + 1 ,"99").
                           v_so_job = if length(pod_so_job) < 2 then "XX" else substring(trim(pod_so_job),1,2) .
                           aa_lot = substring(string(YEAR(TODAY),"9999"),3,2)
                                    + string(month(TODAY),"99")
                                    + string(day(TODAY),"99")
                                    + "-"
                                    + v_id
                                    + v_so_job .

                           create temp1 .   /*xp002*/ 
                           assign  t1_vend = po_vend 
                                   t1_part = aa_part 
                                   t1_lot  = aa_lot 
                                   .
                       end.  /*xp002*/  
                   end.
               /*xp001***********end*/           
          IF j < 4  THEN DO:
                   chExcelSheet1:range("A5"):VALUE = "*" + pod_nbr + "-" + STRING(m) + "*". /*xp001*/  
                   chExcelSheet1:range("H5"):VALUE = "'" + v_nbr . /*xp001*/  
                   chExcelSheet1:range("O5"):VALUE = "'" + pod_nbr + "-" + STRING(m).
                   IF cty = "A" THEN chExcelSheet1:range("C7"):VALUE = "a".
                   IF cty = "B" THEN chExcelSheet1:range("F7"):VALUE = "a".
                   IF cty = "C" THEN chExcelSheet1:range("I7"):VALUE = "a".
                   IF cty = "D" THEN chExcelSheet1:range("L7"):VALUE = "a".
                   IF cty = "E" THEN chExcelSheet1:range("N7"):VALUE = "a".
                   IF cty = "F" THEN chExcelSheet1:range("C9"):VALUE = "a".
                   IF cty = "G" THEN chExcelSheet1:range("I9"):VALUE = "a".
                 /*  IF cty = "H" THEN chExcelSheet1:range("N9"):VALUE = "a". judy*/
                    chExcelSheet1:range("D15" ) = "'" + po_vend.  /*judy*/
                   chExcelSheet1:range("P15"):VALUE = TODAY.
                   chExcelSheet1:Cells(i, 1 ) = pod_line .
                   chExcelSheet1:Cells(i , 2 ) = "'" + pod_part .
                   chExcelSheet1:Cells(i , 7 ) = "'" + desc1 .
                   chExcelSheet1:Cells(i , 11 ) = "'" + aa_lot . /*xp001*/  
                   chExcelSheet1:Cells(i, 13 ) = "'" + vd1.
                   chExcelSheet1:Cells(i , 16 ) = "'" + pod_so_job . /*xp001*/  
                   chExcelSheet1:Cells(i , 17 ) = aa_qty_open . /*xp001*/  
                   /*chExcelSheet1:Cells(i , 16 ) = pod_qty_ord - pod_qty_rcvd. */ /*xp001*/  
                   i = i + 1.
            END.
            IF J >= 4 THEN DO:
                chExcelsheet2:Activate.
                chExcelSheet2:Rows(k):Copy. 

                chExcelSheet2:range("A4"):VALUE = "*" + pod_nbr + "-" + STRING(m) + "*". /*xp001*/  
                chExcelSheet2:range("H4"):VALUE = "'" + v_nbr . /*xp001*/  
                chExcelSheet2:range("O4"):VALUE = "'" + pod_nbr + "-" + STRING(m). /*xp001*/  

                chExcelSheet1:range("A5"):VALUE = "*" + pod_nbr + "-" + STRING(m) + "*". /*xp001*/                 
                chExcelSheet1:range("H5"):VALUE = "'" + v_nbr . /*xp001*/  
                chExcelSheet1:range("O5"):VALUE = "'" + pod_nbr + "-" + STRING(m). /*xp001*/  
                
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
                chExcelSheet2:range("O4"):VALUE = "'" + pod_nbr + "-" + STRING(m).
                chExcelSheet2:Cells(k, 1 ) =  pod_line .
                chExcelSheet2:Cells(k , 2 ) = "'" + pod_part .
                chExcelSheet2:Cells(k , 7 ) = "'" + desc1 .
                chExcelSheet2:Cells(k , 11 ) = "'" + aa_lot . /*xp001*/  
                chExcelSheet2:Cells(k, 13 ) = "'" + vd1.
                chExcelSheet2:Cells(k , 16 ) = "'" + pod_so_job . /*xp001*/  
                chExcelSheet2:Cells(k , 17 ) = aa_qty_open . /*xp001*/  
                /*chExcelSheet2:Cells(k , 16 ) = pod_qty_ord - pod_qty_rcvd. */ /*xp001*/  
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
     
     chExcelWorkbook:SaveAs("c:\qadinsp01.xls",,,,,,1).  
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
   
     OS-DELETE "c:\qadinsp01.xls". 
    if v_nbr2 = "" then do: /*xp001*/  
        find first aa 
            where aa_lot <> "" and (substring(aa_lot,8,2) = "XX" or substring(aa_lot,10,2) = "XX" )
        no-lock no-error .
        if avail aa then do:  /*not_update*/
            message "送检单错误,不更新送检单!" skip 
                    "批号异常: " aa_lot  view-as alert-box.
            undo,retry .
        end.  /*not_update*/
        else do: /*update*/
               ym = YES.
               MESSAGE "是否更新打印次数？" VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL              
                          TITLE "" UPDATE  ym .   
               IF ym =YES THEN DO:
                   FIND FIRST po_mstr WHERE po_nbr = ponbr NO-ERROR.
                   IF AVAIL po_mstr THEN ASSIGN po__dec01 = m.

                    /*xp001*********begin*/
                    for each aa where aa_select = "*" NO-LOCK,
                    each pod_det where pod_nbr = aa_nbr and pod_line = aa_line no-lock:
                        create xsj_hist .
                        assign 
                            xsj_nbr = pod_nbr + "-" + STRING(m)
                            xsj_line = pod_line
                            xsj_ponbr = pod_nbr 
                            xsj_part  = pod_part
                            xsj_ht    = v_nbr 
                            xsj_qty   = aa_qty_open
                            xsj_lot   = aa_lot 
                            xsj_user  = global_userid
                            xsj_date  = today 
                            xsj_time  = time 
                            xsj_cty   = cty
                            .
                    end.
                    disp ponbr + "-" + STRING(m) @ v_nbr2 with frame a .
                    /*xp001***********end*/ 
               END.
        end.  /*update*/
    end. /*if v_nbr2 = "" then do:*/ /*xp001*/  
end.   /* repeat */
/*GUI if global-beam-me-up then undo, leave.*/


