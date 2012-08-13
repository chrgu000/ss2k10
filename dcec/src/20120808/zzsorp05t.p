/* zzsorp05t.p    create by longbo                */
/* LAST MODIFIED BY LONGBO 2004-07-12             */





	define    input parameter comp_addr like soc_company.  /*lb01*/
	
	FORM
		code_cmmt no-label
	with stream-io frame so_tr_add2 side-label down width 80 no-box.
	
	for each code_mstr no-lock
	where code_fldname = "zz-soprn-trail" break by code_value:
		display code_cmmt with frame so_tr_add2.
		down 1 with frame so_tr_add2.
	end.
	
	/*
	define variable bkline as integer.

	FORM
		bkline format "9、" no-label 
		ad_name label "名称"  colon 10 skip 
		bk_desc label "开户行" colon 10 skip
		bk_bk_acct1 label "账号" colon 10 
	with stream-io frame so_tr_add2 side-label down width 80 no-box.

	find first ad_mstr where ad_addr = comp_addr no-lock no-error.
	find first bk_mstr where bk_code = ad_user1 no-lock no-error.
	bkline = 1.
	if available ad_mstr and available bk_mstr then do:
		display
			bkline
			ad_name
			bk_desc
			bk_bk_acct1
		with frame so_tr_add2.
		down with frame so_tr_add2.
	end.
	
	find first bk_mstr where bk_code = ad_user2 no-lock no-error.
	bkline = 2.
	if available ad_mstr and available bk_mstr then do:
		display
			bkline
			ad_name
			bk_desc
			bk_bk_acct1
		with frame so_tr_add2.
		down with frame so_tr_add2.
	end.
	*/