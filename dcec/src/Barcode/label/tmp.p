DEFINE FRAME mlabeltr
    skip(1)
    
   
   "(1) �ƿ�" at 12
   "(2)��ӡ����/Print Date:" at 42
   "(3)�������/Receipt Date:" at 67
   skip
   prndate at 45 no-label
    transfer.transfer-date at 70 no-label
   skip(1)
    "(4)�������/Part NO.:" at 12
   "(5)����/Quantity:" at 42
   "(6)��λ/Unit:" at 67
   skip
       transfer.transfer-part at 15 no-label
        item-qty  at 45 no-label
        transfer.transfer-um at 70 no-label
        skip(1)
  
 "(7)�������/Desc:" at 12
   skip 
  itemdesc at 15  no-label

    skip(1)
   "(8)�Ƴ��ص�/��λ/From:" at 12 space(2) transfer.src-site no-label
   "(9)����ص�/��λ/To:" at 42 space(2)  transfer.desti-site no-label
   skip
     transfer.src-loc no-label at 15
     transfer.desti-loc no-label at 45

 
   skip(1)
   "(10)�ɹ�����/�ӹ�����/Order:" at 12
   "(11)��Ӧ�̴���/Supplier:" at 42
   "(12)�ջ�����/Receiver:" at 67
   skip
      /*  transfer.transfer-nbr at 15  no-label
      transfer.transfer-addr at 45 no-label
       transfer.transfer-lot at 71 no-label*/
   skip(1)
   "(13)��Ӧ��/Name of supplier:" at 12 
   "(14)QAD�����/Lot:" at 67 
       skip
       mname at 15 no-label
       transfer.transfer-desti-lot-serial at 71 no-label
      
   
    WITH    stream-io WIDTH 180 SIDE-LABEL.
    
    DEFINE FRAME mlabeltr1
    skip(1)
    
   
   "(1) �ƿ�" at 12
   "(2)��ӡ����/Print Date:" at 42
   "(3)�������/Receipt Date:" at 67
   skip
   prndate at 45 no-label
    transfer.transfer-date at 70 no-label
   skip(1)
    "(4)�������/Part NO.:" at 12
   "(5)����/Quantity:" at 42
   "(6)��λ/Unit:" at 67
   skip
       transfer.transfer-part at 15 no-label
        item-qty  at 45 no-label
        transfer.transfer-um at 70 no-label
        skip(1)
  
 "(7)�������/Desc:" at 12
   skip 
  itemdesc at 15  no-label

    skip(1)
   "(8)�Ƴ��ص�/��λ/From:" at 12 space(2) transfer.src-site no-label
   "(9)����ص�/��λ/To:" at 42 space(2)  transfer.desti-site no-label
   skip
     transfer.src-loc no-label at 15
     transfer.desti-loc no-label at 45

 
   skip(1)
   "(10)�ɹ�����/�ӹ�����/Order:" at 12
   "(11)��Ӧ�̴���/Supplier:" at 42
   "(12)�ջ�����/Receiver:" at 67
   skip
      /*  transfer.transfer-nbr at 15  no-label
      transfer.transfer-addr at 45 no-label
       transfer.transfer-lot at 71 no-label*/
   skip(1)
   "(13)��Ӧ��/Name of supplier:" at 12 
   "(14)QAD�����/Lot:" at 67 
       skip
       mname at 15 no-label
       transfer.transfer-desti-lot-serial at 71 no-label
      
   
    WITH    stream-io WIDTH 180 SIDE-LABEL.
 DEFINE FRAME mlabelsrcremain1
    skip(1)
    
   
   "(1) ʣ��" at 12
   "(2)��ӡ����/Print Date:" at 42
   "(3)�������/Receipt Date:" at 67
   skip
   prndate at 45 no-label
    transfer.transfer-date at 70 no-label
   skip(1)
    "(4)�������/Part NO.:" at 12
   "(5)����/Quantity:" at 42
   "(6)��λ/Unit:" at 67
   skip
       transfer.transfer-part at 15 no-label
        item-qty  at 45 no-label
        transfer.transfer-um at 70 no-label
        skip(1)
  
 "(7)�������/Desc:" at 12
   skip 
  itemdesc at 15  no-label

    skip(1)
   "(8)�Ƴ��ص�/��λ/From:" at 12 space(2) transfer.src-site no-label
   "(9)����ص�/��λ/To:" at 42 
   skip
     transfer.src-loc no-label at 15
    
   skip(1)
   "(10)�ɹ�����/�ӹ�����/Order:" at 12
   "(11)��Ӧ�̴���/Supplier:" at 42
   "(12)�ջ�����/Receiver:" at 67
   skip
      /*  transfer.transfer-nbr at 15  no-label
      transfer.transfer-addr at 45 no-label
       transfer.transfer-lot at 71 no-label*/
   skip(1)
   "(13)��Ӧ��/Name of supplier:" at 12 
   "(14)QAD�����/Lot:" at 67 
       skip
       mname at 15 no-label
       transfer.transfer-src-lot-serial at 71 no-label
      
   
    WITH    stream-io WIDTH 180 SIDE-LABEL.
 DEFINE FRAME mlabelsrcremain
    skip(1)
    
   
   "(1) ʣ��" at 12
   "(2)��ӡ����/Print Date:" at 42
   "(3)�������/Receipt Date:" at 67
   skip
   prndate at 45 no-label
    transfer.transfer-date at 70 no-label
   skip(1)
    "(4)�������/Part NO.:" at 12
   "(5)����/Quantity:" at 42
   "(6)��λ/Unit:" at 67
   skip
       transfer.transfer-part at 15 no-label
        item-qty  at 45 no-label
        transfer.transfer-um at 70 no-label
        skip(1)
  
 "(7)�������/Desc:" at 12
   skip 
  itemdesc at 15  no-label

    skip(1)
   "(8)�Ƴ��ص�/��λ/From:" at 12 space(2) transfer.src-site no-label
   "(9)����ص�/��λ/To:" at 42 
   skip
     transfer.src-loc no-label at 15
    
   skip(1)
   "(10)�ɹ�����/�ӹ�����/Order:" at 12
   "(11)��Ӧ�̴���/Supplier:" at 42
   "(12)�ջ�����/Receiver:" at 67
   skip
      /*  transfer.transfer-nbr at 15  no-label
      transfer.transfer-addr at 45 no-label
       transfer.transfer-lot at 71 no-label*/
   skip(1)
   "(13)��Ӧ��/Name of supplier:" at 12 
   "(14)QAD�����/Lot:" at 67 
       skip
       mname at 15 no-label
       transfer.transfer-src-lot-serial at 71 no-label
      
   
    WITH    stream-io WIDTH 180 SIDE-LABEL.
