/* xxptstkrp03.p - INVOICE/PURCHASE COST VARIANCE REPORT                         */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.9.1.7 $                                                           */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 4.0        LAST EDIT: 01/14/87    MODIFIED BY: FLM               */
/* REVISION: 6.0    LAST MODIFIED: 06/28/91    BY: MLV *D733*                 */
/* REVISION: 7.0    LAST MODIFIED: 07/30/91    BY: MLV *F001*                 */
/* REVISION: 7.0    LAST MODIFIED: 08/14/92    BY: MLV *F847*                 */
/* REVISION: 7.3    LAST MODIFIED: 05/17/93    BY: JJS *GB03* (rev only)      */
/*                                 06/21/93    by: jms *GC52* (rev only)      */
/*                                 04/10/96    by: jzw *G1LD*                 */
/* REVISION: 8.6    LAST MODIFIED: 10/11/97    BY: ckm *K0SY*                 */
/* REVISION: 8.6    LAST MODIFIED: 10/20/97    BY: *H1FW* Samir Bavkar        */
/* REVISION: 8.6E   LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane           */
/* REVISION: 8.6E   LAST MODIFIED: 04/10/98    BY: *L00K* RVSL                */
/* REVISION: 8.6E   LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan          */
/* REVISION: 9.0    LAST MODIFIED: 03/10/99    BY: *M0B3* Michael Amaladhas   */
/* REVISION: 9.0    LAST MODIFIED: 03/13/99    BY: *M0BD* Alfred Tan          */
/* REVISION: 9.1    LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane    */
/* REVISION: 9.1    LAST MODIFIED: 08/11/00    BY: *N0KK* jyn                 */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.9.1.6    BY: Katie Hilbert     DATE: 03/12/03  ECO: *P0NL*    */
/* $Revision: 1.9.1.7 $    BY: Subramanian Iyer  DATE: 11/24/03  ECO: *P13Q*    */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* $Revision: eb21sp4   BY: Davild Xu   DATE: 20061103  ECO: SS - 20061103.1 */
/* $Revision: eb21sp4   BY: Davild Xu   DATE: 20070118  ECO: SS - 20070118.1 */

{mfdtitle.i "090806.1"}
/* Add By:  SS - 20061103.1 Begin */
	/*
	--------------------------------------------------------------------------------------
	*/

	/*define temp table*/
	{a6ppptrp0701.i "new"}

define temp-table xxptstkrp02
	field xxptstkrp02_part			like pt_part
	field xxptstkrp02_sct			as   decimal
	field xxptstkrp02_qty_oh		like ld_qty_oh
    FIELD xxptstkrp02_site          LIKE IN_site
	index index1 xxptstkrp02_part.	

DEFINE TEMP-TABLE tt 
    FIELD tt_year LIKE glc_year
    FIELD tt_per  LIKE glc_per
    FIELD tt_part LIKE pt_part
    INDEX index1 tt_year tt_per tt_part
    .

DEFINE TEMP-TABLE ttc 
    FIELD ttc_acc LIKE xxvh_acc 
    INDEX index1 ttc_acc
    .

DEFINE TEMP-TABLE ttv 
    FIELD ttv_acc LIKE xxvh_acc
    FIELD ttv_amt AS DECIMAL
    INDEX index1 ttv_acc 
    .

DEF VAR v_qty_oh        AS DECIMAL.
DEF VAR v_total_sjcb    AS DECIMAL.
DEF VAR v_total_dwsjcb  AS DECIMAL.
DEF VAR v_end_stk_var_amt AS DECIMAL.
DEF VAR v_cl_end_stk_var_amt AS DECIMAL.
DEF VAR v_rg_end_stk_var_amt AS DECIMAL.
DEF VAR v_fj_end_stk_var_amt AS DECIMAL.
DEF VAR v_jj_end_stk_var_amt AS DECIMAL.
DEF VAR v_zb_end_stk_var_amt AS DECIMAL.
DEF VAR v_total_bzcb    AS DECIMAL.
DEF VAR v_total_dwbzcb  AS DECIMAL.
DEF VAR v_total_cyhj    AS DECIMAL.
DEF VAR v_cl            AS DECIMAL.
DEF VAR v_rg            AS DECIMAL.
DEF VAR v_fj            AS DECIMAL.
DEF VAR v_jj            AS DECIMAL.
DEF VAR v_zb            AS DECIMAL.
DEF VAR v_lab_var_amt   AS DECIMAL.
DEF VAR v_bur_var_amt   AS DECIMAL.
DEF VAR v_ovh_var_amt   AS DECIMAL.
DEF VAR v_mtl_std       LIKE tr_mtl_std .
DEF VAR v_lbr_std       LIKE tr_lbr_std .
DEF VAR v_bdn_std       LIKE tr_bdn_std .
DEF VAR v_ovh_std       LIKE tr_ovh_std .
DEF VAR v_sub_std       LIKE tr_sub_std .
define variable std_as_of     like glxcst       no-undo.

/* Add By:  SS - 20061103.1 End */
DEFINE VARIABLE j LIKE trgl_gl_amt.
define variable site     like prh_site     no-undo.
define variable site1    like prh_site     no-undo.
define variable loc	 like ld_loc       no-undo.
define variable loc1	 like ld_loc       no-undo.
define variable locgroup as char format "x(24)" .

define variable idate    like vph_inv_date no-undo.
define variable idate1   like vph_inv_date no-undo.
define variable line     like pt_prod_line no-undo.
define variable line1    like pt_prod_line no-undo.
define variable part     like prh_part     no-undo.
define variable part1    like prh_part     no-undo.
define variable vendor   like prh_vend     no-undo.
define variable vendor1  like prh_vend     no-undo.
define variable type	 like tr_rmks     no-undo.
define variable type1	 like tr_rmks     no-undo.
define variable rcttype as char .
define variable ii as inte .
define variable maxii as inte .

/*a6apicrp02 var*/
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
define variable v_yn as logi.	/* Add By:  SS - 20070118.1 */
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

/*a6ictrrp03*/
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
define variable year1 LIKE glc_year.
define variable per1 LIKE glc_per.
define variable output_option as char format "x(1)" init "1" .
define variable output_select as char format "x(1)" init "1" .

DEF BUFFER xxvhhist FOR xxvh_hist .
DEF BUFFER xxvhhist1 FOR xxvh_hist .


define variable trrecno       as   recid        no-undo.
define variable cst_date      like tr_effdate   no-undo.
DEF VAR v1 AS DECIMAL.

efdate1 = TODAY - DAY(TODAY).
efdate = efdate1 - DAY(efdate1) + 1.
year1 = YEAR(efdate).
per1 = MONTH(efdate).
/* THE FIELD LABEL OF THE DATE SELECTION CHANGED FROM INVOICE DATE */
/* TO EFFECTIVE.                                                   */

FORM
   year1          colon 25
   per1           colon 25 
   v_yn           COLON 25 LABEL "是否更新单位实际成本"
   SKIP(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
	hide all no-pause .
	view frame dtitle .
   if idate   = low_date then idate = ?.
   if idate1  = hi_date then idate1 = ?.
   if part_group1 = hi_char then part_group1 = "".
   if loc1    = hi_char then loc1  = "".
   if part1   = hi_char then part1 = "".
   if site1   = hi_char then site1 = "".
   if line1   = hi_char then line1 = "".

   if c-application-mode <> 'web' then
      UPDATE
       year1        
	   per1      	 	
       v_yn
     with frame a.

   {wbrp06.i &command = update &fields = "  
			 year1        
			 per1 
             v_yn
		   " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i year1          }
      {mfquoter.i per1         }
      {mfquoter.i v_yn         }

      if idate = ? then idate = low_date.
      if idate1 = ? then idate1 = hi_date.
      if part_group1 = "" then part_group1 = hi_char.
      if part1 = "" then part1 = hi_char.
      if site1 = "" then site1 = hi_char.
      if loc1    = "" then loc1  = hi_char.
      if line1   = "" then line1 = hi_char.

   end.

   IF year1 = 0 OR per1 = 0 THEN DO:
       MESSAGE "期间不允许为空,请重新输入" .
       UNDO,RETRY .
   END.

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


   /* Add By:  SS - 20070227.1 Begin */
   FIND FIRST glc_cal 
       WHERE glc_domain = global_domain and glc_year = year1
       AND glc_per = per1
       NO-LOCK
       NO-ERROR
       .

   IF NOT AVAILABLE glc_cal THEN DO:
       /* INVALID YEAR OR PERIOD */
       /* mgmsgmt.p */
       {mfmsg.i 9904 3}
       next-prompt year1 with frame a.
       undo, retry.
   END.

   efdate = glc_start.
   efdate1 = glc_end.
   /* Add By:  SS - 20070227.1 End */

	   FOR EACH tta6ppptrp0701:
	       DELETE tta6ppptrp0701.
	   END.
	
       customer_consign = "include" .
       supplier_consign = "include" .
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

		INPUT efdate1 ,
		INPUT neg_qty,
		INPUT net_qty,
		INPUT inc_zero_qty,
		INPUT zero_cost,
		INPUT customer_consign,
		INPUT supplier_consign
		)"}

    EMPTY TEMP-TABLE xxptstkrp02 .
    FOR EACH tta6ppptrp0701 :
        FIND FIRST xxptstkrp02 WHERE xxptstkrp02_part = tta6ppptrp0701_part NO-ERROR.
        IF AVAIL xxptstkrp02 THEN DO:
            ASSIGN
                xxptstkrp02_qty_oh		= xxptstkrp02_qty_oh + tta6ppptrp0701_qty_non_consign + tta6ppptrp0701_qty_cust_consign + tta6ppptrp0701_qty_supp_consign
                .
        END.
        ELSE DO:
            CREATE xxptstkrp02 .
            ASSIGN
                xxptstkrp02_part = tta6ppptrp0701_part
                xxptstkrp02_site = tta6ppptrp0701_site
                xxptstkrp02_sct = tta6ppptrp0701_sct
                xxptstkrp02_qty_oh = tta6ppptrp0701_qty_non_consign + tta6ppptrp0701_qty_cust_consign + tta6ppptrp0701_qty_supp_consign
                .
        END.
    END.

    EMPTY TEMP-TABLE tt .
    EMPTY TEMP-TABLE ttc .
    FOR EACH xxvh_hist WHERE xxvh_domain = GLOBAL_domain
                         AND xxvh_year = year1
                         AND xxvh_per = per1                 
                         AND xxvh_part >= part 
                         AND xxvh_part <= part1 NO-LOCK 
                         BREAK BY xxvh_year BY xxvh_per BY xxvh_part BY xxvh_acc :
        IF LAST-OF(xxvh_part) THEN DO:
            FIND FIRST tt WHERE tt_year = year1 AND tt_per = per1 
                            AND tt_part = xxvh_part NO-LOCK NO-ERROR.
            IF NOT AVAIL tt THEN DO:
                CREATE tt .
                ASSIGN
                    tt_year = year1 
                    tt_per = per1
                    tt_part = xxvh_part
                    .
            END.   
        END.
        IF LAST-OF(xxvh_acc) THEN DO:
            FIND FIRST ttc WHERE ttc = xxvh_acc NO-LOCK NO-ERROR.
            IF NOT AVAIL ttc THEN DO:
                CREATE ttc .
                ASSIGN
                    ttc_acc = xxvh_acc 
                    .
            END.
        END.
    END.

    FOR EACH xxptstkrp02 WHERE xxptstkrp02_part >= part 
                           AND xxptstkrp02_part <= part1 ,
        EACH pt_mstr WHERE pt_domain = GLOBAL_domain 
                       AND pt_part = xxptstkrp02_part
                       AND pt_group >= part_group
                       AND pt_group <= part_group1
                       AND pt_prod_line >= LINE
                       AND pt_prod_line <= line1 NO-LOCK ,
        EACH tt WHERE tt_year = year1
                  AND tt_per = per1
                  AND tt_part = pt_part NO-LOCK 
        WITH FRAME b WIDTH 150 :

        v_end_stk_var_amt = 0.
        FOR EACH ttc :
            FIND FIRST xxvh_hist WHERE xxvh_domain = GLOBAL_domain
                                 AND xxvh_part = tt_part
                                 AND xxvh_year = tt_year
                                 AND xxvh_per = tt_per
                                 AND xxvh_acc = ttc_acc NO-LOCK NO-ERROR.
            IF AVAIL xxvh_hist THEN DO:
                v_end_stk_var_amt = xxvh_end_stk_var_amt + v_end_stk_var_amt .
            END.
        END.
              
        FIND FIRST xxvhhist WHERE xxvhhist.xxvh_domain = GLOBAL_domain
                              AND xxvhhist.xxvh_part = tt_part 
                              AND xxvhhist.xxvh_year = tt_year
                              AND xxvhhist.xxvh_per = tt_per 
                              AND xxvhhist.xxvh_none_part = YES NO-ERROR.
        IF AVAIL xxvhhist THEN DO:
            v_end_stk_var_amt = v_end_stk_var_amt + 
                                xxvhhist.xxvh_lab_stk_var_amt + 
                                xxvhhist.xxvh_bur_stk_var_amt + 
                                xxvhhist.xxvh_ovh_stk_var_amt  .
        END.

        FIND FIRST xxvhhist1 WHERE xxvhhist1.xxvh_domain = GLOBAL_domain
                              AND xxvhhist1.xxvh_part = tt_part 
                              AND xxvhhist1.xxvh_year = tt_year
                              AND xxvhhist1.xxvh_per = tt_per   NO-ERROR.
        IF AVAIL xxvhhist1 AND v_yn THEN DO:
                /* 库存单位实际成本 */
                IF xxptstkrp02_qty_oh <> 0 THEN ASSIGN xxvhhist1.xxvh_dec[12] = ((xxptstkrp02_qty_oh * xxptstkrp02_sct) + v_end_stk_var_amt) / xxptstkrp02_qty_oh .
                                           ELSE ASSIGN xxvhhist1.xxvh_dec[12] = 0 .
                                           ASSIGN xxvhhist1.xxvh_chr[5] = "cost" .
        END. 

        IF xxptstkrp02_qty_oh <> 0 THEN v1 = ABS(((xxptstkrp02_qty_oh * xxptstkrp02_sct) + v_end_stk_var_amt) / xxptstkrp02_qty_oh) .
                                   ELSE v1 = 0 .

        DISP 
            pt_group            LABEL "车型"
            pt_part             LABEL "零件号"
            pt_desc1 + pt_desc2 FORMAT "x(48)" LABEL "零件名称"
            xxptstkrp02_qty_oh  FORMAT "->>>,>>>,>>>,>>9.99<" LABEL "数量"
            (xxptstkrp02_qty_oh * xxptstkrp02_sct) + v_end_stk_var_amt FORMAT "->>>,>>>,>>>,>>9.99<" LABEL "实际成本"
            v1 FORMAT "->>>,>>>,>>>,>>9.99<" LABEL "单位实际成本"
            .
    END.

    {a6mfrtrail.i}
    /* SS - 20050922 - E */

end.

{wbrp04.i &frame-spec = a}
