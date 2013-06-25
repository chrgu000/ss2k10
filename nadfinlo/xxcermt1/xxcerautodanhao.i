/* Creation: eB21SP3 Chui Last Modified: 20080303 By: Davild Xu *ss-20080303.1*/
/*自动产生单据号*/
	
	find first rqf_ctrl where rqf__log01 = yes 
	no-error.
	if avail rqf_ctrl then do:
	
		danju = rqf__chr02 + rqf__chr03 .
		display danju with frame a .
		assign rqf__chr03 = string(int(rqf__chr03) + 1) .	
	end.