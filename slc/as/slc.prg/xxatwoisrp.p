/*assign  propath = "/qad_data/mfgpro/eb21tj/xrc," + propath .
disp propath .*/
 {mfdtitle.i "dd"}
  /*---Add Begin by davild 20080104.1*/
{xxatwoisrp.i "new"}
form
	danhao	colon 14 label "���ݺ�" format "x(13)"
	danhao1	colon 49 label "��" format "x(13)" skip(1)
     v_user	colon 28 label "�û���"
     printyn    colon 28 label "δ��ӡ"
     /*loc colon 30 label "��λ"*/
     with frame a width 80 side-label.

	{wbrp01.i}
	v_user = global_userid .
printyn = yes .
 REPEAT :
hide all no-pause .
view frame dtitle .

 FOR EACH  tmp_mstr 
 	 :
 delete tmp_mstr .
 END.
	
		IF danhao1	= hi_char	THEN danhao1	= "".
		


		IF c-application-mode <> 'web':u THEN
			UPDATE
				danhao danhao1 v_user printyn
			WITH FRAME a.

		{wbrp06.i &command = UPDATE
			&fields = "danhao danhao1 v_user printyn"
			&frm = "a"}

		IF (c-application-mode <> 'web':u) OR
			(c-application-mode = 'web':u AND
			(c-web-request begins 'data':u)) THEN DO:
			bcdparm = "".
			{mfquoter.i danhao   }
			{mfquoter.i danhao1  }
			{mfquoter.i v_user  }
			{mfquoter.i printyn  }
			

			IF danhao1	= ""	THEN danhao1	= hi_char.
			
		END.

	
           /*Ҫ��Ҫ�ظ���ӡ*/
          {mfselprt.i "printer" 132}	/*---Remark by davild 20071214.1*/
	
	   for each tr_hist where tr_domain = global_domain 
			and substring(tr_vend_Lot,1,4) = "WOIS" 
			and tr_vend_lot >= danhao and tr_vend_lot <= danhao1 
			and tr_userid = v_user
			and tr__chr07 = "WOIS"
		 :
		if printyn and tr__log01 = yes then next .
		find first pt_mstr where pt_domain = global_domain and pt_part = tr_part no-lock no-error.
		create tmp_mstr.
		assign 
		       tmp_part = tr_part
		       tmp_um   = if avail pt_mstr then pt_um else ""
		       tmp_site = tr_site
		       tmp_wolot = tr_rmks		       
		       tmp_loc  = tr_loc
		       tmp_lot  = tr_serial
		       tmp_ld_qty_oh = tr__dec02	/*��ʱ�������*/
		       tmp_sod_qty_ship = tr__dec03	/*��ʱӦ��������*/
		       tmp_sod_qty_ord = tr__dec04	/*��������*/
 		       tmp_ii = tr__chr08 			
		       tmp_ok_iss = tr_qty_loc 	/*ʵ���������*/
		       tmp_desc = tr_vend_Lot .
		       assign tr__log01 = yes  .
		       if tmp_ii = "1" then assign tmp_ii = "����" .
		       if tmp_ii = "2" then assign tmp_ii = "�����˻�" .
		 
	   end.

 	find first tmp_Mstr where tmp_part <> "" no-error.
	if avail tmp_mstr then do:
 
 

	  find first usr_mstr where usr_userid = global_userid no-lock no-error.
	  if avail usr_mstr then assign v_name = usr_name .

	FORM HEADER
		"----------------------------------------------------------------------------------------------" at 1 
		"������:                  ���Ա:                  ����Ա:               �Ƶ�Ա: " at 1 v_name 
		"����:���  ����:����  ����:����" at 1		
	WITH STREAM-IO FRAME pbottomc PAGE-BOTTOM WIDTH 132 NO-BOX.

	  FOR EACH  tmp_mstr where tmp_ii <> ""
	  	NO-LOCK break by tmp_desc by tmp_line by tmp_part by tmp_lot :
		
		/*��ͷ--BEIGN*/
		FORM  HEADER
		"¡�ι�ҵ��˾ͨ������" AT 40
		     "�Զ��˻���" AT 45		 skip
		    
 		  "�� �� ��:" at 5 tmp_desc format "x(15)"   "��������:" at 50 tmp_ii format "x(8)"
		  "�� �� ID:" at 5 tmp_wolot	"�Ƶ�����:" at 50 TODAY STRING(TIME,"HH:MM") skip
		  
		WITH STREAM-IO FRAME phead PAGE-TOP WIDTH 132 NO-BOX.
		VIEW FRAME phead.
		VIEW FRAME pbottomc.

		/*��ͷ--END--*/

		/*״̬����*/
		tmp_char = "" .
		find first cd_det where cd_domain = global_domain
			and cd_ref = tmp_part
			and cd_type = "SC"
			and cd_lang = "CH"
			and cd_seq  = 0
			no-lock no-error.
		if avail cd_det then do:
			do i = 1 to 15 :
				if trim(cd_cmmt[i]) <> "" then
				assign tmp_char = tmp_char + trim(cd_cmmt[i]) .
			end.			
		end.
		k = 1 .
		run getstring(input tmp_char ,input 50, output tmp_char ,output k) .
		
		find first ad_mstr where ad_domain = global_domain 
			and ad_addr = substring(tmp_lot,10,6) no-lock no-error.
		if avail ad_mstr then assign tt_ad_sort = ad_sort . else assign tt_ad_sort = "" .
		assign v_ad_name = substring(tmp_lot,10,6) .
		find first pt_mstr where pt_domain = global_domain and pt_part = tmp_part no-lock no-error.
		find first vp_mstr where vp_domain = global_domain and vp_part = tmp_part 
			and vp_vend = v_ad_name
			no-lock no-error.
		if avail vp_mstr then assign v_vp_vend_part = vp_vend_part .
		else  assign v_vp_vend_part = "" .
		/*�������--BEGIN*/
		display 
			tmp_part	column-label "���ϴ���" format "x(18)"
			v_vp_vend_part	column-label "������" format "x(18)"
			tmp_loc		column-label "����λ"  format "x(4)"
			tmp_lot		column-label "�� ��"
			tmp_ref		column-label "�� ��"
			tmp_um		column-label "UM"			
 			tmp_ok_iss	column-label "�������" format "->>>>>>9.9<"
			tt_ad_sort	column-label "��Ӧ��"			
		with stream-io width 300 .
		put unformatted pt_desc1 at 5 .
		put unformatted "����:" at 33 .

		do i = 1 to k :
			if i = 1 then
			put unformatted ENTRY(i, tmp_char, "^") skip .
			else
			put unformatted ENTRY(i, tmp_char, "^") at 38.
		end.
		if last-of(tmp_desc)  then page .
		/*�������--END*/
	  END.

	  end.
        
  	{mfreset.i}
	{mfgrptrm.i}

end.
	{wbrp04.i &frame-spec = a}


















PROCEDURE getstring:
		define input  parameter iptstring as char.
		define input  parameter iptlength as int.
		define output parameter optstring as char.
		define output parameter xxk as int.	/*---Add by davild 20071220.1*/
		define var xxs as char.
		define var xxss as char.
		define var xxi as int.
		define var xxj as int.
		
		optstring = "".
		xxss = "".
		xxi = 1.
		
		if iptlength < 2 then return.
		
		repeat while xxi <= length(iptstring,"RAW") :
			xxs = substring(iptstring,xxi,1).
			if length( xxss + xxs , "RAW") > iptlength then do:
				optstring = optstring + xxss + "^".
				xxss = "".
				next.
			end.
			xxi = xxi + 1.
			xxss = xxss + xxs.
		end.
		optstring = optstring + xxss.

		/*---Add Begin by davild 20071220.1*/
		xxk = 1 .
		do xxj = 1 to length(optstring):
			if substring(optstring,xxj,1) = "^" then assign xxk = xxk + 1 .
		end.
		/*---Add End   by davild 20071220.1*/


END PROCEDURE.