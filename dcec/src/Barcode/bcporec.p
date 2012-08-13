{mfdeclre.i}
{bcdeclre.i}
DEFINE VAR C-Win AS WIDGET-HANDLE .
DEF VAR bc_id AS CHAR FORMAT "x(20)"  LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_po_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_po_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".

DEF VAR bc_po_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".
DEF VAR bc_site AS CHAR FORMAT "x(8)" LABEL "地点".
DEF VAR bc_loc AS CHAR FORMAT "x(8)" LABEL "库位".
DEF VAR bc_po_nbr AS CHAR FORMAT "x(8)"    LABEL "采购单".
DEF VAR bc_po_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_po_line AS CHAR FORMAT "x(8)"  LABEL "行号".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF VAR bc_sub AS LOGICAL LABEL "转包".
DEF VAR bc_woid AS CHAR FORMAT "x(8)" LABEL "标志".
DEF VAR bc_wo AS CHAR FORMAT "x(8)" LABEL "工单".
DEF VAR bc_ref AS CHAR FORMAT "x(8)" LABEL "参考号".

DEF FRAME bc
    bc_po_nbr AT ROW 1.2 COL 2.5
    bc_po_line AT ROW 2.4 COL 4
  bc_po_part AT ROW 3.6 COL 2.5
    bc_po_qty AT ROW 4.8 COL 4  
    'EA' AT ROW 4.8 COL 15 
    /*bc_po_part_desc  AT ROW 6 COL 1
    bc_po_part_desc1  NO-LABEL AT ROW 7 COL 8.5*/
    bc_sub AT ROW 6 COL 4
    bc_wo AT ROW 7.2 COL 4
    bc_woid AT ROW 8.4 COL 4
    bc_id AT ROW 9.4 COL 4
    bc_part AT ROW 10.6 COL 2.5
   
    
   bc_lot AT ROW 11.8 COL 1.6
    bc_ref AT ROW 13 COL 2.5
    bc_qty AT ROW 14.2 COL 4 'EA' AT ROW 14.2 COL 15 
   
    bc_site AT ROW 15.4 COL 4

    bc_loc AT ROW 15.4 COL 15
  
   
    bc_button AT ROW 16.5 COL 10
    WITH SIZE 30 BY 18.5 TITLE "采购收货"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "BARCODEING"
         HEIGHT             = 18.5
         WIDTH              = 30
         MAX-HEIGHT         = 18.5
         MAX-WIDTH          = 30
         VIRTUAL-HEIGHT     = 120
         VIRTUAL-WIDTH      = 133
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = NO
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ASSIGN CURRENT-WINDOW                = c-win
       THIS-PROCEDURE:CURRENT-WINDOW = c-win.
C-Win:HIDDEN = no.

ENABLE bc_po_nbr 
   /* bc_po_line
  
    bc_id */
     WITH FRAME bc IN WINDOW c-win.
bc_sub = NO.
DISP bc_sub WITH FRAME bc.
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
VIEW c-win.

 
ON enter OF bc_po_nbr
DO:
    bc_po_nbr = bc_po_nbr:SCREEN-VALUE.
    run bccheck.p(input 'po',input '',input '', input '', input '', input '', input '', input '', input bc_po_nbr, input '', input '', input '', input '',output success).
    IF  NOT success THEN do:
       
       UNDO,RETRY.

    END.
   ELSE DO: 
       DISABLE bc_po_nbr WITH FRAME bc.
       ENABLE bc_po_line WITH FRAME bc.
   
   END.
  
    END.


    ON enter OF bc_po_line
DO:
        bc_po_line = bc_po_line:SCREEN-VALUE.
        run bccheck.p(input 'pod',input '',input '', input '', input '', input '', input '', input '', input bc_po_nbr, input bc_po_line, input '', input '', input '',output success).
    IF  NOT success THEN do:
        UNDO,RETRY.
    END.
    ELSE do:
        run bcordexp.p(INPUT 'pod',INPUT bc_po_nbr,INPUT bc_po_line,OUTPUT part,OUTPUT qty,OUTPUT lntyp).
    
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
    END.

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
    run bccheck.p(input 'wo',input '',input '', input '', input '', input '', input '', input '', input bc_wo, input '', input '', input '', input '',output success).
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
        run bccheck.p(input 'woid',input '',input '', input '', input '', input '', input '', input '', input bc_wo, input bc_woid, input '', input '', input '',output success).
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
        run bccheck.p(input 'bd',input '',input '', input '', input '', input '', input '', input bc_id, input '', input '', input 'in', input '', input '',output success).
    IF NOT success THEN 
        UNDO,RETRY.
      ELSE DO:
     

          
          run bccheck.p(input 'bd_match',input '',input '', input '', input '', input '', input '', input bc_id, input '', input '', input '', input '', input '',output success).
           IF NOT success THEN UNDO,RETRY.
             ELSE
               do:
              DISABLE bc_id WITH FRAME bc.
              FIND FIRST b_co_mstr WHERE b_co_code = bc_id NO-LOCK NO-ERROR.
              IF AVAILABLE b_co_mstr THEN DO:
                 bc_part = b_co_part.
                 IF b_co_lot <> '' THEN  bc_lot = b_co_lot.
                 IF b_co_ser <> 0 THEN bc_lot = string(b_co_ser).
                 bc_ref = b_co_ref.
                  bc_qty = b_co_qty_cur.
                  DISP bc_part bc_lot bc_ref bc_qty WITH FRAME bc.
                  END.
              ENABLE bc_site WITH FRAME bc.
      END.
          END.

         
    END.

     ON enter OF bc_site
DO:
         bc_site = bc_site:SCREEN-VALUE.
         run bccheck.p(input 'site',input bc_site,input '', input '', input '', input '', input '', input '', input '', input '', input '', input '', input '',output success).
    IF NOT success THEN UNDO,RETRY.
    ELSE DO:
       DISABLE bc_site WITH FRAME bc.
       ENABLE bc_loc WITH FRAME bc.
        
        
        
        END.
   
   
   END.

    ON enter OF bc_loc
DO:
        bc_loc = bc_loc:SCREEN-VALUE.
        run bccheck.p(input 'loc',input bc_site,input bc_loc, input '', input '', input '', input '', input '', input '', input '', input '', input '', input '',output success).
   IF NOT success THEN UNDO,RETRY.
    ELSE DO:
       DISABLE bc_loc WITH FRAME bc.
       ENABLE bc_button WITH FRAME bc.
        
        
        
        END.
   
   
   END.
    ON 'choose':U OF bc_BUTTON
      DO:
    RUN main.



        
        END.
        ON WINDOW-CLOSE OF C-Win /* <insert window title> */
   DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.

        END.


PROCEDURE main:
     run bccheck.p(input 'period',input '',input '', input '', input '', input '', input '', input '', input '', input '', input '', input '', input '',output success).
        IF NOT success THEN LEAVE.
run bccheck.p(input 'ictr_typ',input bc_site,input bc_loc, input bc_part, input bc_lot, input bc_ref, input 'rct-po', input '', input '', input '', input '', input '', input '',output success).
        IF NOT success THEN LEAVE.
        FIND FIRST b_co_mstr WHERE b_co_code = bc_id NO-LOCK NO-ERROR.
          b_co_status = 'received'.
        CREATE b_loc_mstr.
          b_loc_code = b_co_code.
          b_loc_loc = bc_loc.
          b_loc_site = bc_site.
         CREATE b_ld_det.
         b_ld_code = b_co_code.
         b_ld_loc = bc_loc.
         b_ld_site = bc_site.
         b_ld_part = b_co_part.
         b_ld_lot = b_co_lot.
         /*b_ld_ser = b_co_ser.*/
       /*  b_ld_ref = b_co_ref.*/
       
         b_ld_qty_oh = b_co_qty_cur.
        
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
           &b_site=bc_site}
           
             {bcusrhist.i }
             
             RUN gpwrbf.p
          (INPUT bc_po_nbr,
          INPUT bc_po_line,
          INPUT b_co_code,
          INPUT b_co_part,
          INPUT b_co_lot,
          INPUT b_co_ser,
           INPUT b_co_ref,
    INPUT b_co_qty_cur,
          INPUT b_co_um,
    INPUT TODAY,
    INPUT "",
    INPUT "",
    INPUT "",
    INPUT "",
    INPUT bc_loc,
    INPUT bc_site,
    "poporc.p",
    INPUT "",
    INPUT "",
    INPUT "",
    INPUT "",
    INPUT bc_sub,
    INPUT bc_wo,
    INPUT bc_woid).
         FIND FIRST b_ct_ctrl NO-LOCK NO-ERROR.
         IF b_ct_up_mtd = 'online' THEN DO:
         
             
             
             
             
             RUN gpwrfl.p(INPUT 'poporc',INPUT mcount).
             
             
             
             
             
             
             
             
             
             END.
END.
WAIT-FOR CLOSE OF THIS-PROCEDURE.
