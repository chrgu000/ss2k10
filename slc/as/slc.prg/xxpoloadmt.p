/*******************************************************************/
/*Designed by Billy 2008-10-24                                     */
/*Name:老采购订单导入新系统                                        */
/*******************************************************************/
{mfdtitle.i "b+ "}

	DEFINE VARIABLE ponbr  LIKE xxpo_nbr    NO-UNDO.
	DEFINE VARIABLE ponbr1 LIKE xxpo_nbr    NO-UNDO.
	define variable tmppart like pt_part.
	define variable i as integer init 0.

	DEFINE VARIABLE vchr_poload_in AS CHARACTER.
	DEFINE variable vchr_poload_out as character.
	
  define temp-table two 
	       field two_ponbr  like xxpo_nbr
	       field two_poline like xxpo_line
	       field two_ptpart like xxpt_part
	       field two_oldptpart like xxpt_part
	       field two_vendnbr like xxvend_nbr
	       field two_poordqty   like xxpo_ord_qty
	       index two_ponbr 
	       two_poline
	       two_ptpart.
	       
	/*记录有老件号无新件号的项次*/       
  define temp-table three
         field three_ponbr like xxpo_nbr
         field three_poline like xxpo_line
         field three_ptpart like xxpt_part
         field three_oldptpart like xxpt_part
         .

	vchr_poload_in = "./ssi" + mfguser.
	vchr_poload_out = "./sso" + mfguser.


	FORM
		ponbr       COLON 18
		ponbr1      LABEL {t001.i} COLON 49 
    SKIP (1)
	WITH FRAME a SIDE-LABELS WIDTH 80 attr-space.
	setFrameLabels(FRAME a:HANDLE).

	form 
		pod_nbr        column-label "采购订单号"
		pod_line       column-label "项次"
		two_oldptpart  column-label "老编码"
		pod_part       column-label "物料编码"
		two_vendnbr    column-label "供应商"
		pod_qty_ord    column-label "数量"
	with frame c down  width 120 no-attr-space.
	setframelabels(FRAME c:HANDLE).
		
	form
	  	  three_ponbr      column-label "采购订单号"
	  	  three_poline     column-label "项次"
	  		three_oldptpart  column-label "老件号"
	  		three_ptpart     column-label "新件号"
	with frame d down width 120 no-attr-space.
	setframelabels(frame d:handle).  

	{wbrp01.i}
	Mainloop:
	REPEAT ON ENDKEY UNDO, LEAVE:
    IF ponbr1 = hi_char THEN ponbr1 = "". 

		UPDATE
        ponbr
        ponbr1
			WITH FRAME a.


		IF (c-application-mode <> 'web':u) OR
			(c-application-mode = 'web':u AND
			(c-web-request begins 'data':u)) THEN DO:
			bcdparm = "".

			{mfquoter.i ponbr }
			{mfquoter.i ponbr1}

      IF ponbr1 = "" THEN ponbr1 = hi_char.

		END.

		{mfselbpr.i "printer" 80}

    for each two :
        delete two.
    end.

		FOR EACH xxpo_load WHERE xxpo_nbr >= ponbr AND xxpo_nbr <= ponbr1 no-lock :
			  find first vp_mstr where vp_domain = global_domain and vp_vend_part = xxpt_part and vp_vend = "" no-lock no-error.
			  if avail vp_mstr then
			  	do:
			  		tmppart = vp_part.
			  	end.
			  else
			  	do:
			  		tmppart = "无新件号".
			  		if substring(xxpt_part,10,1) = "-" then
			  			do:
			  				tmppart = xxpt_part.
			  			end.
			  	end.
			  
			  if tmppart <> "无新件号" then
				  do:
				    create two.
				    assign two_ponbr = xxpo_nbr
				           two_poline = xxpo_line
				           two_oldptpart = xxpt_part 
				           two_ptpart   = tmppart
				           two_vendnbr  = xxvend_nbr
				           two_poordqty = xxpo_ord_qty.
				  end.
			  else
				  do:
				  	create three.
				  	assign 
				  		three_ponbr = xxpo_nbr
				  	  three_poline = xxpo_line
				  	  three_oldptpart = xxpt_part
				  	  three_ptpart = tmppart.     
				  end.
	  end. /*for each xxpo_load*/
  
	  for each two no-lock break by two_ponbr:  	
	  	 find first pod_det where pod_domain = global_domain and pod_nbr = two_ponbr and pod_line = two_poline no-lock no-error.
	  	 if avail pod_det then
	  	 	do:
	  	 		put "采购订单号:" two_ponbr "项次:" two_poline two_oldptpart "已经存在,系统将不会导入这一项" skip.
	  	 		delete two. 
	  	 	end.
	  end.
	  	  
	  for each two no-lock break by two_ponbr by two_poline:
				
				find first tr_hist use-index tr_nbr_eff where tr_domain = global_domain and tr_nbr = two_ponbr and (tr_type <> "ORD-SO") and (tr_type <> "ORD-PO") no-lock no-error.
				if avail tr_hist then
				 do:
				 		cim: 		
						DO TRANSACTION:		
		  				OUTPUT TO value(vchr_poload_in).
			        
							PUT '~"' two_ponbr  '~"' SKIP.
							PUT "-" SKIP.
							PUT "-" SKIP.
							PUT "-" SKIP.
							PUT "-" SKIP.
							PUT '~"' two_poline '~"' SKIP. 
							PUT '10000' SKIP.
							PUT "-" SKIP. 
							PUT '~"' two_ptpart '~"' SKIP.
							PUT '~"' two_poordqty '~"' SKIP.
							PUT "-" SKIP.
							PUT "-" SKIP.
							PUT "." .
							PUT ".".
							PUT	"-" SKIP.
							PUT "-" SKIP.		
							put "." skip.
							
							OUTPUT CLOSE.
		
							INPUT FROM VALUE(vchr_poload_in).	
							OUTPUT TO VALUE(vchr_poload_out).		
			
							batchrun = YES.  /* In order to	disable the "Pause" message */
							{gprun.i ""popomt.p""} 
							batchrun = NO.
							INPUT CLOSE.
							OUTPUT CLOSE.
						end.  /* cim */
				 end.
				else
				 do:
						cim: 		
						DO TRANSACTION:		
		  				OUTPUT TO value(vchr_poload_in).
			
							PUT '~"' two_ponbr  '~"' SKIP.
							PUT '~"' two_vendnbr '~"' SKIP.
							PUT "-" SKIP.
							PUT "-" SKIP.
							PUT "-" SKIP.
							PUT '~"' two_poline '~"' SKIP. 
							PUT '10000' SKIP.
							PUT "-" SKIP. 
							PUT '~"' two_ptpart '~"' SKIP.
							PUT '~"' two_poordqty '~"' SKIP.
							PUT "-" SKIP.
							PUT "-" SKIP.
							PUT "." .
							PUT ".".
							PUT	"-" SKIP.
							PUT "-" SKIP.		
							put "." skip.
							
							OUTPUT CLOSE.
		
							INPUT FROM VALUE(vchr_poload_in).	
							OUTPUT TO VALUE(vchr_poload_out).		
			
							batchrun = YES.  /* In order to	disable the "Pause" message */
							{gprun.i ""popomt.p""} 
							batchrun = NO.
							INPUT CLOSE.
							OUTPUT CLOSE.
						end.  /* cim */
					end.
	  end. /* for each two */
   
	  OS-DELETE VALUE("./ssi" + mfguser).
	  OS-DELETE VALUE("./sso" + mfguser).
			
		output to value(path) page-size value(printlength) . 
	
		for each two no-lock break by two_ponbr by two_poline:
			find first pod_det where pod_domain = global_domain and pod_nbr = two_ponbr and pod_line = two_poline no-lock no-error.			
			if avail pod_det then do:
				disp
					  pod_nbr        column-label "采购订单号"
						pod_line       column-label "项次"
						two_oldptpart  column-label "老编码"
						pod_part       column-label "物料编码"
						two_vendnbr    column-label "供应商"
						pod_qty_ord    column-label "数量"
			  with frame c.
				down with frame c.		
			end.
			else message "采购订单:" two_ponbr "  项次：" two_poline "  " two_oldptpart "供应商：" two_vendnbr "  没有导入成功，系统中没有供应商基础信息" .
	  end.
	  
	  FOR EACH xxpo_load where xxpo_nbr >= ponbr and xxpo_nbr <= ponbr1 exclusive-lock:
				delete xxpo_load.
		end.	
	  
	  for each three no-lock break by three_ponbr:
	  	if first (three_ponbr) then
	  	do:
		  	put skip(3).
		  	put "以下是无新件号的采购项次，请与品质部联系，添加新件号！" at 1 skip.
	  	end.
	  	disp
	  		three_ponbr      column-label "采购订单号"
	  	  three_poline     column-label "项次"
	  		three_oldptpart  column-label "老件号"
	  		three_ptpart     column-label "新件号"
	  	with frame d.
	  	down with frame d.
	  end. 
	  empty temp-table two.
	  empty temp-table three.
	  
		{mfreset.i}
		{mfgrptrm.i}
	END.

	{wbrp04.i &frame-spec = a}