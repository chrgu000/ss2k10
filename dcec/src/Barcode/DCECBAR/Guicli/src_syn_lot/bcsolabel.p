{mfdeclre.i}
{bcdeclre.i  }
{bcwin02.i}
    {bctitle.i}
DEF VAR bc_id AS CHAR FORMAT "x(18)" LABEL "����".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "�����".
DEF VAR bc_part_desc AS CHAR FORMAT "x(24)" LABEL "�������".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9" LABEL "����".
DEF VAR charqty AS CHAR FORMAT "x(1)" .
DEF VAR charpart AS CHAR.
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9" LABEL "����".*/

DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "��/���".
DEF VAR bc_split_qty AS DECIMAL FORMAT "->>,>>>,>>9" LABEL "�������".
DEF TEMP-TABLE bcomstr_so LIKE b_co_mstr
    FIELD bcomstr_so_sess LIKE g_sess
    INDEX bcomstr_so_sess IS PRIMARY bcomstr_so_sess ASC.
DEF TEMP-TABLE bcoprt_so LIKE b_co_mstr
    FIELD bcoprt_so_sess LIKE g_sess
    INDEX bcoprt_so_sess IS PRIMARY bcoprt_so_sess ASC.
DEF VAR bc_pack AS CHAR FORMAT "x(8)" LABEL "��װ��".
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
    bc_pack AT ROW 6.5 COL 2.5
    bc_qty AT ROW 8 COL 4
  /* bc_pkqty AT ROW 10 COL 4*/
   bc_split_qty AT ROW 9.5 COL 1.3

   
   
    WITH SIZE 30 BY 12 TITLE "���۱�ǩ����"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ENABLE bc_id  WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 /*DISP  
   
   
   bc_lot 
    bc_qty 
   bc_split_qty
  
    WITH FRAME bc .*/
VIEW c-win.
ON CURSOR-DOWN OF bc_id
DO:
    
       ASSIGN bc_id.
       FIND FIRST b_co_mstr NO-LOCK WHERE b_co_code > bc_id NO-ERROR.
       IF AVAILABLE b_co_mstr THEN DO:
           ASSIGN bc_id = b_co_code.
           DISPLAY bc_id WITH FRAME bc.
       END.
    
END.

ON CURSOR-UP OF bc_id
DO:
   
        ASSIGN bc_id.
       FIND LAST b_co_mstr NO-LOCK WHERE b_co_code < bc_id NO-ERROR.
       IF AVAILABLE b_co_mstr THEN DO:
           ASSIGN bc_id = b_co_code.
           DISPLAY bc_id WITH FRAME bc.
       END.
   
END.
ON enter OF bc_id
DO:
      bc_id = bc_id:SCREEN-VALUE.
        
        APPLY 'entry':u TO bc_id.
     

          FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
         IF b_co_status <> "rct" THEN do:
             success = NO.
             MESSAGE '��Ч���룡' '�����Ϊ:'  b_co_part  ' ״̬Ϊ: ' b_co_status "  "   VIEW-AS ALERT-BOX ERROR.
         END.
       /* {bcrun.i ""bcmgcheck.p"" "(input ""bd_exp"",
        input """",
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
        output success)"} */
          IF NOT success THEN UNDO,RETRY.
             ELSE
               do:
              DISABLE bc_id WITH FRAME bc.
              
              IF AVAILABLE b_co_mstr THEN DO:
                 bc_part = b_co_part.
                 bc_site = b_co_site.
                 IF b_co_lot <> '' THEN  bc_lot = b_co_lot.
                 IF b_co_ser <> 0 THEN bc_lot = string(b_co_ser).
                 bc_pack = b_co_ref.
                  bc_qty = b_co_qty_cur.
                  DISP bc_part bc_lot bc_pack bc_qty WITH FRAME bc.

                  bc_split_qty = bc_qty.
                  FIND FIRST ptp_det WHERE ptp_part = bc_part AND ptp_site = bc_site  NO-LOCK NO-ERROR.
                  IF AVAILABLE ptp_det AND ptp_ord_mult <> 0 THEN bc_split_qty = ptp_ord_mult.
                  ELSE DO: 
                       FIND FIRST pt_mstr  WHERE pt_part = bc_part NO-LOCK NO-ERROR.
                       IF AVAILABLE pt_mstr AND pt_ord_mult <> 0 THEN bc_split_qty = pt_ord_mult.
                  END.
                  DISPLAY bc_split_qty WITH FRAME bc.
               END.
               ENABLE bc_split_qty WITH FRAME bc. 
        /*      bc_split_qty = b_co_qty_cur.
              FIND FIRST ptp_det WHERE ptp_part = b_co_part AND ptp_site = b_co_site  NO-LOCK NO-ERROR.
              IF AVAILABLE ptp_det AND ptp_ord_mult <> 0 THEN bc_split_qty = ptp_ord_mult.
              ELSE DO: 
                   FIND FIRST pt_mstr  WHERE pt_part = b_co_part NO-LOCK NO-ERROR.
                   IF AVAILABLE pt_mstr AND pt_ord_mult <> 0 THEN bc_split_qty = pt_ord_mult.
              END.
              RUN main.*/
      END.
         
END.
 
ON enter OF bc_split_qty
DO:
    bc_split_qty = decimal(bc_split_qty:SCREEN-VALUE).
    IF bc_split_qty > bc_qty OR bc_split_qty = 0 THEN DO:
        MESSAGE '�����������ԭ����������㣡' VIEW-AS ALERT-BOX.
        UNDO,RETRY.
    END.
    ELSE do:
        DISABLE bc_split_qty WITH FRAME bc.
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
      DEF  VAR bcprefix AS CHAR.
      DEF VAR bcorist LIKE b_co_status.
      DEF VAR bc_qty_label AS INT.
DEF  VAR i AS INT.
DEF VAR j AS INT.
DEF VAR isld AS LOGICAL.
 DEF VAR mdesc AS CHAR FORMAT "x(50)".
 DEF VAR prt AS CHAR FORMAT 'x(22)' LABEL '��ӡ��'.
      DEF VAR isfirst AS CHAR.
          DEF VAR isleave AS LOGICAL.
          isfirst = 'first'.
      bc_qty_label = IF (bc_qty MOD bc_split_qty = 0) THEN (bc_qty / bc_split_qty) ELSE TRUNCATE(bc_qty / bc_split_qty,0) + 1.
 bcprefix = SUBSTR(string(YEAR(TODAY),'9999'),3,2) + STRING(MONTH(TODAY),'99') + STRING(DAY(TODAY),'99') + STRING(TIME,'999999') + SUBstr(STRING(etime),LENGTH(STRING(etime)) - 1,2).
 
 FIND FIRST b_co_mstr WHERE b_co_mstr.b_co_code = bc_id  EXCLUSIVE-LOCK NO-ERROR.
 bcorist = b_co_status.                  
 b_co_status = 'ia'.
              CREATE bcomstr_so.
              BUFFER-COPY 
                  b_co_mstr TO
                  bcomstr_so
                  ASSIGN bcomstr_so_sess = g_sess.
                 FIND FIRST bcomstr_so WHERE bcomstr_so.b_co_code = bc_id AND bcomstr_so_sess = g_sess EXCLUSIVE-LOCK NO-ERROR.
              j = 1.
              DO i = 1 TO bc_qty_label:
              IF j MOD 1000 = 0 THEN do:
                  PAUSE 1.
                   MESSAGE '������1000�ű�ǩ��' VIEW-AS ALERT-BOX.
                  bcprefix = SUBSTR(string(YEAR(TODAY),'9999'),3,2) + STRING(MONTH(TODAY),'99') + STRING(DAY(TODAY),'99') + STRING(TIME,'999999') + SUBstr(STRING(etime),LENGTH(STRING(etime)) - 1,2).
                  j = 1.
                  END.
              CREATE b_co_mstr.
                   BUFFER-COPY
                       bcomstr_so 
                       EXCEPT bcomstr_so.b_co_code bcomstr_so.b_co_qty_cur  bcomstr_so.b_co_status bcomstr_so.b_co_btype bcomstr_so.b_co_userid bcomstr_so_sess 
                       TO
                        b_co_mstr
                       
                   ASSIGN
                   b_co_mstr.b_co_code = bcprefix + STRING(j,'999')
                   b_co_mstr.b_co_qty_cur = IF i < bc_qty_label THEN bc_split_qty ELSE IF bc_qty MOD bc_split_qty = 0 THEN bc_split_qty ELSE bc_qty MOD bc_split_qty
                       b_co_mstr.b_co_status = bcorist
                       b_co_mstr.b_co_btype = 's'
                       b_co_mstr.b_co_userid = barusr.
                  CREATE bcoprt_so.
                  BUFFER-COPY
                      b_co_mstr TO bcoprt_so
                      ASSIGN
                         bcoprt_so_sess = g_sess.
                 
                j = j + 1.
                 
                 

               
                 
               
              END.
    DELETE bcomstr_so.
    FOR EACH bcoprt_so NO-LOCK WHERE bcoprt_so_sess = g_sess:
   mdesc = bcoprt_so.b_co_desc2 + bcoprt_so.b_co_desc1.
  {bclabel.i ""zpl"" ""split"" "bcoprt_so.b_co_code" "bcoprt_so.b_co_part" 
  "bcoprt_so.b_co_lot" "bcoprt_so.b_co_ref" "bcoprt_so.b_co_qty_cur" "bcoprt_so.b_co_vend" "mdesc" }
      
     DELETE bcoprt_so.
    END.
    
     
    
     
     
     
    
      RELEASE b_co_mstr. 
     
     ENABLE bc_id WITH FRAME bc.    
     APPLY 'entry':u TO bc_id.
               END.

{bctrail.i}
