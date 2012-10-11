/*modify by henri 20120815   */
/*{mfdtitle.i "++ "} FN07*/
{mfdtitle.i "20120815"}

DEFINE VAR sosum LIKE tr_qty_loc INIT 0.
DEFINE VAR ptsum LIKE tr_qty_loc INIT 0.
DEFINE VAR bgdate LIKE tr_date INIT TODAY LABEL "��ʼ����". /*��ʼ����*/
DEFINE VAR eddate LIKE tr_date  INIT TODAY LABEL "��������". /*��������*/
DEFINE VAR costls AS CHAR INIT "STD2007" LABEL "�ɱ���".
DEFINE VAR part LIKE  tr_part.
DEFINE VAR part1 LIKE  tr_part.


DEF VAR tot_bd LIKE sct_cst_tot.  /*����*/
DEF VAR tot_lb LIKE sct_cst_tot.  /*ֱ���˹�*/
DEF VAR tot_rg LIKE sct_cst_tot.  /*�˹�*/
DEF VAR tot_fj LIKE  sct_cst_tot.  /*����*/
DEF VAR tot_jj LIKE sct_cst_tot.  /*ֱ��*/
DEF VAR tot_gs LIKE  sct_cst_tot.  /*��˰*/
DEF VAR tot_zb LIKE  sct_cst_tot.  /*ת��*/ 
DEF VAR tot_cl LIKE  sct_cst_tot. /*����*/
DEF VAR partcost AS DECIMAL. /*cost*/


DEFINE WORKFILE xxwkso
       FIELD part LIKE  tr_part LABEL "����"
       FIELD qty LIKE  tr_qty_loc LABEL "����"
       FIELD site LIKE tr_site LABEL "�ص�"
       FIELD lot LIKE tr_lot LABEL "�����"
       FIELD bkdate LIKE tr_date LABEL "�س�����"
       FIELD effdate LIKE tr_effdate .   /*so */

DEFINE WORKFILE xxwkpt
       FIELD part LIKE  tr_part LABEL "�����"
       FIELD qty LIKE  tr_qty_loc LABEL "����"
       FIELD site LIKE tr_site LABEL "�ص�"
       FIELD lot LIKE tr_lot LABEL "�����"
       FIELD bkdate LIKE tr_date LABEL "�س�����"
       FIELD effdate LIKE tr_effdate. /*part */

DEFINE WORKFILE xxwkpc
       FIELD list LIKE pc_list LABEL "��Ӧ�̴���"
       FIELD part LIKE pc_part LABEL "�����"
       FIELD stdate LIKE pc_start 
       FIELD exdate LIKE pc_expire 
       FIELD um LIKE pc_um LABEL "������λ"
       FIELD amt_type LIKE pc_amt_type LABEL "����"
       FIELD amt LIKE pc_amt[1] LABEL "price"
       FIELD curr LIKE pc_curr LABEL "����". /*price*/

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP
 part COLON 22 LABEL "�����" part1 COLON 49 LABEL "��"
 bgdate COLON 22 eddate COLON 49
 costls colon 22 LABEL "�ɱ���" 
 SKIP
 "ע�⣺���Ƽ�û�вɹ��۸�ȡ��׼�ɱ���"    COLON 15
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
setframelabels(frame a:handle) .
repeat:
  update  part part1 bgdate eddate costls with frame a.
    {mfquoter.i part}
    {mfquoter.i part1}
    {mfquoter.i bgdate}
    {mfquoter.i eddate}
    {mfquoter.i costls}
    {mfselbpr.i "printer" 132}
    /*{mfphead.i}*/
  IF part = hi_char THEN part = "".
  IF part1 = ""  THEN part1 = hi_char.
  FOR EACH xxwkso:
      DELETE xxwkso.
  END.
  FOR EACH xxwkpt:
      DELETE xxwkpt.
  END.
  FOR EACH xxwkpc:
      DELETE xxwkpc.
  END.
  IF part <> "" THEN DO:
    FOR EACH tr_hist WHERE tr_domain = global_domain and tr_type ="RCT-WO" AND tr_date >=bgdate AND tr_date <= eddate 
    AND tr_part >= part AND tr_part <= part1  USE-INDEX tr_date BREAK BY tr_lot BY tr_part.
      IF FIRST-OF (tr_lot) THEN sosum=0.
         sosum = sosum + tr_qty_loc.
      IF LAST-OF(tr_lot) THEN DO:
        CREATE xxwkso.
        ASSIGN xxwkso.part = tr_part
               xxwkso.qty = sosum
               xxwkso.site = tr_site
               xxwkso.lot = tr_lot
               xxwkso.bkdate = tr_date
               xxwkso.effdate = tr_effdate.
      END.
    END. /* get so */

    FOR EACH  xxwkso.
       FOR EACH tr_hist WHERE tr_domain = global_domain and tr_lot = xxwkso.lot AND tr_type ="ISS-WO"AND tr_date >=bgdate AND tr_date <= eddate 
       USE-INDEX tr_date BREAK BY tr_part BY tr_part.
          IF FIRST-OF(tr_part) THEN ptsum=0.
             ptsum = ptsum + tr_qty_loc.
          IF LAST-OF(tr_part) THEN DO:
            CREATE xxwkpt.
            ASSIGN xxwkpt.part = tr_part
                   xxwkpt.qty = ptsum
                   xxwkpt.site = tr_site
                   xxwkpt.lot = tr_lot
                   xxwkpt.bkdate = tr_date
                   xxwkpt.effdate = tr_effdate.
          END.
       END.
    END. /* get part*/


    FOR EACH xxwkpt.
       FOR EACH pc_mstr WHERE pc_domain = global_domain and pc_part = xxwkpt.part AND pc_start <= bgdate BREAK BY pc_part BY pc_start BY pc_part .
         IF LAST-OF (pc_part) THEN DO:
           CREATE xxwkpc.
           ASSIGN xxwkpc.list = pc_list
                  xxwkpc.part = pc_part
                  xxwkpc.stdate = pc_start
                  xxwkpc.exdate = pc_expire
                  xxwkpc.um =pc_um
                  xxwkpc.amt_type = pc_amt_type
                  xxwkpc.amt = pc_amt[1]
                  xxwkpc.curr = pc_curr.
         END.
       END.
    END. /* get price*/

/*OUTPUT TO c:\show.*/
  FOR EACH xxwkso.
    FIND FIRST pt_mstr WHERE pt_domain = global_domain and pt_part = xxwkso.part.
    IF AVAIL pt_mstr THEN DO:
       PUT "����               ;                 ;Ӣ������                 ;��������                ;               ;   ; �س�����    ;��λ; �ص�  ;�س�����  ;   ��Ч����" SKIP.
       PUT xxwkso.part ";                  ;" pt_desc1 ";" pt_desc2 ";               ;   ;" xxwkso.qty ";  ;" xxwkso.site ";" xxwkso.bkdate ";" xxwkso.effdate SKIP.
       PUT "����               ;�����           ;Ӣ������                 ;��������                ;����           ;����;�س�����;��λ;��Ӧ�̴���;��Ч����;ʧЧ����" SKIP.
    END.
    

    FOR EACH xxwkpt WHERE xxwkpt.lot =xxwkso.lot.
        FIND FIRST pt_mstr WHERE  pt_domain = global_domain and xxwkpt.part = pt_part NO-ERROR.
        FIND FIRST xxwkpc WHERE xxwkpc.part = xxwkpt.part NO-ERROR.
        IF NOT AVAIL xxwkpc THEN DO:
            FIND FIRST spt_det WHERE spt_domain = global_domain and spt_part = xxwkpt.part AND spt_sim = costls  NO-LOCK.
            CASE  spt_element:
            WHEN  "����"  THEN 
                  tot_cl = spt_cst_tl + spt_cst_ll.
            WHEN  "�˹�"  THEN 
                  tot_rg = spt_cst_tl + spt_cst_ll.
            WHEN  "����"  THEN  
                  tot_fj = spt_cst_tl + spt_cst_ll.
            WHEN  "���" THEN 
                  tot_jj = spt_cst_tl + spt_cst_ll.
	        WHEN  "�������"  THEN 
                  tot_bd = spt_cst_tl + spt_cst_ll.
            WHEN  "ֱ���˹�"  THEN 
                  tot_lb = spt_cst_tl + spt_cst_ll.
            WHEN  "��˰�˷�"  THEN 
                  tot_gs = spt_cst_tl + spt_cst_ll.
            WHEN  "ת��"  THEN 
                   tot_zb = spt_cst_tl + spt_cst_ll. 
            END CASE .
            partcost = tot_cl + tot_bd + tot_lb + tot_rg +  tot_fj  + tot_jj +  tot_gs + tot_zb. /*cost*/
            PUT xxwkso.part ";" xxwkpt.part ";" pt_desc1 ";" pt_desc2 ";" partcost ";RMB;" xxwkpt.qty * -1 ";EA" SKIP.
        END.
        ELSE DO:
           PUT xxwkso.part ";" xxwkpt.part ";" pt_desc1 ";" pt_desc2 ";"  xxwkpc.amt ";" xxwkpc.curr ";" xxwkpt.qty * -1 ";" xxwkpc.um ";" xxwkpc.list ";"    xxwkpc.stdate ";" xxwkpc.exdate SKIP.
        END. /* end else*/
    END. /*end for xxwkpt*/
   END. /*end for xxwkso*/
  END. /*end if*/
 

    {mfguitrl.i} 
    {mfreset.i}  
    {mfgrptrm.i}
END. /*repeat*/
