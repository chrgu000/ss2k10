/*By: Neil Gao 09/02/05 ECO: *SS 20090205* */

{mfdtitle.i "Billy"}

define variable trlot	like so_nbr.
define variable trlot1	like so_nbr.
define variable jdate as date.
define variable jdate1 as date.
define variable xxmod as char format "x(16)".
define variable ptname like pt_desc1.
define variable vender like vd_sort.

form
	trlot colon 15 label "�ջ�����"
	trlot1 colon 45 label "��"
	jdate colon 15 label "����"
	jdate1 colon 45 label "��"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

mainloop:
repeat:
	
	if trlot1 = hi_char then trlot1 = "".
  if jdate = low_date then jdate = ?.
  if jdate1 = hi_date then jdate1 = ?.
  
  update trlot trlot1 jdate jdate1 with frame a.
  
  if trlot1 = "" then trlot1 = hi_char.
  if jdate  = ? then jdate = low_date.
  if jdate1  = ? then jdate1 = hi_date.
  
  {mfselprt.i "printer" 132}
  
  for each tr_hist where tr_domain = global_domain and tr_type = 'rct-po' and tr__dec02 <> 0
  	and tr_lot >= trlot and tr_lot <= trlot1
		and (tr__dte04 >= jdate and tr__dte04 <= jdate1) no-lock :
		
		find first pt_mstr where pt_domain = global_domain and pt_part = tr_part no-lock no-error.
		if avail pt_mstr then do:
			xxmod = substring(pt_desc2,1,4).
			ptname = pt_desc1.
			find first pt_mstr where pt_domain = global_domain and pt_part = xxmod no-lock no-error.
			if avail pt_mstr then xxmod = pt_desc1.
		end.
		else xxmod = "".
  	find first rsn_ref where rsn_domain = global_domain and rsn_type = "SCRAP" and rsn_code = tr__chr04 no-lock no-error.
  	find first vd_mstr where vd_domain = global_domain and vd_addr = substring(tr_serial,7) no-lock no-error.
  	if avail vd_mstr then vender = vd_sort.
  	
  	disp 	tr_lot 		column-label "�ջ�����"
  				tr_part   column-label "�����"
  				xxmod			column-label "�ɻ���"
  				ptname    column-label "��������"
  				vender    column-label "��Ӧ��"
  				tr_qty_chg column-label "�ͼ�����"
  				tr__dec02 column-label "��������"
  				tr__dec03 column-label "�ܲ��ϸ�����"
  				tr__dec04 column-label "���ϸ�����1"
  				/*tr__dec05 int(tr__chr12)*/
  				tr__chr04 column-label "ԭ�����"
  				rsn_desc column-label "˵��" when avail rsn_ref
  				tr__chr10 column-label "����"
  				/*tr__chr05 tr__chr06 */
  				tr__chr08 column-label "������"
  				tr_effdate column-label "�������"
  				tr__dte04 column-label "��������"
  				string(int(tr__chr11),"HH:MM") column-label "����ʱ��"
  	with width 300 stream-io.			 
  	ptname = "".
  	vender = "".
  end.
  	
	{mfreset.i}
	{mfgrptrm.i}
	
end.
