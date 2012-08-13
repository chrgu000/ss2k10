/* xxgtptrp.p - Part Information Report for Golden Tax                */
/* COPYRIGHT Infopower.Ltd. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.6      LAST MODIFIED: 01/13/2001   BY: IFP010 */


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

 {mfdtitle.i "f "}  /*GUI moved to top.*/

 define variable part  like pt_part.
 define variable part1 like pt_part.
 define variable ptline  like pt_prod_line.
 define variable ptline1 like pt_prod_line.
 define variable pct like vt_tax_pct.
 
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
	    
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
          part           colon 15
	    part1          label {t001.i} colon 49 skip
          ptline         colon 15
	    ptline1        label {t001.i} colon 49 skip(1)

	  SKIP(.4)  /*GUI*/
with frame a side-labels WIDTH 80 /*GUI*/ NO-BOX THREE-D /*GUI*/.

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

 
/*GUI*/ {mfguirpa.i true  "printer" 255 }

/*GUI*/ procedure p-enable-ui:

	    if part1 = hi_char then part1 = "".
	    if ptline1 = hi_char then ptline1 = "".
	    
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


	    bcdparm = "".
	    {mfquoter.i part   }
	    {mfquoter.i part1  }
	    {mfquoter.i ptline  }
	    {mfquoter.i ptline1 }

	    if  part1 = "" then part1 = hi_char.
	    if  ptline1 = "" then ptline1 = hi_char.

	    /* SELECT PRINTER  */
	    
/*GUI*/ end procedure. /* p-report-quote */

/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 255}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:

          for each pt_mstr where pt_part >= part and pt_part <= ptline1
          and pt_prod_line >= ptline and pt_prod_line <= ptline1 no-lock
          with frame b width 255 STREAM-IO:
    
            find first vt_mstr where vt_class = pt_taxc no-lock no-error.
            if available vt_mstr then pct = vt_tax_pct.
            else pct = 0.
            
            display pt_part label "产品代码"
                    pt_desc1 + pt_desc2 format "x(40)" label "名称"
                    pt__chr01  format "x(44)" label "税目"
                    pt__chr02 format "x(4)"  label "简码"
                    pt__chr03 format "x(16)" label "规格"      
                    pt_price  label "缺省含税单价"  space(2)
                    pct label "内销税率"  space(2)
                    pt__dec01 format ">>>9.99" label "外销税率" space(2)
                    pt__chr04 format "x(5)" label "商品类别" .

          end.   
               

	    {mfphead.i}
	          
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

   
       /* REPORT TRAILER */

	    
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

	 end.

/*GUI*/ end procedure. /*p-report*/

/*GUI*/ {mfguirpb.i &flds=" part part1 ptline ptline1 "} /*Drive the Report*/


