
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

DEF TEMP-TABLE tttr 
           FIELD tttr_part LIKE tr_part
           FIELD tttr_rct_loc LIKE tr_loc
           FIELD tttr_rct_trnbr LIKE tr_trnbr
           FIELD tttr_rct_qty_dr LIKE tr_qty_loc
           FIELD tttr_rct_amt_dr LIKE trgl_gl_amt
           FIELD tttr_iss_loc LIKE tr_loc
           FIELD tttr_iss_trnbr LIKE tr_trnbr
           FIELD tttr_iss_qty_dr LIKE tr_qty_loc
           FIELD tttr_iss_amt_dr LIKE trgl_gl_amt
           FIELD tttr_iss_integer AS INTEGER 
           FIELD tttr_rct_integer AS INTEGER 
           INDEX index1 tttr_part 
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
    field xxptstkrp02_line			like pt_prod_line
	field xxptstkrp02_desc1			like pt_desc1
	field xxptstkrp02_desc2			like pt_desc2
	field xxptstkrp02_um			like pt_um
	field xxptstkrp02_sct			as   decimal
	/*期初*/
	field xxptstkrp02_start_qty_oh		like ld_qty_oh		/*包含委托库存的库存量*/
	field xxptstkrp02_start_amt		like trgl_gl_amt
	field xxptstkrp02_start_cust_consi_qty	like ld_qty_oh		/*期初客户委托库存*/
	field xxptstkrp02_start_cust_consi_amt	like trgl_gl_amt
	/*入库及出库事务*/
	field xxptstkrp02_rctiss_qty		like ld_qty_oh   extent 60
	field xxptstkrp02_rctiss_amt		like trgl_gl_amt extent 60
	/*期末库存*/
	field xxptstkrp02_end_qty_oh		like ld_qty_oh		/*包含委托库存的库存量*/
	field xxptstkrp02_end_amt		like trgl_gl_amt
	field xxptstkrp02_end_cust_consi_qty	like ld_qty_oh		/*期初客户委托库存*/
	field xxptstkrp02_end_cust_consi_amt	like trgl_gl_amt
	index index1  	xxptstkrp02_part.		/* Add By:  SS - 20070118.1 */


define temp-table xxqmrp095
    field xxqmrp095_site			like pt_site     
	field xxqmrp095_part			like pt_part
    field xxqmrp095_line			like pt_prod_line
	field xxqmrp095_sct			    as   decimal
	/*期初*/
	field xxqmrp095_start_qty_oh		like ld_qty_oh	 extent 5	/*包含委托库存的库存量*/
	field xxqmrp095_start_amt		    like trgl_gl_amt extent 5
	/*入库及出库事务*/
	field xxqmrp095_rct_qty		like ld_qty_oh   extent 5
	field xxqmrp095_rct_amt		like trgl_gl_amt extent 5
	field xxqmrp095_iss_qty		like ld_qty_oh   extent 5
	field xxqmrp095_iss_amt		like trgl_gl_amt extent 5
	field xxqmrp095_cnt_qty		like ld_qty_oh   extent 5
	field xxqmrp095_cnt_amt		like trgl_gl_amt extent 5
	/*期末库存*/
	field xxqmrp095_end_qty_oh		like ld_qty_oh  	extent 5	/*包含委托库存的库存量*/
	field xxqmrp095_end_amt		    like trgl_gl_amt    extent 5
	index index1  	xxqmrp095_part  xxqmrp095_site.		/* Add By:  SS - 20070118.1 */


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

define var v_linename as char format "x(24)" .
define var v_sitename as char format "x(24)" .
define var v_locname as char format "x(24)" .



/*小计*/
define var xx_qty_start like ld_qty_oh extent 5.
define var xx_amt_start like trgl_gl_amt  extent 5 .
define var xx_qty_end like ld_qty_oh   extent 5.
define var xx_amt_end like trgl_gl_amt  extent 5.
define var xx_qty_rct like ld_qty_oh extent 5.
define var xx_amt_rct like trgl_gl_amt  extent 5.
define var xx_qty_iss like ld_qty_oh extent 5.
define var xx_amt_iss like trgl_gl_amt  extent 5.
define var xx_qty_cnt like ld_qty_oh extent 5.
define var xx_amt_cnt like trgl_gl_amt  extent 5.
define var xx_qty_err like ld_qty_oh extent 5.
define var xx_amt_err like trgl_gl_amt  extent 5.

/*总计*/
define var xxx_qty_start like ld_qty_oh  extent 5.
define var xxx_amt_start like trgl_gl_amt  extent 5.
define var xxx_qty_end like ld_qty_oh  extent 5.
define var xxx_amt_end like trgl_gl_amt  extent 5.
define var xxx_qty_rct like ld_qty_oh extent 5.
define var xxx_amt_rct like trgl_gl_amt  extent 5.
define var xxx_qty_iss like ld_qty_oh extent 5.
define var xxx_amt_iss like trgl_gl_amt  extent 5.
define var xxx_qty_cnt like ld_qty_oh extent 5.
define var xxx_amt_cnt like trgl_gl_amt  extent 5.
define var xxx_qty_err like ld_qty_oh extent 5.
define var xxx_amt_err like trgl_gl_amt  extent 5.




/******************** SS - 20070308.1 - E ********************/

/* THE FIELD LABEL OF THE DATE SELECTION CHANGED FROM INVOICE DATE */
/* TO EFFECTIVE.                                                   */

idate = date (month(today),1,year(today)).

FORM
   idate	label "Effective" colon 15      
   idate1	label "To"        colon 49 skip 
   
   site		colon 15               
   site1	label {t001.i} colon 49
   /*loc		colon 15               
   loc1		label {t001.i} colon 49
   locgroup	label "库位分组" colon 15*/
           

   line		colon 15                    
   line1	label {t001.i} colon 49 skip  /**/
   part		colon 15                    
   part1	label {t001.i} colon 49 skip
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
         site		
    	 site1	
    	 /*loc		
    	 loc1		
    	 locgroup	*/	              

    	 line		
    	 line1	/**/
    	 part		
    	 part1	
    	 /*vendor	
    	 vendor1*/	
      with frame a.

   {wbrp06.i &command = update &fields = " 
			 idate	
			 idate1
             site		
			 site1	   
			 
             line		
    	     line1
			 part		
			 part1	
			     
		   " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i site	}
      {mfquoter.i site1	}
      {mfquoter.i loc	}
      {mfquoter.i loc1	}
      {mfquoter.i locgroup}
      {mfquoter.i idate	}
      {mfquoter.i idate1	}
      {mfquoter.i line	}
      {mfquoter.i line1	}
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

	/*期初库存--BEGIN*/
	   FOR EACH tta6ppptrp0701:
	       DELETE tta6ppptrp0701.
	   END.
	
       /*
       PUT UNFORMATTED "a6ppptrp0701 begin: " + STRING(TIME, "HH:MM:SS") SKIP.
         */

	assign as_of_date = idate - 1 .		/*期初*/
	    {gprun.i ""a6ppptrp0701.p"" "(
		INPUT part,
		INPUT part1,
		INPUT LINE,
		INPUT line1,
		INPUT vendor,
		INPUT vendor1,
		INPUT abc,
		INPUT abc1,
		INPUT site,
		INPUT site1,
	    INPUT loc,
	    INPUT loc1,
		INPUT part_group,
		INPUT part_group1,
		INPUT part_type,
		INPUT part_type1,

		INPUT AS_of_date,
		INPUT neg_qty,
		INPUT net_qty,
		INPUT inc_zero_qty,
		INPUT zero_cost,
		INPUT customer_consign,
		INPUT supplier_consign
		)"}
		/* Remark By:  SS - 20061103.1 Begin ****
	EXPORT DELIMITER ";" "site" "loc" "part" "desc" "abc" "qty" "um" "sct" "ext" "Qty_none_consign" "Qty_supp_consign" "Qty_cust_consign".
        FOR EACH tta6ppptrp0701:
            EXPORT DELIMITER ";" tta6ppptrp0701.
        END.

        PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.
	****** Remark By:  SS - 20061103.1 End */

	FOR EACH tta6ppptrp0701:
		
		/*判断是否在库位分组里--BEGIN*/
			run pro_locgroup(input tta6ppptrp0701_loc,locgroup,output v_yn).                        
			if v_yn = no then next .
		/*判断是否在库位分组里--END*/

        find first pt_mstr 
            where pt_domain = global_domain 
            and pt_part = tta6ppptrp0701_part
            and (pt_prod_line >= line and pt_prod_line <= line1 )
        no-lock no-error .
        if not avail pt_mstr then next .

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
                   xxptstkrp02_line			= pt_prod_line
                   xxptstkrp02_site         = tta6ppptrp0701_site 
                   xxptstkrp02_loc          = tta6ppptrp0701_loc 
			       xxptstkrp02_sct			= tta6ppptrp0701_sct
			       xxptstkrp02_start_qty_oh		= tta6ppptrp0701_qty_non_consign + tta6ppptrp0701_qty_cust_consign + tta6ppptrp0701_qty_supp_consign
			       xxptstkrp02_start_amt		= (tta6ppptrp0701_qty_non_consign + tta6ppptrp0701_qty_cust_consign + tta6ppptrp0701_qty_supp_consign) * tta6ppptrp0701_sct 
			       xxptstkrp02_start_cust_consi_qty = tta6ppptrp0701_qty_cust_consign
			       xxptstkrp02_start_cust_consi_amt = tta6ppptrp0701_qty_cust_consign * tta6ppptrp0701_sct .
		end.
	END.
	/*期初库存--END*/	
	
	/*期末库存--BEGIN*/
	   FOR EACH tta6ppptrp0701:
	       DELETE tta6ppptrp0701.
	   END.
	
	assign as_of_date = idate1 .		
	    {gprun.i ""a6ppptrp0701.p"" "(
		INPUT part,
		INPUT part1,
		INPUT LINE,
		INPUT line1,
		INPUT vendor,
		INPUT vendor1,
		INPUT abc,
		INPUT abc1,
		INPUT site,
		INPUT site1,
	    INPUT loc,
	    INPUT loc1,
		INPUT part_group,
		INPUT part_group1,
		INPUT part_type,
		INPUT part_type1,

		INPUT AS_of_date,
		INPUT neg_qty,
		INPUT net_qty,
		INPUT inc_zero_qty,
		INPUT zero_cost,
		INPUT customer_consign,
		INPUT supplier_consign
		)"}
	/* Remark By:  SS - 20061103.1 Begin *****
	EXPORT DELIMITER ";" "site" "loc" "part" "desc" "abc" "qty" "um" "sct" "ext" "Qty_none_consign" "Qty_supp_consign" "Qty_cust_consign".
        FOR EACH tta6ppptrp0701:
            EXPORT DELIMITER ";" tta6ppptrp0701.
        END.

        PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.
	***** Remark By:  SS - 20061103.1 End */
	
	FOR EACH tta6ppptrp0701:
		/*判断是否在库位分组里--BEGIN*/
        run pro_locgroup(input tta6ppptrp0701_loc,locgroup,output v_yn).
        if v_yn = no then next .
		/*判断是否在库位分组里--END*/


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
	END.
	/*期末库存--END*/

    /*
    PUT UNFORMATTED "a6ppptrp0701 end: " + STRING(TIME, "HH:MM:SS") SKIP.
      */

	for each tta6ictrrp0303:
        delete tta6ictrrp0303.
    end.

    /*
    put unformatted "tr_hist begin: " + string(time, "hh:mm:ss") skip.
      */
	assign efdate = idate
	       efdate1 = idate1 .   
    for each tr_hist field( tr_rmks tr_nbr tr_line tr_site tr_prod_line tr_part tr_trnbr tr_addr tr_lot tr_effdate
                            tr_date tr_type tr_loc tr_program tr_qty_loc )
          where tr_hist.tr_domain = global_domain
          and tr_part >= part and tr_part <= part1
          and tr_ship_type = ""
          and tr_loc >= loc and tr_loc <= loc1
          and tr_site >= site and tr_site <= site1
          and tr_prod_line >= line
          and tr_prod_line <= line1
          and ( (tr_effdate >= efdate and tr_effdate <= efdate1 
                 or tr_effdate = ?)
          and (tr_type = trtype or trtype = "")
          and (tr_date >= trdate and tr_date <= trdate1
                 or tr_date = ?) ) no-lock ,
          each trgl_det field( trgl_dr_acct trgl_gl_amt)  where trgl_det.trgl_domain = global_domain 
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
              )  )no-lock  break by tr_type by tr_part by tr_site by tr_loc:
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
           if first-of(tr_loc) then do:
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

    /*
    PUT UNFORMATTED "tr_hist end: " + STRING(TIME, "HH:MM:SS") SKIP.
      */

	/* Remark By:  SS - 20061103.1 Begin **** */
            /*
	    EXPORT DELIMITER ";" "inv_nbr" "nbr" "line" "site" "pl" "part" "wo_part" "trnbr" "traddr" "lot" "effdate" "date" "type" "loc" "acct" "sub" "cc" "proj" "qty_dr" "amt_dr" "qty_cr" "amt_cr".
        FOR EACH tta6ictrrp0303:
            EXPORT DELIMITER ";" tta6ictrrp0303.
        END.
             
        PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.
	          */
	/***** Remark By:  SS - 20061103.1 End */

    /*
    PUT UNFORMATTED "tt3 begin: " + STRING(TIME, "HH:MM:SS") SKIP.
      */
    /*
    ii = 1 .
    FOR EACH tt3 WHERE (tt3_type = "CYC-RCNT" OR tt3_type = "TAG-CNT") BREAK BY tt3_type :
        if first-of(tt3_type) then do:
			create  tt .
			assign	tt_integer = ii 
				tt_trtype  = tt3_type
                tt_class = "TYPE" .
			ii = ii + 1 .
		end.
    END.
	for each tt3 where tt3_type >= "RCT" and tt3_type <= "RCTZ" 
                   AND tt3_type <> "RCT-TR" 
                   break by tt3_type:
		if first-of(tt3_type) then do:
			create  tt .
			assign	tt_integer = ii 
				tt_trtype  = tt3_type
                tt_class = "TYPE" .
			ii = ii + 1 .
		end.
	end.
	for each tt3 where tt3_type = "RCT-TR"  break by tt3_type :
		if first-of(tt3_type) then do:
			create  tt .
			assign	tt_integer = ii 
				    tt_trtype  = "RCT-TR "  
                    tt_class = "TYPE" .
			ii = ii + 1 .
		end.
	end.   

	for each tt3 where tt3_type >= "ISS" and tt3_type <= "ISSZ" 
                   AND tt3_type <> "ISS-TR" 
                   break by tt3_type:
		if first-of(tt3_type) then do:
			create tt .
			ASSIGN 
                tt_integer = ii 
				tt_trtype  = tt3_type
                tt_class = "TYPE" .
			ii = ii + 1 .
		end.
	end.
	for each tt3 WHERE tt3_type = "ISS-TR"  break by tt3_type :
		if first-of(tt3_type) then do:
			create  tt .
			assign	tt_integer = ii 
			        tt_trtype  = "ISS-TR " 
                    tt_class = "TYPE"  .
			ii = ii + 1 .
		end.
	end.

	maxii = ii - 1 .

    
    PUT UNFORMATTED "tt3 end: " + STRING(TIME, "HH:MM:SS") SKIP.
      */

create  tt .
assign	
    tt_integer = 1 
    tt_trtype  = "RCT-total"
    tt_trtype_name = "入库总计"
    tt_class = "TYPE" .
create  tt .
assign	
    tt_integer = 2 
    tt_trtype  = "ISS-total"
    tt_trtype_name = "出库总计"
    tt_class = "TYPE" .
create  tt .
assign	
    tt_integer = 3 
    tt_trtype  = "CYC-TAG"  /*"CYC-RCNT" OR "TAG-CNT"*/
    tt_trtype_name = "盘点更新"
    tt_class = "TYPE" .




    /*
    PUT UNFORMATTED "xxptrstkrp02 begin: " + STRING(TIME, "HH:MM:SS") SKIP.
      */

    FOR EACH tttr :
        DELETE tttr .
    END.
    FOR EACH xxptstkrp02 
                    where (xxptstkrp02_loc <> "130" 
                    and xxptstkrp02_loc <> "131" 
                    and xxptstkrp02_loc <> "132"  
                    and xxptstkrp02_loc <> "133" 
                    and xxptstkrp02_loc <> "134" 
                    and xxptstkrp02_loc <> "137" ) :
        /*库位: 人為不良134		來料不良130、131		设计不良132、133		成品不良137*/
        delete  xxptstkrp02 .
    end.
    FOR EACH tta6ictrrp0303 
                    where (tta6ictrrp0303_loc <> "130" 
                    and tta6ictrrp0303_loc <> "131" 
                    and tta6ictrrp0303_loc <> "132"  
                    and tta6ictrrp0303_loc <> "133" 
                    and tta6ictrrp0303_loc <> "134" 
                    and tta6ictrrp0303_loc <> "137" ) :
        /*库位: 人為不良134		來料不良130、131		设计不良132、133		成品不良137*/
        delete  tta6ictrrp0303 .
    end.

	FOR EACH xxptstkrp02 break  by xxptstkrp02_part by xxptstkrp02_site by xxptstkrp02_loc :
        if first-of(xxptstkrp02_site) then do:
            find first xxqmrp095 where xxqmrp095_part = xxptstkrp02_part and xxqmrp095_site = xxptstkrp02_site  no-error .
            if not avail xxqmrp095 then do:
                create xxqmrp095.
                assign 
                    xxqmrp095_part = xxptstkrp02_part 
                    xxqmrp095_site = xxptstkrp02_site 
                    xxqmrp095_line = xxptstkrp02_line 
                    xxqmrp095_sct  = xxptstkrp02_sct 
                    .
            end.

        end. /*if first-of(xxptstkrp02_site)*/

        /* cyc-rcnt tag-cnt  B*/
        FOR EACH tta6ictrrp0303 FIELD(tta6ictrrp0303_part tta6ictrrp0303_type tta6ictrrp0303_loc
                                 tta6ictrrp0303_trnbr tta6ictrrp0303_qty_dr tta6ictrrp0303_amt_dr)
            WHERE tta6ictrrp0303_part = xxptstkrp02_part 
            and tta6ictrrp0303_site = xxptstkrp02_site 
            and tta6ictrrp0303_loc = xxptstkrp02_loc 
            AND (tta6ictrrp0303_type = 'CYC-RCNT' OR tta6ictrrp0303_type = 'TAG-CNT') 
            BREAK by tta6ictrrp0303_type by tta6ictrrp0303_trnbr :
                /*判断是否在库位分组里--BEGIN*/
                run pro_locgroup(input tta6ictrrp0303_loc,locgroup,output v_yn).
                if v_yn = no then next .            
                if not (tta6ictrrp0303_loc >= loc and tta6ictrrp0303_loc <= loc1) then next .
                /*判断是否在库位分组里--END*/

                find first tt where tt_trtype = "CYC-TAG"  no-error.
                if not avail tt then next .
                else do:         
                    if first-of(tta6ictrrp0303_trnbr) then
                        assign xxptstkrp02_rctiss_qty[tt_integer] = xxptstkrp02_rctiss_qty[tt_integer] + tta6ictrrp0303_qty_dr .
                        assign xxptstkrp02_rctiss_amt[tt_integer] = xxptstkrp02_rctiss_amt[tt_integer] + tta6ictrrp0303_amt_dr .
                end.
                DELETE tta6ictrrp0303 .
        END.
        /* cyc-rcnt tag-cnt  E*/

		/*本月入库事务--BEGIN*/
		for each tta6ictrrp0303 FIELD(tta6ictrrp0303_part tta6ictrrp0303_type tta6ictrrp0303_loc tta6ictrrp0303_nbr
                                      tta6ictrrp0303_trnbr tta6ictrrp0303_qty_dr tta6ictrrp0303_amt_dr tta6ictrrp0303_program ) 
                                where tta6ictrrp0303_part = xxptstkrp02_part
                                and tta6ictrrp0303_site = xxptstkrp02_site 
                                and tta6ictrrp0303_loc = xxptstkrp02_loc 
				                  and ((tta6ictrrp0303_type >= "RCT" and tta6ictrrp0303_type <= "RCTZ") /* OR tta6ictrrp0303_type = "ISS-PRV" */ )
			                      break BY tta6ictrrp0303_type by tta6ictrrp0303_trnbr :
			/*判断是否在库位分组里--BEGIN*/
				run pro_locgroup(input tta6ictrrp0303_loc,locgroup,output v_yn).
				if v_yn = no then next .            
				if not (tta6ictrrp0303_loc >= loc and tta6ictrrp0303_loc <= loc1) then next .
			/*判断是否在库位分组里--END*/

                find first tt where tt_trtype = "RCT-total" no-error.
                if avail tt then do:
                    if first-of(tta6ictrrp0303_trnbr) then
                        assign xxptstkrp02_rctiss_qty[tt_integer] = xxptstkrp02_rctiss_qty[tt_integer] + tta6ictrrp0303_qty_dr .
                        assign xxptstkrp02_rctiss_amt[tt_integer] = xxptstkrp02_rctiss_amt[tt_integer] + tta6ictrrp0303_amt_dr .
                end.

                
                DELETE tta6ictrrp0303 .
		end.		
		/*本月入库事务--END*/

		/*本月出库事务--BEGIN*/
		for each tta6ictrrp0303 FIELD(tta6ictrrp0303_part tta6ictrrp0303_type tta6ictrrp0303_loc tta6ictrrp0303_nbr
                                      tta6ictrrp0303_trnbr tta6ictrrp0303_qty_dr tta6ictrrp0303_amt_dr tta6ictrrp0303_program )
                                where tta6ictrrp0303_part = xxptstkrp02_part
                                and tta6ictrrp0303_site = xxptstkrp02_site 
                                and tta6ictrrp0303_loc = xxptstkrp02_loc 
				                  and tta6ictrrp0303_type >= "ISS" and tta6ictrrp0303_type <= "ISSZ"
			                      BREAK by tta6ictrrp0303_type by tta6ictrrp0303_trnbr :
			/*判断是否在库位分组里--BEGIN*/         
				run pro_locgroup(input tta6ictrrp0303_loc,locgroup,output v_yn).
				if v_yn = no then next .               
				if not (tta6ictrrp0303_loc >= loc and tta6ictrrp0303_loc <= loc1) then next .            
			/*判断是否在库位分组里--END*/

                find first tt where tt_trtype = "ISS-total" no-error.
                if avail tt then do:
                    if first-of(tta6ictrrp0303_trnbr) then
                        assign xxptstkrp02_rctiss_qty[tt_integer] = xxptstkrp02_rctiss_qty[tt_integer] + tta6ictrrp0303_qty_dr .
                        assign xxptstkrp02_rctiss_amt[tt_integer] = xxptstkrp02_rctiss_amt[tt_integer] + tta6ictrrp0303_amt_dr .
                end.


                DELETE tta6ictrrp0303 .
		end.		
		/*本月出库事务--END*/           

        find first xxqmrp095 where xxqmrp095_part = xxptstkrp02_part and xxqmrp095_site = xxptstkrp02_site  no-error .
        if not avail xxqmrp095 then next .

        ii = 0 .
        if xxptstkrp02_loc = "134" then ii = 1.
        if xxptstkrp02_loc = "130" then ii = 2 .
        if xxptstkrp02_loc = "131" then ii = 2 .
        if xxptstkrp02_loc = "132" then ii = 3 .
        if xxptstkrp02_loc = "133" then ii = 3 .
        if xxptstkrp02_loc = "137" then ii = 4 .
            assign xxqmrp095_start_qty_oh[ii] =  xxqmrp095_start_qty_oh[ii] + xxptstkrp02_start_qty_oh
                   xxqmrp095_start_amt[ii] =  xxqmrp095_start_amt[ii] + xxptstkrp02_start_amt
                   xxqmrp095_end_qty_oh[ii] =  xxqmrp095_end_qty_oh[ii] + xxptstkrp02_end_qty_oh
                   xxqmrp095_end_amt[ii] =  xxqmrp095_end_amt[ii] + xxptstkrp02_end_amt

                   xxqmrp095_rct_qty[ii] =  xxqmrp095_rct_qty[ii] + xxptstkrp02_rctiss_qty[1]
                   xxqmrp095_rct_amt[ii] =  xxqmrp095_rct_amt[ii] + xxptstkrp02_rctiss_amt[1] 
                   xxqmrp095_iss_qty[ii] =  xxqmrp095_iss_qty[ii] + xxptstkrp02_rctiss_qty[2]
                   xxqmrp095_iss_amt[ii] =  xxqmrp095_iss_amt[ii] + xxptstkrp02_rctiss_amt[2]
                   xxqmrp095_cnt_qty[ii] =  xxqmrp095_cnt_qty[ii] + xxptstkrp02_rctiss_qty[3]
                   xxqmrp095_cnt_amt[ii] =  xxqmrp095_cnt_amt[ii] + xxptstkrp02_rctiss_amt[3].
        ii = 5 . /*total*/
            assign xxqmrp095_start_qty_oh[ii] =  xxqmrp095_start_qty_oh[ii] + xxptstkrp02_start_qty_oh
                   xxqmrp095_start_amt[ii] =  xxqmrp095_start_amt[ii] + xxptstkrp02_start_amt
                   xxqmrp095_end_qty_oh[ii] =  xxqmrp095_end_qty_oh[ii] + xxptstkrp02_end_qty_oh
                   xxqmrp095_end_amt[ii] =  xxqmrp095_end_amt[ii] + xxptstkrp02_end_amt

                   xxqmrp095_rct_qty[ii] =  xxqmrp095_rct_qty[ii] + xxptstkrp02_rctiss_qty[1]
                   xxqmrp095_rct_amt[ii] =  xxqmrp095_rct_amt[ii] + xxptstkrp02_rctiss_amt[1] 
                   xxqmrp095_iss_qty[ii] =  xxqmrp095_iss_qty[ii] + xxptstkrp02_rctiss_qty[2]
                   xxqmrp095_iss_amt[ii] =  xxqmrp095_iss_amt[ii] + xxptstkrp02_rctiss_amt[2]
                   xxqmrp095_cnt_qty[ii] =  xxqmrp095_cnt_qty[ii] + xxptstkrp02_rctiss_qty[3]
                   xxqmrp095_cnt_amt[ii] =  xxqmrp095_cnt_amt[ii] + xxptstkrp02_rctiss_amt[3].
                   
	END.  /*End for each xxptstkrp02*/
    /*
    PUT UNFORMATTED "xxptrstkrp02 end: " + STRING(TIME, "HH:MM:SS") SKIP.
      */                      



	PUT UNFORMATTED "#def REPORTPATH=$/Citizen/xxqmrp095" SKIP.
	PUT UNFORMATTED "#def :end" SKIP.   


    do ii = 1 to 5 :
        xx_qty_start[ii] = 0 .
        xx_amt_start[ii] = 0 .
        xx_qty_end[ii] = 0 . 
        xx_amt_end[ii] = 0 . 
        xx_qty_rct[ii] = 0 . 
        xx_amt_rct[ii] = 0 . 
        xx_qty_iss[ii] = 0 . 
        xx_amt_iss[ii] = 0 .
        xx_qty_cnt[ii] = 0 .
        xx_amt_cnt[ii] = 0 .
        xx_qty_err[ii] = 0 .
        xx_amt_err[ii] = 0 .
    end.

	FOR EACH xxqmrp095 ,
        EACH pt_mstr WHERE pt_domain = GLOBAL_domain AND pt_part = xxqmrp095_part NO-LOCK 
        break by xxqmrp095_line by xxqmrp095_part by xxqmrp095_site  
        :   
        
        if first-of(xxqmrp095_line) then do:
            do ii = 1 to 5 :
                xx_qty_start[ii] = 0 .
                xx_amt_start[ii] = 0 .
                xx_qty_end[ii] = 0 . 
                xx_amt_end[ii] = 0 . 
                xx_qty_rct[ii] = 0 . 
                xx_amt_rct[ii] = 0 . 
                xx_qty_iss[ii] = 0 . 
                xx_amt_iss[ii] = 0 .
                xx_qty_cnt[ii] = 0 .
                xx_amt_cnt[ii] = 0 .
                xx_qty_err[ii] = 0 .
                xx_amt_err[ii] = 0 .
            end.
        end. /*if first-of(xxqmrp095_line) */


        find first pl_mstr 
            where pl_domain = global_domain 
            and pl_prod_line = pt_prod_line 
        no-lock no-error .
        v_linename  = if avail pl_mstr then pl_desc else "" .  

        find first si_mstr 
            where si_domain = global_domain 
            and   si_site = xxptstkrp02_site
        no-lock no-error.
        v_sitename = if avail si_mstr then si_desc else "".

            if idate = ? then put  UNFORMATTED  ";". 
            else             put UNFORMATTED  year(idate) "/" month(idate) "/" day(idate) ";". 
            if idate1 = ? then put  UNFORMATTED  ";". 
            else             put UNFORMATTED  year(idate1) "/" month(idate1) "/" day(idate1) ";" . 

        PUT UNFORMATTED xxqmrp095_line			  ";" .
        PUT UNFORMATTED v_linename       			  ";" .
        PUT UNFORMATTED xxqmrp095_part			  ";" .
        PUT UNFORMATTED pt_desc1			  ";" .
        PUT UNFORMATTED pt_desc2			  ";" .
        PUT UNFORMATTED pt_um			  ";" .
        PUT UNFORMATTED xxqmrp095_site			  ";" .
        PUT UNFORMATTED v_sitename			  ";" .
        PUT UNFORMATTED xxqmrp095_sct			  ";" .
        do ii = 1 to 5 :
            PUT UNFORMATTED xxqmrp095_start_qty_oh[ii]		  ";" .
            PUT UNFORMATTED xxqmrp095_start_amt[ii]		  ";" .
        end.
        do ii = 1 to 5 :
            PUT UNFORMATTED xxqmrp095_rct_qty[ii]		  ";" .
            PUT UNFORMATTED xxqmrp095_rct_amt[ii]		  ";" .
        end.
        do ii = 1 to 5 :
            PUT UNFORMATTED xxqmrp095_iss_qty[ii]		  ";" .
            PUT UNFORMATTED xxqmrp095_iss_amt[ii]		  ";" .
        end.
        do ii = 1 to 5 :
            PUT UNFORMATTED xxqmrp095_cnt_qty[ii]		  ";" .
            PUT UNFORMATTED xxqmrp095_cnt_amt[ii]		  ";" .
        end.
        do ii = 1 to 5 :
            PUT UNFORMATTED xxqmrp095_rct_qty[ii] - xxqmrp095_iss_qty[ii]		  ";" .
            PUT UNFORMATTED xxqmrp095_rct_amt[ii] - xxqmrp095_iss_amt[ii]		  ";" .
        end.
        /*do ii = 1 to 5 :
            PUT UNFORMATTED xxqmrp095_end_qty_oh[ii]		  ";" .
            PUT UNFORMATTED xxqmrp095_end_amt[ii]		  ";".
        end.  多出一个分号*/
        do ii = 1 to 4 :
            PUT UNFORMATTED xxqmrp095_end_qty_oh[ii]		  ";" .
            PUT UNFORMATTED xxqmrp095_end_amt[ii]		  ";".
        end.
            PUT UNFORMATTED xxqmrp095_end_qty_oh[5]		  ";" .
            PUT UNFORMATTED xxqmrp095_end_amt[5]		  .
        put skip .

        do ii = 1 to 5 :
            xx_qty_start[ii] = xx_qty_start[ii] + xxqmrp095_start_qty_oh[ii].
            xx_amt_start[ii] = xx_amt_start[ii] + xxqmrp095_start_amt[ii]	.
            xx_qty_end[ii] = xx_qty_end[ii] + xxqmrp095_end_qty_oh[ii]	 . 
            xx_amt_end[ii] = xx_amt_end[ii] + xxqmrp095_end_amt[ii]. 
            xx_qty_rct[ii] = xx_qty_rct[ii] + xxqmrp095_rct_qty[ii]. 
            xx_amt_rct[ii] = xx_amt_rct[ii] + xxqmrp095_rct_amt[ii]. 
            xx_qty_iss[ii] = xx_qty_iss[ii] + xxqmrp095_iss_qty[ii]. 
            xx_amt_iss[ii] = xx_amt_iss[ii] + xxqmrp095_iss_amt[ii] .
            xx_qty_cnt[ii] = xx_qty_cnt[ii] + xxqmrp095_cnt_qty[ii].
            xx_amt_cnt[ii] = xx_amt_cnt[ii] + xxqmrp095_cnt_amt[ii] .
            xx_qty_err[ii] = xx_qty_err[ii] + xxqmrp095_rct_qty[ii] + xxqmrp095_iss_qty[ii]  + xxqmrp095_cnt_qty[ii].
            xx_amt_err[ii] = xx_amt_err[ii] + xxqmrp095_rct_amt[ii] + xxqmrp095_iss_amt[ii]  + xxqmrp095_cnt_amt[ii] .
        end.

        do ii = 1 to 5 :
            xxx_qty_start[ii] = xxx_qty_start[ii] + xxqmrp095_start_qty_oh[ii].
            xxx_amt_start[ii] = xxx_amt_start[ii] + xxqmrp095_start_amt[ii]	.
            xxx_qty_end[ii] = xxx_qty_end[ii] + xxqmrp095_end_qty_oh[ii]	 . 
            xxx_amt_end[ii] = xxx_amt_end[ii] + xxqmrp095_end_amt[ii]. 
            xxx_qty_rct[ii] = xxx_qty_rct[ii] + xxqmrp095_rct_qty[ii]. 
            xxx_amt_rct[ii] = xxx_amt_rct[ii] + xxqmrp095_rct_amt[ii]. 
            xxx_qty_iss[ii] = xxx_qty_iss[ii] + xxqmrp095_iss_qty[ii]. 
            xxx_amt_iss[ii] = xxx_amt_iss[ii] + xxqmrp095_iss_amt[ii] .
            xxx_qty_cnt[ii] = xxx_qty_cnt[ii] + xxqmrp095_cnt_qty[ii].
            xxx_amt_cnt[ii] = xxx_amt_cnt[ii] + xxqmrp095_cnt_amt[ii] .
            xxx_qty_err[ii] = xxx_qty_err[ii] + xxqmrp095_rct_qty[ii] + xxqmrp095_iss_qty[ii]  + xxqmrp095_cnt_qty[ii].
            xxx_amt_err[ii] = xxx_amt_err[ii] + xxqmrp095_rct_amt[ii] + xxqmrp095_iss_amt[ii]  + xxqmrp095_cnt_amt[ii]  .
        end.
      
        if last-of(xxqmrp095_line) then do:
            if idate = ? then put  UNFORMATTED  ";". 
            else             put UNFORMATTED  year(idate) "/" month(idate) "/" day(idate) ";". 
            if idate1 = ? then put  UNFORMATTED  ";". 
            else             put UNFORMATTED  year(idate1) "/" month(idate1) "/" day(idate1) ";" . 

            PUT UNFORMATTED xxqmrp095_line			  ";" .
            PUT UNFORMATTED "小计;" .
            PUT UNFORMATTED ";" .
            PUT UNFORMATTED ";" .
            PUT UNFORMATTED ";" .
            PUT UNFORMATTED ";" .
            PUT UNFORMATTED ";" .
            PUT UNFORMATTED ";" .
            PUT UNFORMATTED ";" .
            do ii = 1 to 5 :
                PUT UNFORMATTED xx_qty_start[ii]		  ";" .
                PUT UNFORMATTED xx_amt_start[ii]		  ";" .
            end.
            do ii = 1 to 5 :
                PUT UNFORMATTED xx_qty_rct[ii]		  ";" .
                PUT UNFORMATTED xx_amt_rct[ii]		  ";" .
            end.
            do ii = 1 to 5 :
                PUT UNFORMATTED xx_qty_iss[ii]		  ";" .
                PUT UNFORMATTED xx_amt_iss[ii]		  ";" .
            end.
            do ii = 1 to 5 :
                PUT UNFORMATTED xx_qty_cnt[ii]		  ";" .
                PUT UNFORMATTED xx_amt_cnt[ii]		  ";" .
            end.
            do ii = 1 to 5 :
                PUT UNFORMATTED xx_qty_err[ii]			  ";" .
                PUT UNFORMATTED xx_amt_err[ii]			  ";" .
            end.
            do ii = 1 to 4 :
                PUT UNFORMATTED xx_qty_end[ii]		  ";" .
                PUT UNFORMATTED xx_amt_end[ii]		  ";".
            end.
                PUT UNFORMATTED xx_qty_end[5]		  ";" .
                PUT UNFORMATTED xx_amt_end[5]		  .
            put skip .
        end. /*if last-of(xxqmrp095_line) */        

	    delete xxqmrp095 .
    END.
	
    if idate = ? then put  UNFORMATTED  ";". 
    else             put UNFORMATTED  year(idate) "/" month(idate) "/" day(idate) ";". 
    if idate1 = ? then put  UNFORMATTED  ";". 
    else             put UNFORMATTED  year(idate1) "/" month(idate1) "/" day(idate1) ";" . 

    PUT UNFORMATTED "总计;" .
    PUT UNFORMATTED ";" .
    PUT UNFORMATTED ";" .
    PUT UNFORMATTED ";" .
    PUT UNFORMATTED ";" .
    PUT UNFORMATTED ";" .
    PUT UNFORMATTED ";" .
    PUT UNFORMATTED ";" .
    PUT UNFORMATTED ";" .
    do ii = 1 to 5 :
        PUT UNFORMATTED xxx_qty_start[ii]		  ";" .
        PUT UNFORMATTED xxx_amt_start[ii]		  ";" .
    end.
    do ii = 1 to 5 :
        PUT UNFORMATTED xxx_qty_rct[ii]		  ";" .
        PUT UNFORMATTED xxx_amt_rct[ii]		  ";" .
    end.
    do ii = 1 to 5 :
        PUT UNFORMATTED xxx_qty_iss[ii]		  ";" .
        PUT UNFORMATTED xxx_amt_iss[ii]		  ";" .
    end.
    do ii = 1 to 5 :
        PUT UNFORMATTED xxx_qty_cnt[ii]		  ";" .
        PUT UNFORMATTED xxx_amt_cnt[ii]		  ";" .
    end.
    do ii = 1 to 5 :
        PUT UNFORMATTED xxx_qty_err[ii]			  ";" .
        PUT UNFORMATTED xxx_amt_err[ii]			  ";" .
    end.
    do ii = 1 to 4 :
        PUT UNFORMATTED xxx_qty_end[ii]		  ";" .
        PUT UNFORMATTED xxx_amt_end[ii]		  ";".
    end.
        PUT UNFORMATTED xxx_qty_end[5]		  ";" .
        PUT UNFORMATTED xxx_amt_end[5]		  .
    put skip .

    for each tt:
        delete tt.
    end.

    {a6mfrtrail.i}

end.

{wbrp04.i &frame-spec = a}








/*********************************************************************/



procedure pro_locgroup:
    define input parameter pro_loc as char .
    define input parameter pro_locgroup as char .
    define output parameter pro_yesno as logi .
    
    define variable prov_1 as char extent 20 .
    define variable prov_2 as char extent 20 .
    define variable jj as inte  .
    define variable kk as inte .
    define variable yn as logi .
    define variable iiii as inte .
    define variable loc33 as char extent 10 .

	pro_yesno = no .

	find code_mstr  where code_mstr.code_domain = global_domain and
			code_fldname = "locgroup"
                    and code_value = pro_locgroup no-lock no-error.
	if avail code_mstr then do:
		DO iiii = 1 to 10 :
			assign loc33[iiii] = substring(code_cmmt, (iiii - 1) * 60 + 1 ,60) .
		END.

		DO iiii = 1 to 10 :
			assign pro_locgroup = loc33[iiii]  .
			
			if pro_locgroup <> "" and pro_yesno = no then do:
				jj = 1 .
				yn = no .		
				DO kk = 1 to 20 :
					assign  prov_1[kk] = "" 
						prov_2[kk] = "" .
				END.  /* END DO */
				DO kk = 1 to length(pro_locgroup) :
					if substr(pro_locgroup,kk,1) <> "" then do:
						if substr(pro_locgroup,kk,1) = "-" then do:
							assign yn = yes 
								prov_2[jj] = "" .
						end.
						else if substr(pro_locgroup,kk,1) = "," then do:
							assign yn = no .
							if kk <> length(pro_locgroup) then assign jj = jj + 1 .
						end.
						else do:
							if yn = no then 
								assign prov_1[jj] = prov_1[jj] + substr(pro_locgroup,kk,1)
								       prov_2[jj] = prov_2[jj] + substr(pro_locgroup,kk,1) .
							else assign    prov_2[jj] = prov_2[jj] + substr(pro_locgroup,kk,1) .
						end.
					end.
				END.  /* END DO */
				do kk = 1 to jj + 1:
				/*disp prov_1[kk]
				     prov_2[kk] .*/
					
					if pro_loc >= prov_1[kk] and pro_loc <= prov_2[kk] then assign pro_yesno = yes .
					
				end.
			end.                  
		END.      
	end.	/*如果分组有效*/
	else assign pro_yesno = yes .   
end.
