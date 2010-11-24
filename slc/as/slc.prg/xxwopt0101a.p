/* poporp6a.p - PURCHASE ORDER RECEIPTS REPORT Sort By Po Num                 */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* REVISION: 7.4    LAST MODIFIED: 12/17/93                 BY: dpm *H074     */
/* REVISION: 7.4    LAST MODIFIED: 09/27/94                 BY: dpm *FR87*    */
/* REVISION: 7.4    LAST MODIFIED: 10/21/94                 BY: mmp *H573*    */
/* REVISION: 7.4    LAST MODIFIED: 03/29/95                 BY: dzn *F0PN*    */
/* REVISION: 8.5    LAST MODIFIED: 11/15/95                 BY: taf *J053*    */
/* REVISION: 8.5    LAST MODIFIED: 02/12/96     BY: *J0CV* Robert Wachowicz   */
/* REVISION: 8.5    LAST MODIFIED: 04/08/96     BY: *G1LD* Jeff Wootton       */
/* REVISION: 8.5    LAST MODIFIED: 07/18/96     BY: *J0ZS* Tamra Farnsworth   */
/* REVISION: 8.5    LAST MODIFIED: 10/24/96     BY: *H0NK* Ajit Deodhar       */
/* REVISION: 8.5    LAST MODIFIED: 03/07/97     BY: *J1KL* Suresh Nayak       */
/* REVISION: 8.6    LAST MODIFIED: 10/03/97     BY: *K0KK* Madhusudhana Rao   */
/* REVISION: 8.6E   LAST MODIFIED: 02/23/98     BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E   LAST MODIFIED: 06/11/98     BY: *L020* Charles Yen        */
/* REVISION: 9.0    LAST MODIFIED: 02/06/99     BY: *M06R* Doug Norton        */
/* REVISION: 9.0    LAST MODIFIED: 03/13/99     BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1    LAST MODIFIED: 06/28/99     BY: *N00Q* Sachin Shinde      */
/* REVISION: 9.1    LAST MODIFIED: 12/23/99     BY: *L0N3* Sandeep Rao        */
/* REVISION: 9.1    LAST MODIFIED: 03/06/00     BY: *N05Q* David Morris       */
/* REVISION: 9.1    LAST MODIFIED: 03/24/00     BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1    LAST MODIFIED: 04/27/00     BY: *N09M* Peter Faherty      */
/* REVISION: 9.1    LAST MODIFIED: 06/30/00     BY: *N009* David Morris       */
/* REVISION: 9.1    LAST MODIFIED: 07/20/00     BY: *N0GF* Mudit Mehta        */
/* REVISION: 9.1    LAST MODIFIED: 08/13/00     BY: *N0KQ* Mark Brown         */
/* REVISION: 9.1    LAST MODIFIED: 01/18/01     BY: *N0VP* Sandeep Parab      */
/* Revision: 1.25        BY: Patrick Rowan        DATE: 04/17/02  ECO: *P043* */
/* Revision: 1.26        BY: Patrick Rowan        DATE: 05/24/02  ECO: *P018* */
/* Revision: 1.27        BY: Hareesh V            DATE: 06/21/02  ECO: *N1HY* */
/* Revision: 1.29        BY: Patrick Rowan        DATE: 08/15/02  ECO: *P0FH* */
/* Revision: 1.30        BY: Karan Motwani        DATE: 08/27/02  ECO: *N1SB* */
/* Revision: 1.31        BY: Dan Herman           DATE: 08/29/02  ECO: *P0DB* */
/* Revision: 1.32        BY: Mercy Chittilapilly  DATE: 12/10/02  ECO: *N21W* */
/* Revision: 1.33.1.1    BY: N. Weerakitpanich    DATE: 05/02/03  ECO: *P0R5* */
/* Revision: 1.33.1.2    BY: Paul Donnelly (SB)   DATE: 06/28/03  ECO: *Q00J* */
/* Revision: 1.33.1.3    BY: Deepak Rao           DATE: 07/31/03  ECO: *P0T9* */
/* Revision: 1.33.1.4    BY: Bhagyashri Shinde    DATE: 02/13/04  ECO: *P1NV* */
/* Revision: 1.33.1.5    BY: Manisha Sawant       DATE: 04/26/04  ECO: *P1YV* */
/* Revision: 1.33.1.6    BY: Bhagyashri Shinde    DATE: 11/23/04  ECO: *P2W5* */
/* Revision: 1.33.1.7    BY: Robin McCarthy       DATE: 01/05/05  ECO: *P2P6* */
/* $Revision: 1.33.1.8 $ BY: Sukhad Kulkarni      DATE: 03/29/05  ECO: *P2Y8* */
/* By: Neil Gao Date: 20070410 ECO: * ss 20070410.1 * */
/* By: Neil Gao Date: 20070521 ECO: * ss 20070521.1 * */

/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Report                                                       */

{mfdeclre.i }
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
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
define variable j as integer.
define variable k as integer.
define variable u as integer.
define variable tmpchar as character format "x(120)".
define variable tmpchar1 as character.
define variable tmpchar2 as character format "x(300)".
define variable xxdep like usrg_group_desc.
define buffer tcd_det for cd_det.
define buffer tpt_mstr for pt_mstr.
define buffer tpt_mstr2 for pt_mstr.
define variable xxtemp as character.
define variable xxtemp1 like ld_qty_oh.

define shared variable noprinter				as logical.
DEFINE VARIABLE wpage     AS integer format ">>>" init 0.

define temp-table xxlcsn
	field xxlcsn_type as char
	field xxlcsn_sn as char
	field xxlcsn_nbr as char
	field xxlcsn_nbr1 as char.

empty temp-table xxlcsn.

form
              	tr_part label "物料代码"
					      vp_vend_part format "X(20)" label "旧号" 
					      tr_serial label "批序号"
					      tr_ref label "参考"
								pt_mstr.pt_um
								wod_qty_req format ">>>>9" label "计划数"
								tr_qty_loc  format ">>>>9" label "派工数"
								xxtemp1 format ">>>>>9" label "结存数"
							  vd_sort format "x(18)"	label "供应商" 
with frame c width 200 down attr-space.						  
							  		  

for each usrw_wkfl where usrw_domain = global_domain and usrw_key1 = sntype and
	usrw_key2 >= snnbr and usrw_key2 <= snnbr1 and 
	usrw_datefld[1] >= rdate and usrw_datefld[1] <= rdate1 and
	( usrw_datefld[2] = ? or not noprinter ) no-lock :
	{xxlcsntb.i "usrw_charfld"}
	
end.

for each usrw_wkfl where usrw_domain = global_domain and usrw_key1 = sntype and
	usrw_key2 >= snnbr and usrw_key2 <= snnbr1 and 
	usrw_datefld[1] >= rdate and usrw_datefld[1] <= rdate1 and 
	( usrw_datefld[2] = ? or not noprinter ) no-lock,
	each xxlcsn where xxlcsn_type = sntype and xxlcsn_sn = usrw_key2 no-lock ,
	each tr_hist where tr_domain = global_domain and tr_trnbr = int(xxlcsn_nbr) no-lock,
	each pt_mstr where pt_domain = global_domain and pt_part = tr_part no-lock
	break by usrw_key2 by tr_loc by tr_part by tr_wod_op:

	find first wo_mstr where wo_domain = global_domain and wo_nbr = tr_nbr and wo_lot = tr_lot no-lock no-error.
	find first so_mstr where so_domain = global_domain and so_nbr = wo_so_job no-lock no-error.
	find first sod_det where sod_domain = global_domain and sod_nbr = so_nbr and sod_part = wo_part no-lock no-error.
  find first sp_mstr where sp_domain = global_domain and sp_addr = so_slspsn[1] no-lock no-error.
  if avail sp_mstr then
  	xxtemp = sp_sort.
  
/*
	find first usrgd_det where usrgd_domain = global_domain and usrgd_userid = so_slspsn[1] no-lock no-error.
	find first usrg_mstr where usrg_mstr.oid_usrg_mstr = usrgd_det.oid_usrg_mstr no-lock no-error.
	if avail usrg_mstr then
		xxdep = usrg_group_desc.
*/
if avail so_mstr then do:
  if so_nbr begins "1" then
  	xxdep = "国贸部".
  else if so_nbr begins "2" then
  	xxdep = "营销部".
  else
  	xxdep = "技术部".
end.
  	
	find first tcd_det where tcd_det.cd_domain = global_domain and tcd_det.cd_ref = wo_part and tcd_det.cd_type = "SC" and tcd_det.cd_lang = "ch" no-lock no-error.	
  do k = 1 to 15 : 
        	if (avail tcd_det and tcd_det.cd_cmmt[k] <> "") then 
        	do:
        		tmpchar = tmpchar + tcd_det.cd_cmmt[k].
          end.
  end.
  find first tpt_mstr where tpt_mstr.pt_domain = global_domain and tpt_mstr.pt_part = substring(wo_part,1,4) no-lock no-error.
  if avail tpt_mstr then
  	tmpchar1 = tpt_mstr.pt_desc1.
  
  find first cmt_det where cmt_domain = global_domain and cmt_indx = sod_cmtindx no-lock no-error.
  do u = 1 to 15:
  	if (avail cmt_det and cmt_cmmt[u] <> "") then
  	do:
  		 tmpchar2 = tmpchar2 + cmt_cmmt[u].
  	end.
  end.
  	

FORM  HEADER
    "隆鑫工业有限公司四轮车部" at 40 skip
		"零部件发料清单" at 42 skip(1)
		"加工单号:"   at 1  trim(tr_nbr)
		"ID:"         at 25 trim(tr_lot)
		"发料库位:"   at 40 tr_loc                         
		"制单日期:" at 61  today string(time,"hh:mm am") skip          
		"单据号:"  at 1 usrw_key2 format "x(11)"
		"销售订单号:" at 40 wo_so_job
		"计划部门:" at 61 trim(xxdep)
		"业务员:" at 85 trim(xxtemp) skip                     
		"成品号:" at 1 wo_part
		"旧机型:" at 40 tmpchar1
		"派工数量:" at 61 string(wo_qty_ord)
		"生产线:" at 85 wo_vend
		"描述:" at 1 substring(tmpchar,1,100,"raw") format "x(100)" skip
		substring(tmpchar,101,100,"raw") format "x(100)" skip
		"备注:" at 1 substring(tmpchar2,1,100,"raw") format "x(100)" skip
		substring(tmpchar2,101,100,"raw") format "x(100)" skip
		substring(tmpchar2,201,100,"raw") format "x(100)" 
WITH STREAM-IO FRAME ph1 PAGE-TOP WIDTH 130 NO-BOX.

/*	if page-size - line-counter <= 5 then page .   */
	
	view frame ph1 .
	
/*			find first cp_mstr where cp_domain = global_domain and cp_cust = "C0001" and cp_part = tr_part no-lock no-error.  */
			find first ad_mstr where ad_domain = global_domain and ad_addr = substring(tr_serial,10) no-lock no-error.
			find first usr_mstr where usr_userid = usrw_key3 no-lock no-error.
			find first wod_det  where wod_domain = global_domain and wod_nbr = tr_nbr and wod_lot = tr_lot and wod_part = tr_part no-lock no-error.
			find first cd_det where cd_det.cd_domain = global_domain and cd_det.cd_ref = tr_part and cd_det.cd_type = "SC" and cd_det.cd_lang = "ch" no-lock no-error.			
			find first vp_mstr where vp_domain = global_domain and vp_part = tr_part and  vp_vend = substring(tr_serial,10) no-lock no-error.	
			find first vd_mstr where vd_domain = global_domain and vd_addr = substring(tr_serial,10) no-lock no-error.
			xxtemp1 = 0.
			for each ld_det where ld_domain = global_domain and ld_part = tr_part and substring(ld_lot,10) = substring(tr_serial,10) and ld_status begins "Y" no-lock:
				xxtemp1 = xxtemp1 + ld_qty_oh.
			end.
				
			
					disp 	tr_part label "物料代码"
					      vp_vend_part format "X(20)" label "旧号" when avail vp_mstr
					      tr_serial label "批序号"
					      tr_ref label "参考"
								pt_mstr.pt_um
								wod_qty_req format ">>>>9" label "计划数"
								(- tr_qty_loc ) format ">>>>9" label "派工数"
								xxtemp1 format ">>>>>9" label "结存数"
							  vd_sort format "x(18)"	label "供应商" when avail vd_mstr
/*								
								tr_wod_op  when tr_wod_op <> 0 @ wod_op Column-label "工位"
								wod_op Column-label "工位" when tr_wod_op = 0
*/
					with frame c.
					down with frame c.
					
					put pt_mstr.pt_desc1 at 1.
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
		  
/*        
	if last-of( usrw_key2 ) or last-of( tr_loc ) then do:
		repeat while page-size - line-counter >= 2 :
			put " " skip.
		end.
	end.
	last-of( usrw_key2 ) or
*/

 if last-of(tr_loc) then do:
 	  put skip(2).
 		put "全缺的物料" skip.
 		put "------------------------" skip.
 		for each wod_det where wod_domain = global_domain 
 		                   and wod_nbr = tr_nbr and wod_lot = tr_lot
 		                   and wod_qty_iss = 0 no-lock,
 		    each tpt_mstr2 where tpt_mstr2.pt_domain = global_domain 
 		                     and tpt_mstr2.pt_part = wod_part no-lock
 		    break by wod_part:
 		                   disp
 		                   	wod_part  @  tr_part      /*  column-label "物料编码"*/
 		                   	tpt_mstr2.pt_desc1 @ vp_vend_part /*column-label "物料名称"*/
 		                   	string(wod_qty_req)    @  tr_serial  /*column-label "计划数"*/
 		                   	string(wod_qty_iss)    @  tr_ref /*column-label "派工数"*/
 		                   	/*with stream-io width 100*/
 		                   	
 		                   	with frame c
 		                   .
 		                   down with frame c.
 		                   
/* 		                   	tpt_mstr2.pt_desc2.	   */

 		end. /*for each wod_det*/
 		
 end.


	if last-of( tr_loc ) or page-size - line-counter <= 4 then do:   
		put "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" skip.
		put "领料人:" at 1                               
				"库管员:" at 20
				"配料员" at 40
				"制单员:" at 70 usr_name  format "x(8)"
				"   页数:"  string(page-number - wpage ) skip.
		put "[白联:库管 红联:财务 其他:配料]" at 1.
		if not last(tr_loc) then page.
		if last-of(usrw_key2) then wpage = page-number.
	end.
	tmpchar = "".
	tmpchar1 = "".
	tmpchar2 = "".

end. /* for each usrw_wkfl */
/*
for each usrw_wkfl where usrw_domain = global_domain and usrw_key1 = sntype and
	usrw_key2 >= snnbr and usrw_key2 <= snnbr1 and 
	usrw_datefld[1] >= rdate and usrw_datefld[1] <= rdate1 and 
	usrw_datefld[2] = ? ,
	first xxlcsn where xxlcsn_type = sntype and xxlcsn_sn = usrw_key2 no-lock ,
	first tr_hist where tr_domain = global_domain and tr_trnbr = int(xxlcsn_nbr) no-lock,
	first pt_mstr where pt_domain = global_domain and pt_part = tr_part no-lock:

	usrw_datefld[2] = today.
	
end.
*/
/*V8-*/
{wbrp04.i}
/*V8+*/
hide frame a no-pause.
