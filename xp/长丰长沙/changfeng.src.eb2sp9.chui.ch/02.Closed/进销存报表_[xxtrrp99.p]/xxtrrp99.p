/*By: Randy Li 09/07/13 ECO: *SS 20090713* */
/* ss - 100412.1 By: Randy Li */
/* ss - 100426.1 By: Randy Li */
/* SS - 100625.1  By: Roger Xiao */
/* SS - 100726.1  By: Roger Xiao */  /*ί���(M���͵�����),����ȡ�ܳɱ�*/
/*-Revision end---------------------------------------------------------------*/


/* SS - 100625.1 - RNB
�޸�����:
������������������̵���ӯ����
���ڳ��������������̵��̿�����
��ӯ����ֳ�:��ӯ���̿�
�ƻ�����: ȡ��ȡί��ĵ���
SS - 100625.1 - RNE */


/* ���е�xxtrrp99.p���߼��޸Ķ�Ҫ��Ӧ�޸�xxtrrp098.p*/
{mfdtitle.i "100726.1"}

DEFINE VARIABLE part like mrp_part. 
DEFINE VARIABLE part2 like mrp_part.
DEFINE VARIABLE date1 as date.      
DEFINE VARIABLE date2 as date.      
DEFINE VARIABLE loc like tr_loc.    
DEFINE VARIABLE loc1 like tr_loc.
DEFINE VARIABLE qcqty like tr_qty_loc.	/*�ڳ���*/
DEFINE VARIABLE qmqty like tr_qty_loc.	/*��ĩ��*/
DEFINE BUFFER ptmstr for pt_mstr.
/* SS - 100412.1 - B */
DEFINE VARIABLE type like pt_part_type .
DEFINE VARIABLE type1 like pt_part_type .
DEFINE VARIABLE cmmt like code_cmmt .
/* SS - 100412.1 - E */
/* SS - 100426.1 - B */
DEFINE VARIABLE price like sct_mtl_tl .
/* SS - 10026.1 - E */
DEFINE TEMP-TABLE tmp_mstr 
	field tmp_part like pt_part			/*���ϱ���*/
	field tmp_loc like tr_loc			/*��λ*/
	/* SS - 100412.1 - B */
	field tmp_type like pt_part_type         /*��������*/
	/* SS - 100412.1 - E */
	field tmp_qty1 like ld_qty_oh		/*���ڽ������ڵ��������������*/
	field tmp_qty2 like ld_qty_oh		/*���ڽ������ڵĳ�������ĳ�����*/
	field tmp_qty3 like ld_qty_oh		/*�������*/
	field tmp_qty4 like ld_qty_oh		/*���ڳ���*/
	field tmp_qty5 like ld_qty_oh		/*�ɹ����*/
	field tmp_qty6 like ld_qty_oh		/*�ɹ��˻�*/
	field tmp_qty7 like ld_qty_oh		/*�ƻ������*/
	field tmp_qty8 like ld_qty_oh		/*ת�����*/
/* SS - 100625.1 - B 
	field tmp_qty9 like ld_qty_oh		/*�̵�ӯ��*/
   SS - 100625.1 - E */
/* SS - 100625.1 - B */
	field tmp_qty91 like ld_qty_oh		/*��ӯ*/
	field tmp_qty92 like ld_qty_oh		/*�̿�*/
/* SS - 100625.1 - E */

	field tmp_qty10 like ld_qty_oh		/*��������*/
	field tmp_qty11 like ld_qty_oh		/*���۳���*/	
	field tmp_qty12 like ld_qty_oh		/*�ƻ������*/
	field tmp_qty13 like ld_qty_oh		/*ת�ֳ���*/
	field tmp_qty14 like ld_qty_oh		/*�����*/
	/* SS - 100412.1 - B */
	field tmp_qty15 like ld_qty_oh		/*�������*/
	/* SS - 100412.1 - E */
	.

form 
	date1					colon 15
	date2					colon 45
	part					colon 15
	part2 label {t001.i}	colon 45 
	loc						colon 15
	loc1					colon 45
	/* SS - 100412.1 - B */
	type	                colon 15
	type1					colon 45
	/* SS - 100412.1 - E */
	skip(1)

with frame a side-labels width 80 attr-space.

setFrameLabels(frame a:handle).

{wbrp01.i}

REPEAT ON ENDKEY UNDO, LEAVE: 
	if part2 = hi_char then part2 = "".
	if date1 = low_date then date1 = ?.
	if date2 = hi_date  then date2 = ?.
	if loc1 = hi_char then loc1 = "".
	/* SS - 100412.1 - B */
	if type1 = hi_char then type1 = "" .
	/* SS - 100412.1 - E */
	
	IF c-application-mode <> 'web':u THEN

	/* SS - 100412.1 - B
	update date1 date2 part part2 loc loc1 WITH FRAME a.
	SS - 100412.1 - E */

	/* SS - 100412.1 - B */
	update date1 date2 part part2 loc loc1 type type1 WITH FRAME a.
	/* SS - 100412.1 - E */

	{wbrp06.i &command = UPDATE
	
	/* SS - 100412.1 - B
		&fields = "date1 date2 part part2 loc loc1 "
	SS - 100412.1 - E */

		/* SS - 100412.1 - B */
		&fields = "date1 date2 part part2 loc loc1 type type1"
		/* SS - 100412.1 - E */
		&frm = "a"}
	if part2 = "" then part2 = hi_char.
	if date1 = ? then  date1 = low_date.
	if date2 = ? then date2 = hi_date.
	if loc1 = "" then loc1 = hi_char.
	/* SS - 100412.1 - B */
	if type1 = "" then type1 = hi_char .
	/* SS - 100412.1 - E */

	{mfselprt.i "printer" 132}

	for each tmp_mstr :
		delete tmp_mstr .
	end.
	/* SS - 100412.1 - B
	for each  pt_mstr where pt_part >= part
		and pt_part <= part2 no-lock:
	SS - 100412.1 - E */

	/* SS - 100412.1 - B */
	for each  pt_mstr where pt_part >= part
		and pt_part <= part2
		and pt_part_type >= type
		and pt_part_type <= type1
		no-lock:
	/* SS - 100412.1 - E */

		/****find first tr_hist where tr_part = pt_part 
			and tr_effdate >= date1
			and tr_loc >= loc
			and tr_loc <= loc1
			no-lock no-error
			.
		if avail tr_hist then do :
		*****/ /* SS - 090706.1 - B
		SS - 090706.1 - E */
			for each tr_hist where tr_part = pt_part
				and tr_effdate >= date1
				and tr_loc >= loc
				and tr_loc <= loc1
				and tr_qty_loc <> 0
				and tr_ship_type = ""
				no-lock 
				/****break by tr_part by tr_loc by tr_effdate 
				****/	/* SS - 090706.1 - B
				SS - 090706.1 - E */
				:
				find first tmp_mstr where tmp_part = tr_part and tmp_loc = tr_loc no-error .
				if not avail tmp_mstr then do :
					create tmp_mstr .
					assign 
						tmp_part = tr_part
						tmp_loc = tr_loc
						/* SS - 100412.1 - B */
						tmp_type = pt_part_type
						/* SS - 100412.1 - E */
						.
				end.
				if tr_effdate <= date2 then do :
					if ( tr_type begins "RCT" or tr_type = "CN-RCT" 
/* SS - 100625.1 - B 
                       or (tr_type = "CYC-RCNT" and tr_qty_loc > 0 ) 
   SS - 100625.1 - E */
                       or tr_type = "TAG-CNT" 
                       or tr_type = "ISS-PRV" or tr_type = "ISS-RV" or (tr_type = "RCT-WO" and tr_program = "icunrc01.p")) 
						then tmp_qty3 = tmp_qty3 + tr_qty_loc.
/* SS - 100625.1 - B 
						else tmp_qty4 = tmp_qty4 - tr_qty_loc.
   SS - 100625.1 - E */
/* SS - 100625.1 - B */
						else if (not tr_type begins "CYC") then tmp_qty4 = tmp_qty4 - tr_qty_loc.
/* SS - 100625.1 - E */
					if ( (tr_type = "RCT-PO" and tr_qty_loc > 0) or (tr_type = "RCT-WO" and tr_program = "icunrc01.p") or (tr_type = "ISS-WO" and tr_program = "icunrc01.p")) then tmp_qty5 = tmp_qty5 + tr_qty_loc.
					if ( tr_type = "ISS-PRV" or tr_type = "ISS-RV" or (tr_type = "RCT-PO" and tr_qty_loc <= 0) ) then tmp_qty6 = tmp_qty6 + tr_qty_loc.
					if ( tr_type = "RCT-UNP" ) then tmp_qty7 = tmp_qty7 + tr_qty_loc.
					if ( tr_type = "RCT-TR" ) then tmp_qty8 = tmp_qty8 + tr_qty_loc.

					/* SS - 100412.1 - B */
					if (tr_type = "RCT-WO" and tr_program <> "icunrc01.p") then tmp_qty15 = tmp_qty15 + tr_qty_loc .
					/* SS - 100412.1 - E */

/* SS - 100625.1 - B 
					if ( tr_type = "CYC-RCNT" or tr_type = "CYC-CNT" ) then tmp_qty9 = tmp_qty9 + tr_qty_loc.
   SS - 100625.1 - E */
/* SS - 100625.1 - B */
					if ( tr_type = "CYC-RCNT" or tr_type = "CYC-CNT" ) then do:
                        if tr_qty_loc >= 0 then tmp_qty91 = tmp_qty91 + tr_qty_loc.
                        if tr_qty_loc <  0 then tmp_qty92 = tmp_qty92 - tr_qty_loc.
                    end.
/* SS - 100625.1 - E */

					if (tr_type = "ISS-WO" and tr_program <> "icunrc01.p") then tmp_qty10 = tmp_qty10 - tr_qty_loc.
					if (tr_type = "ISS-SO" ) then tmp_qty11 = tmp_qty11 - tr_qty_loc.
					if (tr_type = "ISS-UNP" ) then tmp_qty12 = tmp_qty12 - tr_qty_loc.
					if (tr_type = "ISS-TR" ) then tmp_qty13 = tmp_qty13 - tr_qty_loc.
				end.

				if tr_effdate > date2 then do :
					if ( tr_type begins "RCT" or tr_type = "CN-RCT" or (tr_type = "CYC-RCNT" and tr_qty_loc > 0 )or tr_type = "TAG-CNT" or tr_type = "ISS-PRV" or tr_type = "ISS-RV" or (tr_type = "RCT-WO" and tr_program = "icunrc01.p")) 
					then tmp_qty1 = tmp_qty1 + tr_qty_loc.
					else tmp_qty2 = tmp_qty2 - tr_qty_loc.
				end.
			/***
			end.
			****/	/* SS - 090706.1 - B
			SS - 090706.1 - E */
		end.
		for each ld_det where ld_part = pt_part
			and ld_loc >= loc
			and ld_loc <= loc1
			and ld_qty_oh <> 0
			no-lock:
			find first tmp_mstr where tmp_part = ld_part and tmp_loc = ld_loc  no-error .
			if not avail tmp_mstr then do :
				create tmp_mstr .
				assign 
					tmp_part = ld_part 
					tmp_loc = ld_loc
					/* SS - 100412.1 - B */
					tmp_type = pt_part_type
					/* SS - 100412.1 - E */
					.
			end.
			tmp_qty14 = tmp_qty14 + ld_qty_oh .
		end.
	end.

	for each tmp_mstr where no-lock break by tmp_part by tmp_loc:
		/*�����ڳ��������*/
		/* SS - 100426.1 - B */
		price = 0 .
		/* SS - 100426.1 - E */
		qmqty = 0 .
		qcqty = 0 .
		qmqty = tmp_qty14 - tmp_qty1 + tmp_qty2 .
		qcqty = tmp_qty14 - tmp_qty1 + tmp_qty2 - tmp_qty3 + tmp_qty4 /* SS - 100625.1 - B */ - tmp_qty91 + tmp_qty92. /* SS - 100625.1 - E */

		find first pt_mstr where pt_part = tmp_part no-lock no-error .
		find first sct_det where sct_sim = "standard" and sct_part = tmp_part no-lock no-error . 
		/* SS - 100412.1 - B */
		find first loc_mstr where loc_loc= tmp_loc no-lock no-error .
		find first code_mstr where code_fldname = "pt_part_type" and code_value = tmp_type no-lock no-error .
		cmmt = if avail code_mstr then code_cmmt else "" .
		/* SS - 100426.1 - B */
		price = sct_mtl_tl + sct_mtl_ll .
/* SS - 100625.1 - B 
		if pt_pm_code = "M" then do :
			find first ro_det where ro_routing = tmp_part and ro_op = 88 no-lock no-error .
		if avail ro_det then price = sct_sub_tl + sct_sub_ll .
		end.
   SS - 100625.1 - E */
/* SS - 100726.1 - B */
if pt_pm_code = "M" then price = sct_cst_tot .
/* SS - 100726.1 - E */

		/* SS - 100426.1 - E */
		/* SS - 100412.1 - E */
		display
			/* SS - 100412.1 - B */
			tmp_type														column-label "��������" format "x(5)"
			cmmt															column-label "����˵��" format "x(12)"
			/* SS - 100412.1 - E */
			tmp_loc															column-label "��λ" format "x(4)"
			/* SS - 100412.1 - B */
			loc_desc														column-label "��λ����"	
			/* SS - 100412.1 - E */
			tmp_part														column-label "���ϱ���"
			trim (pt_desc1) + trim (pt_desc2)								column-label "��������" format "x(24)"
			/* SS - 100426.1 - B
			sct_mtl_tl + sct_mtl_ll	+ sct_sub_tl + sct_sub_ll				column-label "�ƻ�����"
			SS - 100426.1 - E */
			/* SS - 100426.1 - B */
			price															column-label "�ƻ�����"
			/* SS - 100426.1 - E */
			qcqty															column-label "�ڳ����"
			tmp_qty3														column-label "�������"	
			tmp_qty4														column-label "���ڳ���"
			qmqty															column-label "��ĩ���"
			tmp_qty5														column-label "�ɹ����"
			tmp_qty6														column-label "�ɹ��˻�"

			/* SS - 100412.1 - B */
			tmp_qty15														column-label "�������"
			/* SS - 100412.1 - E */

			tmp_qty7														column-label "�ƻ������"
			tmp_qty8														column-label "ת�����"
/* SS - 100625.1 - B 
			tmp_qty9														column-label "�̵�ӯ��"
   SS - 100625.1 - E */
/* SS - 100625.1 - B */
			tmp_qty91														column-label "�̵���ӯ"
			tmp_qty92														column-label "�̵��̿�"
/* SS - 100625.1 - E */
			tmp_qty10														column-label "��������"
			tmp_qty11														column-label "���۳���"
			tmp_qty12														column-label "�ƻ������"
			tmp_qty13														column-label "ת�ֳ���"
		with stream-io	width 320.
	end .
	{mfreset.i}
	{mfgrptrm.i}
END.

{wbrp04.i &frame-spec = a}
