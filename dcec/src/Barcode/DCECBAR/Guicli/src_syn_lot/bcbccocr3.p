{mfdeclre.i}
{bcdeclre.i  }
{bcwin02.i}
    {bctitle.i}
DEF VAR bc_id AS CHAR FORMAT "x(18)" LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(20)" LABEL "零件描述".
DEF VAR bc_part_desc2 AS CHAR FORMAT "x(20)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9" LABEL "数量".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9" LABEL "数量".*/
DEF VAR bc_qty_std AS DECIMAL FORMAT "->>,>>>,>>9" LABEL "标准数量".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEF VAR bc_split_qty AS DECIMAL FORMAT "->>,>>>,>>9" LABEL "拆分数量".
DEF VAR bcprefix AS CHAR.
DEF VAR bc_po_nbr AS CHAR FORMAT "x(8)" LABEL "排程单".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
DEF VAR oktocomt AS LOGICAL.
DEF VAR bc_split_id LIKE bc_id.
DEF VAR bc_site AS CHAR.
DEF VAR bc_loc AS CHAR.
DEF VAR bc_qty_label AS  DECIMAL FORMAT "->>,>>>,>>9" LABEL "张数".
DEF VAR ismodi AS LOGICAL.

DEF VAR bc_rlse_qty AS DECIMAL FORMAT "->>,>>>,>>9" LABEL "需求量".
DEF FRAME bc
    bc_po_nbr AT ROW 1.2 COL 2.5
    bc_id AT ROW 2.4 COL 4
    bc_part AT ROW 3.6 COL 2.5
   
    bc_part_desc1  AT ROW 4.8 COL 1
    bc_part_desc2  NO-LABEL AT ROW 5.8 COL 8.8

   bc_lot AT ROW 7 COL 1.6
   /* bc_po_nbr AT ROW 6.5 COL 2.5*/
    bc_rlse_qty AT ROW 8.2 COL 2.5
  /* bc_pkqty AT ROW 10 COL 4*/
   /* bc_qty_std AT ROW 8 COL 1*/
  
   bc_qty AT ROW 9.4 COL 4
    
    WITH SIZE 30 BY 12 TITLE "条码生成-排程单"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.
ismodi = NO.
ENABLE bc_po_nbr  WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 
VIEW c-win.

ON CURSOR-DOWN OF bc_po_nbr
DO:
    
       ASSIGN bc_po_nbr.
       FIND FIRST scx_ref NO-LOCK WHERE scx_type = 2 AND scx_order > bc_po_nbr NO-ERROR.
       IF AVAILABLE scx_ref THEN DO:
           ASSIGN bc_po_nbr = scx_order.
           DISPLAY bc_po_nbr WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_po_nbr
DO:
   
       ASSIGN bc_po_nbr.
       FIND LAST scx_ref NO-LOCK WHERE scx_type = 2 AND scx_order < bc_po_nbr NO-ERROR.
       IF AVAILABLE scx_ref THEN DO:
           ASSIGN bc_po_nbr = scx_order.
           DISPLAY bc_po_nbr WITH FRAME bc.
       END.
   
END.
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
       ENABLE bc_part WITH FRAME bc.
 
   END.
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

ON enter OF bc_part
DO:
    
   
    
   /* IF LASTKEY = KEYCODE("cursor-up") THEN DO:
       
    END.*/
    /*IF LASTKEY = KEYCODE("return") THEN DO:*/
    bc_part = bc_part:SCREEN-VALUE.
    {bcrun.i ""bcmgcheck.p"" "(input ""part_rlse"",
        input """",
        input """", 
        input bc_part, 
        input """",
         input """", 
        input """", 
        input """",
         input bc_po_nbr, 
        input """",
         input """",
        INPUT """",
        INPUT """",
        output success)"}
        IF NOT success THEN
            UNDO,RETRY.
        ELSE DO: DISABLE bc_part WITH FRAME bc.
        FIND FIRST pt_mstr WHERE pt_part = bc_part NO-LOCK NO-ERROR.
        IF AVAILABLE pt_mstr THEN 
            ASSIGN bc_part_desc1 = pt_desc1
        bc_part_desc2 = pt_desc2.
        bc_rlse_qty = qty.
         bc_qty = IF pt_ord_mult <> 0 THEN pt_ord_mult ELSE 1. 
        DISABLE bc_part WITH FRAME bc.
        DISP bc_part_desc1 bc_part_desc2 bc_rlse_qty bc_qty WITH FRAME bc. 
        bcprefix = SUBSTR(string(YEAR(TODAY),'9999'),3,2) + STRING(MONTH(TODAY),'99') + STRING(DAY(TODAY),'99') + STRING(TIME,'999999') + SUBstr(STRING(etime),LENGTH(STRING(etime)) - 1,2).

        bc_id = bcprefix + '001' .
        bc_lot = bc_id.
        DISP bc_id bc_lot WITH FRAME bc.
        ENABLE bc_lot WITH FRAME bc.
        END.
         
     
      /*bc_lot = bcprefix.
      DISP bc_lot WITH FRAME bc.  
      ENABLE bc_lot WITH FRAME bc.*/
       /* END.*/
   
END.



ON enter OF bc_lot
DO:
    bc_lot = bc_lot:SCREEN-VALUE.
    IF bc_lot = '' THEN DO:
        MESSAGE '批/序号不能为空！' VIEW-AS ALERT-BOX error.
        UNDO,RETRY.    
        END.
        ELSE DO:
       
       IF bc_lot <> bc_id THEN ismodi = YES.
         
    DISABLE bc_lot WITH FRAME bc.
        ENABLE bc_qty WITH FRAME bc.
            END.
END.

/*ON enter OF bc_po_nbr
DO:
    bc_po_nbr = bc_po_nbr:SCREEN-VALUE.
    
       DISABLE bc_po_nbr WITH FRAME bc.
        ENABLE bc_qty WITH FRAME bc.
       
END.*/

ON enter OF bc_qty
DO:
    bc_qty = DECIMAL(bc_qty:SCREEN-VALUE).
      
      IF bc_qty = ? OR bc_qty = 0 THEN DO:
        MESSAGE '数量不能为空，或零！' VIEW-AS ALERT-BOX error.
        UNDO,RETRY.    
        END.
        
        ELSE DO:
       
       DISABLE bc_qty WITH FRAME bc.
        /*ENABLE bc_qty_std WITH FRAME bc.*/
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
       DEF VAR mdesc AS CHAR FORMAT "x(50)".
      DEF VAR i AS INT.
       DEF VAR prt AS CHAR FORMAT 'x(22)' LABEL '打印机'.
      DEF VAR isfirst AS CHAR.
          DEF VAR isleave AS LOGICAL.
          isfirst = 'first'.
     bc_qty_label = truncate(bc_rlse_qty / bc_qty,0) + 1. 
     FIND FIRST scx_ref WHERE scx_type = 2 AND scx_order = bc_po_nbr NO-LOCK NO-ERROR.
     DO i = 1 TO bc_qty_label:
             
                 
                 b_id = bcprefix + STRING(i,'999').
                   
                       bc_id = b_id.
                    IF NOT ismodi THEN bc_lot =  b_id.
                       DISP bc_id bc_lot WITH FRAME bc.
                       CREATE b_co_mstr.
               ASSIGN 
                   b_co_code = b_id
                   b_co_part = bc_part
                   b_co_lot = bc_lot
                  
                  /* b_co_qty_ini = bc_qty*/
                   b_co_qty_cur = bc_qty
                   /*b_co_qty_std = bc_qty_std*/
                   b_co_um = 'ea'
                   b_co_status = 'ac'
                   /*b_co_format = m_fmt*/
                   b_co_userid = barusr
                   b_co_ord = bc_po_nbr
                   b_co_line = lntyp
                   b_co_vend = scx_shipfrom
                   b_co_due_date = TODAY
                   b_co_qty_req = bc_rlse_qty
                   b_co_desc1 = bc_part_desc1
                   b_co_desc2 = bc_part_desc2.
       mdesc = b_co_desc2 + b_co_desc1.
    
          {bclabel.i ""zpl"" ""part"" "b_co_code" "b_co_part" 
     "b_co_lot" "b_co_ref" "b_co_qty_cur" "b_co_vend" "mdesc" }
    
        END.
               
               
              /* {bcusrhist.i }*/
                   
/*MESSAGE "是否打印？" SKIP(1)
        "继续?"
        VIEW-AS ALERT-BOX
        QUESTION
        BUTTON YES-NO
        UPDATE oktocomt.*/
 /*IF oktocomt THEN DO:*/
/* FIND FIRST b_usr_mstr WHERE b_usr_usrid = g_user NO-LOCK NO-ERROR.*/
    /*IF b_usr_prt_typ <> 'ipl' AND b_usr_prt_typ <> 'zpl' THEN DO:
    MESSAGE '本系统暂不支持除了ipl,zpl类型的条码打印机!' VIEW-AS ALERT-BOX ERROR.

        LEAVE.*/
       /* END.*/
 /*OUTPUT TO VALUE(b_usr_printer).*/

 
     
     
     
     
   
     
    
             
   RELEASE b_co_mstr.
               RELEASE b_po_wkfl.
         ENABLE bc_part WITH FRAME bc.
         APPLY 'entry':u TO bc_part.
               END.


{bctrail.i}
