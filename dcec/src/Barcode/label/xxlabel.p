{mfdtitle.i }
    {gplabel.i}
/*{mfdeclre.i}*/
    define  variable part like pt_part VIEW-AS fill-in SIZE 20 BY 1 LABEL "�������" .
DEFINE VAR wo like WO_NBR VIEW-AS fill-in SIZE 20 BY 1 LABEL "�ӹ�����".
DEFINE VAR standard AS LOGICAL initial yes  VIEW-AS FILL-IN SIZE 5 BY 1 FORMAT "Yes/No" LABEL "��׼".
DEFINE VAR qty AS INTEGER VIEW-AS FILL-IN SIZE 8 BY 1 LABEL "����".
    DEFINE VAR pallet-per AS INT VIEW-AS fill-in SIZE 12 BY 1 LABEL "ÿ��������" .
    DEFINE VAR pallet-qty AS INT VIEW-AS FILL-IN SIZE 12 BY 1 LABEL  "��������".
     define var isprint as logical initial no.
    DEFINE VAR pallet-qtys AS INT  EXTENT 99 initial 0 VIEW-AS FILL-IN SIZE 12 BY 1 LABEL "����".
    DEFINE VAR totalqty LIKE tr_qty_loc.
    DEFINE VAR prndate LIKE tr_date INITIAL TODAY.
    DEFINE VAR remain AS LOGICAL.
    DEFINE VAR i AS INT.
    DEFINE VAR mline LIKE tr_line VIEW-AS fill-in SIZE 5 BY 1 LABEL "��".
    DEFINE VAR item-qty LIKE  tr_qty_loc.
      define var isavailable as logical initial no.
  define var itemdesc as char format "x(48)".
   define var mcount as int initial 0.
   DEFINE VAR mdate like tr_date  VIEW-AS FILL-IN SIZE 8 BY 1 LABEL "����".
DEFINE VAR mdate1 like tr_date  VIEW-AS FILL-IN SIZE 8 BY 1 LABEL "��". 
   def  var mname like ad_name.
   DEF VAR vend LIKE po_vend.
   DEF VAR pass_qty LIKE tr_qty_loc.
   DEF VAR unpass_qty LIKE tr_qty_loc.
    DEFINE BUTTON b-done LABEL "ѡ��" SIZE 12 BY 1.
     DEFINE QUERY qry FOR tr_hist.
    DEFINE BROWSE brw  QUERY qry
    DISPLAY
        
        tr_hist.tr_date LABEL "����"    
       tr_hist.tr_line LABEL "�к�"
        tr_hist.tr_part LABEL "�������"
           abs(tr_hist.tr_qty_loc)  LABEL "����" 
          tr_hist.tr_site  column-label "�ص�"  
            tr_hist.tr_loc column-LABEL "��λ" 
           tr_hist.tr_serial LABEL "��/���" 
      
      
           
            
         
    WITH   7 DOWN WIDTH 77 TITLE "�ջ�����" LABEL-FGCOLOR 15 LABEL-BGCOLOR 9  SEPARATORS.
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
         WITH  FRAME a WIDTH 80  three-d TITLE "�ʼ쵥��ӡ" SIDE-LABEL.
   /* part at 127*/
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
     
     
        tr_hist.tr_date COLON 20 LABEL "����"    
   
      tr_hist.tr_part COLON 45 LABEL "�������"
   skip(0.5)
     
      /* pt_desc1 COLON 20 LABEL "�������" 
    pt_desc2 COLON 50*/
    itemdesc colon 20 LABEL "�������" 
    
    

      
      
       
        skip(0.5)
            tr_hist.tr_site COLON 20 LABEL "�ص�"
            tr_hist.tr_loc COLON 45 LABEL "��λ"
        skip(0.5)
         
     tr_hist.tr_qty_loc COLON 20 LABEL "����"
     tr_hist.tr_serial COLON 45 LABEL "��/���"
      skip(0.5)
     standard COLON 20 
     
      WITH WIDTH 80 THREE-D SIDE-LABEL.
DEFINE FRAME mlabelin
    skip(4)
   "�ʼ쵥" at 12
    SKIP(2)
    tr_hist.tr_part at 12 LABEL "�����"
    SKIP(1)
    itemdesc at 12 LABEL "�������"
    SKIP(1)
    tr_hist.tr_qty_loc at 12 LABEL "����"
    SKIP(1)
    tr_hist.tr_ser at 12 LABEL "����"
    SKIP(1)
    tr_hist.tr_um at 12 LABEL "��λ"
    SKIP(1)
    tr_hist.tr_date at 12 LABEL "�ջ�����"
    SKIP(1)
    tr_hist.tr_nbr at 12 LABEL "�ɹ���"
    SKIP(1)
    vend at 12 LABEL  "��Ӧ��"
   SKIP(1)
    mname at 12 LABEL "��Ӧ������"
   SKIP(2)
    pass_qty AT 12 LABEL "�ϸ���"
    SKIP(1)
    unpass_qty AT 12 LABEL "���ϸ���"
      
   
    WITH    stream-io WIDTH 180 SIDE-LABEL.
    
setFrameLabels(frame a:handle).


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
       MESSAGE "��Ч������!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

             NEXT-PROMPT wo WITH FRAME a.
         UNDO,RETRY.

      
       end.*/
      /*  FIND FIRST tr_hist WHERE TR_part = part AND tr_userid = global_userid AND tr_type = "RCT-WO" AND tr_qty_loc > 0 AND tr_date >= mdate AND tr_date <= mdate1 NO-LOCK NO-ERROR.
        
        
         IF NOT AVAILABLE tr_hist THEN DO:
             MESSAGE "��Ч����������!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

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
       MESSAGE "��Ч�������!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

             NEXT-PROMPT part WITH FRAME a.
         UNDO,RETRY.

      
      
        end.

         For each tr_hist WHERE TR_NBR = wo AND tr_userid = global_userid AND tr_part = part AND tr_type ="RCT-WO" NO-LOCK:
        isavailable = yes.

        end.
         IF NOT isavailable THEN DO:
             MESSAGE "��Ч�������!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

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
             MESSAGE "��Ч�к�!"  VIEW-AS ALERT-BOX  error BUTTONS OK. 

             NEXT-PROMPT mline WITH FRAME a.
         UNDO,RETRY.
             END.      
          
          isavailable = no.
          END.*/
          
       
      repeat:
      OPEN QUERY qry   for each tr_hist   WHERE tr_part = part /*AND tr_userid = global_userid*/ AND  tr_type ="iss-tr" /*AND tr_qty_loc > 0*/ AND tr_date >= mdate AND tr_date <= mdate1 BY tr_trnbr DESCENDING .
    ENABLE ALL WITH FRAME fr-brws.
   
          WAIT-FOR CHOOSE OF b-done.
        

             
           
         /* END.*/
      
         /*run print.*/
     REPEAT:
     
       {mfselbpr.i "printer" 80}  /*output to printer.*/
    
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
         FIND FIRST po_mstr WHERE po_nbr = tr_hist.tr_nbr NO-LOCK NO-ERROR.
         IF AVAILABLE po_mstr THEN DO:
        find first ad_mstr where ad_addr = po_vend NO-LOCK NO-ERROR.
        if available ad_mstr then  mname = if ad_name <> '' then ad_name else ad_sort.
        vend = po_vend.
         END.
   

         DISPLAY  tr_hist.tr_part
 /*   pt_desc1 
    pt_desc2 */ itemdesc
    abs(tr_hist.tr_qty_loc) @ tr_hist.tr_qty_loc 
    tr_hist.tr_nbr 
  vend 
   
   
    mname tr_hist.tr_um
   
  
   
    tr_hist.tr_serial 
    
    tr_hist.tr_date
    
   WITH FRAME mlabelin .
               PAGE. 
        
  
     {xxmftrl080.i} 
     end. /*output close.*/
END.
end.
           
