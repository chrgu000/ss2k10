 
 {mfdtitle.i  }
/*{mfdeclre.i}*/
 define  variable part like pt_part VIEW-AS fill-in SIZE 20 BY 1 LABEL "零件代码" .
DEFINE VAR mdate like tr_date  VIEW-AS FILL-IN SIZE 8 BY 1 LABEL "日期".
DEFINE VAR mdate1 like tr_date  VIEW-AS FILL-IN SIZE 8 BY 1 LABEL "至".
DEFINE VAR prndate LIKE tr_date INITIAL TODAY.
DEFINE BUTTON b-done LABEL "Select" SIZE 12 BY 1.

DEFINE VAR isrecord AS LOGICAL INITIAL NO. 
/*DEFINE VAR src-pallet AS INT VIEW-AS FILL-IN SIZE 12 BY 1 LABEL "源铲板数量".
DEFINE VAR desti-pallet AS INT VIEW-AS FILL-IN SIZE 12 BY 1 LABEL "目标铲板数量".
DEFINE VAR src-remain-pallet AS INT.
DEFINE VAR desti-update-pallet AS INT.*/
DEFINE VAR pallet-per AS INT VIEW-AS fill-in SIZE 12 BY 1 LABEL "每铲板数量" .
    DEFINE VAR pallet-qty AS INT VIEW-AS FILL-IN SIZE 12 BY 1 LABEL  "铲板数量".
     define var mcount as int initial 0.
    DEFINE VAR pallet-qtys AS INT EXTENT 99 VIEW-AS FILL-IN SIZE 12 BY 1 LABEL "铲板".
 DEFINE VAR pallet-remain-qty LIKE tr_qty_loc.
    DEFINE VAR pallet-remain-qtys AS INT EXTENT 99 VIEW-AS FILL-IN SIZE 12 BY 1 LABEL "铲板".
    DEFINE VAR item-qty LIKE  tr_qty_loc.
      def  var mname like ad_name.
DEFINE BUFFER trhist FOR tr_hist.  
    
    DEFINE VAR standard AS LOGICAL initial yes VIEW-AS FILL-IN SIZE 5 BY 1 FORMAT "Yes/No" LABEL "标准".
    DEFINE VAR remain AS LOGICAL.
    DEFINE VAR i AS INT.
   define var isavailable as logical initial no.
    DEFINE TEMP-TABLE transfer FIELD transfer-nbr LIKE tr_trnbr 
        FIELD transfer-date LIKE tr_date
        FIELD transfer-part LIKE tr_part 
        FIELD src-lot-serial LIKE tr_serial
         FIELD desti-lot-serial LIKE tr_serial
        FIELD transfer-qty LIKE tr_qty_loc
    FIELD src-site LIKE tr_site 

    FIELD src-loc LIKE tr_loc

    FIELD desti-site LIKE tr_site 

    FIELD desti-loc LIKE tr_loc
FIELD transfer-um LIKE tr_um
    .
     define var itemdesc as char format "x(48)".

    DEFINE QUERY qry FOR transfer.
    DEFINE BROWSE brw QUERY qry
    DISPLAY transfer.transfer-nbr LABEL "事务号"
        transfer.transfer-date LABEL "日期"    
        transfer.transfer-part LABEL "零件代码"
           
        transfer.transfer-qty LABEL "移库数量"
            transfer.src-site COLUMN-LABEL "源地点"
            transfer.src-loc COLUMN-LABEL "源库位"
            transfer.desti-site COLUMN-LABEL "目标地点"
           transfer.desti-loc COLUMN-LABEL "目标库位"
         transfer.src-lot-serial LABEL "源批/序号"
        transfer.desti-lot-serial LABEL "目标批/序号"
         /*ENABLE ALL*/
    WITH 7 DOWN WIDTH 77 TITLE "移库事务" LABEL-FGCOLOR 15 LABEL-BGCOLOR 7  SEPARATORS.
DEFINE FRAME fr-brws
       brw 
       SKIP(0.5)
       b-done AT COLUMN 60 ROW 11
       
       WITH size-chars 80 by 12.5.
          
    FORM
  
   SKIP(0.5)
    part COLON 15
        SKIP(0.5)
        mdate COLON 15
        mdate1 COLON 40
       
    WITH  FRAME a width 80 attr-space  three-d TITLE "移库标签打印"  SIDE-LABEL.
  DEFINE FRAME inventory-transfer
     skip(0.5)
      transfer.transfer-nbr COLON 20 LABEL "事务号"
      transfer.transfer-date COLON 35 LABEL "日期"     
     
      transfer.transfer-part COLON 55 LABEL "零件代码"
           SKIP(0.5)
    itemdesc colon 20 LABEL "零件描述" 
     /*  pt_desc1 COLON 20 LABEL "零件描述" 
    pt_desc2 COLON 50*/
      SKIP(0.5)
        transfer.transfer-qty COLON 20 LABEL "移库数量"
      
      SKIP(0.5)      
      transfer.src-site COLON 20 LABEL "源地点"
           
            transfer.desti-site COLON 50 LABEL "目标地点"
           SKIP(0.5)
            transfer.src-loc COLON 20 LABEL "源库位"
            transfer.desti-loc COLON 50 LABEL "目标库位"
     SKIP(0.5)
       transfer.src-lot-serial COLON 20 LABEL "源批/序号"
      transfer.desti-lot-serial COLON 50 LABEL "目标批/序号"
      /*SKIP(1)
      src-pallet COLON 20 
      desti-pallet COLON 50*/
        SKIP(0.5)
     standard COLON 20 
      WITH WIDTH 80 THREE-D SIDE-LABEL.
   FORM
    SKIP(0.5)
    Pallet-per COLON 18
    pallet-qty COLON 45
    
    WITH  FRAME std WIDTH 80 THREE-D SIDE-LABEL .
FORM
    
    SKIP(0.5)
    pallet-qtys 
   
    WITH  title "铲板移库数量" FRAME unstd WIDTH 80 THREE-D SIDE-LABEL.
  FORM
    
    SKIP(0.5)
   
    pallet-remain-qtys 
    WITH title "铲板剩余数量" FRAME unstd-remain WIDTH 80 THREE-D SIDE-LABEL.

/*DEFINE FRAME mlabelout
    SKIP(1)
    SKIP(1)
    
    "出库" at 12
    SKIP(1)
    SKIP(1)
    transfer.transfer-part at 12 LABEL "零件代码" 
    item-qty at 48 LABEL "零件数量"
  SKIP(1)
  itemdesc at 12 label "零件描述" 

  /*  pt_desc1 COLON 50 LABEL "零件描述" 
    pt_desc2 COLON 80*/
   /* SKIP(1)
 
    "自" COLON 50
    "至" COLON 80*/
    SKIP(1)
    transfer.src-site at 12 LABEL "源地点"
    transfer.desti-site at 48 LABEL "目标地点"
   SKIP(1)
   transfer.src-loc at 12 LABEL "源库位" 
     transfer.desti-loc at 48 LABEL "目标库位" 
     SKIP(1)
    
  transfer.src-lot-serial at 12 LABEL "源批/序号"
    
     
   
      transfer.desti-lot-serial at 48 LABEL "目标批/序号"
    SKIP(1)
   
    transfer.transfer-date at 12 LABEL "出库日期"
    SKIP(1)
    prndate at 12 LABEL "打印日期"
    WITH   stream-io  WIDTH 180 SIDE-LABEL.
DEFINE FRAME mlabelout1
    SKIP(1)
    SKIP(1)
    
    "出库" at 12
    SKIP(1)
    SKIP(1)
    transfer.transfer-part at 12 LABEL "零件代码" 
    item-qty at 48 LABEL "零件数量"
  SKIP(1)
  itemdesc at 12 label "零件描述" 

  /*  pt_desc1 COLON 50 LABEL "零件描述" 
    pt_desc2 COLON 80*/
   /* SKIP(1)
 
    "自" COLON 50
    "至" COLON 80*/
    SKIP(1)
    transfer.src-site at 12 LABEL "源地点"
    transfer.desti-site at 48 LABEL "目标地点"
   SKIP(1)
   transfer.src-loc at 12 LABEL "源库位" 
     transfer.desti-loc at 48 LABEL "目标库位" 
     SKIP(1)
    
  transfer.src-lot-serial at 12 LABEL "源批/序号"
    
     
   
      transfer.desti-lot-serial at 48 LABEL "目标批/序号"
    SKIP(1)
   
    transfer.transfer-date at 12 LABEL "出库日期"
    SKIP(1)
    prndate at 12 LABEL "打印日期"
    WITH   stream-io  WIDTH 180 SIDE-LABEL.*/

DEFINE FRAME mlabeltr
    skip(5)
    
   
   "(1) 移库" at 4
   "(2)打印日期/Print Date:" at 37
   "(3)入库日期/Receipt Date:" at 62
   skip
   prndate at 40 no-label
    transfer.transfer-date at 65 no-label
   skip(1)
    "(4)零件代码/Part NO.:" at 4
   "(5)数量/Quantity:" at 37
   "(6)单位/Unit:" at 62
   skip
       transfer.transfer-part at 7 no-label
        item-qty  at 41 no-label
        transfer.transfer-um at 65 no-label
        skip(1)
  
 "(7)零件描述/Desc:" at 4
   skip 
  itemdesc at 7  no-label

    skip(1)
   "(8)移出地点/库位/From:" at 4 space(1) transfer.src-site no-label
   "(9)移入地点/库位/To:" at 37 space(1)  transfer.desti-site no-label
   skip
     transfer.src-loc no-label at 7
     transfer.desti-loc no-label at 40

 
   skip(1)
   "(10)采购单号/加工单号/Order:" at 4
   "(11)供应商代码/Supplier:" at 37
   "(12)收货单号/Receiver:" at 62
   skip
      /*  transfer.transfer-nbr at 15  no-label
      transfer.transfer-addr at 48 no-label
       transfer.transfer-lot at 74 no-label*/
   skip(1)
   "(13)供应商/Name of supplier:" at 4 
   "(14)QAD批序号/Lot:" at 62 
       skip
       mname at 7 no-label
       transfer.desti-lot-serial at 66 no-label
      
   
    WITH    stream-io WIDTH 180 SIDE-LABEL.
    
    DEFINE FRAME mlabeltr1
     skip(5)
    
   
   "(1) 移库" at 4
   "(2)打印日期/Print Date:" at 37
   "(3)入库日期/Receipt Date:" at 62
   skip
   prndate at 40 no-label
    transfer.transfer-date at 65 no-label
   skip(1)
    "(4)零件代码/Part NO.:" at 4
   "(5)数量/Quantity:" at 37
   "(6)单位/Unit:" at 62
   skip
       transfer.transfer-part at 7 no-label
        item-qty  at 41 no-label
        transfer.transfer-um at 65 no-label
        skip(1)
  
 "(7)零件描述/Desc:" at 4
   skip 
  itemdesc at 7  no-label

    skip(1)
   "(8)移出地点/库位/From:" at 4 space(1) transfer.src-site no-label
   "(9)移入地点/库位/To:" at 37 space(1)  transfer.desti-site no-label
   skip
     transfer.src-loc no-label at 7
     transfer.desti-loc no-label at 40

 
   skip(1)
   "(10)采购单号/加工单号/Order:" at 4
   "(11)供应商代码/Supplier:" at 37
   "(12)收货单号/Receiver:" at 62
   skip
      /*  transfer.transfer-nbr at 15  no-label
      transfer.transfer-addr at 48 no-label
       transfer.transfer-lot at 74 no-label*/
   skip(1)
   "(13)供应商/Name of supplier:" at 4 
   "(14)QAD批序号/Lot:" at 62 
       skip
       mname at 7 no-label
       transfer.desti-lot-serial at 66 no-label
      
   
    WITH    stream-io WIDTH 180 SIDE-LABEL.
 DEFINE FRAME mlabelsrcremain
    skip(5)
    
   
   "(1) 剩余" at 4
   "(2)打印日期/Print Date:" at 37
   "(3)入库日期/Receipt Date:" at 62
   skip
   prndate at 40 no-label
    transfer.transfer-date at 65 no-label
   skip(1)
    "(4)零件代码/Part NO.:" at 4
   "(5)数量/Quantity:" at 37
   "(6)单位/Unit:" at 62
   skip
       transfer.transfer-part at 7 no-label
         pallet-remain-qty   at 40 no-label
        transfer.transfer-um at 65 no-label
        skip(1)
  
 "(7)零件描述/Desc:" at 4
   skip 
  itemdesc at 7  no-label

    skip(1)
   "(8)移出地点/库位/From:" at 4 space(1) transfer.src-site no-label
   "(9)移入地点/库位/To:" at 37 
   skip
     transfer.src-loc no-label at 7
    
   skip(1)
   "(10)采购单号/加工单号/Order:" at 4
   "(11)供应商代码/Supplier:" at 37
   "(12)收货单号/Receiver:" at 62
   skip
      /*  transfer.transfer-nbr at 15  no-label
      transfer.transfer-addr at 48 no-label
       transfer.transfer-lot at 74 no-label*/
   skip(1)
   "(13)供应商/Name of supplier:" at 4 
   "(14)QAD批序号/Lot:" at 62 
       skip
       mname at 7 no-label
      /* transfer.src-lot-serial at 74 no-label*/
      
   
    WITH    stream-io WIDTH 180 SIDE-LABEL.
 DEFINE FRAME mlabelsrcremain1
    skip(5)
    
   
   "(1) 剩余" at 4
   "(2)打印日期/Print Date:" at 37
   "(3)入库日期/Receipt Date:" at 62
   skip
   prndate at 40 no-label
    transfer.transfer-date at 65 no-label
   skip(1)
    "(4)零件代码/Part NO.:" at 4
   "(5)数量/Quantity:" at 37
   "(6)单位/Unit:" at 62
   skip
       transfer.transfer-part at 7 no-label
         pallet-remain-qty   at 40 no-label
        transfer.transfer-um at 65 no-label
        skip(1)
  
 "(7)零件描述/Desc:" at 4
   skip 
  itemdesc at 7  no-label

    skip(1)
   "(8)移出地点/库位/From:" at 4 space(1) transfer.src-site no-label
   "(9)移入地点/库位/To:" at 37 
   skip
     transfer.src-loc no-label at 7
    
   skip(1)
   "(10)采购单号/加工单号/Order:" at 4
   "(11)供应商代码/Supplier:" at 37
   "(12)收货单号/Receiver:" at 62
   skip
      /*  transfer.transfer-nbr at 15  no-label
      transfer.transfer-addr at 48 no-label
       transfer.transfer-lot at 74 no-label*/
   skip(1)
   "(13)供应商/Name of supplier:" at 4 
   "(14)QAD批序号/Lot:" at 62 
       skip
       mname at 7 no-label
      /* transfer.src-lot-serial at 74 no-label*/
      
   
    WITH    stream-io WIDTH 180 SIDE-LABEL.


  

   

/*DEFINE FRAME mlabeldestiupdate
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
  /*desti-update-pallet COLON 20 LABEL "数量"*/
    
   transfer.desti-site COLON 30 LABEL "地点"
    
    SKIP(1)
    transfer.desti-loc COLON 30 LABEL "库位"
 
   
      
    SKIP(1)
   
    
    prndate COLON 30 LABEL "打印日期"
    WITH WIDTH 180 SIDE-LABEL.*/

    DISPLAY  part mdate WITH FRAME a.
/* ENABLE ALL WITH FRAME a.  */
repeat:
    FOR EACH transfer:
        DELETE transfer.
    END.
    disable all with frame fr-brws.
    isavailable = NO.
    seta1:
      do transaction on error undo, retry:
         SET part WITH FRAME a EDITING:
     
          {mfnp.i pt_mstr part pt_part part pt_part pt_part}

          if recno <> ? then do:
               part = pt_part.
               display part with frame a.
               recno = ?.
            end.
          END.
       
          if part = "" then do:
       MESSAGE "无效零件代码!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

             NEXT-PROMPT part WITH FRAME a.
         UNDO,RETRY.

      
      
        end.
         for FIRST  tr_hist WHERE tr_part = part and tr_type = 'iss-tr' NO-LOCK:
         isavailable = yes.
         end.
          IF not isavailable THEN DO:
              MESSAGE "无效零件代码!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

             NEXT-PROMPT part WITH FRAME a.
         UNDO,RETRY.
          END.
     isavailable = no.
      END.
     mdate = ?.
     mdate1 = ?.
      if mdate = low_date then mdate = ?.
if mdate1 = hi_date then mdate1 = ?.
UPDATE mdate mdate1 WITH FRAME a.
IF MDATE = ? THEN MDATE = LOW_DATE.

IF MDATE1 = ? THEN MDATE1 = HI_DATE.
      /* seta2:
            do transaction on error undo, retry:
                UPDATE mdate WITH FRAME a.
               if mdate = ? then do:
               mdate = today.
               display mdate with frame a.
               end.
               FOR EACH tr_hist  WHERE tr_part = part AND tr_type = 'iss-tr'AND tr_date = mdate NO-LOCK:
                isavailable = yes.
                 end.
                 IF not isavailable  THEN DO:
                   MESSAGE "当前日期无移库事务!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

                   NEXT-PROMPT mdate WITH FRAME a.
               UNDO,RETRY.
                END.
           ISAVAILABLE = NO.
            END.*/
          /*  isrecord = NO.
            FIND pt_mstr WHERE pt_part = part NO-LOCK.*/
           for FIRST tr_hist   WHERE tr_part = part AND tr_type = 'iss-tr'AND tr_date >= mdate AND tr_date <= mdate1  AND tr_qty_loc < 0 NO-LOCK:
            isavailable = yes.
            end.   
              if not isavailable then 
             MESSAGE "当前日期范围无移库事务!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

            
            
            
              
               ELSE DO:
              
            FOR EACH tr_hist  WHERE tr_hist.tr_part = part AND tr_hist.tr_type = 'iss-tr'AND tr_hist.tr_date >= mdate AND tr_hist.tr_date <= mdate1  AND tr_hist.tr_qty_loc < 0 NO-LOCK:
               /* isrecord = NO.*/
              if isrecord then do:
              find  first transfer where transfer.transfer-nbr = tr_trnbr NO-LOCK NO-ERROR.
                if not available transfer then
                CREATE transfer.
               
               end.
               else
                 CREATE transfer.

               
                assign
                  transfer.transfer-nbr = tr_trnbr 
                  transfer.transfer-part = tr_part
                  transfer.src-lot-serial = tr_serial
                  transfer.transfer-qty = tr_qty_loc * (-1) 
                   transfer.transfer-date = tr_date
                 transfer.src-site = tr_site
                        transfer.src-loc = tr_loc
                    transfer.transfer-um = tr_um.
                  /* IF pt_lot_ser THEN DO: */  
                    isrecord = yes.
              FIND FIRST trhist  WHERE trhist.tr_part = tr_hist.tr_part AND trhist.tr_type = 'rct-tr' AND trhist.tr_date = tr_hist.tr_date AND trhist.tr_qty_loc > 0 
       AND  trhist.tr_qty_loc = ABS(tr_hist.tr_qty_loc) AND trhist.tr_serial = tr_hist.tr_serial   NO-LOCK NO-ERROR.
              IF AVAILABLE trhist THEN
              assign
           transfer.desti-site = trhist.tr_site
            transfer.desti-loc = trhist.tr_loc
            transfer.desti-lot-serial = trhist.tr_serial.
  

                       
                       
                        
                       
                    /*isrecord = YES.*/
               /*END.*/
              ELSE DO:
             
             /* IF NOT isrecord THEN */
                  FIND FIRST trhist  WHERE trhist.tr_part = tr_hist.tr_part AND trhist.tr_type = 'rct-tr' AND trhist.tr_date = tr_hist.tr_date AND trhist.tr_qty_loc > 0 
               AND  trhist.tr_qty_loc = ABS(tr_hist.tr_qty_loc)   NO-LOCK NO-ERROR.
                assign
                   transfer.desti-site = trhist.tr_site
                    transfer.desti-loc = trhist.tr_loc
                    transfer.desti-lot-serial = trhist.tr_serial.
           END.

            END.
           /* ELSE
                  FOR EACH trhist  WHERE trhist.tr_part = tr_hist.tr_part AND tr_type = 'rct-tr' AND trhist.tr_date = tr_hist.tr_date AND tr_qty_loc > 0 
                   AND  trhist.tr_qty_loc = ABS(tr_hist.tr_qty_loc)   NO-LOCK:
                    assign
                       transfer.desti-site = trhist.tr_site
                        transfer.desti-loc = trhist.tr_loc
                        transfer.desti-lot-serial = trhist.tr_serial.
               END. 

            END. */
   repeat:
    OPEN QUERY qry FOR EACH transfer BY transfer-nbr DESCENDING.
   ENABLE ALL WITH FRAME fr-brws.
    ON 'choose':U OF b-done
DO:
   

    FIND pt_mstr WHERE pt_part = part NO-LOCK.
  itemdesc = pt_desc1 + pt_desc2.
   /* HIDE FRAME fr-brws.*/
    /*DISABLE ALL WITH FRAME fr-brws.*/
   /* i = brw:NUM-SELECTED-ROWS.
        brw:FETCH-SELECTED-ROW(i).*/
            DISPLAY transfer.transfer-nbr 
                transfer.transfer-date
                transfer.transfer-part 
           itemdesc
               transfer.src-lot-serial 
                transfer.desti-lot-serial
        transfer.transfer-qty 
           transfer.src-site 
            transfer.src-loc
            transfer.desti-site 
           transfer.desti-loc 
                WITH FRAME inventory-transfer.
            ENABLE ALL WITH FRAME invertory-transfer.
      
 
END.
     WAIT-FOR CHOOSE OF b-done.    
       UPDATE standard WITH FRAME inventory-transfer.
/*i = brw:NUM-SELECTED-ROWS.
        brw:FETCH-SELECTED-ROW(i).*/
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
       
      
         IF  transfer.transfer-qty MOD pallet-per <> 0 THEN DO:
          
              pallet-qty = TRUNCATE( transfer.transfer-qty / pallet-per,0) + 1.
                remain = YES.  
              END.
             ELSE DO:
            REMAIN = NO.
             pallet-qty =  transfer.transfer-qty / pallet-per.
              END.
          display pallet-qty WITH FRAME std.
       
          END.  
        ELSE
        DO:
       
              seta5:
      do transaction on error undo, retry:
        repeat i = 1 to 99 by 1 :
       pallet-qtys[i] = 0.
        end.  
   mcount = 0.
              UPDATE 
              
                  pallet-qtys 
                  WITH 3 COLUMN FRAME unstd .
               repeat i = 1 to 99 by 1:
             mcount = mcount + pallet-qtys[i].
             end.
             if mcount > transfer.transfer-qty then do:
             MESSAGE "输入数量超过移库数量!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

           /* update  pallet-qtys with 3 column frame unstd.*/
             undo,retry.
         end.
        end.
              HIDE FRAME unstd.
              repeat i = 1 to 99 by 1 :
       pallet-remain-qtys[i] = 0.
        end.  

            
              UPDATE
                  pallet-remain-qtys
                  WITH 3 COLUMN FRAME unstd-remain.
              

          END.
repeat:
{mfselbpr.i "printer" 80} /*output to printer.*/

/*src-remain-pallet = src-pallet - transfer.transfer-qty .
desti-update-pallet = desti-pallet + transfer.transfer-qty.*/
FIND pt_mstr WHERE pt_part = part NO-LOCK.
itemdesc = pt_desc1 + pt_desc2.
 IF standard THEN DO:
 
         
              REPEAT i = 1 TO pallet-qty BY 1 :
               item-qty = pallet-per.
                   
                       IF i = pallet-qty  THEN DO:
                  
                   IF remain THEN DO:
                   
                       item-qty = transfer.transfer-qty  MOD pallet-per.
                  
                      END.  
                      
                   END.
 
  
                    DISPLAY 
    
    transfer.transfer-part 
  itemdesc
    
  item-qty
   /* "自" 
    "至"*/
    
    transfer.src-site 
    transfer.desti-site 
   
    transfer.src-loc 
   transfer.desti-loc 
    
    
      transfer.desti-lot-serial 
    transfer.transfer-um
   
    transfer.transfer-date 
    
    prndate 
    WITH FRAME mlabeltr.
                     PAGE.
                  
/*DISPLAY 
    
    transfer.transfer-part 
    itemdesc
    
 item-qty
    transfer.transfer-um
    
    transfer.src-site 
    transfer.desti-site 
   
    transfer.src-loc 
   transfer.desti-loc 
    
    transfer.src-lot-serial 
      transfer.desti-lot-serial 
    
   
    transfer.transfer-date 
    
    prndate 
    WITH FRAME mlabelout.
      PAGE.*/
          END.
          IF remain THEN do:
              pallet-remain-qty = pallet-per - transfer.transfer-qty MOD pallet-per.
         
     DISPLAY 
    
    transfer.transfer-part 
  itemdesc
   
pallet-remain-qty
    
    transfer.src-site 
    
 
    transfer.src-loc
 
      
  transfer.transfer-um
   
    
    prndate 
    WITH FRAME mlabelsrcremain.
 PAGE.
         
 END.        
       
     
               
END.
             
              ELSE
                  REPEAT i = 1 TO 99 BY 1 :
                   IF pallet-qtys[i] <> 0 THEN do:
                    item-qty = pallet-qtys[i].
               
                 end.
                  IF pallet-remain-qtys[i] <> 0 THEN do:
                  pallet-remain-qty = pallet-remain-qtys[i].
                
               end.
                
                   IF pallet-qtys[i] <> 0  THEN DO:
                
                       DISPLAY
    
    transfer.transfer-part 
   itemdesc
    
  item-qty
  
     transfer.transfer-um
    transfer.src-site 
    transfer.desti-site 
   
    transfer.src-loc 
   transfer.desti-loc 
    
    /*transfer.src-lot-serial */
      transfer.desti-lot-serial 
    
   
    transfer.transfer-date 
    
    prndate 
    WITH FRAME mlabeltr1.
                                   PAGE.
       /* DISPLAY 
    
    transfer.transfer-part 
   itemdesc
    
 item-qty
    
    
    transfer.src-site 
    transfer.desti-site 
   
    transfer.src-loc 
   transfer.desti-loc 
    
    transfer.src-lot-serial 
      transfer.desti-lot-serial 
    
   
    transfer.transfer-date 
    
    prndate 
    WITH FRAME mlabelout1.*/
       
                          END.
               
                
             IF pallet-remain-qtys[i] <> 0 THEN DO:
             

          DISPLAY 
    
    transfer.transfer-part 
   itemdesc
   
pallet-remain-qty
    
    transfer.src-site 
    
 
    transfer.src-loc
 
       transfer.transfer-um
 
   
    
    prndate 
    WITH FRAME mlabelsrcremain1.
    PAGE.
     
     END.     
    END.
                      
                      
                      
                      
                      
                    
                 


{mftrl080.i} /*output close.*/
end.

    END.
end.
end.



