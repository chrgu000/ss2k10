{mfdtitle.i }
    define  variable part like pt_part VIEW-AS EDITOR SIZE 8 BY 1 LABEL "�������" .
DEFINE VAR recevier AS CHAR FORMAT "x(12)" VIEW-AS FILL-IN SIZE 8 BY 1 LABEL "�ջ�����".
DEFINE VAR standard AS LOGICAL VIEW-AS FILL-IN SIZE 5 BY 1 FORMAT "Yes/No" LABEL "��׼".
DEFINE VAR qty AS INTEGER VIEW-AS FILL-IN SIZE 8 BY 1 LABEL "����".
    DEFINE VAR pallet-per AS INT VIEW-AS fill-in SIZE 12 BY 1 LABEL "ÿ��������" .
    DEFINE VAR pallet-qty AS INT VIEW-AS FILL-IN SIZE 12 BY 1 LABEL  "��������".
     
    DEFINE VAR pallet-qtys AS INT EXTENT 99 VIEW-AS FILL-IN SIZE 12 BY 1 LABEL "����".
    DEFINE VAR totalqty LIKE tr_qty_chg.
    DEFINE VAR remain AS LOGICAL.
    DEFINE VAR i AS INT.
    DEFINE VAR mline LIKE tr_line VIEW-AS TEXT SIZE 12 BY 1 LABEL "��".
    DEFINE VAR item-qty LIKE  tr_qty_chg.
    DEFINE VAR mdate AS DATE INITIAL TODAY.
    FORM
    SKIP(1)
    recevier COLON 18
    part COLON 45
     mline COLON 65
        skip(1)
    qty COLON 18
    standard COLON 45
    WITH  FRAME a WIDTH 80  TITLE "�ɹ��ջ���ǩ��ӡ" SIDE-LABEL.
FORM
    SKIP(1)
    Pallet-per COLON 18
    pallet-qty COLON 45
    
    WITH  FRAME std WIDTH 80 THREE-D SIDE-LABEL .
FORM
    
    SKIP(1)
    pallet-qtys
    WITH  FRAME unstd WIDTH 80 THREE-D SIDE-LABEL.
DEFINE FRAME mlabel
    SKIP(1)
    SKIP(1)
    SKIP(1)
    SKIP(1)
    "�ջ������"
     COLON 20
    part COLON 30 LABEL "�������"
    pt_desc1 COLON 50 LABEL "�������" 
    pt_desc2 COLON 80
    SKIP(1)
    item-qty COLON 20 LABEL "����"
    tr_nbr COLON 30 LABEL "�ɹ�����"
    tr_lot COLON 50 LABEL "�ջ�����"
    SKIP(1)
    tr_addr COLON 20 LABEL "��Ӧ��"
    tr_ref_site COLON 50 LABEL "�ص�"
    SKIP(1)
    tr_loc COLON 50 LABEL "��λ"
    SKIP(1)
    vd_sort COLON 20 LABEL "��Ӧ����Ϣ"
    tr_serial COLON 50 LABEL "��/���"
    SKIP(1)
    tr_date COLON 30 LABEL "�ջ�����"
    SKIP(1)
    mdate COLON 30 LABEL "��ӡ����"
    WITH WIDTH 180 SIDE-LABEL.
 DISPLAY recevier part mline standard qty WITH FRAME a.
 ENABLE ALL WITH FRAME a.  
mainloop:
REPEAT:


 seta1:
      do transaction on error undo, retry:
          UPDATE  recevier WITH FRAME a.
 
         FIND tr_hist WHERE tr_lot = recevier AND tr_userid = global_userid AND tr_type = "rct-po"  NO-LOCK.
         IF NOT AVAILABLE tr_hist THEN DO:
             MESSAGE "��Ч�ջ�����!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

             NEXT-PROMPT recevier WITH FRAME a.
         UNDO,RETRY.
             END.
      END.
       seta2:
      do transaction on error undo, retry:
        UPDATE part WITH FRAME a.
         FIND tr_hist WHERE tr_lot = recevier AND tr_userid = global_userid AND tr_part = part AND tr_type ="rct-po" NO-LOCK.
         IF NOT AVAILABLE tr_hist THEN DO:
             MESSAGE "��Ч�������!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

             NEXT-PROMPT part WITH FRAME a.
         UNDO,RETRY.
             END.      
          
          
          END.
           seta3:
      do transaction on error undo, retry:
        UPDATE mline WITH FRAME a.
         FIND tr_hist WHERE tr_lot = recevier AND tr_userid = global_userid AND tr_part = part AND tr_type ="rct-po" AND tr_line = mline NO-LOCK.
         IF NOT AVAILABLE tr_hist THEN DO:
             MESSAGE "��Ч�к�!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

             NEXT-PROMPT mline WITH FRAME a.
         UNDO,RETRY.
             END.      
          
          
          END.
          UPDATE standard WITH FRAME a.
          
          totalqty = 0.  
          FOR EACH tr_hist WHERE tr_lot = recevier AND tr_userid = global_userid AND tr_part = part AND tr_type ="rct-po" NO-LOCK:
        totalqty = totalqty + tr_qty_chg.
         END.
         qty = totalqty.
         DISPLAY qty WITH FRAME a.
           IF standard THEN DO: 
               seta4:
      do transaction on error undo, retry:
            
            
          UPDATE 
          pallet-per
         
          WITH FRAME std.
             IF pallet-per = 0 THEN DO:
              MESSAGE "����Ϊ��!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 
               NEXT-PROMPT pallet-per WITH FRAME std.
         UNDO,RETRY.
              END.
          
          
          END.
       
      
         IF totalqty MOD pallet-per <> 0 THEN DO:
          
              pallet-qty = TRUNCATE(totalqty / pallet-per) + 1.
                remain = YES.  
              END.
             ELSE
             pallet-qty = totalqty / pallet-per.
          dispaly pallet-qty WITH FRAME std.
       
          END.  
        ELSE
          
             
              UPDATE 
                  pallet-qtys
                  WITH FRAME unstd.
              
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
               FIND tr_hist WHERE tr_lot = recevier AND tr_userid = global_userid AND tr_part = part AND tr_type ="rct-po" AND tr_line = mline NO-LOCK.
              FIND pt_mstr WHERE pt_part = tr_part NO-LOCK.
              FIND vd_mstr WHERE tr_addr = vd_addr NO-LOCK.
          IF standard THEN 
         
              REPEAT i = 1 TO pallet-qty BY 1 :
               item-qty = pallet-per.
                  IF i = pallet-qty  THEN DO:
                  
                   IF remain THEN 
                       item-qty = totalqty MOD pallet-per.
                      
                        END.

                     DISPLAY  part 
    pt_desc1 
    pt_desc2 
    
    item-qty 
    tr_nbr 
    tr_lot 
   
    tr_addr 
    tr_ref_site
    
    tr_loc 
  
    vd_sort 
    tr_serial 
    
    tr_date 
    
    mdate WITH FRAME mlabel .
               PAGE.
               

              END.
              ELSE
                  REPEAT i = 1 TO 999 BY 1 :
                  IF pallet-qtys[i] <> 0 THEN DO:
                  item-qty = pallet-qtys[i].
                  DISPLAY  part 
    pt_desc1 
    pt_desc2 
    
    item-qty 
    tr_nbr 
    tr_lot 
   
    tr_addr 
    tr_ref_site
    
    tr_loc 
  
    vd_sort 
    tr_serial 
    
    tr_date 
    
    mdate WITH FRAME mlabel .
                  PAGE
                      END.
                  END.
      {mftrl080.i}
END.

