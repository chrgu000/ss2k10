 
 {mfdtitle.i }
 define  variable part like pt_part VIEW-AS EDITOR SIZE 8 BY 1 LABEL "�������" .
DEFINE VAR mdate like tr_date  VIEW-AS FILL-IN SIZE 8 BY 1 LABEL "����".
DEFINE VAR prndate LIKE tr_date INITIAL TODAY.
DEFINE BUTTON b-done LABEL "Done" SIZE 12 BY 1.
DEFINE VAR isrecord AS LOGICAL. 
/*DEFINE VAR src-pallet AS INT VIEW-AS FILL-IN SIZE 12 BY 1 LABEL "Դ��������".
DEFINE VAR desti-pallet AS INT VIEW-AS FILL-IN SIZE 12 BY 1 LABEL "Ŀ���������".
DEFINE VAR src-remain-pallet AS INT.
DEFINE VAR desti-update-pallet AS INT.*/
DEFINE VAR pallet-per AS INT VIEW-AS fill-in SIZE 12 BY 1 LABEL "ÿ��������" .
    DEFINE VAR pallet-qty AS INT VIEW-AS FILL-IN SIZE 12 BY 1 LABEL  "��������".
     
    DEFINE VAR pallet-qtys AS INT EXTENT 99 VIEW-AS FILL-IN SIZE 12 BY 1 LABEL "������������".
 DEFINE VAR pallet-remain-qty LIKE tr_qty_chg.
    DEFINE VAR pallet-remain-qtys AS INT EXTENT 99 VIEW-AS FILL-IN SIZE 12 BY 1 LABEL "����ʣ������".
    DEFINE VAR item-qty LIKE  tr_qty_chg.
DEFINE BUFFER trhist FOR tr_hist.  
    DEFINE VAR standard AS LOGICAL VIEW-AS FILL-IN SIZE 5 BY 1 FORMAT "Yes/No" LABEL "��׼".
    DEFINE VAR remain AS LOGICAL.
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
    DISPLAY transfer.transfer-nbr LABEL "�����"
        transfer.transfer-date LABEL "����"    
        transfer.transfer-part LABEL "�������"
            transfer.src-lot-serial LABEL "Դ��/���"
        transfer.desti-lot-serial LABEL "Ŀ����/���"
        transfer.transfer-qty LABEL "�ƿ�����"
            transfer.src-site LABEL "Դ�ص�"
            transfer.src-loc LABEL "Դ��λ"
            transfer.desti-site LABEL "Ŀ��ص�"
           transfer.desti-loc LABEL "Ŀ���λ"
         /*ENABLE ALL*/
    WITH 9 DOWN WIDTH 77 TITLE "�ƿ�����" LABEL-FGCOLOR 15 LABEL-BGCOLOR 9 MULTIPLE SEPARATORS.
DEFINE FRAME fr-brws
       brw SKIP (1)
       b-done AT COLUMN 35 ROW 10.5 SKIP (1)
       WITH SIZE-CHARS 80 BY 13.
          
    FORM
    SKIP(1)
   
    part COLON 20
     mdate COLON 40
       
    WITH  FRAME a WIDTH 80  three-d TITLE "�ƿ��ǩ��ӡ" SIDE-LABEL.
  DEFINE FRAME inventory-transfer
      SKIP(1)
      transfer.transfer-nbr COLON 20 LABEL "�����"
      transfer.transfer-date COLON 30 LABEL "����"     
      transfer.transfer-part COLON 50 LABEL "�������"
           SKIP(1)
       pt_desc1 COLON 20 LABEL "�������" 
    pt_desc2 COLON 50
      SKIP(1)
        transfer.transfer-qty COLON 50 LABEL "�ƿ�����"
      SKIP(1)
       transfer.src-lot-serial COLON 30 LABEL "Դ��/���"
      transfer.desti-lot-serial COLON 50 LABEL "Ŀ����/���"
      SKIP(1)      
      transfer.src-site COLON 30 LABEL "Դ�ص�"
           
            transfer.desti-site COLON 50 LABEL "Ŀ��ص�"
           skip(1)
            transfer.src-loc COLON 30 LABEL "Դ��λ"
            transfer.desti-loc COLON 50 LABEL "Ŀ���λ"
      /*SKIP(1)
      src-pallet COLON 20 
      desti-pallet COLON 50*/
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

DEFINE FRAME mlabelout
    SKIP(1)
    SKIP(1)
    SKIP(1)
    SKIP(1)
    "����" COLON 20
    
    transfer.transfer-part COLON 30 LABEL "�������"


    pt_desc1 COLON 50 LABEL "�������" 
    pt_desc2 COLON 80
    SKIP(1)
  item-qty COLON 20 LABEL "����"
    "��" COLON 30
    "��" COLON 50
    SKIP(1)
    transfer.src-site COLON 30 LABEL "Դ�ص�"
    transfer.desti-site COLON 50 LABEL "Ŀ��ص�"
    SKIP(1)
    transfer.src-loc COLON 30 LABEL "Դ��λ"
   transfer.desti-loc COLON 50 LABEL "Ŀ���λ"
    SKIP(1)
    transfer.src-lot-serial COLON 30 LABEL "Դ��/���"
      transfer.desti-lot-serial COLON 50 LABEL "Ŀ����/���"
    SKIP(1)
   
    transfer.transfer-date COLON 30 LABEL "��������"
    SKIP(1)
    prndate COLON 30 LABEL "��ӡ����"
    WITH WIDTH 180 SIDE-LABEL.
DEFINE FRAME mlabelout1
    SKIP(1)
    SKIP(1)
    SKIP(1)
    SKIP(1)
    "����" COLON 20
    
    transfer.transfer-part COLON 30 LABEL "�������"


    pt_desc1 COLON 50 LABEL "�������" 
    pt_desc2 COLON 80
    SKIP(1)
  item-qty COLON 20 LABEL "����"
    "��" COLON 30
    "��" COLON 50
    SKIP(1)
    transfer.src-site COLON 30 LABEL "Դ�ص�"
    transfer.desti-site COLON 50 LABEL "Ŀ��ص�"
    SKIP(1)
    transfer.src-loc COLON 30 LABEL "Դ��λ"
   transfer.desti-loc COLON 50 LABEL "Ŀ���λ"
    SKIP(1)
    transfer.src-lot-serial COLON 30 LABEL "Դ��/���"
      transfer.desti-lot-serial COLON 50 LABEL "Ŀ����/���"
    SKIP(1)
   
    transfer.transfer-date COLON 30 LABEL "��������"
    SKIP(1)
    prndate COLON 30 LABEL "��ӡ����"
    WITH WIDTH 180 SIDE-LABEL.

DEFINE FRAME mlabelin
    SKIP(1)
    SKIP(1)
    SKIP(1)
    SKIP(1)
    "���"
     COLON 20
    transfer.transfer-part COLON 30 LABEL "�������"
    pt_desc1 COLON 50 LABEL "�������" 
    pt_desc2 COLON 80
    SKIP(1)
 item-qty COLON 20 LABEL "����"
    "��" COLON 30
    "��" COLON 50
    SKIP(1)
    transfer.src-site COLON 30 LABEL "Դ�ص�"
    transfer.desti-site COLON 50 LABEL "Ŀ��ص�"
    SKIP(1)
    transfer.src-loc COLON 30 LABEL "Դ��λ"
   transfer.desti-loc COLON 50 LABEL "Ŀ���λ"
    SKIP(1)
    transfer.src-lot-serial COLON 30 LABEL "Դ��/���"
      transfer.desti-lot-serial COLON 50 LABEL "Ŀ����/���"
    SKIP(1)
   
    transfer.transfer-date COLON 30 LABEL "�������"
    SKIP(1)
    prndate COLON 30 LABEL "��ӡ����"
    WITH WIDTH 180 SIDE-LABEL.
   
    DEFINE FRAME mlabelin1
    SKIP(1)
    SKIP(1)
    SKIP(1)
    SKIP(1)
    "���"
     COLON 20
    transfer.transfer-part COLON 30 LABEL "�������"
    pt_desc1 COLON 50 LABEL "�������" 
    pt_desc2 COLON 80
    SKIP(1)
 item-qty COLON 20 LABEL "����"
    "��" COLON 30
    "��" COLON 50
    SKIP(1)
    transfer.src-site COLON 30 LABEL "Դ�ص�"
    transfer.desti-site COLON 50 LABEL "Ŀ��ص�"
    SKIP(1)
    transfer.src-loc COLON 30 LABEL "Դ��λ"
   transfer.desti-loc COLON 50 LABEL "Ŀ���λ"
    SKIP(1)
    transfer.src-lot-serial COLON 30 LABEL "Դ��/���"
      transfer.desti-lot-serial COLON 50 LABEL "Ŀ����/���"
    SKIP(1)
   
    transfer.transfer-date COLON 30 LABEL "�������"
    SKIP(1)
    prndate COLON 30 LABEL "��ӡ����"
    WITH WIDTH 180 SIDE-LABEL.

DEFINE FRAME mlabelsrcremain
    SKIP(1)
    SKIP(1)
    SKIP(1)
    SKIP(1)
    "ʣ����"
     COLON 20
    transfer.transfer-part COLON 30 LABEL "�������"
    pt_desc1 COLON 50 LABEL "�������" 
    pt_desc2 COLON 80
    SKIP(1)
pallet-remain-qty COLON 20 LABEL "����"
    
    transfer.src-site COLON 30 LABEL "�ص�"
    
    SKIP(1)
    transfer.src-loc COLON 30 LABEL "��λ"
 
      
    SKIP(1)
   
    
    prndate COLON 30 LABEL "��ӡ����"
    WITH WIDTH 180 SIDE-LABEL.
    DEFINE FRAME mlabelsrcremain1
    SKIP(1)
    SKIP(1)
    SKIP(1)
    SKIP(1)
    "ʣ����"
     COLON 20
    transfer.transfer-part COLON 30 LABEL "�������"
    pt_desc1 COLON 50 LABEL "�������" 
    pt_desc2 COLON 80
    SKIP(1)
pallet-remain-qty COLON 20 LABEL "����"
    
    transfer.src-site COLON 30 LABEL "�ص�"
    
    SKIP(1)
    transfer.src-loc COLON 30 LABEL "��λ"
 
      
    SKIP(1)
   
    
    prndate COLON 30 LABEL "��ӡ����"
    WITH WIDTH 180 SIDE-LABEL.

/*DEFINE FRAME mlabeldestiupdate
    SKIP(1)
    SKIP(1)
    SKIP(1)
    SKIP(1)
    "���п��"
     COLON 20
    transfer.transfer-part COLON 30 LABEL "�������"
    pt_desc1 COLON 50 LABEL "�������" 
    pt_desc2 COLON 80
    SKIP(1)
  /*desti-update-pallet COLON 20 LABEL "����"*/
    
   transfer.desti-site COLON 30 LABEL "�ص�"
    
    SKIP(1)
    transfer.desti-loc COLON 30 LABEL "��λ"
 
   
      
    SKIP(1)
   
    
    prndate COLON 30 LABEL "��ӡ����"
    WITH WIDTH 180 SIDE-LABEL.*/

    DISPLAY  part mdate WITH FRAME a.
 ENABLE ALL WITH FRAME a.  

    seta1:
      do transaction on error undo, retry:
          UPDATE part WITH FRAME a.
          FIND pt_mstr WHERE pt_part = part NO-LOCK.
          IF NOT available pt_mstr THEN DO:
              MESSAGE "��Ч�������!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

             NEXT-PROMPT part WITH FRAME a.
         UNDO,RETRY.
          END.
      END.
      seta2:
            do transaction on error undo, retry:
                UPDATE mdate WITH FRAME a.
                IF mdate = ?  THEN DO:
                    MESSAGE "���ڲ���Ϊ��!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

                   NEXT-PROMPT mdate WITH FRAME a.
               UNDO,RETRY.
                END.
            END.
          /*  isrecord = NO.
            FIND pt_mstr WHERE pt_part = part NO-LOCK.*/
           
            FOR EACH tr_hist  WHERE tr_part = part AND tr_type = 'iss-tr'AND tr_date = mdate NO-LOCK:
                CREATE transfer.
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
    HIDE FRAME fr-brws.
    /*DISABLE ALL WITH FRAME fr-brws.*/
    /*i = brw:NUM-SELECTED-ROWS.
        brw:FETCH-SELECTED-ROW(i).*/
            DISPLAY transfer.transfer-nbr 
                transfer.transfer-date
                transfer.transfer-part 
            pt_desc1 
    pt_desc2 
               transfer.src-lot-serial 
                transfer.desti-lot-serial
        transfer.transfer-qty 
           transfer.src-site 
            transfer.src-loc
            transfer.desti-site 
           transfer.desti-loc 
                WITH FRAME inventory-transfer.
            ENABLE ALL WITH FRAME invertory-transfer.
            
  UPDATE standard WITH FRAME inventory-transfer.
END.
    WAIT-FOR CHOOSE OF b-done.
/*i = brw:NUM-SELECTED-ROWS.
        brw:FETCH-SELECTED-ROW(i).*/
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
       
      
         IF  transfer.transfer-qty MOD pallet-per <> 0 THEN DO:
          
              pallet-qty = TRUNCATE( transfer.transfer-qty / pallet-per,0) + 1.
                remain = YES.  
              END.
             ELSE
             pallet-qty =  transfer.transfer-qty / pallet-per.
          display pallet-qty WITH FRAME std.
       
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
{mfselbpr.i "printer" 80}


/*src-remain-pallet = src-pallet - transfer.transfer-qty .
desti-update-pallet = desti-pallet + transfer.transfer-qty.*/
FIND pt_mstr WHERE pt_part = part NO-LOCK.

 IF standard THEN 
         
              REPEAT i = 1 TO pallet-qty BY 1 :
               item-qty = pallet-per.
                   
                       IF i = pallet-qty  THEN DO:
                  
                   IF remain THEN DO:
                   
                       item-qty = transfer.transfer-qty  MOD pallet-per.
                  
                      END.  
                      
                   END.
 
  
                    DISPLAY "���"
    
    transfer.transfer-part 
    pt_desc1 
    pt_desc2
    
  item-qty
    "��" 
    "��"
    
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
                  
DISPLAY "����"
    
    transfer.transfer-part 
    pt_desc1 
    pt_desc2
    
 item-qty
    "��" 
    "��"
    
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
          IF remain THEN do:
              pallet-remain-qty = pallet-per - transfer.transfer-qty MOD pallet-per.
         
     DISPLAY "ʣ����"
    
    transfer.transfer-part 
    pt_desc1 
    pt_desc2 
   
pallet-remain-qty
    
    transfer.src-site 
    
 
    transfer.src-loc
 
      
 
   
    
    prndate 
    WITH FRAME mlabelsrcremain.
 PAGE.
          END.
 END.        
       
     
               

             
              ELSE
                  REPEAT i = 1 TO 999 BY 1 :
                   IF pallet-qtys[i] <> 0 THEN 
                    item-qty = pallet-qtys[i].
                  IF pallet-remain-qtys[i] <> 0 THEN pallet-remain-qty = pallet-remain-qtys[i].
               
                
                   IF pallet-qtys[i] <> 0  THEN DO:
                
                       DISPLAY "���"
    
    transfer.transfer-part 
    pt_desc1 
    pt_desc2
    
  item-qty
    "��" 
    "��"
    
    transfer.src-site 
    transfer.desti-site 
   
    transfer.src-loc 
   transfer.desti-loc 
    
    transfer.src-lot-serial 
      transfer.desti-lot-serial 
    
   
    transfer.transfer-date 
    
    prndate 
    WITH FRAME mlabelin1.
                                   PAGE.
        DISPLAY "����"
    
    transfer.transfer-part 
    pt_desc1 
    pt_desc2
    
 item-qty
    "��" 
    "��"
    
    transfer.src-site 
    transfer.desti-site 
   
    transfer.src-loc 
   transfer.desti-loc 
    
    transfer.src-lot-serial 
      transfer.desti-lot-serial 
    
   
    transfer.transfer-date 
    
    prndate 
    WITH FRAME mlabelout1.
        PAGE.
                      
                          END.
               
                
             IF pallet-remain-qtys[i] <> 0 THEN DO:
             

          DISPLAY "ʣ����"
    
    transfer.transfer-part 
    pt_desc1 
    pt_desc2 
   
pallet-remain-qty
    
    transfer.src-site 
    
 
    transfer.src-loc
 
      
 
   
    
    prndate 
    WITH FRAME mlabelsrcremain1.
    PAGE.
     END.     
    END.
                      
                      
                      
                      
                      
                    
                 
/*DISPLAY "����
    
    transfer.transfer-part 
    pt_desc1 
    pt_desc2
    
  transfer.transfer-qty 
    "��" 
    "��"
    
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
DISPLAY "���
    
    transfer.transfer-part 
    pt_desc1 
    pt_desc2
    
  transfer.transfer-qty 
    "��" 
    "��"
    
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
DISPLAY "ʣ����"
    
    transfer.transfer-part 
    pt_desc1 
    pt_desc2 
   
src-remain-pallet 
    
    transfer.src-site 
    
 
    transfer.src-loc
 
      
 
   
    
    prndate 
    WITH FRAME mlabelsrcremain.
PAGE.
DISPLAY "���п��"
    
    transfer.transfer-part 
    pt_desc1 
    pt_desc2 
   
  desti-update-pallet 
    
   transfer.desti-site 
    
    
    transfer.desti-loc 
 
   
      
  
   
    
    prndate 
    WITH FRAME mlabeldestiupdate.*/
{mftrl080.i}




END.



