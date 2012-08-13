{mfdtitle.i}
     &SCOPED-DEFINE rsrp01_p_5 "Created"
     define  variable supplier_from like po_vend.
 define  variable supplier_to like po_vend.
/*K0MZ*/ define  variable shipto_from like po_ship.
/*K0MZ*/ define  variable shipto_to like po_ship.
/*K0MZ*/ define  variable part_from like pod_part.
/*K0MZ*/ define  variable part_to like pod_part.
/*K0MZ*/ DEFINE variable po_from like po_nbr.
/*K0MZ*/ define  variable po_to like po_nbr.
/*K0MZ*/ define  variable date_from as date label {&rsrp01_p_5}.
/*K0MZ*/ define  variable date_to as date.
DEF VAR amt AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99".
DEF VAR mtot_amt LIKE amt.
DEF FRAME a
    
    SKIP(0.5)
    supplier_from COLON 15
    supplier_to COLON 45
    shipto_from COLON 15
    shipto_to COLON 45
   po_from COLON 15
    po_to COLON 45  
    part_from COLON 15
    part_to COLON 45
  DATE_from COLON 15
    DATE_to COLON 45
  WITH WIDTH 80 SIDE-LABELS THREE-D.
DEF FRAME m_header
    SKIP(2)
    xxpo_vend LABEL '供应商'COLON 10
    ad_name LABEL '描述' COLON 10
    xxpo_cur LABEL '币种' COLON 10
    WITH WIDTH 180 SIDE-LABELS STREAM-IO.
DEF FRAME m_detail
   xxpo_nbr COLUMN-LABEL '采购单' COLON 10
   xxpo_line COLUMN-LABEL '行'
    xxpo_part COLUMN-LABEL '零件号'
    pt_desc1 COLUMN-LABEL '零件描述'
    xxpo_qty COLUMN-LABEL '耗用数量'
    xxpo_price COLUMN-LABEL '单价'
    xxpo_disc COLUMN-LABEL '折扣'
    amt COLUMN-LABEL '金额'
    WITH WIDTH 180 DOWN STREAM-IO.
 setFrameLabels(frame a:handle).
 REPEAT :
      DATE_from = TODAY.
   DATE_to = TODAY + 7.
   UPDATE supplier_from 
    supplier_to 
    shipto_from
    shipto_to 
    part_from 
    part_to 
    po_from 
    po_to 
    DATE_from 
    DATE_to 
        WITH FRAME a.
    {mfselbpr.i "printer" 80} 
   IF supplier_to = '' THEN supplier_to = hi_char.
   IF shipto_to = '' THEN shipto_to = hi_char.
   IF part_to = '' THEN part_to = hi_char.
   IF po_to = '' THEN po_to = hi_char.
   IF DATE_from = ? THEN DATE_from = low_date.
   IF DATE_to = ? THEN DATE_to = hi_date.
    FOR EACH xxpo_consign USE-INDEX xxpo_condttyp WHERE 
        xxpo_condt >= DATE_from AND xxpo_condt <= DATE_to
        AND xxpo_type = 'consume' AND 
         xxpo_vend >= supplier_from AND xxpo_vend <= supplier_to
        AND xxpo_nbr >= po_from AND xxpo_nbr <= po_to
        AND xxpo_part >= part_from AND xxpo_part <= part_to NO-LOCK BREAK BY xxpo_vend BY xxpo_cur:
         if page-size - line-counter < 2 then page.
        IF FIRST-OF(xxpo_cur) THEN DO:
            mtot_amt = 0.
            FIND FIRST ad_mstr WHERE ad_addr = xxpo_vend NO-LOCK NO-ERROR.
           DISP xxpo_vend IF ad_name <> '' THEN ad_name ELSE ad_sort @ ad_name xxpo_cur WITH FRAME m_header.
        END.
        amt = xxpo_qty * xxpo_price * xxpo_disc.
        mtot_amt = mtot_amt + amt.  
       FIND FIRST pt_mstr WHERE pt_part = xxpo_part NO-LOCK NO-ERROR.
       DISP  xxpo_nbr 
   xxpo_line 
    xxpo_part
    pt_desc1 WHEN AVAILABLE pt_mstr
    xxpo_qty 
    xxpo_price 
    xxpo_disc 
    amt  WITH FRAME m_detail.
       IF AVAILABLE pt_mstr AND pt_desc2 <> '' THEN DO:
                down 1 .
                    put space(31).
                    put pt_desc2.
       END.
       IF LAST-OF(xxpo_cur) THEN DO:
           put skip(1). 
PUT SPACE(82). put "合计". put space(2).
PUT '-------------'.
put skip.
PUT SPACE(88). 
PUT UNFORMAT string(mtot_amt). 

       END.
    END.
    {mftrl080.i} 
 END.
