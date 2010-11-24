/* SS - 090403.1 By: Neil Gao */
/* SS - 091023.1 By: Neil Gao */
/* SS - 100623.1 By: Kaine Zhang */
/* SS - 100629.1 By: Kaine Zhang */

/* SS - 100623.1 - RNB
[100702.1]
�ݹ�����,���Ѿ����ⲿ�ֵ��ݹ�,�Բ����һ����Ӧ����.��������Ϊ0,��������(�ѳ�����ݹ�����*���).
[100702.1]
[100629.1]
�ݹ�����ʱ,���¼۸���������ʱ���ݹ��۸��в��,���Խ���������ϵĲ���,�����Ǽ�¼���µ�xxtr_hist��¼��.
[100629.1]
[100623.1]
#�������ݹ����������xxtr,xxld,xxglpod��¼,����һ��_is_zgcl���.
#����⴦���ʱ��,��ɾ���������ǵļ�¼.
��������,��֪��������,��[��⴦��]�����д���.
ȡ���޸�,���γ�mfdtitle�����ڰ汾��,δ�޸��κ�ʵ�ʴ���.
[100623.1]
SS - 100623.1 - RNE */

{mfdtitle.i "100702.1"}

define var yr like glc_year.
define var per like glc_per.
define var vend like po_vend.
define var part like pt_part.
define var desc1 like pt_desc1.
define var desc2 like pt_desc2.
define var tt_recid as recid.
define var first-recid as recid.
define var sw_reset like mfc_logical. 
define var update-yn as logical. 
define var site like in_site init "10000".
define var tnbr as char.

/* SS - 100629.1 - B */
define variable decOldPrice as decimal no-undo.
/* SS - 100629.1 - E */

define temp-table tt1
	field tt1_f1 like po_vend
	field tt1_f2 like pt_part
	field tt1_f3 like pt_desc1
	field tt1_f4 like ld_qty_oh
	field tt1_f5 like pt_price
	field tt1_f6 like pt_price
	field tt1_f7 as char format "x(4)"
	field tt1_f8 as int
	field tt1_f9 as int
	.

form
	yr colon 25
	per colon 25
	part colon 25
with frame a width 80 side-labels attr-space.

setFramelabels(frame a:handle).


form
	tt1_f1 label "��Ӧ��"
	tt1_f2 label "���Ϻ�"
	tt1_f4 label "����"
	tt1_f7 label "�ڼ�"
	tt1_f5 label "�ڼ�۸�"
	tt1_f6 label "���ڼ۸�"
with frame b width 80 5 down scroll 1.
	
mainloop:
repeat with frame a:
	
	hide frame b no-pause.
	
	update yr per part with frame a.
	
	find first glc_cal where glc_domain = global_domain and glc_year = yr and glc_per = per no-lock no-error.
	if not avail glc_cal then do:
	 	message "����: �ڼ䲻����".
	 	next.
	end.
	if glc_user1 <> "" then do:
		message "����: �����Ѿ��ر�".
		next.
	end.
	
	find first xxzgp_det where xxzgp_domain = global_domain and xxzgp_year = yr and xxzgp_per = per no-lock no-error.
	if not avail xxzgp_det then do:
		message "����: �ݹ��۸�û�д���".
		next.
	end.
	
	empty temp-table tt1.

	for each xxld_det where xxld_domain = global_domain and not ( xxld_year = yr and xxld_per	= per )
		and (xxld_part = part or part = "")
		and xxld_type = "�ݹ�" and xxld_zg_qty <> 0 no-lock:
		
		find first xxzgp_det where xxzgp_domain = global_domain and xxzgp_year = yr and xxzgp_per = per
      and xxzgp_vend = xxld_vend and xxzgp_part = xxld_part and xxzgp_type = "����" no-error.
     if not avail xxzgp_det then next.
   	
		create tt1.
		assign tt1_f1 = xxld_vend
					 tt1_f2 = xxld_part
					 tt1_f4 = xxld_zg_qty
					 tt1_f5 = xxld_tax_price
					 tt1_f6 = xxzgp_price
					 tt1_f7 = substring(string(xxld_year),3,2) + string(xxld_per,"99")
					 tt1_f8 = xxld_year
					 tt1_f9 = xxld_per
					 .
	end.
	
	find first tt1 no-lock no-error.
	if not avail tt1 then do:
		message "�޼�¼".
		next.
	end.
	
	loop1:
	repeat on error undo,retry:
		
		{xuview.i
    	     &buffer = tt1
    	     &scroll-field = tt1_f1
    	     &framename = "b"
    	     &framesize = 5
    	     &display1     = tt1_f1
    	     &display2     = tt1_f2
    	     &display3     = tt1_f4
    	     &display4     = tt1_f7
    	     &display5     = tt1_f5
    	     &display6     = tt1_f6
    	     &searchkey    = true
    	     &logical1     = false
    	     &first-recid  = first-recid
    	     &exitlabel = loop1
    	     &exit-flag = true
    	     &record-id = tt_recid
    	     &cursordown = " 		
                         "
    	     &cursorup   = " 
    	     							
                         "
    	     }
    
    	
		if keyfunction(lastkey) = "end-error" then do:
			update-yn = no.
      {pxmsg.i &MSGNUM=36 &ERRORLEVEL=1 &CONFIRM=update-yn}
       if update-yn = yes then next mainloop.
       else next loop1.
		end.
		
		if keyfunction(lastkey) = "go" then do:
			update-yn = yes.
      {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=update-yn}
      if update-yn = no then next loop1.
      for each tt1 no-lock,
      	each xxld_det where xxld_domain = global_domain	and xxld_vend = tt1_f1 and xxld_part = tt1_f2 
      		and xxld_year = tt1_f8 and xxld_per  = tt1_f9 :
      	if tt1_f6 > 0 then do:
      		/* ������ */
      		create xxtr_hist.
      		assign xxtr_domain = global_domain
								xxtr_site = site
								xxtr_year = yr
								xxtr_per	= per
								xxtr_vend = xxld_vend
								xxtr_type = "RCT-ZG"
								xxtr_sort = "IN"
								xxtr_part = xxld_part
								xxtr_tax_pct = xxld_tax_pct
								xxtr_price = xxld_tax_price
								xxtr_qty   = - xxld_zg_qty
								xxtr_amt   = - xxld_tax_amt
								xxtr_effdate  = today
								xxtr_time  = time
								xxtr_rmks  = "�ݹ�����"
								.
					
					/* SS - 100629.1 - B */
					decOldPrice = xxld_tax_price.
					/* SS - 100629.1 - E */
					
					/*�������ʼ�¼*/
					tnbr = "PO" + substring(string(yr,"9999"),3,2) + string(per,"99") .
					find last xxglt_det where xxglt_domain = global_domain and xxglt_ref begins tnbr no-error.
					if avail xxglt_det then tnbr = tnbr + string((int(substring(xxglt_ref,7,6)) + 1),"999999").
					else tnbr = tnbr + "000001".
				
					create 	xxglt_det.
					assign  xxglt_domain = global_domain
									xxglt_ref = tnbr
									xxglt_year = yr
									xxglt_per  = per
									xxglt_type = "POZG"
									xxglt_nbr  = xxld_nbr
									xxglt_line = xxld_line
									xxglt_effdate = today
									xxglt_date = today
									xxglt_price = xxld_price
									xxglt_part  = xxld_part
									xxglt_qty   = - xxld_zg_qty
									xxglt_amt   = - xxld_amt
									.      		
      		
      		xxld_price = tt1_f6 / ( 1 + xxld_tax_pct / 100 ).
      		xxld_tax_price = tt1_f6.
      		xxld_amt = xxld_zg_qty * xxld_price.
      		xxld_tax_amt = xxld_zg_qty * xxld_tax_price.
      		xxld_type = "����".
      		xxtr_glnbr = xxglt_ref.
      		
      		create xxtr_hist.
      		assign xxtr_domain = global_domain
								xxtr_site = site
								xxtr_year = yr
								xxtr_per	= per
								xxtr_vend = xxld_vend
								xxtr_type = "RCT-PO"
								xxtr_sort = "IN"
								xxtr_part = xxld_part
								xxtr_tax_pct = xxld_tax_pct
								xxtr_price = xxld_tax_price
								xxtr_qty   = xxld_zg_qty
								xxtr_amt   = xxld_tax_amt
								xxtr_effdate  = today
								xxtr_time  = time
								xxtr_rmks  = "�ݹ�����"
								.
      		
      		/*�������ʼ�¼*/
					tnbr = "PO" + substring(string(yr,"9999"),3,2) + string(per,"99") .
					find last xxglt_det where xxglt_domain = global_domain and xxglt_ref begins tnbr no-error.
					if avail xxglt_det then tnbr = tnbr + string((int(substring(xxglt_ref,7,6)) + 1),"999999").
					else tnbr = tnbr + "000001".
				
					create 	xxglt_det.
					assign  xxglt_domain = global_domain
									xxglt_ref = tnbr
									xxglt_year = yr
									xxglt_per  = per
									xxglt_type = "PO"
									xxglt_nbr  = xxld_nbr
									xxglt_line = xxld_line
									xxglt_effdate = today
									xxglt_date = today
									xxglt_price = xxld_price
									xxglt_part  = xxld_part
									xxglt_qty   = xxld_zg_qty
									xxglt_amt   = xxld_amt
									.      		
      		xxtr_glnbr = xxglt_ref.
      		
      		
      		/* SS - 100702.1 - B */
      		/* ��֮ǰ�ݹ�����Ĳ�����,�����﷢��ȥ */
      		create xxtr_hist.
      		assign xxtr_domain = global_domain
								xxtr_site = site
								xxtr_year = yr
								xxtr_per	= per
								xxtr_vend = xxld_vend
								xxtr_type = "iss-wo"   /* ��֮ǰ�ݹ�����Ĳ�����,�����﷢��ȥ */
								xxtr_sort = "out"
								xxtr_part = xxld_part
								xxtr_tax_pct = xxld_tax_pct
								xxtr_price = tt1_f6 - decOldPrice
								xxtr_qty   = 0
								xxtr_amt   = xxtr_price * (xxld_zg_qty - xxld_qty)
								xxtr_effdate  = today
								xxtr_time  = time
								xxtr_rmks  = "�ݹ�����"
								xxtr_glnbr = xxglt_ref
								.
      		/* SS - 100702.1 - E */
      		
      		/* SS - 100629.1 - B */
      		create xxtr_hist.
      		assign xxtr_domain = global_domain
								xxtr_site = site
								xxtr_year = yr
								xxtr_per	= per
								xxtr_vend = xxld_vend
								xxtr_type = "CY-ZGCL"   /* ����-�ݹ����� */
								xxtr_sort = "IN"
								xxtr_part = xxld_part
								xxtr_tax_pct = xxld_tax_pct
								xxtr_price = tt1_f6 - decOldPrice
								xxtr_qty   = 0
								xxtr_amt   = xxtr_price * xxld_zg_qty
								xxtr_effdate  = today
								xxtr_time  = time
								xxtr_rmks  = "�ݹ�����"
								xxtr_glnbr = xxglt_ref
								.
      		/* SS - 100629.1 - E */
      		
      		
      		/*�����ջ���¼*/
      		find first xxglpod_det where xxglpod_domain = global_domain and xxglpod_year = yr
						and xxglpod_per = per and xxglpod_nbr = xxld_nbr and xxglpod_line = xxld_line 
						and xxglpod_tax_pct = xxld_tax_pct and xxglpod_price  = xxld_tax_price
						and xxglpod_vend = xxld_vend and xxglpod_part = xxld_part no-error.
					if not avail xxglpod_det then do:
						create xxglpod_det.
						assign xxglpod_domain = global_domain
								 xxglpod_year   = yr
								 xxglpod_per    = per
								 xxglpod_nbr    = xxld_nbr
								 xxglpod_line   = xxld_line
								 xxglpod_vend   = xxld_vend
								 xxglpod_part   = xxld_part
								 xxglpod_curr   = "RMB"
								 xxglpod_tax_pct = xxld_tax_pct
								 xxglpod_price  = xxld_tax_price
								 xxglpod_qty    = xxld_zg_qty
								 xxglpod_amt    = xxld_tax_amt
								 xxglpod_type   = "����"
								 .
					end.
					else do:
						xxglpod_qty   = xxglpod_qty + xxld_zg_qty.
						xxglpod_amt   = xxglpod_amt + xxld_tax_amt.
					end.
      		xxld_type = "����".
      	end.
    	end. /* for each tt1 */
    	next mainloop.
		end.
		
	end. /* loop1 */
end. /* mainloop */	