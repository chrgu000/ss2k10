/*zzbmcstrp.p ���Ͳɹ��ɱ�����								*/
/* 8.5 F03 LAST MODIFIED BY LONG BO 2004/07/01				*/

/*GN61*/ {mfdtitle.i "d+ "}

def var parent like bom_parent.
/*Jch---*/
def var stdate like pc_start label "�ɱ�����".
def var endate like pc_start label "�ɱ�������" initial today.

def var effdate like tr_effdate.
define variable record as integer extent 100.
define variable comp like ps_comp.
define variable level as integer.
define variable maxlevel as integer format ">>>" label "���".
def var datecost like pc_start.
def var partcost as   decimal.

def var totcost as decimal.
/*
def var partcost like pc_amt.
*/
def var umcost   like pc_um.
datecost = 01/01/90.

      define new shared variable exch_rate   like exd_rate.
      define            variable ent_exch    like exd_ent_rate.
      
      define variable exp_p	as logic.
      define variable tmp_ex as decimal.
      define variable effp_date as date. /*�ɹ�������Ч����*/
      define variable tmp_per  as decimal. /*���ڼ��ɹ�����*/



def temp-table xxwk
	field parent like bom_parent
	field comp like ps_comp
	field desc1 like pt_desc1
	field desc2 like pt_desc2
	field ref like ps_ref
	field st	like si_site
	field ponbr like po_nbr
	field xxum like pod_um
	field sdate like ps_start
	field edate like ps_end
	field qty like ps_qty_per
	field vend like po_vend
	field pper as decimal /*�ɹ�����*/
	field pprice like pod_pur_cost /*�ɹ��۸�*/
	field monkind like pc_curr
	field pcost as decimal format ">>>,>>9.99" /*��λ�Ҽ۸�*/
	field rmks as char
	index comp comp.

def temp-table zzwk like xxwk.

def buffer yywk for zzwk.

/*G0XW*/ define            variable dummy_disc  like pod_disc_pct no-undo.
/*G0XW*/ define            variable pc_recno    as recid no-undo.
/*G0JN*/ define            variable newprice    like pod_pur_cost.


FORM /*GUI*/

	RECT-FRAME       AT ROW 1.4 COLUMN 1.25
	RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
	SKIP(.1)  /*GUI*/
	parent      colon 30
	effdate colon 30
	skip(1)
	exp_p	colon 30 label "BOMչ������Ͳ�(Y/N)" 

	SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

form 
	skip(1)
	"----------------------" colon 80
	totcost colon 90 label "�ܼ�"
	skip(1)
	"   �۸�(RMB) = �۸񵥼� �� ���� �� ��λ����ֵ �� ���� �� �ɹ����� �� 100 "
	skip(1)
	"   ��ע��I-���ڼ�   *-�����Ӧ�̹���   ***-�ɹ��ٷֱȴ�"
with frame c side-labels width 120 no-box.

	DEFINE VARIABLE F-a-title AS CHARACTER.
	F-a-title = " ѡ������ ".
	RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
	RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
	FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
	RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
	RECT-FRAME:HEIGHT-PIXELS in frame a =
	FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
	RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

	effdate = today.

	repeat:


		update parent effdate exp_p with frame a.

		find bom_mstr where bom_parent = parent no-lock no-error.
		if not available bom_mstr then do:
			message "�ò�Ʒ�ṹ���벻����,����������!" view-as alert-box error.
			next-prompt parent with frame a.
			undo,retry.
		end.

		find first ps_mstr use-index ps_parcomp where ps_par = parent
		no-lock no-error.
		if not available ps_mstr then do:
			message "�ø�����޲�Ʒ�ṹ,����������!" view-as alert-box error.
			undo,retry.
		end.

		if effdate = ? then effdate = today.

		{mfselprt.i "printer" 132}

		for each xxwk:
			delete xxwk.
		end.
		totcost = 0.
		
		assign
		level = 1
		comp = parent
		maxlevel = min(maxlevel,99).

		repeat: /*for expand the ps*/
			if not available ps_mstr then do:
				repeat:
					level = level - 1.
					if level < 1 then leave.
					find ps_mstr where recid(ps_mstr) = record[level]
					no-lock no-error.
					comp = ps_par.
					find next ps_mstr use-index ps_parcomp where ps_par = comp
					no-lock no-error.
					if available ps_mstr then leave.
				end.
			end.
	
			if level < 1 then leave.
	
			if (ps_start = ? or ps_start <= effdate)
			and (ps_end = ? or effdate <= ps_end) then do:
	
				find pt_mstr where pt_part = ps_comp no-lock no-error.
				find ptp_det where ptp_site = ps__chr01 and ptp_part = ps_comp no-lock no-error.
		
				if available pt_mstr and
				(	(exp_p and ( (available ptp_det and pt_pm_code = "P")
					             or
					             (not available ptp_det and pt_pm_code = "P")
					           )
					)
					or
					(not exp_p and ( (available ptp_det and not ptp_phantom)
					                 or
					                 (not available ptp_det and not pt_phantom)
					               )				
					)
				)
				  then do:
					find first xxwk where xxwk.comp = ps_comp no-error.
					if not available xxwk then do:
						/*
						if (available ptp_det and pt_pm_code = "P")
						or (not available ptp_det and pt_pm_code = "P") then do: */
						create xxwk.
						assign xxwk.parent = parent
							xxwk.comp = ps_comp
							xxwk.desc1 = pt_desc1
							xxwk.desc2 = pt_desc2
							xxwk.xxum  = pt_um
							xxwk.ref = ps_ref
							xxwk.sdate = ps_start
							xxwk.edate = ps_end
							xxwk.qty = ps_qty_per
							xxwk.st	 = ps__chr01.  /*site*/
						/*end.*/
					end.
					else
						xxwk.qty = xxwk.qty + ps_qty_per.
				end.
	
				record[level] = recid(ps_mstr).
	
				if level < maxlevel or maxlevel = 0
				/*and (available ptp_det and ptp_pm_code = "P") */
			 	and 
			 	( (exp_p)
			 	  or ((not exp_p and
			 	            ( (available ptp_det and ptp_phantom) or (not available ptp_det and available pt_mstr and pt_phantom)
				            or not available pt_mstr
				            )
				     ))
				) 
			 	then do:
					comp = ps_comp.
					level = level + 1.
					find first ps_mstr use-index ps_parcomp where ps_par = comp
					no-lock no-error.
				end.
				else do:
					find next ps_mstr use-index ps_parcomp where ps_par = comp
					no-lock no-error.
				end.
			end.
			else do:
				find next ps_mstr use-index ps_parcomp where ps_par = comp
				no-lock no-error.
			end.
	
		end. /*expand the ps*/
	

		for each zzwk:
			delete zzwk.
		end.
		
		/*begin���㹩Ӧ�̱���*/
		for each xxwk:
			/*��Ӧ�̺Ͳɹ�����*/
			find first scx_ref no-lock where scx_part = xxwk.comp
/*test*/			and scx_shipto = xxwk.st no-error.
			if not available scx_ref then do:  /*�����ڲɹ��ճ�*/
				create zzwk.
				buffer-copy xxwk to zzwk.
				find first ptp_det no-lock where ptp_part = xxwk.comp and
				ptp_site = xxwk.st no-error.
				find pt_mstr no-lock where pt_part = xxwk.comp no-error.
				if available ptp_det then
					assign
					zzwk.vend = ptp_vend
					zzwk.pper = 100.
				else
					assign
					zzwk.vend = pt_vend
					zzwk.pper = 100.
				zzwk.rmks = "I".   /*���ڼ�*/
			end.
			else do:
				/*�Ҳɹ�������Ч����*/				
				find last qad_wkfl no-lock where qad_key1 = "poa_det"
/*test*/		and qad_charfld[3] = xxwk.st and  qad_datefld[1] <= effdate
				and qad_charfld[2] = xxwk.comp
				no-error.
				if available qad_wkfl then effp_date = qad_datefld[1].
		
				for each scx_ref no-lock where scx_part = xxwk.comp
			/*test*/	and scx_shipto = xxwk.st break by scx_part :
					create zzwk.
					buffer-copy xxwk to zzwk.
					find first po_mstr no-lock where po_nbr = scx_po no-error.
					if available po_mstr then do:
						assign
						      zzwk.vend 	= po_vend		                                  
						 /*     zzwk.monkind  = po_curr
						      zzwk.ponbr	= po_nbr  */
						      .
						find last qad_wkfl no-lock where qad_key1 = "poa_det"
						and qad_charfld[1] = po_nbr and qad_charfld[2] = xxwk.comp
						/*test*/ and qad_charfld[3] = xxwk.st  and  qad_datefld[1] = effp_date /*<= effdate*/ no-error.
						if available qad_wkfl then
							zzwk.pper = qad_decfld[1].  /*�ɹ�����*/
						else
							zzwk.pper = 0.
					end.
					if not first-of(scx_part) then
						zzwk.rmks = "*".
				end.
			end.
		end.					
		/*end���㹩Ӧ�̱���*/

		/*���ɹ���������*/
		for each zzwk break by zzwk.comp:
			if first-of(zzwk.comp) then
				tmp_per = 0.
			tmp_per = tmp_per + zzwk.pper.
			if last-of(zzwk.comp) then do:
				if tmp_per <> 100 then do:
					zzwk.rmks = "***".
				end.
			end.
		end.
		
		/*�۸�*/
		for each zzwk:						
		
			find last pc_mstr no-lock
			where substring(pc_list,1,7) = zzwk.vend
			and pc_part = zzwk.comp
			and pc_start <= effdate 
			and (pc_expire > effdate or pc_expire = ?)
			no-error.
			if available pc_mstr then do:
				zzwk.monkind = pc_curr.
				zzwk.pprice = pc_amt[1].
				/*��λ*/
				tmp_ex = 1.
				if pc_um <> zzwk.xxum then do:
					find um_mstr where
					um_um = pc_um and um_alt_um = zzwk.xxum 
					and um_part = zzwk.comp no-lock no-error.
					if available um_mstr then do:
						tmp_ex = um_conv.
					end.
					else do:
						find um_mstr where
						um_alt_um = pc_um and um_um = zzwk.xxum and um_part = zzwk.comp no-lock no-error.
						if available um_mstr then do:
							tmp_ex = 1 / um_conv.
						end.
						else do:
							find um_mstr where
							um_um = pc_um and um_alt_um = zzwk.xxum no-lock no-error.
							if available um_mstr then do:
								tmp_ex = um_conv.
							end.
							else do:					
								find um_mstr where
								um_alt_um = pc_um and um_um = zzwk.xxum no-lock no-error.
								if available um_mstr then do:
									tmp_ex = 1 / um_conv.
								end.
								else do:
									message string("��λ���㲻����" + um_um + zzwk.xxum).
								end.
							end.
						end.
					end.
				end.
				/*�һ���*/
				if zzwk.monkind <> "RMB" then do:
					find first exd_det no-lock where
					exd_curr = "RMB" and exd_from_curr = zzwk.monkind 
					and exd_eff_date <= effdate and exd_end_date >= effdate no-error.
					if available exd_det then
						tmp_ex = tmp_ex * exd_ent_rate.
					else do:
						find first exd_det no-lock where
						exd_curr = zzwk.monkind and exd_from_curr =  "RMB"
						and exd_eff_date <= effdate and exd_end_date >= effdate no-error.
						if available exd_det then
							tmp_ex = tmp_ex / exd_ent_rate.
						else 
							message string("�һ��ʲ�����:" + zzwk.monkind).
					end.
				end.						
				/*�۸�*/
				zzwk.pcost = zzwk.pprice * tmp_ex * zzwk.qty * zzwk.pper / 100.
				totcost = totcost + zzwk.pcost.
			end.
		end.
			
			
		find first xxwk no-error.
		if available xxwk then
		disp xxwk.parent label "����" with side-label width 200 stream-io.
		
		for each zzwk break by zzwk.comp by zzwk.pcost:
						/**--------------------------**********************/
			find first yywk where
			yywk.comp = zzwk.comp and yywk.rmks <> "" no-lock no-error.
			
			disp 
			SPACE(1)
			zzwk.comp zzwk.desc1 label "���������"
			zzwk.desc2 label "���������"
			zzwk.ref 
			zzwk.qty label "����"
			zzwk.xxum label	"��λ" 
			zzwk.vend label "��Ӧ��" 
			zzwk.pper label "�ɹ�����"
			zzwk.pprice label "�۸񵥼�"
			zzwk.monkind label "��"
			zzwk.pcost label "�۸�(RMB)" 
			(if available yywk then yywk.rmks else "") @ zzwk.rmks label "��ע"
			space (1)
			with width 200 stream-io.

		end. /*for each xxwk*/
		
		disp  
		totcost with frame c.

		{mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


	end. /*repeat*/
