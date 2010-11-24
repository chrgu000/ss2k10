/*入库事务明细表 Designed by axiang 2007-06-05    */
/* By: Neil Gao Date: 08/02/27 ECO: * ss 20080227 */
/*Modified by Billy 2009-07-03                    */

{mfdtitle.i "billy "}

DEFINE VARIABLE date1 AS date.
DEFINE VARIABLE date2 AS date.
DEFINE VARIABLE loc LIKE tr_loc.
DEFINE VARIABLE loc1 LIKE tr_loc.
DEFINE VARIABLE part LIKE tr_part.
DEFINE VARIABLE part1 LIKE tr_part.
DEFINE VARIABLE user_id LIKE tr_userid.
DEFINE VARIABLE user_id1 LIKE tr_userid.
DEFINE VARIABLE trtype LIKE tr_type.
DEFINE VARIABLE type1 LIKE tr_type.
/* ss 20080227 - b */
define var vend like po_vend.
define var vend1 like po_vend.
/* ss 20080227 - e */

define variable site like tr_site.
define variable site1 like tr_site.

form
	 date1										colon 15
	 date2              	    colon 45
   part                     colon 15
   part1 label {t001.i}     colon 45
   site                     colon 15
   site1                    colon 45 
   loc                      colon 15
   loc1                     colon 45
   vend                     colon 15
   vend1   									colon 45 
   user_id                  colon 15
   user_id1 label {t001.i}  colon 45 
   trtype                     colon 15
   /*type1                    colon 45 skip(1)*/
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
REPEAT ON ENDKEY UNDO, LEAVE:

   if part1 = hi_char then part1 = "".
   if date1 = low_date then date1 = ?.
   if date2 = hi_date  then date2 = ?.
   if loc1 = hi_char then loc1 = "".
   if user_id1 = hi_char then user_id = "".
   if type1 = hi_char then type1 = "".
   if vend1 = hi_char then vend1 = "".
   if site1 = hi_char then site1 = "".

		IF c-application-mode <> 'web':u THEN
	   update
	   	date1 date2
      part part1
      site site1
      loc  loc1
      vend vend1
      user_id user_id1
      trtype /*type1*/
			WITH FRAME a.

		{wbrp06.i &command = UPDATE
			&fields = "date1 date2 part part1 site site1 loc loc1 vend vend1 user_id user_id1 trtype"
			&frm = "a"}

		  if part1 = "" then part1 = hi_char.
		  if date1 = ? then  date1 = low_date.
		  if date2 = ? then date2 = hi_date.
		  if site1 = "" then site1 = hi_char.
		  if loc1 = "" then loc1 = hi_char.
		  if vend1 = "" then vend1 = hi_char.
		  if user_id1 = "" then user_id1 = hi_char.
		  if type1 = "" then type1 = hi_char.

		  
		  {mfselprt.i "printer" 132}
		  
		for each tr_hist where tr_domain = global_domain 
		  		and tr_part >= part and tr_part <= part1
		      and tr_effdate >= date1 and tr_effdate <= date2
		      and tr_site >= site and tr_site <= site1
		      and tr_loc >= loc and tr_loc <= loc1
		      and ( tr_type = trtype or trtype = "" )
		      and tr_userid >= user_id and tr_userid <= user_id1
		      and tr_ship_type = ""
/* ss 20080227 */ and substring(tr_serial,7) >= vend and substring(tr_serial,7) <= vend1		      
		      /*and length( substring(tr_serial,10,6) ) = 6*/ no-lock,
		    each pt_mstr where pt_domain = global_domain 
		  		and pt_part = tr_part  no-lock
		break by tr_effdate by tr_part by  length(substring(tr_serial,7)):

	  find first vd_mstr where vd_domain = global_domain and vd_addr = substring(tr_serial,7) no-lock no-error.
	  find first cd_det where cd_domain = global_domain and cd_ref = tr_part and cd_type = "SC"
	  	and cd_lang = "ch" no-lock no-error.
/*
			FORM  HEADER
				"出入库事务明细表" colon 35
			WITH STREAM-IO FRAME phead PAGE-TOP WIDTH 132 NO-BOX.
      
			VIEW FRAME phead.*/
	
			if tr_type <> "ORD-PO" and tr_type <> "ORD-SO" then do:
					disp
						tr_effdate column-label "生效日期"
						tr_part COLUMN-LABEL "物料编码"
						pt_desc1 column-label "品名"
						cd_cmmt[1] column-label "描述" when avail cd_det
						tr_ref  COLUMN-LABEL "参考号"
						tr_userid COLUMN-LABEL "操作员"
						tr_effdate COLUMN-LABEL "操作日期"
						tr_loc COLUMN-LABEL "库区"
						substring(tr_serial,7) COLUMN-LABEL "供应商编码" when avail tr_hist
						vd_sort column-label "供应商简称" when avail vd_mstr
						tr_nbr COLUMN-LABEL "订单号"
/* 20080214 */ tr_lot column-label "ID"						
						tr_serial COLUMN-LABEL "批次号"
						tr_qty_loc COLUMN-LABEL "数量"
						tr_type COLUMN-LABEL "事务类型" 
						tr__chr01 column-label "单据号" format "x(20)" when tr_type <> "iss-so"
						tr_vend_lot  when tr_type = "iss-so" @ tr__chr01
						tr_vend_lot  when tr_type = "iss-wo" and (tr_program = "xxhuanjn.p" or tr_program = "xxhuanjcu.p") @ tr__chr01
						substring(tr_hist.tr_rmks,1,index(tr_hist.tr_rmks,'-') - 1 ) when tr_type = "RCT-TR" and tr_program = "xxtrchmt.p" @ tr__chr01
						tr_rmks  column-label "备注"
					with stream-io width 350.
			end.
		end.
		put " " skip(1).
/*		
		for each tr_hist where tr_domain = global_domain 
		  		and tr_part >= part and tr_part <= part1
		      and tr_effdate >= date and tr_effdate <= date1
		      and tr_loc >= loc and tr_loc <= loc1
		      and tr_type >= trtype and tr_type <= type1
		      and tr_userid > user_id and tr_userid <= user_id1
		      and tr_ship_type = ""
		      and length( substring(tr_serial,12,4) ) = 4 no-lock,
		    each pt_mstr where pt_domain = global_domain 
		  		and pt_part = tr_part 
		  		and pt_prod_line <> "1000" no-lock
		  break by  length(substring(tr_serial,12,4)):
			
			VIEW FRAME phead.
			
			if tr_type = "rct_unp" then
			do:
					disp
						tr_part COLUMN-LABEL "物料编码"
						tr_userid COLUMN-LABEL "操作员"
						tr_loc COLUMN-LABEL "库区"
						substring(tr_serial,12,4) COLUMN-LABEL "供应商编码" when avail tr_hist
						tr_nbr COLUMN-LABEL "单据号"
						tr_serial COLUMN-LABEL "批次号"
						tr_qty_chg COLUMN-LABEL "计划外入库数"
					with stream-io width 120.
					if avail pt_mstr then put pt_desc1.
					put skip.
				  if avail pt_mstr then put pt_desc2.
			end.
		end.
		
		for each tr_hist where tr_domain = global_domain 
		  		and tr_part >= part and tr_part <= part1
		      and tr_effdate >= date and tr_effdate <= date1
		      and tr_loc >= loc and tr_loc <= loc1
		      and tr_type >= trtype and tr_type <= type1
		      and tr_userid > user_id and tr_userid <= user_id1
		      and tr_ship_type = ""
		      and length( substring(tr_serial,12,4) ) = 4 no-lock,
		    each pt_mstr where pt_domain = global_domain 
		  		and pt_part = tr_part 
		  		and pt_prod_line <> "1000" no-lock
		    break by  length(substring(tr_serial,12,4)):
		    	
		  VIEW FRAME phead.

		  if tr_type = "iss-wo" or tr_type = "cn-iss" then
		  do:
		  		disp
		  			tr_part COLUMN-LABEL "物料编码"
						tr_userid COLUMN-LABEL "操作员"
						tr_loc COLUMN-LABEL "库区"
						substring(tr_serial,12,4) COLUMN-LABEL "供应商编码" when avail tr_hist
						tr_nbr COLUMN-LABEL "单据号"
						tr_serial COLUMN-LABEL "批次号"
						tr_qty_chg COLUMN-LABEL "定额领料"
		  		with stream-io width 120.
		  		if avail pt_mstr then put pt_desc1.
					put skip.
				  if avail pt_mstr then put pt_desc2.
		  end.    
    end.
    
    for each tr_hist where tr_domain = global_domain 
		  		and tr_part >= part and tr_part <= part1
		      and tr_effdate >= date and tr_effdate <= date1
		      and tr_loc >= loc and tr_loc <= loc1
		      and tr_type >= trtype and tr_type <= type1
		      and tr_userid > user_id and tr_userid <= user_id1
		      and tr_ship_type = ""
		      and length( substring(tr_serial,12,4) ) = 4 no-lock,
		    each pt_mstr where pt_domain = global_domain 
		  		and pt_part = tr_part 
		  		and pt_prod_line <> "1000" no-lock
		    break by  length(substring(tr_serial,12,4)):
		    	
		  VIEW FRAME phead.
  
		  if tr_type = "iss-unp" then
		  do:
		  	 disp
		  			tr_part COLUMN-LABEL "物料编码"
						tr_userid COLUMN-LABEL "操作员"
						tr_loc COLUMN-LABEL "库区"
						substring(tr_serial,12,4) COLUMN-LABEL "供应商编码" when avail tr_hist
						tr_nbr COLUMN-LABEL "单据号"
						tr_serial COLUMN-LABEL "批次号"
						tr_qty_chg COLUMN-LABEL "计划外领料"
		  	 with stream-io width 120.
		  	 if avail pt_mstr then put pt_desc1.
				 put skip.
				 if avail pt_mstr then put pt_desc2.
		  end.
	  end.
*/ 
		{mfreset.i}
		{mfgrptrm.i}
		  
end.
{wbrp04.i &frame-spec = a}
		      
		  