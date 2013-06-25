/* ss-090108.1 by jack */

    /* 注意po到期日为空的控制 */
     

     for first pt_mstr
     fields(  pt_part pt_prod_line)
    where  pt_part = pod_part
    no-lock:
    end. 

  if po_pr_list2 <> "" then do :

    for last pc_mstr
/*N0CD*/    fields(  pc_amt pc_amt_type pc_curr pc_expire pc_list
/*N0CD*/           pc_max_price pc_min_price pc_part pc_prod_line
/*N0CD*/           pc_start pc_um)
/*N0CD*/     where  (  pc_list     = po_pr_list2  and
/*N0CD*/          pc_amt_type = "L"                           and
/*N0CD*/          pc_part     = pod_part                          and
/*N0CD*/          pc_um       = pod_um                            and
/*N0CD*/          (pc_start <= pod_due_date or pc_start = ?)      and
/*N0CD*/          (pc_expire >= pod_due_date or pc_expire = ?)    and
          pc_curr    = po_curr ) no-lock
/*N0CD*/    :
/*N0CD*/ end. /* FOR LAST PC_MSTR */

     /* FIND PRICE LIST FOR pod_part REGARDLESS OF pod_um */
     if not available pc_mstr then

/*N0CD*/ for last pc_mstr
/*N0CD*/    fields(  pc_amt pc_amt_type pc_curr pc_expire pc_list
/*N0CD*/           pc_max_price pc_min_price pc_part pc_prod_line
/*N0CD*/           pc_start pc_um)
/*N0CD*/     where  (  pc_list = po_pr_list2    
                 and pc_amt_type = "L"                           and
/*N0CD*/          pc_part     = pod_part                          and
/*N0CD*/          pc_um       = ""                            and
/*N0CD*/          (pc_start <= pod_due_date or pc_start = ?)      and
/*N0CD*/          (pc_expire >= pod_due_date or pc_expire = ?)    and
          pc_curr     = po_curr ) no-lock:
/*N0CD*/ end. /* FOR LAST PC_MSTR */

     /* FIND PRICE LIST FOR PRODUCT LINE AND pod_um */
     if not available pc_mstr and available pt_mstr then
/*N0CD*/ for last pc_mstr
/*N0CD*/    fields(  pc_amt pc_amt_type pc_curr pc_expire pc_list
/*N0CD*/           pc_max_price pc_min_price pc_part pc_prod_line
/*N0CD*/           pc_start pc_um)
/*N0CD*/     where (  pc_list      = po_pr_list2  and
/*N0CD*/          pc_amt_type  = "L"                                and
/*N0CD*/          pc_part      =  ""                                and
/*N0CD*/          pc_prod_line = pt_prod_line                       and
/*N0CD*/          pc_um        = pod_um                                 and
/*N0CD*/          (pc_start <= pod_due_date or pc_start = ?)            and
/*N0CD*/          (pc_expire >= pod_due_date or pc_expire = ?)          and
          pc_curr     = po_curr ) no-lock:
/*N0CD*/ end. /* FOR LAST PC_MSTR */

     /* FIND PRICE LIST FOR PRODUCT LINE REGARDLESS OF pod_um */
     if not available pc_mstr and available pt_mstr then
/*N0CD*/ for last pc_mstr
/*N0CD*/    fields(  pc_amt pc_amt_type pc_curr pc_expire pc_list
/*N0CD*/           pc_max_price pc_min_price pc_part pc_prod_line
/*N0CD*/           pc_start pc_um)
/*N0CD*/     where  (  pc_list      = po_pr_list2      and
/*N0CD*/          pc_amt_type  = "L"                                and
/*N0CD*/          pc_prod_line = pt_prod_line                       and
/*N0CD*/          pc_part      = ""                                 and
/*N0CD*/          pc_um        = ""                                 and
/*N0CD*/          (pc_start <= pod_due_date or pc_start = ?)            and
/*N0CD*/          (pc_expire >= pod_due_date or pc_expire = ?)          and
          pc_curr      = po_curr ) no-lock :
/*N0CD*/ end. /* FOR LAST PC_MSTR */

/*H1HH*/ if not available pc_mstr then


/*N0CD*/ for last pc_mstr
/*N0CD*/    fields(  pc_amt pc_amt_type pc_curr pc_expire pc_list
/*N0CD*/           pc_max_price pc_min_price pc_part pc_prod_line
/*N0CD*/           pc_start pc_um)
/*N0CD*/     where  (  pc_list      = po_pr_list2       and
/*N0CD*/          pc_amt_type  = "L"                               and
/*N0CD*/          pc_prod_line = ""                                and
/*N0CD*/          pc_part      = ""                                and
/*N0CD*/          pc_um        = pod_um                                and
/*N0CD*/          (pc_start <= pod_due_date or pc_start = ?)           and
/*N0CD*/          (pc_expire >= pod_due_date or pc_expire = ?)         and
          pc_curr      = po_curr ) no-lock:
/*N0CD*/ end. /* FOR LAST PC_MSTR */

        if not available pc_mstr then

/*N0CD*/ for last pc_mstr
/*N0CD*/    fields(  pc_amt pc_amt_type pc_curr pc_expire pc_list
/*N0CD*/           pc_max_price pc_min_price pc_part pc_prod_line
/*N0CD*/           pc_start pc_um)
/*N0CD*/     where  (  pc_list      =
po_pr_list2                       and
/*N0CD*/          pc_amt_type  = "L"                               and
/*N0CD*/          pc_prod_line = ""                                and
/*N0CD*/          pc_part      = ""                                and
/*N0CD*/          pc_um        = ""                                and
/*N0CD*/          (pc_start <= pod_due_date or pc_start = ?)           and
/*N0CD*/          (pc_expire >= pod_due_date or pc_expire = ?)         and
          pc_curr      = po_curr ) no-lock
/*N0CD*/    query-tuning(no-index-hint hint "INDEX_DESC(T0 PC_MSTR##PC_LIST)"):
/*N0CD*/ end. /* FOR LAST PC_MSTR */

     if available pc_mstr then do:

        /* PLUG PRICE FROM PRICE TABLE */
      if  pc_amt[1] > 0 then do:
       if pc_um = pod_um then
         v_amt1 = pc_amt[1].
        else
        v_amt1 = pc_amt[1] * pod_um_conv.
      end.
     end.
     else do :
      v_amt1 = 0 .
     end . /* not pc_mstr */
  end . /* po_pr_list2 <> "" */
  else v_amt1 = 0 .  /* po_pr_list2 = "" */
  v_amt = v_amt1 .
 

 
 if po_pr_list <> "" then do :

 for last pc_mstr
     fields(  pc_amt pc_amt_type pc_curr pc_expire pc_list
            pc_min_qty pc_part pc_prod_line pc_start pc_um)
      where  (  pc_list =  po_pr_list and
          pc_part = pod_part  and
          pc_um   = pod_um     and
          ((pc_start    <= pod_due_date or pc_start = ?) or pod_due_date = ? )  and
           ((pc_expire   >= pod_due_date or pc_expire = ?) or pod_due_date = ? ) and
           pc_curr      = po_curr                        and
           pc_amt_type  = "p" ) no-lock:
 end. 
     if not available pc_mstr then

 for last pc_mstr
    fields(  pc_amt pc_amt_type pc_curr pc_expire pc_list
           pc_min_qty pc_part pc_prod_line pc_start pc_um)
      where (  pc_list = po_pr_list   and
          pc_part      = pod_part   and
          pc_um        = ""                          and
           ((pc_start    <= pod_due_date or pc_start = ?) or pod_due_date = ? ) and
           ((pc_expire   >= pod_due_date or pc_expire = ?) or pod_due_date = ? ) and
           pc_curr      = po_curr                        and
           pc_amt_type  = "p" ) no-lock:
 end. 
    
     if not available pc_mstr and available pt_mstr then

 for last pc_mstr
     fields( pc_amt pc_amt_type pc_curr pc_expire pc_list
            pc_min_qty pc_part pc_prod_line pc_start pc_um)
      where  (  pc_list      =
po_pr_list                  and
          pc_part      = ""                          and
          pc_prod_line = pt_prod_line                and
           pc_um        = pod_um                          and
          ((pc_start    <= pod_due_date or pc_start = ?) or pod_due_date = ? ) and
           ((pc_expire   >= pod_due_date or pc_expire = ?) or pod_due_date = ? ) and
           pc_curr      = po_curr                        and
           pc_amt_type  = "p" ) no-lock:
 end. 

     
     if not available pc_mstr and available pt_mstr then

 for last pc_mstr
     fields(  pc_amt pc_amt_type pc_curr pc_expire pc_list
            pc_min_qty pc_part pc_prod_line pc_start pc_um)
      where  (  pc_list      =
po_pr_list                  and
          pc_prod_line = pt_prod_line                and
           pc_part      = ""                          and
           pc_um        = ""                          and
           ((pc_start    <= pod_due_date or pc_start = ?) or pod_due_date = ? ) and
           ((pc_expire   >= pod_due_date or pc_expire = ?) or pod_due_date = ? ) and
           pc_curr      = po_curr                        and
           pc_amt_type  = "p" ) no-lock:
 end. 
  
     if not available pc_mstr then

 for last pc_mstr
    fields(  pc_amt pc_amt_type pc_curr pc_expire pc_list
          pc_min_qty pc_part pc_prod_line pc_start pc_um)
     where  (  pc_list      =
po_pr_list                  and
         pc_part      = ""                          and
          pc_prod_line = ""                          and
          pc_um        = pod_um                          and
           ((pc_start    <= pod_due_date or pc_start = ?) or pod_due_date = ? )  and
          ((pc_expire   >= pod_due_date or pc_expire = ?) or pod_due_date = ? ) and
           pc_curr      = po_curr                        and
           pc_amt_type  = "p" ) no-lock:
 end. 
   
     if not available pc_mstr then

 for last pc_mstr
     fields(  pc_amt pc_amt_type pc_curr pc_expire pc_list
            pc_min_qty pc_part pc_prod_line pc_start pc_um)
      where  (  pc_list      =
po_pr_list                  and
          pc_prod_line = ""                          and
           pc_part      = ""                          and
           pc_um        = ""                          and
          ( (pc_start    <= pod_due_date or pc_start = ?) or pod_due_date = ? ) and
          ((pc_expire   >= pod_due_date or pc_expire = ?) or pod_due_date = ? ) and
           pc_curr      = po_curr                        and
           pc_amt_type  = "p" ) no-lock:
 end. 

     if available pc_mstr then do:

        if v_qty < 0 then v_qty = v_qty * -1.

       /* Convert to stock pod_um if we don't have a pod_um match */
       if pc_um <> pod_um then v_qty = v_qty * pod_um_conv.

              ii = 1 .
               
               IF v_qty >= pc_min_qty[1] AND pc_amt[1] <> 0 THEN DO:
	          if pc_um = pod_um then do :
		    v_amt = pc_amt[1] .
                    if v_amt1 <> 0 then do :
		      v_disc = (v_amt1 - v_amt ) / v_amt1  * 100.
		    end .
		    else v_disc = 0  . /* 没有l价格 */
                   end .
		   else do : /* pc_um <> pod_um */
		   v_amt = pc_amt[1] * pod_um_conv.
		   if v_amt1 <> 0 then do :
		     v_disc = (v_amt1 - v_amt ) / v_amt1 * 100.
	            end .
	             else v_disc = 0  . /* 没有l价格 */
		   end .
               END.
               REPEAT ii = 2 TO 15 :
                   IF (pc_min_qty[ii] <> 0 ) AND v_qty >= pc_min_qty[ii] AND pc_amt[ii] <> 0 THEN DO:
                       if pc_um = pod_um then do :
		         v_amt = pc_amt[ii] .
                         if v_amt1 <> 0 then do :
		          v_disc = (v_amt1 - v_amt ) / v_amt1 * 100.
		         end .
		         else v_disc = 0  . /* 没有l价格 */
                        end .
		        else do : /* pc_um <> pod_um */
		        v_amt = pc_amt[ii] * pod_um_conv.
		         if v_amt1 <> 0 then do :
		         v_disc = (v_amt1 - v_amt ) / v_amt1 * 100 .
	                 end .
	                 else v_disc = 0  . /* 没有l价格 */
		       end . 
                   END.
               END.
    end.  /* available pc_mstr */
   else do :
        assign v_disc = 0  .
   end .
  end . /* po_pr_list <> "" */
  else  v_disc = 0 .



  
