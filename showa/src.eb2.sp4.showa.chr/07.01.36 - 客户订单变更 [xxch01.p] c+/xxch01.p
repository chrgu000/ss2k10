/* BY: Micho Yang         DATE: 07/07/08  ECO: *SS - 20080707.1* */

{mfdtitle.i "c+ "}
define variable T as integer init 0.                        /*�����ʱ��*/
def variable i AS integer INIT 0.
def variable D AS integer init 0.                        /*���������*/
def variable A as date.
DEF variable j as integer INIT 0.
define variable xxsoduedate as date.
define variable xxsoduedate1 as date.
define variable xxsoduetime as char format "99:99" initial "0800".
define variable xxsoduetime1 as char format "99:99" initial "2300".
define variable xxsodinvnbr like xxsod_invnbr.
define variable xxsodinvnbr1 like xxsod_invnbr.
define variable xxsodcust like xxsod_cust.
define variable xxsodrmks2 like xxsod_rmks2.  
define variable ifupdate as logical.              /*��ע*/
define variable str as char extent 15 initial["08:00","09:00","10:00","11:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"].      /*������12�������*/
define variable str1 as char extent 16 initial["08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"].       /*����12�������*/

&SCOPED-DEFINE PP_FRAME_NAME A
form
    RECT-FRAME       AT ROW 1 COLUMN 1.25
    RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
    skip(1)
    xxsoduedate  colon 12 label "�ͻ�����"
    xxsoduedate1 colon 40 label "��"
    xxsoduetime  colon 12 label "�ͻ�ʱ��"
    xxsoduetime1 colon 40 label "��"
    xxsodinvnbr  COLON 12 label "��Ʊ��"
    xxsodinvnbr1 colon 40 label "��"
    xxsodcust    colon 12 label "�ͻ�����"
    skip(1)
    D            colon 12 label "��������"
    T            colon 12 label "����ʱ��"
    xxsodrmks2   colon 12 label "��ע"
    skip(1)     /**����**/   
    "����˵��: ʱ���Ƴ���'����ʱ��'����������,ʱ����ǰ��'����ʱ��'�����븺��;"    colon 5
    "          ����������'��������'��������Ӧ������,�Ƴ�Ϊ����,��ǰΪ����."     COLON 5

    "      ��: ��ǰ1��,��'��������'������'-1';�Ƴ�4Сʱ,��'����ʱ��'������'4';"   COLON 5
    "          �Ƴ�2��1Сʱ,��'��������'������'2',��'����ʱ��'������'1' "         COLON 5
    SKIP(1)
with frame a side-label width 80 attr-space NO-BOX THREE-D.

DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

&UNDEFINE PP_FRAME_NAME

setframelabels(frame a:handle).                                                 
form
    xxsod_cust
    xxsod_part
    xxsod_invnbr
    xxsod_due_date1
    xxsod_due_time1
    xxsod_qty_ord
    xxsod_rmks1
with frame b down width 120.
setframelabels(frame b:handle).

main:
repeat:
  if xxsoduedate  = low_date then xxsoduedate = ? .
  if xxsoduedate1 = hi_date  then xxsoduedate1 = ? .
  if xxsodinvnbr1 = hi_char  then xxsodinvnbr1 = "".
  if xxsodcust    = hi_char  then xxsodcust = "".     

  update  xxsoduedate xxsoduedate1 xxsoduetime xxsoduetime1
          xxsodinvnbr xxsodinvnbr1 xxsodcust D T xxsodrmks2 WITH FRAME a .

  if xxsoduedate  = ?  then xxsoduedate  = low_date.
  if xxsoduedate1 = ?  then xxsoduedate1 = hi_date. 
  if xxsodinvnbr1 = "" then xxsodinvnbr1 = hi_char. 

  IF T > 15 OR T < -15 THEN DO:
      MESSAGE "�����������,����'��������'���������������" .
      UNDO,RETRY .
      NEXT-PROMPT T WITH FRAME a.
  END.

  {mfselprt.i "printer" 120}

  for each xxsod_det NO-LOCK 
      where date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-")))  >= xxsoduedate 
      AND date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-"))) <= xxsoduedate1 
      and xxsod_due_time1 >= substring(xxsoduetime,1,2) + ":" + SUBSTRING(xxsoduetime,3,2) 
      and xxsod_due_time1 <= substring(xxsoduetime1,1,2) + ":" + SUBSTRING(xxsoduetime1,3,2)
      and xxsod_invnbr >= xxsodinvnbr 
      and xxsod_invnbr <= xxsodinvnbr1 
      and xxsod_cust = xxsodcust :

       disp   xxsod_cust        LABEL "�ͻ�����" 
               xxsod_part       LABEL "�ͻ�ͼ��"
               xxsod_invnbr     LABEL "��Ʊ����" 
               xxsod_due_date1  LABEL "�ͻ�����"
               xxsod_due_time1  LABEL "�ͻ�ʱ��"   
               xxsod_qty_ord    LABEL "��������" 
               xxsod_rmks1      LABEL "��ע1" 
          with frame b.
          down 1 with frame b. 
  end.   /* for each xxsod_det */

  {mfreset.i} 
  {mfgrptrm.i}        
  message "�Ƿ���� ?"  update ifupdate  .

  if ifupdate then               /*ѡ���Ƿ����*/
  do transaction on error undo , retry :
      for each xxsod_det 
          where date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-")))  >= xxsoduedate 
          AND date(int(entry(2,xxsod_due_date1,"-")),int(ENTRY(3,xxsod_due_date1,"-")),int(ENTRY(1,xxsod_due_date1, "-"))) <= xxsoduedate1  
          and xxsod_due_time1 >= substring(xxsoduetime,1,2) + ":" + SUBSTRING(xxsoduetime,3,2)
          and xxsod_due_time1 <= substring(xxsoduetime1,1,2) + ":" + SUBSTRING(xxsoduetime1,3,2)
          and xxsod_invnbr >= xxsodinvnbr 
          and xxsod_invnbr <= xxsodinvnbr1  
          and xxsod_cust = xxsodcust : 

          A = date(xxsod_due_date1) + D.
          ASSIGN xxsod_rmks1 = xxsodrmks2.

          IF d <> 0 THEN DO:
              ASSIGN xxsod_due_date1 = STRING(YEAR(a),"9999") + "-" + STRING(MONTH(a),"99") + "-" + STRING(DAY(a),"99") .
          END.

          i = 0.
          j = 0.

          updatedatetime:
          REPEAT:
              i = i + 1.

              IF str1[i] = xxsod_due_time1 THEN DO:
                  i = i + T .

                  IF i < 1 THEN DO:
                      ASSIGN xxsod_due_date1 = STRING(YEAR(a - 1),"9999") + "-" + STRING(MONTH(a - 1),"99") + "-" + STRING(DAY(a - 1),"99") .

                      j = i + 16 .
                      xxsod_due_time1 = str1[j] .
                  END.
                  ELSE IF i >= 17 THEN DO:
                      ASSIGN xxsod_due_date1 = STRING(YEAR(a + 1),"9999") + "-" + STRING(MONTH(a + 1),"99") + "-" + STRING(DAY(a + 1),"99") .

                      j = i - 16 .
                      xxsod_due_time1 = str1[j] .
                  END.
                  ELSE DO:
                      xxsod_due_time1 = str1[i] .
                  END.

                  LEAVE.
              END. /* IF str1[i] = xxsod_due_time1 THEN DO: */
          END. /* updatedatetime: */
      end. /* for each xxsod_det  where */

      ifupdate = no.

  end. /* do transaction on error undo , retry : */

end. /* repeat: */      
