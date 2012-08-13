{mfdeclre.i}
{bcdeclre.i NEW}
{bcwin05.i}
    {bctitle.i}
DEF VAR bc_id AS CHAR FORMAT "x(18)" LABEL "条码".
DEF VAR bc_part AS CHAR FORMAT "x(18)" LABEL "零件号".
DEF VAR bc_part_desc AS CHAR FORMAT "x(24)" LABEL "零件描述".
DEF VAR bc_part_desc1 AS CHAR FORMAT "x(24)".
DEF VAR bc_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".
/*DEF VAR bc_pkqty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "数量".*/

DEF VAR bc_lot AS CHAR FORMAT "x(18)" LABEL "批/序号".
DEF VAR bc_split_qty AS DECIMAL FORMAT "->>,>>>,>>9.9" LABEL "拆分数量".
DEF TEMP-TABLE bcomstr LIKE b_co_mstr.
DEF VAR bc_pack AS CHAR FORMAT "x(8)" LABEL "包装号".
DEFINE BUTTON bc_button LABEL "确认" SIZE 8 BY 1.50.
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
    /*bc_pack AT ROW 6.5 COL 2.5*/
    bc_qty AT ROW 6.5 COL 4
  /* bc_pkqty AT ROW 10 COL 4*/
   /*bc_split_qty AT ROW 9.5 COL 1.3*/

   
    bc_button AT ROW 8 COL 10
    WITH SIZE 30 BY 10 TITLE "销售标签改制"  SIDE-LABELS  NO-UNDERLINE THREE-D AT COLUMN 1 ROW 1.

ENABLE bc_id  bc_qty WITH FRAME bc IN WINDOW c-win.
/*DISABLE bc_part_desc  bc_part_desc1 WITH FRAME bc .*/
 DISP  
   
   
   bc_lot 
    bc_qty 
   /*bc_split_qty*/
  
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
            INPUT """",
            INPUT """",
        output success)"}
        IF NOT success THEN 
        UNDO,RETRY.
      ELSE DO:
     

          
          
          {bcrun.i ""bcmgcheck.p"" "(input ""bd_exp"",
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
        output success)"} 
          IF NOT success THEN UNDO,RETRY.
             ELSE
               do:
              DISABLE bc_id WITH FRAME bc.
              FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
              IF AVAILABLE b_co_mstr THEN DO:
                 bc_part = b_co_part.
                 IF b_co_lot <> '' THEN  bc_lot = b_co_lot.
                 IF b_co_ser <> 0 THEN bc_lot = string(b_co_ser).
                 bc_pack = b_co_ref.
                  bc_qty = b_co_qty_cur.
                  DISP bc_part bc_lot /*bc_pack*/ bc_qty WITH FRAME bc.
                  END.
             /* ENABLE bc_split_qty WITH FRAME bc.*/
      END.
          END.
END.
/*
ON enter OF bc_split_qty
DO:
    bc_split_qty = decimal(bc_split_qty:SCREEN-VALUE).
    IF bc_split_qty >= bc_qty THEN DO:
        MESSAGE '拆分数量超过或等于原数量' VIEW-AS ALERT-BOX ERROR.
        UNDO,RETRY.
    END.
    ELSE do:
        DISABLE bc_split_qty WITH FRAME bc.
        ENABLE bc_button WITH FRAME bc.
    END.
END.
*/

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
       CASE  LENGTH(bc_id):
      
       WHEN  15 THEN DO:
         FIND LAST b_co_mstr WHERE b_co_code BEGINS bc_id AND LENGTH(b_co_code) = 16  NO-LOCK NO-ERROR.
           IF AVAILABLE b_co_mstr THEN do:
           IF SUBSTR(b_co_code,16,1) = '9' THEN DO:
             FIND LAST b_co_mstr WHERE b_co_code BEGINS bc_id AND LENGTH(b_co_code) = 17  NO-LOCK NO-ERROR.
               IF AVAILABLE b_co_mstr THEN DO:
                 IF SUBSTR(b_co_code,17,1) = '9' THEN DO:
               
                   FIND LAST b_co_mstr WHERE b_co_code BEGINS bc_id AND LENGTH(b_co_code) = 18  NO-LOCK NO-ERROR.
                   IF AVAILABLE b_co_mstr THEN DO:
                      IF SUBSTR(b_co_code,18,1) = '9' THEN DO:
                 
                             MESSAGE "该条码的分解位已用完!" VIEW-AS ALERT-BOX ERROR.
                             LEAVE.
                   END.
                  ELSE DO:  /*18 add*/
                     bc_split_id = string(decimal(b_co_code) + 1,'999999999999999999').
                     
                      END.
                   END.
                 ELSE DO: /*18 create*/
                   
                      bc_split_id = bc_id + '990'.
                     
                     
                     
                     END.
                 END.
              ELSE DO:  /*17 add*/
                bc_split_id = string(decimal(b_co_code) + 1,'99999999999999999').
                    
                    END.
               END.
               ELSE DO: /*17 create*/
                  bc_split_id = bc_id + '90'.
                    END.
           END.
            ELSE DO:  /*16 add*/     
                bc_split_id = string(decimal(b_co_code) + 1,'9999999999999999').
                
                
                END.
           END.
           ELSE  DO:      /*16 create*/
               bc_split_id = bc_id + '0'.
           END.
           
                   
               END. 

               WHEN  16 THEN DO:
               
                   FIND LAST b_co_mstr WHERE b_co_code BEGINS bc_id AND LENGTH(b_co_code) = 17  NO-LOCK NO-ERROR.
               IF AVAILABLE b_co_mstr THEN DO:
                 IF SUBSTR(b_co_code,17,1) = '9' THEN DO:
               
                   FIND LAST b_co_mstr WHERE b_co_code BEGINS bc_id AND LENGTH(b_co_code) = 18  NO-LOCK NO-ERROR.
                   IF AVAILABLE b_co_mstr THEN DO:
                      IF SUBSTR(b_co_code,18,1) = '9' THEN DO:
                 
                             MESSAGE "该条码的分解位已用完!" VIEW-AS ALERT-BOX ERROR.
                             LEAVE.
                   END.
                  ELSE DO:  /*18 add*/
                     bc_split_id = string(decimal(b_co_code) + 1,'999999999999999999').
                     
                      END.
                   END.
                 ELSE DO: /*18 create*/
                   
                      bc_split_id = bc_id + '90'.
                     
                     
                     
                     END.
                 END.
                   
                   
                ELSE DO:  /*17 add*/
                bc_split_id = string(decimal(b_co_code) + 1,'99999999999999999').
                    
                    END.
               END.
               ELSE DO: /*17 create*/
                  bc_split_id = bc_id + '0'.
                    END.
               
                   END.
       
     
      
               
               
                   WHEN  17 THEN DO:
                   FIND LAST b_co_mstr WHERE b_co_code BEGINS bc_id AND LENGTH(b_co_code) = 18  NO-LOCK NO-ERROR.
                   IF AVAILABLE b_co_mstr THEN DO:
                      IF SUBSTR(b_co_code,18,1) = '9' THEN DO:
                 
                             MESSAGE "该条码的分解位已用完!" VIEW-AS ALERT-BOX ERROR.
                             LEAVE.
                   END.
                  ELSE DO:  /*18 add*/
                     bc_split_id = string(decimal(b_co_code) + 1,'999999999999999999').
                     
                      END.
                   END.
                 ELSE DO: /*18 create*/
                   
                      bc_split_id = bc_id + '0'.
                     
                     
                     
                     END.
                       
                       
                       
                       
                       END.
               
               END CASE.

 FIND FIRST b_co_mstr WHERE b_co_mstr.b_co_code = bc_id  EXCLUSIVE-LOCK NO-ERROR.
                    b_co_mstr.b_co_qty_cur = b_co_mstr.b_co_qty_cur - bc_split_qty.
              CREATE bcomstr.
              BUFFER-COPY 
                  b_co_mstr TO
                  bcomstr.
                   CREATE b_co_mstr.
                   BUFFER-COPY
                       bcomstr 
                       EXCEPT bcomstr.b_co_code bcomstr.b_co_qty_cur
                       TO
                        b_co_mstr
                       
                   ASSIGN
                   b_co_mstr.b_co_code = bc_split_id
                   b_co_mstr.b_co_qty_cur = bc_split_qty.
                  

                 FIND FIRST b_ld_det WHERE b_ld_code = bc_id AND b_ld_qty_oh <> 0 EXCLUSIVE-LOCK NO-ERROR.
                 IF AVAILABLE b_ld_det THEN DO:
                
                
                    b_ld_qty_oh = b_ld_qty_oh - bc_split_qty.
                    CREATE b_ld_det.
                   
         b_ld_code = bc_split_id.
         b_ld_loc =  b_ld_loc.
         b_ld_site = b_ld_site.
         b_ld_part = b_co_mstr.b_co_part.
         b_ld_lot = b_co_mstr.b_co_lot.
         /*b_ld_ser = b_co_ser.*/
       /*  b_ld_ref = b_co_ref.*/
       
         b_ld_qty_oh = bc_split_qty.
                 END.
                 
               
                {bcusrhist.i }
                    MESSAGE '分解成功!' VIEW-AS ALERT-BOX INFORMATION.
MESSAGE "是否打印？" SKIP(1)
        "继续?"
        VIEW-AS ALERT-BOX
        QUESTION
        BUTTON YES-NO
        UPDATE oktocomt.
 IF oktocomt THEN DO:
 
    
     FIND FIRST b_usr_mstr WHERE b_usr_usrid = g_user NO-LOCK NO-ERROR.
    IF b_usr_prt_typ <> 'ipl' AND b_usr_prt_typ <> 'zpl' THEN DO:
    MESSAGE '本系统暂不支持除了ipl,zpl类型的条码打印机!' VIEW-AS ALERT-BOX ERROR.

        LEAVE.
        END.
/* OUTPUT TO VALUE(b_usr_printer).*/
  
 {bclabel.i "b_usr_prt_typ" ""part"" "b_co_mstr.b_co_code" "b_co_mstr.b_co_part" 
     "b_co_mstr.b_co_lot" "b_co_mstr.b_co_ref" "b_co_mstr.b_co_qty_cur" }
     

     {bclabel.i "b_usr_prt_typ" ""part"" "bcomstr.b_co_code" "bcomstr.b_co_part" 
     "bcomstr.b_co_lot" "bcomstr.b_co_ref" "bcomstr.b_co_qty_cur" }
     
     
     MESSAGE '打印完毕！' VIEW-AS ALERT-BOX INFORMATION.
     
     
     
     
     END.
      {bcrelease.i}    
     ENABLE bc_id WITH FRAME bc.    
               END.

{bctrail.i}
