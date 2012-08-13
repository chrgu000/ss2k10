{mfdtitle.i }
/*{mfdeclre.i}*/
    define  variable part like pt_part VIEW-AS fill-in SIZE 20 BY 1 LABEL "零件代码" .
DEFINE VAR wo like WO_NBR VIEW-AS fill-in SIZE 20 BY 1 LABEL "加工单号".
DEFINE VAR standard AS LOGICAL initial yes  VIEW-AS FILL-IN SIZE 5 BY 1 FORMAT "Yes/No" LABEL "标准".
DEFINE VAR qty AS INTEGER VIEW-AS FILL-IN SIZE 8 BY 1 LABEL "数量".
    DEFINE VAR pallet-per AS INT VIEW-AS fill-in SIZE 12 BY 1 LABEL "每铲板数量" .
    DEFINE VAR pallet-qty AS INT VIEW-AS FILL-IN SIZE 12 BY 1 LABEL  "铲板数量".
     define var isprint as logical initial no.
    DEFINE VAR pallet-qtys AS INT  EXTENT 99 initial 0 VIEW-AS FILL-IN SIZE 12 BY 1 LABEL "铲板".
    DEFINE VAR totalqty LIKE tr_qty_loc.
    DEFINE VAR prndate LIKE tr_date INITIAL TODAY.
    DEFINE VAR remain AS LOGICAL.
    DEFINE VAR i AS INT.
    DEFINE VAR mline LIKE tr_line VIEW-AS fill-in SIZE 5 BY 1 LABEL "行".
    DEFINE VAR item-qty LIKE  tr_qty_loc.
      define var isavailable as logical initial no.
  define var itemdesc as char format "x(48)".
   define var mcount as int initial 0.
   DEFINE VAR mdate like tr_date  VIEW-AS FILL-IN SIZE 8 BY 1 LABEL "日期".
DEFINE VAR mdate1 like tr_date  VIEW-AS FILL-IN SIZE 8 BY 1 LABEL "至". 
   def  var mname like ad_name.
    DEFINE BUTTON b-done LABEL "Select" SIZE 12 BY 1.
     DEFINE QUERY qry FOR tr_hist.
    DEFINE BROWSE brw  QUERY qry
    DISPLAY
        
        tr_hist.tr_date LABEL "日期"    
       tr_hist.tr_line LABEL "行号"
        tr_hist.tr_part LABEL "零件代码"
           abs(tr_hist.tr_qty_loc)  LABEL "数量" 
          tr_hist.tr_site  column-label "地点"  
            tr_hist.tr_loc column-LABEL "库位" 
           tr_hist.tr_serial LABEL "批/序号" 
      
      
           
            
         
    WITH   7 DOWN WIDTH 77 TITLE "工单入库事务" LABEL-FGCOLOR 15 LABEL-BGCOLOR 9  SEPARATORS.
DEFINE FRAME fr-brws
       brw  SKIP(0.5)
       b-done AT COLUMN 60 ROW 11 SKIP(0.5)
       WITH SIZE-CHARS 80 BY 12.5.
           
   FORM
    skip(0.5)
    PART colon 15
       SKIP(0.5)
        mdate COLON 15
        mdate1 COLON 40
         WITH  FRAME a WIDTH 80  three-d TITLE "加工单入库标签打印" SIDE-LABEL.
   /* part at 47*/
     /*mline at 65*/
   
FORM
    skip(0.5)
    Pallet-per colon 18
    pallet-qty colon 47
    
    WITH  FRAME std WIDTH 80 THREE-D SIDE-LABEL .
FORM
    
    skip(0.5)
    pallet-qtys 
    WITH  FRAME unstd WIDTH 80 THREE-D SIDE-LABEL.
 DEFINE FRAME rct
     
     
        tr_hist.tr_date COLON 20 LABEL "日期"    
   
      tr_hist.tr_part COLON 45 LABEL "零件代码"
   skip(0.5)
     
      /* pt_desc1 COLON 20 LABEL "零件描述" 
    pt_desc2 COLON 50*/
    itemdesc colon 20 LABEL "零件描述" 
    
    

      
      
       
        skip(0.5)
            tr_hist.tr_site COLON 20 LABEL "地点"
            tr_hist.tr_loc COLON 45 LABEL "库位"
        skip(0.5)
         
     tr_hist.tr_qty_loc COLON 20 LABEL "数量"
     tr_hist.tr_serial COLON 45 LABEL "批/序号"
      skip(0.5)
     standard COLON 20 
     
      WITH WIDTH 80 THREE-D SIDE-LABEL.
DEFINE FRAME mlabelin
    skip(5)
    
   
   "(1) 加工单入库" at 4
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
  "(9)移入地点/库位/To:" at 37 space(1)   tr_hist.tr_site no-label
   skip
  tr_hist.tr_loc no-label  at 40

   skip(1)
   "(10)采购单号/加工单号/Order:" at 4
   "(11)供应商代码/Supplier:" AT 37
   "(12)加工单号/wo:" at 62
   skip
       tr_hist.tr_nbr at 7  no-label
       tr_hist.tr_addr at 40 no-label
       tr_hist.TR_lot at 66 no-label
   skip(1)
   "(13)供应商/Name of supplier:" at 4 
   "(14)QAD批序号/Lot:" at 62 
       skip
       mname at 7 no-label
       tr_hist.tr_ser at 66 no-label
      
   
    WITH    stream-io WIDTH 180 SIDE-LABEL.
    DEFINE FRAME mlabelin1
     skip(5)
    
   
   "(1) 加工单入库" at 4
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
  "(9)移入地点/库位/To:" at 37 space(1)   tr_hist.tr_site no-label
   skip
  tr_hist.tr_loc no-label  at 40

   skip(1)
   "(10)采购单号/加工单号/Order:" at 4
   "(11)供应商代码/Supplier:" AT 37
   "(12)加工单号/wo:" at 62
   skip
       tr_hist.tr_nbr at 7  no-label
       tr_hist.tr_addr at 40 no-label
       tr_hist.TR_lot at 66 no-label
   skip(1)
   "(13)供应商/Name of supplier:" at 4 
   "(14)QAD批序号/Lot:" at 62 
       skip
       mname at 7 no-label
       tr_hist.tr_ser at 66 no-label
      
   
    WITH    stream-io WIDTH 180 SIDE-LABEL.




 /*DISPLAY wo part  standard qty  WITH FRAME a.*/
/* ENABLE ALL WITH FRAME a.*/  
mainloop:
REPEAT:
isavailable = NO.
  disable all with frame fr-brws.

seta1:
      do transaction on error undo, retry:
          /*UPDATE  wo WITH FRAME a.*/
          SET PART WITH FRAME a EDITING:
      /*  FOR FIRST prh_hist  NO-LOCK:
         isavailabe = YES.
        END.*/
          {mfnp.i pt_mstr part pt_part part pt_part pt_part}
          /*{mfnp05.i tr_hist tr_trnbr "tr_type = 'RCT-WO'" TR_NBR "input wo"}*/

          if recno <> ? then do:
               part = pt_part.
               display part with frame a.
               /*recno = ?.*/
            end.
          END.
         /* FIND FIRST TR_HIST  WHERE TR_TYPE= 'RCT-WO' AND TR_part = part NO-LOCK NO-ERROR.
          if NOT AVAILABLE TR_HIST then do:
       MESSAGE "无效工单号!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

             NEXT-PROMPT wo WITH FRAME a.
         UNDO,RETRY.

      
       end.*/
      /*  FIND FIRST tr_hist WHERE TR_part = part AND tr_userid = global_userid AND tr_type = "RCT-WO" AND tr_qty_loc > 0 AND tr_date >= mdate AND tr_date <= mdate1 NO-LOCK NO-ERROR.
        
        
         IF NOT AVAILABLE tr_hist THEN DO:
             MESSAGE "无效零件或无入库!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

             NEXT-PROMPT part WITH FRAME a.
         UNDO,RETRY.
             END.
     isavailable = no.*/
      END.
       mdate = ?.
 mdate1 = ?.
UPDATE mdate mdate1 WITH FRAME a.
IF MDATE = ? THEN MDATE = LOW_DATE.

IF MDATE1 = ? THEN MDATE1 = HI_DATE.
      /* seta2:
      do transaction on error undo, retry:
        UPDATE part WITH FRAME a.
         if part = "" then do:
       MESSAGE "无效零件代码!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

             NEXT-PROMPT part WITH FRAME a.
         UNDO,RETRY.

      
      
        end.

         For each tr_hist WHERE TR_NBR = wo AND tr_userid = global_userid AND tr_part = part AND tr_type ="RCT-WO" NO-LOCK:
        isavailable = yes.

        end.
         IF NOT isavailable THEN DO:
             MESSAGE "无效零件代码!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

             NEXT-PROMPT part WITH FRAME a.
         UNDO,RETRY.
             END.      
          
          isavailable = no.
          END.*/
           /*seta3:
      do transaction on error undo, retry:
        UPDATE mline WITH FRAME a.
         For each tr_hist WHERE TR_NBR = wo AND tr_userid = global_userid AND tr_part = part AND tr_type ="RCT-WO" AND tr_line = mline NO-LOCK:
         isavailable = yes.

         end.
         IF NOT isavailable THEN DO:
             MESSAGE "无效行号!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

             NEXT-PROMPT mline WITH FRAME a.
         UNDO,RETRY.
             END.      
          
          isavailable = no.
          END.*/
          
       
      repeat:
      OPEN QUERY qry   for each tr_hist   WHERE tr_part = part AND tr_userid = global_userid AND  tr_type ="RCT-WO" AND tr_qty_loc > 0 AND tr_date >= mdate AND tr_date <= mdate1 BY tr_trnbr DESCENDING .
    ENABLE ALL WITH FRAME fr-brws.
    ON 'choose':U OF b-done
DO:  

 FIND first pt_mstr WHERE pt_part = tr_hist.tr_part NO-LOCK.
    itemdesc = pt_desc1 + pt_desc2.
   
    HIDE FRAME fr-brws.
    /*DISABLE ALL WITH FRAME fr-brws.
    j = brw:NUM-SELECTED-ROWS.
        brw:FETCH-SELECTED-ROW(j).*/
       /* FIND first ld_det WHERE tr_hist.tr_loc = ld_loc and tr_hist.tr_site = ld_site NO-LOCK.
         remain-qty = ld_qty_oh.*/
        DISPLAY 
     
        tr_hist.tr_date 
       
      tr_hist.tr_part 
           tr_hist.tr_serial 
  tr_hist.tr_qty_loc
/*remain-qty*/
     itemdesc
      
      
       
            tr_hist.tr_site 
            tr_hist.tr_loc 
     
                WITH FRAME rct.
           


    /*totalqty = 0.  
          FOR EACH tr_hist WHERE TR_NBR = wo AND tr_userid = global_userid AND tr_part = part AND tr_type ="RCT-WO" AND tr_line =  NO-LOCK:
        totalqty = totalqty + tr_qty_loc.
         END.
         qty = totalqty.*/
         
       totalqty = tr_hist.tr_qty_loc.
        
        
        END.
            WAIT-FOR CHOOSE OF b-done.
          
         UPDATE standard WITH FRAME rct.
           IF standard THEN DO: 
               seta3:
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
       
      
         IF totalqty MOD pallet-per <> 0 THEN DO:
          
              pallet-qty = TRUNCATE(totalqty / pallet-per,0) + 1.
                remain = YES.  
              END.
             ELSE DO:
             REMAIN = NO.
             pallet-qty = totalqty / pallet-per.
             END.
          display pallet-qty WITH FRAME std.
          
          END.  
        ELSE
          seta4:
      do transaction on error undo, retry:
        repeat i = 1 to 99 by 1:
        pallet-qtys[i] = 0.
        end.
        mcount = 0.
          UPDATE 
                  pallet-qtys
                  WITH 3 column  FRAME unstd.
             repeat i = 1 to 99 by 1:
             mcount = mcount + pallet-qtys[i].
              end.
             if mcount > totalqty then do:
             MESSAGE "输入数量超过该加工单数量!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

            /*update  pallet-qtys with 3 column frame unstd.*/
             undo,retry.
        
         end.
         end.

             
           
         /* END.*/
      
         /*run print.*/
      repeat:
       {mfselbpr.i "printer" 80}  /*output to printer.*/
     find first ad_mstr where ad_addr = tr_hist.tr_addr no-lock no-error.
if available ad_mstr then  mname = if ad_name <> '' then ad_name else ad_sort.

       /*{mfphead.i}*/ 
         /*{gpselout.i &printType = "printer"
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
                  &defineVariables = "yes"}*/
              /* FIND tr_hist WHERE TR_NBR = wo AND tr_userid = global_userid AND tr_part = part AND tr_type ="RCT-WO"  NO-LOCK.*/
              FIND pt_mstr WHERE pt_part = tr_part NO-LOCK.
             /* FIND vd_mstr WHERE tr_addr = vd_addr NO-LOCK.*/
         itemdesc = pt_desc1 + pt_desc2.
          IF standard THEN 
         
              REPEAT i = 1 TO pallet-qty BY 1 :
               item-qty = pallet-per.
                  IF i = pallet-qty  THEN DO:
                  
                   IF remain THEN 
                       item-qty = totalqty MOD pallet-per.
                      
                        END.

                     DISPLAY  tr_hist.tr_part
 /*   pt_desc1 
    pt_desc2 */ itemdesc
    
    item-qty 
    tr_hist.tr_nbr 
   tr_hist.TR_lot 
   
    tr_hist.tr_addr 
    tr_hist.tr_site
    mname tr_hist.tr_um
    tr_hist.tr_loc 
  
   
    tr_hist.tr_serial 
    
    tr_hist.tr_date 
    
   prndate WITH FRAME mlabelin .
               PAGE.
               

              END.
              ELSE
                  REPEAT i = 1 TO 99 BY 1 :
                  IF pallet-qtys[i] <> 0 THEN DO:
                  item-qty = pallet-qtys[i].
               
                   DISPLAY  tr_hist.tr_part
 /*   pt_desc1 
    pt_desc2 */ itemdesc
    
    item-qty 
    tr_hist.tr_nbr 
   tr_hist.TR_lot 
   
    tr_hist.tr_addr 
    tr_hist.tr_site
    mname tr_hist.tr_um
    tr_hist.tr_loc 
  
   
    tr_hist.tr_serial 
    
    tr_hist.tr_date 
    
   prndate WITH FRAME mlabelin1 .

                  PAGE.
                      END.
                  END.
  
     {mftrl080.i} 
     end. /*output close.*/
END.
end.
           
