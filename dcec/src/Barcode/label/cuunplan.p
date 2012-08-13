 {mfdtitle.i}
/*{mfdeclre.i}*/
 define  variable part like pt_part VIEW-AS fill-in SIZE 20 BY 1 LABEL "零件代码" .
DEFINE VAR mdate like tr_date  VIEW-AS FILL-IN SIZE 8 BY 1 LABEL "日期".
DEFINE VAR mdate1 like tr_date  VIEW-AS FILL-IN SIZE 8 BY 1 LABEL "至".
DEFINE VAR prndate LIKE tr_date INITIAL TODAY.
DEFINE BUTTON b-done LABEL "Select" SIZE 12 BY 1.
DEFINE VAR isrecord AS LOGICAL. 
define var isavailable as logical initial no.
DEFINE VAR standard AS LOGICAL initial yes VIEW-AS FILL-IN SIZE 5 BY 1 FORMAT "Yes/No" LABEL "标准".
DEFINE VAR pallet-per AS INT VIEW-AS fill-in SIZE 12 BY 1 LABEL "每铲板数量" .
    DEFINE VAR pallet-qty AS INT VIEW-AS FILL-IN SIZE 12 BY 1 LABEL  "铲板数量".
    define var mcount as int initial 0. 
    DEFINE VAR pallet-qtys AS INT EXTENT 99 VIEW-AS FILL-IN SIZE 12 BY 1 LABEL "铲板".
    DEFINE VAR totalqty LIKE tr_qty_loc.
    DEFINE VAR remain AS LOGICAL.
    DEFINE VAR i AS INT.
    DEFINE VAR mline LIKE tr_line VIEW-AS fill-in SIZE 5 BY 1 LABEL "行".
    DEFINE VAR item-qty LIKE  tr_qty_loc.
   define var remain-qty like ld_qty_oh.
   DEFINE VAR j AS INT.
   def  var mname like ad_name.
  define var msite as char format "x(15)".
 define var mloc as char format "x(15)".
define var itemdesc as char format "x(48)".
    DEFINE VAR pallet-remain-qty LIKE tr_qty_loc.
    DEFINE VAR pallet-remain-qtys AS INT EXTENT 99 VIEW-AS FILL-IN SIZE 12 BY 1 LABEL "铲板".
   define var mtr_qty_loc like tr_qty_loc.
   define var mpro like glt_project.
    DEFINE QUERY qry FOR tr_hist.
    DEFINE BROWSE brw  QUERY qry
    DISPLAY tr_hist.tr_trnbr LABEL "事务号"
        tr_hist.tr_nbr LABEL "订单号"
        
        tr_hist.tr_date LABEL "日期"    
        tr_hist.tr_type LABEL "事务类型"
        tr_hist.tr_part LABEL "零件代码"
           abs(tr_hist.tr_qty_loc)  LABEL "数量" 
          tr_hist.tr_site  column-label "地点"  
            tr_hist.tr_loc column-LABEL "库位" 
           tr_hist.tr_serial LABEL "批/序号"
      
      
           
            
         
    WITH   7 DOWN WIDTH 77 TITLE "计划外出/入库事务" LABEL-FGCOLOR 15 LABEL-BGCOLOR 9 /*MULTIPLE*/ SEPARATORS.
DEFINE FRAME fr-brws
       brw SKIP(0.5)
       b-done AT COLUMN 60 ROW 11 SKIP(0.5)
       WITH SIZE-CHARS 80 BY 12.5.
          
    FORM
     SKIP(0.5)
    part COLON 15
        SKIP(0.5)
        mdate COLON 15
        mdate1 COLON 40
       
    WITH  FRAME a WIDTH 80 three-d TITLE "计划外出/入库标签打印" SIDE-LABEL.
  DEFINE FRAME unplan-inventory
      SKIP(0.5)
      tr_hist.tr_trnbr COLON 20 LABEL "事务号"
        tr_hist.tr_date COLON 35 LABEL "日期"    
        tr_hist.tr_type COLON 55 LABEL "事务类型"
      skip(0.5)  
      tr_hist.tr_part COLON 20 LABEL "零件代码"
    
  mtr_qty_loc COLON 45 LABEL "数量"
    skip(0.5)
     
      /* pt_desc1 COLON 20 LABEL "零件描述" 
    pt_desc2 COLON 50*/
    itemdesc colon 20 LABEL "零件描述" 

      skip(0.5)
      
        tr_hist.tr_nbr COLON 20 LABEL "订单号"
        skip(0.5)
            tr_hist.tr_site COLON 20 LABEL "地点"
            tr_hist.tr_loc COLON 45 LABEL "库位"
        skip(0.5)
         tr_hist.tr_serial COLON 20 LABEL "批/序号"
      skip(0.5)
     standard COLON 20 
     
      WITH WIDTH 80 THREE-D SIDE-LABEL.
  FORM
    skip(0.5)
    Pallet-per COLON 18
    pallet-qty COLON 45
    
    WITH  FRAME std WIDTH 80 THREE-D SIDE-LABEL .
FORM
    
    skip(0.5)
    pallet-qtys 
   
    WITH title "铲板出/入库数量" FRAME unstd WIDTH 80 THREE-D SIDE-LABEL.
  FORM
    
    skip(0.5)
   
    pallet-remain-qtys 
    WITH title "铲板剩余数量" FRAME unstd-remain WIDTH 80 THREE-D SIDE-LABEL.

  DEFINE FRAME mlabelin
    skip(5)
    
   
   "(1) 计划外入库" AT 4
   "(2)打印日期/Print Date:" at 37
   "(3)入库日期/Receipt Date:" at 62
   skip
   prndate at 40 no-label
    tr_hist.tr_date at 65 no-label
   skip(1)
    "(4)零件代码/Part NO.:" at 4
   "(5)数量/Quantity:" at 37
   "(6)单位/Unit:" at 62
   skip
       tr_hist.tr_part at 7 no-label
        item-qty  at 40 no-label
        tr_hist.tr_um at 65 no-label
        skip(1)
  
 "(7)零件描述/Desc:" at 4
   skip 
  itemdesc at 7  no-label

    skip(1)
   "(8)移出地点/库位/From:" at 4
   "(9)移入地点/库位/To:" at 37 space(2)  tr_hist.tr_site no-label
   skip
     tr_hist.tr_loc no-label at 40
 
   skip(1)
   "(10)采购单号/加工单号/Order:" at 4
   "(11)供应商代码/Supplier:" at 37
   "(12)收货单号/Receiver:" at 62
   skip
       tr_hist.tr_nbr at 7  no-label
       tr_hist.tr_addr at 40 no-label
       tr_hist.tr_lot at 66 no-label
   skip(1)
   "(13)供应商/Name of supplier:" at 4 
   "(14)QAD批序号/Lot:" at 62 
       skip
       mname at 7 no-label
       tr_hist.tr_ser at 66 no-label
      
   
    WITH    stream-io WIDTH 180 SIDE-LABEL.
    DEFINE FRAME mlabelin1
    skip(5)
    
   
   "(1) 计划外入库" AT 4
   "(2)打印日期/Print Date:" at 37
   "(3)入库日期/Receipt Date:" at 62
   skip
   prndate at 40 no-label
    tr_hist.tr_date at 65 no-label
   skip(1)
    "(4)零件代码/Part NO.:" at 4
   "(5)数量/Quantity:" at 37
   "(6)单位/Unit:" at 62
   skip
       tr_hist.tr_part at 7 no-label
        item-qty  at 40 no-label
        tr_hist.tr_um at 65 no-label
        skip(1)
  
 "(7)零件描述/Desc:" at 4
   skip 
  itemdesc at 7  no-label

    skip(1)
   "(8)移出地点/库位/From:" at 4
   "(9)移入地点/库位/To:" at 37 space(2)  tr_hist.tr_site no-label
   skip
     tr_hist.tr_loc no-label at 40
 
   skip(1)
   "(10)采购单号/加工单号/Order:" at 4
   "(11)供应商代码/Supplier:" at 37
   "(12)收货单号/Receiver:" at 62
   skip
       tr_hist.tr_nbr at 7  no-label
       tr_hist.tr_addr at 40 no-label
       tr_hist.tr_lot at 66 no-label
   skip(1)
   "(13)供应商/Name of supplier:" at 4 
   "(14)QAD批序号/Lot:" at 62 
       skip
       mname at 7 no-label
       tr_hist.tr_ser at 66 no-label
      
   
    WITH    stream-io WIDTH 180 SIDE-LABEL.




    DEFINE FRAME mlabelout
    skip(1)
    skip(1)
   
   "出库" at 12
   skip(1)
   skip(1)
    
    tr_hist.tr_part at 12 LABEL "零件代码"
  item-qty at 47 LABEL "零件数量"  
   /*pt_desc1 COLON 50 LABEL "零件描述" 
    pt_desc2 COLON 80*/
  skip(1)
    itemdesc at 12  LABEL "零件描述" 

    skip(1)
   
    tr_hist.tr_nbr at 12 LABEL "订单号"
    mpro at 47 label "项目代码"

    skip(1)
   
     tr_hist.tr_site at 12 LABEL "地点"
 
    tr_hist.tr_loc at 47 LABEL "库位"
  
   skip(1)
    tr_hist.tr_serial at 12 LABEL "批/序号"
    skip(1)
    tr_hist.tr_date at 12 LABEL "出库日期"
    skip(1)
   prndate at 12 LABEL "打印日期"
    WITH    stream-io WIDTH 180 SIDE-LABEL.

 DEFINE FRAME mlabelout1
    skip(1)
    skip(1)
   
   "出库" at 12
   skip(1)
   skip(1)
    
    tr_hist.tr_part at 12 LABEL "零件代码"
  item-qty at 47 LABEL "零件数量"  
   /*pt_desc1 COLON 50 LABEL "零件描述" 
    pt_desc2 COLON 80*/
  skip(1)
    itemdesc at 12  LABEL "零件描述" 

    skip(1)
   
    tr_hist.tr_nbr at 12 LABEL "订单号"
    mpro at 47 label "项目代码"

    skip(1)
   
     tr_hist.tr_site at 12 LABEL "地点"
 
    tr_hist.tr_loc at 47 LABEL "库位"
  
   skip(1)
    tr_hist.tr_serial at 12 LABEL "批/序号"
    skip(1)
    tr_hist.tr_date at 12 LABEL "出库日期"
    skip(1)
   prndate at 12 LABEL "打印日期"
    WITH    stream-io WIDTH 180 SIDE-LABEL.

   


    

    
 DEFINE FRAME mlabelremain
    skip(5)
    
   
   "(1) 剩余" at 4
   "(2)打印日期/Print Date:" at 37
   "(3)入库日期/Receipt Date:" at 62
   skip
   prndate at 40 no-label
    tr_hist.tr_date at 65 no-label
   skip(1)
    "(4)零件代码/Part NO.:" at 4
   "(5)数量/Quantity:" at 37
   "(6)单位/Unit:" at 62
   skip
       tr_hist.tr_part at 4 no-label
        pallet-remain-qty  at 40 no-label
        tr_hist.tr_um at 65 no-label
        skip(1)
  
 "(7)零件描述/Desc:" at 4
   skip 
  itemdesc at 4  no-label

    skip(1)
   "(8)移出地点/库位/From:" at 4 space(2)  tr_hist.tr_site no-label
   "(9)移入地点/库位/To:" at 37
   skip
     tr_hist.tr_loc no-label  at 7
   skip(1)
   "(10)采购单号/加工单号/Order:" at 4
   "(11)供应商代码/Supplier:" at 37
   "(12)收货单号/Receiver:" at 62
   skip
       tr_hist.tr_nbr at 7 no-label
       tr_hist.tr_addr at 40 no-label
       tr_hist.tr_lot at 66 no-label
   skip(1)
   "(13)供应商/Name of supplier:" at 4
   "(14)QAD批序号/Lot:" at 62
       skip
       mname at 7 no-label
       
      
   
    WITH    stream-io WIDTH 180 SIDE-LABEL.


  DEFINE FRAME mlabelremain1
      skip(5)
    
   
   "(1) 剩余" at 4
   "(2)打印日期/Print Date:" at 37
   "(3)入库日期/Receipt Date:" at 62
   skip
   prndate at 40 no-label
    tr_hist.tr_date at 65 no-label
   skip(1)
    "(4)零件代码/Part NO.:" at 4
   "(5)数量/Quantity:" at 37
   "(6)单位/Unit:" at 62
   skip
       tr_hist.tr_part at 4 no-label
        pallet-remain-qty  at 40 no-label
        tr_hist.tr_um at 65 no-label
        skip(1)
  
 "(7)零件描述/Desc:" at 4
   skip 
  itemdesc at 4  no-label

    skip(1)
   "(8)移出地点/库位/From:" at 4 space(2)  tr_hist.tr_site no-label
   "(9)移入地点/库位/To:" at 37
   skip
     tr_hist.tr_loc no-label  at 7
   skip(1)
   "(10)采购单号/加工单号/Order:" at 4
   "(11)供应商代码/Supplier:" at 37
   "(12)收货单号/Receiver:" at 62
   skip
       tr_hist.tr_nbr at 7 no-label
       tr_hist.tr_addr at 40 no-label
       tr_hist.tr_lot at 66 no-label
   skip(1)
   "(13)供应商/Name of supplier:" at 4
   "(14)QAD批序号/Lot:" at 62
       skip
       mname at 7 no-label
       
      
   
    WITH    stream-io WIDTH 180 SIDE-LABEL.



   

DISPLAY  part mdate WITH FRAME a.
 /*ENABLE ALL WITH FRAME a.  */
 repeat:
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

          FOR FIRST tr_hist WHERE tr_part = part AND (tr_type = 'rct-unp' OR tr_type = 'iss-unp' ) NO-LOCK:
         isavailable = yes.
          end.
          IF NOT isavailable  THEN DO:
              MESSAGE "该零件无计划外出/入库事务!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

             NEXT-PROMPT part WITH FRAME a.
         UNDO,RETRY.
          END.
      isavailable = no.
      
      END.
      mdate = ?.
 mdate1 = ?.
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
                  for each tr_hist WHERE tr_part = part AND (tr_type = 'rct-unp' OR tr_type = 'iss-unp') and tr_date = mdate NO-LOCK:
                 isavailable = yes.
                 end.
                IF not isavailable  THEN DO:
                    MESSAGE "当前日期无该零件计划外出/入库事务!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

                   NEXT-PROMPT mdate WITH FRAME a.
               UNDO,RETRY.
                END.
             isavailable = no.

            END.*/
     for FIRST tr_hist   WHERE tr_part = part AND (tr_type = 'rct-unp' OR tr_type = 'iss-unp') AND tr_date >= mdate AND tr_date <= mdate1  AND tr_qty_loc < 0 NO-LOCK:
            isavailable = yes.
            end.   
              if not isavailable then 
             MESSAGE "当前日期范围无计划外出/入库事务!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

            
            
            
              
               ELSE DO:

mainloop:
REPEAT:           

OPEN QUERY qry   for each tr_hist   WHERE tr_part = part AND (tr_type = 'rct-unp' OR tr_type = 'iss-unp') AND tr_date >= mdate AND tr_date <= mdate1 AND (IF tr_type = 'iss-unp' THEN tr_qty_loc < 0 ELSE tr_qty_loc > 0) BY tr_trnbr DESCENDING BY tr_type DESCENDING.
    ENABLE ALL WITH FRAME fr-brws.
    ON 'choose':U OF b-done
DO:
   mtr_qty_loc = tr_hist.tr_qty_loc.
    FIND first pt_mstr WHERE pt_part = part NO-LOCK.
    itemdesc = pt_desc1 + pt_desc2.
   
    HIDE FRAME fr-brws.
    /*DISABLE ALL WITH FRAME fr-brws.
    j = brw:NUM-SELECTED-ROWS.
        brw:FETCH-SELECTED-ROW(j).*/
       /* FIND first ld_det WHERE tr_hist.tr_loc = ld_loc and tr_hist.tr_site = ld_site NO-LOCK.
         remain-qty = ld_qty_oh.*/
        DISPLAY 
      tr_hist.tr_trnbr 
        tr_hist.tr_date 
        tr_hist.tr_type 
      
      tr_hist.tr_part 
           tr_hist.tr_serial 
  mtr_qty_loc
/*remain-qty*/
     itemdesc
      
            tr_hist.tr_site 
            tr_hist.tr_loc 
     
                WITH FRAME unplan-inventory.
           
            
           
     
         
          
            

    
END.
    WAIT-FOR CHOOSE OF b-done.
     UPDATE standard WITH FRAME unplan-inventory.
  /*j = brw:NUM-SELECTED-ROWS.
        brw:FETCH-SELECTED-ROW(j).*/
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
       
      
         IF abs(tr_hist.tr_qty_loc) MOD pallet-per <> 0 THEN DO:
          
              pallet-qty = TRUNCATE(abs(abs(tr_hist.tr_qty_loc)) / pallet-per,0) + 1.
                remain = YES.  
              END.
             ELSE DO:
            
             REMAIN = NO.
                 pallet-qty = abs(abs(tr_hist.tr_qty_loc)) / pallet-per.
             END.
          display pallet-qty WITH FRAME std.
       
          END.  
        ELSE
          
             DO:
       
              seta5:
      do transaction on error undo, retry:
          mcount= 0.
          repeat i = 1 to 99 by 1:
          pallet-qtys[i] = 0.
          end.
          

              UPDATE 
                  pallet-qtys 
                  WITH 3 COLUMN FRAME unstd .
               repeat i = 1 to 99 by 1:
             mcount = mcount + pallet-qtys[i].
             end.
             if mcount > abs(tr_hist.tr_qty_loc) then do:
             MESSAGE "输入数量超过计划外出/入库数量!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

           /* update  pallet-qtys with 3 column frame unstd.*/
             undo,retry.
         end.
        end.
             
             
              HIDE FRAME unstd.
             repeat i = 1 to 99 by 1:
          pallet-remain-qtys[i] = 0.
          end.

              UPDATE
                  pallet-remain-qtys
                  WITH 3 COLUMN FRAME unstd-remain.
              
          END.
  repeat:       
  
{mfselbpr.i "printer" 80}  /*output to printer.*/
 /*FIND pt_mstr WHERE pt_part = tr_part NO-LOCK.*/

find first ad_mstr where ad_addr = tr_hist.tr_addr no-lock no-error.
if available ad_mstr then  mname = if ad_name <> '' then ad_name else ad_sort.
 for first glt_det where glt_doc = string(tr_hist.tr_trnbr) no-lock:
mpro = glt_det.glt_project.
 end.

 IF standard THEN DO:

         
              REPEAT i = 1 TO pallet-qty BY 1 :
               item-qty = pallet-per.
                   
                       IF i = pallet-qty  THEN DO:
                  
                   IF remain THEN DO:
                   
                       item-qty =  abs(tr_hist.tr_qty_loc)  MOD pallet-per.
                  
                      END.  
                      
                   END.
  IF tr_hist.tr_type = 'rct-unp' THEN DO:
  
                     DISPLAY  tr_hist.tr_part 
   itemdesc
    item-qty 
    tr_hist.tr_nbr 
    
   tr_hist.tr_um
   
    tr_hist.tr_site 
    
    tr_hist.tr_loc 
    tr_hist.tr_lot
   tr_hist.tr_addr    tr_hist.tr_serial 
    
    tr_hist.tr_date 
    
 mname
    
    prndate WITH FRAME mlabelin .
                     PAGE.
                     END.  
ELSE DO:
  
/*DISPLAY  tr_hist.tr_part 
    itemdesc    
    item-qty 
    tr_hist.tr_nbr 
    
   
   
    tr_hist.tr_site 
    
    tr_hist.tr_loc 
    
   
    tr_hist.tr_serial 
    
    tr_hist.tr_date 
    

    
    prndate WITH FRAME mlabelout .
      PAGE. */
      END.
          
         
 END.        
       IF remain  AND tr_hist.tr_type = 'iss-unp' THEN do:
              pallet-remain-qty = pallet-per -  abs(abs(tr_hist.tr_qty_loc))  MOD pallet-per.
         
     DISPLAY  tr_hist.tr_part 
   itemdesc
    mname
   pallet-remain-qty 
    tr_hist.tr_nbr 
    tr_hist.tr_um
   tr_hist.tr_addr
   tr_hist.tr_lot
    tr_hist.tr_site 
    
    tr_hist.tr_loc 
    
   
    tr_hist.tr_serial 
    
    tr_hist.tr_date 
    

    
    prndate WITH FRAME mlabelremain .
 PAGE.
     
               

             end.
              END.
              ELSE
                  REPEAT i = 1 TO 99 BY 1 :
                   IF pallet-qtys[i] <> 0 THEN 
                    item-qty = pallet-qtys[i].
                  IF pallet-remain-qtys[i] <> 0 THEN pallet-remain-qty = pallet-remain-qtys[i].
                 IF tr_hist.tr_type = 'rct-unp' THEN DO:
                
                   IF pallet-qtys[i] <> 0  THEN DO:
                
                      DISPLAY  tr_hist.tr_part 
                                itemdesc
    mname
                                   item-qty 
                                 tr_hist.tr_nbr 
                               tr_hist.tr_addr
                                 tr_hist.tr_um
                               tr_hist.tr_lot
                               tr_hist.tr_site 
    
                                tr_hist.tr_loc 
    
   
                                 tr_hist.tr_serial 
    
                                  tr_hist.tr_date 
    
 
    
                                  prndate WITH FRAME mlabelin1 .
                                   PAGE.
                     
                          END.
                END.
                 ELSE DO:
                  IF pallet-qtys[i] <> 0  THEN DO:
                     /* DISPLAY  tr_hist.tr_part 
                      itemdesc
    
    item-qty 
    tr_hist.tr_nbr 
    
   
   
    tr_hist.tr_site 
    
    tr_hist.tr_loc 
    
   
    tr_hist.tr_serial 
    
    tr_hist.tr_date 
    

    
    prndate WITH FRAME mlabelout1 .
      PAGE.*/
                  END.
             IF pallet-remain-qtys[i] <> 0 THEN DO:
             

           DISPLAY  tr_hist.tr_part 
   itemdesc
    mname
   pallet-remain-qty 
    tr_hist.tr_nbr 
    
   tr_hist.tr_um
   tr_hist.tr_lot
    tr_hist.tr_site 
    tr_hist.tr_addr
    tr_hist.tr_loc 
    
   
    tr_hist.tr_serial 
    
    tr_hist.tr_date 
    

    
    prndate WITH FRAME mlabelremain1 .
    PAGE.
  
     END.     
    END.
                      
                      
                      
                 
                      
                    
                  END.
   
      {mftrl080.i}  /*output close.*/
end.
END.
               END.
end.


                    
                    

