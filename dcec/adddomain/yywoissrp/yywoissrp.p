/* xxretrrp.p  - Repetitive Picklist Transfer Report                               */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.     */
/* V1                 Developped: 03/28/01      BY: Rao Haobin          */
/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 08/13/12  ECO: *SS-20120813.1*   */
/* 反映领料单实际转移量的报表 */

{mfdtitle.i "120813.1" } 
define variable nbr like tr_nbr.
define variable nbr1 like tr_nbr.
define variable lineno as integer.

form         
skip(1)
     tr_nbr           label "加工单号  "   at 48 
/*     tr_effdate          label "生效日期  " at 48*/
     lineno label "页号" at 80
     with no-box side-labels width 180 frame b.
     
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

 FORM /*GUI*/ 
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
	     nbr             label "加工单号" colon 18
	     nbr1           label {t001.i} colon 49
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
/*judy 07/05/05*/  /* SET EXTERNAL LABELS */
/*judy 07/05/05*/  setFrameLabels(frame a:handle).


	  /* REPORT BLOCK */

	  
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

	     if nbr1 = hi_char then nbr = "".

	     
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


	     bcdparm = "".

	     {mfquoter.i nbr   }
	     {mfquoter.i nbr1   }
	     
	     if  nbr1 = "" then nbr1 = hi_char.

	     /* SELECT PRINTER */
	     
/*GUI*/ end procedure. /* p-report-quote */

/*GUI*/ procedure p-report:

/*GUI*/   {gpprtrpa.i  "printer" 132}
{mfphead.i}
lineno=0.
for each tr_hist no-lock where /* *SS-20120813.1*   */ tr_hist.tr_domain = global_domain and  tr_nbr>=nbr and tr_nbr <= nbr1  and tr_type="ISS-wo" /*cj*/ USE-INDEX tr_nbr_eff break by tr_nbr by tr_part:
if (page-size - line-counter <3) or (first-of(tr_nbr)) then do:
  if lineno<>0 then page.
  lineno = lineno + 1.
  display tr_nbr lineno format "999" label "页号"  with frame b STREAM-IO .
end.
find pt_mstr where /* *SS-20120813.1*   */ pt_mstr.pt_domain = global_domain and pt_part = tr_part no-lock.
disp tr_part pt_desc2 pt_article column-label "保管员" pt_um tr_loc tr_qty_chg column-label "已发数量  " tr_effdate  with width 144  STREAM-IO.
end.

/* {mfguitrl.i} */


/*judy 07/05/05*/  {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

end procedure.



/*GUI*/ {mfguirpb.i &flds=" nbr nbr1  "} /*Drive the Report*/


 /*judy 07/05/05*/ /* {mfreset.i}*/
