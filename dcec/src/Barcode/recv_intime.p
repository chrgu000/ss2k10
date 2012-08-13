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
DEFINE FRAME out
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
    WITH WIDTH 220 STREAM-IO DOWN NO-ATTR-SPACE.
REPEAT:
    IF rlse_dt = low_date THEN rlse_dt = ?.
    IF rlse_dt1 = hi_date THEN rlse_dt1 = ?.
    
    SET vendor vendor1 part part1 rlse_dt rlse_dt1 WITH FRAME a.
   {mfselbpr.i "printer" 80}  
       
    IF vendor1 =''  THEN vendor1 = hi_char.
   
    IF part1 = '' THEN part1 = hi_char.
    IF rlse_dt = ? THEN rlse_dt = low_date.
    IF rlse_dt1 = ? THEN rlse_dt1 = hi_date.

    
    
    
    {mfphead.i}
    
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
         
          FOR EACH tr_hist WHERE tr_type = 'rct-tr' AND tr_loc = '8888'  AND tr_effdate = schd_date AND tr_nbr = schd_rlse_id AND tr_so_job = schd_nbr AND tr_part = pod_part NO-LOCK :
                 
                          IF string(abs(tr_date - schd_date)) <= shre_range  THEN

                             m_intime_qty = m_intime_qty + tr_qty_loc.
                          else
                              m_nontime_qty = m_nontime_qty + tr_qty_loc.
                        rec_date = tr_date.
                            END.
                   
                 
                            DISP  po_vend 
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
                   
                 end.
                            
                            END. /* shcd_det*/

          END. /*sch_mstr*/
               END. /*pod_det*/
           END. /*po_mstr*/

{mftrl080.i} 
END.
