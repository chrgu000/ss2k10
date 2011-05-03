{mfdtitle.i "C+ "}
define variable xxsodaddr like xxsod_addr.
define variable xxsodaddr1 like xxsod_addr.
define variable xxsoduedate  AS DATE  .
define variable xxsoduedate1 AS DATE  .
define variable xxsoduedate2 AS DATE  .
define variable xxsoduetime as char format "99:99" init "0000".
define variable xxsoduetime1 as char format "99:99" init "2400".
define variable xxsoduetime2 as char format "99:99".
define variable xxsoduetime3 as CHAR .

define variable xxsodinvnbr like xxsod_invnbr.
define variable xxsodinvnbr1 like xxsod_invnbr.
define variable xxsodqtyord like  xxsod_qty_ord.
define variable xxsodrmks2 like xxsod_rmks2.
define variable ifupdate as logical.

DEF VAR v_del AS LOGICAL INIT NO .
DEF VAR v_due_date AS CHAR.
DEF VAR v_due_time AS CHAR.

form 
   xxsodaddr  colon 12   label "�ջ��ص�"
   xxsodaddr1 colon 40   label "��"
   xxsoduedate colon 12  label "�ͻ�����"
   xxsoduedate1 colon 40 label "��"
   xxsoduetime  colon 12 label "�ͻ�ʱ��"
   xxsoduetime1 colon 40 label "��"
   xxsodinvnbr  colon 12 label "��Ʊ����"
   xxsodinvnbr1 colon 40 label "��"
   skip(1)
   "�޸ĺ��ֵ(δ��������޸�):"  colon 8   skip(1)
   xxsoduedate2 colon 30 label "�ͻ�����"
   xxsoduetime2 colon 30 label "�ͻ�ʱ��"
   xxsodqtyord  colon 30 label "����"
   xxsodrmks2   colon 30 label "��ע"
   v_del        COLON 30 LABEL "�Ƿ�ɾ��" 
with frame a side-label width 80 .
setFrameLabels(frame a:handle).

form
  xxsod_cust
  xxsod_part
  xxsod_invnbr
  xxsod_due_date 
  xxsoduetime3
  xxsod_qty_ord   
  xxsod_rmks   
with frame b down width 120.
setframelabels(frame b:handle).
  
     
main:
repeat :

  if xxsodaddr1 = hi_char then xxsodaddr1 = "".
  if xxsoduedate  = low_date then xxsoduedate = ? .
  if xxsoduedate1 = hi_date then xxsoduedate1 = ? .
  if xxsodinvnbr1 = hi_char then xxsodinvnbr1 = "".
        
  update  xxsodaddr   xxsodaddr1 
          xxsoduedate xxsoduedate1
          xxsoduetime xxsoduetime1
          xxsodinvnbr xxsodinvnbr1
  with frame a.
  
  if xxsodaddr1 = "" then xxsodaddr1 = hi_char.
  if xxsoduedate  = ? then xxsoduedate = low_date.
  if xxsoduedate1 = ? then xxsoduedate1 = hi_date. 
  if xxsodinvnbr1 = "" then xxsodinvnbr1 = hi_char.
           
     
  update xxsoduedate2 xxsoduetime2 
         xxsodqtyord  xxsodrmks2 v_del with frame a.
           
  {mfselprt.i "printer" 120}
   for each xxsod_det no-lock where xxsod_addr >= xxsodaddr and 
       xxsod_addr <= xxsodaddr1 and 
      date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),
     int(ENTRY(1,xxsod_due_date1, "-")))  >= xxsoduedate and
       date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),
     int(ENTRY(1,xxsod_due_date1, "-"))) <= xxsoduedate1 and xxsod_invnbr >= xxsodinvnbr and
       xxsod_invnbr <= xxsodinvnbr1 and 
       xxsod_due_time1 >= xxsoduetime and
       xxsod_due_time1 <= xxsoduetime1 :

       xxsoduetime3 = "".
       IF xxsoduedate2 = ?  THEN v_due_date = xxsod_due_date1 .

      /* MESSAGE xxsoduetime2 + "----" + xxsod_due_time1  VIEW-AS ALERT-BOX.  */
       
       IF xxsoduetime2 = "" THEN v_due_time = substring(xxsod_due_time1,1,2) + ":" + SUBSTRING(xxsod_due_time1,4,2) .
       IF xxsoduetime2 <> "" THEN xxsoduetime3 = substring(xxsoduetime2,1,2) + ":" + SUBSTRING(xxsoduetime2,3,2)  .

      /* MESSAGE v_due_time + "----" xxsoduetime3  VIEW-AS ALERT-BOX. */
                                                    
       disp xxsod_cust    LABEL "�ͻ�����" 
            xxsod_part    LABEL "�ͻ�ͼ��"
            xxsod_invnbr  LABEL "��Ʊ����" 
            v_due_date    @ xxsod_due_date    LABEL "�ͻ�����"
            string(year(xxsoduedate2)) + "-" + STRING(MONTH(xxsoduedate2)) + "-" + STRING(DAY(xxsoduedate2))    when xxsoduedate2 <> ? @ xxsod_due_date  LABEL "�ͻ�����"
            v_due_time                                            @ xxsoduetime3   LABEL "�ͻ�ʱ��"   
            xxsoduetime3                 when xxsoduetime2 <> ""  @ xxsoduetime3   LABEL "�ͻ�ʱ��" 
            xxsod_qty_ord  when xxsodqtyord = 0               LABEL "��������" 
            xxsodqtyord    when xxsodqtyord <> 0  @ xxsod_qty_ord   LABEL "��������" 
            xxsod_rmks1    when xxsodrmks2 = ""                LABEL "��ע1" 
            xxsodrmks2     when xxsodrmks2 <> ""  @ xxsod_rmks    LABEL "��ע1" 
      with frame b  .
      down 1 with frame b . 
                         
   end.  
     {mfreset.i} 
   {mfgrptrm.i}
   message "�Ƿ���� ��"  update ifupdate  .
   if ifupdate then 
   do transaction on error undo , retry :
      for each xxsod_det where xxsod_addr >= xxsodaddr and
          xxsod_addr <= xxsodaddr1 AND
          date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-")))  >= xxsoduedate and
          date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-"))) <= xxsoduedate1 and
          xxsod_invnbr >= xxsodinvnbr and
          xxsod_invnbr <= xxsodinvnbr1 and
          xxsod_due_time1 >= xxsoduetime   and
          xxsod_due_time1 <= xxsoduetime1  :
          
          if xxsoduedate2 <> ? then do:
	         xxsod_due_date1 = string(year(xxsoduedate2)) + "-" + STRING(MONTH(xxsoduedate2)) + "-" + STRING(DAY(xxsoduedate2)) .
	      end.

          if xxsoduetime2 <> "" then do:
             xxsod_due_time1 = substring(xxsoduetime2,1,2) + ":" + SUBSTRING(xxsoduetime2,3,2)  .
          END.

          if xxsodqtyord  <> 0 then xxsod_qty_ord = xxsodqtyord.
          if xxsodrmks2   <> "" then xxsod_rmks1 = xxsodrmks2 .           
     end.   

     ifupdate = NO.

   end.  /*do */                              

   IF v_del = YES THEN DO:
      for each xxsod_det where xxsod_addr >= xxsodaddr and
          xxsod_addr <= xxsodaddr1 AND
          date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-")))  >= xxsoduedate and
          date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-"))) <= xxsoduedate1 and
          xxsod_invnbr >= xxsodinvnbr and
          xxsod_invnbr <= xxsodinvnbr1 and
          xxsod_due_time1 >= xxsoduetime   and
          xxsod_due_time1 <= xxsoduetime1  :

          DELETE xxsod_det .
      END.
   END. /* if v_del = yes */

end.
