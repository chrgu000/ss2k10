
 {mfdtitle.i "b+ "}    

      define variable trdate like tr_date.
      define variable trdate1 like tr_date.
      define buffer trhist for tr_hist.
      define variable wrec like tr_lot.
      define variable waddr like tr_addr.
      define variable weff like tr_effdate.
      define variable kk as char format "x(2)".
      define temp-table tmp_file
	       field tmp_rec	like tr_lot
	       field tmp_effdate like tr_effdate
	       field tmp_part	like tr_part
	       field tmp_desc1	like pt_desc1
	       field tmp_addr   like tr_addr
	       field tmp_serial like tr_serial
	       field tmp_qty_loc like tr_qty_loc
	       index tmp_eff_rec tmp_effdate tmp_rec ASCENDING.



      /* SELECT FORM */
      form
         skip(1)
         trdate         label "转仓日期" colon 18
         trdate1        label {t001.i} colon 49 skip (2)

         "使用说明:"								at 2 skip
	 "1) 该报表显示满足以下条件资料:"					at 2 skip
	 "   A) 从HK转移到SJ的交易, TYPE = ISS-TR AND TR_LOC = HM0001 "		at 2 skip 
	 "   B) 批号 = 采购单收货批号    OR 转仓单前8码 = 收货单号      "       at 2 skip(1)
	 "2) 该报表不更新任何MFG/PRO资料                            "           at 2 skip(1)
	 "3) 由於数据量问题，该报表的运行时间约1分钟(1天的转仓资料) "           at 2 skip(1)  
         "4) Sort By 生效日期 + RM单"                                           at 2 skip  


      with frame a side-labels width 80 attr-space.
      form 
         header
         "货物检验单(香港转仓)" at 59 skip(1)
	 "转仓日期从:" trdate  "   至:  " trdate1     "    检验编码: " at 80 skip(2)
      with STREAM-IO /*GUI*/  frame pheads page-top width 132 no-box.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame a:handle).

      /* REPORT BLOCK */


/*K0PW*/ {wbrp01.i}
repeat:

         if trdate = low_date then trdate = ?.
         if trdate1 = hi_date then trdate1 = ?.


/*K0PW*/ if c-application-mode <> 'web':u then
            update
           trdate trdate1
         with frame a.

/*K0PW*/ {wbrp06.i &command = update &fields = " trdate
trdate1 " &frm = "a"}

/*K0PW*/ if (c-application-mode <> 'web':u) or
/*K0PW*/ (c-application-mode = 'web':u and
/*K0PW*/ (c-web-request begins 'data':u)) then do:


         bcdparm = "".

         {mfquoter.i trdate }
         {mfquoter.i trdate1}

         if trdate = ? then trdate = low_date.
         if trdate1 = ? then trdate1 = hi_date.


/*K0PW*/ end.
            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}
            {mfphead.i}
		view fram pheads.

		for each tr_hist where tr_type ="ISS-TR" and tr_date >= trdate and tr_date <= trdate1 and tr_loc = "HM0001" use-index tr_date_trn no-lock, 
		    each pt_mstr where pt_part = tr_part and ( pt_prod_line = "0100" or    pt_prod_line = "0200" or
			 pt_prod_line = "0300" or pt_prod_line = "0400" or pt_prod_line = "0500" or pt_prod_line = "0600" or 
			 pt_prod_line = "0640" )  no-lock:
		wrec = "".
		waddr = "".

		find first trhist where  (  trhist.tr_serial = tr_hist.tr_serial and length(trhist.tr_serial) = 13 or trhist.tr_lot = substring(tr_hist.tr_nbr ,1,8) ) 
		     and trhist.tr_type ="RCT-PO" and trhist.tr_part = tr_hist.tr_part  no-lock no-error .

		if available trhist then do:
		   wrec = trhist.tr_lot.
		   waddr = trhist.tr_addr.
		   weff  = trhist.tr_effdate.

		end.



		create tmp_file.
		assign  
		       tmp_rec		= wrec
		       tmp_effdate      = weff
		       tmp_part		= tr_hist.tr_part 
		       tmp_desc1	= pt_desc1 
		       tmp_addr		= waddr
		       tmp_serial	= tr_hist.tr_serial 
		       tmp_qty_loc	= tr_hist.tr_qty_loc * -1 .


		end.

		for each tmp_file , each prh_hist where tmp_rec = prh_receiver no-lock :
	
		display kk		column-label ""
			tmp_rec		column-label "RM单编号"
			tmp_effdate     column-label "生效日期"
			tmp_part	column-label "零件"
			tmp_desc1       column-label "描述"
			tmp_addr	column-label "供应商"
			tmp_serial      column-label "LOT #"
			tmp_qty_loc	column-label "数量"
			prh_rev		column-label "版本"
			"             " column-label "检查结果"
			"             " column-label "备注"
			"             " column-label "签名" 
			kk + ""		column-label "" format "x(2)"
			skip(1)
			with width 200.

			if kk ="" then kk = "**" . else kk = "".
		end.
		for each tmp_file:
		delete tmp_file.
		end.


         /* REPORT TRAILER */
         {mfrtrail.i}

      end. /* REPEAT */

/*K0PW*/ {wbrp04.i &frame-spec = a}
