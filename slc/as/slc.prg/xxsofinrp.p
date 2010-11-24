/******************************************************************************/
/*name:���۶�������������                                                */
/*designed by Billy 2009-05-12                                               */
/******************************************************************************/

{mfdtitle.i "billy"}

define variable sonbr like xxvin_nbr.
define variable sonbr1 like xxvin_nbr.
define variable soline like xxvin_line.
define variable soline1 like xxvin_line.
define variable yn1 as logical init no.
define variable orddate1 like so_ord_date.
define variable orddate2 like so_ord_date.
define variable sodduedate like sod_due_date.
define variable sodduedate1 like sod_due_date.
define variable yn as logical.
define variable wonbr like xxvin_wonbr.
define variable ptpart like pt_part.
define variable oldname like pt_desc1.
define variable sodqty like sod_qty_ord.
define variable shipdate like sod_due_date.
define variable saler as character format "x(8)".
define variable woqtyord like wo_qty_ord.
define variable onqty like xxvin_qty_down.
define variable downqty like xxvin_qty_pack.
define variable inqty like xxvin_qty_ruku.
define variable shipqty like sod_qty_ship.
define variable outqty like xxvin_qty_ruku.
define variable custno like so_cust.
define variable custname like cm_sort.
define variable orddate like so_ord_date.
define variable mpsqty like wo_qty_ord.
define variable ontimeqty like wo_qty_ord.
define variable diffqty like wo_qty_ord.
define variable delayday as int.
define variable finish as char.
define variable practicedate like xxvind_ruku_date.
define variable wofindate like wo_due_date.
define variable woreldate like wo_rel_date.

form
  custno     column-label "�ͻ�����"
  custname   column-label "�ͻ����"
	wonbr      column-label "������"
	ptpart     column-label "���ϱ���"
	oldname    column-label "�ϻ���"
	orddate    column-label "��������"
	practicedate column-label "����������"
	sodqty     column-label "������"
	mpsqty     column-label "�Ų���"
	woqtyord   column-label "�ɹ���"
	onqty      column-label "������"
	downqty    column-label "������"
	inqty      column-label "�����"
  ontimeqty  column-label "׼ʱ�����"
	diffqty    column-label "������"
	delayday   column-label "�ӳ�����"
	finish     column-label "�Ƿ����"
with frame b width 400 down attr-space.

form
 orddate1 colon 18 label "��������"
 orddate2 colon 49 label "��"
 sonbr COLON 18 label "���۶�����"
 sonbr1 COLON 49 label "��" skip
 soline colon 18 label "���"
 soline1 colon 49 label "��" skip
 yn1 colon 18 label "ֻ��ʾ���" skip
WITH FRAME a SIDE-LABELS WIDTH 80 attr-space.

repeat:
	if sonbr1 = hi_char then sonbr1 = "".
	if orddate1 = low_date then orddate1 = ?.
	if orddate2 = hi_date then orddate2 = ?.
	if soline1 = 999 then soline1 = 0.
	orddate2 = today.
	orddate1 = today - 60.

		update
		  orddate1
		  orddate2
			sonbr 
			sonbr1
			soline
			soline1
			yn1
		with frame a.
			
			
			if sonbr1 = "" then sonbr1 = hi_char.
			if orddate1 = ? then orddate1 = low_date.
			if orddate2 = ? then orddate2 = hi_date.
			if soline1 = 0 then soline1 = 999.

	{mfselprt.i "printer" 132}
	
	form header
	"¡�ι�ҵ���޹�˾���ֳ�����" at 40 skip
	"���۶�������������" at 43 skip
	WITH STREAM-IO FRAME ph1 PAGE-TOP WIDTH 130 NO-BOX.
	
			for each xxvin_mstr where xxvin_domain = global_domain
			                      and xxvin_nbr >= sonbr and xxvin_nbr <= sonbr1
			                      and xxvin_line >= soline and xxvin_line <= soline1 no-lock,
			    each pt_mstr where pt_domain = global_domain
			                      and pt_part = xxvin_part no-lock,
			    each sod_det where sod_domain = global_domain
			                      and sod_nbr = xxvin_nbr 
			                      and sod_line = xxvin_line
			                      and sod_part = xxvin_part no-lock,
			    each so_mstr where so_domain = global_domain
			                      and so_nbr = sod_nbr
			                      and so_ord_date >= orddate1 and so_ord_date <= orddate2 no-lock
			    break by xxvin_wonbr by xxvin_part:
			    	onqty = onqty + xxvin_qty_up.
			    	downqty = downqty + xxvin_qty_down.
			    	inqty = inqty + xxvin_qty_ruku.
			    	shipqty = shipqty + xxvin_qty_cuku.
			    	if last-of(xxvin_part) then
			    		do:
					    	for each wo_mstr where wo_domain = global_domain
					    	                   and wo_nbr = xxvin_wonbr
					    	                   and wo_part = xxvin_part no-lock
					    	    break by wo_nbr by wo_due_date:
					      		if (wo_status = "R" or wo_status = "C") then woqtyord = woqtyord + wo_qty_ord.
					      		if (wo_status = "F" or wo_status = "R" or wo_status = "C") then mpsqty = mpsqty + wo_qty_ord.
					      		if last-of(wo_nbr) then 
					      		do:
					      			wofindate = wo_due_date.
					      			woreldate = wo_rel_date.
					      		end.
					      end. /*for each wo_mstr*/
					  	 
					      find first sp_mstr where sp_domain = global_domain and sp_addr = sod_slspsn[1] no-lock no-error.
					      if avail sp_mstr then
					      	saler = sp_sort.
					      else
					        saler = "".
					      wonbr = xxvin_wonbr.
					      ptpart = pt_part.
					      oldname = pt_desc1.
					      sodqty = sod_qty_ord.
						    shipdate = sod_due_date.
						    
						    custno = so_cust.
						    orddate = so_ord_date.
						    find first cm_mstr where cm_domain = global_domain and cm_addr = so_cust no-lock no-error.
						    if avail cm_mstr then custname = cm_sort.
						    
						    for each xxvind_det use-index xxvind_sonbrline_wolot_id 
						                            where xxvind_domain = global_domain
						                              and xxvind_nbr = sod_nbr
						                              and xxvind_line = sod_line
						                              and xxvind_ruku_date <> ? no-lock
						        break by xxvind_part by xxvind_ruku_date:
						        	if (xxvind_ruku_date <= wofindate) then 
						        			ontimeqty = ontimeqty + 1.
						        	if last-of(xxvind_part) then
						        	do:
						        			practicedate = xxvind_ruku_date.
						        	end.		
						    end.   
						    diffqty = sodqty - mpsqty. 
						    delayday = practicedate - woreldate.
						    if delayday = ? then
						    		delayday = today - woreldate.
						    if inqty = sodqty then 
						    	finish = "���".
						    else
						    	finish = "δ���".                                    
						    view frame ph1.
						    if (yn1 = yes) then
						    do:
						    	if finish = "���" then
						    	do:
							      disp
							      		custno     column-label "�ͻ�����"
											  custname   column-label "�ͻ����"
												wonbr      column-label "������"
												ptpart     column-label "���ϱ���"
												oldname    column-label "�ϻ���"
												orddate    column-label "��������"
												practicedate column-label "����������"
												sodqty     column-label "������"
												mpsqty     column-label "�Ų���"
												woqtyord   column-label "�ɹ���"
												onqty      column-label "������"
												downqty    column-label "������"
												inqty      column-label "�����"
											  ontimeqty  column-label "׼ʱ�����"
												diffqty    column-label "������"
												delayday   column-label "�ӳ�����"
												finish     column-label "�Ƿ����"
							      with frame b.
							      down with frame b.
							      custno = "".
							      custname = "".
							      orddate = ?.
							      mpsqty = 0.
							      ontimeqty = 0.
							      diffqty = 0.
							      delayday = 0.
							      finish = "".
							      wonbr = "".
							      ptpart = "".
							      oldname = "".
							      sodqty = 0.
							      shipdate = ?.
							      saler = "".
							      woqtyord = 0.
							      onqty = 0.
							      downqty = 0.
							      inqty = 0.
							      shipqty = 0.
							      outqty = 0.
							      practicedate = ?.
							     end.
							    end.
							    else
							    do:
							    	disp
							      		custno     column-label "�ͻ�����"
											  custname   column-label "�ͻ����"
												wonbr      column-label "������"
												ptpart     column-label "���ϱ���"
												oldname    column-label "�ϻ���"
												orddate    column-label "��������"
												practicedate column-label "����������"
												sodqty     column-label "������"
												mpsqty     column-label "�Ų���"
												woqtyord   column-label "�ɹ���"
												onqty      column-label "������"
												downqty    column-label "������"
												inqty      column-label "�����"
											  ontimeqty  column-label "׼ʱ�����"
												diffqty    column-label "������"
												delayday   column-label "�ӳ�����"
												finish     column-label "�Ƿ����"
							      with frame b.
							      down with frame b.
							      custno = "".
							      custname = "".
							      orddate = ?.
							      mpsqty = 0.
							      ontimeqty = 0.
							      diffqty = 0.
							      delayday = 0.
							      finish = "".
							      wonbr = "".
							      ptpart = "".
							      oldname = "".
							      sodqty = 0.
							      shipdate = ?.
							      saler = "".
							      woqtyord = 0.
							      onqty = 0.
							      downqty = 0.
							      inqty = 0.
							      shipqty = 0.
							      outqty = 0.
							      practicedate = ?.
							    end.
							
					    end.	                   
			end. /*for each xxvin_mstr*/

	  {mfreset.i}
	  {mfgrptrm.i}
end. /*repeat*/
