 
 {mfdtitle.i }
 define  variable part like pt_part VIEW-AS EDITOR SIZE 8 BY 1 LABEL "�������" .
DEFINE VAR mdate like tr_date  VIEW-AS FILL-IN SIZE 8 BY 1 LABEL "����".
DEFINE VAR prndate LIKE tr_date INITIAL TODAY.
DEFINE BUTTON b-done LABEL "Done" SIZE 12 BY 1.
DEFINE VAR isrecord AS LOGICAL. 
DEFINE VAR src-pallet AS INT VIEW-AS FILL-IN SIZE 12 BY 1 LABEL "Դ��������".
DEFINE VAR desti-pallet AS INT VIEW-AS FILL-IN SIZE 12 BY 1 LABEL "Ŀ���������".
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
         ENABLE ALL
    WITH 9 DOWN WIDTH 77 TITLE "�ƿ�����" LABEL-FGCOLOR 15 LABEL-BGCOLOR 9 MULTIPLE SEPARATORS.
DEFINE FRAME fr-brws
       brw SKIP (1)
       b-done AT COLUMN 35 ROW 10.5 SKIP (1)
       WITH SIZE-CHARS 80 BY 13.
          
    FORM
    SKIP(1)
   
    part COLON 18
     mdate COLON 65
       
    WITH  FRAME a WIDTH 80  TITLE "�ƿ��ǩ��ӡ" SIDE-LABEL.
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
      transfer.src-site COLON 20 LABEL "Դ�ص�"
            transfer.src-loc COLON 30 LABEL "Դ��λ"
            transfer.desti-site COLON 50 LABEL "Ŀ��ص�"
           transfer.desti-loc COLON 70LABEL "Ŀ���λ"
      SKIP(1)
      src-pallet COLON 20 
      desti-pallet COLON 50
      WITH WIDTH 80 THREE-D SIDE-LABEL.
DEFINE FRAME mlabelout
    SKIP(1)
    SKIP(1)
    SKIP(1)
    SKIP(1)
    "����
     COLON 20
    transfer.transfer-part COLON 30 LABEL "�������"
    pt_desc1 COLON 50 LABEL "�������" 
    pt_desc2 COLON 80
    SKIP(1)
  transfer.transfer-qty COLON 20 LABEL "����"
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
    "���
     COLON 20
    transfer.part COLON 30 LABEL "�������"
    pt_desc1 COLON 50 LABEL "�������" 
    pt_desc2 COLON 80
    SKIP(1)
  transfer.transfer-qty COLON 20 LABEL "����"
    "��" COLON 30
    "��" COLON 50
    SKIP(1)
    transfer.src-site COLON 30 LABEL "Դ�ص�"
    transfer.desti-site COLON 50 LABEL "Ŀ��ص�"
    SKIP(1)
    transfer.rc-loc COLON 30 LABEL "Դ��λ"
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
src-remain-pallet COLON 20 LABEL "����"
    
    transfer.src-site COLON 30 LABEL "�ص�"
    
    SKIP(1)
    transfer.src-loc COLON 30 LABEL "��λ"
 
      
    SKIP(1)
   
    
    prndate COLON 30 LABEL "��ӡ����"
    WITH WIDTH 180 SIDE-LABEL.
DEFINE FRAME mlabeldestiupdate
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
  desti-update-pallet COLON 20 LABEL "����"
    
   transfer.desti-site COLON 30 LABEL "�ص�"
    
    SKIP(1)
    transfer.desti-loc COLON 30 LABEL "��λ"
 
   
      
    SKIP(1)
   
    
    prndate COLON 30 LABEL "��ӡ����"
    WITH WIDTH 180 SIDE-LABEL.

    DISPLAY  part mdate WITH FRAME a.
 ENABLE ALL WITH FRAME a.  

    seta1:
      do transaction on error undo, retry:
          UPDATE part WITH FRAME a.
          FIND pt_part WHERE pt_part = part NO-LOCK.
          IF NOT availablew pt_part THEN DO:
              MESSAGE "��Ч�������!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

             NEXT-PROMPT part WITH FRAME a.
         UNDO,RETRY.
          END.
      END.
      seta2:
            do transaction on error undo, retry:
                UPDATE madate WITH FRAME a.
                IF mdate = ?  THEN DO:
                    MESSAGE "���ڲ���Ϊ��!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

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
                    MESSAGE "Դ������������Ϊ��!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

                   NEXT-PROMPT src-pallet WITH FRAME inventory-transfer.
               UNDO,RETRY.
                END.
            END.
             seta4:
      do transaction on error undo, retry:
          UPDATE desti-pallet WITH FRAME inventory-transfer.
          IF desti-pallet = 0  THEN DO:
                    MESSAGE "Ŀ�������������Ϊ��!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

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
DISPLAY "����
    
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
    WITH FRAME mlabelout.
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
    WITH FRAME mlabeldestiupdate.
{mftrl080.i}
END.




                    
                    

