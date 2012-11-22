/* xxtestoprp.p  - operation report print                               */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* V1                 Developped: 09/05/01      BY: Kang Jian          */
/* V2                 Developped: 09/16/01      BY: Kang Jian     *������������Ӽ������м��**/
/*�����ֶ�˵��
pt_mstr ������ݱ�
pt_iss_pol ��ʵ
pt_phantom ����
ps_mstr BOM���ݱ�
ps_par �����
ps_comp �����
ps_op ����
ps_qty_per ����
ps_start ��ʼ����
ps_end ��ֹ����

ro_det �����������ݱ�
ro_routing �������̴���
ro_op �������̴��빤��
ro_std_op ��׼����

opm_mstr ��׼�������ݱ�
opm_std_op ��׼���� */
{mfdtitle.i "120817.1"}
define workfile bom1 field bom1_par like ps_par
                     field bom1_op like ps_op
                     field bom1_i as integer.
define workfile bom2 field bom2_par like ps_par label "�����"
                     field bom2_op like ps_op label "BOM�й���"
                     field bom2_ro_op like ro_op label "���������й���"
                     field bom2_start like ps_start label "��ʼ����"
                     field bom2_end like ps_end label "��ֹ����"
                     field bom2_std_op like opm_std_op label "��׼����"
                     field bom2_pt_iss_pol like pt_iss_pol label "��"
                     field bom2_pt_phantom like pt_phantom label "��ʵ"
                     field bom2_pt_pm_code like pt_pm_code label "��/��"
                     field bom2_i as integer.
define var bom1 like ps_par.
define var level as integer.
/*start format of query screen*/
&SCOPED-DEFINE PP_FRAME_NAME A
FORM      
   RECT-FRAME       AT ROW 1.4 COLUMN 1.25
   RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
   SKIP(.1)  
   bom1 colon 30 
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
/*judy 05/08/05*/ /* SET EXTERNAL LABELS */
/*judy 05/08/05*/  setFrameLabels(frame a:handle).

{mfguirpa.i true  "printer" 132 }
/*end format of query screen*/

/*start query preference initialize*/
/*start procefuer p-enable-ui*/
procedure p-enable-ui:
   
   if bom1     = hi_char  then bom1 = "". 
     
   run p-action-fields (input "display").
   run p-action-fields (input "enable").
end procedure. 
/*end procefuer p-enable-ui*/
/*end query preference initialize*/

/*start procedure of p-report-quote*/
/*start receive query preference*/
procedure p-report-quote:
   bcdparm = "".
   {mfquoter.i bom1} 
/*end receive query preference*/

/*start check the validity of query preference*/
   if bom1     = ""  then bom1 = hi_char. 
/*end check the validity of query preference*/
end procedure. 
/*end procedure of p-report-quote*/

/*end query  preference */

/*start procedure of p-report*/
/*start report out put*/
procedure p-report:
{gpprtrpa.i  "window" 132}                               
create bom1.
bom1_par = bom1.
bom1_i = 0.
do level = 0 to 99 :
    for each bom1 where bom1_i = level :
        for each ps_mstr where ps_domain = global_domain and 
        				 ps_par = bom1_par use-index ps_par no-lock:
            create bom2.
            bom2_par = ps_comp.
            bom2_op = ps_op.
            bom2_start = ps_start.
            bom2_end = ps_end.
            bom2_i = level + 1.
            find pt_mstr where pt_domain = global_domain and
            		 pt_part = ps_comp no-lock no-error .
            if available pt_mstr then do:
                 bom2_pt_pm_code = pt_pm_code.
               bom2_pt_iss_pol = pt_iss_pol.
               bom2_pt_phantom = pt_phantom.
            end.
        end.
    end.
    find first bom2 where bom2_i = (level + 1) no-error.
    if not available bom2 then leave.
    for each bom2 :
         if not (bom2_pt_pm_code="M" and (not bom2_pt_phantom)) then do:            
          create bom1.
            bom1_par = bom2_par.
            bom1_i = bom2_i.
       end.
    end.   
end.
for each bom2 :    
    if bom2_op <> 0 then do:
       find first ro_det where ro_domain = global_domain and 
       			ro_routing = bom1 and ro_op = bom2_op no-lock no-error .
       if available ro_det then do:
        bom2_ro_op = ro_op.
        bom2_std_op = ro_std_op.
       end.
    end.
end.
display space(15) "BOM��δ���幤������  " with STREAM-IO no-attr-space down.
for each bom2 where bom2_op = 0:
   display bom2_par bom2_op bom2_start bom2_end with STREAM-IO no-attr-space down.
   if line-count + 4 > page-size then page.
end.
display "����������δ������嵥" at 10 with STREAM-IO no-attr-space down.
for each bom2 where bom2_op <> 0   and bom2_ro_op = 0:
   display bom2_par bom2_op bom2_pt_iss_pol  bom2_pt_phantom with STREAM-IO no-attr-space down.
   if line-count + 4 > page-size then page.
end.
/*display "BOM1���򱨱�:" at 10 with STREAM-IO no-attr-space down.
for each bom1 no-lock:
    disp bom1_par  bom1_i with STREAM-IO no-attr-space down.
end.
display "BOM2���򱨱�" at 10 with STREAM-IO no-attr-space down.
for each bom2 no-lock:
    disp bom2_par bom2_op bom2_ro_op bom2_start bom2_end bom2_std_op bom2_std_op bom2_pt_iss_pol 
         bom2_pt_phantom bom2_pt_pm bom2_i with STREAM-IO no-attr-space down.
end.  */
for each bom1:
   delete bom1.
end.
for each bom2:
  delete bom2.
end.

{mfreset.i}    
{mfgrptrm.i}
 
/* reset variable */

end. /*end of the procedure*/
{mfguirpb.i &flds="bom1 "}

