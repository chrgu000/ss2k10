/* xxqmrp092.p 成品库存报表,按输入日期的BOM,展开成原材料               */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 2008/05/20   BY: Softspeed RogerXiao         */

/****************************************************************************/

/*
说明:
1.地点(上线前):1100-->1100,1300,1700 ;1200--> 1200,1400 .  
  香港库位v_loclist 
2.成品展成原材料:按库存地点(指定地点-->地点清单-->地点清单内库存的地点-->判断P/M),BOM生效日期展开
3.生产线入仓数: 不含返修工单wo_type<> "R"
4.出货数量: 所有iss-so ,暂不能从系统区分返修品

*/


{mfdtitle.i "1+ "}

/*define temp table for a6ppptrp0701.p*/
{a6ppptrp0701.i "new"}

DEFINE TEMP-TABLE tta6ictrrp0303
    FIELD tta6ictrrp0303_inv_nbr LIKE tr_rmks
    FIELD tta6ictrrp0303_nbr LIKE tr_nbr
    FIELD tta6ictrrp0303_line LIKE tr_line
    FIELD tta6ictrrp0303_site LIKE tr_site
    FIELD tta6ictrrp0303_pl LIKE tr_prod_line
    FIELD tta6ictrrp0303_part LIKE tr_part
    FIELD tta6ictrrp0303_trnbr LIKE tr_trnbr
    FIELD tta6ictrrp0303_traddr LIKE tr_addr
    FIELD tta6ictrrp0303_lot LIKE tr_lot
    FIELD tta6ictrrp0303_effdate LIKE tr_effdate
    FIELD tta6ictrrp0303_date LIKE tr_date
    FIELD tta6ictrrp0303_type LIKE tr_type
    FIELD tta6ictrrp0303_loc LIKE tr_loc
    FIELD tta6ictrrp0303_qty_dr LIKE tr_qty_loc
    FIELD tta6ictrrp0303_amt_dr LIKE trgl_gl_amt
    FIELD tta6ictrrp0303_qty_cr LIKE tr_qty_loc
    FIELD tta6ictrrp0303_amt_cr LIKE trgl_gl_amt
    FIELD tta6ictrrp0303_program LIKE tr_program /* add by: SS - 20070301.1 */
    FIELD tta6ictrrp0303_ship_type LIKE tr_ship_type                                                                      
    index index1 tta6ictrrp0303_part tta6ictrrp0303_type tta6ictrrp0303_trnbr
    index index2 tta6ictrrp0303_loc tta6ictrrp0303_part tta6ictrrp0303_type tta6ictrrp0303_trnbr
    index index3 tta6ictrrp0303_type
    index index4 tta6ictrrp0303_type tta6ictrrp0303_program tta6ictrrp0303_nbr
    index index5 tta6ictrrp0303_part
    .

DEF VAR v_rct_qty LIKE tr_qty_loc .
DEF VAR v_rct_amt LIKE trgl_gl_amt .
DEF VAR v_iss_qty LIKE tr_qty_loc .
DEF VAR v_iss_amt LIKE trgl_gl_amt .
DEF VAR v_rct_integer AS INTEGER .
DEF VAR v_iss_integer AS INTEGER .
DEF VAR v_log1 AS LOGICAL .
DEF VAR v_log2 AS LOGICAL .

define temp-table xxptstkrp02
    field xxptstkrp02_site			like pt_site     
	field xxptstkrp02_loc			like pt_loc 
	field xxptstkrp02_part			like pt_part
	field xxptstkrp02_desc1			like pt_desc1
	field xxptstkrp02_desc2			like pt_desc2
	field xxptstkrp02_um			like pt_um
	field xxptstkrp02_sct			as   decimal
	/*期初*/
	field xxptstkrp02_start_qty_oh		like ld_qty_oh		/*包含委托库存的库存量*/
	field xxptstkrp02_start_amt		like trgl_gl_amt
	field xxptstkrp02_start_cust_consi_qty	like ld_qty_oh		/*期初客户委托库存*/
	field xxptstkrp02_start_cust_consi_amt	like trgl_gl_amt
	/*field xxptstkrp02_start_supp_consi_qty	like ld_qty_oh		/*期初供应商委托库存*/
	field xxptstkrp02_start_supp_consi_amt	like trgl_gl_amt	*/
	/*入库及出库事务*/
	field xxptstkrp02_rctiss_qty		like ld_qty_oh   extent 60
	field xxptstkrp02_rctiss_amt		like trgl_gl_amt extent 60
	/*期末库存*/
	field xxptstkrp02_end_qty_oh		like ld_qty_oh		/*包含委托库存的库存量*/
	field xxptstkrp02_end_amt		like trgl_gl_amt
	field xxptstkrp02_end_cust_consi_qty	like ld_qty_oh		/*期初客户委托库存*/
	field xxptstkrp02_end_cust_consi_amt	like trgl_gl_amt
	/*field xxptstkrp02_end_supp_consi_qty	like ld_qty_oh		/*期初供应商委托库存*/
	field xxptstkrp02_end_supp_consi_amt	like trgl_gl_amt*/
	/*集团内部 外部进口 外部国内*/
    field xxptstkrp02_jtnb_rct_qty		like ld_qty_oh  /*集团内部采购*/
    field xxptstkrp02_wbjk_rct_qty		like ld_qty_oh
	field xxptstkrp02_wbgn_rct_qty		like ld_qty_oh
	field xxptstkrp02_jtnb_tmp_qty		like ld_qty_oh	/* 集团内部暂估 = 集团内部采购 - 集团内部发票 */
	field xxptstkrp02_wbjk_tmp_qty		like ld_qty_oh
	field xxptstkrp02_wbgn_tmp_qty		like ld_qty_oh
	field xxptstkrp02_jtnb_inv_qty		like ld_qty_oh	/*集团内部发票*/
	field xxptstkrp02_wbjk_inv_qty		like ld_qty_oh
	field xxptstkrp02_wbgn_inv_qty		like ld_qty_oh
	/*集团内部 外部进口 外部国内 金额*/
	field xxptstkrp02_jtnb_rct_amt		like trgl_gl_amt	/*集团内部采购*/
	field xxptstkrp02_wbjk_rct_amt		like trgl_gl_amt
	field xxptstkrp02_wbgn_rct_amt		like trgl_gl_amt
	field xxptstkrp02_jtnb_tmp_amt		like trgl_gl_amt	/* 集团内部暂估 = 集团内部采购 - 集团内部发票 */
	field xxptstkrp02_wbjk_tmp_amt		like trgl_gl_amt
	field xxptstkrp02_wbgn_tmp_amt		like trgl_gl_amt
	field xxptstkrp02_jtnb_inv_amt		like trgl_gl_amt	/*集团内部发票*/
	field xxptstkrp02_wbjk_inv_amt		like trgl_gl_amt
	field xxptstkrp02_wbgn_inv_amt		like trgl_gl_amt
	index index1  	xxptstkrp02_part.		/* Add By:  SS - 20070118.1 */


define var v_only_total as logical format "Yes - 仅汇总 /No - 仅明细" initial yes .
define temp-table temp99
	field t99_part			like pt_part
	field t99_desc1			like pt_desc1
	field t99_desc2			like pt_desc2
	field t99_um			like pt_um
	/*期初*/
	field t99_start_qty_oh		like ld_qty_oh	
	field t99_start_amt		    like trgl_gl_amt
	/*入库及出库事务*/
	field t99_rctiss_qty		like ld_qty_oh   extent 60
	field t99_rctiss_amt		like trgl_gl_amt extent 60
	/*期末库存*/
	field t99_end_qty_oh		like ld_qty_oh	
	field t99_end_amt		    like trgl_gl_amt .



/*存放入库事务及出库事务如	1 rct-po  2 rct-unp  3 iss-so  4 iss-wo 等等*/
define temp-table tt	
	field tt_integer	 as integer
	field tt_trtype		 as char 
	field tt_trtype_name as char 
    FIELD tt_class       AS CHAR 
	index index1 tt_integer tt_trtype .

define variable site     like prh_site     no-undo.
define variable site1    like prh_site     no-undo.
define variable loc	 like ld_loc       no-undo.
define variable loc1	 like ld_loc       no-undo.
define variable locgroup as char format "x(30)" .
define variable idate    like vph_inv_date no-undo.
define variable idate1   like vph_inv_date no-undo.
define variable line     like pt_prod_line no-undo.
define variable line1    like pt_prod_line no-undo.
define variable part     like prh_part     no-undo.
define variable part1    like prh_part     no-undo.
define variable vendor   like prh_vend     no-undo.
define variable vendor1  like prh_vend     no-undo.
define variable rcttype as char .
define variable ii as inte .
define variable maxii as inte .
define variable v_yn as logi.
define  variable buyer    like prh_buyer    no-undo.
define  variable buyer1   like prh_buyer    no-undo.
define  variable order    like prh_nbr      no-undo.
define  variable order1   like prh_nbr      no-undo.
define  variable sel_inv  like mfc_logical  no-undo
                          label "Inventory Items" initial yes.
define  variable sel_sub  like mfc_logical  no-undo
                          label "Subcontracted Items" initial yes.
define  variable sel_mem  like mfc_logical  no-undo
                          label "Memo Items" initial no.
define  variable sel_neg  like mfc_logical  no-undo
                                    label "Include Returns" initial no.

/*a6ppptrp0701 var*/
define variable abc		like pt_abc       no-undo.
define variable abc1		like pt_abc       no-undo.
define variable part_group    like pt_group     no-undo.
define variable part_group1   like pt_group     no-undo.
define variable part_type     like pt_part_type no-undo.
define variable part_type1    like pt_part_type no-undo.
define variable as_of_date        like tr_effdate no-undo.
define variable neg_qty       like mfc_logical initial yes
   label "Include Negative Inventory" no-undo.
define variable net_qty       like mfc_logical initial yes
   label "Include Non-nettable Inventory" no-undo.
define variable inc_zero_qty  like mfc_logical initial no
   label "Include Zero Quantity" no-undo.
define variable zero_cost     like mfc_logical initial yes
   label "Accept Zero Initial Cost" no-undo.

/* CONSIGNMENT VARIABLES */
{pocnvars.i}
{pocnvar2.i}

/*a6ictrrp0301*/
define variable glref  like trgl_gl_ref.
define variable glref1 like trgl_gl_ref.
define variable efdate like tr_effdate.
define variable efdate1 like tr_date.
define variable trtype like tr_type.
define variable entity like en_entity.
define variable entity1 like en_entity.
define variable acct like glt_acct.
define variable acct1 like glt_acct.
define variable sub like glt_sub.
define variable sub1 like glt_sub.
define variable proj like glt_project.
define variable proj1 like glt_project.
define variable cc like glt_cc.
define variable cc1 like glt_cc.
define variable trdate like tr_date.
define variable trdate1 like tr_date.
DEF VAR v_idate LIKE tr_date .

DEF TEMP-TABLE tt2 
    FIELD tt2_part LIKE tr_part
	field tt2_jtnb_rct_qty		like ld_qty_oh	/*集团内部采购*/
	field tt2_wbjk_rct_qty		like ld_qty_oh
	field tt2_wbgn_rct_qty		like ld_qty_oh
	field tt2_jtnb_inv_qty		like ld_qty_oh	/*集团内部发票*/
	field tt2_wbjk_inv_qty		like ld_qty_oh
	field tt2_wbgn_inv_qty		like ld_qty_oh
	field tt2_jtnb_rct_amt		like trgl_gl_amt	/*集团内部采购*/
	field tt2_wbjk_rct_amt		like trgl_gl_amt
	field tt2_wbgn_rct_amt		like trgl_gl_amt
	field tt2_jtnb_inv_amt		like trgl_gl_amt	/*集团内部发票*/
	field tt2_wbjk_inv_amt		like trgl_gl_amt
	field tt2_wbgn_inv_amt		like trgl_gl_amt
    INDEX ipart tt2_part
    .

DEF TEMP-TABLE tt3 
    FIELD tt3_type LIKE tr_type
    FIELD tt3_program LIKE tr_program
    FIELD tt3_nbr LIKE tr_nbr
    INDEX nbr1 tt3_type tt3_program tt3_nbr 
    .

def var v_jtnb_tmp_qty like ld_qty_oh.
def var v_wbjk_tmp_qty like ld_qty_oh.
def var v_wbgn_tmp_qty like ld_qty_oh.
def var v_jtnb_tmp_amt like trgl_gl_amt.
def var v_wbjk_tmp_amt like trgl_gl_amt.
def var v_wbgn_tmp_amt like trgl_gl_amt.



define temp-table temp1
        field t1_par         like ps_par label "父零件" 
        field t1_comp        like ps_comp  label "子零件"
        field t1_site        like si_site
        field t1_um          like pt_um
        field t1_desc1       like pt_desc1
        field t1_desc2       like pt_desc2
        field t1_qty_per     like ps_qty_per
        index t1_parcomp     t1_par t1_comp.


define variable eff__date as date label "BOM生效日期".
define var v_site        like si_site     .
define var v_sitelist    as char .
define var v_loclist     as char .



/******************** SS - 20070308.1 - E ********************/

/* THE FIELD LABEL OF THE DATE SELECTION CHANGED FROM INVOICE DATE */
/* TO EFFECTIVE.                                                   */
find first icc_ctrl where icc_domain = global_domain no-lock no-error.
site = if available icc_ctrl then icc_site else global_domain .

idate1 = date (month(today),1,year(today)) - 1 .
idate  = date (month(idate1),1,year(idate1)) .
eff__date = idate1 .
site   = "" .
site1  = "" .
v_site = "1100" .


FORM

    idate	label "Effective" colon 15      
    idate1	label "To"        colon 49 skip 

    v_site		colon 15
    eff__date  colon 15 label "BOM生效日期"
    v_only_total colon 15 label "汇总/明细"
    skip(1)

    part		colon 15                    
    part1	label {t001.i} colon 49
    loc		colon 15               
    loc1		label {t001.i} colon 49
   



   /*locgroup	label "库位分组" colon 15*/
    /*site1	label {t001.i} colon 49*/       

   /*line		colon 15                    
   line1	label {t001.i} colon 49 skip*/
   
/*   vendor	colon 15                    
   vendor1	label {t001.i} colon 49 skip
*/
  
    
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
	hide all no-pause .
	view frame dtitle .
   if idate   = low_date then idate = ?.
   if idate1  = hi_date then idate1 = ?.
   if vendor1 = hi_char then vendor1 = "".
   if loc1    = hi_char then loc1  = "".
   if part1   = hi_char then part1 = "".
   if site1   = hi_char then site1 = "".
   if line1   = hi_char then line1 = "".
   if glref1 = hi_char then
      glref1 = "".
   if trdate = low_date then
      trdate = ?.
   if trdate1 = hi_date then
      trdate1 = ?.
   if acct1  = hi_char then
      acct1  = "".
   if sub1   = hi_char then
      sub1   = "".
   if cc1    = hi_char then
      cc1    = "".
   if proj1  = hi_char then
      proj1  = "".

   if c-application-mode <> 'web' then
      update
    	 idate	
    	 idate1	         
         v_site	
         eff__date
         v_only_total
    	 
         
    	 	
    	 part		
    	 part1	
         loc		
    	 loc1	
    	 /*vendor	
    	 vendor1*/
         /*site1*/	
    	 /*locgroup	*/	              

    	 /*line		
    	 line1	*/
         
      with frame a.

      if eff__date= ? then eff__date = date (month(today),1,year(today)) - 1 .

      if lookup(v_site,"1100,1200") = 0 then do:
          message "地点仅限1100,1200,请重新输入" view-as alert-box.
          next-prompt v_site.
          undo,retry .
      end.
      if v_site = "1100" then v_sitelist = "1100,1300,1700" .
      if v_site = "1200" then v_sitelist = "1200,1400" .
      v_loclist = "500,666,888,999" .



   {wbrp06.i &command = update &fields = " 
			 idate	
			 idate1
             v_site		
			 eff__date 
             v_only_total
             
			 part		
			 part1	
			 loc		
			 loc1			              
			 		
			     
		   " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i idate	}
      {mfquoter.i idate1	}
      {mfquoter.i v_site	}
      {mfquoter.i eff__date	}
      {mfquoter.i loc	}
      {mfquoter.i loc1	}
      {mfquoter.i part	}
      {mfquoter.i part1	}

      if idate = ? then idate = low_date.
      if idate1 = ? then idate1 = hi_date.
      if vendor1 = "" then vendor1 = hi_char.
      if part1 = "" then part1 = hi_char.
      if site1 = "" then site1 = hi_char.
      if loc1    = "" then loc1  = hi_char.
      if line1   = "" then line1 = hi_char.
      if glref1 = "" then
         glref1 = hi_char.
      if entity1 = "" then
         entity1 = hi_char.
      if acct1  = "" then
         acct1  = hi_char.
      if sub1   = "" then
         sub1   = hi_char.
      if cc1    = "" then
         cc1    = hi_char.
      if proj1  = "" then
         proj1  = hi_char.
      if trdate = ? then
         trdate = low_date.
      if trdate1 = ? then
         trdate1 = hi_date.

   end.
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

/*期初库存--begin*/
for each tta6ppptrp0701:
   delete tta6ppptrp0701.
end.

assign as_of_date = idate - 1 .		/*期初*/
{gprun.i ""a6ppptrp0701.p"" "(
    input part,
    input part1,
    input line,
    input line1,
    input vendor,
    input vendor1,
    input abc,
    input abc1,
    input site,
    input site1,
    input loc,
    input loc1,
    input part_group,
    input part_group1,
    input part_type,
    input part_type1,

    input as_of_date,
    input neg_qty,
    input net_qty,
    input inc_zero_qty,
    input zero_cost,
    input customer_consign,
    input supplier_consign
)"}

for each tta6ppptrp0701
    where lookup(tta6ppptrp0701_site,v_sitelist) > 0 
    and lookup(tta6ppptrp0701_loc , v_loclist) = 0 :


    /*仅成品半成品*/
    find first ptp_det where ptp_domain = global_domain and ptp_part = tta6ppptrp0701_part and ptp_site = tta6ppptrp0701_site  no-lock no-error  .
    if avail ptp_det then do:
        if ptp_pm_code = "P" then next .
    end.
    else do:
        find first pt_mstr where pt_domain = global_domain and pt_part =  tta6ppptrp0701_part  no-lock no-error  .
        if not avail pt_mstr then next .
        else if pt_pm_code = "p" then next .
        else do:
        end.          
    end.



    find first xxptstkrp02 
        where xxptstkrp02_part = tta6ppptrp0701_part 
        and xxptstkrp02_site = tta6ppptrp0701_site 
        and xxptstkrp02_loc = tta6ppptrp0701_loc  
    no-error.
    if avail xxptstkrp02 then do:
        assign xxptstkrp02_start_qty_oh		= xxptstkrp02_start_qty_oh + tta6ppptrp0701_qty_non_consign + tta6ppptrp0701_qty_cust_consign + tta6ppptrp0701_qty_supp_consign
               xxptstkrp02_start_amt		= xxptstkrp02_start_amt + (tta6ppptrp0701_qty_non_consign + tta6ppptrp0701_qty_cust_consign + tta6ppptrp0701_qty_supp_consign) * tta6ppptrp0701_sct 
               xxptstkrp02_start_cust_consi_qty = xxptstkrp02_start_cust_consi_qty + tta6ppptrp0701_qty_cust_consign
               xxptstkrp02_start_cust_consi_amt = xxptstkrp02_start_cust_consi_amt + tta6ppptrp0701_qty_cust_consign * tta6ppptrp0701_sct .
    end.
    else do:      
        create xxptstkrp02.
        assign 
               xxptstkrp02_part			= tta6ppptrp0701_part
               xxptstkrp02_site         = tta6ppptrp0701_site 
               xxptstkrp02_loc          = tta6ppptrp0701_loc 
               xxptstkrp02_sct			= tta6ppptrp0701_sct
               xxptstkrp02_start_qty_oh		= tta6ppptrp0701_qty_non_consign + tta6ppptrp0701_qty_cust_consign + tta6ppptrp0701_qty_supp_consign
               xxptstkrp02_start_amt		= (tta6ppptrp0701_qty_non_consign + tta6ppptrp0701_qty_cust_consign + tta6ppptrp0701_qty_supp_consign) * tta6ppptrp0701_sct 
               xxptstkrp02_start_cust_consi_qty = tta6ppptrp0701_qty_cust_consign
               xxptstkrp02_start_cust_consi_amt = tta6ppptrp0701_qty_cust_consign * tta6ppptrp0701_sct .
    end.
end.
/*期初库存--end*/
	
/*期末库存--begin*/
for each tta6ppptrp0701:
   delete tta6ppptrp0701.
end.
	
assign as_of_date = idate1 .		
{gprun.i ""a6ppptrp0701.p"" "(
    input part,
    input part1,
    input line,
    input line1,
    input vendor,
    input vendor1,
    input abc,
    input abc1,
    input site,
    input site1,
    input loc,
    input loc1,
    input part_group,
    input part_group1,
    input part_type,
    input part_type1,

    input as_of_date,
    input neg_qty,
    input net_qty,
    input inc_zero_qty,
    input zero_cost,
    input customer_consign,
    input supplier_consign
)"}
	
for each tta6ppptrp0701
    where lookup(tta6ppptrp0701_site,v_sitelist) > 0 
    and lookup(tta6ppptrp0701_loc , v_loclist) = 0 :


    /*仅成品半成品*/
    find first ptp_det where ptp_domain = global_domain and ptp_part = tta6ppptrp0701_part and ptp_site = tta6ppptrp0701_site  no-lock no-error  .
    if avail ptp_det then do:
        if ptp_pm_code = "P" then next .
    end.
    else do:
        find first pt_mstr where pt_domain = global_domain and pt_part =  tta6ppptrp0701_part  no-lock no-error  .
        if not avail pt_mstr then next .
        else if pt_pm_code = "p" then next .
        else do:
        end.          
    end.



    find first xxptstkrp02 
        where xxptstkrp02_part = tta6ppptrp0701_part 
        and xxptstkrp02_site   = tta6ppptrp0701_site 
        and xxptstkrp02_loc    = tta6ppptrp0701_loc  
    no-error.
    if avail xxptstkrp02 then do:
        assign xxptstkrp02_end_qty_oh	        = xxptstkrp02_end_qty_oh + tta6ppptrp0701_qty_non_consign + tta6ppptrp0701_qty_cust_consign + tta6ppptrp0701_qty_supp_consign
               xxptstkrp02_end_amt	            = xxptstkrp02_end_amt + (tta6ppptrp0701_qty_non_consign + tta6ppptrp0701_qty_cust_consign + tta6ppptrp0701_qty_supp_consign) * tta6ppptrp0701_sct 
               xxptstkrp02_end_cust_consi_qty   = xxptstkrp02_end_cust_consi_qty + tta6ppptrp0701_qty_cust_consign
               xxptstkrp02_end_cust_consi_amt   = xxptstkrp02_end_cust_consi_amt + tta6ppptrp0701_qty_cust_consign * tta6ppptrp0701_sct .
    end.		
end.
/*期末库存--end*/


/*tr_hist begin:*/
for each tta6ictrrp0303:
    delete tta6ictrrp0303.
end.

assign efdate = idate
       efdate1 = idate1 .   

for each tr_hist 
        field( tr_rmks tr_nbr tr_line tr_site tr_prod_line tr_part 
        tr_trnbr tr_addr tr_lot tr_effdate
        tr_date tr_type tr_loc tr_program tr_qty_loc )
        where tr_hist.tr_domain = global_domain
        and tr_part >= part and tr_part <= part1
        and tr_ship_type = ""
        and tr_loc >= loc and tr_loc <= loc1
        and tr_site >= site and tr_site <= site1
            and lookup(tr_site,v_sitelist) > 0 

        and tr_prod_line >= line
        and tr_prod_line <= line1
        and ( (tr_effdate >= efdate and tr_effdate <= efdate1 
        or tr_effdate = ?)
        and (tr_type = trtype or trtype = "")
        and (tr_date >= trdate and tr_date <= trdate1
        or tr_date = ?) ) 
    no-lock ,
    each trgl_det field( trgl_dr_acct trgl_gl_amt) 
        where trgl_det.trgl_domain = global_domain 
        and ( trgl_trnbr = tr_trnbr
        and ( trgl_gl_ref  >= glref  and trgl_gl_ref  <= glref1)
        and (
        (trgl_dr_acct >= acct and trgl_dr_acct <= acct1)
        or (trgl_cr_acct >= acct and trgl_cr_acct <= acct1)
        )
        and (
        (trgl_dr_sub >= sub and trgl_dr_sub <= sub1)
        or (trgl_cr_sub >= sub and trgl_cr_sub <= sub1)
        )
        and (
        (trgl_dr_cc >= cc and trgl_dr_cc <= cc1)
        or (trgl_cr_cc >= cc and trgl_cr_cc <= cc1)

        )
        and (
        (trgl_dr_proj >= proj and trgl_dr_proj <= proj1)
        or (trgl_cr_proj >= proj and trgl_cr_proj <= proj1)
        )  )
    no-lock  
    break by tr_type by tr_part by tr_site by tr_loc:

    /*仅成品半成品*/
    find first ptp_det where ptp_domain = global_domain and ptp_part = tr_part and ptp_site = tr_site  no-lock no-error  .
    if avail ptp_det then do:
        if ptp_pm_code = "P" then next .
    end.
    else do:
        find first pt_mstr where pt_domain = global_domain and pt_part =  tr_part  no-lock no-error  .
        if not avail pt_mstr then next .
        else if pt_pm_code = "p" then next .
        else do:
        end.          
    end.

    
    find first tta6ictrrp0303 where tta6ictrrp0303_trnbr   = tr_trnbr no-error .
    if not avail tta6ictrrp0303 then do:
        create tta6ictrrp0303.
        assign
            tta6ictrrp0303_inv_nbr = tr_rmks
            tta6ictrrp0303_nbr     = tr_nbr
            tta6ictrrp0303_line    = tr_line
            tta6ictrrp0303_site    = tr_site
            tta6ictrrp0303_pl      = tr_prod_line
            tta6ictrrp0303_part    = tr_part
            tta6ictrrp0303_trnbr   = tr_trnbr
            tta6ictrrp0303_traddr  = tr_addr
            tta6ictrrp0303_lot     = tr_lot
            tta6ictrrp0303_effdate = tr_effdate
            tta6ictrrp0303_date    = tr_date
            tta6ictrrp0303_type    = tr_type
            tta6ictrrp0303_loc     = tr_loc
            tta6ictrrp0303_program = tr_program /* add by: ss - 20070301.1 */
            .
    end.

    if  (trgl_dr_acct >= acct and trgl_dr_acct <= acct1) then do:
        assign
            tta6ictrrp0303_qty_dr = tr_qty_loc
            tta6ictrrp0303_amt_dr = trgl_gl_amt
            .
    end.
    else do:
        assign
            tta6ictrrp0303_qty_cr = tr_qty_loc
            tta6ictrrp0303_amt_cr = - trgl_gl_amt
            .
    end.
    if first-of(tr_type) then do:
        find first tt3 where tt3_type = tr_type  no-error.
        if not avail tt3 then do:
            create tt3 .
            assign 
                tt3_type = tr_type 
                .
        end.
    end.
    if first-of(tr_loc)  and lookup(tr_loc , v_loclist) = 0 then do:
        find first xxptstkrp02 
            where xxptstkrp02_part = tr_part 
            and xxptstkrp02_site   = tr_site 
            and xxptstkrp02_loc    = tr_loc  
        no-error.
        if not avail xxptstkrp02 then do:
            create xxptstkrp02.
            assign 
                xxptstkrp02_part   = tr_part
                xxptstkrp02_site   = tr_site 
                xxptstkrp02_loc    = tr_loc .                          
        end.
    end.
end.

/*tr_hist end*/

/*tr_type begin*/
    ii = 1 .
			create  tt .
			assign	tt_integer = ii 
				    tt_trtype  = "rct-WO "  
                    tt_class = "type" .
			ii = ii + 1 .
			create  tt .
			assign	tt_integer = ii 
			        tt_trtype  = "iss-SO " 
                    tt_class = "type"  .
			ii = ii + 1 .
	maxii = ii - 1 .
/*tr_type end*/



	for each xxptstkrp02 break by xxptstkrp02_site by xxptstkrp02_loc  by xxptstkrp02_part :

		/*本月入库事务--begin*/
		for each tta6ictrrp0303 field(tta6ictrrp0303_part tta6ictrrp0303_type tta6ictrrp0303_loc tta6ictrrp0303_nbr
                                      tta6ictrrp0303_trnbr tta6ictrrp0303_qty_dr tta6ictrrp0303_amt_dr tta6ictrrp0303_program ) 
                                where tta6ictrrp0303_part = xxptstkrp02_part
                                and tta6ictrrp0303_site = xxptstkrp02_site 
                                and tta6ictrrp0303_loc = xxptstkrp02_loc 
				                  and ((tta6ictrrp0303_type >= "rct" and tta6ictrrp0303_type <= "rctz") /* or tta6ictrrp0303_type = "iss-prv" */ )
			                      break by tta6ictrrp0303_type by tta6ictrrp0303_trnbr :
                
                find first tt where tt_trtype = tta6ictrrp0303_type no-error.
    			if not avail tt then next .
    			else do: 
                    if tta6ictrrp0303_type = "RCT-WO" then do:
                        find first wo_mstr where wo_domain = global_domain and wo_lot = tta6ictrrp0303_lot and wo_part = tta6ictrrp0303_part  no-lock no-error .
                        if not avail wo_mstr then next .
                        else do:
                            if wo_type = "R" then next . /*排除返修工单*/
                        end.
                    end.


    					assign xxptstkrp02_rctiss_qty[tt_integer] = xxptstkrp02_rctiss_qty[tt_integer] + tta6ictrrp0303_qty_dr .
    			        assign xxptstkrp02_rctiss_amt[tt_integer] = xxptstkrp02_rctiss_amt[tt_integer] + tta6ictrrp0303_amt_dr .
    			end.
                
                delete tta6ictrrp0303 .
		end.		
		/*本月入库事务--end*/

		/*本月出库事务--begin*/
		for each tta6ictrrp0303 field(tta6ictrrp0303_part tta6ictrrp0303_type tta6ictrrp0303_loc tta6ictrrp0303_nbr
                                      tta6ictrrp0303_trnbr tta6ictrrp0303_qty_dr tta6ictrrp0303_amt_dr tta6ictrrp0303_program )
                                where tta6ictrrp0303_part = xxptstkrp02_part
                                and tta6ictrrp0303_site = xxptstkrp02_site 
                                and tta6ictrrp0303_loc = xxptstkrp02_loc 
				                  and tta6ictrrp0303_type >= "iss" and tta6ictrrp0303_type <= "issz"
			                      break by tta6ictrrp0303_type by tta6ictrrp0303_trnbr :

                
                
                find first tt where tt_trtype = tta6ictrrp0303_type no-error.
    			if not avail tt then next .
    			else do:
    					assign xxptstkrp02_rctiss_qty[tt_integer] = xxptstkrp02_rctiss_qty[tt_integer] + tta6ictrrp0303_qty_dr .
    				    assign xxptstkrp02_rctiss_amt[tt_integer] = xxptstkrp02_rctiss_amt[tt_integer] + tta6ictrrp0303_amt_dr .
    			end.

                delete tta6ictrrp0303 .
		end.		
		/*本月出库事务--end*/           

	end.  /*end for each xxptstkrp02*/
    /*
    put unformatted "xxptrstkrp02 end: " + string(time, "hh:mm:ss") skip.
      */                      

for each temp1 : delete temp1. end.
for each xxptstkrp02 break by xxptstkrp02_site by xxptstkrp02_part :
    if last-of(xxptstkrp02_part) then do:
            run process_report (input xxptstkrp02_part,input eff__date ,input xxptstkrp02_site ).
    end.
end.

for each temp99 : delete temp99 . end.


	put unformatted "#def reportpath=$/Citizen/xxqmrp092" skip.
	put unformatted "#def :end" skip.   

	for each xxptstkrp02 ,
        each pt_mstr where pt_domain = global_domain and pt_part = xxptstkrp02_part no-lock ,
        each temp1 where t1_par = pt_part and t1_site = xxptstkrp02_site
        break by xxptstkrp02_site by xxptstkrp02_loc  by xxptstkrp02_part 
        :   

        
        v_log1 = no .
        v_log2 = no .
        if (xxptstkrp02_start_qty_oh <> 0 or
            xxptstkrp02_end_qty_oh <> 0 ) then v_log1 = yes .
        if maxii >= 1 then do:
            do ii = 1 to maxii :
                if xxptstkrp02_rctiss_qty[ii] <> 0 then v_log2 = yes.
            end.
        end.

        if v_log1 = yes or v_log2 = yes then do:
            if v_only_total = no then do:
                put unformatted xxptstkrp02_site			  ";" .
                put unformatted xxptstkrp02_loc			  ";" .
                put unformatted xxptstkrp02_part			  ";" .
                put unformatted pt_desc1			  ";" .
                put unformatted pt_desc2			  ";" .
                put unformatted pt_um			  ";" .
                put unformatted t1_comp			  ";" .
                put unformatted t1_desc1			  ";" .
                put unformatted t1_desc2			  ";" .
                put unformatted t1_um			  ";" .
                put unformatted xxptstkrp02_start_qty_oh  * t1_qty_per	  ";" .
                if maxii >= 1 then do:
                    do ii = 1 to maxii:
                            if xxptstkrp02_rctiss_qty[ii] >= 0 then do:
                                 put unformatted xxptstkrp02_rctiss_qty[ii]	 * t1_qty_per	";" .
                            end.
                            else do:
                                 put unformatted xxptstkrp02_rctiss_qty[ii] * t1_qty_per		";" .
                            end.
                    end.   
                end.
                put unformatted xxptstkrp02_end_qty_oh	 * t1_qty_per		. 
                put skip .
            end.

            find first temp99 where t99_part = t1_comp	no-error .
            if not avail temp99 then do:
                create temp99 .
                assign 
                    t99_part     = t1_comp
                    t99_desc1    = t1_desc1
                    t99_desc2    = t1_desc2
                    t99_um       = t1_um
                    t99_start_qty_oh  = xxptstkrp02_start_qty_oh  * t1_qty_per 
                    t99_end_qty_oh = xxptstkrp02_end_qty_oh	 * t1_qty_per	
                    .
                    if maxii >= 1 then do:
                        do ii = 1 to maxii:
                            t99_rctiss_qty[ii] =  xxptstkrp02_rctiss_qty[ii]	 * t1_qty_per .                               
                        end.   
                    end.
            end.
            else do:
                    assign 
                    t99_start_qty_oh  = t99_start_qty_oh + xxptstkrp02_start_qty_oh  * t1_qty_per 
                    t99_end_qty_oh = t99_end_qty_oh + xxptstkrp02_end_qty_oh	 * t1_qty_per	
                    .
                    if maxii >= 1 then do:
                        do ii = 1 to maxii:
                            t99_rctiss_qty[ii] = t99_rctiss_qty[ii] + xxptstkrp02_rctiss_qty[ii] * t1_qty_per .                               
                        end.   
                    end.                
            end.


        end. 


    end.
if v_only_total = yes then do:
    for each temp99:
            put unformatted 	  "零件总计;;;;;;" .
            put unformatted t99_part			  ";" .
            put unformatted t99_desc1			  ";" .
            put unformatted t99_desc2			  ";" .
            put unformatted t99_um			  ";" .
    	    put unformatted t99_start_qty_oh    ";" .
            if maxii >= 1 then do:
                do ii = 1 to maxii:
                        put unformatted t99_rctiss_qty[ii]	";" .
                end.   
            end.
    	    put unformatted t99_end_qty_oh			. 
    		put skip .       
    end.
end.



    for each tt:
        delete tt.
    end.
    for each tt2:
        delete tt2.
    end.
    for each tt3:
        delete tt3.
    end.

    for each xxptstkrp02 :
        delete xxptstkrp02 .
    end.

    for each temp1 :
        delete temp1 .
    end.
    for each temp99 : delete temp99 . end.
    {a6mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}








/*--------------------------------------------------------------------------------------------------------*/


                
                
         
procedure process_report:
    define input  parameter vv_part as character .
    define input  parameter vv_eff_date as date format "99/99/99" .
    define input  parameter vv_site as character .
    
    define var  vv_comp like ps_comp no-undo.
    define var  vv_level as integer no-undo.
    define var  vv_record as integer extent 100.
    define var  vv_qty as decimal initial 1 no-undo.
    define var  vv_save_qty as decimal extent 100 no-undo.
    define var  vv_pm_code like ptp_pm_code no-undo .
    define var  vv_recno    like recno .
    
    



    assign vv_level = 1 vv_qty = 1 vv_comp = vv_part  /*vv_site = ""*/ .

    find first ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp  no-lock no-error .
    repeat:        
               if not avail ps_mstr then do:                        
                     repeat:  
                        vv_level = vv_level - 1.
                        if vv_level < 1 then leave .                    
                        find ps_mstr where recid(ps_mstr) = vv_record[vv_level] no-lock no-error.
                        vv_comp  = ps_par.  
                        vv_qty = vv_save_qty[vv_level].            
                        find next ps_mstr use-index ps_parcomp where ps_domain = global_domain and  ps_par = vv_comp  no-lock no-error.
                        if avail ps_mstr then leave .               
                    end.
                end.  /*if not avail ps_mstr*/
            
                if vv_level < 1 then leave .
                vv_record[vv_level] = recid(ps_mstr).                
                
                
                if (ps_end = ? or vv_eff_date <= ps_end) then do :
                       vv_save_qty[vv_level] = vv_qty.
                       
                
                       vv_pm_code = "" .   
                       find ptp_det where ptp_domain = global_domain and ptp_part = ps_comp and ptp_site = vv_site no-lock no-error .
                       if avail ptp_det then do :
                             vv_pm_code = ptp_pm_code  .                             
                       end.
                       else do:
                            find pt_mstr where pt_domain = global_domain and pt_part = ps_comp no-lock no-error .
                            vv_pm_code = if avail pt_mstr then pt_pm_code else "" .
                       end.
                       
                       /*if ps_ps_code = "x" then vv_pm_code = "P"  . */

                              
                              
                     if vv_pm_code <> "P" then do:
                               vv_comp  = ps_comp .
                               vv_qty = vv_qty * ps_qty_per * (100 / (100 - ps_scrp_pct)).
                               vv_level = vv_level + 1.
                               vv_recno = recid(ps_mstr) .

                               find first ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp  no-lock no-error.
                               if not avail ps_mstr then do:
                                    find ps_mstr where recid(ps_mstr) = vv_recno  no-lock no-error.
                                    if avail ps_mstr then do:
                                        /*create */
                                        find first temp1 where t1_par = vv_part and t1_comp = ps_comp and t1_site = vv_site no-error.
                                        if not available temp1 then do:
                                            find pt_mstr where pt_domain = global_domain and pt_part = ps_comp no-lock no-error .
                                            create temp1.
                                            assign
                                                t1_par      = caps(vv_part)
                                                t1_comp     = caps(ps_comp)
                                                t1_site     = vv_site
                                                t1_desc1    = (if available pt_mstr then pt_desc1 else "")
                                                t1_desc2    = (if available pt_mstr then pt_desc2 else "")
                                                t1_um       = (if available pt_mstr then pt_um else "")
                                                t1_qty_per  = vv_qty 
                                                .
                                        end.
                                        else t1_qty_per   = t1_qty_per + vv_qty  .  
                                    end.
                               end.

                               
                               find first ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp  no-lock no-error.     
                     end. /*if vv_pm_code <> "P"*/
                     else do :
                                /*create */
                                find first temp1 where t1_par = vv_part and t1_comp = ps_comp and t1_site = vv_site no-error.
                                if not available temp1 then do:
                                    find pt_mstr where pt_domain = global_domain and pt_part = ps_comp no-lock no-error .
                                    create temp1.
                                    assign
                                        t1_par      = caps(vv_part)
                                        t1_comp     = caps(ps_comp)
                                        t1_site     = vv_site
                                        t1_desc1    = (if available pt_mstr then pt_desc1 else "")
                                        t1_desc2    = (if available pt_mstr then pt_desc2 else "")
                                        t1_um       = (if available pt_mstr then pt_um else "")
                                        t1_qty_per  = vv_qty * ps_qty_per * (100 / (100 - ps_scrp_pct))
                                        .
                                end.
                                else t1_qty_per   = t1_qty_per + vv_qty * ps_qty_per * (100 / (100 - ps_scrp_pct)) .  
                               find next ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp no-lock no-error.
                     end. /*if vv_pm_code = "P"*/      
                end.   /*if (ps_end = ? or vv_eff_date <= ps_end)*/
                else do:
                      find next ps_mstr use-index ps_parcomp where ps_domain = global_domain and ps_par = vv_comp  no-lock no-error.
                end.  /* not (ps_end = ? or vv_eff_date <= ps_end)  */
    
    
    end. /*repeat:*/   

end procedure.
