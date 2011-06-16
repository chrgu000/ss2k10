
{mfdtitle.i "b+ "} 


DEF VAR v_type LIKE xxsod_type.
DEF VAR v_cust LIKE xxsod_cust.
DEF VAR v_cust1 LIKE xxsod_cust.
DEF VAR v_project LIKE xxsod_project .
DEF VAR v_project1 LIKE xxsod_project .
DEF VAR v_vend LIKE xxsod_vend.
DEF VAR v_vend1 LIKE xxsod_vend.
DEF VAR v_addr LIKE xxsod_addr.
DEF VAR v_addr1 LIKE xxsod_addr.
DEF VAR v_part LIKE xxsod_part.
DEF VAR v_part1 LIKE xxsod_part .
DEF VAR v_due_date AS DATE .
DEF VAR v_due_date1 AS DATE .
DEF VAR v_invnbr LIKE xxsod_invnbr .
DEF VAR v_invnbr1 LIKE xxsod_invnbr .
DEF VAR v_week LIKE xxsod_week .
DEF VAR v_week1 LIKE xxsod_week.


form
    SKIP(.2)
    v_type       COLON 15    
    v_cust       COLON 15    v_cust1     label {t001.i} COLON 49 SKIP
    v_project    COLON 15    v_project1  LABEL {t001.i} COLON 49 SKIP
    v_vend       COLON 15    v_vend1     LABEL {t001.i} COLON 49 SKIP
    v_addr       COLON 15    v_addr1     LABEL {t001.i} COLON 49 SKIP
    v_part       COLON 15    v_part1     LABEL {t001.i} COLON 49 SKIP
    v_due_date   COLON 15    v_due_date1 LABEL {t001.i} COLON 49 SKIP
    v_invnbr     COLON 15    v_invnbr1   LABEL {t001.i} COLON 49 SKIP
    v_week       COLON 15    v_week1     LABEL {t001.i} COLON 49 SKIP

skip(1) 
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    IF v_cust1 = hi_char THEN v_cust1 = "".
    IF v_project1 = hi_char THEN v_project1 = "".
    IF v_vend1 = hi_char THEN v_vend1 = "".
    IF v_addr1 = hi_char THEN v_addr1 = "".
    IF v_part1 = hi_char THEN v_part1 = "".
    IF v_due_date = low_date THEN v_due_date = ? .
    IF v_due_date1 = hi_date THEN v_due_date1 = ?.
    IF v_invnbr1 = hi_char THEN v_invnbr1 = "" .

    update 
        v_type v_cust v_cust1 v_project v_project1 
        v_vend v_vend1 v_addr v_addr1 v_part v_part1
        v_due_date v_due_date1 v_invnbr v_invnbr1 
        v_week v_week1  
    with frame a.

    IF v_cust1 = "" THEN v_cust1 = hi_char.
    IF v_project1 = "" THEN v_project1 = hi_char.
    IF v_vend1 = "" THEN v_vend1 = hi_char.
    IF v_addr1 = "" THEN v_addr1 = hi_char.
    IF v_part1 = "" THEN v_part1 = hi_char.
    IF v_due_date = ? THEN v_due_date = low_date.
    IF v_due_date1 = ? THEN v_due_date1 = hi_date .
    IF v_invnbr1 = "" THEN v_invnbr1 = hi_char.

    {gpselout.i &printType = "printer"
                &printWidth = 132
                &pagedFlag = " "
                &stream = " "
                &appendToFile = " "
                &streamedOutputToTerminal = " "
                &withBatchOption = "yes"
                &displayStatementType = 1
                &withCancelMessage = "yes"
                &pageBottomMargin = 6
                &withEmail = "yes"
                &withWinprint = "yes"
                &defineVariables = "yes"}
mainloop: 
do on error undo, return error on endkey undo, return error:                    
        {mfphead.i}

         /* EXPORT DELIMITER ";" "����" "�ͻ�" "��Ŀ"	"˳���"	"��Ӧ�̺�"	"�ջ��ص�"	"�����"	"�����ɫ"	"�������"	"�ƻ�����"	"��Ʊ����"	"��Ʊʱ��"	"��������"	"��Ʊ����"  
                                 "�汾��" 	"�ܴ�"	"����"	"��������"	"��ע"	"��ע1"  "�ͻ�����" "�ͻ�ʱ��" .*/
            
            put unformatted "����   �ͻ�     ��Ŀ    ˳���  ��Ӧ�̺�  �ջ��ص�        �����        �����ɫ            �������       �ƻ�����  �ͻ�����   �ͻ�ʱ��      ��������            ��Ʊ����      �汾��    �ܴ�      ����       ��������              ��ע                 ��ע1       ��Ʊ����  ��Ʊʱ��       ��Ʊ����   " SKIP.
            put unformatted "---- -------- -------- ------- --------- --------- -------------------- --------- ------------------------ --------- ---------- --------- ---------------- -------------------- ------ ---------- -------- ---------------- -------------------- -------------------- --------- --------- ----------------" SKIP .
            FOR EACH xxsod_det NO-LOCK WHERE xxsod_cust >= v_cust
                                         AND xxsod_cust <= v_cust1
                                         AND xxsod_project >= v_project
                                         AND xxsod_project <= v_project1
                                         AND xxsod_vend >= v_vend
                                         AND xxsod_vend <= v_vend1
                                         AND xxsod_addr >= v_addr
                                         AND xxsod_addr <= v_addr1
                                         AND xxsod_part >= v_part
                                         AND xxsod_part <= v_part1 
                                         AND date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-"))) >= v_due_date
                                         AND date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-"))) <= v_due_date1
                                         AND xxsod_invnbr >= v_invnbr 
                                         AND xxsod_invnbr <= v_invnbr1
                                         AND (xxsod_week >= v_week OR v_week = 0)
                                         AND (xxsod_week <= v_week1 OR v_week1 = 0):
                PUT UNFORMATTED xxsod_type AT 1.
                PUT UNFORMATTED xxsod_cust AT 6.
                PUT UNFORMATTED xxsod_project AT 15.
                PUT UNFORMATTED xxsod_item AT 24 .
                PUT UNFORMATTED xxsod_vend AT 32 .
                PUT UNFORMATTED xxsod_addr AT 42 .
                PUT UNFORMATTED xxsod_part AT 52 .
                PUT UNFORMATTED xxsod_color AT 73 .
                PUT UNFORMATTED xxsod_desc AT 83 .
                PUT UNFORMATTED xxsod_plan AT 108 .
                PUT UNFORMATTED xxsod_due_date1 AT 118.
                PUT UNFORMATTED xxsod_due_time1 AT 129.
                PUT UNFORMATTED xxsod_qty_ord TO 154 .
                PUT UNFORMATTED xxsod_invnbr AT 156 .
                PUT UNFORMATTED xxsod_rev AT 177.
                PUT UNFORMATTED xxsod_week TO 193.
                PUT UNFORMATTED xxsod_category AT 195.
                PUT UNFORMATTED xxsod_ship AT 204.
                PUT UNFORMATTED xxsod_rmks AT 221.
                PUT UNFORMATTED xxsod_rmks1 AT 242.
                PUT UNFORMATTED xxsod_due_date AT 263.
                PUT UNFORMATTED xxsod_due_time  AT 273.
                PUT UNFORMATTED xxsod__chr02 TO 298.
                PUT SKIP.

            END. /*FOR EACH xxsod_det*/

end. /* mainloop: */
{mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
