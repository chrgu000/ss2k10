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
DEFINE VAR shre_range AS CHAR.
DEFINE VAR BACK_qty LIKE tr_qty_loc.
DEFINE VAR rec_date LIKE tr_date.
DEF  VAR chExcelApplication   AS COM-HANDLE.
DEF  VAR chWorkbook           AS COM-HANDLE.
DEF  VAR chWorksheet          AS COM-HANDLE.
/*DEF  VAR chWorksheetRange     AS COM-HANDLE.*/
DEF VAR rowstart AS INT.
DEF VAR oktocomt AS LOGICAL.
DEFINE VAR crange AS CHAR.
FORM  
 SKIP(0.5)
    vendor COLON 10 LABEL "��Ӧ��"
    vendor1 COLON 45 LABEL "��"
    SKIP(0.5)
    part COLON 10 LABEL "�����"
    part1 COLON 45 LABEL "��"
    SKIP(0.5)
rlse_dt COLON 10 LABEL "�´���"
    rlse_dt1 COLON 45 LABEL "�´���"
    WITH FRAME a WIDTH 80 THREE-D SIDE-LABEL.
DEFINE FRAME out
    po_vend COLON 12 COLUMN-LABEL "��Ӧ��"
    pod_part COLUMN-LABEL "��Ʒ����"
    pt_desc1 COLUMN-LABEL "��Ʒ����"
    pt_draw COLUMN-LABEL "ͼ��"
    pt_ord_per COLUMN-LABEL "�ɹ�����"
    schd_rlse_id COLUMN-LABEL "�´��"
    schd_date COLUMN-LABEL "Ӧ������"
    rec_date COLUMN-LABEL "ʵ������"
    schd_discr_qty COLUMN-LABEL "�´���"
    m_intime_qty COLUMN-LABEL "׼ʱʵ����"
    m_nontime_qty COLUMN-LABEL "�ͺ�ʵ����"
    back_qty COLUMN-LABEL "δ����"
    shre_range COLUMN-LABEL "�����������"
    WITH WIDTH 180 STREAM-IO DOWN NO-ATTR-SPACE.
REPEAT:
    IF rlse_dt = low_date THEN rlse_dt = ?.
    IF rlse_dt1 = hi_date THEN rlse_dt1 = ?.
    
    SET vendor vendor1 part part1 rlse_dt rlse_dt1 WITH FRAME a.
   /*{mfselbpr.i "printer" 80}  */
     MESSAGE "ȷ�Ͻ���������" SKIP(1)
        "����?"
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
     
       create "Excel.Application" chExcelApplication.
       chExcelApplication:Visible = TRUE.
     
       chWorkbook = chExcelApplication:Workbooks:Add().
       chWorkSheet = chExcelApplication:Sheets:Item(1).
       chExcelApplication:Sheets:Item(1):SELECT().
       chExcelApplication:Sheets:Item(1):NAME = "��������".
        chWorkSheet:Rows("1"):RowHeight = 20.
       chWorkSheet:Columns("A:M"):ColumnWidth = 15.
       chWorkSheet:Columns("C:C"):ColumnWidth = 20.

        chWorkSheet:Range("a1:m400"):Select().
        chexcelApplication:Selection:Font:Size = 10. 
       chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:VerticalAlignment = 2.
       chExcelApplication:selection:Font:Name = "ARIAL". 
        chWorkSheet:Range("a1:m1"):Select().
 chExcelApplication:selection:Font:Name = "����_gb2312".
     /*chWorkSheet:Range("a1:m1"):Select().*/
  chExcelApplication:selection:Font:bold = TRUE.
       chWorkSheet:Range("a1:a1"):VALUE = "��Ӧ��".
      chWorkSheet:Range("b1:b1"):VALUE = "��Ʒ����".
 chWorkSheet:Range("c1:c1"):VALUE = "��Ʒ����".
    chWorkSheet:Range("d1:d1"):VALUE = "ͼ��".
      chWorkSheet:Range("e1:e1"):VALUE =  "�ɹ�����".
      chWorkSheet:Range("f1:f1"):VALUE = "�´��".
      chWorkSheet:Range("g1:g1"):VALUE = "Ӧ������".
      chWorkSheet:Range("h1:h1"):VALUE = "ʵ������".
      chWorkSheet:Range("i1:i1"):VALUE = "�´���".
      chWorkSheet:Range("j1:j1"):VALUE = "׼ʱʵ����".
      chWorkSheet:Range("k1:k1"):VALUE = "�ͺ�ʵ����".
      chWorkSheet:Range("l1:l1"):VALUE = "δ����".
      chWorkSheet:Range("m1:m1"):VALUE = "�����������" .
     /* {mfphead.i}*/
    rowstart = 2.
    FOR EACH po_mstr WHERE po_vend >= vendor AND po_vend <= vendor1 NO-LOCK:
   
       FOR EACH pod_det WHERE pod_nbr = po_nbr AND pod_part >= part AND pod_part <= part1 NO-LOCK:
       
    FOR EACH sch_mstr WHERE sch_cr_date >= rlse_dt AND sch_cr_date <= rlse_dt1 AND sch_nbr = pod_nbr AND sch_line = pod_line AND (sch_type = 4 OR sch_type = 5 OR sch_type = 6) NO-LOCK: 
    
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
         
      


          FIND pt_mstr WHERE pt_part = pod_part NO-LOCK NO-ERROR. 
          m_intime_qty = 0.
          m_nontime_qty = 0.
          shre_range = '1'.
         rec_date = ?.
         
          FOR EACH tr_hist WHERE tr_type = 'iss-tr' AND tr_loc = '9sp999' AND TR_SITE = '1000'  AND tr_effdate = schd_date AND tr_nbr = schd_rlse_id AND tr_so_job = schd_nbr AND tr_part = pod_part NO-LOCK :
                 
                          IF string(abs(tr_date - schd_date)) <= shre_range  THEN

                             m_intime_qty = m_intime_qty + tr_qty_loc.
                          else
                              m_nontime_qty = m_nontime_qty + tr_qty_loc.
                        rec_date = tr_date.
                            END.
                            back_qty = schd_discr_qty + m_intime_qty + m_nontime_qty.

                            crange = "a" + STRING(rowstart).  
                  chWorkSheet:Range(crange):VALUE = po_vend.
                  crange = "b" + STRING(rowstart).  
                  chWorkSheet:Range(crange):VALUE = pod_part.
                  crange = "c" + STRING(rowstart). 

 chWorkSheet:Range(crange):VALUE = pt_desc1 + pt_desc2.
 crange = "d" + STRING(rowstart).     
 chWorkSheet:Range(crange):VALUE = pt_draw.
 crange = "e" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE =  pt_ord_per.
 crange = "f" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE = schd_rlse_id.
 crange = "g" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE = schd_date.
 crange = "h" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = rec_date.
      crange = "i" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = schd_discr_qty.
      crange = "j" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = abs(m_intime_qty).
      crange = "k" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = abs(m_nontime_qty).
      crange = "l" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = BACK_qty.
      
       crange = "m" + STRING(rowstart). 
      chWorkSheet:Range(crange):VALUE = shre_range.
      rowstart = rowstart + 1.                     
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

          END. /*sch_mstr*/
               END. /*pod_det*/
           END. /*po_mstr*/
     chWorkSheet:Range("A1:m" + string(Rowstart - 1)):Select().
      chExcelApplication:selection:Borders(8):Weight = 4. 
     chExcelApplication:selection:Borders(1):Weight = 2. 
       chExcelApplication:selection:Borders(4):Weight = 2.
        chExcelApplication:selection:Borders(10):Weight = 4.
        chWorkSheet:Range("A" + string(Rowstart - 1) + ":m" + string(Rowstart - 1)):Select().
        chExcelApplication:selection:Borders(4):Weight = 4.
       chWorkSheet:Range("A1:A" + STRING(rowstart - 1)):Select().
 chExcelApplication:selection:Borders(1):Weight = 4. 
  
 /* CHWORKSHEET:SaveAs("e:\StartExcelTest-2.xls" ).*/



     
   /*{mftrl080.i}*/   RELEASE OBJECT chWorksheet.
       RELEASE OBJECT chWorkbook.
       RELEASE OBJECT chExcelApplication.
       
END.
END.
