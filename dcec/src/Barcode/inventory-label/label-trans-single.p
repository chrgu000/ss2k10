 
 {mfdtitle.i }
 define  variable part like pt_part VIEW-AS EDITOR SIZE 8 BY 1 LABEL "零件代码" .
DEFINE VAR mdate like tr_date  VIEW-AS FILL-IN SIZE 8 BY 1 LABEL "日期".
DEFINE VAR prndate LIKE tr_date INITIAL TODAY.
DEFINE BUTTON b-done LABEL "Done" SIZE 12 BY 1.
DEFINE VAR isrecord AS LOGICAL. 
DEFINE VAR src-pallet AS INT VIEW-AS FILL-IN SIZE 12 BY 1 LABEL "源铲板数量".
DEFINE VAR desti-pallet AS INT VIEW-AS FILL-IN SIZE 12 BY 1 LABEL "目标铲板数量".
DEFINE VAR src-remain-pallet AS INT.
DEFINE VAR desti-update-pallet AS INT.
DEFINE BUFFER trhist FOR tr_hist.  
    DEFINE VAR i AS INT.
    DEFINE TEMP-TABLE transfer FIELD transfer-nbr LIKE tr_trnbr 
        FIELD transfer-date LIKE tr_date
        FIELD transfer-part LIKE tr_part 
        FIELD src-lot-serial LIKE tr_serial
         FIELD desti-lot-serial LIKE tr_serial
        FIELD transfer-qty LIKE tr_qty_chg
    FIELD src-site LIKE tr_ref_site
    FIELD src-loc LIKE tr_loc
    FIELD desti-site LIKE tr_ref_site
    FIELD desti-loc LIKE tr_loc
    .
    
    DEFINE QUERY qry FOR transfer.
    DEFINE BROWSE brw QUERY qry
    DISPLAY transfer.transfer-nbr LABEL "事务号"
        transfer.transfer-date LABEL "日期"    
        transfer.transfer-part LABEL "零件代码"
            transfer.src-lot-serial LABEL "源批/序号"
        transfer.desti-lot-serial LABEL "目标批/序号"
        transfer.transfer-qty LABEL "移库数量"
            transfer.src-site LABEL "源地点"
            transfer.src-loc LABEL "源库位"
            transfer.desti-site LABEL "目标地点"
           transfer.desti-loc LABEL "目标库位"
         ENABLE ALL
    WITH 9 DOWN WIDTH 77 TITLE "移库事务" LABEL-FGCOLOR 15 LABEL-BGCOLOR 9 MULTIPLE SEPARATORS.
DEFINE FRAME fr-brws
       brw SKIP (1)
       b-done AT COLUMN 35 ROW 10.5 SKIP (1)
       WITH SIZE-CHARS 80 BY 13.
          
    FORM
    SKIP(1)
   
    part COLON 18
     mdate COLON 65
       
    WITH  FRAME a WIDTH 80  TITLE "移库标签打印" SIDE-LABEL.
  DEFINE FRAME inventory-transfer
      SKIP(1)
      transfer.transfer-nbr COLON 20 LABEL "事务号"
      transfer.transfer-date COLON 30 LABEL "日期"     
      transfer.transfer-part COLON 50 LABEL "零件代码"
           SKIP(1)
       pt_desc1 COLON 20 LABEL "零件描述" 
    pt_desc2 COLON 50
      SKIP(1)
        transfer.transfer-qty COLON 50 LABEL "移库数量"
      SKIP(1)
       transfer.src-lot-serial COLON 30 LABEL "源批/序号"
      transfer.desti-lot-serial COLON 50 LABEL "目标批/序号"
      SKIP(1)      
      transfer.src-site COLON 20 LABEL "源地点"
            transfer.src-loc COLON 30 LABEL "源库位"
            transfer.desti-site COLON 50 LABEL "目标地点"
           transfer.desti-loc COLON 70LABEL "目标库位"
      SKIP(1)
      src-pallet COLON 20 
      desti-pallet COLON 50
      WITH WIDTH 80 THREE-D SIDE-LABEL.
DEFINE FRAME mlabelout
    SKIP(1)
    SKIP(1)
    SKIP(1)
    SKIP(1)
    "出库
     COLON 20
    transfer.transfer-part COLON 30 LABEL "零件代码"
    pt_desc1 COLON 50 LABEL "零件描述" 
    pt_desc2 COLON 80
    SKIP(1)
  transfer.transfer-qty COLON 20 LABEL "数量"
    "自" COLON 30
    "至" COLON 50
    SKIP(1)
    transfer.src-site COLON 30 LABEL "源地点"
    transfer.desti-site COLON 50 LABEL "目标地点"
    SKIP(1)
    transfer.src-loc COLON 30 LABEL "源库位"
   transfer.desti-loc COLON 50 LABEL "目标库位"
    SKIP(1)
    transfer.src-lot-serial COLON 30 LABEL "源批/序号"
      transfer.desti-lot-serial COLON 50 LABEL "目标批/序号"
    SKIP(1)
   
    transfer.transfer-date COLON 30 LABEL "出库日期"
    SKIP(1)
    prndate COLON 30 LABEL "打印日期"
    WITH WIDTH 180 SIDE-LABEL.
DEFINE FRAME mlabelin
    SKIP(1)
    SKIP(1)
    SKIP(1)
    SKIP(1)
    "入库
     COLON 20
    transfer.part COLON 30 LABEL "零件代码"
    pt_desc1 COLON 50 LABEL "零件描述" 
    pt_desc2 COLON 80
    SKIP(1)
  transfer.transfer-qty COLON 20 LABEL "数量"
    "自" COLON 30
    "至" COLON 50
    SKIP(1)
    transfer.src-site COLON 30 LABEL "源地点"
    transfer.desti-site COLON 50 LABEL "目标地点"
    SKIP(1)
    transfer.rc-loc COLON 30 LABEL "源库位"
   transfer.desti-loc COLON 50 LABEL "目标库位"
    SKIP(1)
    transfer.src-lot-serial COLON 30 LABEL "源批/序号"
      transfer.desti-lot-serial COLON 50 LABEL "目标批/序号"
    SKIP(1)
   
    transfer.transfer-date COLON 30 LABEL "入库日期"
    SKIP(1)
    prndate COLON 30 LABEL "打印日期"
    WITH WIDTH 180 SIDE-LABEL.
DEFINE FRAME mlabelsrcremain
    SKIP(1)
    SKIP(1)
    SKIP(1)
    SKIP(1)
    "剩余库存"
     COLON 20
    transfer.transfer-part COLON 30 LABEL "零件代码"
    pt_desc1 COLON 50 LABEL "零件描述" 
    pt_desc2 COLON 80
    SKIP(1)
src-remain-pallet COLON 20 LABEL "数量"
    
    transfer.src-site COLON 30 LABEL "地点"
    
    SKIP(1)
    transfer.src-loc COLON 30 LABEL "库位"
 
      
    SKIP(1)
   
    
    prndate COLON 30 LABEL "打印日期"
    WITH WIDTH 180 SIDE-LABEL.
DEFINE FRAME mlabeldestiupdate
    SKIP(1)
    SKIP(1)
    SKIP(1)
    SKIP(1)
    "现有库存"
     COLON 20
    transfer.transfer-part COLON 30 LABEL "零件代码"
    pt_desc1 COLON 50 LABEL "零件描述" 
    pt_desc2 COLON 80
    SKIP(1)
  desti-update-pallet COLON 20 LABEL "数量"
    
   transfer.desti-site COLON 30 LABEL "地点"
    
    SKIP(1)
    transfer.desti-loc COLON 30 LABEL "库位"
 
   
      
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
           /* isrecord = NO.
            FIND pt_mstr WHERE pt_part = part NO-LOCK.*/
           
            FOR EACH tr_hist  WHERE tr_part = part AND tr_type = 'iss-tr'AND tr_date = mdate NO-LOCK:
              assign
                  transfer.transfer-nbr = tr_trnbr 
                  transfer.transfer-part = tr_part
                  transfer.src-lot-serial = tr_serial
                  transfer.transfer-qty = tr_qty_chg 
                  
                 transfer.src-site = tr_ref_site
                        transfer.src-loc = tr_loc.
                  /* IF pt_lot_ser THEN DO:   
                   
                       FOR EACH trhist  WHERE trhist.tr_part = tr_hist.tr_part AND tr_type = 'rct-tr' AND trhist.tr_date = tr_hist.tr_date 
                   AND  tr_hist.tr_qty_chg = trhist.tr_qty_chg AND trhist.tr_serial = tr_hist.tr_serial NO-LOCK:
                    assign
                       transfer.desti-site = tr_ref_site
                        transfer.desti-loc = tr_loc
                         transfer.desti-lot-serial = tr_serial.

                       
                       
                        
                       
                    isrecord = YES.
               END.
               IF NOT isrecord THEN 
                   FOR EACH trhist  WHERE trhist.tr_part = tr_hist.tr_part AND tr_type = 'rct-tr' AND trhist.tr_date = tr_hist.tr_date 
                   AND  tr_hist.tr_qty_chg = trhist.tr_qty_chg  NO-LOCK:
                    assign
                       transfer.desti-site = tr_ref_site
                        transfer.desti-loc = tr_loc
                        transfer.desti-lot-serial = tr_serial.
               END.
            END.
            ELSE*/
                FOR EACH trhist  WHERE trhist.tr_part = tr_hist.tr_part AND tr_type = 'rct-tr' AND trhist.tr_date = tr_hist.tr_date 
                   AND  tr_hist.tr_qty_chg = trhist.tr_qty_chg  NO-LOCK:
               assign
                       transfer.desti-site = tr_ref_site
                        transfer.desti-loc = tr_loc
                   transfer.desti-lot-serial = tr_serial.
              END. 
            END.
             mainloop:
REPEAT:
            OPEN QUERY qry FOR EACH transfer BY transfer-nbr DESCENDING.
    ENABLE ALL WITH FRAME fr-brws.
    ON 'choose':U OF b-done
DO:
    FIND pt_mstr WHERE pt_part = part NO-LOCK.
DISABLE ALL WITH FRAME fr-brws.
    i = brw:NUM-SELECTED-ROWS.
        brw:FETCH-SELECTED-ROW(i).
            DISPLAY transfer.transfer-nbr 
                transfer.transfer-date
                transfer.transfer-part 
            pt_desc1 
    pt_desc2 
               transfer.src-lot-serial 
                transfer.desti-lot-serial
        transfer.transfer-qty 
           transfer. src-site 
            transfer.src-loc
            transfer.desti-site 
           transfer.desti-loc 
                WITH FRAME inventory-transfer.
            ENABLE ALL WITH FRAME invertory-transfer.
            seta3:
      do transaction on error undo, retry:
          UPDATE src-pallet WITH FRAME inventory-transfer.
          IF src-pallet = 0  THEN DO:
                    MESSAGE "源铲板数量不能为零!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

                   NEXT-PROMPT src-pallet WITH FRAME inventory-transfer.
               UNDO,RETRY.
                END.
            END.
             seta4:
      do transaction on error undo, retry:
          UPDATE desti-pallet WITH FRAME inventory-transfer.
          IF desti-pallet = 0  THEN DO:
                    MESSAGE "目标铲板数量不能为零!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

                   NEXT-PROMPT desti-pallet WITH FRAME inventory-transfer.
               UNDO,RETRY.
                END.
            END.

    
END.
    WAIT-FOR CHOOSE OF b-done.

{mfselbpr.i "printer" 80}


src-remain-pallet = src-pallet - transfer.transfer-qty .
desti-update-pallet = desti-pallet + transfer.transfer-qty.
FIND pt_mstr WHERE pt_part = part NO-LOCK.
DISPLAY "出库
    
    transfer.transfer-part 
    pt_desc1 
    pt_desc2
    
  transfer.transfer-qty 
    "自" 
    "至"
    
    transfer.src-site 
    transfer.desti-site 
   
    transfer.src-loc 
   transfer.desti-loc 
    
    transfer.src-lot-serial 
      transfer.desti-lot-serial 
    
   
    transfer.transfer-date 
    
    prndate 
    WITH FRAME mlabelin.
PAGE.
DISPLAY "入库
    
    transfer.transfer-part 
    pt_desc1 
    pt_desc2
    
  transfer.transfer-qty 
    "自" 
    "至"
    
    transfer.src-site 
    transfer.desti-site 
   
    transfer.src-loc 
   transfer.desti-loc 
    
    transfer.src-lot-serial 
      transfer.desti-lot-serial 
    
   
    transfer.transfer-date 
    
    prndate 
    WITH FRAME mlabelout.
PAGE.
DISPLAY "剩余库存"
    
    transfer.transfer-part 
    pt_desc1 
    pt_desc2 
   
src-remain-pallet 
    
    transfer.src-site 
    
 
    transfer.src-loc
 
      
 
   
    
    prndate 
    WITH FRAME mlabelsrcremain.
PAGE.
DISPLAY "现有库存"
    
    transfer.transfer-part 
    pt_desc1 
    pt_desc2 
   
  desti-update-pallet 
    
   transfer.desti-site 
    
    
    transfer.desti-loc 
 
   
      
  
   
    
    prndate 
    WITH FRAME mlabeldestiupdate.
{mftrl080.i}
END.




                    
                    

