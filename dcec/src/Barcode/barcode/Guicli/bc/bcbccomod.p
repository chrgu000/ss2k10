{mfdeclre.i}
{bcdeclre.i}
{bcwin02.i}
     {bctitle.i}
   
DEF VAR bc_id AS CHAR FORMAT "x(18)" LABEL "����".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "�����".
DEF VAR bc_part_desc AS CHAR FORMAT "x(24)" LABEL "�������".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "����".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "����".*/
DEF VAR bc_qty_std AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "��׼����".
DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "��/���".
DEF VAR bc_split_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "�������".
DEF TEMP-TABLE bcomstr LIKE b_co_mstr.
DEF VAR bc_ref AS CHAR FORMAT "x(8)" LABEL "�ο���".
DEFINE BUTTON bc_button LABEL "ȷ��" SIZE 8 BY 1.50.
DEF VAR oktocomt AS LOGICAL.
DEF VAR bc_split_id LIKE bc_id.
DEF VAR bc_site AS CHAR.
DEF VAR bc_loc AS CHAR.
DEF FRAME bc
    bc_id AT ROW 2 COL 4
    bc_part AT ROW 3.5 COL 2.5
   
   /* bc_part_desc  AT ROW 5 COL 1
    bc_part_desc1  NO-LABEL AT ROW 6 COL 8.5*/

   bc_lot AT ROW 5 COL 1.6
    bc_ref AT ROW 6.5 COL 2.5
    bc_qty AT ROW 8 COL 4
  /* bc_pkqty AT ROW 10 COL 4*/
    bc_qty_std AT ROW 9.5 COL 1
  

   
    bc_button AT ROW 11.5 COL 10
    WITH SIZE 30 BY 14 TITLE "�����޸�"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ENABLE bc_id  WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 DISP  
   
   
  
    bc_qty 
   bc_qty_std
  
    WITH FRAME bc .
VIEW c-win.
ON enter OF bc_id
DO:
      bc_id = bc_id:SCREEN-VALUE.
     {bcrun.i ""bcmgcheck.p"" "(input ""bd"",
        input """",
        input """", 
        input """", 
        input """", 
        input """",
         INPUT """", 
        input bc_id, 
        input """",
         input """", 
        input """",
         input """",
         INPUT """",
        output success)"}
        IF NOT success THEN 
        UNDO,RETRY.
       ELSE DO:
           FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
              IF AVAILABLE b_co_mstr THEN DO:
                 bc_part = b_co_part.
                 IF b_co_lot <> '' THEN  bc_lot = b_co_lot.
                 IF b_co_ser <> 0 THEN bc_lot = string(b_co_ser).
                 bc_ref = b_co_ref.
                  bc_qty = b_co_qty_cur.
                  bc_qty_std = b_co_qty_std.
                  DISP bc_part bc_lot bc_qty bc_qty_std  WITH FRAME bc.
              END.
           DISABLE bc_id WITH FRAME bc.
           ENABLE bc_lot WITH FRAME bc.
       END.
END.
/*ON enter OF bc_part
DO:
    bc_part = bc_part:SCREEN-VALUE.
    {bcrun.i ""bcmgcheck.p"" "(input ""part"",
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
         input """",
        output success)"}
        IF NOT success THEN
            UNDO,RETRY.
        ELSE DO: DISABLE bc_part WITH FRAME bc.
        ENABLE bc_lot WITH FRAME bc.
        END.
END.*/



ON enter OF bc_lot
DO:
    bc_lot = bc_lot:SCREEN-VALUE.
   /* IF bc_lot = '' THEN DO:
        MESSAGE '���Ų���Ϊ��!' VIEW-AS ALERT-BOX error.
        UNDO,RETRY.    
        END.
        ELSE DO:
       
      
         END.*/
     DISABLE bc_lot WITH FRAME bc.
        ENABLE bc_ref WITH FRAME bc.
END.

ON enter OF bc_ref
DO:
    bc_ref = bc_ref:SCREEN-VALUE.
    
       DISABLE bc_ref WITH FRAME bc.
        ENABLE bc_qty WITH FRAME bc.
       
END.

ON enter OF bc_qty
DO:
    bc_qty = DECIMAL(bc_qty:SCREEN-VALUE).
      
   IF bc_qty = ? OR bc_qty = 0 THEN DO:
        MESSAGE '��������Ϊ�ջ�0' VIEW-AS ALERT-BOX error.
        UNDO,RETRY.    
        END.
        ELSE DO:
       
       DISABLE bc_qty WITH FRAME bc.
        ENABLE bc_qty_std WITH FRAME bc.
         END.
       
END.
ON enter OF bc_qty_std
DO:
    bc_qty_std = DECIMAL(bc_qty_std:SCREEN-VALUE).
      
   IF bc_qty_std = ? OR bc_qty_std = 0 THEN DO:
        MESSAGE '��������Ϊ�ջ�0' VIEW-AS ALERT-BOX error.
        UNDO,RETRY.    
        END.
        ELSE DO:
        IF bc_qty_std >= bc_qty THEN DO:
        
       DISABLE bc_qty_std WITH FRAME bc.
        ENABLE bc_button WITH FRAME bc.
        END.
        ELSE DO:
MESSAGE '��׼��������С������ǰ/��ʼ������' VIEW-AS ALERT-BOX error.
            
        UNDO,RETRY.   
        END.
         END.
       
END.



ON 'choose':u OF bc_button
DO:
    DISABLE bc_button WITH FRAME bc.
    RUN main.
END.

ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

PROCEDURE main:
      
               FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.  
               ASSIGN 
                  
                   
                   b_co_lot = bc_lot
                   b_co_ref = bc_ref
                   b_co_qty_ini = bc_qty
                   b_co_qty_cur = bc_qty
                   b_co_qty_std = bc_qty_std
                   b_co_um = 'ea'.
                 
                   


               
               {bcusrhist.i }
                    MESSAGE '�������޸�!' VIEW-AS ALERT-BOX INFORMATION.

MESSAGE "�Ƿ��ӡ��" SKIP(1)
        "����?"
        VIEW-AS ALERT-BOX
        QUESTION
        BUTTON YES-NO
        UPDATE oktocomt.
 IF oktocomt THEN DO:
 
    
     FIND FIRST b_usr_mstr WHERE b_usr_usrid = g_user NO-LOCK NO-ERROR.
    IF b_usr_prt_typ <> 'ipl' AND b_usr_prt_typ <> 'zpl' THEN DO:
    MESSAGE '��ϵͳ�ݲ�֧�ֳ���ipl,zpl���͵������ӡ��!' VIEW-AS ALERT-BOX ERROR.

        LEAVE.
        END.
/* OUTPUT TO VALUE(b_usr_printer).*/
  
 {bclabel.i "b_usr_prt_typ" ""part"" "b_co_code" "b_co_part" 
     "b_co_lot" "b_co_ref" "b_co_qty_cur" }
     

     
     
     
     MESSAGE '��ӡ��ϣ�' VIEW-AS ALERT-BOX INFORMATION.
     
     
     
     
     END.
       {bcrelease.i}         
     ENABLE bc_id WITH FRAME bc.   
               END.

{bctrail.i}
