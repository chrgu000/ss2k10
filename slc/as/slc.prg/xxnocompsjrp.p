/******************************************************************************/
/*name:δ����ɢ����ѯ                                                         */
/*designed by Billy 2009-04-15                                                */
/*Ŀ�ģ�ͳ��ɢ�������������Ѿ������������û�з��������                      */
/******************************************************************************/

{mfdtitle.i "billy"}

define variable sjnbr1 like so_nbr.
define variable sjnbr2 like so_nbr.
define variable loc1 like pt_loc.
define variable part1 like pt_part.
define variable part2 like pt_part.
define variable yn as logical init yes.
define variable oldname as char.
define variable issqty like sod_qty_ord.
define variable noissqty like sod_qty_ord.
define variable desc1 as char format "x(76)".

form
    sod_nbr     column-label "ɢ��������"
    sod_line    column-label "���"
    sod_part    column-label "���ϱ���"
    pt_desc1    column-label "��������"
    oldname     column-label "�ϳ���"
    sod_qty_ord column-label "������"
    issqty      column-label "�ѷ�����"
    noissqty    column-label "δ������"
    desc1       column-label "��������"
with frame b width 300 down attr-space.

form
 sjnbr1 COLON 15 label "ɢ��������"
 sjnbr2 COLON 49 label "��"  skip
 part1  colon 15 label "���ϱ���"
 part2  colon 49 label "��"  skip
 loc1   colon 15 label "��λ" skip
 yn     colon 15 label "δ��������" skip 
WITH FRAME a SIDE-LABELS WIDTH 80 attr-space.

repeat:
	if sjnbr2 = hi_char then sjnbr2 = "".
	if part2 = hi_char then part2 = "".
  
	update
			sjnbr1
			sjnbr2
			part1
			part2
			loc1
			yn
	with frame a.
			
			
	if sjnbr2 = "" then sjnbr2 = hi_char.
	if part2 = "" then part2 = hi_char.

	{mfselprt.i "printer" 132}
	
	for each sod_det where sod_domain = global_domain
	                   and sod_nbr begins "C"
	                   and sod_nbr >= sjnbr1 and sod_nbr <= sjnbr2
	                   and sod_part >= part1 and sod_part <= part2 no-lock,
	    each pt_mstr where pt_domain = global_domain
	                   and pt_part = sod_part
	                   and pt_loc = loc1
	    break by sod_nbr:
	    	for each tr_hist use-index tr_part_eff where tr_domain = global_domain
	    	                                         and tr_site = "12000"
	    	                                         and tr_type = "iss-tr"
	    	                                         and tr_part = sod_part
	    	                                         and tr_rmks = sod_nbr no-lock:
                                   issqty = issqty - tr_qty_loc.	    	
	    	end.
	    	{gprun.i ""xxaddoldname.p"" "(input sod_part,output oldname)"}
	    	if yn then
	    	do:
	    		if issqty < sod_qty_ord then
	    			do:
	    				find first cd_det where cd_domain = global_domain and cd_ref = sod_part and cd_type = "SC" no-lock no-error.
	    	      if avail cd_det then desc1 = cd_cmmt[1] + cd_cmmt[2].
	    				noissqty = sod_qty_ord - issqty.
	    				disp
	    					sod_nbr     column-label "ɢ��������"
						    sod_line    column-label "���"
						    sod_part    column-label "���ϱ���"
						    pt_desc1    column-label "��������"
						    oldname     column-label "�ϳ���"
						    sod_qty_ord column-label "������"
						    issqty      column-label "�ѷ�����"
						    noissqty    column-label "δ������"
						    desc1       column-label "��������"
						  with frame b.
						  down with frame b.
						  issqty = 0.
						  noissqty = 0.
						  desc1 = "".
	    			end.
	    	end.
	    	else
	    	do:
	    		find first cd_det where cd_domain = global_domain and cd_ref = sod_part and cd_type = "SC" no-lock no-error.
	    	  if avail cd_det then desc1 = cd_cmmt[1] + cd_cmmt[2].
	    	  noissqty = sod_qty_ord - issqty.
	    				disp
	    					sod_nbr     column-label "ɢ��������"
						    sod_line    column-label "���"
						    sod_part    column-label "���ϱ���"
						    pt_desc1    column-label "��������"
						    oldname     column-label "�ϳ���"
						    sod_qty_ord column-label "������"
						    issqty      column-label "�ѷ�����"
						    noissqty    column-label "δ������"
						    desc1       column-label "��������"
						  with frame b.
						  down with frame b.
						  issqty = 0.
						  noissqty = 0.
						  desc1 = "".
	    	end.
	end.

	{mfreset.i}
	{mfgrptrm.i}
end. /*repeat*/
