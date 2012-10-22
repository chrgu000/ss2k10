{mfdeclre.i}
{bcdeclre.i  }
{bcwin02.i}
    {bctitle.i}
DEF VAR bc_id AS CHAR FORMAT "x(18)" LABEL "����".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "�����".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(20)" LABEL "�������".
DEF VAR bc_part_desc2 AS CHAR FORMAT "x(20)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9" LABEL "����".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9" LABEL "����".*/
DEF VAR bc_qty_std AS DECIMAL FORMAT "->>,>>>,>>9" LABEL "��׼����".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "��/���".
DEF VAR bc_split_qty AS DECIMAL FORMAT "->>,>>>,>>9" LABEL "�������".
 DEF VAR bcprefix AS CHAR.
DEF VAR bc_pack AS CHAR FORMAT "x(8)" LABEL "�ο���".
DEFINE BUTTON bc_button LABEL "ȷ��" SIZE 8 BY 1.50.
DEF VAR oktocomt AS LOGICAL.
DEF VAR bc_split_id LIKE bc_id.
DEF VAR bc_site AS CHAR FORMAT "x(18)" LABEL "�ص�".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "��λ".
DEF VAR  msite AS CHAR.
DEF VAR ismodi AS LOGICAL.
DEF VAR bc_vend AS CHAR FORMAT "X(8)" LABEL "��Ӧ��".
DEF VAR mqty AS DECIMAL.
 DEF VAR bc_qty_mult AS DECIMAL FORMAT "->>,>>>,>>9"  LABEL '��װ��'.
DEF VAR bc_qty_label AS INT FORMAT "->>,>>>,>>9" LABEL '����'.
DEF FRAME bc
    bc_id AT ROW 1.2 COL 4
    bc_part AT ROW 2.4 COL 2.5
   /*bc_vend AT ROW 3.6 COL 2.5*/
    bc_part_desc1  AT ROW 3.6 COL 1
    bc_part_desc2  NO-LABEL AT ROW 4.6 COL 8.8
   
    bc_site AT ROW 5.8 COL 4
    bc_loc AT ROW 7 COL 4
  /* bc_lot AT ROW 8.2 COL 1.6*/
   /* bc_pack AT ROW 6.5 COL 2.5*/
   
    bc_qty AT ROW 8.2 COL 4
    bc_qty_mult AT ROW 9.4 COL 2.5
    bc_qty_label AT ROW 9.4 COL 20 NO-LABEL
  /* bc_pkqty AT ROW 10 COL 4*/
   /* bc_qty_std AT ROW 8 COL 1*/
  
  /* bc_qty_mult AT ROW 10.6 COL 2.5*/
   
    WITH SIZE 30 BY 12 TITLE "���Ƽ������������"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
ismodi = NO.
ENABLE bc_part  WITH FRAME bc IN WINDOW c-win.

VIEW c-win.
ON CURSOR-DOWN OF bc_part
DO:
    
       ASSIGN bc_part.
       FIND FIRST pt_mstr NO-LOCK WHERE pt_part > bc_part NO-ERROR.
       IF AVAILABLE pt_mstr THEN DO:
           ASSIGN bc_part = pt_part.
           DISPLAY bc_part WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_part
DO:
   
       ASSIGN bc_part.
       FIND LAST pt_mstr NO-LOCK WHERE pt_part < bc_part NO-ERROR.
       IF AVAILABLE pt_mstr THEN DO:
           ASSIGN bc_part = pt_part.
           DISPLAY bc_part WITH FRAME bc.
       END.
   
END.

ON enter OF bc_part
DO:
    
   
    
   /* IF LASTKEY = KEYCODE("cursor-up") THEN DO:
       
    END.*/
    /*IF LASTKEY = KEYCODE("return") THEN DO:*/
    bc_part = bc_part:SCREEN-VALUE.
    {bcrun.i ""bcmgcheck.p"" "(input ""part"",
        input """",
        input """", 
        input bc_part, 
        input """",
         input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """",
         input """",
        INPUT """",
        output success)"}
        IF NOT success THEN
            UNDO,RETRY.
        ELSE DO: DISABLE bc_part WITH FRAME bc.
        FIND FIRST pt_mstr WHERE pt_part = bc_part NO-LOCK NO-ERROR.
       IF AVAILABLE pt_mstr THEN
           ASSIGN
            bc_part_desc1 = pt_desc1
        bc_part_desc2 = pt_desc2.
        
        /* bc_qty = IF pt_ord_mult <> 0 THEN pt_ord_mult ELSE 1. */
        DISABLE bc_part WITH FRAME bc.
        DISP bc_part_desc1 bc_part_desc2 bc_qty WITH FRAME bc. 
        bcprefix = SUBSTR(string(YEAR(TODAY),'9999'),3,2) + STRING(MONTH(TODAY),'99') + STRING(DAY(TODAY),'99') + STRING(TIME,'999999') + SUBstr(STRING(etime),LENGTH(STRING(etime)) - 1,2).
        bc_id = bcprefix + '001' .
        bc_lot = bc_id.
        DISP bc_id /*bc_lot*/ WITH FRAME bc.
        ENABLE bc_site WITH FRAME bc.
        END.
         
     
      /*bc_lot = bcprefix.
      DISP bc_lot WITH FRAME bc.  
      ENABLE bc_lot WITH FRAME bc.*/
       /* END.*/
   
END.
ON enter OF bc_site
DO:  
      
          ASSIGN bc_site. 
     IF INDEX(bc_site,'.') <> 0 THEN DO:      
    
          /* APPLY 'entry':u TO bc_site.*/
         msite = bc_site.
         bc_site = SUBSTR(msite,1,INDEX(msite,'.') - 1).
         bc_loc = SUBSTR(msite,INDEX(msite,'.') + 1).
      END.
         
              {bccntlock.i "bc_site" "bc_loc"}
          {bcrun.i ""bcmgcheck.p"" "(input ""loc"" ,
        input bc_site,
        input bc_loc, 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """",
         input """",
        output success)"}
           
           IF NOT success  THEN 
               
               do:
               ASSIGN bc_site = ''
                     bc_loc = ''.
               DISP bc_site bc_loc WITH FRAME bc.
               
               UNDO,RETRY.
           END.

          
           ELSE DO:
         
      
      DISP bc_site bc_loc WITH FRAME bc.
       FIND FIRST ld_det WHERE ld_site = bc_site AND ld_loc = bc_loc AND ld_part = bc_part AND ld_lot = '' AND ld_qty_oh  > 0 NO-LOCK NO-ERROR.
       IF NOT AVAILABLE ld_det THEN DO:
           MESSAGE '����޴������' VIEW-AS ALERT-BOX.
           UNDO,RETRY.
           END.
       ELSE DO:
         DISABLE bc_site WITH FRAME bc.   
         mqty = ld_qty_oh.
         bc_qty = mqty.
         FIND FIRST ptp_det WHERE ptp_part = bc_part AND ptp_site = bc_site NO-LOCK NO-ERROR.
        IF AVAILABLE ptp_det THEN
            bc_qty_mult = IF ptp_ord_mult <> 0 THEN ptp_ord_mult ELSE mqty.
                    
           ELSE DO:
          FIND FIRST pt_mstr WHERE pt_part = bc_part NO-LOCK NO-ERROR.
              IF AVAILABLE pt_mstr THEN  bc_qty_mult = IF pt_ord_mult <> 0 THEN pt_ord_mult ELSE mqty.

           END.
       
           DISP bc_qty bc_qty_mult WITH FRAME bc.
          
       ENABLE bc_qty WITH FRAME bc.
          END.
          END.     
       
   
  
     END.

    
/*
ON enter OF bc_loc
DO:
    ASSIGN bc_loc.
    FIND FIRST loc_mstr WHERE loc_site = bc_site AND loc_loc = bc_loc NO-LOCK NO-ERROR.
    IF NOT AVAILABLE loc_mstr THEN DO:
        success = NO.
        MESSAGE '��Ч��λ!' VIEW-AS ALERT-BOX.
    END.
    ELSE DO:
     DISABLE bc_loc WITH FRAME bc.
     
     ENABLE bc_qty WITH FRAME bc.
    END.
END.*/
/*
ON CURSOR-DOWN OF bc_vend
DO:
    
       ASSIGN bc_vend.
       FIND FIRST scx_ref NO-LOCK WHERE scx_type = 2 AND scx_shipfrom > bc_vend NO-ERROR.
       IF AVAILABLE scx_ref THEN DO:
           ASSIGN bc_vend = scx_shipfrom.
           DISPLAY bc_vend WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_vend
DO:
   
       ASSIGN bc_vend.
       FIND LAST scx_ref NO-LOCK WHERE scx_type = 2 AND scx_shipfrom < bc_vend NO-ERROR.
       IF AVAILABLE scx_ref THEN DO:
           ASSIGN bc_vend = scx_shipfrom.
           DISPLAY bc_vend WITH FRAME bc.
       END.
   
END.

ON enter OF bc_vend
    DO:
    ASSIGN bc_vend.
        {bcrun.i ""bcmgcheck.p"" "(input ""supp"",
        input """",
        input """", 
        input bc_part, 
        input """",
         input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input bc_vend,
         input """",
        INPUT """",
        output success)"}
        IF NOT success THEN
            UNDO,RETRY.
        ELSE DO:
            DISABLE bc_vend WITH FRAME bc.
            ENABLE bc_lot WITH FRAME bc.
        END.

END.*/
/*
ON enter OF bc_lot
DO:
    bc_lot = bc_lot:SCREEN-VALUE.
    IF bc_lot = '' THEN DO:
        MESSAGE '��/��Ų���Ϊ��!' VIEW-AS ALERT-BOX error.
        UNDO,RETRY.    
        END.
        ELSE DO:
       
       IF bc_lot <> bc_id THEN ismodi = YES.
         
    DISABLE bc_lot WITH FRAME bc.
        ENABLE bc_qty WITH FRAME bc.
            END.
END.*/

/*ON enter OF bc_pack
DO:
    bc_pack = bc_pack:SCREEN-VALUE.
    
       DISABLE bc_pack WITH FRAME bc.
        ENABLE bc_qty WITH FRAME bc.
       
END.*/

ON enter OF bc_qty
DO:
    bc_qty = DECIMAL(bc_qty:SCREEN-VALUE).
      
      IF bc_qty = ? OR bc_qty <= 0 OR bc_qty > mqty THEN DO:
        MESSAGE '��������Ϊ�գ����㣬��Ϊ�����򳬹�ԭ������' VIEW-AS ALERT-BOX error.
        UNDO,RETRY.    
        END.
        
        ELSE DO:
       
       /*DISABLE bc_qty WITH FRAME bc.
        /*ENABLE bc_qty_std WITH FRAME bc.*/
 FIND FIRST ptp_det WHERE ptp_part = bc_part AND ptp_site = bc_site     NO-LOCK NO-ERROR.
        IF AVAILABLE ptp_det THEN
            bc_qty_mult = IF ptp_ord_mult <> 0  AND bc_qty > ptp_ord_mult THEN ptp_ord_mult ELSE bc_qty.
           ELSE DO:
          FIND FIRST pt_mstr WHERE pt_part = bc_part NO-LOCK NO-ERROR.
              IF AVAILABLE pt_mstr THEN  bc_qty_mult = IF pt_ord_mult <> 0 AND bc_qty > pt_ord_mult THEN pt_ord_mult ELSE bc_qty.
            END.
            DISP bc_qty_mult WITH FRAME bc.
            ENABLE bc_qty_mult WITH FRAME bc. */
            
                        DISABLE bc_qty WITH FRAME bc.
                
            ENABLE bc_qty_mult WITH FRAME bc.
         END.
       
END.

ON enter OF bc_qty_mult
DO:
    ASSIGN bc_qty_mult.
      
   IF bc_qty_mult = ? OR bc_qty_mult <= 0 OR bc_qty_mult > bc_qty THEN DO:
  
       MESSAGE '��������Ϊ�գ����㣬��Ϊ�������װ�����ܳ���������' VIEW-AS ALERT-BOX error.
        UNDO,RETRY.    
        END.
        
        ELSE DO:
            DISABLE bc_qty_mult WITH FRAME bc.
             bc_qty_label = IF bc_qty_mult <> 0 AND bc_qty MOD bc_qty_mult <> 0 THEN truncate(bc_qty / bc_qty_mult,0) + 1  ELSE
                 bc_qty / (IF bc_qty_mult <> 0 THEN bc_qty_mult ELSE bc_qty). 
                 DISP bc_qty_label WITH FRAME bc.
            RUN main.
        END.
         
      
END.




ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

PROCEDURE main:
      DEF VAR b_id LIKE b_co_code.
      DEF VAR m_fmt LIKE b_co_format.
    DEF VAR i AS INT.
      DEF VAR j AS INT.
      DEF VAR mdesc AS CHAR FORMAT "x(50)".
       DEF VAR prt AS CHAR FORMAT 'x(22)' LABEL '��ӡ��'.
      DEF VAR isfirst AS CHAR.
          DEF VAR isleave AS LOGICAL.
          DEF VAR muser AS CHAR.
          isfirst = 'first'.
           DEF VAR mtime AS INT.
    DEF VAR mdate AS DATE.
     DEF VAR bc_offset AS INT.
    DEF VAR shre_date AS DATE.
    DEF VAR eff_date AS DATE.
    FIND FIRST b_ct_ctrl NO-LOCK NO-ERROR.
     IF AVAILABLE b_ct_ctrl THEN DO:
         bc_offset = INTEGER(b_ct_nrm) NO-ERROR.
         IF ERROR-STATUS:ERROR THEN bc_offset = 0.
     END.
     ELSE bc_offset = 0.
          shre_date = DATE('01/' + string(MONTH(TODAY) MOD 12 + 1,'99') + '/' +  IF MONTH(TODAY) = 12 THEN string(YEAR(TODAY) + 1,'9999') ELSE STRING(YEAR(TODAY),'9999')).
          eff_date = MIN(TODAY + bc_offset, shre_date).
         
    {bcrun.i ""bcmgcheck.p"" "(input ""period"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input """", 
        input """",
         input ""IC"", 
        input STRING(eff_date),
         input """",
        output success)"}   
     IF NOT success THEN LEAVE.
     {bcrun.i ""bcmgcheck.p"" "(input ""si_au"" ,
        input bc_site,
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """",
         input """",
        output success)"}   
     IF NOT success THEN LEAVE.
    
 
 
    {bcrun.i ""bcmgcheck.p"" "(input ""ictr_typ"" ,
        input bc_site, 
        input bc_loc, 
        input bc_part, 
        input """",
         input """", 
        input ""iss-tr"" , 
        input """", 
        input """",
         input """", 
        input """",
         input """",
        INPUT """",
       output success)"}      
IF NOT success THEN LEAVE.
    
     {bcrun.i ""bcmgcheck.p"" "(input ""ictr_typ"" ,
        input bc_site, 
        input bc_loc, 
        input bc_part, 
        input bc_lot,
         input """", 
        input ""rct-tr"" , 
        input """", 
        input """",
         input """", 
        input """",
         input """",
          INPUT """",
       output success)"}      
IF NOT success THEN LEAVE.
     
                 /*  {bctrcr.i
         &ord=b_co_part
         &mline=?
         &b_code=?
         &b_part=b_co_part
         &b_lot=b_co_lot
         &id=?
         &b_qty_req=0
         &b_qty_loc=b_co_qty_cur
         &b_qty_chg=b_co_qty_cur
         &b_qty_short=0
         &b_um=b_co_um
         &mdate1=t_tr_date
          &mdate2=t_tr_date
          &mdate_eff=t_tr_date
           &b_typ='"rct-wo"'
          &mtime=t_tr_time
           &b_loc=b_co_loc
           &b_site=b_co_site
           &b_usrid=g_user
           &b_addr=?}
 
           b_tr_trnbr_qad =  mtrqadid.*/
        
      /*  FIND FIRST ld_det WHERE ld_site = b_co_site AND ld_loc = b_co_loc AND ld_part = b_co_part AND ld_lot = ''  AND ld_qty_oh >= b_co_qty_cur NO-LOCK NO-ERROR.
    IF AVAILABLE ld_det THEN DO:*/
  IF bc_qty  > 0 THEN DO:
 
    OUTPUT TO value(g_sess).
                
              put  "@@BATCHLOAD iclotr04.P" skip.
            PUT UNFORMAT '"' bc_part '"' SKIP.
            PUT UNFORMAT STRING(bc_qty) ' ' string(eff_date)   skip.
            PUT 'Y T Y - ' SKIP.
            PUT UNFORMAT '"' + bc_site + '" "' + bc_loc + '"'   SKIP.
            PUT UNFORMAT '"' bc_site '" "' bc_loc '"' +  ' "' bc_lot '"' SKIP.
          PUT      SKIP(2)
                     "." SKIP
                     "@@END" SKIP.
          OUTPUT CLOSE.
          mtime = TIME.
          mdate = TODAY.
             {bcrun.i ""bcmgbdpro.p"" "(INPUT g_sess,INPUT ""out.txt"")"}
                 OS-DELETE VALUE(g_sess).
              OS-DELETE VALUE('out.txt').
                 FIND LAST tr_hist USE-INDEX tr_date_trn WHERE tr_date >= mdate AND tr_date <= TODAY AND tr_type = 'iss-tr' AND tr_program = 'iclotr04.p' AND tr_site = bc_site AND tr_loc = bc_loc AND /*tr_nbr = bc_nbr AND tr_so_job = bc_so_job1 AND*/ tr_part = bc_part AND /*tr_serial = b_co_lot  AND*/ tr_qty_loc = (bc_qty * -1) AND tr_userid = g_user AND tr_time >= mtime AND tr_time <= TIME  NO-LOCK NO-ERROR.

             IF  NOT AVAILABLE tr_hist THEN do:
              MESSAGE '�����������ʧ�ܣ�' VIEW-AS ALERT-BOX ERROR.
              LEAVE.
               END.
               
                FIND FIRST pt_mstr WHERE pt_part = bc_part NO-LOCK NO-ERROR.
      
            
                   
                  j = 1.
                     
                    
                  DO i = 1 TO bc_qty_label:
                 
                  IF j MOD 1000 = 0 THEN do:
                     PAUSE 1.
                      MESSAGE '������1000�ű�ǩ��' VIEW-AS ALERT-BOX.
                     bcprefix = SUBSTR(string(YEAR(TODAY),'9999'),3,2) + STRING(MONTH(TODAY),'99') + STRING(DAY(TODAY),'99') + STRING(TIME,'999999') + SUBstr(STRING(etime),LENGTH(STRING(etime)) - 1,2).
                     j = 1.
                     END.
                 b_id = bcprefix + STRING(j,'999').
                   
                       bc_id = b_id.
                   CREATE b_co_mstr.
               ASSIGN 
                   b_co_code = bc_id
                   b_co_part = bc_part
                   b_co_lot = bc_lot
                                   /* b_co_qty_ini = bc_qty*/
                 
                    b_co_qty_cur = IF i < bc_qty_label THEN bc_qty_mult ELSE IF bc_qty MOD bc_qty_mult = 0 THEN bc_qty_mult ELSE bc_qty MOD bc_qty_mult
                                    
                   /*b_co_qty_std = bc_qty_std*/
                   b_co_um = 'ea'
                   b_co_status = 'rct'
                   /*b_co_format = m_fmt*/
                   b_co_userid = barusr
                    
                  /* b_co_qty_req = bc_rlse_qty*/
                   b_co_desc1 = IF AVAILABLE pt_mstr THEN pt_desc1 ELSE ''
                   b_co_desc2 = IF AVAILABLE pt_mstr THEN pt_desc2 ELSE ''
                   b_co_site = bc_site
                    b_co_loc = bc_loc.
               
              j = j + 1.
   /* END.
     ELSE DO:
         MESSAGE '���������󣬻�û��QAD���ƥ�䣡' VIEW-AS ALERT-BOX ERROR.
         LEAVE.
     END.*/
              muser = ''.
        mdesc = b_co_desc2 + b_co_desc1.           
         FIND FIRST IN_mstr WHERE IN_part = b_co_part AND IN_site = b_co_site NO-LOCK NO-ERROR.
      IF AVAILABLE in_mstr THEN muser = IN__qadc01 + ' '.
            {bclabel.i ""zpl"" ""part"" "b_co_code" "b_co_part" 
     "b_co_lot" "b_co_ref" "b_co_qty_cur" "b_co_vend" "mdesc" "muser" }
               
                  END.

  END.
               
              /* {bcusrhist.i }*/
                   
/*MESSAGE "�Ƿ��ӡ��" SKIP(1)
        "����?"
        VIEW-AS ALERT-BOX
        QUESTION
        BUTTON YES-NO
        UPDATE oktocomt.*/
 /*IF oktocomt THEN DO:*/
 /*FIND FIRST b_usr_mstr WHERE b_usr_usrid = g_user NO-LOCK NO-ERROR.*/
    /*IF b_usr_prt_typ <> 'ipl' AND b_usr_prt_typ <> 'zpl' THEN DO:
    MESSAGE '��ϵͳ�ݲ�֧�ֳ���ipl,zpl���͵������ӡ��!' VIEW-AS ALERT-BOX ERROR.

        LEAVE.*/
       /* END.*/
 /*OUTPUT TO VALUE(b_usr_printer).*/

     
     
     
     
   
     
     
   
             
   RELEASE b_co_mstr.
          /*MESSAGE '���������ɲ���ӡ���!' VIEW-AS ALERT-BOX INFORMATION.   */    
         ENABLE bc_part WITH FRAME bc.
          APPLY 'entry':u TO bc_part.
               END.


{bctrail.i}