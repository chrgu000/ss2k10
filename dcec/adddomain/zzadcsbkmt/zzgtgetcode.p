/* 得到金税代码*/
/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 08/29/12  ECO: *SS-20120829.1*   */


 /* *SS-20120829.1*   */ tr_hist.tr_domain = global_domain and 

	define input parameter cust as char.
	
	define output parameter gtcode as char.
	
	
	find first ad_mstr no-lock where  /* *SS-20120829.1*   */ ad_mstr.ad_domain = global_domain and  ad__chr01 = cust no-error.
	
	gtcode = if available ad_mstr then ad_addr else "".
	
	