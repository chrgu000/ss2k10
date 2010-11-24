/******************************************************************************/
/*name:װ���嵥��ѯ                                                           */
/*designed by Billy 2009-01-14                                                */
/******************************************************************************/

{mfdtitle.i "billy"}

define variable packno1 like xxvind_ZhuangXiang_NBR.
define variable packno2 like xxvind_ZhuangXiang_NBR.
define variable sonbr1 like xxvind_nbr.
define variable sonbr2 like xxvind_nbr.
define variable soline1 like xxvind_line.
define variable soline2 like xxvind_line.
define variable freightno like xxvind_chr01 format "x(10)".
define variable packlistno like xxvind_ZhuangXiang_NBR.
define variable sono like xxvind_nbr.
define variable soline like xxvind_line.
define variable ptpart like xxvind_part.
define variable oldname like pt_desc1.
define variable packqty as int init 0.
define variable vin like xxvind_id.
define variable yn1 as logical.
define variable motorid like xxvind_motor_id format "x(20)".
define variable packno like xxvind_chr02.

form
	freightno      column-label "���˵���"
	packlistno     column-label "װ�䵥��"
	sono           column-label "���۶�����"
	soline         column-label "���"
	ptpart         column-label "��Ʒ����"
	oldname        column-label "�ϳ���"
	packqty        column-label "װ������"
	vin            column-label "VIN��"
	motorid        column-label "��������"
	packno     column-label "���"
with frame b width 300 down attr-space.

form
 packno1 COLON 15 label "��װ���"
 packno2 COLON 49 label "��" skip
 sonbr1  colon 15 label "���۶�����"
 sonbr2  colon 49 label "��" skip
 soline1 colon 15 label "���"
 soline2 colon 49 label "��" skip
 yn1     colon 15 label "��ʾװ����ϸ"
WITH FRAME a SIDE-LABELS WIDTH 80 attr-space.

repeat:
	if sonbr2 = hi_char then sonbr1 = "".
	if packno2 = hi_char then packno2 = "".
	if soline2 = 999 then soline2 = 0.
  
		update
			packno1
			packno2
			sonbr1
			sonbr2
			soline1
			soline2
			yn1
		with frame a.
			
			if sonbr2 = "" then sonbr2 = hi_char.
			if packno2 = "" then packno2 = hi_char.
			if soline2 = 0 then soline2 = 999.

	{mfselprt.i "printer" 132}
	
	for each xxvind_det use-index xxvind_zhuangxiang where xxvind_domain = global_domain
	                          and xxvind_ZhuangXiang_NBR >= packno1 and xxvind_ZhuangXiang_NBR <= packno2
	                          and xxvind_ZhuangXiang_NBR <> ""
	                          and xxvind_nbr >= sonbr1 and xxvind_nbr <= sonbr2
	                          and xxvind_line >= soline1 and xxvind_line <= soline2 no-lock
	    break by xxvind_ZhuangXiang_NBR by xxvind_nbr:
	    	packqty = packqty + 1.
	    	if yn1 then 
	    		do:
			    			freightno = xxvind_chr01.
			    			packlistno = xxvind_ZhuangXiang_NBR.
			    			sono = xxvind_nbr.
			    			soline = xxvind_line.
			    			ptpart = xxvind_part.
			    			vin = xxvind_id.
			    			motorid = xxvind_motor_id.
			    			packno = xxvind_chr02.
			    			{gprun.i ""xxaddoldname.p"" "(input xxvind_part,output oldname)"}
			    			
			    			display
			    					freightno      column-label "���˵���"
										packlistno     column-label "װ�䵥��"
										sono           column-label "���۶�����"
										soline         column-label "���"
										ptpart         column-label "��Ʒ����"
										oldname        column-label "�ϳ���"
									  "1" @ packqty
										vin            column-label "VIN��"
										motorid    
										packno
							  with frame b.
							  down with frame b.
							  freightno = "".
							  packlistno = "".
							  sono = "".
							  soline = 0.
							  ptpart = "".
							  oldname = "".
							  packqty = 0.
							  vin = "".
							  motorid = "".
							  packno = "".
			     end.
			     else
			     do:
			     	if last-of(xxvind_ZhuangXiang_NBR) then
			    		do:
			    			freightno = xxvind_chr01.
			    			packlistno = xxvind_ZhuangXiang_NBR.
			    			sono = xxvind_nbr.
			    			soline = xxvind_line.
			    			ptpart = xxvind_part.
			    			{gprun.i ""xxaddoldname.p"" "(input xxvind_part,output oldname)"}
			    			
			    			display
			    					freightno      column-label "���˵���"
										packlistno     column-label "װ�䵥��"
										sono           column-label "���۶�����"
										soline         column-label "���"
										ptpart         column-label "��Ʒ����"
										oldname        column-label "�ϳ���"
										packqty        column-label "װ������"
										vin            column-label "VIN��"
										motorid
										packno
							  with frame b.
							  down with frame b.
							  freightno = "".
							  packlistno = "".
							  sono = "".
							  soline = 0.
							  ptpart = "".
							  oldname = "".
							  packqty = 0.
			    		end.
			     end.
  end. /*for each xxvind_det*/ 

	{mfreset.i}
	{mfgrptrm.i}
end. /*repeat*/
