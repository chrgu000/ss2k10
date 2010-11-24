/* By: Neil Gao Date: 20070403 ECO: * ss 20070403.1 * */
/*By: Neil Gao 08/03/29 ECO: *SS 20080329* */
/*By: Neil Gao 08/04/18 ECO: *SS 20080418* */
/*By: Neil Gao 09/02/03 ECO: *SS 20090203* */

/*
�ӿ��ʽ�ٶ�
*/

{mfdtitle.i "n+ "}

define var trlot like tr_lot.
define var desc1 like pt_desc1.
define var desc2 like pt_desc2.
define var xxqty1	 like tr_qty_loc.
define var xxqty2  like tr_qty_loc.
define var xxqty3  like tr_qty_loc.
define var xxqty4  like tr_qty_loc.
define var xxloc1  like tr_loc.
define var xxloc2	 like tr_loc.
define var xxloc3  like tr_loc.
define var xxloc4  like tr_loc.
define var xxreas1 like prh_reason.
define var xxreas2 like prh_reason.
define var xxreas3 like prh_reason.
define var xxreas4 like prh_reason.
define var xxrecid as recid.
define var effdate like tr_effdate init today.
define var vendname as char format "x(20)".

define var undo-input as logical no-undo.

/* DISPLAY SELECTION FORM */
form
   trlot		      colon 15 label "���ϵ�"
   tr_nbr					colon 35
   tr_part				colon 15 label "�����"
   desc1					colon 35 no-label
   desc2					colon 35 no-label
   tr_qty_loc			colon 15 label "��������"
   tr_loc					colon 35
   tr_serial			colon 55 label "��/��"
   effdate        colon 15 label "��Ч����"
   tr_ref					colon 35 label "�ο���"
   vendname       colon 55 label "��Ӧ������"
   xxqty1					colon 15 label "�ϸ�Ʒ����"
   xxloc1					colon 35 label "��λ"
   xxreas1				colon 55 label "ԭ����"
   xxqty2					colon 15 label "���ϸ�����"
   xxloc2					colon 35 label "��λ"
   xxreas2				colon 55 label "ԭ����"
   xxqty3					colon 15 label "�ƻ�(������)"
   xxloc3					colon 35 label "��λ"
   xxreas3				colon 55 label "ԭ����"
   xxqty4					colon 15 label "�ƻ�(����)"
   xxloc4					colon 35 label "��λ"
   xxreas4				colon 55 label "ԭ����"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

view frame a.
repeat with frame a:
	
	 clear frame a all no-pause.
   prompt-for trlot
   editing:
   	
      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp05.i tr_hist tr_type "tr_domain = global_domain and
      tr_type = 'rct-po' and tr__dec01 = 0  "  tr_lot
      "input trlot"
       }

      if recno <> ? then
		  do:
         find first pt_mstr where pt_domain = global_domain and pt_part = tr_part no-lock no-error.
         find first vd_mstr where vd_domain = global_domain and vd_addr = substring(tr_serial,10) no-lock no-error.
         display 	tr_lot @ trlot
         					tr_nbr
         					tr_part
         					tr_loc 
         					tr_qty_loc tr_serial tr_ref
         					vd_sort  when ( avail vd_mstr ) @ vendname
         					pt_desc1 when ( avail pt_mstr ) @ desc1 
         					pt_desc2 when ( avail pt_mstr ) @ desc2  .
      end.
   end.
   
   if avail tr_hist then xxrecid = recid(tr_hist).
   
   if not avail tr_hist or ( avail tr_hist and tr_lot <> input trlot ) then do:
/*SS 20080329 - B*/
/*
   find first tr_hist where tr_domain = global_domain and 
   tr_type = 'rct-po' and tr_lot = input trlot and tr__dec01 = 0 no-lock no-error.
*/
			find first prh_hist use-index prh_receiver where prh_domain = global_domain and prh_receiver = input trlot no-lock no-error.
			if avail prh_hist then 
			find first tr_hist use-index tr_part_eff where tr_domain = global_domain and tr_type = 'rct-po' and tr_lot = input trlot 
				and tr__dec01 = 0 /*and tr__dec02 <> 0*/ and prh_rcp_date = tr_effdate and prh_part = tr_part no-lock no-error.
		end.
/*SS 20080329 - E*/
   
   if not avail tr_hist then do:
   		message "���ϵ������ڻ��ѽ��δ����".
   		undo,retry.
   end.
   find first pt_mstr where pt_domain = global_domain and pt_part = tr_part no-lock no-error.
   if not avail pt_mstr then do:
   		message "���������".
   		undo,retry.
   end.

   if avail tr_hist then xxrecid = recid(tr_hist).
   find first vd_mstr where vd_domain = global_domain and vd_addr = substring(tr_serial,10) no-lock no-error.
   
   display tr_lot @ trlot
      		 tr_nbr
     			 tr_part
     			 tr_loc 
     			 tr_qty_loc tr_serial tr_ref
     			 vd_sort  when ( avail vd_mstr ) @ vendname 
     			 pt_desc1 @ desc1 
     			 pt_desc2 @ desc2.
   
   assign xxqty1  = tr_qty_loc - tr__dec03
   				xxloc1  = pt_loc
   				xxreas1 = ""
   				xxqty2	= tr__dec03
   				xxloc2  = "NC02"
   				xxreas2	= ""	
   				xxqty3	= 0			
   				xxloc3  = "NC3"
   				xxreas3	= ""		
   				xxqty4	= 0			
   				xxloc4  = ""
   				xxreas4 = "" .
/*SS 20080418 - B*/
	if tr_site = "12000" then xxloc1 = "SJ01".
	if tr_site = "11000" then xxloc1 = "SH01".
/*SS 20080418 - E*/
   
   do transaction on error undo, retry:
   		update effdate
   				xxqty1
   				xxloc1
   				xxreas1
   				xxqty2	
   				xxloc2
   				xxreas2			
   				xxqty3				
   				xxloc3
   				xxreas3			
   				xxqty4				
   				xxloc4
   				xxreas4
   				with frame a .
   				
   		if effdate = ? then effdate = today.
   		
   		if xxqty1 + xxqty2 + xxqty3 + xxqty4 <> tr_qty_loc then do:
   			message "���������".
   			undo,retry.
   		end.
   		
   		if xxqty1 <> 0 and xxloc1 <> tr_loc then do:
   		{gprun.i ""xxmdiclotr.p"" 
   			"(input tr_part,
   				input xxqty1,
   				input effdate,
   				input '',
   				input '',
   				input tr_lot + '-1-' + xxreas1,
   				input tr_site,
   				input tr_loc,
   				input tr_serial,
   				input tr_ref,
   				input tr_site,
   				input xxloc1,
   				output undo-input)"
   				}
   				if undo-input then undo,leave.
   		end.
   		
   		if xxqty2 <> 0 and xxloc2 <> tr_loc then do:
   		{gprun.i ""xxmdiclotr.p"" 
   			"(input tr_part,
   				input xxqty2,
   				input effdate,
   				input '',
   				input '',
   				input tr_lot + '-2-' + xxreas2,
   				input tr_site,
   				input tr_loc,
   				input tr_serial,
   				input tr_ref,
   				input tr_site,
   				input xxloc2,
   				output undo-input)"
   				}
   				if undo-input then undo,leave.
   		end. 		
   		if xxqty3 <> 0 and xxloc3 <> tr_loc then do:
   		{gprun.i ""xxmdiclotr.p"" 
   			"(input tr_part,
   				input xxqty3,
   				input effdate,
   				input '',
   				input '',
   				input tr_lot + '-3-' + xxreas3,
   				input tr_site,
   				input tr_loc,
   				input tr_serial,
   				input tr_ref,
   				input tr_site,
   				input xxloc3,
   				output undo-input)"
   				}
   				if undo-input then undo,leave.
   		end.
   		if xxqty4 <> 0 and xxloc4 <> tr_loc then do:
   		{gprun.i ""xxmdiclotr.p"" 
   			"(input tr_part,
   				input xxqty4,
   				input effdate,
   				input '',
   				input '',
   				input tr_lot + '-4-' + xxreas4,
   				input tr_site,
   				input tr_loc,
   				input tr_serial,
   				input tr_ref,
   				input tr_site,
   				input xxloc4,
   				output undo-input)"
   				}
   				if undo-input then undo,leave.
   		end.
   end. /*do on error undo,retry */
		if undo-input then do:
			message "ִ��ʧ��".
			next.
		end.
		else 
			/*��¼ת������ */	
			do transaction on error undo, retry:
		  	for first tr_hist where recid(tr_hist) = xxrecid :
      		tr__dec01 = tr_qty_loc.
      		message "ִ�гɹ�".
      		hide frame a no-pause.
      	end.
			end.
		/*
		{gprun.i ""xxtrchrp.p"" "(input tr_lot)" }
		*/
end. /* repeat */