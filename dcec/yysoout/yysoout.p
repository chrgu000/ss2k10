/* xxunrp.p  - UNPLANNED RECEIPTS PRINT                               */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* V1                 Developped: 07/19/01      BY: Kang Jian          */
/* Rev: eb2+ sp7      Last Modified: 05/07/07      BY: judy Liu         */
	  
{mfdtitle.i}

/*start of define the value */
def var parttype as char.
def var part_from like tr_part.
def var part_to like tr_part.
def var line_from like tr_line.
def var line_to like tr_line.
def var soddet as char.
def var sonbr_from as char .
def var sonbr_to     as char .
def var duedate_from   as date .
def var duedate_to     as date .
def var flag1      as logical label "ֻ��ӡδ��ӡ�����ջ���".
def var pageno     as integer. /*ҳ��*/
def var duplicate  as char.    /*����*/
def var vendor     as char extent 6.
def var site       like tr_site.
def var pdate      as date initial today.    /*��ӡ����*/
def var vend_phone as char format "x(20)". /*��Ӧ�̵绰*/
def var rmks       as char format "x(80)". /*��ע*/
def var i          as integer.
def var j          as integer.
def var qty like tr_qty_chg.
def var qty_cri like tr_qty_chg label "Ӧ������".
DEF VAR SOAV AS LOGICAL.
def var sum as integer initial 0.
DEF VAR loc LIKE tr_loc.
/*end of define the value*/

/*start report title*/
form "���ⵥ"      at 33  
     pageno        label "ҳ��: "       at 42
     duplicate     no-labels          at 60
     so_cust      label "�ͻ�����: "     at 1
     ad_zip label "��    ��: "   at  35 
     so_nbr     label "�� �� ��: "   at 70
     "�ͻ�ȫ��:" at 1  ad_name       no-labels  at 10 
     so_ord_date  label "��������: "   at 72 
      ad_attn  label "�� ϵ ��:  " at 1
     ad_phone    label "��ϵ�绰:  "    at 35
     pdate         label "��ӡ����:  "   at 70 
    /* "�ͻ���ַ:"*/      ad_line1 label "�ͻ���ַ:  "   at  1
     so_rmks     label "��ע:  "   at 70 
     "���䷽ʽ:" at 1       "�˷ѳе���λ: " at 35 skip(1)
     "�����           �������                 ����     ʵ������ ��ˮ��       ��� ��ͬ����    �ۼ�      ��λ      ����Ա"
     skip "-----------------------------------------------------------------------------------------------------------------------"
     with no-box side-labels width 180 frame b.
form "���ⵥ"      at 33  
     pageno        label "ҳ��"       at 42
     duplicate     no-labels          at 60
     ih_cust      label "�ͻ�����:  "     at 1
     ad_zip label "��    ��: "   at  35
     ih_nbr     label "�� �� �ţ�"   at 70
     "�ͻ�ȫ��:" at 1     ad_name     no-labels  at 10  
     ih_ord_date  label "��������:  "   at 72
     ad_attn label "��ϵ��:  " at 1
     ad_phone    label "��ϵ�绰: "    at 1
     pdate         label "��ӡ����:  "   at 70 
    /* "�ͻ���ַ:"*/     ad_line1 label "�ͻ���ַ: " at  1
     ih_rmks     label "��ע:  "   at 70 skip(.1)
     "���䷽ʽ:" at 1       "�˷ѳе���λ: " at 35 skip(1)
     
     "�����           �������                 ����     ʵ������ ��ˮ��       ��� ��ͬ����     �ۼ�      ��λ      ����Ա"
     skip "-----------------------------------------------------------------------------------------------------------------------"
     with no-box side-labels width 180 frame bih.
/*end of report title*/     
     
/*start query  preference */

/*start format of query screen*/
&SCOPED-DEFINE PP_FRAME_NAME A
FORM      
RECT-FRAME       AT ROW 1.4 COLUMN 1.25
RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
SKIP(.1)  
sonbr_from  colon 25 label "�ͻ�����" 
sonbr_to  colon 50 label "��" skip
part_from colon 25 label "�����"
part_to colon 50 label "��"
line_from colon 25 label "���"
line_to colon 50 label "��"
duedate_from colon 25 label "��������"
duedate_to colon 50 label "��" skip
site colon 25 label "�ص�" skip
flag1 colon 25 label "ֻ��ӡδ��ӡ�����ջ���"
with frame a side-labels width 80 attr-space NO-BOX THREE-D.
 

DEFINE VARIABLE F-a-title AS CHARACTER.
F-a-title = " ѡ������ ".
RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
RECT-FRAME:HEIGHT-PIXELS in frame a =
FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.
&UNDEFINE PP_FRAME_NAME	  
 
/*judy 07/07/05*/   /* SET EXTERNAL LABELS */
/*judy 07/07/05*/   setFrameLabels(frame a:handle).


{mfguirpa.i true  "printer" 132 }
/*end format of query screen*/

/*start query preference initialize*/
/*start procefuer p-enable-ui*/
procedure p-enable-ui:
if part_to    = hi_char  then part_to = "". 
if sonbr_to    = hi_char  then sonbr_to = "". 
if duedate_from  = low_date then duedate_from = ?. 
if duedate_to    = hi_date  then duedate_to = ?.
     
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. 
/*end procefuer p-enable-ui*/
/*end query preference initialize*/

/*start procedure of p-report-quote*/
/*start receive query preference*/
procedure p-report-quote:
bcdparm = "".
{mfquoter.i part_from} 
{mfquoter.i part_to} 
{mfquoter.i sonbr_from} 
{mfquoter.i sonbr_to} 
{mfquoter.i duedate_from} 
{mfquoter.i duedate_to} 
{mfquoter.i flag1}
/*end receive query preference*/

/*start check the validity of query preference*/
if part_to     = ""  then part_to = hi_char. 
if sonbr_to     = ""  then sonbr_to = hi_char. 
if duedate_from  = ?   then duedate_from = low_date. 
if duedate_to    = ?   then duedate_to = hi_date.
IF LINE_to = 0  THEN  LINE_to = 999.
/*end check the validity of query preference*/
end procedure. 
/*end procedure of p-report-quote*/

/*end query  preference */

/*start procedure of p-report*/
/*start report out put*/
procedure p-report:
  {gpprtrpa.i  "window" 132}                               
  pageno = 1.
  i = 1.
 
/*start of for each*/
  for each tr_hist where (tr_effdate >= duedate_from)
                         and (tr_effdate <= duedate_to)
                         and (tr_part >= part_from)
                         and (tr_part <= part_to)
                         and (tr_nbr >= sonbr_from)
                         and (tr_nbr <= sonbr_to)
                         and (tr_line >= line_from)
                         and (tr_line <= line_to)
                         and (tr_site = site)
                         and (tr_type = "iss-so"  or tr_type = "iss-fas")
                         and ((not flag1) or tr__log02 = no)                         
                         no-lock use-index tr_nbr_eff,
       each in_mstr where (in_part = tr_part)
                         and in_site = tr_site                 
                         break  by tr_nbr by in__qadc01 by tr_part by tr_effdate by tr_serial
  			       with width 132 no-attr-space: 

    if available tr_hist then do:
      /*  MESSAGE "AA".
        PAUSE.*/
         find first pt_mstr where pt_part = tr_part.
      /*   find first in_mstr where in_part = tr_part and in_site = site.*/
         if available(pt_mstr) then parttype = pt_lot_ser.
         else parttype = "".         
         find first so_mstr where so_nbr = tr_nbr no-lock no-error.
         if available so_mstr then do:
             find first sod_det where sod_nbr = tr_nbr and sod_line = tr_line no-lock no-error.
             find first ad_mstr where ad_addr = so_cust no-lock no-error.
             if available(sod_det) then soddet="Y".
             else soddet="N". 
             if  i = 1 then  do:
                if tr__log02 = No then duplicate = "ԭ��".
                else duplicate = "����".
                display pageno duplicate so_cust so_nbr ad_zip ad_name ad_attn ad_line1  so_ord_date ad_phone pdate so_rmks with frame b.
             end.
             SOAV = yes.
         END.
         else do:
             soddet="N".
             find first ih_hist where ih_inv_nbr = tr_rmks no-lock no-error.
             find first IDH_HIST where iDH_nbr = tr_NBR and iDH_line = tr_line no-lock no-error.
             find first ad_mstr where ad_addr = ih_cust no-lock no-error.  
             if  i = 1 then  do:
                if tr__log02 = No then duplicate = "ԭ��".
                else duplicate = "����".
                display pageno duplicate ih_cust ih_nbr ad_zip ad_name ad_attn ad_line1 ih_ord_date ad_phone pdate ih_rmks with frame bih.
             end.
             SOAV = no.
         end.

     
         i = i + 1.
         qty = 0 - tr_qty_chg.        
         if SOAV = yes and soddet="Y" THEN             
             disp tr_part  pt_desc2 tr_effdate qty "  " tr_serial format "x(8)"  tr_line format ">>>"  sod_qty_ord format "->>>>>>>" sod_qty_ship  format "->>>>>>>" space(4)  
                    IN_user1 FORMAT "x(8)" /*pt_article*/ in__qadc01 FORMAT "x(4)" AT 117  with no-box no-labels width 132 frame c down.
         else
             if available(idh_hist) then
             disp tr_part  pt_desc2 tr_effdate qty "  " tr_serial format "x(8)"  tr_line format ">>>"  IDH_qty_ord format "->>>>>>>" IDH_qty_ship  format "->>>>>>>" space(4) 
                     IN_user1  FORMAT "x(8)"  /*pt_article*/ in__qadc01  FORMAT "x(4)"  AT 117 with no-box no-labels width 132 frame cIH down.
             else
             disp tr_part  pt_desc2 tr_effdate qty "  " tr_serial format "x(8)"  tr_line format ">>>"   "        "  "        " space(3)  /*pt_article*/ in__qadc01  with no-box no-labels width 132 frame cIH down.
             disp "-----------------------------------------------------------------------------------------------------------------------"
                  with width 132 no-box frame f.     
         sum = sum + 1.                                      
         if pt_pm_code = "C" then do:
            for each ps_mstr where ps_par = tr_part and  (pdate>=ps_start or ps_start=?) and (ps_end=? or ps_end>=pdate)
             no-lock:
                if  i = 1 then  do:
                   if tr__log02 = No then duplicate = "ԭ��".
                   else duplicate = "����".
                   if soav = yes then
                       display pageno duplicate so_cust so_nbr ad_name so_ord_date ad_phone pdate so_rmks with frame b.
                   else
                       display pageno duplicate ih_cust ih_nbr ad_name ih_ord_date ad_phone pdate ih_rmks with frame bih.
                end.                 
                i = i + 1.
                find pt_mstr where pt_part = ps_comp no-lock no-error.
                qty_cri = qty * ps_qty_per.
                disp ps_comp pt_desc2 tr_effdate space(32) qty_cri format "->>>>>>>" with no-box no-label width 132 frame c2 down.
                disp "-----------------------------------------------------------------------------------------------------------------------"
                with width 132 no-box frame f1.                                           
            end.
            if line-counter >= (page-size - 5)  then do:
              display "����Ա��           ����Ա��            �ջ��ˣ�            ����       �������ܣ�"   at 1
                  with width 132 no-box frame d.  
              page.
              i=1.
              pageno = pageno + 1.
            end.
         end.
         if line-counter >= (page-size - 5) or last-of(tr_nbr) or (last-of(tr_part) and parttype="S")  then do:
              if last-of(tr_part) and parttype ="S" then do:
                  disp tr_nbr tr_part pt_desc2 "�ϼ�:" sum format "->>>>>>>>" with no-box no-label width 132 frame hj down.
                  sum = 0.
              end.
              display "����Ա��           ����Ա��            �ջ��ˣ�            ����       �������ܣ�"   at 1
                  with width 132 no-box frame d.  
              page.
              i=1.
              pageno = pageno + 1.
         end.
    end.
  end.


  {mfgrptrm.i}
  {mfphead.i}

/* start of flag of printed */ 
  if dev = "printer" or dev="print-sm" or dev="PRNT88" or dev="PRNT80" or dev="printer" or dev="print-sm" then do:
    for each tr_hist where (tr_effdate >= duedate_from)
                         and (tr_effdate <= duedate_to)
                         and (tr_nbr >= sonbr_from)
                         and (tr_nbr <= sonbr_to)
                         and (tr_type = "iss-so" or tr_type = "iss-fas")
                         and ((not flag1) or tr__log02 = no)
                         use-index tr_nbr:
          tr__log02 = yes.
    end.
  end.
/* end of flag of printed */ 
/*judy 05/06/28*/ {mfreset.i}  
end procedure.  
/* end report out put */

/* cycle drive the query output */
{mfguirpb.i &flds="sonbr_from sonbr_to part_from part_to line_from line_to  duedate_from duedate_to site flag1 "}

/* reset variable */

