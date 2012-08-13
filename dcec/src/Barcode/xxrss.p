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
DEF VAR c_rlse_dt AS CHAR FORMAT "x(8)".
DEF VAR c_rlse_dt1 AS CHAR FORMAT "x(8)".
DEF VAR xxid AS RECID.
DEF VAR week_date AS DATE.
DEF VAR MAX_date AS DATE.
DEF VAR MAX_week_rlse LIKE sch_rlse_id.
DEF BUFFER schmstr FOR sch_mstr.
    DEF VAR pre_week_dt LIKE week_date.
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
/*DEFINE FRAME out
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
    WITH WIDTH 180 STREAM-IO DOWN NO-ATTR-SPACE.*/
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
       chWorkSheet:Columns("A:n"):ColumnWidth = 15.
       chWorkSheet:Columns("C:C"):ColumnWidth = 20.

        chWorkSheet:Range("a1:n400"):Select().
        chexcelApplication:Selection:Font:Size = 10. 
       chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:VerticalAlignment = 2.
       chExcelApplication:selection:Font:Name = "ARIAL". 
        chWorkSheet:Range("a1:n1"):Select().
 chExcelApplication:selection:Font:Name = "����_gb2312".
     /*chWorkSheet:Range("a1:m1"):Select().*/
  chExcelApplication:selection:Font:bold = TRUE.
       chWorkSheet:Range("a1:a1"):VALUE = "��Ӧ��".
       chWorkSheet:Range("b1:b1"):VALUE = "��Ӧ������".
       chWorkSheet:Range("c1:c1"):VALUE = "��Ʒ����".
    
      chWorkSheet:Range("d1:d1"):VALUE = "��Ʒ����".
    chWorkSheet:Range("e1:e1"):VALUE = "ͼ��".
      chWorkSheet:Range("f1:f1"):VALUE =  "�ɹ�����".
      chWorkSheet:Range("g1:g1"):VALUE = "�´��".
      chWorkSheet:Range("h1:h1"):VALUE = "Ӧ������".
      chWorkSheet:Range("i1:i1"):VALUE = "ʵ������".
      chWorkSheet:Range("j1:j1"):VALUE = "�´���".
      chWorkSheet:Range("k1:k1"):VALUE = "׼ʱʵ����".
      chWorkSheet:Range("l1:l1"):VALUE = "�ͺ�ʵ����".
      chWorkSheet:Range("m1:m1"):VALUE = "δ����".
      chWorkSheet:Range("n1:n1"):VALUE = "������".
      /*chWorkSheet:Range("m1:m1"):VALUE = "�����������" .*/
     /* {mfphead.i}*/
    rowstart = 2.
    FOR EACH po_mstr USE-INDEX po_vend WHERE po_vend >= vendor AND po_vend <= vendor1 NO-LOCK:
   
       FOR EACH pod_det USE-INDEX pod_nbrln WHERE pod_nbr = po_nbr AND pod_part >= part AND pod_part <= part1 NO-LOCK:
       week_date = low_date.
       MAX_date = low_date.
       pre_week_dt = hi_date.
        FOR LAST sch_mstr USE-INDEX sch_cr_date WHERE sch_cr_date >= rlse_dt AND sch_cr_date <= rlse_dt1 AND sch_nbr = pod_nbr AND sch_line = pod_line AND (sch_type = 4 OR sch_type = 5 OR sch_type = 6)  NO-LOCK /*BY sch_cr_date*/: 
        xxid = RECID(sch_mstr).
            END.
       FOR EACH sch_mstr USE-INDEX sch_cr_date WHERE sch_cr_date >= rlse_dt AND sch_cr_date <= rlse_dt1 AND sch_nbr = pod_nbr AND sch_line = pod_line AND (sch_type = 4 OR sch_type = 5 OR sch_type = 6)  NO-LOCK /*BY sch_cr_date*/: 
 /* FIND FIRST tr_hist WHERE tr_type = 'iss-tr' AND tr_loc = '9sp999' AND TR_SITE = '1000'   AND tr_nbr = sch_rlse_id AND /*tr_so_job = (pod_nbr + STRING(pod_line))*/ tr_so_job = pod_nbr AND tr_part = pod_part USE-INDEX tr_nbr_eff  NO-LOCK NO-ERROR.*/
         /*DISP sch_nbr sch_line sch_rlse_id sch_cr_date WITH 1 COLUMN.*/
   IF week_date = low_date THEN DO:
         
         IF WEEKDAY(sch_cr_date) = 1 THEN week_date = sch_cr_date + 6.
             IF WEEKDAY(sch_cr_date) = 2 THEN week_date = sch_cr_date + 5.
           IF WEEKDAY(sch_cr_date) = 3 THEN week_date = sch_cr_date + 4.
                IF WEEKDAY(sch_cr_date) = 4 THEN week_date = sch_cr_date + 3.

                    IF WEEKDAY(sch_cr_date) = 5 THEN week_date = sch_cr_date + 2.

                        IF WEEKDAY(sch_cr_date) = 6 THEN week_date = sch_cr_date + 1.

                            IF WEEKDAY(sch_cr_date) = 7 THEN week_date = sch_cr_date.
                             MAX_date = sch_cr_date.
                            
                            
    END.
   /*  ELSE DO:*/
    
        IF sch_cr_date > max_date AND sch_cr_date <= week_date THEN 
            MAX_date = sch_cr_date.
        
          /* IF sch_cr_date > week_date THEN DO:*/
             .
               
             
           

               
               
               
      
  
        IF sch_cr_date > week_date  OR xxid = recid(sch_mstr) THEN DO:
      FOR LAST schmstr USE-INDEX sch_cr_date WHERE schmstr.sch_cr_date = MAX_date AND schmstr.sch_nbr = pod_nbr AND schmstr.sch_line = pod_line AND (schmstr.sch_type = 4 OR schmstr.sch_type = 5 OR schmstr.sch_type = 6)  NO-LOCK BY schmstr.sch_rlse_id: 
         max_week_rlse = schmstr.sch_rlse_id.
         
    /*  IF pod_nbr = 'po1049' THEN   DISP max_date MAX_week_rlse schmstr.sch_nbr schmstr.sch_line schmstr.sch_cr_date week_date WITH  1  column. */
      
    iscal = NO.
   
    FOR EACH schd_det  USE-INDEX schd_dtr WHERE schd_rlse_id = MAX_week_rlse AND schd_nbr = schmstr.sch_nbr AND schd_line = schmstr.sch_line AND (schd_type = 4 OR schd_type = 5 OR schd_type = 6) NO-LOCK BY schd_date:
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
        
          FOR EACH tr_hist USE-INDEX tr_nbr_eff WHERE tr_type = 'iss-tr' AND tr_loc = '9sp999' AND TR_SITE = '1000'  AND tr_effdate = schd_date AND tr_nbr = schd_rlse_id AND /*tr_so_job = (schd_nbr + STRING(schd_line))*/ tr_so_job = schd_nbr AND tr_part = pod_part  NO-LOCK :
                 
                          IF (tr_date - schd_date = 0 ) OR (tr_date - schd_date < 0 AND tr_date - schd_date >= shre_pre_range) OR (tr_date - schd_date > 0 AND tr_date - schd_date <= shre_delay_range)  THEN

                             m_intime_qty = m_intime_qty + tr_qty_loc.
                          else
                              m_nontime_qty = m_nontime_qty + tr_qty_loc.
                        rec_date = tr_date.
                        
                        
                        END.
                      
                       
                        back_qty = schd_discr_qty + m_intime_qty + m_nontime_qty.
                 
                            crange = "a" + STRING(rowstart).  
                  chWorkSheet:Range(crange):VALUE = po_vend.
                  crange = "b" + STRING(rowstart).  
                  chWorkSheet:Range(crange):VALUE = ad_name.
                  crange = "c" + STRING(rowstart). 

 chWorkSheet:Range(crange):VALUE = pod_part.
 crange = "d" + STRING(rowstart).     
 chWorkSheet:Range(crange):VALUE = pt_desc1 + pt_desc2.
 crange = "e" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE =  pt_draw.
 crange = "f" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE = pt_ord_per.
 crange = "g" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE = schd_rlse_id.
 crange = "h" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = schd_date.
      crange = "i" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = rec_date.
      crange = "j" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = schd_discr_qty.
      crange = "k" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = abs(m_intime_qty).
      crange = "l" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = abs(m_nontime_qty).
      
       crange = "m" + STRING(rowstart). 
     chWorkSheet:Range(crange):VALUE = BACK_qty.
         crange = "n" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pod_nbr + STRING(pod_line).
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
      END.
      IF WEEKDAY(sch_mstr.sch_cr_date) = 1 THEN week_date = sch_mstr.sch_cr_date + 6.
          IF WEEKDAY(sch_mstr.sch_cr_date) = 2 THEN week_date = sch_mstr.sch_cr_date + 5.
        IF WEEKDAY(sch_mstr.sch_cr_date) = 3 THEN week_date = sch_mstr.sch_cr_date + 4.
             IF WEEKDAY(sch_mstr.sch_cr_date) = 4 THEN week_date = sch_mstr.sch_cr_date + 3.

                 IF WEEKDAY(sch_mstr.sch_cr_date) = 5 THEN week_date = sch_mstr.sch_cr_date + 2.

                     IF WEEKDAY(sch_mstr.sch_cr_date) = 6 THEN week_date = sch_mstr.sch_cr_date + 1.

                         IF WEEKDAY(sch_mstr.sch_cr_date) = 7 THEN week_date = sch_mstr.sch_cr_date.  
       MAX_date = sch_mstr.sch_cr_date.

      END.
         
                                   
              /* END.*/
    /* END.*/
       
                          END. /*sch_mstr*/
             
               END. /*pod_det*/
           END. /*po_mstr*/
              /* c_rlse_dt = string(YEAR(rlse_dt)) + string(MONTH(rlse_dt)) + string(DAY(RLSE_dt)).
                c_rlse_dt1 = string(YEAR(rlse_dt1)) + string(MONTH(rlse_dt1)) + string(DAY(RLSE_dt1)).           
                FOR EACH po_mstr  USE-INDEX po_vend WHERE  po_vend >= vendor AND po_vend <= vendor1 NO-LOCK:    
           FOR EACH tr_hist  USE-INDEX tr_nbr_eff WHERE tr_type = 'iss-tr' AND tr_loc = '9sp999' AND TR_SITE = '1000' AND tr_nbr <> ''AND  substr(tr_nbr,1,8) >= c_rlse_dt AND substr(tr_nbr,1,8) <= c_rlse_dt1  AND tr_so_job = po_nbr AND tr_part >= part AND tr_part <= part1  /*AND tr_effdate = schd_date AND tr_nbr = schd_rlse_id AND /*tr_so_job = (schd_nbr + STRING(schd_line))*/ tr_so_job = schd_nbr AND tr_part = pod_part */ NO-LOCK :
             
             FIND FIRST pod_det use-index pod_nbrln  WHERE pod_nbr = tr_so_job AND pod_part = tr_part   NO-LOCK NO-ERROR.
                   IF AVAILABLE pod_det THEN DO:
                
           
                  
                 FIND FIRST schd_det USE-INDEX schd_dtr WHERE schd_rlse_id = tr_nbr AND schd_nbr = tr_so_job AND schd_date = tr_effdate AND schd_line = pod_line NO-LOCK NO-ERROR.
                     
                     IF AVAILABLE schd_det THEN DO:
                   
                         
                         
                        
               
               IF (tr_date - schd_date < 0 AND tr_date - schd_date >= shre_pre_range) OR (tr_date - schd_date > 0 AND tr_date - schd_date <= shre_delay_range)  THEN

                                       m_intime_qty = m_intime_qty + tr_qty_loc.
                                    else
                                        m_nontime_qty = m_nontime_qty + tr_qty_loc.
                                  rec_date = tr_date.

  back_qty = schd_discr_qty + m_intime_qty + m_nontime_qty.
                  
                   FIND ad_mstr WHERE ad_addr = po_vend NO-LOCK.
                    FIND pt_mstr WHERE pt_part = pod_part NO-LOCK NO-ERROR. 
                            crange = "a" + STRING(rowstart).  
                  chWorkSheet:Range(crange):VALUE = po_vend.
                  crange = "b" + STRING(rowstart).  
                  chWorkSheet:Range(crange):VALUE = ad_name.
                  crange = "c" + STRING(rowstart). 

 chWorkSheet:Range(crange):VALUE = pod_part.
 crange = "d" + STRING(rowstart).     
 chWorkSheet:Range(crange):VALUE = pt_desc1 + pt_desc2.
 crange = "e" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE =  pt_draw.
 crange = "f" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE = pt_ord_per.
 crange = "g" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE = schd_rlse_id.
 crange = "h" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = schd_date.
      crange = "i" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = rec_date.
      crange = "j" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = schd_discr_qty.
      crange = "k" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = abs(m_intime_qty).
      crange = "l" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = abs(m_nontime_qty).
      
       crange = "m" + STRING(rowstart). 
     chWorkSheet:Range(crange):VALUE = BACK_qty.
         crange = "n" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pod_nbr.
      rowstart = rowstart + 1.  

                     END.


               END.
                   END.
                                  END.*/

    MESSAGE "���������" VIEW-AS ALERT-BOX.


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
