{bcdeclre.i "new" "global"}
{mfdeclre.i}
   g_user = GLOBAL_userid .




define  shared temp-table xkprhhist
             field xkprhnbr      as char format "x(8)"
             field xkprhponbr    as char format "x(8)"
             field xkprhline     as integer format ">,>>>,>>9"
             field xkprhpart     as char format "x(18)"
             field xkprhrctdate  as date format "99/99/99"
             field xkprheffdate  as date format "99/99/99"
             field xkprhqty      as decimal format ">>,>>9.99"
             field xkprhvend     as char format "x(8)"
             field xkprhdsite    as char format "x(8)"
             field xkprhdloc     as char format "x(18)"
             field xkprhssite    as char format "x(18)"
             field xkprhssloc    as char format "x(18)"       
             field xkprhinrcvd   as logical 
             field xkprhregion   as char format "x(8)"
             field xkprhkbid     as char format "x(20)"
             index  xkprhinrcvd xkprhinrcvd xkprhponbr xkprheffdate.
DEF TEMP-TABLE bki_tmp
    FIELD bki_nbr AS CHAR.
    
DEF VAR bc_id AS CHAR FORMAT "x(20)"  LABEL "����".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "�����".
DEF VAR bc_po_part_desc AS CHAR FORMAT "x(24)" LABEL "�������".
DEF VAR bc_po_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "����".

DEF VAR bc_po_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "����".
DEF VAR bc_site AS CHAR FORMAT "x(18)" LABEL "�ص�".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "��λ".
DEF VAR bc_po_nbr AS CHAR FORMAT "x(8)"    LABEL "�ɹ���".
DEF VAR bc_po_part AS CHAR FORMAT "x(18)" LABEL "�����".
DEF VAR bc_po_line AS CHAR FORMAT "x(8)"  LABEL "�к�".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "��/���".
DEFINE BUTTON bc_button LABEL "ȷ��" SIZE 8 BY 1.50.
DEF VAR bc_sub AS LOGICAL LABEL "ת��".
DEF VAR bc_woid AS CHAR FORMAT "x(8)" LABEL "��־".
DEF VAR bc_wo AS CHAR FORMAT "x(8)" LABEL "����".
DEF VAR bc_ref AS CHAR FORMAT "x(8)" LABEL "�ο���".

DEF FRAME bc
    bc_po_nbr AT ROW 1.2 COL 2.5
    bc_po_line AT ROW 2.4 COL 4
  bc_po_part AT ROW 3.6 COL 2.5
    bc_po_qty AT ROW 4.8 COL 4  
    'EA' AT ROW 4.8 COL 22 
    /*bc_po_part_desc  AT ROW 6 COL 1
    bc_po_part_desc1  NO-LABEL AT ROW 7 COL 8.5*/
    bc_sub AT ROW 6 COL 4
    bc_wo AT ROW 7.2 COL 4
    bc_woid AT ROW 8.4 COL 4
    bc_id AT ROW 9.6 COL 4
    bc_part AT ROW 10.8 COL 2.5
   
    
   bc_lot AT ROW 12 COL 1.6
    bc_ref AT ROW 13.2 COL 2.5
    bc_qty AT ROW 14.4 COL 4 'EA' AT ROW 14.4 COL 22 
   
    bc_site AT ROW 15.6 COL 4

    bc_loc AT ROW 15.6 COL 20 NO-LABEL
  
   
    bc_button AT ROW 16.7 COL 10
    WITH SIZE 30 BY 18.5 TITLE "�ɹ��ջ�"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
FOR EACH xkprhhist NO-LOCK:
assign
    bc_po_nbr = xkprhponbr 
    bc_po_line = xkprhline
    bc_po_part = xkprhpart
    bc_po_qty = xkprhqty
    bc_site = xkprhdsite
    bc_loc = xkprhdloc.
{bcrun.i ""bcmgordexp.p"" "(INPUT ""pod"" ,
            INPUT bc_po_nbr,
            INPUT bc_po_line,
            OUTPUT part,OUTPUT qty,
            OUTPUT lntyp)"}

       
  
    DISP bc_po_part bc_po_qty WITH FRAME bc.
     DISABLE bc_po_line WITH FRAME bc. 
    IF lntyp = 's' THEN do:
        bc_sub = YES.
        ENABLE bc_wo WITH FRAME bc.
    END.
    ELSE do:
        bc_sub = NO.
        bc_wo = ''.
        bc_woid = ''.
        ENABLE bc_id WITH FRAME bc.


/*DISABLE bc_po_part_desc  bc_po_part_desc1 WITH FRAME bc_pick .*/
 /*DISP bc_part 
   bc_po_qty
  /*  bc_po_part_desc  
    bc_po_part_desc1  */
   bc_lot 
    bc_qty 
   
    bc_site 

    bc_loc 
  
    WITH FRAME bc .*/
/*VIEW c-win.*/

/*
ON enter OF bc_po_nbr
DO:
    bc_po_nbr = bc_po_nbr:SCREEN-VALUE.
    {bcrun.i ""bcmgcheck.p"" "(input ""po"",
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input bc_po_nbr, 
        input """",
         input """", 
        input """",
         input """",
        output success)"}
    IF  NOT success THEN do:
       
       UNDO,RETRY.

    END.
   ELSE DO: 
       DISABLE bc_po_nbr WITH FRAME bc.
       ENABLE bc_po_line WITH FRAME bc.
   {bclock.i "po_mstr" "po_nbr" "bc_po_nbr"}
   END.
  
    END.


   ON enter OF bc_po_line
DO:
        bc_po_line = bc_po_line:SCREEN-VALUE.
        
         {bcrun.i ""bcmgcheck.p"" "(input ""pod"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input bc_po_nbr, 
        input bc_po_line,
         input """", 
        input """",
         input """",
        output success)"}
        IF  NOT success THEN do:
        UNDO,RETRY.
    END.
    ELSE do:
        {bcrun.i ""bcmgordexp.p"" "(INPUT ""pod"" ,
            INPUT bc_po_nbr,
            INPUT bc_po_line,
            OUTPUT part,OUTPUT qty,
            OUTPUT lntyp)"}

        bc_po_part = part.
    bc_po_qty = qty.
  
    DISP bc_po_part bc_po_qty WITH FRAME bc.
     DISABLE bc_po_line WITH FRAME bc. 
    IF lntyp = 's' THEN do:
        bc_sub = YES.
        ENABLE bc_wo WITH FRAME bc.
    END.
    ELSE do:
        bc_sub = NO.
        bc_wo = ''.
        bc_woid = ''.
        ENABLE bc_id WITH FRAME bc.
        
        END.
    
   
    
    END.
    END.*/

   /* ON enter OF bc_sub
DO:
      
        IF bc_sub:SCREEN-VALUE = 'YES' THEN 
    ENABLE bc_wo  WITH FRAME bc.
        ELSE  ENABLE bc_id WITH FRAME bc.
        DISABLE bc_sub WITH FRAME bc.
        END.*/
    
    
 ON enter OF bc_wo
DO:
     bc_wo = bc_wo:SCREEN-VALUE.
    {bcrun.i ""bcmgcheck.p"" "(input ""wo"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input bc_wo, 
        input """",
         input """", 
        input """",
         input """",
        output success)"}.
    IF NOT success THEN do:
      UNDO,RETRY.
      
    END.
    ELSE DO:
    DISABLE bc_wo WITH FRAME bc.
    ENABLE bc_woid WITH FRAME bc.
        
        END.
    END.

    ON enter OF bc_woid
DO:
        bc_woid = bc_woid:SCREEN-VALUE.
          {bcrun.i ""bcmgcheck.p"" "(input ""woid"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input """", 
        input bc_wo, 
        input bc_woid,
         input """", 
        input """",
         input """",
        output success)"}
        IF NOT success THEN 
        UNDO,RETRY.
      ELSE 
          do:
              DISABLE bc_woid WITH FRAME bc.
          ENABLE bc_id WITH FRAME bc.
      END.
    END.

    ON enter OF bc_id
DO:
        bc_id = bc_id:SCREEN-VALUE.
         {bcrun.i ""bcmgcheck.p"" "(input ""bd"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input bc_id, 
        input """", 
        input """",
         input  ""in"" , 
        input """",
         input """",
        output success)"}
        IF NOT success THEN 
        UNDO,RETRY.
      ELSE DO:
     
            DISABLE bc_id WITH FRAME bc.
            
            FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
              IF AVAILABLE b_co_mstr THEN DO:
                 bc_part = b_co_part.
                 IF b_co_lot <> '' THEN  bc_lot = b_co_lot.
                 IF b_co_ser <> 0 THEN bc_lot = string(b_co_ser).
                 bc_ref = b_co_ref.
                  bc_qty = b_co_qty_cur.
                  IF bc_part = xkprhpart AND bc_qty = xkprhqty THEN DO:
                  
                  DISP bc_part bc_lot bc_ref bc_qty WITH FRAME bc.
                 
                  
              ENABLE bc_button WITH FRAME bc.
                  END.
                  ELSE DO:
                    MESSAGE '��ɨ��'  bc_po_part '!'             VIEW-AS ALERT-BOX.
                  END.
      END.
          END
      END.
         
    END.

    /* ON enter OF bc_site
DO:
         bc_site = bc_site:SCREEN-VALUE.
         {bcrun.i ""bcmgcheck.p"" "(input ""bd_loc"" ,
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input bc_site, 
        input """", 
        input """",
         input """", 
        input """",
         input """",
        output success)"}
           
        IF NOT success THEN UNDO,RETRY.
        
        ELSE DO:
              FIND b_loc_mstr WHERE b_loc_code = bc_site NO-LOCK NO-ERROR.
              bc_site = b_loc_site.
              bc_loc = b_loc_loc.
          
           {bcrun.i ""bcmgcheck.p"" "(input ""bd_match"" ,
        input bc_site,
        input """", 
        input """", 
        input """", 
        input """",
         input """", 
        input bc_id, 
        input """", 
        input """",
         input """", 
        input """",
         input """",
        output success)"}
          IF NOT success THEN do:
              
              UNDO,RETRY.
          END.
             ELSE
               do: 
       
                 
                 
                 DISABLE bc_site WITH FRAME bc.
      DISP bc_site bc_loc WITH FRAME bc.
        ENABLE bc_button WITH FRAME bc.
        
             END.
       
   
   END.
     END.
  /*  ON enter OF bc_loc
DO:
        bc_loc = bc_loc:SCREEN-VALUE.
        
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
        output success)"}
        IF NOT success THEN UNDO,RETRY.
    ELSE DO:
       DISABLE bc_loc WITH FRAME bc.
       ENABLE bc_button WITH FRAME bc.
        
        
        
        END.
   
   
   END.*/*/
    ON 'choose':U OF bc_BUTTON
      DO:
       DISABLE bc_button WITH FRAME bc.
        RUN main.


        
        END.


 


PROCEDURE main:
     
        FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
          b_co_status = 'received'.
          
           FIND FIRST b_ld_det WHERE b_ld_code = b_co_code AND b_ld_site = bc_site AND b_ld_loc = bc_loc  EXCLUSIVE-LOCK NO-ERROR.
           IF AVAILABLE b_ld_det THEN 
               ASSIGN b_ld_qty_oh = b_co_qty_cur.
           ELSE DO:
           CREATE b_ld_det.
         b_ld_code = b_co_code.
         b_ld_loc = bc_loc.
         b_ld_site = bc_site.
         b_ld_part = b_co_part.
         b_ld_lot = b_co_lot.
         /*b_ld_ser = b_co_ser.*/
       /*  b_ld_ref = b_co_ref.*/
       
         b_ld_qty_oh = b_co_qty_cur.
           END.
         {bctrcr.i
         &ord=bc_po_nbr
         &mline=bc_po_line
         &b_code=b_co_code
         &b_part=b_co_part
         &b_lot=b_co_lot
         &b_ser=b_co_ser
         &b_qty_ord=bc_po_qty
         &b_qty_loc=b_co_qty_cur
         &b_qty_chg=b_co_qty_cur
         &b_um=b_co_um
         &mdate1=TODAY
          &mdate2=TODAY
          &mdate_eff=TODAY
           &b_typ='"rct-po"'
          &mtime=TIME
           &b_loc=bc_loc
           &b_site=bc_site
           &b_usrid=g_user}
           
             {bcusrhist.i }
              
         {bcrelease.i}
    
    bki_nbr = xkprhnbr.
END.
  FOR EACH xkprhhist NO-LOCK:
      FIND FIRST bki_tmp WHERE bki_nbr = xkprhnbr NO-LOCK NO-ERROR.
      IF NOT AVAILABLE bki_tmp THEN DO:
         
      END.
  END.
     
END.



    {BCTRAIL.I}
