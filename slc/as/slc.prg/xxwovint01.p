/* Creation: eB21SP3 Chui Last Modified: 20081011 By: Davild Xu *ss-20081011.1*/
/* SS - 090402.1 By: Neil Gao */

{mfdeclre.i}  
{gplabel.i} 

define new shared var site like pt_site.
define var stdate as date label "����".
define var date1 as date.
define var date2 as date.
define var sonbr  like so_nbr.
define var sonbr1 like so_nbr.
define var ord		like so_ord_date.
define var ord1		like so_ord_date.
define var line   like ln_line.
define var line1  like ln_line.
define var xxdate1 as date.
define var i as int.
define new shared variable prline   like  rps_line.
define new shared variable line_rate      like lnd_rate.
define var tt_recid as recid no-undo.
define var first-recid as recid no-undo.
define new shared variable part         like seq_part.
define new shared variable hours          as   decimal extent 4.
define new shared variable cap            as   decimal extent 4.
define variable sw_reset     like mfc_logical. 
define var tmpqty like ld_qty_oh.
define var tmppick like ld_qty_oh.
define var tmpqty1 as int. /* ȱ������ */
define var tmpqty2 like ld_qty_oh. /* ȱ������ */
define var inpqty like ld_qty_oh.
define var update-yn as logical.
DEFINE VARIABLE tmp_integer as integer .	/*---Add by davild 20080303.1*/
define var tothours as decimal.

define variable errorst        as logical no-undo.
define variable errornum       as integer no-undo.
define variable v_number       as char  no-undo.
define variable v_id		as int   no-undo.
define variable v_from         as int   no-undo.
define variable fstnub         like xxsovd_id.
DEFINE VARIABLE yy as logi .	/*---Add by davild 20080303.1*/
/*SS 20090306 - B*/
define variable stnb as int.
/*SS 20090306 - E*/

define variable new_priority   as   decimal no-undo.
	DEFINE VARIABLE vchr_filename_in AS CHARACTER.
	DEFINE VARIABLE vchr_filename_out AS CHARACTER.	
	DEFINE VARIABLE vlog_fail_flag AS LOGICAL.

	vchr_filename_in = "./ssi" + mfguser.
	vchr_filename_out = "./sso" + mfguser.

define temp-table xuseq_mstr
	field xuseq_site like xxseq_site
	field xuseq_priority like xxseq_priority
	field xuseq_ii like xxseq_priority
  field xuseq_wod_lot like xxseq_wod_lot
  field xuseq_wod_qty like xxseq_qty_req
  field xuseq_sod_nbr like xxseq_sod_nbr
  field xuseq_sod_line like xxseq_sod_line   
  field xuseq_due_date like xxseq_due_date   /*�ɹ�����*/
  field xuseq_rel_date like xxseq_due_date   /*��������*/
  field xuseq_line like xxseq_line       
  field xuseq_part like xxseq_part       
  field xuseq_qty_req like xxseq_qty_req
  field xuseq_qty_pick like xxseq_qty_req
  field xuseq_pick_rmks as char
  field xuseq_qty2 like xxseq_qty_req
  field xuseq_chgtype as char
  field xuseq_shift1 like xxseq_shift1
  field xuseq_time like wo__Dec01
  field xuseq_status as char format "x(1)"
  field xuseq_vined as char format "x(1)"
  index xuseq_ii
  xuseq_ii
  index xuseq_priority
  xuseq_priority
  index idx3 xuseq_vined xuseq_due_date xuseq_line xuseq_time
  .

define buffer T1 for xxseq_mstr.
DEFINE VARIABLE strQianBaWei as char .
DEFINE VARIABLE strShiShiYi as char .

form
   site     colon 12 label "�ص�"
   date1 		colon 12 label "�ɹ�����" 
	date2		colon 45 label "��"
   line     colon 12   label "������" format "x(3)"
	line1  colon 45 label "��" format "x(3)"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS 
setFrameLabels(frame a:handle).*/


form
   xuseq_ii   column-label "���" format ">>>>>9.9"
   xuseq_due_date   column-label "�ɹ�����"
   xuseq_line       column-label "��" format "x(3)"
   xuseq_part       column-label "���Ϻ�"
   xuseq_qty_req    column-label "����"
/*
   xuseq_qty_pick   column-label "���׿��"
   xuseq_pick_rmks  column-label "ȱ�����"
   xuseq_status     column-label "R"*/
	xuseq_wod_lot	column-label "����ID"
	xuseq_sod_nbr	column-label "���۵���"
	xuseq_sod_line	column-label "��" format ">>9"
	xuseq_vined	column-label "*" format "x(1)"
with frame d down no-attr-space width 80
title color normal (getFrameTitle("AVAILABLE_SEQUENCE_RECORDS",34)).
/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).
	
/* DISPLAY */
view frame a.


stdate = today.
{gprunp.i "xxproced" "p" "getglsite" "(output site)"}

   date1 = today - 1 .	/*---Add by davild 20080303.1*/
	date2 = today .		/*---Add by davild 20080303.1*/

mainloop:
repeat with frame a:
   
   if date1	 = low_date then date1  = ?.
   if date2  = hi_date  then date2 = ?.
   if line1  = hi_char then line1  = "".


   update 
   	site 
   	date1	date2
   	line 	line1
   with frame a.
   
   if date1 = ? then date1 = low_date.
   if date2 = ? then date2 = hi_date.
   if line1 = "" then line1 = hi_char.
	 
   empty temp-table xuseq_mstr.
   
   i = 1.
   
   for each xxseq_mstr where xxseq_domain = global_domain 
    and xxseq_site = site and xxseq_user1 = "R"
   	/*and xxseq_due_date >= date1 and xxseq_due_date <= date2 */	/*---Remark by davild 20080303.1*/
   	and xxseq_due_date >= date1 - 60 and xxseq_due_date <= hi_date	/*---Add by davild 20080303.1*/ 
   	and xxseq_line >= line and xxseq_line <= line1 
   	/*and xxseq_qty_req > xxseq_mode_qty */	/*---Remark by davild 20080303.1*/
		no-lock
   	by xxseq_due_date by xxseq_line by xxseq_shift4:
			/*---Add Begin by davild 20080303.1*/
   		find first wo_mstr where wo_domain = global_domain and wo_lot = xxseq_wod_lot 
				and wo_rel_date >= date1 and wo_rel_date <= date2				
				no-lock no-error.
			if not avail wo_mstr then next .
			/*---Add End   by davild 20080303.1*/
		
		find first sod_det where sod_domain = global_domain and sod_nbr = xxseq_sod_nbr 
   			and sod_line = xxseq_sod_line 
			and sod_part = xxseq_part no-lock no-error.
   		if not avail sod_det then next .	
			if xxseq_mstr.xxseq_line begins "C" then next .	/*---Add by davild 20080303.1*/

   		create	xuseq_mstr.
   		assign	xuseq_ii       = i
				xuseq_site     = xxseq_mstr.xxseq_site
				xuseq_priority = xxseq_mstr.xxseq_priority
				xuseq_due_date = wo_rel_date		/*--�ɹ�����-Add by davild 20080303.1*/
				xuseq_rel_date = xxseq_mstr.xxseq_due_date	/*--��������-Add by davild 20080303.1*/
				xuseq_time	   = wo__dec01 /*---Add by davild 20080303.1*/
				xuseq_line     = xxseq_mstr.xxseq_line
				xuseq_part     = xxseq_mstr.xxseq_part
				xuseq_qty_req  = xxseq_mstr.xxseq_qty_req
				xuseq_wod_qty  = xxseq_mstr.xxseq_qty_req
				xuseq_wod_lot  = xxseq_mstr.xxseq_wod_lot
				xuseq_sod_nbr  = xxseq_mstr.xxseq_sod_nbr 
				xuseq_sod_line = xxseq_mstr.xxseq_sod_line
				xuseq_shift1   = xxseq_mstr.xxseq_shift1.
		 	i = i + 1.
			if xxseq_mstr.xxseq_qty_req > xxseq_mstr.xxseq_mode_qty then assign xuseq_vined = " " . else assign xuseq_vined = "*" .
    end.
	
	i = 1.
    for each xuseq_mstr by xuseq_vined by xuseq_due_date by xuseq_line by xuseq_time:
		assign xuseq_ii = i .
		i = i + 1 .
	end.
	

   find first xuseq_mstr no-lock no-error.
   if not avail xuseq_mstr then next mainloop.
      
   view frame d.
   pause 0.
   sw_reset = yes.
   scroll_loop:
   repeat with frame d:
      if sw_reset then do:
      end.
      do transaction:	
   			{xxrescrad.i xuseq_mstr "use-index xuseq_ii" xuseq_ii
            "xuseq_ii 
			 xuseq_due_date 
			 xuseq_line 
			 xuseq_part 
			 xuseq_qty_req 
			 xuseq_wod_lot	
			 xuseq_sod_nbr	
			 xuseq_sod_line 
			 xuseq_vined
            "
            xuseq_ii d
            "xuseq_site = site"
            " "
            " find first pt_mstr where pt_domain = global_domain and pt_part = xuseq_part no-lock no-error.
            	if avail pt_mstr then message pt_desc1."
            " find first pt_mstr where pt_domain = global_domain and pt_part = xuseq_part no-lock no-error.
            	if avail pt_mstr then message pt_desc1."
            }
      end.
      
      if keyfunction(lastkey) = "end-error" then do:
      	update-yn = no.
        {pxmsg.i &MSGNUM=36 &ERRORLEVEL=1 &CONFIRM=update-yn}
        if update-yn = yes then leave.
      end.

	  /* If you press return then in modify mode */
      if keyfunction(lastkey) = "return" and recno <> ?
      then do transaction on error undo, retry:
		/*---Add Begin by davild 20080303.1*/
		if avail xuseq_mstr and xuseq_wod_lot <> "" 
			and xuseq_vined = "*"	
		then do:
			message "�Ѿ���������!" view-as alert-box .
			next .
		end.
		/*---Add End   by davild 20080303.1*/
      	if avail xuseq_mstr and xuseq_wod_lot <> "" 
			and xuseq_vined <> "*"	/*---Add by davild 20080303.1*/
			then do:
			find first wo_mstr where wo_domain = global_domain and wo_lot = xuseq_wod_lot 
				and wo_status = "R" no-lock no-error.
			if avail wo_mstr then do:
				
				find first sod_det where sod_domain = global_domain and sod_nbr = xuseq_sod_nbr
					and sod_line = xuseq_sod_line no-lock no-error.
				if not avail sod_det then do:
					message "����:" xuseq_sod_nbr "��:" xuseq_sod_line "������" . 
					next .	
				end.
				else do:
					/*���� ȡֵ*/
					assign 
						strQianBaWei = trim(sod__chr02) .
						strShiShiYi  = trim(sod__chr08) .
						stnb				 = int(sod__chr09) no-error.
				end.
				if not (length(strQianBaWei) = 8 and length(strShiShiYi) = 2) then do:
					message "������VIN�������ȷ,ǰ׺Ϊ8λ ������Ϊ2λ".
					next .
				end.
				
/*SS 20081202 - B*/
				if stnb = 0 then do:
					find first xxslc_mstr where xxslc_domain = global_domain
						and xxslc_QianBaWei = strQianBaWei	and xxslc_ShiShiYi = strShiShiYi no-error.
					if avail xxslc_mstr then
						message "VIN��ʼ��Ϊ" + strQianBaWei + "*" + strShiShiYi + string(xxslc_last_number + 1 ,"999999") + ", ȷ������VIN(����)��?" update yy .
					else
						message "VIN��ʼ��Ϊ" + strQianBaWei + "*" + strShiShiYi + "000010" + ", ȷ������VIN(����)��?" update yy .
				end.
				else do:
/* SS 090703.1 - B */
/*
					for each xxsovd_det where xxsovd_domain = global_domain and xxsovd_nbr = xuseq_sod_nbr 
						and xxsovd_line = int(xuseq_sod_line) and xxsovd_wolot <> "" no-lock:
						stnb = stnb + 1.
					end.
*/
/* SS 090703.1 - E */
					message "VIN��ʼ��Ϊ" + strQianBaWei + "*" + strShiShiYi + string(stnb,"999999") + ", ȷ������VIN(����)��?" update yy .
				end.
/*SS 20081202 - E*/
				if yy = no then 
					next .	
				
				fstnub = "".
				v_id = wo_qty_ord.
				v_from = v_id.
				do v_id = v_id to 1 by -1 :
					/*�õ�17 λ VIN��--BEGIN*/
					{gprun.i ""xxwovintgetvin.p"" 
					"(input strQianBaWei, 
					input strShiShiYi , 
					input stnb,
					output v_number)"}
					if v_number = "" then do:
						message "�������������¸��Ĺ�������" view-as alert-box .
						undo,leave.
					end.
					/*�õ�17 λ VIN��--END*/
					
/* SS 090402.1 - B */
					if stnb = 0 then do:
						find first xxsovd_det where xxsovd_domain = global_domain 
										and xxsovd_id = v_number 							
										no-lock no-error.
						if (avail xxsovd_det) or (v_number = "" ) then do:
							message "VIN�� " + xxsovd_id + " �Ѿ�����,���޸Ĺ���".
							undo ,leave .
						end.
          	
						create xxsovd_det.
						assign xxsovd_domain = global_domain
							 xxsovd_nbr  = xuseq_sod_nbr
							 xxsovd_line = int(xuseq_sod_line)
							 xxsovd_part = wo_part
							 xxsovd_wonbr = wo_nbr
							 xxsovd_wolot = wo_lot
							 /*xxsovd_seqid = xxsov_seqid*/
							 xxsovd_id  = v_number							
							 xxsovd_id1 = v_number		/*���� = VIN��*/
							 xxsovd_qty = 1.
					end . /* if stnb = 0 */
					else do:
						find first xxsovd_det where xxsovd_domain = global_domain and xxsovd_id = v_number 
							and xxsovd_nbr = xuseq_sod_nbr and xxsovd_line = int(xuseq_sod_line) no-error.
						if not avail xxsovd_det then do:
							message "����: Ԥ��VIN��û�в���" v_number.
							undo,leave.
						end.
						assign xxsovd_part = wo_part
									 xxsovd_wonbr = wo_nbr
									 xxsovd_wolot = wo_lot
									 .
						stnb = stnb + 1.
					end. /* else do: */
					
					if fstnub = "" then fstnub = xxsovd_id.
					hide message no-pause.
					message "����:" + xxsovd_nbr + "-" + trim(string(xxsovd_line)) 
						+ " ����ID:"+ xxsovd_wolot 
						+ " ����:"+ string(xuseq_wod_qty)
						+ " ��:" + trim(fstnub) + " - " + trim(xxsovd_id) .							
				end.	/*v_id = v_id to 1 by -1*/
				find first wo_mstr where wo_domain = global_domain and wo_lot = xxsovd_wolot no-error.
				if avail wo_mstr then do:
					assign wo__chr04 = trim(fstnub)
						   wo__chr05 = trim(xxsovd_id) .
					select count(*) into tmp_integer from xxsovd_det where xxsovd_domain = global_domain and xxsovd_wolot = wo_lot .
					if tmp_integer <> wo_qty_ord then do:
						message "����:���ɵ�VIN���� " + string(tmp_integer) + " �����ڹ���ID���� " + string(wo_qty_ord) skip
							"��������һ��." view-as alert-box .
						undo,leave .
					end.
				end.
				for first xxseq_mstr where xxseq_domain = global_domain 
								and xxseq_site = site
								and xuseq_priority = xxseq_priority :
							xxseq_mode_qty = xxseq_qty_req.
				end.
			end.	/*if avail wo_mstr*/
		end.	/*if avail xuseq_mstr and xuseq_wod_lot <> ""*/
				
		hide frame d no-pause.
		next mainloop.
	end. /* if keyfunction */
			
	else if keyfunction(lastkey) = "insert-mode" then 
	do on error undo,retry:
	end.
	else if keyfunction(lastkey) = "go"
	then do:
	end.
			
   end. /* repeat do with frame d */   
   hide frame d no-pause.   
end. /* repeat with frame a */

status input.


