/* xxinpt01.p - ������ͨ�ô��뵼��                      */
/*----rev history-------------------------------------------------------------------------------------*/
/* Revision: eb2sp4	BY: Micho Yang         DATE: 08/05/08  ECO: *SS - 20080805.1* */
/* SS - 100906.1  By: Roger Xiao */  /*��cp_mstr,Ҫ������Ŀͻ���*/
/*-Revision end---------------------------------------------------------------*/

/* SS - 20080805.1 - B */
/* 
1. ��Ҫ���ڵ������۲��Ŷ�������������
2. ÿ�����µ���ʱ����ɾ��ϵͳ�Ѿ����ڵļ�¼��
   Ȼ���ٵ��뵽code_mstr 
   code_fldname = "xxdtbrp1.p"
   code_value = ��1������                                                                          
   code_cmmt = ��2������
   */
/* SS - 20080805.1 - E */

/* DISPLAY TITLE */
{mfdtitle.i "100906.1"}

DEF VAR effdate   LIKE tr_effdate .
DEF VAR effdate1  LIKE tr_effdate .
DEF VAR v_site    AS CHAR INIT "1" .
DEF VAR tot_qty AS INT.
DEF VAR tot_car AS INT.
DEF VAR tot_pcs AS INT.
DEF VAR v_qty AS INT.
DEF VAR jz AS CHAR.
DEF VAR pkg AS INT.
DEF VAR cust AS CHAR.
DEF VAR cust1 AS CHAR.
DEF VAR bb AS CHAR.
DEF VAR v_pcs AS INT.
DEF VAR v_disptitle AS CHAR.
DEF VAR v_dispdate AS CHAR.
DEF VAR v_cmmt AS CHAR.
DEF VAR v_promo AS CHAR.
DEF VAR v_promo1 AS CHAR.
DEF VAR v_flag AS LOGICAL .
DEF VAR v_by AS CHAR.

DEF TEMP-TABLE tsod
    FIELD tsod_part label "ͼ��" LIKE pt_part
    FIELD tsod_date1 AS DATE LABEL "����"
    FIELD tsod_time1 AS CHAR LABEL "ʱ��"
    FIELD tsod_date AS DATE LABEL "��Ʊ����"
    FIELD tsod_time AS CHAR LABEL "��Ʊʱ��"
    FIELD tsod_qty LIKE ld_qty_oh  label "����"
    FIELD tsod_cust AS CHAR  label "�ͻ�"
    FIELD tsod_pkg  LIKE ld_qty_oh label "��װ"
    FIELD tsod_jz  AS CHAR LABEL "����"
    FIELD tsod_inv  AS CHAR label "��Ʊ"
    FIELD tsod_buyer LIKE pt_buyer label "����"
    FIELD tsod_memo AS CHAR FORMAT 'x(30)' LABEL "��ע"
    INDEX INDEX1 tsod_date1 
    .

DEF BUFFER tsod1 FOR tsod.
DEF BUFFER tsod2 FOR tsod.
DEF BUFFER tsod3 FOR tsod.

DEF TEMP-TABLE tt
   FIELD tt_by AS CHAR
   FIELD tt_value LIKE CODE_value
   FIELD tt_cmmt LIKE CODE_cmmt
   .

FORM 
   effdate     COLON 15    effdate1    LABEL {t001.i}    COLON 49 
   v_promo     COLON 15 LABEL "������(����)"   v_promo1    LABEL {t001.i}    COLON 49
   SKIP(1)
   v_site      COLON 15    LABEL "�ͻ�����"   FORMAT "x(1)"
               "[1] (4H0001:�㱾һ��/4H0003:����һ��)" COLON 20
               "[2] (4H1001:�㱾����/4H1003:��������)" COLON 20
               "[3] (4H0004:�б�)"                     COLON 20

   SKIP(1)
with frame a side-labels attr-space width 80 .

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


/* REPORT BLOCK */
{wbrp01.i}

mainloop:
REPEAT:
   IF effdate = low_date THEN effdate = ? .
   IF effdate1 = hi_date THEN effdate1 = ?.
   IF v_promo1 = hi_char THEN v_promo1 = "".
   
   if c-application-mode <> 'web' then
   update
      effdate effdate1 v_promo v_promo1 v_site
      with frame a.

   {wbrp06.i &command = update &fields = " 
         effdate effdate1 v_promo v_promo1 v_site 
    " &frm = "a"}

   if (c-application-mode <> 'web') or
   (c-application-mode = 'web' and
   (c-web-request begins 'data')) then do:
        /* CREATE BATCH INPUT STRING */
        assign bcdparm = "".
        {mfquoter.i effdate      }
        {mfquoter.i effdate1      }
        {mfquoter.i v_promo       }
        {mfquoter.i v_promo1       }
        {mfquoter.i v_site       }                 

        IF effdate = ?     THEN ASSIGN effdate = low_date .
        IF effdate1 = ?    THEN ASSIGN effdate1 = hi_date .
        IF v_promo1 = ""    THEN v_promo1 = hi_char.
   end.  /* if (c-application-mode <> 'web') ... */

   IF NOT (v_site = "1" OR v_site = "2" OR v_site = "3") THEN DO:
       MESSAGE "����: ������Ч,��������ȷ�ĳ���" .
       NEXT-PROMPT v_site WITH FRAME a .
       UNDO,RETRY.
   END.               

   /* SELECT PRINTER */
   {mfselbpr.i "printer" 132}
      
   /* main programmer */
   CASE v_site :
       WHEN "1" THEN DO:
            cust = "4h0001".
            cust1 = "4h0003".
       END.
       WHEN "2" THEN DO:
            cust = "4h1001".
            cust1 = "4h1003".
       END.
       OTHERWISE DO:
            cust = "4h0004".
            cust1 = "4H0004".
       END.
   END CASE.

   /*����Ϊ�ַ��ͣ�Ҫ����yyyy-mm-dd��yyyy-m-d��ʽ */
   /* xxsod_due_date1 �޸ĺ�����                  */
   /* xxsod_due_time1 �޸ĺ�ʱ��                  */
   EMPTY TEMP-TABLE tsod .
   FOR EACH xxsod_det NO-LOCK
      WHERE (upper(xxsod_cust) = UPPER(cust) OR upper(xxsod_cust) = UPPER(cust1))
      AND date(int(entry(2,xxsod_due_date1,"-")) ,int(entry(3,xxsod_due_date1,"-")),int(entry(1,xxsod_due_date1,"-")))  >= effdate
      AND date(int(entry(2,xxsod_due_date1,"-")) ,int(entry(3,xxsod_due_date1,"-")),int(entry(1,xxsod_due_date1,"-")))  <= effdate1
      USE-INDEX cust_invnbr: 

/* SS - 100906.1 - B 
      FIND FIRST cp_mstr WHERE cp_cust_part = xxsod_part NO-LOCK NO-ERROR.
   SS - 100906.1 - E */
/* SS - 100906.1 - B */
      find first cp_mstr 
          where cp_cust_part = xxsod_part
          and  (cp_cust = cust or cp_cust = cust1 )
      no-lock no-error.
/* SS - 100906.1 - E */
      IF AVAIL cp_mstr THEN DO:
         FIND FIRST pt_mstr WHERE pt_part = cp_part NO-LOCK NO-ERROR.
         IF AVAIL pt_mstr THEN DO:
            IF pt_promo <> "" THEN jz = pt_promo .
            ELSE jz = "SP" .

            IF pt_ord_mult <> 0 THEN pkg = pt_ord_mult.
            ELSE pkg = 1.

            IF pt_buyer <> "" THEN bb = pt_buyer .
            ELSE bb = "XX".
         END.
         ELSE DO:
            jz = "SP".
            pkg = 1 .
            bb = "XX".
         END.
      END. /* IF AVAIL cp_mstr THEN DO: */
      ELSE DO:
         jz = "SP".
         pkg = 1.
         bb = "XX".
      END.

      IF jz >= v_promo AND jz <= v_promo1 THEN DO:
         CREATE tsod.
         ASSIGN
            tsod_cust = UPPER(xxsod_cust)
            tsod_date = DATE(xxsod_due_date)
            tsod_date1 = DATE(xxsod_due_date1)
            tsod_time = xxsod_due_time
            tsod_time1 = xxsod_due_time1
            tsod_part = xxsod_part
            tsod_qty = int(xxsod_qty)
            tsod_inv = xxsod_invnbr
            tsod_jz = jz
            tsod_pkg = pkg
            tsod_buyer = UPPER(bb).
            tsod_memo = xxsod_rmks1.
      END.

   END. /* FOR EACH xxsod_det NO-LOCK */
  
   EMPTY TEMP-TABLE tt .
   v_flag = NO .
   FOR EACH tsod BREAK BY tsod_cust BY tsod_jz :

      ACCUMULATE tsod_qty (TOTAL BY tsod_cust BY tsod_jz) .

      IF LAST-OF(tsod_jz) AND ((ACCUMULATE TOTAL BY tsod_jz tsod_qty) <> 0) THEN DO:
         v_by = "" .
         FIND FIRST CODE_mstr WHERE CODE_fldname = "pt_promo" 
            AND CODE_value = tsod_jz NO-LOCK NO-ERROR.
         IF AVAIL CODE_mstr THEN DO: 
            v_cmmt = CODE_cmmt.
            v_by = CODE_user1.
         END.
         ELSE DO: 
            v_cmmt = tsod_jz .
            v_by = "".
         END.

         v_flag = YES .
         CREATE tt.
         ASSIGN
            tt_by = v_by 
            tt_value = tsod_jz
            tt_cmmt = v_cmmt.
      END.
   END.

   /* ��ʾ��ͷ��Ϣ */
   IF v_site = "1" OR v_site = "2" THEN do:
      v_disptitle = "�ͻ���̬�����(�㱾/����)" .
      IF substring(cust,3,1) = "0" THEN v_disptitle = v_disptitle + "1��".
      ELSE v_disptitle = v_disptitle + "2��".
   END.
   ELSE v_disptitle = "�ͻ���̬�����(�б�)" .

   v_dispdate = "��ӡ����: " + STRING(YEAR(TODAY),"9999") + "-" + STRING(MONTH(TODAY),"99") + "-" + STRING(DAY(TODAY),"99") 
                  + " " + STRING(TIME,"HH:MM:SS") .

   PUT UNFORMATTED "#def REPORTPATH=$/����/�ͻ���̬�����/xxdtbrp1" SKIP.
   PUT UNFORMATTED "#def :end" SKIP.

   IF v_flag = YES THEN DO:
      PUT UNFORMATTED 
         v_disptitle ";"
         v_dispdate ";"
         "ʱ��" ";"
         "��Ʊ����" ";"
         "����" ";"
         "̨���ܼ�" ";"
         "�޸İ汾" ";"
         .  
   END.

   FOR EACH tt BY tt_by BY tt_value :
      PUT UNFORMATTED tt_cmmt ";" .
   END.
   IF v_flag = YES THEN DO:
      PUT UNFORMATTED 
         "��Ʊ�ϼ�" ";"
         "QCȷ��"
         SKIP.
   END.

   /* ��ʾ���� */
   v_pcs = 0.
   FOR EACH tsod BREAK BY tsod_date1 BY tsod_time1 BY tsod_date BY tsod_time BY tsod_memo :

      IF FIRST-OF(tsod_date1) THEN DO:
         tot_qty = 0.
         tot_car = 0.
         tot_pcs = 0.
         FOR EACH tsod1 WHERE tsod1.tsod_date1 = tsod.tsod_date1:
            tot_qty = tot_qty + tsod1.tsod_qty .
            tot_car = tot_car + INT(tsod1.tsod_qty / tsod_pkg + 0.9999).
            tot_pcs = tot_pcs + 1.
         END.

         PUT UNFORMATTED 
            v_disptitle ";"
            v_dispdate ";"
            STRING(MONTH(tsod_date1),"99") + "-" + STRING(DAY(tsod_date1),"99") ";"
            "�պϼ�" ";"
            .

         IF tot_qty <> 0 THEN DO:
         	put unformatted 
               " " + string(tot_qty) ";"
               .
         END.
         else put unformatted "" ";" .

         IF tot_car <> 0 THEN DO:
            put unformatted 
               " " + string(tot_car) ";".         	
         END.
         else put unformatted "" ";" .
         put unformatted 
            "" ";"
            .

         /* ��ʾͨ�ô�����ά���ı�ͷ */
         FOR EACH tt BY tt_by BY tt_value :
            v_qty = 0.
            FOR EACH tsod2 WHERE tsod2.tsod_date1 = tsod.tsod_date1 
               AND tsod2.tsod_jz = tt_value :
               v_qty = v_qty + tsod2.tsod_qty .
            END.             
            IF v_qty <> 0 THEN DO:
            	PUT UNFORMATTED " " + string(v_qty) ";".
            END.
            else put unformatted "" ";" .
            
         END.

         IF tot_pcs <> 0 THEN DO:
            PUT UNFORMATTED " " + string(tot_pcs) ";" .            
         END.
         else put unformatted "" ";" .
         
         put unformatted "" SKIP.
      END. /* IF FIRST-OF(tsod_date1) THEN DO: */

      ACCUMULATE tsod_qty (TOTAL BY tsod_date1 BY tsod_time1 BY tsod_date BY tsod_time BY tsod_memo) .
      ACCUMULATE INT(tsod_qty / tsod_pkg + 0.9999) (TOTAL BY tsod_date1 BY tsod_time1 BY tsod_date BY tsod_time BY tsod_memo) .
      v_pcs = v_pcs + 1.

      IF LAST-OF(tsod_memo) THEN DO:
         PUT UNFORMATTED 
            v_disptitle ";"
            v_dispdate ";"
            tsod_time1 ";"
            STRING(MONTH(tsod_date),"99") + "-" + STRING(DAY(tsod_date),"99") + " " + tsod_time ";"
            .

         IF (ACCUMULATE TOTAL BY tsod_memo tsod_qty) <> 0 THEN DO:
         	put unformatted " " + STRING(ACCUMULATE TOTAL BY tsod_memo tsod_qty) ";".
         END.
         else put unformatted "" ";" .
            
         IF (ACCUMULATE TOTAL BY tsod_memo INT(tsod_qty / tsod_pkg + 0.9999) ) <> 0 THEN DO:
         	put unformatted " " + STRING(ACCUMULATE TOTAL BY tsod_memo INT(tsod_qty / tsod_pkg + 0.9999) ) ";".
         END.
         else put unformatted "" ";" .
               
         put unformatted tsod_memo ";".

         FOR EACH tt BY tt_by BY tt_value :
            v_qty = 0.
            FOR EACH tsod3 WHERE tsod3.tsod_date1 = tsod.tsod_date1
               AND tsod3.tsod_time1 = tsod.tsod_time1
               AND tsod3.tsod_date = tsod.tsod_date
               AND tsod3.tsod_time = tsod.tsod_time
               AND tsod3.tsod_memo = tsod.tsod_memo 
               AND tsod3.tsod_jz = tt_value :
               v_qty = v_qty + tsod3.tsod_qty .
            END.
            IF v_qty <> 0 THEN DO:
               PUT UNFORMATTED " " + string(v_qty) ";" .	
            END.
            else put unformatted "" ";" .            
         END.

         IF v_pcs <> 0 THEN DO:
            PUT UNFORMATTED " " + string(v_pcs) ";" .	
         END.
         else put unformatted "" ";" .
         
         put unformatted "" SKIP.

         v_pcs = 0.
      END. /* IF LAST-OF(tsod_memo) THEN DO: */

      IF LAST-OF(tsod_date1) THEN DO:
         PUT UNFORMATTED 
            v_disptitle ";"
            v_dispdate ";"
            "" ";"
            "" ";"
            "" ";" 
            "" ";"
            "" ";"
            .

            FOR EACH tt BY tt_by BY tt_value :
               PUT UNFORMATTED "" ";" .
            END.

            PUT UNFORMATTED 
               "" ";"
               ""
               SKIP.
      END.
   END. /* FOR EACH tsod BREAK BY tsod_date1 : */

    {a6mfrtrail.i}
end. /* mainloop: */

{wbrp04.i &frame-spec = a}
