/* zzgtsoll.p - UPLOAD INVOICE DATA GENERATE BY GOLD-TAX INTO MFG/PRO       */
/*                                                                         */
/*	LAST MODIFIED 	DAT:2004.5.27	BY: *LB01* LONG BO 					   */
/*	LAST MODIFIED 	DAT:2005-01-07 09:52	BY: *LB02* LONG BO 			   */

	{mfdeclre.i }

define shared stream rpt .

define  shared var v_bkbox  as char format "x(50)".
define  shared var v_inbox  as char format "x(50)".
define shared  var v_rpbox  as char format "x(50)".
define shared  var v_ptbox  as char format "x(50)".  /*过账结果数据*/

define  shared var v_bkfile as char format "x(50)".
define shared  var v_infile as char format "x(50)".
define  shared var v_infilex as char format "x(12)".
define  shared var v_rpfile as char format "x(50)".
define  shared var v_rpline as char format "x(100)".

define  shared variable v_postfile          as character.

define  shared var v_times  as integer.
define shared  var v_load   as logical .
define  shared var v_adj    as logical .
define  shared var v_post   as logical .

define  shared var type     as char.
define  shared var nbr      like so_nbr.
define  shared var v_dt       as date.
define  shared var v_site   like so_site.
define  shared var i        as char format "x(70)" extent 48.

DEFINE  shared VAR savepos AS INT.
define shared  var strdummy as char.

define  shared var invsite  as char.
define shared var v_totso  as integer.
define shared  variable i3            as integer  no-undo.
define  shared variable i2            as integer  no-undo.


define   shared workfile giv
 field ginv              as char
 field ginvx             as char
 field gdate             like gltr_eff_dt
 field gshipdate         like gltr_eff_dt
 field gref              as char
 field gtotamt              like glt_amt
 field gtaxamt              like glt_amt
 field gnetamt              like glt_amt
 field gtaxpct           like usrw_decfld[1]
 field gcust             as   char format "x(8)"
 field gbill             as   char format "x(8)"
 field grmks             as char
 field gsite            as character
 field gnbr             as character
 field gmfgtotamt           like glt_amt
 field gmfgtaxamt           like glt_amt
 field gmfgnetamt           like glt_amt
 field gerrflag          as logical  initial no
 field gerrmsg           as character
 .

define  shared variable xsonbr like so_nbr.
define  shared workfile xinvd
	field x_ref	as char			/*lb02*/
	field xnbr	like so_nbr
	field xpart	like sod_part
	field xqty	like sod_qty_inv
 .

define   shared temp-table wrk_var				/*lb01*/ 
    field wrk_sonbr  	like sod_nbr		/*lb01*/		 
    field wrk_line   	like sod_line		/*lb01*/		
    field wrk_qty_inv  	like sod_qty_inv /*lb01*/
    field wrk_sched    	like sod_sched   /*lb01*/
    index wrk_sonbr wrk_sonbr.          /*lb01*/
    
define variable tmptotamt like glt_amt.
define variable tmptaxamt like glt_amt.
define variable tmpnetamt like glt_amt.

{zzgtos01.i}
{zzgt002.i }	
	
    v_totso = 0.
    
    output stream rpt to value(v_rpfile).
    
    put stream rpt "日期 : " at 1 today at 20 skip
                   "输入文件: " at 1 v_infile at 20  skip
                   "备份文件: " at 1 v_bkfile at 20 skip.
    put stream rpt "上载(Y)/预览(N) : " at 1 v_load at 20 skip(1).
    

	for each giv
	break by gnbr           /*lb01 2004-09-02 11:20*/
	:  /*每张发票*/
	/*
	put stream rpt unformatted fill("=",80) skip.
	display stream rpt giv with 2 column.
	*/
	
		type = "".
		/*检查号码*/
		if gref = "无" or gref = "" then do:  /*lb01 2004-09-02 08:54*/
			put stream rpt  
			    "发票 " at 1 
			    ginv at 10
			    ": 号码为空!" AT 20.
			gerrflag = yes.
			gerrmsg  = "号码为空.".
			next.
		end.
		else do:  /* reference nbr is not blank */
	        find first usrw_wkfl 
	             where usrw_key1 = "GOLDTAX-MSTR"
	             and   usrw_key5 = gref
	             no-lock no-error.
	        if available usrw_wkfl then do:  /*load before*/
				put stream rpt  
				  "发票 " at 1 
				  ginv at 10
				  ": 订单发票号已经上载过!" AT 20.
				gerrflag = yes.
				gerrmsg  = "发票号已经上载过!".
				next.
	        end.
	        else do: /*will be load*/
	
				find first so_mstr 
				   where so_inv_nbr = ginv
				   and  so_nbr <> substring(gref,4,8) 
				   no-lock no-error.
				if available so_mstr then do:
					gerrflag = yes.
					gerrmsg  = "发票号已经被其他订单占用!".
					next.
				end.
				find first so_mstr 
				   where so_nbr = substring(gref,4,8) 
				   exclusive-lock /*lb01 2004-09-02 09:21*/
				   no-error.
				if available so_mstr then do:
		            type    = "SO".
	
		            if can-find(ar_mstr where ar_nbr = ginv)
		            or can-find(first ih_hist where ih_inv_nbr = ginv) 
		            then do:
						put stream rpt  
						  "发票 " at 1 
						  ginv at 10
						  ": 发票冲突 ih_hist / ar_mstr!" AT 20.
						IF v_invprex = "" THEN DO:
						  gerrflag = yes.
						  gerrmsg  = "发票冲突 ih_hist / ar_mstr!".
						  next.
						END.
						ELSE DO:
							ginvx = v_invprex + SUBSTRING(ginv, (LENGTH(v_invprex) + 1)).
							if can-find(ar_mstr where ar_nbr = ginvx)
							or can-find(first ih_hist where ih_inv_nbr = ginvx) 
							then do:
								put stream rpt  
								     "发票 " at 1 
								     ginvx      at 10
								     ": 发票冲突 ih_hist / ar_mstr!" AT 20.
								gerrflag = yes.
								gerrmsg  = "发票冲突 ih_hist / ar_mstr!".
								next.
							END.
						END.
					end.
	
		            v_site  = so_site.
		            v_totso = v_totso + 1.
		        /*    gnbr    = so_nbr. */
		            gcust   = so_cust.
		            gbill   = so_bill.
		            gshipdate   = so_ship_date.
		            gsite   = so_site.
	
					/*load inv_nbr,inv_date, change status*/
					if v_load = yes then do:
						so_inv_nbr  = ginvx.
						so_to_inv   = no.
						so_invoiced = yes.
						so_inv_date = gdate.
					/*	substring(so_user1,1,1) = "L".
						so_user2    = ginv. lb01 2004-09-02 14:32*/
					end.
	
		            /*create goldtax-mstr*/
		            if v_load = yes then do:
		              create usrw_wkfl.
		              assign usrw_key1    = "GOLDTAX-MSTR"
		                 usrw_key2        = v_gtaxid + "-" + gref + "-" + ginv + "-" + ginvx
		                 usrw_key3        = v_gtaxid
		                 usrw_key4        = gnbr
		                 usrw_key5        = gref
		                 usrw_key6        = ginv
		                 usrw_user2       = ginvx
		                 usrw_user1       = global_userid
		                 usrw_charfld[1]  = "VAT"
		                 usrw_charfld[2]  = "SO"
		                 usrw_charfld[3]  = "L"
		                 usrw_charfld[4]  = gcust
		                 usrw_charfld[5]  = gbill
		                 usrw_charfld[6]  = gsite
		                 usrw_charfld[7]  = grmks
		                 usrw_datefld[1]  = gdate
		                 usrw_datefld[2]  = gshipdate
		                 usrw_charfld[11] = string(gtotamt)
		                 usrw_charfld[12] = string(gmfgtotamt)
		                 usrw_decfld[1]   = gtaxpct * 100
		                 .
		            end.
				end. /*available so_mstr*/
				else do: /*can not find so_mstr*/ 
					if can-find(ar_mstr where ar_nbr = ginv)
					or can-find(first ih_hist where ih_inv_nbr = ginv) 
					then do:
						put stream rpt  
						  "发票 " at 1 
						  ginv at 10
						  ": 订单发票已经过账!" AT 20.
						gerrflag = yes.
						gerrmsg  = "订单发票已经过账!".
						next.
					end.
		            else do: 
						put stream rpt  
						  "发票 " at 1 
						  ginv at 10
						  ": 不能找到SO/INV!" AT 20.
						gerrflag = yes.
						gerrmsg  = "不能找到SO/INV!".
						next.
					end.
				end. /*not so_mstr*/
			end. /*will load*/
		end. /* ref not blank*/
		
	    if type = "" then do:
			put stream rpt  
			  "发票 " at 1 
			  ginv at 10
			  ":不能找到SO/INV!" AT 20.
			gerrflag = yes.
			gerrmsg  = "不能找到SO/INV!".
			next.
	    end.

	    /*CHECK END. LOAD BEGIN...*/
	    if v_post then do:
			/*check part exists*/
			find first xinvd where xnbr = so_nbr
			and (not can-find(first sod_det where sod_nbr = so_nbr and sod_part = xpart)) no-error.
			if available xinvd then do:
				put stream rpt
					"发票" at 1
					ginv at 10
					":零件项" + xpart + "在订单中不存在。不能过账,请手工操作".
					gerrflag = yes.
					gerrmsg = "订单中零件项" + xpart + "不存在!".
				next.
			end.			
			
			/*store old status before adjusting and posting*/
			for each sod_det exclusive-lock where sod_nbr = so_nbr:
/*				find first xinvd where xnbr = sod_nbr and xpart = sod_part no-error.  lb02*/
				find first xinvd where xnbr = sod_nbr and x_ref = gref and xpart = sod_part no-error.   /*lb02*/
				if available xinvd then do:
					if xqty <> sod_qty_inv then do:
						create wrk_var.
						assign
							wrk_sonbr = sod_nbr
							wrk_line = sod_line
							wrk_qty_inv = sod_qty_inv - xqty   /* this will write to sod_det after posting*/
							wrk_sched = sod_sched.
						sod_sched = yes. /*then will not be delete when post*/
						sod_qty_inv = xqty.
					end.
				end.
				else do:
					create wrk_var.
					assign
						wrk_sonbr = sod_nbr
						wrk_line = sod_line
						wrk_qty_inv = sod_qty_inv   /* this will write to sod_det after posting*/
						wrk_sched = sod_sched. 
					sod_sched = yes.
					sod_qty_inv = 0.
				end.
			end.
	
			/*adjust*/
	        /*cal totamt using MFG standard method*/
	        {gprun.i ""zzgtsola.p"" 
	                 "(
	                   input gnbr,
	                   output gmfgtotamt,output  gmfgtaxamt,output  gmfgnetamt
	                  )"}
			if (ABSOLUTE(gtotamt - gmfgtotamt) <= v_drange) or (v_drange = 0) then do:
				/*在容差范围内，调整*/
	            find first so_mstr
	                 where so_nbr = gnbr
	                 and   so_inv_nbr = ginvx
	                 no-error.
	            if available so_mstr then do:
					FIND FIRST trl_mstr WHERE trl_code = so_trl2_cd NO-LOCK NO-ERROR.
					IF AVAILABLE trl_mstr THEN
					FIND FIRST trl_mstr WHERE trl_code = so_trl3_cd NO-LOCK NO-ERROR.
					IF NOT AVAILABLE trl_mstr THEN DO:
						gerrflag = yes.
						gerrmsg  = "ERROR:尾栏代码错误.".
						{zzgtsolr.i no}	  /*2004-09-02 10:16*/
						next.
					END.
					so_trl2_amt = gnetamt - gmfgnetamt.
					so_trl3_amt = gtaxamt - gmfgtaxamt.
	            end.
			end.
			else do:
				gerrflag = yes.
				gerrmsg  = "ERROR:超过容差限制，不能过账，请手工操作".
				{zzgtsolr.i no}	  /*2004-09-02 10:16*/
				next.
			end.
			
	   		/*ajusted, post begin ...*/
	        /*check post effdate*/
	        {gpglefv.i}
	        {gprun.i ""gpglef1.p""
	                 "( input  ""SO"",
	                    input  glentity,
	                    input  gdate,
	                    output gpglef_result,
	                    output gpglef_msg_nbr
	                    )" }
		
			if gpglef_result > 0 then do:
				gerrflag = yes.
				gerrmsg  = "ERROR:生效日期无效，无法过账!".
				{zzgtsolr.i no}	  /*2004-09-02 10:16*/
				next.
			end.
	        else do:
				v_postfile = v_rpbox 
				          + "iv"
				          + string(month(v_dt),"99")
				          + string(day(v_dt),"99")
				          + string(ginvx) 
	                      .
		
				find first so_mstr
				   where so_inv_nbr = ginvx
				   and   so_nbr     = gnbr
				   and   so_to_inv  = no
				   and   so_invoiced = yes
				   exclusive-lock no-error.
				if not available so_mstr then do:
					gerrflag = yes.
					gerrmsg  = "ERROR:SO发票状态无效，无法过账!".
					{zzgtsolr.i no}	  /*2004-09-02 10:16*/
					next.
				end.
				/*过账*/
				output to value(v_ptbox + gref + ".txt").  /*保存过帐结果*/
	            {gprun.i ""zzgtsolb.p"" 
	                     "(input ginvx, 
	                       input gdate, 
	                       input v_postfile, 
	                       output gerrflag
	                       )"}
	            output close.
	            
				if gerrflag then do:
					gerrmsg = "错误:自动过账失败!".
					{zzgtsolr.i no}	  /*2004-09-02 10:16*/
					next.
				end.
				else do:
					{zzgtsolr.i yes}	  /*2004-09-02 10:16*/
				end.					
	   		end. 	
	    end. /*if v_post*/

	    if (not v_post) and v_adj then do:
	    	/*不过账，仅仅是调整差异*/
	    	if first-of(gnbr) then do:
	    		tmptotamt = 0.
	    		tmpnetamt = 0.
	    		tmptaxamt = 0.
	    	end.
	    	tmptotamt = tmptotamt + gtotamt.
	    	tmpnetamt = tmpnetamt + gnetamt.
	    	tmptaxamt = tmptaxamt + gtaxamt.
	    	if last-of(gnbr) then do:
		        /*cal totamt using MFG standard method*/
		        {gprun.i ""zzgtsola.p"" 
		                 "(
		                   input gnbr,
		                   output gmfgtotamt,output  gmfgtaxamt,output  gmfgnetamt
		                  )"}
				if (ABSOLUTE(tmptotamt - gmfgtotamt) <= v_drange) or (v_drange = 0) then do:
					/*在容差范围内，调整*/
		            find first so_mstr
		                 where so_nbr = gnbr
		                 and   so_inv_nbr = ginvx
		                 no-error.
		            if available so_mstr then do:
						FIND FIRST trl_mstr WHERE trl_code = so_trl2_cd NO-LOCK NO-ERROR.
						IF AVAILABLE trl_mstr THEN
						FIND FIRST trl_mstr WHERE trl_code = so_trl3_cd NO-LOCK NO-ERROR.
						IF NOT AVAILABLE trl_mstr THEN DO:
							gerrflag = yes.
							gerrmsg  = "ERROR:尾栏代码错误.".
							next.
						END.
						so_trl2_amt = tmpnetamt - gmfgnetamt.
						so_trl3_amt = tmptaxamt - gmfgtaxamt.
		            end.
				end.
				else do:
					gerrflag = yes.
					gerrmsg  = "ERROR:超过容差限制，放弃差异调整!".
					next.
				end.
	    	end.
	    end.
			
	    /*create goldtax-mstr*/
	    if v_load = yes then do:
			find first usrw_wkfl
			where usrw_key1    = "GOLDTAX-MSTR"
			and   usrw_key2    = v_gtaxid + "-" + gref + "-" + ginvx
			no-error.
			if available usrw_wkfl then do:
				assign
				usrw_charfld[12] = string(gmfgtotamt)
				.
			end.
	    end.
	    else do: 
	        /*cal totamt using MFG standard method*/
	        {gprun.i ""zzgtsola.p"" 
	                 "(
	                   input gnbr,
	                   output gmfgtotamt,output  gmfgtaxamt,output  gmfgnetamt
	                  )"}
		end.	    
	end.  /* end of "for each" */

    
    put stream rpt skip(1)
        "订单发票上载数量 : " at 1 v_totso to 45 skip.
        
/*    output stream rpt close. */
    
    /*update control file*/
    find first usrw_wkfl 
         where usrw_key1 = "GOLDTAX-CTRL"
         and   lookup(global_userid,usrw_charfld[1]) <> 0
         no-error.
    if available usrw_wkfl then do:
      overlay(usrw_charfld[6],31,6) = string(v_times,"999999").
      overlay(usrw_charfld[6],21,8) =   string(year(today),"9999") 
                                      + string(month(today),"99")
                                      + string(day(today),"99").
    end.

    /*report to screen*/      
/************
    input from value(v_rpfile) .
    repeat:
      import unformatted v_rpline.
      put v_rpline at 1.
    end.
************/
put stream rpt unformatted skip fill("=",150) skip.
    for each giv with frame zz width 200 down:
/* message "zzzz" . pause. */
      display stream rpt
              ginv                         column-label "发票号"
              gerrflag                     column-label "ERR"
              ginvx                        column-label "MFG发票"
              gref         format "x(12)"  column-label "单据号"
              gnbr                         column-label "订单号"
              gbill                        column-label "开票至"
              gdate                        column-label "发票日期"
              gshipdate                    column-label "发货日期"
              gtotamt                      column-label "发票金额"
              gmfgtotamt                   column-label "原MFG金额"
              gerrmsg      format "x(40)"  column-label "错误信息"
              with stream-io.
      display 
              ginv                         column-label "发票号"
              gerrflag                     column-label "ERR"
              ginvx                        column-label "MFG发票"
              gref         format "x(12)"  column-label "单据号"
              gnbr                         column-label "订单号"
              gbill                        column-label "开票至"
              gdate                        column-label "发票日期"
              gshipdate                    column-label "发货日期"
              gtotamt                      column-label "发票金额"
              gmfgtotamt                   column-label "原MFG金额"
              gerrmsg      format "x(40)"  column-label "错误信息"
              with stream-io.
    end.
    output stream rpt close.
    
/*    {mfreset.i} */
    

    /*move data file to back box*/
    if v_load then do:
		IF	OPSYS = "MSDOS" or OPSYS = "WIN32" then DOS SILENT move value(v_infile) value(v_bkfile).
    	else if OPSYS = "UNIX" then unix silent mv value(v_infile) value(v_bkfile).
    end.
    else do:
		IF	OPSYS = "MSDOS" or OPSYS = "WIN32" then DOS SILENT copy value(v_infile) value(v_bkfile).
    	else if OPSYS = "UNIX" then unix silent cp value(v_infile) value(v_bkfile).
   	end.
