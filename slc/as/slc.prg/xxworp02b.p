/*********************************************************************/
/*Name:工单发料单打印                                                */
/*Designed by Billy 2008-11-27                                       */
/*********************************************************************/
                            
{mfdeclre.i }
{gplabel.i}   /* EXTERNAL LABEL INCLUDE */
{wbrp02.i}

define shared variable sntype 				 as char .
define shared variable snnbr					 as char format "x(11)".
define shared variable snnbr1					 like snnbr.
define shared variable rdate           like prh_rcp_date.
define shared variable rdate1          like prh_rcp_date.
define shared variable part            like pt_part.
define shared variable part1           like pt_part.
define shared variable site            like pt_site.
define shared variable site1           like pt_site.
define shared variable yn1             as logical.
define variable j as integer.
define variable k as integer.
define variable u as integer.
define variable tmpchar as character format "x(120)".
define variable tmpchar1 as character format "x(12)".
define variable tmpchar2 as character format "x(300)".
define variable xxdep like usrg_group_desc.
define buffer tcd_det for cd_det.
define buffer tpt_mstr for pt_mstr.
define buffer tpt_mstr2 for pt_mstr.
define variable xxtemp as character.
define variable xxtemp1 like ld_qty_oh.
define variable xxtemp2 like ld_qty_oh.
define variable xxcust like cm_sort format "x(18)".
define variable xxzhiding like vd_sort format "x(12)".
define variable tmpwonbr as character format "x(90)".
define variable tmpwolot as character format "x(90)".
define variable tmpvender like vp_vend_part.
define variable totqty like ld_qty_oh.

define shared variable noprinter				as logical.
DEFINE VARIABLE wpage     AS integer format ">>>" init 0.

define temp-table xxlcsn
	field xxlcsn_type as char
	field xxlcsn_sn as char
	field xxlcsn_nbr as char
	field xxlcsn_nbr1 as char.

empty temp-table xxlcsn.

define temp-table xxpicklist
  field xxlcnbr as character
  field xxpart like pt_part
  field xxoldpart like pt_part
  field xxserial like tr_serial
  field xxop  like tr_wod_op
  field xxordqty like wod_qty_req
  field xxpickqty like wod_qty_req
  field xxinvqty like wod_qty_req
  field xxvend like vd_sort
  field xxloc like tr_loc
  field xxpler like pt_article
.
empty temp-table xxpicklist.

define temp-table xxwo
  field xxwonbr as character
  field xxwolot as character
  field xxwoordqty as decimal
.
empty temp-table xxwo.

form
      xxpart label "物料代码"
      xxoldpart format "X(20)" label "旧号" 
			xxserial label "批序号"
			xxop column-label "工位"
			xxpickqty  format "->>>>9" label "派工数"
			xxinvqty format "->>>>>9" label "结存数"
			xxvend format "x(18)"	label "供应商" 
with frame c width 200 down attr-space.

for each usrw_wkfl where usrw_domain = global_domain and usrw_key1 = sntype and
	usrw_key2 >= snnbr and usrw_key2 <= snnbr and 
	usrw_datefld[1] >= rdate and usrw_datefld[1] <= rdate1 and
	( usrw_datefld[2] = ? or not noprinter ) no-lock :
	{xxlcsntb.i "usrw_charfld"}
end.

FORM  HEADER
    "隆鑫工业有限公司四轮车本部" at 40 skip
		"派工单发料清单" at 44 skip
     "单据号码:" at 1 xxlcnbr format "x(11)" "库位:" at 30 xxloc skip
     "加工单号:" at 1 tmpwonbr skip
     "派工单ID:" at 1 tmpwolot
WITH STREAM-IO FRAME ph1 PAGE-TOP WIDTH 130 NO-BOX.


for each usrw_wkfl where usrw_domain = global_domain and usrw_key1 = sntype and
	usrw_key2 >= snnbr and usrw_key2 <= snnbr and 
	usrw_datefld[1] >= rdate and usrw_datefld[1] <= rdate1 and 
	( usrw_datefld[2] = ? or not noprinter ) no-lock,
	each xxlcsn where xxlcsn_type = sntype and xxlcsn_sn = usrw_key2 no-lock ,
	each tr_hist where tr_domain = global_domain and tr_trnbr = int(xxlcsn_nbr) no-lock,
	each pt_mstr where pt_domain = global_domain and pt_part = tr_part no-lock
	break by usrw_key2 by tr_loc by tr_part by tr_wod_op:

	find first wo_mstr where wo_domain = global_domain and wo_nbr = tr_nbr and wo_lot = tr_lot no-lock no-error.
	find first so_mstr where so_domain = global_domain and so_nbr = wo_so_job no-lock no-error.
	find first sod_det where sod_domain = global_domain and sod_nbr = so_nbr and sod_part = wo_part no-lock no-error.

	find first ad_mstr where ad_domain = global_domain and ad_addr = substring(tr_serial,7) no-lock no-error.
	find first usr_mstr where usr_userid = usrw_key3 no-lock no-error.
	find first wod_det  where wod_domain = global_domain and wod_nbr = tr_nbr and wod_lot = tr_lot and wod_part = tr_part no-lock no-error.
				
	find first vp_mstr where vp_domain = global_domain and vp_part = tr_part and  vp_vend = "" no-lock no-error.
	if avail vp_mstr then 
	do:
		tmpvender = vp_vend_part.
	end.	
	else
	do:
		tmpvender = "".
	end.
	find first vd_mstr where vd_domain = global_domain and vd_addr = substring(tr_serial,7) no-lock no-error.
	xxtemp1 = 0.
	for each ld_det where ld_domain = global_domain and ld_site = "10000" and ld_part = tr_part and substring(ld_lot,7) = substring(tr_serial,7) and ld_status begins "Y" no-lock:
		xxtemp1 = xxtemp1 + ld_qty_oh.
	end.
  
	xxtemp2 = tr_qty_loc * (-1).
	
	    find first xxwo where xxwonbr = tr_nbr and xxwolot = tr_lot no-lock no-error.
	   	if not avail xxwo then
	   	do:
	   		create xxwo.
	   		assign
	   			xxwonbr = tr_nbr
	   			xxwolot = tr_lot
	   			xxwoordqty = wo_qty_ord.
      end.

			 
			find first xxpicklist where xxpart = tr_part and xxserial = tr_serial and xxop = tr_wod_op no-lock no-error.
			if avail xxpicklist then
			 do:
			 	xxpickqty = xxpickqty + xxtemp2.
			 end.
			else
			 do:
			 	create xxpicklist.
			 	assign
			 	  xxlcnbr = usrw_key2
			 		xxpart = tr_part
			 		xxoldpart = tmpvender
			 		xxserial = tr_serial
			 		xxop = tr_wod_op
/* 		xxordqty =         不明确*/
			 		xxpickqty = xxtemp2
			 		xxinvqty = xxtemp1
			 		xxvend = vd_sort
			 		xxloc = tr_loc
			 		xxpler = pt_article
			 		.
			 end.

/*			
					disp 	tr_part label "物料代码"
					      vp_vend_part format "X(20)" label "旧号" when avail vp_mstr
					      tr_serial label "批序号"
					      
								wod_qty_req format "->>>>9" label "计划数"
								xxtemp2 format "->>>>9" label "派工数"
								xxtemp1 format "->>>>>9" label "结存数"
							  vd_sort format "x(18)"	label "实发供应商" when avail vd_mstr							
								tr_wod_op  when tr_wod_op <> 0 @ wod_op Column-label "工位"
								wod_op Column-label "工位" when tr_wod_op = 0
					with frame c.
					down with frame c.
					
					put pt_mstr.pt_desc1 at 2.
					put "描述:" at 30.
					if avail cd_det then do:
					find first tpt_mstr where tpt_mstr.pt_domain = global_domain and tpt_mstr.pt_part = substring(cd_det.cd_cmmt[1],1,4) no-lock no-error.
          if avail tpt_mstr then
          put tpt_mstr.pt_desc1 format "x(14)".
					 do j = 1 to 15 : 
		        	if (avail cd_det and cd_det.cd_cmmt[j] <> "") then put cd_det.cd_cmmt[j] skip.
		        	else 
		        	do:
		        		  if (not avail cd_det and avail pt_mstr) then
		        		  do:
		        				put pt_mstr.pt_desc2 skip.
		        				leave.
		        		  end.
		          end.
		        end.
		        put skip.
		      end.
*/
/*		  
 if last-of(tr_loc) then do:

 	  put skip(2).
 		put "全缺的物料" skip.
 		put "------------------------" skip.
 		for each wod_det where wod_domain = global_domain 
 		                   and wod_nbr = tr_nbr and wod_lot = tr_lot
 		                   and wod_loc = tr_loc
 		                   and wod_qty_iss = 0 
 		                   and wod_qty_req <> 0 no-lock,
 		    each tpt_mstr2 where tpt_mstr2.pt_domain = global_domain 
 		                     and tpt_mstr2.pt_part = wod_part no-lock
 		    break by wod_part:
 		    	
 		    find first xxsob_det where xxsob_domain = global_domain and xxsob_nbr = wo_so_job and xxsob_parent = wo_part and xxsob_part = wod_part and xxsob_line = int(substring(wo_nbr,9)) no-lock no-error.
				find first vd_mstr where vd_domain = global_domain and vd_addr = xxsob_user1 no-lock no-error.
				if avail vd_mstr then 
				  xxzhiding = vd_sort.
				else
				  xxzhiding = "".
 		    disp
 		        wod_part  @  tr_part
 		        tpt_mstr2.pt_desc1 @ vp_vend_part
 		        xxzhiding
 		    with frame c.
 		    down with frame c.
 		end. 

 end.
*/
end. /* for each usrw_wkfl */

 for each xxwo no-lock:
 		tmpwonbr = tmpwonbr + " " + xxwonbr.
 		tmpwolot = tmpwolot + " " + xxwolot.
 end.
 
 	for each xxpicklist no-lock, 
	 	   each pt_mstr where pt_domain = global_domain and  pt_part = xxpart no-lock
	 break by xxlcnbr by xxloc by xxpler by xxop by xxpart:
	 	
	 find first cd_det where cd_det.cd_domain = global_domain and cd_det.cd_ref = xxpart and cd_det.cd_type = "SC" and cd_det.cd_lang = "ch" no-lock no-error.	
	 	       view frame ph1.
	 	       if yn1 then
	 	       do:
		 	       totqty = totqty + xxpickqty. 
		 	       if last-of(xxpart) then
		 	       do: 
		 	         disp 	
		 	              xxpart label "物料代码"
							      xxoldpart format "X(20)" label "旧号" 
							      xxop     label "工位"
							      "合并" @ xxserial
										totqty @ xxpickqty
										xxinvqty format "->>>>>9" label "结存数"
									  xxvend format "x(18)"	label "供应商"
							 with frame c.
							 down with frame c.
							 totqty = 0.
							 put pt_desc1 at 2.
								put "描述:" at 30.
								if avail cd_det then do:
									find first tpt_mstr where tpt_mstr.pt_domain = global_domain and tpt_mstr.pt_part = substring(cd_det.cd_cmmt[1],1,4) no-lock no-error.
				          if avail tpt_mstr then
				          put tpt_mstr.pt_desc1 format "x(14)".
									 do j = 1 to 15 : 
						        	if (avail cd_det and cd_det.cd_cmmt[j] <> "") then put cd_det.cd_cmmt[j] skip.
						        	else 
						        	do:
						        		  if (not avail cd_det and avail pt_mstr) then
						        		  do:
						        				put pt_mstr.pt_desc2 skip.
						        				leave.
						        		  end.
						          end.
						        end.
						        put skip.
						    end.
						 end. /*if last-of(xxpart)*/	 
						end.
						else
						do:
								disp 	
	 	              xxpart label "物料代码"
						      xxoldpart format "X(20)" label "旧号" 
						      xxserial label "批序号"
						      xxop     label "工位"
									xxpickqty format "->>>>9" label "派工数"
									xxinvqty format "->>>>>9" label "结存数"
								  xxvend format "x(18)"	label "供应商"
							 with frame c.
							 down with frame c.
							 put pt_mstr.pt_desc1 at 2.
								put "描述:" at 30.
								if avail cd_det then do:
									find first tpt_mstr where tpt_mstr.pt_domain = global_domain and tpt_mstr.pt_part = substring(cd_det.cd_cmmt[1],1,4) no-lock no-error.
				          if avail tpt_mstr then
				          put tpt_mstr.pt_desc1 format "x(14)".
									 do j = 1 to 15 : 
						        	if (avail cd_det and cd_det.cd_cmmt[j] <> "") then put cd_det.cd_cmmt[j] skip.
						        	else 
						        	do:
						        		  if (not avail cd_det and avail pt_mstr) then
						        		  do:
						        				put pt_mstr.pt_desc2 skip.
						        				leave.
						        		  end.
						          end.
						        end.
						        put skip.
						    end.
						end.
						 
		if last-of( xxloc ) or last-of(xxpler) or page-size - line-counter <= 4 then do:   
			put "--------------------------------------------------------------------------------------------------" skip.
			put "领料人:" at 1                               
					"帐务员:" at 20
					"配料员:" at 40 xxpler
					"制单员:" at 70 usr_name  format "x(8)"
					"   页数:"  string(page-number - wpage ) skip.
			put "[白联:库管 红联:财务 其他:配料]" at 1.
			if not last(xxloc) then page.
			if last-of(xxlcnbr) then wpage = page-number.
		end.
end.
/* 
 else
 do:
	 for each xxpicklist no-lock, 
	 	   each pt_mstr where pt_domain = global_domain and  pt_part = xxpart no-lock
	 break by xxlcnbr by xxloc by xxpler by xxop:
	 	
	 find first cd_det where cd_det.cd_domain = global_domain and cd_det.cd_ref = xxpart and cd_det.cd_type = "SC" and cd_det.cd_lang = "ch" no-lock no-error.	
	 	         
	 	         
	 	         view frame ph1.
	 	         disp 	
	 	              xxpart label "物料代码"
						      xxoldpart format "X(20)" label "旧号" 
						      xxserial label "批序号"
						      xxop     label "工位"
									xxpickqty format "->>>>9" label "派工数"
									xxinvqty format "->>>>>9" label "结存数"
								  xxvend format "x(18)"	label "供应商"
						 with frame c.
						 down with frame c.
						 
						put pt_desc1 at 2.
						put "描述:" at 30.
						if avail cd_det then do:
							find first tpt_mstr where tpt_mstr.pt_domain = global_domain and tpt_mstr.pt_part = substring(cd_det.cd_cmmt[1],1,4) no-lock no-error.
		          if avail tpt_mstr then
		          put tpt_mstr.pt_desc1 format "x(14)".
							 do j = 1 to 15 : 
				        	if (avail cd_det and cd_det.cd_cmmt[j] <> "") then put cd_det.cd_cmmt[j] skip.
				        	else 
				        	do:
				        		  if (not avail cd_det and avail pt_mstr) then
				        		  do:
				        				put pt_mstr.pt_desc2 skip.
				        				leave.
				        		  end.
				          end.
				        end.
				        put skip.
				    end.
						
		if last-of( xxloc ) or last-of(xxpler) or page-size - line-counter <= 4 then do:   
			put "--------------------------------------------------------------------------------------------------" skip.
			put "领料人:" at 1                               
					"帐务员:" at 20
					"配料员:" at 40 xxpler
					"制单员:" at 70 usr_name  format "x(8)"
					"   页数:"  string(page-number - wpage ) skip.
			put "[白联:库管 红联:财务 其他:配料]" at 1.
			if not last(xxloc) then page.
			if last-of(xxlcnbr) then wpage = page-number.
		end.
 end.
end. /*if yn1*/
*/
/*V8-*/
{wbrp04.i}
/*V8+*/
hide frame a no-pause.


