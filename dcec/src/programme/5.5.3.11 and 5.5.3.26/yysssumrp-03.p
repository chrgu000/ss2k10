/*yysssumrp.p for 零件需求预测汇总报表打印（也即采购计划单打印），writed by Kevin,2003/11*/
/*Last modified: 01/14/2004, By: Kevin for adding the tolerance according to Zhaotao*/
/*Last modified: 08/04/2008, By: Philips for merging excel of the same person but different buyer*/

         /* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*GI32*/ {mfdtitle.i "E"}

def var site like si_site.
def var site1 like si_site.
def var vend like vd_addr.
def var vend1 like vd_addr.
def var buyer like ptp_buyer.
def var buyer1 like ptp_buyer.
def var part like pt_part.
def var part1 like pt_part.
def new shared var start like ps_start label "汇总起始日期".
def var outpath as char format "x(40)" label "输出目录".
def var testdir as char.
def var i as inte.
/*phi*/DEF VAR tempname AS CHAR FORMAT "x(18)".
/*phi*/DEF VAR tempbuyer LIKE ptp_buyer.


def new shared var sdate as date extent 7.
def new shared var edate as date extent 7.

/*workfile key index: buyer + vend + part*/
def workfile xxwk
/*phi*/   FIELD cname AS CHAR FORMAT "x(18)"
/*phi*/   FIELD buyer1 LIKE ptp_buyer
   field buyer like ptp_buyer
   field vend like vd_addr
   field part like pt_part
   field desc1 like pt_desc1
   field qty_ord like tr_qty_loc extent 7
   field qty_pack like tr_qty_loc
   field loc like loc_loc
   field nbr like pod_nbr
   field rlse_id like schd_rlse_id
   field site like si_site
   FIELD ptstatus LIKE pt_status.

def var up_yn as logic.

def var tol_per as inte format ">>9%".

/* define Excel object handle */
DEFINE NEW SHARED VARIABLE chExcelApplication AS COM-HANDLE.
/*DEFINE VARIABLE chExcelWorksheet AS COM-HANDLE.*/
DEFINE NEW SHARED VARIABLE chExcelWorkbook AS COM-HANDLE.
/*Define Sheet Variavble*/
DEFINE VARIABLE iLine AS INTEGER.
DEFINE VARIABLE iTotalLine AS INTEGER.
DEFINE VARIABLE iHeaderLine AS INTEGER.
DEFINE VARIABLE iHeaderStartLine AS INTEGER.
DEFINE VARIABLE iMAXPageLine AS INTEGER.
DEFINE VARIABLE iFooterLine AS INTEGER.
DEFINE VARIABLE iPageNum AS INTEGER.
DEFINE VARIABLE iLoop1 AS INTEGER.


form
   RECT-FRAME       AT ROW 1 COLUMN 1.25
   RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
   SKIP(1)  /*GUI*/
   site colon 22        site1 colon 45 label {t001.i}
   vend colon 22        vend1 colon 45 label {t001.i}
   buyer colon 22       buyer1 colon 45 label {t001.i}
   part colon 22        part1 colon 45 label {t001.i} skip(1)
   tol_per colon 22 label "容差百分比"
   start colon 22 skip(1)
   outpath colon 22
   skip (1)
   with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

   DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
   RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
   RECT-FRAME-LABEL:HIDDEN in frame a = yes.
   RECT-FRAME:HEIGHT-PIXELS in frame a =
   FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
   RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
setframelabels(frame a:handle) .
repeat:
    
    start = today.
    outpath = "c:\Purchase plan".
    
    if site1 = hi_char then site1 = "".
    if vend1 = hi_char then vend1 = "".
    if buyer1 = hi_char then buyer1 = "".
    if part1 = hi_char then part1 = "".
    
    update site site1 vend vend1 buyer buyer1 part part1 tol_per start outpath with frame a.
    
    if site1 = "" then site1 = hi_char.
    if vend1 = "" then vend1 = hi_char.
    if buyer1 = "" then buyer1 = hi_char.
    if part1 = "" then part1 = hi_char.
    
/*J034*/       if not batchrun then do:
/*J034*/          {gprun.i ""gpsirvr.p""
                   "(input site, input site1, output return_int)"}
/*J034*/          if return_int = 0 then do:
/*J034*/             next-prompt site with frame a.
/*J034*/             undo, retry.
/*J034*/          end.
/*J034*/       end.

    /*verify whether the output path is existing*/    
    if outpath = "" then do:
          message "目录不允许为空,请重新输入!" view-as alert-box error.
          next-prompt outpath with frame a.
          undo,retry.
    end.
    
    testdir = outpath + "\testdir".
    OS-CREATE-DIR value(testdir).
    if OS-ERROR <> 0 then do:
          message "目录不存在,请重新输入!" view-as alert-box error.
          next-prompt outpath with frame a.
          undo,retry.
    end.
    OS-DELETE value(testdir).
     /*end verify the output path*/
    
    up_yn = yes.
   message "确认更新" view-as alert-box question buttons yes-no update up_yn.
   if not up_yn then undo,retry.

   /*search the template file*/
   /*if search("\\dcecssy006\dcec_erp\kevin\template\PO planning form template.xlt") = ? then do:*/
  if search("\\qadtemp\appeb2\template\purchase\PO planning form template.xlt") = ? then do: 
      message "报表模板不存在!" view-as alert-box error.
      undo,retry.
   end.
    
     /*create period*/
     {gprun.i ""yysspdcal.p""}

    
    for each xxwk:
       delete xxwk.
    end. 
    
    for each pod_det where (pod_site >= site and pod_site <= site1)
                       and (pod_part >= part and pod_part <= part1) no-lock,
        each po_mstr where po_nbr = pod_nbr
                       and po_sched
                       and (po_vend >= vend and po_vend <= vend1) no-lock,
        each pt_mstr where pt_part = pod_part no-lock,
  /*phi      each ptp_det where ptp_site = pod_site
                       and ptp_part = pt_part 
                       and (ptp_buyer >= buyer and ptp_buyer <= buyer1) no-lock,*/
        each schd_det where schd_type = 4
                     and schd_rlse_id = pod_curr_rlse_id[1] 
                       and schd_nbr = pod_nbr 
                       and schd_line = pod_line 
                       and schd_discr_qty > 0
                       and (schd_date >= start and schd_date <= start + 100) no-lock:              /*kevin*/
        /*break by ptp_buyer by po_vend:*/
  
        FOR  each ptp_det where ptp_site = pod_site
                       and ptp_part = pt_part 
                       and (ptp_buyer >= buyer and ptp_buyer <= buyer1) no-lock:
      
   
/*phi*/ FIND FIRST code_mstr WHERE code_fldname = "ptp_buyer" AND code_value = ptp_buyer NO-LOCK NO-ERROR.
        find first xxwk where xxwk.buyer = ptp_buyer
                         and xxwk.vend = po_vend
                         and xxwk.site = pod_site
                         and xxwk.nbr = pod_nbr
                         and xxwk.part = pod_part no-error.
        if not available xxwk then do:
              create xxwk.
              assign xxwk.buyer = ptp_buyer
/*phi*/              xxwk.buyer1 = ptp_buyer
/*phi*/              xxwk.cname = substr(code_cmmt,index(code_cmmt,",") + 1,length(code_cmmt,"raw") - index(code_cmmt,","),"raw")
                     xxwk.vend = po_vend
                     xxwk.part = pod_part
                     xxwk.desc1 = pt_desc2              /*chinese description*/
                     xxwk.qty_pack = pod_ord_mult
                     xxwk.loc = pod_loc
                     xxwk.nbr = pod_nbr
                     xxwk.rlse_id = schd_rlse_id
                     xxwk.site = pod_site
                     xxwk.ptstatus = pt_status.
        end.
        
        Do i = 1 to 7:
             if schd_date >= sdate[i] and schd_date <= edate[i] then do:
                assign xxwk.qty_ord[i] = xxwk.qty_ord[i] + schd_discr_qty.
             end.
        end.
          
        END.

        RELEASE xxwk.

        FOR each ptp_det where ptp_site = pod_site
                       and ptp_part = pt_part no-lock:
        FIND FIRST code_mstr WHERE code_fldname = "ptp_buyer" AND code_value = ptp_buyer NO-LOCK NO-ERROR.
        IF AVAIL code_mstr THEN DO:
            tempbuyer = code_value.
            tempname = substr(code_cmmt,index(code_cmmt,",") + 1,length(code_cmmt,"raw") - index(code_cmmt,","),"raw").
            FIND FIRST code_mstr WHERE tempname = substr(code_cmmt,index(code_cmmt,",") + 1,length(code_cmmt,"raw") - index(code_cmmt,","),"raw") 
                                       AND code_fldname = "ptp_buyer" AND code_value >= buyer AND code_value <= buyer1 
                                       AND code_value <> tempbuyer NO-LOCK NO-ERROR.
            IF AVAIL code_mstr THEN DO:
       
            find first xxwk where xxwk.buyer = ptp_buyer
                         and xxwk.vend = po_vend
                         and xxwk.site = pod_site
                         and xxwk.nbr = pod_nbr
                         and xxwk.part = pod_part no-error.
        if not available xxwk then do:
              create xxwk.
              assign xxwk.buyer = ptp_buyer
/*phi*/              xxwk.buyer1 = code_value
/*phi*/              xxwk.cname = substr(code_cmmt,index(code_cmmt,",") + 1,length(code_cmmt,"raw") - index(code_cmmt,","),"raw")
                     xxwk.vend = po_vend
                     xxwk.part = pod_part
                     xxwk.desc1 = pt_desc2              /*chinese description*/
                     xxwk.qty_pack = pod_ord_mult
                     xxwk.loc = pod_loc
                     xxwk.nbr = pod_nbr
                     xxwk.rlse_id = schd_rlse_id
                     xxwk.site = pod_site
                     xxwk.ptstatus = pt_status.
        end.
        
        Do i = 1 to 7:
             if schd_date >= sdate[i] and schd_date <= edate[i] then do:
                assign xxwk.qty_ord[i] = xxwk.qty_ord[i] + schd_discr_qty.
             end.
        end.
        IF AVAIL xxwk THEN DO:
            IF code_value <= xxwk.buyer THEN xxwk.buyer1 = code_value.
        END.
            END.
        END.
        END.

   
    end. /*for each pod_det, each ...*/
        

     /*Begin to create the PO　palnning order by vendor*/

     /* Create a New chExcel Application object */
     CREATE "Excel.Application" chExcelApplication.

/*     for each xxwk no-lock break by xxwk.buyer by xxwk.vend by xxwk.nbr by xxwk.part by xxwk.site:  */
/*phi*/    for each xxwk no-lock break by xxwk.cname by xxwk.vend by xxwk.nbr by xxwk.part by xxwk.site:
    
        i = i + 1.
        
       if first-of(xxwk.nbr) then do:
                  
         /*Create a new workbook based on the template chExcel file */
         /*chExcelWorkbook = chExcelApplication:Workbooks:ADD("\\dcecssy006\dcec_erp\kevin\template\PO planning form template.xlt").*/
        chExcelWorkbook = chExcelApplication:Workbooks:ADD("\\qadtemp\appeb2\template\purchase\PO planning form template.xlt"). 
         /* Set Excel Format Variable.*/
         iHeaderLine = 18.
         iLine = iHeaderLine + 1.
         iHeaderStartLine = 1.
         iTotalLine = iLine.
         iMAXPageLine = 42.
         iFooterLine = 42.
         iPageNum = 1.

         /*chExcelApplication:visible = true.*/
           
           i = 1.
           
           chExcelWorkbook:worksheets(1):cells(5,"V"):value = xxwk.rlse_id.
           chExcelWorkbook:worksheets(1):cells(6,"V"):value = xxwk.nbr.
           chExcelWorkbook:worksheets(1):cells(7,"V"):value = today.
           
           chExcelWorkbook:worksheets(1):cells(9,"D"):value = xxwk.vend.
           find first ad_mstr where (ad_type = "supplier" or ad_type = "vendor")
                              and ad_addr = xxwk.vend no-lock no-error.
           if available ad_mstr then do:
              chExcelWorkbook:worksheets(1):cells(10,"D"):value = ad_name.
              chExcelWorkbook:worksheets(1):cells(11,"E"):value = ad_line1 + " \ " + ad_zip.
              chExcelWorkbook:worksheets(1):cells(13,"D"):value = ad_attn.
              chExcelWorkbook:worksheets(1):cells(14,"D"):value = ad_phone.
              chExcelWorkbook:worksheets(1):cells(15,"D"):value = ad_fax.
           end.
           
           find vd_mstr where vd_addr = xxwk.vend no-lock no-error.
         if available vd_mstr then 
             chExcelWorkbook:worksheets(1):cells(16,"D"):value = vd_rmks.
           
/*phi           find code_mstr where code_fldname = "ptp_buyer" and code_value = xxwk.buyer no-lock no-error.
           if available code_mstr then do:    */
               chExcelWorkbook:worksheets(1):cells(13,"V"):value = 
/*phi          substr(code_cmmt,index(code_cmmt,",") + 1,length(code_cmmt,"raw") - index(code_cmmt,","),"raw").*/
/*phi*/            xxwk.cname.   
               find emp_mstr where emp_addr = xxwk.buyer no-lock no-error.
               if available emp_mstr then do:
                     chExcelWorkbook:worksheets(1):cells(14,"V"):value = emp_bs_phone. /* + ",转: " + emp_ext.*/ /*kevin*/
                     chExcelWorkbook:worksheets(1):cells(16,"V"):value = emp_line3.     
               end.
/*phi           end.   */                                         
           
           find usr_mstr where usr_userid = global_userid no-lock no-error.
           if available usr_mstr then do:
                 chExcelWorkbook:worksheets(1):cells(17,"J"):value = usr_name.
           end.
           
           /*display the period information*/
           chExcelWorkbook:worksheets(1):cells(18,"K"):value = sdate[1].
           chExcelWorkbook:worksheets(1):cells(18,"M"):value = sdate[2].
           chExcelWorkbook:worksheets(1):cells(18,"O"):value = sdate[3].
           chExcelWorkbook:worksheets(1):cells(18,"Q"):value = sdate[4].
           chExcelWorkbook:worksheets(1):cells(18,"S"):value = sdate[5].
           chExcelWorkbook:worksheets(1):cells(18,"U"):value = string(month(sdate[6])) + "月预测".
           chExcelWorkbook:worksheets(1):cells(18,"W"):value = string(month(sdate[7])) + "月预测".
           
       end. /*if first-of(xxwk.vend)*/

         if not first-of(xxwk.nbr) /*and not last-of(xxwk.nbr)*/ then do:
            chExcelWorkbook:worksheets(1):rows(itotalline):insert.
            chExcelWorkbook:worksheets(1):rows(itotalline + 1):copy.
            chExcelWorkbook:worksheets(1):cells(itotalline,1):select.
            chExcelWorkbook:worksheets(1):paste.
         end. 
         /*
         ELSE DO:
            IF LAST(xxwk.nbr) THEN DO:
                IF FIRST(xxwk.nbr) THEN DO:
                    chExcelWorkbook:Worksheets(1):Rows(iTotalLine + 1):DELETE.
                END.  
                ELSE DO:
                    chExcelWorkbook:Worksheets(1):Rows(iTotalLine):DELETE.
                END.  
            END.
         END.           
        */

         IF iLine > iMAXPageLine THEN DO:
             DO iLoop1 = 1 TO 6:
                 chExcelWorkbook:Worksheets(1):Rows(iTotalLine):INSERT.
             END.
             chExcelWorkbook:Worksheets(1):Range("A" + string(iTotalLine + 8) + ":AB" +  string(iTotalLine + 13)):COPY.
             chExcelWorkbook:Worksheets(1):Cells(iTotalLine,1):SELECT.
             chExcelWorkbook:Worksheets(1):Paste.
             iTotalLine = iTotalLine + 6.
             iLine = iHeaderLine + 1.
         END.
               
        chExcelWorkbook:worksheets(1):cells(itotalline,"A"):value = i.
        chExcelWorkbook:worksheets(1):cells(itotalline,"B"):value = xxwk.part.
        chExcelWorkbook:worksheets(1):cells(itotalline,"F"):value = xxwk.desc1.
        chExcelWorkbook:worksheets(1):cells(itotalline,"K"):value = round(xxwk.qty_ord[1] * (100 + tol_per) / 100,0).
        chExcelWorkbook:worksheets(1):cells(itotalline,"M"):value = round(xxwk.qty_ord[2] * (100 + tol_per) / 100,0).
        chExcelWorkbook:worksheets(1):cells(itotalline,"O"):value = round(xxwk.qty_ord[3] * (100 + tol_per) / 100,0).
        chExcelWorkbook:worksheets(1):cells(itotalline,"Q"):value = round(xxwk.qty_ord[4] * (100 + tol_per) / 100,0).
        chExcelWorkbook:worksheets(1):cells(itotalline,"S"):value = round(xxwk.qty_ord[5] * (100 + tol_per) / 100,0).
        chExcelWorkbook:worksheets(1):cells(itotalline,"U"):value = round(xxwk.qty_ord[6] * (100 + tol_per) / 100,0).
        chExcelWorkbook:worksheets(1):cells(itotalline,"W"):value = round(xxwk.qty_ord[7] * (100 + tol_per) / 100,0).
        chExcelWorkbook:worksheets(1):cells(itotalline,"Y"):value = xxwk.qty_pack.
        /*chExcelWorkbook:worksheets(1):cells(itotalline,"AA"):value = xxwk.loc.*/
        chExcelWorkbook:worksheets(1):cells(itotalline,"AA"):value = xxwk.site.       /*kevin,12/1/2003*/
        chExcelWorkbook:worksheets(1):cells(itotalline,"AC"):value = xxwk.ptstatus.       /*kevin,12/1/2003*/
        iline = iline + 1.
        itotalline = itotalline + 1.

        if last-of(xxwk.nbr) then do:

            DO iLoop1 = 1 TO iMAXPageLine - iLine + 1:
                chExcelWorkbook:Worksheets(1):Rows(iTotalLine):INSERT.
                chExcelWorkbook:Worksheets(1):Rows(iTotalLine + 1):COPY.
                chExcelWorkbook:Worksheets(1):Rows(iTotalLine):SELECT.
                chExcelWorkbook:Worksheets(1):Paste.
                iTotalLine = iTotalLine + 1.
            END.
        
            chExcelWorkbook:Worksheets(1):Rows(iTotalLine):DELETE.


           /* save the new chExcel data workbook file */ 
/*phi        chExcelWorkbook:SaveAs(outpath + "\" + xxwk.buyer + "-" + xxwk.vend + "-" + xxwk.nbr + "-" + xxwk.rlse_id + ".xls",,,,,,1).*/
/*phi*/      chExcelWorkbook:SaveAs(outpath + "\" + xxwk.buyer1 + "-" + xxwk.vend + "-" + xxwk.nbr + "-" + xxwk.rlse_id + ".xls",,,,,,1).
             chExcelWorkbook:CLOSE.
             RELEASE OBJECT chExcelWorkbook.
        end.
         
     end. /*for each xxwk*/ 

     /* close the Excel file */
     chExcelApplication:QUIT.
     /* release com - handles */
     RELEASE OBJECT chExcelApplication.
     /*End of creation*/                  
        
end. /*repeat*/
