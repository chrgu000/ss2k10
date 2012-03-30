
{ xxrepkup1.i }    
/*
for each xxwa_det no-lock
break by xxwa_site
      by xxwa_line
      by xxwa_part
      by xxwa_date
      by xxwa_rtime:
   /*
   display xxwa_date xxwa_site xxwa_line xxwa_part 
   xxwa_pstime  /* 货架拿到备料区的时间  */
   xxwa_sstime  /* 从备料区发出的时间    */
   string(xxwa_rtime,"hh:mm:ss") label "time" xxwa_ord_mult.
   */
   find first tiss1 where 
     tiss1_sdate    = xxwa_date     and
     tiss1_stime    = xxwa_sstime   and
     tiss1_line     = xxwa_line     and
     tiss1_part     = xxwa_part   
     no-error.
   if not avail tiss1 then do:
   	 create tiss1.
     assign
       tiss1_sdate    = xxwa_date     
       tiss1_pdate    = xxwa_date     
       tiss1_ptime    = xxwa_pstime   
       tiss1_stime    = xxwa_sstime   
       tiss1_rtime    = xxwa_rtime   
       tiss1_line     = xxwa_line     
       tiss1_part     = xxwa_part     
   	   tiss1_qty      = 0 
   	 .
   end.
   tiss1_qty = tiss1_qty + xxwa_ord_mult.
end.
*/
define var myqty like ld_qty_oh.
define var myseq as int.
for each tsupp:
  	find first pt_mstr no-lock where pt_part = tsu_part .  
  	tsu_abc     = pt__chr10.
  	if pt__qad19 <= 0 then tsu_lit = 1 .
  	else tsu_lit     = pt__qad19.
  	if pt__qad20 <= 0 then tsu_big = 1 .
  	else tsu_big     = pt__qad20.
  	  tsu_lpacks  = truncate( tsu_qty / tsu_lit ,0).
  	  tsu_ltrail  = tsu_qty - tsu_lit * tsu_lpacks.
  	  tsu_bpacks  = truncate(tsu_qty / tsu_big , 0).
  	  tsu_btrail  = tsu_qty - tsu_big * tsu_bpacks.
  	.
  	find first loc_mstr where loc_site = "gsa01" and loc_loc = tsu_loc.
  	if substring(loc_user2,1,1) = "Y" then tsu_flg = "Y" .
  	tsu_tqty = tsu_qty.
end.
/* 检查库存中已经分配的物料 */
/*
output to "/home/admin/testrepkall.txt".
put "11111=" skip.
for each tsupp:
  EXPORT DELIMITER ";" tsupp.
end.
put "2222=" skip.
for each tiss1:
  EXPORT DELIMITER ";" tiss1.
end.
output close.
*/
myseq = 0 .
for each tt1swddet break by tt1swd_part by tt1swd_lot by tt1swd_ref by tt1swd_time :
  if first-of(tt1swd_ref) then do:
    myqty = 0 .
    for each tsupp no-lock where (tsu_loc = "P-ALL" or tsu_flg = "Y") and tsu_part = tt1swd_part and tsu_lot = tt1swd_lot and tsu_ref = tt1swd_ref:
    	myqty = myqty + tsu_qty.
    end.
  end.
  myqty = myqty - tt1swd_qty.
  if last-of(tt1swd_ref) then do:
    if myqty < 0 then do:
      create ttmsg.
      tmsg = "物料:" + tt1swd_part + "批次:" + tt1swd_lot + "参考:" + tt1swd_ref + "无法满足发放".
      myseq = myseq + 1.
    end.
  end.
end.
for each tt1pwddet break by tt1pwd_loc by tt1pwd_part by tt1pwd_lot by tt1pwd_ref by tt1pwd_time :
  if first-of(tt1pwd_ref) then do:
    myqty = 0 .
    for each tsupp no-lock where tsu_loc = tt1pwd_loc and tsu_part = tt1pwd_part and tsu_lot = tt1pwd_lot and tsu_ref = tt1pwd_ref:
    	myqty = myqty + tsu_qty.
    end.
  end.
  myqty = myqty - tt1pwd_qty.
  if last-of(tt1pwd_ref) then do:
    if myqty < 0 then do:
      create ttmsg.
      tmsg = "物料:" + tt1pwd_part + "批次:" + tt1pwd_lot + "参考:" + tt1pwd_ref + "无法满足备料".
      myseq = myseq + 1.
    end.
  end.
end.
if myseq > 0 then return.
/* 现有库存和单据无法匹配 */
/* 进行第一次消耗模拟 */
    for each tt1swddet :
      find first tsupp where tsu_loc = "P-ALL" and tsu_part = tt1swd_part and tsu_lot = tt1swd_lot and tsu_ref = tt1swd_ref no-error.
      if not avail tsupp then do:
        create tsupp.
        assign 
          tsu_loc  = "P-ALL" 
          tsu_part = tt1swd_part 
          tsu_lot  = tt1swd_lot 
          tsu_ref  = tt1swd_ref
          tsu_qty  = 0 
        .
      end.
      tsu_qty = tsu_qty - tt1swd_qty.      
  	  tsu_lpacks  = truncate( tsu_qty / tsu_lit ,0).
  	  tsu_ltrail  = tsu_qty - tsu_lit * tsu_lpacks.
  	  tsu_bpacks  = truncate(tsu_qty / tsu_big , 0).
  	  tsu_btrail  = tsu_qty - tsu_big * tsu_bpacks.
    end.
    for each tt1pwddet : 
      find first tsupp where tsu_loc = tt1pwd_loc and tsu_part = tt1pwd_part and tsu_lot = tt1pwd_lot and tsu_ref = tt1pwd_ref no-error.
      if not avail tsupp then do:
        create tsupp.
        assign 
          tsu_loc  = tt1pwd_loc
          tsu_part = tt1pwd_part
          tsu_lot  = tt1pwd_lot 
          tsu_ref  = tt1pwd_ref
          tsu_qty  = 0 
        .
      end.
      tsu_qty = tsu_qty - tt1pwd_qty.            
  	  tsu_lpacks  = truncate( tsu_qty / tsu_lit ,0).
  	  tsu_ltrail  = tsu_qty - tsu_lit * tsu_lpacks.
  	  tsu_bpacks  = truncate(tsu_qty / tsu_big , 0).
  	  tsu_btrail  = tsu_qty - tsu_big * tsu_bpacks.
    end.    

/* 计算发料到生产线的队列 */
for each trlt1 : delete trlt1 . end.
myseq = 0 . 
for each tiss1 break by tiss1_part by tiss1_sdate by tiss1_rtime  by tiss1_line :
	/* 消耗生产线物料 */
	if first-of(tiss1_part) then myqty = 0.

  if first-of(tiss1_rtime) then do:
    /* 根据送料单增加生产线供应 */
    for each tt1swddet where tt1swd_part = tiss1_part and tt1swd_line = tiss1_line and tt1swd_date <= tiss1_sdate and tt1swd_time <= tiss1_rtime:
      find first tsupp where tsu_loc = tt1swd_line and tsu_part = tt1swd_part and tsu_lot = tt1swd_lot and tsu_ref = tt1swd_ref no-error.
      if not avail tsupp then do:
        create tsupp.
        assign 
          tsu_loc  = tt1swd_line 
          tsu_part = tt1swd_part 
          tsu_lot  = tt1swd_lot 
          tsu_ref  = tt1swd_ref
          tsu_qty  = 0 
        .
      end.
      tsu_qty = tsu_qty + tt1swd_qty.
    end.
    /* 根据备料单增加备料区供应 */    
    for each tt1pwddet where tt1pwd_part = tiss1_part and tt1pwd_line = tiss1_line and tt1pwd_date <= tiss1_sdate and tt1pwd_time <= tiss1_rtime: 
      tt1pwd_nbr = tiss1_nbr.
      find first tsupp where tsu_loc = "P-ALL" and tsu_part = tt1pwd_part and tsu_lot = tt1pwd_lot and tsu_ref = tt1pwd_ref no-error.
      if not avail tsupp then do:
        create tsupp.
        assign 
          tsu_loc  = tt1pwd_loc
          tsu_part = tt1pwd_part
          tsu_lot  = tt1pwd_lot 
          tsu_ref  = tt1pwd_ref
          tsu_qty  = 0 
        .
      end.
      tsu_qty = tsu_qty + tt1pwd_qty.          
  	  tsu_lpacks  = truncate( tsu_qty / tsu_lit ,0).
  	  tsu_ltrail  = tsu_qty - tsu_lit * tsu_lpacks.
  	  tsu_bpacks  = truncate(tsu_qty / tsu_big , 0).
  	  tsu_btrail  = tsu_qty - tsu_big * tsu_bpacks.
    end.
  end.
	if first-of(tiss1_line) then do:
    for each tsupp no-lock where tsu_loc = tiss1_line and tsu_part = tiss1_part :
    	myqty = myqty + tsu_qty.
    	tsu_qty = 0.
    end.
	end.
	myqty = myqty - tiss1_qty.
	if myqty >= 0 then next.
	/* 消耗备料区物料 */
	for each tsupp no-lock where tsu_part = tiss1_part and tsu_loc = "P-ALL" and tsu_lpacks > 0
		break by tsu_lot by tsu_ref  :
		if tsu_ltrail  > 0 then do:
			myseq = myseq + 1.
			create trlt1.   
			assign 
			  trt1_seq    = myseq
			  trt1_nbr    = tiss1_nbr
			  trt1_loc    = tsu_loc
			  trt1_line   = tiss1_line
			  trt1_part   = tsu_part
			  trt1_lot    = tsu_lot
			  trt1_ref    = tsu_ref
			  trt1_qty    = tsu_ltrail
			  trt1_stime  = tiss1_rtime
			  trt1_sdate  = tiss1_sdate
			.			
			myqty = myqty + tsu_ltrail.
			tsu_qty = tsu_qty - tsu_ltrail.
			tsu_ltrail = 0.
		end.
		do while tsu_lpacks > 0 and  myqty < 0 :		
			  myqty = myqty + tsu_lit.
			  tsu_lpacks = tsu_lpacks - 1.
			  tsu_qty = tsu_qty - tsu_lit.
		  	myseq = myseq + 1.
			  create trlt1.   
	  		assign 
  			  trt1_seq    = myseq
  			  trt1_nbr    = tiss1_nbr
		      trt1_line   = tiss1_line
		      trt1_loc    = tsu_loc
		      trt1_part   = tsu_part
		      trt1_lot    = tsu_lot
		      trt1_ref    = tsu_ref
		      trt1_qty    = tsu_lit
		      trt1_stime   = tiss1_rtime
		      trt1_sdate   = tiss1_sdate
		    .	
		end.
		if myqty >= 0 then leave.
	end.
	if myqty >= 0 then next.
	/* 消耗货架物料 */
	for each tsupp no-lock where tsu_part = tiss1_part and tsu_flg = "Y" and tsu_lpacks > 0 
		break by tsu_lot by tsu_ref by tsu_loc:
		if tsu_ltrail  > 0 then do:
			myseq = myseq + 1.
			create trlt1.   
			assign 
			  trt1_seq    = myseq
			  trt1_nbr    = tiss1_nbr
			  trt1_line   = tiss1_line
			  trt1_loc    = tsu_loc
			  trt1_part   = tsu_part
			  trt1_lot    = tsu_lot
			  trt1_ref    = tsu_ref
			  trt1_qty    = tsu_ltrail
	      trt1_stime  = tiss1_rtime
	      trt1_sdate  = tiss1_sdate
			.			
			myqty = myqty + tsu_ltrail.
			tsu_qty = tsu_qty - tsu_ltrail.
			tsu_ltrail = 0.
		end.
		if myqty < 0 then do:
		  do while tsu_lpacks > 0 and  myqty < 0 :		
			  myqty = myqty + tsu_lit.
			  tsu_qty = tsu_qty - tsu_lit.
			  tsu_lpacks = tsu_lpacks - 1.
		  	myseq = myseq + 1.
			  create trlt1.   
	  		assign 
  			  trt1_seq    = myseq
  			  trt1_nbr    = tiss1_nbr
		      trt1_loc    = tsu_loc
		      trt1_line   = tiss1_line
		      trt1_part   = tsu_part
		      trt1_lot    = tsu_lot
		      trt1_ref    = tsu_ref
		      trt1_qty    = tsu_lit
		      trt1_stime  = tiss1_rtime
		      trt1_sdate  = tiss1_sdate
		    .			
			end.
		end.
		if myqty >= 0 then leave.
	end.
end.

/* 计算取料到备料区的队列 */
for each trlt2: delete trlt2 . end.

for each trlt1 where trt1_loc <> "p-all" 
	break by trt1_part by trt1_sdate by trt1_stime 
	by trt1_loc by trt1_lot by trt1_ref	:
	if first-of(trt1_ref) then do:
		myqty = 0 .
	end.
	myqty = myqty - trt1_qty.
	/* 消耗已经取出的物料 */
	if myqty >= 0 then next.
	/* 消耗尾数的物料 */
	find first tsupp where tsu_loc = trt1_loc and tsu_part = trt1_part and tsu_lot = trt1_lot and  tsu_ref = trt1_ref .
	if tsu_btrail > 0 then do:
	  myseq = myseq + 1.
	  create trlt2.
	  assign 
	    trt2_seq      = myseq
	    trt2_nbr      = trt1_nbr
	    trt2_date     = trt1_sdate
	    trt2_time     = trt1_stime
	    trt2_loc      = trt1_loc
	    trt2_part     = trt1_part
	    trt2_lot      = trt1_lot
	    trt2_ref      = trt1_ref
	    trt2_qty      = tsu_btrail
	  .
	  myqty = myqty + tsu_btrail.
	  tsu_btrail = 0 .
  end.
	if myqty >= 0 then next.
	/* 消耗整托的物料 */
	do while myqty < 0 and tsu_bpacks > 0 :
	  myseq = myseq + 1.
	  create trlt2.
	  assign 
	    trt2_seq      = myseq
	    trt2_nbr      = trt1_nbr
	    trt2_date     = trt1_sdate
	    trt2_time     = trt1_stime
	    trt2_loc      = trt1_loc
	    trt2_part     = trt1_part
	    trt2_lot      = trt1_lot
	    trt2_ref      = trt1_ref
	    trt2_qty      = tsu_big
	  .
		myqty = myqty + tsu_big.
		tsu_bpacks = tsu_bpacks - 1.
	end.
	trt1_loc = "p-all".
end.
