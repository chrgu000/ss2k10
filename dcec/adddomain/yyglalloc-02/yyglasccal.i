/*  自动费用分摊子程序


	计算某一账户的期间发生费用。
	
	{1}  account
	{2}  sub-acct
	{3}  cost center
	{4}	 return value
	
*/
/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 09/06/12  ECO: *SS-20120906.1*   */


	do:
		{4} = 0.
		
 		for each glt_det no-lock 
		where  /* *SS-20120906.1*   */ glt_det.glt_domain = global_domain 
		and glt_acct = {1}
		and (glt_sub = {2})					
		and (glt_cc = {3} or {3} = "?")
		and glt_effdate >= perdt_from and glt_effdate <= perdt_to
		:
			{4} = {4} + glt_amt.
		end. 
 
		for each gltr_hist no-lock 
		where  /* *SS-20120906.1*   */ gltr_hist.gltr_domain = global_domain 
		and gltr_acc = {1}
		and (gltr_sub = {2})					
		and (gltr_ctr = {3} or {3} = "?")
		and gltr_eff_dt >= perdt_from and gltr_eff_dt <= perdt_to
 	    use-index gltr_acc_ctr  
		:
			{4} = {4} + gltr_amt.
		end. 
 
	end.
