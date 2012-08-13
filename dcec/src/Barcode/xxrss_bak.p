{mfdtitle.i}
DEFINE VAR vendor LIKE vd_addr.

DEFINE VAR vendor1 LIKE vd_addr.
DEFINE VAR part LIKE pt_part.
DEFINE VAR part1 LIKE pt_part.
DEFINE VAR rlse_dt AS DATE.
DEFINE VAR rlse_dt1 AS DATE.
DEFINE VAR m_intime_qty LIKE tr_qty_loc.
DEFINE VAR m_nontime_qty LIKE tr_qty_loc.
DEFINE VAR shre_date LIKE schd_date.
DEFINE VAR iscal AS LOGICAL.
DEFINE VAR shre_pre_range AS INT.
DEFINE VAR shre_delay_range AS INT.
DEFINE VAR BACK_qty LIKE tr_qty_loc.
DEFINE VAR rec_date LIKE tr_date.
DEF  VAR chExcelApplication   AS COM-HANDLE.
DEF  VAR chWorkbook           AS COM-HANDLE.
DEF  VAR chWorksheet          AS COM-HANDLE.
/*DEF  VAR chWorksheetRange     AS COM-HANDLE.*/
DEF VAR rowstart AS INT.
DEF VAR oktocomt AS LOGICAL.
DEFINE VAR crange AS CHAR.
DEF VAR isfind AS LOGICAL.
DEF TEMP-TABLE M_SCH_REC FIELD M_VEND LIKE po_vend
    FIELD M_PART LIKE pt_part
    FIELD M_DESC AS CHAR FORMAT "x(48)"
    FIELD M_DRAW LIKE pt_draw
    FIELD M_PERIOD LIKE pt_ord_per
    FIELD M_RLSE_id LIKE schd_rlse_id 
    FIELD M_DUE_date LIKE schd_date
    FIELD M_REC_DATE LIKE tr_date
    FIELD M_RLSE_QTY LIKE schd_discr_qty
    FIELD M_OT_QTY LIKE tr_qty_loc
    FIELD M_DE_QTY LIKE tr_qty_loc
    FIELD M_BACK_QTY LIKE tr_qty_loc
    FIELD M_PO_NBR LIKE pod_nbr
    FIELD M_VEN_NAME LIKE ad_name.

FORM  
 SKIP(0.5)
    vendor COLON 10 LABEL "供应商"
    vendor1 COLON 45 LABEL "至"
    SKIP(0.5)
    part COLON 10 LABEL "零件号"
    part1 COLON 45 LABEL "至"
    SKIP(0.5)
rlse_dt COLON 10 LABEL "下达日"
    rlse_dt1 COLON 45 LABEL "下达日"
    WITH FRAME a WIDTH 80 THREE-D SIDE-LABEL.
/*DEFINE FRAME out
    po_vend COLON 12 COLUMN-LABEL "供应商"
    pod_part COLUMN-LABEL "产品代码"
    pt_desc1 COLUMN-LABEL "产品名称"
    pt_draw COLUMN-LABEL "图号"
    pt_ord_per COLUMN-LABEL "采购周期"
    schd_rlse_id COLUMN-LABEL "下达号"
    schd_date COLUMN-LABEL "应到日期"
    rec_date COLUMN-LABEL "实交日期"
    schd_discr_qty COLUMN-LABEL "下达数"
    m_intime_qty COLUMN-LABEL "准时实交数"
    m_nontime_qty COLUMN-LABEL "滞后实交数"
    back_qty COLUMN-LABEL "未交数"
    shre_range COLUMN-LABEL "允许误差天数"
    WITH WIDTH 180 STREAM-IO DOWN NO-ATTR-SPACE.*/
REPEAT:
    IF rlse_dt = low_date THEN rlse_dt = ?.
    IF rlse_dt1 = hi_date THEN rlse_dt1 = ?.
    
    SET vendor vendor1 part part1 rlse_dt rlse_dt1 WITH FRAME a.
   /*{mfselbpr.i "printer" 80}  */
     MESSAGE "确认将报表导出吗" SKIP(1)
        "继续?"
        VIEW-AS ALERT-BOX
        QUESTION
        BUTTON YES-NO
        UPDATE oktocomt.
 
    IF oktocomt THEN
    DO:  
    IF vendor1 =''  THEN vendor1 = hi_char.
   
    IF part1 = '' THEN part1 = hi_char.
    IF rlse_dt = ? THEN rlse_dt = low_date.
    IF rlse_dt1 = ? THEN rlse_dt1 = hi_date.

     hide message no-pause.
     
      
    FOR EACH po_mstr WHERE po_vend >= vendor AND po_vend <= vendor1 NO-LOCK:
   
       FOR EACH pod_det WHERE pod_nbr = po_nbr AND pod_part >= part AND pod_part <= part1 NO-LOCK:
       
    FOR EACH sch_mstr WHERE sch_cr_date >= rlse_dt AND sch_cr_date <= rlse_dt1 AND sch_nbr = pod_nbr AND sch_line = pod_line AND (sch_type = 4 OR sch_type = 5 OR sch_type = 6)  NO-LOCK: 
     FIND FIRST tr_hist USE-INDEX tr_nbr_eff WHERE tr_type = 'iss-tr' AND tr_loc = '9sp999' AND TR_SITE = '1000'   AND tr_nbr <> '' AND  tr_nbr = sch_rlse_id AND /*tr_so_job = (pod_nbr + STRING(pod_line))*/ tr_so_job = pod_nbr AND tr_part = pod_part NO-LOCK NO-ERROR.
    
    IF sch_rlse_id = pod_curr_rlse_id[1] OR AVAILABLE tr_hist THEN DO:
   
    iscal = NO.
     FOR EACH schd_det WHERE schd_rlse_id = sch_rlse_id AND schd_nbr = sch_nbr AND schd_line = sch_line AND (schd_type = 4 OR schd_type = 5 OR schd_type = 6) NO-LOCK BY schd_date:
       IF NOT iscal THEN DO:
        
         IF WEEKDAY(schd_date) = 1 THEN shre_date = schd_date + 6.
             IF WEEKDAY(schd_date) = 2 THEN shre_date = schd_date + 5.
           IF WEEKDAY(schd_date) = 3 THEN shre_date = schd_date + 4.
                IF WEEKDAY(schd_date) = 4 THEN shre_date = schd_date + 3.

                    IF WEEKDAY(schd_date) = 5 THEN shre_date = schd_date + 2.

                        IF WEEKDAY(schd_date) = 6 THEN shre_date = schd_date + 1.

                            IF WEEKDAY(schd_date) = 7 THEN shre_date = schd_date.
         
                                iscal = YES.
                                END.
         
         IF schd_date > shre_date THEN LEAVE.
         
      
      FIND ad_mstr WHERE ad_addr = po_vend NO-LOCK.

          FIND pt_mstr WHERE pt_part = pod_part NO-LOCK NO-ERROR. 
          m_intime_qty = 0.
          m_nontime_qty = 0.
          shre_pre_range = -3.
          shre_delay_range = 2.
         rec_date = ?.
         ISfind = NO.
          FOR EACH tr_hist USE-INDEX tr_nbr_eff WHERE tr_type = 'iss-tr' AND tr_loc = '9sp999' AND TR_SITE = '1000'  AND tr_nbr <> '' AND tr_effdate = schd_date AND tr_nbr = schd_rlse_id AND /*tr_so_job = (schd_nbr + STRING(schd_line))*/ tr_so_job = schd_nbr AND tr_part = pod_part NO-LOCK :
                 
                          IF (tr_date - schd_date < 0 AND tr_date - schd_date >= shre_pre_range) OR (tr_date - schd_date > 0 AND tr_date - schd_date <= shre_delay_range)  THEN

                             m_intime_qty = m_intime_qty + tr_qty_loc.
                          else
                              m_nontime_qty = m_nontime_qty + tr_qty_loc.
                        rec_date = tr_date.
                        isfind = YES.    
                        
                        END.
                                            
                        back_qty = schd_discr_qty + m_intime_qty + m_nontime_qty.
                 
                            CREATE M_SCH_REC.
                            M_PART = POD_PART.
                            M_VEND = PO_VEND.
                            M_VEN_NAME = AD_NAME.
                            M_DESC = PT_DESC1 + PT_DESC2.
                            M_DRAW = PT_DRAW.
                            M_PERIOD = PT_ORD_PER.
                            M_RLSE_id = SCHD_RLSE_ID.
                            M_DUE_date = SCHD_DATE.
                            M_REC_DATE = REC_DATE.
                            M_RLSE_QTY = SCHD_DISCR_QTY.
                            M_OT_QTY = abs(m_intime_qty).
                            M_DE_QTY = abs(m_nontime_qty).
                            M_BACK_QTY = BACK_QTY.
                            M_PO_NBR = POD_NBR.
                        
                        
                         
                      
      /* DISP  po_vend 
                           pod_part 
                             pt_desc1
                                pt_draw
                                pt_ord_per
                                schd_rlse_id
                              schd_date
                              rec_date schd_discr_qty
                           m_intime_qty
                         m_nontime_qty
                             (schd_discr_qty - m_intime_qty - m_nontime_qty) @ back_qty
                                shre_range
                                WITH FRAME out.
                              if pt_desc2 <> '' then do:
                     down 1 .
                    put space(35).
                    put pt_desc2.
                   
                 end.*/
                            
                            END. /* shcd_det*/
    END.
          END. /*sch_mstr*/
               END. /*pod_det*/
           END. /*po_mstr*/
            create "Excel.Application" chExcelApplication.
       chExcelApplication:Visible = TRUE.
     
       chWorkbook = chExcelApplication:Workbooks:Add().
       chWorkSheet = chExcelApplication:Sheets:Item(1).
       chExcelApplication:Sheets:Item(1):SELECT().
       chExcelApplication:Sheets:Item(1):NAME = "交货报表".
        chWorkSheet:Rows("1"):RowHeight = 20.
       chWorkSheet:Columns("A:n"):ColumnWidth = 15.
       chWorkSheet:Columns("C:C"):ColumnWidth = 20.

        chWorkSheet:Range("a1:n400"):Select().
        chexcelApplication:Selection:Font:Size = 10. 
       chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:VerticalAlignment = 2.
       chExcelApplication:selection:Font:Name = "ARIAL". 
        chWorkSheet:Range("a1:n1"):Select().
 chExcelApplication:selection:Font:Name = "楷体_gb2312".
     /*chWorkSheet:Range("a1:m1"):Select().*/
  chExcelApplication:selection:Font:bold = TRUE.
       chWorkSheet:Range("a1:a1"):VALUE = "供应商".
       chWorkSheet:Range("b1:b1"):VALUE = "供应商名称".
       chWorkSheet:Range("c1:c1"):VALUE = "订单号" .
    
      chWorkSheet:Range("d1:d1"):VALUE = "产品代码".
    chWorkSheet:Range("e1:e1"):VALUE ="产品名称" .
      chWorkSheet:Range("f1:f1"):VALUE = "图号" .
      chWorkSheet:Range("g1:g1"):VALUE = "采购周期".
      chWorkSheet:Range("h1:h1"):VALUE = "下达号".
      chWorkSheet:Range("i1:i1"):VALUE = "应到日期".
      chWorkSheet:Range("j1:j1"):VALUE = "下达数".
      chWorkSheet:Range("k1:k1"):VALUE = "实交日期".
      chWorkSheet:Range("l1:l1"):VALUE = "准时实交数".
      chWorkSheet:Range("m1:m1"):VALUE = "滞后实交数".
      chWorkSheet:Range("n1:n1"):VALUE = "未交数".
      /*chWorkSheet:Range("m1:m1"):VALUE = "允许误差天数" .*/
     /* {mfphead.i}*/
    rowstart = 2.
           FOR EACH M_SCH_REC BY M_VEND:
               crange = "a" + STRING(rowstart).  
                  chWorkSheet:Range(crange):VALUE = M_vend.
                  crange = "b" + STRING(rowstart).  
                  chWorkSheet:Range(crange):VALUE = M_VEN_name.
                  crange = "c" + STRING(rowstart). 
          

 chWorkSheet:Range(crange):VALUE = M_PO_NBR.
 crange = "d" + STRING(rowstart).     
 chWorkSheet:Range(crange):VALUE = M_PART.
 crange = "e" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE =  M_DESC.
 crange = "f" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE = M_DRAW.
 crange = "g" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE = M_PERIOD.
 crange = "h" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = M_RLSE_ID.
      crange = "i" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = M_DUE_DATE.
      crange = "j" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = M_RLSE_QTY.
      crange = "k" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = M_REC_DATE.
      crange = "l" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = M_Ot_QTY.
      
       crange = "m" + STRING(rowstart). 
     chWorkSheet:Range(crange):VALUE = M_DE_qty.
         crange = "n" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = M_BACK_QTY.
      rowstart = rowstart + 1. 
           END.
     chWorkSheet:Range("A1:n" + string(Rowstart - 1)):Select().
      chExcelApplication:selection:Borders(8):Weight = 4. 
     chExcelApplication:selection:Borders(1):Weight = 2. 
       chExcelApplication:selection:Borders(4):Weight = 2.
        chExcelApplication:selection:Borders(10):Weight = 4.
        chWorkSheet:Range("A" + string(Rowstart - 1) + ":n" + string(Rowstart - 1)):Select().
        chExcelApplication:selection:Borders(4):Weight = 4.
       chWorkSheet:Range("A1:A" + STRING(rowstart - 1)):Select().
 chExcelApplication:selection:Borders(1):Weight = 4. 
  
 /* CHWORKSHEET:SaveAs("e:\StartExcelTest-2.xls" ).*/



     
   /*{mftrl080.i}*/   RELEASE OBJECT chWorksheet.
       RELEASE OBJECT chWorkbook.
       RELEASE OBJECT chExcelApplication.
       
END.
END.
