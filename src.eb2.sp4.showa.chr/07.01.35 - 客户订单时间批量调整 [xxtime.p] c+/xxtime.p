{mfdtitle.i "c+ "}
define variable up_time as integer.                        /*�����ʱ��*/
def variable A AS integer init 1.
def variable B AS date.
DEF variable C as integer.
define variable xxsoduedate as date.
define variable xxsoduedate1 as date.
define variable xxsodinvnbr like xxsod_invnbr.
define variable xxsodinvnbr1 like xxsod_invnbr.
define variable xxsodcust like xxsod_cust.
define variable xxsodrmks2 like xxsod_rmks2.  
define variable ifupdate as logical.              /*��ע*/

form
    xxsoduedate colon 12  label "�ͻ�����"
    xxsoduedate1 colon 40 label "��"
    xxsodinvnbr colon 12  label "��Ʊ��"
    xxsodinvnbr1 colon 40  label "��"
    xxsodcust    colon 12  label "�ͻ�����"
    skip(1)     /**����**/   
    "(����˵����ʱ���Ƴ�����������ʱ����ǰ���븺�����Ƴ���������24�ı���."    colon 8
    " ��:��ǰһ�죬����-24;�Ƴ�4Сʱ������4; �Ƴ����죬����48.) "            colon 11      
    skip(1)
    up_time colon 30  label "�����ͻ�ʱ��"
    xxsodrmks2   colon 30  label "��ע"
with frame a side-label width 80.
setframelabels(frame a:handle).                                                 
form
    xxsod_cust
    xxsod_part
    xxsod_invnbr
    xxsod_due_date1
    xxsod_due_time1
    xxsod_qty_ord
    xxsod_rmks2
with frame b down width 120.
setframelabels(frame b:handle).
main:
  repeat:
  if xxsoduedate  = low_date then xxsoduedate = ? .
  if xxsoduedate1 = hi_date then xxsoduedate1 = ? .
  if xxsodinvnbr1 = hi_char then xxsodinvnbr1 = "".
  if xxsodcust = hi_char then xxsodcust = "".        
  update  xxsoduedate xxsoduedate1
          xxsodinvnbr xxsodinvnbr1 xxsodcust
  with frame a.  
  if xxsoduedate  = ? then xxsoduedate = low_date.
  if xxsoduedate1 = ? then xxsoduedate1 = hi_date. 
  if xxsodinvnbr1 = "" then xxsodinvnbr1 = hi_char. 
  update up_time  xxsodrmks2 
  with frame a.  
  {mfselprt.i "printer" 120}
  for each xxsod_det where  date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-")))  >= xxsoduedate and
       date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-"))) <= xxsoduedate1 and 
       xxsod_invnbr >= xxsodinvnbr and xxsod_invnbr <= xxsodinvnbr1 and xxsod_cust = xxsodcust : 
       disp   xxsod_cust    LABEL "�ͻ�����" 
               xxsod_part    LABEL "�ͻ�ͼ��"
               xxsod_invnbr  LABEL "��Ʊ����" 
               xxsod_due_date1    LABEL "�ͻ�����"
               xxsod_due_time1   LABEL "�ͻ�ʱ��"   
               xxsod_qty_ord     LABEL "��������" 
               xxsod_rmks1    LABEL "��ע1" 
          with frame b.
          down 1 with frame b. 
  end.   /*for*/
  {mfreset.i} 
  {mfgrptrm.i}        
  message "�Ƿ���� ��"  update ifupdate  .
   if ifupdate then               /*ѡ���Ƿ����*/
   do transaction on error undo , retry :
   for each xxsod_det  where  
      date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-")))  >= xxsoduedate and
       date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-"))) <= xxsoduedate1  and 
       xxsod_invnbr >= xxsodinvnbr and xxsod_invnbr <= xxsodinvnbr1  and xxsod_cust = xxsodcust : 
         A = int(substring(xxsod_due_time1,1,2)).
          xxsod_rmks1 = xxsodrmks2.
          IF UP_time > 0 THEN
              DO:
                  IF UP_time MOD 24 = 0 THEN
                     DO:
                         xxsod_due_time1 = xxsod_due_time1.
                         B = DATE(xxsod_due_date1) + INT(UP_time / 24).
                         xxsod_due_date1 = STRING(YEAR(B)) + '-' + SUBSTRING(string(B),4,2) + '-' + SUBSTRING(string(B),7,2).
                     END.
                  ELSE
                     DO:
                        IF UP_time < 16 THEN
                            DO:
                                 if (A + up_time) < 24 then xxsod_due_date1 = xxsod_due_date1.
                                 else
                                    do:
                                           C = INT(UP_time / 16 - 0.5) + INT(( UP_time + A - INT(UP_time / 16 - 0.5) * 16 ) / 24 - 0.5 ).
                                           B = DATE(xxsod_due_date1) + C.
                                           xxsod_due_date1 = STRING(YEAR(B)) + '-' + SUBSTRING(string(B),4,2) + '-' + SUBSTRING(string(B),7,2).
                                    end.
                                 IF A + UP_time > 23 THEN
                                    DO:
                                       A = A + UP_time - 16.
                                       IF A = 12 AND (xxsod_cust = '4h0003' or xxsod_cust = '4h1003') THEN
                                          xxsod_due_time1 = STRING(A + 1) + ':' + SUBSTRING(xxsod_due_time1,4,2).
                                       IF A > 9 THEN
                                            xxsod_due_time1 = STRING(A) + ':' + SUBSTRING(xxsod_due_time1,4,2).
                                       ELSE
                                            xxsod_due_time1 =  '0' + STRING(A) + ':' + SUBSTRING(xxsod_due_time1,4,2). 
                                    END.
                                 ELSE
                                     DO:
                                         A = A + UP_time.
                                         IF A = 12 AND (xxsod_cust = '4h0003' or xxsod_cust = '4h1003') THEN
                                              xxsod_due_time1 = STRING(A + 1) + ':' + SUBSTRING(xxsod_due_time1,4,2).
                                         IF A > 9 THEN
                                               xxsod_due_time1 = STRING(A) + ':' + SUBSTRING(xxsod_due_time1,4,2).
                                         ELSE
                                               xxsod_due_time1 =  '0' + STRING(A) + ':' + SUBSTRING(xxsod_due_time1,4,2). 
                                     END.
                            END.
                        ELSE
                            DO:
                               C = INT(UP_time / 16 - 0.5) + INT(( UP_time + A - INT(UP_time / 16 - 0.5) * 16 ) / 24 - 0.5 ).
                               B = DATE(xxsod_due_date1) + C.
                               xxsod_due_date1 = STRING(YEAR(B)) + '-' + SUBSTRING(string(B),4,2) + '-' + SUBSTRING(string(B),7,2).
                               IF A + UP_time - INT(UP_time / 16 - 0.5) * 16 > 23 THEN
                                   DO:
                                      A = A + UP_time - INT(UP_time / 16 - 0.5) * 16 - 16.
                                      IF A = 12 AND (xxsod_cust = '4h0003' or xxsod_cust = '4h1003') THEN
                                          xxsod_due_time1 = STRING(A + 1) + ':' + SUBSTRING(xxsod_due_time1,4,2).
                                      IF A > 9 THEN
                                          xxsod_due_time1 = STRING(A) + ':' + SUBSTRING(xxsod_due_time1,4,2).
                                      ELSE
                                          xxsod_due_time1 =  '0' + STRING(A) + ':' + SUBSTRING(xxsod_due_time1,4,2). 
                                   END.
                               ELSE
                                   DO:
                                       A = A + UP_time - INT(UP_time / 16 - 0.5) * 16.
                                       IF A = 12 AND (xxsod_cust = '4h0003' or xxsod_cust = '4h1003') THEN
                                            xxsod_due_time1 = STRING(A + 1) + ':' + SUBSTRING(xxsod_due_time1,4,2).
                                       IF A > 9 THEN
                                            xxsod_due_time1 = STRING(A) + ':' + SUBSTRING(xxsod_due_time1,4,2).
                                       ELSE
                                            xxsod_due_time1 =  '0' + STRING(A) + ':' + SUBSTRING(xxsod_due_time1,4,2). 
                                   END.
                            END.
                     END.
              END.
 /*************************************************************************************************************************************************/
          ELSE   /*��ǰ��������*/
               DO:
                  IF UP_time MOD 24 = 0 THEN
                     DO:
                         B = DATE(xxsod_due_date1) + INT(UP_time / 24).
                         xxsod_due_date1 = STRING(YEAR(B)) + '-' + substring(string(B),4,2) + '-' + substring(string(B), 7,2).
                         xxsod_due_time1 = STRING(A) + ':' + SUBSTRING(xxsod_due_time1,4,2).
                     END.
                  ELSE
                      DO:
                         IF ABS(UP_time) < 16 THEN
                             DO: 
                                 IF (A + UP_time) < 8 THEN
                                     DO:
                                        B = DATE(xxsod_due_date1) - 1.
                                        xxsod_due_date1 = STRING(YEAR(B)) + '-' + substring(string(B),4,2) + '-' + substring(string(B), 7,2). 
                                     END.
                                 ELSE 
                                     DO:
                                         B = DATE(xxsod_due_date1).
                                         xxsod_due_date1 = STRING(YEAR(B)) + '-' + substring(string(B),4,2) + '-' + substring(string(B), 7,2).
                                     END.
                             END.
                         ELSE 
                             IF ABS(UP_time) >= 16 THEN
                                 DO:
                                     C = INT(UP_time / 16 + 0.5).
                                     IF (A + UP_time - C * 16) < 8 THEN
                                         DO:
                                             B = DATE(xxsod_due_date1) + (C - 1).
                                             xxsod_due_date1 = STRING(YEAR(B)) + '-' + substring(string(B),4,2) + '-' + substring(string(B), 7,2).
                                         END.
                                     IF (A + UP_time) > 7 AND (A + UP_time) < 24 THEN
                                         DO:
                                             B = DATE(xxsod_due_date1) + C.
                                             xxsod_due_date1 = STRING(YEAR(B)) + '-' + substring(string(B),4,2) + '-' + substring(string(B), 7,2).
                                         END.
                                 END.
     
                             IF 23 - (7 - (A + UP_time)) MOD 16 > 9 THEN
                                 DO:
                                     IF 23 - (7 - (A + UP_time)) MOD 16 = 12 AND (xxsod_cust = '4h0003' or xxsod_cust = '4h1003') THEN
                                         xxsod_due_time1 = STRING(23 - (7 - (A + UP_time)) MOD 16 + 1) + ':' + SUBSTRING(xxsod_due_time1,4,2).
                                     ELSE
                                         xxsod_due_time1 = STRING(23 - (7 - (A + UP_time)) MOD 16) + ':' + SUBSTRING(xxsod_due_time1,4,2).
                                 END.
                             ELSE
                                  xxsod_due_time1 = '0' + STRING(23 - (7 - (A + UP_time)) MOD 16) + ':' + SUBSTRING(xxsod_due_time1,4,2).
                      END.
               END.
          end.  /*for*/
       ifupdate = no.   
       end.   /*do*/
         
         
end.                  