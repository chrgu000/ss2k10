/*By: Neil Gao 08/10/14 ECO: *SS 20081014* */
/*By: Neil Gao 09/01/12 ECO: *SS 20090112* */

/* DISPLAY TITLE */
{mfdtitle.i "n+"}

define var site like ld_site.
define var packno as char.
define var packno1 as char.
define var vin as char format "x(18)".
define var desc1 like pt_desc1.
define var desc2 like pt_desc2.
define var part like pt_part.
define var qty like ld_qty_oh.
define var sonbr like so_nbr.
define var yn as logical.

form
	site colon 12
	packno colon 12 label "���װ���"
with frame a side-labels width 80 attr-space.

setFrameLabels(frame a:handle).

form
/*SS 20090112 - B*/
/*
	vin colon 12 label "����"
	sonbr  colon 12 label "������"
*/
/*SS 20090112 - E*/
	packno1 colon 12 label "�ڰ�װ���" 
	desc1 colon 45 no-label
	desc2 colon 45 no-label
	xxabs_qty  colon 12 label "����"
	xxabs_gwt colon 12 label "ë��"
	xxabs_gwt_um no-label
	xxabs_nwt colon 12 label "����"
	xxabs_nwt_um no-label
with frame b side-labels width 80 attr-space.

setFrameLabels(frame b:handle).
	
site = global_site.

mainloop:
repeat:
	
	update site packno with frame a.
	
	find first si_mstr where si_domain= global_domain and si_site = site no-lock no-error.
	if not avail si_mstr then do:
		message "�ص㲻����".
		next.
	end.
	global_site = site.
	
	find first xxabs_mstr where xxabs_domain = global_domain and xxabs_id = packno and xxabs_type = "P" no-error.
	if not avail xxabs_mstr then do:
		message "��װ��Ų�����".
		next.
	end.
	if xxabs_par_id <> "" then do:
		message "�˰�װ���Ѿ�װ��" xxabs_par_id.
		next.
	end.
	
	loop:
	repeat transaction on error undo,retry:
		
		update packno1 with frame b editing:
			
			{mfnp05.i xxabs_mstr xxabs_par_id "xxabs_domain = global_domain and xxabs_type = 'P'
      	and xxabs_shipfrom = site and xxabs_par_id = packno "  packno1 "input packno1" 
      }
			
			if recno <> ? then do:
				disp xxabs_id @ packno1 xxabs_gwt xxabs_gwt_um xxabs_nwt xxabs_nwt_um with frame b.
			end.
			
		end.
 		
 		if packno1 = packno then do:
 			message "���ܺ�װ�Լ�".
 			next.
 		end.
 		
 		find first xxabs_mstr where xxabs_domain = global_domain and xxabs_shipfrom = site and xxabs_type = "P"
 			and xxabs_id = packno1 no-error.
 		if not avail xxabs_mstr then do:
 			message "��װ��Ų�����".
 			next.
 		end.
 		if xxabs_par_id <> "" and xxabs_par_id <> packno then do:
 			message "�˰�װ���Ѿ���װ��" xxabs_par_id .
 			next.
 		end.
 		
   	if xxabs_par_id = "" then message "������¼".
   	else message "�޸ļ�¼".
   	
   	update xxabs_gwt xxabs_gwt_um xxabs_nwt xxabs_nwt_um go-on("ctrl-d") with frame b.
   	
   	if lastkey = keycode("ctrl-d") then do:
   		message "��ȷ���Ƿ�ɾ��" update yn.
   		if yn then do:
   			xxabs_par_id = "".
   			next loop.
   		end.
   		else undo,retry.
   	end.
   	
   	assign	xxabs_par_id = packno.
   	message packno1 "����ɹ�".
   	
 	end.

end.