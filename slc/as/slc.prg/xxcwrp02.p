/* SS - 090520.1 By: Neil Gao */
/* SS - 090630.1 By: Neil Gao */
/* SS - 090717.1 By: Neil Gao */

{mfdtitle.i "090717.1"}

define new shared var yr like glc_year.
define new shared var per like glc_per.
define new shared var vend  like po_vend.

form
  yr    		colon 12
  per     	colon 12
  vend			colon 12
with frame a side-labels width 80 attr-space.

setFrameLabels(frame a:handle).

mainloop:
repeat:
	
	update yr per vend with frame a.
	
	find first glc_cal where glc_domain = global_domain and glc_year = yr and glc_per = per no-lock no-error.
	if not avail glc_cal then do:
	 	message "�ڼ䲻����".
	 	next.
	end.
	
	find first vd_mstr where vd_domain = global_domain and vd_domain = global_domain and vd_addr = vend no-lock no-error.
	if not avail vd_mstr then do:
		message "����: ��Ӧ�̴��벻����".
		next.
	end.
	
	{mfselprt.i "priter" 132}

/* SS 090717.1 - B */
/*	
*	for each xxgzd_det where xxgzd_domain = global_domain and xxgzd_year = yr and xxgzd_per = per 
*		and xxgzd_vend = vend and xxgzd_end_qty > 0 no-lock,
*		each xxgz_mstr where xxgz_domain = global_domain and xxgz_year = yr and xxgz_per = per
*			and xxgz_vend = vend no-lock,
*		each ad_mstr where ad_domain = global_domain and ad_addr = xxgzd_vend no-lock 
*		break by xxgzd_part
*		with frame c width 200 no-attr-space:
*		
*		find first pt_mstr where pt_domain = global_domain and pt_part = xxgzd_part no-lock no-error.
*		
*		form header
*			 per colon 50 "�¹��˱�" skip
*			 "��Ƶ�λ: " colon 2 "¡�ι�ҵ���޹�˾���ֳ�����"
*			 "��������: " colon 80 xxgz_date skip
*			 "  ��Ӧ��: " colon 2 xxgzd_vend ad_name colon 22 
*		with frame fh1 page-top stream-io no-box no-label width 100.
*		
*		view frame fh1.
*		
*		if avail pt_mstr then do:
*			find first ptmstr where ptmstr.pt_domain = global_domain and ptmstr.pt_part = pt_mstr.pt_group no-lock no-error.
*		end.
*		else do:
*			release ptmstr.
*		end.
*		find first xxkc_det where xxkc_domain = global_domain and xxkc_year = yr and xxkc_per = per
*			and xxkc_part = xxgzd_part and xxkc_vend = xxgzd_vend no-lock no-error.
*		
*		tamt = xxgzd_amt / (1 + xxgzd_tax_pct / 100 ).
*		disp 	space(2)
*					xxgzd_part    column-label "���ϱ���"
*					ptmstr.pt_desc1 			column-label "���ʹ���"	when avail ptmstr format "x(8)"
*					pt_mstr.pt_desc2      column-label "���ƹ��" when avail pt_mstr
*					xxgzd_begin_qty column-label "����δ��" format "->>>>>>9"
*					xxkc_rct_po   column-label "�������" when avail xxkc_det format "->>>>>>9"
*					xxgzd_end_qty column-label "��������" format "->>>>>>9"
*					xxgzd_price   column-label "��˰����"
*					xxgzd_tax_pct column-label "˰��"    
*					xxgzd_amt     column-label "��˰���"
*					tamt			 		column-label "δ˰���"
*					xxkc_end_qty  column-label "δ������" when avail xxkc_det format "->>>>>>9"
*		with frame c .
*		down with frame c.
*		
*		accumulate xxgzd_amt ( total ).
*		accumulate tamt ( total ).
*		
*		if last(xxgzd_part) then do:
*			
*			underline xxgzd_amt tamt with frame c.
*			down with frame c.
*			disp 	"�ϼ�:" @ xxgzd_part
*						( accum total xxgzd_amt )  @ xxgzd_amt
*						( accum total tamt )  @ tamt
*						with frame c.
*			down with frame c.
*			
*			put skip(2).
*			put "��Ӧ��ȷ��: " at 10.
*			put "�Ʊ���:"      at 70.
*			find first usr_mstr where usr_userid = global_userid no-lock no-error.
*			if avail usr_mstr then put usr_name .	
*			
*		end.
*		else do:		
*			if page-size - line-counter <= 3 then do:
*				put "��Ӧ��ȷ��: " at 10.
*				put "�Ʊ���:"      at 70.
*				find first usr_mstr where usr_userid = global_userid no-lock no-error.
*				if avail usr_mstr then put usr_name .
*				page.
*			end.
*		end. 
*	end.
*/
	{gprun.i ""xxcwrp02a.p""}
/* SS 090717.1 - E */
	
	{mfreset.i}
	{mfgrptrm.i}
	
end.	
	
	
		
   