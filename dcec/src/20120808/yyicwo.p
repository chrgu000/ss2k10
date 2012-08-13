/*yyicwo1.p   IC-WO Cal*/
/* Copyright 2009-2010 QAD Inc., Shanghai CHINA.                        */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 1.0    LAST MODIFIED: 09/03/2009     BY: Leo Zhou          *CLZ*/

{mfdtitle.i}

def var v_year   as int format ">>>9".
def var v_period as int format ">9".
def var part	 like pt_part.
def var part1	 like pt_part.
def var v_update as logical init no.
def var v_del    as logical init no.
def var v_mtl_cost  as deci format ">>>,>>>,>>9.99<<".
def var v_lbr_cost  as deci format ">>>,>>>,>>9.99<<".
def var v_ovh_cost  as deci format ">>>,>>>,>>9.99<<".
def var v_start  as date.
def var v_end    as date.
def var v_qty    like wo_qty_ord.
def var v_cost   like sct_cst_tot.
def var i as int.
def var v_time  as int.
def var v_pmcode like pt_pm_code.
def buffer bwobmvd for xxwobmvd_det.
def var minI as int.
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

def temp-table two
    field two_nbr   like wo_nbr
    field two_lot   like wo_lot
    field two_type  like wo_type
    field two_part  like wo_part
    field two_pl    like pt_prod_line
    field two_qty   like wo_qty_ord
index twolot is primary two_lot two_part.

def temp-table ttt
    field ttt_wolot   like wo_lot
    field ttt_part    like wo_part
    field ttt_comp    like ps_comp
    field ttt_op      like xxwobmvd_op
    field ttt_var     like xxwobmvd_var_det[1]
    field ttt_qty_tot like wo_qty_ord
    field ttt_qty_ps  like wo_qty_ord
    field ttt_flag    as logical
index lot is primary ttt_wolot ttt_part ttt_comp ttt_flag.

def buffer bttt for ttt.

FORM 
     RECT-FRAME       AT ROW 1.4 COLUMN 1.25
     RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
     SKIP(.3)  /*GUI*/
     v_year   colon 20 label "年份"
     v_period colon 20 label "期间"
     part     colon 20 label "零件"
     part1    colon 50 label "至"
     v_update colon 20 label "开始计算"
     skip
with frame a width 80 side-labels no-box attr-space THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = " 当期IC-WO差异计算  ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


v_year = year(today).
v_period = month(today).


main-loop:
repeat:

   update v_year validate(v_year > 2000 and v_year <= year(today), " 年份错误. ")
          v_period validate(v_period > 0 and v_period < 13, " 期间错误. ")
	  part
	  part1
	  v_update with frame a.
   if part1 = "" then part1 = hi_char.
   find first glc_cal where glc_year = v_year and glc_per = v_period no-lock no-error.
   if not avail glc_cal then do:
      message "错误：财务期间不存在，请检查后重新输入. " view-as alert-box error.
      next.
   end.

   v_time = time.

   v_start = glc_start.
   v_end = glc_end.

   empty temp-table two.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "terminal"
               &printWidth = 80
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.

    /*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

   if v_update then do:
           /*Clear*/
	   for each yycsvar_mstr where yycsvar_year = v_year and yycsvar_per = v_period
				and yycsvar_part >= part and yycsvar_part <= part1
	       /*and yyinvi_element begins "IC-WO"*/:
	       do i = 1 to 12:
	          assign yycsvar_variance[i] = 0.
	       end.
	   end. /*for each yycsvar_mstr*/

	   for each yycsvard_det where yycsvard_year = v_year and yycsvard_per = v_period
				and yycsvard_part >= part and yycsvard_part <= part1
	       /*and yyinvid_element begins "IC-WO"*/:
	       do i =1 to 12:
	          assign yycsvard_variance[i] = 0.
	       end.
	   end. /*for each yycsvard_det*/
	   	   
	   
	   for each yyinvi_mstr where yyinvi_year = v_year and yyinvi_per = v_period
				and yyinvi_part >= part and yyinvi_part <= part1:
	       assign yyinvi_mfg_qty = 0.
	   end. /*for each yyinvi_mstr*/

	   for each yyinvid_det where yyinvid_year = v_year and yyinvid_per = v_period
				and yyinvid_part >= part and yyinvid_part <= part1:
	       assign yyinvid_qty = 0.
	   end. /*for each yyinvi_mstr*/
   end. /* if v_update */

   /*Get WO List (WO Receipt Qty)*/
   for each tr_hist no-lock where tr_type = "RCT-WO"
       and tr_effdate >= v_start and tr_effdate <= v_end 
       and tr_part >= part and tr_part <= part1
       use-index tr_type
       break by tr_lot:

       if first-of(tr_lot) then v_qty = 0.

       v_qty = v_qty + tr_qty_loc.

       if last-of(tr_lot) then do:
          find first wo_mstr where wo_nbr = tr_nbr and wo_lot = tr_lot no-lock no-error.
          create two.
	  assign two_nbr  = tr_nbr 
	         two_lot  = tr_lot
		 two_type = wo_type
		 two_part = tr_part
		 two_pl   = tr_prod_line
		 two_qty  = v_qty.     /*Receipt Qty*/
       end.
   end.  /*for each tr_hist*/

   /*Create RCT-WO data*/
   run crt-rct-mstr.
   
   /*Create var detail*/
   run crt-var-det.

   /*Create var master*/
   run crt-var-mstr.
	
   put "IC-WO差异计算已完成，共耗时" + string(time - v_time, "HH:MM:SS") format "x(60)" skip.
       

   {mfreset.i} 
   
   {mfgrptrm.i} /*Report-to-Window*/

end.  /*main-loop*/


procedure crt-rct-mstr:
    for each two where two_qty <> 0:
        find first yyinvi_mstr where yyinvi_year = v_year
	     and yyinvi_per = v_period 
	     and yyinvi_part = two_part no-error.
	if not avail yyinvi_mstr then do:
	   find last yywobmspt_mstr where yywobmspt_part = two_part 
		and year(yywobmspt_mod_date) <= v_year
		and month(yywobmspt_mod_date) <= v_period no-lock no-error.
	   create yyinvi_mstr.
	   assign yyinvi_year = v_year
	          yyinvi_per  = v_period
		  yyinvi_part = two_part
	          yyinvi_part_pl = two_pl .
	   if avail yywobmspt_mstr then assign yyinvi_std_bom = yywobmspt_version.
        end.
	
	assign yyinvi_mfg_qty = yyinvi_mfg_qty + two_qty.


	for each wod_det no-lock where wod_lot = two_lot:

            find first yyinvid_det where yyinvid_year = v_year
	         and yyinvid_per = v_period 
		 and yyinvid_part = two_part 
		 and yyinvid_comp = wod_part no-error.
            if not avail yyinvid_det then do:
               
	       find first pt_mstr where pt_part = wod_part no-lock no-error.

	       create yyinvid_det.
	       assign yyinvid_year = v_year
	              yyinvid_per  = v_period
		      yyinvid_part = two_part
		      yyinvid_part_pl = two_pl
		      yyinvid_comp    = wod_part
		      yyinvid_comp_pl = pt_prod_line.
	    end.

            /*Actual issue qty*/
	    assign yyinvid_qty = yyinvid_qty + wod_qty_iss.

	end.   /*each wod_det*/
    end.   /*each two*/
end procedure.


procedure crt-var-det:
   empty temp-table ttt.	
   for each two :

          
           for each xxwobmvd_det no-lock where xxwobmvd_det.xxwobmvd_woid = two_lot:
               
	       find first pt_mstr where pt_part = xxwobmvd_det.xxwobmvd_comp no-lock no-error.
	       if not avail pt_mstr then next.
	       find first ptp_det where ptp_part = xxwobmvd_det.xxwobmvd_comp and ptp_site begins "dcec-" no-lock no-error.
	       if avail ptp_det then assign v_pmcode = ptp_pm_code.
	       else assign v_pmcode = pt_pm_code.

               find first yycsvard_det where yycsvard_year = v_year 
	            and yycsvard_per = v_period 
		    and yycsvard_part = two_part
		    and yycsvard_comp = xxwobmvd_det.xxwobmvd_comp no-error.
	       if not avail yycsvard_det then do:
	          create yycsvard_det.
	          assign yycsvard_year    = v_year
		         yycsvard_per     = v_period
		         yycsvard_part    = two_part
		         yycsvard_part_pl = two_pl
		         yycsvard_comp    = xxwobmvd_det.xxwobmvd_comp
		         yycsvard_comp_pl = pt_prod_line.
	       end.
		
	       find first wo_mstr where wo_lot = two_lot no-lock no-error.

	       if wo_type = "E" then do:   /*改制工单*/
		      /*IC-WO 路线变更*/
		      assign yycsvard_variance[2] = yycsvard_variance[2] + xxwobmvd_det.xxwobmvd_var_tot.

	       end.
	       else do:   /*重复生产工单*/
                  /* 量差 */
   	          if xxwobmvd_det.xxwobmvd_var_det[1] <> 0 then do:
			if xxwobmvd_det.xxwobmvd_cwo_qty - xxwobmvd_det.xxwobmvd_act_qty = 0 then 
				assign yycsvard_variance[5] = yycsvard_variance[5] + xxwobmvd_det.xxwobmvd_var_det[1].
			else do:				        
				find first ttt where ttt.ttt_wolot = xxwobmvd_det.xxwobmvd_woid
					and ttt.ttt_part = two_part
					and ttt.ttt_comp = xxwobmvd_det.xxwobmvd_comp no-error.
				if not avail ttt then do:
					create ttt.
					assign
					    ttt.ttt_wolot = xxwobmvd_det.xxwobmvd_woid
					    ttt.ttt_part = two_part
					    ttt.ttt_comp = xxwobmvd_det.xxwobmvd_comp
					    ttt.ttt_op = xxwobmvd_det.xxwobmvd_op
					    ttt.ttt_var = xxwobmvd_det.xxwobmvd_var_det[1]
					    ttt.ttt_qty_tot = abs(xxwobmvd_det.xxwobmvd_cwo_qty - xxwobmvd_det.xxwobmvd_act_qty).
					if xxwobmvd_det.xxwobmvd_cwo_qty - xxwobmvd_det.xxwobmvd_act_qty > 0 then do:
						assign ttt.ttt_flag = true.
						for each bttt where bttt.ttt_wolot = ttt.ttt_wolot
							and bttt.ttt_part = two_part
							and bttt.ttt_flag <> ttt.ttt_flag :
							find first yypts_det where yypts_year = v_year
								and yypts_per = v_period
								and yypts_part = two_part 
								and yypts_comp = ttt.ttt_comp 
								and yypts_sub_comp = bttt.ttt_comp
								no-lock no-error.
							if avail yypts_det then do:
								assign minI = min((ttt.ttt_qty_tot - ttt.ttt_qty_ps),(bttt.ttt_qty_tot - bttt.ttt_qty_ps))
									ttt.ttt_qty_ps = ttt.ttt_qty_ps + minI
									bttt.ttt_qty_ps = bttt.ttt_qty_ps + minI.
							end.
						end. /* for each bttt */
					end. /* if xxwobmvd_det.xxwobmvd_cwo_qty - xxwobmvd_det.xxwobmvd_act_qty > 0 */
					else do:
						assign ttt.ttt_flag = false.
						for each bttt where bttt.ttt_wolot = ttt.ttt_wolot
							and bttt.ttt_part = two_part
							and bttt.ttt_flag <> ttt.ttt_flag :
							find first yypts_det where yypts_year = v_year
								and yypts_per = v_period
								and yypts_part = two_part 
								and yypts_comp = bttt.ttt_comp 
								and yypts_sub_comp = ttt.ttt_comp
								no-lock no-error.
							if avail yypts_det then do:
								assign minI = min((ttt.ttt_qty_tot - ttt.ttt_qty_ps),(bttt.ttt_qty_tot - bttt.ttt_qty_ps))
									ttt.ttt_qty_ps = ttt.ttt_qty_ps + minI
									bttt.ttt_qty_ps = bttt.ttt_qty_ps + minI.
							end.
						end. /* for each bttt */
					end. /* if xxwobmvd_det.xxwobmvd_cwo_qty - xxwobmvd_det.xxwobmvd_act_qty < 0  */
				end. /* if not avial ttt */
				
			end. /* else */

		  end. /* if xxwobmvd_det.xxwobmvd_var_det[1] <> 0 */
			
                  /*率差*/
   	          if xxwobmvd_det.xxwobmvd_var_det[2] <> 0 then  
		     assign yycsvard_variance[7] = yycsvard_variance[7] + xxwobmvd_det.xxwobmvd_var_det[2].
			
                  /*方法差异量差*/
   	          if xxwobmvd_det.xxwobmvd_var_det[3] <> 0 then do: 
	
                     if v_pmcode = "M" then do:
		        
		        {gprun.i ""yycalmtl.p"" "(yycsvard_comp, 
			                          wo_site,
						  xxwobmvd_det.xxwobmvd_var_det[3],
						  (xxwobmvd_det.xxwobmvd_cwo_qty  - xxwobmvd_det.xxwobmvd_bom_qty),
						  output v_mtl_cost,
						  output v_lbr_cost,
						  output v_ovh_cost)"}
			
			assign yycsvard_variance[3] = yycsvard_variance[3] + v_mtl_cost
		               yycsvard_variance[9] = yycsvard_variance[9] + v_lbr_cost
			       yycsvard_variance[10] = yycsvard_variance[10] + v_ovh_cost.
                     end.
		     else yycsvard_variance[3] = yycsvard_variance[3] + xxwobmvd_det.xxwobmvd_var_det[3]. 
                     
		  end.
			
                   /*方法差异率差*/
   	          if xxwobmvd_det.xxwobmvd_var_det[4] <> 0 then 
		     assign yycsvard_variance[4] = yycsvard_variance[4] + xxwobmvd_det.xxwobmvd_var_det[4].
		  
		 		  
	       end.  /*else do*/
	   end.   /*for each xxwobmvd_det*/
       

   end.  /*for each two*/
   for each ttt no-lock:
       find first pt_mstr where pt_part = ttt.ttt_comp no-lock no-error.
       if not avail pt_mstr then next.
       find first ptp_det where ptp_part = ttt.ttt_comp and ptp_site begins "dcec-" no-lock no-error.
       if avail ptp_det then assign v_pmcode = ptp_pm_code.
       else assign v_pmcode = pt_pm_code.
       find first xxwobmvd_det  where xxwobmvd_det.xxwobmvd_woid = ttt.ttt_wolot 
		and xxwobmvd_det.xxwobmvd_comp = ttt.ttt_comp 
		and xxwobmvd_det.xxwobmvd_op = ttt.ttt_op no-lock no-error.
       if not avail xxwobmvd_det then next.
       find first yycsvard_det where yycsvard_year = v_year 
	    and yycsvard_per = v_period 
	    and yycsvard_part = ttt.ttt_part
	    and yycsvard_comp = ttt.ttt_comp no-error.
       if not avail yycsvard_det then next.
       /* 制造件明细到量差工和量差费 */
       if v_pmcode = "M" then do:
		{gprun.i ""yycalmtl.p"" "(yycsvard_comp, 
					  ptp_site,
					  xxwobmvd_det.xxwobmvd_var_det[1],
					  (xxwobmvd_det.xxwobmvd_act_qty - xxwobmvd_det.xxwobmvd_cwo_qty),
					  output v_mtl_cost,
					  output v_lbr_cost,
					  output v_ovh_cost)"}
		assign  yycsvard_variance[6] = yycsvard_variance[6] + (v_mtl_cost * ttt.ttt_qty_ps / ttt.ttt_qty_tot)
			yycsvard_variance[5] = yycsvard_variance[5] + (v_mtl_cost - v_mtl_cost * ttt.ttt_qty_ps / ttt.ttt_qty_tot)
			yycsvard_variance[11] = yycsvard_variance[11] + v_lbr_cost
			yycsvard_variance[12] = yycsvard_variance[12] + v_ovh_cost.
	end. 
	else 
		assign yycsvard_variance[6] = yycsvard_variance[6] + (xxwobmvd_det.xxwobmvd_var_det[1]* ttt.ttt_qty_ps / ttt.ttt_qty_tot)
		       yycsvard_variance[5] = yycsvard_variance[5] + (xxwobmvd_det.xxwobmvd_var_det[1] - xxwobmvd_det.xxwobmvd_var_det[1] * ttt.ttt_qty_ps / ttt.ttt_qty_tot).
   end.
   empty temp-table ttt.
end procedure.


procedure crt-var-mstr:


   for each two no-lock group by two_part:
	find first xxwobmvm_mstr where xxwobmvm_woid = two_lot no-error.
	if avail xxwobmvm_mstr then do:
		find first yycsvar_mstr where yycsvar_year = v_year
			and yycsvar_per = v_period and yycsvar_part = two_part no-error.
		if not avail yycsvar_mstr then do:
		      find first pt_mstr where pt_part = two_part no-lock no-error.
		      find first ptp_det where ptp_part = two_part and ptp_site begins "dcec-" no-lock no-error.
		      
		      create yycsvar_mstr.
		      assign yycsvar_year = v_year
			     yycsvar_per  = v_period
			     yycsvar_part = two_part
			     yycsvar_part_pl = two_pl.
		      if avail ptp_det then assign yycsvar_pm_code = ptp_pm_code.
		      else assign yycsvar_pm_code = pt_pm_code.
		end.
		find first wo_mstr where wo_lot = xxwobmvm_woid no-lock no-error.
		if avail wo_mstr and wo_type = "E" then
			assign yycsvar_variance[2] = yycsvar_variance[2] + xxwobmvm_var_det[5].
		else
			assign yycsvar_variance[8] = yycsvar_variance[8] + xxwobmvm_var_det[5].
	end.
       if last-of(two_part) then do:
	       for each yycsvard_det no-lock where yycsvard_year = v_year 
		    and yycsvard_per = v_period and yycsvard_part = two_part:
		   find first yycsvar_mstr where yycsvar_year = v_year
			and yycsvar_per = v_period 
			and yycsvar_part = two_part no-error.
		   if not avail yycsvar_mstr then do:
		      find first pt_mstr where pt_part = two_part no-lock no-error.
		      find first ptp_det where ptp_part = two_part and ptp_site = xxwobmvm_site no-lock no-error.
		      
		      create yycsvar_mstr.
		      assign yycsvar_year = v_year
			     yycsvar_per  = v_period
			     yycsvar_part = two_part
			     yycsvar_part_pl = two_pl.
		      if avail ptp_det then assign yycsvar_pm_code = ptp_pm_code.
		      else assign yycsvar_pm_code = pt_pm_code.
		   end.
			  
		   do i = 1 to 12:
		      yycsvar_variance[i] = yycsvar_variance[i] + yycsvard_variance[i].
		   end.
	       end.  /*for each yycsvard_det*/
	end. /* if last-of(two_part) */
   end.  /*for each two*/

end procedure.

