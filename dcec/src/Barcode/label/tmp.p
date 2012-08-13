DEFINE FRAME mlabeltr
    skip(1)
    
   
   "(1) 移库" at 12
   "(2)打印日期/Print Date:" at 42
   "(3)入库日期/Receipt Date:" at 67
   skip
   prndate at 45 no-label
    transfer.transfer-date at 70 no-label
   skip(1)
    "(4)零件代码/Part NO.:" at 12
   "(5)数量/Quantity:" at 42
   "(6)单位/Unit:" at 67
   skip
       transfer.transfer-part at 15 no-label
        item-qty  at 45 no-label
        transfer.transfer-um at 70 no-label
        skip(1)
  
 "(7)零件描述/Desc:" at 12
   skip 
  itemdesc at 15  no-label

    skip(1)
   "(8)移出地点/库位/From:" at 12 space(2) transfer.src-site no-label
   "(9)移入地点/库位/To:" at 42 space(2)  transfer.desti-site no-label
   skip
     transfer.src-loc no-label at 15
     transfer.desti-loc no-label at 45

 
   skip(1)
   "(10)采购单号/加工单号/Order:" at 12
   "(11)供应商代码/Supplier:" at 42
   "(12)收货单号/Receiver:" at 67
   skip
      /*  transfer.transfer-nbr at 15  no-label
      transfer.transfer-addr at 45 no-label
       transfer.transfer-lot at 71 no-label*/
   skip(1)
   "(13)供应商/Name of supplier:" at 12 
   "(14)QAD批序号/Lot:" at 67 
       skip
       mname at 15 no-label
       transfer.transfer-desti-lot-serial at 71 no-label
      
   
    WITH    stream-io WIDTH 180 SIDE-LABEL.
    
    DEFINE FRAME mlabeltr1
    skip(1)
    
   
   "(1) 移库" at 12
   "(2)打印日期/Print Date:" at 42
   "(3)入库日期/Receipt Date:" at 67
   skip
   prndate at 45 no-label
    transfer.transfer-date at 70 no-label
   skip(1)
    "(4)零件代码/Part NO.:" at 12
   "(5)数量/Quantity:" at 42
   "(6)单位/Unit:" at 67
   skip
       transfer.transfer-part at 15 no-label
        item-qty  at 45 no-label
        transfer.transfer-um at 70 no-label
        skip(1)
  
 "(7)零件描述/Desc:" at 12
   skip 
  itemdesc at 15  no-label

    skip(1)
   "(8)移出地点/库位/From:" at 12 space(2) transfer.src-site no-label
   "(9)移入地点/库位/To:" at 42 space(2)  transfer.desti-site no-label
   skip
     transfer.src-loc no-label at 15
     transfer.desti-loc no-label at 45

 
   skip(1)
   "(10)采购单号/加工单号/Order:" at 12
   "(11)供应商代码/Supplier:" at 42
   "(12)收货单号/Receiver:" at 67
   skip
      /*  transfer.transfer-nbr at 15  no-label
      transfer.transfer-addr at 45 no-label
       transfer.transfer-lot at 71 no-label*/
   skip(1)
   "(13)供应商/Name of supplier:" at 12 
   "(14)QAD批序号/Lot:" at 67 
       skip
       mname at 15 no-label
       transfer.transfer-desti-lot-serial at 71 no-label
      
   
    WITH    stream-io WIDTH 180 SIDE-LABEL.
 DEFINE FRAME mlabelsrcremain1
    skip(1)
    
   
   "(1) 剩余" at 12
   "(2)打印日期/Print Date:" at 42
   "(3)入库日期/Receipt Date:" at 67
   skip
   prndate at 45 no-label
    transfer.transfer-date at 70 no-label
   skip(1)
    "(4)零件代码/Part NO.:" at 12
   "(5)数量/Quantity:" at 42
   "(6)单位/Unit:" at 67
   skip
       transfer.transfer-part at 15 no-label
        item-qty  at 45 no-label
        transfer.transfer-um at 70 no-label
        skip(1)
  
 "(7)零件描述/Desc:" at 12
   skip 
  itemdesc at 15  no-label

    skip(1)
   "(8)移出地点/库位/From:" at 12 space(2) transfer.src-site no-label
   "(9)移入地点/库位/To:" at 42 
   skip
     transfer.src-loc no-label at 15
    
   skip(1)
   "(10)采购单号/加工单号/Order:" at 12
   "(11)供应商代码/Supplier:" at 42
   "(12)收货单号/Receiver:" at 67
   skip
      /*  transfer.transfer-nbr at 15  no-label
      transfer.transfer-addr at 45 no-label
       transfer.transfer-lot at 71 no-label*/
   skip(1)
   "(13)供应商/Name of supplier:" at 12 
   "(14)QAD批序号/Lot:" at 67 
       skip
       mname at 15 no-label
       transfer.transfer-src-lot-serial at 71 no-label
      
   
    WITH    stream-io WIDTH 180 SIDE-LABEL.
 DEFINE FRAME mlabelsrcremain
    skip(1)
    
   
   "(1) 剩余" at 12
   "(2)打印日期/Print Date:" at 42
   "(3)入库日期/Receipt Date:" at 67
   skip
   prndate at 45 no-label
    transfer.transfer-date at 70 no-label
   skip(1)
    "(4)零件代码/Part NO.:" at 12
   "(5)数量/Quantity:" at 42
   "(6)单位/Unit:" at 67
   skip
       transfer.transfer-part at 15 no-label
        item-qty  at 45 no-label
        transfer.transfer-um at 70 no-label
        skip(1)
  
 "(7)零件描述/Desc:" at 12
   skip 
  itemdesc at 15  no-label

    skip(1)
   "(8)移出地点/库位/From:" at 12 space(2) transfer.src-site no-label
   "(9)移入地点/库位/To:" at 42 
   skip
     transfer.src-loc no-label at 15
    
   skip(1)
   "(10)采购单号/加工单号/Order:" at 12
   "(11)供应商代码/Supplier:" at 42
   "(12)收货单号/Receiver:" at 67
   skip
      /*  transfer.transfer-nbr at 15  no-label
      transfer.transfer-addr at 45 no-label
       transfer.transfer-lot at 71 no-label*/
   skip(1)
   "(13)供应商/Name of supplier:" at 12 
   "(14)QAD批序号/Lot:" at 67 
       skip
       mname at 15 no-label
       transfer.transfer-src-lot-serial at 71 no-label
      
   
    WITH    stream-io WIDTH 180 SIDE-LABEL.
