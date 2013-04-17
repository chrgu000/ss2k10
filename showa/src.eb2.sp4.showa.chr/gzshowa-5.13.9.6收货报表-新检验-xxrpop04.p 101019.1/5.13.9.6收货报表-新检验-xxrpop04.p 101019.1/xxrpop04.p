/* ss - 101019.1 by: jack */
/*-Revision end--------------------------------------------------------------------------*/



/* DISPLAY TITLE */

{mfdtitle.i "101019.1"}

{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{apconsdf.i}

define var rdate like pc_start .
define var rdate1 like pc_start .
define var vendor like vd_addr .
define var vendor1 like vd_addr .
define var part like pc_part .
define var part1 like pc_part .
define var uninv_only as logical initial yes. /* 是否只打印未做凭证*/
define var v_logical as logical .  /* 是否包含检验库位 */
define var v_sort as logical . /* yes 明细 no 汇总 */
define var type1 as char extent 3 . /* 存储税代码*/
define var v_desc as char format "x(24)" extent 3 . /* 存储税描述*/
define var qty1 like tx2d_cur_tax_amt extent 3 . /*存储金额 */
define var i as int .
define var v_qty like tx2d_cur_tax_amt .
define var v_qty_oh like ld_qty_oh .
define var v_curr like tr_curr .
define var v_inv_acct like pl_inv_acct .
define var v_inv_sub like pl_inv_sub .
define var v_inv_cc like pl_inv_cc .
define var v_qty_chg like ld_qty_oh .
define var v_tax_usage like pod_tax_usage .
define var v_ps_nbr like prh_ps_nbr .

/* ss - 091013.1 -b */
DEFINE VAR v_check AS CHAR FORMAT "x(1)" .  /* 1 为检验合格 0 为不合格 空为全部*/
/* ss - 091013.1 -e */

define temp-table tt
field tt_addr like tr_addr
field tt_desc like ad_name
field tt_curr like tr_curr
field tt_ex_rate like tr_ex_rate2
field tt_amt like tr_price    /*原币金额 */
field tt_nbr like pod_nbr
field tt_receiver like tr_lot
field tt_line like tr_line
field tt_part like pt_part
field tt_qty like ld_qty_oh
field tt_price like tr_price  /* 订单单价*/
field tt_tax like tx2d_cur_tax_amt extent 3 
field tt_invoice as char
field tt_date as date 
field tt_ps_nbr like prh_ps_nbr
field tt_tax_usage like pod_tax_usage
FIELD tt_status LIKE xxmqp_status
    /* ss - 091013.1 -b */
FIELD tt_type AS CHAR  /* 收货或退货*/
 /* ss - 091013.1 -e */
.   
    /* ss - 091216.1 -b */
    DEFINE VAR v_buyer LIKE pt_buyer .
    /* ss - 091216.1 -e */


define temp-table tt1
field	tt1_addr like tr_addr
field	tt1_receiver like tr_lot
field	tt1_nbr like tr_nbr
field	tt1_line like tr_line
field	tt1_part like tr_part
field	tt1_qty like ld_qty_oh
field	tt1_ex_rate like tr_ex_rate2
field	tt1_serial like tr_serial
field	tt1_ref  like tr_ref
field	tt1_logical as logical 
field   tt1_date like tr_date
field   tt1_curr like tr_curr
.

/* ss - 091110.1 -b */
DEFINE VAR v_chr02 LIKE vd__chr02 .
/* ss - 091110.1 -e */

 /* ss - 091209.1 -b */
    DEFINE VAR v_desc1 LIKE pt_desc1 .
    DEFINE VAR v_draw LIKE pt_draw  .
    /* ss - 091209.1 -e */

define buffer trhist for tr_hist .

form

   rdate           colon 16  
   rdate1        label {t001.i}  colon 45  
   
   vendor       colon 16  
   vendor1    label {t001.i}  colon 45  
   
   part           colon 16  
   part1         label {t001.i}  colon 45  
   
   v_curr      label "币别" colon 16
   uninv_only      label "只显示未做凭证收货单" colon 16  
   /* ss - 091013.1 -b */
    v_check LABEL "检验输出"   COLON 16 "1 查询检验合格 2 不合格 空为全部" 
    "备注：报表包括退货" COLON 16
 /* ss - 091013.1 -e */
 /*  v_logical      label  "包含检验库位" */
   skip(1)        

skip(1)
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
   
    
    if rdate  = low_date   then rdate = ?.
    if rdate1 = hi_date then rdate1 = ? .
    if vendor1 = hi_char then vendor1 = "" .
    if part1   = hi_char   then part1  = "".
    
    
   

    UPDATE  rdate rdate1 vendor vendor1 part part1 v_curr uninv_only   v_check  /* v_logical */  with frame a.

    
    if rdate = ?   then rdate = low_date .
    if rdate1 = ? then rdate1 = hi_date .
    if vendor1 = "" then vendor1 = hi_char .
    if part1 = ""   then  part1  = hi_char .
    
    

    /* PRINTER SELECTION */
    /* OUTPUT DESTINATION SELECTION */
    {gpselout.i &printType = "printer"
                &printWidth = 132
                &pagedFlag = " "
                &stream = " "
                &appendToFile = " "
                &streamedOutputToTerminal = " "
                &withBatchOption = "yes"
                &displayStatementType = 1
                &withCancelMessage = "yes"
                &pageBottomMargin = 6
                &withEmail = "yes"
                &withWinprint = "yes"
                &defineVariables = "yes"}
mainloop: 
do on error undo, return error on endkey undo, return error:                    

for each tt :
delete tt .
end .

for each tt1 :
delete tt1 .
end .

PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname,1,LENGTH(execname) - 2) SKIP.
PUT UNFORMATTED "#def :end" SKIP.



export delimiter ";" "供应商" "供应商名称" "结算供应商" "收货日期" "收货单" "订单" "项次" "零件" "零件说明"  "图纸图号"  
                     "数量" "订单单价" "币别" "汇率" "原币金额" /* "关税(原币)" "手续费(原币)" "增值税(原币)" */ 
                     "发票价格(原币)" "发票数量"  "库存账户" "库存分账户" "成本中心" 
                     "税用途" "装箱单"  "检验状态" "类型"  "采购员"  . /* 发票价格为0*/


   /*  if v_logical = yes then do: */
	     
	     
          for each tr_hist USE-INDEX  /*  tr_type */ tr_eff_trnbr  no-lock where (tr_effdate >= rdate and tr_effdate <= rdate1) and ( tr_type = "rct-po" or tr_type = "iss-prv" )  
	        and ( tr_addr >= vendor and tr_addr <= vendor1) 
		and (tr_part >= part and tr_part <= part1) 
		and ( can-find(first pod_det where pod_nbr = tr_nbr and pod_line = tr_line ) )
		and (tr_curr = v_curr or v_curr = "" )
		and ( uninv_only = no 
		      or (uninv_only   and  /* Non-Vouchered Receipts Only = YES */
              not can-find (first pvo_mstr where
                  pvo_lc_charge         = ""                 and
                  pvo_internal_ref_type = {&TYPE_POReceiver} and
                  pvo_internal_ref      = tr_lot       and
                  pvo_line              = tr_line           and
                  pvo_last_voucher      <> ""))) break by tr_part by tr_serial by tr_ref :
         
             
	         qty1 = 0 .
	     
	     find first pod_det where pod_nbr = tr_nbr and pod_line = tr_line   no-lock no-error .
	      
	       if pod_taxable = yes then do:
                     /*

			  for each tx2_mstr where tx2_tax_usage = pod_tax_usage and tx2_pt_taxc = pod_taxc no-lock:
			   
			    
			   if tx2_tax_type = "tarrif" then do:
			     qty1[1] = pod_pur_cost * tr_qty_chg * ( tx2_tax_pct / 100 ) .
			   end .
			  
			  

			  
			   if tx2_tax_type = "ex1" then do:
			     qty1[2] = pod_pur_cost * tr_qty_chg * ( tx2_tax_pct / 100 ) .
			   end .

			  

			   
			   if tx2_tax_type = "zzs" then do:
			     qty1[3] = ( qty1[1] +  qty1[2] ) * ( tx2_tax_pct / 100 ) .
			   end .
		      end .

		      */
		      v_tax_usage = pod_tax_usage .
			  
		  end .
		  else do:
			       qty1 = 0 .
			       v_tax_usage = "" .
		  end .

          /* ss - 091013.1 -b */
           find first prh_hist where prh_receiver = tr_lot and prh_nbr = tr_nbr and prh_line = tr_line no-lock no-error .
		    if available prh_hist then
		     v_ps_nbr = prh_ps_nbr .
		    else 
		     v_ps_nbr = "" .

          IF tr_type = "iss-prv" THEN DO:
              
		     create tt .
		      assign
		             tt_addr = tr_addr
			     tt_receiver = tr_lot
			     tt_nbr = tr_nbr
			     tt_line = tr_line
			     tt_part = tr_part
			     tt_qty = tr_qty_chg
			     tt_price = pod_pur_cost
			     tt_date = tr_effdate
			     tt_curr = tr_curr
			     tt_ex_rate = tr_ex_rate2
			     /*
			     tt_tax[1] = qty1[1]
			     tt_tax[2] = qty1[2]
			     tt_tax[3] = qty1[3]
			     */
			     tt_ps_nbr = v_ps_nbr
			     tt_tax_usage = v_tax_usage
			     tt_invoice = ""
                 tt_status = ""
                  /* ss - 091013.1 -b */
                 tt_type = "退货"
                 /* ss - 091013.1 -e */
			     .
          END.
          ELSE DO:
         
           
              IF v_check <> ""  THEN DO:
              
              FIND FIRST xxmqp_det WHERE  xxmqp_receiver = tr_lot AND xxmqp_line = tr_Line AND  xxmqp_rcp_date = tr_effdate AND xxmqp_vend = tr_addr AND xxmqp_part = tr_part AND
                   xxmqp_serial = tr_serial  AND xxmqp_status = v_check  NO-LOCK NO-ERROR .
              IF AVAILABLE xxmqp_det   THEN do:
               
           

                    create tt .
		      assign
		             tt_addr = tr_addr
			     tt_receiver = tr_lot
			     tt_nbr = tr_nbr
			     tt_line = tr_line
			     tt_part = tr_part
			     tt_qty = tr_qty_chg
			     tt_price = pod_pur_cost
			     tt_date = tr_effdate
			     tt_curr = tr_curr
			     tt_ex_rate = tr_ex_rate2
			     /*
			     tt_tax[1] = qty1[1]
			     tt_tax[2] = qty1[2]
			     tt_tax[3] = qty1[3]
			     */
			     tt_ps_nbr = v_ps_nbr
			     tt_tax_usage = v_tax_usage
			     tt_invoice = ""
                 tt_status = xxmqp_status
                  /* ss - 091013.1 -b */
                  /* ss - 091110.1 -b
                 tt_type = "收货"
                 ss - 0911110.1 -e */
                 /* ss - 091013.1 -e */
			     .
                /* ss  - 091110.1 -b */
                  IF tr_qty_chg > 0 THEN
                       tt_type = "收货" .
                  ELSE 
                       tt_type = "退货" .
                      
                  /* ss - 091110.1 -e */
               END.
               /* ss - 091019.1 -b */
              /* ss - 091110.1 -b */
              END. /* v_check <> "" */ 
              ELSE DO:
              FIND FIRST xxmqp_det WHERE xxmqp_receiver = tr_lot AND xxmqp_line = tr_Line AND  xxmqp_rcp_date = tr_effdate AND xxmqp_vend = tr_addr AND xxmqp_part = tr_part AND xxmqp_serial = tr_serial    NO-LOCK NO-ERROR .
              IF AVAILABLE xxmqp_det   THEN do:
                       create tt .
		      assign
		             tt_addr = tr_addr
			     tt_receiver = tr_lot
			     tt_nbr = tr_nbr
			     tt_line = tr_line
			     tt_part = tr_part
			     tt_qty = tr_qty_chg
			     tt_price = pod_pur_cost
			     tt_date = tr_effdate
			     tt_curr = tr_curr
			     tt_ex_rate = tr_ex_rate2
			     tt_ps_nbr = v_ps_nbr
			     tt_tax_usage = v_tax_usage
			     tt_invoice = ""
                 tt_status = xxmqp_status

                  /* ss - 091013.1 -b */
                  /* ss - 091110.1 -b
                 tt_type = "收货"
                 ss - 091110.1 -e */
                  .
                  /* ss  - 091110.1 -b */
                  IF tr_qty_chg > 0 THEN
                       tt_type = "收货" .
                  ELSE 
                       tt_type = "退货" .
                      
                  /* ss - 091110.1 -e */
                 /* ss - 091013.1 -e */
			  
              END.
               /* ss - 091110.1 -e */
              ELSE DO:
                 create tt .
		      assign
		             tt_addr = tr_addr
			     tt_receiver = tr_lot
			     tt_nbr = tr_nbr
			     tt_line = tr_line
			     tt_part = tr_part
			     tt_qty = tr_qty_chg
			     tt_price = pod_pur_cost
			     tt_date = tr_effdate
			     tt_curr = tr_curr
			     tt_ex_rate = tr_ex_rate2
                 tt_ps_nbr = v_ps_nbr
			     tt_tax_usage = v_tax_usage
			     tt_invoice = ""
                 tt_status = ""
                  /* ss - 091013.1 -b */
                                /* ss - 091110.1 -b
                 tt_type = "收货"
                 ss - 091110.1 -e */
                  .
                  /* ss  - 091110.1 -b */
                  IF tr_qty_chg > 0 THEN
                       tt_type = "收货" .
                  ELSE 
                       tt_type = "退货" .
                      
                  /* ss - 091110.1 -e */

                 /* ss - 091013.1 -e */
			     
              END. /* not available */
             END.  /* v_check <> "" */
               /* ss - 091019.1 -e */
            
          END.
          /* ss - 091013.1 -e */
		   
		
		
		   qty1 = 0 .
	   
	   
	     end .  /* for each */
	     

      /*      end .
          else do: /* v_logical = no */
                

	     for each tr_hist use-index tr_type no-lock where (tr_effdate >= rdate and tr_effdate <= rdate1) and ( tr_type = "rct-po"  ) 
	        and ( tr_addr >= vendor and tr_addr <= vendor1) 
		and (tr_part >= part and tr_part <= part1) 
		and (tr_curr = v_curr or v_curr = "" )
		and ( can-find(first pod_det where pod_nbr = tr_nbr and pod_line = tr_line ) )
		and ( uninv_only = no 
		      or (uninv_only   and  /* Non-Vouchered Receipts Only = YES */
              not can-find (first pvo_mstr where
                  pvo_lc_charge         = ""                 and
                  pvo_internal_ref_type = {&TYPE_POReceiver} and
                  pvo_internal_ref      = tr_lot       and
                  pvo_line              = tr_line           and
                  pvo_last_voucher      <> ""))) break by tr_part by tr_serial by tr_ref :
         
              if last-of( tr_ref) then do:
		  
		  v_qty_oh = 0 .
		for each ld_det where ld_part = tr_part and ld_loc <> "check" and   ld_lot = tr_serial and ld_ref = tr_ref no-lock :
		 
		   v_qty_oh =  ld_qty_oh + v_qty_oh .
		end .

                
		if  v_qty_oh > 0 then do:
                  
		  /* 一个零件的一个批次对应多个订单*/
		 if v_qty_oh > tr_qty_chg then do:
		  
                    /* 计算本次订单*/
		  find last pod_det where pod_nbr = tr_nbr and pod_line = tr_line no-lock no-error .

                  if pod_taxable = yes then do:
		 /* 注意与实际类型一致*/
		     for each tx2_mstr where tx2_tax_usage = pod_tax_usage and tx2_pt_taxc = pod_taxc no-lock:
			   
			  
			   if tx2_tax_type = "tarrif" then do:
			     qty1[1] = pod_pur_cost * tr_qty_chg * ( tx2_tax_pct / 100 ) .
			   end .
			  
			  

			   
			   if tx2_tax_type = "ex1" then do:
			     qty1[2] = pod_pur_cost * tr_qty_chg * ( tx2_tax_pct / 100 ) .
			   end .

			  

			  
			   if tx2_tax_type = "zzs" then do:
			     qty1[3] = ( qty1[1] +  qty1[2] ) * ( tx2_tax_pct / 100 ) .
			   end .
		      end .
		    end .
		    else do:
		     qty1 = 0 .
		    end .

               
		    create tt .
		      assign
		             tt_addr = tr_addr
			     tt_receiver = tr_lot
			     tt_nbr = tr_nbr
			     tt_line  = tr_line
			     tt_part = tr_part
			     tt_qty = tr_qty_chg
			     tt_price = pod_pur_cost
			     tt_date = tr_effdate
			     tt_curr = tr_curr
			     tt_ex_rate = tr_ex_rate2
			     tt_tax[1] = qty1[1]
			     tt_tax[2] = qty1[2]
			     tt_tax[3] = qty1[3]
			     tt_invoice = ""
			     .
		    v_qty_oh = v_qty_oh - tr_qty_chg .
		    /* 计算本次订单*/
		     
		    /* 查询其他订单收货*/
		    for each tt1 :
		      delete tt1 .
		    end .

		    v_qty_chg = 0 .
                    for each trhist no-lock where trhist.tr_part = tr_hist.tr_part and trhist.tr_serial = tr_hist.tr_serial 
		         and trhist.tr_ref = tr_hist.tr_ref break by trhist.tr_nbr by trhist.tr_line by trhist.tr_lot :
                         v_qty_chg = v_qty_chg + tr_qty_chg .
			 
			 if last-of(trhist.tr_lot) then do:
			    
			    if v_qty_chg > 0 then do:
			       create tt1 .
			            assign 
				          tt1_addr = trhist.tr_addr
					  tt1_receiver = trhist.tr_lot
					  tt1_nbr = trhist.tr_nbr
					  tt1_line = trhist.tr_line
					  tt1_part = trhist.tr_part
					  tt1_date = trhist.tr_effdate
					  tt1_curr = trhist.tr_curr
					  tt1_qty = v_qty_chg
					  tt1_ex_rate = trhist.tr_ex_rate2
					  tt1_serial = trhist.tr_serial
					  tt1_ref    = trhist.tr_ref
					  tt1_logical = no
					  .
			       v_qty_chg = 0 .
			    end .

			 end .
		     end .   /* 查询其他订单收货*/
                   
		       
		  repeat while v_qty_oh > 0 :
		   
		    find last tt1 where tt1_logical = no no-error .
		    
		    if available tt1 then do:
		   
		  
			  find last pod_det where pod_nbr = tt1_nbr and pod_line = tt1_line no-lock no-error .

			  if pod_taxable = yes then do:
			 /* 注意与实际类型一致*/
			     for each tx2_mstr where tx2_tax_usage = pod_tax_usage and tx2_pt_taxc = pod_taxc no-lock:
				   
				  
				   if tx2_tax_type = "tarrif" then do:
				     qty1[1] = pod_pur_cost * tt1_qty * ( tx2_tax_pct / 100 ) .
				   end .
				  
				  

				   
				   if tx2_tax_type = "ex1" then do:
				     qty1[2] = pod_pur_cost * tt1_qty * ( tx2_tax_pct / 100 ) .
				   end .

				  

				  
				   if tx2_tax_type = "zzs" then do:
				     qty1[3] = ( qty1[1] +  qty1[2] ) * ( tx2_tax_pct / 100 ) .
				   end .
			      end .
			    end .
			    else do:
			     qty1 = 0 .
			    end .
                           
			  
			    create tt .
			      assign
				     tt_addr = tt1_addr
				     tt_receiver = tt1_receiver
				     tt_nbr = tt1_nbr
				     tt_line  = tt1_line
				     tt_part = tt1_part
				     tt_qty = tt1_qty
				     tt_price = pod_pur_cost
				     tt_date = tt1_date
				     tt_curr = tt1_curr
				     tt_ex_rate = tt1_ex_rate
				     tt_tax[1] = qty1[1]
				     tt_tax[2] = qty1[2]
				     tt_tax[3] = qty1[3]
				     tt_invoice = ""
				     .
		            assign tt1_logical = yes .
			    v_qty_oh = v_qty_oh - tt1_qty .

		       end  . /* available tt1 */

		   end . /* repeat while */
                 
		  end . /* v_qty_oh > tr_qty_chg */  /* 一个零件的一个批次对应多个订单*/
		  
		  else do:
		    
		   
		   find last pod_det where pod_nbr = tr_hist.tr_nbr and pod_line = tr_hist.tr_line no-lock no-error .

                    if pod_taxable = yes then do:
		      /* 注意与实际类型一致*/
		      for each tx2_mstr where tx2_tax_usage = pod_tax_usage and tx2_pt_taxc = pod_taxc no-lock:
			   
			  
			   if tx2_tax_type = "tarrif" then do:
			     qty1[1] = pod_pur_cost * v_qty_oh * ( tx2_tax_pct / 100 ) .
			   end .
			  
			  

			   
			   if tx2_tax_type = "ex1" then do:
			     qty1[2] = pod_pur_cost * v_qty_oh * ( tx2_tax_pct / 100 ) .
			   end .

			  

			  
			   if tx2_tax_type = "zzs" then do:
			     qty1[3] = ( qty1[1] +  qty1[2] ) * ( tx2_tax_pct / 100 ) .
			   end .
		       end .
		    end .
		    else do:
		     qty1 = 0 .
		    end .
                    
		    create tt .
		      assign
		             tt_addr = tr_hist.tr_addr
			     tt_receiver = tr_hist.tr_lot
			     tt_nbr = tr_hist.tr_nbr
			     tt_line  = tr_hist.tr_line
			     tt_part = tr_hist.tr_part
			     tt_qty = v_qty_oh
			     tt_price = pod_pur_cost
			     tt_date = tr_hist.tr_effdate
			     tt_curr = tr_hist.tr_curr
			     tt_ex_rate = tr_hist.tr_ex_rate2
			     tt_tax[1] = qty1[1]
			     tt_tax[2] = qty1[2]
			     tt_tax[3] = qty1[3]
			     tt_invoice = ""
			     .
		  end .  /* v_qty_oh <= tr_qty_chg */

		 end . /* v_qty_oh > 0 */
		
		 qty1 = 0 .
	       
	       end .  /* last-of */
         
	     end .   /* for each tr_hist */
	      
        
	 end . /* v_logical = no */
          */
    

       for each tt no-lock where tt_addr <> "" break by  tt_addr by tt_part by tt_date :
	  accumulate tt_qty (total by tt_part) .
	  accumulate tt_tax[1] ( total by tt_part) .
	  accumulate tt_tax[2] ( total by tt_part) .
	  accumulate tt_tax[3] (total by tt_part) .
	  accumulate tt_qty * tt_price  (total by tt_part) .

	  find first ad_mstr where ad_addr = tt_addr no-lock no-error .
      
      /* ss - 091019.1 -b */
      FIND FIRST vd_mstr WHERE vd_addr = tt_addr NO-LOCK NO-ERROR .
      /* ss - 091019.1 -e */
           
	   find first pt_mstr where pt_part = tt_part no-lock no-error .
	   if available pt_mstr THEN DO:
           ASSIGN   
              v_desc1 = pt_desc1 
               v_draw = pt_draw 
               /* ss - 091216.1 -b */
               v_buyer = pt_buyer
               /* ss - 091216.1 -e */
               .
         find first pl_mstr where pl_prod_line = pt_prod_line no-lock no-error .
	     if available pl_mstr then
	      assign 
	        v_inv_acct = pl_inv_acct
		v_inv_sub  = pl_inv_sub
		v_inv_cc   = pl_inv_cc .
       END.
       /* ss - 091209.1 -b */
       ELSE DO:
            ASSIGN   
              v_desc1 = "" 
               v_draw = ""
                /* ss - 091216.1 -b */
                v_buyer = ""
                /* ss - 091216.1 -e */
                .
       END.
       /* ss - 091209.1 -e */
         /* ss  - 091110.1 -b */
         IF vd__chr02 = "" THEN
             v_chr02 = vd_addr .
         ELSE
             v_chr02 = vd__chr02 .
         /* ss - 091110.1 -e */

	   export delimiter ";" tt_addr ad_name v_chr02  tt_date tt_receiver tt_nbr tt_line tt_part   v_desc1 v_draw  tt_qty  tt_price tt_curr tt_ex_rate tt_qty * tt_price  /* tt_tax[1] tt_tax[2] tt_tax[3] */  "" " " v_inv_acct v_inv_sub v_inv_cc tt_tax_usage tt_ps_nbr  /* ss - 091013.1 -b */ tt_status  tt_type /* ss - 091013.1 -e */ /* ss - 091216.1 -b */  v_buyer /* ss - 091216.1 -e */.
	  
	  if last-of(tt_part) then do:
	   export delimiter ";" "小计 "  " "  "" " "  " "  ""  "" " " " " " " (accumulate total by tt_part tt_qty ) " "  " " " "  (accumulate total by tt_part tt_qty * tt_price )  /* (accumulate total by tt_part tt_tax[1])  
	   (accumulate total by tt_part tt_tax[2]) (accumulate total by tt_part tt_tax[3]) */ " " " " v_inv_acct v_inv_sub v_inv_cc "" "" "" ""  /* ss - 091216.1 -b */  "" /* ss - 091216.1 -e */ .
	  
	  end .
	  
	   {mfrpchk.i}
	  
	end .


end. /* mainloop: */
/* {mfrtrail.i}  REPORT TRAILER  */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}


    
