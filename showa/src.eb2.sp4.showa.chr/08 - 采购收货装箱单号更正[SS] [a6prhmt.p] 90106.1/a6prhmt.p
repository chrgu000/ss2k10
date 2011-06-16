/* a6prhmt.p - 装箱单号更新                      */
/* SS - 20081216.1 By: Micho Yang */

/* SS - 20081216.1 - B */
/*
按用户输入的条件，修改装箱单号(prh_ps_nbr),
同时保留原始的prh_ps_nbr 到prh__chr09
*/
/* SS - 20081216.1 - E */

{mfdtitle.i "090106.1"}

DEF VAR receiver LIKE prh_receiver .
DEF VAR rcp_date LIKE prh_rcp_date.
DEF VAR rcp_date1 LIKE prh_rcp_date.
DEF VAR v_nbr LIKE prh_nbr .
DEF VAR v_prh_ps_nbr LIKE prh_ps_nbr .
DEF VAR v_receiver LIKE prh_receiver .
DEF VAR v_ps_nbr LIKE prh_ps_nbr .
DEF VAR v_line LIKE prh_line .

DEF BUFFER prhhist FOR prh_hist.

FORM
   prh_vend  COLON 9  LABEL "供应商"          
   prh_part  COLON 28 LABEL "零件" 
   prh_nbr   COLON 60 LABEL "订单"
   rcp_date  COLON 9  LABEL "收货日期"        
   rcp_date1 COLON 28 LABEL "至"
   v_receiver COLON 9  LABEL "收货单" 
   v_ps_nbr   COLON 28 LABEL "装箱单"
with frame a side-labels width 80.
{&SOSOISM-P-TAG14}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

FORM
with frame b title color normal "收货明细数据" 6 down width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).


form                       
   receiver        COLON 15
   prh_line        FORMAT ">>9" 
   prh_rcp_date    COLON 55
   prh_rcvd        COLON 15 
   prhhist.prh__chr10      COLON 55 FORMAT "x(20)" LABEL "装箱单(Bakcup)"
   prhhist.prh_ps_nbr      COLON 15  LABEL "装箱单"
with frame c SIDE-LABELS ATTR-SPACE WIDTH 80 .

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).


/* mainloop */
mainloop:
REPEAT :
   receiver = "".
   v_line = 0.
   VIEW FRAME a .
   VIEW FRAME b .
   VIEW FRAME c .

   rcp_date1 = TODAY .
   DISP rcp_date1 WITH FRAME a .

   PROMPT-FOR   
      prh_vend prh_part prh_nbr
      rcp_date rcp_date1
      v_receiver v_ps_nbr
      WITH FRAME a.

   IF INPUT prh_vend = "" THEN DO:
      MESSAGE "错误: 供应商不允许为空,请重新输入" .
      NEXT-PROMPT prh_vend WITH FRAME a .
      UNDO,RETRY.
   END.
   IF INPUT prh_part = "" THEN DO:
      MESSAGE "错误: 零件号不允许为空,请重新输入" .
      NEXT-PROMPT prh_part WITH FRAME a .
      UNDO,RETRY.
   END.
   IF INPUT prh_nbr = "" THEN DO:
      MESSAGE "错误: 采购单不允许为空,请重新输入" .
      NEXT-PROMPT prh_nbr WITH FRAME a .
      UNDO,RETRY.
   END.

   IF INPUT rcp_date = ? THEN rcp_date = low_date .
   IF INPUT rcp_date1 = ? THEN rcp_date = hi_date .

   ASSIGN
      v_nbr = INPUT prh_nbr 
      rcp_date 
      rcp_date1
      .

   clear frame b all no-pause.
   clear frame c all no-pause.

   /* detail data */
   FOR EACH prh_hist 
      WHERE prh_vend = INPUT prh_vend
      AND prh_part = INPUT prh_part
      AND (prh_rcp_date >= rcp_date AND 
           prh_rcp_date <= rcp_date1 ) 
      AND prh_nbr = INPUT prh_nbr 
      AND (prh_receiver = INPUT v_receiver OR INPUT v_receiver = "")
      AND (prh_ps_nbr = INPUT v_ps_nbr OR INPUT v_ps_nbr = "")
      USE-INDEX prh_vend 
      BREAK BY prh_receiver BY prh_line BY prh_rcp_date BY prh_ps_nbr :

      DISP 
         prh_receiver
         prh_line
         prh_rcp_date
         prh_rcvd
         prh_ps_nbr
         prh__chr10 FORMAT "x(20)" LABEL "装箱单号(Bakcup)"
         WITH FRAME b .

      IF FRAME-LINE(b) = FRAME-DOWN(b) THEN LEAVE.
      DOWN 1 WITH FRAME b .
   END. /* FOR EACH prh_hist */

   /*
   MESSAGE "b. " +
         INPUT prh_vend + " " + INPUT prh_part + " " + INPUT prh_nbr + " " + 
         INPUT v_receiver + " " + 
         INPUT v_ps_nbr VIEW-AS ALERT-BOX.
     */

   DO ON ERROR UNDO,RETRY :
      UPDATE 
         receiver
         WITH FRAME c WIDTH 80 EDITING:
         IF FRAME-FIELD = "receiver" THEN DO:

            /* FIND NEXT/PREVIOUS RECORD */
            {a6mfnp01a6prhmt.i
               prh_hist
               receiver
               prh_receiver
               v_nbr
               prh_nbr
               prh_nbr }

            IF recno <> ? THEN DO:
                  receiver = prh_receiver .
                  v_line = prh_line .

               DISP 
                  receiver
                  prh_line 
                  prh_rcp_date
                  prh_rcvd
                  prh_ps_nbr @ prhhist.prh_ps_nbr
                  prh__chr10 @ prhhist.prh__chr10 
                  WITH FRAME c .
                  
            END.
         END.
         ELSE DO:
            STATUS INPUT.
            READKEY.
            APPLY LASTKEY.
         END.
      END.
      STATUS INPUT .

      FOR FIRST prhhist WHERE prhhist.prh_nbr = INPUT prh_hist.prh_nbr
         AND prhhist.prh_receiver = receiver 
         AND prhhist.prh_line = v_line :
      END.
      IF NOT AVAIL prhhist THEN DO:
         MESSAGE "错误: 收货单和项次不匹配,请重新输入" .
         UNDO,RETRY.
      END.

      v_prh_ps_nbr = prhhist.prh_ps_nbr .

      SET 
         prhhist.prh_ps_nbr  
         WITH FRAME c .

      IF prhhist.prh__chr10 = "" THEN prhhist.prh__chr10 = v_prh_ps_nbr .

      DISP 
         prhhist.prh_ps_nbr
         prhhist.prh__chr10 
         WITH FRAME c .

   END. /* DO ON ERROR UNDO,RETRY: */

END. /* mainloop */
