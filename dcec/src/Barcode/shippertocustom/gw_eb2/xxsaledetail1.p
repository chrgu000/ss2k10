{mfdtitle.i}
    DEF VAR mdate AS DATE LABEL "日期".
DEF VAR mdate1 AS DATE LABEL "至".
DEF VAR ISfirst AS logical.
DEF VAR iscal AS LOGICAL.
DEF VAR mprofit AS DECIMAL   FORMAT "->>,>>>,>>>,>>9.99" LABEL "毛利".
DEF VAR mcheckstr AS CHAR.
DEF VAR mprice AS DECIMAL.
DEF VAR mqty AS INT FORMAT "->>,>>>,>>>,>>9" LABEL "数量".
DEF VAR mamt AS DECIMAL FORMAT  "->>,>>>,>>>,>>9.99" LABEL "销售额".
DEF VAR nbr LIKE so_nbr.
DEF VAR nbr1 LIKE so_nbr.
DEF VAR part LIKE pt_part.
DEF VAR part1 LIKE pt_part.
DEF VAR XXID AS RECID.
DEF VAR cmdate AS CHAR FORMAT "x(8)".
DEF VAR cmdate1 AS CHAR FORMAT "x(8)".
DEF VAR MCST LIKE MAMT.
DEF VAR pre_date LIKE ABS__qad08.
DEF VAR pre_order LIKE ABS_order.
DEF VAR pre_line LIKE ABS_line.
DEF VAR pre_item LIKE ABS_item.
DEF VAR pre_tax_in LIKE sod_tax_in.
DEF VAR i AS INT.
DEF VAR    pre_desc1 LIKE pt_desc1.
 DEF VAR       pre_desc2  LIKE pt_desc2.
  DEF VAR      pre_prod LIKE pt_prod_line.
   DEF VAR     pre_group LIKE pt_group.
   DEF VAR     pre_promo LIKE pt_promo.
     DEF VAR  pre_taxable LIKE sod_taxable.
     DEF VAR pre_part_type LIKE pt_part_type.
      DEF VAR  pre_price LIKE sod_price.
      DEF VAR pre_taxrate LIKE sod_taxc.
      DEF VAR cust LIKE cm_addr.
      DEF VAR cust1 LIKE cm_addr.
      DEF VAR region LIKE cm_region.
      DEF VAR region1 LIKE cm_region.
      DEF VAR cu_type AS CHAR FORMAT "x(10)".
      DEF VAR salerep1 LIKE so_slspsn[1].
      DEF  VAR salerep2 LIKE so_slspsn[2].
      DEF VAR pre_curr LIKE so_curr.
      DEF VAR cst LIKE mcst.
      DEF VAR camt LIKE mamt.
      DEF VAR msubcst LIKE mcst.
      DEF VAR slspsn LIKE so_slspsn[1].
      DEF VAR slspsn1 LIKE so_slspsn[1].
      DEF BUFFER somstr FOR so_mstr.
      DEF BUFFER ihhist FOR ih_hist.
          DEF VAR MSUBQTY LIKE MQTY.
          DEF TEMP-TABLE so FIELD ord AS CHAR.
          DEF VAR pre_nbr LIKE ih_nbr.
FORM 
    SKIP(0.5)
    
    cust COLON 15 LABEL "客户"
    cust1 COLON 45 LABEL "至"
    SKIP(0.5)
    region COLON 15 LABEL "区域"
    region1 COLON 45 LABEL "至"
    SKIP(0.5)
    slspsn COLON 15 LABEL "销售代表"
slspsn1 COLON 45 LABEL "至"
    SKIP(0.5)
    nbr COLON 15  LABEL "订单号" 
    nbr1 COLON 45 LABEL "至"
   /* SKIP(0.5)
    part COLON 15 LABEL "零件号"
    part1 COLON 45 LABEL "至"*/
    SKIP(0.5)
    mdate COLON 15
    mdate1 COLON 45
   
    WITH FRAME a WIDTH 80 SIDE-LABELS THREE-D.
/*DEF FRAME out
    
      ABS_order   COLUMN-LABEL "订单号"
    
    so_cust COLUMN-LABEL "客户代码"
    ad_name COLUMN-LABEL "客户简称" FORMAT "x(20)"
    salerep1 COLUMN-LABEL "代表" FORMAT "x(5)"
    salerep2 COLUMN-LABEL "代表" FORMAT "x(5)"
    ad_state COLUMN-LABEL "省份" FORMAT "x(5)"
    cm_region COLUMN-LABEL "区域" FORMAT "x(5)"
    cu_type COLUMN-LABEL "客户类型" FORMAT "x(20)"
      ABS_line COLUMN-LABEL "行" FORMAT "x(1)"
    ABS_item COLUMN-LABEL    "零件号" FORMAT "x(18)"
     pre_desc1 COLUMN-LABEL "描述一" FORMAT "x(15)"
    pre_desc2 COLUMN-LABEL "描述二" FORMAT "x(15)"
     mqty COLUMN-LABEL "发货量"
    pre_prod COLUMN-LABEL "产品类 " FORMAT "x(5)"
    pre_promo COLUMN-LABEL "产品簇" FORMAT "x(5)"
    pre_group COLUMN-LABEL "产品型号" FORMAT "x(5)"
    
    ABS__qad08 COLUMN-LABEL "发货日期" FORMAT "x(8)"
  
  mprice COLUMN-LABEL "单价（含税）"
    pre_curr COLUMN-LABEL "币制" FORMAT "x(3)"

    mamt COLUMN-LABEL "合计金额"
    cst COLUMN-LABEL "标准成本"
    camt COLUMN-LABEL "成本合计"
   pre_taxrate COLUMN-LABEL "税率"
   pre_taxable COLUMN-LABEL "纳税" 
  pre_tax_in COLUMN-LABEL "含税"
    msubcst COLUMN-LABEL "外包成本"
    mcst COLUMN-LABEL "物料成本"
    
    
   /* mprofit*/
    WITH WIDTH 620 TITLE '未开票' STREAM-IO DOWN.
DEF FRAME out1
    
      ABS_order   COLUMN-LABEL "订单号"
    
    ih_cust COLUMN-LABEL "客户代码"
    ad_name COLUMN-LABEL "客户简称" FORMAT "x(20)"
    salerep1 COLUMN-LABEL "代表" FORMAT "x(5)"
    salerep2 COLUMN-LABEL "代表" FORMAT "x(5)"
    ad_state COLUMN-LABEL "省份" FORMAT "x(5)"
    cm_region COLUMN-LABEL "区域" FORMAT "x(5)"
    cu_type COLUMN-LABEL "客户类型" FORMAT "x(20)"
      ABS_line COLUMN-LABEL "行" FORMAT "x(1)"
    ABS_item COLUMN-LABEL    "零件号" FORMAT "x(18)"
     pre_desc1 COLUMN-LABEL "描述一" FORMAT "x(15)"
    pre_desc2 COLUMN-LABEL "描述二" FORMAT "x(15)"
     mqty COLUMN-LABEL "发货量"
    pre_prod COLUMN-LABEL "产品类 " FORMAT "x(5)"
    pre_promo COLUMN-LABEL "产品簇" FORMAT "x(5)"
    pre_group COLUMN-LABEL "产品型号" FORMAT "x(5)"
    
    ABS__qad08 COLUMN-LABEL "发货日期" FORMAT "x(8)"
  
  mprice COLUMN-LABEL "单价（含税）"
    pre_curr COLUMN-LABEL "币制" FORMAT "x(3)"

    mamt COLUMN-LABEL "合计金额"
    cst COLUMN-LABEL "标准成本"
    camt COLUMN-LABEL "成本合计"
   pre_taxrate COLUMN-LABEL "税率"
   pre_taxable COLUMN-LABEL "纳税" 
  pre_tax_in COLUMN-LABEL "含税"
    msubcst COLUMN-LABEL "外包成本"
    mcst COLUMN-LABEL "物料成本"
    
    
   /* mprofit*/
    WITH WIDTH 620 TITLE '已开票' STREAM-IO DOWN.*/
DEF VAR crange AS CHAR.
DEF VAR rowstart AS INT.
DEF VAR oktocomt AS LOGICAL.
DEF  VAR chExcelApplication   AS COM-HANDLE.
DEF  VAR chWorkbook           AS COM-HANDLE.
DEF  VAR chWorksheet          AS COM-HANDLE.
DEF VAR isconfig AS LOGICAL.
REPEAT:
    IF mdate = low_date THEN mdate = ?.
    IF mdate1 = hi_date THEN mdate1 = ?.
   UPDATE mdate mdate1 cust cust1 region region1 nbr nbr1 slspsn slspsn1 WITH FRAME a.
   MESSAGE "确认将报表导出吗" SKIP(1)
        "继续?"
        VIEW-AS ALERT-BOX
        QUESTION
        BUTTON YES-NO
        UPDATE oktocomt.
 
    IF oktocomt THEN
    DO:   
        IF mdate = ? THEN mdate = low_date.
   IF mdate1 = ? THEN mdate1 = hi_date.
   IF nbr1 = '' THEN nbr1 = hi_char.
   IF cust1 = '' THEN cust1 = hi_char.
   IF region1 = '' THEN region1 = hi_char.
   IF slspsn1 = '' THEN slspsn1 = hi_char.
      cmdate = string(YEAR(mdate)) + string(MONTH(mdate)) + string(DAY(mdate)).
     cmdate1 = string(YEAR(mdate1)) + string(MONTH(mdate1)) + string(DAY(mdate1)).
    

     hide message no-pause.
     
       create "Excel.Application" chExcelApplication.
       chExcelApplication:Visible = TRUE.
     
       chWorkbook = chExcelApplication:Workbooks:Add().
       chWorkSheet = chExcelApplication:Sheets:Item(1).
       chExcelApplication:Sheets:Item(1):SELECT().
       chExcelApplication:Sheets:Item(1):NAME = "销售统计报表".
        chWorkSheet:Rows("1"):RowHeight = 25.
       chWorkSheet:Columns("A:ab"):ColumnWidth = 15.
        chWorkSheet:Columns("k:K"):ColumnWidth = 30.
         chWorkSheet:Columns("l:l"):ColumnWidth = 30.
          chWorkSheet:Columns("h:h"):ColumnWidth = 30.
        chWorkSheet:Columns("n:n"):ColumnWidth = 25.
         chWorkSheet:Columns("o:o"):ColumnWidth = 25.
         chWorkSheet:Columns("v:v"):ColumnWidth = 20.
         chWorkSheet:Columns("c:c"):ColumnWidth = 25.
         chWorkSheet:Range("a1:ab1"):Select().
 chExcelApplication:selection:Font:Name = "宋体".
     /*chWorkSheet:Range("a1:m1"):Select().*/
    chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:VerticalAlignment = 2.
  chexcelApplication:Selection:Font:Size = 12.  
 chExcelApplication:selection:Font:bold = TRUE.
       chWorkSheet:Range("a1:a1"):VALUE = "订单号".
       chWorkSheet:Range("b1:b1"):VALUE = "客户代码".
       chWorkSheet:Range("c1:c1"):VALUE = "客户简称".
    
      chWorkSheet:Range("d1:d1"):VALUE = "销售代表".
    chWorkSheet:Range("e1:e1"):VALUE = "销售代表".
      chWorkSheet:Range("f1:f1"):VALUE =  "省份".
      chWorkSheet:Range("g1:g1"):VALUE = "区域".
      chWorkSheet:Range("h1:h1"):VALUE = "客户类型".
      chWorkSheet:Range("i1:i1"):VALUE = "项次".
      chWorkSheet:Range("j1:j1"):VALUE = "零件号".
      chWorkSheet:Range("k1:k1"):VALUE = "描述一".
      chWorkSheet:Range("l1:l1"):VALUE = "描述二".
      chWorkSheet:Range("m1:m1"):VALUE = "发货量".
      chWorkSheet:Range("n1:n1"):VALUE = "产品子系列".
      chWorkSheet:Range("o1:o1"):VALUE = "产品类".
      chWorkSheet:Range("p1:p1"):VALUE = "产品簇".
      chWorkSheet:Range("q1:q1"):VALUE = "产品型号".
      chWorkSheet:Range("r1:r1"):VALUE = "发货日期".
      chWorkSheet:Range("s1:s1"):VALUE = "单价（含税）".
      chWorkSheet:Range("t1:t1"):VALUE = "币制".
      chWorkSheet:Range("u1:u1"):VALUE = "合计金额".
      
chWorkSheet:Range("v1:v1"):VALUE = "标准成本".
    chWorkSheet:Range("w1:w1"):VALUE = "成本合计（不含税）".
        chWorkSheet:Range("x1:x1"):VALUE = "税率".
        chWorkSheet:Range("y1:y1"):VALUE = "是否纳税".
          chWorkSheet:Range("z1:z1"):VALUE = "是否含税".
            chWorkSheet:Range("aa1:aa1"):VALUE = "外包成本".
              chWorkSheet:Range("ab1:ab1"):VALUE = "标准成本".
               
               
    /* {mfselbpr.i "printer" 80}*/

   /*{mfphead.i}*/
          isfirst = YES.
          iscal = YES.
          mprofit = 0.
          mcheckstr = ''.
         mamt = 0.
                mqty = 0.
                rowstart = 2.
                
                FOR EACH cm_mstr WHERE cm_addr >= cust AND cm_addr <= cust1 AND cm_region >= region AND cm_region <= region1 NO-LOCK:
                     FIND FIRST ad_mstr WHERE ad_addr = cm_addr NO-LOCK NO-ERROR.
                  
                 

                  FIND FIRST CODE_mstr WHERE CODE_fldname = 'cm_type' AND CODE_value = cm_type NO-LOCK NO-ERROR.
                 IF AVAILABLE CODE_mstr THEN cu_type = CODE_cmmt.
                     ELSE cu_type = cm_type.
             
                FIND FIRST code_mstr WHERE code_fldname = 'cm_region' AND CODE_value = cm_region NO-LOCK NO-ERROR.
                    region = CODE_cmmt.
                FOR EACH so_mstr WHERE so_cust = cm_addr AND ((so_slspsn[1] >= slspsn AND so_slspsn[1] <= slspsn1) 
                                       OR (so_slspsn[2] >= slspsn AND so_slspsn[2] <= slspsn1) OR (so_slspsn[3] >= slspsn AND so_slspsn[3] <= slspsn1)
                                       OR (so_slspsn[4] >= slspsn AND so_slspsn[4] <= slspsn1)) AND so_nbr >= nbr AND so_nbr <= nbr1 NO-LOCK:
                 
                        
                      CREATE so.
                      ord = so_nbr.
                        cst = 0.
                        mcst = 0.
                        msubcst = 0.
                        mprice = 0.
                        mamt = 0.
                        camt = 0.
                        mqty = 0.
                        iscal = YES.
                         pre_desc1 = ''.
        pre_desc2 = ''.
        pre_prod = ''.
        pre_group = ''.
        pre_promo = ''. 
         pre_tax_in = NO.
     /*  pre_curr = idh_curr.*/
        pre_taxable = NO.
                  pre_curr = so_curr.
                  ISFIRST = YES.
                  MSUBQTY = 0.
                      
                    /*  DO i = 1 TO 4:
                          FIND FIRST somstr WHERE RECID(somstr) = RECID(so_mstr) NO-LOCK NO-ERROR.
                          IF somstr.so_slspsn[i] <> ''AND salerep1 = '' THEN salerep1 = somstr.so_slspsn[i].
                           IF somstr.so_slspsn[i + 1] <> ''AND salerep2 = '' THEN salerep2 = somstr.so_slspsn[i + 1].
                      END.*/
                 salerep1 = ''.
                 salerep2 = ''.
                      IF so_slspsn[1] <> '' AND salerep1 = '' THEN salerep1 = so_slspsn[1].
                      IF so_slspsn[2] <> '' THEN DO: 
                          IF salerep1 = '' THEN 
                              salerep1 = so_slspsn[2].
                           IF salerep1 <> so_slspsn[2] AND salerep2 = '' THEN salerep2 = so_slspsn[2].
                   END.
                   IF so_slspsn[3] <> '' THEN DO: 
                      IF salerep1 = '' THEN 
                          salerep1 = so_slspsn[3].
                       IF salerep1 <> so_slspsn[3] AND salerep2 = '' THEN salerep2 = so_slspsn[3].
               END.
             IF so_slspsn[4] <> '' THEN DO: 
                      IF salerep1 = '' THEN 
                          salerep1 = so_slspsn[4].
                       IF salerep1 <> so_slspsn[4] AND salerep2 = '' THEN salerep2 = so_slspsn[4].
               END.
                   
               FIND FIRST sp_mstr WHERE sp_addr = salerep1 NO-LOCK NO-ERROR.
              IF AVAILABLE sp_mstr THEN  salerep1 = sp_sort.
                FIND FIRST sp_mstr WHERE sp_addr = salerep2 NO-LOCK NO-ERROR.
                IF AVAILABLE sp_mstr THEN salerep2 = sp_sort.

                            /* FOR LAST ABS_mstr WHERE ABS_loc = '8888' AND ABS__qad08 >= cmdate AND ABS__qad08 <= cmdate1 AND ABS_order = so_mstr.so_nbr   NO-LOCK BY ABS__qad08 BY ABS_order BY ABS_line :
                               XXID = RECID(ABS_MSTR).
                                END.*/
          FOR EACH ABS_mstr WHERE (ABS_loc = '8888' OR ABS_loc = '1CH12001') AND ABS__qad08 >= cmdate AND ABS__qad08 <= cmdate1 AND ABS_order = so_mstr.so_nbr   NO-LOCK BREAK BY (trim(ABS__qad08) + trim(abs_order) + trim(ABS_line))  :
                                    
        /*
       
                 IF NOT isFIRST AND (mcheckstr <> ABS__qad08 + ABS_order + ABS_line) THEN do:
                   /*  DISP  pre_tax_in  pre_taxable  pre_taxrate  cst camt msubcst so_mstr.so_cust pre_curr  ad_NAME salerep1 salerep2 ad_state cu_type pre_desc1  pre_desc2  pre_prod  pre_group  pre_promo  mprice pre_date @ ABS__qad08  pre_order @ ABS_order pre_line @ ABS_line pre_item @ ABS_item mqty mamt mcst /*mprofit*/ WITH FRAME out.
                  */ 
                  
                     IF ISconfig THEN do:
                       
                         FIND FIRST wo_mstr WHERE wo_nbr =  (PRE_order + '.' + PRE_line) AND WO_TYPE = 'F' NO-LOCK NO-ERROR.
                      IF AVAILABLE WO_MSTR THEN DO:
                      
                      FOR EACH wod_det WHERE wod_nbr = (pre_order + '.' + pre_line) NO-LOCK:
                     FIND FIRST pt_mstr WHERE pt_part = wod_part NO-LOCK NO-ERROR.
  FIND FIRST pl_mstr WHERE pl_prod_line = pt_prod_line NO-LOCK NO-ERROR. 
 pre_desc1 = pt_desc1.
        pre_desc2 = pt_desc2.
        pre_prod = pl_desc.
        FIND FIRST code_mstr WHERE code_fldname = 'pt_group' AND CODE_value = pt_group NO-LOCK NO-ERROR.
                 
        pre_group = CODE_cmmt.
        pre_promo = pt_promo.
        pre_part_type = pt_part_type.
        cst = wod_bom_amt.
        camt = cst * wod_bom_qty * mqty.
        MSUBQTY = wod_bom_qty * mqty.
          PRE_ITEM = WOD_PART.
         FIND FIRST sob_det WHERE sob_nbr = pre_order AND STRING(sob_line) = pre_line AND sob_part = wod_part NO-LOCK NO-ERROR.
                        IF AVAILABLE sob_det THEN mprice = sob_price.
                          ELSE DO:
                         
                        FIND FIRST ibh_hist WHERE ibh_nbr = pre_order AND STRING(ibh_line) = pre_line AND ibh_part = wod_part NO-LOCK NO-ERROR.
                        mprice = ibh_price. 
                        END. 
                        mamt = mprice * wod_bom_qty * mqty.
        FIND FIRST tr_hist WHERE tr_type = 'iss-wo' AND tr_part = wod_part AND tr_nbr = wod_nbr AND tr_lot = wod_lot NO-LOCK NO-ERROR.
         IF AVAILABLE tr_hist THEN do:
             mcst = tr_mtl_std.
         msubcst = tr_sub_std.
         END.
                      chWorkSheet:Rows(rowstart):RowHeight = 15. 
                     crange = "a" + STRING(rowstart) + ":"  + "ab" + STRING(rowstart).
                       chWorkSheet:Range(crange):Select().
        chexcelApplication:Selection:Font:Size = 10.  
        
       chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:VerticalAlignment = 2.
       chExcelApplication:selection:Font:Name = "ARIAL". 
     /*  chExcelApplication:selection:wrap.*/
                     crange = "a" + STRING(rowstart).  
                   
                  chWorkSheet:Range(crange):VALUE = pre_order.
                  crange = "b" + STRING(rowstart).  
                  chWorkSheet:Range(crange):VALUE = so_cust.
                  crange = "c" + STRING(rowstart). 

 chWorkSheet:Range(crange):VALUE = ad_name.
 crange = "d" + STRING(rowstart).     
 chWorkSheet:Range(crange):VALUE = salerep1.
 crange = "e" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE =  salerep2.
 crange = "f" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE = ad_state.
 crange = "g" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE = /*code_cmmt*/ region.
 crange = "h" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = cu_type.
      crange = "i" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_line.
      crange = "j" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_item.
      crange = "k" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_desc1.
      crange = "l" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_desc2.
      
       crange = "m" + STRING(rowstart). 
     chWorkSheet:Range(crange):VALUE = mSUBqty.
     crange = "n" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_part_type.
         crange = "o" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_prod.
crange = "p" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_promo.
              crange = "q" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_group.
              crange = "r" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_date.
              crange = "s" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = mprice.
          crange = "t" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_curr.
          crange = "u" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = mamt.
          crange = "v" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = cst.
          crange = "w" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = camt.
          crange = "x" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_taxrate.
          crange = "y" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_taxable.
          crange = "z" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_tax_in.
          crange = "aa" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = msubcst.
          crange = "ab" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = mcst.
           rowstart = rowstart + 1.  
                      END.
           END.
                  END.
                  ELSE DO:
                  
                      chWorkSheet:Rows(rowstart):RowHeight = 15. 
                     crange = "a" + STRING(rowstart) + ":"  + "ab" + STRING(rowstart).
                       chWorkSheet:Range(crange):Select().
        chexcelApplication:Selection:Font:Size = 10.  
        
       chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:VerticalAlignment = 2.
       chExcelApplication:selection:Font:Name = "ARIAL". 
     /*  chExcelApplication:selection:wrap.*/
                     crange = "a" + STRING(rowstart).  
                   
                  chWorkSheet:Range(crange):VALUE = pre_order.
                  crange = "b" + STRING(rowstart).  
                  chWorkSheet:Range(crange):VALUE = so_cust.
                  crange = "c" + STRING(rowstart). 

 chWorkSheet:Range(crange):VALUE = ad_name.
 crange = "d" + STRING(rowstart).     
 chWorkSheet:Range(crange):VALUE = salerep1.
 crange = "e" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE =  salerep2.
 crange = "f" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE = ad_state.
 crange = "g" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE = region.
 crange = "h" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = cu_type.
      crange = "i" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_line.
      crange = "j" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_item.
      crange = "k" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_desc1.
      crange = "l" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_desc2.
      
       crange = "m" + STRING(rowstart). 
     chWorkSheet:Range(crange):VALUE = mqty.
     crange = "n" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_part_type.    
     crange = "o" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_prod.
crange = "p" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_promo.
              crange = "q" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_group.
              crange = "r" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_date.
              crange = "s" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = mprice.
          crange = "t" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_curr.
          crange = "u" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = mamt.
          crange = "v" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = cst.
          crange = "w" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = camt.
          crange = "x" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_taxrate.
          crange = "y" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_taxable.
          crange = "z" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_tax_in.
          crange = "aa" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = msubcst.
          crange = "ab" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = mcst.
           rowstart = rowstart + 1.  
                  END.






     MSUBQTY = 0.
                     mprofit = 0.
                 iscal = YES.
                mamt = 0.
                mqty = 0.
                camt = 0.
                mprice = 0.
                 pre_desc1 = ''.
        pre_desc2 = ''.
        pre_prod = ''.
        pre_group = ''.
        pre_promo = ''. 
         pre_tax_in = NO.
     /*  pre_curr = idh_curr.*/
        pre_taxable = NO.
                 END.
                */
             IF iscal  THEN DO:  
                 isconfig = NO.
                 FIND FIRST tr_hist WHERE tr_type = 'iss-so' AND tr_nbr = ABS_order AND STRING(tr_line) = ABS_line AND tr_loc = '8888' AND tr_ship_id = SUBSTR(ABS_par_id,2,50) NO-LOCK NO-ERROR.
                             IF AVAILABLE tr_hist THEN mprice = tr_price. 
                             ELSE DO:
                             FIND FIRST sod_det WHERE sod_nbr = ABS_order AND string(sod_line) = abs_line NO-LOCK NO-ERROR.
                    IF AVAILABLE sod_det THEN mprice = sod_price.
                    
                    
                       
                        
                        
                        END.
                 

                                         mcst = 0.
                                           msubcst = 0.
                                  cst = 0.
                
               
              FIND FIRST PT_MSTR WHERE PT_PART = ABS_ITEM  NO-LOCK NO-ERROR.

               IF  PT_PM_CODE <> 'C' THEN  DO:
                    
                   FIND FIRST tr_hist WHERE tr_type = 'rct-tr' AND tr_loc = '8888' AND tr_nbr = ABS_order AND string(tr_line) = ABS_line AND tr_ship_id = SUBSTR(ABS_par_id,2,50) NO-LOCK NO-ERROR.
                          IF AVAILABLE tr_hist THEN DO: mcst = tr_mtl_std.    
                          msubcst = tr_sub_std.
                                                        
                                                        
                                       cst = tr_price.                 
                                                        END.
                           



               END.
               ELSE DO:
                  isconfig = YES.
                    END.
  
 
  FIND FIRST sod_det WHERE sod_nbr = ABS_order AND abs_line = string(sod_line) NO-LOCK NO-ERROR.
        IF AVAILABLE sod_det THEN DO:
     
/*FIND FIRST tx2_mstr WHERE tx2_tax_type = sod_taxc AND tx2_tax_usage = sod_tax_usage NO-LOCK NO-ERROR.
 */       
pre_tax_in = sod_tax_in.
      /* pre_curr = sod_curr.*/
        pre_taxable = sod_taxable.
        
        /*FIND FIRST tx2_mstr WHERE tx2_tax_type = sod_taxc AND tx2_tax_usage = sod_tax_usage NO-LOCK NO-ERROR.
    IF AVAILABLE tx2_mstr THEN
        pre_taxrate = tx2_tax_pct.
    ELSE pre_taxrate = 0.*/
        pre_taxrate = sod_taxc.
        END.
        ELSE DO:
FIND FIRST idh_hist WHERE idh_nbr = ABS_order AND abs_line = string(idh_line) NO-LOCK NO-ERROR.
        IF AVAILABLE idh_hist THEN DO :
     
FIND FIRST tx2_mstr WHERE tx2_tax_type = idh_taxc AND tx2_tax_usage = idh_tax_usage NO-LOCK NO-ERROR.
        pre_tax_in = idh_tax_in.
     /*  pre_curr = idh_curr.*/
        pre_taxable = idh_taxable.
      /* FIND FIRST tx2_mstr WHERE tx2_tax_type = idh_taxc AND tx2_tax_usage = idh_tax_usage NO-LOCK NO-ERROR.
       IF AVAILABLE tx2_mstr then  pre_taxrate = tx2_tax_pct.
       ELSE PRE_TAXRATE = 0. */
        pre_taxrate = idh_taxc.
       END.
        END.
        IF NOT isconfig THEN DO:
        FIND FIRST pt_mstr WHERE pt_part = ABS_item NO-LOCK NO-ERROR.
 FIND FIRST pl_mstr WHERE pl_prod_line = pt_prod_line NO-LOCK NO-ERROR. 
 pre_desc1 = pt_desc1.
        pre_desc2 = pt_desc2.
        pre_prod = pl_desc.
         FIND FIRST code_mstr WHERE code_fldname = 'pt_group' AND CODE_value = pt_group NO-LOCK NO-ERROR.
                 
        pre_group = CODE_cmmt.
        pre_promo = pt_promo.
        pre_part_type = pt_part_type.
        END.
  
             iscal = NO.    
               END.     
               IF NOT isconfig THEN  DO:
              
               mprofit = mprofit + (mprice * ABS_qty - mcst * ABS_qty).
                   
                  mamt = mamt + mprice * ABS_qty.
                   
                  camt = camt + cst * ABS_qty.
               END.
                  
                  mqty = mqty + ABS_qty.
             
             
             
            
               
                  mcheckstr = ABS__qad08 + ABS_order + ABS_line.  
                   pre_date = ABS__qad08.
                  pre_order = ABS_order.
                  pre_line = ABS_line.
                  pre_item = ABS_item.
                  isfirst = NO.

              
                /*  IF XXID = RECID(ABS_MSTR) THEN do:*/
                  IF LAST-OF(trim(ABS__qad08) + trim(abs_order) + trim(ABS_line))  THEN DO:
                  
                    /* PUT SKIP.
                     DISP mcst pre_tax_in  pre_taxable  pre_taxrate  cst camt msubcst so_mstr.so_cust pre_curr  ad_NAME salerep1 salerep2 ad_state cu_type pre_desc1  pre_desc2  pre_prod  pre_group  pre_promo  mprice pre_date @ ABS__qad08  pre_order @ ABS_order pre_line @ ABS_line pre_item @ ABS_item mqty mamt /*mprofit*/ WITH FRAME out.
 */  
  
                    IF ISconfig THEN do:
                      
                        FIND FIRST wo_mstr WHERE wo_nbr =  (PRE_order + '.' + PRE_line) AND WO_TYPE = 'F' NO-LOCK NO-ERROR.
                      IF AVAILABLE WO_MSTR THEN DO: 
                        FOR EACH wod_det WHERE wod_nbr = (pre_order + '.' + pre_line) NO-LOCK:
                     FIND FIRST pt_mstr WHERE pt_part = wod_part NO-LOCK NO-ERROR.
  FIND FIRST pl_mstr WHERE pl_prod_line = pt_prod_line NO-LOCK NO-ERROR. 
 pre_desc1 = pt_desc1.
        pre_desc2 = pt_desc2.
        pre_prod = pl_desc.
        FIND FIRST code_mstr WHERE code_fldname = 'pt_group' AND CODE_value = pt_group NO-LOCK NO-ERROR.
                 
        pre_group = CODE_cmmt.
        pre_promo = pt_promo.
        pre_part_type = pt_part_type.
        cst = wod_bom_amt.
        camt = cst * wod_bom_qty * mqty.
            MSUBQTY = wod_bom_qty * mqty.
        PRE_ITEM = WOD_PART.
         FIND FIRST sob_det WHERE sob_nbr = pre_order AND STRING(sob_line) = pre_line AND sob_part = wod_part NO-LOCK NO-ERROR.
                        IF AVAILABLE sob_det THEN mprice = sob_price.
                          ELSE DO:
                         
                        FIND FIRST ibh_hist WHERE ibh_nbr = pre_order AND STRING(ibh_line) = pre_line AND ibh_part = wod_part NO-LOCK NO-ERROR.
                        mprice = ibh_price. 
                        END. 
                        mamt = mprice * wod_bom_qty * mqty.
        FIND FIRST tr_hist WHERE tr_type = 'iss-wo' AND tr_part = wod_part AND tr_nbr = wod_nbr AND tr_lot = wod_lot NO-LOCK NO-ERROR.
         IF AVAILABLE tr_hist THEN do:
             mcst = tr_mtl_std.
         msubcst = tr_sub_std.
         END.
                      chWorkSheet:Rows(rowstart):RowHeight = 15. 
                     crange = "a" + STRING(rowstart) + ":"  + "ab" + STRING(rowstart).
                       chWorkSheet:Range(crange):Select().
        chexcelApplication:Selection:Font:Size = 10.  
        
       chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:VerticalAlignment = 2.
       chExcelApplication:selection:Font:Name = "ARIAL". 
     /*  chExcelApplication:selection:wrap.*/
                     crange = "a" + STRING(rowstart).  
                   
                  chWorkSheet:Range(crange):VALUE = pre_order.
                  crange = "b" + STRING(rowstart).  
                  chWorkSheet:Range(crange):VALUE = so_cust.
                  crange = "c" + STRING(rowstart). 

 chWorkSheet:Range(crange):VALUE = ad_name.
 crange = "d" + STRING(rowstart).     
 chWorkSheet:Range(crange):VALUE = salerep1.
 crange = "e" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE =  salerep2.
 crange = "f" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE = ad_state.
 crange = "g" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE = region.
 crange = "h" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = cu_type.
      crange = "i" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_line.
      crange = "j" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_item.
      crange = "k" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_desc1.
      crange = "l" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_desc2.
      
       crange = "m" + STRING(rowstart). 
     chWorkSheet:Range(crange):VALUE = mSUBqty.
     crange = "n" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_part_type.    
     crange = "o" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_prod.
crange = "p" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_promo.
              crange = "q" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_group.
              crange = "r" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_date.
              crange = "s" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = mprice.
          crange = "t" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_curr.
          crange = "u" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = mamt.
          crange = "v" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = cst.
          crange = "w" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = camt.
          crange = "x" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_taxrate.
          crange = "y" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_taxable.
          crange = "z" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_tax_in.
          crange = "aa" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = msubcst.
          crange = "ab" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = mcst.
           rowstart = rowstart + 1.  
                        END.
                      END.
                  END.
                  ELSE DO:
                  
                      chWorkSheet:Rows(rowstart):RowHeight = 15. 
                     crange = "a" + STRING(rowstart) + ":"  + "ab" + STRING(rowstart).
                       chWorkSheet:Range(crange):Select().
        chexcelApplication:Selection:Font:Size = 10.  
        
       chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:VerticalAlignment = 2.
       chExcelApplication:selection:Font:Name = "ARIAL". 
     /*  chExcelApplication:selection:wrap.*/
                     crange = "a" + STRING(rowstart).  
                   
                  chWorkSheet:Range(crange):VALUE = pre_order.
                  crange = "b" + STRING(rowstart).  
                  chWorkSheet:Range(crange):VALUE = so_cust.
                  crange = "c" + STRING(rowstart). 

 chWorkSheet:Range(crange):VALUE = ad_name.
 crange = "d" + STRING(rowstart).     
 chWorkSheet:Range(crange):VALUE = salerep1.
 crange = "e" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE =  salerep2.
 crange = "f" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE = ad_state.
 crange = "g" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE = region.
 crange = "h" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = cu_type.
      crange = "i" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_line.
      crange = "j" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_item.
      crange = "k" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_desc1.
      crange = "l" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_desc2.
      
       crange = "m" + STRING(rowstart). 
     chWorkSheet:Range(crange):VALUE = mqty.
     crange = "n" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_part_type.    
     crange = "o" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_prod.
crange = "p" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_promo.
              crange = "q" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_group.
              crange = "r" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_date.
              crange = "s" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = mprice.
          crange = "t" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_curr.
          crange = "u" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = mamt.
          crange = "v" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = cst.
          crange = "w" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = camt.
          crange = "x" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_taxrate.
          crange = "y" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_taxable.
          crange = "z" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_tax_in.
          crange = "aa" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = msubcst.
          crange = "ab" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = mcst.
           rowstart = rowstart + 1.  
                  END.
                 
                  
     MSUBQTY = 0.
                     mprofit = 0.
                 iscal = YES.
                mamt = 0.
                mqty = 0.
                camt = 0.
                mprice = 0.
                 pre_desc1 = ''.
        pre_desc2 = ''.
        pre_prod = ''.
        pre_group = ''.
        pre_promo = ''. 
         pre_tax_in = NO.
     /*  pre_curr = idh_curr.*/
        pre_taxable = NO.
                  
                  
                  END.
                  
          END.
                  
                    END.
                    
                    
                       pre_nbr = ''. 
                     FOR EACH ih_hist USE-INDEX ih_nbr WHERE ih_cust = cm_addr AND ((ih_slspsn[1] >= slspsn AND ih_slspsn[1] <= slspsn1) 
                                       OR (ih_slspsn[2] >= slspsn AND ih_slspsn[2] <= slspsn1) OR (ih_slspsn[3] >= slspsn AND ih_slspsn[3] <= slspsn1)
                                       OR (ih_slspsn[4] >= slspsn AND ih_slspsn[4] <= slspsn1)) AND ih_nbr >= nbr AND ih_nbr <= nbr1 AND NOT CAN-FIND(FIRST so WHERE ord = ih_nbr NO-LOCK) NO-LOCK:
                 
                       /* FOR EACH idh_hist WHERE idh_nbr = ih_nbr NO-LOCK:
                         FIND FIRST sod_det WHERE sod_nbr = idh_nbr AND sod_line = idh_line NO-LOCK NO-ERROR.
                         IF NOT AVAILABLE sod_det THEN DO:*/
                         IF pre_nbr <> ih_nbr THEN DO:
                        
                         cst = 0.
                        mcst = 0.
                        msubcst = 0.
                        mprice = 0. 
                        mamt = 0.
                        camt = 0.
                       mqty = 0.
                        iscal = YES.
                        pre_desc1 = ''.
        pre_desc2 = ''.
        pre_prod = ''.
        pre_group = ''.
        pre_promo = ''. 
         pre_tax_in = NO.
     /*  pre_curr = idh_curr.*/
        pre_taxable = NO.
         isfirst = YES.
                        salerep1 = ''.
                 salerep2 = ''.
                 MSUBQTY = 0.
                 pre_curr = ih_curr.
                      IF ih_slspsn[1] <> '' AND salerep1 = '' THEN salerep1 = ih_slspsn[1].
                      IF ih_slspsn[2] <> '' THEN DO: 
                          IF salerep1 = '' THEN 
                              salerep1 = ih_slspsn[2].
                           IF salerep1 <> ih_slspsn[2] AND salerep2 = '' THEN salerep2 = ih_slspsn[2].
                   END.
                   IF ih_slspsn[3] <> '' THEN DO: 
                      IF salerep1 = '' THEN 
                          salerep1 = ih_slspsn[3].
                       IF salerep1 <> ih_slspsn[3] AND salerep2 = '' THEN salerep2 = ih_slspsn[3].
               END.
             IF ih_slspsn[4] <> '' THEN DO: 
                      IF salerep1 = '' THEN 
                          salerep1 = ih_slspsn[4].
                       IF salerep1 <> ih_slspsn[4] AND salerep2 = '' THEN salerep2 = ih_slspsn[4].
             END.
                      
                    /*  DO i = 1 TO 4:
                            FIND FIRST ihhist WHERE RECID(ihhist) = RECID(ih_hist) NO-LOCK NO-ERROR.
                           IF ihhist.ih_slspsn[i] <> ''AND salerep1 = '' THEN salerep1 = ihhist.ih_slspsn[i].
                           IF ihhist.ih_slspsn[i + 1] <> ''AND salerep2 = '' THEN salerep2 = ihhist.ih_slspsn[i + 1].
                      END.*/

     
                      
                      FIND FIRST sp_mstr WHERE sp_addr = salerep1 NO-LOCK NO-ERROR.
               IF AVAILABLE sp_mstr THEN salerep1 = sp_sort.
                FIND FIRST sp_mstr WHERE sp_addr = salerep2 NO-LOCK NO-ERROR.
               IF AVAILABLE sp_mstr THEN salerep2 = sp_sort.
                /*FOR LAST ABS_mstr WHERE ABS_loc = '8888' AND ABS__qad08 >= cmdate AND ABS__qad08 <= cmdate1 AND ABS_order = ih_hist.ih_nbr   NO-LOCK BY ABS__qad08 BY ABS_order BY ABS_line :
               XXID = RECID(ABS_MSTR).
                END.*/
          FOR EACH ABS_mstr WHERE (ABS_loc = '8888' OR ABS_loc = '1CH12001') AND ABS__qad08 >= cmdate AND ABS__qad08 <= cmdate1 AND ABS_order = ih_hist.ih_nbr  NO-LOCK BREAK BY (trim(ABS__qad08) + trim(abs_order) + trim(ABS_line))  :
                                    
            /*
       
                 IF NOT isFIRST AND (mcheckstr <> ABS__qad08 + ABS_order + ABS_line) THEN do:
              /*       DISP mcst pre_tax_in  pre_taxable  pre_taxrate  cst camt msubcst ih_hist.ih_cust pre_curr  ad_NAME salerep1 salerep2 ad_state cu_type pre_desc1  pre_desc2  pre_prod  pre_group  pre_promo  mprice pre_date @ ABS__qad08  pre_order @ ABS_order pre_line @ ABS_line pre_item @ ABS_item mqty mamt /*mprofit*/ WITH FRAME out1.
*/       
                   IF ISconfig THEN do:
                     
                       FIND FIRST wo_mstr WHERE wo_nbr =  (PRE_order + '.' + PRE_line) AND WO_TYPE = 'F' NO-LOCK NO-ERROR.
                      IF AVAILABLE WO_MSTR THEN DO: 
                       FOR EACH wod_det WHERE wod_nbr = (pre_order + '.' + pre_line) NO-LOCK:
                     FIND FIRST pt_mstr WHERE pt_part = wod_part NO-LOCK NO-ERROR.
  FIND FIRST pl_mstr WHERE pl_prod_line = pt_prod_line NO-LOCK NO-ERROR. 
 pre_desc1 = pt_desc1.
        pre_desc2 = pt_desc2.
        pre_prod = pl_desc.
         FIND FIRST code_mstr WHERE code_fldname = 'pt_group' AND CODE_value = pt_group NO-LOCK NO-ERROR.
                 
        pre_group = CODE_cmmt.
        pre_promo = pt_promo.
        pre_part_type = pt_part_type.
        cst = wod_bom_amt.
        camt = cst * wod_bom_qty * mqty.
        MSUBQTY = wod_bom_qty * mqty.
          PRE_ITEM = WOD_PART.
         FIND FIRST sob_det WHERE sob_nbr = pre_order AND STRING(sob_line) = pre_line AND sob_part = wod_part NO-LOCK NO-ERROR.
                        IF AVAILABLE sob_det THEN mprice = sob_price.
                          ELSE DO:
                         
                        FIND FIRST ibh_hist WHERE ibh_nbr = pre_order AND STRING(ibh_line) = pre_line AND ibh_part = wod_part NO-LOCK NO-ERROR.
                        mprice = ibh_price. 
                        END. 
                        mamt = mprice * wod_bom_qty * mqty.
        FIND FIRST tr_hist WHERE tr_type = 'iss-wo' AND tr_part = wod_part AND tr_nbr = wod_nbr AND tr_lot = wod_lot NO-LOCK NO-ERROR.
         IF AVAILABLE tr_hist THEN do:
             mcst = tr_mtl_std.
         msubcst = tr_sub_std.
         END.
                      chWorkSheet:Rows(rowstart):RowHeight = 15. 
                     crange = "a" + STRING(rowstart) + ":"  + "ab" + STRING(rowstart).
                       chWorkSheet:Range(crange):Select().
        chexcelApplication:Selection:Font:Size = 10.  
        
       chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:VerticalAlignment = 2.
       chExcelApplication:selection:Font:Name = "ARIAL". 
     /*  chExcelApplication:selection:wrap.*/
                     crange = "a" + STRING(rowstart).  
                   
                  chWorkSheet:Range(crange):VALUE = pre_order.
                  crange = "b" + STRING(rowstart).  
                  chWorkSheet:Range(crange):VALUE = ih_cust.
                  crange = "c" + STRING(rowstart). 

 chWorkSheet:Range(crange):VALUE = ad_name.
 crange = "d" + STRING(rowstart).     
 chWorkSheet:Range(crange):VALUE = salerep1.
 crange = "e" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE =  salerep2.
 crange = "f" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE = ad_state.
 crange = "g" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE = region.
 crange = "h" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = cu_type.
      crange = "i" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_line.
      crange = "j" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_item.
      crange = "k" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_desc1.
      crange = "l" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_desc2.
      
       crange = "m" + STRING(rowstart). 
     chWorkSheet:Range(crange):VALUE = mSUBqty.
     crange = "n" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_part_type.    
     crange = "o" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_prod.
crange = "p" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_promo.
              crange = "q" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_group.
              crange = "r" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_date.
              crange = "s" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = mprice.
          crange = "t" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_curr.
          crange = "u" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = mamt.
          crange = "v" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = cst.
          crange = "w" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = camt.
          crange = "x" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_taxrate.
          crange = "y" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_taxable.
          crange = "z" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_tax_in.
          crange = "aa" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = msubcst.
          crange = "ab" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = mcst.
           rowstart = rowstart + 1.  
                       END.
           END.
                  END.
                  ELSE DO:
                  
                      chWorkSheet:Rows(rowstart):RowHeight = 15. 
                     crange = "a" + STRING(rowstart) + ":"  + "ab" + STRING(rowstart).
                       chWorkSheet:Range(crange):Select().
        chexcelApplication:Selection:Font:Size = 10.  
        
       chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:VerticalAlignment = 2.
       chExcelApplication:selection:Font:Name = "ARIAL". 
     /*  chExcelApplication:selection:wrap.*/
                     crange = "a" + STRING(rowstart).  
                   
                  chWorkSheet:Range(crange):VALUE = pre_order.
                  crange = "b" + STRING(rowstart).  
                  chWorkSheet:Range(crange):VALUE = ih_cust.
                  crange = "c" + STRING(rowstart). 

 chWorkSheet:Range(crange):VALUE = ad_name.
 crange = "d" + STRING(rowstart).     
 chWorkSheet:Range(crange):VALUE = salerep1.
 crange = "e" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE =  salerep2.
 crange = "f" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE = ad_state.
 crange = "g" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE = region.
 crange = "h" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = cu_type.
      crange = "i" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_line.
      crange = "j" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_item.
      crange = "k" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_desc1.
      crange = "l" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_desc2.
      
       crange = "m" + STRING(rowstart). 
     chWorkSheet:Range(crange):VALUE = mqty.
     crange = "n" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_part_type.    
     crange = "o" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_prod.
crange = "p" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_promo.
              crange = "q" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_group.
              crange = "r" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_date.
              crange = "s" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = mprice.
          crange = "t" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_curr.
          crange = "u" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = mamt.
          crange = "v" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = cst.
          crange = "w" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = camt.
          crange = "x" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_taxrate.
          crange = "y" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_taxable.
          crange = "z" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_tax_in.
          crange = "aa" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = msubcst.
          crange = "ab" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = mcst.
           rowstart = rowstart + 1.  
                  END. 
                     mprofit = 0.
                 iscal = YES.
                mamt = 0.
                mqty = 0.
                camt = 0.
                mprice = 0.
                pre_desc1 = ''.
        pre_desc2 = ''.
        pre_prod = ''.
        pre_group = ''.
        pre_promo = ''. 
         pre_tax_in = NO.
     /*  pre_curr = idh_curr.*/
        pre_taxable = NO.
        MSUBQTY = 0.
                END.
                */
             IF iscal  THEN DO:  
                 isconfig = NO.
                 FIND FIRST tr_hist WHERE tr_type = 'iss-so' AND tr_nbr = ABS_order AND STRING(tr_line) = ABS_line AND tr_loc = '8888' AND tr_ship_id = SUBSTR(ABS_par_id,2,50) NO-LOCK NO-ERROR.
                             IF AVAILABLE tr_hist THEN mprice = tr_price. 
                             ELSE DO:
                                      
  FIND FIRST idh_hist WHERE idh_nbr = ABS_order AND abs_line = string(idh_line) NO-LOCK NO-ERROR.
                                 mprice = idh_price.
                    
                    
                       
                        
                        
                        END.
                 

                                         mcst = 0.
                                  msubcst = 0.
                                  cst = 0.
               FIND FIRST wo_mstr WHERE wo_nbr =  (ABS_order + '.' + ABS_line) NO-LOCK NO-ERROR.
               FIND FIRST PT_MSTR WHERE PT_PART = ABS_ITEM  NO-LOCK NO-ERROR.

               IF  PT_PM_CODE <> 'C' THEN  DO:
               
                    
                   FIND FIRST tr_hist WHERE tr_type = 'rct-tr' AND tr_loc = '8888' AND tr_nbr = ABS_order AND string(tr_line) = ABS_line AND tr_ship_id = SUBSTR(ABS_par_id,2,50) NO-LOCK NO-ERROR.
                          IF AVAILABLE tr_hist THEN DO: mcst = tr_mtl_std.    
                          msubcst = tr_sub_std.
                                             cst = tr_price.           
                                                        
                                                        
                                                        END.
                           



               END.
               ELSE DO:
                   isconfig = YES.


                                                             END.




         
              
                    
                   
     
     
  FIND FIRST idh_hist WHERE idh_nbr = ABS_order AND abs_line = string(idh_line) NO-LOCK NO-ERROR.
        IF AVAILABLE idh_hist THEN DO :
     
FIND FIRST tx2_mstr WHERE tx2_tax_type = idh_taxc AND tx2_tax_usage = idh_tax_usage NO-LOCK NO-ERROR.
        pre_tax_in = idh_tax_in.
     /*  pre_curr = idh_curr.*/
        pre_taxable = idh_taxable.
      /* FIND FIRST tx2_mstr WHERE tx2_tax_type = idh_taxc AND tx2_tax_usage = idh_tax_usage NO-LOCK NO-ERROR.
       IF AVAILABLE tx2_mstr then  pre_taxrate = tx2_tax_pct.
       ELSE PRE_TAXRATE = 0. */
        pre_taxrate = idh_taxc.
       END.
     IF NOT isconfig THEN DO:   
 FIND FIRST pt_mstr WHERE pt_part = ABS_item NO-LOCK NO-ERROR.
  FIND FIRST pl_mstr WHERE pl_prod_line = pt_prod_line NO-LOCK NO-ERROR. 
 pre_desc1 = pt_desc1.
        pre_desc2 = pt_desc2.
        pre_prod = pl_desc.
         FIND FIRST code_mstr WHERE code_fldname = 'pt_group' AND CODE_value = pt_group NO-LOCK NO-ERROR.
                 
        pre_group = CODE_cmmt.
        pre_promo = pt_promo.
        pre_part_type = pt_part_type.
              END.
        iscal = NO.    
               
             END.     
              IF NOT isconfig THEN DO:
             
                   mprofit = mprofit + (mprice * ABS_qty - mcst * ABS_qty).
                   
                  mamt = mamt + mprice * ABS_qty.
                 camt = camt + cst * ABS_qty.   
              END.
             mqty = mqty + ABS_qty.
             
             
             
            
               
                 
                 
         
                  mcheckstr = ABS__qad08 + ABS_order + ABS_line.  
                   pre_date = ABS__qad08.
                  pre_order = ABS_order.
                  pre_line = ABS_line.
                  pre_item = ABS_item.
           isfirst = NO.
                 
         /*  IF XXID = RECID(ABS_MSTR) THEN do:*/
           IF LAST-OF(trim(ABS__qad08) + trim(abs_order) + trim(ABS_line)) THEN DO:

                    /*  PUT SKIP.
                    DISP  mcst pre_tax_in  pre_taxable  pre_taxrate  cst camt msubcst ih_hist.ih_cust pre_curr  ad_NAME salerep1 salerep2 ad_state cu_type pre_desc1  pre_desc2  pre_prod  pre_group  pre_promo  mprice pre_date @ ABS__qad08  pre_order @ ABS_order pre_line @ ABS_line pre_item @ ABS_item mqty mamt /*mprofit*/ WITH FRAME out1.
*/ 
  
                    IF ISconfig THEN do:
                     
                        FIND FIRST wo_mstr WHERE wo_nbr =  (PRE_order + '.' + PRE_line) AND WO_TYPE = 'F' NO-LOCK NO-ERROR.
                      IF AVAILABLE WO_MSTR THEN DO:  
                        FOR EACH wod_det WHERE wod_nbr = (pre_order + '.' + pre_line) NO-LOCK:
                     FIND FIRST pt_mstr WHERE pt_part = wod_part NO-LOCK NO-ERROR.
  FIND FIRST pl_mstr WHERE pl_prod_line = pt_prod_line NO-LOCK NO-ERROR. 
 pre_desc1 = pt_desc1.
        pre_desc2 = pt_desc2.
        pre_prod = pl_desc.
        FIND FIRST code_mstr WHERE code_fldname = 'pt_group' AND CODE_value = pt_group NO-LOCK NO-ERROR.
                 
        pre_group = CODE_cmmt.
        pre_promo = pt_promo.
        pre_part_type = pt_part_type.
        cst = wod_bom_amt.
        camt = cst * wod_bom_qty * mqty.
        MSUBQTY = wod_bom_qty * mqty.
          PRE_ITEM = WOD_PART.
         FIND FIRST sob_det WHERE sob_nbr = pre_order AND STRING(sob_line) = pre_line AND sob_part = wod_part NO-LOCK NO-ERROR.
                        IF AVAILABLE sob_det THEN mprice = sob_price.
                          ELSE DO:
                         
                        FIND FIRST ibh_hist WHERE ibh_nbr = pre_order AND STRING(ibh_line) = pre_line AND ibh_part = wod_part NO-LOCK NO-ERROR.
                        mprice = ibh_price. 
                        END. 
                        mamt = mprice * wod_bom_qty * mqty.
        FIND FIRST tr_hist WHERE tr_type = 'iss-wo' AND tr_part = wod_part AND tr_nbr = wod_nbr AND tr_lot = wod_lot NO-LOCK NO-ERROR.
         IF AVAILABLE tr_hist THEN do:
             mcst = tr_mtl_std.
         msubcst = tr_sub_std.
         END.
                      chWorkSheet:Rows(rowstart):RowHeight = 15. 
                     crange = "a" + STRING(rowstart) + ":"  + "ab" + STRING(rowstart).
                       chWorkSheet:Range(crange):Select().
        chexcelApplication:Selection:Font:Size = 10.  
        
       chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:VerticalAlignment = 2.
       chExcelApplication:selection:Font:Name = "ARIAL". 
     /*  chExcelApplication:selection:wrap.*/
                     crange = "a" + STRING(rowstart).  
                   
                  chWorkSheet:Range(crange):VALUE = pre_order.
                  crange = "b" + STRING(rowstart).  
                  chWorkSheet:Range(crange):VALUE = ih_cust.
                  crange = "c" + STRING(rowstart). 

 chWorkSheet:Range(crange):VALUE = ad_name.
 crange = "d" + STRING(rowstart).     
 chWorkSheet:Range(crange):VALUE = salerep1.
 crange = "e" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE =  salerep2.
 crange = "f" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE = ad_state.
 crange = "g" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE = region.
 crange = "h" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = cu_type.
      crange = "i" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_line.
      crange = "j" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_item.
      crange = "k" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_desc1.
      crange = "l" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_desc2.
      
       crange = "m" + STRING(rowstart). 
     chWorkSheet:Range(crange):VALUE = mSUBqty.
     crange = "n" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_part_type.    
     crange = "o" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_prod.
crange = "p" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_promo.
              crange = "q" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_group.
              crange = "r" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_date.
              crange = "s" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = mprice.
          crange = "t" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_curr.
          crange = "u" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = mamt.
          crange = "v" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = cst.
          crange = "w" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = camt.
          crange = "x" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_taxrate.
          crange = "y" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_taxable.
          crange = "z" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_tax_in.
          crange = "aa" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = msubcst.
          crange = "ab" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = mcst.
           rowstart = rowstart + 1.  
                      END.
                  END.
                    END.
                  ELSE DO:
                  
                      chWorkSheet:Rows(rowstart):RowHeight = 15. 
                     crange = "a" + STRING(rowstart) + ":"  + "ab" + STRING(rowstart).
                       chWorkSheet:Range(crange):Select().
        chexcelApplication:Selection:Font:Size = 10.  
        
       chExcelApplication:selection:HorizontalAlignment = 2.
       chExcelApplication:selection:VerticalAlignment = 2.
       chExcelApplication:selection:Font:Name = "ARIAL". 
     /*  chExcelApplication:selection:wrap.*/
                     crange = "a" + STRING(rowstart).  
                   
                  chWorkSheet:Range(crange):VALUE = pre_order.
                  crange = "b" + STRING(rowstart).  
                  chWorkSheet:Range(crange):VALUE = ih_cust.
                  crange = "c" + STRING(rowstart). 

 chWorkSheet:Range(crange):VALUE = ad_name.
 crange = "d" + STRING(rowstart).     
 chWorkSheet:Range(crange):VALUE = salerep1.
 crange = "e" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE =  salerep2.
 crange = "f" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE = ad_state.
 crange = "g" + STRING(rowstart).       
 chWorkSheet:Range(crange):VALUE = region.
 crange = "h" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = cu_type.
      crange = "i" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_line.
      crange = "j" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_item.
      crange = "k" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_desc1.
      crange = "l" + STRING(rowstart).  
      chWorkSheet:Range(crange):VALUE = pre_desc2.
      
       crange = "m" + STRING(rowstart). 
     chWorkSheet:Range(crange):VALUE = mqty.
     crange = "n" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_part_type.    
     crange = "o" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_prod.
crange = "p" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_promo.
              crange = "q" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_group.
              crange = "r" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_date.
              crange = "s" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = mprice.
          crange = "t" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_curr.
          crange = "u" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = mamt.
          crange = "v" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = cst.
          crange = "w" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = camt.
          crange = "x" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_taxrate.
          crange = "y" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_taxable.
          crange = "z" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = pre_tax_in.
          crange = "aa" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = msubcst.
          crange = "ab" + STRING(rowstart).
          chWorkSheet:Range(crange):VALUE = mcst.
           rowstart = rowstart + 1.  
                  END.
                 mprofit = 0.
                 iscal = YES.
                mamt = 0.
                mqty = 0.
                camt = 0.
                mprice = 0.
                pre_desc1 = ''.
        pre_desc2 = ''.
        pre_prod = ''.
        pre_group = ''.
        pre_promo = ''. 
         pre_tax_in = NO.
     /*  pre_curr = idh_curr.*/
        pre_taxable = NO.
        MSUBQTY = 0.
                  
                  
                  
                  
                  END.
                  
                  
                  
                    END.
                    
                         END.
                         pre_nbr = ih_nbr.
                    
                    END.
                  
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    END.
 
               


     chWorkSheet:Range("A1:ab" + string(Rowstart - 1)):Select().
      chExcelApplication:selection:Borders(8):Weight = 4. 
     chExcelApplication:selection:Borders(1):Weight = 2. 
       chExcelApplication:selection:Borders(4):Weight = 2.
        chExcelApplication:selection:Borders(10):Weight = 4.
        chWorkSheet:Range("A" + string(Rowstart - 1) + ":ab" + string(Rowstart - 1)):Select().
        chExcelApplication:selection:Borders(4):Weight = 4.
       chWorkSheet:Range("A1:A" + STRING(rowstart - 1)):Select().
 chExcelApplication:selection:Borders(1):Weight = 4. 
  
 /* CHWORKSHEET:SaveAs("e:\StartExcelTest-2.xls" ).*/



     
   /*{mftrl080.i}*/   RELEASE OBJECT chWorksheet.
       RELEASE OBJECT chWorkbook.
       RELEASE OBJECT chExcelApplication.    
                    
                    
                    
                   MESSAGE "输出结束！" VIEW-AS ALERT-BOX.  
                    
                    
                    
                    /*{mftrl080.i} */
    END.
          END.
