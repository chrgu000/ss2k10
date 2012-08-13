 {mfdtitle.i}
 define  variable part like pt_part VIEW-AS EDITOR SIZE 8 BY 1 LABEL "零件代码" .
DEFINE VAR mdate like tr_date  VIEW-AS FILL-IN SIZE 8 BY 1 LABEL "日期".
DEFINE VAR prndate LIKE tr_date INITIAL TODAY.
DEFINE BUTTON b-done LABEL "Done" SIZE 12 BY 1.
DEFINE VAR isrecord AS LOGICAL. 

DEFINE VAR standard AS LOGICAL VIEW-AS FILL-IN SIZE 5 BY 1 FORMAT "Yes/No" LABEL "标准".
DEFINE VAR pallet-per AS INT VIEW-AS fill-in SIZE 12 BY 1 LABEL "每铲板数量" .
    DEFINE VAR pallet-qty AS INT VIEW-AS FILL-IN SIZE 12 BY 1 LABEL  "铲板数量".
     
    DEFINE VAR pallet-qtys AS INT EXTENT 99 VIEW-AS FILL-IN SIZE 12 BY 1 LABEL "铲板出入库数量.
    DEFINE VAR totalqty LIKE tr_qty_chg.
    DEFINE VAR remain AS LOGICAL.
    DEFINE VAR i AS INT.
    DEFINE VAR mline LIKE tr_line VIEW-AS TEXT SIZE 12 BY 1 LABEL "行".
    DEFINE VAR item-qty LIKE  tr_qty_chg.
   
   DEFINE VAR j AS INT.
  
   
    DEFINE VAR pallet-remain-qty LIKE tr_qty_chg.
    DEFINE VAR pallet-remain-qtys AS INT EXTENT 99 VIEW-AS FILL-IN SIZE 12 BY 1 LABEL "铲板剩余数量".
    DEFINE QUERY qry FOR tr_hist.
    DEFINE BROWSE brw QUERY qry
    DISPLAY tr_hist.tr_trnbr LABEL "事务号"
        tr_hist.tr_nbr LABEL "订单号"
        
        tr_hist.tr_date LABEL "日期"    
        tr_hist..tr_type LABEL "事务类型"
        tr_hist.tr_part LABEL "零件代码"
           tr_hist.tr_serial LABEL "批/序号"
      
        tr_hist.tr_qty_chg LABEL "数量"
            tr_hist.tr_ref_site LABEL "地点"
            tr_hist.tr_loc LABEL "库位"
            
         ENABLE ALL
    WITH 9 DOWN WIDTH 77 TITLE "计划外出/入库事务" LABEL-FGCOLOR 15 LABEL-BGCOLOR 9 MULTIPLE SEPARATORS.
DEFINE FRAME fr-brws
       brw SKIP (1)
       b-done AT COLUMN 35 ROW 10.5 SKIP (1)
       WITH SIZE-CHARS 80 BY 13.
          
    FORM
    SKIP(1)
   
    part COLON 18
     mdate COLON 65
       
    WITH  FRAME a WIDTH 80  TITLE "计划外出/入库标签打印" SIDE-LABEL.
  DEFINE FRAME unplan-inventory
      SKIP(1)
      tr_hist.tr_trnbr COLON 20 LABEL "事务号"
        tr_hist.tr_date COLON 30 LABEL "日期"    
        tr_hist.tr_type COLON 50 LABEL "事务类型"
      SKIP(1)  
      tr_hist.tr_part COLON 20 LABEL "零件代码"
           tr_hist.tr_serial COLON 30  LABEL "批/序号"
       tr_hist.tr_qty_chg COLON 50 LABEL "数量"
     remain-qty COLON 70 
      SKIP(1)
       pt_desc1 COLON 20 LABEL "零件描述" 
    pt_desc2 COLON 50
      SKIP(1)
      
       
            tr_hist.tr_ref_site COLON 20 LABEL "地点"
            tr_hist.tr_loc COLON 30 LABEL "库位"
         tr_hist.tr_nbr COLON 50 LABEL "订单号"
      SKIP(1)
     standard COLON 20 
     
      WITH WIDTH 80 THREE-D SIDE-LABEL.
  FORM
    SKIP(1)
    Pallet-per COLON 18
    pallet-qty COLON 45
    
    WITH  FRAME std WIDTH 80 THREE-D SIDE-LABEL .
FORM
    
    SKIP(1)
    pallet-qtys 
   
    WITH  FRAME unstd WIDTH 80 THREE-D SIDE-LABEL.
  FORM
    
    SKIP(1)
   
    pallet-remain-qtys 
    WITH  FRAME unstd-remain WIDTH 80 THREE-D SIDE-LABEL.

  DEFINE FRAME mlabelin
    SKIP(1)
    SKIP(1)
    SKIP(1)
    SKIP(1)
    "入库"
     COLON 20
    tr_hist.tr_part COLON 30 LABEL "零件代码"
    pt_desc1 COLON 50 LABEL "零件描述" 
    pt_desc2 COLON 80
    SKIP(1)
    item-qty COLON 20 LABEL "数量"
    tr_hist.tr_nbr COLON 30 LABEL "订单号"
    
    SKIP(1)
   
    tr_hist.tr_ref_site COLON 30 LABEL "地点"
    SKIP(1)
    tr_hist.tr_loc COLON 30 LABEL "库位"
    SKIP(1)
   
    tr_hist.tr_serial COLON 30 LABEL "批/序号"
    SKIP(1)
    tr_hist.tr_date COLON 30 LABEL "入库日期"
    SKIP(1)
   prndate COLON 30 LABEL "打印日期"
    WITH WIDTH 180 SIDE-LABEL.
DEFINE FRAME mlabelout
    SKIP(1)
    SKIP(1)
    SKIP(1)
    SKIP(1)
    "出库"
      COLON 20
    tr_hist.tr_part COLON 30 LABEL "零件代码"
    pt_desc1 COLON 50 LABEL "零件描述" 
    pt_desc2 COLON 80
    SKIP(1)
    item-qty COLON 20 LABEL "数量"
    tr_hist.tr_nbr COLON 30 LABEL "订单号"
    
    SKIP(1)
   
    tr_hist.tr_ref_site COLON 30 LABEL "地点"
    SKIP(1)
    tr_hist.tr_loc COLON 30 LABEL "库位"
    SKIP(1)
   
    tr_hist.tr_serial COLON 30 LABEL "批/序号"
    SKIP(1)
    tr_hist.tr_date COLON 30 LABEL "出库日期"
    SKIP(1)
   prndate COLON 30 LABEL "打印日期"
    WITH WIDTH 180 SIDE-LABEL.
    
DEFINE FRAME mlabelremain
    SKIP(1)
    SKIP(1)
    SKIP(1)
    SKIP(1)
    "剩余库存"
      COLON 20
    tr_hist.tr_part COLON 30 LABEL "零件代码"
    pt_desc1 COLON 50 LABEL "零件描述" 
    pt_desc2 COLON 80
    SKIP(1)
    pallet-remain-qty COLON 20 LABEL "数量"
    tr_hist.tr_nbr COLON 30 LABEL "订单号"
    
    SKIP(1)
   
    tr_hist.tr_ref_site COLON 30 LABEL "地点"
    SKIP(1)
    tr_hist.tr_loc COLON 30 LABEL "库位"
    SKIP(1)
   
    tr_hist.tr_serial COLON 30 LABEL "批/序号"
    SKIP(1)
    tr_hist.tr_date COLON 30 LABEL "出库日期"
    SKIP(1)
   prndate COLON 30 LABEL "打印日期"
    WITH WIDTH 180 SIDE-LABEL.
DISPLAY  part mdate WITH FRAME a.
 ENABLE ALL WITH FRAME a.  
 
    seta1:
      do transaction on error undo, retry:
          UPDATE part WITH FRAME a.
          FIND pt_part WHERE pt_part = part NO-LOCK.
          IF NOT availablew pt_part THEN DO:
              MESSAGE "无效零件代码!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

             NEXT-PROMPT part WITH FRAME a.
         UNDO,RETRY.
          END.
      END.
      seta2:
            do transaction on error undo, retry:
                UPDATE madate WITH FRAME a.
                IF mdate = ?  THEN DO:
                    MESSAGE "日期不能为空!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

                   NEXT-PROMPT mdate WITH FRAME a.
               UNDO,RETRY.
                END.
            END.
mainloop:
REPEAT:            
OPEN QUERY qry   FOR EACH tr_hist  WHERE tr_part = part AND tr_type = 'rct-unp' OR tr_type = 'iss-unp'AND tr_date = mdate BY tr_trnbr DESCENDING BY tr_type DESCENDING.
    ENABLE ALL WITH FRAME fr-brws.
    ON 'choose':U OF b-done
DO:
    FIND pt_mstr WHERE pt_part = part NO-LOCK.
    HIDE FRAME fr-brws.
    /*DISABLE ALL WITH FRAME fr-brws.*/
    j = brw:NUM-SELECTED-ROWS.
        brw:FETCH-SELECTED-ROW(j).
        FIND ld_det WHERE tr_hist.tr_loc = ld_loc NO-LOCK.
         remain-qty = ld_qty_oh.
        DISPLAY 
      tr_hist.tr_trnbr 
        tr_hist.tr_date 
        tr_hist.tr_type 
       
      tr_hist.tr_part 
           tr_hist.tr_serial 
       tr_hist.tr_qty_chg 
remain-qty
       pt_desc1 
    pt_desc2 
      
      
       
            tr_hist.tr_ref_site 
            tr_hist.tr_loc 
     
                WITH FRAME unplan-inventory.
            ENABLE ALL WITH FRAME invertory-transfer.
            
           
     
          UPDATE standard WITH FRAME inventory-transfer.
          
            

    
END.
    WAIT-FOR CHOOSE OF b-done.
  j = brw:NUM-SELECTED-ROWS.
        brw:FETCH-SELECTED-ROW(j).
           IF standard THEN DO: 
               seta4:
      do transaction on error undo, retry:
            
            
          UPDATE 
          pallet-per
         
          WITH FRAME std.
             IF pallet-per = 0 THEN DO:
              MESSAGE "不能为零!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 
               NEXT-PROMPT pallet-per WITH FRAME std.
         UNDO,RETRY.
              END.
          
          
          END.
       
      
         IF tr_hist.tr_qty_chg MOD pallet-per <> 0 THEN DO:
          
              pallet-qty = TRUNCATE(tr_hist.tr_qty_chg / pallet-per) + 1.
                remain = YES.  
              END.
             ELSE
             pallet-qty = tr_hist.tr_qty_chg / pallet-per.
          dispaly pallet-qty WITH FRAME std.
       
          END.  
        ELSE
          
             DO:
       
             
              UPDATE 
                  pallet-qtys 
                  WITH 2 COLUMN FRAME unstd .
              HIDE FRAME unstd.
              UPDATE
                  pallet-remain-qtys
                  WITH 2 COLUMN FRAME unstd-remain.
              
          END.
         
/*{mfselbpr.i "printer" 80}*/
          gpselout.i &printType = "printer"
                  &printWidth = 80
                  &pagedFlag = " "
                  &stream = " "
                  &appendToFile = " "
                  &streamedOutputToTerminal = " "
                  &withBatchOption = "yes"
                  &displayStatementType = 1
                  &withCancelMessage = "yes"
                  &pageBottomMargin = 6
                  &withEmail = "yes"
                  &withWinprint = "yes"
                  &defineVariables = "yes"}
 FIND pt_mstr WHERE pt_part = tr_part NO-LOCK.

 IF standard THEN 
         
              REPEAT i = 1 TO pallet-qty BY 1 :
               item-qty = pallet-per.
                   
                       IF i = pallet-qty  THEN DO:
                  
                   IF remain THEN DO:
                   
                       item-qty =  tr_hist.tr_qty_chg  MOD pallet-per.
                  
                      END.  
                      
                   END.
  IF tr_hist.tr_type = 'rct-unp' THEN DO:
  
                     DISPLAY  tr_hist.tr_part 
    pt_desc1 
    pt_desc2 
    
    item-qty 
    tr_hist.tr_nbr 
    
   
   
    tr_hist.tr_ref_site 
    
    tr_hist.tr_loc 
    
   
    tr_hist.tr_serial 
    
    tr_hist.tr_date 
    
 
    
    prndate WITH FRAME mlabelin .
                     PAGE.
                     END.  
ELSE DO:
  
DISPLAY  tr_hist.tr_part 
    pt_desc1 
    pt_desc2 
    
    item-qty 
    tr_hist.tr_nbr 
    
   
   
    tr_hist.tr_ref_site 
    
    tr_hist.tr_loc 
    
   
    tr_hist.tr_serial 
    
    tr_hist.tr_date 
    

    
    prndate WITH FRAME mlabelout .
      PAGE
          IF remain THEN do:
              pallet-remain-qty = pallet-per -  tr_hist.tr_qty_chg  MOD pallet-per.
         
     DISPLAY  tr_hist.tr_part 
    pt_desc1 
    pt_desc2 
    
    item-qty 
    tr_hist.tr_nbr 
    
   
   
    tr_hist.tr_ref_site 
    
    tr_hist.tr_loc 
    
   
    tr_hist.tr_serial 
    
    tr_hist.tr_date 
    

    
    prndate WITH FRAME mlabelremain .
 PAGE.
          END.
 END.        
       
     
               

              END.
              ELSE
                  REPEAT i = 1 TO 999 BY 1 :
                   IF pallet-qtys[i] <> 0 THEN 
                    item-qty = pallet-qtys[i].
                  IF pallet-remain-qtys[i] <> 0 THEN pallet-remain-qty = pallet-remain-qtys[i].
                 IF tr_hsit.tr_type = 'rct-unp' THEN DO:
                
                   IF pallet-qtys[i] <> 0  THEN DO:
                
                      DISPLAY  tr_hist.tr_part 
                                pt_desc1 
                                  pt_desc2 
    
                                   item-qty 
                                 tr_hist.tr_nbr 
    
   
   
                               tr_hist.tr_ref_site 
    
                                tr_hist.tr_loc 
    
   
                                 tr_hist.tr_serial 
    
                                  tr_hist.tr_date 
    
 
    
                                  prndate WITH FRAME mlabelin .
                                   PAGE.
                      
                          END.
                END.
                 ELSE DO:
                 
                      DISPLAY  tr_hist.tr_part 
    pt_desc1 
    pt_desc2 
    
    item-qty 
    tr_hist.tr_nbr 
    
   
   
    tr_hist.tr_ref_site 
    
    tr_hist.tr_loc 
    
   
    tr_hist.tr_serial 
    
    tr_hist.tr_date 
    

    
    prndate WITH FRAME mlabelout .
      PAGE

             IF pallet-remain-qtys[i] <> 0 THEN DO:
             

           DISPLAY  tr_hist.tr_part 
    pt_desc1 
    pt_desc2 
    
   pallet-remain-qty 
    tr_hist.tr_nbr 
    
   
   
    tr_hist.tr_ref_site 
    
    tr_hist.tr_loc 
    
   
    tr_hist.tr_serial 
    
    tr_hist.tr_date 
    

    
    prndate WITH FRAME mlabelremain .
    PAGE.
     END.     
    END.
                      
                      
                      
                      
                      
                    
                  END.
      {mftrl080.i}
END.




                    
                    

