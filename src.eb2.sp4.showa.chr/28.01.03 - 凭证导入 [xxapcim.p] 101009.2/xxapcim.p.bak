/* ss - 090911.1 by: jack */
/* ss - 091111.1 by: jack */
/* ss - 091111.2 by: jack */
/* ss - 091112.1 by: jack */
/* ss - 100923.1 by: jack */  /* 需要检验*/
/* ss - 101009.1 by: SamSong */  /* 修改默认路径*/
/* ss - 101009.2 by: SamSong */  /* CIM TAX */

/*
{mfdtitle.i "091112.1 "}
*/
{mfdtitle.i "101009.2 "}

    /*
&SCOPED-DEFINE PP_FRAME_NAME A
      */

DEF VAR fn_me AS CHAR FORMAT "x(30)" INIT "/cim/hz/cim.txt" .
DEF VAR fn_error AS CHAR FORMAT "x(30)" INIT "/cim/hz/ap_err.txt" .
DEF VAR fn_i AS CHAR .
DEF VAR i AS INTEGER .
DEF VAR j AS INTEGER .
DEF VAR v_tax LIKE pt_taxable .
DEF VAR v_tax1 LIKE pt_taxable .

DEF VAR v_flag AS LOGICAL.
DEF VAR v_sort AS CHAR .
DEF VAR v_year AS CHAR.
DEF VAR v_month AS CHAR.
DEF VAR v_nbr AS CHAR.
DEF VAR v_flag_nbr AS CHAR.
DEF VAR v_ord_date AS CHAR.
DEF VAR vv_ord_date LIKE tr_effdate .
DEF VAR vv_ord_date1 LIKE tr_effdate .

/* ss - 090909.1 -b */
define var v_curr like vd_curr .
define var v_um like pt_um .
define var v_date as date .
define var v_part like pt_part .
define var v_logical as logical .
define var v_pvo_qty like vph_inv_qty .
define var v_pur_cost like vph_curr_amt .
/* ss - 090909.1 -e */

define var v_file as char format "x(40)" .
define var quote as char format "x(2)" initial '"' .
define var v_error as logical .
define var v_entity like gl_entity .

DEF TEMP-TABLE tt 
    field tt_batch as char
    field tt_ref like ap_ref
    field tt_po like vpo_po
    field tt_vend like ap_vend
    field tt_effdate like ap_effdate
    field tt_invoice as char format "x(20)" 
    field tt_date like ap_date
    field tt_cr_terms like vo_cr_terms
    field tt_receiver like prh_receiver
    field tt_line like prh_line
    field tt_inv_qty like vph_inv_qty
    field tt_curr_amt like vph_curr_amt
    field tt_close_pvo as logical
    field tt_tax_edit as logical
    field tt_hold_amt like vo_hold_amt
    field tt_confirmed like vo_confirmed
    field tt_qad01 like vo__qad01
    /* 101009.2  START  */
    field tt_usage as char format "x(10)"
    field tt_type  as char format "x(8)"
    field tt_including as char format "x(1)"
    /* 101009.2  END  */

    field tt_flag as int
    .

    DEF TEMP-TABLE tt2 
    field tt2_batch as char
    field tt2_ref like ap_ref
    field tt2_po like vpo_po
    field tt2_vend like ap_vend
    field tt2_effdate like ap_effdate
    field tt2_invoice as char format "x(20)" 
    field tt2_date like ap_date
    field tt2_cr_terms like vo_cr_terms
    field tt2_receiver like prh_receiver
    field tt2_line like prh_line
    field tt2_inv_qty like vph_inv_qty
    field tt2_curr_amt like vph_curr_amt
    field tt2_close_pvo as logical
    field tt2_tax_edit as logical
    field tt2_hold_amt like vo_hold_amt
    field tt2_confirmed like vo_confirmed
    field tt2_qad01 like vo__qad01
    /* 101009.2  START  */
    field tt2_usage as char format "x(10)"
    field tt2_type  as char format "x(8)"
    field tt2_including as char format "x(1)"
    /* 101009.2  END  */
    field tt2_flag as logical 
    field tt2_desc as char format "x(30)" 
    .

define buffer tt1 for tt .



FORM
    

    SKIP(1)
    v_file  colon 20    label "导入文件"
    v_logical  colon 20    label "是否本位币"
    fn_me   COLON 20    LABEL "导入时的信息文件"
    fn_error colon 20   label "未导入的信息文件"
    "导入文件请以逗号分隔;去除标题行" SKIP
    "批处理，凭证，订单，供应商，生效日期，发票，日期，支付方式，收货单，"
    "项次，发票数量，发票成本，已结项, 编辑税明细，暂留金额， 已确认，承办人" skip
    "税用途,纳税类型，是否纳税"

    SKIP(1)
    with frame a side-labels width 80 ATTR-SPACE
     .



/* Main Repeat */
mainloop:
repeat :
  view frame a .

  update 
      v_file
      v_logical
      fn_me
      fn_error
      
      with frame a.
  
 
  /* 文件的命名规则:SOyyyymmdd99 */
  i = 101.
  REPEAT :
      fn_i = "ap" + STRING(YEAR(TODAY))            + 
             SUBSTRING(STRING(100 + MONTH(TODAY)),2,2) + 
             SUBSTRING(STRING(100 + DAY(TODAY)),2,2)   + 
             SUBSTRING(STRING(i),2,2).
      IF SEARCH(fn_i + ".inp") = ? THEN DO:
          LEAVE.
      END.
      i = i + 1.
  END.




  fn_i = "ap" + string(year(today),"9999") + string(month(today),"99") + string(day(today),"99") + string(time,"99999") .
  
  FOR EACH tt:
      DELETE tt.
  END.
 
  for each tt2 :
    delete tt2 .
  end .

  /*
  MESSAGE "正在导入数据,请等待......" . 
    */

find first gl_ctrl no-lock no-error .
if available gl_ctrl then
v_entity = gl_entity .
    
  input from value(v_file) .
  repeat:
      create tt .
      import delimiter "," tt_batch tt_ref tt_po tt_vend tt_effdate tt_invoice tt_date tt_cr_terms tt_receiver tt_line tt_inv_qty tt_curr_amt 
             tt_close_pvo tt_tax_edit tt_hold_amt tt_confirmed tt_qad01 tt_usage tt_type tt_including .
     
  end .

for each tt where tt_po = "" and tt_receiver = "" and tt_ref = "" :
delete tt .
end .

/* tt_flag = 1 表示有错误 */
for each tt  where tt_po = "" or tt_receiver = "" or tt_ref = "" :
   
   if tt_po = "" then do:
    create tt2 .
        assign 
	     tt2_batch = tt_batch
	     tt2_ref = tt_ref
	     tt2_po = tt_po
	     tt2_vend = tt_vend
	     tt2_effdate = tt_effdate
	     tt2_invoice = tt_invoice 
	     tt2_date = tt_date
	     tt2_cr_terms = tt_cr_terms
	     tt2_receiver = tt_receiver
	     tt2_line = tt_line
	     tt2_inv_qty = tt_inv_qty
	     tt2_curr_amt = tt_curr_amt
	     tt2_close_pvo = tt_close_pvo
	     tt2_tax_edit = tt_tax_edit
	     tt2_hold_amt = tt_hold_amt
	     tt2_confirmed = tt_confirmed
	     tt2_qad01 = tt_qad01
    /* 101009.2  START  */
             tt2_usage  = tt_usage
             tt2_type   = tt_type
             tt2_including = tt_including
    /* 101009.2  END  */

	     tt2_flag = yes 
	     tt2_desc = "订单为空"
	     .
    end .

    if tt_receiver = "" then do:
    create tt2 .
        assign 
	     tt2_batch = tt_batch
	     tt2_ref = tt_ref
	     tt2_po = tt_po
	     tt2_vend = tt_vend
	     tt2_effdate = tt_effdate
	     tt2_invoice = tt_invoice 
	     tt2_date = tt_date
	     tt2_cr_terms = tt_cr_terms
	     tt2_receiver = tt_receiver
	     tt2_line = tt_line
	     tt2_inv_qty = tt_inv_qty
	     tt2_curr_amt = tt_curr_amt
	     tt2_close_pvo = tt_close_pvo
	     tt2_tax_edit = tt_tax_edit
	     tt2_hold_amt = tt_hold_amt
	     tt2_confirmed = tt_confirmed
    /* 101009.2  START  */
             tt2_usage  = tt_usage
             tt2_type   = tt_type
             tt2_including = tt_including
    /* 101009.2  END  */
	     tt2_qad01 = tt_qad01
	     tt2_flag = yes 
	     tt2_desc = "收货单为空"
	     .
    end .

    if tt_receiver = "" then do:
    create tt2 .
        assign 
	     tt2_batch = tt_batch
	     tt2_ref = tt_ref
	     tt2_po = tt_po
	     tt2_vend = tt_vend
	     tt2_effdate = tt_effdate
	     tt2_invoice = tt_invoice 
	     tt2_date = tt_date
	     tt2_cr_terms = tt_cr_terms
	     tt2_receiver = tt_receiver
	     tt2_line = tt_line
	     tt2_inv_qty = tt_inv_qty
	     tt2_curr_amt = tt_curr_amt
	     tt2_close_pvo = tt_close_pvo
	     tt2_tax_edit = tt_tax_edit
	     tt2_hold_amt = tt_hold_amt
	     tt2_confirmed = tt_confirmed
    /* 101009.2  START  */
             tt2_usage  = tt_usage
             tt2_type   = tt_type
             tt2_including = tt_including
    /* 101009.2  END  */

	     tt2_qad01 = tt_qad01
	     tt2_flag = yes 
	     tt2_desc = "凭证为空"
	     .
    end .



   tt_flag = 1 .
end .

for each tt  where tt_flag <> 1 :
   find first prh_hist where prh_receiver = tt_receiver and prh_nbr = tt_po and prh_line = tt_Line no-lock no-error .
   if not available prh_hist then do:
       create tt2 .
        assign 
	     tt2_batch = tt_batch
	     tt2_ref = tt_ref
	     tt2_po = tt_po
	     tt2_vend = tt_vend
	     tt2_effdate = tt_effdate
	     tt2_invoice = tt_invoice 
	     tt2_date = tt_date
	     tt2_cr_terms = tt_cr_terms
	     tt2_receiver = tt_receiver
	     tt2_line = tt_line
	     tt2_inv_qty = tt_inv_qty
	     tt2_curr_amt = tt_curr_amt
	     tt2_close_pvo = tt_close_pvo
	     tt2_tax_edit = tt_tax_edit
	     tt2_hold_amt = tt_hold_amt
	     tt2_confirmed = tt_confirmed
    /* 101009.2  START  */
             tt2_usage  = tt_usage
             tt2_type   = tt_type
             tt2_including = tt_including
    /* 101009.2  END  */
	     tt2_qad01 = tt_qad01
	     tt2_flag = yes 
	     tt2_desc = "没有收货记录"
	     .
	 tt_flag = 1 .
    end .

   /* ss - 100923.1 -b */
    FIND FIRST xxmqp_det WHERE xxmqp_receiver = tt_receiver AND xxmqp_line = tt_line  AND xxmqp_status = "1" NO-LOCK NO-ERROR .
    IF NOT AVAILABLE xxmqp_det  THEN DO:
          create tt2 .
        assign 
	     tt2_batch = tt_batch
	     tt2_ref = tt_ref
	     tt2_po = tt_po
	     tt2_vend = tt_vend
	     tt2_effdate = tt_effdate
	     tt2_invoice = tt_invoice 
	     tt2_date = tt_date
	     tt2_cr_terms = tt_cr_terms
	     tt2_receiver = tt_receiver
	     tt2_line = tt_line
	     tt2_inv_qty = tt_inv_qty
	     tt2_curr_amt = tt_curr_amt
	     tt2_close_pvo = tt_close_pvo
	     tt2_tax_edit = tt_tax_edit
	     tt2_hold_amt = tt_hold_amt
	     tt2_confirmed = tt_confirmed
    /* 101009.2  START  */
             tt2_usage  = tt_usage
             tt2_type   = tt_type
             tt2_including = tt_including
    /* 101009.2  END  */
	     tt2_qad01 = tt_qad01
	     tt2_flag = yes 
	     tt2_desc = "检验不合格或没有检验"
	     .
	 tt_flag = 1 .
    END.
    /* SS - 100923.1 -E */
  
end .


fn_i = fn_me  .
OUTPUT TO VALUE(fn_i + ".cim") .
if v_logical = yes then do:  /* 本位币*/
   for each tt no-lock where tt_flag <> 1 break by tt_ref  :
         
	 if last-of(tt_ref) then do:
	    put unformatted quote tt_batch quote skip .
	    put "-" skip .
	    put unformatted quote tt_ref quote  skip .
	
            
	    for each tt1 no-lock where tt1.tt_ref = tt.tt_ref  break by tt1.tt_po :
	     if first-of(tt1.tt_po) then
	      put unformatted quote  tt1.tt_po quote skip .
	    end .
	    
	    put "." skip .
        /* ss - 091111.2 -b
            put unformatted "- -"  space tt.tt_effdate  space "- -" skip .
         ss - 091111.2 -e */
        /* ss  - 091111.2 -b */
        put unformatted "- " SPACE tt.tt_vend  space tt.tt_effdate  space "- -" skip .

       /* ss - 091111.2 -e */

	    if tt.tt_invoice = "" then
	    put unformatted "- -" space "-" space tt.tt_date space "- - - - - - - - - -" space  quote v_entity quote space "- - - - -"  skip .
	    else
	    put unformatted "- -" space quote tt.tt_invoice quote space tt.tt_date space "- - - - - - - - - -" space  quote v_entity quote space "- - - - -"  skip .
	
	    if  tt.tt_invoice <> "" then do:
	     find first vo_mstr where vo_invoice = tt.tt_invoice and vo_ref <> tt.tt_ref no-lock no-error .
	     if available vo_mstr  then 
	    /* ss - 090927.1 -b
	     put "-" skip . /* 当发票存在另一凭证时*/
               ss - 090927.1 -e */
	     /* ss  - 090927.1 -b */
	      put SKIP (1) .
	     /* ss - 090927.1 -e */
	    end .

	    put "- -"  skip .
	    put no skip .
	    put "- - - - -" skip .
	 
           for each tt1 where tt1.tt_ref = tt.tt_ref no-lock :
	    put unformatted  quote tt1.tt_receiver quote space  tt1.tt_line  skip .
	    
	    /*201009.2 START */
	    if tt.tt_usage = "" then  put unformatted "- "  .
	    else                      put unformatted  """" + tt.tt_usage + """" + " " .

	    if tt.tt_type = ""  then  put unformatted "- "  .
	    else                      put unformatted  """" + tt.tt_type + """" + " " .

	    if tt.tt_including = "" then  put unformatted "- "  .
	    else                      put unformatted  """" + tt.tt_including + """" + " " .

	    put skip.

	    /* put "- - -" skip . /* 明细税*/  */

	    /*201009.2 END */

	    put unformatted tt1.tt_inv_qty space tt1.tt_curr_amt skip .
	    find first pvo_mstr where pvo_order = tt1.tt_po and pvo_line = tt1.tt_line and pvo_internal_ref = tt1.tt_receiver no-lock no-error .
	    if available pvo_mstr then
	      v_pvo_qty = pvo_trans_qty - pvo_vouchered_qty .
	    else 
	    v_pvo_qty = 0 .


          /* ss - 091112.1 -b 
	    find first pod_det where pod_nbr = tt1.tt_po and pod_line = tt1.tt_line no-lock no-error .
	    if available pod_det then
	     v_pur_cost = pod_pur_cost .
	    else 
	    v_pur_cost = 0 .
        ss - 091112.1 -e */
        
        /* ss - 091112.1 -b */
        FIND FIRST prh_hist WHERE prh_nbr = tt1.tt_po AND prh_receiver = tt1.tt_receiver AND prh_line = tt1.tt_line NO-LOCK NO-ERROR .
        IF AVAILABLE prh_hist THEN
            v_pur_cost = prh_pur_cost .
        ELSE
            v_pur_cost = 0 .
        /* ss - 091112.1 -e */

	   
	    if tt1.tt_inv_qty <> v_pvo_qty then
	     put tt.tt_close_pvo skip .
	     if round( tt1.tt_inv_qty * tt1.tt_curr_amt   , 2 ) <> round( tt1.tt_inv_qty * v_pur_cost , 2) then
	     put "-"   skip .
	   end .
	   
	    put "." skip .
	    put "." skip .
	    put "." skip .
	    put no skip .
	    put unformatted tt.tt_hold_amt space tt.tt_confirmed space tt.tt_qad01 skip .
	    /* ss - 091110.1 -b 
        put "." skip .
        ss - 091110.1 -e */
	    put "." skip .
	   end .
   end. /* for each tt */
     /* ss - 091111.1 -b */
   FOR FIRST tt no-lock where tt_flag <> 1 :
     put "." skip .
   END.
   /* ss - 091111.1 -e */
end .
else do:  /* 非本位币*/
      for each tt no-lock where tt_flag <> 1 break by tt_ref :
	   
	  if last-of(tt_ref) then do:
	    put unformatted quote tt_batch quote skip .
	    put "-" skip .
	    put unformatted quote tt_ref quote  skip .
	 
	    for each tt1 no-lock where tt1.tt_ref = tt.tt_ref break by tt1.tt_po   :
	    if first-of(tt1.tt_po) then
	      put unformatted quote  tt1.tt_po quote  skip .
	    end .
 
	    put "." skip .

        /* ss - 091111.2 -b 
	    put unformatted "- -" space  tt.tt_effdate  space "- -" skip .
	       ss - 091111.2 -e */
          
        /* ss  - 091111.2 -b */
        put unformatted "- " SPACE tt.tt_vend  space tt.tt_effdate  space "- -" skip .

       /* ss - 091111.2 -e */

	    if tt.tt_invoice = "" then
	    put unformatted "- -" space "-" space tt.tt_date space "- - - - - - - - - -" space  quote v_entity quote space "- - - - -"  skip .
	    else
	    put unformatted "- -" space quote tt.tt_invoice quote space tt.tt_date space "- - - - - - - - - -" space  quote v_entity quote space "- - - - -"  skip .
	   
            /* ss - 090927.1 -b 
	    put "-" skip . /* 空格 */
             ss - 090927.1 -e */
	     /* ss - 090927.1 -b */
	     put  SKIP (1)  .
	     /* ss - 090927.1 -e */
            
	    put "-" skip . /* 兑换率*/
            
	    if  tt.tt_invoice <> "" then do:
	     find first vo_mstr where vo_invoice = tt.tt_invoice and vo_ref <> tt.tt_ref no-lock no-error .
	     if available vo_mstr  then do:
	     /* ss - 090927.1 -b
	     put "-" skip . /* 当发票存在另一凭证时*/
                ss - 090927.1 -e */
		/* ss - 090927.1 -b */
	        put  SKIP (1) . /* 当发票存在另一凭证时*/
		/* ss - 090927.1 -e */
	     end .
	    
	    end .
	            
	  
	    put "- -" space "-" skip .
	       
     	    put "- - - - -" skip .
	 
           for each tt1 where tt1.tt_ref = tt.tt_ref and tt1.tt_ref <> "" no-lock :
	    put unformatted  quote tt1.tt_receiver quote   space  tt1.tt_line  skip .
	    /*201009.2 START */
	    if tt.tt_usage = "" then  put unformatted "- "  .
	    else                      put unformatted  """" + tt.tt_usage + """" + " " .

	    if tt.tt_type = ""  then  put unformatted "- "  .
	    else                      put unformatted  """" + tt.tt_type + """" + " " .

	    if tt.tt_including = "" then  put unformatted "- "  .
	    else                      put unformatted  """" + tt.tt_including + """" + " " .

	    put skip.

	    /* put "- - -" skip . /* 明细税*/  */

	    /*201009.2 END */
	    put unformatted tt1.tt_inv_qty space tt1.tt_curr_amt skip .
	    find first pvo_mstr where pvo_order = tt1.tt_po and pvo_line = tt1.tt_line and pvo_internal_ref = tt1.tt_receiver no-lock no-error .
	    if available pvo_mstr then
	      v_pvo_qty = pvo_trans_qty - pvo_vouchered_qty .
	    else 
	    v_pvo_qty = 0 .
        /* ss - 091112.1 -b 
	    find first pod_det where pod_nbr = tt1.tt_po and pod_line = tt1.tt_line no-lock no-error .
	    if available pod_det then
	     v_pur_cost = pod_pur_cost .
	    else 
	    v_pur_cost = 0 .
        ss - 091112.1 -e */
        
        /* ss - 091112.1 -b */
        FIND FIRST prh_hist WHERE prh_nbr = tt1.tt_po AND prh_receiver = tt1.tt_receiver AND prh_line = tt1.tt_line NO-LOCK NO-ERROR .
        IF AVAILABLE prh_hist THEN
            v_pur_cost = prh_pur_cost / prh_ex_rate2.
        ELSE
            v_pur_cost = 0 .
        /* ss - 091112.1 -e */

	    if tt1.tt_inv_qty <> v_pvo_qty then
	     put tt1.tt_close_pvo skip .
	    if round( tt1.tt_inv_qty * tt1.tt_curr_amt   , 2 ) <> round( tt1.tt_inv_qty * v_pur_cost , 2) then
	     put "-"   skip .
	    
           end .

	    put "." skip .
	    put "." skip .
	    put "." skip .
	    put no skip .
	    put unformatted tt.tt_hold_amt space tt.tt_confirmed space tt.tt_qad01 skip .
	    /* ss - 091110.1 -b
        put "." skip .
        ss - 091110.1 -e */
	    put "." skip .
	   end .
   end. /* for each tt */
   /* ss - 091111.1 -b */
   FOR FIRST tt no-lock where tt_flag <> 1 :
     put "." skip .
   END.
   /* ss - 091111.1 -e */
end .
output close .
 
 

         INPUT FROM VALUE( fn_i + ".cim") .
         OUTPUT TO VALUE(fn_me) .
         batchrun = YES. 
	   /* ss - 091111.1 -b */
         /* ss - 100923.1 -b
         {gprun.i ""apvomt.p""}
      ss - 100923.1 -e */
         /* ss - 100923.1 -b */
         {gprun.i ""xxapvom1.p""}
        /* ss - 100923.1 -e */
      /* ss - 091111.1 -e */
	 
	 batchrun = NO. 
         INPUT CLOSE .
         OUTPUT CLOSE .


i = 0 .
for each tt no-lock where tt.tt_flag <> 1 break by tt.tt_ref  by tt.tt_po  :
 
      if first-of(tt.tt_po) then do:
 
	  find first vpo_det where vpo_ref = tt.tt_ref and vpo_po = tt.tt_po no-lock no-error .
	  if available vpo_det then do:
	   i = i + 1 .
	   v_error = no .
	  end .
	  else do:
	     v_error = yes .
 	  end .
       end . /* first-of */
    
    if v_error = yes then do:  /* 没有导入*/
      
      create tt2 .
        assign 
	     tt2_batch = tt.tt_batch
	     tt2_ref = tt.tt_ref
	     tt2_po = tt.tt_po
	     tt2_vend = tt.tt_vend
	     tt2_effdate = tt.tt_effdate
	     tt2_invoice = tt.tt_invoice 
	     tt2_date = tt.tt_date
	     tt2_cr_terms = tt.tt_cr_terms
	     tt2_receiver = tt.tt_receiver
	     tt2_line = tt.tt_line
	     tt2_inv_qty = tt.tt_inv_qty
	     tt2_curr_amt = tt.tt_curr_amt
	     tt2_close_pvo = tt.tt_close_pvo
	     tt2_tax_edit = tt.tt_tax_edit
	     tt2_hold_amt = tt.tt_hold_amt
	     tt2_confirmed = tt.tt_confirmed
	         /* 101009.2  START  */
             tt2_usage  = tt_usage
             tt2_type   = tt_type
             tt2_including = tt_including
    /* 101009.2  END  */

	     tt2_qad01 = tt.tt_qad01
	     tt2_flag = yes
	     tt2_desc = "系统导入错误"
	     .
	

     end .

 end .   /* for each */

output to value(fn_error) .
export delimiter "," "批处理" "凭证" "订单"  "供应商" "发票"  "收货单"  "订单项次" "发票数量" "发票金额" "失败原因" .
for each tt2 no-lock where tt2_flag = yes break by tt2_ref by tt2_po :
   export delimiter "," tt2_batch tt2_ref tt2_po tt2_vend tt2_invoice tt2_receiver tt2_line tt2_inv_qty tt2_curr_amt tt2_desc .
end .
output close .
 
  message "导入完成，请查看两个导出文件"  view-as alert-box .
    
  
   
end. /* Main Repeat */
