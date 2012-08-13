/* xxincarp01.p  - Inventroy Activity Report - Materials Cost Adjustment Report                              */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.     */
/* Revision 8.5 V1                 Developped: 10/30/01      BY: Rao Haobin          */
/* RHB 材料成本变动报表*/

{mfdtitle.i } 
def var amt_cst_adj as decimal format "->>>,>>>,>>9.99" label "成本调整金额".
def var prod_cst_adj as decimal format "->>>,>>>,>>9.99" initial 0 label "产品类成本调整金额合计".
define variable tot_cst_adj as decimal format "->>>,>>>,>>9.99" initial 0 label "成本调整合计".

def var lineno as integer.
define variable part like pt_part.
define variable part1 like pt_part.
define variable line like pt_prod_line.
define variable line1 like pt_prod_line.
define variable date like tr_effdate label "起止日期".
define variable date1 like tr_effdate.
define variable keeper like pt_article.
define variable keeper1 like pt_article.
define variable site like pt_site.
define variable site1 like pt_site.
define variable pldesc like pl_desc.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

 FORM /*GUI*/ 
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
	     site           colon 18
	     site1          label {t001.i} colon 49
	     line           colon 18
	     line1          label {t001.i} colon 49
	     part           colon 18
	     part1          label {t001.i} colon 49 skip
             date            colon 18
             date1           label {t001.i} colon 49 skip
	     keeper            label "保管员" colon 18
	     keeper1           label {t001.i} colon 49 skip
  skip
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

setframelabels(FRAME a:HANDLE) .



	  /* REPORT BLOCK */

	  
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

	     if part1 = hi_char then part1 = "".
             if line1 = hi_char then line1 = "".
	     if keeper1 = hi_char then keeper1 = "".
	     if site1 = hi_char then site1 = "".
	     if date = low_date then date = ?.
	     if date1 = hi_date then date1 = ?.

	     
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


	     bcdparm = "".

	     {mfquoter.i part   }
	     {mfquoter.i part1   }
	     {mfquoter.i date   }
	     {mfquoter.i date1   }
	     {mfquoter.i keeper   }
	     {mfquoter.i keeper1   }
	     {mfquoter.i site   }
	     {mfquoter.i site1   }
	     {mfquoter.i line   }
	     {mfquoter.i line1   }
	     	     
	     if  part1 = "" then part1 = hi_char.
	     if  line1 = "" then line1 = hi_char.
	     if  keeper1 = "" then keeper1 = hi_char.
	     if  site1 = "" then site1 = hi_char.
	     if  date = ? then date = low_date.
	     if  date1 = ? then date1 = hi_date.
	     /* SELECT PRINTER */
	     
/*GUI*/ end procedure. /* p-report-quote */

/*GUI*/ procedure p-report:

/*GUI*/   {gpprtrpa.i  "printer" 132}
{mfphead.i}
/* lineno=0.


form header
skip(1)
pt_prod_line pldesc "  (续)" 
with stream-io frame a1 page-top side-labels width 132.
view frame a1.
*/
prod_cst_adj = 0.
tot_cst_adj = 0.
for each tr_hist no-lock where tr_part >= part and tr_part <= part1 and tr_prod_line >= line and tr_prod_line <= line1 and tr_type="cst-adj" and tr_effdate>=date and tr_effdate<=date1 break by tr_prod_line by tr_part:
	amt_cst_adj = amt_cst_adj + tr_gl_amt.
	prod_cst_adj = prod_cst_adj + tr_gl_amt.
	tot_cst_adj = tot_cst_adj + tr_gl_amt.
	
	if last-of(tr_part) then do:
	disp tr_part LABEL "零件" amt_cst_adj WITH STREAM-IO.
	amt_cst_adj = 0.
	end.
	if last-of(tr_prod_line) then do:
	disp tr_prod_line COLUMN-LABEL "产品类" prod_cst_adj WITH STREAM-IO.
	prod_cst_adj = 0.
	end.
    IF LAST(tr_part) THEN DO:
        
        display tot_cst_adj WITH FRAME S STREAM-IO.
        tot_cst_adj = 0.
    END.
end.



{mfguitrl.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
 {mfreset.i}
end procedure.



/*GUI*/ {mfguirpb.i &flds=" site site1 line line1 part part1 date date1 keeper keeper1   "} /*Drive the Report*/



