/* GUI CONVERTED from sosorp04.p (converter v1.69) Mon Dec  2 17:37:39 1996 */
/* sosorp04.p - SALES SHIPPING REPORT BY ITEM                           */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 6.0      LAST MODIFIED: 04/05/90   BY: pml *D001* */
/* REVISION: 6.0      LAST MODIFIED: 04/10/90   BY: ftb *D002* added site*/
/* REVISION: 6.0      LAST MODIFIED: 04/20/90   BY: ftb **/
/* REVISION: 6.0      LAST MODIFIED: 03/08/91   BY: afs *D408**/
/* REVISION: 6.0      LAST MODIFIED: 06/13/91   BY: afs *D696**/
/* REVISION: 6.0      LAST MODIFIED: 07/13/91   BY: afs *D769**/
/* REVISION: 6.0      LAST MODIFIED: 10/21/91   BY: afs *D903**/
/* REVISION: 7.0      LAST MODIFIED: 07/16/92   BY: afs *F774**/
/* REVISION: 7.2      LAST MODIFIED: 03/09/93   BY: tjs *G791**/
/* REVISION: 7.3      LAST MODIFIED: 01/20/94   BY: dpm *FL44**/
/* REVISION: 7.3      LAST MODIFIED: 12/12/94   BY: afs *FU52**/
/* REVISION: 7.3      LAST MODIFIED: 05/11/95   BY: jym *F0RM**/
/* REVISION: 7.3      LAST MODIFIED: 04/10/96   BY: jzw *G1P6**/
/* REVISION: 7.3      LAST MODIFIED: 09/17/96   BY: *G2FC* Ajit Deodhar */
/* REVISION: 7.4      LAST MODIFIED: 11/18/96   BY: *H0PF* Suresh Nayak */
/* revision 7.5       last modified:03/09/01 by :kang jian*/
/* Rev: eb2+ sp7      Last Modified: 05/07/07      BY: judy Liu         */

/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "++ "}  /*FL44*/

define variable addr like tr_addr.
define variable addr1 like tr_addr.
define variable so_job like tr_so_job.
define variable so_job1 like tr_so_job.
define variable part like tr_part.
define variable part1 like tr_part.
define variable trdate like tr_effdate.
define variable trdate1 like tr_effdate.
define variable region like cm_region.
define variable region1 like cm_region.
/*D002*/ define variable site like tr_site.
/*D002*/ define variable site1 like tr_site.
define variable name like ad_name.
define variable ext_price like tr_price 
       format "->,>>>,>>>,>>9.99" label "".
/* kang jian label "总价格"*/       
define variable gr_margin like tr_price.
define variable ext_gr_margin like tr_price 
       format "->,>>>,>>>,>>9.99<<<" label "".
/*kang jian       label "毛利合计" */
define variable summary like mfc_logical format "S-汇总/D-明细"
label "S-汇总/D-明细".
define variable base_rpt like so_curr.
/*G1P6*  initial "Base" format "x(4)". */
define variable base_price like tr_price.
define variable disp_curr as character format "x(1)" label "C".
/*B388*/ define variable prod_line like tr_prod_line.
/*B388*/ define variable prod_line1 like tr_prod_line.
/*B388*/ define variable desc2 like pl_desc.
define variable pct_margin as decimal format "->>9.99" label "".
/* kang jian label "毛利 %" */
/*D408*/ define variable unit_cost like tr_mtl_std.
/*D769*/ define variable tmp_margin like pct_margin.
/*FU52*/ define variable region_chk like mfc_logical.
/*G2FC*/ define variable l_first_prod_line like mfc_logical no-undo.
/*G2FC*/ define variable l_first_part      like mfc_logical no-undo.
/*G2FC*/ define variable l_prod_line_ok    like mfc_logical no-undo.
/*G2FC*/ define variable l_part_ok         like mfc_logical no-undo.
/*G2FC*/ define variable l_report_ok       like mfc_logical no-undo.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
part           colon 15
   part1          label {t001.i} colon 49 skip
/*B388*/
   prod_line      colon 15
   prod_line1     label {t001.i} colon 49 skip
   trdate         colon 15
   trdate1        label {t001.i} colon 49 skip
   addr           colon 15
   addr1          label {t001.i} colon 49 skip
   so_job         colon 15
   so_job1        label {t001.i} colon 49 skip
   region         colon 15
   region1        label {t001.i} colon 49
/*D002*/ site     colon 15
/*D002*/ site1    label {t001.i} colon 49 skip(1)
   summary        colon 15 skip
   base_rpt       colon 15 skip
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = " 选择条件 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/*judy 07/07/05*/   /* SET EXTERNAL LABELS */
/*judy 07/07/05*/   setFrameLabels(frame a:handle).

/*K0ZX*/ {wbrp01.i}


/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

   if part1 = hi_char then part1 = "".
   if addr1 = hi_char then addr1 = "".
   if so_job1 = hi_char then so_job1 = "".
   if trdate = low_date then trdate = ?.
   if trdate1 = hi_date then trdate1 = ?.
   if prod_line1 = hi_char then prod_line1 = "".
/*G791*  if site1 = hi_char then site = "". */
/*G791*/ if site1 = hi_char then site1 = "".
/*D769*/ if region1 = hi_char then region1 = "".

   
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


   bcdparm = "".
   {mfquoter.i part       }
   {mfquoter.i part1      }
   {mfquoter.i prod_line  }
   {mfquoter.i prod_line1 }
   {mfquoter.i trdate     }
   {mfquoter.i trdate1    }
   {mfquoter.i addr       }
   {mfquoter.i addr1      }
   {mfquoter.i so_job     }
   {mfquoter.i so_job1    }
   {mfquoter.i region     }
   {mfquoter.i region1    }
/*D002*/ {mfquoter.i site     }
/*D002*/ {mfquoter.i site1    }
   {mfquoter.i summary    }
   {mfquoter.i base_rpt   }

   if  part1 = "" then part1 = hi_char.
   if  prod_line1 = "" then prod_line1 = hi_char.
   if  addr1 = "" then addr1 = hi_char.
   if  trdate = ? then trdate = low_date.
   if  trdate1 = ? then trdate1 = hi_date.
   if  so_job1 = "" then so_job1 = hi_char.
   if  region1 = "" then region1 = hi_char.
/*D002*/ if  site1 = "" then site1 = hi_char.

   /* SELECT PRINTER */
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:




   {mfphead.i}

   FORM /*GUI*/  header
   skip(1)
   with STREAM-IO /*GUI*/  frame p1 page-top width 132 attr-space.
   view frame p1.

/*G2FC*/ /* SELECTION OF REGION OCCURS OUTSIDE THE FOR EACH LOOP(TO USE THE
	    REPORT AT REMOTE DB). THE "OK" FLAG INDICATES IF ANY VALID RECORD
	    HAS BEEN SELECTED FOR THE REPORT, PRODUCT LINE OR PART */
/*G2FC*/ l_report_ok         = no.

   for each tr_hist where (tr_part >= part and tr_part <= part1)
   and (tr_prod_line >= prod_line and tr_prod_line <= prod_line1)
   and (tr_effdate >= trdate and tr_effdate <= trdate1)
   and (tr_addr >= addr and tr_addr <= addr1)
/*D002*/ and (tr_site >= site and tr_site <= site1)
   and (tr_so_job >= so_job and tr_so_job <= so_job1)
   and (tr_type = "ISS-SO" or tr_type = "RCT-SOR")
/*G1P6*  and ((base_rpt = "base") */
/*G1P6*/ and ((base_rpt = "")
	 or (tr_curr = base_rpt))
/*FU52** use-index tr_eff_trnbr no-lock, **/
/*FU52*/ use-index tr_eff_trnbr no-lock
/*FU52** each cm_mstr where cm_addr = tr_addr                            **/
/*FU52**      and (cm_region >= region and cm_region <= region1) no-lock **/
   break by tr_prod_line by tr_part by tr_effdate with frame b width 132 no-box:

/*G2FC*/ if first-of(tr_part) then
/*G2FC*/    assign
/*G2FC*/    l_first_part     = yes
/*G2FC*/    l_part_ok        = no.
/*G2FC*/  /* SAVE THE first-of(tr_part) OCCURRENCE FOR REFERRING TO VALID
	     tr_hist RECORDS.
	     AND INITIALIZE O.K. TO PRINT PART TOTALS VARIABLE.*/

/*G2FC*/ if first-of(tr_prod_line) then
/*G2FC*/    assign
/*G2FC*/    l_first_prod_line   = yes
/*G2FC*/    l_prod_line_ok      = no.
/*G2FC*/  /* SAVE THE first-of(tr_prod_line) OCCURRENCE FOR REFERRING TO VALID
	     tr_hist RECORDS.
	     INITIALIZE O.K. TO PRINT PRODUCT LINE TOTALS VARIABLE.*/


/*FU52*/ /* Check customer region (if customers in this db) */
/*FU52*/ if (region > "" or region1 < hi_char)
/*H0PF** /*FU52*/    and can-find(first cm_mstr) then do:*/
/*H0PF*/    and can-find(first cm_mstr where cm_addr >= "") then do:
/*FU52*/    find cm_mstr where cm_addr = tr_addr no-lock no-error.
/*FU52*/    region_chk = (available cm_mstr
/*FU52*/                  and cm_region >= region and cm_region <= region1).
/*FU52*/ end.
/*FU52*/ else
/*FU52*/    region_chk = true.

/*G2FC** if first-of(tr_prod_line) then do: */

/*G2FC*/ if l_first_prod_line and region_chk then do:
/*G2FC*/ /* CHECK FOR FIRST VALID RECORD FOR THIS PRDUCT LINE */
/*G2FC*/    l_first_prod_line  = no.
	    find pl_mstr where pl_prod_line = tr_prod_line no-lock no-error.
	    if available pl_mstr then do:
	       desc2 = pl_desc.
	       if page-size - line-counter < 3 then page.
	       if not summary then display with       	             
	        STREAM-IO /*GUI*/ .
	       else display with frame c STREAM-IO /*GUI*/ .
	       put "    产品类: " pl_prod_line
	       " " pl_desc.
	    end.
	 end.

/*FU52*/ if region_chk then do:
/*G2FC*/    l_part_ok = yes.
/*G2FC*/ /* AT-LEAST ONE VALID RECORD FOUND FOR THIS PART BREAK */

	    /*Calculate Currency Exchange */
	    base_price = tr_price.
	    disp_curr = "".
/*G1P6*     if base_rpt <> "Base" */
/*G1P6*/    if base_rpt <> ""
	    and tr_curr <> base_curr then
	    base_price = base_price * tr_ex_rate.
/*G1P6*     if base_rpt = "Base" */
/*G1P6*/    if base_rpt = ""
	    and tr_curr <> base_curr then disp_curr = "Y".
	    ext_price =  - tr_qty_loc * base_price.
/*D408*     gr_margin = tr_price - tr_mtl_std - tr_lbr_std */
/*D408*     - tr_bdn_std - tr_ovh_std - tr_sub_std.        */
/*D408*/    unit_cost = - tr_gl_amt / tr_qty_loc.

/*F0RM                                                                      *
 * /*FL44*/    /* Since tr_hist does not have cost for memo item get the */ *
 * /*FL44*/    /* cost from sod_det or idh_hist                          */ *
 * /*FL44*/    if tr_ship_type = "M" then do:                               *
 * /*FL44*/       find first sod_det                                        *
 * /*FL44*/          where sod_part = tr_part and  sod_nbr = tr_nbr         *
 * /*FL44*/          and tr_line  = sod_line no-lock no-error.              *
 * /*FL44*/       if available sod_det then                                 *
 * /*FL44*/          unit_cost = sod_std_cost.                              *
 * /*FL44*/       if not available sod_det then                             *
 * /*FL44*/          find first idh_hist                                    *
 * /*FL44*/             where idh_part = tr_part and idh_inv_nbr = tr_rmks  *
 * /*FL44*/             and idh_line = tr_line no-lock no-error.            *
 * /*FL44*/             if available idh_hist then                          *
 * /*FL44*/                unit_cost = idh_std_cost.                        *
 * /*FL44*/    end.                                                         */

/*F0RM*/    if tr_ship_type <> " " then
/*F0RM*/      assign unit_cost = tr_mtl_std + tr_lbr_std + tr_bdn_std +
/*F0RM*/                         tr_ovh_std + tr_sub_std.

/*D408*/    gr_margin = tr_price - unit_cost.
/*G1P6*     if base_rpt <> "Base" */
/*G1P6*/    if base_rpt <> ""
	    and tr_curr <> base_curr then
	    gr_margin = gr_margin * tr_ex_rate.
	    ext_gr_margin = - tr_qty_loc * gr_margin.

/*D408*     if (tr_mtl_std + tr_lbr_std + tr_bdn_std  */
/*D408*      + tr_ovh_std + tr_sub_std) = 0           */
/*D408*     then pct_margin = 100.                    */
/*D408*/    if unit_cost = 0 then pct_margin = 100.
	    else if (- tr_qty_loc) = 0 then pct_margin = 0.
/*D696*/    else if ext_price = 0 then pct_margin = 0.
	    else pct_margin = (ext_gr_margin / ext_price) * 100.

	    accumulate ext_gr_margin (total by tr_prod_line by tr_part).
	    accumulate tr_qty_loc (total by tr_prod_line by tr_part).
	    accumulate ext_price (total by tr_prod_line by tr_part).

/*FU52*/ end. /* If region for this line is valid */

	 find pt_mstr where pt_part = tr_part no-lock no-wait no-error.

	 if not summary then do:
	    name = "".
	    find ad_mstr where ad_addr = tr_addr no-lock no-wait no-error.
	    if available ad_mstr then name = ad_name.

/*G2FC**    if first-of(tr_part)  then do: */

/*G2FC*/    if l_first_part and region_chk  then do:
/*G2FC*/ /* CHECK FOR FIRST VALID RECORD FOR THIS PART */
/*G2FC*/       l_first_part = no.
	       if page-size - line-counter < 4 then page.
	       display WITH STREAM-IO /*GUI*/ .
	       put "零件: " tr_part " ".
	       if available pt_mstr then put pt_desc1 " " pt_desc2.
	       put "单位: " tr_um
/*F774*/        skip.
	    end.

	    if page-size - line-counter < 3 then page.

/*FU52*/    if region_chk then
	    display tr_trnbr tr_ship_type
	    tr_effdate tr_so_job tr_addr
	    name format "X(18)" (- tr_qty_loc) @ tr_qty_loc label "已发货量"
/*kang jian  disp_curr base_price label "单价" ext_price 
	    ext_gr_margin pct_margin */ WITH STREAM-IO /*GUI*/ .

/*G2FC**    if last-of(tr_part)  then do: */

/*G2FC*/    /* DISPLAY PART TOTALS WHEN AT-LEAST ONE tr_hist RECORD
	       QUALIFIES SELECTION CRITERIA */

/*G2FC*/    if last-of(tr_part) and l_part_ok then do:
/*G2FC*/ /* AT-LEAST ONE VALID RECORD FOUND FOR THIS PRODUCT LINE BREAK */
/*G2FC*/       l_prod_line_ok = yes.
/*D769*/       /* Calculate the margin separately to avoid division by zero */
/*D769*/       if (accum total by tr_part (ext_price)) <> 0 then
/*D769*/        tmp_margin =
/*D769*/        ((accum total by tr_part (ext_gr_margin)) /
/*D769*/         (accum total by tr_part  (ext_price)) ) * 100.
/*D769*/       else tmp_margin = 0.
	       if page-size - line-counter < 2 then page.
/*kang jian	       underline tr_qty_loc ext_price ext_gr_margin pct_margin
	       with frame b. */
           DOWN 1.
	       display "  零件合计:" @ name
	       - accum total by tr_part (tr_qty_loc) @ tr_qty_loc
/*kang jian    accum total by tr_part (ext_price) @ ext_price
	       accum total by tr_part (ext_gr_margin) @ ext_gr_margin  */
/*D769**       (((accum total by tr_part (ext_gr_margin)) /               */
/*D769**       (accum total by tr_part  (ext_price))) * 100) @ pct_margin */
/*D769*/       /*kang jian tmp_margin @ pct_margin */
	       with frame b  STREAM-IO /*GUI*/ .
	    end.

/*G2FC**    if last-of(tr_prod_line)  then do: */

/*G2FC*/    /* DISPLAY PRODUCT LINE TOTALS WHEN AT-LEAST ONE tr_hist RECORD
	       QUALIFIES SELECTION CRITERIA */

/*G2FC*/    if last-of(tr_prod_line) and l_prod_line_ok then do:
/*G2FC*/       l_report_ok = yes.
/*D769*/       /* Calculate the margin separately to avoid division by zero */
/*D769*/       if (accum total by tr_prod_line (ext_price)) <> 0 then
/*D769*/        tmp_margin =
/*D769*/        ((accum total by tr_prod_line (ext_gr_margin)) /
/*D769*/         (accum total by tr_prod_line  (ext_price)) ) * 100.
/*D769*/       else tmp_margin = 0.
	       if page-size - line-counter < 2 then page.
/*kang jian	       underline tr_qty_loc  ext_price ext_gr_margin pct_margin*/
	         DOWN 1.
           display  "产品类合计:" @ name
	       - accum total by tr_prod_line (tr_qty_loc) @ tr_qty_loc
/*kang jian	       accum total by tr_prod_line (ext_price) @ ext_price
	       accum total by tr_prod_line (ext_gr_margin) @ ext_gr_margin */
/*D769**       (((accum total by tr_prod_line (ext_gr_margin)) /              */
/*D769**       (accum total by tr_prod_line (ext_price))) * 100) @ pct_margin */
/*D769*/  /*kang jian     tmp_margin @ pct_margin  */ WITH STREAM-IO /*GUI*/ .
	    end.

/*G2FC**    if last(tr_prod_line) then do: */

/*G2FC*/    /* DISPLAY REPORT TOTALS WHEN AT-LEAST ONE tr_hist RECORD
	       QUALIFIES SELECTION CRITERIA */

/*G2FC*/    if last(tr_prod_line)  and l_report_ok then do:
/*D769*/       /* Calculate the margin separately to avoid division by zero */
/*D769*/       if (accum total (ext_price)) <> 0 then
/*D769*/        tmp_margin =
/*D769*/        ((accum total (ext_gr_margin)) /
/*D769*/         (accum total  (ext_price)) ) * 100.
/*D769*/       else tmp_margin = 0.
	      if page-size - line-counter < 2 then page.
/*kang jian	      underline tr_qty_loc ext_price ext_gr_margin pct_margin. */
            DOWN 1.
	      display  "  报表合计:" @ name
	    - accum total  (tr_qty_loc) @ tr_qty_loc
/* kang jian  accum total  (ext_price) @ ext_price
	      accum total  (ext_gr_margin) @ ext_gr_margin  */
/*D769**      (((accum total (ext_gr_margin)) /               */
/*D769**      (accum total (ext_price))) * 100) @ pct_margin. */
/*D769*/     /*kang jian  tmp_margin @ pct_margin */ WITH STREAM-IO /*GUI*/ .
	    end.
      end.  /* not summary */

      if summary then do:
/*G2FC** if last-of(tr_part) then do: */

/*G2FC*/    /* DISPLAY PART TOTALS WHEN AT-LEAST ONE tr_hist RECORD
	       QUALIFIES SELECTION CRITERIA */

/*G2FC*/ if last-of(tr_part) and l_part_ok then do:
/*G2FC*/ /* AT-LEAST ONE VALID RECORD FOUND FOR THIS PRODUCT LINE BREAK */
/*G2FC*/   l_prod_line_ok = yes.
/*D769*/   /* Calculate the margin separately to avoid division by zero */
/*D769*/   if (accum total by tr_part (ext_price)) <> 0 then
/*D769*/    tmp_margin =
/*D769*/    ((accum total by tr_part (ext_gr_margin)) /
/*D769*/     (accum total by tr_part  (ext_price)) ) * 100.
/*D769*/   else tmp_margin = 0.
	   if page-size - line-counter < 2 then page.
	   display tr_part with frame c down width 132 STREAM-IO /*GUI*/ .
	   if available pt_mstr then display pt_um pt_desc1  with frame c STREAM-IO /*GUI*/ .	      
         display
	   - (accum total by tr_part (tr_qty_loc)) @ tr_qty_loc
/*kang jian	   accum total by tr_part (ext_price) @ ext_price
	   accum total by tr_part (ext_gr_margin) @ ext_gr_margin */
/*D769**   (((accum total by tr_part (ext_gr_margin)) /               */
/*D769**   (accum total by tr_part  (ext_price))) * 100) @ pct_margin */
/*D769*/  /*kang jian tmp_margin @ pct_margin */
	   with frame c down width 132 STREAM-IO /*GUI*/ .
	   if available pt_mstr and pt_desc2 <> "" then do:
	      down 1 with frame c.
	      display pt_desc2 @ pt_desc1 with frame c STREAM-IO /*GUI*/ .
	   end.
	 end.

/*G2FC** if last-of(tr_prod_line)  then do: */

/*G2FC*/    /* DISPLAY PRODUCT LINE TOTALS WHEN AT-LEAST ONE tr_hist RECORD
	       QUALIFIES SELECTION CRITERIA */

/*G2FC*/ if last-of(tr_prod_line)  and l_prod_line_ok then do:
/*G2FC*/    l_report_ok = yes.
/*D769*/    /* Calculate the margin separately to avoid division by zero */
/*D769*/    if (accum total by tr_prod_line (ext_price)) <> 0 then
/*D769*/     tmp_margin =
/*D769*/     ((accum total by tr_prod_line (ext_gr_margin)) /
/*D769*/      (accum total by tr_prod_line  (ext_price)) ) * 100.
/*D769*/    else tmp_margin = 0.
	    if page-size - line-counter < 2 then page.
/*kang jian	    underline tr_qty_loc ext_price ext_gr_margin pct_margin
	    with frame c. */
         DOWN 1.
	    display  "产品类合计:" @ pt_desc1
		 - (accum total by tr_prod_line (tr_qty_loc)) @ tr_qty_loc
/*kang jian	 accum total by tr_prod_line (ext_price) @ ext_price
		 accum total by tr_prod_line (ext_gr_margin) @ ext_gr_margin */
/*D769**       (((accum total by tr_prod_line (ext_gr_margin)) /              */
/*D769**       (accum total by tr_prod_line (ext_price))) * 100) @ pct_margin */
/*D769*/    /*kang jian     tmp_margin @ pct_margin */
		 with frame c STREAM-IO /*GUI*/ .
	 end.

/*G2FC** if last(tr_prod_line)  then do: */

/*G2FC*/    /* DISPLAY REPORT TOTALS WHEN AT-LEAST ONE tr_hist RECORD
	       QUALIFIES SELECTION CRITERIA */

/*G2FC*/ if last(tr_prod_line)  and l_report_ok then do:
/*D769*/    /* Calculate the margin separately to avoid division by zero */
/*D769*/    if (accum total (ext_price)) <> 0 then
/*D769*/     tmp_margin =
/*D769*/     ((accum total (ext_gr_margin)) /
/*D769*/      (accum total  (ext_price)) ) * 100.
/*D769*/    else tmp_margin = 0.
	    if page-size - line-counter < 2 then page.
/*kang jian	    underline tr_qty_loc ext_price ext_gr_margin pct_margin
		 with frame c. */
          DOWN 1.
	    display  "  报表合计:" @ pt_desc1
	    - (accum total  (tr_qty_loc)) @ tr_qty_loc
/*kang jian	    accum total  (ext_price) @ ext_price
	    accum total  (ext_gr_margin) @ ext_gr_margin */
/*D769**    (((accum total (ext_gr_margin)) /               */
/*D769**    (accum total (ext_price))) * 100) @ pct_margin. */
/*D769*/ /*kang jian    tmp_margin @ pct_margin */
	    with frame c STREAM-IO /*GUI*/ .
	 end.
      end. /* summary*/
      
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/


   end. /*for each*/

   /* REPORT TRAILER  */
   
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

/*K0ZX*/ {wbrp04.i &frame-spec = a} 
end.

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" part part1 prod_line prod_line1 trdate trdate1 addr addr1 so_job so_job1 region region1  site site1 summary base_rpt "} /*Drive the Report*/
