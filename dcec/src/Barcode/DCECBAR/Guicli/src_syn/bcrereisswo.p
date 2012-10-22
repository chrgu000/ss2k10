{mfdeclre.i}
{bcdeclre.i  }
{bcwin12.i}
    {bctitle.i}
DEF VAR bc_id AS CHAR FORMAT "x(18)" LABEL "����".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "�����".
DEF VAR bc_part_desc AS CHAR FORMAT "x(20)" LABEL "�������".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(20)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "����".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "����".*/
DEF VAR bc_qty_std AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "��׼����".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "��/���".
DEF VAR bc_split_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "�������".
DEF VAR bcprefix AS CHAR.
DEF VAR bc_po_nbr AS CHAR FORMAT "x(8)" LABEL "�ų̵�".
DEFINE BUTTON bc_button LABEL "ȷ��" SIZE 8 BY 1.50.
DEF VAR oktocomt AS LOGICAL.
DEF VAR bc_split_id LIKE bc_id.
DEF VAR bc_site AS CHAR.
DEF VAR bc_loc AS CHAR.
DEF VAR bc_qty_label AS  DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "����".
DEF VAR ismodi AS LOGICAL.
DEF VAR bc_po_vend AS CHAR FORMAT "x(8)" LABEL '��Ӧ��'.
DEF VAR bc_po_vend1 AS CHAR FORMAT "x(8)" LABEL "��".
DEF VAR bc_po_nbr1 AS CHAR FORMAT "x(8)" LABEL "��".
DEF VAR bc_part1 AS CHAR FORMAT 'x(18)' LABEL "��".
DEF VAR bc_rlse_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "������".
DEF VAR bc_date AS DATE LABEL '����'.
DEF VAR bc_date1 AS DATE LABEL '��'.
DEF TEMP-TABLE b_po_chk
    FIELD b_po_g_sess LIKE g_sess
    FIELD b_po_recid AS RECID.
DEF FRAME bc
    
   bc_date AT ROW 1.5 COL 4
    bc_date1 AT ROW 3 COL 5.5
   bc_part AT ROW 4.5 COL 2.5
   /* bc_po_nbr AT ROW 6.5 COL 2.5*/
    bc_part1 AT ROW 6 COL 5.5
  /* bc_pkqty AT ROW 10 COL 4*/
   /* bc_qty_std AT ROW 8 COL 1*/
  
   
  /* bc_date1 AT ROW 9.6 COL 5.6*/
    bc_button AT ROW 7.5 COL 10
    
    WITH SIZE 30 BY 10 TITLE "�س�������"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ENABLE bc_date bc_date1 bc_part bc_part1   bc_button WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 bc_date = TODAY .
bc_date1 = TODAY.
 DISP bc_date bc_date1 WITH FRAME bc.
VIEW c-win.

ON VALUE-CHANGED OF bc_date
DO:
   ASSIGN bc_date NO-ERROR.

END.

ON enter OF bc_date
DO:
    ASSIGN bc_date NO-ERROR.
    APPLY 'entry':u TO bc_date1.
END.
ON VALUE-CHANGED OF bc_date1
DO:
   ASSIGN bc_date1 NO-ERROR.

END.
ON enter OF bc_date1
DO:
    ASSIGN bc_date1 NO-ERROR.
    APPLY 'entry':u TO bc_part.
END.
/*ENABLE bc_part  WITH FRAME bc IN WINDOW c-win.*/
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 

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
ON VALUE-CHANGED OF bc_part
DO:
 bc_part = bc_part:SCREEN-VALUE.
END.
ON enter OF bc_part
DO:
    
   
    
   /* IF LASTKEY = KEYCODE("cursor-up") THEN DO:
       
    END.*/
    /*IF LASTKEY = KEYCODE("return") THEN DO:*/
    bc_part = bc_part:SCREEN-VALUE.
  /*  DISABLE bc_part WITH FRAME bc.
    ENABLE bc_part1 WITH FRAME bc.*/
    APPLY 'entry':u TO bc_part1.
         
     
      /*bc_lot = bcprefix.
      DISP bc_lot WITH FRAME bc.  
      ENABLE bc_lot WITH FRAME bc.*/
       /* END.*/
   
END.



ON CURSOR-DOWN OF bc_part1
DO:
    
       ASSIGN bc_part1.
       FIND FIRST pt_mstr NO-LOCK WHERE pt_part > bc_part1 NO-ERROR.
       IF AVAILABLE pt_mstr THEN DO:
           ASSIGN bc_part1 = pt_part.
           DISPLAY bc_part1 WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_part1
DO:
   
       ASSIGN bc_part1.
       FIND LAST pt_mstr NO-LOCK WHERE pt_part < bc_part1 NO-ERROR.
       IF AVAILABLE pt_mstr THEN DO:
           ASSIGN bc_part1 = pt_part.
           DISPLAY bc_part1 WITH FRAME bc.
       END.
   
END.
ON VALUE-CHANGED OF bc_part1
DO:
 bc_part1 = bc_part1:SCREEN-VALUE.
END.
ON enter OF bc_part1
DO:
    
   
    
   /* IF LASTKEY = KEYCODE("cursor-up") THEN DO:
       
    END.*/
    /*IF LASTKEY = KEYCODE("return") THEN DO:*/
    bc_part1 = bc_part1:SCREEN-VALUE.
    /*DISABLE bc_part1 WITH FRAME bc.*/
    
  /*  ENABLE bc_date WITH FRAME bc.*/
    APPLY 'entry':u TO bc_date.
         
     
      /*bc_lot = bcprefix.
      DISP bc_lot WITH FRAME bc.  
      ENABLE bc_lot WITH FRAME bc.*/
       /* END.*/
   
END.




ON 'choose':U OF bc_button
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
      DEF VAR b_id LIKE b_co_code.
      DEF VAR m_fmt LIKE b_co_format.
     DEF VAR bc_qty_mult AS DECIMAL.
      DEF VAR i AS INT.
      DEF VAR bcprefix AS CHAR.
      DEF VAR bc_qty_label AS INT.
      DEF VAR bc_qty AS DECIMAL.
     IF bc_date = ? THEN bc_date = low_date.
     IF bc_date1 = ? THEN bc_date1 = hi_date.
      IF bc_part1 = '' THEN bc_part1 = hi_char.
     /* IF bc_date = ? THEN bc_date = low_date.
      IF bc_date1 = ? THEN bc_date1 = hi_date.*/
       FOR EACH tr_hist USE-INDEX tr_date_trn WHERE tr_date >= bc_date AND tr_date <= bc_date1 AND tr_type = 'iss-wo'   AND 
           tr_part >= bc_part AND tr_part <= bc_part1  NO-LOCK:
             
          FIND FIRST b_tr_hist USE-INDEX b_tr_qadid WHERE b_tr_trnbr_qad = tr_trnbr NO-LOCK NO-ERROR.
          
          IF NOT AVAILABLE b_tr_hist THEN DO:
         
                   {bctrcr.i
         &ord=tr_nbr
         &mline=?
         &b_code=?
         &b_part=tr_part
         &b_lot=?
         &id=tr_lot
         &b_qty_req=0
         &b_qty_loc=tr_qty_loc
         &b_qty_chg=tr_qty_chg
         &b_qty_short=0
         &b_um=tr_um
         &mdate1=tr_date
          &mdate2=tr_date
          &mdate_eff=tr_date
           &b_typ='"iss-wo"'
          &mtime=tr_time
           &b_loc=tr_loc
           &b_site=tr_site
           &b_usrid=g_user
           &b_addr=?}
 
           b_tr_trnbr_qad =  IF AVAILABLE tr_hist THEN tr_trnbr ELSE 0.
          END.
       END.
       MESSAGE '�س������ѵ��� ��' VIEW-AS ALERT-BOX.
END.
{bctrail.i}