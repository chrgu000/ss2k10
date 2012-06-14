
{ xxrepkup1.i }    

define var prevtrail like ld_qty_oh.
define var prevdate  like tiss1_sdate.
define var prevtime  like tiss1_stime.
define var tempqtytl like ld_qty_oh.
define var myqty  like ld_qty_oh.
define var mylot  like tsu_lot.
define var myref  like tsu_ref.
define var myseq as int.
define buffer mysup for tsupp.
for each tsupp:  /* �������¼������ÿ����λ�Ĵ�С��װ�����ʹ�С��װ��Ӧ��β�� */
  run inittsupp(input tsup_part      ,input tsu_qty        ,input tsu_loc        ,input tsup_part      ,input tsup_part      ,
  output tsu_abc       ,output tsu_lit       ,output tsu_big       ,output tsu_flg       ,output tsu_lpacks    ,output tsu_bpacks    ,
  output tsu_ltrail    ,output tsu_btrail    ,output tsu_tqty   ).
end.
/* ��������Ѿ���������� */
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
      tmsg = "����:" + tt1swd_part + "����:" + tt1swd_lot + "�ο�:" + tt1swd_ref + "�޷����㷢��".
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
      tmsg = "����:" + tt1pwd_part + "����:" + tt1pwd_lot + "�ο�:" + tt1pwd_ref + "�޷����㱸��".
      myseq = myseq + 1.
    end.
  end.
end.
if myseq > 0 then do:
  thmsg = "���п��͵����޷�ƥ��".
  return.  /* ���п��͵����޷�ƥ��ֱ�ӷ��� */
end.

/* ���е�һ������ģ�⣬�������ϵ���P-all���ۼ�������λ��� */
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
  	  run inittsupp(input tsup_part      ,input tsu_qty        ,input tsu_loc        ,input tsup_part      ,input tsup_part      ,
      output tsu_abc       ,output tsu_lit       ,output tsu_big       ,output tsu_flg       ,output tsu_lpacks    ,output tsu_bpacks    ,
      output tsu_ltrail    ,output tsu_btrail    ,output tsu_tqty   ).
    end.
/* ���е�һ������ģ�⣬���ݱ��ϵ�(���ܿ�λ)�ۼ�������λ��� */
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
  	  run inittsupp(input tsup_part      ,input tsu_qty        ,input tsu_loc        ,input tsup_part      ,input tsup_part      ,
      output tsu_abc       ,output tsu_lit       ,output tsu_big       ,output tsu_flg       ,output tsu_lpacks    ,output tsu_bpacks    ,
      output tsu_ltrail    ,output tsu_btrail    ,output tsu_tqty   ).
    end.    

/* �������ӵķ��ϵ������ߵĶ��� */
for each trlt1 : delete trlt1 . end.
myseq = 0 . 
for each tiss1 break by tiss1_part by tiss1_sdate by tiss1_rtime  by tiss1_line :

  if first-of(tiss1_rtime) then do:  
    /* �������ϵ����������߹�Ӧ */
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
      run inittsupp(input tsup_part      ,input tsu_qty        ,input tsu_loc        ,input tsup_part      ,input tsup_part      ,
      output tsu_abc       ,output tsu_lit       ,output tsu_big       ,output tsu_flg       ,output tsu_lpacks    ,output tsu_bpacks    ,
      output tsu_ltrail    ,output tsu_btrail    ,output tsu_tqty   ).
    end.
    /* ���ݱ��ϵ����ӱ�������Ӧ */    
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
  	  run inittsupp(input tsup_part      ,input tsu_qty        ,input tsu_loc        ,input tsup_part      ,input tsup_part      ,
      output tsu_abc       ,output tsu_lit       ,output tsu_big       ,output tsu_flg       ,output tsu_lpacks    ,output tsu_bpacks    ,
      output tsu_ltrail    ,output tsu_btrail    ,output tsu_tqty   ).
    end.
  end.
	/* �������������� */
	for each tsupp no-lock where tsu_part = tiss1_part and tsu_loc = tiss1_line and tsu_qty > 0 
	  break by tsu_lot by tsu_ref  :
	  if tsu_qty >= tiss1_qty then do:
	    tsu_qty = tsu_qty - tiss1_qty.
	    tiss1_qty = 0 .
	  end.
	  else do:
	    tiss1_qty = tiss1_qty - tsu_qty.
	    tsu_qty = 0 .
	  end.
	end.
	if tiss1_qty <= 0 then next.
	/* ���ı��������� */
	if first-of(tiss1_part) then prevtrail = 0 .
	for each tsupp where tsu_part = tiss1_part and tsu_loc = "P-ALL" and (tsu_lpacks > 0 or tsu_ltrail > 0)
		break by tsu_lot by tsu_ref  :
		mylot = tsu_lot.
		myref = tsu_ref.
		if tsu_abc = "a" then do:  /* A������ */   
		  if prevtrail > 0 then do:
		    if tsu_qty >= prevtrail then do:  /* �ɰѷ��ϰ�װװ�� */
		      tiss1_qty = tiss1_qty - prevtrail.
		  	  tsu_qty = tsu_qty - prevtrail.
		  	  tsu_lpacks = truncate( tsu_qty / tsu_lit ,0).
		  	  tsu_ltrail  = tsu_qty - tsu_lit * tsu_lpacks.
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
		        trt1_qty    = prevtrail
		        trt1_stime   = prevtime  /* ���ں�ʱ�䶼��ȡ���ϴ�β�����������ڡ�ʱ���ɴ�ӡ��ʱ����ݹ���ת��Ϊ���ϡ���������ʱ�� */
		        trt1_sdate   = prevdate
		      .	
		    end.
		    else do:  /* ���ɰѷ��ϰ�װװ�� */
		      tempqtytl = tsu_qty.
		      tiss1_qty = tiss1_qty - tsu_qty.
		      prevtrail = prevtrail - tsu_qty.
		  	  tsu_qty = 0.
		  	  tsu_lpacks = truncate( tsu_qty / tsu_lit ,0).
		  	  tsu_ltrail  = tsu_qty - tsu_lit * tsu_lpacks.
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
		        trt1_qty    = tempqtytl
		        trt1_stime   = prevtime  /* ���ں�ʱ�䶼��ȡ���ϴ�β�����������ڡ�ʱ���ɴ�ӡ��ʱ����ݹ���ת��Ϊ���ϡ���������ʱ�� */
		        trt1_sdate   = prevdate
		      .	
		    end.
		  end.
		  if tiss1_qty <= 0 then leave.
		  do while tsu_lpacks > 0 and  tiss1_qty > 0 :		/* �����Ϲ������װ */
		  	  tiss1_qty = tiss1_qty - tsu_lit.
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
		        trt1_stime   = tiss1_rtime  /* ���ں�ʱ�䶼��ȡ���������ڡ�ʱ���ɴ�ӡ��ʱ����ݹ���ת��Ϊ���ϡ���������ʱ�� */
		        trt1_sdate   = tiss1_sdate
		      .	
		  end.
		  if tiss1_qty <= 0 then leave.
		  if tsu_ltrail  > 0 then do:   /* �����Ϲ��β�� */
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
        prevtrail = tsu_lit - tsu_ltrail.
        prevdate  = tiss1_sdate.
        prevtime  = tiss1_rtime.
        tsu_qty = tsu_qty - tsu_ltrail.
        tiss1_qty = tiss1_qty - tsu_ltrail .
        tsu_ltrail = 0 .
		  end.
		  if tiss1_qty <= 0 then leave.
		end.
		else do:  /* B,C������ */
		  if tsu_ltrail  > 0 then do:   /*�ȷ����Ϲ��β�� */
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
        tsu_qty = tsu_qty - tsu_ltrail.
        tsu_ltrail = 0 .
        tiss1_qty = tiss1_qty - tsu_ltrail .
		  end.
		  if tiss1_qty <= 0 then leave.
		  do while tsu_lpacks > 0 and  tiss1_qty > 0 :		/* �����Ϲ������װ */
		  	  tiss1_qty = tiss1_qty - tsu_lit.
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
		        trt1_stime   = tiss1_rtime  /* ���ں�ʱ�䶼��ȡ���������ڡ�ʱ���ɴ�ӡ��ʱ����ݹ���ת��Ϊ���ϡ���������ʱ�� */
		        trt1_sdate   = tiss1_sdate
		      .	
		  end.
		  if tiss1_qty <= 0 then leave.
	  end.
	end.
	if tiss1_qty < 0 then do:  /* �г��������������������� */
	    find first tsupp where tsu_part = tiss1_part and tsu_loc = tiss1_line 
         and tsu_lot = mylot and tsu_ref = myref no-error.
      if not avail tsupp then do:
        create tsupp.
        assign 
          tsu_loc  = tiss1_line 
          tsu_part = tiss1_part   
          tsu_lot  = mylot    
          tsu_ref  = myref    
          tsu_qty  = 0 
        .
      end.
		  tsu_qty = tsu_qty - tiss1_qty.
		  tiss1_qty = 0 .
		  run inittsupp(input tsup_part      ,input tsu_qty        ,input tsu_loc        ,input tsup_part      ,input tsup_part      ,
      output tsu_abc       ,output tsu_lit       ,output tsu_big       ,output tsu_flg       ,output tsu_lpacks    ,output tsu_bpacks    ,
      output tsu_ltrail    ,output tsu_btrail    ,output tsu_tqty   ).
	end.
	if tiss1_qty <= 0 then next.
	/* ���Ļ������� */
	for each tsupp no-lock where tsu_part = tiss1_part and tsu_flg = "Y" and (tsu_lpacks > 0 or tsu_ltrail > 0)
		break by tsu_lot by tsu_ref by tsu_loc:
		mylot = tsu_lot.
		myref = tsu_ref.
		if tsu_abc = "A" then do:  /* A������ */
		  if prevtrail > 0 then do:
		    if tsu_qty >= prevtrail then do:  /* �ɰѷ��ϰ�װװ�� */
		      tiss1_qty = tiss1_qty - prevtrail.
		  	  tsu_qty = tsu_qty - prevtrail.
		  	  tsu_lpacks = truncate( tsu_qty / tsu_lit ,0).
		  	  tsu_ltrail  = tsu_qty - tsu_lit * tsu_lpacks.
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
		        trt1_qty    = prevtrail
		        trt1_stime   = prevtime  /* ���ں�ʱ�䶼��ȡ���ϴ�β�����������ڡ�ʱ���ɴ�ӡ��ʱ����ݹ���ת��Ϊ���ϡ���������ʱ�� */
		        trt1_sdate   = prevdate
		      .	
		    end.
		    else do:  /* ���ɰѷ��ϰ�װװ�� */
		      tempqtytl = tsu_qty.
		      tiss1_qty = tiss1_qty - tsu_qty.
		      prevtrail = prevtrail - tsu_qty.
		  	  tsu_qty = 0.
		  	  tsu_lpacks = truncate( tsu_qty / tsu_lit ,0).
		  	  tsu_ltrail  = tsu_qty - tsu_lit * tsu_lpacks.
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
		        trt1_qty    = tempqtytl
		        trt1_stime   = prevtime  /* ���ں�ʱ�䶼��ȡ���ϴ�β�����������ڡ�ʱ���ɴ�ӡ��ʱ����ݹ���ת��Ϊ���ϡ���������ʱ�� */
		        trt1_sdate   = prevdate
		      .	
		    end.
		  end.
		  do while tsu_lpacks > 0 and  tiss1_qty > 0 :		/* ���ı��Ϲ�������װ */
		    tiss1_qty = tiss1_qty - tsu_lit.
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
		  if tiss1_qty <= 0 then leave.
		  if tsu_ltrail  > 0 then do:  /* ���ı��Ϲ���β�� */
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
		  	tiss1_qty = tiss1_qty - tsu_ltrail.
		  	tsu_qty = tsu_qty - tsu_ltrail.
		  	tsu_ltrail = 0.
		  end.
		  if tiss1_qty <= 0 then leave.		
		end.
		else do: /* ��A������ */
		  if tsu_ltrail  > 0 then do:  /* ���ı��Ϲ���β�� */
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
		  	tiss1_qty = tiss1_qty - tsu_ltrail.
		  	tsu_qty = tsu_qty - tsu_ltrail.
		  	tsu_ltrail = 0.
		  end.
		  if tiss1_qty <= 0 then leave.		
		  do while tsu_lpacks > 0 and  tiss1_qty > 0 :		/* ���ı��Ϲ�������װ */
		    tiss1_qty = tiss1_qty - tsu_lit.
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
		  if tiss1_qty <= 0 then leave.
	  end.
	end.
	if tiss1_qty < 0 then do:  /* �г��������������������� */
	    find first tsupp where tsu_part = tiss1_part and tsu_loc = tiss1_line 
         and tsu_lot = mylot and tsu_ref = myref no-error.
       if not avail tsupp then do:
         create tsupp.
         assign 
           tsu_loc  = tiss1_line 
           tsu_part = tiss1_part   
           tsu_lot  = mylot    
           tsu_ref  = myref    
           tsu_qty  = 0 
         .
       end.
		  tsu_qty = tsu_qty - tiss1_qty.
		  tiss1_qty = 0 .
		  run inittsupp(input tsup_part      ,input tsu_qty        ,input tsu_loc        ,input tsup_part      ,input tsup_part      ,
      output tsu_abc       ,output tsu_lit       ,output tsu_big       ,output tsu_flg       ,output tsu_lpacks    ,output tsu_bpacks    ,
      output tsu_ltrail    ,output tsu_btrail    ,output tsu_tqty   ).
	end.
	/*
	if tiss1_qty <= 0 then next.	
	*/
end.

/* ����ȡ�ϵ��������Ķ��� */
for each trlt2: delete trlt2 . end.

for each trlt1 where trt1_loc <> "p-all" 
	break by trt1_part by trt1_sdate by trt1_stime 
	by trt1_loc by trt1_lot by trt1_ref	:
	if first-of(trt1_ref) then do:
		myqty = 0 .
	end.
	myqty = myqty - trt1_qty.
	/* �����Ѿ�ȡ�������� */
	if myqty >= 0 then next.
	/* ����β�������� */
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
	/* �������е����� */
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


procedure inittsupp:
    DEF INPUT PARAMETER myttpart like tsup_part .
    DEF INPUT PARAMETER myttqty  like tsu_qty   .
    DEF INPUT PARAMETER myttloc  like tsu_loc   .
    DEF INPUT PARAMETER myttpart like tsup_part .
    DEF INPUT PARAMETER myttpart like tsup_part .
    
    DEF OUTPUT PARAMETER myttabc     like tsu_abc    .
    DEF OUTPUT PARAMETER myttlit     like tsu_lit    .
    DEF OUTPUT PARAMETER myttbig     like tsu_big    .
    DEF OUTPUT PARAMETER myttflg     like tsu_flg    .
    DEF OUTPUT PARAMETER myttlpacks  like tsu_lpacks .
    DEF OUTPUT PARAMETER myttbpacks  like tsu_bpacks .
    DEF OUTPUT PARAMETER myttltrail  like tsu_ltrail .
    DEF OUTPUT PARAMETER myttbtrail  like tsu_btrail .
    DEF OUTPUT PARAMETER mytttqty    like tsu_tqty   .
    
  	find first pt_mstr no-lock where pt_part = myttpart .  
  	myttabc     = pt__chr10.
  	if pt__qad19 <= 0 then myttlit = 1 .
  	else myttlit     = pt__qad19.
  	if pt__qad20 <= 0 then myttbig = 1 .
  	else myttbig     = pt__qad20.
  	  myttlpacks  = truncate( myttqty / myttlit ,0).
  	  myttltrail  = myttqty - myttlit * myttlpacks.
  	  myttbpacks  = truncate(myttqty / myttbig , 0).
  	  myttbtrail  = myttqty - myttbig * myttbpacks.
  	.
  	find first loc_mstr where loc_site = "gsa01" and loc_loc = myttloc.
  	if substring(loc_user2,1,1) = "Y" then myttflg = "Y" .  /* ���ܿ�λ�������߿�λ�ı�־ */
  	mytttqty = myttqty.  
end procedure.